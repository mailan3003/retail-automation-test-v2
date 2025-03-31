# CreateInvoice Method Dependencies

## InvoiceApi.cs

### CreateInvoice
- **Purpose**: Entry point for creating an invoice.
- **Execution Path**:
  1. Calls `CheckUuidAsync` to ensure the invoice UUID is unique.
  2. Calls `SetDetailTaxForInvoiceDetail` to calculate and set tax details for invoice items.
  3. Calls `SaveCacheRedisUUID` to cache the UUID for processing.
  4. Calls `ValidateBeforeCreateInvoice` to perform pre-creation validations.
  5. Calls `ValidateWithOldData` to validate the invoice against existing data.
  6. Calls `ValidateInvoiceAsync` to perform core invoice validations.
  7. Calls `UpdateInvoiceWithTrackWithEvent` to update the invoice and trigger related events.
  8. Calls `WriteLogUpdateInvoiceAsync` to log updates made to the invoice.
  9. Calls `ProcessInvoiceMappingFBPos` to handle mapping for FBPos integration.
  10. Calls `AddInvoiceWithTracks` to add tracking information to the invoice.
  11. Calls `AddInvoiceWithDelivery` to add delivery details to the invoice.
  12. Calls `UpdateCashflowDetailFollowRelatePayment` to update cashflow details based on payments.
  13. Calls `GetInvoicePoints` to calculate and retrieve customer points for the invoice.
  14. Calls `CalculatePromotionPoint` to calculate promotional points for the invoice.
  15. Calls `VoidOldInvoiceForUpdateInvoice` to void old invoices if the current invoice is an update.
  16. Calls `UpdateOrderOfInvoice` to update the associated order details.
  17. Calls `UpdateDocumentOfInvoice` to update related document details.
  18. Calls `GetLastUpdateInvoice` to retrieve the last updated invoice.
  19. Calls `GetOriginInvoiceUpdateCode` to get the original update code for the invoice.
  20. Calls `GennerateModelDeliveryInfos` to generate delivery information models.
  21. Calls `ValidateVoucher` to validate any vouchers applied to the invoice.
  22. Calls `ValidateCoupon` to validate any coupons applied to the invoice.

---

### CheckUuidAsync
- **Mục đích**: Đảm bảo UUID của hóa đơn là duy nhất.
- **Luồng thực thi**:
  1. **Kiểm tra UUID trong cơ sở dữ liệu**:
     - Truy vấn cơ sở dữ liệu để kiểm tra xem UUID đã tồn tại hay chưa.
     - Nếu UUID đã tồn tại, ném ra ngoại lệ (`KvValidateInvoiceException`) để ngăn chặn việc trùng lặp.
  2. **Xử lý ngoại lệ**:
     - Nếu xảy ra lỗi trong quá trình truy vấn cơ sở dữ liệu, ghi log lỗi để hỗ trợ việc gỡ lỗi.
     - Ném ra ngoại lệ chung nếu không thể xác minh UUID.
  3. **Trả về kết quả**:
     - Nếu UUID không tồn tại, trả về kết quả xác nhận UUID hợp lệ.
     - UUID được coi là duy nhất và có thể sử dụng để tạo hóa đơn mới.

- **Chi tiết logic**:

---

### SetDetailTaxForInvoiceDetail
- **Mục đích**: Tính toán và thiết lập chi tiết thuế cho từng sản phẩm trong hóa đơn.
- Với mỗi chi tiết hóa đơn (invDetail) trong danh sách:
Tìm các bản ghi thuế có DetailId trùng với ID của chi tiết đó
Gán danh sách thuế tìm được vào thuộc tính InvoiceDetailTaxs của chi tiết hóa đơn

- **Chi tiết logic**:

---

### SaveCacheRedisUUID
- **Purpose**: Caches the invoice UUID in Redis for processing.
- **Execution Path**:
  1. Stores the UUID in Redis with a predefined expiration time.
  2. Ensures the UUID is available for subsequent operations.
  3. Handles cleanup of expired UUIDs.

---

