*** Settings ***
Documentation     Dữ liệu cho test cases quản lý đặt giữ (reservation) tồn kho
Resource          ../CommonData.robot

*** Variables ***
# Dữ liệu hóa đơn cơ bản cho chế độ đặt giữ
${RESERVATION_STANDARD_DATA}    {"Invoice":{"Code":"HD_RESV_001","BranchId":${BRANCH_ID},"RetailerId":${RETAILER_ID},"SoldById":${SOLD_BY_ID},"CustomerId":${DEFAULT_CUSTOMER_ID},"PurchaseDate":"2024-05-15T00:00:00.000Z","Status":1,"Total":500000,"ReservationMode":1,"Payments":[{"Method":"Cash","Amount":500000}],"InvoiceDetails":[{"ProductId":${PRODUCT_1},"ProductCode":"${PRODUCT_CODE_1}","Quantity":5,"Price":100000}]}}

# Dữ liệu hóa đơn đặt trước
${RESERVATION_DRAFT_DATA}    {"Invoice":{"Code":"HD_RESV_DRAFT_001","BranchId":${BRANCH_ID},"RetailerId":${RETAILER_ID},"SoldById":${SOLD_BY_ID},"CustomerId":${DEFAULT_CUSTOMER_ID},"PurchaseDate":"2024-05-15T00:00:00.000Z","Status":3,"Total":300000,"ReservationMode":1,"Payments":[{"Method":"Cash","Amount":300000}],"InvoiceDetails":[{"ProductId":${PRODUCT_1},"ProductCode":"${PRODUCT_CODE_1}","Quantity":3,"Price":100000}]}}

# Dữ liệu cho hóa đơn với kiểm tra tồn kho thực tế
${ACTUALRESERVED_CHECK_DATA}    {"Invoice":{"Code":"HD_RESV_ACTUAL_001","BranchId":${BRANCH_ID},"RetailerId":${RETAILER_ID},"SoldById":${SOLD_BY_ID},"CustomerId":${DEFAULT_CUSTOMER_ID},"PurchaseDate":"2024-05-15T00:00:00.000Z","Status":1,"Total":400000,"ReservationMode":1,"Payments":[{"Method":"Cash","Amount":400000}],"InvoiceDetails":[{"ProductId":${PRODUCT_1},"ProductCode":"${PRODUCT_CODE_1}","Quantity":4,"Price":100000}]}}

# Dữ liệu hóa đơn đặt hàng với cập nhật OnOrder
${ORDER_RESERVATION_DATA}    {"Invoice":{"Code":"HD_ORDER_RESV_001","BranchId":${BRANCH_ID},"RetailerId":${RETAILER_ID},"SoldById":${SOLD_BY_ID},"CustomerId":${DEFAULT_CUSTOMER_ID},"PurchaseDate":"2024-05-15T00:00:00.000Z","Status":1,"Total":600000,"ReservationMode":1,"OrderId":${ORDER_ID},"Payments":[{"Method":"Cash","Amount":600000}],"InvoiceDetails":[{"ProductId":${PRODUCT_1},"ProductCode":"${PRODUCT_CODE_1}","Quantity":6,"Price":100000}]}}

# Dữ liệu hóa đơn cần hủy
${INVOICE_TO_CANCEL_DATA}    {"Invoice":{"Code":"HD_CANCEL_001","BranchId":${BRANCH_ID},"RetailerId":${RETAILER_ID},"SoldById":${SOLD_BY_ID},"CustomerId":${DEFAULT_CUSTOMER_ID},"PurchaseDate":"2024-05-15T00:00:00.000Z","Status":1,"Total":200000,"Payments":[{"Method":"Cash","Amount":200000}],"InvoiceDetails":[{"ProductId":${PRODUCT_1},"ProductCode":"${PRODUCT_CODE_1}","Quantity":2,"Price":100000}]}} 