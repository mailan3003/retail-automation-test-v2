*** Settings ***
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Resource          ../../TestData/Product/ProductInputData.robot
Resource          Product_KeywordsCommand.robot

*** Variables ***
${PRODUCT_API_ENDPOINT}     products/addmany

*** Keywords ***
Chuẩn Bị Dữ Liệu Sản Phẩm Tiêu Chuẩn
    ${branch_pr_cost}=        Set Variable     "Id":${BRANCH_ID},"Name":"Chi nhánh trung tâm"
    ${branch_pr_cost}     Evaluate    (None, '[{${branch_pr_cost}}]')
    ${form_data}=    Evaluate    str(${list_product_data}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProducts=${list_products}      BranchForProductCostss=${branch_pr_cost}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

Gửi Yêu Cầu Thêm Sản Phẩm
    ${response}=    Call API With Form Data    ${API_MAN_URL}    ${PRODUCT_API_ENDPOINT}    ${REQUEST_DATA}    ${REQUEST_FILES}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}

Nội dung phản hồi trả về phải tồn tại Id
    Dictionary Should Contain Key    ${RESPONSE.json()}    Id
    ${id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Should Be True    ${id} > 0

Chuẩn Bị Dữ Liệu Sản Phẩm Với JSON Không Hợp Lệ
    ${request}=    Create Dictionary    ListProductsString=${INVALID_JSON}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    ${files}=    Create Dictionary
    ${stream}=    Get File For Streaming Upload    Resources/angularjs.png
    ${files}=    Set To Dictionary    ${files}    randombytes1=${stream}

    Set Test Variable    ${REQUEST_FILES}    ${files}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Với 51 Sản Phẩm Combo
    ${list_products}=    Create List
    FOR    ${index}    IN RANGE    51
        ${product}=    Deep Copy    ${COMBO_PRODUCT_TEMPLATE}
        ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
        ${product}=    Set To Dictionary    ${product}    Name=Combo Product ${index}    CategoryId=${category_id}
        Append To List    ${list_products}    ${product}
    END
    ${json_string}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_string}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Với 201 Sản Phẩm
    ${list_products}=    Create List
    FOR    ${index}    IN RANGE    201
        ${product}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
        ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
        ${product}=    Set To Dictionary    ${product}    Name=Product ${index}    Code=P${index}    ProductType=2    CategoryId=${category_id}
        Append To List    ${list_products}    ${product}
    END
    ${json_string}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_string}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Định Dạng Chi Nhánh Không Hợp Lệ
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${list_products}=    Create List
    ${json_string}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProducts=${json_string}    BranchForProductCostss=${INVALID_BRANCH_JSON}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Gây Lỗi Trong Giao Dịch DB
    # Tạo dữ liệu sản phẩm không hợp lệ gây lỗi khi lưu vào DB
    # Ví dụ: Tạo sản phẩm với tên quá dài
    ${long_name}=    Evaluate    "A" * 500
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${request_data}=    Set To Dictionary    ${request_data}    Name=${long_name}    CategoryId=${category_id}
    ${list_products}=    Create List    ${request_data}
    ${request}=    Create Dictionary    ListProducts=${list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Trùng Tên
    ${product_base}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${product_base}=    Set To Dictionary    ${product_base}    Name=Sản phẩm đơn vị trùng    Code=SPT001    CategoryId=${category_id}
    
    # Tạo danh sách các đơn vị cho sản phẩm, có hai đơn vị trùng tên (khác hoa/thường)
    ${units}=    Create List
    ${unit1}=    Create Dictionary    Unit=Chiếc    ConversionValue=1    IsDefault=${TRUE}    AttributedName=Sản phẩm đơn vị trùng
    ${unit2}=    Create Dictionary    Unit=chiếc    ConversionValue=10    IsDefault=${FALSE}    AttributedName=Sản phẩm đơn vị trùng
    ${unit3}=    Create Dictionary    Unit=Thùng    ConversionValue=50    IsDefault=${FALSE}    AttributedName=Sản phẩm đơn vị trùng
    
    Append To List    ${units}    ${unit1}
    Append To List    ${units}    ${unit2}
    Append To List    ${units}    ${unit3}
    
    ${list_products}=    Create List
    FOR    ${unit}    IN    @{units}
        ${product_copy}=    Deep Copy    ${product_base}
        ${product_copy}=    Set To Dictionary    ${product_copy}    
        ...    Unit=${unit["Unit"]}    
        ...    ConversionValue=${unit["ConversionValue"]}    
        ...    IsDefaultUnit=${unit["IsDefault"]}    
        ...    AttributedName=${unit["AttributedName"]}
        ...    CategoryId=${category_id}
        Append To List    ${list_products}    ${product_copy}
    END
    
    ${json_string}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_string}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Không Trùng
    ${product_base}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${random_code}=    Generate Random String    10    [LOWER]
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${product_base}=    Set To Dictionary    ${product_base}    Name=Sản phẩm đơn vị không trùng    Code=${random_code}    CategoryId=${category_id}
    
    # Tạo danh sách các đơn vị cho sản phẩm, không có đơn vị trùng tên
    ${units}=    Create List
    ${unit1}=    Create Dictionary    Unit=Chiếc    ConversionValue=1    IsDefault=${TRUE}    AttributedName=Sản phẩm đơn vị không trùng
    ${unit2}=    Create Dictionary    Unit=Hộp    ConversionValue=10    IsDefault=${FALSE}    AttributedName=Sản phẩm đơn vị không trùng
    ${unit3}=    Create Dictionary    Unit=Thùng    ConversionValue=50    IsDefault=${FALSE}    AttributedName=Sản phẩm đơn vị không trùng
    
    Append To List    ${units}    ${unit1}
    Append To List    ${units}    ${unit2}
    Append To List    ${units}    ${unit3}
    
    ${list_products}=    Create List
    FOR    ${unit}    IN    @{units}
        ${product_copy}=    Deep Copy    ${product_base}
        ${product_copy}=    Set To Dictionary    ${product_copy}    Unit=${unit["Unit"]}    ConversionValue=${unit["ConversionValue"]}    IsDefaultUnit=${unit["IsDefault"]}    AttributedName=${unit["AttributedName"]}    CategoryId=${category_id}
        Append To List    ${list_products}    ${product_copy}
    END
    
    ${json_string}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_string}
    ${files}=    Create Dictionary
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${REQUEST_FILES}    ${files}
    RETURN    ${REQUEST_DATA}

