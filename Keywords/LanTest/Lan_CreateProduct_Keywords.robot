*** Settings ***

Resource    ../Utilities/DataUtilities.robot
Resource    ../../TestData/LanTest/Lan_Product_data.robot
Resource    ../Utilities/Utilities.robot
Library    ../../Resources/DatabaseLibrary.py
Resource    ../../Config/Env_${ENV}.robot

Documentation     Keywords cho test API tạo sản phẩm
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Product/ProductInputData.robot
Library           String

*** Variables ***
${PRODUCT_API_ENDPOINT}     products/addmany
${WARRANTY_API_SAVE_ENDPOINT}    warranty/save
${PRODUCT_UPDATE_API_ENDPOINT}   products/photo
${PRODUCT_DELETE_API_ENDPOINT}   products/{0}
${REQUEST_FILES}    ${None}


*** Keywords ***
#Chuan bi du lieu


Chuẩn bị dữ liệu tạo sản phẩm
    ${request} =     Deep Copy    ${list_product_data}
    ${category_id}=    Lấy Thông tin Nhóm Hàng    ${CATEGORY_NAME}
    ${request}    Update Dictionary Property    ${request}    CategoryId    ${category_id}
    ${random_code}=    Generate Random String    8    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    HH${random_code}
    ${branch_price_cost}    Evaluate    str(${branch_for_cost}).replace("'",'"')
    ${branch_price_cost}    Evaluate    (None, '[${branch_price_cost}]')
    ${form_data}=    Evaluate    str(${request}).replace("'",'"')
    ${list_product}    Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_product}       BranchForProductCostss=${branch_price_cost}
    Set Test Variable    ${REQUEST_PRODUCT_DATA}    ${payload}
    Log    Request create product data: ${REQUEST_PRODUCT_DATA}
    RETURN    ${REQUEST_PRODUCT_DATA}

Gửi yêu cầu tạo sản phẩm Mới
    ${response}=    Call API With Form Data    ${API_MAN_URL}    ${PRODUCT_API_ENDPOINT}    ${REQUEST_PRODUCT_DATA}    ${REQUEST_FILES}    
    Set Test Variable    ${RESPONSE}    ${response}
    Log    Response data hihihi: ${RESPONSE}
    Log    ${response.text}    level=ERROR
    IF    '${RESPONSE.status_code}' == '200'
        ${product_id}=    Set Variable    ${RESPONSE.json()["Data"][0]["Id"]}
        ${product_code}=    Set Variable    ${RESPONSE.json()["Data"][0]["Code"]}
        Set Test Variable    ${CREATED_PRD_ID}    ${product_id}
        Set Test Variable    ${CREATED_PRD_CODE}    ${product_code}
    END
    RETURN    ${response}   

Xác thực sản phẩm đã được tạo trong DB
    ${query}=    Set Variable    SELECT Id, Code, Name FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRD_ID}
    Should Not Be Equal    ${result}    None     Khong tim thay san pham da tao trong database
    Set Test Variable    ${DB_PRD_ID}    ${result[0]}
    Set Test Variable    ${DB_PRD_CODE}    ${result[1]}
    Set Test Variable    ${DB_PRD_NAME}    ${result[2]}

Xóa sản phẩm vừa tạo
    [Arguments]    ${product_code}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${endpoint}=    Format String    ${PRODUCT_DELETE_API_ENDPOINT}    ${product_id}
    Delete Data    ${endpoint}

Lấy Thông tin Nhóm Hàng 
    [Arguments]    ${group_name}
    ${query}=    Set Variable    SELECT Id FROM Category WHERE Name = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${group_name}    ${RETAILER_ID}
    RETURN    ${result[0]}

Lấy Thông tin Sản Phẩm  
    [Arguments]    ${product_code}
    ${query}=    Set Variable    SELECT Id FROM Product WHERE Code = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${product_code}    ${RETAILER_ID}
    RETURN    ${result[0]}

Chuẩn bị dữ liệu sản phẩm nhiều thuộc tính
    #Tao cac thuoc tinh khac nhau: Mau sac, kich thuoc, chat lieu
    @{COLORS}=    Create list    Red    Blue    Green    BlackGray
    @{SIZE}=    Create List    XS    S    M    L    XL
    @{MATERIAL}=    Create List    Cotton    Polyester
    &{dict_attribuies}=    Create Dictionary
    ...    COLORS=${COLORS}
    ...    SIZE=${SIZE}
    ...    MATERIAL=${MATERIAL}
    ${list_product}=    Create List
    ${attribute_names}=    Get Dictionary Keys    ${dict_attribuies}
    ${attribute_length}=    Get Length    ${attribute_names}
