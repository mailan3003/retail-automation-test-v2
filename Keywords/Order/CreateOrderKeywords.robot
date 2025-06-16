*** Settings ***
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Order/CreateOrderData.robot
Resource          ../Product/ProductCommonKeywords.robot
Resource          ../Customer/CustomerCommonKeywords.robot
Resource          ../Pricebook/PricebookCommonKeywords.robot
Resource          ../Promotion/PromotionComnonKeywords.robot
Resource          ../CashFlow/CashflowCommonKeywords.robot
Resource          OrderCommonKeywords.robot
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
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${order_details}=    Get From Dictionary    ${request_order}    OrderDetails
    ${discount_amount}=    Evaluate    100000 * ${discount_value} / 100
    ${request_order}  Update Dictionary Property    ${request_order}    DiscountRatio    ${discount_value}
    ${request_order}  Update Dictionary Property    ${request_order}    Discount    ${discount_amount}
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Giảm Giá ${discount_amount}
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${request_order}  Update Dictionary Property    ${request_order}    Discount    ${discount_amount}
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Có Khách Hàng ${customer_code}
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${customer_id}=   Run Keyword If    "${customer_code}" != "${EMPTY}"    Lấy Id Khách Hàng Theo Mã Khách Hàng    ${customer_code}    ELSE     Set Variable    0
    ${request_order}  Update Dictionary Property    ${request_order}    CustomerId    ${customer_id}
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}



Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Có ${customer_code} Thanh Toán ${payment_method} Với Số Tiền ${payment_amount}
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${customer_id}=   Run Keyword If    "${customer_code}" != "${EMPTY}"    Lấy Id Khách Hàng Theo Mã Khách Hàng    ${customer_code}    ELSE     Set Variable    0
    ${request_order}  Update Dictionary Property    ${request_order}    CustomerId    ${customer_id}
    ${payment_body}=   Deep Copy   ${STANDARD_PAYMENT}
    ${payment_body}  Update Dictionary Property    ${payment_body}    Method    ${payment_method}
    ${payment_body}  Update Dictionary Property    ${payment_body}    Amount    ${payment_amount}
    ${request_order}  Update Dictionary Property    ${request_order}    Payments    ${payment_body}
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Khách Hàng ${customer_code} Thanh Toán Đa Phương Thức ${list_payment_method} Với ${list_payment_amount}
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${customer_id}=   Run Keyword If    "${customer_code}" != "${EMPTY}"    Lấy Id Khách Hàng Theo Mã Khách Hàng    ${customer_code}    ELSE     Set Variable    0
    ${request_order}  Update Dictionary Property    ${request_order}    CustomerId    ${customer_id}
    ${list_payments}=    Create List
    FOR    ${payment_amount}   ${payment_method}   IN ZIP    ${list_payment_amount}    ${list_payment_method}
        ${payment_body}=   Deep Copy   ${STANDARD_PAYMENT}
        ${payment_body}  Update Dictionary Property    ${payment_body}    Method    ${payment_method}
        ${payment_body}  Update Dictionary Property    ${payment_body}    Amount    ${payment_amount}
        Append To List    ${list_payments}    ${payment_body}
    END
    ${request_order}  Update Dictionary Property    ${request_order}    Payments    ${list_payments}
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Đơn Hàng ${product_code} Thanh Toán Số Tiền ${payment_amount} Sử Dụng Điểm ${reward_point}
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${data}=    Deep Copy     ${STANDARD_PAYMENT}
    ${data}=    Update Nested Dictionary Property    ${data}    Method    ${PAYMENT_POINT}
    ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${payment_amount}
    ${data}=    Update Nested Dictionary Property    ${data}    UsePoint   ${reward_point}
    ${request_order}  Update Dictionary Property    ${request_order}    Payments    ${data}
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Đơn Hàng ${product_code} Thanh Toán ${customer_code} Số Tiền ${payment_amount} Sử Dụng Điểm ${reward_point}
    ${customer_id}=   Run Keyword If    "${customer_code}" != "${EMPTY}"    Lấy Id Khách Hàng Theo Mã Khách Hàng    ${customer_code}    ELSE     Set Variable    0
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${request_order}  Update Dictionary Property    ${request_order}    CustomerId    ${customer_id}
    ${data}=    Deep Copy     ${STANDARD_PAYMENT}
    ${data}=    Update Nested Dictionary Property    ${data}    Method    ${PAYMENT_POINT}
    ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${payment_amount}
    ${data}=    Update Nested Dictionary Property    ${data}    UsePoint   ${reward_point}
    ${request_order}  Update Dictionary Property    ${request_order}    Payments    ${data}
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}



Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Với Điểm Thưởng Và Tiền Mặt
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${payments}=    Create List
    # Tạo thanh toán bằng điểm
    ${payment_point}=    Create Dictionary
    ...    Method=${PAYMENT_POINT}
    ...    Amount=25000
    ...    UsePoint=25
    # Tạo thanh toán bằng tiền mặt
    ${payment_cash}=    Create Dictionary
    ...    Method=${PAYMENT_CASH}
    ...    Amount=75000
    Append To List    ${payments}    ${payment_point}
    Append To List    ${payments}    ${payment_cash}
    ${request_order}    Update Dictionary Property    ${request_order}    Payments    ${payments}
    ${request}    Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Đơn Hàng ${product_code} Thanh Toán Bằng Voucher Đợt ${Voucher_campain}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}

    ${voucher_campaign_id}  ${price}=    Lấy Thông Tin ID, PRICE Của Voucher Campaign    ${Voucher_campain}
    ${voucher_id}=    Lấy ID Mã Voucher Mới Nhất ở Trạng Thái Đã Phát Hành    ${voucher_campaign_id} 
    ${request}=    Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data}=    Deep Copy     ${STANDARD_PAYMENT} 
    ${data_product}=    Deep Copy      ${PRODUCT_ORDER_DETAIL}
    ${data_product}    Update Dictionary Property    ${data_product}    ProductId    ${product_id}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    5
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${data}=    Update Nested Dictionary Property    ${data}    Method    ${PAYMENT_VOUCHER}
    ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${price}
    ${data}=    Update Nested Dictionary Property    ${data}    VoucherId   ${voucher_id}
    ${data}=    Update Nested Dictionary Property    ${data}    VoucherCampaignId   ${voucher_campaign_id}
    ${request}    Update Nested Dictionary Property    ${request}    Order.Payments    ${data}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${VOUCHER_ID}    ${voucher_id}
    RETURN    ${request}

