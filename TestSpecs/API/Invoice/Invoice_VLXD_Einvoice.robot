*** Settings ***
Resource    ../../../Keywords/Utilities/ResponseHelper.robot
Resource    ../../../Keywords/Invoice/InvoiceEInvoiceValidationKeywords.robot
Resource    ../../../TestData/CommonData.robot
Resource    ../../../TestData/Invoice/InvoiceEInvoiceValidationData.robot

*** Test Cases ***
RT-INEIV-001 Kiểm tra tạo hóa đơn điện tử thất bại khi không có thông tin kết nối VNPT
    [Documentation]    Kiểm tra không cho phép tạo hóa đơn điện tử VNPT khi thiếu thông tin đăng nhập
    [Tags]    invoice    validation    einvoice    vnpt    auth
    Given Chuẩn bị dữ liệu hóa đơn VNPT với tài khoản không hợp lệ
    When Gửi yêu cầu tạo hóa đơn điện tử
    Then Response Status Code Should Be 400
    And Response Should Have Error "Thông tin đăng nhập VNPT không hợp lệ"

RT-INEIV-002 Kiểm tra tạo hóa đơn điện tử thất bại khi mẫu hóa đơn VNPT không hợp lệ
    [Documentation]    Kiểm tra không cho phép tạo hóa đơn điện tử VNPT khi mẫu hóa đơn không hợp lệ
    [Tags]    invoice    validation    einvoice    vnpt    template
    Given Chuẩn bị dữ liệu hóa đơn VNPT với mẫu số ${invoice_einvoice_validation_vnpt_invalid_template}
    When Gửi yêu cầu tạo hóa đơn điện tử
    Then Response Status Code Should Be 400
    And Response Should Have Error "Mẫu hóa đơn không hợp lệ"

RT-INEIV-003 Kiểm tra tạo hóa đơn điện tử thất bại khi mẫu hóa đơn VNPT hết hạn
    [Documentation]    Kiểm tra không cho phép tạo hóa đơn điện tử VNPT khi mẫu hóa đơn đã hết hạn
    [Tags]    invoice    validation    einvoice    vnpt    expired
    Given Chuẩn bị dữ liệu hóa đơn VNPT với mẫu số ${invoice_einvoice_validation_vnpt_expired_template}
    When Gửi yêu cầu tạo hóa đơn điện tử
    Then Response Status Code Should Be 400
    And Response Should Have Error "Mẫu hóa đơn đã hết hạn"

RT-INEIV-004 Kiểm tra tạo hóa đơn điện tử thành công với VNPT
    [Documentation]    Kiểm tra cho phép tạo hóa đơn điện tử VNPT khi thông tin hợp lệ
    [Tags]    invoice    validation    einvoice    vnpt    success
    Given Chuẩn bị dữ liệu hóa đơn với kết nối VNPT
    When Gửi yêu cầu tạo hóa đơn điện tử
    Then Response Status Code Should Be 200
    And Response Should Have Id exist

RT-INEIV-005 Kiểm tra tạo hóa đơn điện tử thất bại khi không có thông tin kết nối MISA
    [Documentation]    Kiểm tra không cho phép tạo hóa đơn điện tử MISA khi thiếu token xác thực
    [Tags]    invoice    validation    einvoice    misa    auth
    Given Chuẩn bị dữ liệu hóa đơn MISA với token không hợp lệ
    When Gửi yêu cầu tạo hóa đơn điện tử
    Then Response Status Code Should Be 400
    And Response Should Have Error "Token xác thực MISA không hợp lệ"

RT-INEIV-006 Kiểm tra tạo hóa đơn điện tử thất bại khi mẫu hóa đơn MISA không hợp lệ
    [Documentation]    Kiểm tra không cho phép tạo hóa đơn điện tử MISA khi mẫu hóa đơn không hợp lệ
    [Tags]    invoice    validation    einvoice    misa    template
    Given Chuẩn bị dữ liệu hóa đơn MISA với mẫu số ${invoice_einvoice_validation_misa_invalid_template}
    When Gửi yêu cầu tạo hóa đơn điện tử
    Then Response Status Code Should Be 400
    And Response Should Have Error "Mẫu hóa đơn không hợp lệ"

