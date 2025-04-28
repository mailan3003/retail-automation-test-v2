# Phân tích Business Logic của phương thức CreateInvoice

### 8. Xử lý thông tin địa chỉ giao hàng
- **Quy trình xác định và cập nhật thông tin địa chỉ**:
  - **Điều kiện kiểm tra**:
    - Hệ thống chỉ xử lý khi `invoice.DeliveryDetail` không null
    - Thông tin địa chỉ phải có đầy đủ tên địa điểm (`LocationName`) và tên phường/xã (`WardName`)
  
  - **Quy trình tìm kiếm và ánh xạ ID địa chỉ**:
    - Gọi phương thức `LocationService.GetLocationIdAndWardId(locationName, wardName)` để lấy thông tin ID
    - Phương thức này thực hiện hai bước chính:
      1. **Tìm kiếm thông tin tỉnh/thành phố**:
         - Ưu tiên tìm trong Redis cache (nếu được cấu hình)
         - Nếu không tìm thấy trong cache, truy vấn từ cơ sở dữ liệu bằng câu lệnh:
           ```sql
           SELECT l.Id, l.Name, l.KmsId AS LocationKmsId, w.Id AS WardId, w.KmsId AS WardKmsId
           FROM KvLocations l
           LEFT JOIN KvWards w ON w.LocationId = l.Id
           WHERE LOWER(l.Name) = LOWER(@locationName) AND LOWER(w.Name) = LOWER(@wardName)
           ```
         - So khớp tên địa điểm không phân biệt hoa thường
      
      2. **Tìm kiếm thông tin phường/xã**:
         - Lấy danh sách phường/xã thuộc tỉnh/thành phố đã tìm thấy
         - So khớp tên phường/xã không phân biệt hoa thường
         - Nếu không tìm thấy chính xác, sử dụng phường/xã đầu tiên trong danh sách
    
    - **Kết quả trả về** bao gồm:
      - `LocationId`: ID tỉnh/thành phố trong hệ thống
      - `LocationKmsId`: Mã tỉnh/thành phố để ánh xạ với hệ thống KMS
      - `WardId`: ID phường/xã trong hệ thống
      - `WardKmsId`: Mã phường/xã để ánh xạ với hệ thống KMS

  - **Cập nhật thông tin địa chỉ trong hóa đơn**:
    - **Cập nhật WardId** khi:
      - Tìm thấy thông tin phường/xã hợp lệ (`kvReceiver != null && kvReceiver.WardId > 0`)
      - Mã phường/xã tìm được khác với mã hiện tại (`kvReceiver.WardId != invoice.DeliveryDetail.WardId`)
      - Thực hiện cập nhật: `invoice.DeliveryDetail.WardId = kvReceiver.WardId`
    
    - **Cập nhật LocationId** khi:
      - Tìm thấy thông tin tỉnh/thành phố hợp lệ (`kvReceiver != null && kvReceiver.LocationId > 0`)
      - Hóa đơn chưa có mã tỉnh/thành phố hoặc mã không hợp lệ (`invoice.DeliveryDetail.LocationId.GetValueOrDefault() <= 0`)
      - Thực hiện cập nhật: `invoice.DeliveryDetail.LocationId = kvReceiver.LocationId`

- **Lợi ích của cơ chế xử lý địa chỉ**:
  - Tự động bổ sung thông tin ID từ tên địa chỉ, giúp chuẩn hóa dữ liệu
  - Hỗ trợ tìm kiếm thông minh không phân biệt hoa thường
  - Tối ưu hiệu suất bằng cách sử dụng Redis cache
  - Đảm bảo tính nhất quán của dữ liệu địa chỉ trong hệ thống 

## Test Data JSON cho các trường hợp thất bại

### 1. Không tìm thấy thông tin địa chỉ
```json
{
  "Invoice": {
    "DeliveryDetail": {
      "LocationName": "Địa Điểm Không Tồn Tại",
      "WardName": "Phường Không Tồn Tại",
      "LocationId": null,
      "WardId": null
    }
  },
  "LocationServiceResult": null,
  "ExpectedResult": {
    "DeliveryDetail": {
      "LocationId": null,
      "WardId": null
    }
  }
}
```
**Kết quả kiểm tra**: Hệ thống không cập nhật LocationId và WardId khi không tìm thấy thông tin địa chỉ tương ứng.

### 2. Tìm thấy thông tin địa chỉ nhưng khác với ID hiện tại
```json
{
  "Invoice": {
    "DeliveryDetail": {
      "LocationName": "Hà Nội",
      "WardName": "Cầu Giấy",
      "LocationId": 10,
      "WardId": 20
    }
  },
  "LocationServiceResult": {
    "LocationId": 1,
    "LocationKmsId": "HN",
    "WardId": 15,
    "WardKmsId": "CG"
  },
  "ExpectedResult": {
    "DeliveryDetail": {
      "LocationId": 10,
      "WardId": 15
    }
  }
}
```
**Kết quả kiểm tra**: Hệ thống chỉ cập nhật WardId khi phát hiện sự khác biệt, nhưng giữ nguyên LocationId đã có.

### 3. Tìm thấy thông tin địa chỉ nhưng không có LocationId
```json
{
  "Invoice": {
    "DeliveryDetail": {
      "LocationName": "Hà Nội",
      "WardName": "Cầu Giấy",
      "LocationId": 0,
      "WardId": 20
    }
  },
  "LocationServiceResult": {
    "LocationId": 1,
    "LocationKmsId": "HN",
    "WardId": 15,
    "WardKmsId": "CG"
  },
  "ExpectedResult": {
    "DeliveryDetail": {
      "LocationId": 1,
      "WardId": 15
    }
  }
}
```
**Kết quả kiểm tra**: Hệ thống cập nhật cả LocationId và WardId khi LocationId chưa có giá trị hợp lệ (null hoặc <= 0).

---
**Điều hướng**
- Trước đó: [08-CreateInvoice-CODDelivery.md](./08-CreateInvoice-CODDelivery.md)
- Tiếp theo: [10-CreateInvoice-CustomerAndChannel.md](./10-CreateInvoice-CustomerAndChannel.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 