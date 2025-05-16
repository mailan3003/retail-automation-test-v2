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
Resource          Product_KeywordsCommand.robot
*** Variables ***
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
    Log     ${payload}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}
  
Chuẩn Bị Dữ Liệu Sản Phẩm Không Có Mã
    ${request}=    Deep Copy     ${list_product_data}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
     Set Test Variable    ${REQUEST_DATA}    ${payload}
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
    ${list_product_code}     Create List
    FOR    ${item_name}   ${item_value}  IN ZIP    ${name_unit}  ${value}
        ${request}=    Deep Copy    ${list_product_data}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        ${code}=    Set Variable    QD${random_code}
        ${request}    Update Dictionary Property    ${request}    Code    ${code}
        ${request}    Update Dictionary Property    ${request}    Unit    ${item_name}
        ${request}    Update Dictionary Property    ${request}    ConversionValue    ${item_value}
        Append To List   ${list_product_body}    ${request}
        Append To List   ${list_product_code}    ${code}
    END
    ${list_product_body}=    Evaluate     str(${list_product_body}).replace("'",'"')
    ${list_product_body}    Evaluate    (None, '${list_product_body}')
    ${payload}    Create Dictionary    ListProductsString=${list_product_body}         BranchForProductCostss=${branch_pr_cost}  
    Log     ${payload}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${LIST_PRODUCT_CODE}    ${list_product_code}
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
        ${code}=    Set Variable    HHTT${random_code}
        Append To List    ${list_products_code}    ${code}
        ${request}=    Update Nested Dictionary Property    ${request}    Code    ${code}
        
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

Chuẩn Bị Dữ Liệu Sản Phẩm Với Ghi Chú Đặt Hàng ${n} Ký tự
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${random_ghichu}=    Generate Random String    ${n}    [LETTERS]
    ${request}    Update Dictionary Property    ${request}    Code    GH${random_code}
    ${request}    Update Dictionary Property    ${request}    OrderTemplate    ${random_ghichu}
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
     ${payload}    Create Dictionary    ListProductsString=${list_products}    
    Log     ${payload}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${RANDOM_GHICHU}    ${random_ghichu}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Ghi Chú ${n} Ký tự
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${random_ghichu}=    Generate Random String    ${n}    [LETTERS]
    ${request}    Update Dictionary Property    ${request}    Code    GH${random_code}
    ${request}    Update Dictionary Property    ${request}    Description    ${random_ghichu}
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
     ${payload}    Create Dictionary    ListProductsString=${list_products}    
    Log     ${payload}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${RANDOM_GHICHU}    ${random_ghichu}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Kinh Doanh Ở Chi Nhánh ${list_name_branch}
    ${list_branch}    Create List
    FOR    ${name_branch}    IN    @{list_name_branch}
        ${branch_id}=    Lấy Thông tin Chi Nhánh    ${name_branch}
        Append To List    ${list_branch}    ${branch_id}
    END
    ${request}=    Deep Copy     ${list_product_data}
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}        ListBranchsSelected=${list_branch}
    Log     ${payload}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request}





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



Xác thực thông tin cơ bản hàng hóa
    [Arguments]    ${product_id}
    ${query}=    Set Variable    SELECT Id, Code, Name, ProductType, ProductCategoryId, ProductCategoryName, UnitId, UnitName, ConversionValue, OnHand, MinStock, MaxStock, IsActive FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${product_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    Should Be Equal As Strings    ${result[0]}    ${product_id}
    Should Be Equal As Strings    ${result[1]}    ${product_code}
    Should Be Equal As Strings    ${result[2]}    ${product_name}
    Should Be Equal As Strings    ${result[3]}    ${product_type}
    Should Be Equal As Strings    ${result[4]}    ${product_category_id}
    Should Be Equal As Strings    ${result[5]}    ${product_category_name}
    Should Be Equal As Strings    ${result[6]}    ${unit_id}
    Should Be Equal As Strings    ${result[7]}    ${unit_name}
    Should Be Equal As Numbers    ${result[8]}    ${conversion_value}
    Should Be Equal As Numbers    ${result[9]}    ${on_hand}
    Should Be Equal As Numbers    ${result[10]}    ${min_stock}
    Should Be Equal As Numbers    ${result[11]}    ${max_stock}
    Should Be Equal As Strings    ${result[12]}    ${is_active}        





# Các keyword mới
Chuẩn Bị Dữ Liệu Sản Phẩm Ngừng Kinh Doanh
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    SP${random_code}
    ${request}    Update Dictionary Property    ${request}    isActive    True
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Giá Bán ${price}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    8    GIA[NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    ${random_code}
    ${request}    Update Dictionary Property    ${request}    BasePrice    ${price}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}


Chuẩn Bị Dữ Liệu Sản Phẩm Với Giới Hạn Tồn Kho Tối Thiểu ${min_stock} Và Tối Đa ${max_stock}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    GTK${random_code}
    ${request}    Update Dictionary Property    ${request}    MinQuantity    ${min_stock}
    ${request}    Update Dictionary Property    ${request}    MaxQuantity    ${max_stock}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}



