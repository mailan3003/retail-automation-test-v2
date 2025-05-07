# Phân tích Business Logic của phương thức MakeInvoiceAsync

## Các bước xử lý chính

### 19.6. Kiểm tra và cảnh báo công nợ khách hàng

- **Mục đích**: Kiểm tra và cảnh báo về công nợ của khách hàng khi tạo hóa đơn, tránh việc khách hàng vượt quá hạn mức nợ

- **Điều kiện áp dụng**:
  - Áp dụng cho các hóa đơn thông thường (không phải hóa đơn offline)
  - Cấu hình cảnh báo công nợ khách hàng được bật (PosSetting.WarningCustomerDebt = true)
  - Không áp dụng cho hóa đơn đã thanh toán đủ hoặc hóa đơn trả hàng

- **Quy trình xử lý chi tiết**:
  1. **Xác định điều kiện kiểm tra công nợ**:
     - Kiểm tra một loạt điều kiện để quyết định có cần kiểm tra cảnh báo công nợ không:
       ```csharp
       var isValidateWarningCustomerDebt = true;
       var isUsingCod = invoice.DeliveryDetail != null && invoice.DeliveryDetail.UsingPriceCod == 1;
       var isOfflineWarranty = invoice.Code != null && invoice.Code.StartsWith(Invoice.OffCodePrefix);
       
       if (isOfflineWarranty || isUsingCod || !PosSetting.WarningCustomerDebt || PosSetting.WarningCustomerDebt_IsSale || 
           (!isUpdateInvoice && ((invoice.PaidAmount > 0 ? invoice.PaidAmount : (invoice.PayingAmount ?? 0)) >= invoice.Total || invoice.OrderPaidAmount > 0)) || 
           (isUpdateInvoice && oldInvoice != null && invoice.Total < oldInvoice.Total) || 
           (!isUpdateInvoice && invoice.Id > 0) || invoice.ReturnId > 0)
       {
           isValidateWarningCustomerDebt = false;
       }
       ```
     - Bỏ qua kiểm tra công nợ trong các trường hợp:
       + Hóa đơn offline
       + Đơn hàng sử dụng COD
       + Tính năng cảnh báo công nợ bị tắt
       + Hóa đơn đã thanh toán đầy đủ
       + Cập nhật hóa đơn với tổng tiền giảm
       + Hóa đơn trả hàng

  2. **Tính toán công nợ phát sinh**:
     - Tính toán số tiền công nợ phát sinh từ hóa đơn hiện tại:
       ```csharp
       var customerDebt = invoice.Total - invoice.PayingAmount;
       ```
     - Đây là số tiền khách hàng sẽ nợ thêm sau khi tạo hóa đơn

  3. **Kiểm tra cảnh báo công nợ cho khách hàng cụ thể**:
     - Nếu hóa đơn có thông tin khách hàng, kiểm tra công nợ dựa trên ID khách hàng:
       ```csharp
       if (invoice.CustomerId > 0)
       {
           await ValidateWarningCustomerDebt(invoice.CustomerId ?? 0, customerDebt ?? 0);
       }
       else
       {
           await ValidateWarningCustomerRetailDebt(customerDebt ?? 0);
       }
       ```
     - Phương thức `ValidateWarningCustomerDebt` sẽ:
       + Lấy thông tin công nợ hiện tại của khách hàng
       + Tính toán tổng công nợ sau khi cộng với công nợ mới
       + So sánh với hạn mức công nợ được cấu hình cho khách hàng
       + Hiển thị cảnh báo nếu vượt quá hạn mức

  4. **Kiểm tra cảnh báo công nợ cho khách lẻ**:
     - Nếu hóa đơn không có thông tin khách hàng (khách lẻ), kiểm tra công nợ bán lẻ:
       ```csharp
       await ValidateWarningCustomerRetailDebt(customerDebt ?? 0);
       ```
     - Phương thức `ValidateWarningCustomerRetailDebt` sẽ:
       + Lấy thông tin cấu hình công nợ bán lẻ
       + So sánh công nợ mới với hạn mức
       + Hiển thị cảnh báo nếu vượt quá hạn mức

  5. **Xử lý cảnh báo**:
     - Nếu công nợ vượt quá hạn mức, hệ thống sẽ:
       + Hiển thị thông báo cảnh báo cho người dùng
       + Có thể ngăn không cho tạo hóa đơn (tùy theo cấu hình)
       + Yêu cầu xác nhận từ người dùng để tiếp tục

- **Ý nghĩa nghiệp vụ**:
  - Giúp doanh nghiệp kiểm soát công nợ khách hàng
  - Ngăn ngừa rủi ro tài chính do công nợ quá lớn
  - Hỗ trợ chính sách bán hàng và quản lý khách hàng
  - Tạo cảnh báo sớm để người dùng có thể đưa ra quyết định phù hợp
  - Có thể tùy chỉnh thông qua các cấu hình hệ thống (bật/tắt tính năng, điều chỉnh hạn mức)

- **Lưu ý đặc biệt**:
  - Chức năng này chỉ cảnh báo và không chặn hoàn toàn việc tạo hóa đơn (tùy thuộc vào cấu hình)
  - Khách hàng khác nhau có thể có hạn mức công nợ khác nhau
  - Có thể được điều chỉnh thông qua cấu hình hệ thống

---
**Điều hướng**
- [Quay lại trang chủ](./MakeInvoice-Index.md)
- [Bước trước: Xử lý cập nhật hóa đơn](./5-MakeInvoice-UpdateInvoice.md)
- [Bước tiếp theo: Xác thực mã khuyến mãi và voucher](./7-MakeInvoice-CouponVoucher.md)