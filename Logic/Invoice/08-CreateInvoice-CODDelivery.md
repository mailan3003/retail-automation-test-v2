# Phân tích Business Logic của phương thức CreateInvoice

### 7. Xử lý thông tin giao hàng COD
- **Xác thực thông tin giao hàng COD**:
  - Hệ thống kiểm tra các điều kiện cần thiết:
    - Hóa đơn sử dụng COD (`invoice.UsingCod == 1`)
    - Có thông tin chi tiết giao hàng (`invoice.DeliveryDetail != null`)
    - Hóa đơn chưa được phát hành (`invoice.Status != (byte)InvoiceState.Issued`)
    - Sử dụng đối tác vận chuyển mặc định (`invoice.DeliveryDetail.UseDefaultPartner`)
    - Đang chuyển từ hóa đơn thường sang hóa đơn giao hàng hoặc không phải cập nhật hóa đơn (`invoice.IsChangeNormalToShippingDelivery || !isUpdateInvoice`)

  - **Xác thực đối tác vận chuyển**:
    - Lấy thông tin đối tác vận chuyển từ mã đối tác: `currentCarrierCom = await KvPartnerDeliveryService.GetAll().FirstOrDefaultAsyncWithTracking(p => p.Code.Equals(req.Invoice.DeliveryDetail.PartnerCode), ExecutionContext)`
    - Kiểm tra tính hợp lệ của đối tác:
      - Đối tác phải đang hoạt động: `currentCarrierCom?.IsActive ?? false`
      - Đối tác phải hỗ trợ nhà bán hàng hiện tại: `!string.IsNullOrEmpty(currentCarrierCom.Scope) && !currentCarrierCom.Scope.Contains(CurrentRetailerCode)`
      - Thiết lập của nhà bán hàng phải cho phép sử dụng COD qua đối tác KiotViet: `!PosSetting.UseCodByKvCarrier`
    - Nếu không thỏa mãn, hiển thị thông báo: "Đối tác giao hàng không hợp lệ. Vui lòng kiểm tra lại." (`throw new KvValidatePartnerDeliveryException(KVMessage.delivery_invalidCarrierCompany)`)

  - **Kiểm tra thông tin bên trả phí vận chuyển**:
    - Yêu cầu phải có thông tin dịch vụ mở rộng: `string.IsNullOrEmpty(invoice.DeliveryDetail.ServiceAdd)`
    - Nếu thiếu thông tin, hiển thị thông báo: "Vui lòng chọn bên trả phí" (`throw new KvValidatePartnerDeliveryException(KVMessage.delivery_InvalidPaymentBy)`)

  - **Xử lý trạng thái vận đơn**:
    - Áp dụng cho hóa đơn mới với điều kiện: `invoice.Id <= 0 && invoice.UsingCod == 1 && invoice.DeliveryDetail != null && (invoice.DeliveryDetail.Status == 3 || invoice.DeliveryDetail.Status == 4)`
    - Chuẩn hóa trạng thái:
      - Nếu trạng thái là 3, chuyển thành trạng thái Pending: `invoice.DeliveryDetail.Status = (byte)DeliveryStatus.Pending`
      - Nếu trạng thái là 4, chuyển thành trạng thái Delivering: `invoice.DeliveryDetail.Status = (byte)DeliveryStatus.Delivering`

- **Lợi ích của cơ chế xử lý COD**:
  - Đảm bảo thông tin vận chuyển và thanh toán COD được xác thực đầy đủ
  - Ngăn chặn việc sử dụng đối tác vận chuyển không hợp lệ hoặc không được hỗ trợ
  - Chuẩn hóa trạng thái vận đơn để phù hợp với quy trình xử lý của hệ thống
  - Tăng tính minh bạch và độ tin cậy trong quá trình giao hàng và thu tiền hộ 

---
**Điều hướng**
- Trước đó: [07-CreateInvoice-UUIDCheck.md](./07-CreateInvoice-UUIDCheck.md)
- Tiếp theo: [09-CreateInvoice-DeliveryAddress.md](./09-CreateInvoice-DeliveryAddress.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 