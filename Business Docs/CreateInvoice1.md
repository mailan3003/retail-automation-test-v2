# Logic nghiệp vụ tạo hóa đơn

## 1. Kiểm tra và xác thực dữ liệu đầu vào

### 1.1. Xử lý mã hóa đơn
- Kiểm tra hóa đơn trùng lặp khi đồng bộ offline:
  + Kiểm tra mã hóa đơn đã tồn tại trong hệ thống
  + Kiểm tra UUID của hóa đơn trong vòng 7 ngày trước và sau ngày tạo
  + Đánh dấu hóa đơn là trùng lặp (IsDuplicated = true) nếu tìm thấy
  + Ghi log audit trail khi phát hiện mã hóa đơn trùng lặp

- Xử lý prefix khác nhau cho hóa đơn:
  + HDO: Hóa đơn offline
  + LazadaPrefix: Hóa đơn từ Lazada 
  + ShopeePrefix: Hóa đơn từ Shopee
  + FacebookPrefix: Hóa đơn từ Facebook
  + InstagramPrefix: Hóa đơn từ Instagram 
  + WarrantyPrefix: Hóa đơn bảo hành
  + TikiPrefix: Hóa đơn từ Tiki
  + SendoPrefix: Hóa đơn từ Sendo

- Sinh mã hóa đơn tự động theo định dạng từng loại:
  + Hóa đơn thường: Tự động tăng số thứ tự
  + Hóa đơn update: Thêm dấu chấm và số thứ tự vào cuối mã hóa đơn gốc
  + Hóa đơn clone: Thêm dấu chấm và số thứ tự vào cuối mã hóa đơn gốc
  + Hóa đơn bị thay thế: Duy trì mã hóa đơn gốc để trace
  + Validate độ dài mã hóa đơn không vượt quá 50 ký tự
  + Xử lý trường hợp đặc biệt cho hóa đơn từ FBPos và Instagram:
    * FBPos: Thêm prefix FB_ vào mã
    * Instagram: Thêm prefix IG_ vào mã
    * Tiktok: Thêm prefix TT_ vào mã

- Xử lý trường hợp hóa đơn bị trùng mã:
  + Kiểm tra mã hóa đơn đã tồn tại
  + Nếu là hóa đơn offline (HDO) thì cho phép trùng mã
  + Nếu là hóa đơn thường thì tăng số thứ tự lên 1 đơn vị
  + Lưu thông tin mã hóa đơn gốc vào trường CompareCode
  + Validate quyền cập nhật khi thay đổi mã hóa đơn

### 1.2. Kiểm tra quyền và điều kiện
- Kiểm tra quyền tạo hóa đơn của người dùng:
  + Kiểm tra quyền Invoice._Create cho hóa đơn mới
  + Kiểm tra quyền Invoice._Update cho hóa đơn cập nhật
  + Kiểm tra quyền Invoice._Delete cho hóa đơn hủy
  + Kiểm tra quyền Order.MakeInvoice nếu tạo từ đơn hàng
  + Kiểm tra quyền Invoice.ModifySeller nếu người tạo khác người bán
  + Nếu không có quyền Return._Read và Return._Update thì không cho phép thay đổi ngày hóa đơn có trả hàng

- Kiểm tra điều kiện về thời gian:
  + Validate ngày tạo hóa đơn không được trước ngày khóa sổ (BookClosingDate) của chi nhánh
  + Validate ngày tạo/cập nhật không được trước ngày phát sinh đầu tiên
  + Validate ngày hóa đơn không được lớn hơn ngày hiện tại nếu có cấu hình NotAllowModifyInvoiceDate
  + Kiểm tra thời gian tạo hóa đơn không được trước thời gian tạo đơn hàng
  + Validate thanh toán không được trước ngày hóa đơn
  + Validate ngày giao hàng dự kiến không được trước ngày hóa đơn

- Kiểm tra quyền truy cập chi nhánh:
  + Kiểm tra người dùng có quyền truy cập chi nhánh của hóa đơn
  + Với kho cấp 2, kiểm tra quyền truy cập vào kho master
  + Kiểm tra khách hàng có thuộc chi nhánh quản lý không (nếu bật ManagerCustomerByBranch)
  + Kiểm tra quyền truy cập chi nhánh khi void hóa đơn
  + Kiểm tra quyền truy cập khi chuyển chi nhánh xuất hàng

- Kiểm tra trạng thái đơn hàng:
  + Không cho phép tạo hóa đơn từ đơn hàng đã hoàn thành (Finalized)
  + Không cho phép tạo hóa đơn từ đơn hàng đã hủy (Void)
  + Kiểm tra đơn hàng phải thuộc cùng Retailer với hóa đơn
  + Kiểm tra trạng thái đơn hàng phải là Ongoing khi tạo hóa đơn

- Kiểm tra định dạng ngày tháng:
  + Validate ngày tạo hóa đơn phải có giá trị
  + Kiểm tra định dạng ngày theo múi giờ của chi nhánh
  + Validate ngày tạo hóa đơn phải nhỏ hơn hoặc bằng ngày hiện tại
  + Kiểm tra tính hợp lệ của ngày giao hàng dự kiến
  + Kiểm tra tính hợp lệ của thời gian bảo hành

### 1.3. Kiểm tra tồn kho
- Kiểm tra số lượng tồn kho sản phẩm:
  + Lấy danh sách sản phẩm từ chi tiết hóa đơn
  + Lấy thông tin tồn kho hiện tại của sản phẩm theo chi nhánh
  + Kiểm tra với từng sản phẩm:
    * Tính tổng số lượng đã đặt từ các đơn hàng chưa hoàn thành
    * Trừ đi số lượng đã đặt từ đơn hàng hiện tại (nếu có)
    * So sánh (Tồn kho - Số lượng đặt) với số lượng cần bán
    * Báo lỗi nếu không đủ số lượng và không cho phép bán âm

