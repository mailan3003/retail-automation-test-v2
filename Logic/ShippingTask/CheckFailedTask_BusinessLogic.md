# Tài liệu phân tích Business Logic: CheckFailedTask

## Mục đích
Phương thức `CheckFailedTask` được sử dụng để kiểm tra trạng thái của các nhiệm vụ vận chuyển (shipping tasks) và xử lý các trường hợp thất bại do quá thời gian hoặc các vấn đề khác.

## Tham số đầu vào
- `stod`: Danh sách các ID của nhiệm vụ vận chuyển cần kiểm tra
- `timeOut`: Giá trị thời gian tối đa cho phép (tính bằng phút)
- `checkExistedInvoices`: Cờ boolean xác định có kiểm tra hóa đơn đã tồn tại hay không (mặc định là false)
- `invoiceCodes`: Mã hóa đơn (tùy chọn)
- `invoiceIds`: Danh sách ID hóa đơn (tùy chọn)

## Luồng xử lý chính

### 1. Kiểm tra trạng thái nhiệm vụ đang xử lý (Processing)
- Lấy ID nhà bán lẻ (retailerId) từ context xác thực
- Truy vấn danh sách nhiệm vụ vận chuyển dựa trên các ID được cung cấp
- Lọc ra các nhiệm vụ được tạo trong khoảng thời gian ít hơn `timeOut`
- Nếu có bất kỳ nhiệm vụ nào trong trạng thái "Processing", ném ngoại lệ `KvValidateException` với thông báo "Hệ thống đang trong quá trình tạo vận đơn với hãng vận chuyển cho hóa đơn này. Bạn vui lòng thử lại sau" (`KVMessage.shippingTaskBlockMsg`)

### 2. Kiểm tra hóa đơn đã tồn tại (nếu được yêu cầu)
- Kiểm tra các điều kiện sau:
  - `checkExistedInvoices` là true (yêu cầu kiểm tra hóa đơn đã tồn tại)
  - `invoiceCodes` không rỗng (có mã hóa đơn được cung cấp)
  - `stAfter` không null và có ít nhất một nhiệm vụ ở trạng thái "Completed"
  - `invoiceIds` không null và có ít nhất một ID hóa đơn
- Nếu tất cả điều kiện trên đều thỏa mãn:
  - Truy vấn cơ sở dữ liệu để kiểm tra xem có tồn tại thông tin giao hàng nào thỏa mãn các điều kiện:
    - Thuộc về nhà bán lẻ hiện tại (`RetailerId` = retailerId)
    - Có liên kết với một trong các hóa đơn được cung cấp (`InvoiceId` nằm trong danh sách `invoiceIds`)
    - Đang hoạt động (`IsCurrent` = true)
    - Sử dụng đối tác vận chuyển mặc định (`UseDefaultPartner` = true)
    - Không ở trạng thái Void (`Status` khác DeliveryStatus.Void)
  - Nếu tìm thấy bất kỳ thông tin giao hàng nào thỏa mãn, ném ngoại lệ `KvValidateException` với thông báo "Hóa đơn {mã hóa đơn} đã được tạo vận đơn trước đó" (sử dụng `KVMessage.shippingTaskExistedInvoicesMsg` với tham số là `invoiceCodes`)

### 3. Cập nhật trạng thái thất bại
- Gọi phương thức `UpdateStatusFailed` để cập nhật trạng thái của các nhiệm vụ đã quá thời gian

## Chi tiết về phương thức UpdateStatusFailed

### 1. Xác định các nhiệm vụ đã quá thời gian
- Phương thức nhận vào danh sách ID nhiệm vụ (`stod`), thời gian tối đa (`timeOut`) và danh sách nhiệm vụ tùy chọn (`st`)
- Nếu danh sách nhiệm vụ (`st`) không được cung cấp, phương thức sẽ truy vấn từ cơ sở dữ liệu để lấy các nhiệm vụ thuộc về retailer hiện tại, có ID nằm trong danh sách `stod` và đang ở trạng thái "Processing"
- Sau đó, lọc ra các nhiệm vụ đang ở trạng thái "Processing" và thời gian xử lý đã vượt quá `timeOut` phút (tính từ thời điểm tạo nhiệm vụ)

### 2. Xử lý các nhiệm vụ đã quá thời gian
- Nếu có nhiệm vụ quá thời gian, phương thức sẽ lấy ID của retailer hiện tại từ context xác thực
- Truy vấn các chi tiết đơn hàng vận chuyển (ShippingTaskOrderDetails) chưa hoàn thành liên quan đến các nhiệm vụ quá thời gian
- Lấy danh sách ID thông tin giao hàng (DeliveryInfo) từ các chi tiết đơn hàng chưa hoàn thành
- Truy vấn thông tin giao hàng từ cơ sở dữ liệu, chỉ lấy những bản ghi thuộc về retailer hiện tại, có ID nằm trong danh sách đã lấy, đang sử dụng đối tác vận chuyển mặc định (`UseDefaultPartner` = true) và đang hoạt động (`IsCurrent` = true)
- Lưu lại danh sách ID đối tác vận chuyển từ thông tin giao hàng
- Tạo bản sao của danh sách thông tin giao hàng để sử dụng sau này
- Đối với mỗi thông tin giao hàng, loại bỏ liên kết với đối tác vận chuyển mặc định bằng cách đặt `DeliveryBy` = null và `UseDefaultPartner` = null, sau đó cập nhật vào cơ sở dữ liệu (chưa lưu ngay)
- Đối với mỗi nhiệm vụ quá thời gian, cập nhật trạng thái sang "Error", thêm thông báo về việc quá thời gian, cập nhật thông tin người sửa đổi và thời gian sửa đổi, sau đó cập nhật vào cơ sở dữ liệu (chưa lưu ngay)
- Lưu tất cả các thay đổi vào cơ sở dữ liệu

