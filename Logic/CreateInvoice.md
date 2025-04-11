# Logic Xác Thực Đầu Vào Khi Tạo Hóa Đơn (CreateInvoice)

## 1. Kiểm Tra Và Xác Thực Đầu Vào

### 1.1. Kiểm Tra Dữ Liệu Đầu Vào Cơ Bản

- **Xác thực mã hóa đơn**:
  - Hệ thống kiểm tra mã hóa đơn có bắt đầu bằng các tiền tố hợp lệ như `HDO`, `LZD`, `FB`.
  - Nếu là hóa đơn tạo từ online, kiểm tra `UUID` để không bị trùng lặp thông qua Redis cache (`InvoiceService.CheckCachRedisUUID`).
  - Nếu phát hiện UUID trùng lặp, hệ thống sẽ hiển thị thông báo "Mã hóa đơn online bị trùng" (`KVMessage.invoiceLog_OnlineInvoiceCodeIsDup`) trên giao diện người dùng.
  - Nếu là hóa đơn cập nhật, hệ thống sẽ kiểm tra và xác thực với dữ liệu cũ thông qua hàm `validateWithOldData`:
    - Kiểm tra thông tin giao hàng cũ: Nếu hóa đơn cũ có thông tin giao hàng với `UseDefaultPartner` là `true` và trạng thái khác `Void` (hóa đơn đã hủy), nhưng hóa đơn mới không có thông tin giao hàng hoặc `UseDefaultPartner` là `false`, hệ thống sẽ hiển thị thông báo "Có thay đổi mới hơn từ server. Bạn cần cập nhật trước khi tạo thay đổi mới" (`KVMessage.OverwriteNewerCopyNotAllowed`).
    - Kiểm tra thay đổi khách hàng: Nếu hóa đơn cũ có khách hàng (CustomerId > 0) khác với khách hàng mới và đã có thanh toán (TotalPayment > 0), hệ thống sẽ hiển thị thông báo lỗi.
    - Kiểm tra hóa đơn đã hoàn thành và có phiếu trả hàng: Nếu hóa đơn cũ ở trạng thái `Issued` và đã có phiếu trả hàng, hệ thống sẽ hiển thị thông báo "Hóa đơn đã có trả hàng, không thể mở phiếu để cập nhật" (`KVMessage._InvoiceUpdateHasReturnInvoice`).
  - Nếu hóa đơn đã tồn tại (ID > 0), hệ thống sẽ kiểm tra thông tin giao hàng và trạng thái để đảm bảo không ghi đè phiên bản mới hơn, nếu không sẽ hiển thị thông báo lỗi trên giao diện người dùng.

- **Kiểm tra ID cập nhật hóa đơn**:
  - Khi cập nhật hóa đơn (`invoice.UpdateInvoiceId > 0`), hệ thống kiểm tra tồn tại của hóa đơn cũ và trạng thái của nó.
  - Không được cập nhật hóa đơn ở trạng thái **Đã hủy (Void)** hoặc **Không giao được (Failed)**.
  - Nếu hóa đơn không tồn tại, hệ thống sẽ hiển thị thông báo "Hóa đơn không tồn tại" (`KVMessage.Invoice_NotExist`) trên giao diện người dùng.
  - Nếu hóa đơn ở trạng thái không hợp lệ, hệ thống sẽ hiển thị thông báo "Không thể cập nhật hóa đơn đã hủy hoặc không giao được" (`KVMessage.Invoice_CannotUpdateVoidOrFailed`) trên giao diện người dùng.

- **Xác thực ID đơn hàng**:
  - Nếu hóa đơn được tạo từ đơn hàng (`invoice.OrderId != null`), hệ thống kiểm tra:
    - Đơn hàng có tồn tại không.
    - Đơn hàng thuộc cùng retailer.
    - Trạng thái đơn hàng hợp lệ (không ở trạng thái **Finalized** hoặc **Void**).
  - Nếu đơn hàng không tồn tại, hệ thống sẽ hiển thị thông báo "Đơn hàng không tồn tại" (`KVMessage.Order_NotExist`) trên giao diện người dùng.
  - Nếu đơn hàng ở trạng thái không hợp lệ, hệ thống sẽ hiển thị thông báo "Đơn hàng đã hoàn thành hoặc đã hủy" (`KVMessage.Order_FinishedOrVoid`) trên giao diện người dùng.

- **Kiểm tra quyền thao tác với chi nhánh**:
  - Hệ thống xác thực người dùng có quyền thực hiện tác vụ trên chi nhánh hiện tại.
  - Kiểm tra thời gian khóa sổ của chi nhánh (`BranchService.ValidCloseDate`).
  - Nếu người dùng không có quyền, hệ thống sẽ hiển thị thông báo "Bạn không có quyền thao tác trên chi nhánh này" (`KVMessage.Branch_NoPermission`) trên giao diện người dùng.
  - Nếu chi nhánh đã khóa sổ, hệ thống sẽ hiển thị thông báo "Chi nhánh đã khóa sổ cho ngày này" (`KVMessage.Branch_ClosedForDate`) trên giao diện người dùng.

- **Kiểm tra thông tin sổ giá**:
  - Nếu có sử dụng sổ giá (`invoice.PriceBookId > 0`), hệ thống kiểm tra:
    - Sổ giá tồn tại, còn hoạt động (`IsActive`) và chưa hết hạn.
    - Nếu sổ giá không tồn tại, hệ thống sẽ hiển thị thông báo "Sổ giá không tồn tại" (`KVMessage.PriceBook_NotExist`) trên giao diện người dùng.
    - Nếu sổ giá không hoạt động hoặc hết hạn, hệ thống sẽ hiển thị thông báo "Sổ giá không còn hiệu lực" (`KVMessage.PriceBook_NotActive`) trên giao diện người dùng.

### 1.2. Kiểm Tra Thông Tin Khách Hàng

- **Xác thực ID khách hàng**:
  - Khi hóa đơn có khách hàng (`invoice.CustomerId != null`), hệ thống kiểm tra khách hàng có tồn tại trong hệ thống không.
  - Nếu khách hàng không tồn tại, hệ thống sẽ hiển thị thông báo "Khách hàng không tồn tại" (`KVMessage.Customer_NotExist`) trên giao diện người dùng.

- **Kiểm tra quản lý khách hàng theo chi nhánh**:
  - Nếu cài đặt quản lý khách hàng theo chi nhánh (`PosSetting.ManagerCustomerByBranch`), hệ thống xác thực khách hàng phải thuộc cùng chi nhánh với hóa đơn.
  - Nếu khách hàng không thuộc chi nhánh, hệ thống sẽ hiển thị thông báo "Khách hàng không thuộc chi nhánh này" (`KVMessage.Customer_NotBelongToBranch`) trên giao diện người dùng.

- **Kiểm tra thanh toán bằng điểm**:
  - Khi thanh toán bằng điểm thưởng (`payment.Method == "Point"`), hệ thống kiểm tra:
    - Tính năng tích điểm có được bật (`PosSetting.RewardPoint`).
    - Chức năng chuyển đổi điểm thành tiền có được bật (`isPointToMoney`).
    - Số điểm khách hàng hiện có đủ để thanh toán.
    - Tổng tiền thanh toán bằng điểm không vượt quá tổng hóa đơn.
    - Số lượng hóa đơn tối thiểu để sử dụng điểm đã đạt yêu cầu.
  - Nếu tính năng tích điểm không được bật, hệ thống sẽ hiển thị thông báo "Tính năng tích điểm chưa được bật" (`KVMessage.RewardPoint_NotEnabled`) trên giao diện người dùng.
  - Nếu chức năng chuyển đổi điểm không được bật, hệ thống sẽ hiển thị thông báo "Chức năng chuyển đổi điểm thành tiền chưa được bật" (`KVMessage.RewardPoint_PointToMoneyNotEnabled`) trên giao diện người dùng.
  - Nếu số điểm không đủ, hệ thống sẽ hiển thị thông báo "Khách hàng không đủ điểm để thanh toán" (`KVMessage.RewardPoint_NotEnough`) trên giao diện người dùng.
  - Nếu số lượng hóa đơn không đủ, hệ thống sẽ hiển thị thông báo "Khách hàng chưa đủ số lượng hóa đơn tối thiểu để sử dụng điểm" (`KVMessage.RewardPoint_NotEnoughInvoiceCount`) trên giao diện người dùng.

