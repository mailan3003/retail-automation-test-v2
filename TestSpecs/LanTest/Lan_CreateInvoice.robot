*** Settings ***
Suite Setup          Init Test Environment   ${ENV}    MHQL
Resource    ../../Keywords/Login/Login.robot
Resource    ../../Keywords/LanTest/Lan_CreateInvoice_keywords.robot
Resource    ../../TestData/LanTest/Lan_CreateInvoice_data.robot
Resource          ../../TestData/CommonData.robot
Library    ../../Resources/DatabaseLibrary.py
Resource    ../../Keywords/Utilities/Utilities.robot
Library    ../../Resources/DatabaseLibrary.py
Resource    ../../Keywords/Utilities/DataUtilities.robot
Resource    ../../Keywords/Utilities/ResponseHelper.robot
Library    DateTime

*** Variables ***
@{payment_list}    ${PAYMENT_CASH}    ${PAYMENT_CARD}
@{list_amount}    150000    2500000 
${INVALID_BANK_ACCOUNT_ID}=    000000000

*** Test Cases ***
TC01 Tao hoa don voi du lieu san pham co ban
    [Tags]    Lantesttt
    Given Chuẩn bị dữ liệu tạo hóa đơn với phương thức thanh toán ${PAYMENT_CARD} và số tiền 100000
    When Gửi yêu cầu tạo hóa đơn cơ bản
    Then Nội dung phản hồi trả về phải tồn tại Id
    And Xác thực phiếu thu được tạo với số tiền 100000
    And Xác thực phiếu thu có mã phù Hợp
    And Xác thực ngày tạo phiếu thu là ngày hiện tại
    And Xác thực tổng thanh toán của hóa đơn là 100000
    And Xác thực công nợ của hóa đơn là 0
    [Teardown]    Xóa hóa đơn vừa tạo




TC02 Tao hoa don voi phuong thuc thanh toan the
    [Tags]    Lantesttt
    Given Chuẩn bị dữ liệu tạo hóa đơn với phương thức ${PAYMENT_CASH} tài khoản ${BANK_ACCOUNT_CODE} với số tiền 2000000
    When Gửi yêu cầu tạo hóa đơn cơ bản
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác thực phiếu thu được tạo với số tiền 2000000
    And Xác thực phiếu thu có mã phù Hợp
    And Xác thực ngày tạo phiếu thu là ngày hiện tại
    And Xác thực thanh toán được ghi nhận với phương thức ${PAYMENT_CASH} và số tiền 2000000
    And Xác thực công nợ của hóa đơn là 0
    [Teardown]    Xóa hóa đơn vừa tạo


RT-INV-003 Tạo hóa đơn kết hợp nhiều phương thức thanh toán
    [Tags]    Lantesttt
    Given Chuẩn bị dữ liệu tạo hóa đơn với các phương thức thanh toán ${payment_list} và số tiền ${list_amount}
    When Gửi yêu cầu tạo hóa đơn cơ bản
    Then Mã trạng thái phải là 200
    And Xác thực phiếu thu được tạo với các phương thức ${payment_list} và số tiền ${list_amount}
    And Xác thực công nợ của hóa đơn là 0
    [Teardown]       Xóa hóa đơn vừa tạo



