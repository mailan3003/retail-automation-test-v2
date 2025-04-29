# Phân tích Business Logic của phương thức CreateInvoice

### 13. Kiểm tra người bán hàng
- **Xác thực người bán hàng**:
  - Hệ thống kiểm tra ID người bán hàng (`SoldById`) trong hóa đơn
  - Sử dụng `UserService.GetUserById(invoice.SoldById)` để lấy thông tin người dùng
  - Kiểm tra người bán hàng có tồn tại trong hệ thống không:
    - Nếu người bán không tồn tại (`soldby == null`), hệ thống sẽ ném ngoại lệ `KvValidateUserException` với thông báo `$"{KVMessage.invoiceLog_SalePersion} {KVMessage.invoiceError_NotExistOrDeleted}"` (Người bán không tồn tại hoặc đã bị xóa khỏi hệ thống)
  - Kiểm tra trạng thái hoạt động của người bán hàng (`user.Status == UserStatus.Active`)
  - Nếu người bán tồn tại nhưng không còn hoạt động (`IsActive == false`) và đang tạo hóa đơn mới (`invoice.Id <= 0`), hệ thống sẽ ném ngoại lệ `KvValidateUserException` với thông báo `$"{KVMessage.invoiceLog_SalePersion} {soldby.GivenName} {KVMessage.invoiceError_StopedProcessing}"` (Người bán [tên người bán] đã bị ngừng hoạt động) 

## Test Data JSON cho các trường hợp thất bại

### 1. Người bán không còn hoạt động khi tạo hóa đơn mới
```json
{
  "Invoice": {
    "Id": 0,
    "SoldById": 123,
    "Code": "HD001"
  },
  "SalesPerson": {
    "Id": 123,
    "GivenName": "Nguyễn Văn A",
    "Status": 0,
    "IsActive": false
  },
  "ExpectedError": {
    "Type": "KvValidateUserException",
    "Message": "Người bán Nguyễn Văn A đã bị ngừng hoạt động"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi phát hiện người bán hàng đã bị ngừng hoạt động trong quá trình tạo hóa đơn mới.

### 2. Bỏ qua kiểm tra người bán không hoạt động khi cập nhật hóa đơn
```json
{
  "Invoice": {
    "Id": 100,
    "SoldById": 123,
    "Code": "HD100"
  },
  "SalesPerson": {
    "Id": 123,
    "GivenName": "Nguyễn Văn A",
    "Status": 0,
    "IsActive": false
  },
  "ExpectedResult": {
    "Success": true
  }
}
```
**Kết quả kiểm tra**: Hệ thống bỏ qua kiểm tra trạng thái người bán khi thực hiện cập nhật hóa đơn đã tồn tại.

### 3. Người bán không tồn tại
```json
{
  "Invoice": {
    "Id": 0,
    "SoldById": 456,
    "Code": "HD001"
  },
  "SalesPerson": null,
  "ExpectedError": {
    "Type": "KvValidateUserException",
    "Message": "Người bán không tồn tại hoặc đã bị xóa khỏi hệ thống"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi không tìm thấy thông tin người bán hàng trong hệ thống.

---
**Điều hướng**
- Trước đó: [13-CreateInvoice-Prescription.md](./13-CreateInvoice-Prescription.md)
- Tiếp theo: [15-CreateInvoice-PaymentValidation.md](./15-CreateInvoice-PaymentValidation.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 