### 1.3. Kiểm Tra Giao Hàng COD

- **Xác thực thông tin đơn vị vận chuyển**:
  - Nếu là hóa đơn COD (`invoice.UsingCod == 1`), hệ thống kiểm tra đơn vị vận chuyển (`PartnerDelivery`) có tồn tại và đang hoạt động.
  - Nếu sử dụng đơn vị vận chuyển mặc định (`UseDefaultPartner`), phải có cấu hình đúng.
  - Nếu đơn vị vận chuyển không tồn tại, hệ thống sẽ hiển thị thông báo "Đơn vị vận chuyển không tồn tại" (`KVMessage.PartnerDelivery_NotExist`) trên giao diện người dùng.
  - Nếu đơn vị vận chuyển không hoạt động, hệ thống sẽ hiển thị thông báo "Đơn vị vận chuyển không hoạt động" (`KVMessage.PartnerDelivery_NotActive`) trên giao diện người dùng.

- **Kiểm tra địa chỉ giao hàng**:
  - Hệ thống xác thực thông tin địa chỉ giao hàng (`DeliveryDetail`) và cập nhật mã định danh của địa chỉ (`WardId`, `LocationId`) dựa trên tên địa chỉ.
  - Nếu thông tin địa chỉ không đầy đủ, hệ thống sẽ hiển thị thông báo "Thông tin địa chỉ giao hàng không đầy đủ" (`KVMessage.DeliveryInfo_AddressRequired`) trên giao diện người dùng.

- **Xác thực dịch vụ vận chuyển**:
  - Kiểm tra thông tin dịch vụ vận chuyển (`ServiceAdd`) phải được nhập.
  - Nếu thông tin dịch vụ không đầy đủ, hệ thống sẽ hiển thị thông báo "Thông tin dịch vụ vận chuyển không đầy đủ" (`KVMessage.DeliveryInfo_ServiceRequired`) trên giao diện người dùng.

### 1.4. Kiểm Tra Điểm Thưởng Và Khuyến Mãi

- **Xác thực việc dùng voucher cùng khuyến mãi**:
  - Nếu cấu hình không cho phép sử dụng voucher kết hợp khuyến mãi (`!PosSetting.UseVoucherCombinePromotion`), hệ thống kiểm tra và báo lỗi nếu hóa đơn có cả voucher và khuyến mãi hoặc thanh toán bằng điểm.
  - Nếu vi phạm quy tắc này, hệ thống sẽ hiển thị thông báo "Không thể sử dụng voucher cùng với khuyến mãi" (`KVMessage.Voucher_CannotCombineWithPromotion`) trên giao diện người dùng.

- **Kiểm tra điều kiện tích điểm thưởng**:
  - Hệ thống kiểm tra các điều kiện tích điểm như:
    - Hóa đơn có giảm giá và cấu hình cho phép tích điểm (`RewardPoint_ForDiscountInvoice`).
    - Hóa đơn thanh toán bằng điểm và cấu hình cho phép tích điểm (`RewardPoint_ForInvoiceUsingRewardPoint`).
    - Hóa đơn thanh toán bằng voucher và cấu hình cho phép tích điểm (`RewardPoint_ForInvoiceUsingVoucher`).
  - Nếu hóa đơn có giảm giá nhưng cấu hình không cho phép tích điểm, hệ thống sẽ không tích điểm và hiển thị thông báo "Hóa đơn có giảm giá không được tích điểm" (`KVMessage.RewardPoint_NotForDiscountInvoice`) trên giao diện người dùng.
  - Tương tự cho các trường hợp thanh toán bằng điểm hoặc voucher.

### 1.5. Kiểm Tra Tồn Kho

- **Xác thực số lượng tồn kho**:
  - Nếu cấu hình không cho phép bán âm (`AllowSellWhenOutStock = false`), hệ thống kiểm tra số lượng tồn kho (`OnHand`) của các sản phẩm tại chi nhánh hiện tại so với số lượng trong hóa đơn.
  - Nếu số lượng tồn kho không đủ, hệ thống sẽ hiển thị thông báo "Sản phẩm [Tên sản phẩm] không đủ số lượng tồn kho. Hiện tại: [OnHand], Yêu cầu: [Quantity]" (`KVMessage.Product_NotEnoughStock`) trên giao diện người dùng.

- **Kiểm tra sản phẩm combo**:
  - Đối với sản phẩm combo, hệ thống kiểm tra tồn kho của từng thành phần con trong combo (`ValidateComboProduct`).
  - Nếu bất kỳ thành phần nào không đủ số lượng, hệ thống sẽ hiển thị thông báo tương tự về việc không đủ tồn kho trên giao diện người dùng.

- **Xác thực tồn kho theo đơn hàng**:
  - Nếu hóa đơn được tạo từ đơn hàng, hệ thống kiểm tra cả số lượng tồn kho hiện tại và số lượng đã đặt trước cho đơn hàng khác.
  - Nếu không đủ tồn kho, hệ thống sẽ hiển thị thông báo chi tiết về tình trạng tồn kho trên giao diện người dùng.

### 1.6. Kiểm Tra Serial/IMEI

- **Xác thực trạng thái serial/imei**:
  - Đối với sản phẩm quản lý theo serial/imei, hệ thống kiểm tra mỗi serial/imei đã được nhập và có trạng thái hợp lệ (`Active`, chưa bán).
  - Nếu serial không được nhập, hệ thống sẽ hiển thị thông báo "Vui lòng nhập serial cho sản phẩm [Tên sản phẩm]" (`KVMessage.Serial_Required`) trên giao diện người dùng.
  - Nếu serial không tồn tại, hệ thống sẽ hiển thị thông báo "Serial [Mã serial] không tồn tại" (`KVMessage.Serial_NotExist`) trên giao diện người dùng.
  - Nếu serial đã được bán, hệ thống sẽ hiển thị thông báo "Serial [Mã serial] đã được bán" (`KVMessage.Serial_AlreadySold`) trên giao diện người dùng.

- **Kiểm tra trùng serial/imei**:
  - Hệ thống kiểm tra không có serial/imei nào bị trùng lặp trong cùng một hóa đơn.
  - Nếu phát hiện trùng lặp, hệ thống sẽ hiển thị thông báo "Serial [Mã serial] đã được sử dụng trong hóa đơn này" (`KVMessage.Serial_DuplicateInInvoice`) trên giao diện người dùng.

### 1.7. Kiểm Tra Thanh Toán

- **Xác thực giá trị thanh toán**:
  - Hệ thống kiểm tra tổng giá trị các khoản thanh toán không vượt quá tổng giá trị hóa đơn.
  - Đối với thanh toán bằng thẻ hoặc chuyển khoản, kiểm tra thông tin tài khoản ngân hàng hợp lệ.
  - Nếu thông tin tài khoản không hợp lệ, hệ thống sẽ hiển thị thông báo "Thông tin tài khoản thanh toán không hợp lệ" (`KVMessage.Payment_InvalidAccountInfo`) trên giao diện người dùng.

