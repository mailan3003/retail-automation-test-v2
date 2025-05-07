# Phân tích Business Logic của phương thức MakeInvoiceAsync

## Các bước xử lý chính

### 19.11. Phân bổ thanh toán

- **Mục đích**: Thực hiện việc phân bổ thanh toán giữa hóa đơn và các đối tượng liên quan như đơn hàng, giữ các khoản thanh toán được cân đối và nhất quán

- **Điều kiện áp dụng**:
  - Áp dụng sau khi hóa đơn đã được tạo hoặc cập nhật thành công
  - Đặc biệt quan trọng khi có các thanh toán trực tiếp hoặc đặt cọc từ đơn hàng

- **Quy trình xử lý chi tiết**:
  1. **Xử lý thanh toán từ đặt cọc**:
     - Kiểm tra và phân bổ các khoản đặt cọc từ đơn hàng:
       ```csharp
       if (result.OrderId > 0 && result.Payments != null && result.Payments.Any())
       {
           // Xử lý phân bổ thanh toán từ đơn hàng
           await updateVoucherPaymentWhenUsingDeposit(result, order);
       }
       ```
     - Quá trình phân bổ đặt cọc bao gồm:
       + Lấy thông tin đặt cọc từ đơn hàng
       + Tạo các bản ghi thanh toán tương ứng cho hóa đơn
       + Cập nhật trạng thái của các khoản đặt cọc
       + Theo dõi số tiền đã sử dụng từ đặt cọc

  2. **Phân bổ thanh toán liên hóa đơn**:
     - Nếu có nhiều hóa đơn liên quan (ví dụ: hóa đơn chính và hóa đơn trả hàng):
       ```csharp
       if (result.RelatedInvoiceIds != null && result.RelatedInvoiceIds.Any())
       {
           // Xử lý phân bổ thanh toán giữa các hóa đơn liên quan
           await PaymentAllocationService.ProcessPaymentAllocation(result);
       }
       ```
     - Quy trình phân bổ bao gồm:
       + Tính toán số tiền cần phân bổ giữa các hóa đơn
       + Tạo các bản ghi liên kết thanh toán
       + Cập nhật công nợ của từng hóa đơn
       + Theo dõi lịch sử phân bổ thanh toán

  3. **Xử lý các phương thức thanh toán đặc biệt**:
     - Đối với các phương thức thanh toán như thẻ tín dụng, ví điện tử:
       ```csharp
       var specialPayments = result.Payments.Where(p => p.Method == "CreditCard" || p.Method == "E-Wallet");
       foreach (var payment in specialPayments)
       {
           // Xử lý đặc biệt cho từng phương thức thanh toán
           await ProcessSpecialPayment(payment);
       }
       ```
     - Quy trình xử lý bao gồm:
       + Ghi nhận thông tin giao dịch đặc thù
       + Đồng bộ dữ liệu với hệ thống thanh toán bên ngoài
       + Cập nhật trạng thái thanh toán
       + Tạo các báo cáo thanh toán liên quan

  4. **Xử lý thanh toán theo đợt**:
     - Đối với hóa đơn có thanh toán theo đợt:
       ```csharp
       if (result.HasInstallmentPayment)
       {
           // Xử lý thanh toán theo đợt
           await ProcessInstallmentPayment(result);
       }
       ```
     - Quy trình xử lý bao gồm:
       + Tạo lịch thanh toán theo đợt
       + Ghi nhận các đợt thanh toán đã hoàn thành
       + Tính toán số tiền còn lại cần thanh toán
       + Theo dõi trạng thái thanh toán của từng đợt

  5. **Cập nhật công nợ khách hàng**:
     - Sau khi phân bổ thanh toán, cập nhật công nợ khách hàng:
       ```csharp
       if (result.CustomerId > 0)
       {
           // Cập nhật công nợ của khách hàng
           await UpdateCustomerDebt(result.CustomerId.Value, result.Debt ?? 0);
       }
       ```
     - Quy trình cập nhật bao gồm:
       + Tính toán lại tổng công nợ của khách hàng
       + Ghi nhận lịch sử thay đổi công nợ
       + Cập nhật trạng thái công nợ của khách hàng
       + Kiểm tra ngưỡng tín dụng của khách hàng

- **Xử lý đặc biệt**:
  - **Xử lý hoàn tiền**:
    - Đối với trường hợp khách hàng thanh toán dư:
      ```csharp
      if (result.PayingAmount > result.Total)
      {
          // Xử lý hoàn tiền hoặc giữ số dư
          await ProcessOverPayment(result);
      }
      ```
    - Quy trình xử lý bao gồm:
      + Tạo phiếu hoàn tiền
      + Lưu trữ thông tin số dư của khách hàng
      + Áp dụng số dư vào các hóa đơn sau này
      + Theo dõi lịch sử hoàn tiền

  - **Xử lý thu chi nội bộ**:
    - Khi thanh toán liên quan đến thu chi nội bộ:
      ```csharp
      var internalPayments = result.Payments.Where(p => p.IsInternalTransaction);
      foreach (var payment in internalPayments)
      {
          // Tạo phiếu thu chi nội bộ
          await CreateInternalTransaction(payment);
      }
      ```
    - Quy trình xử lý bao gồm:
      + Tạo phiếu thu hoặc phiếu chi nội bộ
      + Cập nhật số dư quỹ
      + Theo dõi lịch sử giao dịch nội bộ
      + Đồng bộ dữ liệu với hệ thống kế toán

- **Ý nghĩa nghiệp vụ**:
  - Đảm bảo tính chính xác của dữ liệu tài chính
  - Theo dõi đầy đủ các khoản thanh toán và công nợ
  - Hỗ trợ quy trình thanh toán linh hoạt cho khách hàng
  - Tạo cơ sở cho việc đối chiếu và báo cáo tài chính
  - Đảm bảo sự nhất quán trong thông tin tài chính của hệ thống

- **Lưu ý đặc biệt**:
  - Phân bổ thanh toán cần đảm bảo tính chính xác và nhất quán cao
  - Xử lý cẩn thận các trường hợp đặc biệt (hoàn tiền, thay đổi giá trị hóa đơn...)
  - Lưu trữ đầy đủ lịch sử các thay đổi tài chính
  - Đảm bảo tuân thủ các quy định về kế toán và thuế

---
**Điều hướng**
- [Quay lại trang chủ](./MakeInvoice-Index.md)
- [Bước trước: Cập nhật đơn hàng và tài liệu](./10-MakeInvoice-OrderDocumentUpdate.md)
- [Bước tiếp theo: Theo dõi sự kiện](./12-MakeInvoice-EventTracking.md) 