Chuẩn Bị Dữ Liệu Sản Phẩm Có Tích Điểm
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    TD${random_code}
    ${request}    Update Dictionary Property    ${request}    IsRewardPoint    True
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}


Chuẩn Bị Dữ Liệu Sản Phẩm Có Thời Gian ${type} ${month} ${unit}
    ${type}    Set Variable If    "${type}" == "Bảo Hành"   1   2
    ${unit}    Run Keyword If    "${unit}" == "Tháng"    Set Variable    6    ELSE IF    "${unit}" == "Ngày"
    ...   Set Variable    7    ELSE    Set Variable    1
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    BH${random_code}
    ${warr}=    Deep Copy    ${GENUINE_GUARANTEES}
    ${warr}    Update Dictionary Property    ${warr}    NumberTime    ${month}
    ${warr}    Update Dictionary Property    ${warr}    TimeType    ${unit}
    ${warr}    Update Dictionary Property    ${warr}    WarrantyType    ${type}
    ${warranties}=    Create List    ${warr}
    ${request}    Update Dictionary Property    ${request}    GenuineGuarantees    ${warranties}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}




Chuẩn Bị Dữ Liệu Sản Phẩm Có Hình Ảnh
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    HA${random_code}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    ${files}=    Create Dictionary
    ${stream}=    Get File For Streaming Upload    Images/Anh1.jpg
    ${files}=    Set To Dictionary    ${files}    ProductImage=${stream}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${REQUEST_FILES}    ${files}
    RETURN    ${REQUEST_DATA}



Chuẩn Bị Dữ Liệu Sản Phẩm Có Kích Thước ${width}x${height} ${unit}
    ${unit}    Run Keyword If    "${unit}" == "cm"    Set Variable    1    ELSE IF    "${unit}" == "m"
    ...   Set Variable    2   ELSE    Set Variable    0
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    KT${random_code}
    ${request}    Update Dictionary Property    ${request}    CategoryId    1000000753
    ${request}    Update Dictionary Property    ${request}    Attribute1    ${width}
    ${request}    Update Dictionary Property    ${request}    Attribute2    ${height}
    ${request}    Update Dictionary Property    ${request}    Type1    1
    ${request}    Update Dictionary Property    ${request}    Type2   ${unit}  
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}



Chuẩn Bị Dữ Liệu Sản Phẩm Không Có Tên
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    KT${random_code}
    ${request}    Update Dictionary Property    ${request}    Name    ${EMPTY}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

# Keywords bổ sung cho các điều kiện hợp lệ trong template
Chuẩn Bị Dữ Liệu Sản Phẩm Có Giá Vốn 200000
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    GV${random_code}
    ${request}    Update Dictionary Property    ${request}    Cost    200000
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

# Keywords bổ sung cho các điều kiện lỗi trong template
Chuẩn Bị Dữ Liệu Sản Phẩm Với Giá Trị Âm
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    GTA${random_code}
    ${request}    Update Dictionary Property    ${request}    BasePrice    -50000
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Danh Mục Không Tồn Tại
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    DM${random_code}
    ${request}    Update Dictionary Property    ${request}    CategoryId    999999999
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

