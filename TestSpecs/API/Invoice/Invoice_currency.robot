*** Settings ***
Documentation     Test cases API cho phần xử lý giảm giá khi tạo hóa đơn
Resource          ../../../Keywords/Invoice/Currency_Keywords.robot
Resource          ../../../Keywords/Invoice/DiscountProcessingKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py

*** Keywords ***


*** Test Cases ***

RT-QT-01 Tính tổng tiền hàng cơ bản
    [Documentation]    Kiểm tra tính tổng tiền hàng cơ bản:
    ...    - Sản phẩm: 1 sản phẩm với giá 100.55đ, số lượng 2.5
    ...    - Kỳ vọng: Tổng tiền = 100.55đ * 2.5 = 250.55
    ...    - Chuẩn hóa: Tổng tiền được làm tròn lên theo cấu hình CurrencyDecimalPlace (2 chữ số)
    ...    - Kết quả: 250.55đ nếu cấu hình là 2 chữ số thập phân
    [Tags]     currency     apicurrency
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Gian Quốc Tế Với Sản Phẩm Đơn Giá 100.55 Số Lượng 2.5
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Tổng tiền hóa đơn phải bằng ${TOTAL_PRICE}

RT-QT-02 Tính tổng tiền hàng có giảm giá sản phẩm
    [Documentation]    Kiểm tra tính tổng tiền hàng có giảm giá sản phẩm:
    ...    - Sản phẩm: 1 sản phẩm với giá 350.55đ, giảm giá 25.05đ, số lượng 2.33
    ...    - Kỳ vọng: Tổng tiền = (350.55đ - 25.05đ) * 2.33 = 758.42
    ...    - Chuẩn hóa: Tổng tiền được làm tròn lên theo cấu hình CurrencyDecimalPlace (2 chữ số)
    ...    - Kết quả: 758.42đ nếu cấu hình là 2 chữ số thập phân
    [Tags]     currency     apicurrency
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá 350.55 Giảm Giá 25.05 Số Lượng 2.33
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Tổng tiền hóa đơn phải bằng ${TOTAL_PRICE}


RT-QT-03 Tạo hóa đơn thành công với làm tròn chiết khấu cố định
    [Documentation]    Kiểm tra tạo hóa đơn thành công với làm tròn chiết khấu cố định
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_TEST_ROUNDING001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Chiết khấu cố định (chưa làm tròn): 10,500.03đ
    ...    - Logic xử lý: InvoiceService.NormalizeData() làm tròn chiết khấu theo cấu hình
    ...    - Code: invoice.Discount = NumberHelper.GetCurrencyDecimal(invoice.Discount, currencyData.CurrencyDecimalPlace);
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Giá trị chiết khấu (Discount) được làm tròn theo cài đặt tiền tệ: 10,500.03đ
    [Tags]    currency    apicurrency
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Chiết Khấu Cố Định 10500.03
    When Gửi Yêu Cầu Tạo Hóa Đơn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Chiết Khấu Hóa Đơn 10500.03
    And Tổng tiền hóa đơn phải bằng ${TOTAL_PRICE}




RT-QT-04 Tạo hóa đơn thành công với chiết khấu theo phần trăm
    [Documentation]    Kiểm tra tạo hóa đơn thành công với chiết khấu theo phần trăm
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_TEST_PERCENT001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Tỷ lệ chiết khấu: 10.02%
    ...    - Logic xử lý: InvoiceService.NormalizeData() 
    ...    - Code: invoice.DiscountRatio = NumberHelper.GetCurrencyDecimal(invoice.DiscountRatio, currencyData.CurrencyDecimalPlaceForProduct);
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tỷ lệ chiết khấu (DiscountRatio) được chuẩn hóa và lưu vào DB: 10.02
    ...    - Giá trị chiết khấu (Discount) = 0 (tỷ lệ được ưu tiên hơn)
    [Tags]    currency    apicurrency
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Chiết Khấu Tỷ Lệ 10.02 %
    When Gửi Yêu Cầu Tạo Hóa Đơn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Tỉ Lệ Chiết Khấu Hóa Đơn 10.02
    And Tổng tiền hóa đơn phải bằng ${TOTAL_PRICE}


RT-QT-05 Tạo hóa đơn thành công với nhiều loại chiết khấu kết hợp
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


RT-QT-06 Tạo hóa đơn quốc tế với múi giờ khác nhau
    [Documentation]    Kiểm tra tạo hóa đơn quốc tế với múi giờ khác nhau
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_TEST_TIMEZONE001"
    ...    - Chi nhánh ID: ${BRANCH_ID_TIMEZONE}
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Múi giờ: (US) Chậm hơn việt nam 12 giờ
    ...    - Logic xử lý: InvoiceService.NormalizeData() xử lý ngày giờ theo múi giờ cấu hình
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Ngày tạo hóa đơn được lưu đúng theo múi giờ cấu hình
    ...    - Tổng tiền hóa đơn chính xác
    [Tags]    currency    timezone    apicurrency
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Gian Quốc Tế Chi Nhánh Có Timezone ${BRANCH_ID_TIMEZONE}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Ngày Tạo Hóa Đơn Theo Múi Giờ
    And Tổng tiền hóa đơn phải bằng 100000

