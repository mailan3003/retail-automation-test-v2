# Phân tích Business Logic của phương thức CreateInvoice

## Các bước xử lý chính

### 18.1.3. Cập nhật hóa đơn

Sau khi xử lý các tác vụ vận chuyển, hệ thống tiến hành cập nhật thông tin hóa đơn trong cơ sở dữ liệu.

#### Gọi phương thức cập nhật hóa đơn

- **Phương thức sử dụng**: `InvoiceService.UpdateInvoiceAsync()`
- **Tham số truyền vào**:
  - `invoice`: Đối tượng hóa đơn cần cập nhật
  - `isUpdatePayment`: Xác định có cập nhật thông tin thanh toán hay không
  - `isVoidDeliveryPayment`: Xác định có hủy thanh toán giao hàng hay không (mặc định là false)
  - `isForceUpdateBranchTakingAddr`: Xác định có bắt buộc cập nhật địa chỉ chi nhánh nhận hàng hay không (mặc định là false)
  - `isSkipUpdateShippingDelivery`: Xác định có bỏ qua cập nhật thông tin giao hàng hay không (mặc định là true)
  - `deliveryReturnedDate`: Ngày trả hàng (mặc định là giá trị mặc định của DateTime)

#### Quy trình xử lý cập nhật hóa đơn

##### 1. Kiểm tra sự tồn tại của hóa đơn
- Truy vấn cơ sở dữ liệu để kiểm tra sự tồn tại của hóa đơn
- Nếu không tìm thấy, ném ngoại lệ với thông báo "Dữ liệu này không còn tồn tại trên hệ thống. Vui lòng kiểm tra lại"
- Đảm bảo hóa đơn vẫn còn hiệu lực trong hệ thống trước khi cập nhật

##### 2. Chuẩn hóa chi tiết hóa đơn
- **Xử lý trùng lặp UUID**:
  - Tạo một HashSet để lưu trữ và kiểm tra các UUID đã xuất hiện
  - Duyệt qua từng dòng chi tiết hóa đơn:
    + Bỏ qua những dòng không có UUID
    + Kiểm tra nếu UUID đã tồn tại trong danh sách
    + Nếu trùng lặp, thêm chữ "U" vào cuối UUID cho đến khi tạo được UUID duy nhất
    + Lưu UUID vào danh sách để tránh trùng lặp trong các dòng tiếp theo
  - Mục đích: Đảm bảo tính duy nhất của UUID trong chi tiết hóa đơn

##### 3. Cập nhật trạng thái cũ của hóa đơn
- **Xử lý đặc biệt cho hóa đơn COD**:
  - Điều kiện: **UsingCod = 1** (sử dụng COD) và trạng thái là 4 (đang trả hàng)
  - Hành động:
    + Đặt lại trạng thái hóa đơn thành "Chờ xử lý" (InvoiceState.Pending)
    + Nếu có thông tin giao hàng (DeliveryDetail), cập nhật trạng thái giao hàng thành "Đang giao" (DeliveryStatus.Delivering)
  - Mục đích: Đảm bảo trạng thái phù hợp cho hóa đơn COD trong quá trình giao hàng

##### 4. Xử lý thông tin giao hàng
- **Chuyển đổi thông tin giao hàng**:
  - Gọi phương thức `ConvertInvoiceDelivery()` để chuẩn hóa thông tin giao hàng
  - Xử lý các trường thông tin địa chỉ, thời gian giao hàng dự kiến, v.v.

- **Gán đối tác giao hàng mặc định**:
  - Gọi phương thức `AssignPartnerDeliveryDefault()` để thiết lập đối tác giao hàng mặc định (nếu cần)
  - Xử lý logic lựa chọn đối tác giao hàng phù hợp dựa trên cấu hình hệ thống

##### 5. Xử lý đặc biệt cho hóa đơn COD bị trả hàng
- **Điều kiện áp dụng**:
  - Hóa đơn đã tồn tại (Id > 0)
  - Sử dụng COD (UsingCod = 1)
  - Có thông tin giao hàng
  - Trạng thái giao hàng là "Đã trả hàng"
  - Cấu hình thời gian khóa Redis cho cập nhật trả hàng > 0

