*** Variables ***
# Standard product data
${STANDARD_PRODUCT_NAME}    Sản phẩm test tự động
${STANDARD_PRODUCT_CODE}    TEST001
${STANDARD_PRODUCT_PRICE}    100000
${STANDARD_PRODUCT_COST}    50000
${STANDARD_PRODUCT_CATEGORY_ID}    1
${STANDARD_PRODUCT_TYPE}    1    # Regular product

# Common data
${INVALID_JSON}    {không phải JSON hợp lệ}
${INVALID_BRANCH_JSON}    {cấu trúc chi nhánh không hợp lệ}
${PRODUCT_WITH_SPECIAL_CHARS}    Sản   Phẩm   Test  #@& 
${PRODUCT_NAME_NORMALIZED}    Sản Phẩm Test
${PRODUCT_WITHOUT_CODE}    Sản phẩm không có mã
${PRODUCT_WITHOUT_COST_PERMISSION}    Sản phẩm không quyền giá vốn

# Branch data
@{SELECTED_BRANCHES}    1    2
${BRANCH_ID}    1

# Request templates
&{STANDARD_PRODUCT_REQUEST}    Name=${STANDARD_PRODUCT_NAME}    Code=${STANDARD_PRODUCT_CODE}    CategoryId=${STANDARD_PRODUCT_CATEGORY_ID}    Price=${STANDARD_PRODUCT_PRICE}    Cost=${STANDARD_PRODUCT_COST}    ProductType=${STANDARD_PRODUCT_TYPE}    IsActive=${TRUE}

&{COMBO_PRODUCT_TEMPLATE}    Name=Combo Product    CategoryId=${STANDARD_PRODUCT_CATEGORY_ID}    Price=${STANDARD_PRODUCT_PRICE}    Cost=${STANDARD_PRODUCT_COST}    ProductType=2    IsActive=${TRUE}

# Error messages
${ERROR_INVALID_REQUEST}    Tham số truyền vào không hợp lệ
${ERROR_PRODUCT_LIMIT_COMBO}    Không thể gửi quá 50 sản phẩm combo trong một lần
${ERROR_PRODUCT_LIMIT}    Không thể gửi quá 200 sản phẩm trong một lần
${ERROR_DB_UPDATE}    Có lỗi trong quá trình cập nhật dữ liệu

# SQL queries
${QUERY_GET_PRODUCT_BY_NAME}    SELECT Id, Name, Code, Cost FROM Product WHERE Name = ? AND RetailerId = ?
${QUERY_GET_PRODUCT_BY_CODE}    SELECT Id, Name, Code, Cost FROM Product WHERE Code = ? AND RetailerId = ?
${QUERY_GET_PRODUCT_BRANCHES}    SELECT BranchId FROM ProductBranch WHERE ProductId = ? AND RetailerId = ? 