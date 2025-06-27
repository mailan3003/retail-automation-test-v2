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

${VOUCHER_CAMPAIGN_ID_2}    1000000031    

${PRODUCT_CODE}           	HH0113 
${PRODUCT_NAME}           Bánh Tipo Hữu Nghị trà xanh hộp 90g
${MASTER_PRODUCT_ID}      1000014171

# E-Invoice Fixed Values (không thay đổi trong mọi request)
${E_INVOICE_TEMPLATE_ID}    99b93352-b1e9-4af2-92fd-eb5c3410642d
${PARTNER_TYPE}             0
${INCLUDES_ARRAY}    InvoiceDetails,Payments,Products,Customers

# E-Invoice Request Body Templates
&{einvoice_request_body_basic}
...    InvoiceId=${INVOICE_ID}
...    EInvoiceTemplateId=${E_INVOICE_TEMPLATE_ID}
...    Includes=${INCLUDES_ARRAY}
...    PartnerType=${PARTNER_TYPE}

