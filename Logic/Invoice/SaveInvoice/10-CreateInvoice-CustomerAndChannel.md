# Phân tích Business Logic của phương thức CreateInvoice

### 9. Kiểm tra thông tin khách hàng và kênh bán hàng
- **Quy trình xác thực thông tin khách hàng và kênh bán hàng**:
  - **Xác thực thông tin khách hàng**:
    - Khi khách hàng có ID không hợp lệ (điều kiện `invoice.CustomerId != null && invoice.CustomerId < -0.0000001`): 
      - Hệ thống ném ngoại lệ `KvValidateCustomerException`
      - Thông báo lỗi: `KVMessage.invoiceError_updateInvoiceInfo` ("Có lỗi trong quá trình ghi nhận thông tin. Xin vui lòng Lưu lại thông tin khách hàng một lần nữa.")
      - Đây là cơ chế bảo vệ ngăn chặn việc sử dụng ID khách hàng không hợp lệ

  - **Xác thực kênh bán hàng**:
    - Khi hóa đơn có chỉ định kênh bán hàng (trường `invoice.SaleChannelId` có giá trị và lớn hơn 0):
      - Hệ thống truy vấn thông tin kênh bán hàng: `await SaleChannelService.GetByIdAsync(invoice.SaleChannelId ?? 0)`
      - Kiểm tra các điều kiện:
        1. Kênh bán hàng tồn tại: `saleChannelInDB != null`
        2. Kênh bán hàng thuộc về cửa hàng hiện tại: `saleChannelInDB.RetailerId == CurrentRetailerId`
        3. Kênh bán hàng đang hoạt động: `saleChannelInDB.IsActive == true`
      - Nếu không thỏa mãn bất kỳ điều kiện nào, hệ thống ném ngoại lệ `KvValidateSaleChannelException` với thông báo `KVMessage.sc_kenh_ban_khong_ton_tai` ("Kênh bán không tồn tại")

  - **Xác thực thông tin giao hàng**:
    - Khi hóa đơn có thông tin giao hàng và thời gian giao hàng dự kiến được thiết lập, nhưng thời gian này sớm hơn hoặc bằng thời gian mua hàng (tức là `invoice.DeliveryDetail != null && invoice.DeliveryDetail.ExpectedDelivery != null && invoice.DeliveryDetail.ExpectedDelivery <= invoice.PurchaseDate`):
      - Hệ thống ném ngoại lệ `KvValidateDeliveryInfoException`
      - Thông báo lỗi: `Labels.cod_invalidExpecteDeliveryInvoice` ("Thời gian giao hàng phải sau thời gian hóa đơn")
      - Đảm bảo tính hợp lý về mặt thời gian trong quy trình giao hàng 

## Test Data JSON cho các trường hợp thất bại

### 1. ID khách hàng không hợp lệ
```json
{
  "Invoice": {
    "CustomerId": -1,
    "Code": "HD001"
  },
  "ExpectedError": {
    "Type": "KvValidateCustomerException",
    "Message": "Có lỗi trong quá trình ghi nhận thông tin. Xin vui lòng Lưu lại thông tin khách hàng một lần nữa."
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi phát hiện ID khách hàng không hợp lệ (nhỏ hơn 0).

### 2. Kênh bán hàng không tồn tại
```json
{
  "Invoice": {
    "SaleChannelId": 123,
    "Code": "HD001"
  },
  "SaleChannelInDB": null,
  "CurrentRetailerId": 5,
  "ExpectedError": {
    "Type": "KvValidateSaleChannelException",
    "Message": "Kênh bán không tồn tại"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi kênh bán hàng không tồn tại trong cơ sở dữ liệu.

### 3. Kênh bán hàng không thuộc cửa hàng hiện tại
```json
{
  "Invoice": {
    "SaleChannelId": 123,
    "Code": "HD001"
  },
  "SaleChannelInDB": {
    "Id": 123,
    "RetailerId": 10,
    "IsActive": true
  },
  "CurrentRetailerId": 5,
  "ExpectedError": {
    "Type": "KvValidateSaleChannelException",
    "Message": "Kênh bán không tồn tại"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi kênh bán hàng không thuộc về cửa hàng hiện tại.

### 4. Kênh bán hàng không hoạt động
```json
{
  "Invoice": {
    "SaleChannelId": 123,
    "Code": "HD001"
  },
  "SaleChannelInDB": {
    "Id": 123,
    "RetailerId": 5,
    "IsActive": false
  },
  "CurrentRetailerId": 5,
  "ExpectedError": {
    "Type": "KvValidateSaleChannelException",
    "Message": "Kênh bán không tồn tại"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi kênh bán hàng không hoạt động.

### 5. Thời gian giao hàng không hợp lệ
```json
{
  "Invoice": {
    "PurchaseDate": "2023-08-15T14:00:00",
    "DeliveryDetail": {
      "ExpectedDelivery": "2023-08-15T13:00:00"
    }
  },
  "ExpectedError": {
    "Type": "KvValidateDeliveryInfoException",
    "Message": "Thời gian giao hàng phải sau thời gian hóa đơn"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi thời gian giao hàng dự kiến sớm hơn hoặc bằng thời gian mua hàng.

---
**Điều hướng**
- Trước đó: [09-CreateInvoice-DeliveryAddress.md](./09-CreateInvoice-DeliveryAddress.md)
- Tiếp theo: [11-CreateInvoice-DeliveryTime.md](./11-CreateInvoice-DeliveryTime.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 