- **Cơ chế xử lý**:
  - Sử dụng khóa Redis để đảm bảo xử lý tuần tự
  - Khóa có định dạng: "DeliveryInfoService.DoConfirmStatusReturned_{RetailerId}_{InvoiceId}"
  - Thời gian khóa dựa trên cấu hình RedisLockUpdateDeliveryReturnedTimeout (tính bằng phút)
  - Mục đích: Tránh xung đột khi nhiều người cùng cập nhật trạng thái trả hàng

##### 6. Kiểm tra tính hợp lệ của hóa đơn
- **Kiểm tra tiền tệ hiện tại**:
  - Lấy thông tin tiền tệ từ `NumberHelper.GetCurrentCurrency()`
  - Đảm bảo tính nhất quán về đơn vị tiền tệ

- **Kiểm tra tính hợp lệ của hóa đơn COD**:
  - Điều kiện kiểm tra:
    + Hóa đơn có sử dụng COD (UsingCod = 1)
    + Có thông tin giao hàng (DeliveryDetail không null)
    + Chưa chọn đối tác giao hàng (DeliveryBy = null)
    + Hóa đơn đang ở một trong các trạng thái vận chuyển (đang giao, đã giao, đang trả, đã trả...)
  - Nếu tất cả điều kiện được thỏa mãn, hiển thị thông báo lỗi "Chưa nhập đối tác giao hàng"
  - Đảm bảo hóa đơn COD trong quá trình vận chuyển phải có thông tin đối tác giao hàng

- **Kiểm tra nguồn gốc hóa đơn**:
  - Xác định hóa đơn có phải từ OmniChannel không thông qua `PosOnlineHelper.IsInvoiceOmni()`
  - Kiểm tra mã hóa đơn có bắt đầu bằng các tiền tố của các sàn thương mại điện tử hay không (DHSPE, DHTTS, DHLZD, v.v.)

- **Lấy và so sánh thông tin hóa đơn hiện tại**:
  - Truy vấn thông tin hóa đơn hiện tại từ cơ sở dữ liệu
  - So sánh để xác định các thay đổi về tổng tiền, trạng thái, thông tin thanh toán, v.v.

##### 7. Kiểm tra và cập nhật thông tin thanh toán
- **Điều kiện cập nhật**:
  - Chỉ cập nhật khi **isUpdatePayment = true**
  - Có danh sách thanh toán (invoice.Payments) không rỗng

- **Các thông tin cập nhật**:
  - Đồng bộ ngày giao dịch thanh toán với ngày mua hàng
  - Cập nhật thông tin người thanh toán
  - Cập nhật phương thức thanh toán
  - Xử lý thanh toán COD (nếu có)

- **Ghi nhận lịch sử**:
  - Lưu lại các thay đổi về thanh toán vào nhật ký hệ thống

##### 8. Cập nhật thông tin hóa đơn
- **Cập nhật ngày hết hạn bảo hành** (nếu có)
- **Tính toán lại tổng tiền hóa đơn**
- **Cập nhật PaymentTrack** nếu trạng thái hoặc ngày thay đổi
- **Gửi sự kiện cập nhật đến Elasticsearch** để cập nhật dữ liệu tìm kiếm

##### 9. Xử lý đặc biệt khi ngày thay đổi
- **Điều kiện xử lý**:
  - Ngày mua hàng thay đổi
  - Hoặc là hóa đơn OmniChannel với tổng tiền thay đổi

- **Hành động**:
  - Xây dựng danh sách theo dõi thay đổi
  - Thêm vào hàng đợi theo dõi để xử lý đồng bộ
  - Mục đích: Đảm bảo các hệ thống liên quan được cập nhật khi thông tin quan trọng thay đổi

#### Kết quả cập nhật
- Trả về đối tượng hóa đơn đã cập nhật với đầy đủ thông tin mới
- Cập nhật thông tin liên quan trong cơ sở dữ liệu
- Đảm bảo tính nhất quán của dữ liệu trên toàn hệ thống

---
**Điều hướng**
- Quay lại: [18-1-CreateInvoice-UpdateExistingInvoice-Index.md](./18-1-CreateInvoice-UpdateExistingInvoice-Index.md)
- Trước đó: [18-1-2-ProcessExpiredShippingTasks.md](./18-1-2-ProcessExpiredShippingTasks.md)
- Tiếp theo: [18-1-4-KShipV4Handling.md](./18-1-4-KShipV4Handling.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 