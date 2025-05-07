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
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    SaleChannelId    ${channel_id}
     ${request}=    Deep Copy    ${invoice_request_body_update}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Trạng Thái Giao Hàng ${status}
    ${invoice_data}=    Thông tin hóa đơn được cập nhật  
    ${purchase_date}=    Convert Date    ${invoice_data[2]}    
    ${request_body}    Deep Copy    ${delivery_update_body_1}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Id     ${INVOICE_ID}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    PurchaseDate    ${purchase_date}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     DeliveryDetail.Status    ${status}
    ${request}=    Deep Copy    ${invoice_request_body_update_delivery}
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
    ${invoice_data}=    Thông tin hóa đơn được cập nhật  
    ${purchase_date}=    Convert Date    ${invoice_data[2]}    
    ${request_body}    Deep Copy    ${delivery_update_body_1}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Id     ${INVOICE_ID}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    PurchaseDate    ${purchase_date}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     DeliveryDetail.Receiver   Nguyễn Thị B
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     DeliveryDetail.ContactNumber    0912345678
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     DeliveryDetail.Address    456 Đường Lê Lợi, Q3
    ${request}=    Deep Copy    ${invoice_request_body_update_delivery}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Phí Giao Hàng ${fee}
    [Documentation]    Chuẩn bị dữ liệu cập nhật phí giao hàng
    ${invoice_data}=    Thông tin hóa đơn được cập nhật  
    ${purchase_date}=    Convert Date    ${invoice_data[2]}    
    ${request_body}    Deep Copy    ${delivery_update_body_1}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Id     ${INVOICE_ID}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    PurchaseDate    ${purchase_date}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    DeliveryDetail.Price    ${fee}
    ${request}=    Deep Copy    ${invoice_request_body_update_delivery}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Thu Hộ
    [Documentation]    Chuẩn bị dữ liệu cập nhật miễn phí giao hàng
    ${invoice_data}=    Thông tin hóa đơn được cập nhật  
    ${purchase_date}=    Convert Date    ${invoice_data[2]}    
    ${request_body}    Deep Copy    ${delivery_update_body_1}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Id     ${INVOICE_ID}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    PurchaseDate    ${purchase_date}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    DeliveryDetail.UsingPriceCod    1
    ${request}=    Deep Copy    ${invoice_request_body_update_delivery}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}


Chuẩn Bị Dữ Liệu Cập Nhật Mã Vận Đơn ${tracking_code}
    [Documentation]    Chuẩn bị dữ liệu cập nhật mã vận đơn
    ${invoice_data}=    Thông tin hóa đơn được cập nhật  
    ${purchase_date}=    Convert Date    ${invoice_data[2]}    
    ${request_body}    Deep Copy    ${delivery_update_body_1}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Id     ${INVOICE_ID}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    PurchaseDate    ${purchase_date}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    DeliveryDetail.DeliveryCode    ${tracking_code}
    ${request}=    Deep Copy    ${invoice_request_body_update_delivery}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Đối Tác Giao Hàng ${delivery_by} 
    [Documentation]    Chuẩn bị dữ liệu cập nhật đối tác giao hàng
    ${invoice_data}=    Thông tin hóa đơn được cập nhật  
    ${purchase_date}=    Convert Date    ${invoice_data[2]}    
    ${request_body}    Deep Copy    ${delivery_update_body_1}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Id     ${INVOICE_ID}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    PurchaseDate    ${purchase_date}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    DeliveryDetail.DeliveryBy  ${delivery_by}
    ${request}=    Deep Copy    ${invoice_request_body_update_delivery}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Gói Hàng ${x}x${y}x${z}x${w}
    [Documentation]    Chuẩn bị dữ liệu cập nhật gói hàng
    ${invoice_data}=    Thông tin hóa đơn được cập nhật  
    ${purchase_date}=    Convert Date    ${invoice_data[2]}    
    ${request_body}    Deep Copy    ${delivery_update_body_1}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Id     ${INVOICE_ID}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    PurchaseDate    ${purchase_date}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    DeliveryDetail.Weight  ${x}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    DeliveryDetail.Length  ${y}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    DeliveryDetail.Width  ${z}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    DeliveryDetail.Height  ${w}
    ${request}=    Deep Copy    ${invoice_request_body_update_delivery}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Ngày Giao Dự Kiến và Ghi Chú
    [Documentation]    Chuẩn bị dữ liệu cập nhật ngày giao dự kiến
    ${invoice_data}=    Thông tin hóa đơn được cập nhật  
    ${purchase_date}=    Convert Date    ${invoice_data[2]}    
    ${expected_date}=   Add Time To Date    ${purchase_date}    10 days
    ${note}=    Set Variable    "Dự kiến giao vào ngày"
    ${request_body}    Deep Copy    ${delivery_update_body_1}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Id     ${INVOICE_ID}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    PurchaseDate    ${purchase_date}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    DeliveryDetail.ExpectedDelivery    ${expected_date}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    DeliveryDetail.Comments    ${note}
    ${request}=    Deep Copy    ${invoice_request_body_update_delivery}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_body}
    Set Test Variable    ${EXPECTED_DELIVERY_DATE}    ${expected_date}
    Set Test Variable    ${EXPECTED_NOTE}    ${note}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${REQUEST_DATA} 

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
    ${query}=    Set Variable    SELECT Receiver, ContactNumber, Address FROM DeliveryPackage WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Không tìm thấy thông tin giao hàng cho hóa đơn ${invoice_id}
    Should Be Equal    ${delivery_data[0]}    ${expected_name}    Tên người nhận không khớp
    Should Be Equal    ${delivery_data[1]}    ${expected_phone}    Số điện thoại người nhận không khớp
    Should Be Equal    ${delivery_data[2]}    ${expected_address}    Địa chỉ người nhận không khớp

