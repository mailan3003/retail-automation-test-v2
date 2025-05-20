*** Variables ***
# Standard product data
${STANDARD_PRODUCT_NAME}    Sản phẩm test tự động
${STANDARD_PRODUCT_PRICE}    100000
${STANDARD_PRODUCT_COST}    50000
${STANDARD_PRODUCT_CATEGORY_ID}    1000000705
${STANDARD_PRODUCT_TYPE}    2    # Regular product

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
&{STANDARD_PRODUCT_REQUEST}    
...    Name=${STANDARD_PRODUCT_NAME}    
...    Code=${EMPTY}    
...    CategoryId=${STANDARD_PRODUCT_CATEGORY_ID}    
...    BasePrice=${STANDARD_PRODUCT_PRICE}    
...    Cost=${STANDARD_PRODUCT_COST}    
...    ProductType=${STANDARD_PRODUCT_TYPE}    
...    IsActive=${TRUE}    
...    Description=Mô tả sản phẩm test    
...    ConversionValue=1    
...    Unit=Chiếc
...    OnHand=10

&{COMBO_PRODUCT_TEMPLATE}    Name=Combo Product    CategoryId=${STANDARD_PRODUCT_CATEGORY_ID}    BasePrice=${STANDARD_PRODUCT_PRICE}    Cost=${STANDARD_PRODUCT_COST}    ProductType=1    IsActive=${TRUE}

# Medicine product data
&{STANDARD_MEDICINE_PRODUCT}    
    ...    Name=Sản phẩm dược phẩm test
    ...    Code=${EMPTY}
    ...    CategoryId=${STANDARD_PRODUCT_CATEGORY_ID}
    ...    BasePrice=${STANDARD_PRODUCT_PRICE}
    ...    Cost=${STANDARD_PRODUCT_COST}
    ...    ProductType=${STANDARD_PRODUCT_TYPE}
    ...    IsActive=${TRUE}
    ...    Description=Mô tả sản phẩm dược phẩm test
    ...    ConversionValue=1
    ...    Unit=Viên
    ...    IsMedicineProduct=${TRUE}
    ...    ShortName=Tên ngắn hợp lệ
    ...    RouteOfAdministration=Đường dùng hợp lệ    
    ...    GlobalManufacturerCountryName=Việt Nam    
    ...    GlobalManufacturerId=${VALID_MANUFACTURER_ID}
    ...    RegistrationNo=Số đăng ký hợp lệ
    ...    ActiveElement=Hoạt chất hợp lệ
    ...    Content=Hàm lượng hợp lệ
    ...    PackagingSize=Quy cách đóng gói hợp lệ

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
${ERROR_DESCRIPTION_SIZE}    Mô tả hàng hóa không được lớn quá ${MAX_SIZE_PRODUCT_DESCRIPTION} MB

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
${PARENT_PRODUCT_ID_NOT_EXIST_MASTER_UNIT}    1000017550
${DUPLICATE_UNIT_NAME}    hộp tự gen

# New variables for product attribute validation test cases
${ERROR_ATTRIBUTE_NOT_FOUND}    Thuộc tính đã bị xóa. Vui lòng kiểm tra lại.
${VALID_ATTRIBUTE_ID}    1

${MAX_SIZE_PRODUCT_DESCRIPTION}    1    # Giới hạn kích thước mô tả sản phẩm (MB)

# Medicine validation error messages
${ERROR_MANUFACTURER_COUNTRY}    Nước sản xuất không hợp lệ
${ERROR_MANUFACTURER}    Nhà sản xuất không tồn tại
${ERROR_SHORT_NAME_LENGTH}    Vui lòng nhập Tên viết tắt không quá 100 kí tự
${ERROR_ROUTE_LENGTH}    Vui lòng nhập Đường dùng không quá 200 kí tự

# Valid IDs for testing
${VALID_MANUFACTURER_ID}    1
${VALID_MANUFACTURER_COUNTRY_ID}    1

# List product data for standard request
${list_product_data}    {"Name":"${STANDARD_PRODUCT_NAME}","Code":"","CategoryId":${STANDARD_PRODUCT_CATEGORY_ID},"BasePrice":${STANDARD_PRODUCT_PRICE},"Cost":${STANDARD_PRODUCT_COST},"ProductType":${STANDARD_PRODUCT_TYPE},"IsActive":true,"Description":"Mô tả sản phẩm test","ConversionValue":1,"Unit":"Chiếc"}

# Error messages for medicine product validation
${ERROR_MANUFACTURER_COUNTRY}    Nước sản xuất không hợp lệ
${ERROR_SHORT_NAME_LENGTH}    Vui lòng nhập Tên viết tắt không quá 100 kí tự
${ERROR_ROUTE_LENGTH}    Vui lòng nhập Đường dùng không quá 200 kí tự
${ERROR_EMPTY_ROUTE_OF_ADMINISTRATION}    Vui lòng nhập Đường dùng trước khi lưu
${ERROR_EMPTY_REGISTRATION_NO}    Vui lòng nhập Số đăng ký trước khi lưu
${ERROR_EMPTY_ACTIVE_ELEMENT}    Vui lòng nhập Hoạt chất trước khi lưu
${ERROR_EMPTY_CONTENT}    Vui lòng nhập Hàm lượng trước khi lưu
${ERROR_EMPTY_PACKAGING_SIZE}    Vui lòng nhập Quy cách đóng gói trước khi lưu
${ERROR_EMPTY_UNIT}    Vui lòng nhập Đơn vị cơ bản trước khi lưu
${ERROR_EMPTY_MANUFACTURER}    Vui lòng nhập Hãng sản xuất trước khi lưu
${ERROR_EMPTY_MANUFACTURER_COUNTRY}    Vui lòng nhập Nước sản xuất trước khi lưu
${ERROR_MAX_LENGTH_NAME}    Tên thuốc không được vượt quá 100 kí tự.
${ERROR_MAX_LENGTH_REGISTRATION_NO}    Số đăng ký không được vượt quá 20 kí tự.
${ERROR_MAX_LENGTH_ACTIVE_ELEMENT}    Hoạt chất không được vượt quá 200 kí tự.
${ERROR_MAX_LENGTH_CONTENT}    Hàm lượng không được vượt quá 200 kí tự.
${ERROR_MAX_LENGTH_PACKAGING_SIZE}    Quy cách đóng gói không được vượt quá 50 kí tự.
${ERROR_MAX_LENGTH_MANUFACTURER}    Hãng sản xuất không được vượt quá 100 kí tự.
${ERROR_MAX_LENGTH_UNIT}    Đơn vị cơ bản không được vượt quá 100 kí tự.

${EXCEED_NAME_MEDICINE_MANUFACTURER_ID}    1000000002


# Warehouse validation error messages
${ERROR_WAREHOUSE_NOT_FOUND}    không hợp lệ
${ERROR_WAREHOUSE_INACTIVE}    đã ngừng hoạt động
${ERROR_QUANTITY_DECIMAL}    Số lượng chỉ được phép tối đa 4 chữ số thập phân
${DELETED_WAREHOUSE_ID}    1000000068
${INACTIVE_WAREHOUSE_ID}    1000000069
${ACTIVE_WAREHOUSE_ID}    1000000056
${ACTIVE_WAREHOUSE_ID_2}    1000000054

# New error message variable
${DUPLICATE_CHILD_CODE}    CHILD001
${ERROR_DUPLICATE_CHILD_CODE}    Mã đơn vị: ${DUPLICATE_CHILD_CODE} đã tồn tại