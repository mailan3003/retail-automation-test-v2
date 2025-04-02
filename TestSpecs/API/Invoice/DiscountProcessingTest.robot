*** Settings ***
Documentation     Test cases API cho phần xử lý giảm giá hóa đơn
Suite Setup       Suite Setup
Resource          ../../../Keywords/Invoice/DiscountProcessingKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot

*** Variables ***
${DB_CONNECTED}    ${TRUE}

*** Keywords ***
Suite Setup
    [Documentation]    Setup for the test suite
    Set Suite Variable    ${SUITE_NAME}    DiscountProcessingTest

Get From Response
    [Documentation]    Extrait une valeur de la réponse JSON
    [Arguments]    ${property_name}
    ${response_json}=    Evaluate    json.loads('''${RESPONSE.content.decode('utf-8')}''')
    ${value}=    Get From Dictionary    ${response_json}    ${property_name}
    RETURN    ${value}

*** Test Cases ***
RT-DP-001 Tạo hóa đơn với giảm giá cơ bản
    [Documentation]    Kiểm tra tạo hóa đơn với giảm giá cơ bản:
    ...    - Giá trị giảm giá: 10.000đ
    ...    - Tỷ lệ giảm giá: 10%
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Kỳ vọng: Giảm giá được lưu chính xác trong CSDL theo cấu hình tiền tệ
    ...    - Chuẩn hóa: Giảm giá được làm tròn theo cấu hình số chữ số thập phân
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Giảm Giá Cơ Bản
    When Gửi Yêu Cầu Tạo Hóa Đơn Với Giảm Giá
    Then Response Status Code Should Be 200
    ${invoice_id}=    Get From Response    Id
    Xác Thực Giảm Giá Hóa Đơn Trong CSDL    ${invoice_id}    ${STANDARD_DISCOUNT_AMOUNT}
    Xác Thực Tỷ Lệ Giảm Giá Trong CSDL    ${invoice_id}    ${STANDARD_DISCOUNT_RATIO}

RT-DP-002 Tạo hóa đơn với giảm giá thập phân
    [Documentation]    Kiểm tra tạo hóa đơn với giảm giá có số thập phân:
    ...    - Giá trị giảm giá: 10.500,75đ
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Kỳ vọng: Giảm giá được làm tròn theo CURRENCY_DECIMAL_PLACE (2 chữ số)
    ...    - Chuẩn hóa: Từ 10.500,75đ thành 10.500,75đ nếu cấu hình là 2 chữ số thập phân
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Giảm Giá Thập Phân
    When Gửi Yêu Cầu Tạo Hóa Đơn Với Giảm Giá
    Then Response Status Code Should Be 200
    ${invoice_id}=    Get From Response    Id
    Xác Thực Giảm Giá Hóa Đơn Trong CSDL    ${invoice_id}    10500.75

RT-DP-003 Tạo hóa đơn với tỷ lệ giảm giá thập phân
    [Documentation]    Kiểm tra tạo hóa đơn với tỷ lệ giảm giá có số thập phân:
    ...    - Tỷ lệ giảm giá: 10,5678%
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Kỳ vọng: Tỷ lệ giảm giá được làm tròn theo CURRENCY_DECIMAL_PLACE_FOR_PRODUCT (4 chữ số)
    ...    - Chuẩn hóa: Từ 10,5678% thành 10,5678% nếu cấu hình là 4 chữ số thập phân
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tỷ Lệ Giảm Giá Thập Phân
    When Gửi Yêu Cầu Tạo Hóa Đơn Với Giảm Giá
    Then Response Status Code Should Be 200
    ${invoice_id}=    Get From Response    Id
    Xác Thực Tỷ Lệ Giảm Giá Trong CSDL    ${invoice_id}    10.5678
    ${expected_discount}=    Evaluate    100000 * 10.5678 / 100
    Xác Thực Giảm Giá Hóa Đơn Trong CSDL    ${invoice_id}    ${expected_discount}

RT-DP-004 Tạo hóa đơn với nhiều sản phẩm và giảm giá
    [Documentation]    Kiểm tra tạo hóa đơn với nhiều sản phẩm và giảm giá:
    ...    - Giá trị giảm giá: 10.000đ
    ...    - Sản phẩm 1: Giá 100.000đ
    ...    - Sản phẩm 2: Giá 200.000đ
    ...    - Tổng giá trị sản phẩm: 300.000đ
    ...    - Kỳ vọng: Giảm giá được phân bổ cho các sản phẩm theo tỷ lệ giá trị
    ...    - Phân bổ: SP1 = 10.000 * (100.000/300.000) = 3.333đ, SP2 = 10.000 * (200.000/300.000) = 6.667đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Sản Phẩm Và Giảm Giá
    When Gửi Yêu Cầu Tạo Hóa Đơn Với Giảm Giá
    Then Response Status Code Should Be 200
    ${invoice_id}=    Get From Response    Id
    Xác Thực Giảm Giá Hóa Đơn Trong CSDL    ${invoice_id}    ${STANDARD_DISCOUNT_AMOUNT}
    Xác Thực Phân Bổ Giảm Giá Sản Phẩm Trong CSDL    ${invoice_id}

