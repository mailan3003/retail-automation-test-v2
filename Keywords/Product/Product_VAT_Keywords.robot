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
Resource          Product_KeywordsCommand.robot
Library           String
*** Variables ***
*** Keywords ***
Tạo Sản Phẩm Và Xác Thực Thuế
    [Arguments]    ${tax_rate}
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế ${tax_rate}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    ${clean_rate}=    Remove String    ${tax_rate}    %
    And Xác Thực Sản Phẩm Có Thuế ${clean_rate} Theo Dữ Liệu Đã Gửi
Chuẩn Bị Dữ Liệu Sản Phẩm Thuế ${type_tax} Với ${tax_rate} %
    ${tax_ID}  Run Keyword If  '${type_tax}'=='Trực Tiếp'    Lấy taxid từ giá trị thuế trực tiếp    ${tax_rate}
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy taxid từ giá trị thuế    ${tax_rate}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    SP${random_code}
    ${category_id}=    Run Keyword If  '${type_tax}'=='Trực Tiếp'     Lấy Thông tin Nhóm Hàng  ${CATEGORY_NAME}  
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy Thông tin Nhóm Hàng    ${CATEGORY_HANG_HOA_VLXD}
    ${request}    Update Dictionary Property    ${request}    CategoryId    ${category_id}
    ${request}    Update Dictionary Property    ${request}    TaxId     ${tax_ID}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    



Chuẩn Bị Dữ Liệu Hàng Dịch Vụ Thuế ${type_tax} Với ${tax_rate} %
    ${tax_ID}  Run Keyword If  '${type_tax}'=='Trực Tiếp'    Lấy taxid từ giá trị thuế trực tiếp    ${tax_rate}
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy taxid từ giá trị thuế    ${tax_rate}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    DV${random_code}
   ${category_id}=    Run Keyword If  '${type_tax}'=='Trực Tiếp'     Lấy Thông tin Nhóm Hàng  ${CATEGORY_NAME}  
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy Thông tin Nhóm Hàng    ${CATEGORY_HANG_HOA_VLXD}
    ${request}    Update Dictionary Property    ${request}    CategoryId    ${category_id}
    ${request}    Update Dictionary Property    ${request}    ProductType    3
    ${request}    Update Dictionary Property    ${request}    TaxId     ${tax_ID}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}        BranchForProductCostss=${branch_pr_cost}  
    Log     ${payload}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Quản Lý Serial Thuế ${type_tax} Với ${tax_rate} %
    ${tax_ID}  Run Keyword If  '${type_tax}'=='Trực Tiếp'    Lấy taxid từ giá trị thuế trực tiếp    ${tax_rate}
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy taxid từ giá trị thuế    ${tax_rate}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    SP${random_code}
   ${category_id}=    Run Keyword If  '${type_tax}'=='Trực Tiếp'     Lấy Thông tin Nhóm Hàng  ${CATEGORY_NAME}  
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy Thông tin Nhóm Hàng    ${CATEGORY_HANG_HOA_VLXD}
    ${request}    Update Dictionary Property    ${request}    CategoryId    ${category_id}
    ${request}    Update Dictionary Property    ${request}    IsLotSerialControl    true
    ${request}    Update Dictionary Property    ${request}    TaxId     ${tax_ID}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Quản Lý Lô Và Hạn Sử Dụng Thuế ${type_tax} Với ${tax_rate} %
    ${tax_ID}  Run Keyword If  '${type_tax}'=='Trực Tiếp'    Lấy taxid từ giá trị thuế trực tiếp    ${tax_rate}
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy taxid từ giá trị thuế    ${tax_rate}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    SP${random_code}
    ${category_id}=    Run Keyword If  '${type_tax}'=='Trực Tiếp'     Lấy Thông tin Nhóm Hàng  ${CATEGORY_NAME}  
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy Thông tin Nhóm Hàng    ${CATEGORY_HANG_HOA_VLXD}
    ${request}    Update Dictionary Property    ${request}    CategoryId    ${category_id}
    ${request}    Update Dictionary Property    ${request}    IsBatchExpireControl    true
    ${request}    Update Dictionary Property    ${request}    TaxId     ${tax_ID}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request} 

