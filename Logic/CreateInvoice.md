# Phân tích Business Logic của phương thức CreateInvoice

## Tổng quan
Phương thức `CreateInvoice` quản lý việc tạo mới và cập nhật hóa đơn trong KiotViet. Đây là phương thức core của hệ thống, thực hiện các validation quan trọng và xử lý nhiều business rule phức tạp trước khi lưu dữ liệu vào database.

## Các bước xử lý chính

### 1. Khởi tạo và chuẩn bị dữ liệu
- **Trích xuất và chuẩn bị dữ liệu ban đầu**:
  - Lấy thông tin hóa đơn từ request (`invoice = req.Invoice`) để bắt đầu quá trình xử lý
  - Kiểm tra tính hợp lệ: Nếu `invoice == null`, hệ thống sẽ ném ngoại lệ `KvValidateInvoiceException` với thông báo `KVMessage.NotFound` ("Dữ liệu này không còn tồn tại trên hệ thống. Vui lòng kiểm tra lại")
  - Kiểm tra cấu hình thuế VAT thông qua `TaxService.IsActiveProductVATToggle()` và lưu kết quả vào biến `isUsingProductVAT`
  - Nếu không sử dụng VAT theo sản phẩm (`isUsingProductVAT = false`), hệ thống đặt `invoice.TotalTax = null`
  - Xác định ngành hàng: `isCoffee = CurrentIndustryId == (int)IndustryList.Coffee` để áp dụng các quy tắc xử lý đặc thù

- **Chuẩn hóa thông tin thời gian**:
  - Chuyển đổi thời gian từ UTC sang múi giờ địa phương:
    - `invoice.PurchaseDate = invoice.PurchaseDateUtc ?? invoice.PurchaseDate`
    - `invoice.ExpectedDelivery = invoice.ExpectedDeliveryUtc ?? invoice.ExpectedDelivery`
  - Nếu có thông tin giao hàng, cũng chuẩn hóa thời gian giao hàng dự kiến:
    - `invoice.DeliveryDetail.ExpectedDelivery = invoice.DeliveryDetail.ExpectedDeliveryUtc ?? invoice.DeliveryDetail.ExpectedDelivery`

- **Xử lý thông tin người bán và giao hàng**:
  - Kiểm tra quyền sửa người bán hàng:
    - So sánh `invoice.SoldById` với `invoice.CompareSoldById`
    - Gọi `AuthService.CheckPermission(Invoice.ModifySeller)` để kiểm tra quyền
    - Nếu không có quyền nhưng đang thay đổi người bán, khôi phục giá trị ban đầu: `invoice.SoldById = invoice.CompareSoldById`
  - Làm sạch thông tin giao hàng (nếu có):
    - `invoice.DeliveryDetail.Address = StringHelper.RemoveRegex(invoice.DeliveryDetail.Address)`
    - Loại bỏ các ký tự đặc biệt không hợp lệ, đảm bảo tính nhất quán của dữ liệu

### 2. Kiểm tra hóa đơn trùng lặp
- **Kiểm tra và xử lý UUID để tránh hóa đơn trùng lặp**: 
  - **Điều kiện áp dụng**: Hệ thống chỉ thực hiện kiểm tra khi:
    - Cờ xử lý hóa đơn được bật (`InvoiceProcessingToggle = true`)
    - Đang tạo mới hóa đơn (`invoice.Id <= 0`)
    - UUID và mã hóa đơn không rỗng
    - Không phải hóa đơn offline (mã không bắt đầu bằng `OffCodePrefix`, trong đó `OffCodePrefix` là "HDO")
  
  - **Quy trình xử lý UUID**:
    1. **Kiểm tra trong Redis cache**: Hệ thống gọi `InvoiceService.CheckCachRedisUUID(invoice.Uuid)` để kiểm tra UUID
       - Tạo khóa cache theo định dạng `cache:InvoiceProcessing:retailerId_{0}:{1}` với {0} là ID nhà bán lẻ và {1} là UUID hóa đơn
       - Truy vấn Redis để xác định UUID đã được sử dụng chưa
    
    2. **Xử lý kết quả kiểm tra**:
       - Nếu UUID đã tồn tại: Ném ngoại lệ với thông báo "Mã hóa đơn online bị trùng" kèm thời gian tạo
       - Nếu UUID chưa tồn tại: Lưu UUID vào Redis cache với thời gian hiện tại và TTL giới hạn
    
  - **Lợi ích**: Cơ chế này ngăn chặn việc tạo hóa đơn trùng lặp khi có nhiều request đồng thời, đảm bảo tính toàn vẹn dữ liệu.

### 3. Xử lý hóa đơn cập nhật
- **Xác định và đánh dấu hóa đơn cập nhật**:
  - Hệ thống xác định hóa đơn cập nhật dựa trên hai điều kiện:
    - `invoice.UpdateInvoiceId > 0`: Tồn tại ID của hóa đơn gốc cần cập nhật
    - `!string.IsNullOrEmpty(invoice.Code) && invoice.Code.StartsWith(Invoice.UpdatePrefix)`: Mã hóa đơn bắt đầu bằng tiền tố "Update_"
  - Đánh dấu `isUpdateInvoice = true` và điều chỉnh thời gian mua hàng: `invoice.PurchaseDate = invoice.PurchaseDate.AddMilliseconds(10)` để đảm bảo hóa đơn cập nhật luôn có thời gian sau hóa đơn gốc
  - Trích xuất mã hóa đơn gốc từ mã hóa đơn cập nhật (ví dụ: từ "Update_HD001" lấy ra "HD001")
  - Lấy thông tin giao hàng của hóa đơn gốc: `existOldInvoiceDeliveryInfo = await DeliveryInfoService.GetLastByInvoiceIdAsync(invoice.UpdateInvoiceId)`

- **Xử lý thanh toán cho hóa đơn cập nhật**:
  - Nếu có danh sách thanh toán, hệ thống lọc bỏ các thanh toán đã được đánh dấu cập nhật:
    `invoice.Payments = invoice.Payments.Where(p => !p.IsUpdate).ToList()`
  - Điều này giúp tránh tạo bản ghi thanh toán trùng lặp trong quá trình cập nhật

- **Xác thực tính nhất quán giữa hóa đơn gốc và hóa đơn cập nhật**:
  - Hệ thống gọi phương thức `validateWithOldData(invoice, existOldInvoiceDeliveryInfo)` để thực hiện các kiểm tra sau:
  
  - **Kiểm tra thông tin giao hàng**:
    - Nếu hóa đơn gốc có thông tin giao hàng với đối tác vận chuyển mặc định (`UseDefaultPartner == true`)
    - Và trạng thái giao hàng khác Void (`Status != (byte)DeliveryStatus.Void`)
    - Nhưng hóa đơn cập nhật không sử dụng đối tác vận chuyển mặc định (không có thông tin giao hàng hoặc không dùng đối tác mặc định)
    - Trạng thái giao hàng khác "Đã hủy" (DeliveryStatus.Void)
    - Hệ thống sẽ ném ngoại lệ với thông báo "Có thay đổi mới hơn từ server. Bạn cần cập nhật trước khi tạo thay đổi mới"
  
  - **Kiểm tra thay đổi khách hàng**:
    - Hệ thống truy vấn hóa đơn gốc từ database
    - Nếu hóa đơn gốc có khách hàng (`oldInvoice.CustomerId > 0`)
    - Và khách hàng đã thay đổi trong hóa đơn cập nhật (`oldInvoice.CustomerId != invoice.CustomerId`)
    - Và hóa đơn gốc đã có thanh toán (`oldInvoice.TotalPayment > 0`)
    - Hệ thống sẽ ném ngoại lệ KvValidateException với thông báo "Có thay đổi mới hơn từ server" (OverwriteNewerCopyNotAllowed), ngăn việc thay đổi khách hàng khi hóa đơn đã có thanh toán
  
  - **Kiểm tra hóa đơn trả hàng**:
    - Nếu hóa đơn gốc đã hoàn thành (`oldInvoice.Status == (int)InvoiceState.Issued`)
    - Và đã có hóa đơn trả hàng liên kết (`listReturn != null && listReturn.Any() && oldInvoice.Returns.Any()`)
    - Hệ thống sẽ ném ngoại lệ với thông báo "Hóa đơn đã có trả hàng, không thể mở phiếu để cập nhật"

### 4. Kiểm tra xung đột phiên bản
- **Kiểm tra xung đột phiên bản khi cập nhật hóa đơn**:
  - Hệ thống kiểm tra điều kiện `invoice.Id > 0` để xác định đây là yêu cầu cập nhật hóa đơn đã tồn tại
  - Khi cập nhật hóa đơn hiện có, hệ thống thực hiện các kiểm tra để đảm bảo không ghi đè lên thay đổi mới hơn từ người dùng khác

- **Kiểm tra xung đột thông tin giao hàng**:
  - Hệ thống truy xuất thông tin giao hàng mới nhất: `di = await DeliveryInfoService.GetLastByInvoiceIdAsync(invoice.Id)`
  - Nếu phát hiện xung đột cấu hình đối tác vận chuyển:
    - Hóa đơn hiện tại sử dụng đối tác vận chuyển mặc định (`di?.UseDefaultPartner == true`)
    - Nhưng yêu cầu cập nhật không sử dụng đối tác vận chuyển mặc định (không có thông tin giao hàng hoặc `UseDefaultPartner == false`)
    - Hệ thống sẽ ném ra ngoại lệ `KvValidateException` với thông báo "Có thay đổi mới hơn từ server. Bạn cần cập nhật trước khi tạo thay đổi mới" (`OverwriteNewerCopyNotAllowed`)

- **Kiểm tra xung đột trạng thái hóa đơn**:
  - Hệ thống truy xuất hóa đơn hiện tại: `inv = await InvoiceService.GetByIdAsync(invoice.Id)`
  - So sánh trạng thái hiện tại với trạng thái trong yêu cầu cập nhật: `inv.Status != invoice.Status`
  - Nếu trạng thái đã thay đổi, hệ thống ném ra ngoại lệ `KvValidateException` với thông báo "Có thay đổi mới hơn từ server. Bạn cần cập nhật trước khi tạo thay đổi mới" (`OverwriteNewerCopyNotAllowed`)

- **Lợi ích của cơ chế kiểm tra xung đột**:
  - Ngăn chặn việc vô tình ghi đè lên thay đổi mới hơn từ người dùng khác
  - Đảm bảo tính nhất quán của dữ liệu trong hệ thống đa người dùng
  - Giảm thiểu rủi ro mất dữ liệu do cập nhật đồng thời
  - Cung cấp thông báo rõ ràng cho người dùng khi xảy ra xung đột, hướng dẫn họ tải lại dữ liệu mới nhất


