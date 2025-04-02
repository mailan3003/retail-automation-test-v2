*** Settings ***
Documentation     Dữ liệu test cho phần tính giá trị thanh toán khi tạo hóa đơn
Resource          ../CommonData.robot

*** Variables ***
# Dữ liệu hóa đơn tiêu chuẩn
${STANDARD_INVOICE_CODE}    INV001
${STANDARD_INVOICE_AMOUNT}    100000
${STANDARD_PRODUCT_ID}    PRD001
${STANDARD_PRODUCT_NAME}    Sản phẩm test
${STANDARD_PRODUCT_PRICE}    100000
${STANDARD_PRODUCT_QUANTITY}    1
${STANDARD_CUSTOMER_ID}    CUS001
${STANDARD_CUSTOMER_NAME}    Nguyễn Văn A
${STANDARD_BRANCH_ID}    BR001

# Dữ liệu thanh toán
${PAYMENT_CASH}    Cash
${PAYMENT_CARD}    Card
${PAYMENT_BANK}    Bank
${PAYMENT_POINT}    Point
${PAYMENT_VOUCHER}    Voucher
${PAYMENT_COD}    COD
${PAYMENT_DEPOSIT}    Deposit

# Dữ liệu nhiều sản phẩm
${MULTIPLE_PRODUCT_1_ID}    PRD001
${MULTIPLE_PRODUCT_1_NAME}    Sản phẩm test 1
${MULTIPLE_PRODUCT_1_PRICE}    50000
${MULTIPLE_PRODUCT_1_QUANTITY}    1

${MULTIPLE_PRODUCT_2_ID}    PRD002
${MULTIPLE_PRODUCT_2_NAME}    Sản phẩm test 2
${MULTIPLE_PRODUCT_2_PRICE}    20000
${MULTIPLE_PRODUCT_2_QUANTITY}    2

${MULTIPLE_PRODUCT_3_ID}    PRD003
${MULTIPLE_PRODUCT_3_NAME}    Sản phẩm test 3
${MULTIPLE_PRODUCT_3_PRICE}    10000
${MULTIPLE_PRODUCT_3_QUANTITY}    3

# Dữ liệu khuyến mãi
${PROMOTION_AMOUNT}    10000
${VOUCHER_CODE}    VOUCHER001
${VOUCHER_AMOUNT}    20000

# Dữ liệu thuế và phụ phí
${TAX_RATE}    0.10
${TAX_AMOUNT}    10000
${SURCHARGE_AMOUNT}    5000

# Dữ liệu công nợ
${CUSTOMER_WITH_DEBT_ID}    CUS002
${CUSTOMER_WITH_DEBT_NAME}    Nguyễn Văn B
${EXISTING_DEBT_AMOUNT}    900000
${MAX_DEBT_LIMIT}    1000000

# Dữ liệu điểm thưởng
${CUSTOMER_WITH_POINTS_ID}    CUS003
${CUSTOMER_WITH_POINTS_NAME}    Nguyễn Văn C
${AVAILABLE_POINTS}    50
${POINTS_CONVERSION_RATE}    1000

# Dữ liệu đơn đặt hàng
${ORDER_ID}    ORD001
${ORDER_DEPOSIT_AMOUNT}    30000

# Dữ liệu thanh toán trễ hạn
${INVOICE_WITH_LATE_PAYMENT_ID}    INV002
${LATE_PAYMENT_DUE_DATE}    2023-01-01

# Dữ liệu cơ bản cho hóa đơn
&{STANDARD_INVOICE_REQUEST}
...    Invoice=&{STANDARD_INVOICE}
...    Payments=@{STANDARD_PAYMENTS}

&{STANDARD_INVOICE}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    SaleChannelId=${valid_channel_id}
...    PurchaseDate=2023-10-15T10:00:00
...    Description=Hóa đơn kiểm thử
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    Total=100000
...    PaidState=0
...    CreatedBy=Test

@{STANDARD_INVOICE_DETAILS}
...    &{PRODUCT_1_DETAILS}

