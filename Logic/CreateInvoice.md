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
- **Xác định hóa đơn cập nhật hiện có**:
  - Hệ thống kiểm tra điều kiện `invoice.Id > 0` để xác định đây là một yêu cầu cập nhật hóa đơn đã tồn tại trong hệ thống
  - Khi cập nhật hóa đơn hiện có, cần thực hiện các kiểm tra để đảm bảo không ghi đè lên các thay đổi mới hơn đã được thực hiện bởi người dùng khác

- **Truy xuất thông tin giao hàng hiện tại**:
  - Hệ thống gọi phương thức bất đồng bộ: `di = await DeliveryInfoService.GetLastByInvoiceIdAsync(invoice.Id)`
  - Phương thức này lấy thông tin giao hàng mới nhất của hóa đơn từ cơ sở dữ liệu
  - Thông tin này sẽ được sử dụng để so sánh với thông tin giao hàng trong yêu cầu cập nhật

- **Kiểm tra xung đột thông tin giao hàng**:
  - Hệ thống kiểm tra điều kiện: `di?.UseDefaultPartner == true` (hóa đơn hiện tại đang sử dụng đối tác vận chuyển mặc định)
  - Đồng thời kiểm tra xem trong yêu cầu cập nhật: `invoice.DeliveryDetail == null` (không có thông tin giao hàng) hoặc `invoice.DeliveryDetail.UseDefaultPartner == false` (không sử dụng đối tác vận chuyển mặc định)
  - Nếu điều kiện này đúng, có nghĩa là đang có sự thay đổi không nhất quán về cấu hình đối tác vận chuyển

- **Kiểm tra xung đột trạng thái hóa đơn**:
  - Hệ thống so sánh trạng thái hiện tại của hóa đơn với trạng thái trong yêu cầu cập nhật: `inv.Status != invoice.Status`
  - Nếu trạng thái đã thay đổi, có thể có người dùng khác đã cập nhật hóa đơn này (ví dụ: đã hoàn thành hoặc đã hủy)
  - Việc ghi đè lên trạng thái mới có thể gây ra mất dữ liệu hoặc xung đột logic nghiệp vụ

- **Xử lý khi phát hiện xung đột**:
  - Nếu phát hiện bất kỳ xung đột nào (về thông tin giao hàng hoặc trạng thái), hệ thống sẽ ném ra ngoại lệ `KvValidateException`
  - Thông báo lỗi sẽ là `"OverwriteNewerCopyNotAllowed"` (Không được phép ghi đè phiên bản mới hơn)
  - Người dùng sẽ được thông báo để tải lại dữ liệu mới nhất và thực hiện lại các thay đổi của họ
  - Cơ chế này đảm bảo tính toàn vẹn dữ liệu trong môi trường nhiều người dùng đồng thời cập nhật cùng một hóa đơn

- **Lợi ích của cơ chế kiểm tra xung đột**:
  - Ngăn chặn việc vô tình ghi đè lên các thay đổi mới hơn
  - Đảm bảo tính nhất quán của dữ liệu trong hệ thống
  - Giảm thiểu rủi ro mất dữ liệu do cập nhật đồng thời
  - Cung cấp thông báo rõ ràng cho người dùng khi xảy ra xung đột

### 5. Kiểm tra khuyến mãi
- **Lọc các khuyến mãi mới**:
  - Hệ thống thực hiện truy vấn: `newPromotions = invoice.InvoicePromotions?.Where(p => p.Id == 0 && p.PromotionId != null)`
  - Chỉ lấy các khuyến mãi có Id = 0 (chưa được lưu vào cơ sở dữ liệu) và có PromotionId không null
  - Điều này giúp xác định các khuyến mãi mới được thêm vào hóa đơn trong quá trình tạo hoặc cập nhật

- **Xác thực tính hợp lệ của từng khuyến mãi**:
  - Với mỗi khuyến mãi mới, hệ thống gọi phương thức bất đồng bộ: `PromotionService.GetByIdAsync(promotion.PromotionId.Value)`
  - Phương thức này truy vấn cơ sở dữ liệu để lấy thông tin chi tiết về chương trình khuyến mãi
  - Hệ thống kiểm tra xem khuyến mãi có tồn tại trong hệ thống không (promotionDb != null)
  - Đồng thời kiểm tra trạng thái hoạt động của khuyến mãi (promotionDb.Status == (int)PromotionStatus.Active)

