*** Settings ***
Documentation     Test cases API cho phần xử lý dữ liệu đầu vào khi tạo hóa đơn
Resource          ../../../Keywords/Invoice/DataProcessingKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    InvoiceVATkhautru

*** Test Cases ***
RT-DP-004 Tính thuế VAT của hóa đơn
    [Documentation]    Kiểm tra tính thuế VAT của hóa đơn
    ...    - Dữ liệu đầu vào: 
    ...    - Sản phẩm 1: ID=${product_with_vat}, Số lượng=1, Giá=100,000đ, Thuế suất=10%
    ...    - Logic xử lý: InvoiceService.CalculateVAT() 
    ...    - Code: VAT = invoice.InvoiceDetails.Sum(x => x.Quantity * x.Price * x.VATRate / 100);
    ...    - Thuế VAT = 1 * 100,000đ * 10% = 10,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Thuế VAT trong DB được lưu đúng: 10,000đ
    ...    - Cờ thuế VAT được bật (IsVAT=1)
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Thuế Hóa Đơn    ${INVOICE_ID}    10000