- **Kiểm tra phân bổ thanh toán tự động**:
  - Nếu có nhiều phương thức thanh toán, hệ thống kiểm tra việc phân bổ tự động có hợp lệ không.
  - Nếu phân bổ không hợp lệ, hệ thống sẽ hiển thị thông báo phù hợp trên giao diện người dùng.

- **Xác thực thanh toán bằng voucher/điểm**:
  - Kiểm tra mã voucher hợp lệ, chưa hết hạn và thuộc về khách hàng.
  - Nếu voucher không tồn tại, hệ thống sẽ hiển thị thông báo "Voucher không tồn tại" (`KVMessage.Voucher_NotExist`) trên giao diện người dùng.
  - Nếu voucher đã hết hạn, hệ thống sẽ hiển thị thông báo "Voucher đã hết hạn" (`KVMessage.Voucher_Expired`) trên giao diện người dùng.
  - Nếu voucher đã được sử dụng, hệ thống sẽ hiển thị thông báo "Voucher đã được sử dụng" (`KVMessage.Voucher_Used`) trên giao diện người dùng.
  - Đối với thanh toán bằng điểm, kiểm tra khách hàng có đủ điểm không.

### 1.8. Xác Thực Lô/Hạn Sử Dụng

- **Kiểm tra tồn kho theo lô** (`ValidateBatchInvoice`).
  - Nếu lô không đủ số lượng, hệ thống sẽ hiển thị thông báo "Lô [Mã lô] không đủ số lượng. Hiện tại: [OnHand], Yêu cầu: [Quantity]" (`KVMessage.Batch_NotEnoughStock`) trên giao diện người dùng.
- **Xác thực ngày hết hạn**: 
  - Đảm bảo lô chưa hết hạn tại thời điểm bán.
  - Nếu lô đã hết hạn, hệ thống sẽ hiển thị thông báo "Lô [Mã lô] đã hết hạn sử dụng" (`KVMessage.Batch_Expired`) trên giao diện người dùng.
- **Kiểm tra trạng thái lô**: 
  - Lô có được phép bán không và có bị khóa bởi kiểm kê không.
  - Nếu lô bị khóa, hệ thống sẽ hiển thị thông báo "Lô [Mã lô] đang bị khóa bởi kiểm kê" (`KVMessage.Batch_LockedByInventory`) trên giao diện người dùng.

### 1.9. Kiểm Tra Hóa Đơn Điện Tử

- **Xác thực thông tin hóa đơn điện tử**:
  - Nếu hóa đơn yêu cầu xuất hóa đơn điện tử (`invoice.IsRequestEInvoice`), hệ thống kiểm tra:
    - Thông tin khách hàng đầy đủ (tên, địa chỉ, mã số thuế nếu có).
    - Thông tin sản phẩm phù hợp với quy định về hóa đơn điện tử.
    - Mẫu số hóa đơn điện tử hợp lệ.
  - Nếu thông tin khách hàng không đầy đủ, hệ thống sẽ hiển thị thông báo "Thông tin khách hàng không đầy đủ để xuất hóa đơn điện tử" (`KVMessage.EInvoice_CustomerInfoRequired`) trên giao diện người dùng.
  - Nếu mẫu số không hợp lệ, hệ thống sẽ hiển thị thông báo "Mẫu số hóa đơn điện tử không hợp lệ" (`KVMessage.EInvoice_InvalidTemplate`) trên giao diện người dùng.

### 1.10. Kiểm Tra Giới Hạn Giảm Giá

- **Xác thực giới hạn giảm giá**:
  - Hệ thống kiểm tra tỷ lệ giảm giá không vượt quá giới hạn cho phép (`MaxDiscountRatio`).
  - Nếu người dùng không có quyền vượt giới hạn giảm giá, hệ thống sẽ hiển thị thông báo "Tỷ lệ giảm giá vượt quá giới hạn cho phép ([MaxDiscountRatio]%)" (`KVMessage.Discount_ExceedLimit`) trên giao diện người dùng.
  - Đối với từng sản phẩm, kiểm tra giảm giá không vượt quá giá bán của sản phẩm.
  - Nếu giảm giá vượt quá giá bán, hệ thống sẽ hiển thị thông báo "Giảm giá không được vượt quá giá bán của sản phẩm" (`KVMessage.Discount_ExceedPrice`) trên giao diện người dùng.

Tất cả các kiểm tra trên được thực hiện trong `CreateInvoice` và các phương thức hỗ trợ (`ValidateInvoiceAsync`, `ValidateBatchInvoice`, `PreValidate`, `ValidateBeforeCreateInvoice`).

## 2. Xử Lý Dữ Liệu Đầu Vào

### 2.1. Xử Lý Mã Hóa Đơn
- **Tạo mã hóa đơn mới từ tiền tố**:
  - Hệ thống tự động sinh mã hóa đơn mới nếu chưa được cung cấp bằng cách gọi phương thức `CreateInvoiceCodeWithTransaction`.
  - Mã mặc định bắt đầu bằng tiền tố `HDO` (Invoice.CodePrefix), và hệ thống tạo mã có tính duy nhất bằng cách kết hợp với số thứ tự.
  - Đối với các kênh bán hàng khác nhau, hệ thống sẽ áp dụng các tiền tố khác nhau:
    - Nếu hóa đơn được tạo từ Facebook, mã được đổi từ `HDO` thành `FB` (Invoice.FacebookPrefix).
    - Nếu hóa đơn được tạo từ Instagram, mã được đổi từ `HDO` thành `LZD` (Invoice.InstagramPrefix).
    - Nếu hóa đơn được tạo từ Tiktok, mã được đổi từ `HDO` thành `TT` (Invoice.TiktokPosPrefix).
    - Nếu hóa đơn là bảo hành, mã được đổi từ `HDO` thành tiền tố bảo hành (Invoice.WarrantyPrefix).
  - Hệ thống kiểm tra độ dài mã hóa đơn không vượt quá 50 ký tự thông qua kiểm tra `invoice.Code.Length > 50`.
  - Nếu mã hóa đơn vượt quá độ dài cho phép, hệ thống sẽ hiển thị thông báo "Mã hóa đơn không được vượt quá 50 ký tự" (`KVMessage.Invoice_CodeTooLong`) trên giao diện người dùng.

- **Xử lý mã hóa đơn trùng**:
  - Sử dụng cơ chế khóa và cache Redis để ngăn chặn việc tạo mã hóa đơn trùng lặp.
  - Nếu phát hiện khóa đã tồn tại, hệ thống sẽ hiển thị thông báo lỗi "Hóa đơn đang được tạo bởi người dùng khác" (`KVMessage.Invoice_BeingCreatedByOtherUser`) trên giao diện người dùng.
  - Khóa Redis có thời gian sống được cấu hình qua `AppServiceConfigInfo.RedisLockCreateInvoiceTimeout`.
  - Trong trường hợp hóa đơn được tạo từ đơn hàng, hệ thống hiển thị thông báo lỗi "Đơn hàng đang được xử lý bởi người dùng khác" (`KVMessage.Order_BeingProcessedByOtherUser`) trên giao diện người dùng.

### 2.2. Xử Lý Thông Tin Giao Hàng

