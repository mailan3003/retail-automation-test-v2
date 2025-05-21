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
${CATEGORY_ID_HANG_HOA}    1000000754
*** Keywords ***
Chuẩn Bị Dữ Liệu Sản Phẩm Với Kho Chính Có ${onhand} Và Kho Phụ ${list_kho_hang} Với Tồn Kho ${list_ton_kho}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    8    WH[NUMBERS]
    ${list_body_onhand}    Create List    
    ${total_onhand}    Set Variable   ${onhand}
    FOR    ${kho_hang}    ${ton_kho}  IN ZIP    ${list_kho_hang}    ${list_ton_kho}
        ${id_kho_hang}=    Lấy Thông tin Chi Nhánh    ${kho_hang}
        ${body_onhand}      Deep Copy    ${PRODUCT_WITH_WAREHOUSE_STOCK_TAKES} 
        ${body_onhand}=   Update Dictionary Property    ${body_onhand}    BranchId    ${id_kho_hang}
        ${body_onhand}=   Update Dictionary Property    ${body_onhand}    OnHand    ${ton_kho}
        Append To List    ${list_body_onhand}    ${body_onhand}
        ${total_onhand}=    Evaluate    ${total_onhand} + ${ton_kho}
    END
    ${request}    Update Dictionary Property    ${request}    Code    ${random_code}
    ${request}    Update Dictionary Property    ${request}    CategoryId    ${CATEGORY_ID_HANG_HOA}
    ${request}    Update Dictionary Property    ${request}    Onhand     ${onhand} 
    ${request}    Update Dictionary Property    ${request}    ProductWithWarehouseStockTakes   ${list_body_onhand}  
    ${request}    Update Dictionary Property    ${request}    TotalWarehouseOnHand      ${total_onhand}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${TOTAL_ONHAND}    ${total_onhand}
    RETURN    ${REQUEST_DATA}


