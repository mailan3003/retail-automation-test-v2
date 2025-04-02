*** Settings ***
Documentation     Dữ liệu test cho phần xử lý hoàn tiền khi tạo hóa đơn
Resource          ../CommonData.robot

*** Variables ***
# Cấu hình cho việc chuyển đổi tiền thừa
${SETTING_CHANGE_TO_DEBT_ENABLED}       ${TRUE}
${SETTING_CHANGE_TO_DEBT_DISABLED}      ${FALSE}

# Cấu trúc hóa đơn cơ bản
&{STANDARD_INVOICE}    Code=INVTEST     BranchId=${BRANCH_ID}      SoldById=${DEFAULT_STAFF_ID}
...                    CustomerId=${DEFAULT_CUSTOMER_ID}     Total=100000        Discount=0   
...                    Status=1     PurchaseDate=${PURCHASE_DATE}

# Chi tiết hóa đơn
&{DETAIL_PRODUCT_1}    ProductId=${PRODUCT_1}     Quantity=1      Price=100000    IsSerialTracking=${FALSE}
...                    Discount=0    DiscountRatio=0    TaxId=${DEFAULT_TAX_ID}

@{STANDARD_INVOICE_DETAILS}    ${DETAIL_PRODUCT_1}

# Phương thức thanh toán
&{PAYMENT_CASH_100000}     Method=${PAYMENT_METHOD_CASH}      Amount=100000
&{PAYMENT_CASH_120000}     Method=${PAYMENT_METHOD_CASH}      Amount=120000
&{PAYMENT_CASH_150000}     Method=${PAYMENT_METHOD_CASH}      Amount=150000
&{PAYMENT_CASH_500000}     Method=${PAYMENT_METHOD_CASH}      Amount=500000
&{PAYMENT_CASH_100100}     Method=${PAYMENT_METHOD_CASH}      Amount=100100
&{PAYMENT_CASH_70000}      Method=${PAYMENT_METHOD_CASH}      Amount=70000

&{PAYMENT_CARD_50000}      Method=${PAYMENT_METHOD_CARD}      Amount=50000
&{PAYMENT_CARD_120000}     Method=${PAYMENT_METHOD_CARD}      Amount=120000

# Danh sách thanh toán
@{PAYMENT_LIST_CASH_100000}              ${PAYMENT_CASH_100000}
@{PAYMENT_LIST_CASH_120000}              ${PAYMENT_CASH_120000}
@{PAYMENT_LIST_MIXED_CASH_CARD}          ${PAYMENT_CASH_70000}     ${PAYMENT_CARD_50000}

# Request data mẫu cho các tình huống thanh toán thừa
&{REQUEST_NO_OVERPAYMENT}       Invoice=${STANDARD_INVOICE}    InvoiceDetails=${STANDARD_INVOICE_DETAILS}    PaymentList=${PAYMENT_LIST_CASH_100000}
&{REQUEST_OVERPAYMENT_CASH}     Invoice=${STANDARD_INVOICE}    InvoiceDetails=${STANDARD_INVOICE_DETAILS}    PaymentList=${PAYMENT_LIST_CASH_120000}
&{REQUEST_OVERPAYMENT_MIXED}    Invoice=${STANDARD_INVOICE}    InvoiceDetails=${STANDARD_INVOICE_DETAILS}    PaymentList=${PAYMENT_LIST_MIXED_CASH_CARD}

# Dữ liệu thanh toán tiêu chuẩn
@{STANDARD_PAYMENT_CASH}
...    &{CASH_PAYMENT}

# Thanh toán vượt quá tổng tiền hóa đơn (100,000 + 20,000 = 120,000)
&{OVERPAYMENT_CASH}
...    Method=Cash
...    Amount=120000

# Thanh toán vượt quá tổng tiền với nhiều phương thức
&{OVERPAYMENT_MIXED_CASH}
...    Method=Cash
...    Amount=70000

&{OVERPAYMENT_MIXED_CARD}
...    Method=Card
...    Amount=50000
...    AccountId=${DEFAULT_BANK_ACCOUNT_ID}

# Dữ liệu yêu cầu tiêu chuẩn
&{STANDARD_INVOICE_REQUEST}
...    Invoice=&{STANDARD_INVOICE}
...    Payments=@{STANDARD_PAYMENT_CASH}

# Yêu cầu tạo hóa đơn với thanh toán vượt quá
&{OVERPAYMENT_INVOICE_REQUEST}
...    Invoice=&{STANDARD_INVOICE}
...    Payments=&{OVERPAYMENT_CASH}

# Yêu cầu tạo hóa đơn với nhiều phương thức thanh toán vượt quá
@{OVERPAYMENT_MIXED_METHODS}
...    &{OVERPAYMENT_MIXED_CASH}
...    &{OVERPAYMENT_MIXED_CARD}

&{OVERPAYMENT_MIXED_REQUEST}
...    Invoice=&{STANDARD_INVOICE}
...    Payments=@{OVERPAYMENT_MIXED_METHODS}

# Yêu cầu tạo hóa đơn với khách hàng là khách lẻ (không có khách hàng)
&{STANDARD_INVOICE_NO_CUSTOMER}    
...    Code=HOA_DON_TEST
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=0
...    Total=100000
...    Discount=0
...    Status=1
...    PurchaseDate=2023-09-01T00:00:00

&{OVERPAYMENT_NO_CUSTOMER_REQUEST}
...    Invoice=&{STANDARD_INVOICE_NO_CUSTOMER}
...    Payments=&{OVERPAYMENT_CASH}

# Yêu cầu tạo hóa đơn với tiền thừa nhỏ
&{SMALL_OVERPAYMENT_CASH}
...    Method=Cash
...    Amount=100100

&{SMALL_OVERPAYMENT_REQUEST}
...    Invoice=&{STANDARD_INVOICE}
...    Payments=&{SMALL_OVERPAYMENT_CASH}

# Yêu cầu tạo hóa đơn với tiền thừa lớn
&{LARGE_OVERPAYMENT_CASH}
...    Method=Cash
...    Amount=500000

&{LARGE_OVERPAYMENT_REQUEST}
...    Invoice=&{STANDARD_INVOICE}
...    Payments=&{LARGE_OVERPAYMENT_CASH} 