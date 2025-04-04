*** Settings ***
Documentation     Test cases API cho phần tính tổng tiền hóa đơn
Resource          ../../../TestData/CommonData.robot
Resource          ../../../TestData/Invoice/CommonInvoiceData.robot 
Resource          ../../../TestData/Invoice/InvoiceTotalData.robot
Resource          ../../../Keywords/Invoice/InvoiceTotalKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Suite Setup       Suite Setup
Suite Teardown    Suite Teardown

*** Test Cases ***
RT-IT-001 Tính tổng tiền thành công với một sản phẩm
    [Documentation]    Kiểm tra tính tổng tiền hóa đơn với một sản phẩm:
    ...    - Sản phẩm: 1 x 100,000đ = 100,000đ
    ...    - Tổng tiền: 100,000đ
    [Tags]    api    invoice    total
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Một Sản Phẩm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Tổng Tiền Hóa Đơn    ${INVOICE_ID}    100000
    And Xác Thực Chi Tiết Giá Sản Phẩm    ${INVOICE_ID}    ${PRODUCT_1}    100000    0

RT-IT-002 Tính tổng tiền thành công với sản phẩm có giảm giá
    [Documentation]    Kiểm tra tính tổng tiền hóa đơn với một sản phẩm có giảm giá:
    ...    - Sản phẩm: 1 x 100,000đ, giảm giá: 10,000đ
    ...    - Giá sau giảm: (100,000đ - 10,000đ) = 90,000đ
    ...    - Tổng tiền: 90,000đ
    [Tags]    api    invoice    total    discount
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Có Giảm Giá
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Tổng Tiền Hóa Đơn    ${INVOICE_ID}    90000
    And Xác Thực Chi Tiết Giá Sản Phẩm    ${INVOICE_ID}    ${PRODUCT_1}    100000    10000

RT-IT-003 Tính tổng tiền thành công với nhiều sản phẩm
    [Documentation]    Kiểm tra tính tổng tiền hóa đơn với nhiều sản phẩm:
    ...    - SP1: 1 x 100,000đ = 100,000đ
    ...    - SP2: 1 x 200,000đ = 200,000đ
    ...    - Tổng tiền: 300,000đ
    [Tags]    api    invoice    total    multiple
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Sản Phẩm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Tổng Tiền Hóa Đơn    ${INVOICE_ID}    300000
    And Xác Thực Chi Tiết Giá Sản Phẩm    ${INVOICE_ID}    ${PRODUCT_1}    100000    0
    And Xác Thực Chi Tiết Giá Sản Phẩm    ${INVOICE_ID}    ${PRODUCT_2}    200000    0

RT-IT-004 Tính tổng tiền thành công với giảm giá cả hóa đơn
    [Documentation]    Kiểm tra tính tổng tiền hóa đơn với giảm giá trên tổng hóa đơn:
    ...    - SP1: 1 x 100,000đ = 100,000đ
    ...    - SP2: 1 x 200,000đ = 200,000đ
    ...    - Tổng trước giảm giá: 300,000đ
    ...    - Giảm giá hóa đơn: 20,000đ
    ...    - Tổng sau giảm giá: 280,000đ
    [Tags]    api    invoice    total    discount
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Giảm Giá Hóa Đơn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Tổng Tiền Hóa Đơn    ${INVOICE_ID}    2800000
    And Xác Thực Giảm Giá Hóa Đơn    ${INVOICE_ID}    20000

RT-IT-005 Tính tổng tiền thành công với phụ phí cố định
    [Documentation]    Kiểm tra tính tổng tiền hóa đơn với phụ phí cố định:
    ...    - Sản phẩm: 1 x 100,000đ = 100,000đ
    ...    - Phụ phí: 10,000đ
    ...    - Tổng tiền: 110,000đ
    [Tags]    api    invoice    total    surcharge
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Phụ Phí Cố Định
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Tổng Tiền Hóa Đơn    ${INVOICE_ID}    110000
    And Xác Thực Phụ Phí Hóa Đơn    ${INVOICE_ID}    10000
    And Xác Thực Chi Tiết Phụ Phí    ${INVOICE_ID}    ${SURCHARGE_1_ID}    10000

