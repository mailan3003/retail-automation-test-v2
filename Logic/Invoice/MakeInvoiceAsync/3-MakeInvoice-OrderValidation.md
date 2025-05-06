# Phân tích Business Logic của phương thức MakeInvoiceAsync

## Các bước xử lý chính

### 19.3. Xác thực đơn hàng

- **Mục đích**: Kiểm tra và xác thực thông tin đơn hàng khi tạo hóa đơn từ đơn hàng có sẵn, cũng như xử lý các quyền liên quan đến người bán hàng

- **Điều kiện áp dụng**:
  - Phần xác thực đơn hàng: Áp dụng khi hóa đơn được tạo từ đơn hàng (`invoice.OrderId != null && invoice.OrderId > 0`)
  - Phần xử lý người bán: Áp dụng khi không có đơn hàng/trả hàng/tài liệu liên quan nhưng có chỉ định người bán

- **Quy trình xử lý chi tiết**:
  1. **Kiểm tra và tải đơn hàng**:
     ```csharp
     if (invoice.OrderId != null && invoice.OrderId > 0)
     {
         order = await OrderService.GetByIdAsync(invoice.OrderId.GetValueOrDefault());
         if (order == null)
             throw new KvValidateOrderException(string.Format(Labels.noPermissionAccess, AuthService.Context.User.UserName));
     }
     ```
     - Nếu invoice.OrderId có giá trị > 0, hệ thống tải thông tin đơn hàng từ cơ sở dữ liệu
     - Nếu đơn hàng không tồn tại, ném ngoại lệ với thông báo: "Không có quyền truy cập bản ghi với người dùng {tên_người_dùng}"

  2. **Kiểm tra quyền truy cập đơn hàng**:
     ```csharp
     if ((invoice.RetailerId == 0 && order.RetailerId != AuthService.Context.RetailerId) || 
         (invoice.Id > 0 && order.RetailerId != invoice.RetailerId))
         throw new KvValidateInvoiceException(KVMessage.invalid_Retailer);
     ```
     - Đảm bảo đơn hàng thuộc cùng nhà bán lẻ với người dùng hiện tại
     - Nếu là hóa đơn đã tồn tại (Id > 0), đảm bảo nhà bán lẻ của đơn hàng khớp với nhà bán lẻ của hóa đơn
     - Nếu không khớp, ném ngoại lệ với thông báo: "Bạn không có quyền thực hiện."

  3. **Kiểm tra trạng thái đơn hàng**:
     ```csharp
     if (invoice.UpdateInvoiceId <= 0 && ((order.Status == (int)OrderState.Finalized || order.Status == (int)OrderState.Void) &&
         (string.IsNullOrEmpty(invoice.Code) || !invoice.Code.StartsWith(Invoice.OffCodePrefix))))
     {
         throw new KvValidateInvoiceException(KVMessage.InvalidOrderState);
     }
     ```
     - Kiểm tra trạng thái đơn hàng chỉ áp dụng cho hóa đơn mới (không phải hóa đơn cập nhật)
     - Đơn hàng phải đang ở trạng thái có thể tạo hóa đơn (không được là **Hoàn thành** hoặc **Hủy**)
     - Riêng hóa đơn **offline** được phép tạo từ đơn hàng ở mọi trạng thái
     - Nếu vi phạm các điều kiện trên, hệ thống sẽ báo lỗi "Trạng thái đơn hàng không hợp lệ"

  4. **Kiểm tra quyền tạo hóa đơn**:
     ```csharp
     if (!AuthService.CheckPermission(Order.MakeInvoice, order.BranchId))
     {
         throw new KvValidateInvoiceException(string.Format(KVMessage.invoiceValidate_notOrderRole, invoice.Code, order.Code));
     }
     ```
     - Kiểm tra người dùng có quyền MakeInvoice tại chi nhánh của đơn hàng không
     - Nếu không có quyền, ném ngoại lệ với thông báo: "Bạn không thể cập nhật hóa đơn {mã_hóa_đơn} được tạo từ phiếu đặt hàng {mã_đơn_hàng} do bạn không có phân quyền đặt hàng"

  5. **Xử lý người bán hàng**:
     ```csharp
     else if ((invoice.OrderId == null && invoice.ReturnId == null && invoice.DocumentId == null) 
         && (invoice.SoldById > 0 && invoice.SoldById != AuthService.Context.User.Id)
         && !isOfflineInv
         && invoice.UpdateInvoiceId <= 0
         && (string.IsNullOrEmpty(invoice.Code) || !invoice.Code.StartsWith(Invoice.ClonePrefix, StringComparison.OrdinalIgnoreCase))
         && (!AuthService.Context.User.IsAdmin && !AuthService.CheckPermission(Invoice.ModifySeller)))
     {
         invoice.SoldById = AuthService.Context.User.Id;
     }
     ```
     - Điều kiện áp dụng:
       + Hóa đơn không liên kết với đơn hàng/trả hàng/tài liệu (`invoice.OrderId == null && invoice.ReturnId == null && invoice.DocumentId == null`)
       + Người bán được chỉ định khác với người dùng hiện tại (`invoice.SoldById > 0 && invoice.SoldById != AuthService.Context.User.Id`)
       + Không phải hóa đơn offline (`!isOfflineInv`)
       + Không phải hóa đơn cập nhật (`invoice.UpdateInvoiceId <= 0`)
       + Không phải hóa đơn sao chép (`!invoice.Code.StartsWith(Invoice.ClonePrefix)`)
       + Người dùng không có quyền thay đổi người bán và không phải admin (`!AuthService.Context.User.IsAdmin && !AuthService.CheckPermission(Invoice.ModifySeller)`)
     - Hành động: Gán người bán là người dùng hiện tại (`invoice.SoldById = AuthService.Context.User.Id`)