# Keywords cho test case đầy đủ thông tin
Chuẩn Bị Dữ Liệu Sản Phẩm Đầy Đủ Thông Tin
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${code}=    Set Variable    FULL${random_code}
    
    # Thông tin cơ bản
    ${request}    Update Dictionary Property    ${request}    Code    ${code}
    ${request}    Update Dictionary Property    ${request}    Name    Sản phẩm đầy đủ thông tin
    ${request}    Update Dictionary Property    ${request}    FullName    Sản phẩm đầy đủ thông tin
    ${request}    Update Dictionary Property    ${request}    BasePrice    150000
    ${request}    Update Dictionary Property    ${request}    Cost    100000
    ${request}    Update Dictionary Property    ${request}    Description    Mô tả chi tiết sản phẩm đầy đủ thông tin
    ${request}    Update Dictionary Property    ${request}    CategoryId    ${CATEGORY_1_ID}
    ${request}    Update Dictionary Property    ${request}    ProductType    2
    ${request}    Update Dictionary Property    ${request}    IsActive    true
    
    # Thông tin nâng cao
    ${request}    Update Dictionary Property    ${request}    IsBatchExpireControl    true
    ${request}    Update Dictionary Property    ${request}    IsLotSerialControl    false
    ${request}    Update Dictionary Property    ${request}    IsRewardPoint    true
    ${request}    Update Dictionary Property    ${request}    OnHand    100
    ${request}    Update Dictionary Property    ${request}    MinQuantity    10
    ${request}    Update Dictionary Property    ${request}    MaxQuantity    200
    ${request}    Update Dictionary Property    ${request}    TaxId    4
    ${request}    Update Dictionary Property    ${request}    Barcode    123456789012
    ${request}    Update Dictionary Property    ${request}    Weight    2.5
    
    # Kích thước
    ${request}    Update Dictionary Property    ${request}    Width    10
    ${request}    Update Dictionary Property    ${request}    Height    20
    ${request}    Update Dictionary Property    ${request}    Length    30
    
    # Đơn vị tính và quy đổi
    ${unit1}=    Deep Copy    ${PRODUCT_UNITS}
    ${unit1}    Update Dictionary Property    ${unit1}    Unit    Hộp
    ${unit1}    Update Dictionary Property    ${unit1}    ConversionValue    10
    ${units}=    Create List    ${unit1}
    ${request}    Update Dictionary Property    ${request}    ProductUnits    ${units}
    
    # Bảo hành
    ${warr}=    Deep Copy    ${GENUINE_GUARANTEES}
    ${warr}    Update Dictionary Property    ${warr}    NumberTime    12
    ${warr}    Update Dictionary Property    ${warr}    TimeType    2
    ${warr}    Update Dictionary Property    ${warr}    WarrantyType    1
    ${warranties}=    Create List    ${warr}
    ${request}    Update Dictionary Property    ${request}    GenuineGuarantees    ${warranties}
    
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    
    # Chuẩn bị tập tin hình ảnh
    ${files}=    Create Dictionary
    ${stream}=    Get File For Streaming Upload    Resources/product_image.jpg
    ${files}=    Set To Dictionary    ${files}    ProductImage=${stream}
    
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${REQUEST_FILES}    ${files}
    RETURN    ${REQUEST_DATA}