### ValidateBeforeCreateInvoice
- **Purpose**: Performs pre-creation validations for the invoice.
- **Execution Path**:
  1. Checks for required fields such as customer, products, and payment methods.
  2. Validates the invoice date against business rules (e.g., book closing dates).
  3. Ensures the invoice complies with branch-specific rules.

---

### ValidateWithOldData
- **Purpose**: Validates the invoice against existing data.
- **Execution Path**:
  1. Compares the invoice with previous invoices for the same customer.
  2. Ensures no conflicts with existing orders or returns.
  3. Validates delivery information consistency.

---

### ValidateInvoiceAsync
- **Purpose**: Performs core validations for the invoice.
- **Execution Path**:
  1. Validates customer details, product availability, and pricing.
  2. Ensures compliance with business rules and tax regulations.
  3. Checks for conflicts with existing invoices or orders.

---

### UpdateInvoiceWithTrackWithEvent
- **Purpose**: Updates the invoice and triggers related events.
- **Execution Path**:
  1. Adds tracking information for inventory and delivery.
  2. Publishes events for downstream systems (e.g., accounting, reporting).
  3. Updates the invoice status and related metadata.

---

### WriteLogUpdateInvoiceAsync
- **Purpose**: Logs updates made to the invoice.
- **Execution Path**:
  1. Captures changes to invoice details, payments, and delivery information.
  2. Stores logs for audit and troubleshooting purposes.

---

### ProcessInvoiceMappingFBPos
- **Purpose**: Handles mapping for FBPos integration.
- **Execution Path**:
  1. Maps invoice details to FBPos-specific formats.
  2. Ensures compatibility with FBPos systems for processing.

---

### AddInvoiceWithTracks
- **Purpose**: Adds tracking information to the invoice.
- **Execution Path**:
  1. Updates inventory tracking for products in the invoice.
  2. Links tracking data to the invoice for reporting.

---

### AddInvoiceWithDelivery
- **Purpose**: Adds delivery details to the invoice.
- **Execution Path**:
  1. Updates delivery tracking for the invoice.
  2. Links delivery data to the invoice for fulfillment.

---

### UpdateCashflowDetailFollowRelatePayment
- **Purpose**: Updates cashflow details based on payments.
- **Execution Path**:
  1. Allocates payments to the invoice and updates balances.
  2. Ensures accurate cashflow reporting.

---

### GetInvoicePoints
- **Purpose**: Calculates and retrieves customer points for the invoice.
- **Execution Path**:
  1. Applies loyalty program rules to determine points earned.
  2. Updates the customer's point balance.

---

### CalculatePromotionPoint
- **Purpose**: Calculates promotional points for the invoice.
- **Execution Path**:
  1. Applies promotional rules to determine additional points.
  2. Updates the invoice with calculated promotional points.

---

### VoidOldInvoiceForUpdateInvoice
- **Purpose**: Voids old invoices if the current invoice is an update.
- **Execution Path**:
  1. Ensures no conflicts between the old and new invoices.
  2. Updates the status of the old invoice to "void."

---

### UpdateOrderOfInvoice
- **Purpose**: Updates the associated order details for the invoice.
- **Execution Path**:
  1. Links the invoice to the corresponding order.
  2. Updates order status and fulfillment details.

---

### UpdateDocumentOfInvoice
- **Purpose**: Updates related document details for the invoice.
- **Execution Path**:
  1. Links the invoice to associated documents (e.g., contracts, returns).
  2. Updates document statuses and references.

---

### GetLastUpdateInvoice
- **Purpose**: Retrieves the last updated invoice for the customer.
- **Execution Path**:
  1. Queries the database for the most recent invoice update.
  2. Provides a reference for the current invoice update.

---

### GetOriginInvoiceUpdateCode
- **Purpose**: Gets the original update code for the invoice.
- **Execution Path**:
  1. Tracks the history of invoice updates.
  2. Ensures traceability for audit purposes.

---

### GennerateModelDeliveryInfos
- **Purpose**: Generates delivery information models for the invoice.
- **Execution Path**:
  1. Prepares delivery data for integration with delivery systems.
  2. Ensures accurate and complete delivery information.

