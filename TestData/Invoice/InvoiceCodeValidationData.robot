*** Variables ***
# Dữ liệu hóa đơn cơ bản
${invoice_code_validation_default_data}    {"Invoice":{"BranchId":${BRANCH_ID},"RetailerId":${RETAILER_ID},"SoldById":${SOLD_BY_ID},"PurchaseDate":"2025-03-01T00:00:00.000Z","InvoiceDetails":[{"ProductId":${PRODUCT_1},"ProductCode":"${PRODUCT_CODE_1}","Quantity":1,"Price":100000}],"Status":1,"Total":100000,"Payments":[{"Method":"Cash","Amount":100000}]}}

# Mã hóa đơn trùng lặp
${invoice_code_validation_duplicate_code}    HDV001
${invoice_code_validation_uuid}    uuid-test-12345
${invoice_code_validation_duplicate_uuid}    uuid-duplicate-12345

# Mã hóa đơn theo loại
${invoice_code_validation_offline_code}    HDO12345
${invoice_code_validation_shopee_code}    SP12345
${invoice_code_validation_lazada_code}    LD12345
${invoice_code_validation_facebook_code}    FB_12345
${invoice_code_validation_instagram_code}    IG_12345
${invoice_code_validation_tiktok_code}    TT_12345
${invoice_code_validation_warranty_code}    BH12345

# Mã hóa đơn đặc biệt
${invoice_code_validation_long_code}    INVOICE_CODE_WITH_VERY_LONG_NAME_THAT_EXCEEDS_50_CHARACTERS_LIMIT_12345
${invoice_code_validation_void_code}    HDV567
${invoice_code_validation_failed_code}    HDF567
${invoice_code_validation_old_code}    HDO_PAST
${invoice_code_validation_clone_base_code}    HD_BASE
${invoice_code_validation_clone_code}    C_HD_BASE.1
${invoice_code_validation_update_code}    U_HD_BASE.1

# Trạng thái hóa đơn
${invoice_code_validation_completed_status}    3
${invoice_code_validation_void_status}    4
${invoice_code_validation_failed_status}    5

# Sale channel IDs
${invoice_code_validation_shopee_channel_id}    1
${invoice_code_validation_lazada_channel_id}    2
${invoice_code_validation_facebook_channel_id}    3
${invoice_code_validation_instagram_channel_id}    4
${invoice_code_validation_tiktok_channel_id}    5 