- **Chuyển đổi thông tin địa chỉ giao hàng**:
  - Khi hóa đơn có giao hàng COD (`invoice.UsingCod == 1`), hệ thống chuyển đổi thông tin từ `DeliveryDetail` sang `DeliveryInfo` và `DeliveryPackage` thông qua phương thức `ConvertInvoiceDelivery`.
  - Hệ thống chuẩn hóa trạng thái giao hàng từ thông tin địa chỉ, bao gồm:
    - Cập nhật mã định danh phường/xã (WardId) và địa chỉ (LocationId) dựa trên tên địa chỉ.
    - Tự động chuẩn hóa thông tin về người nhận, số điện thoại liên hệ, địa chỉ chi tiết.
  - Nếu thông tin địa chỉ không hợp lệ, hệ thống sẽ hiển thị thông báo "Địa chỉ giao hàng không hợp lệ" (`KVMessage.DeliveryInfo_InvalidAddress`) trên giao diện người dùng.
  - Nếu hóa đơn đang được cập nhật (`invoice.Id > 0`), hệ thống kiểm tra thông tin giao hàng hiện có thông qua `DeliveryInfoService.GetLastByInvoiceIdAsync`.
  - Sau khi xử lý, hệ thống đánh dấu bản ghi thông tin giao hàng mới là hiện tại (`IsCurrent = true`).

- **Xử lý thông tin đơn vị vận chuyển mặc định**:
  - Nếu hóa đơn sử dụng đơn vị vận chuyển mặc định (`DeliveryDetail.UseDefaultPartner == true`), hệ thống tìm kiếm hoặc tạo đơn vị vận chuyển thông qua `PartnerDeliveryService.GetOrCreateAsync`.
  - Sau khi có thông tin đơn vị vận chuyển, hệ thống cập nhật:
    - ID đơn vị vận chuyển (`DeliveryDetail.DeliveryBy = partnerDelivery.Id`).
    - Gán thông tin đơn vị vận chuyển vào `DeliveryDetail.PartnerDelivery`.
    - Nếu đã có thông tin giao hàng, cập nhật ID vận chuyển cho `DeliveryInfo.DeliveryBy`.
  - Đối với các đơn vị vận chuyển chưa có trong hệ thống, hệ thống sẽ tự động tìm kiếm thông tin tên đơn vị từ cache hoặc từ cơ sở dữ liệu chính.
  - Nếu giao hàng từ chi nhánh có địa chỉ lấy hàng mặc định (đặc biệt là đơn từ Facebook), hệ thống cập nhật địa chỉ lấy hàng từ chi nhánh thông qua `BranchTakingAddressService.GetDefaultCurrentBranchTakingAddressStr`.

- **Tạo thông tin gói hàng vận chuyển**:
  - Nếu có cài đặt tối ưu tạo thông tin giao hàng (`OptimizeCreateDeliveryInfoForInvoice`), hệ thống tạo thông tin gói hàng chi tiết thông qua `GennerateModelDeliveryInfos`.
  - Thông tin gói hàng bao gồm các thuộc tính như kích thước (dài, rộng, cao), cân nặng, người nhận, địa chỉ giao hàng.
  - Hệ thống xác định xem đơn vị vận chuyển có phải là công ty vận chuyển (`PartnerDeliveryType.CarrierCompany`) để thiết lập trường `UseDefaultPartner`.

### 2.3. Xử Lý Giảm Giá

- **Chuẩn hóa giá trị giảm giá**:
  - Trong quá trình xử lý dữ liệu (`NormallizeData`), hệ thống chuẩn hóa các giá trị giảm giá theo cài đặt đơn vị tiền tệ của hệ thống (`NumberHelper.GetCurrentCurrency()`).
  - Giảm giá hóa đơn (`invoice.Discount`) được làm tròn theo cấu hình số chữ số thập phân cho tổng tiền (`CurrencyDecimalPlace`).
  - Tỷ lệ giảm giá (`invoice.DiscountRatio`) được làm tròn theo cấu hình số chữ số thập phân cho giá sản phẩm (`CurrencyDecimalPlaceForProduct`).

- **Xử lý giảm giá theo chương trình khuyến mãi**:
  - Hệ thống phân biệt giữa giảm giá thông thường và giảm giá từ khuyến mãi (`DiscountByPromotion`) để theo dõi riêng biệt.
  - Nếu hóa đơn có giảm giá từ khuyến mãi, hệ thống lưu lại thông tin trong `invoice.InvoicePromotions` để theo dõi và báo cáo.
  - Các giá trị giảm giá được tính toán lại dựa trên cài đặt tiền tệ của hệ thống trước khi lưu.

- **Phân bổ giảm giá cho các sản phẩm**:
  - Giảm giá hóa đơn sẽ được phân bổ cho các sản phẩm trong hóa đơn, giúp tính toán chính xác doanh thu theo sản phẩm và danh mục.
  - Việc phân bổ này được thực hiện dựa trên tỷ lệ giá trị của từng sản phẩm so với tổng giá trị hóa đơn.
  - Sau khi tạo hóa đơn, hệ thống sẽ gọi thủ tục lưu trữ `prCalcInvoiceTotal` hoặc `CalInvoiceTotalWithOut` (nếu được tối ưu) để tính toán lại tổng giá trị hóa đơn.

### 2.4. Xử Lý Thông Tin Thuế

- **Chuẩn hóa thông tin thuế**:
  - Hệ thống kiểm tra và chuẩn hóa thông tin thuế cho từng sản phẩm trong hóa đơn.
  - Nếu sản phẩm có thuế (`InvoiceDetail.TaxRate > 0`), hệ thống tính toán giá trị thuế dựa trên giá sau khi đã trừ giảm giá.
  - Thông tin thuế được lưu trong bảng `InvoiceDetailTax` để theo dõi chi tiết thuế theo từng sản phẩm.
  - Nếu hóa đơn yêu cầu xuất hóa đơn điện tử, thông tin thuế sẽ được kiểm tra kỹ lưỡng để đảm bảo tuân thủ quy định về thuế.

Các xử lý dữ liệu đầu vào được thực hiện trong các phương thức như `DoMakeInvoiceAsync`, `CreateInvoiceAsync`, `NormallizeData`, `ConvertInvoiceDelivery` và `AssignPartnerDeliveryDefault`.

## 3. Tính toán giá trị
   
### 3.1. Tính tổng tiền hàng

- **Tính giá trị từng sản phẩm**:
  - Hệ thống tính giá trị của từng sản phẩm trong hóa đơn bằng công thức: `(Giá - Giảm giá) * Số lượng`.
  - Giá và giảm giá được làm tròn theo cấu hình số chữ số thập phân cho sản phẩm (`CurrencyDecimalPlaceForProduct`).
  - Tổng tiền của từng sản phẩm được làm tròn theo cấu hình số chữ số thập phân cho tổng tiền (`CurrencyDecimalPlace`).
  - Đối với sản phẩm combo, hệ thống tính giá trị dựa trên tổng giá trị của từng thành phần con.

- **Tính phụ phí**:
  - Hệ thống cộng dồn tất cả các phụ phí từ `InvoiceOrderSurcharges` (nếu có).
  - Phụ phí được áp dụng sau khi đã tính giảm giá và được thêm vào tổng tiền hóa đơn.
  - Công thức: `surchargeValue = invoice.InvoiceOrderSurcharges.Sum(s => s.Price > 0 ? s.Price : 0)`.

- **Tính thuế**:
  - Thuế được tính dựa trên từng mặt hàng trong hóa đơn thông qua `InvoiceDetailTaxs`.
  - Nếu sản phẩm có thuế, giá trị thuế được tính dựa trên giá sau khi đã trừ giảm giá.
  - Tổng thuế (`TotalTax`) được cộng vào tổng tiền hóa đơn.
  - Công thức tổng tiền: `Total = ∑(Giá sản phẩm sau giảm giá * Số lượng) - Giảm giá hóa đơn + Phụ phí + Thuế`.

### 3.2. Tính điểm thưởng