---

### ValidateVoucher
- **Purpose**: Validates any vouchers applied to the invoice.
- **Execution Path**:
  1. Checks voucher validity, expiration, and usage limits.
  2. Applies voucher discounts to the invoice.

---

### ValidateCoupon
- **Purpose**: Validates any coupons applied to the invoice.
- **Execution Path**:
  1. Checks coupon validity, expiration, and usage limits.
  2. Applies coupon discounts to the invoice.

## InvoiceService.cs
- MakeInvoiceAsync
- DoMakeInvoiceAsync
- CreateInvoiceAsync
- ValidateWithOldData
- ValidateBeforeCreateInvoice
- ValidateInvoiceAsync
- NormalizeInvoiceDetail
- ConvertInvoiceDelivery
- AssignPartnerDeliveryDefault
- BuildListToTracking
- ProcessInvoiceMappingFBPos
- AddInvoiceWithTracks
- AddInvoiceWithDelivery
- UpdateInvoiceWithTracks
- UpdateCashflowDetailFollowRelatePayment
- GetInvoicePoints
- CalculatePromotionPoint
- ValidateBatchInvoice
- ValidateBatchInvoiceLimitByPositiveTrans
- ValidateBatchInvoiceLimitByStocktake
- ValidateSyncOfflineBatchInvoice
- ValidateWarningCustomerDebt
- ValidateWarningCustomerRetailDebt
- ValidateCheckOrderRequest
- ValidateComboProduct
- ValidateVoucher
- ValidateCoupon
- GennerateModelDeliveryInfos
- UpdateInvoiceWithTrackWithEvent
- VoidOldInvoiceForUpdateInvoice
- UpdateOrderOfInvoice
- UpdateDocumentOfInvoice
- GetLastUpdateInvoice
- GetOriginInvoiceUpdateCode

Mục đích của phương thức:
Kiểm tra tính hợp lệ của việc bán sản phẩm combo (sản phẩm được tạo từ nhiều sản phẩm khác)
Đảm bảo số lượng tồn kho của các sản phẩm thành phần đủ để tạo combo
Các tham số đầu vào:
invoice: Hóa đơn cần kiểm tra
products: Dictionary chứa thông tin các sản phẩm
currentOnhandDictionary: Dictionary lưu số lượng tồn kho hiện tại
invOrder: Đơn hàng liên quan (tham số tùy chọn)
Các bước xử lý chính:
Khởi tạo dữ liệu:
Lấy branchId từ hóa đơn hoặc từ context
Lọc ra các sản phẩm combo (ProductType.Manufactured)
Tạo dictionary comboProductFormulaHistories để lưu lịch sử công thức của sản phẩm combo
Thu thập thông tin công thức sản phẩm:
Duyệt qua các chi tiết hóa đơn
Lưu lại ProductFormulaHistoryId của các sản phẩm combo
Lấy thông tin nguyên liệu từ lịch sử công thức
Thu thập thông tin nguyên liệu:
Tập hợp tất cả nguyên liệu từ các công thức
Lấy thông tin sản phẩm nguyên liệu (ProductType.Purchased)
Lấy thông tin tồn kho của chi nhánh cho cả sản phẩm combo và nguyên liệu
Kiểm tra từng sản phẩm combo:
Duyệt qua từng sản phẩm combo trong hóa đơn
Các trường hợp bỏ qua kiểm tra:
Sản phẩm cho phép bán âm (ProductAllowSellWhenOutStock = true)
Không tìm thấy thông tin nguyên liệu của combo
Tất cả nguyên liệu đều là sản phẩm dịch vụ
Kiểm tra số lượng tồn kho cho từng nguyên liệu:
Tính toán số lượng có thể bán cho từng nguyên liệu:
Lấy số lượng nguyên liệu cần cho 1 combo
Tính số lượng tồn kho hiện tại:
Nếu có trong currentOnhandDictionary thì lấy từ đó
Nếu không thì lấy từ thông tin chi nhánh
Trừ đi số lượng đã đặt trước (Reserved) nếu không cho phép bán khi hết hàng
Xử lý đặc biệt khi không cho phép bán khi hết hàng:
Trừ đi số lượng đặt trước của sản phẩm combo
Cộng lại số lượng từ đơn hàng gốc (nếu có)
Tính số lượng có thể mua của combo dựa trên mỗi nguyên liệu
Kiểm tra điều kiện cuối cùng:
Tìm nguyên liệu có số lượng có thể bán thấp nhất
So sánh với số lượng combo cần bán
Ném ngoại lệ KvValidateInvoiceException nếu số lượng combo cần bán vượt quá số lượng có thể bán
Xử lý lỗi:
Khi phát hiện vi phạm, ném ra ngoại lệ với thông báo chứa tên sản phẩm combo và mã nguyên liệu bị thiếu
Các trường hợp đặc biệt:
Xử lý riêng cho sản phẩm cho phép bán âm
Xử lý riêng khi có đơn hàng gốc
Xử lý cho cả trường hợp cho phép và không cho phép bán khi hết hàng (AllowSellWhenOrderOutStock)
Đây là một phương thức phức tạp với nhiều nhánh logic khác nhau, đảm bảo tính chính xác của việc bán sản phẩm combo dựa trên tồn kho thực tế của các nguyên liệu thành phần.

