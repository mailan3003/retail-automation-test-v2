*** Settings ***
Resource    ../../../Keywords/Utilities/ResponseHelper.robot
Resource    ../../../Keywords/Utilities/RequestHelper.robot
Resource    ../../../TestData/CommonData.robot
Resource    ../../../TestData/Invoice/InvoiceData.robot
Resource    ../../../Keywords/Invoice/InvoiceValidationKeywords.robot

*** Test Cases ***
RT-IN-001 Tạo hóa đơn thành công với mã hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn với mã hợp lệ
    [Tags]    invoice    validation    create    
    Given Chuẩn bị dữ liệu tạo hóa đơn hợp lệ
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist

RT-IN-002 Tạo hóa đơn thất bại khi trùng mã trong 7 ngày
    [Documentation]    Kiểm tra validate mã hóa đơn trùng trong khoảng 7 ngày
    [Tags]    invoice    validation    duplicate
    Given Chuẩn bị dữ liệu hóa đơn với mã ${INVOICE_DUPLICATED_CODE}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Mã hóa đơn đã tồn tại"

RT-IN-003 Tạo hóa đơn thất bại khi độ dài mã vượt quá 50 ký tự
    [Documentation]    Kiểm tra validate độ dài mã hóa đơn
    [Tags]    invoice    validation    length
    Given Chuẩn bị dữ liệu hóa đơn với mã ${INVOICE_LONG_CODE}
    When Gửi yêu cầu tạo hóa đơn  
    Then Response Status Code Should Be 420
    And Response Should Have Error "Mã hóa đơn không được vượt quá 50 ký tự"

RT-IN-004 Tạo hóa đơn offline thành công với prefix HDO
    [Documentation]    Kiểm tra tạo hóa đơn offline với prefix HDO
    [Tags]    invoice    validation    prefix    offline
    Given Chuẩn bị dữ liệu hóa đơn offline với mã HDO001  
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Code With value HDO001

RT-IN-005 Tạo hóa đơn Shopee thành công với prefix SP
    [Documentation]    Kiểm tra tạo hóa đơn Shopee với prefix SP
    [Tags]    invoice    validation    prefix    shopee
    Given Chuẩn bị dữ liệu hóa đơn Shopee với mã SP001
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200  
    And Response Should Have Code With value SP001

RT-IN-006 Tạo hóa đơn Lazada thành công với prefix LD 
    [Documentation]    Kiểm tra tạo hóa đơn Lazada với prefix LD
    [Tags]    invoice    validation    prefix    lazada
    Given Chuẩn bị dữ liệu hóa đơn Lazada với mã LD001
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Code With value LD001

RT-IN-007 Tạo hóa đơn Facebook thành công với prefix FB_
    [Documentation]    Kiểm tra tạo hóa đơn Facebook với prefix FB_
    [Tags]    invoice    validation    prefix    facebook
    Given Chuẩn bị dữ liệu hóa đơn Facebook với mã FB_001
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Code With value FB_001

RT-IN-008 Tạo hóa đơn Instagram thành công với prefix IG_
    [Documentation]    Kiểm tra tạo hóa đơn Instagram với prefix IG_
    [Tags]    invoice    validation    prefix    instagram  
    Given Chuẩn bị dữ liệu hóa đơn Instagram với mã IG_001
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Code With value IG_001

RT-IN-009 Tạo hóa đơn TikTok thành công với prefix TT_
    [Documentation]    Kiểm tra tạo hóa đơn TikTok với prefix TT_
    [Tags]    invoice    validation    prefix    tiktok
    Given Chuẩn bị dữ liệu hóa đơn TikTok với mã TT_001
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Code With value TT_001

RT-IN-010 Tạo hóa đơn thành công khi mã trùng với hóa đơn đã Void
    [Documentation]    Kiểm tra cho phép tạo hóa đơn khi trùng mã với hóa đơn đã hủy
    [Tags]    invoice    validation    duplicate    void
    Given Chuẩn bị dữ liệu hóa đơn với mã ${INVOICE_VOID_CODE}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Code With value ${INVOICE_VOID_CODE}

RT-IN-011 Tạo hóa đơn thành công khi mã trùng với hóa đơn Failed
    [Documentation]    Kiểm tra cho phép tạo hóa đơn khi trùng mã với hóa đơn thất bại
    [Tags]    invoice    validation    duplicate    failed
    Given Chuẩn bị dữ liệu hóa đơn với mã ${INVOICE_FAILED_CODE}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Code With value ${INVOICE_FAILED_CODE}

RT-IN-012 Tạo hóa đơn thành công khi mã trùng ngoài khoảng 7 ngày trước
    [Documentation]    Kiểm tra cho phép tạo hóa đơn khi trùng mã với hóa đơn cũ hơn 7 ngày
    [Tags]    invoice    validation    duplicate    date_range
    Given Chuẩn bị dữ liệu hóa đơn với mã ${INVOICE_PAST_7_DAYS_CODE}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Code With value ${INVOICE_PAST_7_DAYS_CODE}

RT-IN-013 Tạo hóa đơn thành công khi mã trùng ngoài khoảng 7 ngày sau
    [Documentation]    Kiểm tra cho phép tạo hóa đơn khi trùng mã với hóa đơn tương lai hơn 7 ngày
    [Tags]    invoice    validation    duplicate    date_range
    Given Chuẩn bị dữ liệu hóa đơn với mã ${INVOICE_FUTURE_7_DAYS_CODE}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Code With value ${INVOICE_FUTURE_7_DAYS_CODE}

RT-IN-014 Tạo hóa đơn thất bại khi trùng UUID trong 7 ngày
    [Documentation]    Kiểm tra không cho phép tạo hóa đơn khi trùng UUID trong khoảng 7 ngày
    [Tags]    invoice    validation    duplicate    uuid
    Given Chuẩn bị dữ liệu hóa đơn offline có UUID trùng
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "UUID hóa đơn đã tồn tại"
