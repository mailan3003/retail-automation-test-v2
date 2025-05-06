# Phân tích Business Logic của phương thức UpdateInvoiceAsync

## 18.1.3.5. Xử lý hóa đơn COD trả về

### Mục đích
Xử lý các trường hợp đặc biệt khi hóa đơn COD được trả về, bao gồm việc sử dụng Redis lock để đảm bảo tính nhất quán của dữ liệu và xử lý các thông tin liên quan đến việc trả hàng.

### Quy trình xử lý

#### 1. Kiểm tra điều kiện xử lý
- **Mục đích**: Xác định xem hóa đơn có cần được xử lý như hóa đơn COD trả về hay không
- **Xử lý**:
  ```csharp
  if (invoice.UsingCod == 1 && invoice.Status == (int)InvoiceStatus.Returning)
  {
      // Xử lý hóa đơn COD trả về
  }
  ```
  - Kiểm tra hóa đơn có sử dụng COD không (UsingCod = 1)
  - Kiểm tra trạng thái hóa đơn có phải đang trả về không (Status = Returning)

#### 2. Sử dụng Redis Lock
- **Mục đích**: Đảm bảo tính nhất quán của dữ liệu khi xử lý hóa đơn COD trả về
- **Xử lý**:
  ```csharp
  var lockKey = $"Invoice:COD:Return:{invoice.Id}";
  using (var lock = await _redisLockService.LockAsync(lockKey))
  {
      if (lock == null)
      {
          throw new BusinessException("Hóa đơn đang được xử lý bởi người dùng khác");
      }
      // Xử lý hóa đơn COD trả về
  }
  ```
  - Tạo khóa lock dựa trên ID của hóa đơn
  - Sử dụng Redis Lock để đảm bảo chỉ một người dùng có thể xử lý hóa đơn tại một thời điểm
  - Nếu không lấy được lock, ném ngoại lệ thông báo

#### 3. Cập nhật thông tin trả hàng
- **Mục đích**: Cập nhật các thông tin liên quan đến việc trả hàng
- **Xử lý**:
  - Cập nhật ngày trả hàng:
    ```csharp
    invoice.DeliveryReturnedDate = deliveryReturnedDate ?? DateTime.Now;
    ```
  - Cập nhật trạng thái giao hàng:
    ```csharp
    invoice.DeliveryDetail.Status = (int)DeliveryStatus.Returned;
    ```
  - Cập nhật thông tin người nhận trả hàng:
    ```csharp
    invoice.DeliveryDetail.ReceiverName = invoice.DeliveryDetail.SenderName;
    invoice.DeliveryDetail.ReceiverPhone = invoice.DeliveryDetail.SenderPhone;
    ```

#### 4. Xử lý thông tin thanh toán
- **Mục đích**: Cập nhật thông tin thanh toán liên quan đến việc trả hàng
- **Xử lý**:
  - Cập nhật trạng thái thanh toán:
    ```csharp
    invoice.PaymentStatus = (int)PaymentStatus.Refunded;
    ```
  - Cập nhật thông tin hoàn tiền:
    ```csharp
    invoice.RefundAmount = invoice.Total;
    invoice.RefundDate = DateTime.Now;
    ```

#### 5. Cập nhật thông tin đơn hàng
- **Mục đích**: Cập nhật thông tin đơn hàng liên quan
- **Xử lý**:
  - Cập nhật trạng thái đơn hàng:
    ```csharp
    if (invoice.Order != null)
    {
        invoice.Order.Status = (int)OrderStatus.Returned;
    }
    ```
  - Cập nhật thông tin vận chuyển của đơn hàng:
    ```csharp
    if (invoice.Order?.DeliveryDetail != null)
    {
        invoice.Order.DeliveryDetail.Status = (int)DeliveryStatus.Returned;
    }
    ```

### Các trường hợp đặc biệt

#### 1. Hóa đơn đã được xử lý
- **Điều kiện áp dụng**:
  - Hóa đơn đã có ngày trả hàng
  - Hóa đơn đã có trạng thái trả về
- **Xử lý**:
  - Kiểm tra và bỏ qua các bước xử lý không cần thiết
  - Chỉ cập nhật các thông tin mới nếu có

#### 2. Hóa đơn không có thông tin giao hàng
- **Điều kiện áp dụng**:
  - DeliveryDetail là null
- **Xử lý**:
  - Tạo mới thông tin giao hàng
  - Cập nhật các thông tin cơ bản
  - Thiết lập trạng thái trả về

### Xử lý lỗi
- **Các loại lỗi có thể xảy ra**:
  1. Không lấy được Redis lock
  2. Thông tin trả hàng không hợp lệ
  3. Lỗi khi cập nhật thông tin thanh toán
  4. Lỗi khi cập nhật thông tin đơn hàng

- **Cách xử lý**:
  - Ném ngoại lệ tương ứng với loại lỗi
  - Cung cấp thông báo lỗi rõ ràng cho người dùng
  - Ghi log lỗi để theo dõi và xử lý sau

### Kết quả
- Nếu tất cả các xử lý đều thành công:
  - Thông tin trả hàng đã được cập nhật
  - Thông tin thanh toán đã được cập nhật
  - Thông tin đơn hàng đã được cập nhật
  - Redis lock đã được giải phóng
- Nếu có lỗi:
  - Dừng quá trình xử lý
  - Thông báo lỗi cho người dùng
  - Redis lock vẫn được giải phóng thông qua using statement

## Điều hướng
- Quay lại: [18-1-3-UpdateInvoice.md](../18-1-3-UpdateInvoice.md)
- Trước đó: [18-1-3-4-ProcessDeliveryInfo.md](./18-1-3-4-ProcessDeliveryInfo.md)
- Tiếp theo: [18-1-3-6-ValidateCurrency.md](./18-1-3-6-ValidateCurrency.md) 