Xác Thực Sản Phẩm Có Thông Tin Đầy Đủ
    # Xác thực thông tin cơ bản
    ${product_query}=    Set Variable    
    ...    SELECT 
    ...    p.Id, p.Code, p.Name, p.BasePrice, p.Cost, p.IsBatchExpireControl, p.IsLotSerialControl, 
    ...    p.IsRewardPoint, p.MinQuantity, p.MaxQuantity, p.Barcode, p.Weight, 
    ...    p.Width, p.Height, p.Length, t.TaxId
    ...    FROM Product p
    ...    LEFT JOIN ProductTax t ON p.Id = t.Id
    ...    WHERE p.Id = ?
    
    ${result}=    Fetch One    ${product_query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    
    # Xác thực từng trường thông tin
    Should Be Equal As Strings    ${result[2]}    Sản phẩm đầy đủ thông tin
    Should Be Equal As Numbers    ${result[3]}    150000
    Should Be Equal As Numbers    ${result[4]}    100000
    Should Be Equal As Strings    ${result[5]}    True    # IsBatchExpireControl
    Should Be Equal As Strings    ${result[6]}    False   # IsLotSerialControl
    Should Be Equal As Strings    ${result[7]}    True    # IsRewardPoint
    Should Be Equal As Numbers    ${result[8]}    10      # MinQuantity
    Should Be Equal As Numbers    ${result[9]}    200     # MaxQuantity
    Should Be Equal As Strings    ${result[10]}   123456789012  # Barcode
    Should Be Equal As Numbers    ${result[11]}   2.5     # Weight
    Should Be Equal As Numbers    ${result[12]}   10      # Width
    Should Be Equal As Numbers    ${result[13]}   20      # Height
    Should Be Equal As Numbers    ${result[14]}   30      # Length
    Should Be Equal As Numbers    ${result[15]}   4       # TaxId
    
    # Xác thực đơn vị tính quy đổi
    ${unit_query}=    Set Variable    SELECT Unit, ConversionValue FROM Product WHERE MasterProductId = ?
    ${unit_result}=    Fetch One    ${unit_query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${unit_result}    None    Không tìm thấy đơn vị quy đổi
    Should Be Equal As Strings    ${unit_result[0]}    Hộp
    Should Be Equal As Numbers    ${unit_result[1]}    10
    
    # Xác thực thông tin bảo hành
    ${warranty_query}=    Set Variable    SELECT NumberTime, TimeType FROM GenuineGuarantee WHERE ProductId = ?
    ${warranty_result}=    Fetch One    ${warranty_query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${warranty_result}    None    Không tìm thấy thông tin bảo hành
    Should Be Equal As Numbers    ${warranty_result[0]}    12
    Should Be Equal As Numbers    ${warranty_result[1]}    2

Chuẩn Bị Dữ Liệu Sản Phẩm Có Tên Với Ký Tự Đặc Biệt
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${special_name}=    Set Variable    Sản phẩm ĐẶC BIỆT #@&*() 😊 Tiếng Việt Có Dấu
    ${request}    Update Dictionary Property    ${request}    Code    SP${random_code}
    ${request}    Update Dictionary Property    ${request}    Name    ${special_name}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${SPECIAL_PRODUCT_NAME}    ${special_name}
    RETURN    ${REQUEST_DATA}



Chuẩn Bị Dữ Liệu Sản Phẩm Loại Hàng Sản Xuất 
    ${request}=    Deep Copy     ${list_product_data}
    ${formula}          Deep Copy     ${PRODUCT_FORMULAS}  
    ${formula}     Create List    ${formula}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    HSX${random_code}
    ${request}    Update Dictionary Property    ${request}    ProductFormulas    ${formula}    
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}        BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}



Chuẩn Bị Dữ Liệu Sản Phẩm Có Vị Trí Lưu Trữ
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    VT${random_code}
    
    # Lấy ID của một vị trí lưu trữ hợp lệ
    ${query}=    Set Variable    SELECT TOP 1 Id FROM Shelves WHERE RetailerId = ?
    ${result}=    Fetch One    ${query}    ${RETAILER_ID}
    ${shelf_id}=    Set Variable If    "${result}" != "None"    ${result[0]}    1
    
    ${shelf}=    Create Dictionary    ShelvesId=${shelf_id}    ProductId=0
    ${shelves}=    Create List    ${shelf}
    ${request}    Update Dictionary Property    ${request}    ProductShelves    ${shelves}
    
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}        BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${SHELF_ID}    ${shelf_id}
    RETURN    ${REQUEST_DATA}



Chuẩn Bị Dữ Liệu Sản Phẩm Có Thương Hiệu
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    TH${random_code}
    
    # Lấy ID của một thương hiệu hợp lệ
    ${query}=    Set Variable    SELECT TOP 1 Id, Name FROM TradeMark WHERE RetailerId = ?
    ${result}=    Fetch One    ${query}    ${RETAILER_ID}
    ${brand_id}=    Set Variable If    "${result}" != "None"    ${result[0]}    1
    
    ${request}    Update Dictionary Property    ${request}    TradeMarkId    ${brand_id}
    
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}        BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${BRAND_ID}    ${brand_id}
    RETURN    ${REQUEST_DATA}



Chuẩn Bị Dữ Liệu Sản Phẩm Có Trọng Lượng ${weight} Kg
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    TL${random_code}
    ${request}    Update Dictionary Property    ${request}    Weight    ${weight}
    
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}        BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}


Chuẩn Bị Dữ Liệu Sản Phẩm Có Mã Barcode
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${random_barcode}=    Generate Random String    12    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    BC${random_code}
    ${request}    Update Dictionary Property    ${request}    Barcode    ${random_barcode}
    
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}        BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${BARCODE}    ${random_barcode}
    RETURN    ${REQUEST_DATA}

