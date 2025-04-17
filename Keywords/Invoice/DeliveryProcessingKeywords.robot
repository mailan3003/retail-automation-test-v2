*** Settings ***
Documentation     Keywords cho test cases API xử lý thông tin giao hàng
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot        
Resource          ../../TestData/Invoice/DeliveryProcessingData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Library           ../../Resources/DatabaseLibrary.py

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Cơ Bản
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng cơ bản với thông tin giao hàng tiêu chuẩn
    ${data}=    Set Variable    ${STANDARD_DELIVERY_INVOICE}
    Set To Dictionary    ${data}    DeliveryInfo=${STANDARD_DELIVERY_INFO}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Không SĐT
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng thiếu SĐT người nhận
    ${data}=    Set Variable    ${STANDARD_DELIVERY_INVOICE}
    Set To Dictionary    ${data}    DeliveryInfo=${DELIVERY_INFO_NO_PHONE}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Không Tên
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng không có tên người nhận
    ${data}=    Set Variable    ${STANDARD_DELIVERY_INVOICE}
    Set To Dictionary    ${data}    DeliveryInfo=${DELIVERY_INFO_NO_NAME}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Không Địa Chỉ
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng không có địa chỉ người nhận
    ${data}=    Set Variable    ${STANDARD_DELIVERY_INVOICE}
    Set To Dictionary    ${data}    DeliveryInfo=${DELIVERY_INFO_NO_ADDRESS}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Không Khu Vực
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng không có khu vực
    ${data}=    Set Variable    ${STANDARD_DELIVERY_INVOICE}
    Set To Dictionary    ${data}    DeliveryInfo=${DELIVERY_INFO_NO_LOCATION}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Đối Tác Khác
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng với đối tác giao hàng khác
    ${data}=    Set Variable    ${STANDARD_DELIVERY_INVOICE}
    Set To Dictionary    ${data}    DeliveryInfo=${DELIVERY_INFO_OTHER_PARTNER}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Phí Cao
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng với phí giao hàng cao
    ${data}=    Set Variable    ${STANDARD_DELIVERY_INVOICE}
    Set To Dictionary    ${data}    DeliveryInfo=${DELIVERY_INFO_HIGH_FEE}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Miễn Phí
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng với phí ship miễn phí
    ${data}=    Set Variable    ${STANDARD_DELIVERY_INVOICE}
    Set To Dictionary    ${data}    DeliveryInfo=${DELIVERY_INFO_FREE_SHIPPING}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Với Trạng Thái
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng với trạng thái giao hàng cụ thể
    [Arguments]    ${delivery_info}
    ${data}=    Set Variable    ${DELIVERY_STATUS_INVOICE}
    Set To Dictionary    ${data}    DeliveryInfo=${delivery_info}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Với Ghi Chú
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng có ghi chú
    ${data}=    Set Variable    ${STANDARD_DELIVERY_INVOICE}
    Set To Dictionary    ${data}    DeliveryInfo=${DELIVERY_INFO_WITH_NOTE}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Gửi Yêu Cầu Tạo Hóa Đơn Giao Hàng
    [Documentation]    Gọi API để tạo hóa đơn với thông tin giao hàng
    ${response}=    Call API    invoices    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}

