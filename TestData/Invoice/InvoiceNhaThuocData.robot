*** Settings ***
Resource    ../CommonData.robot

*** Variables ***
# Standard invoice data
&{STANDARD_INVOICE}    
...    Code=HD_TEST_001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05


# Standard invoice detail
&{STANDARD_INVOICE_DETAIL}    
...    ProductId=${PRODUCT_1}
...    ProductCode=${PRODUCT_CODE_1}
...    Quantity=1
...    Price=100000

# Invalid invoice data variations
&{DUPLICATE_CODE_INVOICE}
...    Code=${INVOICE_DUPLICATED_CODE}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05

&{LONG_CODE_INVOICE}
...    Code=${INVOICE_LONG_CODE}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05

&{MISSING_BRANCH_INVOICE}
...    Code=HD_TEST_002
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05

&{INVALID_BRANCH_INVOICE}
...    Code=HD_TEST_003
...    BranchId=9999
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05

&{OTHER_BRANCH_CUSTOMER_INVOICE}
...    Code=HD_TEST_004
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${OTHER_BRANCH_CUSTOMER_ID}
...    PurchaseDate=2024-05-05

&{MISSING_SOLD_BY_INVOICE}
...    Code=HD_TEST_005
...    BranchId=${BRANCH_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05

&{INVALID_SOLD_BY_INVOICE}
...    Code=HD_TEST_006
...    BranchId=${BRANCH_ID}
...    SoldById=9999
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05

&{FUTURE_DATE_INVOICE}
...    Code=HD_TEST_007
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=${FUTURE_DATE}

&{DEBT_CUSTOMER_INVOICE}
...    Code=HD_TEST_008
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEBT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05

&{DEBT_LIMIT_CUSTOMER_INVOICE}
...    Code=HD_TEST_009
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEBT_LIMIT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05

# Invoice detail variations
&{MISSING_PRODUCT_INVOICE_DETAIL}
...    Quantity=1
...    Price=100000

&{ZERO_QUANTITY_INVOICE_DETAIL}
...    ProductId=${PRODUCT_1}
...    ProductCode=${PRODUCT_CODE_1}
...    Quantity=0
...    Price=100000

&{NEGATIVE_QUANTITY_INVOICE_DETAIL}
...    ProductId=${PRODUCT_1}
...    ProductCode=${PRODUCT_CODE_1}
...    Quantity=-1
...    Price=100000

&{NEGATIVE_PRICE_INVOICE_DETAIL}
...    ProductId=${PRODUCT_1}
...    ProductCode=${PRODUCT_CODE_1}
...    Quantity=1
...    Price=-10000

&{INACTIVE_PRODUCT_INVOICE_DETAIL}
...    ProductId=${INACTIVE_PRODUCT_ID}
...    Quantity=1
...    Price=100000

&{INVALID_PRODUCT_INVOICE_DETAIL}
...    ProductId=999999
...    Quantity=1
...    Price=100000

&{OUT_OF_STOCK_INVOICE_DETAIL}
...    ProductId=${product_out_of_stock}
...    Quantity=999
...    Price=100000

&{PRESCRIPTION_DRUG_INVOICE_DETAIL}
...    ProductId=${PRESCRIPTION_DRUG_ID}
...    Quantity=1
...    Price=100000

&{COMBO_PRODUCT_INVOICE_DETAIL}
...    ProductId=${COMBO_PRODUCT_ID}
...    Quantity=1
...    Price=100000

# Payment variations
&{STANDARD_PAYMENT}
...    Method=${PAYMENT_CASH}
...    Amount=100000

&{NEGATIVE_AMOUNT_PAYMENT}
...    Method=${PAYMENT_CASH}
...    Amount=-10000

&{ZERO_AMOUNT_PAYMENT}
...    Method=${PAYMENT_CASH}
...    Amount=0

&{CARD_WITHOUT_ACCOUNT_PAYMENT}
...    Method=${PAYMENT_CARD}
...    Amount=100000

# Complete invoice data templates
&{STANDARD_INVOICE_DATA}
...    Invoice=${STANDARD_INVOICE}
...    InvoiceDetails=@{EMPTY}
...    Payments=@{EMPTY}

&{DUPLICATE_CODE_INVOICE_DATA}
...    Invoice=${DUPLICATE_CODE_INVOICE}
...    InvoiceDetails=@{EMPTY}

&{LONG_CODE_INVOICE_DATA}
...    Invoice=${LONG_CODE_INVOICE}
...    InvoiceDetails=@{EMPTY}

&{MISSING_BRANCH_INVOICE_DATA}
...    Invoice=${MISSING_BRANCH_INVOICE}
...    InvoiceDetails=@{EMPTY}

&{INVALID_BRANCH_INVOICE_DATA}
...    Invoice=${INVALID_BRANCH_INVOICE}
...    InvoiceDetails=@{EMPTY}

&{OTHER_BRANCH_CUSTOMER_INVOICE_DATA}
...    Invoice=${OTHER_BRANCH_CUSTOMER_INVOICE}
...    InvoiceDetails=@{EMPTY}

&{MISSING_SOLD_BY_INVOICE_DATA}
...    Invoice=${MISSING_SOLD_BY_INVOICE}
...    InvoiceDetails=@{EMPTY}

&{INVALID_SOLD_BY_INVOICE_DATA}
...    Invoice=${INVALID_SOLD_BY_INVOICE}
...    InvoiceDetails=@{EMPTY}

&{FUTURE_DATE_INVOICE_DATA}
...    Invoice=${FUTURE_DATE_INVOICE}
...    InvoiceDetails=@{EMPTY}

&{DEBT_CUSTOMER_INVOICE_DATA}
...    Invoice=${DEBT_CUSTOMER_INVOICE}
...    InvoiceDetails=@{EMPTY}

&{DEBT_LIMIT_CUSTOMER_INVOICE_DATA}
...    Invoice=${DEBT_LIMIT_CUSTOMER_INVOICE}
...    InvoiceDetails=@{EMPTY}

&{NO_DETAILS_INVOICE_DATA}
...    Invoice=${STANDARD_INVOICE}
...    InvoiceDetails=@{EMPTY} 