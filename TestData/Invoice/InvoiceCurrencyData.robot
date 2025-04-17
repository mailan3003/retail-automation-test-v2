*** Settings ***
Documentation     Dữ liệu cho test cases xử lý thông tin giao hàng
Resource          ../CommonData.robot

*** Variables ***
# Dữ liệu hóa đơn cơ bản
&{STANDARD_DELIVERY_INVOICE}    
...    Code=HD_DELIVERY_STD001    
...    BranchId=${BRANCH_ID}    
...    SoldById=${SOLD_BY_ID}    
...    CustomerId=${DEFAULT_CUSTOMER_ID}    
...    Method=COD    
...    UsingCod=${TRUE}    
...    Description=Hóa đơn giao hàng tiêu chuẩn

# Chi tiết sản phẩm
${details}=    Create List    ${PRODUCT_1_DETAILS}
Set To Dictionary    ${STANDARD_DELIVERY_INVOICE}    InvoiceDetails=${details}

# Thanh toán
&{cod_payment}=    Create Dictionary
...    Method=COD
...    Value=100000
${payments}=    Create List    ${cod_payment}
Set To Dictionary    ${STANDARD_DELIVERY_INVOICE}    Payments=${payments}

# Thông tin giao hàng tiêu chuẩn
&{STANDARD_DELIVERY_INFO}    
...    ReceiverName=Nguyễn Văn A    
...    ReceiverPhone=0987654321    
...    ReceiverAddress=123 Đường Nguyễn Huệ, Q1    
...    LocationId=${DEFAULT_LOCATION_ID}    
...    WardId=${DEFAULT_WARD_ID}    
...    DeliveryBy=1    
...    UseDefaultPartner=${TRUE}    
...    Status=1    
...    ShippingFee=${DEFAULT_DELIVERY_PRICE}

# Thông tin giao hàng không có SĐT
&{DELIVERY_INFO_NO_PHONE}    
...    ReceiverName=Nguyễn Văn A    
...    ReceiverAddress=123 Đường Nguyễn Huệ, Q1    
...    LocationId=${DEFAULT_LOCATION_ID}    
...    WardId=${DEFAULT_WARD_ID}    
...    DeliveryBy=1    
...    UseDefaultPartner=${TRUE}    
...    Status=1    
...    ShippingFee=${DEFAULT_DELIVERY_PRICE}

# Thông tin giao hàng không có tên người nhận
&{DELIVERY_INFO_NO_NAME}    
...    ReceiverPhone=0987654321    
...    ReceiverAddress=123 Đường Nguyễn Huệ, Q1    
...    LocationId=${DEFAULT_LOCATION_ID}    
...    WardId=${DEFAULT_WARD_ID}    
...    DeliveryBy=1    
...    UseDefaultPartner=${TRUE}    
...    Status=1    
...    ShippingFee=${DEFAULT_DELIVERY_PRICE}

# Thông tin giao hàng không có địa chỉ
&{DELIVERY_INFO_NO_ADDRESS}    
...    ReceiverName=Nguyễn Văn A    
...    ReceiverPhone=0987654321    
...    LocationId=${DEFAULT_LOCATION_ID}    
...    WardId=${DEFAULT_WARD_ID}    
...    DeliveryBy=1    
...    UseDefaultPartner=${TRUE}    
...    Status=1    
...    ShippingFee=${DEFAULT_DELIVERY_PRICE}

# Thông tin giao hàng không có khu vực
&{DELIVERY_INFO_NO_LOCATION}    
...    ReceiverName=Nguyễn Văn A    
...    ReceiverPhone=0987654321    
...    ReceiverAddress=123 Đường Nguyễn Huệ, Q1    
...    WardId=${DEFAULT_WARD_ID}    
...    DeliveryBy=1    
...    UseDefaultPartner=${TRUE}    
...    Status=1    
...    ShippingFee=${DEFAULT_DELIVERY_PRICE}

# Thông tin giao hàng với phương thức giao khác
&{DELIVERY_INFO_OTHER_PARTNER}    
...    ReceiverName=Nguyễn Văn A    
...    ReceiverPhone=0987654321    
...    ReceiverAddress=123 Đường Nguyễn Huệ, Q1    
...    LocationId=${DEFAULT_LOCATION_ID}    
...    WardId=${DEFAULT_WARD_ID}    
...    DeliveryBy=2    
...    PartnerId=${DELIVERY_PARTNER_2}    
...    Status=1    
...    ShippingFee=30000

