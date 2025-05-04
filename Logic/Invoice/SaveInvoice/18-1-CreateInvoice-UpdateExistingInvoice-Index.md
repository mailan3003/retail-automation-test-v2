# Phân tích Business Logic của phương thức CreateInvoice

## Các bước xử lý chính

### 18.1. Cập nhật hóa đơn hiện có

- **Điều kiện áp dụng**: **invoice.Id > 0** (hóa đơn đã có ID, đã tồn tại trong hệ thống)

#### Các giai đoạn xử lý

1. [Kiểm tra vận đơn đang xử lý](./18-1-1-CheckProcessingShippingTasks.md)
   - Xác thực tác vụ vận chuyển liên quan đến hóa đơn
   - Xử lý các tác vụ vận chuyển quá hạn

2. [Xử lý tác vụ vận chuyển quá hạn](./18-1-2-ProcessExpiredShippingTasks.md)
   - Xác định các tác vụ vận chuyển quá thời gian xử lý
   - Cập nhật thông tin giao hàng
   - Xử lý thông báo và hủy đơn

3. [Cập nhật hóa đơn](./18-1-3-UpdateInvoice.md)
   - Chuẩn hóa chi tiết hóa đơn 
   - Xử lý thông tin giao hàng
   - Kiểm tra tính hợp lệ của hóa đơn
   - Cập nhật thông tin thanh toán
   - Cập nhật các thông tin liên quan

4. [Xử lý đặc biệt cho KShipV4](./18-1-4-KShipV4Handling.md)
   - Cập nhật thông tin đơn hàng tự giao (self-delivery)

---
**Điều hướng**
- Quay lại: [18-CreateInvoice-SaveOrUpdateInvoice.md](./18-CreateInvoice-SaveOrUpdateInvoice.md)
- Tiếp theo: [18-2-CreateInvoice-CreateNewInvoice.md](./18-2-CreateInvoice-CreateNewInvoice.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 