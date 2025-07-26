*** Settings ***
Library           String


*** Variables ***
# Data cho sản phẩm

#Category Data
${CATEGORY_1_ID}        1000000717
${CATEGORY_NAME}     Smartphone

&{list_product_data}     Id=0
...    ProductType=2
...    CategoryId=${CATEGORY_1_ID} 
...    CategoryName=
...    isActive=false
...    AllowsSale=true
...    isDeleted=false
...    Code=
...    BasePrice=50000
...    Cost=0
...    LatestPurchasePrice=0
...    OnHand=0
...    MinQuantity=0
...    MaxQuantity=999999999
...    CustomId=0
...    Unit=mot
...    ConversionValue=1
...    CustomValue=0
...    MasterProductId=0
...    OrderTemplate=
...    IsLotSerialControl=false
...    IsRewardPoint=false
...    ProductFormulas=@{EMPTY}
...    Name=TEST
...    ListPriceBookDetail=@{EMPTY}
...    ProductImages=@{EMPTY}   

&{branch_for_cost}   Id=${DEFAULT_BRANCH_ID}
...    Name=Chi trung


&{standard_product_attributes}    AttributeId=361
...    ProductId=0
...    Value=L
# Dữ liệu cơ bản cho tạo sản phẩm
&{PRODUCT_FORMULAS}    MaterialId=1000016616
...    MaterialName=
...    MaterialCode=
...    Quantity=5
...    Cost=50000
...    BasePrice=70000
...    $$hashKey=object:2290
 

&{PRODUCT_UNITS}    Id=0
...    Unit=
...    Code=
...    ConversionValue=1
...    BasePrice=0
...    Cost=0
