*** Settings ***
Documentation     Keywords cho test cases API cập nhật thông tin giao hàng
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../../TestData/Invoice/DeliveryUpdateData.robot
Resource          DeliveryProcessingKeywords.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/DataUtilities.robot
Resource          ../Utilities/Utilities.robot
Library           ../../Resources/DatabaseLibrary.py

*** Keywords ***
# Keywords chuẩn bị dữ liệu
Chuẩn Bị Dữ Liệu Hóa Đơn Để Cập Nhật Giao Hàng
    [Documentation]    Chuẩn bị dữ liệu cập nhật giao hàng cơ bản
    Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Cơ Bản
    Gửi Yêu Cầu Tạo Hóa Đơn
    ${invoice_id}    Set Variable    ${RESPONSE.json()["Id"]}
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}

Chuẩn Bị Dữ Liệu Hóa Đơn Cơ Bản 
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật 
    Chuẩn Bị Dữ Liệu Hóa Đơn Cơ Bản 
    Gửi Yêu Cầu Tạo Hóa Đơn
    ${invoice_id}    Set Variable    ${RESPONSE.json()["Id"]}
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}

Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật Có Thanh Toán
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data}=    Deep Copy    ${payment_body} 
    ${data}=    Update Nested Dictionary Property    ${data}    Amount   5000
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.Payments    ${data}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Gửi Yêu Cầu Tạo Hóa Đơn
    ${invoice_id}    Set Variable    ${RESPONSE.json()["Id"]}
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}


Chuẩn Bị Dữ Liệu Cập Nhật Kênh Bán ${channel_id}
    ${invoice_data}=    Thông tin hóa đơn được cập nhật  
    ${purchase_date}=    Convert Date    ${invoice_data[2]}    
    ${request_body}    Deep Copy    ${invoice_body_update} 
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Id     ${INVOICE_ID}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    PurchaseDate    ${purchase_date}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    ChannelId    ${channel_id}
     ${request}=    Deep Copy    ${invoice_request_body_update}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Người Bán ${seller_id}
    ${invoice_data}=    Thông tin hóa đơn được cập nhật  
    ${purchase_date}=    Convert Date    ${invoice_data[2]}    
    ${request_body}    Deep Copy    ${invoice_body_update} 
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Id     ${INVOICE_ID}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    PurchaseDate    ${purchase_date}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    SoldById    ${seller_id}
    ${request}=    Deep Copy    ${invoice_request_body_update}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Thời Gian ${status} ${time_delta} Ngày
    ${invoice_data}=    Thông tin hóa đơn được cập nhật  
    ${current_date}=    Convert Date    ${invoice_data[2]}   
    ${purchase_date}  Run Keyword If  "${status}" == "Thêm"    Add Time To Date    ${current_date}    ${time_delta} days
    ${purchase_date}  Run Keyword If  "${status}" == "Trừ"    Subtract Time From Date    ${current_date}    ${time_delta} days
    ${request_body}    Deep Copy    ${invoice_body_update} 
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Id     ${INVOICE_ID}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    PurchaseDate    ${purchase_date}
    ${request}=    Deep Copy    ${invoice_request_body_update}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_body}
    Set Test Variable    ${PURCHASE_DATE}    ${purchase_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}
 
Chuẩn Bị Dữ Liệu Cập Nhật Thời Gian ${n} Ngày ${status} Thay Đổi Phiếu Thanh Toán
    ${invoice_data}=    Thông tin hóa đơn được cập nhật  
    ${current_date}=    Convert Date    ${invoice_data[2]}       
    ${purchase_date}    Subtract Time From Date   ${current_date}    ${n} days
    ${status}    Set Variable If    "${status}" == "Có"    true    false
    ${request_body}    Deep Copy    ${invoice_body_update} 
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Id     ${INVOICE_ID}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    PurchaseDate    ${purchase_date}
    ${request}=    Deep Copy    ${invoice_request_body_update}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_body}
    ${request}=    Update Nested Dictionary Property    ${request}    IsUpdatePayment    ${status}
    Set Test Variable    ${PURCHASE_DATE}    ${purchase_date}
    Set Test Variable    ${CURRENT_DATE_PAYMENT}    ${current_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}


    

