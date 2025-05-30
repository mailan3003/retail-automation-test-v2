*** Settings ***
Documentation     Test cases API cho phần xử lý làm tròn hóa đơn
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Invoice/InvoiceRoundingKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py

*** Test Cases ***

RT-RD-001 Làm tròn lên với khoảng 0.05
    [Documentation]    Kiểm tra làm tròn lên với khoảng 0.05:
    ...    - Source: InvoiceService.cs > NormalizeData() line ~2150
    ...    - Logic: Áp dụng công thức làm tròn lên ⌈S/M⌉×M
    ...    - Code: Math.Ceiling(amount / roundingInterval) * roundingInterval
    ...    - Kỳ vọng: Các giá trị được làm tròn lên đến bội số gần nhất của 0.05
    [Tags]    rounding    apiinvoice    AIGenerated
    [Template]    Test Làm Tròn Lên Với Khoảng 0.05
    # original_amount    expected_amount
    123.45             123.45
    123.47             123.50
    123.50             123.50
    123.52             123.55
    123.55             123.55
    999.99             1000.00
    1000.01            1000.05
    1234.56            1234.60

RT-RD-002 Làm tròn xuống với khoảng 0.05
    [Documentation]    Kiểm tra làm tròn xuống với khoảng 0.05:
    ...    - Source: InvoiceService.cs > NormalizeData() line ~2155
    ...    - Logic: Áp dụng công thức làm tròn xuống ⌊S/M⌋×M
    ...    - Code: Math.Floor(amount / roundingInterval) * roundingInterval
    ...    - Kỳ vọng: Các giá trị được làm tròn xuống đến bội số gần nhất của 0.05
    [Tags]    rounding    apiinvoice    AIGenerated
    [Template]    Test Làm Tròn Xuống Với Khoảng 0.05
    # original_amount    expected_amount
    123.45             123.45
    123.47             123.45
    123.50             123.50
    123.52             123.50
    123.55             123.55
    999.99             999.95
    1000.01            1000.00
    1234.56            1234.55

RT-RD-003 Làm tròn gần nhất với khoảng 0.05
    [Documentation]    Kiểm tra làm tròn gần nhất với khoảng 0.05:
    ...    - Source: InvoiceService.cs > NormalizeData() line ~2160
    ...    - Logic: Áp dụng công thức làm tròn gần nhất round(S/M)×M
    ...    - Code: Math.Round(amount / roundingInterval) * roundingInterval
    ...    - Kỳ vọng: Các giá trị được làm tròn đến bội số gần nhất của 0.05
    [Tags]    rounding    apiinvoice    AIGenerated
    [Template]    Test Làm Tròn Gần Nhất Với Khoảng 0.05
    # original_amount    expected_amount
    123.45             123.45
    123.47             123.45
    123.50             123.50
    123.52             123.50
    123.55             123.55
    999.99             1000.00
    1000.01            1000.00
    1234.56            1234.55

RT-RD-004 Làm tròn với khoảng 1.00
    [Documentation]    Kiểm tra làm tròn với khoảng 1.00:
    ...    - Source: InvoiceService.cs > NormalizeData() line ~2150
    ...    - Logic: Áp dụng các công thức làm tròn với khoảng 1.00
    ...    - Kỳ vọng: Các giá trị được làm tròn đến số nguyên gần nhất
    [Tags]    rounding    apiinvoice    AIGenerated
    [Template]    Test Làm Tròn Với Khoảng 1.00
    # rounding_type    original_amount    expected_amount
    ${ROUNDING_TYPE_UP}        123.45             124.00
    ${ROUNDING_TYPE_UP}        123.50             124.00
    ${ROUNDING_TYPE_UP}        999.99             1000.00
    ${ROUNDING_TYPE_UP}        1000.01            1001.00
    ${ROUNDING_TYPE_DOWN}      123.45             123.00
    ${ROUNDING_TYPE_DOWN}      123.50             123.00
    ${ROUNDING_TYPE_DOWN}      999.99             999.00
    ${ROUNDING_TYPE_DOWN}      1000.01            1000.00
    ${ROUNDING_TYPE_NEAREST}   123.45             123.00
    ${ROUNDING_TYPE_NEAREST}   123.50             124.00
    ${ROUNDING_TYPE_NEAREST}   999.99             1000.00
    ${ROUNDING_TYPE_NEAREST}   1000.01            1000.00

