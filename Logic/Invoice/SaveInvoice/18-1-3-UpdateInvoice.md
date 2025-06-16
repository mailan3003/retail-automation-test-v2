# Phân tích Business Logic của phương thức UpdateInvoiceAsync

## Tổng quan

Phương thức `UpdateInvoiceAsync` là một phương thức quan trọng trong hệ thống KiotViet, được sử dụng để cập nhật thông tin hóa đơn. Phương thức này xử lý nhiều khía cạnh khác nhau của hóa đơn bao gồm thông tin giao hàng, thanh toán, và các trạng thái liên quan. Chi tiết về quy trình kiểm tra tính hợp lệ của hóa đơn có thể được tìm thấy trong [1-ValidateInvoice.md](../UpdateInvoiceAsync/1-ValidateInvoice.md).

## Tham số đầu vào

- **invoice**: Đối tượng hóa đơn cần cập nhật
- **isUpdatePayment**: Xác định có cập nhật thông tin thanh toán hay không
- **isVoidDeliveryPayment**: Xác định có hủy thanh toán giao hàng hay không (mặc định là false)
- **isForceUpdateBranchTakingAddr**: Xác định có bắt buộc cập nhật địa chỉ chi nhánh nhận hàng hay không (mặc định là false)
- **isSkipUpdateShippingDelivery**: Xác định có bỏ qua cập nhật thông tin giao hàng hay không (mặc định là true)
- **deliveryReturnedDate**: Ngày trả hàng (mặc định là giá trị mặc định của DateTime)

## Các file liên quan

- [1-ValidateInvoice.md](../UpdateInvoiceAsync/1-ValidateInvoice.md)
- [2-NormalizeInvoiceDetail.md](../UpdateInvoiceAsync/2-NormalizeInvoiceDetail.md)
- [3-UpdateInvoiceStatus.md](../UpdateInvoiceAsync/3-UpdateInvoiceStatus.md)
- [4-ProcessDeliveryInfo.md](../UpdateInvoiceAsync/4-ProcessDeliveryInfo.md)
- [5-ProcessCODReturn.md](../UpdateInvoiceAsync/5-ProcessCODReturn.md)
- [6-ValidateCurrency.md](../UpdateInvoiceAsync/6-ValidateCurrency.md)
- [7-ProcessPayment.md](../UpdateInvoiceAsync/7-ProcessPayment.md)
- [8-UpdateInvoiceInfo.md](../UpdateInvoiceAsync/8-UpdateInvoiceInfo.md)
- [9-ProcessPurchaseDate.md](../UpdateInvoiceAsync/9-ProcessPurchaseDate.md)
- [10-ProcessSpecialCases.md](../UpdateInvoiceAsync/10-ProcessSpecialCases.md)

## Điều hướng
- Quay lại: [18-1-CreateInvoice-UpdateExistingInvoice-Index.md](./18-1-CreateInvoice-UpdateExistingInvoice-Index.md)
- Trước đó: [18-1-2-ProcessExpiredShippingTasks.md](./18-1-2-ProcessExpiredShippingTasks.md)
- Tiếp theo: [18-1-4-KShipV4Handling.md](./18-1-4-KShipV4Handling.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 