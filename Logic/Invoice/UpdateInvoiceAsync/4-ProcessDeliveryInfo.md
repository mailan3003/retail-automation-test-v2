# Phân tích Business Logic của phương thức UpdateInvoiceAsync

## 18.1.3.4. Xử lý thông tin giao hàng

### Mục đích
Xử lý và chuẩn hóa thông tin giao hàng của hóa đơn, bao gồm việc chuyển đổi thông tin giao hàng và gán đối tác giao hàng mặc định.

### Quy trình xử lý

#### 1. Chuyển đổi thông tin giao hàng
- **Mục đích**: Chuẩn hóa thông tin giao hàng trước khi cập nhật
- **Xử lý**:
  ```csharp
  var isUpdate = isForceUpdateBranchTakingAddr ? false : true;
  invoice = await ConvertInvoiceDelivery(invoice, isUpdate);
  ```
  - Gọi phương thức `ConvertInvoiceDelivery()` để chuẩn hóa thông tin giao hàng
  - Tham số `isUpdate` xác định có cập nhật địa chỉ chi nhánh nhận hàng hay không

#### 2. Gán đối tác giao hàng mặc định
- **Mục đích**: Thiết lập đối tác giao hàng mặc định cho hóa đơn
- **Xử lý**:
  ```csharp
  invoice = await AssignPartnerDeliveryDefault(invoice);
  ```
  - Gọi phương thức `AssignPartnerDeliveryDefault()` để thiết lập đối tác giao hàng
  - Xử lý logic lựa chọn đối tác giao hàng phù hợp

#### 3. Xử lý thông tin địa chỉ
- **Mục đích**: Chuẩn hóa thông tin địa chỉ giao hàng
- **Xử lý**:
  - Kiểm tra và chuẩn hóa địa chỉ:
    + Tỉnh/Thành phố
    + Quận/Huyện
    + Phường/Xã
    + Địa chỉ chi tiết
  - Đảm bảo tính đầy đủ và chính xác của thông tin địa chỉ

#### 4. Xử lý thông tin đối tác vận chuyển
- **Mục đích**: Quản lý thông tin đối tác vận chuyển
- **Xử lý**:
  - Kiểm tra điều kiện sử dụng đối tác vận chuyển:
    + Đối tác phải đang hoạt động
    + Đối tác phải hỗ trợ nhà bán hàng hiện tại
    + Thiết lập của nhà bán hàng phải cho phép sử dụng đối tác
  - Cập nhật thông tin đối tác vận chuyển:
    + Mã đối tác
    + Tên đối tác
    + Thông tin liên hệ
    + Các dịch vụ hỗ trợ

#### 5. Xử lý thông tin phí vận chuyển
- **Mục đích**: Quản lý thông tin phí vận chuyển
- **Xử lý**:
  - Kiểm tra và chuẩn hóa thông tin phí vận chuyển:
    + Phí cơ bản
    + Phí phát sinh
    + Phí COD (nếu có)
  - Xác định bên trả phí vận chuyển
  - Tính toán tổng phí vận chuyển

### Các trường hợp đặc biệt

#### 1. Hóa đơn COD
- **Điều kiện áp dụng**:
  - Hóa đơn sử dụng COD (UsingCod = 1)
  - Có thông tin giao hàng (DeliveryDetail không null)
- **Xử lý**:
  - Kiểm tra tính hợp lệ của đối tác vận chuyển cho COD
  - Đảm bảo thông tin thanh toán COD đầy đủ
  - Xử lý các trường hợp đặc biệt về phí COD

#### 2. Hóa đơn tự giao hàng
- **Điều kiện áp dụng**:
  - Không sử dụng đối tác vận chuyển (UseDefaultPartner = false)
  - Có thông tin giao hàng (DeliveryDetail không null)
- **Xử lý**:
  - Xóa thông tin đối tác vận chuyển
  - Cập nhật trạng thái giao hàng
  - Xử lý thông tin người giao hàng

### Xử lý lỗi
- **Các loại lỗi có thể xảy ra**:
  1. Thông tin địa chỉ không hợp lệ
  2. Đối tác vận chuyển không hợp lệ
  3. Thông tin phí vận chuyển không chính xác
  4. Xung đột thông tin giao hàng

- **Cách xử lý**:
  - Ném ngoại lệ tương ứng với loại lỗi
  - Cung cấp thông báo lỗi rõ ràng cho người dùng
  - Ghi log lỗi để theo dõi và xử lý sau

### Kết quả
- Nếu tất cả các xử lý đều thành công:
  - Thông tin giao hàng đã được chuẩn hóa
  - Đối tác giao hàng đã được thiết lập
  - Thông tin địa chỉ và phí vận chuyển đã được cập nhật
- Nếu có lỗi:
  - Dừng quá trình xử lý thông tin giao hàng
  - Thông báo lỗi cho người dùng
  - Yêu cầu người dùng sửa lỗi trước khi tiếp tục

## Điều hướng
- Quay lại: [18-1-3-UpdateInvoice.md](../SaveInvoice/18-1-3-UpdateInvoice.md)
- Trước đó: [3-UpdateInvoiceStatus.md](./3-UpdateInvoiceStatus.md)
- Tiếp theo: [5-ProcessCODReturn.md](./5-ProcessCODReturn.md) 