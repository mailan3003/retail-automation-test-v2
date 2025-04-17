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

Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Thừa Cấu Hình ChangeToDebt True
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    ${payments}=    Create List
    ${payment}=    Create Dictionary
    ...    method=${PAYMENT_CASH}
    ...    amount=120000
    
    Append To List    ${payments}    ${payment}
    Set To Dictionary    ${invoice_data}    payments=${payments}
    
    # Set setting ChangeToDebt=true via SQL query
    ${query}=    Set Variable    UPDATE PosSetting SET ChangeToDebt = 1 WHERE RetailerId = ${RETAILER_ID}
    Execute Query    ${query}
    
    Set Test Variable    ${INVOICE_DATA}    ${invoice_data}
    RETURN    ${invoice_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Thừa Cấu Hình ChangeToDebt False
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    ${payments}=    Create List
    ${payment}=    Create Dictionary
    ...    method=${PAYMENT_CASH}
    ...    amount=120000
    
    Append To List    ${payments}    ${payment}
    Set To Dictionary    ${invoice_data}    payments=${payments}
    
    # Set setting ChangeToDebt=false via SQL query
    ${query}=    Set Variable    UPDATE PosSetting SET ChangeToDebt = 0 WHERE RetailerId = ${RETAILER_ID}
    Execute Query    ${query}
    
    Set Test Variable    ${INVOICE_DATA}    ${invoice_data}
    RETURN    ${invoice_data}

Chuẩn Bị Dữ Liệu Hủy Hóa Đơn Thanh Toán Nhiều Phương Thức
    # First create an invoice with multiple payment methods
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Nhiều Phương Thức
    Gửi Yêu Cầu Tạo Hóa Đơn
    ${invoice_id}=    Get Response Property    id
    
    # Prepare data for void request
    ${void_data}=    Create Dictionary
    ...    id=${invoice_id}
    ...    voidReason=Test void invoice
    ...    voidType=1
    
    Set Test Variable    ${VOID_DATA}    ${void_data}
    RETURN    ${void_data}

Gửi Yêu Cầu Hủy Hóa Đơn
    ${response}=    Call API    invoices/void    ${VOID_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    
Số dư của khách hàng tăng
    [Arguments]    ${amount}
    ${query}=    Set Variable    SELECT Surplus FROM Customer WHERE Id = ${INVOICE_DATA}[customerId] AND RetailerId = ${RETAILER_ID}
    ${surplus}=    Query One    ${query}
    Should Be Greater Than Or Equal To    ${surplus}[0]    ${amount}

Không có phiếu chi nào được tạo
    ${invoice_id}=    Get Response Property    id
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ${invoice_id} AND Amount < 0 AND RetailerId = ${RETAILER_ID}
    ${payment_count}=    Query One    ${query}
    Should Be Equal As Numbers    ${payment_count}[0]    0

Trạng thái của hóa đơn là Đã hủy
    ${invoice_id}=    Get Response Property    id
    ${query}=    Set Variable    SELECT Status FROM Invoice WHERE Id = ${invoice_id} AND RetailerId = ${RETAILER_ID}
    ${status}=    Query One    ${query}
    Should Be Equal As Numbers    ${status}[0]    -1

Giao dịch tài khoản ngân hàng được tạo với số tiền
    [Arguments]    ${amount}
    ${invoice_id}=    Get Response Property    id
    ${query}=    Set Variable    SELECT COUNT(*) FROM AccountTransaction WHERE Amount = ${amount} AND RefId = '${invoice_id}' AND RetailerId = ${RETAILER_ID}
    ${transaction_count}=    Query One    ${query}
    Should Be Equal As Numbers    ${transaction_count}[0]    1

Chuẩn Bị Dữ Liệu Hủy Hóa Đơn Thanh Toán Bằng Điểm Thưởng
    # First create an invoice with points payment
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Bằng Điểm
    
    # Add cash payment to complete the total
    ${payment_cash}=    Create Dictionary
    ...    method=${PAYMENT_CASH}
    ...    amount=50000
    
    Append To List    ${invoice_data}[payments]    ${payment_cash}
    
    Gửi Yêu Cầu Tạo Hóa Đơn
    ${invoice_id}=    Get Response Property    id
    
    # Prepare data for void request
    ${void_data}=    Create Dictionary
    ...    id=${invoice_id}
    ...    voidReason=Test void invoice with points
    ...    voidType=1
    
    Set Test Variable    ${VOID_DATA}    ${void_data}
    RETURN    ${void_data}

Chuẩn Bị Dữ Liệu Hủy Hóa Đơn Thanh Toán Bằng Voucher
    # First create an invoice with voucher payment
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Bằng Voucher
    Gửi Yêu Cầu Tạo Hóa Đơn
    ${invoice_id}=    Get Response Property    id
    
    # Prepare data for void request
    ${void_data}=    Create Dictionary
    ...    id=${invoice_id}
    ...    voidReason=Test void invoice with voucher
    ...    voidType=1
    
    Set Test Variable    ${VOID_DATA}    ${void_data}
    RETURN    ${void_data}

Chuẩn Bị Dữ Liệu Hủy Hóa Đơn Thanh Toán COD
    # First create an invoice with COD payment
    ${invoice_data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán COD
    Gửi Yêu Cầu Tạo Hóa Đơn
    ${invoice_id}=    Get Response Property    id
    
    # Prepare data for void request
    ${void_data}=    Create Dictionary
    ...    id=${invoice_id}
    ...    voidReason=Test void invoice with COD
    ...    voidType=1
    
    Set Test Variable    ${VOID_DATA}    ${void_data}
    RETURN    ${void_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Từ Đơn Đặt Hàng Có Đặt Cọc Vượt Quá Tổng Tiền
    # First create an order with deposit
    ${order_data}=    Create Dictionary
    ...    code=ORD${SUITE_NAME}${TEST_NAME}
    ...    branchId=${STANDARD_BRANCH_ID}
    ...    customerId=${STANDARD_CUSTOMER_ID}
    ...    customerName=${STANDARD_CUSTOMER_NAME}
    ...    total=150000
    ...    deposit=100000
    ...    items=@{EMPTY}
    
    ${product}=    Create Dictionary
    ...    productId=${STANDARD_PRODUCT_ID}
    ...    productName=${STANDARD_PRODUCT_NAME}
    ...    quantity=${STANDARD_PRODUCT_QUANTITY}
    ...    price=150000
    
    Append To List    ${order_data}[items]    ${product}
    
    ${order_response}=    Call API    orders    ${order_data}
    ${order_id}=    Get Property From Response    ${order_response}    id
    
    # Then prepare invoice data from this order but with lower total
    ${invoice_data}=    Create Dictionary
    ...    orderId=${order_id}
    ...    code=INV${SUITE_NAME}${TEST_NAME}
    ...    branchId=${STANDARD_BRANCH_ID}
    ...    customerId=${STANDARD_CUSTOMER_ID}
    ...    customerName=${STANDARD_CUSTOMER_NAME}
    ...    total=80000
    ...    items=@{EMPTY}
    
    ${product_invoice}=    Create Dictionary
    ...    productId=${STANDARD_PRODUCT_ID}
    ...    productName=${STANDARD_PRODUCT_NAME}
    ...    quantity=${STANDARD_PRODUCT_QUANTITY}
    ...    price=80000
    
    Append To List    ${invoice_data}[items]    ${product_invoice}
    
    Set Test Variable    ${INVOICE_DATA}    ${invoice_data}
    RETURN    ${invoice_data}

Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Đặt Hàng
    ${response}=    Call API    invoices/fromorder    ${INVOICE_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    ${invoice_id}=    Set Variable If    ${RESPONSE.status_code} == 200    ${RESPONSE.json()["Id"]}    0
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}

Chuẩn Bị Dữ Liệu Hủy Đơn Đặt Hàng Có Đặt Cọc
    # First create an order with deposit
    ${order_data}=    Create Dictionary
    ...    code=ORD${SUITE_NAME}${TEST_NAME}
    ...    branchId=${STANDARD_BRANCH_ID}
    ...    customerId=${STANDARD_CUSTOMER_ID}
    ...    customerName=${STANDARD_CUSTOMER_NAME}
    ...    total=100000
    ...    deposit=50000
    ...    items=@{EMPTY}
    
    ${product}=    Create Dictionary
    ...    productId=${STANDARD_PRODUCT_ID}
    ...    productName=${STANDARD_PRODUCT_NAME}
    ...    quantity=${STANDARD_PRODUCT_QUANTITY}
    ...    price=100000
    
    Append To List    ${order_data}[items]    ${product}
    
    ${order_response}=    Call API    orders    ${order_data}
    ${order_id}=    Get Property From Response    ${order_response}    id
    
    # Prepare data for void order request
    ${void_data}=    Create Dictionary
    ...    id=${order_id}
    ...    voidReason=Test void order with deposit
    ...    voidType=1
    
    Set Test Variable    ${VOID_DATA}    ${void_data}
    RETURN    ${void_data}

Gửi Yêu Cầu Hủy Đơn Đặt Hàng
    ${response}=    Call API    orders/void    ${VOID_DATA}
    Set Test Variable    ${RESPONSE}    ${response}

Điểm thưởng của khách hàng tăng
    [Arguments]    ${points}
    ${query}=    Set Variable    SELECT Point FROM Customer WHERE Id = ${INVOICE_DATA}[customerId] AND RetailerId = ${RETAILER_ID}
    ${customer_points}=    Query One    ${query}
    Should Be Greater Than Or Equal To    ${customer_points}[0]    ${points}

Trạng thái voucher ${voucher_code} được cập nhật thành chưa sử dụng
    ${query}=    Set Variable    SELECT Status FROM Voucher WHERE Code = '${voucher_code}' AND RetailerId = ${RETAILER_ID}
    ${status}=    Query One    ${query}
    Should Be Equal As Numbers    ${status}[0]    0

Trạng thái giao hàng là Đã hủy
    ${invoice_id}=    Get Response Property    id
    ${query}=    Set Variable    SELECT Status FROM DeliveryInfo WHERE InvoiceId = ${invoice_id} AND RetailerId = ${RETAILER_ID}
    ${status}=    Query One    ${query}
    Should Be Equal As Numbers    ${status}[0]    -1

Đơn đặt hàng được liên kết với hóa đơn
    ${invoice_id}=    Get Response Property    id
    ${query}=    Set Variable    SELECT OrderId FROM Invoice WHERE Id = ${invoice_id} AND RetailerId = ${RETAILER_ID}
    ${order_id}=    Query One    ${query}
    Should Not Be Equal As Numbers    ${order_id}[0]    0

Trạng thái của đơn đặt hàng là Đã hủy
    ${order_id}=    Get Response Property    id
    ${query}=    Set Variable    SELECT Status FROM Orders WHERE Id = ${order_id} AND RetailerId = ${RETAILER_ID}
    ${status}=    Query One    ${query}
    Should Be Equal As Numbers    ${status}[0]    -1

Get Response Property
    [Arguments]    ${property_name}
    ${property_value}=    Set Variable    ${RESPONSE.json()["${property_name}"]}
    RETURN    ${property_value}

Get Property From Response
    [Arguments]    ${response}    ${property_name}
    ${property_value}=    Set Variable    ${response.json()["${property_name}"]}
    RETURN    ${property_value}

Tiền thừa của hóa đơn là
    [Arguments]    ${expected_change}
    ${invoice_id}=    Get Response Property    id
    ${query}=    Set Variable    SELECT ReturnAmount FROM Invoice WHERE Id = ${invoice_id} AND RetailerId = ${RETAILER_ID}
    ${change}=    Query One    ${query}
    Should Be Equal As Numbers    ${change}[0]    ${expected_change}

Tổng tiền của hóa đơn là
    [Arguments]    ${expected_total}
    ${invoice_id}=    Get Response Property    id
    ${query}=    Set Variable    SELECT Total FROM Invoice WHERE Id = ${invoice_id} AND RetailerId = ${RETAILER_ID}
    ${total}=    Query One    ${query}
    Should Be Equal As Numbers    ${total}[0]    ${expected_total}

Tiền giảm giá của hóa đơn là
    [Arguments]    ${expected_discount}
    ${invoice_id}=    Get Response Property    id
    ${query}=    Set Variable    SELECT Discount FROM Invoice WHERE Id = ${invoice_id} AND RetailerId = ${RETAILER_ID}
    ${discount}=    Query One    ${query}
    Should Be Equal As Numbers    ${discount}[0]    ${expected_discount}

Tổng tiền thanh toán của hóa đơn là
    [Arguments]    ${expected_payment}
    ${invoice_id}=    Get Response Property    id
    ${query}=    Set Variable    SELECT SUM(Amount) FROM Payment WHERE InvoiceId = ${invoice_id} AND Amount > 0 AND RetailerId = ${RETAILER_ID}
    ${payment_total}=    Query One    ${query}
    Should Be Equal As Numbers    ${payment_total}[0]    ${expected_payment}

Tiền nợ của hóa đơn là
    [Arguments]    ${expected_debt}
    ${invoice_id}=    Get Response Property    id
    ${query}=    Set Variable    SELECT Debt FROM Invoice WHERE Id = ${invoice_id} AND RetailerId = ${RETAILER_ID}
    ${debt}=    Query One    ${query}
    Should Be Equal As Numbers    ${debt}[0]    ${expected_debt}

Trạng thái thanh toán của hóa đơn là
    [Arguments]    ${expected_status}
    ${invoice_id}=    Get Response Property    id
    ${query}=    Set Variable    SELECT PaidState FROM Invoice WHERE Id = ${invoice_id} AND RetailerId = ${RETAILER_ID}
    ${status}=    Query One    ${query}
    Should Be Equal As Numbers    ${status}[0]    ${expected_status}

Phiếu thu được tạo với số tiền
    [Arguments]    ${expected_amount}
    ${invoice_id}=    Get Response Property    id
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ${invoice_id} AND Amount = ${expected_amount} AND Method = 'Cash' AND RetailerId = ${RETAILER_ID}
    ${payment_count}=    Query One    ${query}
    Should Be Equal As Numbers    ${payment_count}[0]    1

Phiếu chi được tạo với số tiền
    [Arguments]    ${expected_amount}
    ${invoice_id}=    Get Response Property    id
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ${invoice_id} AND Amount = -${expected_amount} AND Method = 'Cash' AND RetailerId = ${RETAILER_ID}
    ${payment_count}=    Query One    ${query}
    Should Be Equal As Numbers    ${payment_count}[0]    1

Thanh toán ${method} có số tiền
    [Arguments]    ${expected_amount}
    ${invoice_id}=    Get Response Property    id
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ${invoice_id} AND Amount = ${expected_amount} AND Method = '${method}' AND RetailerId = ${RETAILER_ID}
    ${payment_count}=    Query One    ${query}
    Should Be Equal As Numbers    ${payment_count}[0]    1

Số lượng thanh toán của hóa đơn là
    [Arguments]    ${expected_count}
    ${invoice_id}=    Get Response Property    id
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ${invoice_id} AND RetailerId = ${RETAILER_ID}
    ${payment_count}=    Query One    ${query}
    Should Be Equal As Numbers    ${payment_count}[0]    ${expected_count}

Khách hàng sử dụng ${points} điểm để thanh toán
    ${invoice_id}=    Get Response Property    id
    ${query}=    Set Variable    SELECT PointUsed FROM Invoice WHERE Id = ${invoice_id} AND RetailerId = ${RETAILER_ID}
    ${points_used}=    Query One    ${query}
    Should Be Equal As Numbers    ${points_used}[0]    ${points}

Voucher ${voucher_code} được sử dụng với giá trị
    [Arguments]    ${expected_amount}
    ${invoice_id}=    Get Response Property    id
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ${invoice_id} AND Amount = ${expected_amount} AND Method = 'Voucher' AND RetailerId = ${RETAILER_ID}
    ${payment_count}=    Query One    ${query}
    Should Be Equal As Numbers    ${payment_count}[0]    1

Công nợ của khách hàng tăng
    [Arguments]    ${expected_amount}
    ${invoice_id}=    Get Response Property    id
    ${query}=    Set Variable    SELECT CustomerDebt FROM Invoice WHERE Id = ${invoice_id} AND RetailerId = ${RETAILER_ID}
    ${debt}=    Query One    ${query}
    Should Be Equal As Numbers    ${debt}[0]    ${expected_amount}

Công nợ của khách hàng giảm
    [Arguments]    ${expected_amount}
    ${invoice_id}=    Get Response Property    id
    ${query}=    Set Variable    SELECT CustomerDebtDecrement FROM Invoice WHERE Id = ${invoice_id} AND RetailerId = ${RETAILER_ID}
    ${debt_decrement}=    Query One    ${query}
    Should Be Equal As Numbers    ${debt_decrement}[0]    ${expected_amount} 