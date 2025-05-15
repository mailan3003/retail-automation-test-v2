*** Settings ***
Documentation     Keywords cho test API tạo sản phẩm
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Product/CreateProductData.robot
Library           ../../Resources/DatabaseLibrary.py
Library           ../../Resources/Databasepromotion.py
Resource          ../../TestData/Product/ProductInputData.robot
Library           String

*** Variables ***
${PRODUCT_API_ENDPOINT}     products/addmany
${WARRANTY_API_SAVE_ENDPOINT}    warranty/save
${PRODUCT_UPDATE_API_ENDPOINT}   api/products/photo
${PRODUCT_DELETE_API_ENDPOINT}   api/products/{0}

*** Keywords ***
# Keywords chuẩn bị dữ liệu
Chuẩn Bị Dữ Liệu Sản Phẩm Cơ Bản
    ${request}=    Deep Copy     ${list_product_data}
     ${random_code}=    Generate Random String    6    [NUMBERS]
     ${request}    Update Dictionary Property    ${request}    Code    HHA${random_code}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}        BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Hàng Dịch Vụ
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    DV${random_code}
    ${request}    Update Dictionary Property    ${request}    ProductType    3
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}        BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}
  
Chuẩn Bị Dữ Liệu Sản Phẩm Không Có Mã
    ${request}=    Deep Copy     ${list_product_data}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Tính Và List Quy Đổi ${name_unit} Với ${value}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${list_products}      Deep Copy    ${list_product_data}
    ${list_unit_body}     Create List

    FOR    ${item_name}   ${item_value}  IN ZIP   ${name_unit}    ${value}
        ${unit_body}    Deep Copy    ${PRODUCT_UNITS}
        ${unit_body}    Update Dictionary Property    ${unit_body}    Unit    ${item_name}
        ${unit_body}    Update Dictionary Property    ${unit_body}    ConversionValue    ${item_value}
        Append To List    ${list_unit_body}    ${unit_body}
    END
    ${list_product}        Update Nested Dictionary Property   ${list_products}    ProductUnits    ${list_unit_body}
    ${list_product_body}     Create List    ${list_product}  
    FOR    ${item_name}   ${item_value}  IN ZIP    ${name_unit}  ${value}
        ${request}=    Deep Copy    ${list_product_data}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        ${request}    Update Dictionary Property    ${request}    Code    SP${random_code}
        ${request}    Update Dictionary Property    ${request}    Unit    ${item_name}
        ${request}    Update Dictionary Property    ${request}    ConversionValue    ${item_value}
        Append To List   ${list_product_body}    ${request}
    END
    ${list_product_body}=    Evaluate     str(${list_product_body}).replace("'",'"')
    ${list_product_body}    Evaluate    (None, '${list_product_body}')
    ${payload}    Create Dictionary    ListProductsString=${list_product_body}         BranchForProductCostss=${branch_pr_cost}  
    Log     ${payload}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Tồn Kho ${on_hand} Ban Đầu
    ${request}=    Deep Copy     ${list_product_data}
     ${random_code}=    Generate Random String    6    [NUMBERS]
     ${request}    Update Dictionary Property    ${request}    Code    SP${random_code}
     ${request}    Update Dictionary Property    ${request}    OnHand    ${on_hand}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Quản Lý Lô Và Hạn Sử Dụng
    ${request}=    Deep Copy     ${list_product_data}
     ${random_code}=    Generate Random String    6    [NUMBERS]
     ${request}    Update Dictionary Property    ${request}    Code    SP${random_code}
     ${request}    Update Dictionary Property    ${request}    IsBatchExpireControl    true
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Quản Lý Serial
    ${request}=    Deep Copy     ${list_product_data}
     ${random_code}=    Generate Random String    6    [NUMBERS]
     ${request}    Update Dictionary Property    ${request}    Code    SP${random_code}
     ${request}    Update Dictionary Property    ${request}    IsLotSerialControl    true
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính ${dict_attribute_name}
    ${list_products}=    Create List
    
    # Lấy thông tin thuộc tính từ dictionary đầu vào
    ${attribute_names}=    Get Dictionary Keys    ${dict_attribute_name}
    ${length}=    Get Length    ${attribute_names}
    
    # Tạo danh sách các giá trị thuộc tính cho mỗi thuộc tính
    ${all_attribute_values}=    Create List
    FOR    ${attr_name}    IN    @{attribute_names}
        ${attr_values}=    Get From Dictionary    ${dict_attribute_name}    ${attr_name}
        Append To List    ${all_attribute_values}    ${attr_values}
    END
    
    # Tạo tất cả các tổ hợp thuộc tính
    ${combinations}=    Create List    ${EMPTY}
    FOR    ${attr_values}    IN    @{all_attribute_values}
        ${new_combinations}=    Create List
        FOR    ${combination}    IN    @{combinations}
            FOR    ${value}    IN    @{attr_values}
                ${new_combination}=    Set Variable    ${combination}${value}|
                Append To List    ${new_combinations}    ${new_combination}
            END
        END
        ${combinations}=    Set Variable    ${new_combinations}
    END
    ${list_products_code}     Create List
    # Tạo sản phẩm cho mỗi tổ hợp thuộc tính
    FOR    ${combination}    IN    @{combinations}
        ${request}=    Deep Copy    ${list_product_data}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        Append To List    ${list_products_code}    ${random_code}
        ${request}=    Update Nested Dictionary Property    ${request}    Code    SP${random_code}
        
        # Tạo tên sản phẩm từ tổ hợp thuộc tính
        ${combination_values}=    Split String    ${combination}    |
        ${product_name}=    Set Variable    Sản phẩm
        FOR    ${index}    IN RANGE    ${length}
            ${value}=    Get From List    ${combination_values}    ${index}
            ${product_name}=    Set Variable    ${product_name}-${value}
        END
        ${product_name}=    Set Variable    ${product_name}
        ${request}=    Update Nested Dictionary Property     ${request}    Name    Sản phẩm
        ${request}=    Update Nested Dictionary Property     ${request}    FullName  ${value}
        ${request}=    Update Nested Dictionary Property     ${request}    CompareFullName   ${product_name}

        
        # Tạo danh sách thuộc tính cho sản phẩm
        ${product_attributes}=    Create List
        FOR    ${index}    IN RANGE    ${length}
            ${attribute}=    Deep Copy    ${standard_product_attributes}
            ${value}=    Get From List    ${combination_values}    ${index}
            ${attribute_id}=    Lấy ID thuộc tính    ${attr_name}
            ${attribute}=     Update Nested Dictionary Property    ${attribute}    AttributeId    ${attribute_id}
            ${attribute}=    Update Nested Dictionary Property      ${attribute}    Value    ${value}
            Append To List    ${product_attributes}    ${attribute}
        END
        
        ${request}=    Update Nested Dictionary Property     ${request}    ProductAttributes    ${product_attributes}
        Append To List    ${list_products}    ${request}
    END

    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${list_products} ).replace("'",'"')
    ${list_products_attribute}     Evaluate    (None, '${form_data}')
    ${payload}    Create Dictionary    ListProductsString=${list_products_attribute}          BranchForProductCostss=${branch_pr_cost}  
    Log     ${payload}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${LIST_PRODUCTS_CODE}    ${list_products_code}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Là Thuốc
  ${product_info}=    Lấy thông tin thuốc từ danh mục thuốc    1
  ${manufacturer_info}=    Lấy thông tin hãng sản xuất nhà thuốc  ${product_info[7]}
   ${request}=    Deep Copy     ${list_product_data}
     ${random_code}=    Generate Random String    6    [NUMBERS]
     ${request}    Update Dictionary Property    ${request}    Code    T${random_code}
     ${request}    Update Dictionary Property    ${request}    IsBatchExpireControl    true
     ${request}    Update Dictionary Property    ${request}    Name    ${product_info[2]}
     ${request}    Update Dictionary Property    ${request}    CategoryId        1000000751
     ${request}    Update Dictionary Property    ${request}    IsSyncNationalPharmacy    false
     ${request}    Update Dictionary Property    ${request}    GlobalMedicineId    ${product_info[0]}
     ${request}    Update Dictionary Property    ${request}    MedicineCode    ${product_info[1]}
     ${request}    Update Dictionary Property    ${request}    RegistrationNo    ${product_info[3]}
     ${request}    Update Dictionary Property    ${request}    ActiveElement    ${product_info[4]}
     ${request}    Update Dictionary Property    ${request}    Content    ${product_info[5]}
     ${request}    Update Dictionary Property    ${request}    GlobalManufacturerName    ${manufacturer_info[1]}
     ${request}    Update Dictionary Property    ${request}    GlobalManufacturerCountryName   Ấn Độ
     ${request}    Update Dictionary Property    ${request}    PackagingSize    ${product_info[6]}
     ${request}    Update Dictionary Property    ${request}    GlobalManufacturerId     ${manufacturer_info[0]}
     ${request}    Update Dictionary Property    ${request}    GlobalRoaId    1000000001
     ${request}    Update Dictionary Property    ${request}    RouteOfAdministration  1000000001
     ${request}    Update Dictionary Property    ${request}    GlobalManufacturerCountryId    2
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế ${tax_rate} %
    ${tax_ID}     Run Keyword If  '${tax_rate}'=='0'     Set Variable    1
    ...     ELSE IF   '${tax_rate}'=='5'     Set Variable    2
    ...     ELSE IF   '${tax_rate}'=='8'     Set Variable    3
    ...     ELSE IF   '${tax_rate}'=='10'     Set Variable    4
    ...     ELSE IF   '${tax_rate}'=='Không chịu thuế'     Set Variable   5
    ${request}=    Deep Copy     ${list_product_data}
     ${random_code}=    Generate Random String    6    [NUMBERS]
     ${request}    Update Dictionary Property    ${request}    Code    SP${random_code}
     ${request}    Update Dictionary Property    ${request}    TaxId     ${tax_ID}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}

