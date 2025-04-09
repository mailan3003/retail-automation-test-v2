*** Settings ***
Documentation     Dữ liệu test cho phần tạo phiếu thu khi tạo hóa đơn
Resource          ../CommonData.robot

*** Variables ***
# Dữ liệu hóa đơn tiêu chuẩn
${RECEIPT_INVOICE_CODE}    HD_RECEIPT001
${STANDARD_RECEIPT_AMOUNT}    100000
${RECEIPT_PREFIX}    TT
${RECEIPT_DESCRIPTION}    Thu tiền hóa đơn bán hàng

# Dữ liệu phương thức thanh toán
${PAYMENT_CASH}    Cash
${PAYMENT_CARD}    Card
${PAYMENT_TRANSFER}    Transfer

# Dữ liệu khách hàng
${RECEIPT_CUSTOMER_ID}    ${DEFAULT_CUSTOMER_ID}
${RECEIPT_CUSTOMER_NAME}    Khách hàng test

# Dữ liệu chi nhánh và nhân viên
${RECEIPT_BRANCH_ID}    ${BRANCH_ID}
${RECEIPT_CASHIER_ID}    ${SOLD_BY_ID}

# Trạng thái phiếu thu
${RECEIPT_STATUS_ACTIVE}    1
${RECEIPT_STATUS_DELETED}    0

# Loại phiếu thu
${RECEIPT_TYPE_INVOICE}    1    # Phiếu thu từ hóa đơn
${RECEIPT_TYPE_PAYMENT}    2    # Phiếu thu thanh toán công nợ
${RECEIPT_TYPE_OTHER}    3     # Phiếu thu khác

# Các trường hợp đặc biệt
${EXCESS_RECEIPT_AMOUNT}    120000
${PARTIAL_RECEIPT_AMOUNT}    80000
${MULTIPLE_PAYMENT_AMOUNT}    50000

# Dữ liệu tài khoản ngân hàng và thẻ
${BANK_ACCOUNT_ID}    ${DEFAULT_BANK_ACCOUNT_ID}
${BANK_ACCOUNT_NAME}    Tài khoản ngân hàng mặc định

# Dữ liệu hóa đơn chuẩn
&{STANDARD_RECEIPT_INVOICE}
...    Code=${RECEIPT_INVOICE_CODE}
...    BranchId=${RECEIPT_BRANCH_ID}
...    SoldById=${RECEIPT_CASHIER_ID}
...    CustomerId=${RECEIPT_CUSTOMER_ID}
...    Total=${STANDARD_RECEIPT_AMOUNT}
...    Description=${RECEIPT_DESCRIPTION}
...    InvoiceDetails=@{STANDARD_RECEIPT_INVOICE_DETAILS}
...    CreatedBy=Test

@{STANDARD_RECEIPT_INVOICE_DETAILS}
...    &{PRODUCT_1_DETAILS}

# Dữ liệu thanh toán tiền mặt
&{CASH_RECEIPT_PAYMENT}
...    Method=${PAYMENT_CASH}
...    Amount=${STANDARD_RECEIPT_AMOUNT}

# Dữ liệu thanh toán thẻ
&{CARD_RECEIPT_PAYMENT}
...    Method=${PAYMENT_CARD}
...    Amount=${STANDARD_RECEIPT_AMOUNT}
...    AccountId= 0
...    Id=-1
...    UsePoint=null

# Dữ liệu thanh toán chuyển khoản
&{TRANSFER_RECEIPT_PAYMENT}
...    Method=${PAYMENT_TRANSFER}
...    Amount=${STANDARD_RECEIPT_AMOUNT}
...    AccountId=0
...    Id=-1
...    UsePoint=null

# Request và response tiêu chuẩn
&{STANDARD_RECEIPT_REQUEST}
...    Invoice=&{STANDARD_RECEIPT_INVOICE}
...    Payments=@{STANDARD_CASH_PAYMENTS}

@{STANDARD_CASH_PAYMENTS}
...    &{CASH_RECEIPT_PAYMENT}