Chuẩn Bị Dữ Liệu Sản Phẩm Đơn Vị Tính ${name_unit} Có ${value} Kho Chính Tồn ${onhand} Kho Phụ ${list_kho_hang} Tồn ${list_ton_kho}
    ${list_body_onhand}    Create List    
    ${list_unit_body}    Create List
    ${list_product_unit_body}    Create List
    ${total_onhand}    Set Variable   ${onhand}
    FOR    ${kho_hang}    ${ton_kho}  IN ZIP    ${list_kho_hang}    ${list_ton_kho}
        ${id_kho_hang}=    Lấy Thông tin Chi Nhánh    ${kho_hang}
        ${body_onhand}      Deep Copy    ${PRODUCT_WITH_WAREHOUSE_STOCK_TAKES} 
        ${body_onhand}=   Update Dictionary Property    ${body_onhand}    BranchId    ${id_kho_hang}
        ${body_onhand}=   Update Dictionary Property    ${body_onhand}    OnHand    ${ton_kho}
        Append To List    ${list_body_onhand}    ${body_onhand}
        ${total_onhand}=    Evaluate    ${total_onhand} + ${ton_kho}
    END    


    ${list_product_code}     Create List
    FOR    ${item_name}   ${item_value}  IN ZIP    ${name_unit}  ${value}
       ${unit_body}    Deep Copy    ${PRODUCT_UNITS}
        ${unit_body}    Update Dictionary Property    ${unit_body}    Unit    ${item_name}
        ${unit_body}    Update Dictionary Property    ${unit_body}    ConversionValue    ${item_value}
        Append To List    ${list_unit_body}    ${unit_body}
        ${request}=    Deep Copy    ${list_product_data}
        ${random_code}=    Generate Random String    8    [NUMBERS]
        ${request}    Update Dictionary Property    ${request}    Code    ${random_code}
        ${request}    Update Dictionary Property    ${request}    Unit    ${item_name}
        ${request}    Update Dictionary Property    ${request}    ConversionValue    ${item_value}
        ${request}    Update Dictionary Property    ${request}    Code    ${random_code}
        ${request}    Update Dictionary Property    ${request}    CategoryId    ${CATEGORY_ID_HANG_HOA}
        ${request}    Update Dictionary Property    ${request}    Onhand     ${onhand} 
        ${request}    Update Dictionary Property    ${request}    ProductWithWarehouseStockTakes   ${list_body_onhand}  
        ${request}    Update Dictionary Property    ${request}    TotalWarehouseOnHand      ${total_onhand}    
        ${request}    Update Dictionary Property    ${request}    ProductUnits    ${list_unit_body}
        Append To List   ${list_product_unit_body}     ${request}
        Append To List   ${list_product_code}    ${random_code}
    END

    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${list_product_unit_body}).replace("'",'"')
    ${list_products}     Evaluate    (None, '${form_data}')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${TOTAL_ONHAND}    ${total_onhand}
    Set Test Variable    ${LIST_PRODUCTS_CODE}    ${list_product_code}
    Log     ${payload}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Thuộc Tính ${dict_attribute_name} Kho Chính Tồn ${onhand} Kho Phụ ${list_kho_hang} Tồn ${list_ton_kho}
    ${list_body_onhand}    Create List    
        ${list_products}=    Create List
        ${total_onhand}    Set Variable   ${onhand}
        FOR    ${kho_hang}    ${ton_kho}  IN ZIP    ${list_kho_hang}    ${list_ton_kho}
            ${id_kho_hang}=    Lấy Thông tin Chi Nhánh    ${kho_hang}
            ${body_onhand}      Deep Copy    ${PRODUCT_WITH_WAREHOUSE_STOCK_TAKES} 
            ${body_onhand}=   Update Dictionary Property    ${body_onhand}    BranchId    ${id_kho_hang}
            ${body_onhand}=   Update Dictionary Property    ${body_onhand}    OnHand    ${ton_kho}
            Append To List    ${list_body_onhand}    ${body_onhand}
            ${total_onhand}=    Evaluate    ${total_onhand} + ${ton_kho}
        END
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
            ${request}=    Update Nested Dictionary Property     ${request}    FullName  ${product_name}
            ${request}=    Update Nested Dictionary Property     ${request}    CompareFullName   ${product_name}

            
            # Tạo danh sách thuộc tính cho sản phẩm
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
        ${request}    Update Dictionary Property    ${request}    CategoryId    ${CATEGORY_ID_HANG_HOA}
        ${request}    Update Dictionary Property    ${request}    Onhand     ${onhand} 
        ${request}    Update Dictionary Property    ${request}    ProductWithWarehouseStockTakes   ${list_body_onhand}  
        ${request}    Update Dictionary Property    ${request}    TotalWarehouseOnHand      ${total_onhand}    
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
        Set Test Variable    ${TOTAL_ONHAND}    ${total_onhand}
        RETURN    ${REQUEST_DATA}


