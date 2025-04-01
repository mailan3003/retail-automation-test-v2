*** Settings ***
Resource    ../CommonData.robot

*** Variables ***
# Standard invoice data
&{STANDARD_INVOICE}    
...    Code=HD_TEST_001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05

# Standard invoice detail with reward point enabled product
&{STANDARD_INVOICE_DETAIL}    
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    IsRewardPoint=True
...    RewardPoint=10

# Product specific reward point configurations
&{PRODUCT_WITH_REWARD_POINT}    
...    ProductId=${PRODUCT_1}
...    Quantity=2
...    Price=100000
...    IsRewardPoint=True
...    RewardPoint=10

&{PRODUCT_WITHOUT_REWARD_POINT}    
...    ProductId=${PRODUCT_2}
...    Quantity=1
...    Price=200000
...    IsRewardPoint=False

# Promotion reward point data
&{INVOICE_POINT_PROMOTION}
...    Id=1001
...    Type=2
...    ApplyFor=1
...    PointValue=50

&{PRODUCT_POINT_PROMOTION}
...    Id=1002
...    Type=3
...    ApplyFor=2
...    PointPercentage=10
...    ApplyProductIds=${PRODUCT_1}

# Invoice reward point settings
&{INVOICE_REWARD_TYPE_SETTING}
...    RewardPointType=1
...    RewardPoint_IsActive=True
...    RewardPoint_MoneyPerPoint=10000

&{PRODUCT_REWARD_TYPE_SETTING}
...    RewardPointType=2
...    RewardPoint_IsActive=True

# Complete invoice data templates
&{INVOICE_REWARD_TYPE_DATA}
...    Invoice=${STANDARD_INVOICE}
...    InvoiceDetails=@{EMPTY}
...    PosSetting=${INVOICE_REWARD_TYPE_SETTING}

&{PRODUCT_REWARD_TYPE_DATA}
...    Invoice=${STANDARD_INVOICE}
...    InvoiceDetails=@{EMPTY}
...    PosSetting=${PRODUCT_REWARD_TYPE_SETTING}

&{INVOICE_WITH_PROMOTION_POINT_DATA}
...    Invoice=${STANDARD_INVOICE}
...    InvoiceDetails=@{EMPTY}
...    PosSetting=${INVOICE_REWARD_TYPE_SETTING}
...    Promotions=@{EMPTY}

&{PRODUCT_WITH_PROMOTION_POINT_DATA}
...    Invoice=${STANDARD_INVOICE}
...    InvoiceDetails=@{EMPTY}
...    PosSetting=${PRODUCT_REWARD_TYPE_SETTING}
...    Promotions=@{EMPTY} 