# Thông tin giao hàng với phí ship cao
&{DELIVERY_INFO_HIGH_FEE}    
...    ReceiverName=Nguyễn Văn A    
...    ReceiverPhone=0987654321    
...    ReceiverAddress=123 Đường Nguyễn Huệ, Q1    
...    LocationId=${DEFAULT_LOCATION_ID}    
...    WardId=${DEFAULT_WARD_ID}    
...    DeliveryBy=1    
...    UseDefaultPartner=${TRUE}    
...    Status=1    
...    ShippingFee=100000

# Thông tin giao hàng với phí ship miễn phí
&{DELIVERY_INFO_FREE_SHIPPING}    
...    ReceiverName=Nguyễn Văn A    
...    ReceiverPhone=0987654321    
...    ReceiverAddress=123 Đường Nguyễn Huệ, Q1    
...    LocationId=${DEFAULT_LOCATION_ID}    
...    WardId=${DEFAULT_WARD_ID}    
...    DeliveryBy=1    
...    UseDefaultPartner=${TRUE}    
...    Status=1    
...    ShippingFee=0
...    IsFreeShip=${TRUE}

# Hóa đơn với các trạng thái giao hàng
&{DELIVERY_STATUS_INVOICE}    
...    Code=HD_DELIVERY_STS001    
...    BranchId=${BRANCH_ID}    
...    SoldById=${SOLD_BY_ID}    
...    CustomerId=${DEFAULT_CUSTOMER_ID}    
...    Method=COD    
...    UsingCod=${TRUE}    
...    Description=Hóa đơn giao hàng
Set To Dictionary    ${DELIVERY_STATUS_INVOICE}    InvoiceDetails=${details}
Set To Dictionary    ${DELIVERY_STATUS_INVOICE}    Payments=${payments}

# Thông tin giao hàng cho trạng thái khác nhau
&{DELIVERY_INFO_PENDING}    
...    ReceiverName=Nguyễn Văn A    
...    ReceiverPhone=0987654321    
...    ReceiverAddress=123 Đường Nguyễn Huệ, Q1    
...    LocationId=${DEFAULT_LOCATION_ID}    
...    WardId=${DEFAULT_WARD_ID}    
...    DeliveryBy=1    
...    UseDefaultPartner=${TRUE}    
...    Status=${STATUS_PENDING}    
...    ShippingFee=${DEFAULT_DELIVERY_PRICE}

&{DELIVERY_INFO_PROCESSING}    
...    ReceiverName=Nguyễn Văn A    
...    ReceiverPhone=0987654321    
...    ReceiverAddress=123 Đường Nguyễn Huệ, Q1    
...    LocationId=${DEFAULT_LOCATION_ID}    
...    WardId=${DEFAULT_WARD_ID}    
...    DeliveryBy=1    
...    UseDefaultPartner=${TRUE}    
...    Status=${STATUS_PROCESSING}    
...    ShippingFee=${DEFAULT_DELIVERY_PRICE}

&{DELIVERY_INFO_COMPLETED}    
...    ReceiverName=Nguyễn Văn A    
...    ReceiverPhone=0987654321    
...    ReceiverAddress=123 Đường Nguyễn Huệ, Q1    
...    LocationId=${DEFAULT_LOCATION_ID}    
...    WardId=${DEFAULT_WARD_ID}    
...    DeliveryBy=1    
...    UseDefaultPartner=${TRUE}    
...    Status=${STATUS_COMPLETED}    
...    ShippingFee=${DEFAULT_DELIVERY_PRICE}

&{DELIVERY_INFO_CANCELLED}    
...    ReceiverName=Nguyễn Văn A    
...    ReceiverPhone=0987654321    
...    ReceiverAddress=123 Đường Nguyễn Huệ, Q1    
...    LocationId=${DEFAULT_LOCATION_ID}    
...    WardId=${DEFAULT_WARD_ID}    
...    DeliveryBy=1    
...    UseDefaultPartner=${TRUE}    
...    Status=${STATUS_CANCELLED}    
...    ShippingFee=${DEFAULT_DELIVERY_PRICE}

# Thông tin giao hàng với ghi chú
&{DELIVERY_INFO_WITH_NOTE}    
...    ReceiverName=Nguyễn Văn A    
...    ReceiverPhone=0987654321    
...    ReceiverAddress=123 Đường Nguyễn Huệ, Q1    
...    LocationId=${DEFAULT_LOCATION_ID}    
...    WardId=${DEFAULT_WARD_ID}    
...    DeliveryBy=1    
...    UseDefaultPartner=${TRUE}    
...    Status=1    
...    ShippingFee=${DEFAULT_DELIVERY_PRICE}
...    Note=Giao hàng ngoài giờ hành chính 