Xác Thực Cập Nhật Phí Giao Hàng
    [Documentation]    Xác thực phí giao hàng đã được cập nhật
    [Arguments]    ${invoice_id}    ${expected_fee}
    ${query}=    Set Variable    SELECT Price FROM DeliveryInfo WHERE InvoiceId = ?
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
    ${query}=    Set Variable    SELECT DeliveryCode FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Không tìm thấy thông tin giao hàng cho hóa đơn ${invoice_id}
    Should Be Equal    ${delivery_data[0]}    ${expected_tracking_code}    Mã vận đơn không khớp

Xác Thực Cập Nhật Thu Hộ
    [Documentation]    Xác thực thông tin thu hộ đã được cập nhật
    [Arguments]    ${invoice_id}    
    ${query}=    Set Variable    SELECT UsingCod FROM DeliveryPackage WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_data}    None    Không tìm thấy thông tin giao hàng cho hóa đơn ${invoice_id}
    Should Be Equal As Integers    ${delivery_data[0]}   1

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
    ${query}=    Set Variable    SELECT ExpectedDelivery FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${INVOICE_ID}
    ${payment_date}=    Convert Date    ${delivery_data[0]}
    Should Not Be Equal    ${delivery_data}    None    Không tìm thấy thông tin hóa đơn ${INVOICE_ID}
    ${actual_date_str}=    Convert To String   ${payment_date}
    ${actual_date_str}=    Fetch From Left    ${actual_date_str}    .
    ${expected_date_obj}=    Convert Date    ${EXPECTED_DELIVERY_DATE}
    ${actual_date_obj}=    Convert Date    ${actual_date_str}
    ${diff}=    Subtract Date From Date    ${actual_date_obj}    ${expected_date_obj}
    ${abs_diff}=    Evaluate    abs(${diff})
    Should Be True    ${abs_diff} < 2    Ngày giờ tạo hóa đơn lệch quá 2 giây (lệch ${abs_diff} giây)

Xác Thực Ghi Chú Giao Hàng ${expected_note}
    [Documentation]    Xác thực ghi chú giao hàng đã được cập nhật
    ${query}=    Set Variable    SELECT Comments FROM DeliveryPackage WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${delivery_data}    None    Không tìm thấy thông tin giao hàng cho hóa đơn ${INVOICE_ID}
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

