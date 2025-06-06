*** Settings ***
Documentation     Test cases API
Resource          ../../../Keywords/Invoice/Currency_Keywords.robot
Resource          ../../../Keywords/Invoice/DiscountProcessingKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py

*** Keywords ***


*** Test Cases ***


RT-QT-11 Tạo hóa đơn quốc tế thanh toán kết hợp 3 loại tiền tệ bằng hình thức chuyển khoản
    [Documentation]    Kiểm tra tạo hóa đơn quốc tế với thanh toán kết hợp 3 loại tiền tệ phương thức chuyển khoản
    ...    - Khách hàng ID: ${CUSTOMER_ID_CURRENCY_1}
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

    [Tags]    currency1
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
    [Tags]    currencyy
    # Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Kết Hợp 100 PHP Và Voucher ${VOUCHER_CAMPAIGN_ID_2} Khách Hàng ${CUSTOMER_ID_CURRENCY_2}
    Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Thanh Toán Kết Hợp 97 PHP Và Voucher ${VOUCHER_CAMPAIGN_ID_2} Khách Hàng ${CUSTOMER_ID_CURRENCY_2}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Xác Thực Thanh Toán Voucher Hóa đơn     ${INVOICE_ID}   ${voucher_id}   3
    And Xác Thực Thanh Toán Tiền Mặt Hóa Đơn    ${INVOICE_ID}    97
    And Xác Thực Tổng Tiền Thanh Toán Hóa Đơn    ${INVOICE_ID}    100
    And Xác Thực Trạng Thái Thanh Toán Hóa Đơn   ${INVOICE_ID}    1