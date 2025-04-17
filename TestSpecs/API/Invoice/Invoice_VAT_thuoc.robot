*** Settings ***
Documentation     Test cases API cho phần xử lý thuế VAT trên hóa đơn
Resource          ../../../Keywords/Invoice/InvoiceVATKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    InvoiceVATTest

*** Test Cases ***
RT-VAT-001 Tạo hóa đơn với thuế VAT mặc định
    [Documentation]    Kiểm tra tạo hóa đơn với thuế VAT mặc định
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Không chỉ định thuế VAT (sử dụng mặc định 10%)
    ...    - Logic xử lý:
    ...    - Tổng tiền trước thuế = 100,000đ
    ...    - Tiền thuế = 100,000đ * 10% = 10,000đ
    ...    - Tổng tiền sau thuế = 110,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được lưu vào CSDL với thông tin thuế chính xác
    ...    - Tổng tiền trước thuế = 100,000đ
    ...    - Tiền thuế = 10,000đ
    ...    - Tổng tiền sau thuế = 110,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế Mặc Định
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong CSDL
    And Xác Thực Thông Tin Thuế    ${INVOICE_ID}    10    100000    10000    110000

RT-VAT-002 Tạo hóa đơn với thuế VAT tùy chỉnh
    [Documentation]    Kiểm tra tạo hóa đơn với thuế VAT tùy chỉnh
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Thuế VAT = 8%
    ...    - Logic xử lý:
    ...    - Tổng tiền trước thuế = 100,000đ
    ...    - Tiền thuế = 100,000đ * 8% = 8,000đ
    ...    - Tổng tiền sau thuế = 108,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được lưu vào CSDL với thông tin thuế chính xác
    ...    - Tổng tiền trước thuế = 100,000đ
    ...    - Tiền thuế = 8,000đ
    ...    - Tổng tiền sau thuế = 108,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế Tùy Chỉnh    8
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong CSDL
    And Xác Thực Thông Tin Thuế    ${INVOICE_ID}    8    100000    8000    108000

RT-VAT-003 Tạo hóa đơn không tính thuế VAT
    [Documentation]    Kiểm tra tạo hóa đơn không tính thuế VAT
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Thuế VAT = 0%
    ...    - Logic xử lý:
    ...    - Tổng tiền trước thuế = 100,000đ
    ...    - Tiền thuế = 0đ
    ...    - Tổng tiền sau thuế = 100,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được lưu vào CSDL với thông tin thuế chính xác
    ...    - Tổng tiền trước thuế = 100,000đ
    ...    - Tiền thuế = 0đ
    ...    - Tổng tiền sau thuế = 100,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế Tùy Chỉnh    0
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong CSDL
    And Xác Thực Thông Tin Thuế    ${INVOICE_ID}    0    100000    0    100000

RT-VAT-004 Tạo hóa đơn với thuế VAT không hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn với thuế VAT không hợp lệ
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Thuế VAT = -5% (giá trị âm không hợp lệ)
    ...    - Logic xử lý:
    ...    - Hệ thống kiểm tra giá trị thuế phải >= 0
    ...    - Kỳ vọng:
    ...    - Status code: 400
    ...    - Thông báo lỗi: "Thuế suất không hợp lệ"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế Tùy Chỉnh    -5
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 400
    And Response Should Have Error "Thuế suất không hợp lệ"

RT-VAT-005 Tạo hóa đơn với thuế VAT vượt giới hạn
    [Documentation]    Kiểm tra tạo hóa đơn với thuế VAT vượt giới hạn
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Thuế VAT = 101% (vượt giới hạn 100%)
    ...    - Logic xử lý:
    ...    - Hệ thống kiểm tra giá trị thuế phải <= 100%
    ...    - Kỳ vọng:
    ...    - Status code: 400
    ...    - Thông báo lỗi: "Thuế suất không hợp lệ"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế Tùy Chỉnh    101
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 400
    And Response Should Have Error "Thuế suất không hợp lệ"

RT-VAT-006 Tạo hóa đơn với nhiều sản phẩm có thuế VAT khác nhau
    [Documentation]    Kiểm tra tạo hóa đơn với nhiều sản phẩm có thuế VAT khác nhau
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm 1: SP040943, SL=1, Giá=100,000đ, VAT=10%
    ...    - Sản phẩm 2: SP040944, SL=1, Giá=200,000đ, VAT=5%
    ...    - Logic xử lý:
    ...    - Tiền thuế SP1 = 100,000đ * 10% = 10,000đ
    ...    - Tiền thuế SP2 = 200,000đ * 5% = 10,000đ
    ...    - Tổng tiền trước thuế = 300,000đ
    ...    - Tổng tiền thuế = 20,000đ
    ...    - Tổng tiền sau thuế = 320,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được lưu vào CSDL với thông tin thuế chính xác
    ...    - Tổng tiền trước thuế = 300,000đ
    ...    - Tổng tiền thuế = 20,000đ
    ...    - Tổng tiền sau thuế = 320,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Sản Phẩm Thuế Khác Nhau
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong CSDL
    And Xác Thực Thông Tin Thuế    ${INVOICE_ID}    0    300000    20000    320000
    And Xác Thực Chi Tiết Thuế Sản Phẩm    ${INVOICE_ID}    ${PRODUCT_1}    10    10000
    And Xác Thực Chi Tiết Thuế Sản Phẩm    ${INVOICE_ID}    ${PRODUCT_2}    5    10000