- Cho phép bán âm nếu có cấu hình AllowSellWhenOutStock:
  + Kiểm tra cấu hình AllowSellWhenOutStock trong POS Setting
  + Kiểm tra cấu hình riêng AllowSellWhenOutStock của hóa đơn
  + Kiểm tra cấu hình AllowSellWhenOrderOutStock cho đơn hàng
  + Cho phép bán kể cả khi không đủ tồn nếu thỏa một trong các điều kiện trên
  + Ghi nhận số lượng tồn kho âm nếu được phép bán

- Kiểm tra tồn kho theo lô/serial:
  + Kiểm tra sản phẩm có quản lý theo lô/serial không
  + Validate số serial không được trùng lặp trong hệ thống
  + Kiểm tra số serial phải tồn tại trong kho
  + Kiểm tra số serial không được sử dụng bởi chứng từ khác
  + Kiểm tra trạng thái của serial phải là InStock
  + Kiểm tra serial không được sử dụng trong kiểm kho gần nhất
  + Validate serial theo chi nhánh quản lý
  + Không cho phép một serial xuất hiện ở nhiều chi nhánh
  + Kiểm tra thời gian tạo không được trước thời gian nhập serial

- Kiểm tra tồn kho với sản phẩm combo:
  + Lấy danh sách các sản phẩm con trong combo
  + Tính tổng số lượng cần thiết cho mỗi sản phẩm con:
    * Số lượng = Số lượng combo * Định mức trong combo
  + Kiểm tra tồn kho cho từng sản phẩm con như sản phẩm thường
  + Báo lỗi chi tiết nếu thiếu bất kỳ sản phẩm con nào
  + Áp dụng quy tắc cho phép bán âm nếu được cấu hình

- Xử lý đặc biệt cho sản phẩm theo lô (batch):
  + Validate thông tin lô không được để trống
  + Kiểm tra lô phải tồn tại trong hệ thống
  + Kiểm tra số lượng tồn theo lô
  + Kiểm tra hạn sử dụng của lô
  + Không cho phép bán lô đã hết hạn
  + Kiểm tra lô không được sử dụng trong kiểm kho gần nhất
  + Tính toán số lượng theo đơn vị chuyển đổi của lô
  + Ghi log theo dõi thay đổi số lượng của lô
### 1.4. Xử lý xác thực với MISA/VNPT eInvoice APIs
- Xác thực tài khoản VNPT eInvoice:
  + Validate thông tin đăng nhập:
    * Kiểm tra username không được để trống (EInvoice_VNPT_Username)
    * Kiểm tra password không được để trống (EInvoice_VNPT_Password)
    * Giải mã password được mã hóa từ PosSetting
  + Validate template:
    * Kiểm tra templateNo hợp lệ theo danh sách từ GetInvoiceTemplates API
    * Kiểm tra pattern phù hợp với loại hóa đơn
    * Validate template còn hiệu lực 
  + Xác thực XML hóa đơn:
    * Kiểm tra cấu trúc XML theo quy định VNPT
    * Validate các trường bắt buộc trong XML
    * Kiểm tra định dạng các trường số, ngày tháng

- Xác thực tài khoản MISA eInvoice:
  + Validate thông tin access token:
    * Kiểm tra token không được để trống (EInvoice_MISA_Token)  
    * Kiểm tra thời hạn hiệu lực của token
    * Tự động refresh token khi hết hạn
  + Validate template:
    * Kiểm tra templateNo tồn tại trong hệ thống MISA
    * Template phải phù hợp với loại hóa đơn
    * Validate các field required của template
  + Xác thực dữ liệu hóa đơn:
    * Kiểm tra định dạng JSON gửi lên
    * Validate các trường bắt buộc theo template
    * Kiểm tra ràng buộc nghiệp vụ của MISA

- Xử lý lỗi phát hành hóa đơn điện tử:
  + Lỗi xác thực tài khoản:
    * Ghi log chi tiết lỗi đăng nhập
    * Thông báo kiểm tra lại thông tin tài khoản
    * Cho phép cập nhật lại thông tin đăng nhập
  + Lỗi template không hợp lệ:
    * Log thông tin template bị lỗi
    * Thông báo lựa chọn lại template phù hợp
    * Tự động lấy lại danh sách template mới
  + Lỗi dữ liệu hóa đơn:
    * Ghi log chi tiết các trường dữ liệu lỗi
    * Hiển thị thông báo lỗi cụ thể
    * Cho phép sửa lại dữ liệu không hợp lệ
  + Lỗi kết nối API:
    * Thử lại tối đa 3 lần với delay 5s
    * Log lỗi vào bảng DeliveryApiLog
    * Gửi thông báo cho người quản trị
    * Đánh dấu hóa đơn để phát hành lại sau

- Quản lý trạng thái hóa đơn điện tử:
  + Trạng thái chờ phát hành:
    * Lưu thông tin template đã chọn
    * Lưu trạng thái EInvoiceStatus = Pending
    * Đánh dấu thời gian bắt đầu chờ phát hành
  + Trạng thái đã phát hành:
    * Cập nhật InvoiceNo và Pattern từ response
    * Lưu trạng thái EInvoiceStatus = Success
    * Ghi log thời gian phát hành thành công
  + Trạng thái lỗi phát hành:
    * Lưu error message từ nhà cung cấp
    * Cập nhật EInvoiceStatus = Failed
    * Cho phép thử phát hành lại

