*** Settings ***
Documentation     Dữ liệu cho test case API xử lý thông tin giao hàng
Resource          ../CommonData.robot
Resource          ./CommonInvoiceData.robot

*** Variables ***
# Thông tin giao hàng chuẩn
&{STANDARD_DELIVERY_INFO}
...    ReceiverName=Nguyễn Văn A
...    ReceiverPhone=0987654321
...    ReceiverAddress=123 Đường Test
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID}
...    DeliveryBy=${DEFAULT_PARTNER_DELIVERY_ID}
...    UseDefaultPartner=${TRUE}
...    Status=0
...    ShippingFee=20000



# Thông tin giao hàng thiếu thông tin bắt buộc
&{INVALID_DELIVERY_INFO_MISSING_NAME}
...    ReceiverName=${EMPTY}
...    ReceiverPhone=0987654321
...    ReceiverAddress=123 Đường Test
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID}
...    UseDefaultPartner=${TRUE}
...    Status=0

&{INVALID_DELIVERY_INFO_MISSING_PHONE}
...    ReceiverName=Nguyễn Văn A
...    ReceiverPhone=${EMPTY}
...    ReceiverAddress=123 Đường Test
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID}
...    UseDefaultPartner=${TRUE}
...    Status=0

&{INVALID_DELIVERY_INFO_MISSING_ADDRESS}
...    ReceiverName=Nguyễn Văn A
...    ReceiverPhone=0987654321
...    ReceiverAddress=${EMPTY}
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID}
...    UseDefaultPartner=${TRUE}
...    Status=0

# Thông tin giao hàng với đơn vị vận chuyển cụ thể
&{DELIVERY_INFO_WITH_PARTNER}
...    ReceiverName=Nguyễn Văn A
...    ReceiverPhone=0987654321
...    ReceiverAddress=123 Đường Test
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID}
...    DeliveryBy=1
...    UseDefaultPartner=${FALSE}
...    Status=0
...    ShippingFee=20000

# Thông tin giao hàng từ Facebook
&{DELIVERY_INFO_FROM_FACEBOOK}
...    ReceiverName=Nguyễn Văn A
...    ReceiverPhone=0987654321
...    ReceiverAddress=123 Đường Test
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID}
...    DeliveryBy=${DEFAULT_PARTNER_DELIVERY_ID}
...    UseDefaultPartner=${TRUE}
...    Status=0
...    ShippingFee=20000
...    IsFBPos=${TRUE}

# Đơn vị vận chuyển mặc định
${DEFAULT_PARTNER_DELIVERY_ID}      1000000129
${DEFAULT_PARTNER_DELIVERY_NAME}    Giao hàng nhanh

# ID các kênh bán
${FACEBOOK_SALE_CHANNEL_ID}        2
${INSTAGRAM_SALE_CHANNEL_ID}       3
${TIKTOK_SALE_CHANNEL_ID}          4

# Chuẩn bị dữ liệu hóa đơn với giao hàng COD
&{STANDARD_INVOICE_WITH_COD}
...    Code=HD_COD_001
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${DEFAULT_USER_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    UsingCod=1
...    DeliveryDetail=${STANDARD_DELIVERY_INFO}

# Template request cho hóa đơn với giao hàng COD
&{STANDARD_INVOICE_COD_REQUEST}
...    Invoice=${STANDARD_INVOICE_WITH_COD}
...    Payments=@{EMPTY}

# Template dữ liệu cho hóa đơn Facebook với COD
&{STANDARD_INVOICE_WITH_FB_COD}
...    Code=FB_COD_001
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${DEFAULT_USER_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    UsingCod=1
...    SaleChannelId=${FACEBOOK_SALE_CHANNEL_ID}
...    DeliveryDetail=${DELIVERY_INFO_FROM_FACEBOOK}

# Template request cho hóa đơn Facebook với COD
&{FACEBOOK_INVOICE_COD_REQUEST}
...    Invoice=${STANDARD_INVOICE_WITH_FB_COD}
...    Payments=@{EMPTY}

# Template dữ liệu cho hóa đơn với đơn vị vận chuyển cụ thể
&{STANDARD_INVOICE_WITH_PARTNER_COD}
...    Code=HD_PARTNER_COD_001
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${DEFAULT_USER_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    UsingCod=1
...    DeliveryDetail=${DELIVERY_INFO_WITH_PARTNER}

# Template request cho hóa đơn với đơn vị vận chuyển cụ thể
&{PARTNER_INVOICE_COD_REQUEST}
...    Invoice=${STANDARD_INVOICE_WITH_PARTNER_COD}
...    Payments=@{EMPTY}

# Template dữ liệu cho hóa đơn cập nhật có giao hàng
&{STANDARD_INVOICE_UPDATE_COD}
...    Id=1000000001
...    Code=HD_UPDATE_COD_001
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${DEFAULT_USER_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    UsingCod=1
...    DeliveryDetail=${STANDARD_DELIVERY_INFO}

# Template request cho cập nhật hóa đơn có giao hàng
&{UPDATE_INVOICE_COD_REQUEST}
...    Invoice=${STANDARD_INVOICE_UPDATE_COD}
...    Payments=@{EMPTY} 