Chuẩn Bị Đặt Hàng ${product_code} Thanh Toán Bằng Voucher Đợt ${Voucher_campain} Với Mã Voucher ở Trạng Thái ${status}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${voucher_campaign_id}  ${price}=    Lấy Thông Tin ID, PRICE Của Voucher Campaign    ${Voucher_campain}
    ${voucher_id}  ${voucher_code}=    Lấy ID Mã Voucher Theo Trạng Thái    ${voucher_campaign_id}    ${status}
    ${request}=    Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data}=     Deep Copy    ${STANDARD_PAYMENT} 
    ${data_product}=     Deep Copy     ${PRODUCT_ORDER_DETAIL} 
    ${data_product}    Update Dictionary Property    ${data_product}    ProductId    ${product_id}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    5
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${data}=    Update Nested Dictionary Property    ${data}    Method    ${PAYMENT_VOUCHER}
    ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${price}
    ${data}=    Update Nested Dictionary Property    ${data}    VoucherId   ${voucher_id}
    ${data}=    Update Nested Dictionary Property    ${data}    VoucherCampaignId   ${voucher_campaign_id}
    ${request}    Update Nested Dictionary Property    ${request}    Order.Payments    ${data}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${VOUCHER_CODE}    ${voucher_code}
    RETURN    ${request}