### 5. Kiểm tra khuyến mãi
- **Quy trình xác thực khuyến mãi**:
  - Hệ thống kiểm tra danh sách khuyến mãi trong hóa đơn: `invoice.InvoicePromotions != null && invoice.InvoicePromotions.Any()`
  - Chỉ xử lý các khuyến mãi mới (chưa có Id): `newPromotions = invoice.InvoicePromotions.Where(p => p.Id == 0 && p.PromotionId != null).ToList()`
  - Nếu có khuyến mãi mới, hệ thống sẽ tiến hành kiểm tra tính hợp lệ

- **Quy trình xác minh trạng thái khuyến mãi**:
  - Trích xuất danh sách ID khuyến mãi: `promotionIds = newPromotions.Select(p => (long)p.PromotionId).ToList()`
  - Kiểm tra với hệ thống khuyến mãi: `validateResult = await KvPromotionService.CheckIsDeletedCampaignByIds(promotionIds)`
    - API khuyến mãi sẽ kiểm tra danh sách ID khuyến mãi với cơ sở dữ liệu
    - Trả về danh sách ID hợp lệ (ValidIdList) và danh sách ID đã bị xóa (DeletedIdList)
    - Một ID được coi là hợp lệ nếu tìm thấy chiến dịch khuyến mãi tương ứng trong cơ sở dữ liệu
    - Một ID được coi là đã bị xóa nếu không tìm thấy chiến dịch khuyến mãi tương ứng
  - Xác định các khuyến mãi đã bị xóa: `deletedPromotions = newPromotions.Where(p => validateResult.DeletedIdList.Contains((long)p.PromotionId)).ToList()`

- **Xử lý thông báo lỗi khuyến mãi**:
  - Khi phát hiện khuyến mãi đã bị xóa, hệ thống sẽ:
    - Trích xuất tên khuyến mãi từ thông tin chi tiết (lấy phần trước dấu ":")
    - Tổng hợp danh sách tên khuyến mãi không hợp lệ: `deletedPromotionNamesString = string.Join(", ", deletedPromotionNames)`
    - Hiển thị thông báo lỗi rõ ràng cho người dùng: `throw new KvValidateException(string.Format(KVMessage.PromotionsAreDeletedNotification, deletedPromotionNamesString))` với nội dung "Chương trình khuyến mại {0} ngừng hoạt động, vui lòng áp dụng khuyến mại khác!"

- **Lợi ích của cơ chế kiểm tra khuyến mãi**:
  - Đảm bảo tính nhất quán trong chính sách khuyến mãi
  - Ngăn chặn việc áp dụng khuyến mãi đã hết hạn hoặc bị hủy
  - Cung cấp thông báo chi tiết giúp người dùng hiểu rõ vấn đề
  - Tăng tính minh bạch trong quá trình xử lý hóa đơn

### 6. Kiểm tra UUID
- **Kiểm tra UUID để tránh hóa đơn trùng lặp**:
  - Hệ thống sử dụng phương thức `CheckUuidAsync(invoice)` để xác minh UUID của hóa đơn
  - Hệ thống bỏ qua việc kiểm tra UUID trong các trường hợp sau:
    - Hóa đơn không tồn tại (null)
    - Hóa đơn đã được lưu trong hệ thống (Id > 0)
    - Tính năng kiểm tra UUID trùng lặp đang tắt
    - Hóa đơn không có UUID
    - Hóa đơn là đơn hàng offline (mã bắt đầu bằng tiền tố "HDO")
  
  - Quy trình kiểm tra UUID:
    - Sử dụng transaction với mức cô lập ReadUncommitted
    - Tìm kiếm hóa đơn có UUID giống nhau trong khoảng thời gian 7 ngày trước và sau ngày mua hàng
    - Nếu ngày mua hàng không hợp lệ, sử dụng thời gian hiện tại làm mốc
  
  - Xử lý khi phát hiện UUID trùng lặp:
    - Nếu cả thông tin khách hàng và tổng tiền đều trùng khớp:
      - Ném ngoại lệ với thông báo "Mã hóa đơn online bị trùng: {mã hóa đơn hiện tại} - {mã hóa đơn mới}"
    
    - Nếu tổng tiền khác nhau hoặc thông tin khách hàng khác nhau:
      - Tạo UUID mới với định dạng "WN" + Guid mới
      - Ghi log thông tin về việc phát hiện và xử lý UUID trùng lặp
      - Tiếp tục xử lý hóa đơn với UUID mới

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

### 8. Xử lý thông tin địa chỉ giao hàng
- **Quy trình xác định và cập nhật thông tin địa chỉ**:
  - **Điều kiện kiểm tra**:
    - Hệ thống chỉ xử lý khi `invoice.DeliveryDetail` không null
    - Thông tin địa chỉ phải có đầy đủ tên địa điểm (`LocationName`) và tên phường/xã (`WardName`)
  
  - **Quy trình tìm kiếm và ánh xạ ID địa chỉ**:
    - Gọi phương thức `LocationService.GetLocationIdAndWardId(locationName, wardName)` để lấy thông tin ID
    - Phương thức này thực hiện hai bước chính:
      1. **Tìm kiếm thông tin tỉnh/thành phố**:
         - Ưu tiên tìm trong Redis cache (nếu được cấu hình)
         - Nếu không tìm thấy trong cache, truy vấn từ cơ sở dữ liệu bằng câu lệnh:
           ```sql
           SELECT l.Id, l.Name, l.KmsId AS LocationKmsId, w.Id AS WardId, w.KmsId AS WardKmsId
           FROM KvLocations l
           LEFT JOIN KvWards w ON w.LocationId = l.Id
           WHERE LOWER(l.Name) = LOWER(@locationName) AND LOWER(w.Name) = LOWER(@wardName)
           ```
         - So khớp tên địa điểm không phân biệt hoa thường
      
      2. **Tìm kiếm thông tin phường/xã**:
         - Lấy danh sách phường/xã thuộc tỉnh/thành phố đã tìm thấy
         - So khớp tên phường/xã không phân biệt hoa thường
         - Nếu không tìm thấy chính xác, sử dụng phường/xã đầu tiên trong danh sách
    
    - **Kết quả trả về** bao gồm:
      - `LocationId`: ID tỉnh/thành phố trong hệ thống
      - `LocationKmsId`: Mã tỉnh/thành phố để ánh xạ với hệ thống KMS
      - `WardId`: ID phường/xã trong hệ thống
      - `WardKmsId`: Mã phường/xã để ánh xạ với hệ thống KMS

  - **Cập nhật thông tin địa chỉ trong hóa đơn**:
    - **Cập nhật WardId** khi:
      - Tìm thấy thông tin phường/xã hợp lệ (`kvReceiver != null && kvReceiver.WardId > 0`)
      - Mã phường/xã tìm được khác với mã hiện tại (`kvReceiver.WardId != invoice.DeliveryDetail.WardId`)
      - Thực hiện cập nhật: `invoice.DeliveryDetail.WardId = kvReceiver.WardId`
    
    - **Cập nhật LocationId** khi:
      - Tìm thấy thông tin tỉnh/thành phố hợp lệ (`kvReceiver != null && kvReceiver.LocationId > 0`)
      - Hóa đơn chưa có mã tỉnh/thành phố hoặc mã không hợp lệ (`invoice.DeliveryDetail.LocationId.GetValueOrDefault() <= 0`)
      - Thực hiện cập nhật: `invoice.DeliveryDetail.LocationId = kvReceiver.LocationId`

- **Lợi ích của cơ chế xử lý địa chỉ**:
  - Tự động bổ sung thông tin ID từ tên địa chỉ, giúp chuẩn hóa dữ liệu
  - Hỗ trợ tìm kiếm thông minh không phân biệt hoa thường
  - Tối ưu hiệu suất bằng cách sử dụng Redis cache
  - Đảm bảo tính nhất quán của dữ liệu địa chỉ trong hệ thống

### 9. Kiểm tra thông tin khách hàng và kênh bán hàng
- **Quy trình xác thực thông tin khách hàng và kênh bán hàng**:
  - **Xác thực thông tin khách hàng**:
    - Khi khách hàng có ID không hợp lệ (điều kiện `invoice.CustomerId != null && invoice.CustomerId < -0.0000001`): 
      - Hệ thống ném ngoại lệ `KvValidateCustomerException`
      - Thông báo lỗi: `KVMessage.invoiceError_updateInvoiceInfo` ("Có lỗi trong quá trình ghi nhận thông tin. Xin vui lòng Lưu lại thông tin khách hàng một lần nữa.")
      - Đây là cơ chế bảo vệ ngăn chặn việc sử dụng ID khách hàng không hợp lệ

  - **Xác thực kênh bán hàng**:
    - Khi hóa đơn có chỉ định kênh bán hàng (trường `invoice.SaleChannelId` có giá trị và lớn hơn 0):
      - Hệ thống truy vấn thông tin kênh bán hàng: `await SaleChannelService.GetByIdAsync(invoice.SaleChannelId ?? 0)`
      - Kiểm tra các điều kiện:
        1. Kênh bán hàng tồn tại: `saleChannelInDB != null`
        2. Kênh bán hàng thuộc về cửa hàng hiện tại: `saleChannelInDB.RetailerId == CurrentRetailerId`
        3. Kênh bán hàng đang hoạt động: `saleChannelInDB.IsActive == true`
      - Nếu không thỏa mãn bất kỳ điều kiện nào, hệ thống ném ngoại lệ `KvValidateSaleChannelException` với thông báo `KVMessage.sc_kenh_ban_khong_ton_tai` ("Kênh bán không tồn tại")

  - **Xác thực thông tin giao hàng**:
    - Khi hóa đơn có thông tin giao hàng và thời gian giao hàng dự kiến được thiết lập, nhưng thời gian này sớm hơn hoặc bằng thời gian mua hàng (tức là `invoice.DeliveryDetail != null && invoice.DeliveryDetail.ExpectedDelivery != null && invoice.DeliveryDetail.ExpectedDelivery <= invoice.PurchaseDate`):
      - Hệ thống ném ngoại lệ `KvValidateDeliveryInfoException`
      - Thông báo lỗi: `Labels.cod_invalidExpecteDeliveryInvoice` ("Thời gian giao hàng phải sau thời gian hóa đơn")
      - Đảm bảo tính hợp lý về mặt thời gian trong quy trình giao hàng