RT-RD-005 Làm tròn với khoảng 5.00
    [Documentation]    Kiểm tra làm tròn với khoảng 5.00:
    ...    - Source: InvoiceService.cs > NormalizeData() line ~2150
    ...    - Logic: Áp dụng các công thức làm tròn với khoảng 5.00
    ...    - Kỳ vọng: Các giá trị được làm tròn đến bội số của 5 gần nhất
    [Tags]    rounding    apiinvoice    AIGenerated
    [Template]    Test Làm Tròn Với Khoảng 5.00
    # rounding_type    original_amount    expected_amount
    ${ROUNDING_TYPE_UP}        123.45             125.00
    ${ROUNDING_TYPE_UP}        127.50             130.00
    ${ROUNDING_TYPE_UP}        999.99             1000.00
    ${ROUNDING_TYPE_UP}        1002.01            1005.00
    ${ROUNDING_TYPE_DOWN}      123.45             120.00
    ${ROUNDING_TYPE_DOWN}      127.50             125.00
    ${ROUNDING_TYPE_DOWN}      999.99             995.00
    ${ROUNDING_TYPE_DOWN}      1002.01            1000.00
    ${ROUNDING_TYPE_NEAREST}   123.45             125.00
    ${ROUNDING_TYPE_NEAREST}   127.50             130.00
    ${ROUNDING_TYPE_NEAREST}   999.99             1000.00
    ${ROUNDING_TYPE_NEAREST}   1002.01            1000.00

RT-RD-006 Làm tròn hóa đơn có nhiều sản phẩm
    [Documentation]    Kiểm tra làm tròn hóa đơn có nhiều sản phẩm:
    ...    - Source: InvoiceService.cs > CalculateInvoiceTotal() line ~2200
    ...    - Logic: Tính tổng tiền từ nhiều sản phẩm rồi áp dụng làm tròn
    ...    - SP1: 100.33 × 2.5 = 250.825
    ...    - SP2: (200.67 - 15.25) × 1.75 = 324.485
    ...    - Tổng: 575.31, làm tròn lên với khoảng 1.00 = 576.00
    [Tags]    rounding    apiinvoice    multi-product    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Nhiều Sản Phẩm Với Làm Tròn ${ROUNDING_TYPE_UP} Khoảng ${ROUNDING_INTERVAL_1_00}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Tổng Tiền Hóa Đơn Được Làm Tròn Thành 576.00
    And Xác Thực Cấu Hình Làm Tròn Loại ${ROUNDING_TYPE_UP} Khoảng ${ROUNDING_INTERVAL_1_00}
    And Xác Thực Chênh Lệch Làm Tròn 0.69

RT-RD-007 Làm tròn hóa đơn có chiết khấu
    [Documentation]    Kiểm tra làm tròn hóa đơn có chiết khấu:
    ...    - Source: InvoiceService.cs > CalculateInvoiceTotal() line ~2210
    ...    - Logic: Tính tổng tiền sau chiết khấu rồi áp dụng làm tròn
    ...    - Tổng tiền hàng: 100,000đ
    ...    - Chiết khấu: 15,333đ
    ...    - Tổng sau chiết khấu: 84,667đ
    ...    - Làm tròn xuống với khoảng 5.00: 84,665đ
    [Tags]    rounding    apiinvoice    discount    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu 15333 Làm Tròn ${ROUNDING_TYPE_DOWN} Khoảng ${ROUNDING_INTERVAL_5_00}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Tổng Tiền Hóa Đơn Được Làm Tròn Thành 84665
    And Xác Thực Cấu Hình Làm Tròn Loại ${ROUNDING_TYPE_DOWN} Khoảng ${ROUNDING_INTERVAL_5_00}
    And Xác Thực Chênh Lệch Làm Tròn -2

