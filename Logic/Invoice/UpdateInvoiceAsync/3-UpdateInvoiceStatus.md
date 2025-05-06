# Phân tích Business Logic của phương thức UpdateInvoiceAsync

## 18.1.3.3. Cập nhật trạng thái hóa đơn

### Mục đích
Cập nhật và quản lý trạng thái của hóa đơn, đặc biệt là xử lý các trường hợp đặc biệt như hóa đơn COD và các trạng thái giao hàng.

### Quy trình xử lý

#### 1. Xử lý đặc biệt cho hóa đơn COD
- **Điều kiện áp dụng**:
  - Hóa đơn sử dụng COD (UsingCod = 1)
  - Trạng thái hiện tại là 4 (đang trả hàng)

- **Xử lý**:
  ```csharp
  if (invoice.UsingCod == 1 && invoice.Status == 4)
  {
      invoice.Status = (byte)InvoiceState.Pending;
      if (invoice.DeliveryDetail != null)
      {
          invoice.DeliveryDetail.Status = (byte)DeliveryStatus.Delivering;
      }
  }
  ```
  - Đặt lại trạng thái hóa đơn thành "Chờ xử lý" (InvoiceState.Pending)
  - Nếu có thông tin giao hàng, cập nhật trạng thái giao hàng thành "Đang giao" (DeliveryStatus.Delivering)

#### 2. Cập nhật trạng thái giao hàng
- **Mục đích**: Đảm bảo tính nhất quán giữa trạng thái hóa đơn và trạng thái giao hàng
- **Xử lý**:
  - Kiểm tra điều kiện cập nhật:
    + Có thông tin giao hàng (DeliveryDetail không null)
    + Trạng thái giao hàng hiện tại khác với trạng thái mới
  - Cập nhật trạng thái giao hàng
  - Ghi nhận lịch sử thay đổi trạng thái

#### 3. Xử lý trạng thái thanh toán
- **Mục đích**: Đảm bảo tính nhất quán giữa trạng thái hóa đơn và trạng thái thanh toán
- **Xử lý**:
  - Kiểm tra điều kiện cập nhật:
    + Có thông tin thanh toán (Payments không null)
    + Trạng thái thanh toán hiện tại khác với trạng thái mới
  - Cập nhật trạng thái thanh toán
  - Ghi nhận lịch sử thay đổi trạng thái

#### 4. Xử lý trạng thái đơn hàng
- **Mục đích**: Đảm bảo tính nhất quán giữa trạng thái hóa đơn và trạng thái đơn hàng
- **Xử lý**:
  - Kiểm tra điều kiện cập nhật:
    + Hóa đơn được tạo từ đơn hàng (OrderId > 0)
    + Trạng thái đơn hàng hiện tại khác với trạng thái mới
  - Cập nhật trạng thái đơn hàng
  - Ghi nhận lịch sử thay đổi trạng thái

### Các trạng thái hóa đơn
1. **Chờ xử lý** (Pending)
   - Hóa đơn mới được tạo
   - Chưa được xử lý

2. **Đã phát hành** (Issued)
   - Hóa đơn đã được phát hành
   - Đã có hiệu lực

3. **Đang giao** (Delivering)
   - Hóa đơn đang trong quá trình giao hàng
   - Áp dụng cho hóa đơn có giao hàng

4. **Đã giao** (Delivered)
   - Hóa đơn đã được giao thành công
   - Áp dụng cho hóa đơn có giao hàng

5. **Đang trả** (Returning)
   - Hóa đơn đang trong quá trình trả hàng
   - Áp dụng cho hóa đơn có giao hàng

6. **Đã trả** (Returned)
   - Hóa đơn đã được trả hàng
   - Áp dụng cho hóa đơn có giao hàng

7. **Đã hủy** (Void)
   - Hóa đơn đã bị hủy
   - Không còn hiệu lực

### Xử lý lỗi
- **Các loại lỗi có thể xảy ra**:
  1. Trạng thái không hợp lệ
  2. Xung đột trạng thái
  3. Lỗi khi cập nhật trạng thái giao hàng
  4. Lỗi khi cập nhật trạng thái thanh toán
  5. Lỗi khi cập nhật trạng thái đơn hàng

- **Cách xử lý**:
  - Ném ngoại lệ tương ứng với loại lỗi
  - Cung cấp thông báo lỗi rõ ràng cho người dùng
  - Ghi log lỗi để theo dõi và xử lý sau

### Kết quả
- Nếu tất cả các cập nhật trạng thái đều thành công:
  - Trạng thái hóa đơn đã được cập nhật
  - Các trạng thái liên quan (giao hàng, thanh toán, đơn hàng) đã được đồng bộ
  - Lịch sử thay đổi trạng thái đã được ghi nhận
- Nếu có lỗi:
  - Dừng quá trình cập nhật trạng thái
  - Thông báo lỗi cho người dùng
  - Yêu cầu người dùng sửa lỗi trước khi tiếp tục

## Điều hướng
- Quay lại: [18-1-3-UpdateInvoice.md](../SaveInvoice/18-1-3-UpdateInvoice.md)
- Trước đó: [2-NormalizeInvoiceDetail.md](./2-NormalizeInvoiceDetail.md)
- Tiếp theo: [4-ProcessDeliveryInfo.md](./4-ProcessDeliveryInfo.md) 