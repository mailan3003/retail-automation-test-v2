*** Settings ***
Documentation     Keywords cho test API xử lý giao hàng
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Order/DeliveryProcessingData.robot
Resource          ../../TestData/Order/CreateOrderData.robot
Resource          CreateOrderKeywords.robot
Resource          ../Delivery/DeliveryCommonKeywords.robot
Resource          ../Product/ProductCommonKeywords.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           Collections
Library           DateTime
Library           json

*** Variables ***
${CREATE_ORDER_ENDPOINT}    orders

*** Keywords ***
# Keywords chuẩn bị dữ liệu
Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Có Thông Tin Giao Hàng
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${delivery_info}=    Deep Copy    ${PARTNER_ORDER_DELIVERY_BODY}
    ${request_order}    Update Dictionary Property    ${request_order}    DeliveryDetail    ${delivery_info}
    ${request_order}    Update Dictionary Property    ${request_order}    UsingCod       1
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}



Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Có Đối Tác Giao Hàng ${delivery_code}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng thiếu SĐT người nhận
    ${delivery_id}  Lấy Id Đối Tác Giao Hàng Theo Mã    ${delivery_code}
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${delivery_info}=    Deep Copy    ${PARTNER_ORDER_DELIVERY_BODY}
    ${delivery_info}=    Update Dictionary Property    ${delivery_info}    DeliveryBy    ${delivery_id} 
    ${request_order}    Update Dictionary Property    ${request_order}    DeliveryDetail    ${delivery_info}
    ${request_order}    Update Dictionary Property    ${request_order}    UsingCod       1
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Có khối lượng ${weight} g Và Kích thước ${length}x${width}x${height} cm
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng có khối lượng ${weight} g và kích thước ${length}x${width}x${height} cm
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${delivery_info}=    Deep Copy    ${PARTNER_ORDER_DELIVERY_BODY}
    ${delivery_info}=    Update Nested Dictionary Property    ${delivery_info}    Weight    ${weight}
    ${delivery_info}=    Update Nested Dictionary Property    ${delivery_info}    Length    ${length}
    ${delivery_info}=    Update Nested Dictionary Property    ${delivery_info}    Width    ${width}
    ${delivery_info}=    Update Nested Dictionary Property    ${delivery_info}    Height    ${height}
    ${request_order}    Update Dictionary Property    ${request_order}    DeliveryDetail    ${delivery_info}
    ${request_order}    Update Dictionary Property    ${request_order}    UsingCod       1
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Gắn Với Khách Hàng ${customer_code} Và Phí Giao Hàng ${fee}
    [Documentation]    Chuẩn bị dữ liệu đơn hàng gắn với khách hàng ${customer_cod} và phí giao hàng ${fee}
    ${customer_id}    Lấy Id Khách Hàng Theo Mã Khách Hàng    ${customer_code}
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${delivery_info}=    Deep Copy    ${PARTNER_ORDER_DELIVERY_BODY}
    ${delivery_info}=    Update Nested Dictionary Property    ${delivery_info}    Price    ${fee}
    ${request_order}    Update Dictionary Property    ${request_order}    DeliveryDetail    ${delivery_info}
    ${request_order}    Update Dictionary Property    ${request_order}    CustomerId    ${customer_id}
    ${request_order}    Update Dictionary Property    ${request_order}    UsingCod       1
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Giao Hàng Với Thu Hộ và Thanh Toán ${payment_amount}
    [Documentation]    Chuẩn bị dữ liệu đơn hàng giao hàng với thu hộ và thanh toán ${payment_amount}
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${delivery_info}=    Deep Copy    ${PARTNER_ORDER_DELIVERY_BODY}
    ${payment_info}=     Deep Copy   ${STANDARD_PAYMENT}
    ${payment_info}=    Update Nested Dictionary Property    ${payment_info}    Amount    ${payment_amount}
    ${request_order}    Update Dictionary Property    ${request_order}    DeliveryDetail    ${delivery_info}
    ${request_order}    Update Dictionary Property    ${request_order}    Payments    ${payment_info}
    ${request_order}    Update Dictionary Property    ${request_order}    UsingCod       1
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    ${COD}    Evaluate   100000 - ${payment_amount} 
    Set Test Variable    ${ORIGINAL_COD}    ${COD}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}




Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Giao Hàng Với Trạng Thái ${status}
    [Documentation]    Chuẩn bị dữ liệu đơn hàng giao hàng với trạng thái ${status}
    ${Value}=   Run Keyword If    '${status}' =='Chờ Xử lý'     Set Variable    1
    ...    ELSE IF    '${status}' =='Đang Giao Hàng'       Set Variable    2
    ...    ELSE IF    '${status}' =='Đã Giao Hàng'        Set Variable    3
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${delivery_info}=    Deep Copy    ${PARTNER_ORDER_DELIVERY_BODY}
    ${delivery_info}=    Update Nested Dictionary Property    ${delivery_info}    Status    ${Value}
    ${request_order}    Update Dictionary Property    ${request_order}    DeliveryDetail    ${delivery_info}
    ${request_order}    Update Dictionary Property    ${request_order}    UsingCod       1
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Không Thu Hộ
    [Documentation]    Chuẩn bị dữ liệu đơn hàng không thu hộ
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${delivery_info}=    Deep Copy    ${PARTNER_ORDER_DELIVERY_BODY}
    ${delivery_info}=    Update Nested Dictionary Property    ${delivery_info}    UsingPriceCod    0
    ${request_order}    Update Dictionary Property    ${request_order}    DeliveryDetail    ${delivery_info}
    ${request_order}    Update Dictionary Property    ${request_order}    UsingCod       1
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}
Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Giao Hàng Thời Gian ${status} ${days} Ngày So Với Ngày Hiện Tại
    [Documentation]    Chuẩn bị dữ liệu đơn hàng giao hàng có thời gian giao hàng ${days} ngày sau ngày hiện tại
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${delivery_info}=    Deep Copy    ${PARTNER_ORDER_DELIVERY_BODY}
    ${current_date}=    Get Current Date   result_format=%Y-%m-%d
    ${date_time}=   Run Keyword If    '${status}' =='Sau'     Add Time To Date    ${current_date}    ${days} days    result_format=%Y-%m-%d 
    ...    ELSE IF    '${status}' =='Trước'     Subtract Time From Date    ${current_date}    ${days} days    result_format=%Y-%m-%d 
    ...    ELSE IF    '${status}' =='Trùng'     Set Variable    ${current_date}
    ${delivery_info}=    Update Nested Dictionary Property    ${delivery_info}    ExpectedDelivery     ${date_time}
    ${request_order}    Update Dictionary Property    ${request_order}    DeliveryDetail    ${delivery_info}
    ${request_order}    Update Dictionary Property    ${request_order}    UsingCod       1
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable     ${date_time}       ${date_time}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# Validation Keywords




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

Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Giao Hàng Với Đối Tác COD Không Hoạt Động
    [Documentation]    Chuẩn bị dữ liệu đơn hàng giao hàng với đối tác không hoạt động
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${delivery_info}=    Deep Copy    ${PARTNER_ORDER_DELIVERY_BODY}
    ${delivery_info}=    Update Nested Dictionary Property    ${delivery_info}    UseDefaultPartner    ${TRUE}
    ${delivery_info}=    Update Nested Dictionary Property    ${delivery_info}    PartnerCode    ${NON_EXISTENT_KV_PARTNER_DELIVERY_CODE}
    ${delivery_info}=    Update Nested Dictionary Property    ${delivery_info}    ServiceAdd    S1
    ${request_order}    Update Dictionary Property    ${request_order}    DeliveryDetail    ${delivery_info}
    ${request_order}    Update Dictionary Property    ${request_order}    UsingCod       1
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}