RT-RD-008 Làm tròn hóa đơn có phụ phí
    [Documentation]    Kiểm tra làm tròn hóa đơn có phụ phí:
    ...    - Source: InvoiceService.cs > CalculateInvoiceTotal() line ~2220
    ...    - Logic: Tính tổng tiền bao gồm phụ phí rồi áp dụng làm tròn
    ...    - Tổng tiền hàng: 100,000đ
    ...    - Phụ phí: 8,250đ
    ...    - Tổng: 108,250đ
    ...    - Làm tròn gần nhất với khoảng 1.00: 108,250đ (không thay đổi)
    [Tags]    rounding    apiinvoice    surcharge    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Phụ Phí 8250 Làm Tròn ${ROUNDING_TYPE_NEAREST} Khoảng ${ROUNDING_INTERVAL_1_00}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Tổng Tiền Hóa Đơn Được Làm Tròn Thành 108250
    And Xác Thực Cấu Hình Làm Tròn Loại ${ROUNDING_TYPE_NEAREST} Khoảng ${ROUNDING_INTERVAL_1_00}
    And Xác Thực Chênh Lệch Làm Tròn 0

RT-RD-009 Làm tròn hóa đơn có thuế
    [Documentation]    Kiểm tra làm tròn hóa đơn có thuế:
    ...    - Source: InvoiceService.cs > CalculateInvoiceTotal() line ~2230
    ...    - Logic: Tính tổng tiền bao gồm thuế rồi áp dụng làm tròn
    ...    - Tổng tiền hàng: 100,000đ
    ...    - Thuế: 12,750đ
    ...    - Tổng: 112,750đ
    ...    - Làm tròn lên với khoảng 0.10: 112,800đ
    [Tags]    rounding    apiinvoice    tax    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế 12750 Làm Tròn ${ROUNDING_TYPE_UP} Khoảng ${ROUNDING_INTERVAL_0_10}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Tổng Tiền Hóa Đơn Được Làm Tròn Thành 112800
    And Xác Thực Cấu Hình Làm Tròn Loại ${ROUNDING_TYPE_UP} Khoảng ${ROUNDING_INTERVAL_0_10}
    And Xác Thực Chênh Lệch Làm Tròn 50

RT-RD-010 Làm tròn hóa đơn phức tạp với đầy đủ yếu tố
    [Documentation]    Kiểm tra làm tròn hóa đơn phức tạp với đầy đủ các yếu tố:
    ...    - Source: InvoiceService.cs > CalculateInvoiceTotal() line ~2240
    ...    - Logic: Tính tổng tiền từ công thức: Tổng tiền hàng - Chiết khấu + Phụ phí + Thuế
    ...    - Tổng tiền hàng: 100,000đ
    ...    - Chiết khấu: 15,333đ
    ...    - Phụ phí: 8,250đ
    ...    - Thuế: 12,750đ
    ...    - Tổng: 105,667đ
    ...    - Làm tròn gần nhất với khoảng 5.00: 105,000đ
    [Tags]    rounding    apiinvoice    complex    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Phức Tạp Với Chiết Khấu 15333 Phụ Phí 8250 Thuế 12750 Làm Tròn ${ROUNDING_TYPE_NEAREST} Khoảng ${ROUNDING_INTERVAL_5_00}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Tổng Tiền Hóa Đơn Được Làm Tròn Thành 105000
    And Xác Thực Cấu Hình Làm Tròn Loại ${ROUNDING_TYPE_NEAREST} Khoảng ${ROUNDING_INTERVAL_5_00}
    And Xác Thực Chênh Lệch Làm Tròn -667

