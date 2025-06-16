# Phân tích Business Logic của phương thức MakeInvoiceAsync

## Các bước xử lý chính

### 19.7. Xác thực mã khuyến mãi và voucher

- **Mục đích**: Kiểm tra và xác thực các mã khuyến mãi (coupon) và phiếu quà tặng (voucher) được áp dụng trong hóa đơn

- **Điều kiện áp dụng**:
  - Áp dụng khi hóa đơn có sử dụng mã khuyến mãi (Coupon) hoặc voucher
  - Xác minh tính hợp lệ của mã trước khi áp dụng vào hóa đơn

- **Quy trình xử lý chi tiết**:
  1. **Xác thực mã khuyến mãi (Coupon)**:
     - Gọi phương thức xác thực coupon:
       ```csharp
       await ValidateCoupon(invoice);
       ```
     - Quy trình xác thực coupon bao gồm:
       + Kiểm tra coupon có tồn tại trong hệ thống không
       + Kiểm tra thời hạn sử dụng của coupon
       + Kiểm tra điều kiện áp dụng (giá trị đơn hàng tối thiểu, loại sản phẩm áp dụng...)
       + Kiểm tra số lần sử dụng của coupon (tổng và theo từng khách hàng)
       + Xác thực mã coupon phải thuộc về chương trình coupon hợp lệ
       + Tính toán giá trị khuyến mãi từ coupon được áp dụng

  2. **Xác thực phiếu quà tặng (Voucher)**:
     - Gọi phương thức xác thực voucher:
       ```csharp
       await ValidateVoucher(invoice, fromCombine);
       ```
     - Phương thức `ValidateVoucher` thực hiện:
       + Kiểm tra các thanh toán có sử dụng voucher:
         ```csharp
         var voucherPayments = invoice.Payments?.Where(p => p.Method == "Voucher" && p.VoucherId > 0)?.ToList();
         ```
       + Nếu không có thanh toán bằng voucher, kết thúc kiểm tra
       + Với mỗi thanh toán bằng voucher, kiểm tra:
         * Voucher có tồn tại trong hệ thống không
         * Trạng thái voucher có hợp lệ (chưa sử dụng)
         * Thời hạn sử dụng voucher
         * Giá trị thanh toán không vượt quá giá trị voucher
         * Voucher thuộc về chiến dịch voucher hợp lệ
         * Voucher đã được kích hoạt (nếu yêu cầu)
         * Các ràng buộc đặc biệt của chương trình voucher

  3. **Xử lý lỗi và ngoại lệ**:
     - Nếu phát hiện lỗi trong quá trình xác thực, ném ra ngoại lệ tương ứng:
       + `KvValidateCouponException`: Lỗi liên quan đến mã khuyến mãi
       + `KvValidateVoucherException`: Lỗi liên quan đến phiếu quà tặng
     - Thông báo lỗi cụ thể cho người dùng (mã hết hạn, đã sử dụng, không đủ điều kiện...)

  4. **Cập nhật thông tin khuyến mãi**:
     - Sau khi xác thực thành công, cập nhật thông tin khuyến mãi cho hóa đơn:
       + Cập nhật giá trị giảm giá từ coupon (`invoice.DiscountByCoupon`)
       + Gán thông tin chương trình khuyến mãi vào hóa đơn
       + Chuẩn bị dữ liệu để theo dõi việc sử dụng coupon/voucher

- **Quy trình xử lý đặc biệt**:
  - Đối với hóa đơn được tạo từ việc kết hợp (fromCombine = true):
    + Có thể áp dụng xử lý đặc biệt cho việc xác thực voucher
    + Kiểm tra tính hợp lệ của việc kết hợp các voucher từ nhiều hóa đơn

  - Đối với voucher quà tặng (gift voucher):
    + Được tạo từ chương trình khuyến mãi
    + Cần lưu thông tin để giải phóng voucher sau khi tạo hóa đơn thành công

- **Ý nghĩa nghiệp vụ**:
  - Đảm bảo tính hợp lệ của các chương trình khuyến mãi và quà tặng
  - Ngăn chặn việc sử dụng lại mã đã hết hạn hoặc đã sử dụng
  - Đảm bảo tuân thủ các quy tắc kinh doanh về chiết khấu
  - Hỗ trợ các chiến lược tiếp thị và khuyến mãi của doanh nghiệp
  - Tạo trải nghiệm mua sắm tốt hơn cho khách hàng

- **Lưu ý đặc biệt**:
  - Việc xác thực voucher/coupon diễn ra trước khi lưu hóa đơn vào cơ sở dữ liệu
  - Các chương trình khuyến mãi có thể có quy tắc phức tạp về thời gian, đối tượng áp dụng, sản phẩm...
  - Cần xử lý cẩn thận để tránh lạm dụng hoặc gian lận trong việc sử dụng mã

---
**Điều hướng**
- [Quay lại trang chủ](./MakeInvoice-Index.md)
- [Bước trước: Kiểm tra và cảnh báo công nợ khách hàng](./6-MakeInvoice-CustomerDebt.md)
- [Bước tiếp theo: Tạo hóa đơn và xử lý thanh toán](./8-MakeInvoice-InvoicePayment.md)