- **Tính điểm theo cấu hình**:
  - Hệ thống kiểm tra cài đặt tích điểm (`PosSetting.RewardPoint`) và loại tích điểm được cấu hình (theo hóa đơn hoặc theo sản phẩm).
  - Nếu tích điểm theo hóa đơn (`RewardPointType.Invoice`):
    - Hệ thống tính tổng tiền được tích điểm bằng cách lấy tổng hóa đơn trừ đi phụ phí và thuế.
    - Loại bỏ các sản phẩm không được cấu hình tích điểm (`IsRewardPoint = false`).
    - Điểm được tính bằng cách chia tổng tiền cho tỷ lệ tiền/điểm (`RewardPoint_MoneyPerPoint`).
  - Nếu tích điểm theo sản phẩm (`RewardPointType.Product`):
    - Hệ thống lọc các sản phẩm được cấu hình tích điểm (`IsRewardPoint = true`) và có giá trị điểm (`RewardPoint > 0`).
    - Tính tổng điểm bằng cách nhân điểm thưởng của mỗi sản phẩm với số lượng và cộng dồn.

- **Tính điểm khuyến mãi**:
  - Điểm khuyến mãi được tính thông qua phương thức `CalculatePromotionPoint`.
  - Đối với khuyến mãi tặng điểm theo hóa đơn (`SalePromotionTypes.InvoicePointGift`):
    - Điểm = Giá trị điểm tặng cố định hoặc (Tỷ lệ % * Điểm tích lũy cơ bản).
  - Đối với khuyến mãi tặng điểm theo sản phẩm (`SalePromotionTypes.ProductPointGift`):
    - Điểm = (Tỷ lệ % * Điểm của sản phẩm được áp dụng khuyến mãi) / a100.
  - Điểm khuyến mãi được cộng vào tổng điểm tích lũy của hóa đơn.

### 3.3. Tính giá trị thanh toán

- **Tính tổng thanh toán**:
  - Hệ thống cộng dồn tất cả các khoản thanh toán từ các phương thức khác nhau (tiền mặt, chuyển khoản, thẻ, điểm thưởng, voucher).
  - Công thức: `TotalPayment = payments.Sum(p => p.Amount)`.
  - Nếu hóa đơn có nhiều phương thức thanh toán, số tiền của các phương thức phải bằng hoặc lớn hơn tổng tiền hóa đơn.

- **Xử lý tiền thừa**:
  - Nếu tổng thanh toán lớn hơn tổng tiền hóa đơn, hệ thống tính tiền thừa: `PayingAmount - Total`.
  - Tiền thừa có thể được cấu hình để trả lại cho khách hàng hoặc chuyển thành công nợ âm tùy theo cài đặt.

- **Tính công nợ**:
  - Công nợ được tính bằng tổng tiền hóa đơn trừ đi tổng thanh toán và các khoản thanh toán khác (nếu có).
  - Công thức: `Debt = Total - TotalPayment - TotalOther`.
  - Nếu hóa đơn có khách hàng, công nợ được cập nhật vào thông tin công nợ của khách hàng.
  - Hệ thống có thể thực hiện bù trừ công nợ (`isUsingDebtOffsetWithReturn`) nếu đây là hóa đơn liên quan đến trả hàng.

Quá trình tính toán giá trị được thực hiện thông qua các phương thức như `CreateInvoiceAsync`, `prCalcInvoiceTotal`, `CalInvoiceTotalWithOut`, và được gọi sau khi đã xử lý dữ liệu đầu vào.

## 4. Cập nhật dữ liệu

### 4.1. Cập nhật tồn kho

- **Cập nhật số lượng tồn**:
  - Sau khi xác thực tồn kho thành công, hệ thống cập nhật giảm số lượng tồn kho (`OnHand`) cho mỗi sản phẩm trong hóa đơn thông qua `ProductBranchService`.
  - Đối với sản phẩm thông thường, OnHand giảm trực tiếp theo số lượng trong hóa đơn: `pb.OnHand -= inv.Quantity`.
  - Đối với sản phẩm đơn vị chuyển đổi (sản phẩm có đơn vị con), hệ thống cập nhật tồn kho cho cả sản phẩm chính và các đơn vị con theo tỷ lệ chuyển đổi.
  - Cập nhật tồn kho được thực hiện trong giao dịch cơ sở dữ liệu (transaction) để đảm bảo tính nhất quán.

- **Cập nhật serial/IMEI**:
  - Đối với sản phẩm quản lý theo serial/IMEI, hệ thống cập nhật trạng thái của các serial từ `Active` sang `Sold`.
  - Mỗi serial được liên kết với hóa đơn thông qua bảng `SerialInvoice`.
  - Hệ thống lưu thông tin chi nhánh, thời gian bán và chuyển trạng thái serial để không thể bán lại.

- **Cập nhật lô/hạn sử dụng**:
  - Nếu sản phẩm được quản lý theo lô (`ProductService.IsBatchManagement`), hệ thống giảm số lượng của lô tương ứng.
  - Hệ thống ưu tiên xuất lô gần hết hạn trước theo nguyên tắc FEFO (First Expired, First Out).
  - Thông tin lô được lưu vào `InvoiceDetailBatch` để theo dõi chi tiết xuất theo lô.

### 4.2. Cập nhật công nợ và điểm thưởng

- **Cập nhật công nợ khách hàng**:
  - Nếu hóa đơn có khách hàng (`invoice.CustomerId > 0`), hệ thống cập nhật công nợ thông qua `CustomerService.UpdateCustomerSummaryValueAsync`.
  - Thông tin cập nhật bao gồm: tổng tiền hóa đơn, tổng thanh toán, điểm sử dụng, điểm thưởng, số lượng hóa đơn.
  - Công thức: `customer.Debt += (invoice.Total - totalPayment)`.
  - Lịch sử công nợ được lưu vào bảng `DebtHistory` để theo dõi thay đổi.

- **Cập nhật lịch sử điểm thưởng**:
  - Nếu hóa đơn có tích điểm thưởng (`invoice.Point > 0`), hệ thống tạo bản ghi lịch sử điểm thưởng thông qua `CustomerPointService`.
  - Nếu hóa đơn có sử dụng điểm để thanh toán, hệ thống ghi nhận điểm đã sử dụng và cập nhật điểm hiện có của khách hàng.
  - Thông tin điểm thưởng được lưu trong `CustomerPoint` với mã tham chiếu là mã hóa đơn.

- **Cập nhật trạng thái voucher**:
  - Nếu hóa đơn có sử dụng voucher, hệ thống cập nhật trạng thái của voucher từ `Active` sang `Used` thông qua `InvoiceVoucherService.BulkCreateInvoiceVoucherAsync`.
  - Thông tin liên kết giữa hóa đơn và voucher được lưu trong bảng `InvoiceVoucher`.
  - Hệ thống cập nhật thông tin: thời gian sử dụng, trạng thái, giá trị voucher đã sử dụng.

### 4.3. Cập nhật vận chuyển

- **Cập nhật thông tin giao hàng**:
  - Nếu hóa đơn có giao hàng COD (`invoice.UsingCod == 1`), hệ thống tạo hoặc cập nhật thông tin giao hàng thông qua `DeliveryInfoService.CreateDeliveryForInvoiceAsync`.
  - Thông tin giao hàng bao gồm: địa chỉ, người nhận, số điện thoại, phí giao hàng, đơn vị vận chuyển.
  - Hệ thống cũng tạo gói hàng với thông tin kích thước, cân nặng thông qua bảng `DeliveryPackage`.

- **Cập nhật trạng thái vận chuyển**:
  - Trạng thái vận chuyển ban đầu được thiết lập là `Pending` (Chờ xử lý).
  - Nếu có kết nối với đơn vị vận chuyển, hệ thống có thể gửi thông tin đơn hàng tới API của đối tác vận chuyển.
  - Lịch sử trạng thái vận chuyển được lưu trong bảng `InvoiceDeliveryTracking` để theo dõi thay đổi trạng thái.

### 4.4. Cập nhật thanh toán

