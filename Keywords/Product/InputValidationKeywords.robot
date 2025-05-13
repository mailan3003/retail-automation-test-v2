*** Settings ***
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Resource          ../../TestData/Product/ProductInputData.robot

*** Variables ***
${PRODUCT_API_ENDPOINT}     /products/addmany

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
    ${response}=    Call API With Form Data    ${PRODUCT_API_ENDPOINT}    ${REQUEST_DATA}    ${REQUEST_FILES}
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
        ${product}=    Set To Dictionary    ${product}    Name=Combo Product ${index}
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
        ${product}=    Set To Dictionary    ${product}    Name=Product ${index}    Code=P${index}    ProductType=2
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
    ${request_data}=    Set To Dictionary    ${request_data}    Name=${long_name}
    ${list_products}=    Create List    ${request_data}
    ${request}=    Create Dictionary    ListProducts=${list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Trùng Tên
    ${product_base}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${product_base}=    Set To Dictionary    ${product_base}    Name=Sản phẩm đơn vị trùng    Code=SPT001
    
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
        Append To List    ${list_products}    ${product_copy}
    END
    
    ${json_string}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_string}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Không Trùng
    ${product_base}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${product_base}=    Set To Dictionary    ${product_base}    Name=Sản phẩm đơn vị không trùng    Code=SPK001
    
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
        ${product_copy}=    Set To Dictionary    ${product_copy}    Unit=${unit["Unit"]}    ConversionValue=${unit["ConversionValue"]}    IsDefaultUnit=${unit["IsDefault"]}    AttributedName=${unit["AttributedName"]}
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
    ${request_data}=    Set To Dictionary    ${request_data}    Code=${product_code}
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
    ${request_data}=    Set To Dictionary    ${request_data}    Barcode=${barcode}
    ${list_products}=    Create List    ${request_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    ${message}=    Set Variable    Mã vạch ${barcode} đã tồn tại
    Set Test Variable    ${ErrorMessage}    ${message}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Công Thức Không Hợp Lệ
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${formula}=    Create Dictionary    MaterialId=999999    Quantity=1
    ${formulas}=    Create List    ${formula}
    ${request_data}=    Set To Dictionary    ${request_data}    ProductFormulas=${formulas}
    ${list_products}=    Create List    ${request_data}
    ${request}=    Create Dictionary    ListProductsString=${list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Số Lượng Vị Trí Không Tồn Tại
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${shelf}=    Create Dictionary    ShelvesId=999999    ProductId=0
    ${shelves}=    Create List    ${shelf}
    ${request_data}=    Set To Dictionary    ${request_data}    ProductShelves=${shelves}
    ${list_products}=    Create List    ${request_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Giá Trị Chuyển Đổi Không Hợp Lệ
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${request_data}=    Set To Dictionary    ${request_data}    ConversionValue=0
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
    ${request_data}=    Set To Dictionary    ${request_data}    IsLotSerialControl=${TRUE}
    ${unit}=    Create Dictionary    Unit=Chiếc    ConversionValue=1
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
    ${request_data}=    Set To Dictionary    ${request_data}    Code=${long_code}
    ${list_products}=    Create List    ${request_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Mã Vạch Dài 17 Ký Tự
    ${long_barcode}=    Evaluate    "1" * 17
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${request_data}=    Set To Dictionary    ${request_data}    Barcode=${long_barcode}
    ${list_products}=    Create List    ${request_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Tên Dài 501 Ký Tự
    ${long_name}=    Evaluate    "A" * 501
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${request_data}=    Set To Dictionary    ${request_data}    Name=${long_name}
    ${list_products}=    Create List    ${request_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Danh Sách Vật Liệu Rỗng
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${request_data}=    Set To Dictionary    ${request_data}    ProductFormulas=${EMPTY}
    ${list_products}=    Create List    ${request_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Vật Liệu Là Chính Nó
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${formula}=    Create Dictionary    MaterialId=${PRODUCT_ID}    Quantity=1
    ${formulas}=    Create List    ${formula}
    ${request_data}=    Set To Dictionary    ${request_data}    ProductFormulas=${formulas}
    ${list_products}=    Create List    ${request_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    ${message}=    Set Variable    ${PRODUCT_CODE}: Hàng thành phần và hàng sản xuất không được lồng nhau
    Set Test Variable    ${ERROR_RECURSIVE_FORMULA}    ${message}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Vật Liệu Là Đơn Vị Con
    ${sub_unit_product}=    Fetch One    ${QUERY_GET_SUB_UNIT_PRODUCT}    ${RETAILER_ID}
    Should Not Be Equal    ${sub_unit_product}    None    Không tìm thấy sản phẩm đơn vị con để test
    ${sub_unit_id}=    Set Variable    ${sub_unit_product[0]}
    ${sub_unit_code}=    Set Variable    ${sub_unit_product[1]}
    
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${formula}=    Create Dictionary    MaterialId=${sub_unit_id}    Quantity=1
    ${formulas}=    Create List    ${formula}
    ${request_data}=    Set To Dictionary    ${request_data}    ProductFormulas=${formulas}
    ${list_products}=    Create List    ${request_data}
    ${json_list_products}=    Evaluate    json.dumps(${list_products})    json
    ${request}=    Create Dictionary    ListProductsString=${json_list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    ${message}=    Set Variable    không cho phép sử dụng sản phẩm không phải đơn vị chính trong công thức
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