Chuẩn Bị Dữ Liệu Sản Phẩm Thuộc Tính ${dict_attribute_name} Đơn Vị ${list_unit} Có ${list_unit_value} Và Kho Chính Tồn ${onhand} Kho Phụ ${list_kho_hang} Tồn ${list_ton_kho}
    ${list_body_onhand}    Create List    
    ${list_products}=    Create List
    ${total_onhand}    Set Variable   ${onhand}


    FOR    ${kho_hang}    ${ton_kho}  IN ZIP    ${list_kho_hang}    ${list_ton_kho}
        ${id_kho_hang}=    Lấy Thông tin Chi Nhánh    ${kho_hang}
        ${body_onhand}      Deep Copy    ${PRODUCT_WITH_WAREHOUSE_STOCK_TAKES} 
        ${body_onhand}=   Update Dictionary Property    ${body_onhand}    BranchId    ${id_kho_hang}
        ${body_onhand}=   Update Dictionary Property    ${body_onhand}    OnHand    ${ton_kho}
        Append To List    ${list_body_onhand}    ${body_onhand}
        ${total_onhand}=    Evaluate    ${total_onhand} + ${ton_kho}
    END

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
    ${list_unit_body}    Create List
    FOR    ${item_name}   ${item_value}  IN ZIP   ${list_unit}    ${list_unit_value}

            ${unit_body}    Deep Copy    ${PRODUCT_UNITS}
            ${unit_body}    Update Dictionary Property    ${unit_body}    Unit    ${item_name}
            ${unit_body}    Update Dictionary Property    ${unit_body}    ConversionValue    ${item_value}
            Append To List    ${list_unit_body}    ${unit_body}
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
            ${product_name}=    Set Variable    ${product_name}(${item_name})
            ${request}=    Update Nested Dictionary Property     ${request}    Name    Sản phẩm
            ${request}=    Update Nested Dictionary Property     ${request}    FullName  ${product_name}
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

            ${request}    Update Dictionary Property    ${request}    CategoryId    ${CATEGORY_ID_HANG_HOA}
            ${request}    Update Dictionary Property    ${request}    Onhand     ${onhand} 
            ${request}    Update Dictionary Property    ${request}    Unit    ${item_name}
            ${request}    Update Dictionary Property    ${request}    ConversionValue    ${item_value}
            ${request}    Update Dictionary Property    ${request}    ProductWithWarehouseStockTakes   ${list_body_onhand}  
            ${request}    Update Dictionary Property    ${request}    TotalWarehouseOnHand      ${total_onhand}    
            ${request}=    Update Nested Dictionary Property     ${request}    ProductAttributes    ${product_attributes}
            ${request}=    Update Nested Dictionary Property     ${request}    ProductUnits       ${list_unit_body} 
            Append To List    ${list_products}    ${request}
        END
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


Chuẩn Bị Dữ Liệu Sản Phẩm Thuộc Tính ${dict_attribute_name} Có Tồn Kho ${list_ton_kho} Tương Ứng với Các Kho ${list_kho_hang}
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
            ${request}=    Update Nested Dictionary Property     ${request}    FullName  ${product_name}
            ${request}=    Update Nested Dictionary Property     ${request}    CompareFullName   ${product_name}

            
            # Tạo danh sách thuộc tính cho sản phẩm
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
        
            ${list_body_onhand}    Create List    
            ${total_onhand}    Set Variable    0
            FOR    ${index}    ${ton_kho}    IN ENUMERATE    ${list_ton_kho}
                ${ton_kho_list}=    Get From List    ${list_ton_kho}    ${index}
                ${ton_kho_values}=    Split String    ${ton_kho_list}    ,
                FOR    ${ton_kho}     ${kho_hang}   IN ZIP  ${ton_kho_values}    ${list_kho_hang}
                    ${id_kho_hang}    Run Keyword If    "${kho_hang}" == "Kho bán hàng"    Set Variable    ${DEFAULT_BRANCH_ID}    ELSE    Lấy Thông tin Chi Nhánh    ${kho_hang}
                    ${body_onhand}=    Deep Copy    ${PRODUCT_WITH_WAREHOUSE_STOCK_TAKES}
                    ${body_onhand}=    Update Dictionary Property    ${body_onhand}    BranchId    ${id_kho_hang}
                    ${body_onhand}=    Update Dictionary Property    ${body_onhand}    OnHand    ${ton_kho}
                    Append To List    ${list_body_onhand}    ${body_onhand}
                    ${total_onhand}=    Evaluate    ${total_onhand} + ${ton_kho}

                END
                ${request}    Update Dictionary Property    ${request}    Onhand     ${ton_kho_values[0]} 

            END
            ${request}    Update Dictionary Property    ${request}    CategoryId    ${CATEGORY_ID_HANG_HOA}
            ${request}    Update Dictionary Property    ${request}    ProductWithWarehouseStockTakes   ${list_body_onhand}  
            ${request}    Update Dictionary Property    ${request}    TotalWarehouseOnHand      ${total_onhand} 
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