- **Xử lý khuyến mãi không hợp lệ**:
  - Nếu khuyến mãi không tồn tại, hệ thống ném ra ngoại lệ `KvValidateException` với thông báo: `KVMessage.PromotionNotFound`
  - Nếu khuyến mãi đã bị vô hiệu hóa, hệ thống ném ra ngoại lệ `KvValidateException` với thông báo: `KVMessage.PromotionInactive`
  - Nếu khuyến mãi đã bị xóa, hệ thống ném ra ngoại lệ `KvValidateException` với thông báo: `KVMessage.PromotionDeleted`
  - Các thông báo lỗi này giúp người dùng hiểu rõ lý do tại sao không thể áp dụng khuyến mãi

- **Kiểm tra thời gian áp dụng khuyến mãi**:
  - Hệ thống so sánh thời gian hiện tại với thời gian bắt đầu và kết thúc của khuyến mãi
  - Nếu thời gian hiện tại < thời gian bắt đầu, ném ra ngoại lệ với thông báo: `KVMessage.PromotionNotStarted`
  - Nếu thời gian hiện tại > thời gian kết thúc, ném ra ngoại lệ với thông báo: `KVMessage.PromotionExpired`
  - Điều này đảm bảo khuyến mãi chỉ được áp dụng trong khoảng thời gian hợp lệ

- **Kiểm tra giới hạn sử dụng khuyến mãi**:
  - Hệ thống kiểm tra xem khuyến mãi có giới hạn số lần sử dụng không (promotionDb.LimitUsage == true)
  - Nếu có, hệ thống gọi phương thức: `PromotionService.CheckLimitUsage(promotionDb, invoice.CustomerId)`
  - Phương thức này kiểm tra số lần khách hàng đã sử dụng khuyến mãi và so sánh với giới hạn cho phép
  - Nếu vượt quá giới hạn, ném ra ngoại lệ với thông báo chi tiết về số lần đã sử dụng và giới hạn

- **Kiểm tra đối tượng áp dụng khuyến mãi**:
  - Hệ thống xác thực xem khuyến mãi có áp dụng cho khách hàng hiện tại không
  - Kiểm tra điều kiện về nhóm khách hàng: `PromotionService.CheckCustomerGroup(promotionDb, invoice.CustomerId)`
  - Kiểm tra điều kiện về kênh bán hàng: `PromotionService.CheckSaleChannel(promotionDb, invoice.SaleChannelId)`
  - Nếu không thỏa mãn các điều kiện, ném ra ngoại lệ với thông báo phù hợp

- **Kiểm tra điều kiện áp dụng khuyến mãi**:
  - Hệ thống xác thực các điều kiện như giá trị đơn hàng tối thiểu, số lượng sản phẩm tối thiểu
  - Kiểm tra xem các sản phẩm trong hóa đơn có thuộc danh sách sản phẩm được áp dụng khuyến mãi không
  - Nếu không thỏa mãn điều kiện, ném ra ngoại lệ với thông báo chi tiết về điều kiện áp dụng

- **Lợi ích của việc kiểm tra khuyến mãi**:
  - Đảm bảo tính hợp lệ của các khuyến mãi được áp dụng
  - Ngăn chặn việc lạm dụng hoặc áp dụng sai khuyến mãi
  - Cung cấp thông báo rõ ràng cho người dùng khi khuyến mãi không thể áp dụng
  - Duy trì tính nhất quán trong chính sách khuyến mãi của doanh nghiệp

### 6. Kiểm tra UUID
- **Xác thực tính duy nhất của UUID**:
  - Hệ thống gọi phương thức bất đồng bộ `CheckUuidAsync(invoice)` để kiểm tra và xử lý UUID của hóa đơn
  - Phương thức này kiểm tra xem UUID đã tồn tại trong hệ thống hay chưa thông qua truy vấn cơ sở dữ liệu
  - Nếu UUID đã tồn tại và thuộc về hóa đơn khác, hệ thống sẽ ném ra ngoại lệ `KvValidateInvoiceException` với thông báo `KVMessage.invoiceLog_OnlineInvoiceCodeIsDup`