Xác Thực Sản Phẩm Có Mã Barcode Đúng
    ${query}=    Set Variable    SELECT Barcode FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin mã barcode
    Should Be Equal As Strings    ${result[0]}    ${BARCODE}

Chuẩn Bị Dữ Liệu Sản Phẩm Có Giá Vốn ${cost}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    GV${random_code}
    ${request}    Update Dictionary Property    ${request}    Cost    ${cost}
    
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}        BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}



Chuẩn Bị Dữ Liệu Sản Phẩm Với Nhiều Thuộc Tính Tổ Hợp
    # Tạo dictionary cho thuộc tính màu sắc với các giá trị
    @{value_mau_sac}    Create List    Đỏ    Xanh    Đen
    &{dict_mau_sac}    Create Dictionary    MÀU SẮC=@{value_mau_sac}
    
    # Tạo dictionary cho thuộc tính kích thước với các giá trị
    @{value_kich_thuoc}    Create List    S    M    L
    &{dict_kich_thuoc}    Create Dictionary    KÍCH THƯỚC=@{value_kich_thuoc}
    
    # Kết hợp các thuộc tính để tạo tổ hợp
    &{combined_attributes}    Create Dictionary    MÀU SẮC=@{value_mau_sac}    KÍCH THƯỚC=@{value_kich_thuoc}
    
    # Gọi hàm chuẩn bị dữ liệu với các thuộc tính tổ hợp
    ${request_data}=    Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính    ${combined_attributes}
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    RETURN    ${REQUEST_DATA}

Xác Thực Tất Cả Biến Thể Sản Phẩm Đã Được Tạo Thành Công
    # Lấy số lượng biến thể dự kiến từ danh sách mã sản phẩm
    ${expected_variant_count}=    Get Length    ${LIST_PRODUCTS_CODE}
    
    # Truy vấn số lượng biến thể thực tế được tạo ra trong cơ sở dữ liệu
    ${query}=    Set Variable    SELECT COUNT(*) FROM Product WHERE MasterProductId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    
    # Xác nhận rằng số lượng biến thể thực tế bằng số lượng dự kiến
    Should Be Equal As Numbers    ${result[0]}    ${expected_variant_count}
    Log    Đã tạo thành công ${result[0]} biến thể sản phẩm

Xác Thực Biến Thể Sản Phẩm Được Gắn Với Sản Phẩm Gốc Đúng
    # Kiểm tra xem các biến thể có liên kết với sản phẩm gốc không
    ${query}=    Set Variable    SELECT Id, Code FROM Product WHERE MasterProductId = ?
    ${results}=    Fetch All    ${query}    ${CREATED_PRODUCT_ID}
    
    # Kiểm tra từng biến thể
    FOR    ${result}    IN    @{results}
        ${variant_id}=    Set Variable    ${result[0]}
        
        # Kiểm tra mối quan hệ thuộc tính
        ${attr_query}=    Set Variable    SELECT COUNT(*) FROM ProductAttribute WHERE ProductId = ?
        ${attr_result}=    Fetch One    ${attr_query}    ${variant_id}
        
        # Một biến thể phải có ít nhất một thuộc tính
        Should Be True    ${attr_result[0]} > 0
    END

Chuẩn Bị Dữ Liệu Sản Phẩm Với Các Biến Thể Có Giá Khác Nhau
    # Tạo danh sách giá khác nhau cho các biến thể
    ${prices}=    Create List    50000    70000    90000
    Set Test Variable    ${VARIANT_PRICES}    ${prices}
    
    # Chuẩn bị dữ liệu sản phẩm cơ bản với thuộc tính
    ${request_data}=    Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính    ${dict_kich_thuoc}
    
    # Cập nhật giá cho các biến thể trong yêu cầu
    ${product_list}=    Evaluate    json.loads(${REQUEST_DATA}["ListProductsString"][1])    json
    FOR    ${i}    ${price}    IN ZIP    RANGE    ${prices}
        ${product_list}[${i}]["BasePrice"] = ${price}
    END
    
    # Cập nhật lại danh sách sản phẩm trong yêu cầu
    ${updated_product_list}=    Evaluate    json.dumps(${product_list})    json
    ${REQUEST_DATA}["ListProductsString"] = (None, '${updated_product_list}')
    
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    RETURN    ${REQUEST_DATA}