Chuẩn Bị Dữ Liệu Sản Phẩm Loại Combo
    ${request}=    Deep Copy     ${list_product_data}
    ${formula}=     Deep Copy    ${PRODUCT_FORMULAS}
    ${formula}    Create List    ${formula}
     ${random_code}=    Generate Random String    6    [NUMBERS]
     ${request}    Update Dictionary Property    ${request}    Code    CB${random_code}
     ${request}    Update Dictionary Property    ${request}    ProductType    1
     ${request}    Update Dictionary Property    ${request}    ProductFormulas    ${formula}
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    
    Log     ${payload}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request}

# Keywords cho các trường hợp lỗi
Chuẩn Bị Dữ Liệu Sản Phẩm Thiếu Tên
    ${request}=    Deep Copy    ${SAN_PHAM_THIEU_TEN}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Mã Đã Tồn Tại
    ${request}=    Deep Copy    ${SAN_PHAM_MA_TON_TAI}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Giá Bán Âm
    ${request}=    Deep Copy    ${SAN_PHAM_GIA_AM}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo 201 Sản Phẩm
    ${list_products}=    Create List
    FOR    ${i}    IN RANGE    201
        ${product}=    Deep Copy    ${SAN_PHAM_CO_BAN}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        ${product_code}=    Set Variable    SP${random_code}
        Set To Dictionary    ${product}    Code=${product_code}
        Append To List    ${list_products}    ${product}
    END
    ${request}=    Create Dictionary    ListProducts=${list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo 51 Sản Phẩm Combo
    ${list_products}=    Create List
    FOR    ${i}    IN RANGE    51
        ${product}=    Deep Copy    ${SAN_PHAM_COMBO}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        ${product_code}=    Set Variable    COMBO${random_code}
        Set To Dictionary    ${product}    Code=${product_code}
        Append To List    ${list_products}    ${product}
    END
    ${request}=    Create Dictionary    ListProducts=${list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Tỷ Lệ Quy Đổi Không Hợp Lệ
    ${request}=    Deep Copy    ${SAN_PHAM_TY_LE_QUY_DOI_AM}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Danh Mục Không Tồn Tại
    ${request}=    Deep Copy    ${SAN_PHAM_DANH_MUC_KHONG_TON_TAI}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Là Thuốc Thiếu Thông Tin
    ${request}=    Deep Copy    ${SAN_PHAM_THUOC_THIEU_THONG_TIN}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Mô Tả Quá Dài
    ${request}=    Deep Copy    ${SAN_PHAM_MO_TA_QUA_DAI}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Combo Với Thành Phần Không Tồn Tại
    ${request}=    Deep Copy    ${SAN_PHAM_COMBO_THANH_PHAN_KHONG_TON_TAI}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# Keywords xử lý API
Gửi Yêu Cầu Tạo Sản Phẩm
    ${response}=    Call API With Form Data    ${PRODUCT_API_ENDPOINT}    ${REQUEST_DATA}    ${REQUEST_FILES}
    Set Test Variable    ${RESPONSE}    ${response}
    IF    '${RESPONSE.status_code}' == '200'
        ${product_id}=    Set Variable     ${RESPONSE.json()["Data"][0]["Id"]}
        ${product_code}=    Set Variable    ${RESPONSE.json()["Data"][0]["Code"]}
        Set Test Variable    ${CREATED_PRODUCT_ID}    ${product_id}
        Set Test Variable    ${CREATED_PRODUCT_CODE}    ${product_code}
    END
    RETURN    ${response}

# Keywords xác thực kết quả
Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    ${query}=    Set Variable    SELECT Id, Code, Name FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    Set Test Variable    ${DB_PRODUCT_ID}    ${result[0]}
    Set Test Variable    ${DB_PRODUCT_CODE}    ${result[1]}
    Set Test Variable    ${DB_PRODUCT_NAME}    ${result[2]}

Xác Thực Sản Phẩm Có Thông Tin Chính Xác Theo Dữ Liệu Đã Gửi
    Should Be Equal As Strings    ${DB_PRODUCT_CODE}    ${REQUEST_DATA["ListProductsString"][0]["Code"]}
    Should Be Equal As Strings    ${DB_PRODUCT_NAME}    ${REQUEST_DATA["ListProductsString"][0]["Name"]}

Xác Thực Sản Phẩm Được Tạo Với Mã Tự Sinh
    Should Not Be Empty    ${DB_PRODUCT_CODE}

Xác Thực Sản Phẩm Con Được Tạo Với Đúng Tỷ Lệ Quy Đổi
    ${query}=    Set Variable    SELECT Id FROM Product WHERE MasterProductId = ?
    ${results}=    Fetch All    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Empty    ${results}    Không tìm thấy sản phẩm con cho sản phẩm cha đã tạo
    
    FOR    ${result}    IN    @{results}
        ${child_id}=    Set Variable    ${result[0]}
        ${unit_query}=    Set Variable    SELECT ConversionValue FROM Product WHERE Id = ?
        ${unit_result}=    Fetch One    ${unit_query}    ${child_id}
        Should Be Equal As Numbers    ${unit_result[0]}    ${DON_VI_TINH_PHU['ConversionValue']}
    END

Xác Thực Sản Phẩm Có Tồn Kho ${on_hand} Ở Chi Nhánh ${name_branch}
    ${branch_id}=    Lấy Thông tin Chi Nhánh    ${name_branch}
    ${query}=    Set Variable    SELECT OnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}    ${branch_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin tồn kho cho sản phẩm đã tạo
    Should Be Equal As Numbers    ${result[0]}    ${on_hand}


Lấy Thông tin Chi Nhánh
    [Arguments]    ${name_branch}
    ${query}=    Set Variable    SELECT Id, Name FROM Branch WHERE Name = ?
    ${result}=    Fetch One    ${query}    ${name_branch}
    Set Test Variable    ${DB_BRANCH_ID}    ${result[0]}
    RETURN    ${DB_BRANCH_ID}
    
Xác Thực Sản Phẩm Được Cấu Hình Quản Lý Lô Và Hạn Sử Dụng
    ${query}=    Set Variable    SELECT IsBatchExpireControl FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    Should Be Equal As Strings    ${result[0]}    True

Xác Thực Sản Phẩm Được Cấu Hình Quản Lý Serial
    ${query}=    Set Variable    SELECT IsLotSerialControl FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    Should Be Equal As Strings    ${result[0]}    True

Xác Thực Sản Phẩm Có ${LIST_PRODUCTS_CODE} Tạo Ra 
    FOR    ${code}    IN    @{LIST_PRODUCTS_CODE}
        ${query}=    Set Variable    SELECT Id FROM Product WHERE Code = ?
        ${result}=    Fetch One    ${query}    ${code}
        ${query2}=    Set Variable    SELECT AttributeId, Value FROM ProductAttribute WHERE ProductId = ?
        ${result2}=    Fetch One    ${query2}    ${result[0]}
        Should Not Be Equal    ${result2}    None    Không tìm thấy thuộc tính cho sản phẩm đã tạo
    END

Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    ${query}=    Set Variable    SELECT Id FROM ProductMedicine WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm thuốc đã tạo trong database


Xác Thực Sản Phẩm Tự Động Được Cấu Hình Quản Lý Lô Và Hạn Sử Dụng
    ${query}=    Set Variable    SELECT IsBatchExpireControl FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm thuốc đã tạo trong database
    Should Be Equal As Strings    ${result[0]}    1

Xác Thực Sản Phẩm Có Thuế ${tax_rate} Theo Dữ Liệu Đã Gửi
    ${tax_ID}     Run Keyword If  '${tax_rate}'=='0'     Set Variable    1
    ...     ELSE IF   '${tax_rate}'=='5'     Set Variable    2
    ...     ELSE IF   '${tax_rate}'=='8'     Set Variable    3
    ...     ELSE IF   '${tax_rate}'=='10'     Set Variable    4
    ...     ELSE IF   '${tax_rate}'=='Không chịu thuế'     Set Variable   5
    ${query}=    Set Variable    SELECT TaxId FROM ProductTax WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin thuế cho sản phẩm đã tạo
    Should Be Equal As Strings    ${result[0]}     ${tax_ID}  

Xác Thực Sản Phẩm Combo Có Chứa Các Thành Phần ${product_material_id} Với Số Lượng ${product_material_quantity} 
    ${query}=    Set Variable    SELECT MaterialId, Quantity FROM ProductFormula WHERE ProductId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thành phần cho sản phẩm combo đã tạo
    Should Be Equal As Strings    ${result[0]}   ${product_material_id}
    Should Be Equal As Numbers    ${result[1]}    ${product_material_quantity}
Xác Thực Lỗi "${error_message}"
    Should Be Equal As Strings    ${RESPONSE.status_code}    420
    Should Contain    ${RESPONSE.text}    ${error_message} 


Lấy thông tin thuốc từ danh mục thuốc
    [Arguments]    ${product_id}
    ${query}=    Set Variable    SELECT Id,Code,Name,RegistrationNo,ActiveElement,Content,PackagingSize,GlobalManufacturerId FROM GlobalMedicine WHERE Id=?
    ${result}=    Select One Master    ${query}    ${product_id}
    RETURN    ${result}

Lấy thông tin hãng sản xuất nhà thuốc
    [Arguments]    ${manufacturer_id}
    ${query}=    Set Variable    SELECT Id, Name FROM GlobalManufacturer WHERE Id = ?
    ${result}=    Select One Master    ${query}    ${manufacturer_id}
    RETURN    ${result}

Lấy ID thuộc tính  
    [Arguments]    ${attribute_name}
    ${query}=    Set Variable    SELECT Id FROM Attribute WHERE Name=? 
    ${result}=    Fetch One    ${query}     ${attribute_name}
    RETURN    ${result[0]}
