*** Settings ***
Documentation     Dữ liệu test cho tạo sản phẩm
Resource          ../CommonData.robot
Library           String

*** Variables ***


&{list_product_data}     Id=0
...    ProductType=2
...    CategoryId=${CATEGORY_1_ID} 
...    CategoryName=
...    isActive=false
...    VariantCount=0
...    AllowsSale=true
...    isDeleted=false
...    Code=
...    BasePrice=50000
...    Cost=0
...    LatestPurchasePrice=0
...    OnHand=0
...    OnHandCompareMin=0
...    OnHandCompareMax=0
...    CompareOnHand=0
...    CompareCost=0
...    CompareBasePrice=0
...    CompareUnit=
...    Reserved=0
...    MinQuantity=0
...    MaxQuantity=999999999
...    CustomId=0
...    CustomValue=0
...    MasterProductId=0
...    Unit=
...    ConversionValue=1
...    OrderTemplate=
...    IsLotSerialControl=false
...    IsRewardPoint=false
...    ProductFormulas=@{EMPTY}
...    Name=TEST
...    ListPriceBookDetail=@{EMPTY}
...    ProductImages=@{EMPTY}   


@{LIST_PRODUCT_DATA_BODY}    &{List_product_data}

&{branch_for_cost}   Id=${DEFAULT_BRANCH_ID}
...    Name=Chi trung

# Dữ liệu cơ bản cho tạo sản phẩm

&{PRODUCT_FORMULAS}    MaterialId=1000016616
...    MaterialName=
...    MaterialCode=
...    Quantity=5
...    Cost=50000
...    BasePrice=70000
...    $$hashKey=object:2290
...    

&{PRODUCT_UNITS}    Id=0
...    Unit=
...    Code=
...    ConversionValue=
...    BasePrice=
...    Cost=
...    OnHand=


&{GENUINE_GUARANTEES}    Uuid=
...    Id=-9999
...    Description=Toàn bộ sản phẩm
...    NumberTime=5
...    TimeType=6
...    WarrantyType=1
...    ProductId=0
...    RetailerId=${DEFAULT_RETAILER_ID}


&{Pricebook_book}                   __type=
...    Id=0
...    PriceBookId=${DEFAULT_PRICEBOOK_ID}
...    PriceBookName=BCBBB1
...    ProductId=0
...    IsAuto=false
...    ListDependencies=
...    ParentId=0
...    Value=-20000
...    Price=65656
...    isEnable=true

&{PRODUCT_ATTRIBUTES}    AttributeId=361
...    ProductId=0
...    Value=L

&{PRODUCT_WITH_WAREHOUSE_STOCK_TAKES}    BranchId=0
...    OnHand=0