Chuẩn Bị Dữ Liệu Sản Phẩm Loại Hàng Sản Xuất Thuế ${type_tax} Với ${tax_rate} %
    ${tax_ID}  Run Keyword If  '${type_tax}'=='Trực Tiếp'    Lấy taxid từ giá trị thuế trực tiếp    ${tax_rate}
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy taxid từ giá trị thuế    ${tax_rate}
    ${request}=    Deep Copy     ${list_product_data}
    ${formula}          Deep Copy     ${PRODUCT_FORMULAS}  
    ${formula}     Create List    ${formula}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    HSX${random_code}
    ${category_id}=    Run Keyword If  '${type_tax}'=='Trực Tiếp'     Lấy Thông tin Nhóm Hàng  ${CATEGORY_NAME}  
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy Thông tin Nhóm Hàng    ${CATEGORY_HANG_HOA_VLXD}
    ${request}    Update Dictionary Property    ${request}    CategoryId    ${category_id}
    ${request}    Update Dictionary Property    ${request}    ProductFormulas    ${formula}   
    ${request}    Update Dictionary Property    ${request}    TaxId     ${tax_ID} 
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}        BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}



Chuẩn Bị Dữ Liệu Sản Phẩm Combo Thuế ${type_tax} Với ${tax_rate} %
    ${tax_ID}  Run Keyword If  '${type_tax}'=='Trực Tiếp'    Lấy taxid từ giá trị thuế trực tiếp    ${tax_rate}
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy taxid từ giá trị thuế    ${tax_rate}
    ${request}=    Deep Copy     ${list_product_data}
    ${formula}=     Deep Copy    ${PRODUCT_FORMULAS}
    ${formula}    Create List    ${formula}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    CB${random_code}
    ${request}    Update Dictionary Property    ${request}    ProductType    1
    ${category_id}=    Run Keyword If  '${type_tax}'=='Trực Tiếp'     Lấy Thông tin Nhóm Hàng  ${CATEGORY_NAME}  
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy Thông tin Nhóm Hàng    ${CATEGORY_HANG_HOA_VLXD}
    ${request}    Update Dictionary Property    ${request}    CategoryId    ${category_id}
    ${request}    Update Dictionary Property    ${request}    ProductFormulas    ${formula}
    ${request}    Update Dictionary Property    ${request}    TaxId     ${tax_ID}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Thuế ${type_tax} Với ${tax_rate} %
    ${tax_ID}  Run Keyword If  '${type_tax}'=='Trực Tiếp'    Lấy taxid từ giá trị thuế trực tiếp    ${tax_rate}
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy taxid từ giá trị thuế    ${tax_rate}
    ${product_info}=    Lấy thông tin thuốc từ danh mục thuốc    1
    ${manufacturer_info}=    Lấy thông tin hãng sản xuất nhà thuốc  ${product_info[7]}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${category_id}=      Lấy Thông tin Nhóm Hàng  ${CATEGORY_NAME_DRUG}  
    ${request}    Update Dictionary Property    ${request}    Code    T${random_code}
    ${request}    Update Dictionary Property    ${request}    IsBatchExpireControl    true
    ${request}    Update Dictionary Property    ${request}    Name    ${product_info[2]}
    ${request}    Update Dictionary Property    ${request}    CategoryId    ${category_id}
    ${request}    Update Dictionary Property    ${request}    IsSyncNationalPharmacy    false
    ${request}    Update Dictionary Property    ${request}    GlobalMedicineId    ${product_info[0]}
    ${request}    Update Dictionary Property    ${request}    MedicineCode    ${product_info[1]}
    ${request}    Update Dictionary Property    ${request}    RegistrationNo    ${product_info[3]}
    ${request}    Update Dictionary Property    ${request}    ActiveElement    ${product_info[4]}
    ${request}    Update Dictionary Property    ${request}    Content    ${product_info[5]}
    ${request}    Update Dictionary Property    ${request}    GlobalManufacturerName    ${manufacturer_info[1]}
    ${request}    Update Dictionary Property    ${request}    GlobalManufacturerCountryName    Ấn Độ
    ${request}    Update Dictionary Property    ${request}    PackagingSize    ${product_info[6]}
    ${request}    Update Dictionary Property    ${request}    GlobalManufacturerId     ${manufacturer_info[0]}
    ${request}    Update Dictionary Property    ${request}    GlobalRoaId    1000000001
    ${request}    Update Dictionary Property    ${request}    RouteOfAdministration    1000000001
    ${request}    Update Dictionary Property    ${request}    GlobalManufacturerCountryId    2
    ${request}    Update Dictionary Property    ${request}    TaxId     ${tax_ID}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Thuế ${type_tax} Với ${tax_rate} % Và Đơn Vị Quy Đổi ${name_unit} Với ${value}
    ${tax_ID}  Run Keyword If  '${type_tax}'=='Trực Tiếp'    Lấy taxid từ giá trị thuế trực tiếp    ${tax_rate}
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy taxid từ giá trị thuế    ${tax_rate}
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
    ${list_product}        Update Nested Dictionary Property   ${list_products}    TaxId     ${tax_ID}
    ${list_product_body}     Create List    ${list_product}  
    ${list_product_code}     Create List
    FOR    ${item_name}   ${item_value}  IN ZIP    ${name_unit}  ${value}
        ${request}=    Deep Copy    ${list_product_data}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        ${code}=    Set Variable    QD${random_code}
        ${request}    Update Dictionary Property    ${request}    Code    ${code}
        ${category_id}=    Run Keyword If  '${type_tax}'=='Trực Tiếp'     Lấy Thông tin Nhóm Hàng  ${CATEGORY_NAME}  
        ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy Thông tin Nhóm Hàng    ${CATEGORY_HANG_HOA_VLXD}
        ${request}    Update Dictionary Property    ${request}    CategoryId    ${category_id}
        ${request}    Update Dictionary Property    ${request}    Unit    ${item_name}
        ${request}    Update Dictionary Property    ${request}    ConversionValue    ${item_value}
        ${request}    Update Dictionary Property    ${request}    TaxId    ${tax_ID}
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