Xác Thực Các Biến Thể Có Giá Bán Theo Cấu Hình
    # Kiểm tra giá của từng biến thể
    ${query}=    Set Variable    SELECT Id, BasePrice FROM Product WHERE MasterProductId = ?
    ${results}=    Fetch All    ${query}    ${CREATED_PRODUCT_ID}
    
    # Kiểm tra số lượng kết quả
    ${result_count}=    Get Length    ${results}
    ${price_count}=    Get Length    ${VARIANT_PRICES}
    Should Be Equal As Numbers    ${result_count}    ${price_count}
    
    # Kiểm tra giá của từng biến thể
    FOR    ${i}    ${result}    IN ENUMERATE    @{results}
        ${variant_id}=    Set Variable    ${result[0]}
        ${actual_price}=    Set Variable    ${result[1]}
        ${expected_price}=    Set Variable    ${VARIANT_PRICES}[${i}]
        
        Should Be Equal As Numbers    ${actual_price}    ${expected_price}
    END

Chuẩn Bị Dữ Liệu Sản Phẩm Với Các Biến Thể Có Tồn Kho Khác Nhau
    # Tạo danh sách tồn kho khác nhau cho các biến thể
    ${inventories}=    Create List    10    20    30
    Set Test Variable    ${VARIANT_INVENTORIES}    ${inventories}
    
    # Chuẩn bị dữ liệu sản phẩm cơ bản với thuộc tính
    ${request_data}=    Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính    ${dict_kich_thuoc}
    
    # Cập nhật tồn kho cho các biến thể trong yêu cầu
    ${product_list}=    Evaluate    json.loads(${REQUEST_DATA}["ListProductsString"][1])    json
    FOR    ${i}    ${inventory}    IN ZIP    RANGE    ${inventories}
        ${product_list}[${i}]["OnHand"] = ${inventory}
    END
    
    # Cập nhật lại danh sách sản phẩm trong yêu cầu
    ${updated_product_list}=    Evaluate    json.dumps(${product_list})    json
    ${REQUEST_DATA}["ListProductsString"] = (None, '${updated_product_list}')
    
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    RETURN    ${REQUEST_DATA}

Xác Thực Các Biến Thể Có Tồn Kho Theo Cấu Hình
    # Kiểm tra tồn kho của từng biến thể
    ${branch_id}=    Lấy Thông tin Chi Nhánh    Chi nhánh trung tâm
    
    FOR    ${i}    ${inventory}    ${code}    IN ZIP    RANGE    ${VARIANT_INVENTORIES}    ${LIST_PRODUCTS_CODE}
        ${query}=    Set Variable    SELECT OnHand FROM ProductBranch WHERE ProductId = (SELECT Id FROM Product WHERE Code = ?) AND BranchId = ?
        ${result}=    Fetch One    ${query}    ${code}    ${branch_id}
        
        Should Not Be Equal    ${result}    None    Không tìm thấy thông tin tồn kho cho biến thể ${code}
        Should Be Equal As Numbers    ${result[0]}    ${inventory}
    END

Xác Thực Tổng Tồn Kho Sản Phẩm Chính Bằng Tổng Các Biến Thể
    # Tính tổng tồn kho từ các biến thể
    ${total_inventory}=    Evaluate    sum([int(x) for x in $VARIANT_INVENTORIES])
    
    # Lấy tồn kho của sản phẩm chính
    ${branch_id}=    Lấy Thông tin Chi Nhánh    Chi nhánh trung tâm
    ${query}=    Set Variable    SELECT OnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}    ${branch_id}
    
    # Kiểm tra tổng tồn kho
    Should Be Equal As Numbers    ${result[0]}    ${total_inventory}    Tổng tồn kho sản phẩm chính (${result[0]}) không bằng tổng tồn kho các biến thể (${total_inventory})

Chuẩn Bị Dữ Liệu Sản Phẩm Với Các Biến Thể Có Mã Vạch Riêng
    # Tạo danh sách mã vạch khác nhau cho các biến thể
    ${barcodes}=    Create List    8936451790123    8936451790124    8936451790125
    Set Test Variable    ${VARIANT_BARCODES}    ${barcodes}
    
    # Chuẩn bị dữ liệu sản phẩm cơ bản với thuộc tính
    ${request_data}=    Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính    ${dict_kich_thuoc}
    
    # Cập nhật mã vạch cho các biến thể trong yêu cầu
    ${product_list}=    Evaluate    json.loads(${REQUEST_DATA}["ListProductsString"][1])    json
    FOR    ${i}    ${barcode}    IN ZIP    RANGE    ${barcodes}
        ${product_list}[${i}]["Barcode"] = "${barcode}"
    END
    
    # Cập nhật lại danh sách sản phẩm trong yêu cầu
    ${updated_product_list}=    Evaluate    json.dumps(${product_list})    json
    ${REQUEST_DATA}["ListProductsString"] = (None, '${updated_product_list}')
    
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    RETURN    ${REQUEST_DATA}

