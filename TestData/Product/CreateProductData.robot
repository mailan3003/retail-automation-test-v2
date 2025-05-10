*** Settings ***
Documentation     Dữ liệu test cho tạo sản phẩm
Resource          ../CommonData.robot
Library           String

*** Variables ***


&{List_product_data}      Id=0
...    ProductType=2
...    CategoryId=${CATEGORY_1_ID} 
...    CategoryName=
...    isActive=false
...    VariantCount=0
...    AllowsSale=true
...    isDeleted=false
...    Code=
...    BasePrice=
...    Cost=
...    LatestPurchasePrice=0
...    OnHand=
...    OnHandCompareMin=0
...    OnHandCompareMax=0
...    CompareOnHand=0
...    CompareCost=0
...    CompareBasePrice=0
...    CompareCode=
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
...    ProductFormulas=[]
...    Name=
...    ListPriceBookDetail=[]
...    ProductImages=[]   


@{LIST_PRODUCT_DATA}    &{List_product_data}

${Branch_for_cost}   Id=${DEFAULT_BRANCH_ID}
...    Name=Chi nhánh trung tâm

# Dữ liệu cơ bản cho tạo sản phẩm