Chuẩn Bị Dữ Liệu Sản Phẩm Với Nhiều Loại Thuộc Tính
    # Tạo các thuộc tính khác nhau: Màu sắc, Kích thước, Chất liệu
    &{dict_attributes}=    Create Dictionary    
    ...    MÀU SẮC=@{{"Đỏ", "Xanh", "Vàng"}}
    ...    KÍCH THƯỚC=@{{"S", "M", "L"}}
    ...    CHẤT LIỆU=@{{"Cotton", "Polyester"}}
    
    ${list_products}=    Create List
    
    # Lấy thông tin thuộc tính từ dictionary đầu vào
    ${attribute_names}=    Get Dictionary Keys    ${dict_attributes}
    ${length}=    Get Length    ${attribute_names}
    
    # Tạo danh sách các giá trị thuộc tính cho mỗi thuộc tính
    ${all_attribute_values}=    Create List
    FOR    ${attr_name}    IN    @{attribute_names}
        ${attr_values}=    Get From Dictionary    ${dict_attributes}    ${attr_name}
        Append To List    ${all_attribute_values}    ${attr_values}
    END
    
    # Tạo tất cả các tổ hợp thuộc tính (chỉ lấy tối đa 5 tổ hợp để tránh quá nhiều)
    ${combinations}=    Create List    ${EMPTY}
    ${count}=    Set Variable    0
    FOR    ${attr_values}    IN    @{all_attribute_values}
        ${new_combinations}=    Create List
        FOR    ${combination}    IN    @{combinations}
            FOR    ${value}    IN    @{attr_values}
                Exit For Loop If    ${count} >= 5
                ${new_combination}=    Set Variable    ${combination}${value}|
                Append To List    ${new_combinations}    ${new_combination}
                ${count}=    Evaluate    ${count} + 1
            END
            Exit For Loop If    ${count} >= 5
        END
        ${combinations}=    Set Variable    ${new_combinations}
        Exit For Loop If    ${count} >= 5
    END
    
    ${list_products_code}=    Create List
    # Tạo sản phẩm cho mỗi tổ hợp thuộc tính
    FOR    ${combination}    IN    @{combinations}
        ${request}=    Deep Copy    ${list_product_data}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        ${code}=    Set Variable    HHTT${random_code}
        Append To List    ${list_products_code}    ${code}
        ${request}=    Update Nested Dictionary Property    ${request}    Code    ${code}
        ${category_id}=    Lấy Thông tin Nhóm Hàng   ${CATEGORY_NAME}
        ${request}    Update Dictionary Property    ${request}    CategoryId    ${category_id}
        
        # Tạo tên sản phẩm từ tổ hợp thuộc tính
        ${combination_values}=    Split String    ${combination}    |
        ${product_name}=    Set Variable    Sản phẩm nhiều thuộc tính
        FOR    ${index}    IN RANGE    ${length}
            ${value}=    Get From List    ${combination_values}    ${index}
            ${product_name}=    Set Variable    ${product_name}-${value}
        END
        ${request}=    Update Nested Dictionary Property    ${request}    Name    ${product_name}
        
        # Tạo danh sách thuộc tính cho sản phẩm
        ${product_attributes}=    Create List
        FOR    ${index}    IN RANGE    ${length}
            ${attribute}=    Deep Copy    ${standard_product_attributes}
            ${value}=    Get From List    ${combination_values}    ${index}
            ${attr_name}=    Get From List    ${attribute_names}    ${index}
            ${attribute_id}=    Lấy ID thuộc tính    ${attr_name}
            ${attribute}=    Update Nested Dictionary Property    ${attribute}    AttributeId    ${attribute_id}
            ${attribute}=    Update Nested Dictionary Property    ${attribute}    Value    ${value}
            Append To List    ${product_attributes}    ${attribute}
        END
        
        ${request}=    Update Nested Dictionary Property    ${request}    ProductAttributes    ${product_attributes}
        Append To List    ${list_products}    ${request}
    END

    ${branch_pr_cost}=    Evaluate    str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}=    Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate    str(${list_products}).replace("'",'"')
    ${list_products_attribute}=    Evaluate    (None, '${form_data}')
    ${payload}=    Create Dictionary    ListProductsString=${list_products_attribute}    BranchForProductCostss=${branch_pr_cost}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${LIST_PRODUCTS_CODE}    ${list_products_code}
    RETURN    ${REQUEST_DATA}



# Chuẩn Bị Dữ Liệu Sản Phẩm Cơ Bản
#     ${request}=    Deep Copy     ${list_product_data}
#     ${category_id}=    Lấy Thông tin Nhóm Hàng   ${CATEGORY_NAME}
#     ${request}    Update Dictionary Property    ${request}    CategoryId    ${category_id}
#     ${random_code}=    Generate Random String    8    [NUMBERS]
#     ${request}    Update Dictionary Property    ${request}    Code    HHA${random_code}
#     ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
#     ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
#     ${form_data}=    Evaluate     str(${request}).replace("'",'"')
#     ${list_products}     Evaluate    (None, '[${form_data}]')
#     ${payload}    Create Dictionary    ListProductsString=${list_products}        BranchForProductCostss=${branch_pr_cost}  
#     Set Test Variable    ${REQUEST_DATA}    ${payload}
#     RETURN    ${REQUEST_DATA}

#     Gửi Yêu Cầu Tạo Sản Phẩm
#     ${response}=    Call API With Form Data    ${API_MAN_URL}    ${PRODUCT_API_ENDPOINT}    ${REQUEST_DATA}    ${REQUEST_FILES}
#     Set Test Variable    ${RESPONSE}    ${response}
#     IF    '${RESPONSE.status_code}' == '200'
#         ${product_id}=    Set Variable     ${RESPONSE.json()["Data"][0]["Id"]}
#         ${product_code}=    Set Variable    ${RESPONSE.json()["Data"][0]["Code"]}
#         Set Test Variable    ${CREATED_PRODUCT_ID}    ${product_id}
#         Set Test Variable    ${CREATED_PRODUCT_CODE}    ${product_code}
#     END
#     RETURN    ${response}

# Xác Thực Sản Phẩm Đã Được Tạo Trong Database
#     ${query}=    Set Variable    SELECT Id, Code, Name FROM Product WHERE Id = ?
#     ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
#     Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
#     Set Test Variable    ${DB_PRODUCT_ID}    ${result[0]}
#     Set Test Variable    ${DB_PRODUCT_CODE}    ${result[1]}
#     Set Test Variable    ${DB_PRODUCT_NAME}    ${result[2]}

# Xóa Sản Phẩm 
#     [Arguments]    ${product_code}
#     ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
#     ${endpoint}=    Format String    ${PRODUCT_DELETE_API_ENDPOINT}    ${product_id}
#     Delete Data   ${endpoint}