RT-RD-011 Làm tròn với khoảng 10.00
    [Documentation]    Kiểm tra làm tròn với khoảng 10.00:
    ...    - Source: InvoiceService.cs > NormalizeData() line ~2150
    ...    - Logic: Áp dụng các công thức làm tròn với khoảng 10.00
    ...    - Kỳ vọng: Các giá trị được làm tròn đến bội số của 10 gần nhất
    [Tags]    rounding    apiinvoice    AIGenerated
    [Template]    Test Làm Tròn Với Khoảng 10.00
    # rounding_type    original_amount    expected_amount
    ${ROUNDING_TYPE_UP}        1234.56            1240.00
    ${ROUNDING_TYPE_UP}        1235.00            1240.00
    ${ROUNDING_TYPE_UP}        1999.99            2000.00
    ${ROUNDING_TYPE_DOWN}      1234.56            1230.00
    ${ROUNDING_TYPE_DOWN}      1235.00            1230.00
    ${ROUNDING_TYPE_DOWN}      1999.99            1990.00
    ${ROUNDING_TYPE_NEAREST}   1234.56            1230.00
    ${ROUNDING_TYPE_NEAREST}   1235.00            1240.00
    ${ROUNDING_TYPE_NEAREST}   1999.99            2000.00

RT-RD-012 Làm tròn với số tiền âm
    [Documentation]    Kiểm tra làm tròn với số tiền âm (trường hợp hoàn trả):
    ...    - Source: InvoiceService.cs > NormalizeData() line ~2150
    ...    - Logic: Áp dụng làm tròn cho số tiền âm
    ...    - Kỳ vọng: Làm tròn hoạt động đúng với số âm
    [Tags]    rounding    apiinvoice    negative    AIGenerated
    [Template]    Test Làm Tròn Số Âm
    # rounding_type    original_amount    expected_amount
    ${ROUNDING_TYPE_UP}        -123.45            -123.00
    ${ROUNDING_TYPE_UP}        -123.50            -123.00
    ${ROUNDING_TYPE_DOWN}      -123.45            -124.00
    ${ROUNDING_TYPE_DOWN}      -123.50            -124.00
    ${ROUNDING_TYPE_NEAREST}   -123.45            -123.00
    ${ROUNDING_TYPE_NEAREST}   -123.50            -124.00

RT-RD-013 Làm tròn với số tiền bằng 0
    [Documentation]    Kiểm tra làm tròn với số tiền bằng 0:
    ...    - Source: InvoiceService.cs > NormalizeData() line ~2150
    ...    - Logic: Xử lý trường hợp đặc biệt khi số tiền bằng 0
    ...    - Kỳ vọng: Số 0 không bị thay đổi bởi làm tròn
    [Tags]    rounding    apiinvoice    zero    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tổng Tiền 0 Làm Tròn Lên Khoảng ${ROUNDING_INTERVAL_1_00}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Tổng Tiền Hóa Đơn Được Làm Tròn Thành 0
    And Xác Thực Chênh Lệch Làm Tròn 0

RT-RD-014 Làm tròn với số tiền rất lớn
    [Documentation]    Kiểm tra làm tròn với số tiền rất lớn:
    ...    - Source: InvoiceService.cs > NormalizeData() line ~2150
    ...    - Logic: Xử lý làm tròn với số tiền lớn
    ...    - Số tiền: 999,999,999.99đ
    ...    - Làm tròn lên với khoảng 1.00: 1,000,000,000.00đ
    [Tags]    rounding    apiinvoice    large-amount    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tổng Tiền 999999999.99 Làm Tròn Lên Khoảng ${ROUNDING_INTERVAL_1_00}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Tổng Tiền Hóa Đơn Được Làm Tròn Thành 1000000000.00
    And Xác Thực Chênh Lệch Làm Tròn 0.01

RT-RD-015 Làm tròn với số tiền rất nhỏ
    [Documentation]    Kiểm tra làm tròn với số tiền rất nhỏ:
    ...    - Source: InvoiceService.cs > NormalizeData() line ~2150
    ...    - Logic: Xử lý làm tròn với số tiền nhỏ
    ...    - Số tiền: 0.01đ
    ...    - Làm tròn lên với khoảng 0.05: 0.05đ
    [Tags]    rounding    apiinvoice    small-amount    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tổng Tiền 0.01 Làm Tròn Lên Khoảng ${ROUNDING_INTERVAL_0_05}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Tổng Tiền Hóa Đơn Được Làm Tròn Thành 0.05
    And Xác Thực Chênh Lệch Làm Tròn 0.04

