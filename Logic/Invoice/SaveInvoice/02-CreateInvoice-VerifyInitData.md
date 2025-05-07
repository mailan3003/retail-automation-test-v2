# Phân tích Business Logic của phương thức CreateInvoice

## Các bước xử lý chính

### 1. Khởi tạo và chuẩn bị dữ liệu
- **Trích xuất và chuẩn bị dữ liệu ban đầu**:
  - Kiểm tra cấu hình thuế VAT thông qua `TaxService.IsActiveProductVATToggle()` và lưu kết quả vào biến `isUsingProductVAT`
  - Nếu không sử dụng VAT theo sản phẩm (`isUsingProductVAT = false`), hệ thống đặt `invoice.TotalTax = null`
  - Xác định ngành hàng: `isCoffee = CurrentIndustryId == (int)IndustryList.Coffee` để áp dụng các quy tắc xử lý đặc thù

- **Chuẩn hóa thông tin thời gian**:
  - Chuyển đổi thời gian từ UTC sang múi giờ địa phương:
    - `invoice.PurchaseDate = invoice.PurchaseDateUtc ?? invoice.PurchaseDate`
    - `invoice.ExpectedDelivery = invoice.ExpectedDeliveryUtc ?? invoice.ExpectedDelivery`
  - Nếu có thông tin giao hàng, cũng chuẩn hóa thời gian giao hàng dự kiến:
    - `invoice.DeliveryDetail.ExpectedDelivery = invoice.DeliveryDetail.ExpectedDeliveryUtc ?? invoice.DeliveryDetail.ExpectedDelivery`

- **Xử lý thông tin người bán và giao hàng**:
  - Kiểm tra quyền sửa người bán hàng:
    - So sánh `invoice.SoldById` với `invoice.CompareSoldById`
    - Gọi `AuthService.CheckPermission(Invoice.ModifySeller)` để kiểm tra quyền
    - Nếu không có quyền nhưng đang thay đổi người bán, khôi phục giá trị ban đầu: `invoice.SoldById = invoice.CompareSoldById`
  - Làm sạch thông tin giao hàng (nếu có):
    - `invoice.DeliveryDetail.Address = StringHelper.RemoveRegex(invoice.DeliveryDetail.Address)`
    - Loại bỏ các ký tự đặc biệt không hợp lệ, đảm bảo tính nhất quán của dữ liệu 

---

## Test Data JSON cho các trường hợp thất bại

### 2. Thay đổi người bán không có quyền
```json
{
  "Invoice": {
    "SoldById": 102,
    "CompareSoldById": 101,
    "PurchaseDate": "2023-01-01T10:00:00",
    "ExpectedDelivery": "2023-01-05T14:00:00"
  },
  "CurrentUser": {
    "Permissions": []
  },
  "ExpectedResult": {
    "SoldById": 101
  }
}
```
**Kết quả kiểm tra**: Hệ thống khôi phục người bán về giá trị ban đầu khi người dùng không có quyền sửa đổi, đảm bảo tính toàn vẹn của dữ liệu và phân quyền chức năng.

### 3. Dữ liệu địa chỉ giao hàng không hợp lệ
```json
{
  "Invoice": {
    "DeliveryDetail": {
      "Address": "123 Đường ABC <script>alert('XSS')</script>",
      "ExpectedDeliveryUtc": "2023-01-05T07:00:00Z"
    }
  },
  "ExpectedResult": {
    "DeliveryDetail": {
      "Address": "123 Đường ABC ",
      "ExpectedDelivery": "2023-01-05T14:00:00"
    }
  }
}
```
**Kết quả kiểm tra**: Hệ thống loại bỏ các ký tự đặc biệt và mã script trong địa chỉ, đồng thời chuyển đổi múi giờ, ngăn chặn tấn công XSS và chuẩn hóa dữ liệu thời gian.

---
**Điều hướng**
- Trước đó: [01-CreateInvoice-Overview.md](./01-CreateInvoice-Overview.md)
- Tiếp theo: [03-CreateInvoice-DuplicateInvoice.md](./03-CreateInvoice-DuplicateInvoice.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 