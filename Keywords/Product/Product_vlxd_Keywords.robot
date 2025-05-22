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
Library           String
Resource          Product_KeywordsCommand.robot

*** Variables ***
${CATEGORY_ID_HANG_HOA_VLXD}    1000000753
*** Keywords ***

Chuẩn Bị Dữ Liệu Sản Phẩm ${type} Có Kích Thước ${width}x${height} ${unit}
    ${unit}    Run Keyword If    "${unit}" == "cm"    Set Variable    1    ELSE IF    "${unit}" == "m"
    ...   Set Variable    2   ELSE    Set Variable    0
    ${type}    Set Variable If    "${type}" == "Viên"   1  2
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    KT${random_code}
    ${request}    Update Dictionary Property    ${request}    CategoryId    ${CATEGORY_ID_HANG_HOA_VLXD}
    ${request}    Update Dictionary Property    ${request}    Attribute1    ${width}
    ${request}    Update Dictionary Property    ${request}    Attribute2    ${height}
    ${request}    Update Dictionary Property    ${request}    Type1    ${type}
    ${request}    Update Dictionary Property    ${request}    Type2   ${unit}  
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}


Chuẩn Bị Dữ Liệu Hàng Serial ${type} Có Kích Thước ${width}x${height} ${unit}
    ${unit}    Run Keyword If    "${unit}" == "cm"    Set Variable    1    ELSE IF    "${unit}" == "m"
    ...   Set Variable    2   ELSE    Set Variable    0
    ${type}    Set Variable If    "${type}" == "Viên"   1  2
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    KT${random_code}
    ${request}    Update Dictionary Property    ${request}    CategoryId    ${CATEGORY_ID_HANG_HOA_VLXD}
    ${request}    Update Dictionary Property    ${request}    Attribute1    ${width}
    ${request}    Update Dictionary Property    ${request}    Attribute2    ${height}
    ${request}    Update Dictionary Property    ${request}    Type1    ${type}
    ${request}    Update Dictionary Property    ${request}    Type2   ${unit}  
    ${request}    Update Dictionary Property    ${request}    IsLotSerialControl    True
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Hàng Lô ${type} Có Kích Thước ${width}x${height} ${unit}
    ${unit}    Run Keyword If    "${unit}" == "cm"    Set Variable    1    ELSE IF    "${unit}" == "m"
    ...   Set Variable    2   ELSE    Set Variable    0
    ${type}    Set Variable If    "${type}" == "Viên"   1  2
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    KT${random_code}
    ${request}    Update Dictionary Property    ${request}    CategoryId    ${CATEGORY_ID_HANG_HOA_VLXD}
    ${request}    Update Dictionary Property    ${request}    Attribute1    ${width}
    ${request}    Update Dictionary Property    ${request}    Attribute2    ${height}
    ${request}    Update Dictionary Property    ${request}    Type1    ${type}
    ${request}    Update Dictionary Property    ${request}    Type2   ${unit}  
    ${request}    Update Dictionary Property    ${request}    IsBatchExpireControl    True
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}


Chuẩn Bị Dữ Liệu Hàng DVQD ${list_unit} Và ${list_value} Có Kích Thước ${width}x${height} ${unit}
    ${unit}    Run Keyword If    "${unit}" == "cm"    Set Variable    1    ELSE IF    "${unit}" == "m"
    ...   Set Variable    2   ELSE    Set Variable    0

    ${list_unit_body}    Create List
    ${list_product_code}     Create List
    ${list_product_body}     Create List
    FOR    ${item_name}   ${item_value}  IN ZIP   ${list_unit}    ${list_value}
        ${unit_body}    Deep Copy    ${PRODUCT_UNITS}
        ${unit_body}    Update Dictionary Property    ${unit_body}    Unit    ${item_name}
        ${unit_body}    Update Dictionary Property    ${unit_body}    ConversionValue    ${item_value}
        Append To List    ${list_unit_body}    ${unit_body}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        ${code}=    Set Variable    QD${random_code}
        ${request}    Deep Copy    ${list_product_data}
        ${request}    Update Dictionary Property    ${request}    Code    ${code}
        ${request}    Update Dictionary Property    ${request}    CategoryId    ${CATEGORY_ID_HANG_HOA_VLXD}
        ${request}    Update Dictionary Property    ${request}    Attribute1    ${width}
        ${request}    Update Dictionary Property    ${request}    Attribute2    ${height}
        ${request}    Update Dictionary Property    ${request}    Type1   1
        ${request}    Update Dictionary Property    ${request}    Type2   ${unit}  
        ${request}    Update Dictionary Property    ${request}    Unit    ${item_name}
        ${request}    Update Dictionary Property    ${request}    ConversionValue    ${item_value}
        ${request}    Update Dictionary Property    ${request}    ProductUnits    ${list_unit_body}
        Append To List   ${list_product_body}    ${request}
        Append To List   ${list_product_code}    ${code}
    END
    ${form_data}=    Evaluate     str(${list_product_body}).replace("'",'"')
    ${list_products}     Evaluate    (None, '${form_data}')
    ${payload}    Create Dictionary    ListProductsString=${list_products}         
    Log     ${payload}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${LIST_PRODUCT_CODE}    ${list_product_code}
    RETURN    ${REQUEST_DATA}


