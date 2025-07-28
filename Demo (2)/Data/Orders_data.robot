*** Settings ***

*** Variables ***

${PRODUCT_ID1}    2001437331
${PRODUCT_ID2}    142397
${PRODUCT_ID3}    6134913

${QUANTITY1}    1
${QUANTITY2}    1
${QUANTITY3}    1

${CUSTOMER_ID}    1001445647

&{SOLD_BY}    
...    Id=510    
...    UserName=admin    
...    Email=a@gmail.com    
...    GivenName=aydlllll    
...    IsActive=${True}    
...    IsAdmin=${True}    
...    Type=0    
...    Language=vi-VN    
...    MobilePhone=+84339062167    
...    isDeleted=${False}    
...    CreatedBy=0    
...    CreatedDate=2021-01-19T07:36:27.233Z

&{ORDER_DETAIL_1}    ProductId=${PRODUCT_ID1}    ProductCode=SP1005202255    ProductName=Khẩu trang KT39    Quantity=${QUANTITY1}    BasePrice=40000    Price=40000    OriginPrice=40000    AllocationDiscount=4000    IsLotSerialControl=${True}    IsRewardPoint=${True}    Uuid=
&{ORDER_DETAIL_2}    ProductId=${PRODUCT_ID2}    ProductCode=SP000077    ProductName=Hoa cẩm tú cầu - Xanh 2 - Đà Lạt 2 - (bông)    Quantity=${QUANTITY2}    BasePrice=50000    Price=50000    OriginPrice=50000    AllocationDiscount=5000    IsLotSerialControl=${False}    Uuid=
&{ORDER_DETAIL_3}    ProductId=${PRODUCT_ID3}    ProductCode=8936131180934    ProductName=Thebol sữa tắm thảo dược Vitamin E nước hoa 2 plus vàng 650g    Quantity=${QUANTITY3}    BasePrice=25000    Price=25000    OriginPrice=25000    AllocationDiscount=2500    IsLotSerialControl=${False}    IsRewardPoint=${True}    ProductTradeMarkName=Vinaacecook    Uuid=

@{ORDER_DETAILS}    &{ORDER_DETAIL_1}    &{ORDER_DETAIL_2}    &{ORDER_DETAIL_3}

&{SURCHARGE}    SurchargeId=1000000044    Code=THK000004    Name=Thu Khác Test abc    Price=30000    Value=30000    SurValue=30000    isAuto=${True}    UsageFlag=${True}    RetailerId=861751    CreatedDate=2021-12-11T07:18:53.453Z
@{SURCHARGES}    &{SURCHARGE}

&{PROMOTION}    PromotionId=500307501    SalePromotionId=501269090    DiscountRatio=10    Type=1    TargetType=0    PromotionInfo=Giảm giá hóa đơn:\n Tổng tiền hàng từ 10,000\n giảm giá 10% cho hóa đơn    PrintPromotionInfo=Giảm giá hóa đơn:\n Tổng tiền hàng từ 10,000\n giảm giá 10% cho hóa đơn
@{PROMOTIONS}    &{PROMOTION}

&{ORDER}    
...    BranchId=30    
...    RetailerId=861751    
...    CustomerId=${CUSTOMER_ID}    
...    SoldById=510    
...    SoldBy=&{SOLD_BY}    
...    Seller=&{SOLD_BY}    
...    Code=Đặt hàng 1    
...    Discount=11500    
...    OrderDetails=@{ORDER_DETAILS}    
...    InvoiceOrderSurcharges=@{SURCHARGES}    
...    OrderPromotions=@{PROMOTIONS}    
...    Status=1    
...    Total=133500    
...    Extra={"Amount":0,"Method":{"Id":"Cash","Label":"Tiền mặt"},"ResetPromotion":false}    
...    Surcharge=30000    
...    Type=2    
...    Uuid=    
...    PayingAmount=0    
...    TotalBeforeDiscount=115000    
...    DiscountByPromotion=11500    
...    DiscountByPromotionRatio=10    
...    CreatedBy=510    
...    CreatedDate=2025-07-28T14:01:42.074Z