## 2. Tính toán giá trị hóa đơn

### 2.1. Tính điểm thưởng 
- Tính điểm cho hóa đơn theo cấu hình RewardPoint_Type:
  + RewardPoint_Type = Invoice:
    * Chỉ áp dụng khi CustomerId > 0 và MoneyPerPoint > 0
    * Tổng tiền tích điểm = Total - Surcharge - TotalTax 
    * Điểm = Floor(Tổng tiền tích điểm / MoneyPerPoint)
    * Kiểm tra nhóm khách hàng được phép tích điểm (RewardPoint_ForAllCustomer)
    * Nếu RewardPoint_ForDiscountInvoice = true: tính điểm trên giá đã giảm
    * Bỏ qua sản phẩm có UsePoint = false
  
  + RewardPoint_Type = Product:
    * Chỉ tính điểm cho sản phẩm có UsePoint = true
    * Tổng điểm = Sum(Số lượng * Point của sản phẩm)
    * Kiểm tra nhóm khách hàng được phép tích điểm (RewardPoint_Product_ForAllCustomer)
    * Cập nhật vào trường Point của InvoiceDetail
    * Ghi log sử dụng điểm vào PointTracking

- Tính điểm từ khuyến mãi tặng điểm:
  + Lọc các khuyến mãi có Type = PROMOTION_INVOICE_DONATE_POINT, PROMOTION_PRODUCT_DONATE_POINT
  + Tổng điểm khuyến mãi = Sum(PromotionValue) của các khuyến mãi thỏa điều kiện
  + Lưu thông tin điểm thưởng vào InvoicePromotion
  + Cộng điểm khuyến mãi vào tổng điểm của hóa đơn

### 2.2. Tính chiết khấu và khuyến mãi
- Tính chiết khấu chung cho hóa đơn:
  + SubTotal = Sum(InvoiceDetail.Quantity * InvoiceDetail.Price)
  + Nếu có Discount:
    * DiscountRatio = Discount / SubTotal
    * Chiết khấu từng dòng = Quantity * Price * DiscountRatio
  + Làm tròn chiết khấu theo CurrencyDecimalPlaceForProduct
  + Cập nhật vào InvoiceDetail.Discount

- Tính khuyến mãi cho hóa đơn:
  + Khuyến mãi giảm giá hóa đơn:
    * PROMOTION_INVOICE_DISCOUNT: Giảm trực tiếp trên tổng hóa đơn
    * PROMOTION_INVOICE_DISCOUNT_ON_PRODUCT: Giảm trên từng sản phẩm đủ điều kiện
  + Khuyến mãi tặng sản phẩm:
    * PROMOTION_INVOICE_DONATE_PRODUCT: Tặng sản phẩm theo hóa đơn
    * PROMOTION_PRODUCT_DONATE_PRODUCT: Tặng sản phẩm theo sản phẩm mua
  + Khuyến mãi tặng voucher:
    * PROMOTION_INVOICE_DONATE_VOUCHER: Tặng voucher theo hóa đơn
    * PROMOTION_PRODUCT_DONATE_VOUCHER: Tặng voucher theo sản phẩm
  + Lưu thông tin khuyến mãi vào InvoicePromotion
  + Cập nhật InvoiceDetail.Discount với giá trị khuyến mãi

- Xử lý coupon/voucher:
  + Validate điều kiện áp dụng coupon:
    * Kiểm tra mã coupon hợp lệ
    * Kiểm tra thời hạn sử dụng
    * Kiểm tra trạng thái chưa sử dụng
  + Tính giá trị coupon:
    * Kiểm tra loại giảm giá (% hoặc số tiền)
    * Áp dụng giới hạn giảm tối đa
  + Kiểm tra kết hợp khuyến mãi:
    * Không cho phép dùng chung nếu AllowMergeCouponWithOtherPromotion = false
  + Cập nhật DiscountByCoupon vào hóa đơn
  + Đánh dấu coupon đã sử dụng

### 2.3. Tính phụ phí và phí giao hàng
- Tính phí COD:
  + Kiểm tra UsingCod = 1 và UseDefaultPartner = true
  + DeliveryPrice = CodFixedFee + CodPercentageFee * TotalAmount
  + Cập nhật vào DeliveryInfo.Price và DeliveryDetail.Price
  + Validate DeliveryMethod = COD với đơn COD
  + Cập nhật lại payment nếu thay đổi phí COD

- Tính các phụ phí khác:
  + Lấy danh sách phụ phí từ POS Setting
  + Tính phụ phí theo % hoặc số tiền cố định
  + Áp dụng điều kiện phụ phí:
    * Kiểm tra điều kiện về tổng tiền
    * Kiểm tra điều kiện về số lượng sản phẩm
  + Phụ phí tự động:
    * Phí đóng gói
    * Phí vận chuyển nội bộ
  + Lưu vào InvoiceOrderSurcharge
  + Cộng phụ phí vào trường Surcharge

