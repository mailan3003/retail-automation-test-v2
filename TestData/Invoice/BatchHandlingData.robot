*** Settings ***
Documentation     Dữ liệu cho test cases xử lý lô hàng (batch) nâng cao
Resource          ../CommonData.robot

*** Variables ***
# Dữ liệu hóa đơn với xử lý lô theo quy tắc FIFO (First In First Out)
${BATCH_FIFO_DATA}    {"Invoice":{"Code":"HD_BATCH_FIFO_001","BranchId":${BRANCH_ID},"RetailerId":${RETAILER_ID},"SoldById":${SOLD_BY_ID},"CustomerId":${DEFAULT_CUSTOMER_ID},"PurchaseDate":"2024-05-20T00:00:00.000Z","Status":1,"Total":500000,"Payments":[{"Method":"Cash","Amount":500000}],"InvoiceDetails":[{"ProductId":${product_batch},"ProductCode":"BATCH001","Quantity":5,"Price":100000,"BatchProcessingType":"FIFO"}]}}

# Dữ liệu hóa đơn với xử lý lô theo quy tắc FEFO (First Expired First Out)
${BATCH_FEFO_DATA}    {"Invoice":{"Code":"HD_BATCH_FEFO_001","BranchId":${BRANCH_ID},"RetailerId":${RETAILER_ID},"SoldById":${SOLD_BY_ID},"CustomerId":${DEFAULT_CUSTOMER_ID},"PurchaseDate":"2024-05-20T00:00:00.000Z","Status":1,"Total":600000,"Payments":[{"Method":"Cash","Amount":600000}],"InvoiceDetails":[{"ProductId":${product_batch},"ProductCode":"BATCH001","Quantity":6,"Price":100000,"BatchProcessingType":"FEFO"}]}}

# Dữ liệu hóa đơn với xử lý lô theo quy tắc LIFO (Last In First Out)
${BATCH_LIFO_DATA}    {"Invoice":{"Code":"HD_BATCH_LIFO_001","BranchId":${BRANCH_ID},"RetailerId":${RETAILER_ID},"SoldById":${SOLD_BY_ID},"CustomerId":${DEFAULT_CUSTOMER_ID},"PurchaseDate":"2024-05-20T00:00:00.000Z","Status":1,"Total":400000,"Payments":[{"Method":"Cash","Amount":400000}],"InvoiceDetails":[{"ProductId":${product_batch},"ProductCode":"BATCH001","Quantity":4,"Price":100000,"BatchProcessingType":"LIFO"}]}}

# Dữ liệu hóa đơn với xử lý lô theo chi phí thấp nhất
${BATCH_LOWEST_COST_DATA}    {"Invoice":{"Code":"HD_BATCH_COST_001","BranchId":${BRANCH_ID},"RetailerId":${RETAILER_ID},"SoldById":${SOLD_BY_ID},"CustomerId":${DEFAULT_CUSTOMER_ID},"PurchaseDate":"2024-05-20T00:00:00.000Z","Status":1,"Total":300000,"Payments":[{"Method":"Cash","Amount":300000}],"InvoiceDetails":[{"ProductId":${product_batch},"ProductCode":"BATCH001","Quantity":3,"Price":100000,"BatchProcessingType":"LowestCost"}]}}

# Dữ liệu hóa đơn với xử lý lô thủ công
${BATCH_MANUAL_DATA}    {"Invoice":{"Code":"HD_BATCH_MANUAL_001","BranchId":${BRANCH_ID},"RetailerId":${RETAILER_ID},"SoldById":${SOLD_BY_ID},"CustomerId":${DEFAULT_CUSTOMER_ID},"PurchaseDate":"2024-05-20T00:00:00.000Z","Status":1,"Total":200000,"Payments":[{"Method":"Cash","Amount":200000}],"InvoiceDetails":[{"ProductId":${product_batch},"ProductCode":"BATCH001","Quantity":2,"Price":100000,"BatchId":${batch_specific}}]}}

# Dữ liệu hóa đơn với lô cần hủy
${BATCH_CANCEL_DATA}    {"Invoice":{"Code":"HD_BATCH_CANCEL_001","BranchId":${BRANCH_ID},"RetailerId":${RETAILER_ID},"SoldById":${SOLD_BY_ID},"CustomerId":${DEFAULT_CUSTOMER_ID},"PurchaseDate":"2024-05-20T00:00:00.000Z","Status":1,"Total":300000,"Payments":[{"Method":"Cash","Amount":300000}],"InvoiceDetails":[{"ProductId":${product_batch},"ProductCode":"BATCH001","Quantity":3,"Price":100000,"BatchId":${batch_1}}]}}

# Dữ liệu hóa đơn với lô có ngày hết hạn
${BATCH_EXPIRE_DATE_DATA}    {"Invoice":{"Code":"HD_BATCH_EXPIRE_001","BranchId":${BRANCH_ID},"RetailerId":${RETAILER_ID},"SoldById":${SOLD_BY_ID},"CustomerId":${DEFAULT_CUSTOMER_ID},"PurchaseDate":"2024-05-20T00:00:00.000Z","Status":1,"Total":200000,"Payments":[{"Method":"Cash","Amount":200000}],"InvoiceDetails":[{"ProductId":${product_batch},"ProductCode":"BATCH001","Quantity":2,"Price":100000,"BatchExpiresAdd":{"BatchName":"NEW_BATCH","ExpireDate":"2024-06-30T00:00:00.000Z"}}]}} 