*** Variables ***
# Cấu trúc request cơ bản cho tạo đơn hàng
&{BASE_ORDER_REQUEST}    
...    Order=&{ORDER_DATA}


# Dữ liệu đơn hàng cơ bản
&{ORDER_DATA}
...    Id=0
...    Code=${EMPTY}
...    PurchaseDate=${EMPTY}
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

#Partner Delivery Body
&{PARTNER_ORDER_DELIVERY_BODY}
...    Type=0  
...    TypeName=    
...    Status=1    
...    Address=${None}    
...    ContactNumber=0988673523    
...    Receiver=Hung 
...    Address=1B  
...    DeliveryBy=${None}   
...    LocationId=1    
...    LocationName=An Giang - Huyện Chợ Mới    
...    WardName=Thị trấn Chợ Mới    
...    CustomerId=${None}    
...    CustomerCode=${None}    
...    BranchTakingAddressId=${None}    
...    BranchTakingAddressStr="1,Phường Ba Ngòi,Thành phố Cam Ranh, Khánh Hòa 03322553899"    
...    AdministrativeAreaId=${None}    
...    WardId=10548    
...    Weight=500    
...    Height=10    
...    Width=10    
...    Length=10    
...    IsChangeGBH=${False}   
...    Price=${DEFAULT_DELIVERY_PRICE}    
...    PackageType=0    
...    Paymenter=0    
...    ServiceCode=0    
...    UseDefaultPartner=${False}   
...    UsingOfBilling=${False}   
...    UsingPriceCod=1    
...    ChangeExpectedDelivery=${False}    
...    WeightInput=500    
...    LastLocation=An Giang - Huyện Chợ Mới    
...    LastWard=Thị trấn Chợ Mới    
...    PackageTypeObj=&{package_type_order_body}


&{package_type_order_body}      Value=0    Name=gram 

@{standard_order_detail_tax_body}
...    &{order_detail_tax_body}


&{order_detail_tax_body}
...    TaxId=2
...    DetailTax=3500   

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
@{PROMOTIONS_ORDER}    &{BASIC_PROMOTION_ORDER}

&{BASIC_PROMOTION_ORDER}
...    PromotionId=${VALID_PROMOTION_ID}
...    Type=1
...    TargetType=0
...    Discount=10000
...    PrintPromotionInfo=Khuyến mãi cơ bản

@{SURCHARGE_ORDER}
...    &{SURCHARGE_BODY}

&{SURCHARGE_BODY}
...    SurchargeId=1
...    Price=10000


&{request_order_body_update}
...    Order=&{order_body_update} 
...    FromManager=${True}

&{order_body_update} 
...    Id=
...    SoldById=${DEFAULT_USER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    StatusValue=1
...    OrderDetails=@{STANDARD_PRODUCT_ORDER_DETAILS}

&{request_order_body_update_delivery}
...    Order=&{delivery_update_order_body}
...    FromManager=${True}

&{delivery_update_order_body}
...    Id=
...    SoldById=${DEFAULT_USER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    StatusValue=1
...    UsingCod=1
...    OrderDetails=@{STANDARD_PRODUCT_ORDER_DETAILS}
...    DeliveryDetail=&{delivery_detail_update_body_order}



&{delivery_detail_update_body_order}
...    OrderId=1000001015


&{order_body_complete}
...    Order=&{order_body_update_complete}
...    Complete=${True}

&{order_body_update_complete}
...    Id=141746
...    Status=2

&{PRODUCT_ORDER_DETAIL_MATERIALS}
...    Attribute1=30
...    Attribute2=60
...    Attribute3=${None}
...    Attribute4=6
...    Attribute5=${None}
...    Type1=2
...    Type2=1

# Dữ liệu không hợp lệ