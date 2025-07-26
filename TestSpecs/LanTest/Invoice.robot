*** Settings ***
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../Keywords/Login/Login.robot
Resource          ../../Config/Env_${ENV}.robot
Resource          ../../TestData/LanTest/Invoice_data.robot
Resource          ../../Keywords/LanTest/Invoice_keywords.robot
Resource          ../../Keywords/Utilities/ResponseHelper.robot


*** Test Cases ***

RT-INVOICE-001 Tạo hóa đơn với sản phẩm cơ bản
    [Tags]        laninvoices
    Given Chuẩn bị dữ liệu hóa đơn cơ bản    ${CARD}    3000000    ${ACCOUNT_ID}
    When Gửi yêu cầu tạo hóa đơn cơ bản
    Then Mã trạng thái phải là 200
    And Kiểm tra hóa đơn đã tạo thành công
    And Kiểm tra hàng hóa trong hóa đơn
    And Kiểm tra khách hàng trong hóa đơn
    And Kiểm tra phương thức thanh toán trong hóa đơn
    And Kiểm tra công nợ hóa đơn
    [Teardown]    Xóa hóa đơn sau khi kiểm tra

RT-INVOICE-002 Tạo hóa đơn thất bại khi một trong nhiều phương thức thanh toán có tài khoản ngân hàng không hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi một trong nhiều phương thức thanh toán có tài khoản ngân hàng không hợp lệ
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán 1: thẻ, số tiền 50,000đ, tài khoản ngân hàng ID: ${VALID_BANK_ACCOUNT_ID} (hợp lệ)
    ...    - Phương thức thanh toán 2: chuyển khoản, số tiền 50,000đ, tài khoản ngân hàng ID: ${INVALID_BANK_ACCOUNT_ID} (không tồn tại)
    ...    - Logic xử lý:
    ...      + BankAccountService.ValidateBankAccount() kiểm tra tài khoản tồn tại cho mỗi phương thức thanh toán
    ...      + Phương thức 2 sẽ gây lỗi vì tài khoản không tồn tại
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Tài khoản ngân hàng được chọn không tồn tại hoặc đã bị xóa khỏi hệ thống."
    [Tags]    laninvoices
    Given Chuẩn bị dữ liệu hóa đơn cơ bản    ${TRANSFER}    1000000    ${INVALID_ACCOUNT_ID}
    When Gửi yêu cầu tạo hóa đơn cơ bản
    Then Mã trạng thái phải là 420
    And Kết quả trả về có chứa message lỗi Tài khoản ngân hàng được chọn không tồn tại hoặc đã bị xóa khỏi hệ thống.
