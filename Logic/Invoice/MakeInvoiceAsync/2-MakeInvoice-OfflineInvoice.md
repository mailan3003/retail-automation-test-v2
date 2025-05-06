# Phân tích Business Logic của phương thức MakeInvoiceAsync

## Các bước xử lý chính

### 19.2. Xử lý hóa đơn offline

- **Mục đích**: Xử lý các hóa đơn được tạo từ thiết bị offline (POS không kết nối) và cần đồng bộ lên hệ thống trung tâm

- **Điều kiện áp dụng**:
  - Hóa đơn có mã bắt đầu bằng tiền tố offline (`HDO_`) hoặc có `DocumentId > 0`
  - Được xác định qua biến `isOfflineInv` trong mã nguồn

- **Quy trình xử lý chi tiết**:
  1. **Kiểm tra các hạn chế của hóa đơn offline**:
     - Kiểm tra phương thức thanh toán:
       ```csharp
       if (invoice.Payments.Any(p => p.Method == "Voucher"))
       {
           throw new KvValidatePaymentException(KVMessage.voucher_khong_thanh_toan_khi_offline);
       }
       ```
     - Kiểm tra chương trình khuyến mãi:
       ```csharp
       if (invoice.InvoicePromotions.Any(i => i.Type == (int) SalePromotionTypes.ProductVoucherGift || i.Type == (int) SalePromotionTypes.InvoiceVoucherGift))
       {
           throw new KvValidateInvoiceException(Labels.voucher_promotion_offline);
       }
       ```
     - Hóa đơn offline không được thanh toán bằng voucher
     - Hóa đơn offline không được áp dụng chương trình khuyến mãi tặng voucher

  2. **Kiểm tra trùng lặp hóa đơn**:
     - Kiểm tra hóa đơn trùng mã:
       ```csharp
       var tempInv = await GetAll().FirstOrDefaultAsync(iv => iv.Code == invoice.Code);
       ```
     - Nếu không tìm thấy theo mã, kiểm tra theo UUID trong khoảng 7 ngày:
       ```csharp
       if (tempInv == null && !string.IsNullOrEmpty(invoice.Uuid))
       {
           var dateCheck = invoice.PurchaseDate;
           if (dateCheck == DateTime.MinValue)
           {
               dateCheck = DateTime.Now; // Fallback to the current date and time
           }
           var startDate = dateCheck.AddDays(-7);
           var endDate = dateCheck.AddDays(7);
           tempInv = await GetAll().FirstOrDefaultAsync(iv => iv.CreatedDate >= startDate && iv.CreatedDate <= endDate && iv.Uuid != null && iv.Uuid.Length > 0 && iv.Uuid == invoice.Uuid);
       }
       ```
     - Nếu tìm thấy hóa đơn trùng lặp:
       + Ghi log nếu mã hóa đơn khác nhau
       + Đánh dấu hóa đơn là trùng lặp (`IsDuplicated = true`)
       + Trả về hóa đơn đã tồn tại

  3. **Xử lý trạng thái giao hàng COD**:
     - Nếu hóa đơn có vận đơn và có thông tin giao hàng:
       ```csharp
       if (invoice.UsingCod == 1 && invoice.DeliveryDetail != null)
       {
           // Hóa đơn cũ có trạng thái giao hàng là Chưa giao hàng
           if (invoice.DeliveryDetail.Status == 3)
           {
               invoice.DeliveryDetail.Status = (byte)DeliveryStatus.Pending;
           }
           // Hóa đơn cũ có trạng thái giao hàng là Đang giao hàng
           else if (invoice.DeliveryDetail.Status == 4)
           {
               invoice.DeliveryDetail.Status = (byte)DeliveryStatus.Delivering;
           }
       }
       ```
     - Chuẩn hóa trạng thái giao hàng:
       + Chuyển đổi trạng thái "Chưa giao hàng" (3) thành "Pending"
       + Chuyển đổi trạng thái "Đang giao hàng" (4) thành "Delivering"

## Luồng xử lý chính

1. **Xác định hóa đơn offline**: 
   - Hóa đơn có mã bắt đầu bằng "HDO_" hoặc có DocumentId > 0
   - Biến `isOfflineInv` được đặt là true

2. **Kiểm tra các điều kiện không hợp lệ**:
   - Không cho phép thanh toán bằng voucher
   - Không cho phép áp dụng khuyến mãi tặng voucher

3. **Kiểm tra trùng lặp hóa đơn**:
   - Kiểm tra theo mã hóa đơn (Code)
   - Nếu không tìm thấy, kiểm tra theo UUID trong khoảng thời gian 7 ngày
   - Nếu tìm thấy hóa đơn trùng lặp, ghi log và trả về hóa đơn đã tồn tại

4. **Xử lý trạng thái giao hàng COD**:
   - Chuẩn hóa trạng thái giao hàng cho phù hợp với hệ thống trung tâm
   - Chuyển đổi trạng thái "Chưa giao hàng" (3) thành "Pending"
   - Chuyển đổi trạng thái "Đang giao hàng" (4) thành "Delivering"

5. **Tiếp tục quy trình xử lý hóa đơn** nếu tất cả các kiểm tra đều thành công

## Các lưu ý quan trọng

- UUID được sử dụng như một cơ chế dự phòng để xác định trùng lặp khi mã hóa đơn có thể khác nhau
- Khi tìm thấy hóa đơn trùng lặp, hệ thống ghi log sự khác biệt về mã hóa đơn để theo dõi
- Việc chuẩn hóa trạng thái giao hàng đảm bảo hóa đơn offline hiển thị đúng trạng thái sau khi đồng bộ
- Việc đồng bộ hóa đơn offline cần được thực hiện cẩn thận để tránh tạo ra các bản ghi trùng lặp

---
**Điều hướng**
- [Quay lại trang chủ](./MakeInvoice-Index.md)
- [Bước trước: Chuẩn bị dữ liệu và chuẩn hóa](./1-MakeInvoice-Initialization.md)
- [Bước tiếp theo: Xác thực đơn hàng](./3-MakeInvoice-OrderValidation.md)