RT-IT-006 Tính tổng tiền thành công với phụ phí phần trăm
    [Documentation]    Kiểm tra tính tổng tiền hóa đơn với phụ phí theo phần trăm:
    ...    - Sản phẩm: 1 x 100,000đ = 100,000đ
    ...    - Phụ phí phần trăm: 10% * 100,000đ = 10,000đ
    ...    - Tổng tiền: 110,000đ
    [Tags]    api    invoice    total    surcharge
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Phụ Phí Phần Trăm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Tổng Tiền Hóa Đơn    ${INVOICE_ID}    110000
    And Xác Thực Phụ Phí Hóa Đơn    ${INVOICE_ID}    10000

RT-IT-007 Tính tổng tiền thành công với sản phẩm có thuế VAT
    [Documentation]    Kiểm tra tính tổng tiền hóa đơn với sản phẩm có thuế VAT:
    ...    - Sản phẩm: 1 x 100,000đ = 100,000đ
    ...    - Thuế VAT: 5% * 100,000đ = 5,000đ
    ...    - Tổng tiền: 105,000đ
    [Tags]    api    invoice    total    tax
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế VAT
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Tổng Tiền Hóa Đơn    ${INVOICE_ID}    105000
    And Xác Thực Tổng Thuế    ${INVOICE_ID}    5000

RT-IT-008 Tính tổng tiền thành công với số lượng sản phẩm lớn hơn 1
    [Documentation]    Kiểm tra tính tổng tiền hóa đơn với số lượng sản phẩm lớn hơn 1:
    ...    - Sản phẩm: 2 x 100,000đ = 200,000đ
    ...    - Tổng tiền: 200,000đ
    [Tags]    api    invoice    total    quantity
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Số Lượng Nhiều
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Tổng Tiền Hóa Đơn    ${INVOICE_ID}    200000
    And Xác Thực Chi Tiết Giá Sản Phẩm    ${INVOICE_ID}    ${PRODUCT_1}    100000    0

RT-IT-009 Tính tổng tiền thành công với tất cả các thành phần (sản phẩm, giảm giá, phụ phí, thuế)
    [Documentation]    Kiểm tra tính tổng tiền với tất cả các thành phần:
    ...    - Sản phẩm 1: 1 x 100,000đ = 100,000đ (sau giảm 10,000đ = 90,000đ)
    ...    - Sản phẩm 2: 1 x 200,000đ = 200,000đ
    ...    - Tổng sau giảm giá sản phẩm: 290,000đ
    ...    - Giảm giá hóa đơn: 20,000đ
    ...    - Tổng sau giảm giá hóa đơn: 270,000đ
    ...    - Phụ phí: 10,000đ
    ...    - Thuế VAT: 10% * 270,000đ = 27,000đ
    ...    - Tổng cuối: 307,000đ
    [Tags]    api    invoice    total    complex
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Phức Hợp
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Tổng Tiền Hóa Đơn    ${INVOICE_ID}    307000
    And Xác Thực Giảm Giá Hóa Đơn    ${INVOICE_ID}    20000
    And Xác Thực Phụ Phí Hóa Đơn    ${INVOICE_ID}    10000
    And Xác Thực Tổng Thuế    ${INVOICE_ID}    27000

RT-IT-010 Tính tổng tiền thành công với sản phẩm combo
    [Documentation]    Kiểm tra tính tổng tiền hóa đơn với sản phẩm combo:
    ...    - Sản phẩm combo: 1 x 250,000đ = 250,000đ
    ...    - Các thành phần con: SP1 (100,000đ) + SP2 (150,000đ) = 250,000đ
    ...    - Tổng tiền: 250,000đ
    [Tags]    api    invoice    total    combo
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Combo
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Tổng Tiền Hóa Đơn    ${INVOICE_ID}    250000
    And Xác Thực Sản Phẩm Combo    ${INVOICE_ID}    ${COMBO_PRODUCT_1_ID}    250000

*** Keywords ***

Suite Setup
    Log    Bắt đầu test suite tính tổng tiền hóa đơn

Suite Teardown
    Log    Kết thúc test suite tính tổng tiền hóa đơn 