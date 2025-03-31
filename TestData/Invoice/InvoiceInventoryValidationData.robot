*** Variables ***
# Dữ liệu hóa đơn cơ bản
${invoice_inventory_validation_default_data}    {"Invoice":{"BranchId":${BRANCH_ID},"RetailerId":${RETAILER_ID},"SoldById":${SOLD_BY_ID},"PurchaseDate":"2024-03-01T00:00:00.000Z","InvoiceDetails":[{"ProductId":${PRODUCT_1},"ProductCode":"${PRODUCT_CODE_1}","Quantity":1,"Price":100000}],"Status":1,"Total":100000,"Payments":[{"Method":"Cash","Amount":100000}]}}

# Thông tin sản phẩm
${invoice_inventory_validation_out_of_stock_product_id}    ${product_out_of_stock}
${invoice_inventory_validation_out_of_stock_code}    SPH001
${invoice_inventory_validation_qty_exceed}    1000
${invoice_inventory_validation_serial_product_id}    8001
${invoice_inventory_validation_serial_code}    SER001
${invoice_inventory_validation_used_serial}    SN003
${invoice_inventory_validation_available_serial}    SN001

# Thông tin sản phẩm combo
${invoice_inventory_validation_combo_product_id}    ${COMBO_PRODUCT_ID}
${invoice_inventory_validation_combo_code}    COMBO001
${invoice_inventory_validation_combo_child_1_id}    8100
${invoice_inventory_validation_combo_child_2_id}    8200
${invoice_inventory_validation_combo_qty}    5

# Thông tin sản phẩm theo lô
${invoice_inventory_validation_batch_product_id}    ${product_batch}
${invoice_inventory_validation_batch_code}    BATCH001
${invoice_inventory_validation_batch_id}    ${batch_1}
${invoice_inventory_validation_batch_name}    LOT001
${invoice_inventory_validation_expire_date}    2024-12-31T00:00:00.000Z
${invoice_inventory_validation_expired_date}    2023-01-01T00:00:00.000Z
${invoice_inventory_validation_batch_qty}    10

# Cấu hình
${invoice_inventory_validation_allow_out_of_stock}    true 
${invoice_inventory_validation_not_allow_out_of_stock}    false 