- **Xử lý UUID trong trường hợp đặc biệt**:
  - Nếu `InvoiceProcessingToggle` được bật và `invoice.Id <= 0` (hóa đơn mới)
  - Hệ thống kiểm tra thêm điều kiện: UUID không rỗng (`!string.IsNullOrEmpty(invoice.Uuid)`) và mã hóa đơn không bắt đầu bằng tiền tố offline (`!invoice.Code.StartsWith(Invoice.OffCodePrefix)`)
  - Trong trường hợp này, hệ thống sẽ kiểm tra UUID trong bộ nhớ cache Redis thông qua `InvoiceService.CheckCachRedisUUID(invoice.Uuid)`
  - Nếu UUID đã tồn tại trong cache, hệ thống ném ra ngoại lệ với thông báo trùng lặp kèm theo thời gian tạo

- **Lưu trữ UUID mới vào cache**:
  - Sau khi xác nhận UUID chưa tồn tại, hệ thống lưu UUID mới vào Redis cache thông qua `InvoiceService.SaveCachRedisUUID(invoice.Uuid)`
  - Việc này giúp ngăn chặn các yêu cầu tạo hóa đơn trùng lặp trong khoảng thời gian ngắn, đặc biệt hữu ích trong môi trường có nhiều người dùng đồng thời

- **Tạo UUID mới nếu cần thiết**:
  - Nếu hóa đơn không có UUID (`string.IsNullOrEmpty(invoice.Uuid)`), hệ thống sẽ tự động tạo một UUID mới
  - UUID mới được tạo theo định dạng chuẩn sử dụng `Guid.NewGuid().ToString()`
  - Điều này đảm bảo mỗi hóa đơn đều có một định danh duy nhất trên toàn hệ thống

- **Xử lý UUID trong trường hợp cập nhật hóa đơn**:
  - Khi cập nhật hóa đơn (invoice.Id > 0), hệ thống kiểm tra xem UUID có thay đổi không
  - Nếu UUID mới khác với UUID cũ, hệ thống sẽ thực hiện kiểm tra tính duy nhất của UUID mới
  - Trong trường hợp UUID mới đã tồn tại, hệ thống sẽ giữ nguyên UUID cũ và ghi log cảnh báo

- **Lợi ích của việc kiểm tra UUID**:
  - Ngăn chặn việc tạo các hóa đơn trùng lặp, đặc biệt quan trọng trong môi trường đa người dùng
  - Hỗ trợ đồng bộ dữ liệu giữa các hệ thống khác nhau thông qua định danh duy nhất
  - Đảm bảo tính toàn vẹn dữ liệu trong cơ sở dữ liệu
  - Tạo điều kiện thuận lợi cho việc truy xuất và tham chiếu hóa đơn trong các quy trình nghiệp vụ khác

### 7. Xử lý thông tin giao hàng COD
- **Kiểm tra điều kiện sử dụng COD**:
  - Hệ thống kiểm tra thuộc tính `invoice.DeliveryDetail?.UsingCod == 1` để xác định hóa đơn có sử dụng dịch vụ thu hộ (COD - Cash On Delivery) hay không
  - Nếu sử dụng COD, hệ thống sẽ thực hiện các bước xác thực bổ sung để đảm bảo thông tin giao hàng hợp lệ
  - Trường hợp `UsingCod != 1`, hệ thống bỏ qua các bước xác thực liên quan đến COD

- **Xác thực đối tác vận chuyển**:
  - Hệ thống kiểm tra `PartnerDeliveryId` thông qua `PartnerDeliveryService.GetByIdAsync(invoice.DeliveryDetail.PartnerDeliveryId)`
  - Xác nhận đối tác vận chuyển tồn tại trong hệ thống và có trạng thái hoạt động (`IsActive == true`)
  - Nếu đối tác vận chuyển không tồn tại hoặc không hoạt động, hệ thống sẽ ném ra ngoại lệ `KvValidateDeliveryInfoException` với thông báo lỗi phù hợp
  - Kiểm tra thêm điều kiện đối tác vận chuyển có hỗ trợ dịch vụ COD không thông qua thuộc tính `SupportCod`

- **Kiểm tra dịch vụ vận chuyển**:
  - Hệ thống xác thực `ServiceId` thông qua `DeliveryServiceService.GetByIdAsync(invoice.DeliveryDetail.ServiceId)`
  - Kiểm tra dịch vụ vận chuyển có thuộc về đối tác vận chuyển đã chọn không (`service.PartnerDeliveryId == invoice.DeliveryDetail.PartnerDeliveryId`)
  - Xác nhận dịch vụ vận chuyển đang hoạt động (`IsActive == true`) và hỗ trợ COD (`SupportCod == true`)
  - Nếu dịch vụ vận chuyển không hợp lệ, hệ thống sẽ ném ra ngoại lệ với thông báo chi tiết về lỗi

