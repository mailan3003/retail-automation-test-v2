# Phân tích Business Logic của phương thức CreateInvoice

## Các bước xử lý chính

### 18.2. Tạo hóa đơn mới

- **Xử lý cho hóa đơn mới**:
  - Điều kiện áp dụng: **invoice.Id <= 0** (hóa đơn chưa có ID, chưa tồn tại trong hệ thống)
  
  - **Kiểm tra và xác thực ban đầu**:
    - Nếu là hóa đơn cập nhật (**invoice.UpdateInvoiceId > 0**):
      - Kiểm tra xem hóa đơn gốc có đang được xử lý bởi tác vụ vận chuyển không
      - Sử dụng `ShippingTaskService.ValidateProcessingInvoice(invoice.UpdateInvoiceId)` tương tự như khi cập nhật hóa đơn hiện có
      - Chi tiết về quá trình xử lý: [18-2-1-CheckFailedTask.md](./18-2-1-CheckFailedTask.md)
    - Lưu trữ ID đơn hàng đã hoàn thành (nếu có) để xử lý sau này:
      - Nếu hóa đơn được tạo từ đơn hàng, lưu lại ID đơn hàng để cập nhật trạng thái sau khi tạo hóa đơn thành công

  - **Xử lý hủy vận đơn khi thay đổi phương thức giao hàng**:
    - Điều kiện áp dụng:
      - Đang cập nhật hóa đơn (**invoice.UpdateInvoiceId > 0**)
      - Hóa đơn cũ sử dụng đối tác vận chuyển (**UseDefaultPartner = true**)
      - Hóa đơn cũ đã có mã vận đơn (DeliveryCode không rỗng)
      - Hóa đơn mới chuyển sang tự giao hàng (**UseDefaultPartner = false**)
    - Chi tiết về quá trình xử lý: [18-2-2-VoidDeliveryOrder.md](./18-2-2-VoidDeliveryOrder.md)

  - **Tạo và cập nhật hóa đơn**:
    - Gọi phương thức `InvoiceService.MakeInvoiceAsync()` với các tham số phù hợp:
      - `updateOnHand`: Cập nhật số lượng tồn kho (true/false)
      - `isNewInvoice`: Đánh dấu là hóa đơn mới (true)
      - `fromCombine`: Đánh dấu nếu tạo từ việc kết hợp hóa đơn (false, trừ khi được chỉ định)
      - `omniOnlineFieldObject`: Thông tin bổ sung cho kênh bán hàng đa kênh
    - Chi tiết về quá trình xử lý: [18-2-3-CreateAndUpdateInvoice.md](./18-2-3-CreateAndUpdateInvoice.md)

## Tài liệu chi tiết
- [18-2-1-CheckFailedTask.md](./18-2-1-CheckFailedTask.md): Kiểm tra và xử lý tác vụ vận chuyển bị lỗi
- [18-2-2-VoidDeliveryOrder.md](./18-2-2-VoidDeliveryOrder.md): Xử lý hủy vận đơn khi thay đổi phương thức giao hàng
- [18-2-3-CreateAndUpdateInvoice.md](./18-2-3-CreateAndUpdateInvoice.md): Quy trình tạo và cập nhật hóa đơn

---
**Điều hướng**
- Quay lại: [18-CreateInvoice-SaveOrUpdateInvoice.md](./18-CreateInvoice-SaveOrUpdateInvoice.md)
- Trước đó: [18-1-CreateInvoice-UpdateExistingInvoice-Index.md](./18-1-CreateInvoice-UpdateExistingInvoice-Index.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 