### 10. Kiểm tra thời gian giao hàng dự kiến
- **Quy trình xác thực thời gian giao hàng**:
  - **Điều kiện kiểm tra**:
    - Hệ thống chỉ kiểm tra khi `isValid = false` (bỏ qua kiểm tra khi đã xác thực ở nơi khác)
    - Hóa đơn có thông tin giao hàng (`invoice.DeliveryDetail != null`)
    - Thời gian giao hàng dự kiến được thiết lập (`invoice.DeliveryDetail.ExpectedDelivery != null`)
    - Thời gian giao hàng dự kiến không hợp lệ (`invoice.DeliveryDetail.ExpectedDelivery <= invoice.PurchaseDate`)
  
  - **Xử lý và thông báo lỗi**:
    - Khi thời gian giao hàng không hợp lệ, hệ thống:
      - Ném ngoại lệ `KvValidateDeliveryInfoException`
      - Hiển thị thông báo: "Thời gian giao hàng phải sau thời gian hóa đơn" (`Labels.cod_invalidExpecteDeliveryInvoice`)
    - Mã nguồn thực hiện:
      ```csharp
      if (!isValid && invoice.DeliveryDetail != null && invoice.DeliveryDetail.ExpectedDelivery != null && 
          invoice.DeliveryDetail.ExpectedDelivery <= invoice.PurchaseDate)
      {
          throw new KvValidateDeliveryInfoException(Labels.cod_invalidExpecteDeliveryInvoice);
      }
      ```

### 11. Kiểm tra giới hạn sử dụng khuyến mãi
- **Mục đích**: Đảm bảo khách hàng không sử dụng một khuyến mãi quá số lần cho phép
- **Điều kiện áp dụng**:
  - Chỉ kiểm tra khi hóa đơn có khuyến mãi (`invoice.InvoicePromotions != null && invoice.InvoicePromotions.Any()`)
  - Chỉ áp dụng cho khách hàng đã đăng ký (`invoice.CustomerId > 0`)
  - Không áp dụng cho khách vãng lai hoặc khách hàng không có ID

- **Quy trình kiểm tra**:
  1. **Lọc khuyến mãi cần kiểm tra**:
     - Hệ thống chỉ xét các khuyến mãi có:
       - Thiết lập giới hạn sử dụng (`LimitPromotionUsage = true`)
       - Chế độ chặn được bật (`LimitPromotionUsageType = (int)EnumLimitPromotionUsageTypes.Blocking`)
     ```csharp
     var listPType = invoice.InvoicePromotions.Where(p => 
         p.LimitPromotionUsage.HasValue && p.LimitPromotionUsage == true &&
         p.LimitPromotionUsageType.HasValue && p.LimitPromotionUsageType == (int)EnumLimitPromotionUsageTypes.Blocking
     ).ToList();
     ```

  2. **Kiểm tra lịch sử sử dụng**:
     - Nếu có khuyến mãi cần kiểm tra, hệ thống truy vấn lịch sử sử dụng của khách hàng:
     ```csharp
     var invPromo = await InvoicePromotionService.GetUsePromotionByCustomer(
         invoice.RetailerId,
         invoice.CustomerId.Value,
         listPType.Select(a => a.PromotionId.Value).ToList()
     );
     ```
     - Hệ thống lọc theo:
       - Cửa hàng hiện tại
       - Khách hàng đang xét
       - Chỉ tính các hóa đơn hợp lệ (không bị hủy hoặc thất bại)
       - Chỉ xét các khuyến mãi trong danh sách cần kiểm tra

  3. **Xử lý vi phạm**:
     - Nếu phát hiện khách hàng đã sử dụng khuyến mãi vượt giới hạn:
     ```csharp
     throw new KvValidateCustomerException(
         string.Format(KVMessage.customerError_promotionBlock, 
         invPromo.Select(p => p.PromotionInfo).Distinct().Join(","))
     );
     ```
     - Thông báo lỗi sẽ hiển thị: "Khách hàng đã được hưởng các khuyến mại: [Tên các khuyến mãi], vui lòng kiểm tra lại."
### 12. Xử lý thông tin đơn thuốc (cho nhà thuốc GPP)
- **Điều kiện áp dụng**:
  - Hệ thống sẽ bỏ qua kiểm tra khi `isValid = true` (đã xác thực ở nơi khác)
  - Chỉ áp dụng khi cửa hàng thuộc ngành dược (`AuthService.Context.IsActiveGppDrugStore`), hóa đơn có sử dụng đơn thuốc (`invoice.UsingPrescription == 1`)

- **Quy trình xử lý đơn thuốc**:
  1. **Kiểm tra thông tin đơn thuốc và bệnh nhân**:
     - Hệ thống kiểm tra tính đầy đủ của thông tin:
       - Đơn thuốc: mã đơn (`Code`), bác sĩ (`DoctorId`), phòng khám (`ClinicId`), mô tả (`Description`)
       - Bệnh nhân: tên (`Name`), tuổi (`Age`), giới tính (`Gender`), cân nặng (`Weight`), CMND/CCCD (`IdentityCard`), thẻ BHYT (`HealthInsuranceCard`), địa chỉ (`Address`), người giám hộ (`Guardian`), số điện thoại (`PhoneNumber`)
     - Nếu cả hai đều thiếu thông tin, hiển thị thông báo: "Bạn chưa nhập thông tin đơn thuốc" (`KVMessage.prescription_Empty`)

  2. **Kiểm tra mô tả cách dùng thuốc**:
     - Áp dụng khi hóa đơn sử dụng đơn thuốc toàn cục (`UsingGlobalPrescription == 1`)
     - Mỗi sản phẩm thuốc phải có mô tả cách dùng (trường `Note` không được trống)
     - Nếu phát hiện thiếu mô tả, hiển thị: "Hàng hóa thiếu ghi chú" (`KVMessage.invoice_ProductNoDescription`)

  3. **Kiểm tra tình trạng thuốc**:
     - Hệ thống lọc danh sách thuốc đang bán (không bao gồm thuốc mới/thay thế)
     ```csharp
     var listSellMedicine = invoice.Medicines.Where(x => 
         !invoice.NewMedicines.Any(nm => nm.MedicineCode == x.MedicineCode) || 
         x.ReplaceMedicine != null
     ).ToList();
     ```
     - Kiểm tra thuộc tính `IsExpired` để xác định thuốc hết hạn
     - Nếu phát hiện thuốc hết hạn:
       - Tổng hợp danh sách mã thuốc có vấn đề
       - Hiển thị thông báo: "[danh sách mã] đã bán hết số lượng trong đơn, vui lòng xóa sản phẩm để tạo đơn." (`KVMessage.Medicine_ProductCodeSoldOut`)

  4. **Kiểm tra mã đơn thuốc**:
     - Nếu đơn thuốc có mã (`invoice.Prescription?.Code` không rỗng):
       - Kiểm tra độ dài mã không vượt quá 50 ký tự
       - Kiểm tra mã đơn thuốc không trùng với mã đơn thuốc đã tồn tại trong hệ thống
       - Nếu trùng và không phải đơn thuốc toàn cục (`UsingGlobalPrescription != 1`), hiển thị thông báo: "Mã đơn thuốc {mã} đã tồn tại trong hệ thống" (`KVMessage.prescription_CodeAlreadyExist`)
     - Nếu đơn thuốc không có mã nhưng có ID > 0, hiển thị thông báo: "Mã đơn thuốc không hợp lệ" (`KVMessage.prescription_CodeIsNotValid`)

### 13. Kiểm tra người bán hàng
- **Xác thực người bán hàng**:
  - Hệ thống kiểm tra ID người bán hàng (`SoldById`) trong hóa đơn
  - Sử dụng `UserService.GetUserById(invoice.SoldById)` để lấy thông tin người dùng
  - Kiểm tra người bán hàng có tồn tại trong hệ thống không (không null)
  - Kiểm tra trạng thái hoạt động của người bán hàng (`user.Status == UserStatus.Active`)
  - Nếu người bán tồn tại nhưng không còn hoạt động (`IsActive == false`) và đang tạo hóa đơn mới (`invoice.Id <= 0`), hệ thống sẽ ném ngoại lệ `KvValidateUserException` với thông báo `$"{KVMessage.invoiceLog_SalePersion} {soldby.GivenName} {KVMessage.invoiceError_StopedProcessing}"` (Người bán [tên người bán] đã bị ngừng hoạt động)

### 14. Kiểm tra thông tin thanh toán
- **Xác thực phương thức thanh toán**:
  - Hệ thống kiểm tra danh sách thanh toán trong hóa đơn (`invoice.Payments`)
  - Nếu danh sách thanh toán không rỗng, hệ thống sẽ duyệt qua từng phương thức thanh toán
  - Đối với các phương thức thanh toán qua thẻ (`PaymentType.Card`) hoặc chuyển khoản (`PaymentType.Transfer`):
    - Kiểm tra xem thanh toán có liên kết với tài khoản ngân hàng không (`p.AccountId != null && p.AccountId > 0`)
    - Nếu có, hệ thống sẽ xác thực tài khoản ngân hàng thông qua `BankAccountService.ValidateBankAccount(p.AccountId.Value)`
    - Quá trình xác thực tài khoản ngân hàng bao gồm:
      - Kiểm tra tài khoản ngân hàng có tồn tại trong hệ thống không
      - Nếu tài khoản không tồn tại, hệ thống sẽ hiển thị thông báo lỗi: "Tài khoản ngân hàng được chọn không tồn tại hoặc đã bị xóa khỏi hệ thống." (`KVMessage.account_NotFound`)
      - Nếu tài khoản tồn tại nhưng không phải tài khoản toàn cục (`!bank.IsGlobal`):
        - Hệ thống sẽ kiểm tra xem tài khoản có được phép sử dụng tại chi nhánh hiện tại không
        - Thực hiện truy vấn để xác minh tài khoản được phép sử dụng tại chi nhánh hiện tại:
          ```sql
          SELECT * FROM BankAccountBranch 
          WHERE BankAccountId = @accountId 
          AND RetailerId = @retailerId
          ```
        - Tương đương với truy vấn Entity Framework:
          ```csharp
          var bankAccountBranches = await BankAccountBranchService.GetAll()
              .Where(b => b.BankAccountId == accountId && b.RetailerId == AuthService.Context.RetailerId)
              .ToListAsync();
          ```
        - Nếu không tìm thấy bản ghi nào, tức là tài khoản không được phép sử dụng tại chi nhánh hiện tại
        - Trong trường hợp này, hệ thống sẽ hiển thị thông báo lỗi: "Số tài khoản {số tài khoản} không được áp dụng cho thanh toán tại chi nhánh {tên chi nhánh}" (`KVMessage.BankAccountNotInBranch`)
    - Việc xác thực này đảm bảo tài khoản ngân hàng hợp lệ và được phép sử dụng tại chi nhánh hiện tại trước khi xử lý thanh toán