- **Lưu thông tin thanh toán**:
  - Hệ thống lưu thông tin từng khoản thanh toán vào bảng `Payment` thông qua `PaymentService.AddPaymentAsync`.
  - Thông tin thanh toán bao gồm: phương thức thanh toán, số tiền, thời gian, tài khoản thanh toán.
  - Mỗi phương thức thanh toán (tiền mặt, chuyển khoản, thẻ, điểm) được lưu thành các bản ghi riêng biệt.

- **Cập nhật phân bổ thanh toán**:
  - Nếu có nhiều phương thức thanh toán, hệ thống phân bổ thanh toán thông qua `PaymentAllocationService.CreatePaymentAllocation`.
  - Mỗi khoản thanh toán được phân bổ cho hóa đơn hiện tại hoặc có thể được phân bổ cho nhiều hóa đơn khác nhau nếu được cấu hình.
  - Thông tin phân bổ được lưu trong bảng `PaymentAllocation`.

- **Cập nhật thu chi**:
  - Đối với thanh toán tiền mặt, hệ thống tạo phiếu thu để cập nhật sổ quỹ thông qua `ReceiptService.CreateReceiptFromInvoice`.
  - Đối với thanh toán chuyển khoản hoặc thẻ, hệ thống cập nhật số dư tài khoản thông qua `AccountTransactionService`.
  - Nếu có tiền thừa trả lại, hệ thống có thể tạo phiếu chi tương ứng.

Tất cả các thao tác cập nhật dữ liệu trên được thực hiện trong cùng một giao dịch cơ sở dữ liệu để đảm bảo tính toàn vẹn dữ liệu. Nếu có lỗi xảy ra trong quá trình cập nhật, hệ thống sẽ rollback toàn bộ giao dịch.

## 5. Xử lý khuyến mãi

### 5.1. Áp dụng khuyến mãi

- **Kiểm tra điều kiện khuyến mãi**:
  - Hệ thống kiểm tra các khuyến mãi đang hoạt động (`PromotionService.GetActivePromotions`) tại thời điểm tạo hóa đơn.
  - Đối với khuyến mãi theo hóa đơn:
    - Kiểm tra tổng giá trị hóa đơn có đạt điều kiện tối thiểu không (`MinSubtotalCondition`).
    - Kiểm tra khách hàng có thuộc nhóm khách hàng áp dụng không (`CustomerGroupIds`).
    - Kiểm tra thời gian hiện tại có nằm trong khoảng thời gian khuyến mãi không (`StartDate`, `EndDate`).
  - Đối với khuyến mãi theo sản phẩm:
    - Kiểm tra sản phẩm có thuộc danh sách sản phẩm được khuyến mãi không (`ProductIds`, `ProductCategoryIds`).
    - Kiểm tra số lượng sản phẩm có đạt điều kiện tối thiểu không (`MinQuantityCondition`).
    - Kiểm tra giá trị sản phẩm có đạt điều kiện tối thiểu không (`MinSubtotalCondition`).

- **Tính giá trị khuyến mãi**:
  - Đối với khuyến mãi giảm giá cố định (`PromotionDiscountType.FixedAmount`):
    - Giá trị giảm giá = Giá trị cố định (`DiscountValue`).
  - Đối với khuyến mãi giảm giá theo phần trăm (`PromotionDiscountType.Percentage`):
    - Giá trị giảm giá = Tổng tiền * (Tỷ lệ phần trăm / 100).
  - Đối với khuyến mãi mua X tặng Y (`PromotionDiscountType.BuyXGetY`):
    - Hệ thống tính số lượng sản phẩm tặng dựa trên số lượng sản phẩm mua và tỷ lệ X:Y.
  - Thông tin khuyến mãi được lưu trong bảng `InvoicePromotion` để theo dõi chi tiết các khuyến mãi áp dụng cho hóa đơn.

### 5.2. Xử lý quà tặng

- **Tạo sản phẩm quà tặng**:
  - Nếu khuyến mãi bao gồm sản phẩm quà tặng (`PromotionGiftType.Product`), hệ thống tạo các mục `InvoiceDetail` mới với:
    - Giá = 0
    - Số lượng = Số lượng quà tặng được tính toán
    - Ghi chú = "Quà tặng từ khuyến mãi xyz"
    - Liên kết với khuyến mãi qua `SalePromotionId`
  - Các sản phẩm quà tặng cũng ảnh hưởng đến tồn kho và được xử lý giống như các sản phẩm bán thông thường.
  - Nếu cấu hình cho phép, quà tặng có thể được chuyển thành mã giảm giá hoặc điểm thưởng thay vì sản phẩm vật lý.

- **Tạo voucher tặng**:
  - Nếu khuyến mãi bao gồm voucher quà tặng (`PromotionGiftType.Voucher`), hệ thống tạo các voucher mới thông qua `VoucherService.CreateVoucher`.
  - Thông tin voucher bao gồm:
    - Mã voucher ngẫu nhiên hoặc theo mẫu định sẵn
    - Giá trị voucher theo cấu hình khuyến mãi
    - Ngày hết hạn được tính từ ngày tạo hóa đơn cộng thêm số ngày theo cấu hình
    - Liên kết với khách hàng (nếu hóa đơn có khách hàng)
  - Thông tin voucher được lưu vào bảng `Voucher` và thông tin liên kết với hóa đơn được lưu vào bảng `InvoiceVoucher`.
  - Hệ thống cũng có thể gửi thông tin voucher cho khách hàng qua SMS/Email nếu được cấu hình.

Quá trình xử lý khuyến mãi được thực hiện trong các phương thức như `ApplyPromotion`, `ProcessPromotionGift`, và được tích hợp vào quá trình tạo hóa đơn. Việc áp dụng khuyến mãi cũng có thể ảnh hưởng đến tính toán điểm thưởng và tổng giá trị hóa đơn.

## 6. Xử lý thu chi

### 6.1. Tạo phiếu thu

- **Tạo phiếu thu tiền mặt**:
  - Khi hóa đơn có thanh toán bằng tiền mặt, hệ thống tự động tạo phiếu thu thông qua `ReceiptService.CreateReceiptFromInvoice`.
  - Thông tin phiếu thu bao gồm:
    - Mã phiếu thu được tạo tự động với tiền tố "PT"
    - Số tiền = Số tiền thanh toán tiền mặt của hóa đơn
    - Ngày tạo = Ngày thanh toán hóa đơn
    - Nội dung = "Thu tiền bán hàng" + mã hóa đơn
    - Người tạo = Người tạo hóa đơn
    - Liên kết với khách hàng (nếu hóa đơn có khách hàng)
  - Phiếu thu được lưu trong bảng `Receipt` và số quỹ tiền mặt của chi nhánh được cập nhật tăng tương ứng.

- **Tạo phiếu thu chuyển khoản**:
  - Đối với thanh toán qua chuyển khoản/thẻ, hệ thống tạo giao dịch tài khoản thông qua `AccountTransactionService.CreateTransaction`.
  - Thông tin giao dịch bao gồm:
    - Tài khoản nhận tiền = Tài khoản được chọn khi thanh toán
    - Số tiền = Số tiền thanh toán qua chuyển khoản/thẻ
    - Ngày giao dịch = Ngày thanh toán hóa đơn
    - Nội dung = "Thu tiền bán hàng" + mã hóa đơn
    - Mã tham chiếu = Mã hóa đơn
  - Số dư của tài khoản ngân hàng tương ứng được cập nhật tăng thông qua bảng `AccountBalance`.
  - Giao dịch được lưu trữ trong bảng `AccountTransaction` để theo dõi lịch sử.

### 6.2. Xử lý hoàn tiền