Xác Thực Sản Phẩm Đã Được Tạo Trong CSDL
    [Arguments]    ${product_name}
    ${query}=    Set Variable    ${QUERY_GET_PRODUCT_BY_NAME}
    ${result}=    Fetch One    ${query}    ${product_name}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm với tên ${product_name}
    ${id}=    Set Variable    ${result[0]}
    Should Be True    ${id} > 0
    RETURN    ${id}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Mã Trùng Lặp
    ${existing_product}=    Fetch One    ${QUERY_GET_PRODUCT_BY_RETAILER}    ${RETAILER_ID}
    Should Not Be Equal    ${existing_product}    None    Không tìm thấy sản phẩm để test trùng lặp mã
    ${product_code}=    Set Variable    ${existing_product[1]}
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${request_data}=    Set To Dictionary    ${request_data}    Code=${product_code}    CategoryId=${category_id}
    ${list_products}=    Create List    ${request_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    ${message}=    Set Variable    Mã hàng: ${product_code} đã tồn tại
    Set Test Variable    ${ErrorMessage}    ${message}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Mã Vạch Trùng Lặp
    ${existing_product}=    Fetch One    ${QUERY_GET_PRODUCT_BY_RETAILER_BARCODE}    ${RETAILER_ID}
    Run Keyword If    ${existing_product} is None    Fail    Không tìm thấy sản phẩm với mã vạch để test trùng lặp
    ${barcode}=    Set Variable    ${existing_product[2]}
    
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${request_data}=    Set To Dictionary    ${request_data}    Barcode=${barcode}    CategoryId=${category_id}
    ${list_products}=    Create List    ${request_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    ${message}=    Set Variable    Mã vạch ${barcode} đã tồn tại
    Set Test Variable    ${ErrorMessage}    ${message}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Công Thức Không Hợp Lệ
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${formula}=    Create Dictionary    MaterialId=999999    Quantity=1    CategoryId=${category_id}
    ${request_data}=    Set To Dictionary    ${request_data}    ProductFormulas=${formulas}
    ${list_products}=    Create List    ${request_data}
    ${request}=    Create Dictionary    ListProductsString=${list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Số Lượng Vị Trí Không Tồn Tại
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${shelf}=    Create Dictionary    ShelvesId=999999    ProductId=0    CategoryId=${category_id}
    ${shelves}=    Create List    ${shelf}
    ${request_data}=    Set To Dictionary    ${request_data}    ProductShelves=${shelves}
    ${list_products}=    Create List    ${request_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Giá Trị Chuyển Đổi Không Hợp Lệ
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${request_data}=    Set To Dictionary    ${request_data}    ConversionValue=0    CategoryId=${category_id}
    ${list_products}=    Create List    ${request_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Xác Thực Giá Trị Chuyển Đổi Đã Được Chuẩn Hóa Thành 1
    ${product_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${query}=    Set Variable    SELECT ConversionValue FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${product_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm sau khi tạo
    ${conversion_value}=    Set Variable    ${result[0]}
    Should Be Equal As Numbers    ${conversion_value}    1    Giá trị chuyển đổi không được chuẩn hóa thành 1

Chuẩn Bị Dữ Liệu Sản Phẩm Serial Với Đơn Vị Phụ
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${request_data}=    Set To Dictionary    ${request_data}    IsLotSerialControl=${TRUE}    CategoryId=${category_id}
    ${unit}=    Create Dictionary    Unit=Chiếc    ConversionValue=1    CategoryId=${category_id}
    ${units}=    Create List    ${unit}
    ${request_data}=    Set To Dictionary    ${request_data}    ProductUnits=${units}
    ${list_products}=    Create List    ${request_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Mã Dài 41 Ký Tự
    ${long_code}=    Evaluate    "A" * 41
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${request_data}=    Set To Dictionary    ${request_data}    Code=${long_code}    CategoryId=${category_id}
    ${list_products}=    Create List    ${request_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Mã Vạch Dài 17 Ký Tự
    ${long_barcode}=    Evaluate    "1" * 17
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${request_data}=    Set To Dictionary    ${request_data}    Barcode=${long_barcode}    CategoryId=${category_id}
    ${list_products}=    Create List    ${request_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Tên Dài 501 Ký Tự
    ${long_name}=    Evaluate    "A" * 501
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${request_data}=    Set To Dictionary    ${request_data}    Name=${long_name}    CategoryId=${category_id}
    ${list_products}=    Create List    ${request_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Danh Sách Vật Liệu Rỗng
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${request_data}=    Set To Dictionary    ${request_data}    ProductFormulas=${EMPTY}    CategoryId=${category_id}
    ${list_products}=    Create List    ${request_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Vật Liệu Là Chính Nó
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${formula}=    Create Dictionary    MaterialId=${PRODUCT_ID}    Quantity=1    CategoryId=${category_id}
    ${formulas}=    Create List    ${formula}
    ${request_data}=    Set To Dictionary    ${request_data}    Id=${PRODUCT_ID}
    ${request_data}=    Set To Dictionary    ${request_data}    ProductFormulas=${formulas}
    ${list_products}=    Create List    ${request_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Vật Liệu Là Đơn Vị Con
    ${sub_unit_product}=    Fetch One    ${QUERY_GET_SUB_UNIT_PRODUCT}    ${RETAILER_ID}
    Run Keyword If    ${sub_unit_product} is None    Fail    Không tìm thấy sản phẩm đơn vị con để test
    ${sub_unit_id}=    Set Variable    ${sub_unit_product[0]}
    ${sub_unit_code}=    Set Variable    ${sub_unit_product[1]}
    
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${formula}=    Create Dictionary    MaterialId=${sub_unit_id}    Quantity=1    CategoryId=${category_id}
    ${formulas}=    Create List    ${formula}
    ${request_data}=    Set To Dictionary    ${request_data}    ProductFormulas=${formulas}
    ${list_products}=    Create List    ${request_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    ${message}=    Evaluate    '''${ERROR_SUB_UNIT_IN_FORMULA}'''.format('''${sub_unit_code}''')
    Set Test Variable    ${ERROR_SUB_UNIT_IN_FORMULA}    ${message}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Vòng Lặp Đệ Quy
    ${product_a}=    Fetch One    ${QUERY_GET_PRODUCT_BY_RETAILER}    ${RETAILER_ID}
    Should Not Be Equal    ${product_a}    None    Không tìm thấy sản phẩm A để test vòng lặp đệ quy
    ${product_b}=    Fetch One    ${QUERY_GET_PRODUCT_BY_RETAILER}    ${RETAILER_ID}
    Should Not Be Equal    ${product_b}    None    Không tìm thấy sản phẩm B để test vòng lặp đệ quy
    
    # Tạo công thức cho sản phẩm A chứa B
    ${request_data_a}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${formula_a}=    Create Dictionary    MaterialId=${product_b[0]}    Quantity=1
    ${formulas_a}=    Create List    ${formula_a}
    ${request_data_a}=    Set To Dictionary    ${request_data_a}    ProductFormulas=${formulas_a}
    
    # Tạo công thức cho sản phẩm B chứa A
    ${request_data_b}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${formula_b}=    Create Dictionary    MaterialId=${product_a[0]}    Quantity=1
    ${formulas_b}=    Create List    ${formula_b}
    ${request_data_b}=    Set To Dictionary    ${request_data_b}    ProductFormulas=${formulas_b}
    
    ${list_products}=    Create List    ${request_data_a}    ${request_data_b}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    ${message}=    Set Variable    ${product_a[1]},${product_b[1]}: Hàng thành phần và hàng sản xuất không được lồng nhau
    Set Test Variable    ${ERROR_RECURSIVE_FORMULA}    ${message}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Công Thức Quá Sâu
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${formulas}=    Create List
    
    # Tạo chuỗi công thức với độ sâu vượt quá giới hạn
    ${current_id}=    Set Variable    ${PRODUCT_ID}
    FOR    ${index}    IN RANGE    ${MAX_FORMULA_DEPTH} + 1
        ${formula}=    Create Dictionary    MaterialId=${current_id}    Quantity=1
        Append To List    ${formulas}    ${formula}
        ${current_id}=    Evaluate    ${current_id} + 1
    END
    
    ${request_data}=    Set To Dictionary    ${request_data}    ProductFormulas=${formulas}
    ${list_products}=    Create List    ${request_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    ${message}=    Set Variable    Độ sâu công thức vượt quá giới hạn cho phép
    Set Test Variable    ${ERROR_FORMULA_DEPTH}    ${message}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Công Thức Hợp Lệ
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${formulas}=    Create List
    
    # Tạo công thức hợp lệ với độ sâu trong giới hạn
    ${current_id}=    Set Variable    ${PRODUCT_ID}
    FOR    ${index}    IN RANGE    ${MAX_FORMULA_DEPTH}
        ${formula}=    Create Dictionary    MaterialId=${current_id}    Quantity=1
        Append To List    ${formulas}    ${formula}
        ${current_id}=    Evaluate    ${current_id} + 1
    END
    
    ${request_data}=    Set To Dictionary    ${request_data}    ProductFormulas=${formulas}
    ${list_products}=    Create List    ${request_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Con Với Đơn Vị Trống
    ${data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${data}=    Set To Dictionary    ${data}    Name=Sản phẩm con không có đơn vị    MasterUnitId=${PARENT_PRODUCT_ID}    Unit=${EMPTY}    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Con Với Sản Phẩm Cha Là Sản Phẩm Con
    ${data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${data}=    Set To Dictionary    ${data}    Name=Sản phẩm con với cha là sản phẩm con    MasterUnitId=${CHILD_PRODUCT_ID}    Unit=Chiếc    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Con Với Tên Đơn Vị Trùng Sản Phẩm Con Khác
    ${data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${data}=    Set To Dictionary    ${data}    Name=Sản phẩm con trùng đơn vị với cha    MasterUnitId=${PARENT_PRODUCT_ID_NOT_EXIST_MASTER_UNIT}    Unit=${DUPLICATE_UNIT_NAME}    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Con Với Đơn Vị Tính Hợp Lệ
    ${data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${product}=    Create Dictionary    
    ...    Code=SP_CON_005    
    ...    Name=Sản phẩm con với đơn vị hợp lệ    
    ...    MasterUnitId=${PARENT_PRODUCT_ID}    
    ...    Unit=Hộp
    ...    CategoryId=${category_id}
    ${data}=    Set To Dictionary    ${data}    ${product}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính Không Tồn Tại
    ${product_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${invalid_attributes}=    Create List
    ${attribute}=    Create Dictionary    AttributeId=999999    Value=Test Value    CategoryId=${category_id}
    Append To List    ${invalid_attributes}    ${attribute}
    ${product_data}=    Set To Dictionary    ${product_data}    ProductAttributes=${invalid_attributes}
    ${list_products}=    Create List    ${product_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Mô Tả Rỗng
    ${data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${data}=    Set To Dictionary    ${data}    Description=${EMPTY}    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Mô Tả Vượt Quá Giới Hạn
    ${data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${large_description}=    Evaluate    "a" * 1048576    # Tạo chuỗi khoảng 1MB ký tự
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${data}=    Set To Dictionary    ${data}    Description=${large_description}    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Mô Tả Hợp Lệ
    ${data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${data}=    Set To Dictionary    ${data}    Description=Mô tả sản phẩm hợp lệ với đầy đủ thông tin chi tiết    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Dược Phẩm Với GPP Không Hoạt Động
    ${data}=    Deep Copy    ${STANDARD_MEDICINE_PRODUCT}    
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME_DRUG}
    ${random_code}=    Generate Random String    10    [LOWER]
    ${data}=    Set To Dictionary    ${data}    
    ...    Code=${random_code}
    ...    IsActiveGppDrugStore=${FALSE}
    ...    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Dược Phẩm Với Quốc Gia Không Tồn Tại
    ${data}=    Deep Copy    ${STANDARD_MEDICINE_PRODUCT}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME_DRUG}
    ${data}=    Set To Dictionary    ${data}    
    ...    Code=DP002    
    ...    GlobalManufacturerCountryName=Quốc gia không tồn tại
    ...    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${ERROR_MESSAGE}    ${ERROR_MANUFACTURER_COUNTRY}

Chuẩn Bị Dữ Liệu Sản Phẩm Dược Phẩm Với Nhà Sản Xuất Không Tồn Tại
    ${data}=    Deep Copy    ${STANDARD_MEDICINE_PRODUCT}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME_DRUG}
    ${data}=    Set To Dictionary    ${data}    
    ...    Code=DP003    
    ...    GlobalManufacturerId=999999
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${ERROR_MESSAGE}    ${ERROR_MANUFACTURER}

Chuẩn Bị Dữ Liệu Sản Phẩm Dược Phẩm Với Tên Ngắn Dài 101 Ký Tự
    ${long_short_name}=    Evaluate    "A" * 101
    ${data}=    Deep Copy    ${STANDARD_MEDICINE_PRODUCT}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME_DRUG}
    ${data}=    Set To Dictionary    ${data}
    ...    ShortName=${long_short_name}
    ...    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Dược Phẩm Với Đường Dùng Dài 201 Ký Tự
    ${long_route}=    Evaluate    "A" * 201
    ${data}=    Deep Copy    ${STANDARD_MEDICINE_PRODUCT}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME_DRUG}
    ${data}=    Set To Dictionary    ${data}    
    ...    RouteOfAdministration=${long_route}
    ...    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Dược Phẩm Hợp Lệ
    ${data}=    Deep Copy    ${STANDARD_MEDICINE_PRODUCT}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME_DRUG}
    ${data}=    Set To Dictionary    ${data}    Code=DP006    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}

# Các keywords mới cho chức năng ValidateMedicine

Chuẩn Bị Dữ Liệu Sản Phẩm Dược Phẩm Với Đường Dùng Trống
    ${data}=    Deep Copy    ${STANDARD_MEDICINE_PRODUCT}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME_DRUG}
    ${data}=    Set To Dictionary    ${data}    RouteOfAdministration=${EMPTY}    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}    IsRetailerMedicine=${TRUE}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Dược Phẩm Với Số Đăng Ký Trống
    ${data}=    Deep Copy    ${STANDARD_MEDICINE_PRODUCT}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME_DRUG}
    ${data}=    Set To Dictionary    ${data}    RegistrationNo=${EMPTY}    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}    IsRetailerMedicine=${TRUE}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Dược Phẩm Với Hoạt Chất Trống
    ${data}=    Deep Copy    ${STANDARD_MEDICINE_PRODUCT}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME_DRUG}
    ${data}=    Set To Dictionary    ${data}    ActiveElement=${EMPTY}    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}    IsRetailerMedicine=${TRUE}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Dược Phẩm Với Hàm Lượng Trống
    ${data}=    Deep Copy    ${STANDARD_MEDICINE_PRODUCT}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME_DRUG}
    ${data}=    Set To Dictionary    ${data}    Content=${EMPTY}    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}    IsRetailerMedicine=${TRUE}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Dược Phẩm Với Quy Cách Đóng Gói Trống
    ${data}=    Deep Copy    ${STANDARD_MEDICINE_PRODUCT}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME_DRUG}
    ${data}=    Set To Dictionary    ${data}    PackagingSize=${EMPTY}    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}    IsRetailerMedicine=${TRUE}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Dược Phẩm Với Đơn Vị Cơ Bản Trống
    ${data}=    Deep Copy    ${STANDARD_MEDICINE_PRODUCT}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME_DRUG}
    ${data}=    Set To Dictionary    ${data}    Unit=${EMPTY}    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}    IsRetailerMedicine=${TRUE}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Dược Phẩm Với Nhà Sản Xuất Trống
    ${data}=    Deep Copy    ${STANDARD_MEDICINE_PRODUCT}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME_DRUG}
    ${data}=    Set To Dictionary    ${data}    ManufacturerId=${NULL}    GlobalManufacturerId=${NULL}    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}    IsRetailerMedicine=${TRUE}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Dược Phẩm Với Tên Dài 101 Ký Tự Đồng Bộ DQG
    ${data}=    Deep Copy    ${STANDARD_MEDICINE_PRODUCT}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME_DRUG}
    ${long_name}=    Evaluate    "M" * 101
    ${data}=    Set To Dictionary    ${data}    Name=${long_name}    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}    IsRetailerMedicine=${TRUE}    IsSyncNationalPharmacy=${TRUE}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Dược Phẩm Với Số Đăng Ký Dài 21 Ký Tự Đồng Bộ DQG
    ${long_reg_no}=    Evaluate    "R" * 21
    ${data}=    Deep Copy    ${STANDARD_MEDICINE_PRODUCT}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME_DRUG}
    ${data}=    Set To Dictionary    ${data}    RegistrationNo=${long_reg_no}    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}    IsRetailerMedicine=${TRUE}    IsSyncNationalPharmacy=${TRUE}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Dược Phẩm Với Hoạt Chất Dài 201 Ký Tự Đồng Bộ DQG
    ${long_active}=    Evaluate    "A" * 201
    ${data}=    Deep Copy    ${STANDARD_MEDICINE_PRODUCT}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME_DRUG}
    ${data}=    Set To Dictionary    ${data}    ActiveElement=${long_active}    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}    IsRetailerMedicine=${TRUE}    IsSyncNationalPharmacy=${TRUE}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Dược Phẩm Với Hàm Lượng Dài 201 Ký Tự Đồng Bộ DQG
    ${long_content}=    Evaluate    "C" * 201
    ${data}=    Deep Copy    ${STANDARD_MEDICINE_PRODUCT}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME_DRUG}
    ${data}=    Set To Dictionary    ${data}    Content=${long_content}    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}    IsRetailerMedicine=${TRUE}    IsSyncNationalPharmacy=${TRUE}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Dược Phẩm Với Quy Cách Đóng Gói Dài 51 Ký Tự Đồng Bộ DQG
    ${long_packaging}=    Evaluate    "P" * 51
    ${data}=    Deep Copy    ${STANDARD_MEDICINE_PRODUCT}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME_DRUG}
    ${data}=    Set To Dictionary    ${data}    PackagingSize=${long_packaging}    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}    IsRetailerMedicine=${TRUE}    IsSyncNationalPharmacy=${TRUE}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Dược Phẩm Với Tên Nhà Sản Xuất Dài 101 Ký Tự Đồng Bộ DQG
    ${data}=    Deep Copy    ${STANDARD_MEDICINE_PRODUCT}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME_DRUG}
    ${data}=    Set To Dictionary    ${data}    ManufacturerId=${EXCEED_NAME_MEDICINE_MANUFACTURER_ID}    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}    IsRetailerMedicine=${TRUE}    IsSyncNationalPharmacy=${TRUE}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Dược Phẩm Với Đơn Vị Cơ Bản Dài 101 Ký Tự Đồng Bộ DQG
    ${data}=    Deep Copy    ${STANDARD_MEDICINE_PRODUCT}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME_DRUG}
    ${long_unit}=    Evaluate    "U" * 101
    ${data}=    Set To Dictionary    ${data}    Unit=${long_unit}    CategoryId=${category_id}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}    IsRetailerMedicine=${TRUE}    IsSyncNationalPharmacy=${TRUE}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# Warehouse stocktake validation keywords
