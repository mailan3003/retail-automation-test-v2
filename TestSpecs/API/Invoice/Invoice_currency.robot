*** Settings ***
Documentation     Test cases API cho phần xử lý giảm giá khi tạo hóa đơn
Resource          ../../../Keywords/Invoice/DiscountKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    DiscountTest

*** Test Cases ***
RT-DC-001 Tạo hóa đơn thành công với chiết khấu cố định
    [Documentation]    Kiểm tra tạo hóa đơn thành công với chiết khấu cố định
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_TEST_FIXED001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Chiết khấu cố định: 10,000đ
    ...    - Logic xử lý: InvoiceService.NormalizeData() 
    ...    - Code: invoice.Discount = NumberHelper.GetCurrencyDecimal(invoice.Discount, currencyData.CurrencyDecimalPlace);
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Giá trị chiết khấu (Discount) được chuẩn hóa và lưu vào DB: 10,000đ
    ...    - Tỷ lệ chiết khấu (DiscountRatio) = 0
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Cố Định
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Chiết Khấu Hóa Đơn    ${INVOICE_ID}    10000


RT-DC-002 Tạo hóa đơn thành công với chiết khấu theo phần trăm
    [Documentation]    Kiểm tra tạo hóa đơn thành công với chiết khấu theo phần trăm
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_TEST_PERCENT001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Tỷ lệ chiết khấu: 10%
    ...    - Logic xử lý: InvoiceService.NormalizeData() 
    ...    - Code: invoice.DiscountRatio = NumberHelper.GetCurrencyDecimal(invoice.DiscountRatio, currencyData.CurrencyDecimalPlaceForProduct);
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tỷ lệ chiết khấu (DiscountRatio) được chuẩn hóa và lưu vào DB: 10
    ...    - Giá trị chiết khấu (Discount) = 0 (tỷ lệ được ưu tiên hơn)
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Phần Trăm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Tỉ Lệ Chiết Khấu Hóa Đơn    ${INVOICE_ID}    10
    And Xác Thực Chiết Khấu Hóa Đơn    ${INVOICE_ID}    0


RT-DC-005 Tạo hóa đơn thành công với chiết khấu sản phẩm cố định
    [Documentation]    Kiểm tra tạo hóa đơn thành công với chiết khấu sản phẩm cố định
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_TEST_DISC001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ, Chiết khấu=10,000đ
    ...    - Logic xử lý: InvoiceService.NormalizeData() xử lý chiết khấu cho từng sản phẩm
    ...    - Code: detail.Discount = NumberHelper.GetCurrencyDecimal(detail.Discount, currencyData.CurrencyDecimalPlaceForProduct);
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Giá trị chiết khấu sản phẩm (InvoiceDetail.Discount) được lưu vào DB: 10,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Chiết Khấu
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Chiết Khấu Sản Phẩm    ${INVOICE_ID}    ${PRODUCT_1}    10000
RT-DC-006 Tạo hóa đơn thành công với chiết khấu sản phẩm theo phần trăm
    [Documentation]    Kiểm tra tạo hóa đơn thành công với chiết khấu sản phẩm theo phần trăm
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_TEST_DISC001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ, Tỷ lệ chiết khấu=10%
    ...    - Logic xử lý: InvoiceService.NormalizeData() xử lý tỷ lệ chiết khấu cho từng sản phẩm
    ...    - Code: detail.DiscountRatio = NumberHelper.GetCurrencyDecimal(detail.DiscountRatio, currencyData.CurrencyDecimalPlaceForProduct);
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tỷ lệ chiết khấu sản phẩm (InvoiceDetail.DiscountRatio) được lưu vào DB: 10%
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Chiết Khấu Phần Trăm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Tỉ Lệ Chiết Khấu Sản Phẩm    ${INVOICE_ID}    ${PRODUCT_1}    10

RT-DC-007 Tạo hóa đơn thành công với nhiều loại chiết khấu kết hợp
    [Documentation]    Kiểm tra tạo hóa đơn thành công với nhiều loại chiết khấu kết hợp
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_TEST_COMBINED001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Chiết khấu thường: 10,000đ
    ...    - Chiết khấu khuyến mãi: 5,000đ
    ...    - Chiết khấu voucher: 5,000đ
    ...    - Logic xử lý: InvoiceService.CalInvoiceTotalWithOut() tính tổng tiền sau khi trừ tất cả các loại chiết khấu
    ...    - Code: total = subTotal - invoice.Discount - invoice.DiscountByPromotion - invoice.DiscountByCoupon;
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền đã trừ khuyến mãi = 100,000 - 10,000 - 5,000 - 5,000 = 80,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Kết Hợp
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Chiết Khấu Hóa Đơn    ${INVOICE_ID}    10000
    And Xác Thực Chiết Khấu Khuyến Mãi Hóa Đơn    ${INVOICE_ID}    5000
    And Xác Thực Chiết Khấu Voucher Hóa Đơn    ${INVOICE_ID}    5000
    And Xác Thực Tổng Tiền Sau Chiết Khấu    ${INVOICE_ID}    80000