@{STANDARD_PAYMENTS}
...    &{CASH_PAYMENT}

# Hóa đơn với nhiều sản phẩm, tổng giá trị là 300,000đ
&{MULTI_PRODUCT_INVOICE_REQUEST}
...    Invoice=&{MULTI_PRODUCT_INVOICE}
...    Payments=@{STANDARD_PAYMENTS}

&{MULTI_PRODUCT_INVOICE}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    SaleChannelId=${valid_channel_id}
...    PurchaseDate=2023-10-15T10:00:00
...    Description=Hóa đơn nhiều sản phẩm
...    InvoiceDetails=@{MULTI_PRODUCT_INVOICE_DETAILS}
...    Total=300000
...    PaidState=0
...    CreatedBy=Test

@{MULTI_PRODUCT_INVOICE_DETAILS}
...    &{PRODUCT_1_DETAILS}
...    &{PRODUCT_2_DETAILS}

# Dữ liệu thanh toán theo từng loại
&{CARD_PAYMENT_REQUEST}
...    Invoice=&{STANDARD_INVOICE}
...    Payments=@{CARD_PAYMENTS}

@{CARD_PAYMENTS}
...    &{CARD_PAYMENT}

&{CASH_CARD_PAYMENT_REQUEST}
...    Invoice=&{STANDARD_INVOICE}
...    Payments=@{MIXED_PAYMENTS}

@{MIXED_PAYMENTS}
...    &{CASH_SPLIT_PAYMENT}
...    &{CARD_SPLIT_PAYMENT}

&{CASH_SPLIT_PAYMENT}
...    Method=Cash
...    Amount=50000

&{CARD_SPLIT_PAYMENT}
...    Method=Card
...    Amount=50000
...    AccountId=${DEFAULT_BANK_ACCOUNT_ID}

&{OVERPAYMENT_REQUEST}
...    Invoice=&{STANDARD_INVOICE}
...    Payments=@{OVERPAYMENT_PAYMENTS}

@{OVERPAYMENT_PAYMENTS}
...    &{OVERPAYMENT}

&{OVERPAYMENT}
...    Method=Cash
...    Amount=120000

&{UNDERPAYMENT_REQUEST}
...    Invoice=&{STANDARD_INVOICE}
...    Payments=@{UNDERPAYMENT_PAYMENTS}

@{UNDERPAYMENT_PAYMENTS}
...    &{UNDERPAYMENT}

&{UNDERPAYMENT}
...    Method=Cash
...    Amount=80000

&{POINT_PAYMENT_REQUEST}
...    Invoice=&{POINT_PAYMENT_INVOICE}
...    Payments=@{POINT_PAYMENTS}

&{POINT_PAYMENT_INVOICE}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    SaleChannelId=${valid_channel_id}
...    PurchaseDate=2023-10-15T10:00:00
...    Description=Hóa đơn thanh toán bằng điểm
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    Total=100000
...    PaidState=0
...    CreatedBy=Test
...    RewardPoint_ForInvoiceUsingRewardPoint=True

@{POINT_PAYMENTS}
...    &{POINT_PAYMENT}

&{POINT_PAYMENT}
...    Method=Point
...    Amount=50000

&{VOUCHER_PAYMENT_REQUEST}
...    Invoice=&{VOUCHER_PAYMENT_INVOICE}
...    Payments=@{VOUCHER_PAYMENTS}
...    Vouchers=@{VOUCHER_DETAILS}

&{VOUCHER_PAYMENT_INVOICE}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    SaleChannelId=${valid_channel_id}
...    PurchaseDate=2023-10-15T10:00:00
...    Description=Hóa đơn thanh toán bằng voucher
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    Total=100000
...    PaidState=0
...    CreatedBy=Test
...    RewardPoint_ForInvoiceUsingVoucher=True

@{VOUCHER_PAYMENTS}
...    &{VOUCHER_PAYMENT}
...    &{CASH_VOUCHER_PAYMENT}