### 3. Xử lý thông báo và hủy đơn hàng (nếu được cấu hình)
- Nếu có thông tin giao hàng bị ảnh hưởng, phương thức sẽ thực hiện các xử lý bổ sung dựa trên cấu hình hệ thống:

  #### a. Xử lý khi `ShippingUseConfirmMultipleOrderTimeout` được bật:
  - Lọc ra các nhiệm vụ có BatchId không rỗng
  - Lấy danh sách ID thông tin giao hàng bị ảnh hưởng
  - Lấy danh sách ID hóa đơn từ thông tin giao hàng
  - Truy vấn mã hóa đơn từ cơ sở dữ liệu
  - Đối với mỗi nhiệm vụ, tìm các hóa đơn liên quan đến thông tin giao hàng bị ảnh hưởng
  - Nếu có hóa đơn bị ảnh hưởng, gửi thông báo về việc quá thời gian qua hàng đợi tin nhắn (`ConfirmMultiOrderRequestTimeoutMq`), bao gồm:
    - Mã nhà bán lẻ
    - ID lô (BatchId)
    - Thông báo lỗi với ID nhiệm vụ
    - Danh sách mã hóa đơn không thành công

  #### b. Xử lý khi `ShippingUseCancelMultipleOrderTimeout` được bật:
  - Lấy danh sách ID hóa đơn từ thông tin giao hàng bị ảnh hưởng
  - Lấy danh sách ID thông tin giao hàng bị ảnh hưởng
  - Truy vấn mã hóa đơn từ cơ sở dữ liệu
  - Nếu có mã hóa đơn, truy vấn mã đối tác vận chuyển từ cơ sở dữ liệu (chỉ lấy đối tác loại CarrierCompany)
  - Nếu có mã đối tác vận chuyển, đối với mỗi thông tin giao hàng:
    - Lấy mã hóa đơn và mã đối tác tương ứng
    - Nếu cả hai mã đều không rỗng, gửi yêu cầu hủy đơn hàng qua hàng đợi tin nhắn (`VoidOrderRequestMq`), bao gồm:
      - Mã khách hàng (mã đối tác)
      - Tên cửa hàng (mã nhà bán lẻ)
      - Hóa đơn cửa hàng (mã hóa đơn)

### 4. Ghi nhật ký hệ thống
- Ghi lại thông tin chi tiết về quá trình xử lý vào nhật ký hệ thống, bao gồm:
  - Mã nhà bán lẻ
  - Tên hành động (UpdateStatusFailed)
  - Trạng thái đã loại bỏ đối tác vận chuyển hay chưa
  - Trạng thái đã hủy đơn hàng vận chuyển hay chưa
  - Trạng thái đã xác nhận quá thời gian đơn hàng hay chưa
  - Danh sách ID nhiệm vụ
  - Danh sách ID thông tin giao hàng không thành công
  - Danh sách ID thông tin giao hàng bị ảnh hưởng
  - Danh sách ID hóa đơn
  - Từ điển mã hóa đơn
  - Danh sách ID đối tác
  - Từ điển mã đối tác

### 4. Ghi nhật ký hệ thống
- Lưu thông tin về các hành động đã thực hiện và trạng thái các đối tượng liên quan

## Quy tắc nghiệp vụ chính
1. Không cho phép xử lý các nhiệm vụ vận chuyển mới nếu có nhiệm vụ đang trong quá trình xử lý (Processing)
2. Không cho phép xử lý nếu đã tồn tại thông tin vận chuyển cho các hóa đơn được cung cấp
3. Các nhiệm vụ vận chuyển quá thời gian sẽ được chuyển sang trạng thái lỗi (Error)
4. Thông tin giao hàng liên quan đến nhiệm vụ quá thời gian sẽ bị xóa liên kết với đối tác vận chuyển
5. Tùy thuộc vào cấu hình, hệ thống có thể gửi thông báo hoặc hủy đơn hàng vận chuyển

## Hướng dẫn viết test case
1. **Nhóm test case theo cấu hình**:
   - Kiểm tra với `ShippingUseConfirmMultipleOrderTimeout` bật/tắt
   - Kiểm tra với `ShippingUseCancelMultipleOrderTimeout` bật/tắt

2. **Kiểm tra các trường hợp lỗi**:
   - Nhiệm vụ vận chuyển đang trong trạng thái Processing và chưa quá thời gian
   - Đã tồn tại thông tin giao hàng cho hóa đơn được cung cấp

3. **Kiểm tra cập nhật trạng thái**:
   - Nhiệm vụ đã quá thời gian được chuyển sang trạng thái Error
   - Thông tin giao hàng bị xóa liên kết với đối tác vận chuyển

4. **Kiểm tra xử lý thông báo và hủy đơn hàng**:
   - Thông báo được gửi khi bật cấu hình tương ứng
   - Yêu cầu hủy đơn hàng được gửi khi bật cấu hình tương ứng

5. **Kiểm tra ghi nhật ký**:
   - Thông tin về các hành động được ghi nhật ký đầy đủ

## Các điểm cần lưu ý
- Phương thức này có thể ném ngoại lệ `KvValidateException` dẫn đến phản hồi HTTP 420
- Thời gian quá hạn được tính dựa trên sự chênh lệch giữa thời gian hiện tại và thời điểm tạo nhiệm vụ
- Phương thức phụ thuộc vào nhiều dịch vụ và cấu hình khác nhau của hệ thống
- Có mối quan hệ phức tạp giữa nhiệm vụ vận chuyển, thông tin giao hàng và hóa đơn 