Chuẩn Bị Dữ Liệu Cập Nhật Ghi Chú ${n} Kí Tự
    ${invoice_data}=    Thông tin hóa đơn được cập nhật  
    ${purchase_date}=    Convert Date    ${invoice_data[2]}       
    ${note}=    Generate Random String    ${n}    [LOWER]
    ${request_body}    Deep Copy     ${invoice_body_update} 
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Id     ${INVOICE_ID}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    PurchaseDate    ${purchase_date}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Description    ${note}
    ${request}=    Deep Copy    ${invoice_request_body_update}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_body}
    Set Test Variable    ${NOTE}    ${note}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Gửi Yêu Cầu Cập Nhật Hóa Đơn Từ MHQL
    ${response}=    Call API Man    invoices    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    ${invoice_id}=    Set Variable If    ${RESPONSE.status_code} == 200    ${RESPONSE.json()["Id"]}    0
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}

Chuẩn Bị Dữ Liệu Cập Nhật Người Nhận
    [Documentation]    Chuẩn bị dữ liệu cập nhật thông tin người nhận
    Set To Dictionary    ${data}    DeliveryInfo=${UPDATED_RECEIVER_INFO}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Cập Nhật Phí Giao Hàng ${fee}
    [Documentation]    Chuẩn bị dữ liệu cập nhật phí giao hàng
    ${request}=    Deep Copy    ${invoice_request_body}
    ${delivery_detail_body}=    Deep Copy    ${delivery_detail_body}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    Price    ${fee}
    ${request}=    Update Nested Dictionary Property    ${request}    DeliveryDetail    ${delivery_detail_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.UpdateInvoiceId    ${INVOICE_ID}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Miễn Phí Giao Hàng
    [Documentation]    Chuẩn bị dữ liệu cập nhật miễn phí giao hàng
    ${data}=    Set Variable    ${STANDARD_DELIVERY_UPDATE}
    Set To Dictionary    ${data}    DeliveryInfo=${UPDATED_FREE_SHIPPING}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Cập Nhật Trạng Thái Giao Hàng
    [Documentation]    Chuẩn bị dữ liệu cập nhật trạng thái giao hàng
    [Arguments]    ${status_data}
    ${data}=    Set Variable    ${STANDARD_DELIVERY_UPDATE}
    Set To Dictionary    ${data}    DeliveryInfo=${status_data}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Cập Nhật Mã Vận Đơn
    [Documentation]    Chuẩn bị dữ liệu cập nhật mã vận đơn
    ${data}=    Set Variable    ${STANDARD_DELIVERY_UPDATE}
    Set To Dictionary    ${data}    DeliveryInfo=${UPDATED_TRACKING_CODE}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Cập Nhật Đối Tác Giao Hàng
    [Documentation]    Chuẩn bị dữ liệu cập nhật đối tác giao hàng
    ${data}=    Set Variable    ${STANDARD_DELIVERY_UPDATE}
    Set To Dictionary    ${data}    DeliveryInfo=${UPDATED_DELIVERY_PARTNER}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Cập Nhật Giao Một Phần
    [Documentation]    Chuẩn bị dữ liệu cập nhật giao hàng một phần
    ${data}=    Set Variable    ${STANDARD_DELIVERY_UPDATE}
    Set To Dictionary    ${data}    DeliveryInfo=${PARTIAL_DELIVERY_INFO}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Cập Nhật Ngày Giao Dự Kiến
    [Documentation]    Chuẩn bị dữ liệu cập nhật ngày giao dự kiến
    ${data}=    Set Variable    ${STANDARD_DELIVERY_UPDATE}
    Set To Dictionary    ${data}    DeliveryInfo=${EXPECTED_DELIVERY_DATE}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Cập Nhật Với Hóa Đơn Không Tồn Tại
    [Documentation]    Chuẩn bị dữ liệu cập nhật vận chuyển với hóa đơn không tồn tại
    ${data}=    Set Variable    ${NONEXISTENT_INVOICE_UPDATE}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Cập Nhật Với Trạng Thái Không Hợp Lệ
    [Documentation]    Chuẩn bị dữ liệu cập nhật với trạng thái không hợp lệ
    ${data}=    Set Variable    ${INVALID_STATUS_UPDATE}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}