RT-INEIV-007 Kiểm tra tạo hóa đơn điện tử thất bại khi mẫu hóa đơn MISA hết hạn
    [Documentation]    Kiểm tra không cho phép tạo hóa đơn điện tử MISA khi mẫu hóa đơn đã hết hạn
    [Tags]    invoice    validation    einvoice    misa    expired
    Given Chuẩn bị dữ liệu hóa đơn MISA với mẫu số ${invoice_einvoice_validation_misa_expired_template}
    When Gửi yêu cầu tạo hóa đơn điện tử
    Then Response Status Code Should Be 400
    And Response Should Have Error "Mẫu hóa đơn đã hết hạn"

RT-INEIV-008 Kiểm tra tạo hóa đơn điện tử thành công với MISA
    [Documentation]    Kiểm tra cho phép tạo hóa đơn điện tử MISA khi thông tin hợp lệ
    [Tags]    invoice    validation    einvoice    misa    success
    Given Chuẩn bị dữ liệu hóa đơn với kết nối MISA
    When Gửi yêu cầu tạo hóa đơn điện tử
    Then Response Status Code Should Be 200
    And Response Should Have Id exist

RT-INEIV-009 Kiểm tra tạo hóa đơn điện tử thất bại khi số hóa đơn trùng lặp
    [Documentation]    Kiểm tra không cho phép tạo hóa đơn điện tử khi số hóa đơn đã được sử dụng
    [Tags]    invoice    validation    einvoice    duplicate
    Given Chuẩn bị dữ liệu hóa đơn với kết nối VNPT
    And Chuẩn bị dữ liệu hóa đơn với số hóa đơn ${invoice_einvoice_validation_invoice_no}
    When Gửi yêu cầu tạo hóa đơn điện tử
    Then Response Status Code Should Be 400
    And Response Should Have Error "Số hóa đơn đã tồn tại"

RT-INEIV-010 Kiểm tra xử lý lỗi khi không thể kết nối đến hệ thống hóa đơn điện tử
    [Documentation]    Kiểm tra xử lý lỗi khi không thể kết nối đến hệ thống hóa đơn điện tử
    [Tags]    invoice    validation    einvoice    connection
    Given Chuẩn bị dữ liệu hóa đơn với kết nối VNPT
    When Gửi yêu cầu tạo hóa đơn điện tử
    Then Response Status Code Should Be 500
    And Response Should Have Error ${invoice_einvoice_validation_api_error_message}

RT-INEIV-011 Kiểm tra trạng thái Pending khi hóa đơn điện tử đang được xử lý
    [Documentation]    Kiểm tra trạng thái Pending khi hóa đơn điện tử đang được xử lý
    [Tags]    invoice    validation    einvoice    status    pending
    Given Chuẩn bị dữ liệu hóa đơn với kết nối VNPT
    When Gửi yêu cầu tạo hóa đơn điện tử
    Then Response Status Code Should Be 200
    And Response Should Have EInvoiceStatus With value ${invoice_einvoice_validation_pending_status}

RT-INEIV-012 Kiểm tra trạng thái Success khi hóa đơn điện tử được tạo thành công
    [Documentation]    Kiểm tra trạng thái Success khi hóa đơn điện tử được tạo thành công
    [Tags]    invoice    validation    einvoice    status    success
    Given Chuẩn bị dữ liệu hóa đơn với kết nối VNPT
    When Gửi yêu cầu tạo hóa đơn điện tử
    Then Response Status Code Should Be 200
    And Response Should Have EInvoiceStatus With value ${invoice_einvoice_validation_success_status}

RT-INEIV-013 Kiểm tra trạng thái Failed khi hóa đơn điện tử tạo thất bại
    [Documentation]    Kiểm tra trạng thái Failed khi hóa đơn điện tử tạo thất bại
    [Tags]    invoice    validation    einvoice    status    failed
    Given Chuẩn bị dữ liệu hóa đơn VNPT với tài khoản không hợp lệ
    When Gửi yêu cầu tạo hóa đơn điện tử
    Then Response Status Code Should Be 400
    And Response Should Have EInvoiceStatus With value ${invoice_einvoice_validation_failed_status} 