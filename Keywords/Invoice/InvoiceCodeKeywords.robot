*** Settings ***
Documentation     Keywords cho test cases API xử lý mã hóa đơn
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/InvoiceCodeData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           Collections

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Hợp Lệ
    ${data}=    Tạo Dữ Liệu Tiêu Chuẩn Cho Test Mã Hóa Đơn
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Facebook
    # Tạo chi tiết hóa đơn
    ${invoice_details}=    Create List    ${STANDARD_INVOICE_DETAILS}
    
    # Tạo bản sao của dữ liệu hóa đơn Facebook để không ảnh hưởng biến gốc
    ${facebook_invoice}=    Copy Dictionary    ${FACEBOOK_INVOICE_DATA}
    
    # Cập nhật chi tiết hóa đơn vào dữ liệu
    Set To Dictionary    ${facebook_invoice}    InvoiceDetails=${invoice_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${facebook_invoice}
    RETURN    ${facebook_invoice}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Lazada
    # Tạo chi tiết hóa đơn
    ${invoice_details}=    Create List    ${STANDARD_INVOICE_DETAILS}
    
    # Tạo bản sao của dữ liệu hóa đơn Lazada để không ảnh hưởng biến gốc
    ${lazada_invoice}=    Copy Dictionary    ${LAZADA_INVOICE_DATA}
    
    # Cập nhật chi tiết hóa đơn vào dữ liệu
    Set To Dictionary    ${lazada_invoice}    InvoiceDetails=${invoice_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${lazada_invoice}
    RETURN    ${lazada_invoice}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Tiền Tố Không Hợp Lệ
    # Tạo chi tiết hóa đơn
    ${invoice_details}=    Create List    ${STANDARD_INVOICE_DETAILS}
    
    # Tạo bản sao của dữ liệu hóa đơn không hợp lệ để không ảnh hưởng biến gốc
    ${invalid_prefix_invoice}=    Copy Dictionary    ${INVALID_PREFIX_INVOICE_DATA}
    
    # Cập nhật chi tiết hóa đơn vào dữ liệu
    Set To Dictionary    ${invalid_prefix_invoice}    InvoiceDetails=${invoice_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${invalid_prefix_invoice}
    RETURN    ${invalid_prefix_invoice}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Chứa Ký Tự Đặc Biệt
    # Tạo chi tiết hóa đơn
    ${invoice_details}=    Create List    ${STANDARD_INVOICE_DETAILS}
    
    # Tạo bản sao của dữ liệu hóa đơn với ký tự đặc biệt để không ảnh hưởng biến gốc
    ${special_char_invoice}=    Copy Dictionary    ${SPECIAL_CHAR_INVOICE_DATA}
    
    # Cập nhật chi tiết hóa đơn vào dữ liệu
    Set To Dictionary    ${special_char_invoice}    InvoiceDetails=${invoice_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${special_char_invoice}
    RETURN    ${special_char_invoice}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Rỗng
    # Tạo chi tiết hóa đơn
    ${invoice_details}=    Create List    ${STANDARD_INVOICE_DETAILS}
    
    # Tạo bản sao của dữ liệu hóa đơn với mã rỗng để không ảnh hưởng biến gốc
    ${empty_code_invoice}=    Copy Dictionary    ${EMPTY_CODE_INVOICE_DATA}
    
    # Cập nhật chi tiết hóa đơn vào dữ liệu
    Set To Dictionary    ${empty_code_invoice}    InvoiceDetails=${invoice_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${empty_code_invoice}
    RETURN    ${empty_code_invoice}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Chứa Khoảng Trắng
    # Tạo chi tiết hóa đơn
    ${invoice_details}=    Create List    ${STANDARD_INVOICE_DETAILS}
    
    # Tạo bản sao của dữ liệu hóa đơn với khoảng trắng để không ảnh hưởng biến gốc
    ${whitespace_code_invoice}=    Copy Dictionary    ${WHITESPACE_CODE_INVOICE_DATA}
    
    # Cập nhật chi tiết hóa đơn vào dữ liệu
    Set To Dictionary    ${whitespace_code_invoice}    InvoiceDetails=${invoice_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${whitespace_code_invoice}
    RETURN    ${whitespace_code_invoice}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Đã Tồn Tại
    # Tạo chi tiết hóa đơn
    ${invoice_details}=    Create List    ${STANDARD_INVOICE_DETAILS}
    
    # Tạo bản sao của dữ liệu hóa đơn với mã đã tồn tại để không ảnh hưởng biến gốc
    ${duplicate_code_invoice}=    Copy Dictionary    ${DUPLICATE_CODE_INVOICE_DATA}
    
    # Cập nhật chi tiết hóa đơn vào dữ liệu
    Set To Dictionary    ${duplicate_code_invoice}    InvoiceDetails=${invoice_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${duplicate_code_invoice}
    RETURN    ${duplicate_code_invoice}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Quá Dài
    # Tạo chi tiết hóa đơn
    ${invoice_details}=    Create List    ${STANDARD_INVOICE_DETAILS}
    
    # Tạo bản sao của dữ liệu hóa đơn với mã dài để không ảnh hưởng biến gốc
    ${long_code_invoice}=    Copy Dictionary    ${LONG_CODE_INVOICE_DATA}
    
    # Cập nhật chi tiết hóa đơn vào dữ liệu
    Set To Dictionary    ${long_code_invoice}    InvoiceDetails=${invoice_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${long_code_invoice}
    RETURN    ${long_code_invoice}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sinh Mã Tự Động
    # Tạo chi tiết hóa đơn
    ${invoice_details}=    Create List    ${STANDARD_INVOICE_DETAILS}
    
    # Tạo bản sao của dữ liệu hóa đơn với mã tự động để không ảnh hưởng biến gốc
    ${auto_code_invoice}=    Copy Dictionary    ${AUTO_CODE_INVOICE_DATA}
    
    # Cập nhật chi tiết hóa đơn vào dữ liệu
    Set To Dictionary    ${auto_code_invoice}    InvoiceDetails=${invoice_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${auto_code_invoice}
    RETURN    ${auto_code_invoice}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Theo Phân Quyền
    # Tạo chi tiết hóa đơn
    ${invoice_details}=    Create List    ${STANDARD_INVOICE_DETAILS}
    
    # Tạo bản sao của dữ liệu hóa đơn với tiền tố phân quyền để không ảnh hưởng biến gốc
    ${permission_code_invoice}=    Copy Dictionary    ${PERMISSION_CODE_INVOICE_DATA}
    
    # Cập nhật chi tiết hóa đơn vào dữ liệu
    Set To Dictionary    ${permission_code_invoice}    InvoiceDetails=${invoice_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${permission_code_invoice}
    RETURN    ${permission_code_invoice}

Gửi Yêu Cầu Tạo Hóa Đơn    
    ${response}=    Call API    invoices    ${REQUEST_DATA} 
    Set Test Variable    ${RESPONSE}     ${response}

# DB Validation Keywords
Xác Thực Hóa Đơn Trong DB
    [Documentation]    Xác thực hóa đơn tồn tại trong CSDL và các thông tin chi tiết
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}
    Xác Thực Hóa Đơn Tồn Tại    ${invoice_id}

Xác Thực Hóa Đơn Tồn Tại
    [Arguments]    ${invoice_id}
    ${query}=    Set Variable    SELECT Id FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL

Xác Thực Mã Hóa Đơn
    [Arguments]    ${invoice_id}    ${expected_code}
    ${query}=    Set Variable    SELECT Code FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    Should Be Equal    ${result[0]}    ${expected_code}    Mã hóa đơn không đúng

Xác Thực Mã Tự Động
    [Arguments]    ${invoice_id}
    ${query}=    Set Variable    SELECT Code FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    Should Not Be Empty    ${result[0]}    Mã hóa đơn không được tạo tự động
    Should Start With    ${result[0]}    ${DEFAULT_INVOICE_PREFIX}    Mã tự động không bắt đầu bằng tiền tố mặc định

Xác Thực Mã Tự Động Theo Phân Quyền
    [Arguments]    ${invoice_id}    ${expected_prefix}
    ${query}=    Set Variable    SELECT Code FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    Should Not Be Empty    ${result[0]}    Mã hóa đơn không được tạo tự động
    Should Start With    ${result[0]}    ${expected_prefix}    Mã tự động không bắt đầu bằng tiền tố theo phân quyền 