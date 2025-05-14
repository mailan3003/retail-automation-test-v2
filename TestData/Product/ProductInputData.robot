*** Variables ***
# Standard product data
${STANDARD_PRODUCT_NAME}    Sản phẩm test tự động
${STANDARD_PRODUCT_PRICE}    100000
${STANDARD_PRODUCT_COST}    50000
${STANDARD_PRODUCT_CATEGORY_ID}    1000000705
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
&{STANDARD_PRODUCT_REQUEST}    Name=${STANDARD_PRODUCT_NAME}    CategoryId=${STANDARD_PRODUCT_CATEGORY_ID}    BasePrice=${STANDARD_PRODUCT_PRICE}    Cost=${STANDARD_PRODUCT_COST}    ProductType=${STANDARD_PRODUCT_TYPE}    IsActive=${TRUE}    Description=Mô tả sản phẩm test    ConversionValue=1    Unit=Chiếc

&{COMBO_PRODUCT_TEMPLATE}    Name=Combo Product    CategoryId=${STANDARD_PRODUCT_CATEGORY_ID}    BasePrice=${STANDARD_PRODUCT_PRICE}    Cost=${STANDARD_PRODUCT_COST}    ProductType=1    IsActive=${TRUE}

# Error messages
${ERROR_INVALID_REQUEST}    Tham số truyền vào không hợp lệ
${ERROR_PRODUCT_LIMIT_COMBO}    Hệ thống chỉ hỗ trợ tạo tối đa 50 hàng hóa combo cùng loại
${ERROR_PRODUCT_LIMIT}    Hệ thống chỉ hỗ trợ tạo tối đa 200 hàng hóa cùng loại
${ERROR_DB_UPDATE}    Có lỗi trong quá trình cập nhật dữ liệu
${JSON_ERROR_RESPONSE}    Expected ':' but got: t. Path '', line 1, position 5
${ERROR_DUPLICATE_UNIT}    Tên đơn vị tính không được phép trùng nhau
${ERROR_GLOBAL_SUMMARY}    Dữ liệu không hợp lệ
${ERROR_DUPLICATE_PRODUCT_CODE}    Mã hàng: {0} đã tồn tại
${ERROR_DUPLICATE_BARCODE}    Mã vạch {0} đã tồn tại
${ERROR_INVALID_FORMULA}    Công thức sản phẩm không hợp lệ
${ERROR_SHELF_NOT_FOUND}    Vị trí không tồn tại
${ERROR_SERIAL_UNIT}    Sản phẩm Serial/Imei không được có sản phẩm đơn vị tính
${ERROR_CODE_LENGTH}    Vui lòng nhập Mã hàng hóa không quá 40 kí tự
${ERROR_BARCODE_LENGTH}    Mã vạch không được vượt quá 16 ký tự
${ERROR_NAME_LENGTH}    Tên đầy đủ của hàng hóa ( Tên hàng+Thuộc tính+Đơn vị tính) không vượt quá 500 kí tự

# SQL queries
${QUERY_GET_PRODUCT_BY_NAME}    SELECT Id, Name, Code, Cost FROM Product WHERE Name = ? AND RetailerId = ?
${QUERY_GET_PRODUCT_BY_CODE}    SELECT Id, Name, Code, Cost FROM Product WHERE Code = ? AND RetailerId = ?
${QUERY_GET_PRODUCT_BRANCHES}    SELECT BranchId FROM ProductBranch WHERE ProductId = ? AND RetailerId = ?
${QUERY_GET_PRODUCT_BY_RETAILER}    SELECT TOP 1 Id, Code, Barcode FROM Product WHERE RetailerId = ? AND (isDeleted = 0 OR isDeleted IS NULL)
${QUERY_GET_PRODUCT_BY_RETAILER_BARCODE}    SELECT TOP 1 Id, Code, Barcode FROM Product WHERE RetailerId = ? AND Barcode IS NOT NULL AND Barcode <> '' AND (isDeleted = 0 OR isDeleted IS NULL)

# Formula validation
${MAX_FORMULA_DEPTH}    5
${PRODUCT_ID}    1000014184
${PRODUCT_CODE}    HH0116

# SQL queries for formula validation
${QUERY_GET_SUB_UNIT_PRODUCT}    SELECT TOP 1 Id, Code FROM Product WHERE RetailerId = ? AND MasterUnitId IS NOT NULL AND (isDeleted = 0 OR isDeleted IS NULL)

# Error messages for formula validation
${ERROR_RECURSIVE_FORMULA}    Hàng thành phần và hàng sản xuất không được lồng nhau
${ERROR_SUB_UNIT_IN_FORMULA}    Sản phẩm {0} không phải là đơn vị cơ bản, không thể tạo thành phần từ hàng hóa này
${ERROR_FORMULA_DEPTH}    Độ sâu công thức vượt quá giới hạn cho phép

# Unit validation error messages
${ERROR_NOT_INPUT_UNIT}    Chưa nhập đơn vị cơ bản
${ERROR_INVALID_MASTER_UNIT}    MasterUnitId không hợp lệ
${PARENT_PRODUCT_ID}    1000014200
${CHILD_PRODUCT_ID}    1000014176
${PARENT_PRODUCT_ID_NOT_EXIST_MASTER_UNIT}    1000017738
${PARENT_PRODUCT_UNIT_NOT_EXIST_MASTER_UNIT}    Chiếc