&{VOUCHER_PAYMENT}
...    Method=Voucher
...    Amount=20000

&{CASH_VOUCHER_PAYMENT}
...    Method=Cash
...    Amount=80000

@{VOUCHER_DETAILS}
...    &{VOUCHER_DETAIL}

&{VOUCHER_DETAIL}
...    Code=VOUCHER001
...    Value=20000

&{COD_PAYMENT_REQUEST}
...    Invoice=&{COD_PAYMENT_INVOICE}
...    Payments=@{COD_PAYMENTS}
...    DeliveryDetail=&{COD_DELIVERY_DETAIL}

&{COD_PAYMENT_INVOICE}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    SaleChannelId=${valid_channel_id}
...    PurchaseDate=2023-10-15T10:00:00
...    Description=Hóa đơn thanh toán COD
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    Total=100000
...    PaidState=0
...    CreatedBy=Test
...    UsingCod=1

@{COD_PAYMENTS}
...    &{COD_PAYMENT}

&{COD_PAYMENT}
...    Method=COD
...    Amount=100000

&{COD_DELIVERY_DETAIL}
...    ReceiverName=Khách hàng COD
...    ReceiverPhone=0987654321
...    ReceiverAddress=123 Đường Test, Quận 1, TP.HCM
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID}
...    DeliveryBy=${DELIVERY_PARTNER_1}
...    UseDefaultPartner=True
...    Status=0
...    ShippingFee=${DEFAULT_DELIVERY_PRICE}

&{DISCOUNT_PAYMENT_REQUEST}
...    Invoice=&{DISCOUNT_INVOICE}
...    Payments=@{DISCOUNT_PAYMENTS}

&{DISCOUNT_INVOICE}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    SaleChannelId=${valid_channel_id}
...    PurchaseDate=2023-10-15T10:00:00
...    Description=Hóa đơn có giảm giá
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    Discount=10000
...    Total=90000
...    PaidState=0
...    CreatedBy=Test

@{DISCOUNT_PAYMENTS}
...    &{DISCOUNT_PAYMENT}

&{DISCOUNT_PAYMENT}
...    Method=Cash
...    Amount=90000

&{TAX_SURCHARGE_PAYMENT_REQUEST}
...    Invoice=&{TAX_SURCHARGE_INVOICE}
...    Payments=@{TAX_SURCHARGE_PAYMENTS}

&{TAX_SURCHARGE_INVOICE}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    SaleChannelId=${valid_channel_id}
...    PurchaseDate=2023-10-15T10:00:00
...    Description=Hóa đơn có thuế và phụ phí
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    Surcharge=5000
...    TotalTax=10000
...    Total=115000
...    PaidState=0
...    CreatedBy=Test

@{TAX_SURCHARGE_PAYMENTS}
...    &{TAX_SURCHARGE_PAYMENT}

&{TAX_SURCHARGE_PAYMENT}
...    Method=Cash
...    Amount=115000

&{COMPLEX_PAYMENT_REQUEST}
...    Invoice=&{COMPLEX_INVOICE}
...    Payments=@{COMPLEX_PAYMENTS}
...    Vouchers=@{VOUCHER_DETAILS}

&{COMPLEX_INVOICE}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    SaleChannelId=${valid_channel_id}
...    PurchaseDate=2023-10-15T10:00:00
...    Description=Hóa đơn thanh toán phức hợp
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    Discount=10000
...    Surcharge=5000
...    TotalTax=10000
...    Total=105000
...    PaidState=0
...    CreatedBy=Test
...    RewardPoint_ForInvoiceUsingVoucher=True
...    RewardPoint_ForInvoiceUsingRewardPoint=True

@{COMPLEX_PAYMENTS}
...    &{COMPLEX_CASH_PAYMENT}
...    &{COMPLEX_CARD_PAYMENT}
...    &{COMPLEX_VOUCHER_PAYMENT}
...    &{COMPLEX_POINT_PAYMENT} 