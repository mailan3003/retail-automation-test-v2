*** Settings ***
Documentation     Keywords cho test API cập nhật đơn hàng
Resource          ../../TestData/Order/CreateOrderData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../Product/ProductCommonKeywords.robot
Resource          ../Customer/CustomerCommonKeywords.robot
Resource          ../Delivery/DeliveryCommonKeywords.robot
Resource          OrderCommonKeywords.robot
Resource          ../CommonKeywords.robot
Resource          CreateOrderKeywords.robot
Resource          PromotionOrderKeywords.robot
Resource          DeliveryProcessingKeywords.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           Collections
Library           DateTime

*** Variables ***
${UPDATE_ORDER_ENDPOINT}    orders

*** Keywords ***
# =============================================================================
# Keywords chuẩn bị dữ liệu cho các test case thành công
# =============================================================================
Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản ${product_code} Để Cập Nhật
    [Documentation]    Chuẩn bị dữ liệu để tạo đơn đặt hàng cơ bản
   Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${product_code}
   Gửi Yêu Cầu Tạo Đơn Hàng


Chuẩn Bị Đơn Đặt hàng Với Hàng ${product_code} Với Số Lượng ${quantity} Để Cập Nhật
    Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm ${product_code} Có Số Lượng Đặt Hàng ${quantity}
    Gửi Yêu Cầu Tạo Đơn Hàng


Chuẩn Bị Đơn Hàng ${product_code} Có Thông Tin Giao Hàng Để Cập Nhật
    Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Có Thông Tin Giao Hàng
    Gửi Yêu Cầu Tạo Đơn Hàng

Chuẩn Bị Đơn Hàng Sản Phẩm ${product_code} Có Khách Hàng ${customer_code} Thanh Toán Với Số Tiền ${payment_amount}
   Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Có ${customer_code} Thanh Toán ${PAYMENT_CASH} Với Số Tiền ${payment_amount}
   Gửi Yêu Cầu Tạo Đơn Hàng

Chuẩn Bị Đơn Hàng Sản Phẩm ${product_code} Với Khách Hàng ${customer_code}
   Chuẩn Bị Dữ Liệu Đơn Hàng ${product_code} Có Khách Hàng ${customer_code}
    Gửi Yêu Cầu Tạo Đơn Hàng

Chuẩn Bị Đơn Hàng Sản Phẩm ${product_code} Có Khuyến Mãi ${promotion_code} Để Cập Nhật
   Chuẩn Bị Dữ Liệu Đơn Hàng Sản Phẩm ${product_code} Với Khuyến Mãi ${promotion_code}
   Gửi Yêu Cầu Tạo Đơn Hàng



