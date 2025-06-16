# Phân tích Business Logic của phương thức UpdateInvoiceAsync

## 18.1.3.2. Chuẩn hóa chi tiết hóa đơn

### Mục đích
Chuẩn hóa thông tin chi tiết hóa đơn, đảm bảo tính duy nhất của UUID và tính nhất quán của dữ liệu trước khi cập nhật vào hệ thống.

### Quy trình xử lý

#### 1. Kiểm tra danh sách chi tiết hóa đơn
- **Điều kiện kiểm tra**:
  - Danh sách chi tiết hóa đơn không được null
  - Danh sách phải có ít nhất một phần tử

- **Xử lý**:
  ```csharp
  if (invoice.InvoiceDetails == null || !invoice.InvoiceDetails.Any())
      return;
  ```
  - Nếu không có chi tiết hóa đơn, kết thúc quá trình chuẩn hóa

#### 2. Xử lý trùng lặp UUID
- **Mục đích**: Đảm bảo tính duy nhất của UUID trong chi tiết hóa đơn
- **Xử lý**:
  ```csharp
  var existingUuids = new HashSet<string>();
  foreach (var detail in invoice.InvoiceDetails)
  {
      if (string.IsNullOrEmpty(detail.Uuid))
          continue;

      while (existingUuids.Contains(detail.Uuid))
      {
          detail.Uuid += "U";
      }
      existingUuids.Add(detail.Uuid);
  }
  ```
  - Tạo HashSet để lưu trữ và kiểm tra các UUID đã xuất hiện
  - Duyệt qua từng dòng chi tiết hóa đơn:
    + Bỏ qua những dòng không có UUID
    + Kiểm tra nếu UUID đã tồn tại trong danh sách
    + Nếu trùng lặp, thêm chữ "U" vào cuối UUID cho đến khi tạo được UUID duy nhất
    + Lưu UUID vào danh sách để tránh trùng lặp trong các dòng tiếp theo

#### 3. Chuẩn hóa thông tin sản phẩm
- **Mục đích**: Đảm bảo tính nhất quán của thông tin sản phẩm
- **Xử lý**:
  - Kiểm tra và chuẩn hóa mã sản phẩm
  - Đảm bảo tên sản phẩm không chứa ký tự đặc biệt
  - Chuẩn hóa đơn vị tính
  - Kiểm tra tính hợp lệ của số lượng và đơn giá

#### 4. Chuẩn hóa thông tin khuyến mãi
- **Mục đích**: Đảm bảo tính chính xác của thông tin khuyến mãi
- **Xử lý**:
  - Kiểm tra và chuẩn hóa mã khuyến mãi
  - Tính toán lại giá trị khuyến mãi
  - Đảm bảo tính nhất quán giữa các loại khuyến mãi

#### 5. Chuẩn hóa thông tin thuế
- **Mục đích**: Đảm bảo tính chính xác của thông tin thuế
- **Xử lý**:
  - Kiểm tra và chuẩn hóa mã thuế
  - Tính toán lại giá trị thuế
  - Đảm bảo tính nhất quán giữa các loại thuế

### Xử lý lỗi
- **Các loại lỗi có thể xảy ra**:
  1. UUID không hợp lệ
  2. Thông tin sản phẩm không đầy đủ
  3. Thông tin khuyến mãi không hợp lệ
  4. Thông tin thuế không chính xác

- **Cách xử lý**:
  - Ném ngoại lệ tương ứng với loại lỗi
  - Cung cấp thông báo lỗi rõ ràng cho người dùng
  - Ghi log lỗi để theo dõi và xử lý sau

### Kết quả
- Nếu tất cả các chuẩn hóa đều thành công:
  - Danh sách chi tiết hóa đơn đã được chuẩn hóa
  - Tất cả UUID đều là duy nhất
  - Thông tin sản phẩm, khuyến mãi và thuế đã được chuẩn hóa
- Nếu có lỗi:
  - Dừng quá trình chuẩn hóa
  - Thông báo lỗi cho người dùng
  - Yêu cầu người dùng sửa lỗi trước khi tiếp tục

## Điều hướng
- Quay lại: [18-1-3-UpdateInvoice.md](../SaveInvoice/18-1-3-UpdateInvoice.md)
- Trước đó: [1-ValidateInvoice.md](./1-ValidateInvoice.md)
- Tiếp theo: [3-UpdateInvoiceStatus.md](./3-UpdateInvoiceStatus.md) 