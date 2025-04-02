*** Settings ***
Resource    ../CommonData.robot

*** Variables ***
# Cấu hình tích điểm và công nợ
${MONEY_PER_POINT}    10000
${POINT_TO_MONEY}     100
${STANDARD_DEBT_AMOUNT}    50000

# Dữ liệu hóa đơn tiêu chuẩn
@{STANDARD_INVOICE_DETAILS}
...    &{PRODUCT_1_DETAILS}

&{STANDARD_INVOICE}
...    Code=HD_TEST_DEBTPOINT001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000

# Dữ liệu thanh toán
&{CASH_PAYMENT_50K}
...    Method=${PAYMENT_CASH}
...    Amount=50000

&{CASH_PAYMENT_FULL}
...    Method=${PAYMENT_CASH}
...    Amount=100000

&{CASH_PAYMENT_EXCESS}
...    Method=${PAYMENT_CASH}
...    Amount=150000

&{POINT_PAYMENT_DETAILS}
...    Method=Point
...    Amount=20000

# Khách hàng có công nợ
&{CUSTOMER_WITH_DEBT}
...    Id=${DEBT_CUSTOMER_ID}
...    Debt=50000

# Hóa đơn với khách hàng có công nợ
&{DEBT_CUSTOMER_INVOICE}
...    Code=HD_TEST_DEBTPOINT002
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEBT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000
...    CustomerDebt=50000

# Hóa đơn với thanh toán một phần
&{PARTIAL_PAYMENT_INVOICE}
...    Code=HD_TEST_DEBTPOINT003
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000

# Hóa đơn thanh toán đầy đủ
&{FULL_PAYMENT_INVOICE}
...    Code=HD_TEST_DEBTPOINT004
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000

# Hóa đơn thanh toán thừa
&{EXCESS_PAYMENT_INVOICE}
...    Code=HD_TEST_DEBTPOINT005
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000

# Hóa đơn với tích điểm và công nợ
&{POINT_AND_DEBT_INVOICE}
...    Code=HD_TEST_DEBTPOINT006
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000
...    RewardPoint_Type=Invoice
...    MoneyPerPoint=${MONEY_PER_POINT}

# Hóa đơn thanh toán bằng điểm
&{PAYMENT_WITH_POINT_INVOICE}
...    Code=HD_TEST_DEBTPOINT007
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000
...    RewardPoint_Type=Invoice
...    MoneyPerPoint=${MONEY_PER_POINT}

# Hóa đơn với sản phẩm có điểm
&{PRODUCT_WITH_POINT}
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    Point=5

&{PRODUCT_POINT_INVOICE}
...    Code=HD_TEST_DEBTPOINT008
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000
...    RewardPoint_Type=Product

# Request templates
&{NO_PAYMENT_INVOICE_REQUEST}
...    Invoice=${STANDARD_INVOICE}
...    Payments=@{EMPTY}

&{PARTIAL_PAYMENT_INVOICE_REQUEST}
...    Invoice=${PARTIAL_PAYMENT_INVOICE}
...    Payments=@{CASH_PAYMENT_50K}

&{FULL_PAYMENT_INVOICE_REQUEST}
...    Invoice=${FULL_PAYMENT_INVOICE}
...    Payments=@{CASH_PAYMENT_FULL}

&{EXCESS_PAYMENT_INVOICE_REQUEST}
...    Invoice=${EXCESS_PAYMENT_INVOICE}
...    Payments=@{CASH_PAYMENT_EXCESS}

&{DEBT_CUSTOMER_INVOICE_REQUEST}
...    Invoice=${DEBT_CUSTOMER_INVOICE}
...    Payments=@{EMPTY}

&{POINT_AND_DEBT_INVOICE_REQUEST}
...    Invoice=${POINT_AND_DEBT_INVOICE}
...    Payments=@{CASH_PAYMENT_50K}

@{POINT_PAYMENT}
...    &{POINT_PAYMENT_DETAILS}

&{PAYMENT_WITH_POINT_INVOICE_REQUEST}
...    Invoice=${PAYMENT_WITH_POINT_INVOICE}
...    Payments=@{POINT_PAYMENT}

&{PRODUCT_POINT_INVOICE_REQUEST}
...    Invoice=${PRODUCT_POINT_INVOICE}
...    Payments=@{CASH_PAYMENT_50K} 