*** Keywords ***
Test Làm Tròn Lên Với Khoảng 0.05
    [Arguments]    ${original_amount}    ${expected_amount}
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tổng Tiền ${original_amount} Làm Tròn Lên Khoảng ${ROUNDING_INTERVAL_0_05}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Làm Tròn Lên Từ ${original_amount} Thành ${expected_amount} Với Khoảng ${ROUNDING_INTERVAL_0_05}

Test Làm Tròn Xuống Với Khoảng 0.05
    [Arguments]    ${original_amount}    ${expected_amount}
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tổng Tiền ${original_amount} Làm Tròn Xuống Khoảng ${ROUNDING_INTERVAL_0_05}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Làm Tròn Xuống Từ ${original_amount} Thành ${expected_amount} Với Khoảng ${ROUNDING_INTERVAL_0_05}

Test Làm Tròn Gần Nhất Với Khoảng 0.05
    [Arguments]    ${original_amount}    ${expected_amount}
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tổng Tiền ${original_amount} Làm Tròn Gần Nhất Khoảng ${ROUNDING_INTERVAL_0_05}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Làm Tròn Gần Nhất Từ ${original_amount} Thành ${expected_amount} Với Khoảng ${ROUNDING_INTERVAL_0_05}

Test Làm Tròn Với Khoảng 1.00
    [Arguments]    ${rounding_type}    ${original_amount}    ${expected_amount}
    IF    ${rounding_type} == ${ROUNDING_TYPE_UP}
        Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tổng Tiền ${original_amount} Làm Tròn Lên Khoảng ${ROUNDING_INTERVAL_1_00}
        When Gửi Yêu Cầu Tạo Hóa Đơn
        Then Response Status Code Should Be 200
        And Response Should Have Id exist
        And Xác Thực Làm Tròn Lên Từ ${original_amount} Thành ${expected_amount} Với Khoảng ${ROUNDING_INTERVAL_1_00}
    ELSE IF    ${rounding_type} == ${ROUNDING_TYPE_DOWN}
        Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tổng Tiền ${original_amount} Làm Tròn Xuống Khoảng ${ROUNDING_INTERVAL_1_00}
        When Gửi Yêu Cầu Tạo Hóa Đơn
        Then Response Status Code Should Be 200
        And Response Should Have Id exist
        And Xác Thực Làm Tròn Xuống Từ ${original_amount} Thành ${expected_amount} Với Khoảng ${ROUNDING_INTERVAL_1_00}
    ELSE IF    ${rounding_type} == ${ROUNDING_TYPE_NEAREST}
        Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tổng Tiền ${original_amount} Làm Tròn Gần Nhất Khoảng ${ROUNDING_INTERVAL_1_00}
        When Gửi Yêu Cầu Tạo Hóa Đơn
        Then Response Status Code Should Be 200
        And Response Should Have Id exist
        And Xác Thực Làm Tròn Gần Nhất Từ ${original_amount} Thành ${expected_amount} Với Khoảng ${ROUNDING_INTERVAL_1_00}
    END

Test Làm Tròn Với Khoảng 5.00
    [Arguments]    ${rounding_type}    ${original_amount}    ${expected_amount}
    IF    ${rounding_type} == ${ROUNDING_TYPE_UP}
        Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tổng Tiền ${original_amount} Làm Tròn Lên Khoảng ${ROUNDING_INTERVAL_5_00}
        When Gửi Yêu Cầu Tạo Hóa Đơn
        Then Response Status Code Should Be 200
        And Response Should Have Id exist
        And Xác Thực Làm Tròn Lên Từ ${original_amount} Thành ${expected_amount} Với Khoảng ${ROUNDING_INTERVAL_5_00}
    ELSE IF    ${rounding_type} == ${ROUNDING_TYPE_DOWN}
        Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tổng Tiền ${original_amount} Làm Tròn Xuống Khoảng ${ROUNDING_INTERVAL_5_00}
        When Gửi Yêu Cầu Tạo Hóa Đơn
        Then Response Status Code Should Be 200
        And Response Should Have Id exist
        And Xác Thực Làm Tròn Xuống Từ ${original_amount} Thành ${expected_amount} Với Khoảng ${ROUNDING_INTERVAL_5_00}
    ELSE IF    ${rounding_type} == ${ROUNDING_TYPE_NEAREST}
        Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tổng Tiền ${original_amount} Làm Tròn Gần Nhất Khoảng ${ROUNDING_INTERVAL_5_00}
        When Gửi Yêu Cầu Tạo Hóa Đơn
        Then Response Status Code Should Be 200
        And Response Should Have Id exist
        And Xác Thực Làm Tròn Gần Nhất Từ ${original_amount} Thành ${expected_amount} Với Khoảng ${ROUNDING_INTERVAL_5_00}
    END

