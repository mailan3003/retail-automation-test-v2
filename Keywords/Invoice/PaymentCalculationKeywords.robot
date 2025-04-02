*** Settings ***
Documentation     Keywords cho phần tính giá trị thanh toán khi tạo hóa đơn
Resource          ../../TestData/Invoice/PaymentCalculationData.robot
Resource          ../../TestData/CommonData.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Library           ../../Resources/DatabaseLibrary.py

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    ${invoice_data}=    Create Dictionary
    ...    code=${STANDARD_INVOICE_CODE}
    ...    branchId=${STANDARD_BRANCH_ID}
    ...    customerId=${STANDARD_CUSTOMER_ID}
    ...    customerName=${STANDARD_CUSTOMER_NAME}
    ...    items=@{EMPTY}
    
    ${product}=    Create Dictionary
    ...    productId=${STANDARD_PRODUCT_ID}
    ...    productName=${STANDARD_PRODUCT_NAME}
    ...    quantity=${STANDARD_PRODUCT_QUANTITY}
    ...    price=${STANDARD_PRODUCT_PRICE}
    
    ${payment}=    Create Dictionary
    ...    method=${PAYMENT_CASH}
    ...    amount=${STANDARD_INVOICE_AMOUNT}
    
    Append To List    ${invoice_data}[items]    ${product}
    
    ${payments}=    Create List    ${payment}
    Set To Dictionary    ${invoice_data}    payments=${payments}
    
    Set Test Variable    ${INVOICE_DATA}    ${invoice_data}
    RETURN    ${invoice_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Bằng Thẻ
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    ${payments}=    Create List
    ${payment}=    Create Dictionary
    ...    method=${PAYMENT_CARD}
    ...    amount=${STANDARD_INVOICE_AMOUNT}
    
    Append To List    ${payments}    ${payment}
    Set To Dictionary    ${invoice_data}    payments=${payments}
    
    Set Test Variable    ${INVOICE_DATA}    ${invoice_data}
    RETURN    ${invoice_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Nhiều Phương Thức
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    ${payments}=    Create List
    ${payment_cash}=    Create Dictionary
    ...    method=${PAYMENT_CASH}
    ...    amount=50000
    
    ${payment_card}=    Create Dictionary
    ...    method=${PAYMENT_CARD}
    ...    amount=50000
    
    Append To List    ${payments}    ${payment_cash}
    Append To List    ${payments}    ${payment_card}
    
    Set To Dictionary    ${invoice_data}    payments=${payments}
    
    Set Test Variable    ${INVOICE_DATA}    ${invoice_data}
    RETURN    ${invoice_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Thừa
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    ${payments}=    Create List
    ${payment}=    Create Dictionary
    ...    method=${PAYMENT_CASH}
    ...    amount=120000
    
    Append To List    ${payments}    ${payment}
    Set To Dictionary    ${invoice_data}    payments=${payments}
    
    Set Test Variable    ${INVOICE_DATA}    ${invoice_data}
    RETURN    ${invoice_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Thiếu
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    ${payments}=    Create List
    ${payment}=    Create Dictionary
    ...    method=${PAYMENT_CASH}
    ...    amount=80000
    
    Append To List    ${payments}    ${payment}
    Set To Dictionary    ${invoice_data}    payments=${payments}
    
    Set Test Variable    ${INVOICE_DATA}    ${invoice_data}
    RETURN    ${invoice_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Bằng Điểm
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    Set To Dictionary    ${invoice_data}    customerId=${CUSTOMER_WITH_POINTS_ID}
    Set To Dictionary    ${invoice_data}    customerName=${CUSTOMER_WITH_POINTS_NAME}
    
    ${payments}=    Create List
    ${payment}=    Create Dictionary
    ...    method=${PAYMENT_POINT}
    ...    amount=50000
    ...    points=50
    
    Append To List    ${payments}    ${payment}
    Set To Dictionary    ${invoice_data}    payments=${payments}
    
    Set Test Variable    ${INVOICE_DATA}    ${invoice_data}
    RETURN    ${invoice_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Bằng Voucher
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    ${payments}=    Create List
    ${payment_voucher}=    Create Dictionary
    ...    method=${PAYMENT_VOUCHER}
    ...    amount=20000
    ...    voucherCode=${VOUCHER_CODE}
    
    ${payment_cash}=    Create Dictionary
    ...    method=${PAYMENT_CASH}
    ...    amount=80000
    
    Append To List    ${payments}    ${payment_voucher}
    Append To List    ${payments}    ${payment_cash}
    
    Set To Dictionary    ${invoice_data}    payments=${payments}
    
    Set Test Variable    ${INVOICE_DATA}    ${invoice_data}
    RETURN    ${invoice_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán COD
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    ${payments}=    Create List
    ${payment}=    Create Dictionary
    ...    method=${PAYMENT_COD}
    ...    amount=${STANDARD_INVOICE_AMOUNT}
    
    Append To List    ${payments}    ${payment}
    
    ${delivery_info}=    Create Dictionary
    ...    address=123 Đường Test
    ...    city=Hồ Chí Minh
    ...    district=Quận 1
    ...    contactName=Nguyễn Văn A
    ...    contactPhone=0123456789
    
    Set To Dictionary    ${invoice_data}    payments=${payments}
    Set To Dictionary    ${invoice_data}    deliveryInfo=${delivery_info}
    
    Set Test Variable    ${INVOICE_DATA}    ${invoice_data}
    RETURN    ${invoice_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Có Giảm Giá
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    ${payments}=    Create List
    ${payment}=    Create Dictionary
    ...    method=${PAYMENT_CASH}
    ...    amount=90000
    
    Append To List    ${payments}    ${payment}
    
    Set To Dictionary    ${invoice_data}    discount=${PROMOTION_AMOUNT}
    Set To Dictionary    ${invoice_data}    payments=${payments}
    
    Set Test Variable    ${INVOICE_DATA}    ${invoice_data}
    RETURN    ${invoice_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Có Thuế và Phụ Phí
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    ${payments}=    Create List
    ${payment}=    Create Dictionary
    ...    method=${PAYMENT_CASH}
    ...    amount=115000
    
    Append To List    ${payments}    ${payment}
    
    Set To Dictionary    ${invoice_data}    tax=${TAX_AMOUNT}
    Set To Dictionary    ${invoice_data}    surcharge=${SURCHARGE_AMOUNT}
    Set To Dictionary    ${invoice_data}    payments=${payments}
    
    Set Test Variable    ${INVOICE_DATA}    ${invoice_data}
    RETURN    ${invoice_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Khách Hàng Có Công Nợ Tối Đa
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    Set To Dictionary    ${invoice_data}    customerId=${CUSTOMER_WITH_DEBT_ID}
    Set To Dictionary    ${invoice_data}    customerName=${CUSTOMER_WITH_DEBT_NAME}
    
    ${payments}=    Create List
    Set To Dictionary    ${invoice_data}    payments=${payments}
    
    Set Test Variable    ${INVOICE_DATA}    ${invoice_data}
    RETURN    ${invoice_data}

Chuẩn Bị Dữ Liệu Cập Nhật Thanh Toán Cho Hóa Đơn
    # Đầu tiên tạo hóa đơn với thanh toán một phần
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Thiếu
    Gửi Yêu Cầu Tạo Hóa Đơn
    ${invoice_id}=    Get Response Property    id
    
    # Sau đó chuẩn bị dữ liệu thanh toán bổ sung
    ${update_payment_data}=    Create Dictionary
    ...    invoiceId=${invoice_id}
    ...    payments=@{EMPTY}
    
    ${payment}=    Create Dictionary
    ...    method=${PAYMENT_CASH}
    ...    amount=50000
    
    ${payments}=    Create List    ${payment}
    Set To Dictionary    ${update_payment_data}    payments=${payments}
    
    Set Test Variable    ${UPDATE_PAYMENT_DATA}    ${update_payment_data}
    RETURN    ${update_payment_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Tổng Tiền Bằng 0
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    ${product}=    Create Dictionary
    ...    productId=${STANDARD_PRODUCT_ID}
    ...    productName=${STANDARD_PRODUCT_NAME}
    ...    quantity=${STANDARD_PRODUCT_QUANTITY}
    ...    price=0
    
    ${items}=    Create List    ${product}
    Set To Dictionary    ${invoice_data}    items=${items}
    
    ${payments}=    Create List
    Set To Dictionary    ${invoice_data}    payments=${payments}
    
    Set Test Variable    ${INVOICE_DATA}    ${invoice_data}
    RETURN    ${invoice_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Không Có Thanh Toán
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    ${payments}=    Create List
    Set To Dictionary    ${invoice_data}    payments=${payments}
    
    Set Test Variable    ${INVOICE_DATA}    ${invoice_data}
    RETURN    ${invoice_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Kết Hợp Voucher Và Khuyến Mãi
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    ${payments}=    Create List
    ${payment_voucher}=    Create Dictionary
    ...    method=${PAYMENT_VOUCHER}
    ...    amount=20000
    ...    voucherCode=${VOUCHER_CODE}
    
    ${payment_cash}=    Create Dictionary
    ...    method=${PAYMENT_CASH}
    ...    amount=70000
    
    Append To List    ${payments}    ${payment_voucher}
    Append To List    ${payments}    ${payment_cash}
    
    Set To Dictionary    ${invoice_data}    discount=${PROMOTION_AMOUNT}
    Set To Dictionary    ${invoice_data}    payments=${payments}
    
    Set Test Variable    ${INVOICE_DATA}    ${invoice_data}
    RETURN    ${invoice_data}

Chuẩn Bị Dữ Liệu Hủy Hóa Đơn Đã Thanh Toán
    # Đầu tiên tạo hóa đơn với thanh toán đầy đủ
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    Gửi Yêu Cầu Tạo Hóa Đơn
    ${invoice_id}=    Get Response Property    id
    
    # Sau đó chuẩn bị dữ liệu hủy hóa đơn
    ${cancel_data}=    Create Dictionary
    ...    invoiceId=${invoice_id}
    ...    reason=Test cancel
    
    Set Test Variable    ${CANCEL_DATA}    ${cancel_data}
    RETURN    ${cancel_data}

Chuẩn Bị Dữ Liệu Hủy Hóa Đơn Thanh Toán Một Phần
    # Đầu tiên tạo hóa đơn với thanh toán một phần
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Thiếu
    Gửi Yêu Cầu Tạo Hóa Đơn
    ${invoice_id}=    Get Response Property    id
    
    # Sau đó chuẩn bị dữ liệu hủy hóa đơn
    ${cancel_data}=    Create Dictionary
    ...    invoiceId=${invoice_id}
    ...    reason=Test cancel
    
    Set Test Variable    ${CANCEL_DATA}    ${cancel_data}
    RETURN    ${cancel_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Từ Đơn Đặt Hàng Có Đặt Cọc
    # Giả lập đơn đặt hàng có đặt cọc
    ${order_data}=    Create Dictionary
    ...    orderId=${ORDER_ID}
    ...    depositAmount=${ORDER_DEPOSIT_AMOUNT}
    
    # Chuẩn bị dữ liệu hóa đơn
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    ${payments}=    Create List
    ${payment_deposit}=    Create Dictionary
    ...    method=${PAYMENT_DEPOSIT}
    ...    amount=${ORDER_DEPOSIT_AMOUNT}
    ...    orderId=${ORDER_ID}
    
    ${payment_cash}=    Create Dictionary
    ...    method=${PAYMENT_CASH}
    ...    amount=70000
    
    Append To List    ${payments}    ${payment_deposit}
    Append To List    ${payments}    ${payment_cash}
    
    Set To Dictionary    ${invoice_data}    payments=${payments}
    Set To Dictionary    ${invoice_data}    orderId=${ORDER_ID}
    
    Set Test Variable    ${INVOICE_DATA}    ${invoice_data}
    RETURN    ${invoice_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Nhiều Phiếu
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    ${payments}=    Create List
    ${payment_cash}=    Create Dictionary
    ...    method=${PAYMENT_CASH}
    ...    amount=30000
    
    ${payment_card}=    Create Dictionary
    ...    method=${PAYMENT_CARD}
    ...    amount=40000
    
    ${payment_bank}=    Create Dictionary
    ...    method=${PAYMENT_BANK}
    ...    amount=30000
    
    Append To List    ${payments}    ${payment_cash}
    Append To List    ${payments}    ${payment_card}
    Append To List    ${payments}    ${payment_bank}
    
    Set To Dictionary    ${invoice_data}    payments=${payments}
    
    Set Test Variable    ${INVOICE_DATA}    ${invoice_data}
    RETURN    ${invoice_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Trễ Hạn
    # Giả lập hóa đơn trễ hạn thanh toán
    ${invoice_data}=    Create Dictionary
    ...    id=${INVOICE_WITH_LATE_PAYMENT_ID}
    ...    code=${STANDARD_INVOICE_CODE}
    ...    branchId=${STANDARD_BRANCH_ID}
    ...    customerId=${STANDARD_CUSTOMER_ID}
    ...    customerName=${STANDARD_CUSTOMER_NAME}
    ...    total=${STANDARD_INVOICE_AMOUNT}
    ...    paymentDueDate=${LATE_PAYMENT_DUE_DATE}
    ...    paymentStatus=3
    ...    debt=${STANDARD_INVOICE_AMOUNT}
    ...    totalPayment=0
    
    # Chuẩn bị dữ liệu thanh toán
    ${update_payment_data}=    Create Dictionary
    ...    invoiceId=${INVOICE_WITH_LATE_PAYMENT_ID}
    ...    payments=@{EMPTY}
    
    ${payment}=    Create Dictionary
    ...    method=${PAYMENT_CASH}
    ...    amount=${STANDARD_INVOICE_AMOUNT}
    
    ${payments}=    Create List    ${payment}
    Set To Dictionary    ${update_payment_data}    payments=${payments}
    
    Set Test Variable    ${UPDATE_PAYMENT_DATA}    ${update_payment_data}
    RETURN    ${update_payment_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Nhiều Sản Phẩm
    ${invoice_data}=    Create Dictionary
    ...    code=${STANDARD_INVOICE_CODE}
    ...    branchId=${STANDARD_BRANCH_ID}
    ...    customerId=${STANDARD_CUSTOMER_ID}
    ...    customerName=${STANDARD_CUSTOMER_NAME}
    ...    items=@{EMPTY}
    
    ${product1}=    Create Dictionary
    ...    productId=${MULTIPLE_PRODUCT_1_ID}
    ...    productName=${MULTIPLE_PRODUCT_1_NAME}
    ...    quantity=${MULTIPLE_PRODUCT_1_QUANTITY}
    ...    price=${MULTIPLE_PRODUCT_1_PRICE}
    
    ${product2}=    Create Dictionary
    ...    productId=${MULTIPLE_PRODUCT_2_ID}
    ...    productName=${MULTIPLE_PRODUCT_2_NAME}
    ...    quantity=${MULTIPLE_PRODUCT_2_QUANTITY}
    ...    price=${MULTIPLE_PRODUCT_2_PRICE}
    
    ${product3}=    Create Dictionary
    ...    productId=${MULTIPLE_PRODUCT_3_ID}
    ...    productName=${MULTIPLE_PRODUCT_3_NAME}
    ...    quantity=${MULTIPLE_PRODUCT_3_QUANTITY}
    ...    price=${MULTIPLE_PRODUCT_3_PRICE}
    
    ${items}=    Create List    ${product1}    ${product2}    ${product3}
    Set To Dictionary    ${invoice_data}    items=${items}
    
    ${total_amount}=    Evaluate    ${MULTIPLE_PRODUCT_1_PRICE} * ${MULTIPLE_PRODUCT_1_QUANTITY} + ${MULTIPLE_PRODUCT_2_PRICE} * ${MULTIPLE_PRODUCT_2_QUANTITY} + ${MULTIPLE_PRODUCT_3_PRICE} * ${MULTIPLE_PRODUCT_3_QUANTITY}
    
    ${payment}=    Create Dictionary
    ...    method=${PAYMENT_CASH}
    ...    amount=${total_amount}
    
    ${payments}=    Create List    ${payment}
    Set To Dictionary    ${invoice_data}    payments=${payments}
    
    Set Test Variable    ${INVOICE_DATA}    ${invoice_data}
    RETURN    ${invoice_data}

Gửi Yêu Cầu Tạo Hóa Đơn
    ${headers}=    Create Auth Headers
    ${response}=    Call API POST    ${API_BASE_URL}/api/invoices    ${INVOICE_DATA}    ${headers}
    Status Should Be    200    ${response}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}

Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Đặt Hàng
    ${headers}=    Create Auth Headers
    ${response}=    Call API POST    ${API_BASE_URL}/api/invoices/from-order    ${INVOICE_DATA}    ${headers}
    Status Should Be    200    ${response}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}

Gửi Yêu Cầu Cập Nhật Thanh Toán
    ${headers}=    Create Auth Headers
    ${response}=    Call API PUT    ${API_BASE_URL}/api/invoices/payment    ${UPDATE_PAYMENT_DATA}    ${headers}
    Status Should Be    200    ${response}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}

Gửi Yêu Cầu Hủy Hóa Đơn
    ${headers}=    Create Auth Headers
    ${response}=    Call API POST    ${API_BASE_URL}/api/invoices/cancel    ${CANCEL_DATA}    ${headers}
    Status Should Be    200    ${response}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}

Tổng tiền thanh toán của hóa đơn là ${amount}
    ${invoice_id}=    Get Response Property    id
    ${total_payment}=    Query Database    SELECT total_payment FROM invoices WHERE id = '${invoice_id}'
    Should Be Equal As Numbers    ${total_payment}    ${amount}

Tiền nợ của hóa đơn là ${amount}
    ${invoice_id}=    Get Response Property    id
    ${debt}=    Query Database    SELECT debt FROM invoices WHERE id = '${invoice_id}'
    Should Be Equal As Numbers    ${debt}    ${amount}

Tiền thừa của hóa đơn là ${amount}
    ${invoice_id}=    Get Response Property    id
    ${overpayment}=    Query Database    SELECT overpayment FROM invoices WHERE id = '${invoice_id}'
    Should Be Equal As Numbers    ${overpayment}    ${amount}

Trạng thái thanh toán của hóa đơn là ${status}
    ${invoice_id}=    Get Response Property    id
    ${payment_status}=    Query Database    SELECT payment_status FROM invoices WHERE id = '${invoice_id}'
    Should Be Equal As Numbers    ${payment_status}    ${status}

Trạng thái của hóa đơn là ${status}
    ${invoice_id}=    Get From Dictionary    ${CANCEL_DATA}    invoiceId
    ${invoice_status}=    Query Database    SELECT status FROM invoices WHERE id = '${invoice_id}'
    Should Be Equal As Strings    ${invoice_status}    ${status}

Trạng thái thanh toán trễ là ${status}
    ${invoice_id}=    Get From Dictionary    ${UPDATE_PAYMENT_DATA}    invoiceId
    ${is_late_payment}=    Query Database    SELECT is_late_payment FROM invoices WHERE id = '${invoice_id}'
    ${bool_status}=    Convert To Boolean    ${status}
    ${bool_is_late_payment}=    Convert To Boolean    ${is_late_payment}
    Should Be Equal    ${bool_is_late_payment}    ${bool_status}

Số lượng thanh toán của hóa đơn là ${count}
    ${invoice_id}=    Get Response Property    id
    ${payment_count}=    Query Database    SELECT COUNT(*) FROM invoice_payments WHERE invoice_id = '${invoice_id}'
    Should Be Equal As Numbers    ${payment_count}    ${count}

Thanh toán ${method} có số tiền ${amount}
    ${invoice_id}=    Get Response Property    id
    ${payment_amount}=    Query Database    SELECT amount FROM invoice_payments WHERE invoice_id = '${invoice_id}' AND method = '${method}'
    Should Be Equal As Numbers    ${payment_amount}    ${amount}

Phiếu thu được tạo với số tiền ${amount}
    ${invoice_id}=    Get Response Property    id
    ${receipt_amount}=    Query Database    SELECT amount FROM receipts WHERE invoice_id = '${invoice_id}'
    Should Be Equal As Numbers    ${receipt_amount}    ${amount}

Phiếu chi được tạo với số tiền ${amount}
    ${invoice_id}=    Get From Dictionary    ${CANCEL_DATA}    invoiceId
    ${payment_amount}=    Query Database    SELECT amount FROM payments WHERE invoice_id = '${invoice_id}'
    Should Be Equal As Numbers    ${payment_amount}    ${amount}

Không có phiếu thu nào được tạo
    ${invoice_id}=    Get Response Property    id
    ${receipt_count}=    Query Database    SELECT COUNT(*) FROM receipts WHERE invoice_id = '${invoice_id}'
    Should Be Equal As Numbers    ${receipt_count}    0

Công nợ của khách hàng tăng ${amount}
    ${invoice_id}=    Get Response Property    id
    ${customer_id}=    Query Database    SELECT customer_id FROM invoices WHERE id = '${invoice_id}'
    ${debt_amount}=    Query Database    SELECT debt_amount FROM customer_debt WHERE customer_id = '${customer_id}' AND invoice_id = '${invoice_id}'
    Should Be Equal As Numbers    ${debt_amount}    ${amount}

Công nợ của khách hàng giảm ${amount}
    ${invoice_id}=    Get From Dictionary    ${CANCEL_DATA}    invoiceId
    ${customer_id}=    Query Database    SELECT customer_id FROM invoices WHERE id = '${invoice_id}'
    ${debt_reduction}=    Query Database    SELECT debt_reduction FROM customer_debt_history WHERE customer_id = '${customer_id}' AND invoice_id = '${invoice_id}'
    Should Be Equal As Numbers    ${debt_reduction}    ${amount}

Tổng tiền của hóa đơn là ${amount}
    ${invoice_id}=    Get Response Property    id
    ${total}=    Query Database    SELECT total FROM invoices WHERE id = '${invoice_id}'
    Should Be Equal As Numbers    ${total}    ${amount}

Tiền giảm giá của hóa đơn là ${amount}
    ${invoice_id}=    Get Response Property    id
    ${discount_amount}=    Query Database    SELECT discount FROM invoices WHERE id = '${invoice_id}'
    Should Be Equal As Numbers    ${discount_amount}    ${amount}

Voucher ${voucher_code} được sử dụng với giá trị ${amount}
    ${invoice_id}=    Get Response Property    id
    ${voucher_amount}=    Query Database    SELECT amount FROM invoice_payments WHERE invoice_id = '${invoice_id}' AND voucher_code = '${voucher_code}'
    Should Be Equal As Numbers    ${voucher_amount}    ${amount}

Khách hàng sử dụng ${points} điểm để thanh toán
    ${invoice_id}=    Get Response Property    id
    ${used_points}=    Query Database    SELECT points FROM invoice_payments WHERE invoice_id = '${invoice_id}' AND method = 'Point'
    Should Be Equal As Numbers    ${used_points}    ${points}

Đơn đặt hàng được liên kết với hóa đơn
    ${invoice_id}=    Get Response Property    id
    ${order_id}=    Query Database    SELECT order_id FROM invoices WHERE id = '${invoice_id}'
    Should Be Equal As Strings    ${order_id}    ${ORDER_ID} 