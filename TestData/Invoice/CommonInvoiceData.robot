*** Settings ***
Documentation     Dữ liệu hóa đơn chuẩn dùng chung cho các test cases
Resource          ../CommonData.robot

*** Variables ***
# Chi tiết hóa đơn chuẩn
@{STANDARD_INVOICE_DETAILS}
...    &{STANDARD_INVOICE_DETAIL}
&{STANDARD_INVOICE_DETAIL}    
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    Discount=0
&{STANDARD_INVOICE}
...    Code=HD_TEST_001
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${DEFAULT_USER_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05

# Template dữ liệu cho request
&{STANDARD_INVOICE_REQUEST}
...    Invoice=${STANDARD_INVOICE}
...    Payments=@{EMPTY}
