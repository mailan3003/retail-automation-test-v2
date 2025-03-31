*** Settings ***
Resource    ../../../Keywords/Utilities/ResponseHelper.robot
Resource    ../../../Keywords/Invoice/InvoiceCodeValidationKeywords.robot
Resource    ../../../TestData/CommonData.robot
Resource    ../../../TestData/Invoice/InvoiceCodeValidationData.robot

*** Test Cases ***
RT-INCV-001 Tạo hóa đơn thành công với mã hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn với mã hóa đơn hợp lệ
    [Tags]    invoice    validation    code
    Given Chuẩn bị dữ liệu hóa đơn với mã HD001
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist

RT-INCV-002 Tạo hóa đơn thất bại khi trùng mã trong cùng RetailerId
    [Documentation]    Kiểm tra không cho phép tạo hóa đơn trùng mã trong cùng RetailerId
    [Tags]    invoice    validation    code    duplicate
    Given Chuẩn bị dữ liệu hóa đơn với mã ${invoice_code_validation_duplicate_code}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 400
    And Response Should Have Error "Mã hóa đơn đã tồn tại"

RT-INCV-003 Tạo hóa đơn thất bại khi trùng UUID trong khoảng 7 ngày
    [Documentation]    Kiểm tra không cho phép tạo hóa đơn trùng UUID trong 7 ngày
    [Tags]    invoice    validation    uuid    duplicate
    Given Chuẩn bị dữ liệu hóa đơn với mã HD002 và UUID ${invoice_code_validation_duplicate_uuid}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 400
    And Response Should Have Error "UUID hóa đơn đã tồn tại"

RT-INCV-004 Tạo hóa đơn thất bại khi độ dài mã vượt quá 50 ký tự
    [Documentation]    Kiểm tra không cho phép tạo hóa đơn với mã dài quá 50 ký tự
    [Tags]    invoice    validation    code    length
    Given Chuẩn bị dữ liệu hóa đơn với mã ${invoice_code_validation_long_code}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 400
    And Response Should Have Error "Mã hóa đơn không được vượt quá 50 ký tự"

RT-INCV-005 Tạo hóa đơn thành công khi mã trùng với hóa đơn đã Void
    [Documentation]    Kiểm tra cho phép tạo hóa đơn với mã đã tồn tại nhưng có trạng thái Void
    [Tags]    invoice    validation    code    void
    Given Chuẩn bị dữ liệu hóa đơn với mã ${invoice_code_validation_void_code}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist

RT-INCV-006 Tạo hóa đơn thành công khi mã trùng với hóa đơn Failed
    [Documentation]    Kiểm tra cho phép tạo hóa đơn với mã đã tồn tại nhưng có trạng thái Failed
    [Tags]    invoice    validation    code    failed
    Given Chuẩn bị dữ liệu hóa đơn với mã ${invoice_code_validation_failed_code}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist

RT-INCV-007 Tạo hóa đơn offline thành công với prefix HDO
    [Documentation]    Kiểm tra tạo hóa đơn offline với prefix HDO
    [Tags]    invoice    validation    prefix    offline
    Given Chuẩn bị dữ liệu hóa đơn offline với mã ${invoice_code_validation_offline_code}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Code With value ${invoice_code_validation_offline_code}

RT-INCV-008 Tạo hóa đơn Shopee thành công với prefix SP
    [Documentation]    Kiểm tra tạo hóa đơn Shopee với prefix SP
    [Tags]    invoice    validation    prefix    shopee
    Given Chuẩn bị dữ liệu hóa đơn kênh bán ${invoice_code_validation_shopee_channel_id} với mã ${invoice_code_validation_shopee_code}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Code With value ${invoice_code_validation_shopee_code}

RT-INCV-009 Tạo hóa đơn Lazada thành công với prefix LD
    [Documentation]    Kiểm tra tạo hóa đơn Lazada với prefix LD
    [Tags]    invoice    validation    prefix    lazada
    Given Chuẩn bị dữ liệu hóa đơn kênh bán ${invoice_code_validation_lazada_channel_id} với mã ${invoice_code_validation_lazada_code}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Code With value ${invoice_code_validation_lazada_code}

RT-INCV-010 Tạo hóa đơn Facebook thành công với prefix FB_
    [Documentation]    Kiểm tra tạo hóa đơn Facebook với prefix FB_
    [Tags]    invoice    validation    prefix    facebook
    Given Chuẩn bị dữ liệu hóa đơn kênh bán ${invoice_code_validation_facebook_channel_id} với mã ${invoice_code_validation_facebook_code}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Code With value ${invoice_code_validation_facebook_code}

RT-INCV-011 Tạo hóa đơn Instagram thành công với prefix IG_
    [Documentation]    Kiểm tra tạo hóa đơn Instagram với prefix IG_
    [Tags]    invoice    validation    prefix    instagram
    Given Chuẩn bị dữ liệu hóa đơn kênh bán ${invoice_code_validation_instagram_channel_id} với mã ${invoice_code_validation_instagram_code}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Code With value ${invoice_code_validation_instagram_code}

RT-INCV-012 Tạo hóa đơn TikTok thành công với prefix TT_
    [Documentation]    Kiểm tra tạo hóa đơn TikTok với prefix TT_
    [Tags]    invoice    validation    prefix    tiktok
    Given Chuẩn bị dữ liệu hóa đơn kênh bán ${invoice_code_validation_tiktok_channel_id} với mã ${invoice_code_validation_tiktok_code}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Code With value ${invoice_code_validation_tiktok_code}

RT-INCV-013 Tạo hóa đơn bảo hành thành công với prefix BH
    [Documentation]    Kiểm tra tạo hóa đơn bảo hành với prefix BH
    [Tags]    invoice    validation    prefix    warranty
    Given Chuẩn bị dữ liệu hóa đơn bảo hành với mã ${invoice_code_validation_warranty_code}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Code With value ${invoice_code_validation_warranty_code}

RT-INCV-014 Tạo hóa đơn clone thành công với prefix C_
    [Documentation]    Kiểm tra tạo hóa đơn clone với prefix C_
    [Tags]    invoice    validation    prefix    clone
    Given Chuẩn bị dữ liệu hóa đơn clone với mã ${invoice_code_validation_clone_code} và mã gốc ${invoice_code_validation_clone_base_code}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Code With value ${invoice_code_validation_clone_code}
    And Response Should Have CompareCode With value ${invoice_code_validation_clone_base_code}

RT-INCV-015 Tạo hóa đơn update thành công với prefix U_
    [Documentation]    Kiểm tra tạo hóa đơn cập nhật với prefix U_
    [Tags]    invoice    validation    prefix    update
    Given Chuẩn bị dữ liệu hóa đơn cập nhật với mã ${invoice_code_validation_update_code} và mã gốc ${invoice_code_validation_clone_base_code}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Code With value ${invoice_code_validation_update_code}
    And Response Should Have CompareCode With value ${invoice_code_validation_clone_base_code}

RT-INCV-016 Tạo hóa đơn thành công với trường IsDuplicated được đánh dấu khi phát hiện mã trùng
    [Documentation]    Kiểm tra đánh dấu IsDuplicated khi phát hiện mã trùng
    [Tags]    invoice    validation    duplicate    flag
    Given Chuẩn bị dữ liệu hóa đơn với mã HDO001
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have IsDuplicated With value true 