Xác Thực Các Biến Thể Có Mã Vạch Theo Cấu Hình
    # Kiểm tra mã vạch của từng biến thể
    FOR    ${barcode}    ${code}    IN ZIP    ${VARIANT_BARCODES}    ${LIST_PRODUCTS_CODE}
        ${query}=    Set Variable    SELECT Barcode FROM Product WHERE Code = ?
        ${result}=    Fetch One    ${query}    ${code}
        
        Should Not Be Equal    ${result}    None    Không tìm thấy thông tin mã vạch cho biến thể ${code}
        Should Be Equal    ${result[0]}    ${barcode}
    END

Chuẩn Bị Dữ Liệu Sản Phẩm Với Tổ Hợp Thuộc Tính Trùng Lặp
    # Tạo dictionary cho thuộc tính với giá trị trùng lặp
    @{value_thuoc_tinh}    Create List    Đỏ    Đỏ    Xanh
    &{dict_thuoc_tinh}    Create Dictionary    MÀU SẮC=@{value_thuoc_tinh}
    
    # Chuẩn bị dữ liệu sản phẩm với thuộc tính trùng lặp
    ${request_data}=    Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính    ${dict_thuoc_tinh}
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Tên Biến Thể Tự Động
    # Tạo dictionary cho thuộc tính kích thước và màu sắc
    @{value_mau_sac}    Create List    Đỏ    Xanh
    @{value_kich_thuoc}    Create List    S    M
    &{combined_attributes}    Create Dictionary    MÀU SẮC=@{value_mau_sac}    KÍCH THƯỚC=@{value_kich_thuoc}
    
    # Chuẩn bị dữ liệu sản phẩm cơ bản với thuộc tính
    ${request_data}=    Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính    ${combined_attributes}
    
    # Thiết lập sản phẩm gốc với tên cụ thể để kiểm tra tên tự động của biến thể
    ${product_list}=    Evaluate    json.loads(${REQUEST_DATA}["ListProductsString"][1])    json
    ${base_product_name}=    Set Variable    Áo Thun Test
    ${product_list}[0]["Name"] = "${base_product_name}"
    
    # Cập nhật lại danh sách sản phẩm trong yêu cầu
    ${updated_product_list}=    Evaluate    json.dumps(${product_list})    json
    ${REQUEST_DATA}["ListProductsString"] = (None, '${updated_product_list}')
    
    Set Test Variable    ${BASE_PRODUCT_NAME}    ${base_product_name}
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    RETURN    ${REQUEST_DATA}

Xác Thực Tên Các Biến Thể Được Tạo Đúng Theo Cấu Trúc
    # Kiểm tra tên của từng biến thể
    ${query}=    Set Variable    SELECT Id, Name FROM Product WHERE MasterProductId = ?
    ${results}=    Fetch All    ${query}    ${CREATED_PRODUCT_ID}
    
    FOR    ${result}    IN    @{results}
        ${variant_id}=    Set Variable    ${result[0]}
        ${variant_name}=    Set Variable    ${result[1]}
        
        # Lấy thông tin thuộc tính của biến thể
        ${attr_query}=    Set Variable    SELECT a.Name, pa.Value FROM ProductAttribute pa JOIN Attribute a ON pa.AttributeId = a.Id WHERE pa.ProductId = ?
        ${attr_results}=    Fetch All    ${attr_query}    ${variant_id}
        
        # Kiểm tra tên biến thể chứa giá trị thuộc tính
        FOR    ${attr_result}    IN    @{attr_results}
            ${attr_name}=    Set Variable    ${attr_result[0]}
            ${attr_value}=    Set Variable    ${attr_result[1]}
            Should Contain    ${variant_name}    ${attr_value}
        END
        
        # Kiểm tra tên biến thể bắt đầu bằng tên sản phẩm gốc
        Should Start With    ${variant_name}    ${BASE_PRODUCT_NAME}
    END

