# Phân tích Business Logic của phương thức MakeInvoiceAsync

## Các bước xử lý chính

### 19.12. Theo dõi sự kiện

- **Mục đích**: Ghi nhận và theo dõi các sự kiện liên quan đến quá trình tạo và cập nhật hóa đơn, hỗ trợ cho việc giám sát, gỡ lỗi và báo cáo

- **Điều kiện áp dụng**:
  - Áp dụng trong toàn bộ quy trình tạo và cập nhật hóa đơn
  - Đặc biệt quan trọng để theo dõi các hành động quan trọng và thay đổi trạng thái

- **Quy trình xử lý chi tiết**:
  1. **Ghi nhận nhật ký hoạt động**:
     - Sử dụng `TrackingHelper` để ghi lại các hoạt động chính:
       ```csharp
       using (var bltHelper = new TrackingHelper(AuthService.Context))
       {
           // Các hoạt động được ghi nhận trong quá trình thực hiện
           bltHelper.Track("Invoice", "Create", result.Id);
       }
       ```
     - Các thông tin được ghi nhận bao gồm:
       + Loại đối tượng (hóa đơn, thanh toán, giao hàng...)
       + Loại hành động (tạo mới, cập nhật, xóa...)
       + ID của đối tượng
       + Người thực hiện hành động
       + Thời gian thực hiện

  2. **Ghi nhận lịch sử thay đổi**:
     - Theo dõi các thay đổi quan trọng của hóa đơn:
       ```csharp
       var changes = new List<AuditLogTrack>();
       changes.Add(new AuditLogTrack
       {
           EntityId = result.Id,
           EntityName = "Invoice",
           FieldName = "Status",
           OldValue = oldStatus.ToString(),
           NewValue = result.Status.ToString()
       });
       await AuditTrailService.AddRangeAsync(changes);
       ```
     - Các thay đổi được theo dõi bao gồm:
       + Thay đổi trạng thái hóa đơn
       + Thay đổi thông tin thanh toán
       + Thay đổi thông tin giao hàng
       + Thay đổi thông tin khách hàng

  3. **Gửi thông báo sự kiện**:
     - Phát thông báo cho các hệ thống khác:
       ```csharp
       await EventMessageService.PublishAsync(new InvoiceEvent
       {
           InvoiceId = result.Id,
           Action = "Created",
           RetailerId = AuthService.Context.RetailerId
       });
       ```
     - Các loại sự kiện được gửi đi bao gồm:
       + Tạo mới hóa đơn
       + Cập nhật hóa đơn
       + Hoàn thành hóa đơn
       + Hủy hóa đơn
       + Các thay đổi trạng thái thanh toán

  4. **Ghi nhận dữ liệu theo dõi chi tiết**:
     - Đối với các hoạt động quan trọng, ghi nhận dữ liệu chi tiết:
       ```csharp
       await InventoryTrackingService.AddAsync(new InventoryTracking
       {
           InvoiceId = result.Id,
           ProductId = productId,
           Quantity = quantity,
           OldOnHand = oldOnHand,
           NewOnHand = newOnHand,
           Action = "Sold"
       });
       ```
     - Các loại dữ liệu theo dõi bao gồm:
       + Theo dõi hàng tồn kho
       + Theo dõi điểm tích lũy
       + Theo dõi công nợ
       + Theo dõi sử dụng voucher/coupon

  5. **Xử lý tác vụ đồng bộ hóa**:
     - Thực hiện các tác vụ đồng bộ hóa hệ thống:
       ```csharp
       await SyncDataService.SyncInvoiceData(result.Id);
       ```
     - Đảm bảo dữ liệu được đồng bộ giữa các hệ thống liên quan

  6. **Cập nhật dữ liệu tìm kiếm**:
     - Cập nhật dữ liệu cho hệ thống tìm kiếm:
       ```csharp
       SendToEsEventUpdate("create", new[] { result.Id });
       ```
     - Giúp dữ liệu hóa đơn mới có thể được tìm kiếm ngay lập tức

- **Xử lý đặc biệt**:
  - **Ghi nhận lỗi và ngoại lệ**:
    ```csharp
    try
    {
        // Xử lý nghiệp vụ
    }
    catch (Exception ex)
    {
        // Ghi nhận lỗi
        await LogExceptionService.LogAsync(ex, "MakeInvoiceAsync", result.Id);
        throw;
    }
    ```
    - Ghi nhận đầy đủ thông tin lỗi để hỗ trợ việc gỡ lỗi
    - Đảm bảo các lỗi được xử lý một cách nhất quán

  - **Theo dõi hiệu suất**:
    - Đo lường thời gian thực hiện các bước xử lý quan trọng:
      ```csharp
      var stopwatch = Stopwatch.StartNew();
      // Xử lý nghiệp vụ
      stopwatch.Stop();
      await PerformanceTracking.LogAsync("MakeInvoice", stopwatch.ElapsedMilliseconds);
      ```
    - Giúp theo dõi và tối ưu hiệu suất của hệ thống

  - **Ghi nhận hoạt động người dùng**:
    - Theo dõi các hành động của người dùng:
      ```csharp
      await UserActivityService.LogAsync(new UserActivity
      {
          UserId = AuthService.Context.UserId,
          Action = "CreateInvoice",
          EntityId = result.Id,
          Timestamp = DateTime.UtcNow
      });
      ```
    - Hỗ trợ việc kiểm tra và đảm bảo an ninh hệ thống

- **Ý nghĩa nghiệp vụ**:
  - Tạo khả năng theo dõi toàn diện các hoạt động trong hệ thống
  - Hỗ trợ việc gỡ lỗi và xử lý sự cố
  - Cung cấp dữ liệu cho báo cáo và phân tích
  - Đảm bảo tính minh bạch và trách nhiệm trong hoạt động kinh doanh
  - Hỗ trợ tuân thủ các quy định về kiểm toán và quản lý dữ liệu

- **Lưu ý đặc biệt**:
  - Hệ thống theo dõi sự kiện cần được thiết kế để không ảnh hưởng đến hiệu suất
  - Cần lưu trữ dữ liệu theo dõi một cách hiệu quả để tránh quá tải hệ thống
  - Thông tin nhạy cảm cần được xử lý phù hợp trong quá trình ghi nhận
  - Đảm bảo khả năng phục hồi dữ liệu từ các sự kiện đã ghi nhận

---
**Điều hướng**
- [Quay lại trang chủ](./MakeInvoice-Index.md)
- [Bước trước: Phân bổ thanh toán](./11-MakeInvoice-PaymentAllocation.md)
- Tiếp theo: [19-13-MakeInvoice-ExternalSync.md](./19-13-MakeInvoice-ExternalSync.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 