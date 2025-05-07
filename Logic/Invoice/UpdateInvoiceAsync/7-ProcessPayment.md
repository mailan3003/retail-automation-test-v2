# Phân tích Business Logic của phương thức UpdateInvoiceAsync

## 18.1.3.7. Xử lý thanh toán

### Mục đích
Xử lý và cập nhật thông tin thanh toán của hóa đơn, bao gồm việc kiểm tra, cập nhật và xử lý các khoản thanh toán liên quan đến hóa đơn.

### Quy trình xử lý

#### 1. Kiểm tra điều kiện cập nhật thanh toán
- **Mục đích**: Xác định xem có cần cập nhật thông tin thanh toán hay không
- **Xử lý**:
  ```csharp
  if (isUpdatePayment)
  {
      // Xử lý cập nhật thanh toán
  }
  ```
  - Kiểm tra tham số `isUpdatePayment`
  - Nếu `true`, tiến hành cập nhật thông tin thanh toán

#### 2. Xử lý hủy thanh toán COD
- **Mục đích**: Xử lý việc hủy thanh toán COD nếu cần
- **Xử lý**:
  ```csharp
  if (isVoidDeliveryPayment)
  {
      await VoidDeliveryPayment(invoice);
  }
  ```
  - Kiểm tra tham số `isVoidDeliveryPayment`
  - Nếu `true`, gọi phương thức `VoidDeliveryPayment()` để hủy thanh toán COD

#### 3. Kiểm tra thông tin thanh toán
- **Mục đích**: Xác thực thông tin thanh toán trước khi cập nhật
- **Xử lý**:
  ```csharp
  if (invoice.Payments != null && invoice.Payments.Any())
  {
      foreach (var payment in invoice.Payments)
      {
          if (payment.Amount <= 0)
          {
              throw new BusinessException("Số tiền thanh toán không hợp lệ");
          }
          if (payment.PaymentMethodId <= 0)
          {
              throw new BusinessException("Phương thức thanh toán không hợp lệ");
          }
      }
  }
  ```
  - Kiểm tra danh sách thanh toán
  - Kiểm tra số tiền và phương thức thanh toán
  - Ném ngoại lệ nếu thông tin không hợp lệ

#### 4. Cập nhật thông tin thanh toán
- **Mục đích**: Cập nhật các thông tin thanh toán của hóa đơn
- **Xử lý**:
  - Cập nhật tổng tiền thanh toán:
    ```csharp
    invoice.Paid = invoice.Payments.Sum(p => p.Amount);
    ```
  - Cập nhật trạng thái thanh toán:
    ```csharp
    invoice.PaymentStatus = invoice.Paid >= invoice.Total 
        ? (int)PaymentStatus.Paid 
        : (int)PaymentStatus.PartiallyPaid;
    ```
  - Cập nhật thông tin thanh toán COD:
    ```csharp
    if (invoice.UsingCod == 1)
    {
        invoice.CodAmount = invoice.Total;
    }
    ```

#### 5. Xử lý thanh toán tự động
- **Mục đích**: Xử lý các khoản thanh toán tự động
- **Xử lý**:
  ```csharp
  if (invoice.AutoPayment)
  {
      await ProcessAutoPayment(invoice);
  }
  ```
  - Kiểm tra có thanh toán tự động không
  - Nếu có, gọi phương thức `ProcessAutoPayment()` để xử lý

### Các trường hợp đặc biệt

#### 1. Hóa đơn COD
- **Điều kiện áp dụng**:
  - UsingCod = 1
- **Xử lý**:
  - Kiểm tra thông tin thanh toán COD
  - Cập nhật trạng thái thanh toán COD
  - Xử lý các trường hợp đặc biệt về thanh toán COD

#### 2. Hóa đơn trả về
- **Điều kiện áp dụng**:
  - Status = Returning hoặc Returned
- **Xử lý**:
  - Cập nhật trạng thái thanh toán thành Refunded
  - Xử lý hoàn tiền nếu cần
  - Cập nhật thông tin thanh toán COD nếu có

#### 3. Hóa đơn hủy
- **Điều kiện áp dụng**:
  - Status = Void
- **Xử lý**:
  - Hủy tất cả các khoản thanh toán
  - Cập nhật trạng thái thanh toán thành Void
  - Xử lý hoàn tiền nếu cần

### Xử lý lỗi
- **Các loại lỗi có thể xảy ra**:
  1. Số tiền thanh toán không hợp lệ
  2. Phương thức thanh toán không hợp lệ
  3. Lỗi khi xử lý thanh toán tự động
  4. Lỗi khi hủy thanh toán COD
  5. Lỗi khi xử lý hoàn tiền

- **Cách xử lý**:
  - Ném ngoại lệ tương ứng với loại lỗi
  - Cung cấp thông báo lỗi rõ ràng cho người dùng
  - Ghi log lỗi để theo dõi và xử lý sau

### Kết quả
- Nếu tất cả các xử lý đều thành công:
  - Thông tin thanh toán đã được cập nhật
  - Trạng thái thanh toán đã được cập nhật
  - Các khoản thanh toán đã được xử lý
- Nếu có lỗi:
  - Dừng quá trình cập nhật thanh toán
  - Thông báo lỗi cho người dùng
  - Yêu cầu người dùng sửa lỗi trước khi tiếp tục

## Điều hướng
- Quay lại: [18-1-3-UpdateInvoice.md](../SaveInvoice/18-1-3-UpdateInvoice.md)
- Trước đó: [6-ValidateCurrency.md](./6-ValidateCurrency.md)
- Tiếp theo: [8-UpdateInvoiceInfo.md](./8-UpdateInvoiceInfo.md) 