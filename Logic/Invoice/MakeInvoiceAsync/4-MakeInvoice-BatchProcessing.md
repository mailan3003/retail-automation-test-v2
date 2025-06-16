# Phân tích Business Logic của phương thức MakeInvoiceAsync

## Các bước xử lý chính

### 19.4. Xử lý lô sản phẩm

- **Mục đích**: Kiểm tra và xác thực thông tin lô sản phẩm (sản phẩm có hạn sử dụng/số lô) trong hóa đơn

- **Điều kiện áp dụng**:
  - Áp dụng khi hóa đơn có chi tiết sản phẩm thuộc lô (ProductBatchExpireId > 0)
  - Có ý nghĩa quan trọng đối với các ngành như dược phẩm, thực phẩm, hàng hóa có hạn sử dụng

- **Quy trình xử lý chi tiết**:
  1. **Thu thập thông tin lô sản phẩm cũ (nếu có)**:
     - Nếu đang cập nhật hóa đơn có sản phẩm thuộc lô:
       ```csharp
       if (invoice.UpdateInvoiceId > 0 && invoice.InvoiceDetails != null && invoice.InvoiceDetails.Any(x => x.ProductBatchExpireId > 0))
       {
           oldBatchProductId = await Db.InvoiceDetails
               .Where(p => p.InvoiceId == invoice.UpdateInvoiceId && p.ProductBatchExpireId > 0)
               .Select(p => p.ProductBatchExpireId ?? 0).ToArrayAsync();
       }
       ```
     - Mục đích: Lưu trữ ID lô sản phẩm cũ để xử lý sau này (trả lại số lượng về lô cũ, trừ số lượng từ lô mới)

  2. **Xác thực lô sản phẩm cho hóa đơn offline hoặc omni**:
     - Kiểm tra riêng cho hóa đơn offline hoặc omni:
       ```csharp
       if (isOfflineInv || PosOnlineHelper.IsInvoiceOmni(invoice.Code))
       {
           await ValidateSyncOfflineBatchInvoice(invoice);
       }
       ```
     - Mục đích: Xử lý đặc biệt cho hóa đơn offline khi đồng bộ lô sản phẩm
     - Chi tiết quy trình xử lý: [ValidateSyncOfflineBatchInvoice.md](../ValidateSyncOfflineBatchInvoice.md)

  3. **Xác thực lô sản phẩm cho hóa đơn thông thường**:
     - Kiểm tra cho hóa đơn thông thường (không phải hóa đơn mới):
       ```csharp
       else if(!isNewInvoice)
       {
           await ValidateBatchInvoice(invoice, null, oldBatchProductId, fromCombine);
       }
       ```
     - Phương thức `ValidateBatchInvoice` thực hiện (xem chi tiết tại [ValidateBatchInvoice.md](../ValidateBatchInvoice.md)):
       + Xác thực số lô sản phẩm và đảm bảo chúng tồn tại trong hệ thống
       + Kiểm tra số lượng tồn kho khả dụng cho từng lô
       + Kiểm tra ngày hết hạn của lô so với ngày hiện tại
       + Xác thực quyền hạn của người dùng đối với các thao tác lô

  4. **Xử lý tuỳ theo loại hóa đơn**:
     - `ValidateSyncOfflineBatchInvoice`: Xử lý đồng bộ lô sản phẩm từ hóa đơn offline
       + Kiểm tra tính hợp lệ của lô sản phẩm trong kho
       + Xử lý các trường hợp đặc biệt khi đồng bộ số lượng
       + Tạo lô mới nếu cần thiết (tùy theo cấu hình)
       + Cập nhật thông tin lô trong chi tiết hóa đơn
     
     - `ValidateBatchInvoice`: Xử lý lô sản phẩm cho hóa đơn thông thường
       + Kiểm tra tồn kho theo lô
       + Kiểm tra quyền hạn sử dụng lô
       + Kiểm tra hạn sử dụng của lô
       + Cập nhật thông tin lô trong chi tiết hóa đơn

- **Ý nghĩa nghiệp vụ**:
  - Đảm bảo tính chính xác của việc quản lý hàng hóa theo lô/hạn sử dụng
  - Hỗ trợ tuân thủ quy định về truy xuất nguồn gốc sản phẩm
  - Ngăn chặn việc bán sản phẩm đã hết hạn hoặc không còn tồn kho trong lô
  - Đảm bảo nguyên tắc FIFO (First In First Out) trong quản lý hàng tồn kho
  - Đặc biệt quan trọng đối với các ngành như dược phẩm, thực phẩm, hàng có hạn sử dụng

- **Lưu ý đặc biệt**:
  - Xử lý lô sản phẩm có thể khác nhau giữa các loại hóa đơn (offline, cập nhật, hóa đơn mới)
  - Cần cập nhật số lượng tồn kho theo lô khi tạo hóa đơn
  - Cần xử lý đặc biệt khi chuyển từ lô này sang lô khác trong trường hợp cập nhật hóa đơn

---
**Điều hướng**
- [Quay lại trang chủ](./MakeInvoice-Index.md)
- [Bước trước: Xác thực đơn hàng](./3-MakeInvoice-OrderValidation.md)
- [Bước tiếp theo: Xử lý cập nhật hóa đơn](./5-MakeInvoice-UpdateInvoice.md)