*** Settings ***
Documentation     Keywords cho test cases API xử lý mã hóa đơn
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../../TestData/Invoice/InvoiceCodeData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           Collections
Library           json

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Hợp Lệ
    # Sao chép sâu STANDARD_INVOICE_REQUEST sử dụng utility function
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    
    # Cập nhật trực tiếp mã hóa đơn
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    ${VALID_INVOICE_CODE}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Facebook
    # Sao chép sâu STANDARD_INVOICE_REQUEST sử dụng utility function
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    
    # Cập nhật trực tiếp mã hóa đơn và kênh bán
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    ${VALID_FACEBOOK_CODE}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.SaleChannelId    ${FACEBOOK_SALE_CHANNEL_ID}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Lazada
    # Sao chép sâu STANDARD_INVOICE_REQUEST sử dụng utility function
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    
    # Cập nhật trực tiếp mã hóa đơn và kênh bán
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    ${VALID_LAZADA_CODE}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.SaleChannelId    ${LAZADA_SALE_CHANNEL_ID}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Tiền Tố Không Hợp Lệ
    # Sao chép sâu STANDARD_INVOICE_REQUEST sử dụng utility function
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    
    # Cập nhật trực tiếp mã hóa đơn 
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    ${INVALID_INVOICE_CODE}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Chứa Ký Tự Đặc Biệt
    # Sao chép sâu STANDARD_INVOICE_REQUEST sử dụng utility function
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    
    # Cập nhật trực tiếp mã hóa đơn 
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    ${INVALID_SPECIAL_CHAR_CODE}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Rỗng
    # Sao chép sâu STANDARD_INVOICE_REQUEST sử dụng utility function
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    
    # Cập nhật trực tiếp mã hóa đơn 
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    ${INVALID_EMPTY_CODE}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Chứa Khoảng Trắng
    # Sao chép sâu STANDARD_INVOICE_REQUEST sử dụng utility function
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    
    # Cập nhật trực tiếp mã hóa đơn 
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    ${INVALID_WHITESPACE_CODE}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Đã Tồn Tại
    # Sao chép sâu STANDARD_INVOICE_REQUEST sử dụng utility function
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    
    # Cập nhật trực tiếp mã hóa đơn 
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    ${INVOICE_DUPLICATED_CODE}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Quá Dài
    # Sao chép sâu STANDARD_INVOICE_REQUEST sử dụng utility function
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    
    # Cập nhật trực tiếp mã hóa đơn 
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    ${INVALID_LONG_CODE}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sinh Mã Tự Động
    # Sao chép sâu STANDARD_INVOICE_REQUEST sử dụng utility function
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    
    # Xóa trường Code để hệ thống sinh mã tự động
    ${request}=    Remove Nested Dictionary Property    ${request}    Invoice.Code
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Theo Phân Quyền
    # Sao chép sâu STANDARD_INVOICE_REQUEST sử dụng utility function
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    
    # Xóa trường Code và thêm trường PermissionPrefix
    ${request}=    Remove Nested Dictionary Property    ${request}    Invoice.Code
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.PermissionPrefix    ${PERMISSION_PREFIX}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

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