Chuẩn Bị Dữ Liệu Hàng Thuộc Tính ${dict_attribute_name} Có Kích Thước ${width}x${height} ${unit}
    ${unit}    Run Keyword If    "${unit}" == "cm"    Set Variable    1    ELSE IF    "${unit}" == "m"
    ...   Set Variable    2   ELSE    Set Variable    0
    
    ${list_product_code}     Create List
    ${list_product_body}     Create List
    ${combinations}    ${attribute_names}=    Tạo danh sách tổ hợp thuộc tính    ${dict_attribute_name}
    ${length}=    Get Length    ${combinations}
    ${length}=    Evaluate    ${length}-1

    FOR    ${combination}    IN    @{combinations}
        ${request}=    Deep Copy    ${list_product_data}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        ${code}=    Set Variable    HHTT${random_code}
        Append To List    ${list_product_code}    ${code}
        ${request}=    Update Nested Dictionary Property    ${request}    Code    ${code}
        
        # Tạo tên sản phẩm từ tổ hợp thuộc tính
        ${combination_values}=    Split String    ${combination}    |
        ${product_name}=    Set Variable   Sản phẩm
        FOR    ${index}    IN RANGE    ${length}
            ${value}=    Get From List    ${combination_values}    ${index}
            ${product_name_unit}=    Set Variable   ${product_name}-${value}
        END
        ${request}=    Update Nested Dictionary Property     ${request}  Name   ${product_name}
        ${request}=    Update Nested Dictionary Property     ${request}    FullName   ${value}
        ${request}=    Update Nested Dictionary Property     ${request}    MasterCode    ${value}
        ${request}=    Update Nested Dictionary Property     ${request}    CompareFullName   ${value}
        ${request}    Update Dictionary Property    ${request}    CategoryId    ${CATEGORY_ID_HANG_HOA_VLXD}
        ${request}    Update Dictionary Property    ${request}    Attribute1    ${width}
        ${request}    Update Dictionary Property    ${request}    Attribute2    ${height}
        ${request}    Update Dictionary Property    ${request}    Type1   1
        ${request}    Update Dictionary Property    ${request}    Type2   ${unit}         # Tạo danh sách thuộc tính cho sản phẩm
        ${product_attributes}=    Create List
        FOR    ${index}    IN RANGE    ${length}
            ${attribute}=    Deep Copy    ${standard_product_attributes}
            ${value}=    Get From List    ${combination_values}    ${index}
            ${attr_name}=    Get From List   ${attribute_names}    ${index}
            ${attribute_id}=    Lấy ID thuộc tính    ${attr_name}
            ${attribute}=     Update Nested Dictionary Property    ${attribute}    AttributeId    ${attribute_id}
            ${attribute}=    Update Nested Dictionary Property      ${attribute}    Value    ${value}
            Append To List    ${product_attributes}    ${attribute}
        END
        ${request}=    Update Nested Dictionary Property     ${request}    ProductAttributes    ${product_attributes}
        Append To List    ${list_product_body}    ${request}
    END
    ${form_data}=    Evaluate     str(${list_product_body}).replace("'",'"')
    ${list_products}     Evaluate    (None, '${form_data}')
    ${payload}    Create Dictionary    ListProductsString=${list_products}     
    Log     ${payload}
    Set Test Variable    ${LIST_PRODUCT_CODE}    ${list_product_code}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}




            
