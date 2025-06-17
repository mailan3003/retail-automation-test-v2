*** Settings ***
Documentation     Keywords cho test cases API xử lý thông tin giao hàng
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot   
Resource          ../../Keywords/Customer/CustomerCommonKeywords.robot
Resource          ../../Keywords/Delivery/DeliveryCommonKeywords.robot
Resource          InvoiceCommonKeywords.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           DateTime

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Cơ Bản
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng cơ bản với thông tin giao hàng tiêu chuẩn
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${delivery_id}=    Lấy Id Đối Tác Giao Hàng Theo Mã    ${DELIVERY_PARTNER_CODE} 
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${delivery_detail_body}=    Deep Copy    ${default_delivery_detail_body}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    DeliveryBy    ${delivery_id}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    DeliveryDetail    ${delivery_detail_body}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    UsingCod    1
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Đối Tác Để trống
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng thiếu SĐT người nhận
    ${request}=    Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Cơ Bản
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${delivery_detail_body}=    Deep Copy    ${default_delivery_detail_body}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    DeliveryBy    ${EMPTY}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    DeliveryDetail    ${delivery_detail_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Có khối lượng ${weight} g Và Kích thước ${length}x${width}x${height} cm
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng có khối lượng ${weight} g và kích thước ${length}x${width}x${height} cm
    ${request}=    Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Cơ Bản
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${delivery_detail_body}=    Deep Copy    ${default_delivery_detail_body}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    Weight    ${weight}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    Length    ${length}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    Width    ${width}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    Height    ${height}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    DeliveryDetail    ${delivery_detail_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Gắn Với Khách Hàng ${customer_code} Và Phí Giao Hàng ${fee}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng gắn với khách hàng ${customer_code} và phí giao hàng ${fee}
    ${request}=    Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Cơ Bản
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${delivery_detail_body}=    Deep Copy    ${default_delivery_detail_body}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    Price    ${fee}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    DeliveryDetail    ${delivery_detail_body}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    CustomerId    ${customer_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Với Thu Hộ và Thanh Toán ${payment_amount}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng với thu hộ và thanh toán ${payment_amount}
    ${request}=    Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Cơ Bản
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${delivery_detail_body}=    Deep Copy    ${default_delivery_detail_body}
    ${data}=     Deep Copy   ${payment_body} 
    ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${payment_amount}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Payments    ${data}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    DeliveryDetail    ${delivery_detail_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    ${COD}    Evaluate   100000 - ${payment_amount} 
    Set Test Variable    ${ORIGINAL_COD}    ${COD}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}




Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Với Trạng Thái ${status}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng với trạng thái ${status}
    ${Value}=   Run Keyword If    '${status}' =='Chờ Xử lý'     Set Variable    1
    ...    ELSE IF    '${status}' =='Đang Giao Hàng'       Set Variable    2
    ...    ELSE IF    '${status}' =='Đã Giao Hàng'        Set Variable    3
    ${request}=    Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Cơ Bản
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${delivery_detail_body}=    Get From Dictionary    ${request_invoice}    DeliveryDetail
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    Status    ${Value}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    DeliveryDetail    ${delivery_detail_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Không Thu Hộ
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng không thu hộ
    ${request}=    Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Cơ Bản
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${delivery_detail_body}=    Deep Copy    ${default_delivery_detail_body}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    UsingPriceCod    0
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    DeliveryDetail    ${delivery_detail_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}
Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Thời Gian ${days} Ngày Sau Ngày Hiện Tại
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng có thời gian giao hàng ${days} ngày sau ngày hiện tại
    ${request}=    Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Cơ Bản
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${delivery_detail_body}=    Deep Copy    ${default_delivery_detail_body}
    ${current_date}=    Get Current Date   result_format=%Y-%m-%d
    ${date_time}=    Add Time To Date    ${current_date}    ${days} days    result_format=%Y-%m-%d 
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    ExpectedDelivery     ${date_time}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.DeliveryDetail    ${delivery_detail_body}
    Set Test Variable     ${date_time}       ${date_time}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# Validation Keywords
Xác Thực Hóa Đơn Giao Hàng Trong DB
    [Documentation]    Xác thực hóa đơn giao hàng đã được tạo trong CSDL
    ${query}=    Set Variable    SELECT Id, UsingCod FROM DeliveryPackage WHERE InvoiceId = ?
    ${invoice_data}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${invoice_data}    None    Hóa đơn không tồn tại trong CSDL
    Should Be Equal As Integers    ${invoice_data[1]}    1    Trạng thái UsingCod không được bật


Xác Thực Hóa Đơn Giao Hàng Trong DB Không Thu Hộ
    [Documentation]    Xác thực hóa đơn giao hàng đã được tạo trong CSDL
    ${query}=    Set Variable    SELECT Id, UsingCod FROM DeliveryPackage WHERE InvoiceId = ?
    ${invoice_data}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${invoice_data}    None    Hóa đơn không tồn tại trong CSDL
    Should Be Equal As Integers    ${invoice_data[1]}    0    Trạng thái UsingCod không được bật
Xác Thực Thông Tin Người Nhận
    [Documentation]    Xác thực thông tin người nhận trong CSDL
    [Arguments]    ${expected_name}    ${expected_phone}
    ${query}=    Set Variable    SELECT Receiver, ContactNumber FROM DeliveryPackage WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${delivery_data}    None    Thông tin giao hàng không tồn tại trong CSDL
    Should Be Equal    ${delivery_data[0]}    ${expected_name}    Tên người nhận không khớp
    Should Be Equal    ${delivery_data[1]}    ${expected_phone}    Số điện thoại người nhận không khớp

Xác Thực Địa Chỉ Giao Hàng
    [Documentation]    Xác thực địa chỉ giao hàng trong CSDL
    [Arguments]    ${expected_address}
    ${query}=    Set Variable    SELECT Address FROM DeliveryPackage WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${delivery_data}    None    Thông tin giao hàng không tồn tại trong CSDL
    Should Be Equal    ${delivery_data[0]}    ${expected_address}    Địa chỉ giao hàng không khớp

Xác Thực Thời Gian Giao Hàng 
    [Documentation]    Xác thực thời gian giao hàng trong CSDL
    [Arguments]    ${expected_date_time}
    ${query}=    Set Variable    SELECT ExpectedDelivery FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${delivery_data}    None    Thông tin giao hàng không tồn tại trong CSDL
    ${delivery_data[0]}    Convert To String    ${delivery_data[0]}
    ${get_date_time}    Split String    ${delivery_data[0]}     ${SPACE}
    Should Be Equal    ${get_date_time[0]}   ${expected_date_time}   Ngày giao hàng không khớp

Xác Thực Khu Vực Giao Hàng
    [Documentation]    Xác thực khu vực giao hàng trong CSDL
    [Arguments]        ${expected_location_id}    ${expected_ward_id}
    ${query}=    Set Variable    SELECT LocationId,LocationName,WardId,WardName FROM DeliveryPackage WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${delivery_data}    None    Thông tin giao hàng không tồn tại trong CSDL
    Should Be Equal As Integers    ${delivery_data[0]}    ${expected_location_id}    Mã khu vực không khớp
    Should Be Equal As Integers    ${delivery_data[2]}    ${expected_ward_id}    Mã phường/xã không khớp

Xác Thực Đối Tác Giao Hàng
    [Documentation]    Xác thực đối tác giao hàng trong CSDL
    [Arguments]    ${expected_partner_code}  
    ${partner_id}=    Lấy Id Đối Tác Giao Hàng Theo Mã    ${expected_partner_code}
    ${query}=    Set Variable    SELECT DeliveryBy FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${delivery_data}    None    Thông tin giao hàng không tồn tại trong CSDL
    Should Be Equal As Integers    ${delivery_data[0]}    ${partner_id}    Mã đối tác không khớp

Xác Thực Sử Dụng Thông Tin Trọng Lượng ${expected_weight} Và Kích Thước ${expected_length}x${expected_width}x${expected_height} cm
    [Documentation]    Xác thực sử dụng thông tin trọng lượng gói hàng trong CSDL
    ${query}=    Set Variable    SELECT Weight, Length, Width, Height FROM DeliveryPackage WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${delivery_data}    None    Thông tin giao hàng không tồn tại trong CSDL
    Should Be Equal As Integers    ${delivery_data[0]}    ${expected_weight}    Trọng lượng không khớp
    Should Be Equal As Integers    ${delivery_data[1]}    ${expected_length}    Chiều dài không khớp
    Should Be Equal As Integers    ${delivery_data[2]}    ${expected_width}    Chiều rộng không khớp
    Should Be Equal As Integers    ${delivery_data[3]}    ${expected_height}    Chiều cao không khớp



Xác Thực Phí Giao Hàng
    [Documentation]    Xác thực phí giao hàng trong CSDL
    [Arguments]    ${expected_fee}
    ${query}=    Set Variable    SELECT Price FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${delivery_data}    None    Thông tin giao hàng không tồn tại trong CSDL
    Should Be Equal As Numbers    ${delivery_data[0]}    ${expected_fee}    Phí giao hàng không khớp


Xác Thực Trạng Thái Giao Hàng
    [Documentation]    Xác thực trạng thái giao hàng trong CSDL
    [Arguments]    ${expected_status}
    ${query}=    Set Variable    SELECT Status FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${delivery_data}    None    Thông tin giao hàng không tồn tại trong CSDL
    Should Be Equal As Integers    ${delivery_data[0]}    ${expected_status}    Trạng thái giao hàng không khớp

Xác Thực Số Tiền Thu Hộ
    [Documentation]    Xác thực số tiền thu hộ trong CSDL
    [Arguments]    ${expected_cod_fee}
    ${query}=    Set Variable    SELECT OriginalCOD FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_data}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${delivery_data}    None    Thông tin giao hàng không tồn tại trong CSDL
    Should Be Equal As Numbers    ${delivery_data[0]}    ${expected_cod_fee}    Số tiền thu hộ không khớp



Xác Thực Khách Hàng ${expected_customer_code}
    ${customer_id}=    Lấy Id Khách Hàng Theo Mã Khách Hàng    ${expected_customer_code}
    ${query}=    Set Variable    SELECT CustomerId FROM Invoice WHERE Id = ?
    ${delivery_data}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${delivery_data}    None    Thông tin có thông tin khách hàng
    Should Be Equal As Integers    ${delivery_data[0]}    ${customer_id}    Mã khách hàng không khớp

Get LocationID của Tỉnh/Thành Phố ${province_name}
    [Documentation]    Lấy thông tin khu vực từ CSDL
    ${query}=    Set Variable    SELECT id FROM Location WHERE Name = ?
    ${location_data}=    Fetch One    ${query}    ${province_name}
    RETURN    ${location_data}

Get WardID của Phường/Xã ${ward_name}
    [Documentation]    Lấy thông tin khu vực từ CSDL
    ${query}=    Set Variable    SELECT id FROM Wards WHERE Name = ?
    ${ward_data}=    Fetch One    ${query}    ${ward_name}
    RETURN    ${ward_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thời Gian Giao Hàng ${status} So Với Thời Gian Hóa Đơn
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng với thời gian giao hàng ${status} so với thời gian hóa đơn
    ${purchase_date}=    Get Current Date   result_format=%Y-%m-%d
    ${expected_delivery}=    Run Keyword If    '${status}' == 'Sớm'   Subtract Time From Date    ${purchase_date}   5 days   result_format=%Y-%m-%d
    ...    ELSE IF    '${status}' == 'Trễ'    Add Time To Date    ${purchase_date}    5 days    result_format=%Y-%m-%d
    ...    ELSE    Set Variable    ${purchase_date}
    ${request}=    Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Cơ Bản
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    PurchaseDate    ${purchase_date}
    ${delivery_detail_body}=    Deep Copy    ${default_delivery_detail_body}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    ExpectedDelivery    ${expected_delivery}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    DeliveryDetail    ${delivery_detail_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Với Đối Tác Không Hoạt Động
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng với đối tác không hoạt động
    ${request}=    Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Cơ Bản
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${delivery_detail_body}=    Deep Copy    ${default_delivery_detail_body}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    UseDefaultPartner    ${TRUE}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    PartnerCode    ${NON_EXISTENT_KV_PARTNER_DELIVERY_CODE}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    ServiceAdd    S1
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    DeliveryDetail    ${delivery_detail_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    # Giả định đối tác không hoạt động (IsActive = false) sẽ được xử lý bởi mock service
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Với Đối Tác Không Hỗ Trợ Nhà Bán Hàng
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng với đối tác không hỗ trợ nhà bán hàng hiện tại
    ${request}=    Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Cơ Bản
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${delivery_detail_body}=    Deep Copy    ${default_delivery_detail_body}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    UseDefaultPartner    ${TRUE}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    PartnerCode    ${KV_PARTNER_DELIVERY_CODE_WRONG_SCOPE}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    ServiceAdd    S1
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    DeliveryDetail    ${delivery_detail_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    # Giả định đối tác không hỗ trợ nhà bán hàng hiện tại sẽ được xử lý bởi mock service
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Thiếu Thông Tin Bên Trả Phí
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng thiếu thông tin bên trả phí
    ${request}=    Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Cơ Bản
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${delivery_detail_body}=    Deep Copy    ${default_delivery_detail_body}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    UseDefaultPartner    ${TRUE}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    PartnerCode    ${GHN_PARTNER_DELIVERY_CODE}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    ServiceAdd    ${EMPTY}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    DeliveryDetail    ${delivery_detail_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Với Thiết Lập Không Cho Phép COD Qua KiotViet
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng với thiết lập không cho phép COD qua đối tác KiotViet
    ${request}=    Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Cơ Bản
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${delivery_detail_body}=    Deep Copy    ${default_delivery_detail_body}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    UseDefaultPartner    ${TRUE}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    PartnerCode    ${GHN_PARTNER_DELIVERY_CODE}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    ServiceAdd    S1
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    DeliveryDetail    ${delivery_detail_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    # Giả định thiết lập nhà bán hàng không cho phép COD qua KiotViet sẽ được xử lý bởi mock service
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}
