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

Chuẩn Bị Dữ Liệu Sản Phẩm Không Có Mã
    ${request}=    Deep Copy     ${list_product_data}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Nhiều Đơn Vị Tính
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${list_product_data}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}
    RETURN    ${request}

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

Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính
    ${request}=    Deep Copy    ${SAN_PHAM_CO_THUOC_TINH}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Là Thuốc
  ${product_info}=    Lấy thông tin thuốc từ danh mục thuốc    1
   ${request}=    Deep Copy     ${list_product_data}
     ${random_code}=    Generate Random String    6    [NUMBERS]
     ${request}    Update Dictionary Property    ${request}    Code    T${random_code}
     ${request}    Update Dictionary Property    ${request}    IsBatchExpireControl    true
     ${request}    Update Dictionary Property    ${request}    Name    ${product_info["Name"]}
     ${request}    Update Dictionary Property    ${request}    IsSyncNationalPharmacy    ${product_info["IsSyncNationalPharmacy"]}
     ${request}    Update Dictionary Property    ${request}    GlobalMedicineId    ${product_info["GlobalMedicineId"]}
     ${request}    Update Dictionary Property    ${request}    MedicineCode    ${product_info["MedicineCode"]}
     ${request}    Update Dictionary Property    ${request}    RegistrationNo    ${product_info["RegistrationNo"]}
     ${request}    Update Dictionary Property    ${request}    ActiveElement    ${product_info["ActiveElement"]}
     ${request}    Update Dictionary Property    ${request}    Content    ${product_info["Content"]}
     ${request}    Update Dictionary Property    ${request}    GlobalManufacturerName    ${product_info["GlobalManufacturerName"]}
     ${request}    Update Dictionary Property    ${request}    GlobalManufacturerCountryName    ${product_info["GlobalManufacturerCountryName"]}
     ${request}    Update Dictionary Property    ${request}    PackagingSize    ${product_info["PackagingSize"]}
     ${request}    Update Dictionary Property    ${request}    GlobalManufacturerId    ${product_info["GlobalManufacturerId"]}
     ${request}    Update Dictionary Property    ${request}    GlobalRoaId    ${product_info["GlobalRoaId"]}
     ${request}    Update Dictionary Property    ${request}    RetailerRoaId    ${product_info["RetailerRoaId"]}
     ${request}    Update Dictionary Property    ${request}    GlobalManufacturerCountryId    ${product_info["GlobalManufacturerCountryId"]}
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
    ${payload}    Create Dictionary    ListProductsString=${request}        
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

Xác Thực Sản Phẩm Có Thuộc Tính Theo Dữ Liệu Đã Gửi
    ${query}=    Set Variable    SELECT AttributeName, AttributeValue FROM ProductAttribute WHERE ProductId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thuộc tính cho sản phẩm đã tạo
    Should Be Equal As Strings    ${result[0]}    ${THUOC_TINH['AttributeName']}
    Should Be Equal As Strings    ${result[1]}    ${THUOC_TINH['AttributeValue']}

Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    ${query}=    Set Variable    SELECT IsMedicineProduct, RegistrationNo FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm thuốc đã tạo trong database
    Should Be Equal As Strings    ${result[0]}    1
    Should Be Equal As Strings    ${result[1]}    ${SAN_PHAM_LA_THUOC['RegistrationNo']}

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

Xác Thực Sản Phẩm Combo Có Chứa Các Thành Phần Theo Dữ Liệu Đã Gửi
    ${query}=    Set Variable    SELECT MaterialId, Quantity FROM ProductComboDetail WHERE ComboId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thành phần cho sản phẩm combo đã tạo
    Should Be Equal As Strings    ${result[0]}    ${THANH_PHAN_COMBO['ProductId']}
    Should Be Equal As Numbers    ${result[1]}    ${THANH_PHAN_COMBO['Quantity']}

Xác Thực Lỗi "${error_message}"
    Should Be Equal As Strings    ${RESPONSE.status_code}    420
    Should Contain    ${RESPONSE.text}    ${error_message} 


Lấy thông tin thuốc từ danh mục thuốc
    [Arguments]    ${product_id}
    ${query}=    Set Variable    Select m.Id,m.Code,m.Name,m.RegistrationNo,m.ActiveElement,m.Content,m.PackagingSize,m.GlobalManufacturerId, g.name from GlobalMedicine m JOIN GlobalManufacturer g ON m.GlobalManufacturerId=g.Id  where m.Id=?
    ${result}=    Select One Master    ${query}    ${product_id}
    RETURN    ${result}


Lấy ID thuộc tính  
    [Arguments]    ${attribute_name}
    ${query}=    Set Variable    Select Id from Attribute Where Name='${attribute_name}'  And IsDeleted=NULL
    ${result}=    Fetch One    ${query}    
    RETURN    ${result}
