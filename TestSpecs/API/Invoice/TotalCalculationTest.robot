*** Settings ***
Documentation     Test cases API cho phần tính tổng tiền hàng
Resource          ../../../Keywords/Invoice/TotalCalculationKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    TotalCalculationTest

*** Test Cases ***
RT-TC-001 Tính tổng tiền hàng cơ bản
    [Documentation]    Kiểm tra tính tổng tiền hàng với dữ liệu cơ bản
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_TOTAL_001"
    ...    - Sản phẩm: ID=520107862, SL=1, Giá=100,000đ
    ...    - Không có chiết khấu hay thuế
    ...    - Logic tính toán: Total = SUM(Quantity * Price) = 1 * 100,000 = 100,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - SubTotal: 100,000đ
    ...    - Total: 100,000đ
    ...    - Discount: 0đ
    ...    - VatAmount: 0đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Tổng Tiền Trong DB
    And Xác Thực Chi Tiết Hóa Đơn    ${INVOICE_ID}    ${PRODUCT_1}    1    100000

RT-TC-002 Tính tổng tiền hàng nhiều sản phẩm
    [Documentation]    Kiểm tra tính tổng tiền hàng với nhiều sản phẩm khác nhau
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TOTAL_002" 
    ...    - Sản phẩm 1: ID=520107862, SL=2, Giá=100,000đ
    ...    - Sản phẩm 2: ID=1002, SL=1, Giá=200,000đ
    ...    - Không có chiết khấu hay thuế
    ...    - Logic tính toán: Total = SUM(Quantity * Price) = (2 * 100,000) + (1 * 200,000) = 400,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - SubTotal: 400,000đ
    ...    - Total: 400,000đ
    ...    - Discount: 0đ
    ...    - VatAmount: 0đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Nhiều Sản Phẩm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Tổng Tiền Trong DB
    And Xác Thực Chi Tiết Hóa Đơn    ${INVOICE_ID}    ${PRODUCT_1}    2    100000
    And Xác Thực Chi Tiết Hóa Đơn    ${INVOICE_ID}    ${PRODUCT_2}    1    200000

RT-TC-003 Tính tổng tiền hàng với chiết khấu sản phẩm
    [Documentation]    Kiểm tra tính tổng tiền hàng với chiết khấu trên sản phẩm
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TOTAL_001"
    ...    - Sản phẩm: ID=520107862, SL=1, Giá=100,000đ, Chiết khấu=10,000đ
    ...    - Logic tính toán: 
    ...      + SubTotal = 100,000đ
    ...      + Discount = 10,000đ
    ...      + Total = SubTotal - Discount = 90,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - SubTotal: 100,000đ
    ...    - Total: 90,000đ
    ...    - Discount: 10,000đ
    ...    - VatAmount: 0đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Sản Phẩm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Tổng Tiền Trong DB
    And Xác Thực Chi Tiết Hóa Đơn    ${INVOICE_ID}    ${PRODUCT_1}    1    100000    10000

RT-TC-004 Tính tổng tiền hàng với chiết khấu phần trăm sản phẩm
    [Documentation]    Kiểm tra tính tổng tiền hàng với chiết khấu phần trăm trên sản phẩm
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TOTAL_001"
    ...    - Sản phẩm: ID=520107862, SL=1, Giá=100,000đ, Tỉ lệ chiết khấu=10%
    ...    - Logic tính toán: 
    ...      + SubTotal = 100,000đ
    ...      + Discount = 10% * 100,000 = 10,000đ
    ...      + Total = SubTotal - Discount = 90,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - SubTotal: 100,000đ
    ...    - Total: 90,000đ
    ...    - Discount: 10,000đ
    ...    - VatAmount: 0đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Phần Trăm Sản Phẩm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Tổng Tiền Trong DB
    And Xác Thực Chi Tiết Hóa Đơn    ${INVOICE_ID}    ${PRODUCT_1}    1    100000    10000

RT-TC-005 Tính tổng tiền hàng với thuế VAT
    [Documentation]    Kiểm tra tính tổng tiền hàng có thuế VAT không bao gồm trong giá
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TOTAL_001"
    ...    - Sản phẩm: ID=3333, SL=1, Giá=100,000đ, Thuế VAT=10%
    ...    - Cấu hình: VatIncluded=False (Thuế VAT không bao gồm trong giá)
    ...    - Logic tính toán: 
    ...      + SubTotal = 100,000đ
    ...      + VatAmount = 10% * 100,000 = 10,000đ
    ...      + Total = SubTotal + VatAmount = 110,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - SubTotal: 100,000đ
    ...    - Total: 110,000đ
    ...    - Discount: 0đ
    ...    - VatAmount: 10,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế VAT
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Tổng Tiền Trong DB
    And Xác Thực Chi Tiết Hóa Đơn    ${INVOICE_ID}    ${product_with_vat}    1    100000    0    10000

