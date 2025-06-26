*** Variables ***
# Dữ liệu hóa đơn cơ bản

${CURRENCY_DECIMAL_PLACE}   2

${BRANCH_ID_TIMEZONE}  1000000057
${PAYMENT_CASH}    Cash
${PAYMENT_CARD}    Card
${PAYMENT_TRANSFER}    Transfer
${PAYMENT_POINT}    Point
${PAYMENT_WALLET}    Wallet
${PAYMENT_VOUCHER}    Voucher
${CUSTOMER_ID_CURRENCY_1}   1000009374
${CUSTOMER_ID_CURRENCY_2}   1000009375
${CUSTOMER_ID_CURRENCY_3}   1000009376
${DELIVERY_PARTNER_CODE}   DT00003

${VOUCHER_CAMPAIGN_ID_2}    1000000031    

${PRODUCT_CODE}           	VLXD0001 
${PRODUCT_NAME}           Hàng hóa
${MASTER_PRODUCT_ID}      1000017663

${BRANCH_TRUNG_TAM}        1000000028
${BRANCH_CHI_NHANH_A}        1000000062   

# E-Invoice Fixed Values (không thay đổi trong mọi request)
${E_INVOICE_TEMPLATE_VT}    2/3117_C25MLL
${E_INVOICE_TEMPLATE_KV}    2_C25MKV

${PARTNER_TYPE_VT}             2
${PARTNER_TYPE_KV}             4

${INCLUDES_ARRAY}    InvoiceDetails,Payments,Products,Customers

# E-Invoice Request Body Templates
&{einvoice_request_body_basic}
...    InvoiceId=${INVOICE_ID}
...    EInvoiceTemplateId=${E_INVOICE_TEMPLATE_ID}
...    Includes=${INCLUDES_ARRAY}
...    PartnerType=${PARTNER_TYPE}