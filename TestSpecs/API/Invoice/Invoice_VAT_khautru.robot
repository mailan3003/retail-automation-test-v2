*** Settings ***
Documentation     Test cases API cho phần xử lý thuế VAT trên hóa đơn
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Invoice/InvoiceVATKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Utilities/RequestHelper.robot
Resource          ../../../Keywords/Utilities/DataUtilities.robot
Resource          ../../../TestData/Invoice/CommonInvoiceData.robot
Library           ../../../Resources/DatabaseLibrary.py

*** Keywords ***


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
    [Tags]    apiinvoice    vat    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế Mặc Định Với Sản Phẩm HH0052 
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Thông Tin Thuế ${TOTAL_TAX}

RT-VAT-002 Tạo hóa đơn VAT với hàng hóa giảm giá
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
    [Tags]    apiinvoice    vat    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Hàng Hóa HH0053 Giảm Giá 10000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Thông Tin Thuế ${TOTAL_TAX}

RT-VAT-003 Tạo hóa đơn Hàng hóa nhiều dòng có VAT
    [Documentation]    Kiểm tra tạo hóa đơn Hàng hóa nhiều dòng có VAT
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic xử lý:
    ...    - Tổng tiền trước thuế = 100,000đ
    ...    - Tổng tiền sau thuế = 100,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được lưu vào CSDL với thông tin thuế chính xác
    ...    - Tổng tiền trước thuế = 100,000đ
    ...    - Tiền thuế = 0đ
    ...    - Tổng tiền sau thuế = 100,000đ
    [Tags]    apiinvoice    vat    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm HH0053 có 2 Dòng 
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Thông Tin Thuế ${TOTAL_TAX}


RT-VAT-004 Tạo hóa đơn với nhiều sản phẩm có thuế VAT khác nhau
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
    [Tags]    apiinvoice    vat    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm HH0050 Và HH0052 Có Thuế VAT Khác Nhau
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Thông Tin Thuế ${TOTAL_TAX}