Test Làm Tròn Với Khoảng 10.00
    [Arguments]    ${rounding_type}    ${original_amount}    ${expected_amount}
    IF    ${rounding_type} == ${ROUNDING_TYPE_UP}
        Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tổng Tiền ${original_amount} Làm Tròn Lên Khoảng ${ROUNDING_INTERVAL_10_00}
        When Gửi Yêu Cầu Tạo Hóa Đơn
        Then Response Status Code Should Be 200
        And Response Should Have Id exist
        And Xác Thực Làm Tròn Lên Từ ${original_amount} Thành ${expected_amount} Với Khoảng ${ROUNDING_INTERVAL_10_00}
    ELSE IF    ${rounding_type} == ${ROUNDING_TYPE_DOWN}
        Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tổng Tiền ${original_amount} Làm Tròn Xuống Khoảng ${ROUNDING_INTERVAL_10_00}
        When Gửi Yêu Cầu Tạo Hóa Đơn
        Then Response Status Code Should Be 200
        And Response Should Have Id exist
        And Xác Thực Làm Tròn Xuống Từ ${original_amount} Thành ${expected_amount} Với Khoảng ${ROUNDING_INTERVAL_10_00}
    ELSE IF    ${rounding_type} == ${ROUNDING_TYPE_NEAREST}
        Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tổng Tiền ${original_amount} Làm Tròn Gần Nhất Khoảng ${ROUNDING_INTERVAL_10_00}
        When Gửi Yêu Cầu Tạo Hóa Đơn
        Then Response Status Code Should Be 200
        And Response Should Have Id exist
        And Xác Thực Làm Tròn Gần Nhất Từ ${original_amount} Thành ${expected_amount} Với Khoảng ${ROUNDING_INTERVAL_10_00}
    END

Test Làm Tròn Số Âm
    [Arguments]    ${rounding_type}    ${original_amount}    ${expected_amount}
    IF    ${rounding_type} == ${ROUNDING_TYPE_UP}
        Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tổng Tiền ${original_amount} Làm Tròn Lên Khoảng ${ROUNDING_INTERVAL_1_00}
        When Gửi Yêu Cầu Tạo Hóa Đơn
        Then Response Status Code Should Be 200
        And Response Should Have Id exist
        And Xác Thực Làm Tròn Lên Từ ${original_amount} Thành ${expected_amount} Với Khoảng ${ROUNDING_INTERVAL_1_00}
    ELSE IF    ${rounding_type} == ${ROUNDING_TYPE_DOWN}
        Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tổng Tiền ${original_amount} Làm Tròn Xuống Khoảng ${ROUNDING_INTERVAL_1_00}
        When Gửi Yêu Cầu Tạo Hóa Đơn
        Then Response Status Code Should Be 200
        And Response Should Have Id exist
        And Xác Thực Làm Tròn Xuống Từ ${original_amount} Thành ${expected_amount} Với Khoảng ${ROUNDING_INTERVAL_1_00}
    ELSE IF    ${rounding_type} == ${ROUNDING_TYPE_NEAREST}
        Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tổng Tiền ${original_amount} Làm Tròn Gần Nhất Khoảng ${ROUNDING_INTERVAL_1_00}
        When Gửi Yêu Cầu Tạo Hóa Đơn
        Then Response Status Code Should Be 200
        And Response Should Have Id exist
        And Xác Thực Làm Tròn Gần Nhất Từ ${original_amount} Thành ${expected_amount} Với Khoảng ${ROUNDING_INTERVAL_1_00}
    END 