# Dữ liệu thanh toán nhiều phương thức
&{MULTIPLE_PAYMENT_RECEIPT_REQUEST}
...    Invoice=&{STANDARD_RECEIPT_INVOICE}
...    Payments=@{MULTIPLE_PAYMENT_METHODS}

@{MULTIPLE_PAYMENT_METHODS}
...    &{CASH_MULTIPLE_PAYMENT}
...    &{CARD_MULTIPLE_PAYMENT}

&{CASH_MULTIPLE_PAYMENT}
...    Method=${PAYMENT_CASH}
...    Amount=${MULTIPLE_PAYMENT_AMOUNT}
...    AccountId=null
...    UsePoint=null
...    Id=-1

&{CARD_MULTIPLE_PAYMENT}
...    Method=${PAYMENT_CARD}
...    Amount=${MULTIPLE_PAYMENT_AMOUNT}
...    AccountId=0
...    UsePoint=null
...    Id=-1

# Dữ liệu thanh toán thừa
&{OVERPAYMENT_RECEIPT_REQUEST}
...    Invoice=&{STANDARD_RECEIPT_INVOICE}
...    Payments=@{OVERPAYMENT_METHODS}

@{OVERPAYMENT_METHODS}
...    &{OVERPAYMENT_PAYMENT}

&{OVERPAYMENT_PAYMENT}
...    Method=${PAYMENT_CASH}
...    Amount=${EXCESS_RECEIPT_AMOUNT}

# Dữ liệu thanh toán thiếu
&{UNDERPAYMENT_RECEIPT_REQUEST}
...    Invoice=&{STANDARD_RECEIPT_INVOICE}
...    Payments=@{UNDERPAYMENT_METHODS}

@{UNDERPAYMENT_METHODS}
...    &{UNDERPAYMENT_PAYMENT}

&{UNDERPAYMENT_PAYMENT}
...    Method=${PAYMENT_CASH}
...    Amount=${PARTIAL_RECEIPT_AMOUNT}


# Dữ liệu thanh toán trực tiếp không qua hóa đơn
&{DIRECT_RECEIPT_REQUEST}
...    Receipt=&{DIRECT_RECEIPT}
...    Payment=&{CASH_RECEIPT_PAYMENT}

&{DIRECT_RECEIPT}
...    BranchId=${RECEIPT_BRANCH_ID}
...    CashierId=${RECEIPT_CASHIER_ID}
...    CustomerId=${RECEIPT_CUSTOMER_ID}
...    Amount=${STANDARD_RECEIPT_AMOUNT}
...    Description=${RECEIPT_DESCRIPTION}
...    ReceiptType=${RECEIPT_TYPE_OTHER}
...    CreatedBy=Test

# Dữ liệu thanh toán công nợ
&{DEBT_PAYMENT_RECEIPT_REQUEST}
...    Receipt=&{DEBT_RECEIPT}
...    Payment=&{CASH_RECEIPT_PAYMENT}

&{DEBT_RECEIPT}
...    BranchId=${RECEIPT_BRANCH_ID}
...    CashierId=${RECEIPT_CASHIER_ID}
...    CustomerId=${RECEIPT_CUSTOMER_ID}
...    Amount=${STANDARD_RECEIPT_AMOUNT}
...    Description=${RECEIPT_DESCRIPTION}
...    ReceiptType=${RECEIPT_TYPE_PAYMENT}
...    CreatedBy=Test

# Dữ liệu thanh toán với mô tả chi tiết
&{RECEIPT_WITH_DETAILS_REQUEST}
...    Invoice=&{STANDARD_RECEIPT_INVOICE}
...    Payments=@{DETAILED_PAYMENTS}

@{DETAILED_PAYMENTS}
...    &{DETAILED_PAYMENT}

&{DETAILED_PAYMENT}
...    Method=${PAYMENT_CASH}
...    Amount=${STANDARD_RECEIPT_AMOUNT}
...    Description=Thu tiền hóa đơn bán hàng chi tiết cho khách ${RECEIPT_CUSTOMER_NAME} 