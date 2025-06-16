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
    ${discount_amount}=    Evaluate    ${order_details[0][Price]} * ${discount_value} / 100
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

    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}