### 15. Kiểm tra thông tin khách hàng và xử lý thông tin giao hàng
- **Xử lý thông tin giao hàng**:
  - Hệ thống lấy thông tin hóa đơn cũ (nếu có) thông qua `InvoiceService.GetByIdAsync(invoice.Id)`
  - Tạo đối tượng `oldInvInfo` từ hóa đơn cũ (nếu có) bằng `InvoiceInfo.InstantFrom(oldInv)`
  - Khởi tạo đối tượng `existDeliveryInfo` mới để lưu thông tin giao hàng
  - Nếu hóa đơn cũ tồn tại, có thông tin giao hàng và đang cập nhật hóa đơn (`oldInv != null && oldInv.DeliveryInfoes.Any() && invoice.Id > 0`):
    - Lấy thông tin giao hàng hiện tại từ hóa đơn cũ bằng cách tìm bản ghi có `RetailerId` trùng với người dùng hiện tại và `IsCurrent = true`
    - Tách thông tin giao hàng khỏi đối tượng gốc để tránh ảnh hưởng đến dữ liệu gốc bằng `DeliveryInfoService.DetachByClone()`
  - Lưu trạng thái giao hàng cũ (`oldDeliveryStatus`) và tên kênh bán hàng cũ (`oldSaleChannelName`) để sử dụng sau này
  - Nếu hóa đơn có thông tin giao hàng (`invoice.DeliveryDetail != null`), sử dụng đối tác giao hàng mặc định (`UseDefaultPartner`) và mã hóa đơn bắt đầu bằng mã offline (`Invoice.OffCodePrefix`):
    - Xóa thông tin đối tác giao hàng (`PartnerDelivery = null`)
    - Xóa mã đối tác (`PartnerCode = string.Empty`)
    - Xóa tên đối tác (`PartnerName = string.Empty`)
- **Xử lý ID khách hàng**:
  - Hệ thống kiểm tra ID khách hàng trong hóa đơn (`invoice.CustomerId`)
  - Nếu ID khách hàng > 0, giữ nguyên giá trị ID khách hàng
  - Nếu ID khách hàng ≤ 0, gán giá trị null cho ID khách hàng (`invoice.CustomerId = null`)
  - Điều này giúp phân biệt giữa hóa đơn có khách hàng cụ thể và hóa đơn bán lẻ cho khách vãng lai
  - Đoạn code thực hiện: `invoice.CustomerId = invoice.CustomerId > 0 ? invoice.CustomerId : null;`
- **Xác thực khách hàng**:
  - Nếu hóa đơn có thông tin khách hàng (`invoice.CustomerId > 0`):
    - Hệ thống lấy thông tin công nợ hiện tại của khách hàng thông qua `CustomerService.GetByIdsAsync(new[] { invoice.CustomerId ?? 0 }).Select(c => c.Debt).FirstOrDefaultWithTracking(ExecutionContext) ?? 0`
    - Đồng thời lấy thông tin chi tiết của khách hàng thông qua `CustomerService.GetByIdAsync(invoice.CustomerId.Value)`
    - Kiểm tra trạng thái khách hàng:
      - Nếu đang tạo hóa đơn mới (`invoice.Id <= 0`) và khách hàng không tồn tại (`customer == null`) hoặc không còn hoạt động (`customer.IsActive != true`) hoặc đã bị xóa (`customer.isDeleted == true`):
        - Hệ thống sẽ ném ngoại lệ `KvValidateCustomerException` với thông báo `KVMessage._customer_UnActive` (Khách hàng không còn hoạt động trong hệ thống)
    - Thông tin công nợ hiện tại của khách hàng (`customerOldDebt`) sẽ được sử dụng sau này để tính toán công nợ mới sau khi tạo/cập nhật hóa đơn
  - Nếu không có thông tin khách hàng (`invoice.CustomerId <= 0`):
    - Hóa đơn sẽ được xử lý như hóa đơn bán lẻ cho khách vãng lai
    - Không cần kiểm tra thêm thông tin khách hàng
### 16. Kiểm tra kho hàng
- **Xác định và kiểm tra trạng thái kho hàng**:
  - Hệ thống xác định ID kho hàng (`whId`) dựa trên thông tin trong hóa đơn:
    ```csharp
    var whId = invoice.WareHouse != null && invoice.WareHouse.Type != (byte)WarehouseType.DefaultDirectSale 
               ? invoice.WareHouse.Id 
               : invoice.BranchId;
    ```
  - Hệ thống sử dụng một trong hai giá trị:
    - ID của kho hàng được chỉ định (`invoice.WareHouse.Id`) nếu hóa đơn có thông tin kho hàng và không phải kho bán hàng mặc định
    - ID chi nhánh (`invoice.BranchId`) nếu không có kho hàng cụ thể hoặc là kho bán hàng mặc định
  
  - Sau khi xác định kho hàng, hệ thống gọi `WarehouseService.ValidateStatusOfWarehouse(whId)` để kiểm tra tính hợp lệ của kho hàng
  
  - Quy trình kiểm tra kho hàng bao gồm:
    1. Kiểm tra xem cửa hàng có đang sử dụng hoặc đã từng sử dụng tính năng quản lý kho không
    2. Nếu có, tiếp tục kiểm tra trạng thái kho hàng hiện tại
    3. Lấy thông tin kho hàng từ cơ sở dữ liệu dựa trên ID kho hàng
    4. Kiểm tra các điều kiện về trạng thái kho:
       - Nếu kho hàng không còn hoạt động: Hiển thị thông báo "{tên kho} không hợp lệ" (KVMessage.WarehouseIsDeleted)
       - Nếu kho hàng bị hạn chế truy cập: Hiển thị thông báo "{tên kho} đã ngừng hoạt động" (KVMessage.WarehouseIsDeactived)
  
  - Việc kiểm tra này đảm bảo rằng:
    - Kho hàng được sử dụng trong hóa đơn phải tồn tại
    - Kho hàng đang hoạt động (không bị xóa)
    - Kho hàng không bị hạn chế truy cập (không bị vô hiệu hóa)
  
  - Nếu kho hàng không đáp ứng các điều kiện trên, quá trình tạo/cập nhật hóa đơn sẽ bị dừng lại và hiển thị thông báo lỗi tương ứng

