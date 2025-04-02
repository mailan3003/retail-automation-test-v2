*** Settings ***
Resource    ../CommonData.robot

*** Variables ***
# Dữ liệu hóa đơn cơ bản cho cập nhật tồn kho
${INVENTORY_UPDATE_STANDARD_DATA}    {"Invoice":{"Code":"HD_UPDATE_INV_001","BranchId":${BRANCH_ID},"RetailerId":${RETAILER_ID},"SoldById":${SOLD_BY_ID},"CustomerId":${DEFAULT_CUSTOMER_ID},"PurchaseDate":"2024-05-05T00:00:00.000Z","Status":1,"Total":100000,"Payments":[{"Method":"Cash","Amount":100000}],"InvoiceDetails":[{"ProductId":${PRODUCT_1},"ProductCode":"${PRODUCT_CODE_1}","Quantity":1,"Price":100000}]}}

# Dữ liệu sản phẩm thường
&{STANDARD_PRODUCT_DETAIL}    
...    ProductId=${PRODUCT_1}
...    ProductCode=${PRODUCT_CODE_1}
...    Quantity=5
...    Price=100000

# Dữ liệu sản phẩm với số lượng lớn
&{LARGE_QUANTITY_PRODUCT_DETAIL}    
...    ProductId=${PRODUCT_1}
...    ProductCode=${PRODUCT_CODE_1}
...    Quantity=100
...    Price=100000

# Dữ liệu sản phẩm combo
&{COMBO_PRODUCT_DETAIL}    
...    ProductId=${COMBO_PRODUCT_ID}
...    ProductCode=COMBO001
...    Quantity=1
...    Price=150000

# Dữ liệu sản phẩm theo serial
&{SERIAL_PRODUCT_DETAIL}    
...    ProductId=${PRODUCT_1}
...    ProductCode=${PRODUCT_CODE_1}
...    Quantity=1
...    Price=100000
...    SerialNumbers=SN001,SN002

# Dữ liệu sản phẩm theo lô
&{BATCH_PRODUCT_DETAIL}    
...    ProductId=${product_batch}
...    ProductCode=BATCH001
...    Quantity=1
...    Price=100000
...    BatchId=${batch_1}
...    BatchName=LOT001

# Dữ liệu sản phẩm đơn vị chuyển đổi
&{CONVERSION_PRODUCT_DETAIL}    
...    ProductId=${PRODUCT_1}
...    ProductCode=${PRODUCT_CODE_1}
...    Quantity=2
...    Price=100000
...    UnitId=2
...    ConversionValue=12

# Dữ liệu hóa đơn khi cập nhật tồn kho cho nhiều sản phẩm
@{MULTIPLE_PRODUCT_DETAILS}    &{STANDARD_PRODUCT_DETAIL}    &{LARGE_QUANTITY_PRODUCT_DETAIL}

# Dữ liệu hóa đơn với quyền bán âm
${ALLOW_NEGATIVE_INVENTORY_DATA}    {"Invoice":{"Code":"HD_UPDATE_INV_NEG_001","BranchId":${BRANCH_ID},"RetailerId":${RETAILER_ID},"SoldById":${SOLD_BY_ID},"CustomerId":${DEFAULT_CUSTOMER_ID},"PurchaseDate":"2024-05-05T00:00:00.000Z","Status":1,"Total":100000,"Payments":[{"Method":"Cash","Amount":100000}],"InvoiceDetails":[{"ProductId":${product_out_of_stock},"ProductCode":"OUT001","Quantity":1000,"Price":100000}],"AllowSellWhenOutStock":true}}

# Dữ liệu hóa đơn từ đơn hàng
${ORDER_TO_INVOICE_DATA}    {"Invoice":{"Code":"HD_UPDATE_INV_ORD_001","BranchId":${BRANCH_ID},"RetailerId":${RETAILER_ID},"SoldById":${SOLD_BY_ID},"CustomerId":${DEFAULT_CUSTOMER_ID},"PurchaseDate":"2024-05-05T00:00:00.000Z","Status":1,"Total":100000,"Payments":[{"Method":"Cash","Amount":100000}],"InvoiceDetails":[{"ProductId":${PRODUCT_1},"ProductCode":"${PRODUCT_CODE_1}","Quantity":5,"Price":100000}],"OrderId":${ORDER_ID}}} 