# Phân tích Business Logic của phương thức MakeInvoiceAsync

## Các bước xử lý chính

### 19.2. Xử lý hóa đơn offline

- **Mục đích**: Xử lý các hóa đơn được tạo từ thiết bị offline (POS không kết nối) và cần đồng bộ lên hệ thống trung tâm

- **Điều kiện áp dụng**:
  - Hóa đơn có mã bắt đầu bằng tiền tố offline (`OFF_`) hoặc có `DocumentId > 0`
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
     - Nếu hóa đơn sử dụng COD và có thông tin giao hàng:
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

## Kịch bản kiểm thử

### 1. Kiểm tra phương thức thanh toán với hóa đơn offline

| Kịch bản | Dữ liệu đầu vào | Kết quả mong đợi |
|----------|----------------|-----------------|
| 1.1. Hóa đơn offline không sử dụng voucher | Hóa đơn offline với phương thức thanh toán là tiền mặt/thẻ | Thành công: Hệ thống xử lý tiếp |
| 1.2. Hóa đơn offline sử dụng voucher | Hóa đơn offline với phương thức thanh toán là voucher | Lỗi: "Bạn không thể thanh toán hóa đơn bằng voucher ở chế độ offline" |

**Bước thực hiện**:
1. Tạo hóa đơn với mã bắt đầu bằng "OFF_"
2. Thêm phương thức thanh toán là voucher
3. Thử lưu hóa đơn
4. Kiểm tra thông báo lỗi hiển thị

### 2. Kiểm tra chương trình khuyến mãi với hóa đơn offline

| Kịch bản | Dữ liệu đầu vào | Kết quả mong đợi |
|----------|----------------|-----------------|
| 2.1. Hóa đơn offline không áp dụng khuyến mãi tặng voucher | Hóa đơn offline với khuyến mãi thông thường (giảm giá) | Thành công: Hệ thống xử lý tiếp |
| 2.2. Hóa đơn offline áp dụng khuyến mãi tặng voucher | Hóa đơn offline có áp dụng khuyến mãi tặng voucher | Lỗi: "Chương trình khuyến mãi tặng voucher không thể áp dụng khi đang ở chế độ offline" |

**Bước thực hiện**:
1. Tạo hóa đơn với mã bắt đầu bằng "OFF_"
2. Áp dụng chương trình khuyến mãi tặng voucher
3. Thử lưu hóa đơn
4. Kiểm tra thông báo lỗi hiển thị

### 3. Kiểm tra trùng lặp hóa đơn offline

| Kịch bản | Dữ liệu đầu vào | Kết quả mong đợi |
|----------|----------------|-----------------|
| 3.1. Hóa đơn offline với mã chưa tồn tại | Hóa đơn offline với mã mới | Thành công: Hệ thống tạo hóa đơn mới |
| 3.2. Hóa đơn offline với mã đã tồn tại | Hóa đơn offline với mã đã tồn tại trong hệ thống | Thành công: Hệ thống trả về hóa đơn đã tồn tại và đánh dấu là trùng lặp |
| 3.3. Hóa đơn offline với UUID đã tồn tại | Hóa đơn offline với UUID đã tồn tại (trong khoảng 7 ngày) | Thành công: Hệ thống trả về hóa đơn đã tồn tại và đánh dấu là trùng lặp |

**Bước thực hiện**:
1. Tạo hóa đơn offline với mã hoặc UUID đã tồn tại
2. Đồng bộ hóa đơn lên hệ thống
3. Kiểm tra kết quả trả về (hóa đơn được đánh dấu trùng lặp)

### 4. Kiểm tra đồng bộ trạng thái giao hàng cho hóa đơn offline

| Kịch bản | Dữ liệu đầu vào | Kết quả mong đợi |
|----------|----------------|-----------------|
| 4.1. Hóa đơn offline COD với trạng thái "Chưa giao hàng" | Hóa đơn offline sử dụng COD (UsingCod = 1) và trạng thái giao hàng là 3 | Thành công: Hệ thống chuyển trạng thái thành "Pending" |
| 4.2. Hóa đơn offline COD với trạng thái "Đang giao hàng" | Hóa đơn offline sử dụng COD (UsingCod = 1) và trạng thái giao hàng là 4 | Thành công: Hệ thống chuyển trạng thái thành "Delivering" |

**Bước thực hiện**:
1. Tạo hóa đơn offline sử dụng COD
2. Thiết lập trạng thái giao hàng
3. Đồng bộ hóa đơn lên hệ thống
4. Kiểm tra trạng thái giao hàng sau khi đồng bộ

## Bảng tổng hợp lỗi

| Mã lỗi | Thông báo | Nguyên nhân |
|--------|-----------|------------|
| KvValidatePaymentException | "Bạn không thể thanh toán hóa đơn bằng voucher ở chế độ offline" | Hóa đơn offline sử dụng phương thức thanh toán voucher |
| KvValidateInvoiceException | "Chương trình khuyến mãi tặng voucher không thể áp dụng khi đang ở chế độ offline" | Hóa đơn offline áp dụng khuyến mãi tặng voucher |

## Luồng xử lý chính

1. **Xác định hóa đơn offline**: 
   - Hóa đơn có mã bắt đầu bằng "OFF_" hoặc có DocumentId > 0
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