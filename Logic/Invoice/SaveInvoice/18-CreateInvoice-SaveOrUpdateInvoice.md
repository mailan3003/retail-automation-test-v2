# Phân tích Business Logic của phương thức CreateInvoice

## Các bước xử lý chính

### 18. Lưu hoặc cập nhật hóa đơn

Quy trình lưu hoặc cập nhật hóa đơn bao gồm hai nhánh xử lý chính:

1. [Cập nhật hóa đơn hiện có](./18-1-CreateInvoice-UpdateExistingInvoice-Index.md)
   - Xử lý cho hóa đơn đã tồn tại (invoice.Id > 0)
   - Kiểm tra trạng thái tác vụ vận chuyển liên quan
   - Cập nhật thông tin hóa đơn
   - Xử lý đặc biệt cho hóa đơn sử dụng dịch vụ KShipV4

2. [Tạo hóa đơn mới](./18-2-CreateInvoice-CreateNewInvoice.md)
   - Xử lý cho hóa đơn mới (invoice.Id <= 0)
   - Kiểm tra và xác thực ban đầu
   - Xử lý hủy vận đơn khi thay đổi phương thức giao hàng
   - Tạo và cập nhật hóa đơn mới

---
**Điều hướng**
- Trước đó: [17-CreateInvoice-WarehouseCheck.md](./17-CreateInvoice-WarehouseCheck.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 