Chuẩn Bị Đơn Hàng ${product_code} Thanh Toán Bằng Voucher Đợt ${Voucher_campain} Khi Chưa Đủ Điều Kiện
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${voucher_campaign_id}  ${price}=    Lấy Thông Tin ID, PRICE Của Voucher Campaign    ${Voucher_campain}
    ${voucher_id}=    Lấy ID Mã Voucher Mới Nhất ở Trạng Thái Đã Phát Hành   ${voucher_campaign_id} 
    ${request}=    Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data}=    Deep Copy    ${STANDARD_PAYMENT} 
    ${data}=    Update Nested Dictionary Property    ${data}    Method    ${PAYMENT_VOUCHER}
    ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${price}
    ${data}=    Update Nested Dictionary Property    ${data}    VoucherId   ${voucher_id}
    ${data}=    Update Nested Dictionary Property    ${data}    VoucherCampaignId   ${voucher_campaign_id}
    ${data_product}=    Deep Copy   ${PRODUCT_ORDER_DETAIL}  
    ${data_product}    Update Dictionary Property    ${data_product}    ProductId    ${product_id}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${request}    Update Nested Dictionary Property    ${request}    Order.Payments    ${data}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Thanh Toán Với ${number_of_voucher} Voucher Đợt ${Voucher_campain}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${voucher_campaign_id}  ${price}=    Lấy Thông Tin ID, PRICE Của Voucher Campaign    ${Voucher_campain}
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
        ${voucher_id}=   Lấy List ID Mã Voucher ở Trạng Thái Đã Phát Hành    ${voucher_campaign_id}    ${number_of_voucher}
        ${data}=     Deep Copy     ${STANDARD_PAYMENT} 
        ${data}=    Update Nested Dictionary Property    ${data}    Method    ${PAYMENT_VOUCHER}
        ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${price}
        ${data}=    Update Nested Dictionary Property    ${data}    VoucherId   ${voucher_id[${index}][0]}
        ${data}=    Update Nested Dictionary Property    ${data}    VoucherCampaignId   ${voucher_campaign_id}
        Append To List    ${payments}    ${data}
        Append To List    ${list_voucher_id}    ${voucher_id[${index}][0]}
    END
    ${request}    Update Nested Dictionary Property    ${request}    Order.Payments    ${payments}
    Set Test Variable    ${list_voucher_id}    ${list_voucher_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Log    ${request}
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


Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Có Thanh Toán ${payment_amount} Phương Thức ${payment_method}
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${payments}=   Deep Copy   ${STANDARD_PAYMENT}
    ${payments}  Update Dictionary Property    ${payments}    Method    ${payment_method}
    ${payments}  Update Dictionary Property    ${payments}    Amount    ${payment_amount}
    ${list_payments}=    Create List    ${payments}
    ${request_order}  Update Dictionary Property    ${request_order}    Payments    ${list_payments}
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Thanh Toán Phương Thức ${payment_method} Tài khoản ${bank_account} Với Số Tiền ${payment_amount} 
    ${bank_account_id}=    Lấy Id Bank Account Theo Mã Bank Account    ${bank_account}
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${payments}=   Deep Copy   ${STANDARD_PAYMENT}
    ${payments}  Update Dictionary Property    ${payments}    Method    ${payment_method}
    ${payments}  Update Dictionary Property    ${payments}    Amount    ${payment_amount}
    ${payments}  Update Dictionary Property    ${payments}    AccountId    ${bank_account_id}
    ${list_payments}=    Create List    ${payments}
    ${request_order}  Update Dictionary Property    ${request_order}    Payments    ${list_payments}
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Log    ${REQUEST_DATA}  
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Thanh Toán Phương Thức ${PAYMENT_CARD} ID Account ${bank_account_id} Với Số Tiền ${payment_amount}
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${payments}=   Deep Copy   ${STANDARD_PAYMENT}
    ${payments}  Update Dictionary Property    ${payments}    Method    ${PAYMENT_CARD}
    ${payments}  Update Dictionary Property    ${payments}    Amount    ${payment_amount}
    ${payments}  Update Dictionary Property    ${payments}    AccountId    ${bank_account_id}
    ${list_payments}=    Create List    ${payments}
    ${request_order}  Update Dictionary Property    ${request_order}    Payments    ${list_payments}
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Log    ${REQUEST_DATA}  
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Nhiều Phương Thức Thanh Toán ${list_payment_method} Với Số Tiền ${list_payment_amount}
    ${request}=    Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
    ${request_order}    Get From Dictionary      ${request}    Order
    ${list_payments}=    Create List
    FOR    ${payment_amount}   ${payment_method}   IN ZIP    ${list_payment_amount}    ${list_payment_method}
        ${payments}=   Deep Copy   ${STANDARD_PAYMENT}
        ${payments}  Update Dictionary Property    ${payments}    Method    ${payment_method}
        ${payments}  Update Dictionary Property    ${payments}    Amount    ${payment_amount}
        Append To List    ${list_payments}    ${payments}
    END
    ${request_order}  Update Dictionary Property    ${request_order}    Payments    ${list_payments}
    ${request}  Update Dictionary Property    ${request}    Order    ${request_order}
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
    Set Test Variable    ${TOTAL_TAX}    10000
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm ${product_code} Và Kích Thước ${x}x${y}x${z}x${w} 
    ${request}=    Deep Copy    ${BASE_ORDER_REQUEST}
    ${product_data}     Deep Copy   ${PRODUCT_ORDER_DETAIL}  
    ${materials_data}     Deep Copy    ${PRODUCT_ORDER_DETAIL_MATERIALS}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    ProductId   ${product_id}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    Note    ${x}mx${y}mx${z}mx${w} 
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute1   ${x}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute2   ${y}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute3   ${z}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute4   ${w}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Type1    1
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Type2    8
    ${product_data}    Update Nested Dictionary Property    ${product_data}    TransactionDetailMaterials      ${materials_data} 
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${product_data}   
    Set Test Variable    ${REQUEST_DATA}   ${request} 
    RETURN    ${request}
Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm Gạch ${product_code} Và Kích Thước ${x}x${y}x${z}
    ${request}=    Deep Copy    ${BASE_ORDER_REQUEST}
    ${product_data}     Deep Copy   ${PRODUCT_ORDER_DETAIL}  
    ${materials_data}     Deep Copy    ${PRODUCT_ORDER_DETAIL_MATERIALS}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    ProductId   ${product_id}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    Note    ${x}mx${y}mx${z}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute1   ${x}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute2   ${y}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute4   ${z}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    TransactionDetailMaterials      ${materials_data} 
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${product_data}   
    Set Test Variable    ${REQUEST_DATA}   ${request} 
    RETURN    ${request}
Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm ${product_code_1} Kích Thước ${x}x${y}x${z}x${w} Và ${product_code_2} Kích Thước ${x2}x${y2}x${z2}
    ${request}=    Deep Copy    ${BASE_ORDER_REQUEST}
    ${product_data}     Deep Copy   ${PRODUCT_ORDER_DETAIL}  
    ${product_data_2}     Deep Copy   ${PRODUCT_ORDER_DETAIL}  
    ${materials_data}     Deep Copy    ${PRODUCT_ORDER_DETAIL_MATERIALS}
    ${materials_data_2}     Deep Copy    ${PRODUCT_ORDER_DETAIL_MATERIALS}
    ${product_id_1}=    Lấy Thông Tin Sản Phẩm    ${product_code_1}
    ${product_id_2}=    Lấy Thông Tin Sản Phẩm    ${product_code_2}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    ProductId   ${product_id_1}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    Note    ${x}mx${y}mx${z}x${w}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute1   ${x}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute2   ${y}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute3   ${z}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute4   ${w}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Type1   1
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Type2   8
    ${product_data_2}    Update Nested Dictionary Property    ${product_data_2}    ProductId   ${product_id_2}
    ${product_data_2}    Update Nested Dictionary Property    ${product_data_2}    Note    ${x2}mx${y2}mx${z2}
    ${materials_data_2}    Update Nested Dictionary Property    ${materials_data_2}    Attribute1   ${x2}
    ${materials_data_2}    Update Nested Dictionary Property    ${materials_data_2}    Attribute2   ${y2}
    ${materials_data_2}    Update Nested Dictionary Property    ${materials_data_2}    Attribute4   ${z2}

    ${product_data}    Update Nested Dictionary Property    ${product_data}    TransactionDetailMaterials      ${materials_data} 
    ${product_data_2}    Update Nested Dictionary Property    ${product_data_2}    TransactionDetailMaterials      ${materials_data_2} 
    ${list_product_data}=    Create List    ${product_data}    ${product_data_2}
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${list_product_data}   
    Set Test Variable    ${REQUEST_DATA}   ${request} 
    RETURN    ${request}





Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm ${product_code} Có ${n} Gợi ý và Kích Thước ${x}x${y}${z}
    ${request}=    Deep Copy    ${BASE_ORDER_REQUEST}
    ${product_data}     Deep Copy   ${PRODUCT_ORDER_DETAIL}  
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    ${dimension_string}=    Set Variable    ${EMPTY}
    FOR    ${i}    IN RANGE    ${n}+1
        ${dimension_string}=    Set Variable    ${dimension_string} ${x}mx${y}mx${z}
    END
    Log    Chuỗi kích thước: ${dimension_string}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    ProductId   ${product_id}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    Note    ${dimension_string}
    ${list_materials_data}=    Create List
    FOR    ${i}    IN RANGE    ${n}+1
            ${materials_data}     Deep Copy     ${PRODUCT_ORDER_DETAIL_MATERIALS}
            ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute1   ${x}
            ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute2   ${y}
            ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute4   ${z}    
            Append To List    ${list_materials_data}    ${materials_data}
    END
    ${product_data}    Update Nested Dictionary Property    ${product_data}    TransactionDetailMaterials      ${list_materials_data} 
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${product_data}   
    Set Test Variable    ${REQUEST_DATA}   ${request} 
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm ${product_code} Có ${n} Dòng Với Kích Thước ${x}x${y}x${z}
    ${request}=    Deep Copy    ${BASE_ORDER_REQUEST}
    ${product_data}     Deep Copy   ${PRODUCT_ORDER_DETAIL}  
    ${materials_data}     Deep Copy    ${PRODUCT_ORDER_DETAIL_MATERIALS}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    ProductId   ${product_id}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    IsMaster    ${True}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    Note  ${x}mx${y}mx${z}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute1   ${x}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute2   ${y}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute4   ${z}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    TransactionDetailMaterials      ${materials_data} 
    ${list_product_data}=    Create List   ${product_data}
    FOR    ${i}    IN RANGE    ${n}
        ${product_data_child}     Deep Copy   ${PRODUCT_ORDER_DETAIL}  
        ${materials_data_child}     Deep Copy    ${PRODUCT_ORDER_DETAIL_MATERIALS}
        ${product_data_child}    Update Nested Dictionary Property    ${product_data_child}    ProductId   ${product_id}
        ${product_data_child}    Update Nested Dictionary Property    ${product_data_child}    IsMaster    ${False}
        ${product_data_child}    Update Nested Dictionary Property    ${product_data_child}    Note  ${x}mx${y}mx${z}
        ${materials_data_child}    Update Nested Dictionary Property    ${materials_data_child}    Attribute1   ${x}
        ${materials_data_child}    Update Nested Dictionary Property    ${materials_data_child}    Attribute2   ${y}
        ${materials_data_child}    Update Nested Dictionary Property    ${materials_data_child}    Attribute4   ${z}
        ${materials_data_child}     Update Nested Dictionary Property    ${product_data_child}    TransactionDetailMaterials      ${materials_data_child} 
        Append To List    ${list_product_data}    ${product_data_child}
    END
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${list_product_data}   
    
    Set Test Variable    ${REQUEST_DATA}   ${request} 
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Đơn Hàng Với Thuế Trực Tiếp Mặc Định Với Sản Phẩm ${product_code}
    [Documentation]    Prepares invoice data with default VAT rate (2%)
    ${product_info}=    Thông tin hàng hóa    ${product_code}
    ${price}=    Convert To Number    ${product_info[2]}
    ${request}=    Deep Copy    ${BASE_ORDER_REQUEST}
    ${invoice_detail_tax_body}=    Deep Copy    ${order_detail_tax_body}
    ${invoice_data}=    Deep Copy    ${PRODUCT_ORDER_DETAIL}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    ProductId    ${product_info[0]}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    Price    ${price}
    ${tax_value}=    Evaluate    ${price} * 0.02*20 / 100
    ${tax_value}=    Evaluate    round(${tax_value}, 0)
    ${invoice_detail_tax_body}=    Update Nested Dictionary Property  ${invoice_detail_tax_body}   DetailTax   ${tax_value}
    ${invoice_detail_tax_body}=    Update Nested Dictionary Property  ${invoice_detail_tax_body}   TaxId    7
    ${invoice_detail_tax_body}  Create List    ${invoice_detail_tax_body}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    OrderDetailTaxs    ${invoice_detail_tax_body}
    ${invoice_data}   Create List    ${invoice_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${invoice_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.TotalTax    -${tax_value}
    Log    ${request}
    Set Test Variable    ${TOTAL_TAX}    ${tax_value}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Giảm Giá ${discount} Có Thu Khác ${surcharge_code}
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với sản phẩm có giảm giá và phụ phí cố định
    ${surcharge_id}    ${surcharge_value}    ${surcharge_value_ratio}      Lấy Thông Tin Thu Khác Theo Code    ${surcharge_code}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    ${request}=    Deep Copy    ${BASE_ORDER_REQUEST}
    ${product_data}     Deep Copy   ${PRODUCT_ORDER_DETAIL}  
    ${product_data}    Update Nested Dictionary Property    ${product_data}    ProductId   ${product_id}
    ${list_product_data}=    Create List   ${product_data}
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${list_product_data}   
    ${request}  Update Dictionary Property    ${request}    Order.Discount    ${discount}
    ${surcharge_item_body}=    Deep Copy   ${SURCHARGE_BODY}
    ${surcharge_item_body}=   Update Nested Dictionary Property   ${surcharge_item_body}    SurchargeId    ${surcharge_id}
    ${surcharge_item_body}=  Run Keyword If    '${surcharge_value_ratio}' == '0'    Update Nested Dictionary Property   ${surcharge_item_body}    Price    ${surcharge_value}    ELSE    Update Nested Dictionary Property   ${surcharge_item_body}    ValueRatio    ${surcharge_value_ratio}
    ${request_order_surcharges}=    Create List    ${surcharge_item_body}
    ${request}  Update Dictionary Property    ${request}    Order.OrderSurcharges    ${request_order_surcharges}
    Set Test Variable    ${TOTAL_SURCHARGE}    ${surcharge_value}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Giảm Giá ${discount} Có Nhiều Thu Khác ${surcharge_code}
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với sản phẩm có giảm giá và phụ phí tính theo phần trăm
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    ${request}=    Deep Copy    ${BASE_ORDER_REQUEST}
    ${product_data}     Deep Copy   ${PRODUCT_ORDER_DETAIL}  
    ${product_data}    Update Nested Dictionary Property    ${product_data}    ProductId   ${product_id}
    ${list_product_data}=    Create List   ${product_data}
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${list_product_data}   
    ${request}  Update Dictionary Property    ${request}    Order.Discount    ${discount}
    ${order_surcharges}=    Create List
    FOR    ${surcharge_code}    IN    @{surcharge_code}
        ${surcharge_id}    ${surcharge_value}    ${surcharge_value_ratio}      Lấy Thông Tin Thu Khác Theo Code    ${surcharge_code}
        ${surcharge_item_body}=    Deep Copy    ${SURCHARGE_BODY}
        ${surcharge_item_body}=    Update Dictionary Property    ${surcharge_item_body}   SurchargeId    ${surcharge_id}
        ${surcharge_item_body}=  Run Keyword If    '${surcharge_value_ratio}' == '0'    Update Nested Dictionary Property   ${surcharge_item_body}    Price    ${surcharge_value}    ELSE    Update Nested Dictionary Property   ${surcharge_item_body}    ValueRatio    ${surcharge_value_ratio}
        Append To List    ${order_surcharges}    ${surcharge_item_body}
    END
    ${request}=    Update Nested Dictionary Property    ${request}   Order.OrderSurcharges    ${order_surcharges}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}
