# Phân tích Business Logic của phương thức CreateInvoice

### 2. Kiểm tra hóa đơn trùng lặp
- **Kiểm tra và xử lý UUID để tránh hóa đơn trùng lặp**: 
  - **Điều kiện áp dụng**: Hệ thống chỉ thực hiện kiểm tra khi:
    - Cờ xử lý hóa đơn được bật (`InvoiceProcessingToggle = true`)
    - Đang tạo mới hóa đơn (`invoice.Id <= 0`)
    - UUID và mã hóa đơn không rỗng
    - Không phải hóa đơn offline (mã không bắt đầu bằng `OffCodePrefix`, trong đó `OffCodePrefix` là "HDO")
  
  - **Quy trình xử lý UUID**:
    1. **Kiểm tra trong Redis cache**: Hệ thống gọi `InvoiceService.CheckCachRedisUUID(invoice.Uuid)` để kiểm tra UUID
       - Tạo khóa cache theo định dạng `cache:InvoiceProcessing:retailerId_{0}:{1}` với {0} là ID nhà bán lẻ và {1} là UUID hóa đơn
       - Truy vấn Redis để xác định UUID đã được sử dụng chưa
    
    2. **Xử lý kết quả kiểm tra**:
       - Nếu UUID đã tồn tại: Ném ngoại lệ với thông báo "Mã hóa đơn online bị trùng" kèm thời gian tạo
       - Nếu UUID chưa tồn tại: Lưu UUID vào Redis cache với thời gian hiện tại và TTL giới hạn
    
  - **Lợi ích**: Cơ chế này ngăn chặn việc tạo hóa đơn trùng lặp khi có nhiều request đồng thời, đảm bảo tính toàn vẹn dữ liệu. 

## Test Data JSON cho các trường hợp thất bại

### 1. Hóa đơn trùng UUID
```json
{
  "Invoice": {
    "Id": 0,
    "Uuid": "550e8400-e29b-41d4-a716-446655440000",
    "Code": "HD001"
  },
  "Config": {
    "InvoiceProcessingToggle": true
  },
  "RedisCache": {
    "Key": "cache:InvoiceProcessing:retailerId_123:550e8400-e29b-41d4-a716-446655440000",
    "Value": "2023-08-15T10:30:45"
  },
  "ExpectedError": {
    "Type": "KvValidateInvoiceException",
    "Message": "Mã hóa đơn online bị trùng"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi phát hiện UUID đã tồn tại trong cache, ngăn chặn việc tạo hóa đơn trùng lặp.

### 2. Hóa đơn offline bỏ qua kiểm tra UUID
```json
{
  "Invoice": {
    "Id": 0,
    "Uuid": "550e8400-e29b-41d4-a716-446655440000",
    "Code": "HDO001"
  },
  "Config": {
    "InvoiceProcessingToggle": true,
    "OffCodePrefix": "HDO"
  },
  "ExpectedResult": {
    "SkipUuidCheck": true
  }
}
```
**Kết quả kiểm tra**: Hệ thống không thực hiện kiểm tra UUID với hóa đơn offline (mã bắt đầu bằng HDO), cho phép tạo hóa đơn mà không kiểm tra trùng lặp.

---
**Điều hướng**
- Trước đó: [02-CreateInvoice-VerifyInitData.md](./02-CreateInvoice-VerifyInitData.md)
- Tiếp theo: [04-CreateInvoice-UpdateInvoice.md](./04-CreateInvoice-UpdateInvoice.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 