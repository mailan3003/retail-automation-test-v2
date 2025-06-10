*** Settings ***
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Order/CreateOrderData.robot
Resource          ../Product/Product_KeywordsCommand.robot
Resource          ../Customer/CustomerCommandKeywords.robot
Resource          ../Pricebook/PricebookCommandKeywords.robot
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
Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request}=   Deep Copy   ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${order_details}=   Deep Copy   ${PRODUCT_ORDER_DETAIL}
    ${order_details}    Update Dictionary Property    ${order_details}    ProductId    ${product_id}
    ${request}  Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Sản Phẩm ${list_product_code}
    ${request}=   Deep Copy   ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${list_order_details}=    Create List
    FOR    ${product_code}    IN    @{list_product_code}
        ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
        ${order_details}=   Deep Copy   ${PRODUCT_ORDER_DETAIL}
        ${order_details}    Update Dictionary Property    ${order_details}    ProductId    ${product_id}
        ${order_details}    Update Dictionary Property    ${order_details}    ProductCode    ${product_code}
        Append To List    ${list_order_details}    ${order_details}
    END
    ${request}  Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${list_order_details}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Sản Phẩm ${list_product_code} Với Số Lượng Đặt Hàng ${list_quantity}
    ${request}=   Deep Copy   ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${list_order_details}=    Create List
    FOR    ${product_code}    ${quantity}    IN ZIP    ${list_product_code}    ${list_quantity}
        ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
        ${order_details}=   Deep Copy   ${PRODUCT_ORDER_DETAIL}
        ${order_details}   Update Nested Dictionary Property    ${order_details}    ProductId    ${product_id}
        ${order_details}   Update Nested Dictionary Property    ${order_details}    Quantity    ${quantity}
        Append To List    ${list_order_details}    ${order_details}
    END
    ${request}   Update Nested Dictionary Property     ${request}    Order.OrderDetails    ${list_order_details}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${LIST_ORDER_DETAILS}    ${list_order_details}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm ${product_code} Có Số Lượng Đặt Hàng ${quantity}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${request}=   Deep Copy   ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${order_details}=   Deep Copy   ${PRODUCT_ORDER_DETAIL}
    ${order_details}    Update Dictionary Property    ${order_details}    ProductId    ${product_id}
    ${order_details}    Update Dictionary Property    ${order_details}    Quantity    ${quantity}
    ${request}  Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}

    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Có Chiết Khấu ${discount_value} %
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${request}=   Deep Copy   ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${order_details}=   Deep Copy   ${PRODUCT_ORDER_DETAIL}
    ${order_details}    Update Dictionary Property    ${order_details}    ProductId    ${product_id}
    ${discount_amount}=    Evaluate    ${order_details}[Price] * ${discount_value} / 100
    ${request}  Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    ${request}  Update Nested Dictionary Property    ${request}    Order.DiscountRatio    ${discount_value}
    ${request}  Update Nested Dictionary Property    ${request}    Order.Discount    ${discount_amount}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Giảm Giá ${discount_amount}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${request}=   Deep Copy   ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${order_details}=   Deep Copy   ${PRODUCT_ORDER_DETAIL}
    ${order_details}    Update Dictionary Property    ${order_details}    ProductId    ${product_id}
    ${request}  Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    ${request}  Update Nested Dictionary Property    ${request}    Order.Discount    ${discount_amount}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Có Khách Hàng ${customer_code}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${customer_id}=    Lấy Id Khách Hàng Theo Mã Khách Hàng    ${customer_code}
    ${request}=   Deep Copy   ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${order_details}=   Deep Copy   ${PRODUCT_ORDER_DETAIL}
    ${order_details}    Update Dictionary Property    ${order_details}    ProductId    ${product_id}
    ${request}  Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    ${request}  Update Nested Dictionary Property    ${request}    Order.CustomerId    ${customer_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}



Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Có ${customer_code} Thanh Toán ${payment_method} Với Số Tiền ${payment_amount}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${customer_id}=   Run Keyword If    "${customer_code}" != "${EMPTY}"    Lấy Id Khách Hàng Theo Mã Khách Hàng    ${customer_code}    ELSE     Set Variable    0
    ${request}=   Deep Copy   ${BASE_ORDER_REQUEST}
    ${order_details}=   Deep Copy   ${PRODUCT_ORDER_DETAIL}
    ${order_details}    Update Dictionary Property    ${order_details}    ProductId    ${product_id}
    ${request}  Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    ${payment_body}=   Deep Copy   ${STANDARD_PAYMENT}
    ${payment_body}  Update Dictionary Property    ${payment_body}    Method    ${payment_method}
    ${payment_body}  Update Dictionary Property    ${payment_body}    Amount    ${payment_amount}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${request}  Update Nested Dictionary Property    ${request}    Order.CustomerId    ${customer_id}
    ${request}  Update Nested Dictionary Property    ${request}    Order.Payments    ${payment_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Khách Hàng ${customer_code} Thanh Toán Đa Phương Thức ${list_payment_method} Với ${list_payment_amount}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${customer_id}=   Run Keyword If    ${customer_code} != ${EMPTY}    Lấy Id Khách Hàng Theo Mã Khách Hàng    ${customer_code}    ELSE     Set Test Variable    0
    ${request}=   Deep Copy   ${BASE_ORDER_REQUEST}
    ${list_payments}=    Create List
    FOR    ${payment_amount}   ${payment_method}   IN ZIP    ${list_payment_amount}    ${list_payment_method}
        ${payment_body}=   Deep Copy   ${STANDARD_PAYMENT}
        ${payment_body}  Update Dictionary Property    ${payment_body}    Method    ${payment_method}
        ${payment_body}  Update Dictionary Property    ${payment_body}    Amount    ${payment_amount}
        Append To List    ${list_payments}    ${payment_body}
    END
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${order_details}=   Deep Copy   ${PRODUCT_ORDER_DETAIL}
    ${order_details}    Update Dictionary Property    ${order_details}    ProductId    ${product_id}
    ${request}  Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${request}  Update Nested Dictionary Property    ${request}    Order.CustomerId    ${customer_id}
    ${request}  Update Nested Dictionary Property    ${request}    Order.Payments    ${list_payments}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Đơn Hàng ${product_code} Thanh Toán Số Tiền ${payment_amount} Sử Dụng Điểm ${reward_point}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${request}=    Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data}=    Deep Copy     ${STANDARD_PAYMENT}
    ${data}=    Update Nested Dictionary Property    ${data}    Method    ${PAYMENT_POINT}
    ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${payment_amount}
    ${data}=    Update Nested Dictionary Property    ${data}    UsePoint   ${reward_point}
    ${order_details}=   Deep Copy   ${PRODUCT_ORDER_DETAIL}
    ${order_details}    Update Dictionary Property    ${order_details}    ProductId    ${product_id}
    ${request}  Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    ${request}    Update Nested Dictionary Property    ${request}    Order.Payments    ${data}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Đơn Hàng ${product_code} Thanh Toán Bằng Voucher Đợt ${Voucher_campain}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${query_1}=    Set Variable    SELECT ID, Price FROM VoucherCampaign WHERE Code = ?
    ${result}=    Fetch One    ${query_1}    ${Voucher_campain}
    ${query_2}=    Set Variable    SELECT top(1) Id FROM Voucher WHERE VoucherCampaignId = ? AND Status = 1
    ${Voucher_Id}=    Fetch One    ${query_2}    ${result[0]}
    ${result[1]}    Convert To Number     ${result[1]}
    ${request}=    Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data}=    Deep Copy     ${STANDARD_PAYMENT} 
    ${data_product}=    Deep Copy      ${PRODUCT_ORDER_DETAIL}
    ${data_product}    Update Dictionary Property    ${data_product}    ProductId    ${product_id}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    5
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${data}=    Update Nested Dictionary Property    ${data}    Method    ${PAYMENT_VOUCHER}
    ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${result[1]}
    ${data}=    Update Nested Dictionary Property    ${data}    VoucherId   ${voucher_id[0]}
    ${data}=    Update Nested Dictionary Property    ${data}    VoucherCampaignId   ${result[0]}
    ${request}    Update Nested Dictionary Property    ${request}    Order.Payments    ${data}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Đặt Hàng ${product_code} Thanh Toán Bằng Voucher Đợt ${Voucher_campain} Với Mã Voucher ở Trạng Thái ${status}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${status}=    Set Variable If  '${status}'=='Chưa Sử Dụng'    0     3
    ${query_1}=    Set Variable    SELECT ID, Price FROM VoucherCampaign WHERE Code = ?
    ${result}=    Fetch One    ${query_1}    ${Voucher_campain}
    ${query_2}=    Set Variable    SELECT top(1) Id FROM Voucher WHERE VoucherCampaignId = ? AND Status = ?
    ${Voucher_Id}=    Fetch One    ${query_2}    ${result[0]}    ${status}
    ${result[1]}    Convert To Number     ${result[1]}
    ${request}=    Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data}=     Deep Copy    ${STANDARD_PAYMENT} 
    ${data_product}=     Deep Copy     ${PRODUCT_ORDER_DETAIL} 
    ${data_product}    Update Dictionary Property    ${data_product}    ProductId    ${product_id}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    5
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${data}=    Update Nested Dictionary Property    ${data}    Method    ${PAYMENT_VOUCHER}
    ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${result[1]}
    ${data}=    Update Nested Dictionary Property    ${data}    VoucherId   ${voucher_id[0]}
    ${data}=    Update Nested Dictionary Property    ${data}    VoucherCampaignId   ${result[0]}
    ${request}    Update Nested Dictionary Property    ${request}    Order.Payments    ${data}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Đơn Hàng ${product_code} Thanh Toán Bằng Voucher Đợt ${Voucher_campain} Khi Chưa Đủ Điều Kiện
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${query_1}=    Set Variable    SELECT ID, Price FROM VoucherCampaign WHERE Code = ?
    ${result}=    Fetch One    ${query_1}    ${Voucher_campain}
    ${query_2}=    Set Variable    SELECT top(1) Id FROM Voucher WHERE VoucherCampaignId = ? AND Status = 1
    ${voucher_Id}=    Fetch One    ${query_2}    ${result[0]}
    ${result[1]}    Convert To Number     ${result[1]}
    ${request}=    Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data}=    Deep Copy    ${STANDARD_PAYMENT} 
    ${data}=    Update Nested Dictionary Property    ${data}    Method    ${PAYMENT_VOUCHER}
    ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${result[1]}
    ${data}=    Update Nested Dictionary Property    ${data}    VoucherId   ${voucher_id[0]}
    ${data}=    Update Nested Dictionary Property    ${data}    VoucherCampaignId   ${result[0]}
    ${data_product}=    Deep Copy   ${PRODUCT_ORDER_DETAIL}  
    ${data_product}    Update Dictionary Property    ${data_product}    ProductId    ${product_id}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${request}    Update Nested Dictionary Property    ${request}    Order.Payments    ${data}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Thanh Toán Với ${number_of_voucher} Voucher Đợt ${Voucher_campain}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${query_1}=    Set Variable    SELECT ID, Price FROM VoucherCampaign WHERE Code = ?
    ${result}=    Fetch One    ${query_1}    ${Voucher_campain}
    ${result[1]}    Convert To Number     ${result[1]}
    ${request}=    Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data_product}=    Deep Copy   ${PRODUCT_ORDER_DETAIL}  
    ${data_product}    Update Dictionary Property    ${data_product}    ProductId    ${product_id}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    5
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${payments}=    Create List
    ${list_voucher_id}=    Create List
    FOR    ${index}    IN RANGE    ${number_of_voucher}
        ${query_2}=    Set Variable    SELECT top(${number_of_voucher}) Id FROM Voucher WHERE VoucherCampaignId = ? AND Status = 1
        ${voucher_id}=    Fetch All   ${query_2}    ${result[0]}
        ${data}=     Deep Copy     ${STANDARD_PAYMENT} 
        ${data}=    Update Nested Dictionary Property    ${data}    Method    ${PAYMENT_VOUCHER}
        ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${result[1]}
        ${data}=    Update Nested Dictionary Property    ${data}    VoucherId   ${voucher_id[${index}]}
        ${data}=    Update Nested Dictionary Property    ${data}    VoucherCampaignId   ${result[0]}
        Append To List    ${payments}    ${data}
        Append To List    ${list_voucher_id}    ${voucher_id[${index}]}
    END
    ${request}    Update Nested Dictionary Property    ${request}    Order.Payments    ${payments}
    Set Test Variable    ${list_voucher_id}    ${list_voucher_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}




Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Có Bảng Giá ${pricebook_name}
    ${pricebook_id}=   Lấy Id Bảng Giá Theo Tên Bảng Giá   ${pricebook_name}
    ${request}  Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${request_order}    Update Dictionary Property    ${request_order}    PriceBookId    ${pricebook_id}
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Có Kênh Bán ${channel_name}
    ${channel_id}=   Lấy Id Kênh Bán Hàng Theo Tên ${channel_name}
    ${request}  Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${request_order}    Update Dictionary Property    ${request_order}    SaleChannelId    ${channel_id}
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Có Người Nhận Đặt ${seller_name}
    ${seller_id}=     Lấy Thông tin Người Dùng Theo Tên  ${seller_name}
    ${request}  Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${request_order}    Update Dictionary Property    ${request_order}    SoldById    ${seller_id}
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Có Mô Tả Đơn Hàng ${number_of_characters} Ký Tự
    ${description}=    Generate Random String    ${number_of_characters}
    ${request}  Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${request_order}    Update Dictionary Property    ${request_order}    Description    ${description}
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${DESCRIPTION}    ${description}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Có Ngày Bán ${status} ${days} Ngày So Với Ngày Hiện Tại
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${current_date}=    Get Current Date    UTC    
    ${purchase_date}=     Run Keyword If    '${status}'=='Trước'    Subtract Time From Date   ${current_date}    ${days} days    ELSE    Add Time To Date   ${current_date}    ${days} days
    ${request_order}    Update Dictionary Property    ${request_order}    PurchaseDate    ${purchase_date}
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${PURCHASE_DATE}    ${purchase_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Có Thời Gian Giao Hàng ${status} ${days} Ngày So Với Ngày Hiện Tại
    ${current_date}=    Get Current Date    UTC    
    ${purchase_delivery_date}=   Run Keyword If    '${status}'=='Trước'    Subtract Time From Date   ${current_date}    ${days} days    ELSE    Add Time To Date   ${current_date}    ${days} days
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${request_order}    Update Dictionary Property    ${request_order}    ExpectedDeliveryDate    ${purchase_delivery_date}
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${PURCHASE_DELIVERY_DATE}   ${purchase_delivery_date}
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

Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm ${product_code} Có Thuế VAT 
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${request}=   Deep Copy   ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property     ${request}    Order.PurchaseDate    ${purchase_date}
    ${order_details}=   Deep Copy   ${PRODUCT_ORDER_DETAIL}
    ${order_details}    Update Dictionary Property    ${order_details}    ProductId    ${product_id}
    ${order_details_tax_body}=   Deep Copy   ${order_detail_tax_body}
    ${order_details_tax_body}=  Update Dictionary Property    ${order_details_tax_body}    TaxId   3
    ${order_details_tax_body}=  Update Dictionary Property    ${order_details_tax_body}    DetailTax    10000
    ${list_order_details_tax_body}=    Create List    ${order_details_tax_body}
    ${order_details}   Update Nested Dictionary Property    ${order_details}  OrderDetailTaxs    ${list_order_details_tax_body}
    ${list_order_details}=    Create List    ${order_details}
    ${request}  Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${list_order_details}
    ${request}  Update Nested Dictionary Property    ${request}    Order.TotalTax    10000

    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}




