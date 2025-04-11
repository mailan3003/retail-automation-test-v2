*** Variables ***
# Environment variables
${RETAILER_ID}      19809
${BRANCH_ID}        1000000025  
${USER_ID}          1000000467
${SOLD_BY_ID}       ${USER_ID}

${DEFAULT_BRANCH_ID}        1000000025
${DEFAULT_USER_ID}          1000000467
${DEFAULT_CUSTOMER_ID}      1000009032



${DEFAULT_BANK_ACCOUNT_ID}      1
${DEFAULT_LOCATION_ID}          1        
${DEFAULT_WARD_ID}              1 
${INVOICE_DUPLICATED_CODE}      HD000001
${INVOICE_LONG_CODE}            HDSDO_012345678901234567890123456789012345678901234567890

#Invoice data
${VOID_INVOICE_ID}              521838
${NONEXISTENT_INVOICE_ID}       123456789
${EXISTENT_INVOICE_UUID}        W153171314616413
${INVALID_CODE_INVOICE}         hadhadadhas#249284723$1
${EXISTENT_INVOICE_ID}          520107862
       


#Order data
${ORDER_ID}                     130047
${NONEXISTENT_ORDER_ID}         123456789
${FINALIZED_ORDER_ID}           1300473


# Customer data
${customer_1}     1111
${customer_2}     2222
${DEFAULT_CUSTOMER_ID}              1000009032
${DEBT_CUSTOMER_ID}                 1002
${DEBT_LIMIT_CUSTOMER_ID}           1003
${DEBT_WARNING_OFF_CUSTOMER_ID}     1004
${OTHER_BRANCH_CUSTOMER_ID}         1005
${NONEXISTENT_CUSTOMER_ID}          123456789

# Product data
${PRODUCT_1}                1000017637
${PRODUCT_1_CODE}           SP000001
${PRODUCT_1_NAME}           Auto Test Product 1
${MASTER_PRODUCT_1_ID}      1000017637
${PRODUCT_2}                1000014172

${PRODUCT_WITH_VAT_1_ID}         1000014171

${PRESCRIPTION_DRUG_ID}     2001
${INACTIVE_PRODUCT_ID}      1033707
${COMBO_PRODUCT_1_ID}                   1000014447
${COMBO_PRODUCT_1_MATTERIAL_1_ID}       1000014220
${COMBO_PRODUCT_1_MATTERIAL_2_ID}       1000014225

${PRODUCT_CODE_AM}           HH0110 
${PRODUCT_WITH_DISCOUNT_1}      1000014172
${PRODUCT_CODE_NOMAL}           HH0113
${PRODUCT_CODE_DECIMAL}         HH0114
${PRODUCT_CODE_COMBO}          	Combo028 
${PRODUCT_CODE_SERIAL}          SI001
${SERIAL_NUMBER}               CQH002
${PRODUCT_BATCH_NAME}          	FTLD00003 
${BATCH_NAME}                  DFL
${PRODUCT_CODE_QD}            QDD242 
${PRODUCT_ID_DVCB}      1000017550
${PRODUCT_CODE_SERVICE}    DV214
# Partner Delivery Data
${PARTNER_DELIVERY_1_ID}        1000000127
${PARTNER_DELIVERY_1_CODE}      DT00013
${PARTNER_DELIVERY_1_NAME}      Phạm Anh Tú

${PARTNER_DELIVERY_2_ID}        1000000115
${PARTNER_DELIVERY_2_CODE}      DT00001
${PARTNER_DELIVERY_2_NAME}      Giao hàng nhanh

#Category Data
${CATEGORY_1_ID}        1000000717

#Surcharge Data
${SURCHARGE_1_ID}       1000000047
${SURCHARGE_2_ID}       1000000046

# Additional product data
${product_batch}    1000016309
${product_out_of_stock}    7777
${batch_1}    1000000206


# Tax details
${TAX_1_ID}             2
&{tax_detail_body}
...    TaxPercentage=${DEFAULT_TAX_RATE}
...    TaxType=${1}
...    TaxId=${TAX_1_ID}


# Product Details
&{VALID_PRODUCT_WITH_DISCOUNT}    
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    Discount=10000

&{PRODUCT_1_DETAILS}    
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    Discount=0

&{PRODUCT_2_DETAILS}    
...    ProductId=${PRODUCT_2}
...    Quantity=1
...    Price=200000
...    Discount=0

# Serial Product Templates
&{VALID_SERIAL_PRODUCT}    
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    SerialNumbers=SN001,SN002

&{USED_SERIAL_PRODUCT}    
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    SerialNumbers=SN003,SN004

# Sale channel data
${valid_channel_id}    6666

# Dates
${FUTURE_DATE}    2024-12-31
${PAST_DATE}      2023-01-01

# Promotion data
${promotion_1}    7777
${promotion_2}    8888
${VALID_PROMOTION_ID}     87280
${VALID_PROMOTION_SALE_ID}   24747
${EXPIRED_PROMOTION_ID}   2001
${INACTIVE_PROMOTION_ID}  3001

# Branch data  
${MAIN_BRANCH}    1234
${SUB_BRANCH}     5678
${DEFAULT_BRANCH_ID}      1
${OTHER_BRANCH_ID}        2
${MASTER_BRANCH_ID}       1

# Tax data
${VAT_RATE}       10
${NO_TAX}         0
${DEFAULT_TAX_RATE}        10
${INVALID_TAX_RATE}        999

# Payment methods
${PAYMENT_CASH}    Cash
${PAYMENT_CARD}    Card
${PAYMENT_TRANSFER}    Transfer
${PAYMENT_POINT}    Point
${PAYMENT_WALLET}    Wallet
${PAYMENT_VOUCHER}    Voucher
${PAYMENT_COD}     COD
&{CASH_PAYMENT}
...    Method=Cash
...    Amount=100000

&{CARD_PAYMENT}
...    Method=Card
...    Amount=100000 
...    AccountId=${DEFAULT_BANK_ACCOUNT_ID}

#Pricebook data
${NON_EXISTENT_PRICEBOOK_ID}        123456789
${PRICEBOOK_ID}                     520107862

# Delivery data
${DEFAULT_DELIVERY_PRICE}    20000
${DELIVERY_PARTNER_1}        9999
${DELIVERY_PARTNER_2}        8888
&{VALID_DELIVERY_INFO}
...    ReceiverName=Test Receiver
...    ReceiverPhone=0987654321
...    ReceiverAddress=123 Test Street
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID}
...    DeliveryBy=1
...    UseDefaultPartner=true
...    Status=0

# Status codes
${STATUS_PENDING}        1
${STATUS_PROCESSING}     2
${STATUS_COMPLETED}      3
${STATUS_CANCELLED}      4
${STATUS_FAILED}         5

# API endpoints
${API_BASE_URL}         https://api.kiotviet.com
${API_VERSION}          v1
${API_INVOICE}          ${API_BASE_URL}/${API_VERSION}/invoices

# API Config
${API_ENDPOINT}             https://