### 17. Lưu hoặc cập nhật hóa đơn
- **Cập nhật hóa đơn hiện có**:
  - Nếu hóa đơn đã tồn tại (`invoice.Id > 0`):
    - Kiểm tra xem hóa đơn có đang được xử lý bởi tác vụ vận chuyển không thông qua `ShippingTaskService.ValidateProcessingInvoice(invoice.Id)`
      - Phương thức này kiểm tra xem hóa đơn có đang được xử lý bởi tác vụ vận chuyển nào không:
        - Nếu `invoiceId = 0`, ném ngoại lệ với thông báo "Request không có dữ liệu" (KVMessage.request_DataNull)
        - Lấy thời gian chờ từ cấu hình hệ thống `AppServiceConfigInfo.ShippingTaskTimeOut`
        - Tìm tất cả các tác vụ vận chuyển liên quan đến hóa đơn từ `ShippingTaskOrderDetailService`
        - Nếu có tác vụ vận chuyển liên quan, gọi phương thức `CheckFailedTask` để kiểm tra các tác vụ đã quá thời gian chờ:
          - Lấy danh sách tác vụ vận chuyển từ cơ sở dữ liệu dựa trên các ID tác vụ
          - Xử lý các tác vụ vận chuyển quá hạn:
            1. **Xác định tác vụ quá hạn**: Lọc các tác vụ có trạng thái "Processing" và thời gian xử lý vượt quá thời gian chờ cấu hình
            2. **Xử lý thông tin giao hàng**:
               - Lấy danh sách chi tiết tác vụ vận chuyển chưa hoàn thành
               - Tìm các thông tin giao hàng liên quan đến các tác vụ này
               - Xóa thông tin đối tác vận chuyển (đặt DeliveryBy = null, UseDefaultPartner = null) cho các thông tin giao hàng chưa hoàn thành
               - Đánh dấu các tác vụ quá hạn thành "Error"
               - Thêm thông báo lỗi với nội dung "Lỗi do thời gian tạo vận đơn hàng loạt vượt quá ngưỡng cho phép ({0} phút). Xin vui lòng thử lại." (KVMessage.shippingTaskTimeOutMsg)
               - Cập nhật thông tin người sửa đổi và thời gian sửa đổi
               - Thực hiện SQL query để cập nhật trạng thái:
                 ```sql
                 UPDATE ShippingTask 
                 SET Status = 'Error', 
                     ErrorMessage = N'Lỗi do thời gian tạo vận đơn hàng loạt vượt quá ngưỡng cho phép (' + @timeoutMinutes + ' phút). Xin vui lòng thử lại.',
                     ModifiedBy = @currentUserId,
                     ModifiedDate = GETDATE()
                 WHERE Id IN (@taskIds) AND Status = 'Processing'
                 ```
               - Thực hiện SQL query để lấy các hóa đơn bị ảnh hưởng:
                 ```sql
                 SELECT i.Code AS InvoiceCode, st.Id AS TaskId
                 FROM ShippingTaskOrderDetail stod
                 JOIN ShippingTask st ON stod.ShippingTaskId = st.Id
                 JOIN Invoice i ON stod.InvoiceId = i.Id
                 WHERE st.Id IN (@taskIds) AND st.Status = 'Error'
                 ```
            4. **Xử lý thông báo và hủy đơn**:
               - Nếu cấu hình `ShippingUseConfirmMultipleOrderTimeout` được bật:
                 + Tạo thông điệp xác nhận hết thời gian chờ với thông tin chi tiết về các hóa đơn bị ảnh hưởng
                 + Gửi thông điệp qua RabbitMQ đến hàng đợi `mq.ConfirmMultiOrderRequestTimeoutMq.inq`
               - Nếu cấu hình `ShippingUseCancelMultipleOrderTimeout` được bật:
                 + Lấy thông tin mã hóa đơn và mã đối tác vận chuyển
                 + Gửi yêu cầu hủy đơn hàng vận chuyển qua RabbitMQ đến hàng đợi `mq.VoidOrderRequestMq.inq`
            5. **Ghi log**: Lưu thông tin chi tiết về quá trình xử lý, bao gồm:
               - Mã người bán lẻ, hành động thực hiện
               - Trạng thái các thao tác (đã xóa thông tin đối tác, đã hủy đơn hàng, đã xác nhận hết thời gian chờ)
               - Danh sách ID tác vụ, ID thông tin giao hàng, ID hóa đơn
               - Thông tin mã hóa đơn và mã đối tác vận chuyển
    - Cập nhật hóa đơn bằng cách gọi `InvoiceService.UpdateInvoiceAsync()` với các tham số phù hợp:
      - Phương thức này nhận vào các tham số:
        - `invoice`: Đối tượng hóa đơn cần cập nhật
        - `isUpdatePayment`: Xác định có cập nhật thông tin thanh toán hay không
        - `isVoidDeliveryPayment`: Xác định có hủy thanh toán giao hàng hay không (mặc định là false)
        - `isForceUpdateBranchTakingAddr`: Xác định có bắt buộc cập nhật địa chỉ chi nhánh nhận hàng hay không (mặc định là false)
        - `isSkipUpdateShippingDelivery`: Xác định có bỏ qua cập nhật thông tin giao hàng hay không (mặc định là true)
        - `deliveryReturnedDate`: Ngày trả hàng (mặc định là giá trị mặc định của DateTime)
      - Quy trình xử lý:
        1. Kiểm tra hóa đơn có tồn tại không, nếu không sẽ ném ngoại lệ với thông báo "Dữ liệu này không còn tồn tại trên hệ thống. Vui lòng kiểm tra lại" (KVMessage.NotFound)
        2. Chuẩn hóa chi tiết hóa đơn thông qua `NormalizeInvoiceDetail()`:
           - Nếu danh sách chi tiết hóa đơn trống hoặc không tồn tại, kết thúc xử lý
           - Tạo một danh sách (HashSet<string>) để lưu trữ và kiểm tra các UUID đã xuất hiện
           - Xử lý từng dòng chi tiết hóa đơn:
             - Bỏ qua những dòng không có UUID
             - Kiểm tra trùng lặp UUID: Nếu UUID đã tồn tại trong danh sách, thêm chữ "U" vào cuối UUID cho đến khi tạo được UUID duy nhất
             - Ghi nhận UUID vào danh sách để tránh trùng lặp trong các dòng tiếp theo
        3. Cập nhật trạng thái cũ của hóa đơn thông qua `UpdateInvoiceOldStatus()`:
           - Nếu hóa đơn sử dụng COD (UsingCod = 1) và có trạng thái là 4:
             + Đặt lại trạng thái hóa đơn thành "Chờ xử lý" (InvoiceState.Pending)
             + Nếu có thông tin giao hàng (DeliveryDetail), cập nhật trạng thái giao hàng thành "Đang giao" (DeliveryStatus.Delivering)
           - Đây là bước xử lý đặc biệt cho hóa đơn COD để đảm bảo trạng thái phù hợp trong quá trình giao hàng
        4. Chuyển đổi thông tin giao hàng của hóa đơn thông qua `ConvertInvoiceDelivery()`
        5. Gán đối tác giao hàng mặc định thông qua `AssignPartnerDeliveryDefault()`
        6. Xử lý đặc biệt cho hóa đơn COD bị trả hàng:
           - Nếu hóa đơn đã tồn tại (Id > 0), sử dụng COD (UsingCod = 1), có thông tin giao hàng và trạng thái giao hàng là "Đã trả hàng"
           - Và cấu hình thời gian khóa Redis cho cập nhật trả hàng > 0
           - Sử dụng khóa Redis để đảm bảo chỉ một tiến trình cập nhật hóa đơn tại một thời điểm
           - Khóa có định dạng: "DeliveryInfoService.DoConfirmStatusReturned_{RetailerId}_{InvoiceId}"
           - Thời gian khóa dựa trên cấu hình RedisLockUpdateDeliveryReturnedTimeout (tính bằng phút)
        7. Gọi `ProcessUpdateInvoiceAsync()` để thực hiện cập nhật hóa đơn với các tham số đã truyền vào:
           - Kiểm tra tiền tệ hiện tại thông qua `NumberHelper.GetCurrentCurrency()`
           - Kiểm tra tính hợp lệ của hóa đơn COD (thu tiền khi giao hàng): 
             + Hệ thống sẽ kiểm tra các điều kiện sau:
               * Hóa đơn có sử dụng COD (UsingCod = 1)
               * Có thông tin giao hàng (DeliveryDetail không null)
               * Chưa chọn đối tác giao hàng (DeliveryBy = null)
               * Hóa đơn đang ở một trong các trạng thái vận chuyển sau:
                 - Đang giao hàng (Delivering - 2)
                 - Đang thử giao lại (DeliveringRetry - 10)
                 - Đã giao hàng (Delivered - 3)
                 - Đang trả hàng (Returning - 4)
                 - Đang thử trả lại (ReturnRetry - 12)
                 - Đã trả hàng (Returned - 5)
                 - Đang chờ trả hàng (WaitingReturn - 13)
             + Nếu tất cả các điều kiện trên được thỏa mãn, hệ thống sẽ hiển thị thông báo lỗi:
               "Chưa nhập đối tác giao hàng" (KVMessage.DeliveryPartner_Empty)
             + Mục đích: Đảm bảo rằng tất cả các hóa đơn COD đang trong quá trình vận chuyển hoặc đã hoàn thành vận chuyển đều phải có thông tin đối tác giao hàng
           - Kiểm tra xem hóa đơn có phải từ OmniChannel không thông qua phương thức `PosOnlineHelper.IsInvoiceOmni()`, phương thức này xác định hóa đơn có nguồn gốc từ kênh bán hàng trực tuyến dựa vào mã hóa đơn:
             + Phương thức kiểm tra mã hóa đơn có bắt đầu bằng các tiền tố của các sàn thương mại điện tử hay không:
               * DHSPE: Shopee
               * DHTTS/DHTTL: TikTok
               * DHLZD: Lazada
               * DHTIKI: Tiki
               * DHSDO: Sendo
             + Nếu mã hóa đơn bắt đầu bằng một trong các tiền tố trên, hóa đơn được xác định là từ OmniChannel
           - Lấy thông tin hóa đơn hiện tại từ cơ sở dữ liệu và kiểm tra sự thay đổi về tổng tiền
           - Tạo bản sao tách rời của hóa đơn gốc để so sánh sau này
           - Xác định có cập nhật thông tin giao hàng không dựa trên UsingCod và UseDefaultPartner
           - Thực hiện kiểm tra tính hợp lệ của hóa đơn trước khi cập nhật:
           - Gọi phương thức `ValidateUpdateInvoiceAsync()` để kiểm tra tính hợp lệ của hóa đơn trước khi cập nhật:
             + Kiểm tra ngày mua hàng không được lớn hơn thời gian hiện tại:
               * Hệ thống so sánh `invoice.PurchaseDate` với thời gian hiện tại
               * Nếu ngày mua hàng lớn hơn, hệ thống sẽ hiển thị thông báo lỗi "Vượt quá thời gian hiện tại" (GreaterThanNow)
               * Điều này ngăn chặn việc tạo hóa đơn với ngày trong tương lai
             
             + Xác thực thời gian giao dịch với `KvTransactionTimeHelper.Validate()`:
               * Kiểm tra xem thời gian giao dịch có hợp lệ không dựa trên cấu hình của cửa hàng
               * Nếu tính năng kiểm tra thời gian được bật (ValidateUpdatePurchaseDateToggle):
                 - Hệ thống sẽ áp dụng giới hạn thời gian dựa trên cấu hình MaxMonthUpdatePurchaseDateInvoice (số tháng tối đa)
                 - Các quy tắc kiểm tra thời gian:
                   > Khi tạo hóa đơn mới: Không cho phép tạo hóa đơn có ngày quá xa so với hiện tại
                     Thông báo: "Bạn chỉ được tạo giao dịch trong vòng {0} tháng."
                   
                   > Khi cập nhật hóa đơn: Không cho phép thay đổi ngày nếu ngày cũ hoặc ngày mới vượt quá giới hạn
                     Thông báo: "Bạn chỉ được cập nhật giao dịch trong vòng {0} tháng."
                   
                   > Khi xóa hóa đơn: Không cho phép xóa hóa đơn có ngày quá xa so với hiện tại
                     Thông báo: "Bạn chỉ có thể hủy giao dịch trong vòng {0} tháng."
                   
                   > Khi đồng bộ hóa đơn: Không cho phép đồng bộ hóa đơn có ngày quá xa
                     Thông báo: "Giao dịch có thời gian quá {0} tháng so với hiện tại."
                 
                 - Trong tất cả các thông báo, {0} sẽ được thay thế bằng số tháng tối đa được cấu hình
             
             + Kiểm tra kênh bán hàng:
               * Nếu hóa đơn có kênh bán hàng được chọn (invoice.SaleChannelId > 0):
                 - Hệ thống kiểm tra sự tồn tại của kênh bán hàng trong cơ sở dữ liệu
                 - Nếu kênh bán hàng không tồn tại hoặc đã bị xóa, hiển thị thông báo:
                   "Kênh không tồn tại hoặc đã bị xóa" (KVMessage.channelNotExistorDeleted)
                 - Nếu kênh bán hàng đã bị vô hiệu hóa (IsActive = false), hiển thị thông báo:
                   "Kênh {0} đã bị ngừng hoạt động" (KVMessage.channelIsDown), với {0} là tên kênh
             
             + Kiểm tra trạng thái hóa đơn:
               * Hệ thống không cho phép thay đổi trạng thái nếu hóa đơn đã ở một trong các trạng thái sau:
                 - Đã phát hành (InvoiceState.Issued)
                 - Đã hủy (InvoiceState.Cancelled)
                 - Thất bại (InvoiceState.Failed)
               * Nếu cố gắng thay đổi trạng thái của hóa đơn đã phát hành/hủy/thất bại, hệ thống sẽ hiển thị thông báo lỗi "Trạng thái cập nhật không hợp lệ" (KVMessage.StatusUpdateInvalid)
             
             + Xác thực thông tin giao hàng (nếu có):
               * Kiểm tra sự tồn tại của thông tin giao hàng trong `invoice.DeliveryDetail`
                 - Nếu không tìm thấy thông tin giao hàng trong cơ sở dữ liệu (khi DeliveryInfo.Id > 0 nhưng không tồn tại bản ghi tương ứng), hệ thống sẽ kiểm tra bằng cách gọi DeliveryInfoService.GetByIdAsync(). Nếu kết quả trả về là null, hệ thống sẽ hiển thị thông báo lỗi "Vận đơn gắn với hóa đơn không tồn tại" (Labels.notExistDeliveryInInvoice). Điều này ngăn người dùng cập nhật hóa đơn với thông tin vận đơn không hợp lệ hoặc đã bị xóa khỏi hệ thống.
               * Không cho phép thay đổi đối tác giao hàng nếu đã có thanh toán phí giao hàng:
                 - Hệ thống kiểm tra xem đã có thanh toán phí giao hàng chưa bằng cách:
                   * Truy vấn bảng DeliveryPaymentService để tìm các bản ghi liên quan đến vận đơn hiện tại
                   * Cụ thể, tìm các bản ghi có DeliveryInfoId trùng với ID của vận đơn đang xét
                   * Kiểm tra xem trong các bản ghi này có bản ghi nào đã được thanh toán (có PurchasePaymentId và trạng thái là PaymentStatus.Paid)
                   * Nếu tìm thấy ít nhất một bản ghi đã thanh toán, biến hasPayment sẽ được đặt thành true
                 
                 - Hệ thống xác định người dùng đang muốn thay đổi đối tác giao hàng khi:
                   * Cả vận đơn cũ và vận đơn mới đều có chỉ định đối tác giao hàng (DeliveryBy > 0)
                   * Đối tác giao hàng trong vận đơn cũ (deliveryInfoExist.DeliveryBy) khác với đối tác giao hàng trong vận đơn mới (invoice.DeliveryInfo.DeliveryBy)
                   * Biến changePartner sẽ được đặt thành true nếu cả hai điều kiện trên đều đúng
                 
                 - Nếu đã có thanh toán phí giao hàng (hasPayment = true) VÀ người dùng đang cố gắng thay đổi đối tác giao hàng (changePartner = true):
                   * Hệ thống sẽ ngăn chặn thao tác này bằng cách ném ra ngoại lệ KvValidateDeliveryInfoException
                   * Thông báo lỗi hiển thị: "Không đổi được đối tác giao hàng đã phát sinh phiếu chi phí giao hàng" (Labels.cannotChangePartnerHasFeePayment)
                   * Điều này đảm bảo tính nhất quán trong dữ liệu và ngăn chặn việc thay đổi đối tác giao hàng sau khi đã phát sinh thanh toán

               * Không cho phép thay đổi phí giao hàng nếu đã có thanh toán:
                 - Hệ thống sử dụng cùng một biến hasPayment đã kiểm tra ở trên để xác định xem đã có thanh toán phí giao hàng chưa
                 - Hệ thống phát hiện người dùng đang cố gắng thay đổi phí giao hàng bằng cách so sánh:
                   * Phí giao hàng trong vận đơn cũ (deliveryInfoExist.Price hoặc 0 nếu null)
                   * Phí giao hàng trong vận đơn mới (invoice.DeliveryInfo.Price hoặc 0 nếu null)
                   * Nếu hai giá trị này khác nhau, người dùng đang cố gắng thay đổi phí giao hàng
                 
                 - Nếu đã có thanh toán phí giao hàng (hasPayment = true) VÀ phí giao hàng đã thay đổi:
                   * Hệ thống sẽ ngăn chặn thao tác này bằng cách ném ra ngoại lệ KvValidateDeliveryInfoException
                   * Thông báo lỗi hiển thị: "Không thể thay đổi phí giao hàng với vận đơn đã thanh toán phí giao hàng" (Labels.cannotChangeDeliveryFeeHasPayment)
                   * Quy tắc này đảm bảo rằng sau khi đã thanh toán phí giao hàng, giá trị phí không thể thay đổi, tránh sự không nhất quán giữa số tiền đã thanh toán và phí giao hàng trên vận đơn
               * Kiểm tra tính duy nhất của mã vận đơn trong cùng một hóa đơn:
                 - Khi cập nhật thông tin giao hàng (isUpdateDeliveryInfo = true), hệ thống kiểm tra mã vận đơn mới có bị trùng không
                 - Quy trình kiểm tra:
                   * So sánh mã vận đơn cũ và mới (deliveryInfoExist.DeliveryCode và invoice.DeliveryInfo.DeliveryCode)
                   * Nếu mã vận đơn đã thay đổi và mã mới không trống, hệ thống sẽ kiểm tra trùng lặp
                   * Tìm tất cả thông tin giao hàng thuộc cùng hóa đơn (x.InvoiceId == deliveryInfoExist.InvoiceId)
                   * Kiểm tra xem mã vận đơn mới đã được sử dụng chưa (sau khi chuẩn hóa bằng cách bỏ khoảng trắng và chuyển thành chữ thường)
                   * Nếu tìm thấy mã trùng lặp, biến codeExist sẽ là true
                 - Nếu phát hiện trùng lặp (codeExist = true):
                   * Hệ thống sẽ hiển thị thông báo lỗi: "Mã vận đơn ứng với từng hóa đơn không được trùng nhau"
                   * Ngăn người dùng lưu thông tin bằng cách ném ra ngoại lệ KvValidateDeliveryInfoException
               * Kiểm tra trạng thái giao hàng:
                 - Hệ thống không cho phép thay đổi trạng thái vận đơn nếu vận đơn đã ở một trong các trạng thái cuối:
                   * Đã giao hàng (DeliveryStatus.Delivered)
                   * Đã trả hàng (DeliveryStatus.Returned)
                   * Đã hủy (DeliveryStatus.Void)
                 - Nếu người dùng cố gắng thay đổi trạng thái của vận đơn đã ở trạng thái cuối (trừ khi hóa đơn đang ở trạng thái hủy):
                   * Hệ thống sẽ hiển thị thông báo lỗi: "Trạng thái vận đơn không hợp lệ" (KVMessage.deliveyStatusInvalid)
               * Kiểm tra tính hợp lý của ngày giao hàng:
                 - Hệ thống kiểm tra xem ngày dự kiến giao hàng (`DeliveryDetail.ExpectedDelivery`) có sau ngày mua hàng (`invoice.PurchaseDate`) không
                 - Nếu ngày dự kiến giao hàng sớm hơn ngày mua hàng, hệ thống sẽ hiển thị thông báo lỗi: "Thời gian giao hàng phải sau thời gian hóa đơn" (KVMessage.cod_invalidExpecteDeliveryInvoice)
             
             + Kiểm tra thời gian hợp lệ với phiếu trả hàng:
               * Nguyên tắc cơ bản:
                 - Ngày mua hàng phải sớm hơn hoặc bằng ngày trả hàng (logic thông thường: không thể trả hàng trước khi mua)
                 - Khi thay đổi ngày mua hàng, cần đảm bảo không vi phạm ràng buộc thời gian với các phiếu trả hàng liên quan

               * Kiểm tra với phiếu trả hàng hiện có:
                 - Hệ thống tìm tất cả phiếu trả hàng liên quan đến hóa đơn hiện tại (obj.Returns)
                 - Chỉ xét các phiếu trả hàng còn hiệu lực (không ở trạng thái Void/Hủy)
                 - Nếu có phiếu trả hàng liên quan:
                   + Xác định ngày trả hàng sớm nhất (minDate) từ tất cả phiếu trả hàng
                   + So sánh ngày mua hàng mới (invoice.PurchaseDate) với ngày trả hàng sớm nhất
                   + Nếu ngày mua hàng muộn hơn ngày trả hàng → Không hợp lệ (r = false)
                 - Xử lý khi thời gian không hợp lệ (khi aggressive = true):
                   + Hiển thị thông báo: "Thời gian hóa đơn không được trước đơn hàng, sau phiếu trả hàng, sau phiếu thanh toán"
                   + Ngăn chặn việc lưu thay đổi bằng cách ném ra ngoại lệ KvValidateInvoiceException

               * Kiểm tra với đơn trả hàng mới:
                 - Hệ thống kiểm tra xem ngày mua hàng có thay đổi không (so sánh invoice.PurchaseDate với obj.PurchaseDate)
                 - Nếu ngày mua hàng thay đổi (dateChanged = true):
                   + Tìm kiếm đơn trả hàng mới liên quan đến hóa đơn hiện tại (ret.NewInvoiceId == obj.Id)
                   + Lấy thông tin về mã đơn trả hàng, ngày mua hàng của hóa đơn gốc và các thanh toán liên quan
                 - Nếu tìm thấy đơn trả hàng mới liên quan:
                   + Kiểm tra quyền người dùng:
                     * Người dùng phải có quyền đọc (Return._Read) và cập nhật (Return._Update) đơn trả hàng
                     * Nếu không có đủ quyền và đơn trả hàng có mã:
                       - Hiển thị thông báo: "Bạn cần được cấp quyền Trả hàng - Xem danh sách và Trả hàng - Cập nhật để đổi thời gian cho phiếu trả hàng {0} tương ứng."
                       - Ném ra ngoại lệ KvUnauthorizedException
                   + Kiểm tra ràng buộc về thời gian:
                     * Ngày mua hàng mới không được muộn hơn ngày thanh toán sớm nhất của đơn trả hàng
                     * Ngày mua hàng mới không được sớm hơn ngày mua hàng của hóa đơn gốc (nếu đơn trả hàng liên kết với hóa đơn gốc)
                     * Nếu vi phạm các điều kiện trên và aggressive = true:
                       - Hiển thị thông báo: "Thời gian trả hàng không được trước hóa đơn, sau phiếu thanh toán"
                       - Ném ra ngoại lệ KvValidateInvoiceException
             + Kiểm tra cấu hình bỏ qua xác thực IMEI/Serial:
               * Hệ thống xem xét cài đặt `AppServiceConfigInfo.IsValidateImei`:
                 - Cài đặt này quyết định có cần kiểm tra IMEI/Serial khi tạo hoặc cập nhật hóa đơn hay không
                 - Khi `IsValidateImei = false` (tắt kiểm tra): 
                   + Hệ thống bỏ qua mọi kiểm tra về IMEI/Serial
                   + Trả về kết quả xác thực hiện tại (biến `r`)
                   + Người dùng có thể tạo hóa đơn mà không cần lo lắng về tính hợp lệ của IMEI/Serial
                 - Khi `IsValidateImei = true` (bật kiểm tra):
                   + Hệ thống sẽ kiểm tra kỹ lưỡng tính hợp lệ của IMEI/Serial
                   + Kiểm tra bao gồm: xung đột với kiểm kê kho, trùng lặp giữa các chi nhánh, và tính khả dụng tại thời điểm mua hàng
                 - Tùy chọn này giúp cửa hàng linh hoạt trong việc quản lý IMEI/Serial theo nhu cầu riêng
             + Kiểm tra tính hợp lệ của số serial/IMEI trong hóa đơn:
               * Quy trình kiểm tra:
                 - Thu thập tất cả số serial từ các chi tiết hóa đơn (InvoiceDetails)
                 - Nếu không có số serial nào, bỏ qua kiểm tra và trả về kết quả xác thực hiện tại
                 - Xác định chi nhánh cần kiểm tra:
                   + Sử dụng chi nhánh của hóa đơn (invoice.BranchId) nếu có
                   + Nếu không có, sử dụng chi nhánh của người dùng hiện tại (AuthService.Context.BranchId)
                 - Xác định thời điểm kiểm tra:
                   + Sử dụng ngày mua hàng của hóa đơn (invoice.PurchaseDate) nếu có
                   + Nếu không có, sử dụng thời gian hiện tại (DateTime.Now)

               * Kiểm tra từng số serial trong hóa đơn:
                 - Đối với mỗi sản phẩm có số serial trong hóa đơn:
                   + Tách các số serial riêng lẻ (nếu có nhiều số được phân cách bằng dấu phẩy)
                   + Thực hiện 3 loại kiểm tra cho mỗi số serial:

                 - Kiểm tra xung đột với phiếu kiểm kho:
                   + Gọi phương thức `StockTakeService.IsHaveStockTakeNewer()` để kiểm tra xem có phiếu kiểm kho nào mới hơn không
                   + Phương thức này kiểm tra:
                     * Khi tạo hoặc xóa hóa đơn (newTransDate = null):
                       - Tìm phiếu kiểm kho đã duyệt (Status = Approval) tại chi nhánh của hóa đơn
                       - Phiếu kiểm kho phải có ngày điều chỉnh (AdjustmentDate) >= ngày giao dịch của hóa đơn
                       - Phiếu kiểm kho phải chứa sản phẩm có IMEI/Serial đang kiểm tra
                     * Khi cập nhật hóa đơn (thay đổi ngày giao dịch):
                       - Nếu ngày giao dịch mới = ngày giao dịch cũ: bỏ qua kiểm tra
                       - Nếu ngày giao dịch mới > ngày giao dịch cũ: kiểm tra khoảng thời gian từ ngày cũ đến ngày mới
                       - Nếu ngày giao dịch mới < ngày giao dịch cũ: kiểm tra khoảng thời gian từ ngày mới đến ngày cũ
                       - Kiểm tra xem có giao dịch kiểm kho khác trong khoảng thời gian đó không
                       - Kiểm tra xem có phiếu kiểm kho đã duyệt nào trong khoảng thời gian đó không
                   + Nếu có xung đột (kết quả trả về false):
                     * Hiển thị thông báo lỗi: "Hàng hóa {0} IMEI {1}: Không được phép chuyển thời gian giao dịch về trước hoặc sau phiếu kiểm kho {2}"
                     * Trong đó: {0} là mã sản phẩm, {1} là số serial, {2} là mã phiếu kiểm kho xung đột
                     * Ngăn chặn việc lưu hóa đơn bằng cách ném ra ngoại lệ KvValidateInvoiceException

                 - Kiểm tra xung đột giữa các chi nhánh:
                   + Gọi phương thức `ImeiTrackingService.IsExistsMultiBranch()` để kiểm tra xem số serial có tồn tại ở nhiều chi nhánh không
                   + Nếu có xung đột (kết quả trả về false):
                     * Lấy thông tin chi nhánh hiện tại
                     * Hiển thị thông báo lỗi: "Không thực hiện được thao tác này vì sẽ làm Hàng hóa {0} Serial {1} còn hàng trên nhiều chi nhánh ({2}, {3})"
                     * Trong đó: {0} là mã sản phẩm, {1} là số serial, {2} là tên chi nhánh hiện tại, {3} là thông tin chi nhánh xung đột
                     * Ngăn chặn việc lưu hóa đơn bằng cách ném ra ngoại lệ KvValidateInvoiceException

                 - Kiểm tra tính khả dụng của số serial tại thời điểm mua hàng:
                   + Gọi phương thức `ImeiTrackingService.IsAvailable()` để kiểm tra xem số serial có khả dụng tại thời điểm mua hàng không
                   + Nếu không khả dụng (kết quả trả về false):
                     * Hiển thị thông báo lỗi: "Sản phẩm {0} IMEI {1} hết hàng tại thời gian bạn vừa chọn"
                     * Trong đó: {0} là mã sản phẩm, {1} là số serial
                     * Ngăn chặn việc lưu hóa đơn bằng cách ném ra ngoại lệ KvValidateInvoiceException