Chuẩn Bị Dữ Liệu Sản Phẩm Với Kiểm Kê Kho Hợp Lệ
    ${data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    
    # Tạo thông tin kiểm kê kho hợp lệ
    ${stocktakes}=    Create List
    ${stocktake1}=    Create Dictionary    BranchId=${ACTIVE_WAREHOUSE_ID}    OnHand=10
    ${stocktake2}=    Create Dictionary    BranchId=${ACTIVE_WAREHOUSE_ID_2}    OnHand=20
    Append To List    ${stocktakes}    ${stocktake1}
    Append To List    ${stocktakes}    ${stocktake2}
    
    ${data}=    Set To Dictionary    ${data}    ProductWithWarehouseStockTakes=${stocktakes}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Mã Kho Đã Xóa
    ${data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_HANG_HOA_DAKHO}
    ${data}=    Set To Dictionary    ${data}    CategoryId=${category_id}
    ${stocktakes}=    Create List
    ${stocktake1}=    Create Dictionary    BranchId=${DELETED_WAREHOUSE_ID}    OnHand=10
    Append To List    ${stocktakes}    ${stocktake1}
    
    ${data}=    Set To Dictionary    ${data}    ProductWithWarehouseStockTakes=${stocktakes}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Kho Không Hoạt Động
    ${data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_HANG_HOA_DAKHO}
    ${data}=    Set To Dictionary    ${data}    CategoryId=${category_id}
    # Tạo thông tin kiểm kê kho với kho không hoạt động
    ${stocktakes}=    Create List
    ${stocktake1}=    Create Dictionary    BranchId=${INACTIVE_WAREHOUSE_ID}    OnHand=10
    Append To List    ${stocktakes}    ${stocktake1}
    
    ${data}=    Set To Dictionary    ${data}    ProductWithWarehouseStockTakes=${stocktakes}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Kiểm Soát Lô Với Kiểm Kê Kho
    ${data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_HANG_HOA_DAKHO}
    ${data}=    Set To Dictionary    ${data}    CategoryId=${category_id}
    ${data}=    Set To Dictionary    ${data}    IsBatchExpireControl=${TRUE}
    
    # Tạo thông tin kiểm kê kho
    ${stocktakes}=    Create List
    ${stocktake1}=    Create Dictionary    BranchId=${ACTIVE_WAREHOUSE_ID}    OnHand=10
    Append To List    ${stocktakes}    ${stocktake1}
    
    ${data}=    Set To Dictionary    ${data}    ProductWithWarehouseStockTakes=${stocktakes}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Kiểm Soát Serial Với Kiểm Kê Kho
    ${data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_HANG_HOA_DAKHO}
    ${data}=    Set To Dictionary    ${data}    IsLotSerialControl=${TRUE}    Name=Hàng hóa kiểm soát lô      CategoryId=${category_id}
    
    # Tạo thông tin kiểm kê kho
    ${stocktakes}=    Create List
    ${stocktake1}=    Create Dictionary    BranchId=${ACTIVE_WAREHOUSE_ID}    OnHand=10
    Append To List    ${stocktakes}    ${stocktake1}
    
    ${data}=    Set To Dictionary    ${data}    ProductWithWarehouseStockTakes=${stocktakes}
    ${list_products}=    Create List    ${data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Mã Đơn Vị Con Trùng Lặp
    ${product_base}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${product_base}=    Set To Dictionary    ${product_base}    Name=Sản phẩm chính    CategoryId=${category_id}
    
    # Tạo danh sách các đơn vị con, có hai đơn vị con có mã trùng lặp
    
    ${child1}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${child1}=    Set To Dictionary    ${child1}    Name=Sản phẩm con 1    CategoryId=${category_id}
    ...    Code=${DUPLICATE_CHILD_CODE}    # Mã trùng lặp
    ...    Unit=Hộp
    ...    ConversionValue=10
    ...    BasePrice=${STANDARD_PRODUCT_PRICE}
    ...    Cost=${STANDARD_PRODUCT_COST}
    ...    OnHand=5
    
    ${child2}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${child2}=    Set To Dictionary    ${child2}    Name=Sản phẩm con 2    CategoryId=${category_id}
    ...    Code=${DUPLICATE_CHILD_CODE}    # Mã trùng lặp
    ...    Unit=Thùng
    ...    ConversionValue=50
    ...    BasePrice=${STANDARD_PRODUCT_PRICE}
    ...    Cost=${STANDARD_PRODUCT_COST}
    ...    OnHand=2
    
    ${list_products}=    Create List
    Append To List    ${list_products}    ${product_base}
    Append To List    ${list_products}    ${child1}
    Append To List    ${list_products}    ${child2}
    ${json_string}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_string}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Mã Đơn Vị Con Không Trùng
    ${product_base}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${product_base}=    Set To Dictionary    ${product_base}    Name=Sản phẩm chính    CategoryId=${category_id}
    ${UNIQUE_CHILD_CODE}=    Generate Random String    6    [UPPER]
    ${UNIQUE_CHILD_CODE_2}=    Generate Random String    6    [UPPER]
    
    # Tạo danh sách các đơn vị con, có hai đơn vị con có mã trùng lặp
    
    ${child1}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${child1}=    Set To Dictionary    ${child1}    Name=Sản phẩm con 1    CategoryId=${category_id}
    ...    Code=${UNIQUE_CHILD_CODE}    # Mã trùng lặp
    ...    Unit=Hộp
    ...    ConversionValue=10
    ...    BasePrice=${STANDARD_PRODUCT_PRICE}
    ...    Cost=${STANDARD_PRODUCT_COST}
    ...    OnHand=5
    
    ${child2}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${child2}=    Set To Dictionary    ${child2}    Name=Sản phẩm con 2    CategoryId=${category_id}
    ...    Code=${UNIQUE_CHILD_CODE_2}    # Mã trùng lặp
    ...    Unit=Thùng
    ...    ConversionValue=50
    ...    BasePrice=${STANDARD_PRODUCT_PRICE}
    ...    Cost=${STANDARD_PRODUCT_COST}
    ...    OnHand=2
    
    ${list_products}=    Create List
    Append To List    ${list_products}    ${product_base}
    Append To List    ${list_products}    ${child1}
    Append To List    ${list_products}    ${child2}
    ${json_string}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_string}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${REQUEST_DATA}
