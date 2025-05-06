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
     - Nếu không phải hóa đơn cập nhật (UpdateInvoiceId <= 0), kiểm tra trạng thái đơn hàng
     - Đơn hàng không được ở trạng thái Hoàn thành (Finalized) hoặc Hủy (Void)
     - Có ngoại lệ cho hóa đơn offline (mã bắt đầu bằng tiền tố offline)
     - Nếu điều kiện không thỏa mãn, ném ngoại lệ với thông báo: "Trạng thái đơn hàng không hợp lệ"

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
       + Không phải hóa đơn nhân bản (`!invoice.Code.StartsWith(Invoice.ClonePrefix)`)
       + Người dùng không có quyền thay đổi người bán và không phải admin (`!AuthService.Context.User.IsAdmin && !AuthService.CheckPermission(Invoice.ModifySeller)`)
     - Hành động: Gán người bán là người dùng hiện tại (`invoice.SoldById = AuthService.Context.User.Id`)

## Kịch bản kiểm thử

### 1. Kiểm tra tồn tại của đơn hàng

| Kịch bản | Dữ liệu đầu vào | Kết quả mong đợi |
|----------|----------------|-----------------|
| 1.1. Đơn hàng tồn tại | ID đơn hàng hợp lệ đã có trong hệ thống | Thành công: Hệ thống xử lý tiếp |
| 1.2. Đơn hàng không tồn tại | ID đơn hàng không có trong hệ thống | Lỗi: "Không có quyền truy cập bản ghi với người dùng {tên_người_dùng}" |

**Hướng dẫn kiểm thử**:
- Tạo hóa đơn từ đơn hàng không tồn tại
- Nhập ID đơn hàng không tồn tại vào trường OrderId khi tạo hóa đơn
- Kiểm tra thông báo lỗi hiển thị

### 2. Kiểm tra quyền truy cập đơn hàng

| Kịch bản | Dữ liệu đầu vào | Kết quả mong đợi |
|----------|----------------|-----------------|
| 2.1. Đơn hàng thuộc cùng nhà bán lẻ | Đơn hàng của nhà bán lẻ hiện tại | Thành công: Hệ thống xử lý tiếp |
| 2.2. Đơn hàng thuộc nhà bán lẻ khác | Đơn hàng của nhà bán lẻ khác | Lỗi: "Bạn không có quyền thực hiện." |

**Hướng dẫn kiểm thử**:
- Đăng nhập vào hệ thống với tài khoản của nhà bán lẻ A
- Thử tạo hóa đơn từ đơn hàng của nhà bán lẻ B
- Kiểm tra thông báo lỗi hiển thị

### 3. Kiểm tra trạng thái đơn hàng

| Kịch bản | Dữ liệu đầu vào | Kết quả mong đợi |
|----------|----------------|-----------------|
| 3.1. Đơn hàng đang xử lý | Đơn hàng có trạng thái Đang xử lý (Pending) | Thành công: Hệ thống xử lý tiếp |
| 3.2. Đơn hàng đã hoàn thành | Đơn hàng có trạng thái Đã hoàn thành (Finalized) | Lỗi: "Trạng thái đơn hàng không hợp lệ" |
| 3.3. Đơn hàng đã hủy | Đơn hàng có trạng thái Đã hủy (Void) | Lỗi: "Trạng thái đơn hàng không hợp lệ" |
| 3.4. Đơn hàng offline đã hoàn thành | Đơn hàng offline đã hoàn thành (mã bắt đầu bằng OFF) | Thành công: Hệ thống xử lý tiếp (Trường hợp ngoại lệ) |
| 3.5. Hóa đơn cập nhật từ đơn hàng | Hóa đơn cập nhật (UpdateInvoiceId > 0) | Thành công: Hệ thống xử lý tiếp (Trường hợp ngoại lệ) |

**Hướng dẫn kiểm thử**:
- Tạo các đơn hàng với trạng thái khác nhau
- Thử tạo hóa đơn từ mỗi đơn hàng
- Kiểm tra kết quả và thông báo lỗi (nếu có)

