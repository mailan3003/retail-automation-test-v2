# Phân tích Business Logic của phương thức UpdateInvoiceAsync

## 18.1.3.6. Kiểm tra tiền tệ

### Mục đích
Kiểm tra và xác thực thông tin tiền tệ của hóa đơn, đảm bảo tính nhất quán và chính xác của các thông tin liên quan đến tiền tệ trong quá trình cập nhật hóa đơn.

### Quy trình xử lý

#### 1. Kiểm tra loại tiền tệ
- **Mục đích**: Xác thực loại tiền tệ được sử dụng trong hóa đơn
- **Xử lý**:
  ```csharp
  if (invoice.CurrencyId != currentInvoice.CurrencyId)
  {
      throw new BusinessException("Không thể thay đổi loại tiền tệ của hóa đơn");
  }
  ```
  - So sánh loại tiền tệ mới với loại tiền tệ hiện tại
  - Nếu khác nhau, ném ngoại lệ thông báo không thể thay đổi loại tiền tệ

#### 2. Kiểm tra tỷ giá
- **Mục đích**: Xác thực tỷ giá chuyển đổi tiền tệ
- **Xử lý**:
  ```csharp
  if (invoice.ExchangeRate <= 0)
  {
      throw new BusinessException("Tỷ giá chuyển đổi không hợp lệ");
  }
  ```
  - Kiểm tra tỷ giá có lớn hơn 0 không
  - Nếu không hợp lệ, ném ngoại lệ thông báo

#### 3. Kiểm tra số tiền
- **Mục đích**: Xác thực các số tiền trong hóa đơn
- **Xử lý**:
  - Kiểm tra tổng tiền:
    ```csharp
    if (invoice.Total < 0)
    {
        throw new BusinessException("Tổng tiền không hợp lệ");
    }
    ```
  - Kiểm tra tiền chiết khấu:
    ```csharp
    if (invoice.Discount < 0)
    {
        throw new BusinessException("Tiền chiết khấu không hợp lệ");
    }
    ```
  - Kiểm tra tiền thuế:
    ```csharp
    if (invoice.Tax < 0)
    {
        throw new BusinessException("Tiền thuế không hợp lệ");
    }
    ```

#### 4. Kiểm tra tiền tệ chi tiết
- **Mục đích**: Xác thực thông tin tiền tệ của từng chi tiết hóa đơn
- **Xử lý**:
  ```csharp
  foreach (var detail in invoice.InvoiceDetails)
  {
      if (detail.Price < 0)
      {
          throw new BusinessException($"Giá của sản phẩm {detail.ProductName} không hợp lệ");
      }
      if (detail.Total < 0)
      {
          throw new BusinessException($"Thành tiền của sản phẩm {detail.ProductName} không hợp lệ");
      }
  }
  ```
  - Kiểm tra giá và thành tiền của từng chi tiết
  - Nếu không hợp lệ, ném ngoại lệ thông báo

#### 5. Kiểm tra tiền tệ thanh toán
- **Mục đích**: Xác thực thông tin tiền tệ của các khoản thanh toán
- **Xử lý**:
  ```csharp
  foreach (var payment in invoice.Payments)
  {
      if (payment.Amount <= 0)
      {
          throw new BusinessException("Số tiền thanh toán không hợp lệ");
      }
      if (payment.CurrencyId != invoice.CurrencyId)
      {
          throw new BusinessException("Loại tiền tệ thanh toán không khớp với hóa đơn");
      }
  }
  ```
  - Kiểm tra số tiền thanh toán
  - Kiểm tra loại tiền tệ thanh toán có khớp với hóa đơn không

### Các trường hợp đặc biệt

#### 1. Hóa đơn ngoại tệ
- **Điều kiện áp dụng**:
  - CurrencyId khác với tiền tệ mặc định
- **Xử lý**:
  - Kiểm tra tỷ giá chuyển đổi
  - Kiểm tra số tiền quy đổi
  - Đảm bảo tính nhất quán giữa số tiền gốc và số tiền quy đổi

#### 2. Hóa đơn có chiết khấu
- **Điều kiện áp dụng**:
  - Discount > 0
- **Xử lý**:
  - Kiểm tra loại chiết khấu (phần trăm hoặc số tiền)
  - Kiểm tra giá trị chiết khấu không vượt quá tổng tiền
  - Đảm bảo tính nhất quán giữa chiết khấu và tổng tiền

### Xử lý lỗi
- **Các loại lỗi có thể xảy ra**:
  1. Loại tiền tệ không hợp lệ
  2. Tỷ giá chuyển đổi không hợp lệ
  3. Số tiền âm hoặc không hợp lệ
  4. Tiền tệ thanh toán không khớp
  5. Chiết khấu vượt quá tổng tiền

- **Cách xử lý**:
  - Ném ngoại lệ tương ứng với loại lỗi
  - Cung cấp thông báo lỗi rõ ràng cho người dùng
  - Ghi log lỗi để theo dõi và xử lý sau

### Kết quả
- Nếu tất cả các kiểm tra đều thành công:
  - Thông tin tiền tệ đã được xác thực
  - Có thể tiếp tục quá trình cập nhật hóa đơn
- Nếu có lỗi:
  - Dừng quá trình cập nhật
  - Thông báo lỗi cho người dùng
  - Yêu cầu người dùng sửa lỗi trước khi tiếp tục

## Điều hướng
- Quay lại: [18-1-3-UpdateInvoice.md](../SaveInvoice/18-1-3-UpdateInvoice.md)
- Trước đó: [5-ProcessCODReturn.md](./5-ProcessCODReturn.md)
- Tiếp theo: [7-ProcessPayment.md](./7-ProcessPayment.md) 