Chuẩn Bị Dữ Liệu Sản Phẩm Thuế ${type_tax} Với ${tax_rate} % Và Thuộc Tính ${dict_attribute_name_1}
    ${tax_ID}  Run Keyword If  '${type_tax}'=='Trực Tiếp'    Lấy taxid từ giá trị thuế trực tiếp    ${tax_rate}
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy taxid từ giá trị thuế    ${tax_rate}
    ${list_products}=    Create List
    
    # Lấy thông tin thuộc tính từ dictionary đầu vào
    ${attribute_names}=    Get Dictionary Keys    ${dict_attribute_name_1}
    ${length}=    Get Length    ${attribute_names}
    
    # Tạo danh sách các giá trị thuộc tính cho mỗi thuộc tính
    ${all_attribute_values}=    Create List
    FOR    ${attr_name}    IN    @{attribute_names}
        ${attr_values}=    Get From Dictionary    ${dict_attribute_name_1}    ${attr_name}
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
        ${category_id}=    Run Keyword If  '${type_tax}'=='Trực Tiếp'     Lấy Thông tin Nhóm Hàng  ${CATEGORY_NAME}  
        ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy Thông tin Nhóm Hàng    ${CATEGORY_HANG_HOA_VLXD}
        ${request}    Update Dictionary Property    ${request}    CategoryId    ${category_id}
        ${request}=    Update Nested Dictionary Property    ${request}    TaxId    ${tax_ID}
        
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