Chuẩn Bị Dữ Liệu Cập Nhật Mô Tả Cho Đơn Hàng 
    [Documentation]    Chuẩn bị dữ liệu để cập nhật mô tả cho đơn hàng
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${request}    Update Nested Dictionary Property    ${request}    Order.Id     ${CREATED_ORDER_ID} 
    ${request}    Update Nested Dictionary Property    ${request}    Order.Description    Cập nhật mô tả cho đơn hàng
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Cập Nhật Ngày Bán Cho Đơn Hàng Thành ${status} ${days} Ngày So Với Ngày Hiện Tại
    ${current_date}=    Get Current Date    UTC    
    ${purchase_date}=     Run Keyword If    '${status}'=='Trước'    Subtract Time From Date   ${current_date}    ${days} days    ELSE    Add Time To Date   ${current_date}    ${days} days
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${request}    Update Nested Dictionary Property    ${request}    Order.Id     ${CREATED_ORDER_ID} 
    ${request}=    Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    Set Test Variable    ${PURCHASE_DATE}    ${purchase_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Cập Nhật Thời Gian Giao Hàng Cho Đơn Hàng Thành ${status} ${days} Ngày So Với Ngày Hiện Tại
    ${current_date}=    Get Current Date    UTC    
    ${purchase_delivery_date}=   Run Keyword If    '${status}'=='Trước'    Subtract Time From Date   ${current_date}    ${days} days    ELSE    Add Time To Date   ${current_date}    ${days} days
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${request}    Update Nested Dictionary Property    ${request}    Order.Id     ${CREATED_ORDER_ID} 
    ${request}=    Update Nested Dictionary Property    ${request}    Order.ExpectedDeliveryDate    ${purchase_delivery_date}
    Set Test Variable    ${PURCHASE_DATE}   ${purchase_delivery_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Cập Nhập Người Bán Cho Đơn Hàng Thành ${seller_name}
    ${seller_id}=    Lấy Thông tin Người Dùng Theo Tên   ${seller_name}
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.Id    ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.SoldById    ${seller_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Cập Nhật Bảng Giá ${pricebook_name} Cho Đơn Đặt Hàng
    ${pricebook_id}=    Lấy Id Bảng Giá Theo Tên Bảng Giá    ${pricebook_name}
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.Id    ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.PriceBookId    ${pricebook_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Cập Nhật Sản Phẩm ${product_code} Với Số Lượng ${quantity} Và Giá ${price}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.Id    ${CREATED_ORDER_ID}
    ${order_details}=    Get From Dictionary    ${request}  Order  
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    ${total}=    Evaluate    ${quantity} * ${price}
    ${index}=    Find Index In List    ${order_details}    ProductId    ${product_id}
    ${detail}=    Get From List    ${order_details}    ${index}
    ${detail}=    Update Nested Dictionary Property    ${detail}    Quantity    ${quantity}
    ${detail}=    Update Nested Dictionary Property    ${detail}    Price    ${price}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${TOTAL_PRICE}    ${total}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đặt Hàng Thêm ${product_code} Với Số Lượng ${quantity}
    [Documentation]    Chuẩn bị dữ liệu để đặt hàng thêm sản phẩm với số lượng cụ thể
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${request}    Update Nested Dictionary Property    ${request}    Order.Id    ${CREATED_ORDER_ID}
    ${order_details}=    Get From Dictionary    ${request}  Order  
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    ${product_add_body}=    Create Dictionary    ProductId=${product_id}    Quantity=${quantity}
    Append To List    ${order_details}    ${product_add_body}
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Đặt Hàng Xóa ${product_code} Khỏi Đơn
    [Documentation]    Chuẩn bị dữ liệu để đặt hàng xóa sản phẩm khỏi đơn hàng
    ${product_id}=    Lấy Thông tin Sản Phẩm     ${product_code}
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${request}    Update Nested Dictionary Property    ${request}    Order.Id    ${CREATED_ORDER_ID}
    ${order_details}=    Get From Dictionary    ${request}  Order   
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    ${product_delete_body}=    Remove Item From List   ${order_details}    ProductId    ${product_id}
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${product_delete_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đặt Hàng Update ${product_code} Với Số Lượng ${quantity}
    [Documentation]    Chuẩn bị dữ liệu để đặt hàng update sản phẩm với số lượng cụ thể
    ${product_id}=    Lấy Thông tin Sản Phẩm  ${product_code}
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${request}    Update Nested Dictionary Property    ${request}    Order.Id    ${CREATED_ORDER_ID}
    ${order_details}=    Get From Dictionary    ${request}  Order   
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    ${index}=    Find Index In List    ${order_details}    ProductId    ${product_id}
    ${detail}=    Get From List    ${order_details}    ${index}
    ${detail}=    Update Nested Dictionary Property    ${detail}    Quantity    ${quantity}
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}

    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Thêm ${n} Dòng Cho Sản Phẩm ${product_code} Với Số Lượng Mỗi Dòng ${quantity}
    [Documentation]    Chuẩn bị dữ liệu để cập nhật thêm ${n} dòng cho sản phẩm ${product_code}
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    ${request}    Update Nested Dictionary Property    ${request}    Order.Id    ${CREATED_ORDER_ID}
    ${order_details}=    Get From Dictionary    ${request}  Order   
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    ${index}=    Find Index In List    ${order_details}    ProductId    ${product_id}
    ${detail}=    Get From List    ${order_details}    ${index}
    ${detail}=    Update Nested Dictionary Property    ${detail}    IsMaster    True  
    FOR    ${i}    IN RANGE    ${n}
        ${detail1}=    Deep Copy    ${detail}
        ${detail1}=    Update Nested Dictionary Property    ${detail1}    IsMaster    False
        ${detail1}=    Update Nested Dictionary Property    ${detail1}    Quantity    ${quantity}
        Append To List    ${order_details}    ${detail1}
    END
    ${Total_quantity}=    Evaluate    ${quantity} * ${n}
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${TOTAL_QUANTITY}    ${Total_quantity}
    RETURN    ${request}
Chuẩn Bị Cập Nhật Trạng Thái Đơn Hàng Sang ${status}
    [Documentation]    Chuẩn bị dữ liệu để cập nhật đơn hàng cơ bả
    ${request}=    Deep Copy    ${request_order_body_update}
    ${order_details}=    Get From Dictionary    ${REQUEST_DATA}    Order
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    ${status_id}=    Run Keyword If    '${status}' == 'Đã Xác Nhận'    Set Variable    5    
    ...  ELSE IF    '${status}' == 'Hoàn Thành'    Set Variable   3
    ...  ELSE IF    '${status}' == 'Phiếu Tạm'    Set Variable    1
    ...  ELSE IF    '${status}' == 'Đã Hủy'    Set Variable    4
    ...  ELSE IF    '${status}' == 'Đang Giao Hàng'    Set Variable    2
    ${request}    Update Nested Dictionary Property    ${request}    Order.Id    ${CREATED_ORDER_ID}
    ${request}    Update Nested Dictionary Property    ${request}    Order.StatusValue    ${status_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${STATUS_ID}    ${status_id}
    RETURN    ${request}



Chuẩn Bị Dữ Liệu Cập Nhật Khách Hàng Thành ${customer_code} 

    [Documentation]    Chuẩn bị dữ liệu để cập nhật khách hàng trong đơn hàng
    ${customer_id}=    Lấy Id Khách Hàng Theo Mã Khách Hàng   ${customer_code}
    ${request}=    Deep Copy     ${REQUEST_DATA}
    ${request}    Update Nested Dictionary Property    ${request}    Order.Id    ${CREATED_ORDER_ID}
    ${request}    Update Nested Dictionary Property    ${request}    Order.CustomerId    ${customer_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Khách Hàng ${customer_id} Trong Hệ Thống
    [Documentation]    Chuẩn bị dữ liệu để cập nhật khách hàng ${customer_id} trong hệ thống
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${request}    Update Nested Dictionary Property    ${request}    Order.Id    ${CREATED_ORDER_ID}
    ${request}    Update Nested Dictionary Property    ${request}    Order.CustomerId    ${customer_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Thanh Toán Phương Thức ${payment_method} Số Tiền ${amount}
    [Documentation]    Chuẩn bị dữ liệu để cập nhật thông tin thanh toán
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${request}    Update Nested Dictionary Property    ${request}    Order.Id    ${CREATED_ORDER_ID}

    
    # Cập nhật thông tin thanh toán
    ${payment}=    Create Dictionary    Method=${payment_method}    Amount=${amount}
    Run Keyword If    '${payment_method}' == 'Card'    Set To Dictionary    ${payment}    AccountId=${DEFAULT_BANK_ACCOUNT_ID}
    ${payments}=    Create List    ${payment}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.Payments    ${payments}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.Total    ${amount}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Thường Thành Đơn Có Giao Hàng
    [Documentation]    Chuẩn bị dữ liệu để cập nhật đơn hàng thường thành đơn có giao hàng
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${delivery_info}=    Deep Copy    ${PARTNER_ORDER_DELIVERY_BODY}
    ${request}    Update Nested Dictionary Property    ${request}    Order.Id    ${CREATED_ORDER_ID}
    ${request}    Update Nested Dictionary Property    ${request}    Order.DeliveryDetail    ${delivery_info}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}



Chuẩn Bị Dữ Liệu Cập Nhật Người Nhận Đơn Hàng MHBH
    [Documentation]    Chuẩn bị dữ liệu cập nhật thông tin người nhận
    ${request}     Deep Copy    ${REQUEST_DATA}
    ${request_body}=    Deep Copy    ${PARTNER_ORDER_DELIVERY_BODY}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     Receiver   Nguyễn Thị B
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     ContactNumber    0912345678
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     Address    456 Đường Lê Lợi, Q3
    ${request}=    Update Nested Dictionary Property    ${request}     Order.Id     ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.DeliveryDetail    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Phí Giao Hàng ${fee} MHBH
    [Documentation]    Chuẩn bị dữ liệu cập nhật phí giao hàng
    ${request}    Deep Copy   ${REQUEST_DATA}
    ${request_body}=    Deep Copy    ${PARTNER_ORDER_DELIVERY_BODY}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     Price    ${fee}
    ${request}=    Update Nested Dictionary Property    ${request}     Order.Id     ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.DeliveryDetail    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng ${status} Thu Hộ MHBH
    [Documentation]    Chuẩn bị dữ liệu cập nhật miễn phí giao hàng
    ${using_price_cod}=    Set Variable If    '${status}'=='Có'    1    0
    ${request}    Deep Copy   ${REQUEST_DATA}
    ${request_body}=    Deep Copy    ${PARTNER_ORDER_DELIVERY_BODY}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     UsingPriceCod    ${using_price_cod}
    ${request}=    Update Nested Dictionary Property    ${request}     Order.Id     ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.DeliveryDetail    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}


Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Mã Vận Đơn ${tracking_code} MHBH
    [Documentation]    Chuẩn bị dữ liệu cập nhật mã vận đơn
    ${request}    Deep Copy   ${REQUEST_DATA}
    ${request_body}=    Deep Copy    ${PARTNER_ORDER_DELIVERY_BODY}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     DeliveryCode    ${tracking_code}
    ${request}=    Update Nested Dictionary Property    ${request}     Order.Id     ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.DeliveryDetail    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Đối Tác Giao Hàng ${delivery_code} Ở MHBH
    [Documentation]    Chuẩn bị dữ liệu cập nhật đối tác giao hàng
    ${delivery_by}=    Lấy Id Đối Tác Giao Hàng Theo Mã    ${delivery_code}
    ${request}    Deep Copy   ${REQUEST_DATA}
    ${request_body}=    Deep Copy    ${PARTNER_ORDER_DELIVERY_BODY}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     DeliveryBy    ${delivery_by}
    ${request}=    Update Nested Dictionary Property    ${request}     Order.Id     ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.DeliveryDetail    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Gói Hàng ${x}x${y}x${z}x${w} Ở MHBH
    [Documentation]    Chuẩn bị dữ liệu cập nhật gói hàng
    ${request}    Deep Copy    ${REQUEST_DATA}
    ${request_body}=    Deep Copy    ${PARTNER_ORDER_DELIVERY_BODY}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Weight  ${x}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Length  ${y}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Width  ${z}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Height  ${w}
    ${request}=    Update Nested Dictionary Property    ${request}     Order.Id     ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.DeliveryDetail    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Ngày Giao Dự Kiến và Ghi Chú Ở MHBH
    [Documentation]    Chuẩn bị dữ liệu cập nhật ngày giao dự kiến
    ${purchase_date}=   Get Current Date    UTC
    ${expected_date}=   Add Time To Date    ${purchase_date}    10 days
    ${note}=    Set Variable    "Dự kiến giao vào ngày"
    ${request}    Deep Copy    ${REQUEST_DATA}
    ${request_body}=    Deep Copy    ${PARTNER_ORDER_DELIVERY_BODY}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     ExpectedDelivery    ${expected_date}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     Comments    ${note}
    ${request}=    Update Nested Dictionary Property    ${request}     Order.Id     ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.DeliveryDetail    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}



Chuẩn Bị Dữ Liệu Cập Nhật Kênh Bán Hàng Thành ${new_channel}
    [Documentation]    Chuẩn bị dữ liệu để cập nhật kênh bán hàng
    ${new_channel_id}=    Lấy Id Kênh Bán Hàng Theo Tên ${new_channel} 
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.Id     ${CREATED_ORDER_ID} 
    ${request}=    Update Nested Dictionary Property    ${request}    Order.SaleChannelId    ${new_channel_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# =============================================================================
# Keywords cho chuyển chi nhánh

Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Và Tạo Hóa Đơn
    [Documentation]    Chuẩn bị dữ liệu để cập nhật đơn hàng và tạo hóa đơn
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery} 
    ${order_details}=    Get From Dictionary    ${REQUEST_DATA}    Order
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${order_details}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.OrderId    ${CREATED_ORDER_ID}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Hóa Đơn Lấy 1 Phần Đặt Hàng ${product_code} Với Số Lượng ${quantity}
    [Documentation]    Chuẩn bị dữ liệu để lấy 1 phần đặt hàng
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery} 
    ${order_details}=    Get From Dictionary    ${REQUEST_DATA}    Order
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    ${body_product_list}=    Deep Copy    ${order_details}
    ${index}=    Find Index In List    ${body_product_list}    ProductId    ${product_id}
    ${detail}=    Get From List    ${body_product_list}    ${index}
    ${detail}=    Update Nested Dictionary Property    ${detail}    Quantity    ${quantity}
    ${new_product_list}=    Create List    ${detail}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${new_product_list}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.OrderId    ${CREATED_ORDER_ID}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Hóa Đơn Từ Đặt Hàng Lấy ${list_product_code} Với Số Lượng ${list_quantity}
    [Documentation]    Chuẩn bị dữ liệu để lấy 1 phần đặt hàng

    ${request}=    Deep Copy    ${invoice_request_body_not_delivery} 
    ${body_product_list}=    Deep Copy    ${LIST_ORDER_DETAILS}
    FOR    ${item_product_code}   ${item_quantity}   IN ZIP    ${list_product_code}    ${list_quantity}
        ${product_result}=    Lấy Id Và Type Của Sản Phẩm    ${item_product_code}
        ${index}=    Find Index In List    ${body_product_list}    ProductId   ${product_result}[0]
        ${detail}=    Get From List    ${body_product_list}    ${index}
        ${detail}=    Update Nested Dictionary Property    ${detail}    Quantity    ${item_quantity}
    END
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${body_product_list}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.OrderId    ${CREATED_ORDER_ID}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Hóa Đơn Từ Đặt Hàng Với Hàng Lô ${product_code} Và Số Lượng ${quantity}
    [Documentation]    Chuẩn bị dữ liệu để lấy 1 phần đặt hàng
    ${product_id}=    Lấy Id Và Type Của Sản Phẩm    ${product_code}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery} 
    ${body_product_list}=    Deep Copy    ${REQUEST_DATA}
    ${body_product_list}=    Get From Dictionary    ${body_product_list}    Order
    ${body_product_list}=    Get From Dictionary    ${body_product_list}    OrderDetails
    ${index}=    Find Index In List    ${body_product_list}    ProductId   ${product_id}
    ${detail}=    Get From List    ${body_product_list}    ${index}
    ${detail}=    Update Nested Dictionary Property    ${detail}    Quantity    ${quantity}
    ${detail}=    Update Nested Dictionary Property    ${detail}    IsLot    True
    ${new_product_list}=    Create List    ${detail}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${new_product_list}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.OrderId    ${CREATED_ORDER_ID}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Từ Đặt Hàng Với Hàng Imei ${product_code} Và Số Lượng ${quantity}
    [Documentation]    Chuẩn bị dữ liệu để lấy 1 phần đặt hàng
    ${product_id}=    Lấy Id Và Type Của Sản Phẩm    ${product_code}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery} 
    ${body_product_list}=    Deep Copy    ${REQUEST_DATA}
    ${body_product_list}=    Get From Dictionary    ${body_product_list}    Order
    ${body_product_list}=    Get From Dictionary    ${body_product_list}    OrderDetails
    ${index}=    Find Index In List    ${body_product_list}    ProductId   ${product_id}
    ${detail}=    Get From List    ${body_product_list}    ${index}
    ${detail}=    Update Nested Dictionary Property    ${detail}    Quantity    ${quantity}
    ${detail}=    Update Nested Dictionary Property    ${detail}    IsImei    True
    ${new_product_list}=    Create List    ${detail}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${new_product_list}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.OrderId    ${CREATED_ORDER_ID}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hoàn Thành Đơn Hàng
    [Documentation]    Chuẩn bị dữ liệu để hoàn thành đơn hàng
    ${request}=    Deep Copy    ${order_body_complete}
    ${request}    Update Nested Dictionary Property    ${request}    Order.Id    ${CREATED_ORDER_ID}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# =============================================================================

Chuẩn Bị Cập Nhật Khách Hàng ${customer_code} Cho Đơn Hàng
    [Documentation]    Chuẩn bị dữ liệu đơn hàng có khách hàng không tồn tại
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${customer_id}=   Lấy Id Khách Hàng Theo Mã Khách Hàng   ${customer_code}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.CustomerId    ${customer_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Cập Nhật Người Nhận Đặt Với ID Người Nhận Đặt ${user_id} ở MHBH
    [Documentation]    Chuẩn bị dữ liệu đơn hàng có nhân viên không tồn tại
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.SoldById    ${user_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Cập Nhật Đơn Hàng Với ID Kênh Bán Hàng ${channel_id} ở MHBH
    [Documentation]    Chuẩn bị dữ liệu đơn hàng có kênh bán hàng không tồn tại
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.SaleChannelId    ${channel_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Cập Nhật Đơn Hàng Với ID Chi Nhánh ${branch_id} ở MHBH
    [Documentation]    Chuẩn bị dữ liệu đơn hàng có chi nhánh không tồn tại
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.BranchId    ${branch_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Cập Nhật Đơn Hàng Với ID Bảng Giá ${pricebook_id} ở MHBH
    [Documentation]    Chuẩn bị dữ liệu đơn hàng có bảng giá không tồn tại
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.PriceBookId    ${pricebook_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Cập Nhật Đơn Hàng Với ID Nhân Viên Đặt Hàng ${user_id} ở MHBH
    [Documentation]    Chuẩn bị dữ liệu đơn hàng có nhân viên đặt hàng không tồn tại
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.SoldById    ${user_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Câp Nhật Đơn Hàng Với Sản Phẩm Trùng Ở MHBH
    [Documentation]    Chuẩn bị dữ liệu để cập nhật đơn hàng với sản phẩm trùng
    ${list_product_code}=    Create List   
    ${request_product}=    Deep Copy    ${REQUEST_DATA}
    ${product_details}=    Get From Dictionary    ${request_product}    Order
    ${product_details}=    Get From Dictionary    ${product_details}    OrderDetails
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${order_details}=    Get From Dictionary    ${request}    Order
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    Append To List   ${list_product_code}   ${order_details}   
    Append To List   ${list_product_code}   ${product_details}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${list_product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Cập Nhật Đơn Hàng Với Sản Phẩm Có Số Lượng ${quantity}
    [Documentation]    Chuẩn bị dữ liệu để cập nhật đơn hàng với sản phẩm có số lượng
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${product_details}=    Get From Dictionary    ${request}    Order
    ${product_details}=    Get From Dictionary    ${product_details}    OrderDetails
    ${product_details}=    Update Nested Dictionary Property    ${product_details}    Quantity    ${quantity}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${product_details}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Cập Nhật Đơn Hàng Với Sản Phẩm ${product_code} Ở MHBH
    [Documentation]    Chuẩn bị dữ liệu để cập nhật đơn hàng với sản phẩm
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${product_details}=    Get From Dictionary    ${request}    Order
    ${product_details}=    Get From Dictionary    ${product_details}    OrderDetails
    ${product_details}=    Update Nested Dictionary Property    ${product_details}    ProductId    ${product_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${product_details}
    Set Test Variable    ${REQUEST_DATA}    ${request}
# =============================================================================

# =============================================================================
# Keywords gửi yêu cầu API MHQL
# ============================================================================

Chuẩn Bị Dữ Liệu Chuyển Chi Nhánh Xử Lý Đặt Hàng Thành ${branch_name} Thanh Toán ${status} Cập Nhật Theo
    [Documentation]    Chuẩn bị dữ liệu để chuyển chi nhánh đơn hàng
    ${branch_id}=   Lấy Thông tin Chi Nhánh   ${branch_name}
    ${request_order_body}=    Deep Copy    ${REQUEST_DATA}
    ${product_details}=    Get From Dictionary    ${request_order_body}    Order
    ${product_details}=    Get From Dictionary    ${product_details}    OrderDetails
    ${request}=    Deep Copy    ${request_order_body_update}
    ${status_update}=    Set Variable If    '${status}'=='Có'    ${TRUE}    ${FALSE}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.Id    ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.BranchId    ${branch_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.TransferBranchId    ${branch_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${product_details}
    ${request}=    Update Nested Dictionary Property    ${request}    UpdateCustomerIdInPayments    ${status_update}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Chuyển Chi Nhánh Xử Lý Đặt Hàng Với Đơn Ở Trạng Thái ${status} Thành ${branch_name} 
    [Documentation]    Chuẩn bị dữ liệu để chuyển chi nhánh đơn hàng
    ${branch_id}=   Lấy Thông tin Chi Nhánh   ${branch_name}
    ${request_order_body}=    Deep Copy    ${REQUEST_DATA}
    ${product_details}=    Get From Dictionary    ${request_order_body}    Order
    ${product_details}=    Get From Dictionary    ${product_details}    OrderDetails
    ${request}=    Deep Copy    ${request_order_body_update}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.Id    ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.BranchId    ${branch_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.TransferBranchId    ${branch_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${product_details}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.StatusValue   ${status}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Kênh Bán Thành ${channel_name} Ở MHQL
    [Documentation]    Chuẩn bị dữ liệu để cập nhật kênh bán đơn hàng
    ${channel_id}=    Lấy Id Kênh Bán Hàng Theo Tên ${channel_name}
    ${request}=    Deep Copy    ${request_order_body_update}
        ${order_details}=    Get From Dictionary    ${REQUEST_DATA}    Order
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.Id    ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.SaleChannelId    ${channel_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}


Chuẩn Bị Dữ Liệu Cập Nhật Người Nhận Đặt Thành ${user_name} Ở MHQL
    [Documentation]    Chuẩn bị dữ liệu để cập nhật người nhận đặt đơn hàng
    ${user_id}=    Lấy Thông tin Người Dùng Theo Tên    ${user_name}
    ${request}=    Deep Copy    ${request_order_body_update}
        ${order_details}=    Get From Dictionary    ${REQUEST_DATA}    Order
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.Id    ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.SoldById    ${user_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Thời Gian Giao Hàng ${status} ${number_day} Ngày So Với Hiện Tại MHQL
    [Documentation]    Chuẩn bị dữ liệu để cập nhật thời gian đơn hàng
    ${request}=    Deep Copy    ${request_order_body_update}
    ${order_details}=    Get From Dictionary    ${REQUEST_DATA}    Order
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    ${current_date}=    Get Current Date    UTC    
    ${purchase_delivery_date}=   Run Keyword If    '${status}'=='Trước'    Subtract Time From Date   ${current_date}    ${number_day} days    ELSE    Add Time To Date   ${current_date}    ${number_day} days
    ${request}=    Update Nested Dictionary Property    ${request}    Order.Id    ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.ExpectedDeliveryDate    ${purchase_delivery_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}


Chuẩn Bị Dữ Liệu Cập Nhật Ngày Bán Hàng ${status} ${number_day} Ngày So Với Hiện Tại MHQL
    [Documentation]    Chuẩn bị dữ liệu để cập nhật ngày bán hàng
    ${request}=    Deep Copy    ${request_order_body_update}
    ${order_details}=    Get From Dictionary    ${REQUEST_DATA}    Order
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    ${current_date}=    Get Current Date    UTC    
    ${purchase_date}=   Run Keyword If    '${status}'=='Trước'    Subtract Time From Date   ${current_date}    ${number_day} days    ELSE    Add Time To Date   ${current_date}    ${number_day} days
    ${request}=    Update Nested Dictionary Property    ${request}    Order.Id    ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Ghi Chú ${n} Kí Tự Ở MHQL 
    [Documentation]    Chuẩn bị dữ liệu để cập nhật ghi chú đơn hàng
    ${request}=    Deep Copy    ${request_order_body_update}
    ${order_details}=    Get From Dictionary    ${REQUEST_DATA}    Order
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    ${random_string}=    Generate Random String    ${n}   [LETTERS]
    ${request}=    Update Nested Dictionary Property    ${request}    Order.Id    ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.Description    ${random_string}
    Set Test Variable    ${REQUEST_DATA}    ${request}


Chuẩn Bị Cập Nhật Trạng Thái Đơn Hàng Thành Hoàn Thành MHQL
    [Documentation]    Chuẩn bị dữ liệu để cập nhật trạng thái đơn hàng thành hoàn thành
    ${request}=    Deep Copy    ${request_order_body_update}
    ${order_details}=    Get From Dictionary    ${REQUEST_DATA}    Order
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.Id    ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Complete   ${TRUE}
    Set Test Variable    ${REQUEST_DATA}    ${request}

# =============================================================================
# Keywords xác thực kết quả thành công
# =============================================================================



Chuẩn Bị Dữ Liệu Cập Nhật Người Nhận Đơn Hàng MHQL
    [Documentation]    Chuẩn bị dữ liệu cập nhật thông tin người nhận
    ${request}    Deep Copy   ${request_order_body_update_delivery}
    ${order_details}=    Get From Dictionary    ${REQUEST_DATA}    Order
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    ${request_body}=    Deep Copy    ${delivery_detail_update_body_order}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     OrderId     ${CREATED_ORDER_ID}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     Receiver   Nguyễn Thị B
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     ContactNumber    0912345678
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     Address    456 Đường Lê Lợi, Q3
    ${request}=    Update Nested Dictionary Property    ${request}     Order.Id     ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.DeliveryDetail    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Phí Giao Hàng ${fee} MHQL
    [Documentation]    Chuẩn bị dữ liệu cập nhật phí giao hàng
    ${request}    Deep Copy   ${request_order_body_update_delivery}
    ${order_details}=    Get From Dictionary    ${REQUEST_DATA}    Order
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    ${request_body}=    Deep Copy    ${delivery_detail_update_body_order}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     OrderId     ${CREATED_ORDER_ID}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     Price    ${fee}
    ${request}=    Update Nested Dictionary Property    ${request}     Order.Id     ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.DeliveryDetail    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng ${status} Thu Hộ MHQL
    [Documentation]    Chuẩn bị dữ liệu cập nhật miễn phí giao hàng
    ${using_price_cod}=    Set Variable If    '${status}'=='Có'    1    0
    ${request}    Deep Copy   ${request_order_body_update_delivery}
    ${order_details}=    Get From Dictionary    ${REQUEST_DATA}    Order
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    ${request_body}=    Deep Copy    ${delivery_detail_update_body_order}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     OrderId     ${CREATED_ORDER_ID}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     UsingPriceCod    ${using_price_cod}
    ${request}=    Update Nested Dictionary Property    ${request}     Order.Id     ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.DeliveryDetail    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}


Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Mã Vận Đơn ${tracking_code} MHQL
    [Documentation]    Chuẩn bị dữ liệu cập nhật mã vận đơn
    ${request}    Deep Copy   ${request_order_body_update_delivery}
    ${order_details}=    Get From Dictionary    ${REQUEST_DATA}    Order
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    ${request_body}=    Deep Copy    ${delivery_detail_update_body_order}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     OrderId     ${CREATED_ORDER_ID}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     DeliveryCode    ${tracking_code}
    ${request}=    Update Nested Dictionary Property    ${request}     Order.Id     ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.DeliveryDetail    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Đối Tác Giao Hàng ${delivery_code} Ở MHQL
    [Documentation]    Chuẩn bị dữ liệu cập nhật đối tác giao hàng
    ${delivery_by}=    Lấy Id Đối Tác Giao Hàng Theo Mã    ${delivery_code}
    ${request}    Deep Copy   ${request_order_body_update_delivery}
    ${order_details}=    Get From Dictionary    ${REQUEST_DATA}    Order
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    ${request_body}=    Deep Copy    ${delivery_detail_update_body_order}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     OrderId     ${CREATED_ORDER_ID}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     DeliveryBy    ${delivery_by}
    ${request}=    Update Nested Dictionary Property    ${request}     Order.Id     ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.DeliveryDetail    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Gói Hàng ${x}x${y}x${z}x${w} Ở MHQL
    [Documentation]    Chuẩn bị dữ liệu cập nhật gói hàng
    ${request}    Deep Copy    ${request_order_body_update_delivery}
    ${order_details}=    Get From Dictionary    ${REQUEST_DATA}    Order
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    ${request_body}=    Deep Copy    ${delivery_detail_update_body_order}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    OrderId     ${CREATED_ORDER_ID}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Weight  ${x}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Length  ${y}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Width  ${z}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Height  ${w}
    ${request}=    Update Nested Dictionary Property    ${request}     Order.Id     ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.DeliveryDetail    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Ngày Giao Dự Kiến và Ghi Chú
    [Documentation]    Chuẩn bị dữ liệu cập nhật ngày giao dự kiến
    ${purchase_date}=   Get Current Date    UTC
    ${expected_date}=   Add Time To Date    ${purchase_date}    10 days
    ${note}=    Set Variable    "Dự kiến giao vào ngày"
    ${request}    Deep Copy    ${request_order_body_update_delivery}
    ${order_details}=    Get From Dictionary    ${REQUEST_DATA}    Order
    ${order_details}=    Get From Dictionary    ${order_details}    OrderDetails
    ${request}    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${order_details}
    ${request_body}=    Deep Copy    ${delivery_detail_update_body_order}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     OrderId     ${CREATED_ORDER_ID}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     ExpectedDelivery    ${expected_date}
    ${request_body}=    Update Nested Dictionary Property    ${request_body}     Comments    ${note}
    ${request}=    Update Nested Dictionary Property    ${request}     Order.Id     ${CREATED_ORDER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.DeliveryDetail    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request}




# =============================================================================
# Template Keywords cho test cases
# =============================================================================
