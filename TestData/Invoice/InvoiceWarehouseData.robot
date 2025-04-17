*** Variables ***
# Dữ liệu hóa đơn cơ bản
${invoice_einvoice_validation_default_data}    {"Invoice":{"BranchId":${BRANCH_ID},"RetailerId":${RETAILER_ID},"SoldById":${SOLD_BY_ID},"PurchaseDate":"2024-03-01T00:00:00.000Z","InvoiceDetails":[{"ProductId":${PRODUCT_1},"ProductCode":"${PRODUCT_CODE_1}","Quantity":1,"Price":100000}],"Status":1,"Total":100000,"Payments":[{"Method":"Cash","Amount":100000}]}}

# Thông tin VNPT eInvoice
${invoice_einvoice_validation_vnpt_username}    test_username
${invoice_einvoice_validation_vnpt_password}    test_password
${invoice_einvoice_validation_vnpt_empty_username}    ${EMPTY}
${invoice_einvoice_validation_vnpt_empty_password}    ${EMPTY}
${invoice_einvoice_validation_vnpt_template_no}    01GTKT0/001
${invoice_einvoice_validation_vnpt_pattern}    001
${invoice_einvoice_validation_vnpt_invalid_template}    99GTKT0/999
${invoice_einvoice_validation_vnpt_expired_template}    01GTKT0/002

# Thông tin MISA eInvoice
${invoice_einvoice_validation_misa_token}    valid_misa_token
${invoice_einvoice_validation_misa_empty_token}    ${EMPTY}
${invoice_einvoice_validation_misa_expired_token}    expired_misa_token
${invoice_einvoice_validation_misa_template_no}    01GTKT0/001
${invoice_einvoice_validation_misa_invalid_template}    99GTKT0/999
${invoice_einvoice_validation_misa_expired_template}    01GTKT0/002

# Trạng thái hóa đơn điện tử
${invoice_einvoice_validation_pending_status}    Pending
${invoice_einvoice_validation_success_status}    Success
${invoice_einvoice_validation_failed_status}    Failed

# Cấu hình đặc biệt
${invoice_einvoice_validation_invoice_no}    EIN001
${invoice_einvoice_validation_api_error_message}    "Lỗi kết nối đến hệ thống hóa đơn điện tử" 