### 2.4. Xử lý thuế và chuyển đổi tiền tệ
- Tính thuế cho hóa đơn:
  + Xác định loại thuế áp dụng:
    * Lấy thuế từ sản phẩm hoặc từ cấu hình POS
    * Validate TaxId tồn tại và đang active
    * Kiểm tra thuế suất hợp lệ (Percent > 0)
  + Tính thuế cho từng dòng chi tiết:
    * Với thuế trên giá gốc:
      - TaxAmount = (Price * Quantity - InvoiceDetail.Discount) * TaxPercent / 100
    * Với thuế trên giá đã giảm:
      - TaxAmount = (Price * Quantity - InvoiceDetail.Discount - InvoiceDetail.PromotionDiscount) * TaxPercent / 100
    * Làm tròn theo CurrencyDecimalPlaceForProduct
    * Cập nhật vào InvoiceDetailTax
  + Tổng hợp thuế cho hóa đơn:
    * TotalTax = Sum(InvoiceDetailTax.TaxAmount)
    * TotalAmount += TotalTax

- Xử lý chuyển đổi tiền tệ:
  + Lấy thông tin tiền tệ:
    * CurrencyId từ cấu hình chi nhánh
    * ExchangeRate từ CurrencySetting
    * Validate Rate và Decimals hợp lệ
  + Chuyển đổi giá trị tiền:
    * BaseAmount = Amount * ExchangeRate
    * Round(BaseAmount, CurrencyDecimalPlace)
  + Làm tròn theo quy tắc:
    * Giá sản phẩm: CurrencyDecimalPlaceForProduct
    * Giá tiền: CurrencyDecimalPlace
    * Chiết khấu: CurrencyDecimalPlaceForDiscount
    * Thuế: CurrencyDecimalPlaceForTax

- Xử lý thuế với sản phẩm combo:
  + Phân bổ thuế cho các sản phẩm con:
    * Tính tỷ lệ phân bổ dựa trên giá trị
    * TaxAmount = ComboTax * Ratio
    * Làm tròn từng dòng theo CurrencyDecimalPlaceForTax
  + Tính lại tổng thuế sau phân bổ:
    * Validate tổng thuế các SP con = thuế combo
    * Điều chỉnh chênh lệch làm tròn vào SP đầu tiên

- Xử lý thuế với khuyến mãi:
  + Tính thuế trên giá sau khuyến mãi:
    * BaseAmount = Price - PromotionValue
    * TaxAmount = BaseAmount * TaxPercent / 100
  + Với SP tặng kèm khuyến mãi:
    * Giá = 0, không tính thuế
    * Đánh dấu IsGift = true
  + Điều chỉnh thuế khi có thay đổi khuyến mãi:
    * Tính lại thuế cho các dòng bị ảnh hưởng
    * Cập nhật TotalTax của hóa đơn

## 3. Xử lý thanh toán

### 3.1. Xử lý phương thức thanh toán
- Hỗ trợ nhiều phương thức thanh toán trong 1 hóa đơn:
  + Validate tổng số tiền không vượt quá tổng hóa đơn 
  + Kiểm tra các phương thức thanh toán hợp lệ:
    * Tiền mặt (Cash)
    * Chuyển khoản (Transfer) 
    * Thẻ (Card)
    * Ví điện tử (Wallet)
  + Validate thông tin tài khoản ngân hàng khi thanh toán Transfer/Card:
    * Kiểm tra BankAccountId hợp lệ và đang active
    * Kiểm tra số tài khoản và tên ngân hàng
  + Tự động sinh mã payment:
    * Format: Payment.CodePrefix + Invoice.CodePrefix + số thứ tự
    * Validate độ dài mã không quá 50 ký tự
    * Kiểm tra mã không trùng lặp
  + Với payment thuộc invoice:
    * Cập nhật InvoiceId và OrderId
    * Validate Status = Paid
    * Validate Amount > 0

- Xử lý thanh toán bằng điểm thưởng:
  + Validate số điểm khả dụng của khách hàng:
    * Lấy số điểm hiện có từ bảng Customer 
    * Trừ đi số điểm đã sử dụng chưa hoàn tất
  + Tính giá trị quy đổi điểm:
    * Số tiền = Số điểm * PointToMoney (cấu hình)
    * Làm tròn theo CurrencyDecimalPlace
  + Tạo payment với Method = "Point":
    * DocumentType = PaymentDocType.Sell
    * Status = PaymentStatus.Paid
    * TransDate = Invoice.PurchaseDate
  + Update số điểm đã dùng vào Invoice.PointUsed
  + Ghi log vào PointTracking:
    * DocumentType = RewardPointDocType.PaymentViaRewardPoint
    * Value = -Số điểm sử dụng
    * CustomerBalance = Số điểm còn lại

- Xử lý thanh toán bằng voucher:
  + Validate thông tin voucher:
    * Kiểm tra voucher tồn tại và chưa sử dụng
    * Kiểm tra thời hạn hiệu lực
    * Kiểm tra điều kiện áp dụng (tổng tiền tối thiểu)
    * Kiểm tra giới hạn giảm giá tối đa
  + Tạo payment với Method = "Voucher":
    * VoucherId = Id của voucher
    * Amount = Giá trị voucher được áp dụng
    * Status = PaymentStatus.Paid
  + Cập nhật trạng thái voucher:
    * Status = Used
    * UsedDate = Ngày sử dụng
    * UsedInvoiceId = Id hóa đơn

- Xử lý tiền đặt cọc từ đơn hàng:
  + Với hóa đơn tạo từ đơn hàng có đặt cọc:
    * Tạo payment với Amount = Order.Deposit
    * Method = Cash/Transfer tương ứng với payment đặt cọc
    * Tạo payment hoàn cọc với Amount âm nếu tổng hóa đơn < tiền cọc
    * Status = Paid
    * OrderId = Id đơn hàng gốc

