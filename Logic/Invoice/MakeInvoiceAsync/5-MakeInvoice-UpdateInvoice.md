# Phân tích Business Logic của phương thức MakeInvoiceAsync

## Các bước xử lý chính

### 19.5. Xử lý cập nhật hóa đơn

- **Mục đích**: Xử lý các tác vụ đặc biệt khi cập nhật hóa đơn hiện có thay vì tạo hóa đơn mới

- **Điều kiện áp dụng**:
  - Hóa đơn đang được cập nhật (invoice.UpdateInvoiceId > 0)
  - Mã hóa đơn bắt đầu bằng tiền tố cập nhật "Update_" (`Invoice.UpdatePrefix`)

- **Quy trình xử lý chi tiết**:
  1. **Lấy thông tin hóa đơn cũ**:
     - Truy vấn và xác thực thông tin hóa đơn gốc cần cập nhật:
       ```csharp
       // Lấy thông tin hóa đơn gốc từ database
       oldInvoice = await _getByIdAsync(invoice.UpdateInvoiceId);
       
       // Kiểm tra tồn tại của hóa đơn gốc
       if (oldInvoice == null) 
           throw new KvValidateInvoiceException(
               string.Format(KVMessage.InvoiceNotFound, invoice.UpdateInvoiceId)
           );
       ```
     - **Tóm tắt**: Bước này thực hiện việc lấy thông tin hóa đơn gốc cần cập nhật và xác thực sự tồn tại của nó. Nếu không tìm thấy hóa đơn gốc, hệ thống sẽ ném ra ngoại lệ với thông báo "Không tìm thấy hóa đơn với id {0}".

  2. **Kiểm tra chi nhánh**:
     - Đảm bảo hóa đơn gốc và hóa đơn cập nhật thuộc cùng chi nhánh:
       ```csharp
       if (oldInvoice.BranchId != invoice.BranchId)
       {
           var banchName = await BranchService.GetByIdAsync(invoice.BranchId);
           throw new KvValidateInvoiceException(string.Format(KVMessage._returnConfirm_BranchDoesNotMatch, oldInvoice.BranchName, banchName?.Name));
       }
       ```
     - Mục đích: Ngăn chặn việc chuyển hóa đơn giữa các chi nhánh
     - Khi phát hiện hóa đơn gốc và hóa đơn cập nhật thuộc khác chi nhánh, hệ thống sẽ ném ngoại lệ với thông báo "Hóa đơn bạn chọn thuộc chi nhánh {0}. Xin vui lòng chọn lại chi nhánh làm việc là {1} để thực hiện giao dịch này." trong đó:
       + {0}: Tên chi nhánh của hóa đơn gốc (oldInvoice.BranchName)
       + {1}: Tên chi nhánh của hóa đơn cập nhật (banchName?.Name)

  3. **Lưu trữ thông tin giao hàng COD**:
     - Xác định hóa đơn cũ có sử dụng COD không:
       ```csharp
       oldUsingCod = 0;
       if(invoice.DeliveryDetail?.Status != (byte)DeliveryStatus.Void && oldInvoice?.UsingCod == 1)
       {
           oldUsingCod = 1;
       }
       ```
     - Lưu trữ ID và trạng thái hóa đơn cũ:
       ```csharp
       oldInvoiceId = oldInvoice?.Id ?? 0;
       oldInvoiceStatus = oldInvoice.Status;
       ```
     - Lưu ý nếu khách hàng được thêm mới trong quá trình cập nhật:
       ```csharp
       changeFromNoToHaveCustomer = oldInvoice.CustomerId == null && invoice.CustomerId > 0;
       ```

  4. **Xử lý thông tin vận đơn**:
     - Nếu hóa đơn cũ sử dụng COD và có thông tin giao hàng, lấy thông tin đối tác vận chuyển:
       ```csharp
       if (oldUsingCod == 1)
       {
           oldDeliveryInfo = await DeliveryInfoService.GetLastByInvoiceIdAsync(invoice.UpdateInvoiceId);
           // Xử lý chuyển thông tin vận đơn từ hóa đơn cũ sang hóa đơn mới nếu cần
           ...
       }
       ```
     - Kiểm tra và xử lý các trường hợp đặc biệt:
       + Sao chép mã vận đơn từ hóa đơn cũ sang hóa đơn mới nếu không thay đổi
       + Kiểm tra xung đột khi thay đổi thông tin đối tác vận chuyển

  5. **Kiểm tra thời gian giao dịch**:
     - Kiểm tra thời gian giao dịch của hóa đơn mới so với quy định:
       ```csharp
       if (invoice.PurchaseDate != null && invoice.PurchaseDate != DateTime.MinValue)
       {
           var typeDirection = invoice.UpdateInvoiceId > 0 ? TypeDirection.Update : TypeDirection.Add;
           ValidateUpdateOrDeletePurchaseDate(invoice.PurchaseDate, DateTime.Now, typeDirection, isOfflineInv);
       }
       ```
     - Không cho phép thay đổi thời gian giao dịch quá xa so với hiện tại (thường là 6 tháng)

  6. **Lưu trữ các thông tin đặc biệt để xử lý sau**:
     - Chuẩn bị thông tin gói giao hàng và thông tin giao hàng để xử lý sau:
       ```csharp
       if (oldDeliveryInfo != null)
       {
           var oldDeliveryPackage = await DeliveryPackageService.GetAll().Where(p =>
               p.InvoiceId != null && p.InvoiceId == oldInvoiceId &&
               p.Id == oldDeliveryInfo.DeliveyPackageId)
           .FirstOrDefaultAsync();

           oldInvoiceToKafka = oldInvoice.CreateCopy();
           oldInvoiceToKafka.DeliveryPackage = DeliveryPackageService.DetachByClone(oldDeliveryPackage);
           oldDeliveryInfoToKafka = DeliveryInfoService.DetachByClone(oldDeliveryInfo, new[] { "PartnerDelivery" });
       }
       ```
     - Các thông tin này sẽ được sử dụng để gửi sự kiện đến Kafka sau khi xử lý hóa đơn

- **Ý nghĩa nghiệp vụ**:
  - Đảm bảo tính nhất quán khi cập nhật hóa đơn (giữ nguyên chi nhánh, xử lý đúng thông tin vận chuyển)
  - Hỗ trợ việc theo dõi thay đổi giữa hóa đơn cũ và hóa đơn mới
  - Xử lý đặc biệt cho việc thay đổi thông tin vận chuyển, thông tin khách hàng
  - Đảm bảo các ràng buộc nghiệp vụ được duy trì khi cập nhật hóa đơn
  - Chuẩn bị dữ liệu cho việc thông báo thay đổi đến các hệ thống bên ngoài (Kafka)

---
**Điều hướng**
- [Quay lại trang chủ](./MakeInvoice-Index.md)
- [Bước trước: Xử lý lô sản phẩm](./4-MakeInvoice-BatchProcessing.md)
- [Bước tiếp theo: Kiểm tra và cảnh báo công nợ khách hàng](./6-MakeInvoice-CustomerDebt.md)