Chuẩn Bị Dữ Liệu Cập Nhật Thuế ${type_tax} Với ${tax_rate} % Cho Sản Phẩm
    Chuẩn Bị Dữ Liệu Sản Phẩm Thuế ${type_tax} Với 5 % 
    ${tax_old}     Run Keyword If  '${type_tax}'=='Trực Tiếp'    Lấy taxid từ giá trị thuế trực tiếp   5
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy taxid từ giá trị thuế  5
    Gửi Yêu Cầu Tạo Sản Phẩm
    ${tax_ID}  Run Keyword If  '${type_tax}'=='Trực Tiếp'    Lấy taxid từ giá trị thuế trực tiếp    ${tax_rate}
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy taxid từ giá trị thuế    ${tax_rate}
    ${request}      Deep Copy     ${list_product_data}
    ${request}    Update Dictionary Property    ${request}    TaxId    ${tax_ID}
    ${category_id}=    Run Keyword If  '${type_tax}'=='Trực Tiếp'     Lấy Thông tin Nhóm Hàng  ${CATEGORY_NAME}  
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy Thông tin Nhóm Hàng    ${CATEGORY_HANG_HOA_VLXD}
    ${request}    Update Dictionary Property    ${request}    CategoryId    ${category_id}
    ${request}    Update Dictionary Property    ${request}    Id    ${CREATED_PRODUCT_ID}
    ${request}    Update Dictionary Property    ${request}    Code    ${CREATED_PRODUCT_CODE}
    ${request}    Update Dictionary Property    ${request}    CompareTaxId     ${tax_old} 
    ${request}    Update Dictionary Property    ${request}    VariantCount    1
    ${request}    Update Dictionary Property    ${request}    CompareCode     ${CREATED_PRODUCT_CODE}
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '${form_data}')
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${payload}    Create Dictionary    Product=${list_products}         BranchForProductCostss=${branch_pr_cost}  
    Log     ${payload}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}


Sao chép hàng hóa Thuế ${type_tax} Với ${tax_rate} % Cho Sản Phẩm
    Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế ${type_tax} Với 5 % 
    ${tax_ID}  Run Keyword If  '${type_tax}'=='Trực Tiếp'    Lấy taxid từ giá trị thuế trực tiếp    ${tax_rate}
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy taxid từ giá trị thuế    ${tax_rate}
    Gửi Yêu Cầu Tạo Sản Phẩm
    ${request}      Deep Copy     ${list_product_data}
    ${request}    Update Dictionary Property    ${request}    TaxId    ${tax_ID}
    ${request}    Update Dictionary Property    ${request}    ProductId    ${CREATED_PRODUCT_ID}
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '${form_data}')
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${payload}    Create Dictionary    Product=${list_products}         BranchForProductCostss=${branch_pr_cost}      CloneProductId=${CREATED_PRODUCT_ID}
    Log     ${payload}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}


Chuẩn Bị Dữ Liệu Sản Phẩm Tạo Từ Form Khác Với Thuế ${type_tax} Với ${tax_rate} %
    ${tax_ID}  Run Keyword If  '${type_tax}'=='Trực Tiếp'    Lấy taxid từ giá trị thuế trực tiếp    ${tax_rate}
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy taxid từ giá trị thuế    ${tax_rate}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    SP${random_code}
    ${category_id}=    Run Keyword If  '${type_tax}'=='Trực Tiếp'     Lấy Thông tin Nhóm Hàng  ${CATEGORY_NAME}  
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy Thông tin Nhóm Hàng    ${CATEGORY_HANG_HOA_VLXD}
    ${request}    Update Dictionary Property    ${request}    CategoryId    ${category_id}
    ${request}    Update Dictionary Property    ${request}    TaxId     ${tax_ID}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}     isAddFromOtherForm=true 
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Tạo Từ Form MHBH Với Thuế ${type_tax} Với ${tax_rate} %
    ${tax_ID}  Run Keyword If  '${type_tax}'=='Trực Tiếp'    Lấy taxid từ giá trị thuế trực tiếp    ${tax_rate}
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy taxid từ giá trị thuế    ${tax_rate}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    SP${random_code}
    ${category_id}=    Run Keyword If  '${type_tax}'=='Trực Tiếp'     Lấy Thông tin Nhóm Hàng  ${CATEGORY_NAME}  
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy Thông tin Nhóm Hàng    ${CATEGORY_HANG_HOA_VLXD}
    ${request}    Update Dictionary Property    ${request}    CategoryId    ${category_id}
    ${request}    Update Dictionary Property    ${request}    TaxId     ${tax_ID}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProducts=${list_products}         
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}
