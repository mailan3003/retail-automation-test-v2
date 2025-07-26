*** Settings ***
Resource    ../Env_live.robot
Resource    ../Testdata/Product_data.robot
Resource    ../../Keywords/Utilities/DataUtilities.robot
Library    ../../Resources/DatabaseLibrary.py
Library    RequestsLibrary
Library    OperatingSystem
Library    String

*** Variables ***

${ENPOINT_GETLIST_PRODUCT}    branchs/{0}/masterproducts?format=json&Includes=ProductAttributes&ForSummaryRow=true

*** Keywords ***
Chuẩn bị dữ liệu sản phẩm cơ bản
    ${request}=    Deep Copy    ${list_product_data}

    ${list_products}=    Evaluate    json.dumps([${request}])    json
    ${list_branch_cost}=    Evaluate    json.dumps(${branch_for_cost})    json

    ${body}=    Create Dictionary
    ...    ListProductsString=${list_products}
    ...    BranchForProductCostss=${list_branch_cost}

    Set Test Variable    ${REQUEST_DATA}    ${body}   
    RETURN    ${REQUEST_DATA}

Gửi yêu cầu tạo sản phẩm
    ${headers}=    Create Dictionary    
    # ...    X-GROUP-ID=23
    # ...    sec-ch-ua-platform=Windows
    ...    Authorization=${AUTH}
    ...    sec-ch-ua=Not)A;Brand";v="8", "Chromium";v="138", "Google Chrome";v="138"
    ...    X-TIMEZONE=
    ...    sec-ch-ua-mobile=?0
    ...    FingerPrintKey=9260aa1de596f0d80658143cbe38c670_Chrome_Desktop_Máy tính Windows
    ...    X-Language=vi-VN
    ...    Accept=application/json, text/plain, */*
    ...    X-RETAILER-CODE=${RETAILER}
    # ...    Referer=https://testz23.kiotviet.vn/
    ...    BranchId=30
    ...    User-Agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36
    ...    Retailer=testz23
    ...    IsUseKvClient=1
    Create Session    createproduct    ${URL}    headers=${headers}    
    ${response}=    POST On Session    createproduct    products/addmany    headers=${headers}     data=${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}

Lấy danh sách sản phẩm
    ${headers}=    Deep Copy    ${HEADERS}
    Update Dictionary Property    ${headers}    Authorization    ${AUTH}
    ${filter_body}=    Deep Copy    ${FILTER_BODY}
    Create Session    getlistproduct    ${URL}    headers=${headers}
    ${endpoint}=     Format String    ${ENPOINT_GETLIST_PRODUCT}    ${DEFAULT_BRANCH_ID}
    Log    Endpoint: ${endpoint}
    ${response}=    POST On Session    getlistproduct    ${endpoint}    json=${filter_body}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}

Xóa sản phẩm đầu tiên trong danh sách
    ${product_id}=    Set Variable    ${RESPONSE.json()["Data"][1]["ProductId"]}
    ${headers}=    Deep Copy    ${HEADERS}
    Update Dictionary Property    ${headers}    Authorization    ${AUTH}
    Create Session    deleteproduct    ${URL}    headers=${headers}
    ${response}=    DELETE On Session    deleteproduct    products/${product_id}    
    Should Be Equal As Numbers    ${response.status_code}    200

# Chuẩn bị dữ liệu sản phẩm với thuộc tính ${dict_attribute_name}
#     ${list_product}=    Create List
#     #Lấy thông tin tên thuộc tính từ danh sách thuộc tính đầu vào
#     ${attribute_name}=    Get Dictionary Keys    ${dict_attribute_name}
#     ${length}=    Get Length    ${attribute_name}
#     #Tạo danh sách giá trị các thuộc tính
#     ${all_attribute_value}=    Create List
#     FOR    ${attr_name}    IN    @{attribute_name}
#         ${attr_value}=    Get From Dictionary    ${dict_attribute_name}    ${attr_name}
#         Append To List    ${all_attribute_value}    ${attr_value}
#     END
#     #Tạo tất cả các tổ hợp thuộc tính
#     ${combinations}=    Create List    ${EMPTY}
#     FOR    ${attr_name}    IN    @{all_attribute_value}
#         Log    ${attr_name}
#         ${new_combination}    Create List
#         FOR    ${combination}    IN    @{combinations}
#             Log    ${combination}
#             FOR    ${value}    IN    @{attr_name}
#                 Log    ${value}
#                 ${new_combi}=    Set Variable    ${combination}|${value}
#                 Append To List    ${new_combination}     ${new_combi}
#             END
#         END
#         ${combinations}=    Set Variable    ${new_combination}
#     END
#     Log    combinations:${combinations}
#     #Tạo tất cả các sản phẩm từ tổ hợp thuộc tính
#     FOR    ${combination}    IN    @{combinations}
#         Log    ${combination}
#         ${request}=    Deep Copy    ${list_product_data}
        
#         ${combination_value}=    Split String    ${combination}    |
#         Remove Values From List    ${combination_value}    ${EMPTY}
#         ${product_name}=    Evaluate    ' - '.join([x for x in """${combination}""".split('|') if x])


#         # ${product_name}=    Set Variable    ${EMPTY}
#         # FOR    ${index}    IN RANGE    ${length}
#         #     ${value}=    Get From List    ${combination_value}    ${index}
#         #     ${product_name}=    Set Variable    ${product_name} - ${value}
#         # END
#         ${request}=    Update Nested Dictionary Property    ${request}    Name    Hàng tạo mới để xóa hihi
#         ${compare_name}=    Get From List    ${combination_value}    0

#         Log    CompareFullName:${compare_name}
#         ${request}=    Update Nested Dictionary Property     ${request}    CompareFullName   ${compare_name}
#         Log    FullName:${product_name}
#         ${request}=    Update Nested Dictionary Property    ${request}    FullName    ${product_name}

#         # Tạo danh sách thuộc tính cho sản phẩm
#         ${product_attributes}=    Create List
#         FOR    ${index}    IN RANGE    ${length}
#             Log    ${index}
#             ${attribute}=    Deep Copy    ${standard_product_attributes}
#             ${value}=    Get From List    ${combination_value}    ${index}
#             ${att_name}=    Get From list    ${attribute_name}    ${index}
#             ${att_id}=    Get From Dictionary    ${ATTRIBUTE_ID}    ${att_name}
#             ${attribute}=    Update Nested Dictionary Property    ${attribute}    AttributeId    ${att_id}
#             ${attribute}=    Update Nested Dictionary Property    ${attribute}    Value    ${value}
#             Append To List    ${product_attributes}    ${attribute}
#             Log    product attribute:${product_attributes}
#         END
#         ${request}=    Update Nested Dictionary Property    ${request}    ProductAttributes    ${product_attributes}
#         Append To List    ${list_product}    ${request}
#     END

#     ${list_products}=    Evaluate    json.dumps(${list_product})    json
#     ${list_branch_cost}=    Evaluate    json.dumps(${branch_for_cost})    json

#     ${body}=    Create Dictionary
#     ...    ListProductsString=${list_products}
#     ...    BranchForProductCostss=${list_branch_cost}

#     Set Test Variable    ${REQUEST_DATA}    ${body}   
#     RETURN    ${REQUEST_DATA}

Chuẩn bị dữ liệu sản phẩm với thuộc tính ${dict_attribute_name}
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
    # FOR    ${combination}    IN    @{combinations}
    #     ${request}=    Deep Copy    ${list_product_data}
    #     # ${category_id}=    Lấy Thông tin Nhóm Hàng   ${CATEGORY_NAME}
    #     ${request}    Update Dictionary Property    ${request}    CategoryId    ${DEFAULT_CATEGORY_ID} 
    #     ${random_code}=    Generate Random String    8    [NUMBERS]
    #     ${code}=    Set Variable    HHTT${random_code}
    #     Append To List    ${list_products_code}    ${code}
    #     ${request}=    Update Nested Dictionary Property    ${request}    Code    ${code}      
    #     # Tạo tên sản phẩm từ tổ hợp thuộc tính
    #     ${combination_values}=    Split String    ${combination}    |
    #     ${product_name}=    Set Variable    ${EMPTY}
    #     FOR    ${index}    IN RANGE    ${length}
    #         ${value}=    Get From List    ${combination_values}    ${index}
    #         ${product_name}=    Set Variable    ${product_name} - ${value}
    #     END
    #     ${product_name}=    Set Variable    ${product_name}
    #     ${request}=    Update Nested Dictionary Property     ${request}    Name    Sản phẩm
    #     ${request}=    Update Nested Dictionary Property     ${request}    FullName  ${product_name}
    #     ${request}=    Update Nested Dictionary Property     ${request}    CompareFullName   ${value}
    #     # Tạo danh sách thuộc tính cho sản phẩm
    #     ${product_attributes}=    Create List
    #     FOR    ${index}    IN RANGE    ${length}
    #         ${attribute}=    Deep Copy    ${standard_product_attributes}
    #         ${value}=    Get From List    ${combination_values}    ${index}
    #         # ${attribute_id}=    Lấy ID thuộc tính    ${attr_name}
    #         # ${attribute}=     Update Nested Dictionary Property    ${attribute}    AttributeId    ${attribute_id}
    #         ${att_name}=    Get From list    ${attribute_names}    ${index}
    #         ${att_id}=    Get From Dictionary    ${ATTRIBUTE_ID}    ${att_name}
    #         ${attribute}=    Update Nested Dictionary Property    ${attribute}    AttributeId    ${att_id}
    #         ${attribute}=    Update Nested Dictionary Property      ${attribute}    Value    ${value}
    #         Append To List    ${product_attributes}    ${attribute}
    #     END
    #     ${request}=    Update Nested Dictionary Property     ${request}    ProductAttributes    ${product_attributes}
    #     Append To List    ${list_products}    ${request}
    # END
    
    # Tạo sản phẩm cho mỗi tổ hợp thuộc tính (tức là mỗi SKU)
    FOR    ${combination}    IN    @{combinations}
        # Deep Copy template sản phẩm để tránh thay đổi bản gốc
        # ${list_product_data} được giả định là một list chứa dictionary template, ví dụ: [{"Id": "0", ...}]
        ${request}=    Deep Copy    ${list_product_data}
        
        # Cập nhật CategoryId
        ${request}    Update Dictionary Property    ${request}    CategoryId    ${DEFAULT_CATEGORY_ID}
        
        # Tạo mã sản phẩm ngẫu nhiên (ví dụ: HHTT12345678) và thêm vào danh sách mã sản phẩm
        ${random_code}=    Generate Random String    8    [NUMBERS]
        ${code}=    Set Variable    HHTT${random_code}
        Append To List    ${list_products_code}    ${code}
        ${request}=    Update Nested Dictionary Property    ${request}    Code    ${code}
        
        # Xử lý tên sản phẩm và tên đầy đủ theo yêu cầu
        ${combination_values}=    Split String    ${combination}    |     # Ví dụ: ['Blue', 'S', '']

        # === ĐIỀU CHỈNH CHÍNH TẠI ĐÂY ĐỂ ĐẠT YÊU CẦU TÊN SẢN PHẨM ===
        # 1. Đặt Name là tên sản phẩm cơ bản ("Sản phẩm"), không có thuộc tính
        # Đây sẽ là tên hiển thị nhóm/tên cha trong KiotViet
        ${request}=    Update Nested Dictionary Property    ${request}    Name    Sản phẩm
        
        # 2. Tạo FullName có chứa thuộc tính (tên đầy đủ của SKU)
        ${full_name_for_sku}=    Set Variable    Sản phẩm
        FOR    ${value}    IN    @{combination_values}
            # Chỉ thêm vào nếu value không rỗng (do Split String có thể tạo ra phần tử rỗng cuối cùng)
            IF    '${value}' != ''
                ${full_name_for_sku}=    Set Variable    ${full_name_for_sku}-${value}
            END
        END
        ${request}=    Update Nested Dictionary Property    ${request}    FullName    ${full_name_for_sku} # Ví dụ: "Sản phẩm-Blue-S"
        
        # 3. Tạo CompareFullName cho việc tìm kiếm hoặc so sánh
        # Logic này nên khớp với cách KiotViet dùng CompareFullName.
        # Ví dụ: "Sản phẩm-Blue-S"
        ${compare_full_name_parts}=    Create List    Sản phẩm
        FOR    ${value}    IN    @{combination_values}
            IF    '${value}' != ''
                Append To List    ${compare_full_name_parts}    ${value}
            END
        END
        ${compare_full_name_for_sku}=    Set Variable    Sản phẩm
        FOR    ${value}    IN    @{combination_values}
            IF    '${value}' != ''
                ${compare_full_name_for_sku}=    Set Variable    ${compare_full_name_for_sku}-${value}
            END
        END
        ${request}=    Update Nested Dictionary Property    ${request}    CompareFullName    ${compare_full_name_for_sku}

        # Tạo danh sách thuộc tính cho sản phẩm (cho SKU)
        ${product_attributes}=    Create List
        FOR    ${index}    IN RANGE    ${length}
            ${attribute}=    Deep Copy    ${standard_product_attributes}     # Template thuộc tính cơ bản
            ${value}=    Get From List    ${combination_values}    ${index}
            ${att_name}=    Get From list    ${attribute_names}    ${index}     # Tên thuộc tính (ví dụ: 'color', 'size')
            ${att_id}=    Get From Dictionary    ${ATTRIBUTE_ID}    ${att_name}     # ID thuộc tính từ map (ví dụ: '1200094')
            
            ${attribute}=    Update Nested Dictionary Property    ${attribute}    AttributeId    ${att_id}
            ${attribute}=    Update Nested Dictionary Property    ${attribute}    Value    ${value}
            Append To List    ${product_attributes}    ${attribute}
        END
        ${request}=    Update Nested Dictionary Property    ${request}    ProductAttributes    ${product_attributes}
        
        # Thêm sản phẩm SKU đã tạo vào danh sách chính
        Append To List    ${list_products}    ${request}
    END 

    ${branch_pr_cost}=    Evaluate    json.dumps(${branch_for_cost})    json
    ${form_data}=    Evaluate     str(${list_products} ).replace("'",'"')
    ${list_products_attribute}     Evaluate    (None, '${form_data}')
    ${payload}    Create Dictionary    ListProductsString=${list_products_attribute}          BranchForProductCostss=${branch_pr_cost}  
    Log     ${payload}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${LIST_PRODUCTS_CODE}    ${list_products_code}
    Log    ${REQUEST_DATA}
    RETURN    ${REQUEST_DATA}





# Chuẩn bị dữ liệu sản phẩm cơ bản
#     ${request}=    Deep Copy     ${list_product_data}
#     ${random_code}=    Generate Random String    8    [NUMBERS]
#     ${request}=    Update Dictionary Property    ${request}    Code    HHA${random_code}

#     ${list_products}=    Evaluate    json.dumps([${request}])    json
#     ${branch_json_list}=    Evaluate    json.dumps(${branch_for_cost})    json

#     ${payload}=    Create Dictionary
#     ...    ListProductsString=${list_products}
#     ...    BranchForProductCostss=${branch_json_list}

#     Log    === Payload Gửi ===\n${payload}
#     Set Test Variable    ${REQUEST_DATA}    ${payload}
#     RETURN    ${REQUEST_DATA}

# Chuẩn bị dữ liệu sản phẩm cơ bản
#     ${request}=    Deep Copy     ${list_product_data}
#     # ${category_id}=    Lấy Thông tin Nhóm Hàng   ${CATEGORY_NAME}
#     # ${request}    Update Dictionary Property    ${request}    CategoryId    ${category_id}
#     ${random_code}=    Generate Random String    8    [NUMBERS]
#     ${request}    Update Dictionary Property    ${request}    Code    HHA${random_code}

#     # ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
#     # ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')

#     # ${form_data}=    Evaluate     str(${request}).replace("'",'"')
#     # ${list_products}     Evaluate    (None, '[${form_data}]')

#     # ${payload}    Create Dictionary    ListProductsString=${list_products}        BranchForProductCostss=${branch_pr_cost}  
#     Set Test Variable    ${REQUEST_DATA}    ${payload}
#     RETURN    ${REQUEST_DATA}