### 4. Kiểm tra quyền tạo hóa đơn

| Kịch bản | Dữ liệu đầu vào | Kết quả mong đợi |
|----------|----------------|-----------------|
| 4.1. Người dùng có quyền tạo hóa đơn ở chi nhánh của đơn hàng | Người dùng có quyền MakeInvoice tại chi nhánh của đơn hàng | Thành công: Hệ thống xử lý tiếp |
| 4.2. Người dùng không có quyền tạo hóa đơn ở chi nhánh của đơn hàng | Người dùng không có quyền MakeInvoice tại chi nhánh của đơn hàng | Lỗi: "Bạn không thể cập nhật hóa đơn {mã_hóa_đơn} được tạo từ phiếu đặt hàng {mã_đơn_hàng} do bạn không có phân quyền đặt hàng" |

**Hướng dẫn kiểm thử**:
- Đăng nhập với tài khoản không có quyền MakeInvoice tại chi nhánh của đơn hàng
- Thử tạo hóa đơn từ đơn hàng tại chi nhánh đó
- Kiểm tra thông báo lỗi hiển thị

### 5. Kiểm tra xử lý người bán hàng

| Kịch bản | Dữ liệu đầu vào | Kết quả mong đợi |
|----------|----------------|-----------------|
| 5.1. Người dùng tự tạo hóa đơn, không chọn người bán | Không chọn người bán (SoldById = 0) | Thành công: Hệ thống tự gán người bán là người dùng hiện tại |
| 5.2. Người dùng không có quyền thay đổi người bán | Chọn người bán khác khi không có quyền ModifySeller | Thành công: Hệ thống tự động gán người bán là người dùng hiện tại |
| 5.3. Người dùng có quyền thay đổi người bán | Chọn người bán khác khi có quyền ModifySeller | Thành công: Hệ thống giữ nguyên người bán như đã chọn |
| 5.4. Hóa đơn offline với người bán khác | Hóa đơn offline và SoldById khác người dùng hiện tại | Thành công: Hệ thống giữ nguyên người bán đã chọn |
| 5.5. Hóa đơn được nhân bản với người bán khác | Hóa đơn nhân bản (mã bắt đầu bằng CLONE) và SoldById khác người dùng hiện tại | Thành công: Hệ thống giữ nguyên người bán đã chọn |
| 5.6. Hóa đơn cập nhật với người bán khác | Hóa đơn cập nhật (UpdateInvoiceId > 0) và SoldById khác người dùng hiện tại | Thành công: Hệ thống giữ nguyên người bán đã chọn |
| 5.7. Người dùng là admin tạo hóa đơn | Người dùng là admin và SoldById khác người dùng hiện tại | Thành công: Hệ thống giữ nguyên người bán đã chọn |

**Hướng dẫn kiểm thử**:
- Đăng nhập với các loại tài khoản khác nhau (có/không có quyền ModifySeller, admin/không phải admin)
- Tạo hóa đơn và chọn người bán khác
- Kiểm tra người bán trong hóa đơn sau khi tạo thành công

## Bảng tổng hợp lỗi

| Mã lỗi | Thông báo | Nguyên nhân |
|--------|-----------|------------|
| KvValidateOrderException | "Không có quyền truy cập bản ghi với người dùng {tên_người_dùng}" | Đơn hàng không tồn tại |
| KvValidateInvoiceException | "Bạn không có quyền thực hiện." | Đơn hàng thuộc nhà bán lẻ khác |
| KvValidateInvoiceException | "Trạng thái đơn hàng không hợp lệ" | Đơn hàng đã hoàn thành hoặc đã hủy |
| KvValidateInvoiceException | "Bạn không thể cập nhật hóa đơn {mã_hóa_đơn} được tạo từ phiếu đặt hàng {mã_đơn_hàng} do bạn không có phân quyền đặt hàng" | Người dùng không có quyền tạo hóa đơn tại chi nhánh của đơn hàng |

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