- **Tính tiền thừa trả lại**:
  - Khi tổng thanh toán lớn hơn tổng tiền hóa đơn, hệ thống tính tiền thừa: `TotalPayment - Total`.
  - Dựa vào cấu hình (`PosSetting.ChangeToDebt`), hệ thống xử lý tiền thừa theo hai cách:
    - Nếu `ChangeToDebt = true`: Tiền thừa được chuyển thành công nợ âm (số dư) của khách hàng.
    - Nếu `ChangeToDebt = false`: Tiền thừa được trả lại cho khách hàng và hệ thống tạo phiếu chi.

- **Tạo phiếu chi hoàn tiền**:
  - Nếu cấu hình trả lại tiền thừa, hệ thống tạo phiếu chi thông qua `PaymentService.CreatePaymentOut`.
  - Thông tin phiếu chi bao gồm:
    - Mã phiếu chi được tạo tự động với tiền tố "PC"
    - Số tiền = Số tiền thừa cần trả lại
    - Ngày tạo = Ngày thanh toán hóa đơn
    - Nội dung = "Trả lại tiền thừa" + mã hóa đơn
    - Người tạo = Người tạo hóa đơn
    - Liên kết với khách hàng (nếu hóa đơn có khách hàng)
  - Phiếu chi được lưu trong bảng `Payment` với `Direction = Out` và số quỹ tiền mặt của chi nhánh được cập nhật giảm tương ứng.

Tất cả các thao tác tạo phiếu thu/chi đều được thực hiện trong cùng một giao dịch với việc tạo hóa đơn để đảm bảo tính nhất quán của dữ liệu. Nếu xảy ra lỗi trong quá trình tạo phiếu thu/chi, toàn bộ giao dịch sẽ được rollback.

## 7. Xử lý đặt cọc

### 7.1. Kiểm tra đặt cọc

- **Validate số tiền đặt cọc**:
  - Khi hóa đơn được tạo từ đơn hàng có đặt cọc, hệ thống kiểm tra số tiền đặt cọc thông qua `OrderService.ValidateDepositAmount`.
  - Các kiểm tra bao gồm:
    - Số tiền đặt cọc không được vượt quá tổng giá trị đơn hàng.
    - Số tiền đặt cọc phải lớn hơn hoặc bằng 0.
    - Nếu đơn hàng yêu cầu đặt cọc tối thiểu, số tiền đặt cọc phải đạt mức tối thiểu được cấu hình.
  - Nếu không đạt các điều kiện trên, hệ thống sẽ hiển thị thông báo lỗi tương ứng.

- **Kiểm tra thanh toán đặt cọc**:
  - Hệ thống kiểm tra các thanh toán đặt cọc của đơn hàng thông qua `PaymentService.GetDepositPayments`.
  - Tổng thanh toán đặt cọc được tính bằng cách cộng dồn tất cả các thanh toán có `Type = Deposit`.
  - Nếu đơn hàng yêu cầu phải thanh toán đủ số tiền đặt cọc trước khi tạo hóa đơn, hệ thống sẽ kiểm tra xem số tiền đã thanh toán có đủ không.
  - Nếu số tiền thanh toán đặt cọc không đủ, hệ thống sẽ hiển thị thông báo lỗi.

### 7.2. Xử lý hoàn cọc

- **Tính tiền hoàn cọc**:
  - Khi tạo hóa đơn từ đơn hàng có đặt cọc, hệ thống tính số tiền cần hoàn cọc hoặc bù thêm:
    - Nếu tổng đặt cọc > tổng hóa đơn: Cần hoàn lại tiền cọc thừa.
    - Nếu tổng đặt cọc < tổng hóa đơn: Khách hàng cần thanh toán thêm.
    - Nếu tổng đặt cọc = tổng hóa đơn: Không cần xử lý thêm.
  - Công thức tính tiền hoàn cọc: `TotalDeposit - InvoiceTotal` (nếu kết quả dương).
  - Công thức tính tiền cần thanh toán thêm: `InvoiceTotal - TotalDeposit` (nếu kết quả dương).

- **Tạo phiếu chi hoàn cọc**:
  - Nếu cần hoàn lại tiền cọc thừa, hệ thống tự động tạo phiếu chi thông qua `PaymentService.CreateDepositReturn`.
  - Thông tin phiếu chi bao gồm:
    - Mã phiếu chi được tạo tự động với tiền tố "PC"
    - Số tiền = Số tiền cọc cần hoàn lại
    - Ngày tạo = Ngày tạo hóa đơn
    - Nội dung = "Hoàn cọc đơn hàng" + mã đơn hàng
    - Người tạo = Người tạo hóa đơn
    - Liên kết với đơn hàng và khách hàng
    - Loại phiếu chi = `DepositReturn`
  - Phiếu chi được lưu trong bảng `Payment` với `Direction = Out` và `PaymentRefType = Order`.
  - Số quỹ tiền mặt của chi nhánh được cập nhật giảm tương ứng với số tiền hoàn cọc.

Quá trình xử lý đặt cọc được thực hiện trong các phương thức như `ProcessOrderDeposit`, `ApplyDepositToInvoice` và `CreateDepositReturnIfNeeded`. Việc xử lý đặt cọc đúng đắn đảm bảo tính chính xác trong quản lý tài chính giữa đơn hàng và hóa đơn.

## 8. Xử lý đơn hàng

### 8.1. Cập nhật đơn hàng

- **Cập nhật trạng thái đơn hàng**:
  - Khi hóa đơn được tạo từ đơn hàng (`invoice.OrderId > 0`), hệ thống cập nhật trạng thái đơn hàng thông qua các phương thức trong `OrderService`.
  - Nếu hóa đơn tạo cho toàn bộ đơn hàng, trạng thái đơn hàng được cập nhật thành `Finalized` (Đã hoàn thành):
    - `order.Status = (int)OrderState.Finalized`
    - `order.Complete = true`
    - `order.EndPurchaseDate = DateTime.Now` (nếu chưa có giá trị)
  - Nếu hóa đơn chỉ tạo cho một phần đơn hàng, trạng thái đơn hàng có thể được giữ nguyên hoặc cập nhật thành `PartialDelivery` (Giao hàng một phần) tùy thuộc vào cấu hình.
  - Thông tin cập nhật được ghi vào bảng `Order` và các bảng liên quan.

- **Cập nhật số lượng đã xuất**:
  - Hệ thống cập nhật số lượng đã xuất cho từng sản phẩm trong đơn hàng thông qua `OrderDetailService.UpdateDeliveredQuantity`.
  - Công thức cập nhật: `orderDetail.DeliveredQuantity += invoiceDetail.Quantity`.
  - Nếu `orderDetail.DeliveredQuantity >= orderDetail.Quantity`, sản phẩm được đánh dấu là đã xuất đủ.
  - Thông tin cập nhật được lưu vào bảng `OrderDetail` để theo dõi tình trạng xuất của từng sản phẩm.

### 8.2. Xử lý hàng đặt

- **Cập nhật số lượng đặt hàng**:
  - Khi đơn hàng được tạo, hệ thống tăng số lượng đặt hàng (`OnOrder`) cho các sản phẩm thông qua `ProductBranchService.UpdateReservedAsync`.
  - Khi hóa đơn được tạo từ đơn hàng, hệ thống giảm số lượng đặt hàng tương ứng với số lượng đã xuất:
    - `OnOrderChange = -invoiceDetail.Quantity` (giá trị âm để giảm số lượng đặt)
    - Đồng thời giảm tồn kho thực tế: `OnHand -= invoiceDetail.Quantity`.
  - Việc cập nhật được thực hiện cho từng sản phẩm trong đơn hàng thông qua `UpdateOnOrderAsync`.

