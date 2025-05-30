*** Variables ***
# Cấu trúc request cơ bản cho tạo đơn hàng
&{BASE_ORDER_REQUEST}    
...    Order=&{ORDER_DATA}


# Dữ liệu đơn hàng cơ bản
&{ORDER_DATA}
...    Id=0
...    Code=${EMPTY}
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng mới
...    Total=0
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${DEFAULT_USER_ID}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{STANDARD_PRODUCT_ORDER_DETAILS}
...    Payments=@{EMPTY}
...    InvoiceOrderSurcharges=@{EMPTY}

# Chi tiết sản phẩm 1
&{PRODUCT_ORDER_DETAIL}
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    Total=100000
...    Discount=0
...    DiscountRatio=0
...    Note=${EMPTY}

@{STANDARD_PRODUCT_ORDER_DETAILS}    &{PRODUCT_ORDER_DETAIL}



# Thông tin thanh toán cơ bản
@{BASIC_PAYMENT}    &{STANDARD_PAYMENT}

# Thanh toán COD
&{STANDARD_PAYMENT}
...    Method=Cash
...    Amount=100000

# Thông tin giao hàng cơ bản
&{BASIC_DELIVERY_INFO}    
...    ReceiverName=Nguyễn Văn A
...    ReceiverPhone=0987654321
...    ReceiverAddress=123 Đường Lê Lợi, Quận 1
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID_1}
...    Status=1
...    DeliveryMethod=1
...    PartnerDeliveryId=${DELIVERY_PARTNER_ID}

# Thông tin thuế VAT
#Partner Delivery Body
&{partner_delivery_body}    
...    IdOld=0    
...    TotalInvoiced=0    
...    CompareCode=${PARTNER_DELIVERY_1_CODE}    
...    CompareName=Phạm Anh Tú    
...    Id=${PARTNER_DELIVERY_1_ID}    
...    RetailerId=${RETAILER_ID}    
...    Type=0    
...    Code=${PARTNER_DELIVERY_1_CODE}        
...    Name=Phạm Anh Tú    
...    ContactNumber=01679089901    
...    Address=${None}    
...    Email=${None}    
...    Comments=${None}    
...    CreatedDate=2025-03-28T10:40:23.963+07:00    
...    CreatedBy=${DEFAULT_USER_ID}    
...    ModifiedDate=${None}    
...    Debt=${None}    
...    ModifiedBy=${None}    
...    Uuid=${None}    
...    LocationId=${None}    
...    LocationName=    
...    WardName=    
...    isActive=${True}    
...    isDeleted=${False}    
...    SearchNumber=01679089901    
...    IsOmniChannel=${None}    
...    AdministrativeAreaId=${None}    
...    PartnerDeliveryGroupDetails=@{Empty}    
...    CustomName=Phạm Anh Tú - 01679089901

@{standard_order_detail_tax_body}
...    &{order_detail_tax_body}


&{order_detail_tax_body}
...    TaxId=2
...    DetailTax=3500   

&{invoice_body_update} 
...    Id=
...    PurchaseDate=${None}
...    Status=1
...    SoldById=${DEFAULT_USER_ID}
# Delivery Update Body

&{delivery_update_body_1}
...    Id=
...    PurchaseDate=${None}
...    Status=3
...    UsingCod=1
...    SoldById=${DEFAULT_USER_ID}
...    DeliveryDetail=&{delivery_detail_update_body}

&{delivery_detail_update_body}
...    DeliveryBy=1000000127

# Khuyến mãi
@{PROMOTIONS}    &{BASIC_PROMOTION}

&{BASIC_PROMOTION}
...    PromotionId=${VALID_PROMOTION_ID}
...    Type=1
...    Value=10000
...    Description=Khuyến mãi cơ bản

# Khuyến mãi đã bị xóa
&{DELETED_PROMOTION}
...    PromotionId=${DELETE_PROMOTION_ID}
...    Type=1
...    Value=10000
...    Description=Khuyến mãi đã bị xóa

# Đối tác giao hàng không hợp lệ
&{INVALID_DELIVERY_PARTNER}
...    ReceiverName=Nguyễn Văn A
...    ReceiverPhone=0987654321
...    ReceiverAddress=123 Đường Lê Lợi, Quận 1
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID_1}
...    Status=1
...    DeliveryMethod=1
...    PartnerDeliveryId=999999

# Dữ liệu không hợp lệ
${NONEXISTENT_CUSTOMER_ID}    999999
${INACTIVE_CUSTOMER_ID}    888888
${INVALID_CUSTOMER_ID}    abc123
${NONEXISTENT_SALESPERSON_ID}    999999
${INACTIVE_SALESPERSON_ID}    888888
${NONEXISTENT_SALE_CHANNEL_ID}    999999
${INACTIVE_SALE_CHANNEL_ID}    888888 