---------------------             
             + Nếu hóa đơn được tạo từ đơn đặt hàng:
               * Hệ thống kiểm tra xem hóa đơn có `DocumentId` không (liên kết với đơn đặt hàng)
               * Ngày mua hàng phải lớn hơn hoặc bằng ngày đặt hàng:
                 - So sánh `invoice.PurchaseDate` với `order.PurchaseDate`
                 - Nếu ngày mua hàng nhỏ hơn ngày đặt hàng, hệ thống sẽ hiển thị thông báo lỗi
             
             + Kiểm tra đặc biệt khi thay đổi ngày mua hàng:
               * Xác thực quyền truy cập nếu hóa đơn liên quan đến đơn trả hàng:
                 - Kiểm tra xem người dùng có quyền thay đổi ngày mua hàng của hóa đơn có đơn trả hàng không
                 - Nếu không có quyền, hệ thống sẽ hiển thị thông báo lỗi về quyền truy cập
               * Đảm bảo ngày mua hàng mới không xung đột với các thanh toán của đơn trả hàng:
                 - Kiểm tra tất cả các thanh toán liên quan đến đơn trả hàng
                 - Ngày mua hàng mới không được lớn hơn ngày thanh toán của bất kỳ thanh toán nào
               * Đảm bảo ngày mua hàng mới không xung đột với ngày mua hàng của đơn trả hàng gốc:
                 - Nếu hóa đơn hiện tại là đơn trả hàng, ngày mua hàng không được nhỏ hơn ngày mua hàng của hóa đơn gốc
                 - Nếu xung đột, hệ thống sẽ hiển thị thông báo lỗi tương ứng
             
             + Kiểm tra tính hợp lệ của số serial/IMEI (nếu có):
               * Xác thực số serial không xung đột với kiểm kê kho:
                 - Hệ thống kiểm tra xem số serial có bị ảnh hưởng bởi các phiếu kiểm kê kho không
                 - Nếu có xung đột, hệ thống sẽ hiển thị thông báo lỗi "Số serial đã bị kiểm kê"
               * Đảm bảo số serial không tồn tại ở nhiều chi nhánh:
                 - Kiểm tra xem số serial có xuất hiện ở chi nhánh khác với chi nhánh của hóa đơn không
                 - Nếu có, hệ thống sẽ hiển thị thông báo lỗi về xung đột chi nhánh
               * Kiểm tra tính khả dụng của số serial tại thời điểm mua hàng:
                 - Hệ thống xác minh xem số serial có sẵn để bán tại thời điểm ngày mua hàng không
                 - Nếu không khả dụng, hệ thống sẽ hiển thị thông báo lỗi "Số serial không có sẵn tại thời điểm mua hàng"
           - Kiểm tra ngày đóng sổ để đảm bảo không cập nhật hóa đơn trước ngày đóng sổ
           - Lưu trữ ngày mua hàng và người bán cũ để so sánh
           - Cập nhật các thông tin cơ bản: ngày mua hàng, người bán, mô tả, UsingCod, kênh bán hàng
           - Nếu là hóa đơn từ OmniChannel, cập nhật phụ phí
           - Nếu ngày thay đổi, cập nhật ngày nhập
           - Tính toán lại điểm tích lũy nếu tính năng RewardPoint được bật
           - Cập nhật thông tin giao hàng và xử lý trạng thái trả hàng
           - Cập nhật hóa đơn với theo dõi thay đổi
           - Đồng bộ với hệ thống dược quốc gia nếu cần
           - Cập nhật thông tin giao hàng thông qua DeliveryInfoService
           - Nếu ngày thay đổi, cập nhật ngày sử dụng voucher, ngày trả hàng, ngày sử dụng coupon
           - Cập nhật kênh bán hàng cho các đơn trả hàng liên quan nếu kênh bán hàng thay đổi
           - Cập nhật thông tin thanh toán liên quan đến hóa đơn:
             * Hệ thống kiểm tra tham số `isUpdatePayment` để xác định có cần cập nhật thông tin thanh toán hay không:
               - Nếu `isUpdatePayment = true`: Hệ thống sẽ tiến hành cập nhật thông tin thanh toán liên quan đến hóa đơn
               - Nếu `isUpdatePayment = false`: Hệ thống sẽ bỏ qua việc cập nhật thông tin thanh toán, giữ nguyên các thông tin thanh toán hiện tại
               - Tham số này thường được truyền vào từ API gọi hàm cập nhật hóa đơn (như trong `InvoiceApi.cs`)
             * Nếu có thanh toán liên quan đến hóa đơn (invoice.Payments không rỗng):
               - Hệ thống sẽ duyệt qua từng thanh toán trong danh sách invoice.Payments
               - Cập nhật ngày giao dịch (TransDate) của mỗi thanh toán để đồng bộ với ngày mua hàng mới của hóa đơn:
                 + Đảm bảo tính nhất quán về thời gian giữa hóa đơn và các giao dịch thanh toán
                 + Điều này giúp báo cáo tài chính chính xác theo thời gian thực tế
               - Cập nhật thông tin người thanh toán (CreatedBy) nếu có sự thay đổi:
                 + Gán lại thông tin người thực hiện thanh toán theo dữ liệu mới
                 + Đảm bảo thông tin truy vết chính xác về người thực hiện giao dịch
               - Cập nhật phương thức thanh toán (Method) nếu có thay đổi:
                 + Ví dụ: thay đổi từ "Tiền mặt" sang "Chuyển khoản" hoặc các phương thức khác
                 + Hệ thống sẽ lưu lại phương thức thanh toán mới cho mỗi giao dịch
               - Lưu lại tất cả các thay đổi này vào cơ sở dữ liệu để đảm bảo dữ liệu thanh toán luôn đồng bộ với thông tin hóa đơn
               - Đảm bảo các thanh toán vẫn hợp lệ sau khi cập nhật (ví dụ: không được thanh toán bằng voucher khi offline)
             * Nếu có thanh toán COD (thu hộ), hệ thống sẽ cập nhật thông tin thanh toán tương ứng
             * Ghi nhận lịch sử thay đổi thanh toán vào nhật ký hệ thống
           - Cập nhật ngày hết hạn bảo hành nếu có
           - Tính toán lại tổng tiền hóa đơn
           - Cập nhật PaymentTrack nếu trạng thái hoặc ngày thay đổi
           - Gửi sự kiện cập nhật đến Elasticsearch
           - Nếu ngày thay đổi hoặc là hóa đơn OmniChannel với tổng tiền thay đổi, xây dựng danh sách theo dõi và thêm vào hàng đợi theo dõi
           - Trả về đối tượng hóa đơn đã cập nhật
    - Nếu tính năng KShipV4 đang được kích hoạt và thông tin giao hàng tồn tại với `UseDefaultPartner = false`:
      - Cập nhật thông tin đơn hàng tự giao thông qua `DeliveryInfoService.UpdateSelfDeliveryOrder()`
