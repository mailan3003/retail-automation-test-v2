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

---
**Điều hướng**
- Trước đó: [02-CreateInvoice-VerifyInitData.md](./02-CreateInvoice-VerifyInitData.md)
- Tiếp theo: [04-CreateInvoice-UpdateInvoice.md](./04-CreateInvoice-UpdateInvoice.md)
- Tổng quan: [01-CreateInvoice-Overview.md](./01-CreateInvoice-Overview.md) 