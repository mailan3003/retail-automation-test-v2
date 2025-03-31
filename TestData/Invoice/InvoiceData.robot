*** Variables ***
# Invoice request templates
&{VALID_INVOICE_REQUEST}
...    Code=HD001
...    BranchId=${BRANCH_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-01-20
...    SoldById=${SOLD_BY_ID}
...    RetailerId=${RETAILER_ID}
...    Status=1
...    Details=@{EMPTY}

# Trường hợp mã hóa đơn
${OFFLINE_PREFIX}    HDO
${SHOPEE_PREFIX}    SP
${LAZADA_PREFIX}    LD
${FACEBOOK_PREFIX}    FB_
${INSTAGRAM_PREFIX}    IG_
${TIKTOK_PREFIX}    TT_

${VALID_INVOICE_DATA}    {"Invoice":{"BranchId":${BRANCH_ID},"RetailerId":${RETAILER_ID},"UpdateInvoiceId":0,"UpdateReturnId":0,"SoldById":${SOLD_BY_ID},"InvoiceDetails":[{"ProductId":${PRODUCT_1},"ProductCode":"${PRODUCT_CODE_1}","Quantity":1,"Price":150000}],"Status":1,"Total":150000,"Payments":[{"Method":"Cash","Amount":150000}]}}

# Invoice validation data
${INVOICE_VOID_CODE}    HD000998
${INVOICE_FAILED_CODE}    HD000999
${INVOICE_PAST_7_DAYS_CODE}    HD000888    # 8 days ago
${INVOICE_FUTURE_7_DAYS_CODE}    HD000777   # 8 days later
${INVOICE_SAME_UUID}    HD000666