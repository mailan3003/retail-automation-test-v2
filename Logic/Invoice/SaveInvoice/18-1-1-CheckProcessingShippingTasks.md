# Phân tích Business Logic của phương thức CreateInvoice

## Các bước xử lý chính

### 18.1.1. Kiểm tra vận đơn đang xử lý

- **Mục đích**: Kiểm tra xem hóa đơn có đang được xử lý bởi tác vụ vận chuyển không trước khi cập nhật
  
- **Quy trình kiểm tra**:
  - Gọi phương thức `ShippingTaskService.ValidateProcessingInvoice(invoice.Id)` để thực hiện kiểm tra
  - Các bước xử lý:
    1. **Kiểm tra tính hợp lệ của ID hóa đơn**
       - Nếu **invoiceId = 0**, ném ngoại lệ với thông báo "Request không có dữ liệu" (KVMessage.request_DataNull)
    
    2. **Lấy cấu hình thời gian chờ**
       - Lấy thời gian chờ tối đa từ cấu hình hệ thống `AppServiceConfigInfo.ShippingTaskTimeOut`
       - Thời gian này xác định thời gian tối đa cho phép một tác vụ vận chuyển ở trạng thái "Processing"
    
    3. **Tìm tác vụ vận chuyển liên quan**
       - Truy vấn hệ thống để tìm tất cả các tác vụ vận chuyển liên quan đến hóa đơn này
       - Sử dụng `ShippingTaskOrderDetailService` để tìm các chi tiết tác vụ vận chuyển liên quan
    
    4. **Xử lý tác vụ vận chuyển**
       - Nếu tìm thấy tác vụ vận chuyển liên quan đến hóa đơn:
         + Gọi phương thức `CheckFailedTask` để kiểm tra và xử lý các tác vụ đã quá thời gian chờ
         + Phương thức này thực hiện các bước xử lý chi tiết:
           * **Xác định tác vụ quá hạn**: Lọc các tác vụ có trạng thái "Processing" và thời gian xử lý vượt quá thời gian chờ cấu hình
           * **Xử lý thông tin giao hàng**: Tìm và cập nhật các thông tin giao hàng liên quan
             - Xóa thông tin đối tác vận chuyển (đặt DeliveryBy = null, UseDefaultPartner = null)
             - Đánh dấu các tác vụ quá hạn thành "Error"
             - Thêm thông báo lỗi về việc vượt quá thời gian cho phép
           * **Cập nhật database**: Thực hiện các SQL query để cập nhật trạng thái tác vụ và lấy thông tin hóa đơn bị ảnh hưởng
           * **Xử lý thông báo và hủy đơn**: Tùy theo cấu hình, gửi thông báo xác nhận timeout hoặc yêu cầu hủy đơn qua RabbitMQ
           * **Ghi log**: Lưu thông tin chi tiết về quá trình xử lý
         + Mục đích: Tránh trường hợp hệ thống bị "treo" do các tác vụ vận chuyển không hoàn thành và cho phép người dùng tiếp tục thao tác với hóa đơn

- **Ý nghĩa nghiệp vụ**:
  - Đảm bảo không xảy ra xung đột khi cập nhật hóa đơn đang có tác vụ vận chuyển đang xử lý
  - Tự động xử lý các tác vụ vận chuyển quá hạn để tránh hóa đơn bị "kẹt" trong hệ thống
  - Cho phép người dùng tiếp tục cập nhật hóa đơn sau khi đã xử lý các tác vụ vận chuyển quá hạn

---
**Điều hướng**
- Quay lại: [18-1-CreateInvoice-UpdateExistingInvoice-Index.md](./18-1-CreateInvoice-UpdateExistingInvoice-Index.md)
- Tiếp theo: [18-1-2-ProcessExpiredShippingTasks.md](./18-1-2-ProcessExpiredShippingTasks.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 