- **Tạo hóa đơn mới**:
  - Nếu đang tạo hóa đơn mới (`invoice.Id <= 0`):
    - Nếu là hóa đơn cập nhật (`invoice.UpdateInvoiceId > 0`):
      - Kiểm tra xem hóa đơn gốc có đang được xử lý bởi tác vụ vận chuyển không
    - Xử lý hủy vận đơn cũ nếu chuyển từ giao hàng bởi đối tác sang tự giao:
      - Nếu là hóa đơn cập nhật, thông tin giao hàng cũ sử dụng đối tác mặc định, có mã giao hàng, và thông tin giao hàng mới không sử dụng đối tác mặc định
      - Gọi API `DeliveryClient.VoidOrderV3()` để hủy vận đơn với đối tác vận chuyển
      - Nếu tính năng KShip bị tắt, hiển thị thông báo lỗi tương ứng
    - Lưu trữ ID đơn hàng đã hoàn thành (nếu có) để xử lý sau này
    - Tạo hóa đơn mới thông qua `InvoiceService.MakeInvoiceAsync()`
    - Nếu là hóa đơn kết hợp (`req.IsFormCombine`):
      - Cập nhật mô tả hóa đơn bằng cách thay thế "---" bằng mã hóa đơn
      - Cập nhật thông tin chung của hóa đơn
    - Xử lý thông tin giao hàng:
      - Nếu có thông tin giao hàng và là hóa đơn cập nhật, chuyển đổi thông tin giao hàng sang định dạng phù hợp
    - Xử lý trạng thái hóa đơn COD:
      - Nếu là hóa đơn cập nhật, sử dụng COD, có thông tin giao hàng và trạng thái giao hàng là "Đã giao":
        - Kiểm tra điều kiện thanh toán và cập nhật trạng thái hóa đơn từ "Chờ xử lý" sang "Đã phát hành" nếu thỏa mãn
        - Gửi thông báo cập nhật trạng thái đến hệ thống tìm kiếm
    - Cập nhật thông tin khách hàng và công nợ nếu có ID khách hàng
    - Xử lý trường hợp hóa đơn trùng lặp:
      - Nếu `invoice.IsDuplicated = true`, tạo bản sao hóa đơn và trả về kết quả
    - Lấy thông tin thanh toán và tạo chi tiết dòng tiền
    - Xử lý thông tin đơn hàng liên quan (nếu có)

