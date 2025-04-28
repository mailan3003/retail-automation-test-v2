# Phân tích Business Logic của phương thức CreateInvoice - Index File

## Danh mục các bước xử lý

1. [Tổng quan](./01-CreateInvoice-Overview.md)
2. [Khởi tạo và chuẩn bị dữ liệu](./02-CreateInvoice-VerifyInitData.md)
3. [Kiểm tra hóa đơn trùng lặp](./03-CreateInvoice-DuplicateInvoice.md)
4. [Xử lý hóa đơn cập nhật](./04-CreateInvoice-UpdateInvoice.md)
5. [Kiểm tra xung đột phiên bản](./05-CreateInvoice-VersionConflict.md)
6. [Kiểm tra khuyến mãi](./06-CreateInvoice-PromotionCheck.md)
7. [Kiểm tra UUID](./07-CreateInvoice-UUIDCheck.md)
8. [Xử lý thông tin giao hàng COD](./08-CreateInvoice-CODDelivery.md)
9. [Xử lý thông tin địa chỉ giao hàng](./09-CreateInvoice-DeliveryAddress.md)
10. [Kiểm tra thông tin khách hàng và kênh bán hàng](./10-CreateInvoice-CustomerAndChannel.md)
11. [Kiểm tra thời gian giao hàng dự kiến](./11-CreateInvoice-DeliveryTime.md)
12. [Kiểm tra giới hạn sử dụng khuyến mãi](./12-CreateInvoice-PromotionLimits.md)
13. [Xử lý thông tin đơn thuốc (cho nhà thuốc GPP)](./13-CreateInvoice-Prescription.md)
14. [Kiểm tra người bán hàng](./14-CreateInvoice-SalesPersonCheck.md)
15. [Kiểm tra thông tin thanh toán](./15-CreateInvoice-PaymentValidation.md)
16. [Kiểm tra thông tin khách hàng và xử lý thông tin giao hàng](./16-CreateInvoice-CustomerDelivery.md)
17. [Kiểm tra kho hàng](./17-CreateInvoice-WarehouseCheck.md)
18. [Lưu hoặc cập nhật hóa đơn](./CreateInvoice.md#17-lưu-hoặc-cập-nhật-hóa-đơn)

Mỗi file chứa thông tin chi tiết về một bước xử lý cụ thể trong quy trình tạo/cập nhật hóa đơn của hệ thống KiotViet. Các bước này được thực hiện tuần tự để đảm bảo hóa đơn hợp lệ trước khi lưu vào cơ sở dữ liệu. 