## Luồng xử lý chính

1. **Xử lý đơn hàng liên quan (nếu có)**:
   - Nếu `invoice.OrderId != null && invoice.OrderId > 0`:
     + Tải thông tin đơn hàng từ cơ sở dữ liệu
     + Kiểm tra tồn tại của đơn hàng
     + Kiểm tra quyền truy cập đơn hàng (cùng nhà bán lẻ)
     + Kiểm tra trạng thái đơn hàng (không phải hoàn thành hoặc đã hủy) - với ngoại lệ cho hóa đơn offline và hóa đơn cập nhật
     + Kiểm tra quyền tạo hóa đơn tại chi nhánh của đơn hàng

2. **Xử lý người bán hàng (nếu không liên quan đến đơn hàng)**:
   - Nếu tất cả các điều kiện sau thỏa mãn:
     + Hóa đơn không liên kết với đơn hàng/trả hàng/tài liệu
     + Người bán được chỉ định khác với người dùng hiện tại
     + Không phải hóa đơn offline
     + Không phải hóa đơn cập nhật
     + Không phải hóa đơn nhân bản
     + Người dùng không phải admin và không có quyền thay đổi người bán
   - Thì gán người bán là người dùng hiện tại

## Các lưu ý quan trọng

- Mã nguồn thực hiện kiểm tra nhiều điều kiện phức tạp kết hợp để xác định cách xử lý người bán hàng
- Việc xử lý người bán hàng chỉ áp dụng khi không có đơn hàng/trả hàng/tài liệu liên quan
- Có những ngoại lệ đặc biệt cho hóa đơn offline, hóa đơn cập nhật và hóa đơn nhân bản
- Người dùng là admin hoặc có quyền ModifySeller có thể tạo hóa đơn với người bán khác
- Việc kiểm tra trạng thái đơn hàng không áp dụng cho hóa đơn cập nhật (UpdateInvoiceId > 0)

---
**Điều hướng**
- [Quay lại trang chủ](./MakeInvoice-Index.md)
- [Bước trước: Xử lý hóa đơn offline](./2-MakeInvoice-OfflineInvoice.md)
- [Bước tiếp theo: Xử lý lô sản phẩm](./4-MakeInvoice-BatchProcessing.md)