### 3.2. Phân bổ thanh toán
- Phân bổ tự động thanh toán cho công nợ cũ:
  + Điều kiện phân bổ tự động:
    * Có cấu hình AutoPaymentAllocation = true
    * AddToAccount = "1" hoặc AddToAccountSurplus = "1"
    * CustomerId > 0 và có công nợ cũ
  + Xử lý phân bổ:
    * Số tiền phân bổ = PayingAmount - TotalInvoice
    * Tạo PaymentAllocation cho từng hóa đơn cũ
    * Cập nhật PaymentAllocationStatus cho payment
    * Ghi log vào AuditTrail

- Xử lý thu tiền thừa:
  + Nếu PayingAmount > TotalInvoice + Tolerance:
    * Tạo payment còn thừa với Amount âm
    * Cập nhật CustomerSurplus
    * Ghi log Balance/PointTracking
  + Nếu PayingAmount < TotalInvoice - Tolerance:
    * Validate phải có AddToAccountSurplus = "1"
    * Cập nhật CustomerDebt

- Cập nhật lịch sử thanh toán:
  + Tạo PaymentTracking cho mỗi payment:
    * DocumentType = PaymentTrackType.Invoice
    * Status = Invoice.Status
    * Value = Payment.Amount
    * PaymentId = Payment.Id
  + Ghi log Audit Trail cho mỗi payment
  + Cập nhật balance và point tracking

## 4. Xử lý giao hàng

### 4.1. Thông tin giao hàng
- Xử lý địa chỉ giao hàng:
  + Validate thông tin địa chỉ:
    * WardId và LocationId phải tồn tại và khớp với dữ liệu địa chính
    * Nếu không có WardId thì phải có WardName và LocationName
    * Tự động map WardId, LocationId từ WardName và LocationName
    * Validate thông tin AdministrativeAreaId nếu có
  + Validate trạng thái giao hàng:
    * Status phải là Pending khi khởi tạo
    * Chuyển tiếp trạng thái theo quy trình: Pending -> Delivering -> Delivered
    * Trạng thái trả hàng: Returning -> Returned
    * Trạng thái lấy hàng: InPickup -> Pickuped
  + Validate thời gian:
    * ExpectedDelivery không được trước PurchaseDate
    * SuccessfulDeliveryDate phải lớn hơn thời gian tạo
    * DeliveryReturnedDate phải hợp lệ khi trả hàng

- Xử lý chi nhánh xuất hàng:
  + Tự động lấy chi nhánh mặc định từ cấu hình:
    * Với đơn từ sàn TMĐT: lấy từ cấu hình BranchTakingAddress
    * Với đơn thường: lấy chi nhánh của người tạo
  + Validate quyền truy cập chi nhánh xuất hàng:
    * Người dùng phải có quyền trên chi nhánh
    * Với kho cấp 2 phải có quyền trên kho master
  + Cập nhật BranchTakingAddressId và BranchTakingAddressStr cho DeliveryInfo

### 4.2. Xử lý giao hàng qua đối tác
- Xử lý thông tin đối tác giao hàng:
  + Validate đối tác mặc định:
    * Kiểm tra UsingCod = 1 và UseDefaultPartner = true
    * PartnerDeliveryId phải tồn tại và active
    * DeliveryBy phải khớp với đối tác được chọn
  + Validate dịch vụ giao hàng:
    * ServiceAdd phải hợp lệ theo cấu hình đối tác
    * ServiceType phải phù hợp với loại giao hàng
    * PaymentBy phải đúng với phương thức thanh toán
  + Xử lý mã vận đơn:
    * Không được trùng DeliveryCode trong hệ thống
    * Format mã theo quy định của đối tác
    * Cập nhật trạng thái theo webhook từ đối tác

- Tính phí giao hàng:
  + Phí cố định theo cấu hình đối tác (CodFixedFee)
  + Phí theo % giá trị đơn hàng (CodPercentageFee)
  + Phí thu hộ COD theo cấu hình
  + Cập nhật vào DeliveryInfo.Price và DeliveryDetail.Price
  + Validate payment method phải là COD với đơn COD
  + Cập nhật lại payment nếu thay đổi phí COD

- Xử lý chuyển trạng thái giao hàng:
  + Khi chuyển sang Delivered:
    * Cập nhật SuccessfulDeliveryDate
    * Tạo tracking giao hàng thành công 
    * Cập nhật balance tracking cho đối tác
    * Tạo event tracking giao hàng
  + Khi chuyển sang Returned:
    * Validate DeliveryReturnedDate hợp lệ
    * Cập nhật balance tracking hoàn trả
    * Tạo event tracking trả hàng
    * Void payment COD nếu có
  + Khi void delivery:
    * Cập nhật trạng thái về Void
    * Xóa thông tin giao hàng
    * Void các payment liên quan

- Đồng bộ với shipping service:
  + Gửi thông tin đơn hàng khi tạo mới
  + Cập nhật trạng thái khi thay đổi
  + Nhận webhook cập nhật từ đối tác
  + Xử lý lỗi đồng bộ và retry

## 5. Cập nhật dữ liệu liên quan

### 5.1. Cập nhật tồn kho
- Tạo InventoryTracking ghi nhận xuất kho:
  + Thông tin tracking cơ bản:
    * DocumentType = Invoice
    * DocumentId = Id hóa đơn
    * Value = -Số lượng bán
    * BranchId = Chi nhánh xuất hàng
    * TransDate = Ngày bán
    * RetailerId = RetailerId của đơn vị
  + Với sản phẩm thường:
    * ProductId = Id sản phẩm
    * BatchExpireId = null
    * ExpireDate = null
    * Quantity = Số lượng trong InvoiceDetail
  + Với sản phẩm combo:
    * Tạo tracking cho từng sản phẩm con
    * Quantity = Số lượng combo * Định mức trong combo
    * ProductId = Id sản phẩm con
  + Với sản phẩm theo lô:
    * BatchExpireId = Id của lô
    * ExpireDate = Hạn sử dụng của lô
    * Quantity = Số lượng theo đơn vị chuyển đổi
    * Tạo BatchExpireTracking ghi nhận thay đổi lô