RT-DC-008 Tạo hóa đơn thất bại khi voucher không cho phép kết hợp với khuyến mãi
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi voucher không cho phép kết hợp với khuyến mãi
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_TEST_VOUCHER002"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Chiết khấu voucher: 20,000đ
    ...    - Mã khuyến mãi: 1001 (ID khuyến mãi hợp lệ)
    ...    - AllowMergeCouponWithOtherPromotion: 0
    ...    - Logic xử lý: InvoiceService.ValidateVoucher() kiểm tra cài đặt không cho phép kết hợp
    ...    - Code: if (!voucher.AllowMergeWithOtherPromotion && invoice.PromotionId != null) throw new ParameterValidateException("Voucher không thể kết hợp với khuyến mãi khác");
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Voucher không thể kết hợp với khuyến mãi khác"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Voucher Không Kết Hợp
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Voucher không thể kết hợp với khuyến mãi khác"

RT-DC-009 Tạo hóa đơn thành công với khuyến mãi giảm giá cho sản phẩm
    [Documentation]    Kiểm tra tạo hóa đơn thành công với khuyến mãi giảm giá cho sản phẩm
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_TEST_PROMO_PROD001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Loại khuyến mãi: PROMOTION_INVOICE_DISCOUNT_ON_PRODUCT
    ...    - Giá trị khuyến mãi: 10,000đ
    ...    - Sản phẩm áp dụng: SP040943
    ...    - Logic xử lý: InvoiceService.ApplyProductPromotion() áp dụng khuyến mãi vào sản phẩm cụ thể
    ...    - Code: detail.PromotionDiscount += promotionValue;
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Giá trị khuyến mãi được lưu vào InvoiceDetailPromotion: 10,000đ
    ...    - Loại khuyến mãi được lưu trong InvoicePromotion: PROMOTION_INVOICE_DISCOUNT_ON_PRODUCT
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Theo Sản Phẩm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Thông Tin Khuyến Mãi    ${INVOICE_ID}    PROMOTION_INVOICE_DISCOUNT_ON_PRODUCT

RT-DC-010 Tạo hóa đơn thành công với giới hạn chiết khấu tối đa cho voucher
    [Documentation]    Kiểm tra tạo hóa đơn thành công với giới hạn chiết khấu tối đa cho voucher
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_TEST_VOUCHER003"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Chiết khấu voucher: 15,000đ
    ...    - Giới hạn chiết khấu tối đa: 15,000đ
    ...    - Logic xử lý: InvoiceService.CalculateVoucherValue() áp dụng giới hạn chiết khấu tối đa
    ...    - Code: if (voucherValue > voucher.MaxValue) voucherValue = voucher.MaxValue;
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Giá trị chiết khấu voucher không vượt quá giới hạn: 15,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Giới Hạn Chiết Khấu Voucher
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Chiết Khấu Voucher Hóa Đơn    ${INVOICE_ID}    15000

RT-DC-011 Tạo hóa đơn thành công với làm tròn chiết khấu cố định
    [Documentation]    Kiểm tra tạo hóa đơn thành công với làm tròn chiết khấu cố định
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_TEST_ROUNDING001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Chiết khấu cố định (chưa làm tròn): 10,500đ
    ...    - Logic xử lý: InvoiceService.NormalizeData() làm tròn chiết khấu theo cấu hình
    ...    - Code: invoice.Discount = NumberHelper.GetCurrencyDecimal(invoice.Discount, currencyData.CurrencyDecimalPlace);
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Giá trị chiết khấu (Discount) được làm tròn theo cài đặt tiền tệ: 10,500đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Làm Tròn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Chiết Khấu Hóa Đơn    ${INVOICE_ID}    10500

RT-DC-012 Tạo hóa đơn thành công với làm tròn chiết khấu phần trăm
    [Documentation]    Kiểm tra tạo hóa đơn thành công với làm tròn tỷ lệ chiết khấu phần trăm
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_TEST_ROUNDING002"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Tỷ lệ chiết khấu (chưa làm tròn): 12.34%
    ...    - Logic xử lý: InvoiceService.NormalizeData() làm tròn tỷ lệ chiết khấu theo cấu hình
    ...    - Code: invoice.DiscountRatio = NumberHelper.GetCurrencyDecimal(invoice.DiscountRatio, currencyData.CurrencyDecimalPlaceForProduct);
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tỷ lệ chiết khấu (DiscountRatio) được làm tròn theo cài đặt tiền tệ: 12.34
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Phần Trăm Làm Tròn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Tỉ Lệ Chiết Khấu Hóa Đơn    ${INVOICE_ID}    12.34 