RT-QT-07 Tạo hóa đơn quốc tế với đơn vị tiền tệ khác JPY
    [Documentation]    Kiểm tra tạo hóa đơn quốc tế với đơn vị tiền tệ khác JPY
    ...    - Khách hàng ID: ${CUSTOMER_ID_CURRENCY_1}
    ...    - Sản phẩm:, SL=1, Giá=100000 PHP
    ...    - Đơn vị tiền tệ: JPY
    ...    - Tỷ giá: 1.5
    ...    - Logic xử lý: InvoiceService.NormalizeData() xử lý chuyển đổi tiền tệ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Đơn vị tiền tệ được lưu đúng là USD
    ...    - Tổng tiền hóa đơn = 100000 PHP 
    ...    - Tổng tiền thanh toán = 1.5 * 5 = 7.5 JPY
    ...    - Công nợ khách hàng = 99992.5
    [Tags]    currency    apicurrency
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Thanh toán 5 JPY Phương thức ${PAYMENT_CASH} Khách hàng ${CUSTOMER_ID_CURRENCY_1}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Phiếu Thu Được Tạo ${PAYMENT_EXCHANGE_AMOUNT} Phương thức ${PAYMENT_CASH}
    And Xác thực tổng thanh toán hóa đơn ${PAYMENT_EXCHANGE_AMOUNT}
    And Xác Thực Công Nợ Của Hóa Đơn 99992.5
    And Xác Định Công Nợ Của Khách Hàng ${CUSTOMER_ID_CURRENCY_1} Giảm 7.5
    And Xác Thực Thanh Toán 5 Tiền Tệ JPY Được Lưu Trong Sổ Quỹ

RT-QT-08 Tạo hóa đơn quốc tế thanh toán chuyển khoản VND
    [Documentation]    Kiểm tra tạo hóa đơn quốc tế với đơn vị tiền tệ khác VND
    ...    - Khách hàng ID: ${CUSTOMER_ID_CURRENCY_1}
    ...    - Sản phẩm:, SL=1, Giá=100000 PHP
    ...    - Đơn vị tiền tệ: VND
    ...    - Tỷ giá: 1.5
    ...    - Logic xử lý: InvoiceService.NormalizeData() xử lý chuyển đổi tiền tệ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Đơn vị tiền tệ được lưu đúng là VND
    ...    - Tổng tiền hóa đơn = 100000 PHP 
    ...    - Tổng tiền thanh toán = 1.5 * 5 = 7.5 JPY
    ...    - Công nợ khách hàng = 0
    [Tags]    currency    apicurrency
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Thanh toán 10.5 VND Phương thức ${PAYMENT_TRANSFER} Khách hàng ${CUSTOMER_ID_CURRENCY_2}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Phiếu Thu Được Tạo ${PAYMENT_EXCHANGE_AMOUNT} Phương thức ${PAYMENT_TRANSFER}
    And Xác thực tổng thanh toán hóa đơn ${PAYMENT_EXCHANGE_AMOUNT}
    And Xác Thực Công Nợ Của Hóa Đơn 0
    And Xác Định Công Nợ Của Khách Hàng ${CUSTOMER_ID_CURRENCY_2} Giảm ${PAYMENT_EXCHANGE_AMOUNT}
    And Xác Thực Thanh Toán 10.5 Tiền Tệ VND Được Lưu Trong Sổ Quỹ

RT-QT-09 Tạo hóa đơn quốc tế Khách lẻ thanh toán chuyển khoản PHP
    [Documentation]    Kiểm tra tạo hóa đơn quốc tế với đơn vị tiền tệ khác PHP
    ...    - Khách hàng ID: ${CUSTOMER_ID_CURRENCY_1}
    ...    - Sản phẩm:, SL=1, Giá=100000 PHP
    ...    - Đơn vị tiền tệ: PHP
    ...    - Logic xử lý: InvoiceService.NormalizeData() xử lý chuyển đổi tiền tệ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Đơn vị tiền tệ được lưu đúng là VND

    ...    - Công nợ khách hàng = 0
    [Tags]    currency    apicurrency
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Tiền Tệ Mặc Định 40000 Phương thức ${PAYMENT_CASH} Khách hàng lẻ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Phiếu Thu Được Tạo 40000 Phương thức ${PAYMENT_CASH}
    And Xác thực tổng thanh toán hóa đơn 40000
    And Xác Thực Công Nợ Của Hóa Đơn 60000
    And Xác Thực Thanh Toán 40000 Tiền Tệ PHP Được Lưu Trong Sổ Quỹ