- Cập nhật số lượng Reserved (đặt hàng):
  + Với hóa đơn từ đơn hàng:
    * Giảm số lượng Reserved trong Order
    * Cập nhật trạng thái đơn hàng:
      - Finalized: khi xuất đủ số lượng
      - Failed: khi hủy đơn hàng
      - Void: khi hủy toàn bộ đơn 
  + Với hóa đơn thường:
    * Giảm số lượng Reserved trong Branch
    * Cập nhật OnHand của sản phẩm

- Xử lý serial/imei:
  + Cập nhật trạng thái serial:
    * Status = Sold 
    * DocumentId = Id hóa đơn
    * DocumentType = Invoice
  + Tạo ImeiTracking ghi nhận thay đổi:
    * DocumentType = Invoice
    * SerialId = Id của serial
    * Action = Sold
    * BranchId = Chi nhánh xuất
  + Validate quy tắc serial:
    * Không được bán serial đã bán
    * Serial phải thuộc chi nhánh xuất hàng
    * Serial phải ở trạng thái InStock
    * Serial không được nằm trong kiểm kho

- Xử lý sản phẩm theo lô:
  + Tạo BatchExpireTracking:
    * ProductId = Id sản phẩm
    * BatchExpireId = Id lô
    * BranchId = Chi nhánh xuất
    * Value = -Số lượng xuất
    * DocumentType = Invoice 
  + Cập nhật số lượng tồn của lô:
    * Trừ số lượng đã xuất
    * Cập nhật LastModifiedDate
  + Validate quy tắc lô:
    * Lô phải còn hiệu lực
    * Số lượng xuất không vượt tồn
    * Lô phải thuộc chi nhánh xuất

### 5.2. Cập nhật công nợ
- Cập nhật công nợ khách hàng:
  + Tạo BalanceTracking cho khách hàng:
    * PartnerId = CustomerId
    * DocumentType = PaymentDocType.Sell
    * DocumentCode = Invoice.Code 
    * DocumentId = Invoice.Id
    * Value = Invoice.Total
    * TransDate = Invoice.PurchaseDate
    * DataZone = BalanceTrackType.Customer
    * RetailerId = Invoice.RetailerId
  + Tạo CustomerDebtTracking nếu có nợ:
    * CustomerId = Id khách hàng
    * DocumentCode = Invoice.Code
    * DocumentId = Invoice.Id
    * Value = Số tiền còn nợ
    * TransDate = Ngày hóa đơn
    * Status = DebtStatus.New

- Xử lý công nợ theo từng phương thức thanh toán:
  + Với thanh toán tiền mặt (Cash):
    * Tạo PaymentTracking với DocumentType = PaymentTrackType.Invoice
    * Value = Số tiền thanh toán
    * Status = Payment.Status
    * TransDate = Payment.TransDate
  + Với thanh toán chuyển khoản (Transfer):
    * Validate thông tin tài khoản ngân hàng
    * Tạo PaymentTracking như tiền mặt
    * Lưu thông tin ngân hàng vào PaymentTracking
  + Với thanh toán bằng điểm (Point):
    * Tạo PaymentTracking với DocumentType = PaymentTrackType.Point
    * Value = Số điểm sử dụng
    * CustomerBalance = Số điểm còn lại
  + Với thanh toán bằng voucher:
    * Tạo PaymentTracking với DocumentType = PaymentTrackType.Voucher  
    * Value = Giá trị voucher sử dụng
    * VoucherId = Id voucher

- Phân bổ thanh toán cho công nợ:
  + Nếu cấu hình AutoPaymentAllocation = true:
    * Số tiền phân bổ = PayingAmount - TotalInvoice
    * Lấy danh sách công nợ chưa trả theo thứ tự ngày tạo
    * Tạo PaymentAllocation cho từng hóa đơn cũ:
      - InvoiceId = Id hóa đơn cũ
      - PaymentId = Id payment mới
      - Amount = Số tiền phân bổ
      - Status = PaymentStatus.Allocated
    * Cập nhật PaymentAllocationStatus cho payment
    * Cập nhật CustomerDebt cho từng hóa đơn được phân bổ

- Xử lý tiền thừa/thiếu:
  + Nếu PayingAmount > TotalInvoice + Tolerance:
    * Tạo payment âm ghi nhận tiền thừa
    * Cập nhật CustomerSurplus
    * Tạo BalanceTracking ghi nhận dư tiền
  + Nếu PayingAmount < TotalInvoice - Tolerance:
    * Validate cấu hình AddToAccountSurplus = "1"  
    * Cập nhật CustomerDebt
    * Tạo CustomerDebtTracking ghi nợ

- Theo dõi công nợ theo chi nhánh:
  + Với kho cấp 2:
    * Kiểm tra quyền truy cập kho master
    * Tracking công nợ theo kho master
  + Với chi nhánh thường:
    * Tracking công nợ theo chi nhánh hiện tại
  + Cập nhật thông tin khách hàng:  
    * LastTradingDate = Ngày giao dịch mới nhất
    * Debt = Tổng nợ hiện tại
    * TimePurchase = Số lần mua hàng
    * TotalPurchase = Tổng tiền mua hàng

