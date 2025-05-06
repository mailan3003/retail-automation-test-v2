# Phân tích Business Logic của phương thức UpdateInvoiceAsync

## 18.1.3.10. Xử lý các trường hợp đặc biệt và bổ sung

### Mục đích
Xử lý các trường hợp đặc biệt của hóa đơn và các thông tin bổ sung cần được cập nhật, bao gồm xử lý hóa đơn OmniChannel, cập nhật PaymentTrack và gửi sự kiện đến Elasticsearch.

### Quy trình xử lý

#### 1. Xử lý hóa đơn OmniChannel
- **Mục đích**: Xử lý các trường hợp đặc biệt cho hóa đơn từ các sàn thương mại điện tử
- **Xử lý**:
  ```csharp
  if (PosOnlineHelper.IsInvoiceOmni(invoice))
  {
      // Xử lý khi tổng tiền thay đổi
      if (invoice.Total != currentInvoice.Total)
      {
          await ProcessOmniChannelTotalChange(invoice, currentInvoice);
      }
      
      // Xử lý thông tin đơn hàng
      if (invoice.Order != null)
      {
          await UpdateOmniChannelOrder(invoice.Order);
      }
  }
  ```
  - Kiểm tra nguồn gốc hóa đơn
  - Xử lý thay đổi tổng tiền
  - Cập nhật thông tin đơn hàng

#### 2. Cập nhật PaymentTrack
- **Mục đích**: Ghi nhận lịch sử thay đổi thông tin thanh toán
- **Xử lý**:
  ```csharp
  var paymentTrack = new PaymentTrack
  {
      InvoiceId = invoice.Id,
      OldAmount = currentInvoice.Total,
      NewAmount = invoice.Total,
      OldStatus = currentInvoice.PaymentStatus,
      NewStatus = invoice.PaymentStatus,
      ChangedBy = _currentUser.UserName,
      ChangedDate = DateTime.Now
  };
  await _paymentTrackRepository.AddAsync(paymentTrack);
  ```
  - Tạo bản ghi PaymentTrack mới
  - Ghi nhận các thay đổi về số tiền và trạng thái
  - Lưu thông tin người thay đổi và thời gian

#### 3. Gửi sự kiện đến Elasticsearch
- **Mục đích**: Cập nhật thông tin hóa đơn trong Elasticsearch
- **Xử lý**:
  ```csharp
  var invoiceEvent = new InvoiceEvent
  {
      EventType = "Update",
      InvoiceId = invoice.Id,
      Data = new
      {
          invoice.Total,
          invoice.Status,
          invoice.PaymentStatus,
          invoice.DeliveryStatus,
          invoice.UpdatedDate
      }
  };
  await _eventBus.PublishAsync(invoiceEvent);
  ```
  - Tạo sự kiện cập nhật hóa đơn
  - Đóng gói thông tin cần cập nhật
  - Gửi sự kiện qua EventBus

### Các trường hợp đặc biệt

#### 1. Hóa đơn Shopee
- **Điều kiện áp dụng**:
  - Mã hóa đơn bắt đầu bằng "DHSPE"
- **Xử lý**:
  - Cập nhật thông tin đơn hàng trên Shopee
  - Xử lý các trường hợp đặc biệt của Shopee
  - Đồng bộ trạng thái thanh toán

#### 2. Hóa đơn Tiki
- **Điều kiện áp dụng**:
  - Mã hóa đơn bắt đầu bằng "DHTTS"
- **Xử lý**:
  - Cập nhật thông tin đơn hàng trên Tiki
  - Xử lý các trường hợp đặc biệt của Tiki
  - Đồng bộ trạng thái vận chuyển

#### 3. Hóa đơn Lazada
- **Điều kiện áp dụng**:
  - Mã hóa đơn bắt đầu bằng "DHLZD"
- **Xử lý**:
  - Cập nhật thông tin đơn hàng trên Lazada
  - Xử lý các trường hợp đặc biệt của Lazada
  - Đồng bộ thông tin thanh toán

### Xử lý lỗi
- **Các loại lỗi có thể xảy ra**:
  1. Lỗi khi xử lý hóa đơn OmniChannel
  2. Lỗi khi cập nhật PaymentTrack
  3. Lỗi khi gửi sự kiện đến Elasticsearch
  4. Lỗi khi đồng bộ với các sàn thương mại điện tử

- **Cách xử lý**:
  - Ném ngoại lệ tương ứng với loại lỗi
  - Cung cấp thông báo lỗi rõ ràng cho người dùng
  - Ghi log lỗi để theo dõi và xử lý sau
  - Thực hiện rollback nếu cần thiết

### Kết quả
- Nếu tất cả các xử lý đều thành công:
  - Hóa đơn OmniChannel đã được xử lý
  - PaymentTrack đã được cập nhật
  - Sự kiện đã được gửi đến Elasticsearch
- Nếu có lỗi:
  - Dừng quá trình xử lý
  - Thông báo lỗi cho người dùng
  - Yêu cầu người dùng sửa lỗi trước khi tiếp tục

## Điều hướng
- Quay lại: [18-1-3-UpdateInvoice.md](../SaveInvoice/18-1-3-UpdateInvoice.md)
- Trước đó: [9-ProcessPurchaseDate.md](./9-ProcessPurchaseDate.md) 