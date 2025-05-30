*** Settings ***
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Order/CreateOrderData.robot
Resource          ../Product/Product_KeywordsCommand.robot
Resource          OrderCommandKeywords.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Library           BuiltIn
Library           Collections
Library           DateTime
Library           ../../Resources/DatabaseLibrary.py

*** Variables ***

*** Keywords ***
Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản
    ${request}=   Deep Copy   ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${request}  Update Dictionary Property    ${request}    PurchaseDate    ${purchase_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Sản Phẩm ${list_product_code}
    ${request}=   Deep Copy   ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Dictionary Property    ${request}    PurchaseDate    ${purchase_date}
    ${list_order_details}=    Create List
    FOR    ${product_code}    IN    @{list_product_code}
        ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
        ${order_details}=   Deep Copy   ${PRODUCT_ORDER_DETAIL}
        ${order_details}    Update Dictionary Property    ${order_details}    ProductId    ${product_id}
        ${order_details}    Update Dictionary Property    ${order_details}    ProductCode    ${product_code}
        Append To List    ${list_order_details}    ${order_details}
    END
    ${request}  Update Dictionary Property    ${request}    OrderDetails    ${list_order_details}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Chiết Khấu ${discount_value} 
    ${request}=   Deep Copy   ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Dictionary Property    ${request}    PurchaseDate    ${purchase_date}
    ${order_details}=   Deep Copy   ${PRODUCT_ORDER_DETAIL}
    ${request}  Update Dictionary Property    ${request}    OrderDetails    ${order_details}
    ${request}  Update Dictionary Property    ${request}    Discount    ${discount_value}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Có Thông Tin Giao Hàng
    ${request}=   Deep Copy   ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Dictionary Property    ${request}    PurchaseDate    ${purchase_date}
    ${order_details}=   Deep Copy   ${PRODUCT_ORDER_DETAIL}
    ${request}  Update Dictionary Property    ${request}    OrderDetails    ${order_details}
    ${delivery_info}=   Deep Copy   ${BASIC_DELIVERY_INFO}
    ${request}  Update Dictionary Property    ${request}    DeliveryInfo    ${delivery_info}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Có Khuyến Mãi
    ${request}=   Deep Copy   ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Dictionary Property    ${request}    PurchaseDate    ${purchase_date}
    ${order_details}=   Deep Copy   ${PRODUCT_ORDER_DETAIL}
    ${request}  Update Dictionary Property    ${request}    OrderDetails    ${order_details}
    ${promotions}=   Deep Copy   ${PROMOTIONS}
    ${request}  Update Dictionary Property    ${request}    Promotions    ${promotions}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Có Thanh Toán ${payment_amount} Phương Thức ${payment_method}
    ${request}=   Deep Copy   ${BASE_ORDER_REQUEST}
    ${order_request}=   Deep Copy   ${ORDER_DATA}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${order_request}  Update Dictionary Property    ${order_request}    PurchaseDate    ${purchase_date}
    ${payments}=   Deep Copy   ${STANDARD_PAYMENT}
    ${payments}  Update Dictionary Property    ${payments}    Method    ${payment_method}
    ${payments}  Update Dictionary Property    ${payments}    Amount    ${payment_amount}
    ${list_payments}=    Create List    ${payments}
    ${order_request}  Update Dictionary Property    ${order_request}    Payments    ${list_payments}
    ${request}  Update Dictionary Property    ${request}    Order    ${order_request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}
    
Chuẩn Bị Dữ Liệu Đơn Hàng Nhiều Phương Thức Thanh Toán ${list_payment_method} Với Số Tiền ${list_payment_amount}
    ${request}=   Deep Copy   ${BASE_ORDER_REQUEST}
    ${order_request}=   Deep Copy   ${ORDER_DATA}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${order_request}  Update Dictionary Property    ${order_request}    PurchaseDate    ${purchase_date}
    ${list_payments}=    Create List
    FOR    ${payment_amount}   ${payment_method}   IN ZIP    ${list_payment_amount}    ${list_payment_method}
        ${payments}=   Deep Copy   ${STANDARD_PAYMENT}
        ${payments}  Update Dictionary Property    ${payments}    Method    ${payment_method}
        ${payments}  Update Dictionary Property    ${payments}    Amount    ${payment_amount}
        Append To List    ${list_payments}    ${payments}
    END
    ${order_request}  Update Dictionary Property    ${order_request}    Payments    ${list_payments}
    ${request}  Update Dictionary Property    ${request}    Order    ${order_request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm Có Thuế VAT 
    ${request}=   Deep Copy   ${BASE_ORDER_REQUEST}
    ${order_request}=   Deep Copy   ${ORDER_DATA}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${order_request}   Update Nested Dictionary Property     ${order_request}    PurchaseDate    ${purchase_date}
    ${order_details}=   Deep Copy   ${PRODUCT_ORDER_DETAIL}
    ${order_details_tax_body}=   Deep Copy   ${order_detail_tax_body}
    ${order_details_tax_body}=  Update Dictionary Property    ${order_details_tax_body}    TaxId   3
    ${order_details_tax_body}=  Update Dictionary Property    ${order_details_tax_body}    DetailTax    10000
    ${list_order_details}=    Create List    ${order_details}
    ${list_order_details_tax_body}=    Create List    ${order_details_tax_body}
    
    ${order_request}  Update Nested Dictionary Property    ${order_request}    OrderDetails    ${list_order_details}
    ${order_request}  Update Nested Dictionary Property     ${order_request}    OrderDetails.OrderDetailTaxs    ${order_details_tax_body}
    ${order_request}  Update Nested Dictionary Property    ${order_request}    TotalTax    10000
    ${request}  Update Dictionary Property    ${request}    Order    ${order_request}

    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Xác Thực Thuế VAT Được Tính Đúng
    [Documentation]    Xác thực thuế VAT được tính toán đúng trong response
    Should Not Be Equal    ${RESPONSE_JSON}    ${None}    Response JSON không được rỗng
    Dictionary Should Contain Key    ${RESPONSE_JSON}    OrderDetails    Response phải chứa OrderDetails
    ${order_details}=    Get From Dictionary    ${RESPONSE_JSON}    OrderDetails
    Should Not Be Empty    ${order_details}    OrderDetails không được rỗng
    ${first_detail}=    Get From List    ${order_details}    0
    Dictionary Should Contain Key    ${first_detail}    TaxAmount    OrderDetail phải chứa TaxAmount
    ${tax_amount}=    Get From Dictionary    ${first_detail}    TaxAmount
    Should Be True    ${tax_amount} > 0    TaxAmount phải lớn hơn 0, nhưng thực tế là ${tax_amount}
    Log    Thuế VAT được tính đúng: ${tax_amount}