### 5.3. Cập nhật điểm thưởng
- Cập nhật điểm tích lũy khách hàng:
  + Tính và cập nhật điểm cho hóa đơn:
    * Kiểm tra điều kiện PosSetting.RewardPoint = true
    * Theo hóa đơn (RewardPoint_Type = Invoice):
      - Validate CustomerId > 0 và MoneyPerPoint > 0
      - Tổng tiền tính điểm = Total - Surcharge - TotalTax
      - Điểm = Floor(Tổng tiền tính điểm / MoneyPerPoint)
      - Kiểm tra điều kiện nhóm khách hàng: RewardPoint_ForAllCustomer hoặc thuộc nhóm được phép tích điểm
      - Nếu RewardPoint_ForDiscountInvoice = true: tính trên giá đã giảm và điểm khuyến mãi
    * Theo sản phẩm (RewardPoint_Type = Product):
      - Validate CustomerId > 0
      - Chỉ tính cho sản phẩm có UsePoint = true 
      - Tổng điểm = Sum(Số lượng * Point của sản phẩm)
      - Validate điều kiện nhóm khách hàng: RewardPoint_Product_ForAllCustomer hoặc thuộc nhóm được phép tích điểm
    * Điểm từ khuyến mãi:
      - Cộng điểm từ PROMOTION_INVOICE_DONATE_POINT và PROMOTION_PRODUCT_DONATE_POINT
      - Cập nhật vào tổng điểm của hóa đơn

- Cập nhật lịch sử sử dụng điểm:
  + Tạo PointTracking cho điểm tích lũy:
    * DocumentType = RewardPointDocType.Sell
    * DocumentCode = Invoice.Code 
    * DocumentId = Invoice.Id
    * Value = Invoice.Point (số điểm được tích)
    * CustomerBalance = Customer.Point + Value 
    * RetailerId = Invoice.RetailerId
    * CustomerId = Invoice.CustomerId
    * TransDate = Invoice.PurchaseDate
  + Tạo PointTracking cho điểm thanh toán:
    * DocumentType = RewardPointDocType.PaymentViaRewardPoint
    * DocumentCode = Payment.Code
    * DocumentId = Payment.Id
    * Value = -Payment.PointUsed (số điểm sử dụng)
    * CustomerBalance = Customer.Point - PointUsed
    * RetailerId = Invoice.RetailerId
    * CustomerId = Invoice.CustomerId
    * TransDate = Payment.TransDate

- Cập nhật số điểm khách hàng:
  + Với điểm tích lũy:
    * Customer.Point += Invoice.Point
    * Customer.LastTradingDate = Invoice.PurchaseDate  
    * Cập nhật LastModifiedDate
  + Với điểm sử dụng thanh toán:  
    * Customer.Point -= Payment.PointUsed
    * Customer.LastTradingDate = Payment.TransDate
    * Tạo PointTracking ghi nhận sử dụng điểm

- Xử lý hoàn điểm khi hủy hóa đơn:
  + Tạo PointTracking hoàn điểm:
    * DocumentType = RewardPointDocType.Sell
    * DocumentId = Invoice.Id
    * Value = -Invoice.Point
    * CustomerBalance = Customer.Point - Invoice.Point
    * TransDate = Thời điểm hủy
  + Cập nhật điểm khách hàng:
    * Customer.Point -= Invoice.Point
    * Customer.LastTradingDate = Ngày hủy hóa đơn
  + Xóa các PointTracking liên quan:
    * Xóa tracking tích điểm ban đầu
    * Xóa tracking sử dụng điểm nếu có
    * Xóa tracking điểm từ khuyến mãi
    
## 6. Xử lý đồng bộ và tracking

### 6.1. Tracking
- Tracking thay đổi tồn kho:
  + Tạo InventoryTracking khi xuất kho sản phẩm:
    * DocumentType = (int)DocumentType.Invoice
    * DocumentId = Invoice.Id 
    * Value = -InvoiceDetail.Quantity
    * BranchId = Invoice.BranchId
    * TransDate = Invoice.PurchaseDate
    * RetailerId = Invoice.RetailerId
    * ProductId = InvoiceDetail.ProductId
    * Quantity = InvoiceDetail.Quantity
    * BatchExpireId = InvoiceDetail.BatchExpireId
    * ConversionValue = InvoiceDetail.ConversionValue
  + Tạo BatchExpireTracking cho sản phẩm theo lô:
    * ProductId = InvoiceDetail.ProductId 
    * BatchExpireId = InvoiceDetail.BatchExpireId
    * BranchId = Invoice.BranchId
    * Value = -InvoiceDetail.Quantity * ConversionValue
    * DocumentType = (int)DocumentType.Invoice
    * TransDate = Invoice.PurchaseDate

- Tracking công nợ:
  + Tạo BalanceTracking cho khách hàng:
    * PartnerId = Invoice.CustomerId
    * DocumentType = PaymentDocType.Sell
    * DocumentCode = Invoice.Code
    * DocumentId = Invoice.Id
    * Value = Invoice.Total
    * DataZone = BalanceTrackType.Customer
    * TransDate = Invoice.PurchaseDate
    * RetailerId = Invoice.RetailerId
    * EventId = EventTracking.Id (nếu có)
    * EventAction = EventTracking.Action (nếu có)
  + Tạo BalanceTracking cho đối tác giao hàng:
    * PartnerId = DeliveryInfo.DeliveryBy 
    * DocumentType = PaymentDocType.Sell
    * DocumentCode = Invoice.Code
    * DocumentId = Invoice.Id
    * Value = -DeliveryInfo.Price
    * DataZone = BalanceTrackType.Delivery 
    * TransDate = Invoice.PurchaseDate
    * RetailerId = Invoice.RetailerId
    * EventId = EventTracking.Id (nếu có)
    * EventAction = EventTracking.Action (nếu có)

