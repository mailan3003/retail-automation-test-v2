# Phân tích Business Logic của phương thức CreateInvoice

## Các bước xử lý chính

### 18.2.3. Tạo và cập nhật hóa đơn

- **Mục đích**: Thực hiện việc lưu hoặc cập nhật thông tin hóa đơn mới vào hệ thống

- **Điều kiện áp dụng**:
  - Áp dụng cho tất cả các hóa đơn mới (invoice.Id <= 0)
  - Có thể là hóa đơn tạo mới hoàn toàn hoặc hóa đơn cập nhật từ hóa đơn cũ

- **Quy trình xử lý chi tiết**:
  1. **Chuẩn bị dữ liệu cho hóa đơn**:
     - Chuẩn bị thông tin chi tiết sản phẩm trong hóa đơn (InvoiceDetails)
     - Chuẩn bị thông tin thanh toán (Payments)
     - Xử lý thông tin giao hàng nếu có (DeliveryInfo, DeliveryPackage)
     - Chuẩn bị các thông tin khác như: khuyến mãi, điểm thưởng, thông tin đơn thuốc...

  2. **Gọi phương thức tạo hóa đơn**:
     - Gọi phương thức `InvoiceService.MakeInvoiceAsync()` với các tham số phù hợp (xem chi tiết tại [MakeInvoice-Index.md](../MakeInvoiceAsync/MakeInvoice-Index.md)):
       + `updateOnHand`: Chỉ định có cập nhật số lượng tồn kho không (true/false)
         * Thường đặt là `true` nếu hóa đơn ảnh hưởng đến tồn kho
         * Đặt là `false` trong trường hợp đặc biệt như đồng bộ hóa đơn offline
       + `isNewInvoice`: Đánh dấu đây là hóa đơn mới (true)
       + `fromCombine`: Đánh dấu nếu hóa đơn được tạo từ việc kết hợp nhiều hóa đơn (false, trừ khi được chỉ định)
       + `omniOnlineFieldObject`: Cung cấp thông tin bổ sung cho kênh bán hàng đa kênh

  3. **Xử lý nghiệp vụ trong `MakeInvoiceAsync()`**:
     - Kiểm tra tính hợp lệ của hóa đơn (các điều kiện về số lượng, giá...)
     - Kiểm tra tính hợp lệ của thông tin thanh toán
     - Tạo mã hóa đơn mới (nếu là hóa đơn mới hoàn toàn)
     - Tính toán lại tổng tiền, chiết khấu, thuế... cho hóa đơn
     - Xử lý khuyến mãi và voucher nếu có
     - Tạo các bản ghi thanh toán liên quan đến hóa đơn
     - Cập nhật thông tin giao hàng nếu có

  4. **Xử lý các thao tác liên quan**:
     - Cập nhật trạng thái đơn hàng nếu hóa đơn được tạo từ đơn hàng
     - Cập nhật điểm tích lũy cho khách hàng nếu có
     - Xử lý hàng tồn kho (trừ hàng tồn kho nếu updateOnHand = true)
     - Ghi log về thay đổi của hệ thống

  5. **Hoàn thành và trả về kết quả**:
     - Lưu hóa đơn vào cơ sở dữ liệu
     - Trả về thông tin hóa đơn đã tạo cho người dùng
     - Xử lý các thông báo sau khi tạo hóa đơn thành công

- **Xử lý nâng cao**:
  1. **Xử lý đơn thuốc (prescription)**:
     - Nếu hóa đơn có liên quan đến đơn thuốc, thực hiện các xử lý đặc biệt:
       + Lưu thông tin bệnh nhân (Patient)
       + Lưu thông tin đơn thuốc (Prescription)
       + Tạo liên kết giữa hóa đơn và đơn thuốc

  2. **Xử lý phân bổ công nợ**:
     - Nếu cấu hình `AppServiceConfigInfo.IsAutoPaymentAllocation = true`:
       + Thực hiện phân bổ công nợ tự động cho hóa đơn
       + Tạo các bản ghi phân bổ thanh toán (PaymentAllocation)
       + Cập nhật trạng thái công nợ cho khách hàng

  3. **Xử lý Event Tracking**:
     - Tạo các sự kiện theo dõi cho hóa đơn và thanh toán
     - Sử dụng `TrackingHelper` để theo dõi các thay đổi
     - Gửi thông tin đến hệ thống Elasticsearch để lưu trữ và tìm kiếm

  4. **Đồng bộ với hệ thống bên ngoài**:
     - Gửi thông tin hóa đơn đến các hệ thống liên kết (nếu có)
     - Đồng bộ với hệ thống dược quốc gia nếu có yêu cầu

- **Quy trình xử lý sau khi tạo hóa đơn**:
  - Nếu tạo hóa đơn thành công:
    + Trả về thông tin hóa đơn đã tạo cho người dùng
    + Hiển thị thông báo thành công
    + Cập nhật lại các màn hình liên quan (giỏ hàng, danh sách hóa đơn...)
  - Nếu tạo hóa đơn thất bại:
    + Hiển thị thông báo lỗi cho người dùng
    + Không thực hiện các thao tác ảnh hưởng đến dữ liệu
    + Giữ nguyên trạng thái hiện tại của hệ thống

- **Ý nghĩa nghiệp vụ**:
  - Đảm bảo tính toàn vẹn của dữ liệu khi tạo hóa đơn mới
  - Xử lý đồng bộ các thao tác liên quan (tồn kho, công nợ, điểm thưởng...)
  - Cung cấp quy trình hoàn chỉnh từ việc tạo hóa đơn đến các xử lý sau tạo hóa đơn
  - Hỗ trợ nhiều kịch bản nghiệp vụ khác nhau (bán lẻ, bán sỉ, kê đơn thuốc...)

---
**Điều hướng**
- Quay lại: [18-2-CreateInvoice-CreateNewInvoice.md](./18-2-CreateInvoice-CreateNewInvoice.md)
- Trước đó: [18-2-2-VoidDeliveryOrder.md](./18-2-2-VoidDeliveryOrder.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 