### 18. Cập nhật thông tin sau khi lưu
- Cập nhật thông tin khách hàng: Cập nhật điểm tích lũy, lịch sử mua hàng
- Cập nhật công nợ: Tạo hoặc cập nhật PaymentTrack nếu invoice.CustomerId > 0
- Tạo chi tiết dòng tiền (CashflowDetails) cho các thanh toán
- Ghi log cho hóa đơn mới hoặc cập nhật thông qua AuditTrailService
- Cập nhật thông tin OriginalCOD trong DeliveryInfo nếu có giao hàng

### 19. Xử lý sự kiện giao hàng
- Nếu trạng thái giao hàng thay đổi, gửi thông báo sự kiện giao hàng
- Xử lý các trường hợp như: Đã giao hàng, Đang giao hàng, Đã hủy giao hàng
- Gửi thông báo đến các hệ thống liên quan như đối tác vận chuyển, ứng dụng khách hàng

### 20. Xử lý thông báo ZNS (nếu được cấu hình)
- Kiểm tra điều kiện: Là hóa đơn mới (isCreateNew = true), có cấu hình SMSEmailMarketing và UseZnsNotifyPurchase > 0
- Chuẩn bị nội dung thông báo ZNS dựa trên mẫu đã cấu hình
- Gửi thông báo ZNS cho khách hàng về việc mua hàng thành công
- Lưu lịch sử gửi thông báo để theo dõi và thống kê

## Các xử lý đặc biệt

### Xử lý đơn thuốc (nhà thuốc GPP)
- Kiểm tra đầy đủ thông tin đơn thuốc: PatientName, PatientAge, PatientGender, DoctorName, ClinicName
- Kiểm tra thông tin bệnh nhân: Tuổi phải hợp lệ, giới tính phải nằm trong danh sách cho phép
- Kiểm tra mã đơn thuốc (PrescriptionCode) không được trùng lặp với các đơn thuốc khác trong hệ thống
- Kiểm tra thuốc hết hạn: Lọc các sản phẩm là thuốc và so sánh ngày hiện tại với ngày hết hạn
- Tùy theo cấu hình hệ thống, có thể hiển thị cảnh báo hoặc ngăn chặn hoàn toàn việc bán thuốc hết hạn
- Xử lý các quy định đặc biệt về bán thuốc kê đơn, thuốc gây nghiện, thuốc hướng thần

### Xử lý COD (Thu hộ)
- Xác thực đối tác vận chuyển: Kiểm tra PartnerDeliveryId có tồn tại và đang hoạt động
- Kiểm tra dịch vụ vận chuyển: Xác thực ServiceId có hợp lệ và thuộc đối tác vận chuyển đã chọn
- Tính toán phí vận chuyển dựa trên dịch vụ, khoảng cách, trọng lượng
- Xử lý trạng thái vận đơn phù hợp với trạng thái hóa đơn:
  - Nếu hóa đơn hoàn thành, đánh dấu vận đơn là đã giao
  - Nếu hóa đơn hủy, đánh dấu vận đơn là đã hủy
- Cập nhật thông tin OriginalCod = invoice.Total - invoice.TotalPayment để theo dõi số tiền cần thu hộ
- Xử lý các trường hợp đặc biệt như thay đổi địa chỉ giao hàng, thay đổi đối tác vận chuyển

### Xử lý khuyến mãi
- Kiểm tra từng khuyến mãi mới xem có còn hoạt động không thông qua PromotionService
- Kiểm tra thời gian áp dụng khuyến mãi: Ngày bắt đầu, ngày kết thúc, khung giờ áp dụng
- Kiểm tra giới hạn sử dụng khuyến mãi của khách hàng:
  - Nếu LimitPromotionUsage = true và LimitPromotionUsageType = Blocking, kiểm tra số lần đã sử dụng
  - Nếu đã vượt quá giới hạn, từ chối áp dụng khuyến mãi
- Kiểm tra điều kiện áp dụng khuyến mãi: Giá trị đơn hàng tối thiểu, nhóm khách hàng, sản phẩm áp dụng
- Tính toán lại giá trị khuyến mãi dựa trên các quy tắc áp dụng

### Xử lý hóa đơn cập nhật
- Xử lý hủy vận đơn cũ nếu chuyển từ giao hàng bởi đối tác sang tự giao:
  - Nếu existOldInvoiceDeliveryInfo?.PartnerDeliveryId > 0 và invoice.DeliveryDetail?.PartnerDeliveryId <= 0
  - Gọi API hủy vận đơn của đối tác vận chuyển
- Cập nhật trạng thái hóa đơn dựa trên trạng thái giao hàng và thanh toán:
  - Nếu đã thanh toán đủ và đã giao hàng, đánh dấu hóa đơn là hoàn thành
  - Nếu đã hủy giao hàng, đánh dấu hóa đơn là đã hủy
- Xử lý các thanh toán mới: Tạo các phiếu thu tương ứng
- Cập nhật công nợ khách hàng dựa trên sự thay đổi giá trị hóa đơn

## Các ngoại lệ chính
- **KvValidateInvoiceException**: Lỗi liên quan đến hóa đơn như trùng lặp mã hóa đơn, UUID đã tồn tại, hóa đơn không tìm thấy, hoặc các lỗi validation khác liên quan đến hóa đơn
- **KvValidateCustomerException**: Lỗi liên quan đến khách hàng như khách hàng không tồn tại, không hoạt động, đã vượt quá giới hạn sử dụng khuyến mãi, hoặc không đủ điểm tích lũy
- **KvValidatePartnerDeliveryException**: Lỗi liên quan đến đối tác vận chuyển như đối tác không tồn tại, không hoạt động, dịch vụ vận chuyển không hợp lệ, hoặc không hỗ trợ COD
- **KvValidateDeliveryInfoException**: Lỗi liên quan đến thông tin giao hàng như địa chỉ không hợp lệ, thời gian giao hàng dự kiến không hợp lệ, hoặc phí vận chuyển không hợp lệ
- **KvValidateSaleChannelException**: Lỗi liên quan đến kênh bán hàng như kênh không tồn tại, không hoạt động, hoặc không có quyền truy cập
- **KvValidateClinicException**: Lỗi liên quan đến thông tin phòng khám/đơn thuốc như thiếu thông tin bắt buộc, mã đơn thuốc trùng lặp, hoặc thông tin bệnh nhân không hợp lệ
- **KVMedicineException**: Lỗi liên quan đến thuốc như thuốc hết hạn, thuốc không được phép bán, hoặc thuốc không đủ số lượng
- **KvValidateUserException**: Lỗi liên quan đến người dùng/nhân viên như người bán hàng không tồn tại, không hoạt động, hoặc không có quyền bán hàng
- **KvShippingResponseException**: Lỗi từ dịch vụ vận chuyển như không thể tạo vận đơn, không thể hủy vận đơn, hoặc dịch vụ vận chuyển không khả dụng

## Kết luận
Phương thức CreateInvoice thực hiện nhiều kiểm tra validation và xử lý business logic phức tạp để đảm bảo tính toàn vẹn của dữ liệu hóa đơn. Phương thức này xử lý nhiều trường hợp đặc biệt như hóa đơn cập nhật, hóa đơn có COD, hóa đơn nhà thuốc GPP, và tích hợp với nhiều dịch vụ khác như giao hàng, khuyến mãi, và thông báo khách hàng. Việc hiểu rõ các bước xử lý và các điều kiện nghiệp vụ trong phương thức này là rất quan trọng để phát triển và bảo trì hệ thống KiotViet một cách hiệu quả.