# Keywords xác thực kết quả
Xác Thực Cập Nhật Giao Hàng Trong DB
    [Documentation]    Xác thực thông tin cập nhật giao hàng được lưu trong CSDL
    [Arguments]    ${invoice_id}
    ${query}=    Set Variable    SELECT Id FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Không tìm thấy thông tin giao hàng cho hóa đơn ${invoice_id}
    Set Test Variable    ${DELIVERY_ID}    ${delivery_data[0]}



Xác Thực Cập Nhật Thông Tin Người Nhận
    [Documentation]    Xác thực thông tin người nhận đã được cập nhật
    [Arguments]    ${invoice_id}    ${expected_name}    ${expected_phone}    ${expected_address}
    ${query}=    Set Variable    SELECT ReceiverName, ReceiverPhone, ReceiverAddress FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Không tìm thấy thông tin giao hàng cho hóa đơn ${invoice_id}
    Should Be Equal    ${delivery_data[0]}    ${expected_name}    Tên người nhận không khớp
    Should Be Equal    ${delivery_data[1]}    ${expected_phone}    Số điện thoại người nhận không khớp
    Should Be Equal    ${delivery_data[2]}    ${expected_address}    Địa chỉ người nhận không khớp

Xác Thực Cập Nhật Phí Giao Hàng
    [Documentation]    Xác thực phí giao hàng đã được cập nhật
    [Arguments]    ${invoice_id}    ${expected_fee}
    ${query}=    Set Variable    SELECT ShippingFee FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Không tìm thấy thông tin giao hàng cho hóa đơn ${invoice_id}
    Should Be Equal As Numbers    ${delivery_data[0]}    ${expected_fee}    Phí giao hàng không khớp

Xác Thực Cập Nhật Miễn Phí Giao Hàng
    [Documentation]    Xác thực trạng thái miễn phí giao hàng đã được cập nhật
    [Arguments]    ${invoice_id}    ${expected_is_free}
    ${query}=    Set Variable    SELECT ShippingFee, IsFreeShip FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Không tìm thấy thông tin giao hàng cho hóa đơn ${invoice_id}
    Should Be Equal As Numbers    ${delivery_data[0]}    0    Phí giao hàng không phải là 0
    Should Be Equal As Integers    ${delivery_data[1]}    ${expected_is_free}    Trạng thái miễn phí giao hàng không khớp

Xác Thực Cập Nhật Trạng Thái Giao Hàng
    [Documentation]    Xác thực trạng thái giao hàng đã được cập nhật
    [Arguments]    ${invoice_id}    ${expected_status}
    ${query}=    Set Variable    SELECT Status FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Không tìm thấy thông tin giao hàng cho hóa đơn ${invoice_id}
    Should Be Equal As Integers    ${delivery_data[0]}    ${expected_status}    Trạng thái giao hàng không khớp

Xác Thực Cập Nhật Mã Vận Đơn
    [Documentation]    Xác thực mã vận đơn đã được cập nhật
    [Arguments]    ${invoice_id}    ${expected_tracking_code}
    ${query}=    Set Variable    SELECT TrackingCode FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Không tìm thấy thông tin giao hàng cho hóa đơn ${invoice_id}
    Should Be Equal    ${delivery_data[0]}    ${expected_tracking_code}    Mã vận đơn không khớp

Xác Thực Cập Nhật Đối Tác Giao Hàng
    [Documentation]    Xác thực đối tác giao hàng đã được cập nhật
    [Arguments]    ${invoice_id}    ${expected_delivery_by}    ${expected_partner_id}
    ${query}=    Set Variable    SELECT DeliveryBy, PartnerId FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Không tìm thấy thông tin giao hàng cho hóa đơn ${invoice_id}
    Should Be Equal As Integers    ${delivery_data[0]}    ${expected_delivery_by}    Phương thức giao hàng không khớp
    Should Be Equal As Integers    ${delivery_data[1]}    ${expected_partner_id}    Mã đối tác không khớp