RT-QT-10 Tạo hóa đơn quốc tế thanh toán kết hợp 2 loại tiền tệ
    [Documentation]    Kiểm tra tạo hóa đơn quốc tế với thanh toán kết hợp 2 loại tiền tệ
    ...    - Khách hàng ID: ${CUSTOMER_ID_CURRENCY_1}
    ...    - Sản phẩm:, SL=1, Giá=100000 PHP
    ...    - Đơn vị tiền tệ thanh toán: PHP và JPY
    ...    - Tỷ giá: Theo cấu hình hệ thống
    ...    - Logic xử lý: InvoiceService.NormalizeData() xử lý chuyển đổi tiền tệ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Thanh toán được ghi nhận đúng với 2 loại tiền tệ
    ...    - Công nợ khách hàng được cập nhật chính xác
    [Tags]    currency    apicurrency    multi_currency
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Thanh Toán Kết Hợp 50000 PHP Và 20 JPY Khách hàng ${CUSTOMER_ID_CURRENCY_3}
    And Lấy thông Tin công nợ khách hàng ${CUSTOMER_ID_CURRENCY_3} trước khi thanh toán
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác thực tổng thanh toán hóa đơn ${TOTAL_PAYMENT}  
    And Xác Thực Công Nợ Của Hóa Đơn 49970
    And Lấy thông Tin công nợ khách hàng ${CUSTOMER_ID_CURRENCY_3} trước khi thanh toán


RT-QT-11 Tạo hóa đơn quốc tế thanh toán kết hợp 3 loại tiền tệ bằng hình thức chuyển khoản
    [Documentation]    Kiểm tra tạo hóa đơn quốc tế với thanh toán kết hợp 3 loại tiền tệ phương thức chuyển khoản
    ...    - Khách hàng ID: ${CUSTOMER_ID_CURRENCY_2}
    ...    - Sản phẩm: HGB0002, SL=1, Giá=200 PHP
    ...    - Đơn vị tiền tệ thanh toán: PHP, JPY, VND
    ...    - Tỷ giá: Theo cấu hình hệ thống
    ...    - Logic xử lý: InvoiceService.NormalizeData() xử lý chuyển đổi tiền tệ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Nội dung phản hồi trả về tồn tại ld 
    ...    - Xác thực phiếu thu được tạo
    ...    - Xác thực tổng thanh toán hóa đơn
    ...    - Xác thực công nợ của hóa đơn
    ...    - Thanh toán được ghi nhận đúng với 3 loại tiền tệ
    ...    - Xác thực thanh toán được lưu trong quỹ

    [Tags]    hungcurrency1
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Thanh Toán Kết Hợp 10 PHP Transfer Và 20 JPY Transfer Và 1 VND Transfer Khách hàng ${CUSTOMER_ID_CURRENCY_2}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Số Lượng Phiếu Thu Được Tạo
    And Xác thực tổng thanh toán hóa đơn 14040
    And Xác Thực Công Nợ Của Hóa Đơn 85960
    And Xác Định Số Lượng Phiếu Thu Của Khách Hàng ${CUSTOMER_ID_CURRENCY_2}
    And Xác Định Số Phiếu Công Nợ Của Khách Hàng ${CUSTOMER_ID_CURRENCY_2} Số phiếu 3 Trong Sổ Quỹ

RT-QT-12 Thanh toán hóa đơn kết hợp Voucher và phương thức khác
    [Documentation]    Kiểm tra thanh toán hóa đơn kết hợp Voucher và tiền mặt
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền: 100.00 PHP
    ...    - Thanh toán 1: Voucher 3.000 PHP
    ...    - Thanh toán 2: Tiền mặt 97.000 PHP
    ...    - Logic xử lý: 
    ...      + InvoiceService.CreateInvoice() tạo các Payment với Method khác nhau
    ...      + Hệ thống tổng hợp tất cả các phương thức thanh toán
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công
    ...    - Thanh toán Voucher được ghi nhận với số tiền 3.000 PHP
    ...    - Thanh toán tiền mặt được ghi nhận với số tiền 97.000 PHP
    ...    - Trạng thái thanh toán của hóa đơn là "Đã thanh toán" (1)
    [Tags]    hungcurrency
    Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Thanh Toán Kết Hợp 97 PHP Và Voucher ${VOUCHER_CAMPAIGN_ID_2} Khách Hàng ${CUSTOMER_ID_CURRENCY_2}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Xác Thực Thanh Toán Voucher Hóa đơn     ${INVOICE_ID}   ${voucher_id}   3
    And Xác Thực Thanh Toán Tiền Mặt Hóa Đơn    ${INVOICE_ID}    97
    And Xác Thực Tổng Tiền Thanh Toán Hóa Đơn    ${INVOICE_ID}    100
    And Xác Thực Trạng Thái Thanh Toán Hóa Đơn   ${INVOICE_ID}    1