RT-DP-005 Tạo hóa đơn với giảm giá 0 đồng
    [Documentation]    Kiểm tra tạo hóa đơn với giảm giá 0 đồng:
    ...    - Giá trị giảm giá: 0đ
    ...    - Tỷ lệ giảm giá: 0%
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Kỳ vọng: Giá trị giảm giá và tỷ lệ giảm giá được lưu là 0
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Giảm Giá 0 Và Tỷ Lệ Giảm 0
    When Gửi Yêu Cầu Tạo Hóa Đơn Với Giảm Giá
    Then Response Status Code Should Be 200
    ${invoice_id}=    Get From Response    Id
    Xác Thực Giảm Giá Hóa Đơn Trong CSDL    ${invoice_id}    0
    Xác Thực Tỷ Lệ Giảm Giá Trong CSDL    ${invoice_id}    0

RT-DP-006 Tạo hóa đơn với giảm giá từ khuyến mãi
    [Documentation]    Kiểm tra tạo hóa đơn với giảm giá từ khuyến mãi:
    ...    - Giá trị giảm giá khuyến mãi: 20.000đ
    ...    - Khuyến mãi ID: 1001
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Kỳ vọng: Giảm giá khuyến mãi được lưu riêng biệt trong trường DiscountByPromotion
    ...    - Thông tin khuyến mãi được lưu trong bảng InvoicePromotion
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Giảm Giá Khuyến Mãi
    When Gửi Yêu Cầu Tạo Hóa Đơn Với Giảm Giá
    Then Response Status Code Should Be 200
    ${invoice_id}=    Get From Response    Id
    Xác Thực Giảm Giá Hóa Đơn Trong CSDL    ${invoice_id}    ${PROMOTION_DISCOUNT_AMOUNT}
    Xác Thực Giảm Giá Khuyến Mãi Trong CSDL    ${invoice_id}    ${PROMOTION_DISCOUNT_AMOUNT}
    Xác Thực Chi Tiết Khuyến Mãi Trong CSDL    ${invoice_id}    ${PROMOTION_ID_1}

RT-DP-007 Tạo hóa đơn với giảm giá từ khuyến mãi nhiều sản phẩm
    [Documentation]    Kiểm tra tạo hóa đơn với giảm giá từ khuyến mãi nhiều sản phẩm:
    ...    - Giá trị giảm giá khuyến mãi: 20.000đ
    ...    - Khuyến mãi ID: 1001
    ...    - Sản phẩm 1: Giá 100.000đ
    ...    - Sản phẩm 2: Giá 200.000đ
    ...    - Kỳ vọng: Giảm giá khuyến mãi được phân bổ cho các sản phẩm theo tỷ lệ giá trị
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Giảm Giá Khuyến Mãi Nhiều Sản Phẩm
    When Gửi Yêu Cầu Tạo Hóa Đơn Với Giảm Giá
    Then Response Status Code Should Be 200
    ${invoice_id}=    Get From Response    Id
    Xác Thực Giảm Giá Hóa Đơn Trong CSDL    ${invoice_id}    ${PROMOTION_DISCOUNT_AMOUNT}
    Xác Thực Giảm Giá Khuyến Mãi Trong CSDL    ${invoice_id}    ${PROMOTION_DISCOUNT_AMOUNT}
    Xác Thực Chi Tiết Khuyến Mãi Trong CSDL    ${invoice_id}    ${PROMOTION_ID_1}
    Xác Thực Phân Bổ Giảm Giá Sản Phẩm Trong CSDL    ${invoice_id}

RT-DP-008 Tạo hóa đơn với giảm giá giá trị lớn
    [Documentation]    Kiểm tra tạo hóa đơn với giảm giá giá trị lớn:
    ...    - Giá trị giảm giá: 150.000đ (lớn hơn giá trị sản phẩm)
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Kỳ vọng: Giảm giá được chấp nhận và lưu đúng vào CSDL
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Giảm Giá 150000 Và Tỷ Lệ Giảm 150
    When Gửi Yêu Cầu Tạo Hóa Đơn Với Giảm Giá
    Then Response Status Code Should Be 200
    ${invoice_id}=    Get From Response    Id
    Xác Thực Giảm Giá Hóa Đơn Trong CSDL    ${invoice_id}    150000
    Xác Thực Tỷ Lệ Giảm Giá Trong CSDL    ${invoice_id}    150

RT-DP-009 Tạo hóa đơn với tỷ lệ giảm giá 100%
    [Documentation]    Kiểm tra tạo hóa đơn với tỷ lệ giảm giá 100%:
    ...    - Tỷ lệ giảm giá: 100%
    ...    - Giá trị giảm giá: 100.000đ (bằng giá trị sản phẩm)
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Kỳ vọng: Tỷ lệ giảm giá 100% được chấp nhận và lưu đúng vào CSDL
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Giảm Giá 100000 Và Tỷ Lệ Giảm 100
    When Gửi Yêu Cầu Tạo Hóa Đơn Với Giảm Giá
    Then Response Status Code Should Be 200
    ${invoice_id}=    Get From Response    Id
    Xác Thực Giảm Giá Hóa Đơn Trong CSDL    ${invoice_id}    100000
    Xác Thực Tỷ Lệ Giảm Giá Trong CSDL    ${invoice_id}    100 