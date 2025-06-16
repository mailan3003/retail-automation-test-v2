# Warehouse Validation Logic

## ValidateStatusOfWarehouse

`WarehouseService.ValidateStatusOfWarehouse(whId)` - Phương thức kiểm tra tính hợp lệ của kho hàng.

### Tham số
- `whId`: ID của kho hàng cần kiểm tra

### Quy trình kiểm tra kho hàng
1. Kiểm tra xem cửa hàng có đang sử dụng hoặc đã từng sử dụng tính năng quản lý kho không
2. Nếu có, tiếp tục kiểm tra trạng thái kho hàng hiện tại
3. Lấy thông tin kho hàng từ cơ sở dữ liệu dựa trên ID kho hàng
4. Kiểm tra các điều kiện về trạng thái kho:
   - Nếu kho hàng không còn hoạt động: Hiển thị thông báo "{tên kho} không hợp lệ" (KVMessage.WarehouseIsDeleted)
   - Nếu kho hàng bị hạn chế truy cập: Hiển thị thông báo "{tên kho} đã ngừng hoạt động" (KVMessage.WarehouseIsDeactived)

### Mục đích kiểm tra
- Đảm bảo rằng kho hàng được sử dụng trong hóa đơn phải tồn tại
- Đảm bảo kho hàng đang hoạt động (không bị xóa)
- Đảm bảo kho hàng không bị hạn chế truy cập (không bị vô hiệu hóa)

### Kết quả
- Nếu kho hàng không đáp ứng các điều kiện trên, quá trình tạo/cập nhật hóa đơn sẽ bị dừng lại và hiển thị thông báo lỗi tương ứng
- Nếu kho hàng hợp lệ, quá trình tạo/cập nhật hóa đơn sẽ tiếp tục 