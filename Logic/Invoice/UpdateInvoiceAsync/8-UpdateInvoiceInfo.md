# Phân tích Business Logic của phương thức UpdateInvoiceAsync

## 18.1.3.8. Cập nhật thông tin hóa đơn

### Mục đích
Cập nhật các thông tin cơ bản của hóa đơn, bao gồm thông tin bảo hành, tổng tiền và các thông tin khác liên quan đến hóa đơn.

### Quy trình xử lý

#### 1. Cập nhật thông tin bảo hành
- **Mục đích**: Cập nhật thông tin bảo hành cho các sản phẩm trong hóa đơn
- **Xử lý**:
  ```csharp
  foreach (var detail in invoice.InvoiceDetails)
  {
      if (detail.WarrantyExpirationDate.HasValue)
      {
          detail.WarrantyExpirationDate = detail.WarrantyExpirationDate.Value.Date;
      }
  }
  ```
  - Kiểm tra và cập nhật ngày hết hạn bảo hành cho từng chi tiết
  - Đảm bảo ngày hết hạn bảo hành được lưu dưới dạng ngày (không có giờ)

#### 2. Cập nhật tổng tiền
- **Mục đích**: Tính toán và cập nhật các thông tin tổng tiền của hóa đơn
- **Xử lý**:
  ```csharp
  invoice.SubTotal = invoice.InvoiceDetails.Sum(d => d.Total);
  invoice.Total = invoice.SubTotal - invoice.Discount + invoice.Tax;
  ```
  - Tính tổng tiền trước chiết khấu (SubTotal)
  - Tính tổng tiền sau chiết khấu và thuế (Total)

#### 3. Cập nhật thông tin khách hàng
- **Mục đích**: Cập nhật thông tin khách hàng liên quan đến hóa đơn
- **Xử lý**:
  ```csharp
  if (invoice.Customer != null)
  {
      invoice.CustomerId = invoice.Customer.Id;
      invoice.CustomerName = invoice.Customer.Name;
      invoice.CustomerCode = invoice.Customer.Code;
  }
  ```
  - Cập nhật ID khách hàng
  - Cập nhật tên khách hàng
  - Cập nhật mã khách hàng

#### 4. Cập nhật thông tin chi nhánh
- **Mục đích**: Cập nhật thông tin chi nhánh liên quan đến hóa đơn
- **Xử lý**:
  ```csharp
  if (invoice.Branch != null)
  {
      invoice.BranchId = invoice.Branch.Id;
      invoice.BranchName = invoice.Branch.Name;
  }
  ```
  - Cập nhật ID chi nhánh
  - Cập nhật tên chi nhánh

#### 5. Cập nhật thông tin người tạo
- **Mục đích**: Cập nhật thông tin người tạo và ngày tạo hóa đơn
- **Xử lý**:
  ```csharp
  invoice.CreatedBy = _currentUser.UserName;
  invoice.CreatedDate = DateTime.Now;
  ```
  - Cập nhật tên người tạo
  - Cập nhật ngày tạo

### Các trường hợp đặc biệt

#### 1. Hóa đơn có sản phẩm bảo hành
- **Điều kiện áp dụng**:
  - Có ít nhất một chi tiết có thông tin bảo hành
- **Xử lý**:
  - Kiểm tra tính hợp lệ của ngày bảo hành
  - Cập nhật thông tin bảo hành cho từng sản phẩm
  - Đảm bảo tính nhất quán của thông tin bảo hành

#### 2. Hóa đơn có chiết khấu
- **Điều kiện áp dụng**:
  - Discount > 0
- **Xử lý**:
  - Kiểm tra loại chiết khấu
  - Tính toán giá trị chiết khấu
  - Cập nhật tổng tiền sau chiết khấu

#### 3. Hóa đơn có thuế
- **Điều kiện áp dụng**:
  - Tax > 0
- **Xử lý**:
  - Kiểm tra loại thuế
  - Tính toán giá trị thuế
  - Cập nhật tổng tiền sau thuế

### Xử lý lỗi
- **Các loại lỗi có thể xảy ra**:
  1. Thông tin bảo hành không hợp lệ
  2. Tổng tiền tính toán không chính xác
  3. Thông tin khách hàng không hợp lệ
  4. Thông tin chi nhánh không hợp lệ
  5. Lỗi khi cập nhật thông tin người tạo

- **Cách xử lý**:
  - Ném ngoại lệ tương ứng với loại lỗi
  - Cung cấp thông báo lỗi rõ ràng cho người dùng
  - Ghi log lỗi để theo dõi và xử lý sau

### Kết quả
- Nếu tất cả các cập nhật đều thành công:
  - Thông tin bảo hành đã được cập nhật
  - Tổng tiền đã được tính toán và cập nhật
  - Thông tin khách hàng và chi nhánh đã được cập nhật
  - Thông tin người tạo đã được cập nhật
- Nếu có lỗi:
  - Dừng quá trình cập nhật
  - Thông báo lỗi cho người dùng
  - Yêu cầu người dùng sửa lỗi trước khi tiếp tục

## Điều hướng
- Quay lại: [18-1-3-UpdateInvoice.md](../SaveInvoice/18-1-3-UpdateInvoice.md)
- Trước đó: [7-ProcessPayment.md](./7-ProcessPayment.md)
- Tiếp theo: [9-ProcessPurchaseDate.md](./9-ProcessPurchaseDate.md) 