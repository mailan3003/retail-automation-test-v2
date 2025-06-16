# Phân tích Business Logic của phương thức MakeInvoiceAsync

## Tổng quan
Phương thức `MakeInvoiceAsync` là hàm core xử lý chính của quá trình tạo hóa đơn, được gọi từ `DoMakeInvoiceAsync`. Phương thức này xử lý tất cả các logic nghiệp vụ liên quan đến việc tạo và lưu hóa đơn vào cơ sở dữ liệu.

## Các bước xử lý chính

1. [Chuẩn bị dữ liệu và chuẩn hóa](./1-MakeInvoice-Initialization.md)
2. [Xử lý hóa đơn offline](./2-MakeInvoice-OfflineInvoice.md)
3. [Xác thực đơn hàng](./3-MakeInvoice-OrderValidation.md)
4. [Xử lý lô sản phẩm](./4-MakeInvoice-BatchProcessing.md)
5. [Xử lý cập nhật hóa đơn](./5-MakeInvoice-UpdateInvoice.md)
6. [Kiểm tra và cảnh báo công nợ khách hàng](./6-MakeInvoice-CustomerDebt.md)
7. [Xác thực mã khuyến mãi và voucher](./7-MakeInvoice-CouponVoucher.md)
8. [Tạo hóa đơn và xử lý thanh toán](./8-MakeInvoice-InvoicePayment.md)
9. [Xử lý giao hàng](./9-MakeInvoice-DeliveryProcessing.md)
10. [Cập nhật đơn hàng và tài liệu](./10-MakeInvoice-OrderDocumentUpdate.md)
11. [Phân bổ thanh toán](./11-MakeInvoice-PaymentAllocation.md)
12. [Theo dõi sự kiện](./12-MakeInvoice-EventTracking.md)

## Mô hình thực thi
Phương thức `MakeInvoiceAsync` được thiết kế theo mô hình pipeline, trong đó mỗi bước xử lý đều phụ thuộc vào kết quả của bước trước đó. Hóa đơn đi qua từng bước xử lý, được kiểm tra, xác thực và bổ sung thông tin tại mỗi bước.

## Tham số đầu vào
- `invoice`: Đối tượng hóa đơn cần xử lý
- `updateOnHand`: Cờ xác định có cập nhật số lượng tồn kho không
- `isNewInvoice`: Cờ xác định đây có phải là hóa đơn mới không
- `fromCombine`: Cờ xác định hóa đơn có được tạo từ việc kết hợp không
- `omniOnlineFieldObject`: Thông tin bổ sung cho kênh bán hàng đa kênh

## Kết quả trả về
- Đối tượng `Invoice` đã được xử lý và lưu vào cơ sở dữ liệu