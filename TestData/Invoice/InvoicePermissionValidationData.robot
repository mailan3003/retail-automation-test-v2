*** Variables ***
# Dữ liệu hóa đơn cơ bản
${invoice_permission_validation_default_data}    {"Invoice":{"BranchId":${BRANCH_ID},"RetailerId":${RETAILER_ID},"SoldById":${SOLD_BY_ID},"PurchaseDate":"2024-03-01T00:00:00.000Z","InvoiceDetails":[{"ProductId":${PRODUCT_1},"ProductCode":"${PRODUCT_CODE_1}","Quantity":1,"Price":100000}],"Status":1,"Total":100000,"Payments":[{"Method":"Cash","Amount":100000}]}}

# ID người dùng
${invoice_permission_validation_non_admin_user}    5555
${invoice_permission_validation_admin_user}    ${SOLD_BY_ID}
${invoice_permission_validation_other_seller}    6666

# Ngày tháng
${invoice_permission_validation_future_date}    2024-12-31T00:00:00.000Z
${invoice_permission_validation_past_date}    2022-01-01T00:00:00.000Z
${invoice_permission_validation_book_closing_date}    2023-12-31T00:00:00.000Z
${invoice_permission_validation_first_transaction_date}    2023-01-01T00:00:00.000Z

# Chi nhánh và quyền truy cập
${invoice_permission_validation_main_branch}    ${MAIN_BRANCH}
${invoice_permission_validation_sub_branch}    ${SUB_BRANCH}
${invoice_permission_validation_other_branch}    7777

# Trạng thái đơn hàng
${invoice_permission_validation_finalized_order_id}    8888
${invoice_permission_validation_void_order_id}    9999
${invoice_permission_validation_ongoing_order_id}    1010

# Cấu hình và tham số
${invoice_permission_validation_not_allow_modify_date}    true
${invoice_permission_validation_allow_modify_date}    false 