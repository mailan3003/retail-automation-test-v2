# Phân tích Business Logic của phương thức UpdateInvoiceAsync

## 18.1.3.9. Xử lý thay đổi ngày mua hàng

### Mục đích
Xử lý các trường hợp đặc biệt khi ngày mua hàng của hóa đơn thay đổi, bao gồm việc cập nhật các thông tin liên quan và xử lý các tác động của việc thay đổi ngày mua hàng.

### Quy trình xử lý

#### 1. Kiểm tra thay đổi ngày mua hàng
- **Mục đích**: Xác định xem ngày mua hàng có thay đổi hay không
- **Xử lý**:
  ```csharp
  if (invoice.PurchaseDate.Date != currentInvoice.PurchaseDate.Date)
  {
      // Xử lý thay đổi ngày mua hàng
  }
  ```
  - So sánh ngày mua hàng mới với ngày mua hàng hiện tại
  - Chỉ xử lý khi có sự thay đổi về ngày

#### 2. Cập nhật thông tin liên quan
- **Mục đích**: Cập nhật các thông tin liên quan đến ngày mua hàng
- **Xử lý**:
  - Cập nhật ngày tạo hóa đơn:
    ```csharp
    invoice.CreatedDate = invoice.PurchaseDate;
    ```
  - Cập nhật ngày bảo hành:
    ```csharp
    foreach (var detail in invoice.InvoiceDetails)
    {
        if (detail.WarrantyExpirationDate.HasValue)
        {
            detail.WarrantyExpirationDate = CalculateWarrantyExpirationDate(
                detail.WarrantyExpirationDate.Value,
                currentInvoice.PurchaseDate,
                invoice.PurchaseDate
            );
        }
    }
    ```
  - Cập nhật ngày thanh toán:
    ```csharp
    foreach (var payment in invoice.Payments)
    {
        payment.PaymentDate = invoice.PurchaseDate;
    }
    ```

#### 3. Xử lý tác động đến kho
- **Mục đích**: Xử lý các tác động đến thông tin kho khi thay đổi ngày mua hàng
- **Xử lý**:
  ```csharp
  if (invoice.Status == (int)InvoiceStatus.Issued)
  {
      await UpdateInventory(invoice, currentInvoice.PurchaseDate, invoice.PurchaseDate);
  }
  ```
  - Kiểm tra trạng thái hóa đơn
  - Cập nhật thông tin kho nếu hóa đơn đã phát hành
  - Điều chỉnh số lượng tồn kho theo ngày mới

#### 4. Xử lý tác động đến báo cáo
- **Mục đích**: Xử lý các tác động đến báo cáo khi thay đổi ngày mua hàng
- **Xử lý**:
  ```csharp
  await UpdateReports(invoice, currentInvoice.PurchaseDate, invoice.PurchaseDate);
  ```
  - Cập nhật báo cáo doanh thu
  - Cập nhật báo cáo tồn kho
  - Cập nhật báo cáo chiết khấu

#### 5. Xử lý tác động đến đơn hàng
- **Mục đích**: Xử lý các tác động đến đơn hàng liên quan
- **Xử lý**:
  ```csharp
  if (invoice.Order != null)
  {
      invoice.Order.PurchaseDate = invoice.PurchaseDate;
      await UpdateOrder(invoice.Order);
  }
  ```
  - Cập nhật ngày mua hàng của đơn hàng
  - Cập nhật các thông tin liên quan của đơn hàng

### Các trường hợp đặc biệt

#### 1. Hóa đơn đã phát hành
- **Điều kiện áp dụng**:
  - Status = Issued
- **Xử lý**:
  - Kiểm tra quyền thay đổi ngày mua hàng
  - Cập nhật thông tin kho
  - Cập nhật báo cáo
  - Cập nhật đơn hàng

#### 2. Hóa đơn có bảo hành
- **Điều kiện áp dụng**:
  - Có ít nhất một chi tiết có thông tin bảo hành
- **Xử lý**:
  - Tính toán lại ngày hết hạn bảo hành
  - Cập nhật thông tin bảo hành
  - Thông báo cho khách hàng nếu cần

#### 3. Hóa đơn có thanh toán
- **Điều kiện áp dụng**:
  - Có ít nhất một khoản thanh toán
- **Xử lý**:
  - Cập nhật ngày thanh toán
  - Cập nhật thông tin thanh toán
  - Cập nhật báo cáo tài chính

### Xử lý lỗi
- **Các loại lỗi có thể xảy ra**:
  1. Không có quyền thay đổi ngày mua hàng
  2. Lỗi khi cập nhật thông tin kho
  3. Lỗi khi cập nhật báo cáo
  4. Lỗi khi cập nhật đơn hàng
  5. Lỗi khi tính toán lại ngày bảo hành

- **Cách xử lý**:
  - Ném ngoại lệ tương ứng với loại lỗi
  - Cung cấp thông báo lỗi rõ ràng cho người dùng
  - Ghi log lỗi để theo dõi và xử lý sau

### Kết quả
- Nếu tất cả các xử lý đều thành công:
  - Ngày mua hàng đã được cập nhật
  - Các thông tin liên quan đã được cập nhật
  - Thông tin kho và báo cáo đã được cập nhật
  - Đơn hàng đã được cập nhật
- Nếu có lỗi:
  - Dừng quá trình cập nhật
  - Thông báo lỗi cho người dùng
  - Yêu cầu người dùng sửa lỗi trước khi tiếp tục

## Điều hướng
- Quay lại: [18-1-3-UpdateInvoice.md](../SaveInvoice/18-1-3-UpdateInvoice.md)
- Trước đó: [8-UpdateInvoiceInfo.md](./8-UpdateInvoiceInfo.md)
- Tiếp theo: [10-ProcessSpecialCases.md](./10-ProcessSpecialCases.md) 