## ValidationService.cs
- ValidateNewInvoiceAsync
- ValidateUpdateInvoiceAsync
- ValidateOrderAsync
- ValidatePriceBookAsync
- ValidateStockTake
- ValidatePreviewInvoices

## DeliveryInfoService.cs
- CreateDeliveryInfo
- ValidateDeliveryInfo
- UpdateDeliveryForInvoiceAsync
- ValidateBeforeConfirmStatuReturned
- GetLastByInvoiceIdAsync

## PaymentService.cs
- CreatePayment
- ValidatePayment
- GetPaymentsByCodes
- AddPaymentAllocation
- UpdatePaymentAsync

## InventoryTrackingService.cs
- CreateInventoryTracking
- UpdateInventoryTracking
- ValidateInventoryTracking
- GetCurrentStock

## BalanceTrackingService.cs
- CreateBalanceTracking
- UpdateBalanceTracking

## PointTrackingService.cs
- CreatePointTracking
- UpdatePointTracking
- CalculatePoints

## CustomerService.cs
- ValidateCustomer
- UpdateCustomerSummaryValueAsync
- GetCustomerDeptAndPoint

## OrderService.cs
- GetByIdAsync
- ValidateOrderAsync
- UpdateOrderAsync

## BatchService.cs
- ValidateBatchExpiry
- UpdateBatchQuantity
- GetBatchStock

## ProductService.cs
- ValidateProduct
- GetProductDetails
- GetProductPrices
- ValidateProductStock

## WarehouseService.cs
- IsActiveWarehouseToggle
- GetMasterIdByWarehouseIdAsync
- ValidateWarehouseStock

## DeliveryPackageService.cs
- CreateDeliveryPackage
- UpdateDeliveryPackage

## VoucherService.cs
- ValidateVoucherAsync
- UpdateVoucherStatus

## CouponService.cs
- ValidateCouponAsync
- UpdateCouponStatus

## SerialService.cs
- ValidateSerialNumbers
- UpdateSerialStatus

## EventTrackingService.cs
- CreateEvent
- TrackEvent

## PrescriptionService.cs
- ValidatePrescription
- CreatePrescription

## AuditService.cs
- WriteAuditLog
- TrackChanges

## TransactionManager.cs
- BeginTransaction
- CommitTransaction
- RollbackTransaction

## CacheService.cs
- GetInvoiceLockKey
- SetInvoiceLock
- RemoveInvoiceLock

## Helper Classes
### TrackingHelper.cs
- Enqueue
- ProcessTrackingQueue

### ValidationHelper.cs
- ValidateBusinessRules

### NumberHelper.cs
- RoundProductPrice

### DateTimeHelper.cs
- GetCurrentDate

### StringHelper.cs
- CompareString
