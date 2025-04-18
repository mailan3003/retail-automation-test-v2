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

- **Quy trình kiểm tra chi tiết**:
  - **Bước 1: Lọc khuyến mãi cần kiểm tra**
    - Hệ thống lọc ra các khuyến mãi có thiết lập giới hạn sử dụng (`LimitPromotionUsage = true`)
    - Chỉ xét các khuyến mãi có chế độ chặn (`LimitPromotionUsageType = (int)EnumLimitPromotionUsageTypes.Blocking`)
    - Mã thực hiện:
      ```csharp
      var listPType = invoice.InvoicePromotions.Where(p => 
          p.LimitPromotionUsage.HasValue && p.LimitPromotionUsage == true &&
          p.LimitPromotionUsageType.HasValue && p.LimitPromotionUsageType == (int)EnumLimitPromotionUsageTypes.Blocking
      ).ToList();
      ```

  - **Bước 2: Truy vấn lịch sử sử dụng khuyến mãi**
    - Nếu có khuyến mãi cần kiểm tra (`listPType != null && listPType.Any()`):
      - Gọi service để lấy lịch sử sử dụng khuyến mãi của khách hàng:
        ```csharp
        var invPromo = await InvoicePromotionService.GetUsePromotionByCustomer(
            invoice.RetailerId,
            invoice.CustomerId.Value,
            listPType.Select(a => a.PromotionId.Value).ToList()
        );
        ```
      - Service truy vấn cơ sở dữ liệu để lấy tất cả các khuyến mãi đã sử dụng của khách hàng:
        - Lọc theo cửa hàng hiện tại (`RetailerId == retailId`)
        - Lọc theo khách hàng (`Invoice.CustomerId == customerId`)
        - Chỉ xét các hóa đơn hợp lệ (không bị hủy hoặc thất bại: `Invoice.Status != InvoiceState.Void && Invoice.Status != InvoiceState.Failed`)
        - Chỉ xét các khuyến mãi nằm trong danh sách cần kiểm tra (`WhereIn(listPromotionUse, p => p.PromotionId.Value)`)
      - Kết quả trả về là danh sách các khuyến mãi khách hàng đã sử dụng vượt quá giới hạn cho phép

  - **Bước 3: Xử lý vi phạm giới hạn**
    - Nếu phát hiện khách hàng đã sử dụng khuyến mãi vượt quá giới hạn (`invPromo != null && invPromo.Any()`):
      - Hệ thống tạo thông báo lỗi chi tiết bao gồm tên các khuyến mãi vi phạm:
        ```csharp
        throw new KvValidateCustomerException(
            string.Format(KVMessage.customerError_promotionBlock, 
            invPromo.Select(p => p.PromotionInfo).Distinct().Join(","))
        );
        ```
      - Thông báo lỗi sẽ liệt kê tên các khuyến mãi đã vượt giới hạn, ví dụ: "Khách hàng đã được hưởng các khuyến mại: Giảm 10%, Mua 1 tặng 1, vui lòng kiểm tra lại."

### 12. Xử lý thông tin đơn thuốc (nếu là nhà thuốc GPP)
- Kiểm tra nếu CurrentIndustryId == (int)IndustryList.Pharmacy và invoice.ClinicInfo != null
- Xác thực thông tin đơn thuốc: Kiểm tra các trường bắt buộc như PatientName, PatientAge, PatientGender
- Kiểm tra mã đơn thuốc (PrescriptionCode) không được trùng lặp với các đơn thuốc khác
- Kiểm tra thuốc hết hạn: Lọc các sản phẩm là thuốc và kiểm tra ngày hết hạn
- Hiển thị cảnh báo hoặc ngăn chặn bán thuốc hết hạn tùy theo cấu hình hệ thống

### 13. Kiểm tra người bán hàng
- Xác thực người bán hàng (SoldById) có tồn tại và đang hoạt động thông qua UserService
- Kiểm tra quyền hạn của người bán hàng có phù hợp với loại hóa đơn không
- Nếu người bán hàng không hợp lệ, ném ngoại lệ KvValidateUserException với thông báo phù hợp

### 14. Kiểm tra thông tin thanh toán
- Duyệt qua danh sách invoice.Payments để kiểm tra từng phương thức thanh toán
- Nếu phương thức thanh toán là Card hoặc Transfer, xác thực tài khoản ngân hàng (BankAccountId)
- Kiểm tra tổng số tiền thanh toán có phù hợp với tổng giá trị hóa đơn không
- Xử lý các trường hợp đặc biệt như thanh toán bằng điểm tích lũy, thanh toán bằng thẻ quà tặng

### 15. Xử lý thông tin giao hàng hiện tại
- Nếu đang cập nhật hóa đơn (invoice.Id > 0), lấy thông tin giao hàng hiện tại
- Kiểm tra sự thay đổi trong thông tin giao hàng để xử lý phù hợp
- Xử lý các trường hợp đặc biệt như chuyển từ tự giao sang giao bởi đối tác hoặc ngược lại

### 16. Kiểm tra kho hàng
- Xác thực trạng thái của kho hàng (BranchId) có đang hoạt động không
- Kiểm tra quyền truy cập vào kho hàng của người dùng hiện tại
- Nếu kho hàng không hợp lệ, ném ngoại lệ với thông báo phù hợp

### 17. Lưu hoặc cập nhật hóa đơn
- Nếu invoice.Id > 0, gọi UpdateInvoiceAsync(invoice) để cập nhật hóa đơn hiện có
- Nếu invoice.Id <= 0, gọi MakeInvoiceAsync(invoice) để tạo hóa đơn mới
- Xử lý các trường hợp đặc biệt:
  - Hóa đơn kết hợp (invoice.IsCombo = true): Xử lý các sản phẩm combo
  - Hóa đơn trùng lặp: Kiểm tra và xử lý trùng lặp mã hóa đơn
  - Hóa đơn từ đơn đặt hàng: Cập nhật trạng thái đơn đặt hàng gốc
  - Hóa đơn từ kênh bán hàng online: Xử lý đồng bộ trạng thái với kênh bán hàng

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