- Tracking điểm thưởng:
  + Tạo PointTracking khi tích điểm:
    * DocumentType = RewardPointDocType.Sell
    * DocumentCode = Invoice.Code
    * DocumentId = Invoice.Id 
    * CustomerId = Invoice.CustomerId
    * Value = Invoice.Point (số điểm cộng)
    * CustomerBalance = Customer.Point + Value
    * TransDate = Invoice.PurchaseDate
    * RetailerId = Invoice.RetailerId
    * EventId = EventTracking.Id (nếu có)
    * EventAction = EventTracking.Action (nếu có)
  + Tạo PointTracking khi sử dụng điểm:
    * DocumentType = RewardPointDocType.PaymentViaRewardPoint
    * DocumentCode = Payment.Code
    * DocumentId = Payment.Id
    * CustomerId = Invoice.CustomerId
    * Value = -Payment.PointUsed (số điểm trừ)
    * CustomerBalance = Customer.Point - PointUsed 
    * TransDate = Payment.TransDate
    * RetailerId = Invoice.RetailerId
    * EventId = EventTracking.Id (nếu có)
    * EventAction = EventTracking.Action (nếu có)

- Tracking thanh toán:
  + Tạo PaymentTracking cho mỗi payment:
    * DocumentType = PaymentTrackType.Invoice
    * DocumentCode = Payment.Code
    * DocumentId = Payment.Id
    * InvoiceId = Invoice.Id
    * CustomerId = Invoice.CustomerId
    * Value = Payment.Amount
    * Status = Payment.Status
    * TransDate = Payment.TransDate
    * Method = Payment.Method
    * RetailerId = Invoice.RetailerId
    * EventId = EventTracking.Id (nếu có)
    * EventAction = EventTracking.Action (nếu có)
    * BankAccountId = Payment.BankAccountId (nếu thanh toán chuyển khoản)
    * VoucherId = Payment.VoucherId (nếu thanh toán voucher)

- Event Tracking & Audit Trail:
  + Tạo EventTracking cho các thao tác chính:
    * DocumentType = "Invoice"/"Payment"/"Delivery"
    * Action = "Add"/"Update"/"Remove"/"Void"
    * DocumentId = Id chứng từ
    * Data = Serialize object sau khi thay đổi 
    * OldData = Serialize object trước khi thay đổi
    * RetailerId = Invoice.RetailerId
    * UserId = User hiện tại
    * TransDate = Thời điểm thực hiện
  + Ghi log AuditTrail khi có thay đổi:
    * ModuleName = "Invoice"
    * ActionName = Tên thao tác
    * Description = Chi tiết thay đổi
    * CreatedDate = Thời điểm thực hiện
    * CreatedBy = User thực hiện
    * RetailerId = Invoice.RetailerId
    * OldValue = Giá trị cũ (JSON)
    * NewValue = Giá trị mới (JSON)

### 6.2. Đồng bộ
- Xử lý phiếu ghi AuditTrail:
  + Chuyển đổi EventMessage thành AuditTrailLog:
    * Validate Action > 0 
    * Validate FunctionId > 0
    * Validate Content không rỗng
  + Ghi nhận log qua AuditTrailService.AddLog()

- Gửi thông báo qua mobile app:
  + Validate điều kiện gửi thông báo:
    * Kiểm tra EventType có trong DefaultNotificationSetting
    * Bypass check Redis cho User.Tfa nếu là ForgotPassword/LoginWith2FA
    * Check cấu hình trong Redis cache cho các loại khác
  + Kiểm tra quyền nhận thông báo trong Redis:
    * Key = "notificationSettings_{RetailerId}_{EventType}"
    * Tự động cập nhật cache nếu hết hạn

- Gửi tin nhắn Zalo:
  + Validate điều kiện gửi:
    * IsConnectedZalo = true 
    * CustomerId có giá trị
    * Thuộc một trong các trường hợp:
      - IsUseZaloSmsHappyBirthday + Customer.Birthday
      - IsUseZaloSmsConfirmOrder + Order._Create 
      - IsUseZaloSmsConfirmInvoice + Invoice._Create
  + Gửi qua Redis message queue:
    * Chuyển đổi sang ZaloMessageLog
    * Set CreatedDate, UserId, UserName
    * Publish message qua RedisMqFactory

- Gửi thông báo PosTouch:
  + Kiểm tra feature toggle UsingNotiPostouchToggle
  + Kiểm tra topic trong Redis với DeviceTopicType.Postouch
  + Gửi event message qua RabbitMQ:
    * Exchange: KVNotificationPostouchQueue
    * Message data: RetailerId, BranchId, EventChange, UserId

- Gửi thông báo SoftPos:
  + Kiểm tra feature toggle UsingNotiSoftPosToggle
  + Kiểm tra topic trong Redis với DeviceTopicType.Softpos  
  + Gửi notification qua RabbitMQ:
    * Exchange: KVNotificationSoftPosQueue
    * Message data: RetailerId, UserId, ActionByUserName, EventType=Payment.SoftPos

- Gửi thông báo hóa đơn điện tử:
  + Kiểm tra topic trong Redis với DeviceTopicType.EInvoice
  + Lấy danh sách user được phân quyền từ DeviceTopicService
  + Gửi notification qua NotificationService.Notify()