RT-TC-006 Tính tổng tiền hàng với thuế VAT đã bao gồm
    [Documentation]    Kiểm tra tính tổng tiền hàng có thuế VAT đã bao gồm trong giá
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TOTAL_001"
    ...    - Sản phẩm: ID=3333, SL=1, Giá=100,000đ, Thuế VAT=10%
    ...    - Cấu hình: VatIncluded=True (Thuế VAT đã bao gồm trong giá)
    ...    - Logic tính toán: 
    ...      + Giá chưa thuế = 100,000 / 1.10 = 90,909đ
    ...      + SubTotal = 90,909đ
    ...      + VatAmount = 10% * 90,909 = 9,091đ
    ...      + Total = 100,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - SubTotal: 90,909đ
    ...    - Total: 100,000đ
    ...    - Discount: 0đ
    ...    - VatAmount: 9,091đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế VAT Bao Gồm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Tổng Tiền Trong DB
    And Xác Thực Chi Tiết Hóa Đơn    ${INVOICE_ID}    ${product_with_vat}    1    100000    0    9091

RT-TC-007 Tính tổng tiền hàng với chiết khấu trên tổng hóa đơn
    [Documentation]    Kiểm tra tính tổng tiền hàng có chiết khấu trên tổng hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TOTAL_003"
    ...    - Sản phẩm: ID=520107862, SL=1, Giá=100,000đ
    ...    - Chiết khấu hóa đơn: 50,000đ
    ...    - Logic tính toán:
    ...      + SubTotal = 100,000đ
    ...      + Discount = 50,000đ
    ...      + Total = SubTotal - Discount = 50,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - SubTotal: 100,000đ
    ...    - Total: 50,000đ
    ...    - Discount: 50,000đ
    ...    - VatAmount: 0đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Tổng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Tổng Tiền Trong DB
    And Xác Thực Chi Tiết Hóa Đơn    ${INVOICE_ID}    ${PRODUCT_1}    1    100000

RT-TC-008 Tính tổng tiền hàng với chiết khấu phần trăm trên tổng hóa đơn
    [Documentation]    Kiểm tra tính tổng tiền hàng có chiết khấu phần trăm trên tổng hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TOTAL_004"
    ...    - Sản phẩm: ID=520107862, SL=1, Giá=100,000đ
    ...    - Tỉ lệ chiết khấu hóa đơn: 10%
    ...    - Logic tính toán:
    ...      + SubTotal = 100,000đ
    ...      + Discount = 10% * 100,000 = 10,000đ
    ...      + Total = SubTotal - Discount = 90,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - SubTotal: 100,000đ
    ...    - Total: 90,000đ
    ...    - Discount: 10,000đ
    ...    - VatAmount: 0đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Tổng Phần Trăm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Tổng Tiền Trong DB
    And Xác Thực Chi Tiết Hóa Đơn    ${INVOICE_ID}    ${PRODUCT_1}    1    100000

RT-TC-009 Tính tổng tiền hàng kết hợp thuế và chiết khấu
    [Documentation]    Kiểm tra tính tổng tiền hàng kết hợp cả thuế và chiết khấu
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TOTAL_001"
    ...    - Sản phẩm: ID=3333, SL=1, Giá=100,000đ, Chiết khấu=10,000đ, Thuế VAT=10%
    ...    - Logic tính toán:
    ...      + SubTotal = 100,000đ
    ...      + Discount = 10,000đ
    ...      + Giá sau chiết khấu = 100,000 - 10,000 = 90,000đ
    ...      + VatAmount = 10% * 90,000 = 9,000đ (thuế tính trên giá sau chiết khấu)
    ...      + Total = (SubTotal - Discount) + VatAmount = 90,000 + 9,000 = 99,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - SubTotal: 100,000đ
    ...    - Total: 99,000đ
    ...    - Discount: 10,000đ
    ...    - VatAmount: 9,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Kết Hợp Thuế Và Chiết Khấu
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Tổng Tiền Trong DB
    And Xác Thực Chi Tiết Hóa Đơn    ${INVOICE_ID}    ${product_with_vat}    1    100000    10000    9000 