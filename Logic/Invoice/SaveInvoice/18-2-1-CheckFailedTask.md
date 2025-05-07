# Phân tích Business Logic của phương thức CreateInvoice

## Các bước xử lý chính

### 18.2.1. Kiểm tra và xử lý tác vụ vận chuyển bị lỗi (CheckFailedTask)

- **Mục đích**: Kiểm tra và xử lý các tác vụ vận chuyển bị lỗi hoặc quá thời gian chờ khi tạo hóa đơn mới

- **Điều kiện áp dụng**:
  - Đang tạo hóa đơn mới hoặc cập nhật hóa đơn (thông qua hóa đơn mới)
  - Có liên quan đến tác vụ vận chuyển (thông thường với đơn hàng có UsingCod = 1)

- **Quy trình xử lý chi tiết**:
  1. **Xác định tác vụ vận chuyển quá hạn**:
     - Hệ thống sẽ quét tất cả các tác vụ vận chuyển có trạng thái "Processing" liên quan đến hóa đơn
     - Thời gian xử lý (processingTime) được tính từ lúc bắt đầu xử lý tác vụ
     - So sánh thời gian xử lý với thời gian cho phép từ cấu hình `AppServiceConfigInfo.ShippingTaskTimeOut`
     - Nếu thời gian xử lý vượt quá thời gian chờ, tác vụ được đánh dấu là "quá hạn"

  2. **Xử lý thông tin giao hàng của tác vụ quá hạn**:
     - Tìm thông tin giao hàng (DeliveryInfo) liên quan đến tác vụ quá hạn
     - Xóa thông tin đối tác vận chuyển bằng cách:
       + Đặt DeliveryBy = null (xóa thông tin đơn vị vận chuyển)
       + Đặt UseDefaultPartner = null (đánh dấu không sử dụng đối tác vận chuyển mặc định)
     - Đánh dấu tác vụ quá hạn thành trạng thái "Error"
     - Thêm thông báo lỗi "Tác vụ đã vượt quá thời gian cho phép"

  3. **Cập nhật cơ sở dữ liệu**:
     - Thực hiện các câu lệnh SQL để cập nhật trạng thái tác vụ vận chuyển
     - Lưu lại thông tin các hóa đơn bị ảnh hưởng để xử lý tiếp theo
     - Cập nhật các bảng liên quan: ShippingTask, DeliveryInfo, ShippingTaskOrderDetail

  4. **Xử lý thông báo và hủy đơn**:
     - Tùy theo cấu hình hệ thống, hệ thống có thể:
       + Gửi thông báo xác nhận timeout đến người dùng
       + Tự động gửi yêu cầu hủy đơn hàng qua RabbitMQ nếu cấu hình cho phép
       + Thông báo cho các dịch vụ liên quan về việc tác vụ vận chuyển bị hủy

  5. **Ghi nhật ký (Log)**:
     - Lưu thông tin chi tiết về quá trình xử lý tác vụ quá hạn
     - Bao gồm thông tin: ID tác vụ, thời gian xử lý, thời gian chờ cấu hình, trạng thái xử lý
     - Giúp quản trị viên theo dõi và khắc phục sự cố

- **Quy trình xử lý sau khi kiểm tra**:
  - Nếu không còn tác vụ vận chuyển nào đang xử lý (Processing) sau khi đã xử lý các tác vụ quá hạn:
    + Cho phép tiếp tục quy trình tạo hóa đơn mới
  - Nếu vẫn còn tác vụ vận chuyển đang xử lý (Processing) và chưa quá hạn:
    + Hiển thị thông báo cho người dùng về việc không thể cập nhật hóa đơn do đang có tác vụ vận chuyển đang xử lý
    + Yêu cầu người dùng thử lại sau

- **Ý nghĩa nghiệp vụ**:
  - Đảm bảo hệ thống không bị "treo" do các tác vụ vận chuyển không hoàn thành
  - Cho phép người dùng tiếp tục tạo hoặc cập nhật hóa đơn sau khi đã xử lý các tác vụ vận chuyển quá hạn
  - Duy trì tính nhất quán của dữ liệu giữa hóa đơn và thông tin vận chuyển
  - Cải thiện trải nghiệm người dùng bằng cách không yêu cầu can thiệp thủ công cho các tác vụ vận chuyển bị lỗi

---
**Điều hướng**
- Quay lại: [18-2-CreateInvoice-CreateNewInvoice.md](./18-2-CreateInvoice-CreateNewInvoice.md)
- Tiếp theo: [18-2-2-VoidDeliveryOrder.md](./18-2-2-VoidDeliveryOrder.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 