Chuẩn Bị Dữ Liệu Sản Phẩm Với Mã Biến Thể Tự Động
    # Tạo dictionary cho thuộc tính kích thước
    @{value_kich_thuoc}    Create List    S    M    L
    &{dict_kich_thuoc}    Create Dictionary    KÍCH THƯỚC=@{value_kich_thuoc}
    
    # Chuẩn bị dữ liệu sản phẩm cơ bản với thuộc tính
    ${request_data}=    Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính    ${dict_kich_thuoc}
    
    # Thiết lập mã sản phẩm gốc cụ thể để kiểm tra mã tự động của biến thể
    ${base_product_code}=    Set Variable    ATTT123
    
    # Cập nhật mã sản phẩm gốc trong yêu cầu
    ${product_list}=    Evaluate    json.loads(${REQUEST_DATA}["ListProductsString"][1])    json
    ${product_list}[0]["Code"] = "${base_product_code}"
    
    # Cập nhật lại danh sách sản phẩm trong yêu cầu
    ${updated_product_list}=    Evaluate    json.dumps(${product_list})    json
    ${REQUEST_DATA}["ListProductsString"] = (None, '${updated_product_list}')
    
    Set Test Variable    ${BASE_PRODUCT_CODE}    ${base_product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    RETURN    ${REQUEST_DATA}

Xác Thực Mã Các Biến Thể Được Tạo Dựa Trên Mã Sản Phẩm Gốc
    # Kiểm tra mã của từng biến thể
    ${query}=    Set Variable    SELECT Code FROM Product WHERE MasterProductId = ?
    ${results}=    Fetch All    ${query}    ${CREATED_PRODUCT_ID}
    
    FOR    ${result}    IN    @{results}
        ${variant_code}=    Set Variable    ${result[0]}
        
        # Kiểm tra mã biến thể bắt đầu bằng mã sản phẩm gốc
        Should Start With    ${variant_code}    ${BASE_PRODUCT_CODE}
    END

Kiểm Tra Giới Hạn Số Lượng Thuộc Tính Cho Sản Phẩm
    [Arguments]    ${số_thuộc_tính}    ${kết_quả_mong_đợi}
    # Tạo danh sách thuộc tính theo số lượng yêu cầu
    &{attributes_dict}=    Create Dictionary
    
    FOR    ${i}    IN RANGE    ${số_thuộc_tính}
        @{values}=    Create List    Value_${i}_1    Value_${i}_2
        Set To Dictionary    ${attributes_dict}    Attribute_${i}    ${values}
    END
    
    # Chuẩn bị dữ liệu sản phẩm với thuộc tính
    ${request_data}=    Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính    ${attributes_dict}
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    
    # Gửi yêu cầu và kiểm tra kết quả
    Gửi Yêu Cầu Tạo Sản Phẩm
    
    IF    '${kết_quả_mong_đợi}' == 'Thành công'
        Mã Trạng Thái Phải Là 200
        Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    ELSE
        Mã Trạng Thái Phải Là 420
        Phản hồi phải chứa lỗi "Số lượng thuộc tính vượt quá giới hạn cho phép"
    END

Kiểm Tra Giới Hạn Số Lượng Giá Trị Thuộc Tính
    [Arguments]    ${số_giá_trị}    ${kết_quả_mong_đợi}
    # Tạo danh sách giá trị thuộc tính theo số lượng yêu cầu
    @{attribute_values}=    Create List
    
    FOR    ${i}    IN RANGE    ${số_giá_trị}
        Append To List    ${attribute_values}    Value_${i}
    END
    
    &{attribute_dict}=    Create Dictionary    Test_Attribute    ${attribute_values}
    
    # Chuẩn bị dữ liệu sản phẩm với thuộc tính
    ${request_data}=    Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính    ${attribute_dict}
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    
    # Gửi yêu cầu và kiểm tra kết quả
    Gửi Yêu Cầu Tạo Sản Phẩm
    
    IF    '${kết_quả_mong_đợi}' == 'Thành công'
        Mã Trạng Thái Phải Là 200
        Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    ELSE
        Mã Trạng Thái Phải Là 420
        Phản hồi phải chứa lỗi "Số lượng giá trị thuộc tính vượt quá giới hạn cho phép"
    END

    
