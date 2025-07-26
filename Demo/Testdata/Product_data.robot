*** Settings ***
Resource    ../Env_live.robot
*** Variables ***
${PRODUCT_NAME}     Hàng hóa tạo để auto xóa


&{list_product_data}     Id=0
...    ProductType=2
...    CategoryId=${DEFAULT_CATEGORY_ID} 
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
...    Unit=
...    ConversionValue=1
...    CustomValue=0
...    MasterProductId=0
...    OrderTemplate=
...    IsLotSerialControl=false
...    IsRewardPoint=false
...    ProductFormulas=@{EMPTY}
...    Name=${PRODUCT_NAME}
...    ListPriceBookDetail=@{EMPTY}
...    ProductImages=@{EMPTY}   




# &{branch_for_cost}   Id=${DEFAULT_BRANCH_ID}
# ...    Name=Chi trung
   
&{BRANCH_1}    Id=100048    Name=Chi nhánh Lê Duẩn
&{BRANCH_2}    Id=30        Name=Chi nhánh trung tâm
@{branch_for_cost}    ${BRANCH_1}    ${BRANCH_2}

&{ATTRIBUTE_ID}
...    COLOR=1200094
...    SIZE=1305930


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




&{GENUINE_GUARANTEES}    Uuid=
...    Id=-9999
...    Description=Toàn bộ sản phẩm
...    NumberTime=5
...    TimeType=6
...    WarrantyType=1
...    ProductId=0
...    RetailerId=


&{Pricebook_body_standard}                   __type=
...    Id=0
...    PriceBookId=
...    PriceBookName=BCBBB1
...    ProductId=0
...    IsAuto=false
...    Price=65656
...    isEnable=true


&{HEADERS}    
# ...    X-GROUP-ID=23
...    sec-ch-ua-platform="Windows"
...    sec-ch-ua="Not)A;Brand\";v=\"8\", \"Chromium\";v=\"138\", \"Google Chrome\";v=\"138\""
...    X-TIMEZONE=
...    sec-ch-ua-mobile=?0
...    FingerPrintKey=9260aa1de596f0d80658143cbe38c670_Chrome_Desktop_Máy tính Windows
...    X-Language=vi-VN
...    Accept=application/json, text/plain, */*
...    Content-Type=application/json; charset=utf-8
...    X-RETAILER-CODE=testz23
# ...    Referer=https://testz23.kiotviet.vn/
...    BranchId=${DEFAULT_BRANCH_ID}
...    User-Agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36
...    Retailer=${RETAILER}
...    IsUseKvClient=1

&{FILTER_BODY}    
...    $inlinecount=allpages
...    $format=json
...    CategoryIds=[]
...    AttributeFilter=[]
...    ConditionTaxIds=
...    BranchId=-1
...    ProductTypes=
...    IsImei=2
...    IsFormulas=2
...    IsActive=${TRUE}
...    AllowSale=${NONE}
...    IsBatchExpireControl=2
...    ShelvesIds=
...    TrademarkIds=
...    StockoutDate=alltime
...    CreatedDate=alltime
...    supplierIds=
...    isNewFilter=${TRUE}
...    $top=15
...    Skip=0
...    Take=15
...    PageSize=15
...    Page=1