Xác Thực Cập Nhật Giao Một Phần
    [Documentation]    Xác thực thông tin giao hàng một phần đã được cập nhật
    [Arguments]    ${invoice_id}    ${expected_is_partial}    ${expected_amount}
    ${query}=    Set Variable    SELECT IsPartialDelivery, PartialDeliveryAmount FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Không tìm thấy thông tin giao hàng cho hóa đơn ${invoice_id}
    Should Be Equal As Integers    ${delivery_data[0]}    ${expected_is_partial}    Trạng thái giao một phần không khớp
    Should Be Equal As Numbers    ${delivery_data[1]}    ${expected_amount}    Số tiền giao một phần không khớp

Xác Thực Cập Nhật Ngày Giao Dự Kiến
    [Documentation]    Xác thực ngày giao dự kiến đã được cập nhật
    [Arguments]    ${invoice_id}    ${expected_date}
    ${query}=    Set Variable    SELECT ExpectedDeliveryDate FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Không tìm thấy thông tin giao hàng cho hóa đơn ${invoice_id}
    Should Be Equal    ${delivery_data[0]}    ${expected_date}    Ngày giao dự kiến không khớp

Xác Thực Ghi Chú Giao Hàng
    [Documentation]    Xác thực ghi chú giao hàng đã được cập nhật
    [Arguments]    ${invoice_id}    ${expected_note}
    ${query}=    Set Variable    SELECT Note FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Không tìm thấy thông tin giao hàng cho hóa đơn ${invoice_id}
    Should Be Equal    ${delivery_data[0]}    ${expected_note}    Ghi chú giao hàng không khớp

Thông tin hóa đơn được cập nhật
    [Documentation]    Xác thực thông tin hóa đơn đã được cập nhật
    ${query}=    Set Variable    SELECT Id, SoldById, PurchaseDate FROM Invoice WHERE Id = ?
    ${invoice_data}=    Fetch One    ${query}    ${INVOICE_ID}
    RETURN    ${invoice_data}

Người Bán Được Cập Nhật Thành ${expected_seller_id}
    [Documentation]    Xác thực người bán đã được cập nhật
    ${query}=    Set Variable    SELECT SoldById FROM Invoice WHERE Id = ?
    ${invoice_data}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${invoice_data}    None    Không tìm thấy thông tin hóa đơn ${INVOICE_ID}
    Should Be Equal As Integers    ${invoice_data[0]}    ${expected_seller_id}    Người bán không khớp

Kênh Bán Được Cập Nhật Thành ${expected_channel_id}
    [Documentation]    Xác thực kênh bán đã được cập nhật
    ${query}=    Set Variable    SELECT SaleChannelId FROM Invoice WHERE Id = ?
    ${invoice_data}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${invoice_data}    None    Không tìm thấy thông tin hóa đơn ${INVOICE_ID}
    Should Be Equal As Integers    ${invoice_data[0]}    ${expected_channel_id}    Kênh bán không khớp

Thời Gian Được Cập Nhật Thành ${expected_purchase_date}
    [Documentation]    Xác thực thời gian đã được cập nhật
    ${query}=    Set Variable    SELECT PurchaseDate FROM Invoice WHERE Id = ?
    ${invoice_data}=    Fetch One    ${query}    ${INVOICE_ID}
    ${purchase_date}=    Convert Date    ${invoice_data[0]}
    Should Not Be Equal    ${invoice_data}    None    Không tìm thấy thông tin hóa đơn ${INVOICE_ID}
    Should Be Equal   ${purchase_date}  ${expected_purchase_date}   Thời gian không khớp
Thời Gian Phiếu Thanh Toán ${expected_payment_date}
    [Documentation]    Xác thực thời gian phiếu thanh toán đã được cập nhật
    ${query}=    Set Variable    SELECT TransDate FROM Payment WHERE InvoiceId = ?
    ${invoice_data}=    Fetch One    ${query}    ${INVOICE_ID}
    ${payment_date}=    Convert Date    ${invoice_data[0]}
    Should Not Be Equal    ${invoice_data}    None    Không tìm thấy thông tin hóa đơn ${INVOICE_ID}
    ${actual_date_str}=    Convert To String   ${payment_date}
    ${actual_date_str}=    Fetch From Left    ${actual_date_str}    .
    ${expected_date_obj}=    Convert Date    ${expected_payment_date}
    ${actual_date_obj}=    Convert Date    ${actual_date_str}
    ${diff}=    Subtract Date From Date    ${actual_date_obj}    ${expected_date_obj}
    ${abs_diff}=    Evaluate    abs(${diff})
    Should Be True    ${abs_diff} < 2    Ngày giờ tạo hóa đơn lệch quá 2 giây (lệch ${abs_diff} giây)