- **Tính số lượng còn lại**:
  - Sau khi cập nhật số lượng đã xuất, hệ thống tính toán số lượng còn lại cần xuất cho đơn hàng:
    - `RemainingQuantity = orderDetail.Quantity - orderDetail.DeliveredQuantity`
  - Nếu tất cả các sản phẩm trong đơn hàng có `RemainingQuantity = 0`, đơn hàng được đánh dấu là đã hoàn thành.
  - Nếu còn sản phẩm chưa xuất đủ, đơn hàng được giữ ở trạng thái phù hợp để tiếp tục xử lý.

Quá trình xử lý đơn hàng được thực hiện trong các phương thức như `UpdateOrderWhenCreateInvoice`, `CompleteOrderIfNeeded`, và `prCalcOrderTotal`. Sau khi xử lý xong, hệ thống cập nhật lại tổng số tiền đã thanh toán và còn lại của đơn hàng thông qua thủ tục lưu trữ `prCalcOrderTotal`.

## 9. Xử lý ngoại lệ

### 9.1. Rollback dữ liệu

- **Rollback tồn kho**:
  - Khi xảy ra lỗi trong quá trình tạo hóa đơn, hệ thống thực hiện rollback tồn kho thông qua cơ chế transaction của cơ sở dữ liệu.
  - Trong phương thức `CreateInvoiceAsync`, toàn bộ quá trình tạo hóa đơn được bao bọc trong một transaction:
    ```
    using (var dbContextTransaction = Db.Database.BeginTransaction())
    {
        try
        {
            // Các thao tác tạo hóa đơn, cập nhật tồn kho...
            dbContextTransaction.Commit();
        }
        catch (Exception e)
        {
            dbContextTransaction.Rollback();
            throw;
        }
    }
    ```
  - Khi gọi `dbContextTransaction.Rollback()`, tất cả các thay đổi về tồn kho sẽ được hoàn tác, đảm bảo dữ liệu tồn kho không bị sai lệch.

- **Rollback thanh toán**:
  - Các thanh toán và phân bổ thanh toán cũng được thực hiện trong cùng transaction với tạo hóa đơn.
  - Khi rollback transaction, tất cả các bản ghi thanh toán (`Payment`), phân bổ thanh toán (`PaymentAllocation`), và phiếu thu/chi sẽ được hoàn tác.
  - Điều này đảm bảo rằng không có tình trạng tiền đã được ghi nhận nhưng hóa đơn không tồn tại.

- **Rollback công nợ**:
  - Các thay đổi về công nợ khách hàng, điểm thưởng, và voucher cũng nằm trong cùng transaction.
  - Khi rollback, thông tin công nợ, điểm thưởng, và trạng thái voucher sẽ được giữ nguyên như trước khi thực hiện tạo hóa đơn.
  - Điều này đảm bảo tính nhất quán trong quản lý công nợ và lợi ích của khách hàng.

### 9.2. Log lỗi

- **Log chi tiết lỗi**:
  - Hệ thống sử dụng cơ chế log để ghi lại các lỗi xảy ra trong quá trình tạo hóa đơn thông qua `Log.Error()`.
  - Chi tiết lỗi được ghi vào log bao gồm:
    - Message lỗi
    - Stack trace
    - Thông tin hóa đơn đang xử lý
    - Thời gian xảy ra lỗi
    - User thực hiện hành động
  - Đối với các lỗi nghiệp vụ cụ thể, hệ thống sử dụng các loại exception riêng biệt như `KvValidateInvoiceException`, `KvValidateStockException`, `KvValidateVoucherException`.

- **Thông báo lỗi**:
  - Khi xảy ra lỗi, hệ thống hiển thị thông báo lỗi phù hợp cho người dùng.
  - Các thông báo lỗi được định nghĩa trước và lưu trong `KVMessage` hoặc `Labels`.
  - Đối với các hóa đơn online (POS, Omnichannel), hệ thống cập nhật trạng thái hóa đơn thành `Error` và lưu chi tiết lỗi vào bảng `KvSaleInvoice`:
    ```
    await UpdateKvSaleStatusById(invoice.RetailerId, invoice.Id, (byte)KvSaleInvoiceState.Error);
    ```
  - Hệ thống cũng có cơ chế retry cho các hóa đơn bị lỗi, với số lần thử lại được cấu hình trong `RetryTimes`.

## 10. Xử lý kết thúc

### 10.1. Tính toán lại

- **Tính lại tổng tiền**:
  - Sau khi hoàn thành việc tạo hóa đơn, hệ thống thực hiện tính toán lại tổng tiền thông qua thủ tục lưu trữ `prCalcInvoiceTotal` hoặc `CalInvoiceTotalWithOut` (nếu được tối ưu):
    ```
    if (AppServiceConfigInfo.IsOptimizePaymentAllocation)
    {
        InvoiceService.CalInvoiceTotalWithOut(invoice.Id);
    }
    else
    {
        DbRetailer.prCalcInvoiceTotal(invoice.Id);
    }
    ```
  - Việc tính toán lại đảm bảo các giá trị như Total, TotalPayment, Debt được cập nhật chính xác sau khi xử lý tất cả các bước.
  - Nếu hóa đơn được tạo từ đơn hàng, hệ thống cũng tính toán lại tổng tiền đơn hàng thông qua `prCalcOrderTotal`.

- **Tính lại công nợ**:
  - Nếu hóa đơn có khách hàng, hệ thống cập nhật lại thông tin tổng quan của khách hàng thông qua `CustomerService.UpdateCustomerSummaryValueAsync`:
    ```
    await CustomerService.UpdateCustomerSummaryValueAsync(
        invoice.CustomerId.Value,
        invoice.Total,
        totalPayment,
        point,
        invoice.Point ?? 0,
        1,  // increase invoice count
        0,  // not return
        invoice.PurchaseDate
    );
    ```
  - Thông tin cập nhật bao gồm: tổng số tiền đã mua, công nợ hiện tại, tổng số điểm, số lượng hóa đơn.
  - Việc cập nhật này đảm bảo thông tin tổng quan của khách hàng luôn chính xác để phục vụ báo cáo và phân tích.

### 10.2. Cập nhật cache

- **Clear cache hóa đơn**:
  - Sau khi tạo hóa đơn, hệ thống clear cache liên quan đến hóa đơn để đảm bảo dữ liệu mới nhất được hiển thị:
    ```
    var cacheClient = HostContext.TryResolve<ICacheClient>();
    cacheClient?.Remove($"cache:invoice:{invoice.Id}");
    ```
  - Nếu hệ thống sử dụng Redis, các key cache liên quan cũng được xóa thông qua `InvoiceService.SendToEsEventUpdate`.
  - Việc clear cache đảm bảo rằng khi truy vấn hóa đơn, dữ liệu trả về là dữ liệu mới nhất từ cơ sở dữ liệu.

- **Clear cache tồn kho**:
  - Hệ thống cũng clear cache liên quan đến tồn kho của các sản phẩm trong hóa đơn:
    ```
    foreach (var productId in invoice.InvoiceDetails.Select(d => d.ProductId))
    {
        cacheClient?.Remove($"cache:product:branch:{invoice.BranchId}:{productId}");
    }
    ```
  - Nếu sử dụng Redis, các key cache liên quan đến tồn kho cũng được xóa thông qua `ProductService.SendToEsEventUpdate`.
  - Việc clear cache tồn kho đảm bảo rằng thông tin tồn kho hiển thị cho người dùng là chính xác sau khi tạo hóa đơn.

Sau khi hoàn thành tất cả các bước xử lý, hệ thống trả về đối tượng hóa đơn đã được tạo thành công với đầy đủ thông tin như Id, Code, Total, TotalPayment, Debt, PurchaseDate và các thông tin khác để hiển thị cho người dùng hoặc xử lý tiếp theo.
