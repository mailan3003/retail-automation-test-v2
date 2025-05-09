*** Settings ***
Documentation     Dữ liệu mở rộng cho test cases cập nhật tồn kho
Resource          ../CommonData.robot

*** Variables ***
# Dữ liệu hóa đơn với nhiều sản phẩm khác loại (các sản phẩm có cơ chế quản lý tồn kho khác nhau)
&{MIXED_INVENTORY_TYPE_PRODUCT_DETAIL_1}    
...    ProductId=${PRODUCT_1}
...    ProductCode=${PRODUCT_1_CODE}
...    Quantity=3
...    Price=100000

&{MIXED_INVENTORY_TYPE_PRODUCT_DETAIL_2}    
...    ProductId=${product_batch}
...    ProductCode=BATCH001
...    Quantity=2
...    Price=150000
...    BatchId=${batch_1}
...    BatchName=LOT001

&{MIXED_INVENTORY_TYPE_PRODUCT_DETAIL_3}    
...    ProductId=${PRODUCT_2}
...    ProductCode=SP000002
...    Quantity=1
...    Price=200000
...    SerialNumbers=SN005

# Dữ liệu cho sản phẩm combo với số lượng lớn
&{LARGE_COMBO_PRODUCT_DETAIL}    
...    ProductId=${COMBO_PRODUCT_1_ID}
...    ProductCode=COMBO001
...    Quantity=5
...    Price=150000
...    IsCombo=${TRUE}

# Dữ liệu sản phẩm theo lô khi xuất nhiều lô cho một sản phẩm
&{MULTI_BATCH_PRODUCT_DETAIL}    
...    ProductId=${product_batch}
...    ProductCode=BATCH001
...    Quantity=3
...    Price=100000
...    Batches=[{"BatchId": ${batch_1}, "BatchName": "LOT001", "Quantity": 2}, {"BatchId": 8889, "BatchName": "LOT002", "Quantity": 1}]

# Dữ liệu sản phẩm với đơn vị chuyển đổi không chuẩn
&{UNUSUAL_CONVERSION_PRODUCT_DETAIL}    
...    ProductId=${PRODUCT_1}
...    ProductCode=${PRODUCT_1_CODE}
...    Quantity=1.5
...    Price=100000
...    UnitId=3
...    ConversionValue=0.5

# Dữ liệu cho hóa đơn với cập nhật tồn kho các chi nhánh khác nhau
#${MULTI_BRANCH_INVENTORY_DATA}    {"Invoice":{"Code":"HD_UPDATE_INV_BR_001","BranchId":${DEFAULT_BRANCH_ID},"RetailerId":${RETAILER_ID},"SoldById":${SOLD_BY_ID},"CustomerId":${DEFAULT_CUSTOMER_ID},"PurchaseDate":"2024-05-05T00:00:00.000Z","Status":1,"Total":350000,"Payments":[{"Method":"Cash","Amount":350000}],"InvoiceDetails":[{"ProductId":${PRODUCT_1},"ProductCode":"${PRODUCT_1_CODE}","Quantity":2,"Price":100000,"BranchId":${DEFAULT_BRANCH_ID}},{"ProductId":${PRODUCT_2},"ProductCode":"SP000002","Quantity":1,"Price":150000,"BranchId":${OTHER_BRANCH_ID}}]}}
# Dữ liệu cho hóa đơn với giao dịch tồn kho xử lý bất đồng bộ (FIFO/LIFO)
#${ASYNC_INVENTORY_PROCESSING_DATA}    {"Invoice":{"Code":"HD_UPDATE_INV_ASYNC_001","BranchId":${BRANCH_ID},"RetailerId":${RETAILER_ID},"SoldById":${SOLD_BY_ID},"CustomerId":${DEFAULT_CUSTOMER_ID},"PurchaseDate":"2024-05-05T00:00:00.000Z","Status":1,"Total":500000,"Payments":[{"Method":"Cash","Amount":500000}],"InvoiceDetails":[{"ProductId":${product_batch},"ProductCode":"BATCH001","Quantity":5,"Price":100000,"ProcessingType":"FIFO"}]}} 