# Validation Keywords
Xác Thực Hóa Đơn Giao Hàng Trong DB
    [Documentation]    Xác thực hóa đơn giao hàng đã được tạo trong CSDL
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}
    
    ${query}=    Set Variable    SELECT Id, UsingCod FROM Invoice WHERE Id = ?
    ${invoice_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${invoice_data}    None    Hóa đơn không tồn tại trong CSDL
    Should Be Equal As Integers    ${invoice_data[1]}    1    Trạng thái UsingCod không được bật

Xác Thực Thông Tin Người Nhận
    [Documentation]    Xác thực thông tin người nhận trong CSDL
    [Arguments]    ${invoice_id}    ${expected_name}    ${expected_phone}
    ${query}=    Set Variable    SELECT ReceiverName, ReceiverPhone FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Thông tin giao hàng không tồn tại trong CSDL
    Should Be Equal    ${delivery_data[0]}    ${expected_name}    Tên người nhận không khớp
    Should Be Equal    ${delivery_data[1]}    ${expected_phone}    Số điện thoại người nhận không khớp

Xác Thực Địa Chỉ Giao Hàng
    [Documentation]    Xác thực địa chỉ giao hàng trong CSDL
    [Arguments]    ${invoice_id}    ${expected_address}
    ${query}=    Set Variable    SELECT ReceiverAddress FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Thông tin giao hàng không tồn tại trong CSDL
    Should Be Equal    ${delivery_data[0]}    ${expected_address}    Địa chỉ giao hàng không khớp

Xác Thực Khu Vực Giao Hàng
    [Documentation]    Xác thực khu vực giao hàng trong CSDL
    [Arguments]    ${invoice_id}    ${expected_location_id}    ${expected_ward_id}
    ${query}=    Set Variable    SELECT LocationId, WardId FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Thông tin giao hàng không tồn tại trong CSDL
    Should Be Equal As Integers    ${delivery_data[0]}    ${expected_location_id}    Mã khu vực không khớp
    Should Be Equal As Integers    ${delivery_data[1]}    ${expected_ward_id}    Mã phường/xã không khớp

Xác Thực Đối Tác Giao Hàng
    [Documentation]    Xác thực đối tác giao hàng trong CSDL
    [Arguments]    ${invoice_id}    ${expected_partner_id}
    ${query}=    Set Variable    SELECT DeliveryBy, PartnerId FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Thông tin giao hàng không tồn tại trong CSDL
    Should Be Equal As Integers    ${delivery_data[0]}    2    Phương thức giao hàng không khớp
    Should Be Equal As Integers    ${delivery_data[1]}    ${expected_partner_id}    Mã đối tác không khớp

Xác Thực Sử Dụng Đối Tác Mặc Định
    [Documentation]    Xác thực sử dụng đối tác giao hàng mặc định trong CSDL
    [Arguments]    ${invoice_id}    ${expected_default_partner}
    ${query}=    Set Variable    SELECT DeliveryBy, UseDefaultPartner FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Thông tin giao hàng không tồn tại trong CSDL
    Should Be Equal As Integers    ${delivery_data[0]}    1    Phương thức giao hàng không khớp
    Should Be Equal As Integers    ${delivery_data[1]}    ${expected_default_partner}    Trạng thái sử dụng đối tác mặc định không khớp

Xác Thực Phí Giao Hàng
    [Documentation]    Xác thực phí giao hàng trong CSDL
    [Arguments]    ${invoice_id}    ${expected_fee}
    ${query}=    Set Variable    SELECT ShippingFee FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Thông tin giao hàng không tồn tại trong CSDL
    Should Be Equal As Numbers    ${delivery_data[0]}    ${expected_fee}    Phí giao hàng không khớp

Xác Thực Miễn Phí Giao Hàng
    [Documentation]    Xác thực trạng thái miễn phí giao hàng trong CSDL
    [Arguments]    ${invoice_id}    ${expected_is_free}
    ${query}=    Set Variable    SELECT ShippingFee, IsFreeShip FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Thông tin giao hàng không tồn tại trong CSDL
    Should Be Equal As Numbers    ${delivery_data[0]}    0    Phí giao hàng không phải là 0
    Should Be Equal As Integers    ${delivery_data[1]}    ${expected_is_free}    Trạng thái miễn phí giao hàng không khớp

Xác Thực Trạng Thái Giao Hàng
    [Documentation]    Xác thực trạng thái giao hàng trong CSDL
    [Arguments]    ${invoice_id}    ${expected_status}
    ${query}=    Set Variable    SELECT Status FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Thông tin giao hàng không tồn tại trong CSDL
    Should Be Equal As Integers    ${delivery_data[0]}    ${expected_status}    Trạng thái giao hàng không khớp

Xác Thực Ghi Chú Giao Hàng
    [Documentation]    Xác thực ghi chú giao hàng trong CSDL
    [Arguments]    ${invoice_id}    ${expected_note}
    ${query}=    Set Variable    SELECT Note FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Thông tin giao hàng không tồn tại trong CSDL
    Should Be Equal    ${delivery_data[0]}    ${expected_note}    Ghi chú giao hàng không khớp 