- **Xử lý giá trị COD**:
  - Hệ thống tính toán giá trị COD dựa trên tổng giá trị hóa đơn trừ đi số tiền đã thanh toán: `invoice.Total - invoice.TotalPayment`
  - Cập nhật giá trị `OriginalCod` trong thông tin giao hàng để lưu trữ giá trị COD ban đầu
  - Kiểm tra giá trị COD không vượt quá giới hạn cho phép của đối tác vận chuyển (nếu có)

- **Xử lý trạng thái vận đơn theo trạng thái hóa đơn**:
  - Hệ thống tự động cập nhật trạng thái vận đơn (`ShippingStatus`) dựa trên trạng thái hiện tại của hóa đơn (`invoice.Status`)
  - Nếu `invoice.Status == (int)InvoiceStatus.Completed`, hệ thống đặt `ShippingStatus = (int)ShippingStatus.Delivered` để đánh dấu vận đơn đã giao thành công
  - Nếu `invoice.Status == (int)InvoiceStatus.Cancelled`, hệ thống đặt `ShippingStatus = (int)ShippingStatus.Cancelled` để đánh dấu vận đơn đã hủy
  - Trong các trường hợp khác (như đang xử lý, đang giao hàng), hệ thống giữ nguyên `ShippingStatus` hiện tại
  - Việc đồng bộ trạng thái này đảm bảo tính nhất quán giữa hóa đơn và thông tin giao hàng

- **Cập nhật thông tin giao hàng trong cơ sở dữ liệu**:
  - Sau khi xác thực và xử lý, hệ thống lưu thông tin giao hàng vào bảng `DeliveryInfo` với thuộc tính `IsCurrent = true`
  - Nếu đang cập nhật hóa đơn, hệ thống sẽ đánh dấu các thông tin giao hàng cũ là `IsCurrent = false`
  - Hệ thống ghi log các thay đổi trong thông tin giao hàng để phục vụ mục đích kiểm tra và theo dõi

- **Xử lý thông báo cho đối tác vận chuyển**:
  - Nếu cấu hình cho phép, hệ thống sẽ tự động gửi thông tin đơn hàng COD đến đối tác vận chuyển
  - Thông tin gửi đi bao gồm địa chỉ giao hàng, giá trị COD, thông tin người nhận và các yêu cầu đặc biệt
  - Hệ thống lưu trữ mã vận đơn (`TrackingCode`) được trả về từ đối tác vận chuyển để theo dõi

### 8. Xử lý thông tin địa chỉ giao hàng
- Kiểm tra nếu có thông tin LocationName và WardName nhưng không có LocationId và WardId
- Gọi các service tương ứng để lấy LocationId từ LocationName và WardId từ WardName
- Cập nhật WardId và LocationId cho thông tin giao hàng
- Xử lý các trường hợp đặc biệt như địa chỉ không tìm thấy, địa chỉ không thuộc phạm vi giao hàng

### 9. Kiểm tra khách hàng
- Nếu CustomerId < 0, ném ngoại lệ KvValidateCustomerException với thông báo phù hợp
- Nếu CustomerId > 0, kiểm tra khách hàng có tồn tại và đang hoạt động không
- Kiểm tra kênh bán hàng (SaleChannelId) có tồn tại và đang hoạt động không thông qua SaleChannelService
- Xác thực các thông tin liên quan đến khách hàng như nhóm khách hàng, bảng giá áp dụng, điểm tích lũy

### 10. Kiểm tra thời gian giao hàng dự kiến
- Nếu invoice.DeliveryDetail?.ExpectedDelivery <= invoice.PurchaseDate, ném ngoại lệ KvValidateDeliveryInfoException
- Thông báo lỗi yêu cầu thời gian giao hàng dự kiến phải sau thời gian mua hàng
- Đảm bảo tính logic về mặt thời gian trong quy trình giao hàng

### 11. Kiểm tra giới hạn sử dụng khuyến mãi
- Lọc các khuyến mãi có LimitPromotionUsage = true và LimitPromotionUsageType = Blocking
- Với mỗi khuyến mãi, kiểm tra xem khách hàng đã sử dụng khuyến mãi này chưa thông qua PromotionService
- Nếu khách hàng đã sử dụng khuyến mãi vượt quá giới hạn, ném ngoại lệ KvValidateCustomerException
- Thông báo chi tiết về giới hạn sử dụng và số lần đã sử dụng

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