Đối tác giao hàng được cập nhật thành ${expected_delivery_by}
    [Documentation]    Xác thực đối tác giao hàng đã được cập nhật
    ${query}=    Set Variable    SELECT DeliveryBy FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${delivery_data}    None    Không tìm thấy thông tin giao hàng cho hóa đơn ${INVOICE_ID}
    Should Be Equal As Integers    ${delivery_data[0]}    ${expected_delivery_by}    Phương thức giao hàng không khớp

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


Chuẩn Bị Dữ Liệu Cập Nhật Mã Vận Đơn Thành ${tracking_code}
    ${data}=    Set Variable    ${STANDARD_DELIVERY_UPDATE}
    &{delivery_info}=    Create Dictionary    TrackingCode=${tracking_code}
    Set To Dictionary    ${data}    DeliveryInfo=${delivery_info}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Thông Tin Cập Nhật Giao Hàng Được Lưu Với Trạng Thái ${status}
    Xác Thực Cập Nhật Giao Hàng Trong DB    ${INVOICE_ID}
    Xác Thực Cập Nhật Trạng Thái Giao Hàng    ${INVOICE_ID}    ${status}

Thông Tin Người Nhận Được Cập Nhật Thành ${name}, ${phone}, ${address}
    Xác Thực Cập Nhật Thông Tin Người Nhận    ${INVOICE_ID}    ${name}    ${phone}    ${address}

Phí Giao Hàng Được Cập Nhật Thành ${fee} Đồng
    Xác Thực Cập Nhật Phí Giao Hàng    ${INVOICE_ID}    ${fee}

Mã Vận Đơn Được Cập Nhật Thành ${tracking_code}
    Xác Thực Cập Nhật Mã Vận Đơn    ${INVOICE_ID}    ${tracking_code}

Hóa Đơn Được Cập Nhật Thu Hộ
    Xác Thực Cập Nhật Thu Hộ    ${INVOICE_ID}