Ghi Chú Được Cập Nhật Thành ${expected_note}
    [Documentation]    Xác thực ghi chú đã được cập nhật
    ${query}=    Set Variable    SELECT Description FROM Invoice WHERE Id = ?
    ${invoice_data}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${invoice_data}    None    Không tìm thấy thông tin hóa đơn ${INVOICE_ID}
    Should Be Equal    ${invoice_data[0]}    ${expected_note}    Ghi chú không khớp

Chuẩn Bị Dữ Liệu Cập Nhật Giao Hàng Với Mã Hóa Đơn ${invoice_id} Và Trạng Thái ${status} Và Ghi Chú "${note}"
    ${data}=    Set Variable    ${STANDARD_DELIVERY_UPDATE}
    Set To Dictionary    ${data}    InvoiceId=${invoice_id}
    &{delivery_info}=    Create Dictionary    Status=${status}    Note=${note}
    Set To Dictionary    ${data}    DeliveryInfo=${delivery_info}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Cập Nhật Người Nhận Với Tên ${name} SĐT ${phone} Và Địa Chỉ "${address}"
    ${data}=    Set Variable    ${STANDARD_DELIVERY_UPDATE}
    &{delivery_info}=    Create Dictionary    
    ...    ReceiverName=${name}    
    ...    ReceiverPhone=${phone}    
    ...    ReceiverAddress=${address}
    Set To Dictionary    ${data}    DeliveryInfo=${delivery_info}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Cập Nhật Phí Giao Hàng Thành ${fee} Đồng
    ${data}=    Set Variable    ${STANDARD_DELIVERY_UPDATE}
    &{delivery_info}=    Create Dictionary    ShippingFee=${fee}
    Set To Dictionary    ${data}    DeliveryInfo=${delivery_info}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Cập Nhật Trạng Thái Giao Hàng Thành ${status}
    ${data}=    Set Variable    ${STANDARD_DELIVERY_UPDATE}
    &{delivery_info}=    Create Dictionary    Status=${status}
    Set To Dictionary    ${data}    DeliveryInfo=${delivery_info}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Cập Nhật Mã Vận Đơn Thành ${tracking_code}
    ${data}=    Set Variable    ${STANDARD_DELIVERY_UPDATE}
    &{delivery_info}=    Create Dictionary    TrackingCode=${tracking_code}
    Set To Dictionary    ${data}    DeliveryInfo=${delivery_info}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Thông Tin Cập Nhật Giao Hàng Được Lưu Với Trạng Thái ${status}
    ${invoice_id}=    Set Variable    ${REQUEST_DATA.InvoiceId}
    Xác Thực Cập Nhật Giao Hàng Trong DB    ${invoice_id}
    Xác Thực Cập Nhật Trạng Thái Giao Hàng    ${invoice_id}    ${status}

Thông Tin Người Nhận Được Cập Nhật Thành ${name}, ${phone}, ${address}
    ${invoice_id}=    Set Variable    ${REQUEST_DATA.InvoiceId}
    Xác Thực Cập Nhật Thông Tin Người Nhận    ${invoice_id}    ${name}    ${phone}    ${address}

Phí Giao Hàng Được Cập Nhật Thành ${fee} Đồng
    ${invoice_id}=    Set Variable    ${REQUEST_DATA.InvoiceId}
    Xác Thực Cập Nhật Phí Giao Hàng    ${invoice_id}    ${fee}

Mã Vận Đơn Được Cập Nhật Thành ${tracking_code}
    ${invoice_id}=    Set Variable    ${REQUEST_DATA.InvoiceId}
    Xác Thực Cập Nhật Mã Vận Đơn    ${invoice_id}    ${tracking_code}

Ghi Chú Giao Hàng Được Cập Nhật Thành "${note}"
    ${invoice_id}=    Set Variable    ${REQUEST_DATA.InvoiceId}
    Xác Thực Ghi Chú Giao Hàng    ${invoice_id}    ${note} 

