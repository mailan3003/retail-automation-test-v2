# Phân tích Business Logic của phương thức CreateInvoice

## Các bước xử lý chính

### 18.1.4. Xử lý đặc biệt cho KShipV4

Sau khi hoàn tất cập nhật thông tin hóa đơn, hệ thống thực hiện xử lý đặc biệt cho hóa đơn sử dụng dịch vụ KShipV4 (phiên bản 4 của hệ thống quản lý vận chuyển KiotViet).

#### Điều kiện áp dụng

- **KShipV4 đang được kích hoạt**: 
  - Cấu hình hệ thống cho phép sử dụng KShipV4
  - Dịch vụ KShipV4 đang hoạt động và sẵn sàng xử lý

- **Thông tin giao hàng thỏa mãn**:
  - Hóa đơn có thông tin giao hàng (DeliveryDetail)
  - Thiết lập **UseDefaultPartner = false** (đơn hàng tự giao, không sử dụng đối tác vận chuyển mặc định)

#### Quy trình xử lý

- **Cập nhật thông tin đơn hàng tự giao**:
  - Gọi phương thức `DeliveryInfoService.UpdateSelfDeliveryOrder()`
  - Tham số truyền vào:
    + Thông tin hóa đơn đã cập nhật
    + Thông tin giao hàng liên quan

- **Các thông tin cập nhật**:
  - Thông tin người giao hàng
  - Lịch trình giao hàng
  - Trạng thái giao hàng
  - Các thông tin liên lạc và ghi chú

#### Ý nghĩa nghiệp vụ

- **Phân biệt 2 loại đơn giao hàng**:
  1. **Đơn tự giao** (UseDefaultPartner = false):
     - Cửa hàng tự quản lý việc giao hàng
     - Sử dụng nhân viên giao hàng nội bộ
     - Không sử dụng đối tác vận chuyển bên ngoài
  
  2. **Đơn giao qua đối tác** (UseDefaultPartner = true):
     - Sử dụng dịch vụ của đối tác vận chuyển bên ngoài (như Giao Hàng Nhanh, VNPost, v.v.)
     - Có mã vận đơn do đối tác cấp
     - Theo dõi trạng thái thông qua API của đối tác

- **Lợi ích của KShipV4**:
  - Quản lý tập trung cả đơn tự giao và đơn giao qua đối tác
  - Theo dõi trạng thái giao hàng trong thời gian thực
  - Hỗ trợ các tính năng nâng cao như phân vùng giao hàng, tối ưu lịch trình
  - Tích hợp với nhiều đối tác vận chuyển hơn so với các phiên bản trước

#### Kết quả xử lý

- **Cập nhật thông tin giao hàng**:
  - Lưu thông tin cập nhật vào cơ sở dữ liệu
  - Đồng bộ hóa thông tin với hệ thống KShipV4

- **Theo dõi trạng thái**:
  - Thiết lập các cơ chế theo dõi trạng thái giao hàng
  - Cho phép cập nhật trạng thái và thông báo cho khách hàng

- **Báo cáo và thống kê**:
  - Cập nhật dữ liệu để phục vụ báo cáo giao hàng
  - Thống kê hiệu suất giao hàng

---
**Điều hướng**
- Quay lại: [18-1-CreateInvoice-UpdateExistingInvoice-Index.md](./18-1-CreateInvoice-UpdateExistingInvoice-Index.md)
- Trước đó: [18-1-3-UpdateInvoice.md](./18-1-3-UpdateInvoice.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 