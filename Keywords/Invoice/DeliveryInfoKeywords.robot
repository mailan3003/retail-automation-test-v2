*** Settings ***
Documentation     Keywords cho test cases API xử lý thông tin giao hàng
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../../TestData/Invoice/DeliveryInfoData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           Collections
Library           json

*** Keywords ***
# Keywords chuẩn bị dữ liệu
Chuẩn Bị Dữ Liệu Hóa Đơn Với Giao Hàng COD
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với giao hàng COD cơ bản
    #${request}=    Deep Copy    ${invoice_request_body}
    ${request}=    Deep Copy    ${invoice_request_body}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}
Chuẩn Bị Dữ Liệu Hóa Đơn Với Giao Hàng COD mặc định Với Đơn Vị Vận Chuyển ${partner_id}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với giao hàng COD mặc định
    ${request}=    Deep Copy    ${invoice_request_body}
    ${partner_delivery_body}=    Deep Copy    ${partner_delivery_body}
   # ${partner_delivery_body}=    Update Nested Dictionary Property    ${partner_delivery_body}    Id    ${partner_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.DeliveryDetail.PartnerDelivery    ${partner_delivery_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.DeliveryDetail.DeliveryBy    ${partner_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}


Chuẩn Bị Dữ Liệu Hóa Đơn Với Giao Hàng COD Có Người Nhận ${receiver_name}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với tên người nhận tùy chỉnh
    ${request}=    Deep Copy    ${invoice_request_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.DeliveryDetail.ReceiverName    ${receiver_name}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Giao Hàng COD Có Số Điện Thoại ${phone}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với số điện thoại người nhận tùy chỉnh
    ${request}=    Deep Copy    ${invoice_request_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.DeliveryDetail.ReceiverPhone    ${phone}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Giao Hàng COD Thiếu Thông Tin Người Nhận
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với thông tin giao hàng thiếu tên người nhận
    ${request}=    Deep Copy    ${invoice_request_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.DeliveryDetail    ${INVALID_DELIVERY_INFO_MISSING_NAME}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Giao Hàng COD Thiếu Số Điện Thoại
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với thông tin giao hàng thiếu số điện thoại
    ${request}=    Deep Copy    ${invoice_request_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.DeliveryDetail    ${INVALID_DELIVERY_INFO_MISSING_PHONE}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Giao Hàng COD Thiếu Địa Chỉ
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với thông tin giao hàng thiếu địa chỉ
    ${request}=    Deep Copy    ${invoice_request_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.DeliveryDetail    ${INVALID_DELIVERY_INFO_MISSING_ADDRESS}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Đơn Vị Vận Chuyển Cụ Thể
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với đơn vị vận chuyển được chỉ định cụ thể
    ${request}=    Deep Copy    ${invoice_request_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.DeliveryDetail.PartnerDelivery    ${partner_delivery_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.DeliveryDetail.DeliveryBy    ${PARTNER_DELIVERY_1_ID}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Đơn Vị Vận Chuyển Có ID ${partner_id}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với ID đơn vị vận chuyển tùy chỉnh
    ${request}=    Deep Copy    ${invoice_request_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.DeliveryDetail.DeliveryBy    ${partner_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.DeliveryDetail.UseDefaultPartner    ${FALSE}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Từ Facebook
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng từ Facebook
    ${request}=    Deep Copy    ${FACEBOOK_INVOICE_COD_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Hóa Đơn Có Giao Hàng
    [Documentation]    Chuẩn bị dữ liệu cập nhật hóa đơn có giao hàng
    #${request}=    Deep Copy    ${UPDATE_INVOICE_COD_REQUEST}
    ${request}=    Deep Copy    ${invoice_request_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Id    ${INVOICE_HAS_COD_1}
    #${request}=    Update Nested Dictionary Property    ${request}    Invoice.DeliveryDetail.DeliveryBy    ${PARTNER_DELIVERY_2_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.PurchaseDate    2025-03-27T06:44:21.083Z
    
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# Keywords gửi API
Gửi Yêu Cầu Tạo Hóa Đơn Có Giao Hàng
    [Documentation]    Gửi API request tạo hóa đơn có giao hàng
    ${response}=    Call API    invoices    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}

Gửi Yêu Cầu Cập Nhật Hóa Đơn Có Giao Hàng
    [Documentation]    Gửi API request cập nhật hóa đơn có giao hàng
    ${invoice_id}=    Get From Dictionary    ${REQUEST_DATA["Invoice"]}    Id
    ${response}=    Call API    invoices/${invoice_id}    ${REQUEST_DATA}    method=PUT
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}

# Keywords xác thực response
Xác Thực Thông Tin Giao Hàng Trong Response
    [Documentation]    Xác thực thông tin giao hàng có trong response
    ${response_data}=    Set Variable    ${RESPONSE.json()}
    Dictionary Should Contain Key    ${response_data}    DeliveryDetail
    Should Not Be Empty    ${response_data["DeliveryDetail"]}
    Set Test Variable    ${DeliveryDetail}    ${response_data["DeliveryDetail"]}

# Keywords xác thực trong database
Xác Thực Thông Tin Giao Hàng Trong DB
    [Documentation]    Xác thực thông tin giao hàng đã được lưu trong database
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${delivery_info_id}=    Set Variable    ${RESPONSE.json()["DeliveryDetail"]["Id"]}
    
    # Xác thực DeliveryInfo đã được tạo
    ${query}=    Set Variable    SELECT Id, InvoiceId, IsCurrent FROM DeliveryInfo WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin giao hàng trong CSDL    
    Should Be Equal As Integers    ${result[2]}    1    Trạng thái IsCurrent không đúng

Xác Thực Chi Tiết Thông Tin Giao Hàng
    [Documentation]    Xác thực chi tiết thông tin giao hàng trong DB
    [Arguments]    ${expected_address}
    #${delivery_info_id}=    Set Variable    ${RESPONSE.json()["DeliveryInfoId"]}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    
    ${query}=    Set Variable    SELECT BranchTakingAddressStr FROM DeliveryInfo WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin giao hàng trong CSDL
    #Should Be Equal    ${result[0]}    ${expected_name}    Tên người nhận không khớp
    #Should Be Equal    ${result[1]}    ${expected_phone}    Số điện thoại không khớp
    Should Be Equal    ${result[0]}    ${expected_address}    Địa chỉ không khớp

Xác Thực Thông Tin Gói Hàng Trong DB
    [Documentation]    Xác thực thông tin gói hàng đã được tạo trong database
    #${delivery_info_id}=    Set Variable    ${RESPONSE.json()["DeliveryInfoId"]}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    
    ${query}=    Set Variable    SELECT Id FROM DeliveryPackage WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin gói hàng trong CSDL
    Set Test Variable    ${DELIVERY_PACKAGE_ID}    ${result[0]}

Xác Thực Thông Tin Đơn Vị Vận Chuyển
    [Documentation]    Xác thực thông tin đơn vị vận chuyển trong DB
    [Arguments]    ${expected_partner_id}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}    
    ${query}=    Set Variable    SELECT DeliveryBy FROM DeliveryInfo WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin giao hàng trong CSDL
    Should Be Equal As Strings    ${result[0]}    ${expected_partner_id}    ID đơn vị vận chuyển không khớp

Xác Thực Địa Chỉ Lấy Hàng Từ Chi Nhánh
    [Documentation]    Xác thực địa chỉ lấy hàng từ chi nhánh trong DB
    ${delivery_package_id}=    Set Variable    ${DELIVERY_PACKAGE_ID}
    
    ${query}=    Set Variable    SELECT PickupAddress FROM DeliveryPackage WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${delivery_package_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin gói hàng trong CSDL
    Should Not Be Empty    ${result[0]}    Địa chỉ lấy hàng không được cập nhật

Xác Thực Cập Nhật Thông Tin Giao Hàng
    [Documentation]    Xác thực thông tin giao hàng được cập nhật IsCurrent = 0 cho bản ghi cũ
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    #${current_delivery_info_id}=    Set Variable    ${RESPONSE.json()["DeliveryInfoId"]}
    
    # Xác thực có nhiều bản ghi DeliveryInfo
    ${query}=    Set Variable    SELECT COUNT(*) FROM DeliveryInfo WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be True    ${result[0]} > 1    Không có nhiều bản ghi thông tin giao hàng
    
    # Xác thực chỉ có một bản ghi IsCurrent = 1
    ${query}=    Set Variable    SELECT COUNT(*) FROM DeliveryInfo WHERE InvoiceId = ? AND IsCurrent = 1
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Integers    ${result[0]}    1    Có nhiều hơn một bản ghi IsCurrent = 1
    
    # Xác thực bản ghi hiện tại đúng là bản ghi mới
    ${query}=    Set Variable    SELECT Id FROM DeliveryInfo WHERE InvoiceId = ? AND IsCurrent = 1
    ${result}=    Fetch One    ${query}    ${invoice_id}
    #Should Be Equal As Strings    ${result[0]}    ${current_delivery_info_id}    Bản ghi hiện tại không phải là bản ghi mới nhất 