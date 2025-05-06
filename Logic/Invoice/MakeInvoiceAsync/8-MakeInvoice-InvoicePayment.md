# Phân tích Business Logic của phương thức MakeInvoiceAsync

## Các bước xử lý chính

### 19.8. Tạo hóa đơn và xử lý thanh toán

- **Mục đích**: Thực hiện các bước chính của quá trình tạo hóa đơn, thiết lập trạng thái và xử lý thông tin thanh toán

- **Quy trình xử lý chi tiết**:
  1. **Thiết lập trạng thái hóa đơn**:
     - Đảm bảo hóa đơn có trạng thái hợp lệ (InvoiceState.Issued nếu chưa được thiết lập):
       ```csharp
       invoice.Status = (byte)(invoice.Status > 0 ? invoice.Status : (int)InvoiceState.Issued);
       ```
     - Quy định trạng thái mặc định cho hóa đơn mới là "Đã phát hành" (Issued)

  2. **Chuẩn bị thông tin thanh toán**:
     - Trích xuất các thanh toán từ hóa đơn:
       ```csharp
       IEnumerable<Payment> payments = null;
       if (invoice.Payments != null && invoice.Payments.Any())
       {
           // Chỉ lấy các thanh toán mới (chưa có ID)
           payments = invoice.Payments.Where(p => p.Id <= 0);
       }
       ```
     - Sao chép mô tả hóa đơn vào các thanh toán:
       ```csharp
       if (invoice.Description != null)
       {
           var tmp = invoice.Description.Length > 255 ? invoice.Description.Substring(0, 255) : invoice.Description;
           foreach (var item in invoice.Payments)
           {
               item.Description = tmp ?? string.Empty;
           }
       }
       ```

  3. **Xử lý thanh toán bằng tài khoản ngân hàng**:
     - Kiểm tra và xác thực tài khoản ngân hàng cho các thanh toán:
       ```csharp
       foreach (var payment in payments)
       {
           var accId = await BankAccountService.GetByIdAsync(payment.AccountId ?? 0);
           if (accId == null && payment.AccountId > 0)
           {
               throw new KvBankAccountNotFoundException();
           }
       }
       ```
     - Đảm bảo tài khoản ngân hàng sử dụng trong thanh toán phải tồn tại

  4. **Xử lý thanh toán và hóa đơn**:
     - Dựa vào loại hóa đơn (mới hoặc cập nhật), gọi các phương thức xử lý tương ứng:
       ```csharp
       var result = invoice.Id <= 0
           ? await CreateInvoiceAsync(invoice, payments, updateOnHand, null, fromCombine)
           : await UpdateInvoiceAsync(invoice, invoice.UpdatePayment ?? false);
       ```
     - Đối với hóa đơn mới (ID <= 0):
       + Gọi `CreateInvoiceAsync` để tạo mới hóa đơn và các thanh toán liên quan
       + Cập nhật số lượng tồn kho nếu tham số `updateOnHand` được bật
     - Đối với hóa đơn hiện có (ID > 0):
       + Gọi `UpdateInvoiceAsync` để cập nhật thông tin hóa đơn
       + Cập nhật các thanh toán nếu `UpdatePayment` được bật

  5. **Xử lý thông tin khách hàng**:
     - Cập nhật thông tin khách hàng trong hóa đơn kết quả:
       ```csharp
       if (invoice.CustomerId > 0)
       {
           var customer = await CustomerService.GetByIdAsync(invoice.CustomerId.Value);
           if (customer != null)
           {
               result.CustomerCode = customer.Code;
               result.CustomerName = customer.Name;
               result.CustomerPhone = customer.ContactNumber;
           }
       }
       ```
     - Đảm bảo thông tin khách hàng đầy đủ trong hóa đơn kết quả

  6. **Xử lý điểm tích lũy và khuyến mãi**:
     - Tính toán điểm thưởng khuyến mãi cho khách hàng:
       ```csharp
       var promotionPoint = CalculatePromotionPoint(result);
       if (promotionPoint > 0)
       {
           result.Point = promotionPoint;
       }
       ```
     - Áp dụng điểm thưởng dựa trên chương trình khuyến mãi và giá trị hóa đơn

  7. **Xử lý đơn hàng liên quan**:
     - Nếu hóa đơn được tạo từ đơn hàng, cập nhật trạng thái đơn hàng tương ứng:
       ```csharp
       if (invoice.OrderId > 0)
       {
           // Thực hiện các bước cập nhật trạng thái đơn hàng
       }
       ```
     - Đảm bảo đồng bộ giữa trạng thái đơn hàng và hóa đơn

  8. **Xử lý thay đổi thông tin máy POS**:
     - Cập nhật thông tin máy POS khi hóa đơn liên quan đến FBPos:
       ```csharp
       if (fbposParam != null && fbposParam.IsUseFBPosParam)
       {
           await ProcessInvoiceMappingFBPos(fbposParam, result);
       }
       ```
     - Xử lý đặc biệt cho hóa đơn được tạo từ các hệ thống POS tích hợp

- **Bước xử lý đặc biệt**:
  - **Xử lý khóa đồng bộ (TrackingHelper)**:
    ```csharp
    using (var bltHelper = new TrackingHelper(AuthService.Context))
    {
        // Các bước xử lý hóa đơn trong khối using
    }
    ```
    - Sử dụng `TrackingHelper` để theo dõi và quản lý quá trình tạo hóa đơn
    - Đảm bảo giải phóng tài nguyên sau khi hoàn thành xử lý
    - Hỗ trợ xử lý các sự kiện liên quan đến hóa đơn

  - **Xử lý thanh toán đặc biệt**:
    - Với thanh toán bằng thẻ tín dụng:
      + Kiểm tra thông tin thẻ và xác thực giao dịch
      + Ghi nhận thông tin giao dịch thẻ
    - Với thanh toán bằng voucher:
      + Đánh dấu voucher đã sử dụng
      + Cập nhật số dư voucher sau khi thanh toán

- **Ý nghĩa nghiệp vụ**:
  - Đây là bước trọng tâm trong quy trình tạo hóa đơn
  - Đảm bảo hóa đơn được tạo đúng quy định, có đầy đủ thông tin
  - Xử lý chính xác các phương thức thanh toán đa dạng
  - Đảm bảo tính toàn vẹn của dữ liệu giữa hóa đơn, thanh toán và các dữ liệu liên quan

- **Lưu ý đặc biệt**:
  - Phương thức phải xử lý đồng bộ giữa nhiều đối tượng (hóa đơn, thanh toán, khách hàng...)
  - Cần xử lý các trường hợp đặc biệt (hóa đơn offline, hóa đơn cập nhật...)
  - Đảm bảo tất cả giao dịch tài chính được ghi nhận chính xác
  - Theo dõi và xử lý các lỗi có thể xảy ra trong quá trình tạo hóa đơn

---
**Điều hướng**
- [Quay lại trang chủ](./MakeInvoice-Index.md)
- [Bước trước: Xác thực mã khuyến mãi và voucher](./7-MakeInvoice-CouponVoucher.md)
- [Bước tiếp theo: Xử lý giao hàng](./9-MakeInvoice-DeliveryProcessing.md) 