Chuẩn Bị Dữ Liệu Cập Nhật Hóa Đơn Thanh Toán Phương Thức ${payment_method} Với Số Tiền ${payment_amount}
    ${INVOICE_CODE}   ${purchase_date}    Thông tin mã hóa đơn
    ${request}=     Deep Copy    ${invoice_request_body_not_delivery}
    ${data}=    Deep Copy    ${payment_body} 
    ${data}=    Update Nested Dictionary Property    ${data}    Method    ${payment_method}
    ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${payment_amount}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.Payments    ${data}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.UpdateInvoiceId    ${INVOICE_ID}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.Code    Update_${INVOICE_CODE}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.PurchaseDate    ${purchase_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Log    ${REQUEST_DATA}  
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Cập Nhật Hóa Đơn Thanh Toán Phương Thức ${payment_method} Với Số Tiền ${payment_amount} Với Khách Hàng ${customer_id}
    ${INVOICE_CODE}   ${purchase_date}    Thông tin mã hóa đơn
    ${request}=     Deep Copy    ${invoice_request_body_not_delivery}
    ${data}=    Deep Copy    ${payment_body} 
    ${data}=    Update Nested Dictionary Property    ${data}    Method    ${payment_method}
    ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${payment_amount}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.Payments    ${data}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.CustomerId    ${customer_id}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.UpdateInvoiceId    ${INVOICE_ID}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.Code    Update_${INVOICE_CODE}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.PurchaseDate    ${purchase_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Log    ${REQUEST_DATA}  
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Cập Nhật Hóa Đơn Thay Đổi Số Lượng ${quantity} Hàng hóa trong đơn
    ${INVOICE_CODE}   ${purchase_date}    Thông tin mã hóa đơn
    ${request}=     Deep Copy    ${invoice_request_body_not_delivery}
    ${data}=    Deep Copy    ${STANDARD_INVOICE_DETAIL} 
    ${data}=    Update Nested Dictionary Property    ${data}    Quantity    ${quantity}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.UpdateInvoiceId    ${INVOICE_ID}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.Code    Update_${INVOICE_CODE}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.PurchaseDate    ${purchase_date}
    ${total_price}=    Evaluate    100000 * ${quantity}
    Set Test Variable    ${TOTAL_PRICE}    ${total_price}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Log    ${REQUEST_DATA}  
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Hóa Đơn Thay Đổi ${product_id} Với Số Lượng ${quantity}
    ${INVOICE_CODE}   ${purchase_date}    Thông tin mã hóa đơn
    ${request}=     Deep Copy    ${invoice_request_body_not_delivery}
    ${data}=    Deep Copy    ${STANDARD_INVOICE_DETAIL} 
    ${data}=    Update Nested Dictionary Property    ${data}    ProductId    ${product_id}
    ${data}=    Update Nested Dictionary Property    ${data}    Quantity    ${quantity}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.UpdateInvoiceId    ${INVOICE_ID}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.Code    Update_${INVOICE_CODE}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.PurchaseDate    ${purchase_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Log    ${REQUEST_DATA}  
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Cập Nhập Hóa Đơn Đã Hủy
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%d
    ${request}=     Deep Copy    ${invoice_request_body_not_delivery}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.UpdateInvoiceId    ${INVOICE_ID_VOID}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.Code    Update_HD011452
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.PurchaseDate    ${purchase_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Log    ${REQUEST_DATA}  
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Cập Nhập Hóa Đơn Không Tồn Tại
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%d
    ${request}=     Deep Copy    ${invoice_request_body_not_delivery}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.UpdateInvoiceId    5395735
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.Code    Update_HD011452
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.PurchaseDate    ${purchase_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Log    ${REQUEST_DATA}  
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Hóa Đơn Thay Đổi Thành Tiền ${total_price}
    ${INVOICE_CODE}   ${purchase_date}    Thông tin mã hóa đơn
    ${request}=     Deep Copy    ${invoice_request_body_not_delivery}
    ${data}=    Deep Copy    ${STANDARD_INVOICE_DETAIL} 
    ${data}=    Update Nested Dictionary Property    ${data}    Price    ${total_price}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.UpdateInvoiceId    ${INVOICE_ID}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.Code    Update_${INVOICE_CODE}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.PurchaseDate    ${purchase_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Log    ${REQUEST_DATA}  
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Hóa Đơn Cập Nhập Mô Tả Hóa Đơn
    ${description}=    Set Variable    Mô tả hóa đơn
    ${INVOICE_CODE}   ${purchase_date}    Thông tin mã hóa đơn
    ${request}=     Deep Copy    ${invoice_request_body_not_delivery}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.Description    ${description}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.UpdateInvoiceId    ${INVOICE_ID}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.Code    Update_${INVOICE_CODE}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.PurchaseDate    ${purchase_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${DESCRIPTION}    ${description}
    Log    ${REQUEST_DATA}  
    RETURN    ${request}
Số lượng hàng hóa trong đơn là ${quantity}
    ${query}=    Set Variable    SELECT Quantity FROM InvoiceDetail WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}
    ${quantity_in_db}=    Convert To Number    ${result[0]}
    Should Be Equal As Numbers    ${quantity_in_db}    ${quantity}    Số lượng hàng hóa trong đơn không đúng    

Thông tin mã hóa đơn
   ${query}=    Set Variable    SELECT Code, PurchaseDate FROM Invoice WHERE Id = ?
   ${result}=    Fetch One    ${query}    ${INVOICE_ID}
   ${purchase_date}=    Convert Date    ${result[1]}
   Set Test Variable    ${INVOICE_CODE}    ${result[0]}
   RETURN    ${INVOICE_CODE}      ${purchase_date}

Thông tin khách hàng trong hóa đơn là ${customer_id}
    ${query}=    Set Variable    SELECT CustomerId FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}
    Set Test Variable    ${CUSTOMER_ID}    ${result[0]}
    RETURN    ${CUSTOMER_ID}

Xác Thực Trạng Thái Hóa Đơn ${invoice_code} Là Trạng Thái ${expected_status}
    ${status}=    Set Variable If    '${expected_status}'=='Hủy'    2    1
    ${status}    Convert To Number    ${status}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${query}=    Set Variable    SELECT Status FROM Invoice WHERE Code = ?
    ${result}=    Fetch One    ${query}    ${invoice_code}
    Should Be Equal    ${result[0]}    ${status}    Trạng thái hóa đơn không đúng. Kỳ vọng: ${expected_status}, Thực tế: ${result[0]}

