# Phân tích Business Logic của phương thức CreateInvoice

## Các bước xử lý chính

### 18.1.2. Xử lý tác vụ vận chuyển quá hạn

Khi hệ thống phát hiện tác vụ vận chuyển đã quá thời gian chờ (timeout), cần thực hiện một chuỗi các bước xử lý để đảm bảo hệ thống vận hành trơn tru và không bị "treo" bởi các tác vụ không hoàn thành.

#### 1. Xác định tác vụ quá hạn

- **Tiêu chí xác định**:
  - Tác vụ có trạng thái "Processing" (đang xử lý)
  - Thời gian xử lý vượt quá thời gian chờ được cấu hình (AppServiceConfigInfo.ShippingTaskTimeOut)
  - Công thức tính: Thời gian hiện tại - Thời gian bắt đầu xử lý > Thời gian chờ cấu hình

- **Kết quả**:
  - Tạo danh sách các tác vụ quá hạn cần xử lý
  - Lưu thông tin ID tác vụ để phục vụ các bước xử lý tiếp theo

#### 2. Xử lý thông tin giao hàng

- **Thu thập thông tin liên quan**:
  - Lấy danh sách chi tiết tác vụ vận chuyển chưa hoàn thành
  - Tìm các thông tin giao hàng (DeliveryInfo) liên quan đến các tác vụ này

- **Cập nhật thông tin giao hàng**:
  - Xóa thông tin đối tác vận chuyển:
    + Đặt **DeliveryBy = null** (bỏ liên kết với đối tác vận chuyển)
    + Đặt **UseDefaultPartner = null** (bỏ cờ sử dụng đối tác mặc định)
  - Mục đích: Cho phép người dùng chọn lại đối tác vận chuyển sau khi xử lý lỗi

- **Cập nhật trạng thái tác vụ vận chuyển**:
  - Đánh dấu các tác vụ quá hạn thành "Error" (lỗi)
  - Thêm thông báo lỗi: "Lỗi do thời gian tạo vận đơn hàng loạt vượt quá ngưỡng cho phép ({0} phút). Xin vui lòng thử lại."
  - Cập nhật thông tin người sửa đổi (ModifiedBy) và thời gian sửa đổi (ModifiedDate)

#### 3. Cập nhật trạng thái trong database

- **Cập nhật bảng ShippingTask**:
  ```sql
  UPDATE ShippingTask 
  SET Status = 'Error', 
      ErrorMessage = N'Lỗi do thời gian tạo vận đơn hàng loạt vượt quá ngưỡng cho phép (' + @timeoutMinutes + ' phút). Xin vui lòng thử lại.',
      ModifiedBy = @currentUserId,
      ModifiedDate = GETDATE()
  WHERE Id IN (@taskIds) AND Status = 'Processing'
  ```

- **Truy vấn thông tin hóa đơn bị ảnh hưởng**:
  ```sql
  SELECT i.Code AS InvoiceCode, st.Id AS TaskId
  FROM ShippingTaskOrderDetail stod
  JOIN ShippingTask st ON stod.ShippingTaskId = st.Id
  JOIN Invoice i ON stod.InvoiceId = i.Id
  WHERE st.Id IN (@taskIds) AND st.Status = 'Error'
  ```

#### 4. Xử lý thông báo và hủy đơn

- **Xử lý xác nhận hết thời gian chờ**:
  - Điều kiện: Cấu hình `ShippingUseConfirmMultipleOrderTimeout` được bật
  - Hành động:
    + Tạo thông điệp xác nhận hết thời gian chờ với thông tin chi tiết về các hóa đơn bị ảnh hưởng
    + Gửi thông điệp qua RabbitMQ đến hàng đợi `mq.ConfirmMultiOrderRequestTimeoutMq.inq`
    + Hệ thống xử lý hàng đợi sẽ gửi xác nhận đến đối tác vận chuyển về việc đơn hàng không thể xử lý do hết thời gian

- **Xử lý hủy đơn hàng vận chuyển**:
  - Điều kiện: Cấu hình `ShippingUseCancelMultipleOrderTimeout` được bật
  - Hành động:
    + Lấy thông tin mã hóa đơn và mã đối tác vận chuyển
    + Gửi yêu cầu hủy đơn hàng vận chuyển qua RabbitMQ đến hàng đợi `mq.VoidOrderRequestMq.inq`
    + Hệ thống xử lý hàng đợi sẽ thực hiện việc hủy đơn hàng trên hệ thống của đối tác vận chuyển

#### 5. Ghi log

- **Thông tin ghi nhận**:
  - Mã người bán lẻ, hành động thực hiện
  - Trạng thái các thao tác:
    + Đã xóa thông tin đối tác vận chuyển
    + Đã hủy đơn hàng vận chuyển
    + Đã xác nhận hết thời gian chờ
  - Danh sách các ID:
    + ID tác vụ vận chuyển
    + ID thông tin giao hàng
    + ID hóa đơn
  - Thông tin hóa đơn và đối tác vận chuyển:
    + Mã hóa đơn
    + Mã đối tác vận chuyển

- **Mục đích**:
  - Theo dõi và kiểm soát quá trình xử lý
  - Tạo điểm khôi phục khi cần tra cứu lỗi
  - Phục vụ các báo cáo vận hành hệ thống

---
**Điều hướng**
- Quay lại: [18-1-CreateInvoice-UpdateExistingInvoice-Index.md](./18-1-CreateInvoice-UpdateExistingInvoice-Index.md)
- Trước đó: [18-1-1-CheckProcessingShippingTasks.md](./18-1-1-CheckProcessingShippingTasks.md)
- Tiếp theo: [18-1-3-UpdateInvoice.md](./18-1-3-UpdateInvoice.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 