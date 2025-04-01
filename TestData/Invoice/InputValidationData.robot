*** Settings ***
Resource    ../CommonData.robot

*** Variables ***
# Dữ liệu hóa đơn chuẩn
# Chi tiết hóa đơn chuẩn
@{STANDARD_INVOICE_DETAILS}
...    &{PRODUCT_1_DETAILS}
&{STANDARD_INVOICE}
...    Code=HD_TEST_001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05

# Dữ liệu hóa đơn không hợp lệ
&{INVALID_CODE_PREFIX_INVOICE}
...    Code=XX_INVALID_001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05

&{DUPLICATED_CODE_INVOICE}
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
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05

# Dữ liệu hóa đơn cập nhật
&{UPDATE_INVOICE}
...    Code=HD_TEST_UPDT001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    UpdateInvoiceId={NONEXISTENT_INVOICE_ID}

&{UPDATE_VOID_INVOICE}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    UpdateInvoiceId=${VOID_INVOICE_ID}

&{UPDATE_NONEXISTENT_INVOICE}
...    Code=HD_TEST_UPDT003
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    UpdateInvoiceId=${NONEXISTENT_INVOICE_ID}

# Dữ liệu hóa đơn từ đơn hàng
&{ORDER_INVOICE}
...    Code=HD_TEST_ORDER001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    OrderId=${ORDER_ID}

&{INVALID_ORDER_INVOICE}
...    Code=HD_TEST_ORDER002
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    OrderId=${NONEXISTENT_ORDER_ID}

&{FINALIZED_ORDER_INVOICE}
...    Code=HD_TEST_ORDER003
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    OrderId=${FINALIZED_ORDER_ID}

# Dữ liệu hóa đơn với khách hàng
&{NONEXISTENT_CUSTOMER_INVOICE}
...    Code=HD_TEST_CUST001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${NONEXISTENT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05

&{OTHER_BRANCH_CUSTOMER_INVOICE}
...    Code=HD_TEST_CUST002
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${OTHER_BRANCH_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05

# Dữ liệu hóa đơn với thanh toán bằng điểm
&{POINT_PAYMENT_INVOICE}
...    Code=HD_TEST_POINT001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05

&{POINT_PAYMENT}
...    Method=Point
...    Amount=100000

# Dữ liệu hóa đơn với giao hàng COD
&{COD_INVOICE}
...    Code=HD_TEST_COD001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    UsingCod=1

&{COD_PAYMENT}
...    Method=COD
...    Amount=100000

&{VALID_DELIVERY_PARTNER}
...    Id=${DELIVERY_PARTNER_1}
...    Name=Partner 1
...    Status=1

&{INVALID_DELIVERY_PARTNER}
...    Id=${DELIVERY_PARTNER_2}
...    Name=Partner 2
...    Status=0

# Dữ liệu sản phẩm hết hàng
&{OUT_OF_STOCK_PRODUCT}
...    ProductId=${product_out_of_stock}
...    Quantity=10
...    Price=100000
...    Discount=0

# Dữ liệu sản phẩm với serial
&{INVALID_SERIAL_PRODUCT}
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    SerialNumbers=INVALID001

&{DUPLICATE_SERIAL_PRODUCT}
...    ProductId=${PRODUCT_1}
...    Quantity=2
...    Price=100000
...    SerialNumbers=SN001,SN001

# Dữ liệu sản phẩm theo lô
&{BATCH_PRODUCT}
...    ProductId=${product_batch}
...    Quantity=1
...    Price=100000
...    BatchId=${batch_1}

&{EXPIRED_BATCH_PRODUCT}
...    ProductId=${product_batch}
...    Quantity=1
...    Price=100000
...    BatchId=9999

# Dữ liệu thanh toán không hợp lệ
&{OVERPAYMENT}
...    Method=Cash
...    Amount=200000

# Dữ liệu sổ giá
&{PRICEBOOK_INVOICE}
...    Code=HD_TEST_PB001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PriceBookId=${PRICEBOOK_ID}

&{INVALID_PRICEBOOK_INVOICE}
...    Code=HD_TEST_PB002
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    PriceBookId=${NON_EXISTENT_PRICEBOOK_ID}

# Dữ liệu hóa đơn với voucher và khuyến mãi
&{VOUCHER_PROMOTION_INVOICE}
...    Code=HD_TEST_VP001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05

&{VOUCHER_PAYMENT}
...    Method=Voucher
...    Amount=50000
...    VoucherCode=VC001

# Dữ liệu khuyến mãi
&{STANDARD_PROMOTION}
...    Id=${VALID_PROMOTION_ID}
...    Type=1
...    Value=10000
...    IsPercent=False

# Template dữ liệu cho request
&{STANDARD_INVOICE_REQUEST}
...    Invoice=${STANDARD_INVOICE}
...    Payments=@{EMPTY}

&{COD_INVOICE_REQUEST}
...    Invoice=${COD_INVOICE}
...    Payments=@{EMPTY}
...    DeliveryDetail=${VALID_DELIVERY_INFO}

&{ORDER_INVOICE_REQUEST}
...    Invoice=${ORDER_INVOICE}
...    Payments=@{EMPTY}

&{PRICEBOOK_INVOICE_REQUEST}
...    Invoice=${PRICEBOOK_INVOICE}

...    Payments=@{EMPTY}

&{POINT_PAYMENT_INVOICE_REQUEST}
...    Invoice=${POINT_PAYMENT_INVOICE}

...    Payments=@{EMPTY} 