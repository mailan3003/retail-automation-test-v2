# Phân tích Business Logic của phương thức CreateInvoice

### 15. Kiểm tra thông tin khách hàng và xử lý thông tin giao hàng
- **Xử lý thông tin giao hàng**:
  - Hệ thống lấy thông tin hóa đơn cũ (nếu có) thông qua `InvoiceService.GetByIdAsync(invoice.Id)`
  - Tạo đối tượng `oldInvInfo` từ hóa đơn cũ (nếu có) bằng `InvoiceInfo.InstantFrom(oldInv)`
  - Khởi tạo đối tượng `existDeliveryInfo` mới để lưu thông tin giao hàng
  - Nếu hóa đơn cũ tồn tại, có thông tin giao hàng và đang cập nhật hóa đơn (`oldInv != null && oldInv.DeliveryInfoes.Any() && invoice.Id > 0`):
    - Lấy thông tin giao hàng hiện tại từ hóa đơn cũ bằng cách tìm bản ghi có `RetailerId` trùng với người dùng hiện tại và `IsCurrent = true`
    - Tách thông tin giao hàng khỏi đối tượng gốc để tránh ảnh hưởng đến dữ liệu gốc bằng `DeliveryInfoService.DetachByClone()`
  - Lưu trạng thái giao hàng cũ (`oldDeliveryStatus`) và tên kênh bán hàng cũ (`oldSaleChannelName`) để sử dụng sau này
  - Nếu hóa đơn có thông tin giao hàng (`invoice.DeliveryDetail != null`), sử dụng đối tác giao hàng mặc định (`UseDefaultPartner`) và mã hóa đơn bắt đầu bằng mã offline (`Invoice.OffCodePrefix`):
    - Xóa thông tin đối tác giao hàng (`PartnerDelivery = null`)
    - Xóa mã đối tác (`PartnerCode = string.Empty`)
    - Xóa tên đối tác (`PartnerName = string.Empty`)
- **Xử lý ID khách hàng**:
  - Hệ thống kiểm tra ID khách hàng trong hóa đơn (`invoice.CustomerId`)
  - Nếu ID khách hàng > 0, giữ nguyên giá trị ID khách hàng
  - Nếu ID khách hàng ≤ 0, gán giá trị null cho ID khách hàng (`invoice.CustomerId = null`)
  - Điều này giúp phân biệt giữa hóa đơn có khách hàng cụ thể và hóa đơn bán lẻ cho khách vãng lai
  - Đoạn code thực hiện: `invoice.CustomerId = invoice.CustomerId > 0 ? invoice.CustomerId : null;`
- **Xác thực khách hàng**:
  - Nếu hóa đơn có thông tin khách hàng (`invoice.CustomerId > 0`):
    - Hệ thống lấy thông tin công nợ hiện tại của khách hàng thông qua `CustomerService.GetByIdsAsync(new[] { invoice.CustomerId ?? 0 }).Select(c => c.Debt).FirstOrDefaultWithTracking(ExecutionContext) ?? 0`
    - Đồng thời lấy thông tin chi tiết của khách hàng thông qua `CustomerService.GetByIdAsync(invoice.CustomerId.Value)`
    - Kiểm tra trạng thái khách hàng:
      - Nếu đang tạo hóa đơn mới (`invoice.Id <= 0`) và khách hàng không tồn tại (`customer == null`) hoặc không còn hoạt động (`customer.IsActive != true`) hoặc đã bị xóa (`customer.isDeleted == true`):
        - Hệ thống sẽ ném ngoại lệ `KvValidateCustomerException` với thông báo `KVMessage._customer_UnActive` (Khách hàng không còn hoạt động trong hệ thống)
    - Thông tin công nợ hiện tại của khách hàng (`customerOldDebt`) sẽ được sử dụng sau này để tính toán công nợ mới sau khi tạo/cập nhật hóa đơn
  - Nếu không có thông tin khách hàng (`invoice.CustomerId <= 0`):
    - Hóa đơn sẽ được xử lý như hóa đơn bán lẻ cho khách vãng lai
    - Không cần kiểm tra thêm thông tin khách hàng 

---
**Điều hướng**
- Trước đó: [15-CreateInvoice-PaymentValidation.md](./15-CreateInvoice-PaymentValidation.md)
- Tiếp theo: [17-CreateInvoice-WarehouseCheck.md](./17-CreateInvoice-WarehouseCheck.md)
- Tổng quan: [01-CreateInvoice-Overview.md](./01-CreateInvoice-Overview.md) 