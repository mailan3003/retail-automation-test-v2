# Phân tích Business Logic của phương thức CreateInvoice

### 6. Kiểm tra UUID
- **Kiểm tra UUID để tránh hóa đơn trùng lặp**:
  - Hệ thống sử dụng phương thức `CheckUuidAsync(invoice)` để xác minh UUID của hóa đơn
  - Hệ thống bỏ qua việc kiểm tra UUID trong các trường hợp sau:
    - Hóa đơn không tồn tại (null)
    - Hóa đơn đã được lưu trong hệ thống (Id > 0)
    - Tính năng kiểm tra UUID trùng lặp đang tắt
    - Hóa đơn không có UUID
    - Hóa đơn là đơn hàng offline (mã bắt đầu bằng tiền tố "HDO")
  
  - Quy trình kiểm tra UUID:
    - Sử dụng transaction với mức cô lập ReadUncommitted
    - Tìm kiếm hóa đơn có UUID giống nhau trong khoảng thời gian 7 ngày trước và sau ngày mua hàng
    - Nếu ngày mua hàng không hợp lệ, sử dụng thời gian hiện tại làm mốc
  
  - Xử lý khi phát hiện UUID trùng lặp:
    - Nếu cả thông tin khách hàng và tổng tiền đều trùng khớp:
      - Ném ngoại lệ với thông báo "Mã hóa đơn online bị trùng: {mã hóa đơn hiện tại} - {mã hóa đơn mới}"
    
    - Nếu tổng tiền khác nhau hoặc thông tin khách hàng khác nhau:
      - Tạo UUID mới với định dạng "WN" + Guid mới
      - Ghi log thông tin về việc phát hiện và xử lý UUID trùng lặp `$"{KVMessage.invoiceLog_OnlineInvoiceCodeIsDup}: {tempInv.Code} - UUID: {tempInv.Uuid} | {inv.Code} - UUID: {inv.Uuid}"`
      - Tiếp tục xử lý hóa đơn với UUID mới 

## Test Data JSON cho các trường hợp thất bại

### 1. UUID trùng lặp với cùng khách hàng và tổng tiền
```json
{
  "Invoice": {
    "Id": 0,
    "Uuid": "550e8400-e29b-41d4-a716-446655440000",
    "Code": "HD001",
    "CustomerId": 123,
    "Total": 500000,
    "PurchaseDate": "2023-08-10T10:00:00"
  },
  "ExistingInvoice": {
    "Id": 50,
    "Uuid": "550e8400-e29b-41d4-a716-446655440000",
    "Code": "HD050",
    "CustomerId": 123,
    "Total": 500000,
    "PurchaseDate": "2023-08-10T09:30:00"
  },
  "Settings": {
    "OffCodePrefix": "HDO"
  },
  "ExpectedError": {
    "Type": "KvValidateInvoiceException",
    "Message": "Mã hóa đơn online bị trùng: HD050 - HD001"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi phát hiện UUID trùng lặp với cùng khách hàng và tổng tiền, ngăn chặn tạo hóa đơn trùng.

### 2. UUID trùng lặp nhưng khác thông tin khách hàng
```json
{
  "Invoice": {
    "Id": 0,
    "Uuid": "550e8400-e29b-41d4-a716-446655440000",
    "Code": "HD001",
    "CustomerId": 456,
    "Total": 500000,
    "PurchaseDate": "2023-08-10T10:00:00"
  },
  "ExistingInvoice": {
    "Id": 50,
    "Uuid": "550e8400-e29b-41d4-a716-446655440000",
    "Code": "HD050",
    "CustomerId": 123,
    "Total": 500000,
    "PurchaseDate": "2023-08-10T09:30:00"
  },
  "Settings": {
    "OffCodePrefix": "HDO"
  },
  "ExpectedResult": {
    "NewUuid": "WN*"
  },
  "LogInfo": {
    "Type": "Info",
    "Message": "UUID trùng lặp được phát hiện và xử lý"
  }
}
```
**Kết quả kiểm tra**: Hệ thống tự động tạo UUID mới khi phát hiện UUID trùng lặp nhưng khác thông tin khách hàng, cho phép tiếp tục xử lý hóa đơn.

### 3. UUID trùng lặp nhưng khác tổng tiền
```json
{
  "Invoice": {
    "Id": 0,
    "Uuid": "550e8400-e29b-41d4-a716-446655440000",
    "Code": "HD001",
    "CustomerId": 123,
    "Total": 600000,
    "PurchaseDate": "2023-08-10T10:00:00"
  },
  "ExistingInvoice": {
    "Id": 50,
    "Uuid": "550e8400-e29b-41d4-a716-446655440000",
    "Code": "HD050",
    "CustomerId": 123,
    "Total": 500000,
    "PurchaseDate": "2023-08-10T09:30:00"
  },
  "Settings": {
    "OffCodePrefix": "HDO"
  },
  "ExpectedResult": {
    "NewUuid": "WN*"
  },
  "LogInfo": {
    "Type": "Info",
    "Message": "Mã hóa đơn online bị trùng"
  }
}
```
**Kết quả kiểm tra**: Hệ thống tự động tạo UUID mới khi phát hiện UUID trùng lặp nhưng khác tổng tiền, cho phép tiếp tục xử lý hóa đơn.

---
**Điều hướng**
- Trước đó: [06-CreateInvoice-PromotionCheck.md](./06-CreateInvoice-PromotionCheck.md)
- Tiếp theo: [08-CreateInvoice-CODDelivery.md](./08-CreateInvoice-CODDelivery.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 