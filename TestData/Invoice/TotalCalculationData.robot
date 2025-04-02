*** Settings ***
Documentation     Dữ liệu kiểm thử cho chức năng tính tổng tiền hàng
Resource          ../CommonData.robot

*** Variables ***
# Dữ liệu hóa đơn tiêu chuẩn
&{STANDARD_INVOICE_REQUEST}    
...    Code=HD_TOTAL_001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05

# Chi tiết hóa đơn tiêu chuẩn
&{STANDARD_INVOICE_DETAIL}    
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000

# Thanh toán tiêu chuẩn
&{STANDARD_PAYMENT}
...    Method=${PAYMENT_CASH}
...    Value=100000

# Dữ liệu hóa đơn nhiều sản phẩm
&{MULTI_PRODUCT_INVOICE}    
...    Code=HD_TOTAL_002
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05

# Chi tiết sản phẩm
&{PRODUCT_1_DETAIL}    
...    ProductId=${PRODUCT_1}
...    Quantity=2
...    Price=100000

&{PRODUCT_2_DETAIL}    
...    ProductId=${PRODUCT_2}
...    Quantity=1
...    Price=200000

# Sản phẩm với chiết khấu
&{PRODUCT_WITH_DISCOUNT}    
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    Discount=10000

&{PRODUCT_WITH_PERCENT_DISCOUNT}    
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    DiscountRatio=10

# Sản phẩm với thuế
&{PRODUCT_WITH_VAT}    
...    ProductId=${product_with_vat}
...    Quantity=1
...    Price=100000
...    VatRate=${VAT_RATE}

# Cấu hình tính tổng
&{VAT_INCLUDE_SETTING}
...    VatIncluded=True

&{VAT_EXCLUDE_SETTING}
...    VatIncluded=False

# Dữ liệu hóa đơn hoàn chỉnh
&{STANDARD_TOTAL_INVOICE_DATA}
...    Invoice=${STANDARD_INVOICE_REQUEST}
...    InvoiceDetails=@{EMPTY}
...    Payments=@{EMPTY}
...    PosSetting=${VAT_EXCLUDE_SETTING}

&{MULTI_PRODUCT_INVOICE_DATA}
...    Invoice=${MULTI_PRODUCT_INVOICE}
...    InvoiceDetails=@{EMPTY}
...    Payments=@{EMPTY}
...    PosSetting=${VAT_EXCLUDE_SETTING}

&{DISCOUNTED_INVOICE_DATA}
...    Invoice=${STANDARD_INVOICE_REQUEST}
...    InvoiceDetails=@{EMPTY}
...    Payments=@{EMPTY}
...    PosSetting=${VAT_EXCLUDE_SETTING}

&{VAT_INVOICE_DATA}
...    Invoice=${STANDARD_INVOICE_REQUEST}
...    InvoiceDetails=@{EMPTY}
...    Payments=@{EMPTY}
...    PosSetting=${VAT_EXCLUDE_SETTING}

&{VAT_INCLUDED_INVOICE_DATA}
...    Invoice=${STANDARD_INVOICE_REQUEST}
...    InvoiceDetails=@{EMPTY}
...    Payments=@{EMPTY}
...    PosSetting=${VAT_INCLUDE_SETTING}

# Dữ liệu giảm giá trên tổng hóa đơn
&{INVOICE_WITH_DISCOUNT_AMOUNT}
...    Code=HD_TOTAL_003
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05
...    Discount=50000

&{INVOICE_WITH_DISCOUNT_PERCENT}
...    Code=HD_TOTAL_004
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05
...    DiscountRatio=10

&{INVOICE_DISCOUNT_AMOUNT_DATA}
...    Invoice=${INVOICE_WITH_DISCOUNT_AMOUNT}
...    InvoiceDetails=@{EMPTY}
...    Payments=@{EMPTY}
...    PosSetting=${VAT_EXCLUDE_SETTING}

&{INVOICE_DISCOUNT_PERCENT_DATA}
...    Invoice=${INVOICE_WITH_DISCOUNT_PERCENT}
...    InvoiceDetails=@{EMPTY}
...    Payments=@{EMPTY}
...    PosSetting=${VAT_EXCLUDE_SETTING} 