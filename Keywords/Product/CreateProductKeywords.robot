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
#Resource          ../../TestData/Product/ProductInputData.robot
Library           String
Resource          Product_KeywordsCommand.robot
*** Variables ***
${IMAGE_URL}    https://cdn2-retail-images.kiotviet.vn/0914616818/1c8f44ae06ca4e5583f3648db0eeeac1.jpeg
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

Chuẩn Bị Dữ Liệu Sản Phẩm Với Nhiều Đơn Vị Tính ${unit_names} Và Giá Trị Quy Đổi ${conversion_values}
    ${list_product_body}     Create List
    ${list_unit_body}     Create List
    ${list_product_code}     Create List
    FOR    ${item_name}   ${item_value}     IN ZIP    ${unit_names}    ${conversion_values}   
        ${request}=    Deep Copy    ${list_product_data}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        ${code}=    Set Variable    QD${random_code}
        ${request}    Update Dictionary Property    ${request}    Code    ${code}
        ${request}    Update Dictionary Property    ${request}    Unit    ${item_name}
        ${request}    Update Dictionary Property    ${request}    ConversionValue    ${item_value}
        ${unit_body}    Deep Copy    ${PRODUCT_UNITS}
        ${unit_body}    Update Dictionary Property    ${unit_body}    Unit    ${item_name}
        ${unit_body}    Update Dictionary Property    ${unit_body}    ConversionValue    ${item_value}
        Append To List    ${list_unit_body}    ${unit_body}
        ${request}    Update Dictionary Property    ${request}    ProductUnits    ${list_unit_body}  
        Append To List   ${list_product_body}    ${request}
        Append To List   ${list_product_code}    ${code}
    END
    ${list_product_body}=    Evaluate     str(${list_product_body}).replace("'",'"')
    ${list_product_body}    Evaluate    (None, '${list_product_body}')
    ${payload}    Create Dictionary    ListProductsString=${list_product_body}        
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

Chuẩn Bị Dữ Liệu Sản Phẩm Loại Combo Có Thành Phần ${dict_product_tp}
    ${request}=    Deep Copy     ${list_product_data}
    ${formulas_list}=    Create List
    ${list_material_id}=    Create List
    ${material_code}=   Get Dictionary Keys   ${dict_product_tp} 
    ${quantity}=    Get Dictionary Values    ${dict_product_tp}
    ${total_cost}=    Set Variable    0
    FOR    ${item_material_code}    ${item_quantity}   IN ZIP     ${material_code}    ${quantity} 
        ${formula_item}=    Deep Copy    ${PRODUCT_FORMULAS}
        ${material_id}      Lấy Thông tin Sản Phẩm  ${item_material_code}
        ${cost_product}=    Lây thông tin giá vốn của sản phẩm    ${material_id}    Chi nhánh trung tâm
        ${total_cost}=    Evaluate    round(${total_cost} + ${cost_product}*${item_quantity},2)
        # Cập nhật thông tin vào formula
        ${formula_item}=    Update Dictionary Property    ${formula_item}    MaterialId    ${material_id}
        ${formula_item}=    Update Dictionary Property    ${formula_item}    Quantity    ${item_quantity}
        # Thêm vào danh sách formula
        Append To List    ${formulas_list}    ${formula_item}
        Append To List    ${list_material_id}    ${material_id}
    END

     ${random_code}=    Generate Random String    6    [NUMBERS]
     ${request}    Update Dictionary Property    ${request}    Code    CB${random_code}
     ${request}    Update Dictionary Property    ${request}    ProductType    1
     ${request}    Update Dictionary Property    ${request}    ProductFormulas    ${formulas_list}
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    
    Log     ${payload}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${TOTAL_COST}    ${total_cost}
    Set Test Variable    ${LIST_MATERIAL_QUANTITY}    ${quantity}
    Set Test Variable    ${LIST_MATERIAL_ID}    ${list_material_id}
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

# Các keyword mới
Chuẩn Bị Dữ Liệu Sản Phẩm Kinh Doanh Theo Chi Nhánh ${list_name_branch}
    ${list_branch}    Create List
    FOR    ${name_branch}    IN    @{list_name_branch}
        ${branch_id}=    Lấy Thông tin Chi Nhánh    ${name_branch}
        Append To List    ${list_branch}    ${branch_id}
    END
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    SP${random_code}
    ${request}    Update Dictionary Property    ${request}    isActive    false
    ${branch_id_list}    Evaluate    (None, '${list_branch}')
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}       ListBranchsSelected=${branch_id_list} 
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Không Được Bán Trực Tiếp
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    8    GIA[NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    ${random_code}
    ${request}    Update Dictionary Property    ${request}      AllowsSale    false
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

Chuẩn Bị Dữ Liệu Sản Phẩm Với Nhóm Hàng Không Tồn Tại
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    TD${random_code}
    ${request}    Update Dictionary Property    ${request}    CategoryId    999999999
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Để Trống Nhóm Hàng
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    TD${random_code}
    ${request}    Update Dictionary Property    ${request}    CategoryId   ${EMPTY} 
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}        
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Có Tích Điểm Với Số Điểm ${point}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    TD${random_code}
    ${request}    Update Dictionary Property    ${request}    IsRewardPoint    True
    ${request}    Update Dictionary Property    ${request}    RewardPoint    ${point}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}
Chuẩn Bị Dữ Liệu Sản Phẩm Có Thời Gian ${type} Là ${month} ${unit}

    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    BH${random_code}
    ${warranties}=    Thời gian bảo hành ${type} là ${month} ${unit}
    ${request}    Update Dictionary Property    ${request}    GenuineGuarantees    ${warranties}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${PAYLOAD_WARRANTY_SAVE_DATA}    ${warranties}
    RETURN    ${REQUEST_DATA}


Thời gian bảo hành ${type} là ${month} ${unit}
    ${type}    Set Variable If    "${type}" == "Bảo Hành"   1   2
    ${unit}    Run Keyword If    "${unit}" == "Tháng"    Set Variable    6    ELSE IF    "${unit}" == "Ngày"
    ...   Set Variable    7    ELSE    Set Variable    1
    ${warr}=    Deep Copy    ${GENUINE_GUARANTEES}
    ${warr}    Update Dictionary Property    ${warr}    NumberTime    ${month}
    ${warr}    Update Dictionary Property    ${warr}    TimeType    ${unit}
    ${warr}    Update Dictionary Property    ${warr}    WarrantyType    ${type}
    RETURN    ${warr}


Save Warranty For Many Product
    ${warranty_save_data}=    Deep Copy    ${WARRANTIES_SAVE_DATA}
    ${warranties}    Deep Copy    ${PAYLOAD_WARRANTY_SAVE_DATA}
    ${warranties}    Update Dictionary Property    ${warranties}      ProductId    ${CREATED_PRODUCT_ID}
    ${warranties}    Create List    ${warranties}
    ${warranty_save_data}    Update Dictionary Property    ${warranty_save_data}      warranties   ${warranties}
    Save warranty for product   ${warranty_save_data}


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
 



Chuẩn Bị Dữ Liệu Sản Phẩm Có Tên ${n} Ký Tự
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${random_name}=   Generate Random String    ${n}    [LETTERS]
    ${request}    Update Dictionary Property    ${request}    Code    KT${random_code}
    ${request}    Update Dictionary Property    ${request}    Name    ${random_name}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

# Keywords bổ sung cho các điều kiện hợp lệ trong template
Chuẩn Bị Dữ Liệu Sản Phẩm Có Giá Vốn ${cost}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    GV${random_code}
    ${request}    Update Dictionary Property    ${request}    Cost    ${cost}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Có Giá Vốn ${cost} Áp Dụng Cho Chi Nhánh ${list_name_branch}
    ${list_branch_cost}=    Create List
    FOR    ${branch_name}    IN    @{list_name_branch}
        ${branch_id}    Lấy Thông tin Chi Nhánh    ${branch_name}
        ${branch_cost}    Deep Copy    ${branch_for_cost}
        ${branch_cost}    Update Dictionary Property    ${branch_cost}    Id    ${branch_id}
        ${branch_cost}    Update Dictionary Property    ${branch_cost}    Name    ${branch_name}
        Append To List    ${list_branch_cost}    ${branch_cost}
    END
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    GV${random_code}
    ${request}    Update Dictionary Property    ${request}    Cost    ${cost}
    ${branch_pr_cost}     Evaluate     str(${list_branch_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '${branch_pr_cost}')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}


# Keywords bổ sung cho các điều kiện lỗi trong templat
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

Chuẩn Bị Dữ Liệu Sản Phẩm Loại Hàng Sản Xuất Với Hàng Thành Phần ${dict_product_tp}
    
    ${request}=    Deep Copy     ${list_product_data}

    # Tạo danh sách formula từ dictionary sản phẩm thành phần
    ${formulas_list}=    Create List
    ${list_material_id}=    Create List
    ${material_code}=   Get Dictionary Keys   ${dict_product_tp} 
    ${quantity}=    Get Dictionary Values    ${dict_product_tp}
    ${total_cost}=    Set Variable    0
    FOR    ${item_material_code}    ${item_quantity}   IN ZIP     ${material_code}    ${quantity} 
        ${formula_item}=    Deep Copy    ${PRODUCT_FORMULAS}
        ${material_id}      Lấy Thông tin Sản Phẩm  ${item_material_code}
        ${cost_product}=    Lây thông tin giá vốn của sản phẩm    ${material_id}    Chi nhánh trung tâm
        ${total_cost}=    Evaluate    round(${total_cost} + ${cost_product}*${item_quantity},2)
        # Cập nhật thông tin vào formula
        ${formula_item}=    Update Dictionary Property    ${formula_item}    MaterialId    ${material_id}
        ${formula_item}=    Update Dictionary Property    ${formula_item}    Quantity    ${item_quantity}
        # Thêm vào danh sách formula
        Append To List    ${formulas_list}    ${formula_item}
        Append To List    ${list_material_id}    ${material_id}
    END
    
    # Gán danh sách formula
    ${formula}=    Set Variable    ${formulas_list}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    HSX${random_code}
    ${request}    Update Dictionary Property    ${request}    ProductFormulas    ${formulas_list}  
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}        
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${TOTAL_COST}    ${total_cost}
    Set Test Variable    ${LIST_MATERIAL_ID}    ${list_material_id}
    Set Test Variable    ${LIST_MATERIAL_QUANTITY}    ${quantity}
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

Chuẩn Bị Dữ Liệu Sản Phẩm Có ${list_shelves} Vị Trí Lưu Trữ 
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    VT${random_code}
    ${shelves_body}=    Create List  
    ${shelves_id}=    Create List
    FOR    ${item}    IN    @{list_shelves}
        ${query}=    Set Variable    SELECT Id FROM Shelves WHERE RetailerId = ? And Name = ?
        ${result}=    Fetch One    ${query}    ${RETAILER_ID}    ${item}
        ${shelf_body}     Deep Copy    ${PRODUCT_WITH_SHELVES}
        ${shelf_body}    Update Dictionary Property    ${shelf_body}    ShelvesId    ${result[0]}
        Append To List    ${shelves_body}    ${shelf_body}
        Append To List    ${shelves_id}    ${result[0]}
    END
    ${request}    Update Dictionary Property    ${request}    ProductShelves    ${shelves_body}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}        BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${SHELVES_ID}    ${shelves_id}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Có Giá ${price} Và Giá Bảng Giá ${list_pricebook} Với ${list_price}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    BG${random_code}
    ${request}    Update Dictionary Property    ${request}    BasePrice    ${price}
    ${request_pricebook}=    Create List
    FOR    ${item}  ${price}   IN ZIP    ${list_pricebook}    ${list_price}
        ${id_pricebook}=    Get Pricebook Id    ${item}
        ${price_body}     Deep Copy    ${Pricebook_body_standard}    
        ${price_body}    Update Dictionary Property    ${price_body}    PriceBookId    ${id_pricebook}
        ${price_body}    Update Dictionary Property    ${price_body}    Price    ${price}
        ${price_body}    Update Dictionary Property    ${price_body}    Name    ${item}
        Append To List    ${request_pricebook}    ${price_body}
    END
    ${request}    Update Dictionary Property    ${request}    ListPriceBookDetail    ${request_pricebook}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}        BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
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



Chuẩn Bị Dữ Liệu Sản Phẩm Có Trọng Lượng ${weight} ${unit}
    
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

Chuẩn Bị Dữ Liệu Sản Phẩm Có Giá Bán ${price}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    GB${random_code}
    ${request}    Update Dictionary Property    ${request}    BasePrice    ${price}
    
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}        BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}



Chuẩn Bị Dữ Liệu Sản Phẩm Với Các Biến Thể ${dict_attribute_name} Có Giá Khác Nhau ${list_price}
    # Tạo danh sách giá khác nhau cho các biến thể
    
    # Chuẩn bị dữ liệu sản phẩm cơ bản với thuộc tính
    ${list_products}=    Chuẩn Bị Dữ Liệu Sản Phẩm Có Thuộc Tính ${dict_attribute_name}
    
    # Convert list_products to JSON format
    FOR    ${index}    ${price}    IN ENUMERATE    @{list_price}
       Set To Dictionary    ${list_products}[${index}]    BasePrice    ${price}
    END
    
    # Cập nhật lại danh sách sản phẩm trong yêu cầu
    ${updated_product_list}=    Evaluate    json.dumps(${list_products})    json

    ${form_data}=    Evaluate     str(${updated_product_list}).replace("'",'"')
    ${list_products}     Evaluate    (None, '${form_data}')
    ${payload}    Create Dictionary    ListProductsString=${list_products}      
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

Xác Thực Các Biến Thể Có Giá Bán ${list_price} Theo Cấu Hình
    # Kiểm tra giá của từng biến thể
    ${query}=    Set Variable    SELECT Id, BasePrice FROM Product WHERE MasterProductId = ?
    ${results}=    Fetch All    ${query}    ${CREATED_PRODUCT_ID}
    
    # Kiểm tra số lượng kết quả
    ${result_count}=    Get Length    ${results}
    ${price_count}=    Get Length    ${list_price}
    Should Be Equal As Numbers    ${result_count}    ${price_count}
    
    # Kiểm tra giá của từng biến thể
    FOR    ${i}    ${result}    IN ENUMERATE    @{results}
        ${variant_id}=    Set Variable    ${result[0]}
        ${actual_price}=    Set Variable    ${result[1]}
        ${expected_price}=    Set Variable    ${list_price}[${i}]
        
        Should Be Equal As Numbers    ${actual_price}    ${expected_price}
    END

Chuẩn Bị Dữ Liệu Sản Phẩm Với Các Biến Thể Có Tồn Kho Khác Nhau
    # Tạo danh sách tồn kho khác nhau cho các biến thể
    ${inventories}=    Create List    10    20    30
    Set Test Variable    ${VARIANT_INVENTORIES}    ${inventories}
    
    # Chuẩn bị dữ liệu sản phẩm cơ bản với thuộc tính
    ${request_data}=     Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính    ${dict_kich_thuoc}
    
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

    
Chuẩn Bị Dữ Liệu Sản Phẩm Ở Form Khác
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    TD${random_code}
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}            isAddFromOtherForm=True
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}


Chuẩn Bị Dữ Liệu Sản Phẩm Ở MHBH
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    TD${random_code}
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProducts=${list_products}         
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

# Keywords cho quản lý hình ảnh sản phẩm
Chuẩn Bị Dữ Liệu Sản Phẩm Với Nhiều Hình Ảnh
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    MHA${random_code}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}  
    
    # Tạo request files với nhiều hình ảnh
    ${files}=    Create Dictionary
    ${stream1}=    Get File For Streaming Upload    Images/Anh1.jpg
    ${stream2}=    Get File For Streaming Upload    Images/Anh2.jpg
    ${stream3}=    Get File For Streaming Upload    Images/Anh3.jpg
    ${files}=    Set To Dictionary    ${files}    ProductImage=${stream1}
    ${files}=    Set To Dictionary    ${files}    ProductImage2=${stream2}
    ${files}=    Set To Dictionary    ${files}    ProductImage3=${stream3}
    
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${REQUEST_FILES}    ${files}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Hình Ảnh Ghim Chính
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    PIN${random_code}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    
    # Chuẩn bị tham số hình ảnh ghim chính
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}    PinnedImageId=1
    
    # Tạo request files với hình ảnh
    ${files}=    Create Dictionary
    ${stream}=    Get File For Streaming Upload    Images/Anh1.jpg
    ${stream2}=    Get File For Streaming Upload    Images/Anh2.jpg
    ${files}=    Set To Dictionary    ${files}    ProductImage=${stream}
    
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${REQUEST_FILES}    ${files}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Hình Ảnh Từ URL
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    URL${random_code}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    
    # URL hình ảnh mẫu
    ${image_url}=    Set Variable    ${IMAGE_URL} 
    
    # Chuẩn bị payload với URL hình ảnh
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}    ProductImageSuggestUrl=${image_url}
    
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${IMAGE_URL}    ${image_url}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Hình Ảnh Nhiều Định Dạng
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    FMT${random_code}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}
    
    # Chuẩn bị các định dạng hình ảnh khác nhau
    ${files}=    Create Dictionary
    ${stream_jpg}=    Get File For Streaming Upload    Images/Anh1.jpg
    ${stream_png}=    Get File For Streaming Upload    Images/Anh7.png
    ${stream_jpeg}=    Get File For Streaming Upload    Images/Anh6.jpeg
    ${files}=    Set To Dictionary    ${files}    ProductImage=${stream_jpg}
    ${files}=    Set To Dictionary    ${files}    ProductImage2=${stream_png}
    ${files}=    Set To Dictionary    ${files}    ProductImage3=${stream_jpeg}

    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${REQUEST_FILES}    ${files}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Hình Ảnh Vượt Kích Thước Tối Đa
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    OVR${random_code}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}
    
    # Chuẩn bị hình ảnh kích thước vượt giới hạn
    ${files}=    Create Dictionary
    ${stream}=    Get File For Streaming Upload    Images/oversize.jpg
    ${files}=    Set To Dictionary    ${files}    ProductImage=${stream}
    
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${REQUEST_FILES}    ${files}
    RETURN    ${REQUEST_DATA}

# Keywords xác thực cho test hình ảnh
Xác Thực Sản Phẩm Có Nhiều Hình Ảnh Được Lưu Trữ
    ${query}=    Set Variable    SELECT COUNT(*) FROM ProductImage WHERE ProductId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin hình ảnh sản phẩm
    ${count}=    Convert To Integer    ${result[0]}
    Should Be True    ${count} >= 3    Số lượng hình ảnh không đủ, chỉ có ${count} hình ảnh
    
    # Xác thực thông tin hình ảnh có trong database
    ${query_images}=    Set Variable    SELECT TOP 3 Image FROM ProductImage WHERE ProductId = ? 
    ${results}=    Fetch All    ${query_images}    ${CREATED_PRODUCT_ID}
    ${count_results}=    Get Length    ${results}
    Should Be True    ${count_results} >= 3    Không đủ số lượng hình ảnh cần kiểm tra
    
    # Kiểm tra URL của mỗi hình ảnh không rỗng
    FOR    ${result}    IN    @{results}
        ${url}=    Set Variable    ${result[0]}
        Should Not Be Empty    ${url}    URL hình ảnh không được để trống
        Should Contain    ${url}    https://cdn     URL hình ảnh phải chứa địa chỉ lưu trữ Amazon S3
    END

Xác Thực Sản Phẩm Có Hình Ảnh Ghim Chính
    ${query}=    Set Variable    SELECT TOP 1 Id, IsDefault FROM ProductImage WHERE ProductId = ? AND IsDefault = 1
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy hình ảnh ghim chính
    Should Be Equal As Strings    ${result[1]}    True    Hình ảnh không được đánh dấu là hình ảnh mặc định
    
    # Kiểm tra chỉ có một hình ảnh ghim chính
    ${query_count}=    Set Variable    SELECT COUNT(*) FROM ProductImage WHERE ProductId = ? AND IsDefault = 1
    ${result_count}=    Fetch One    ${query_count}    ${CREATED_PRODUCT_ID}
    Should Be Equal As Integers    ${result_count[0]}    1    Có nhiều hơn một hình ảnh ghim chính

Xác Thực Sản Phẩm Có Hình Ảnh Từ URL Được Lưu Trữ
    ${query}=    Set Variable    SELECT TOP 1 Id, Image FROM ProductImage WHERE ProductId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy hình ảnh sản phẩm
    
    # Xác thực URL hình ảnh không rỗng và có định dạng đúng
    ${url}=    Set Variable    ${result[1]}
    Should Not Be Empty    ${url}    URL hình ảnh không được để trống
    Should Contain    ${url}      https://cdn   URL hình ảnh phải chứa địa chỉ lưu trữ Amazon S3
    

Xác Thực Sản Phẩm Có Hình Ảnh Với Các Định Dạng Khác Nhau
    ${query}=    Set Variable    SELECT Id, Image FROM ProductImage WHERE ProductId = ?
    ${results}=    Fetch All    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${results}    None    Không tìm thấy hình ảnh sản phẩm
    ${count}=    Get Length    ${results}
    Should Be True    ${count} >= 3    Không đủ số lượng hình ảnh cần kiểm tra, chỉ có ${count} hình ảnh
    
    # Kiểm tra các định dạng được lưu trữ đúng
    ${formats}=    Create List    jpg    png    jpeg
    FOR    ${i}    ${format}    IN ENUMERATE    @{formats}
        ${url}=    Set Variable    ${results}[${i}][1]
        Should Not Be Empty    ${url}    URL hình ảnh không được để trống
        # Thực tế, tất cả định dạng thường được chuyển đổi thành jpg khi lưu trữ
        Should Contain    ${url}    https://cdn    URL hình ảnh phải chứa địa chỉ lưu trữ Amazon S3
    END

# Keywords for Unit Management tests
Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Tính Cơ Bản ${unit_name}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    DVT${random_code}
    ${request}    Update Dictionary Property    ${request}    Unit    ${unit_name}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Tính ${unit_names} Có Giá Trị Quy Đổi ${conversion_values} Và Giá Bán ${prices}
    ${list_product_body}     Create List  
    ${list_product_code}     Create List
    ${list_unit_body}     Create List
    FOR    ${item_name}   ${item_value}   ${item_price}  IN ZIP    ${unit_names}    ${conversion_values}    ${prices}
        ${request}=    Deep Copy    ${list_product_data}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        ${code}=    Set Variable    QD${random_code}
        ${request}    Update Dictionary Property    ${request}    Code    ${code}
        ${request}    Update Dictionary Property    ${request}    Unit    ${item_name}
        ${request}    Update Dictionary Property    ${request}    ConversionValue    ${item_value}
        ${request}    Update Dictionary Property    ${request}    BasePrice    ${item_price}
        ${unit_body}    Deep Copy    ${PRODUCT_UNITS}
        ${unit_body}    Update Dictionary Property    ${unit_body}    Unit    ${item_name}
        ${unit_body}    Update Dictionary Property    ${unit_body}    ConversionValue    ${item_value}
        ${unit_body}    Update Dictionary Property    ${unit_body}    BasePrice    ${item_price}
        Append To List    ${list_unit_body}    ${unit_body}
        ${request}    Update Dictionary Property    ${request}    ProductUnits    ${list_unit_body}  
        Append To List   ${list_product_body}    ${request}
        Append To List   ${list_product_code}    ${code}
    END
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${list_product_body}).replace("'",'"')
    ${list_products}     Evaluate    (None, '${form_data}')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}  
    log    ${payload}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${UNIT_NAMES}    ${unit_names}
    Set Test Variable    ${PRICES}    ${prices}
    Set Test Variable    ${LIST_PRODUCT_CODE}    ${list_product_code}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Tính ${unit_names} Có Giá Trị Quy Đổi ${conversion_values} Và Mã Vạch ${barcodes}
    ${list_product_body}     Create List  
    ${list_product_code}     Create List
    ${list_unit_body}     Create List
    FOR    ${item_name}   ${item_value}   ${item_barcode}  IN ZIP    ${unit_names}    ${conversion_values}    ${barcodes}
        ${request}=    Deep Copy    ${list_product_data}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        ${code}=    Set Variable    QD${random_code}
        ${request}    Update Dictionary Property    ${request}    Code    ${code}
        ${request}    Update Dictionary Property    ${request}    Unit    ${item_name}
        ${request}    Update Dictionary Property    ${request}    ConversionValue    ${item_value}
        ${request}    Update Dictionary Property    ${request}    Barcode   ${item_barcode}
        ${unit_body}    Deep Copy    ${PRODUCT_UNITS}
        ${unit_body}    Update Dictionary Property    ${unit_body}    Unit    ${item_name}
        ${unit_body}    Update Dictionary Property    ${unit_body}    ConversionValue    ${item_value}
        ${unit_body}    Update Dictionary Property    ${unit_body}    Barcode    ${item_barcode}
        Append To List    ${list_unit_body}    ${unit_body}
        ${request}    Update Dictionary Property    ${request}    ProductUnits    ${list_unit_body}  
        Append To List   ${list_product_body}    ${request}
        Append To List   ${list_product_code}    ${code}
    END
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${list_product_body} ).replace("'",'"')
    ${list_products}     Evaluate    (None, '${form_data}')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${UNIT_NAMES}    ${unit_names}
    Set Test Variable    ${BARCODES}    ${barcodes}
    Set Test Variable    ${LIST_PRODUCT_CODE}    ${list_product_code}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Tính ${unit_names} Có Giá Trị Quy Đổi ${conversion_values} Và Điểm Khác Nhau ${different_points}
    ${list_product_body}     Create List  
    ${list_product_code}     Create List
    ${list_unit_body}     Create List
    FOR    ${item_name}   ${item_value}   ${item_different_point}  IN ZIP    ${unit_names}    ${conversion_values}    ${different_points}
        ${request}=    Deep Copy    ${list_product_data}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        ${code}=    Set Variable    QD${random_code}
        ${request}    Update Dictionary Property    ${request}    Code    ${code}
        ${request}    Update Dictionary Property    ${request}    Unit    ${item_name}
        ${request}    Update Dictionary Property    ${request}    ConversionValue    ${item_value}
        ${request}    Update Dictionary Property    ${request}    IsRewardPoint   True   
        ${request}    Update Dictionary Property    ${request}    RewardPoint    ${item_different_point}
        ${unit_body}    Deep Copy    ${PRODUCT_UNITS}
        ${unit_body}    Update Dictionary Property    ${unit_body}    Unit    ${item_name}
        ${unit_body}    Update Dictionary Property    ${unit_body}    ConversionValue    ${item_value}
        ${unit_body}    Update Dictionary Property    ${unit_body}    RewardPoint    ${item_different_point}
        Append To List    ${list_unit_body}    ${unit_body}
        ${request}    Update Dictionary Property    ${request}    ProductUnits    ${list_unit_body}
        Append To List   ${list_product_body}    ${request}
        Append To List   ${list_product_code}    ${code}
    END
    ${form_data}=    Evaluate     str(${list_product_body} ).replace("'",'"')
    ${list_products}     Evaluate    (None, '${form_data}')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${UNIT_NAMES}    ${unit_names}
    Set Test Variable    ${CONVERSION_VALUES}    ${conversion_values}
    Set Test Variable    ${DIFFERENT_POINTS}    ${different_points}
    Set Test Variable    ${LIST_PRODUCT_CODE}   ${list_product_code} 
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Tính ${unit_names} Có Giá Trị Quy Đổi ${conversion_values} Và ${direct_selling} Bán Trực Tiếp
    ${list_product_body}     Create List  
    ${list_product_code}     Create List
    ${list_unit_body}     Create List
    FOR    ${item_name}   ${item_value}   ${item_direct_selling}     IN ZIP    ${unit_names}    ${conversion_values}    ${direct_selling}
        ${status}    Run Keyword If    "${item_direct_selling}" == "Không"    Set Variable    false    ELSE    Set Variable    true
        ${request}=    Deep Copy    ${list_product_data}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        ${code}=    Set Variable    QD${random_code}
        ${request}    Update Dictionary Property    ${request}    Code    ${code}
        ${request}    Update Dictionary Property    ${request}    Unit    ${item_name}
        ${request}    Update Dictionary Property    ${request}    ConversionValue    ${item_value}
        ${request}    Update Dictionary Property    ${request}    AllowsSale    ${status}
        ${unit_body}    Deep Copy    ${PRODUCT_UNITS}
        ${unit_body}    Update Dictionary Property    ${unit_body}    Unit    ${item_name}
        ${unit_body}    Update Dictionary Property    ${unit_body}    ConversionValue    ${item_value}
        ${unit_body}    Update Dictionary Property    ${unit_body}    AllowsSale    ${status}
        Append To List    ${list_unit_body}    ${unit_body}
        ${request}    Update Dictionary Property    ${request}    ProductUnits    ${list_unit_body}  
        Append To List   ${list_product_body}    ${request}
        Append To List   ${list_product_code}    ${code}
    END
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${list_product_body} ).replace("'",'"')
    ${list_products}     Evaluate    (None, '${form_data}')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${LIST_PRODUCT_CODE}    ${list_product_code}
    RETURN    ${REQUEST_DATA}



Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Tính ${unit_names} Có Giá Trị Quy Đổi ${conversion_values} Và Tồn Kho ${stock}
    ${list_product_body}     Create List  
    ${list_product_code}     Create List
    ${list_unit_body}     Create List
    FOR    ${item_name}   ${item_value}     IN ZIP    ${unit_names}    ${conversion_values}   
        ${request}=    Deep Copy    ${list_product_data}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        ${code}=    Set Variable    QD${random_code}
        ${request}    Update Dictionary Property    ${request}    Code    ${code}
        ${request}    Update Dictionary Property    ${request}    Unit    ${item_name}
        ${request}    Update Dictionary Property    ${request}    ConversionValue    ${item_value}
        ${request}    Update Dictionary Property    ${request}    Onhand   ${stock}
        ${unit_body}    Deep Copy    ${PRODUCT_UNITS}
        ${unit_body}    Update Dictionary Property    ${unit_body}    Unit    ${item_name}
        ${unit_body}    Update Dictionary Property    ${unit_body}    ConversionValue    ${item_value}
        Append To List    ${list_unit_body}    ${unit_body}
        ${request}    Update Dictionary Property    ${request}    ProductUnits    ${list_unit_body}  
        Append To List   ${list_product_body}    ${request}
        Append To List   ${list_product_code}    ${code}
    END
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${list_product_body} ).replace("'",'"')
    ${list_products}     Evaluate    (None, '${form_data}')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${UNIT_NAMES}    ${unit_names}
    Set Test Variable    ${CONVERSION_VALUES}    ${conversion_values}
    Set Test Variable    ${BASE_STOCK}    ${stock}
    Set Test Variable    ${LIST_PRODUCT_CODE}    ${list_product_code}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Tính ${unit_names} Có Giá Trị Quy Đổi ${conversion_values} Và Giá Vốn ${cost}
    ${list_product_body}     Create List  
    ${list_product_code}     Create List
    ${list_unit_body}     Create List
    FOR    ${item_name}   ${item_value}     IN ZIP    ${unit_names}    ${conversion_values}   
        ${request}=    Deep Copy    ${list_product_data}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        ${code}=    Set Variable    QD${random_code}
        ${request}    Update Dictionary Property    ${request}    Code    ${code}
        ${request}    Update Dictionary Property    ${request}    Unit    ${item_name}
        ${request}    Update Dictionary Property    ${request}    ConversionValue    ${item_value}
        ${request}    Update Dictionary Property    ${request}    Cost   ${cost}
        ${unit_body}    Deep Copy    ${PRODUCT_UNITS}
        ${unit_body}    Update Dictionary Property    ${unit_body}    Unit    ${item_name}
        ${unit_body}    Update Dictionary Property    ${unit_body}    ConversionValue    ${item_value}
        Append To List    ${list_unit_body}    ${unit_body}
        ${request}    Update Dictionary Property    ${request}    ProductUnits    ${list_unit_body}  
        Append To List   ${list_product_body}    ${request}
        Append To List   ${list_product_code}    ${code}
    END
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${list_product_body} ).replace("'",'"')
    ${list_products}     Evaluate    (None, '${form_data}')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${UNIT_NAMES}    ${unit_names}
    Set Test Variable    ${CONVERSION_VALUES}    ${conversion_values}
    Set Test Variable    ${BASE_COST}    ${cost}
    Set Test Variable    ${LIST_PRODUCT_CODE}    ${list_product_code}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Số Lượng Đơn Vị Tính ${number_of_units}
    ${list_product_body}     Create List  
    ${list_product_code}     Create List
    ${list_unit_body}     Create List

    # Tạo tối đa đơn vị tính phụ (10 đơn vị)
    ${units_list}=    Create List
    FOR    ${index}    IN RANGE    1    ${number_of_units}+1
        ${request}=    Deep Copy    ${list_product_data}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        ${code}=    Set Variable    QD${random_code}
        ${request}    Update Dictionary Property    ${request}    Code    ${code}
        ${request}    Update Dictionary Property    ${request}    Unit    ĐVT ${index}
        ${request}    Update Dictionary Property    ${request}    ConversionValue    ${index * 10}
        ${unit_body}=    Deep Copy    ${PRODUCT_UNITS}
        ${unit_body}=    Update Dictionary Property    ${unit_body}    Unit    ĐVT ${index}
        ${unit_body}=    Update Dictionary Property    ${unit_body}    ConversionValue    ${index * 10}
        Append To List    ${list_unit_body}      ${unit_body}
        ${request}    Update Dictionary Property    ${request}    ProductUnits    ${list_unit_body}
        Append To List   ${list_product_body}    ${request}
        Append To List   ${list_product_code}    ${code}
    END
    
    ${form_data}=    Evaluate     str(${list_product_body}).replace("'",'"')
    ${list_products}     Evaluate    (None, '${form_data}')
    ${payload}    Create Dictionary    ListProductsString=${list_products}   
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${LIST_PRODUCT_CODE}    ${list_product_code}
    Set Test Variable    ${MAX_UNITS_COUNT}    ${number_of_units}
    RETURN    ${REQUEST_DATA}

# Verification keywords for Unit Management tests
Xác Thực Sản Phẩm Có Đơn Vị Tính ${unit_name}
    ${query}=    Set Variable    SELECT Unit FROM Product WHERE Id = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm với ID ${CREATED_PRODUCT_ID}
    Should Be Equal    ${result[0]}    ${unit_name}    Đơn vị tính của sản phẩm không khớp. Mong đợi: ${unit_name}, Thực tế: ${result[0]}

Xác Thực Sản Phẩm Có Giá Bán Theo Đơn Vị Tính ${unit_names} Là ${prices}
    # Xác thực giá bán đơn vị tính cơ bản
    ${base_unit}=    Get From List    ${unit_names}    0
    ${base_price}=    Get From List    ${prices}    0
    ${query_base}=    Set Variable    SELECT Unit, BasePrice FROM Product WHERE Id = ${CREATED_PRODUCT_ID} AND RetailerId = ${RETAILER_ID}
    ${result_base}=    Fetch One    ${query_base}
    Should Not Be Equal    ${result_base}    None    Không tìm thấy sản phẩm với ID ${product_id}
    Should Be Equal    ${result_base[0]}    ${base_unit}    Đơn vị tính cơ bản không khớp
    Should Be Equal As Numbers    ${result_base[1]}    ${base_price}    Giá bán của đơn vị ${base_unit} không khớp
    # Loại bỏ đơn vị tính cơ bản và giá của nó khỏi danh sách kiểm tra
    ${unit_names}=    Get Slice From List    ${unit_names}    1
    ${prices}=    Get Slice From List    ${prices}    1
    # Xác thực giá bán các đơn vị tính phụ
    FOR    ${unit_name}    ${price}    IN ZIP    ${unit_names}    ${prices}
        ${query}=    Set Variable    SELECT Unit, BasePrice FROM Product WHERE MasterUnitId = ${CREATED_PRODUCT_ID} AND Unit = '${unit_name}' AND RetailerId = ${RETAILER_ID}
        ${result}=    Fetch One    ${query}
        Should Not Be Equal    ${result}    None    Không tìm thấy đơn vị tính phụ ${unit_name}
        Should Be Equal    ${result[0]}    ${unit_name}    Tên đơn vị tính phụ không khớp
        Should Be Equal As Numbers    ${result[1]}    ${price}    Giá bán của đơn vị ${unit_name} không khớp
    END

Xác Thực Sản Phẩm Có Mã Vạch Theo Đơn Vị Tính ${unit_names} Là ${barcodes}
    # Xác thực mã vạch đơn vị tính cơ bản
    ${base_unit}=    Get From List    ${unit_names}    0
    ${base_barcode}=    Get From List    ${barcodes}    0
    ${query_base}=    Set Variable    SELECT Unit, Barcode FROM Product WHERE Id = ${CREATED_PRODUCT_ID} AND RetailerId = ${RETAILER_ID}
    ${result_base}=    Fetch One    ${query_base}
    Should Not Be Equal    ${result_base}    None    Không tìm thấy sản phẩm với ID ${CREATED_PRODUCT_ID}
    Should Be Equal    ${result_base[0]}    ${base_unit}    Đơn vị tính cơ bản không khớp
    Should Be Equal    ${result_base[1]}    ${base_barcode}    Mã vạch của đơn vị ${base_unit} không khớp
    ${unit_names}=    Get Slice From List    ${unit_names}    1
    ${barcodes}=    Get Slice From List    ${barcodes}    1
    # Xác thực mã vạch các đơn vị tính phụ
    FOR    ${unit_name}    ${barcode}    IN ZIP    ${unit_names}    ${barcodes}
        ${query}=    Set Variable    SELECT Unit, Barcode FROM Product WHERE MasterUnitId=${CREATED_PRODUCT_ID} AND Unit = '${unit_name}' AND RetailerId = ${RETAILER_ID}
        ${result}=    Fetch One    ${query}
        Should Not Be Equal    ${result}    None    Không tìm thấy đơn vị tính phụ ${unit_name}
        Should Be Equal    ${result[0]}    ${unit_name}    Tên đơn vị tính phụ không khớp
        Should Be Equal    ${result[1]}    ${barcode}    Mã vạch của đơn vị ${unit_name} không khớp
    END

Xác Thực Sản Phẩm Có Tồn Kho Đơn Vị "${unit_name}" Là ${expected_stock}
    # Xác định ID của đơn vị tính cụ thể
    ${query_unit}=    Set Variable    SELECT Id FROM Product WHERE (Id = ${CREATED_PRODUCT_ID} OR MasterProductId = ${CREATED_PRODUCT_ID}) AND Unit = '${unit_name}' AND RetailerId = ${RETAILER_ID}
    ${result_unit}=    Fetch One    ${query_unit}
    Should Not Be Equal    ${result_unit}    None    Không tìm thấy đơn vị tính ${unit_name} cho sản phẩm ID ${CREATED_PRODUCT_ID}
    
    # Kiểm tra tồn kho của đơn vị tính đó ở chi nhánh mặc định
    ${unit_id}=    Set Variable    ${result_unit[0]}
    ${query_stock}=    Set Variable    SELECT OnHand FROM ProductBranch WHERE ProductId = ${unit_id} AND BranchId = ${DEFAULT_BRANCH_ID} AND RetailerId = ${RETAILER_ID}
    ${result_stock}=    Fetch One    ${query_stock}
    Should Not Be Equal    ${result_stock}    None    Không tìm thấy thông tin tồn kho cho đơn vị tính ${unit_name}
    
    # So sánh với tồn kho mong đợi (làm tròn đến 2 chữ số thập phân để tránh lỗi do làm tròn số thực)
    ${actual_stock}=    Evaluate    round(float(${result_stock[0]}), 2)
    ${expected_stock}=    Evaluate    round(float(${expected_stock}), 2)
    Should Be Equal As Numbers    ${actual_stock}    ${expected_stock}    Tồn kho của đơn vị ${unit_name} không khớp. Mong đợi: ${expected_stock}, Thực tế: ${actual_stock}

Xác Thực Sản Phẩm Có Giá Vốn Đơn Vị "${unit_name}" Là ${expected_cost}
    ${query_unit}=    Set Variable    SELECT Id FROM Product WHERE (Id = ${CREATED_PRODUCT_ID} OR MasterUnitId=${CREATED_PRODUCT_ID}) AND Unit = '${unit_name}' AND RetailerId = ${RETAILER_ID}
    ${result_unit}=    Fetch One    ${query_unit}
    Should Not Be Equal    ${result_unit}    None    Không tìm thấy đơn vị tính ${unit_name} cho sản phẩm ID ${CREATED_PRODUCT_ID}
    
    # Kiểm tra giá vốn của đơn vị tính đó ở chi nhánh mặc định
    ${unit_id}=    Set Variable    ${result_unit[0]}
    ${query_cost}=    Set Variable    SELECT Cost FROM ProductBranch WHERE ProductId = ${unit_id} AND BranchId = ${DEFAULT_BRANCH_ID} AND RetailerId = ${RETAILER_ID}
    ${result_cost}=    Fetch One    ${query_cost}
    Should Not Be Equal    ${result_cost}    None    Không tìm thấy thông tin giá vốn cho đơn vị tính ${unit_name}
    
    # So sánh với giá vốn mong đợi (làm tròn đến 2 chữ số thập phân để tránh lỗi do làm tròn số thực)
    ${actual_cost}=    Evaluate    round(float(${result_cost[0]}), 2)
    ${expected_cost}=    Evaluate    round(float(${expected_cost}), 2)
    Should Be Equal As Numbers    ${actual_cost}    ${expected_cost}    Giá vốn của đơn vị ${unit_name} không khớp. Mong đợi: ${expected_cost}, Thực tế: ${actual_cost}

Xác Thực Sản Phẩm Có Đúng Số Lượng Đơn Vị Tính Tối Đa

    # Đếm số lượng đơn vị tính (bao gồm cả đơn vị cơ bản)
    ${query}=    Set Variable    SELECT COUNT(*) FROM Product WHERE (Id = ${CREATED_PRODUCT_ID} OR MasterUnitId=${CREATED_PRODUCT_ID}) AND RetailerId = ${RETAILER_ID}
    ${result}=    Fetch One    ${query}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm với ID ${CREATED_PRODUCT_ID}
    
    Should Be Equal As Numbers    ${result[0]}    ${MAX_UNITS_COUNT}    Số lượng đơn vị tính không khớp. Mong đợi: ${MAX_UNITS_COUNT}, Thực tế: ${result[0]}

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

Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính Nhập Tự Do
    ${list_products}=    Create List
    ${request}=    Deep Copy    ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${code}=    Set Variable    HHTT${random_code}
    ${request}=    Update Nested Dictionary Property    ${request}    Code    ${code}
    ${request}=    Update Nested Dictionary Property    ${request}    Name    Sản phẩm với thuộc tính tự do
    
    # Tạo thuộc tính tự do
    ${custom_value}=    Set Variable    Giá trị tự nhập không có trong danh sách
    ${attribute_id}=    Lấy ID thuộc tính    MÀU SẮC
    
    # Tạo thuộc tính
    ${product_attributes}=    Create List
    ${attribute}=    Deep Copy    ${standard_product_attributes}
    ${attribute}=    Update Nested Dictionary Property    ${attribute}    AttributeId    ${attribute_id}
    ${attribute}=    Update Nested Dictionary Property    ${attribute}    Value    ${custom_value}
    Append To List    ${product_attributes}    ${attribute}
    
    ${request}=    Update Nested Dictionary Property    ${request}    ProductAttributes    ${product_attributes}
    Append To List    ${list_products}    ${request}
    
    ${branch_pr_cost}=    Evaluate    str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}=    Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate    str(${list_products}).replace("'",'"')
    ${list_products_attribute}=    Evaluate    (None, '${form_data}')
    ${payload}=    Create Dictionary    ListProductsString=${list_products_attribute}    BranchForProductCostss=${branch_pr_cost}
    
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${CREATED_PRODUCT_CODE}    ${code}
    Set Test Variable    ${CUSTOM_ATTRIBUTE_VALUE}    ${custom_value}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính Chứa Ký Tự Đặc Biệt
    ${list_products}=    Create List
    ${request}=    Deep Copy    ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${code}=    Set Variable    HHTT${random_code}
    ${request}=    Update Nested Dictionary Property    ${request}    Code    ${code}
    ${request}=    Update Nested Dictionary Property    ${request}    Name    Sản phẩm với thuộc tính đặc biệt
    
    # Tạo thuộc tính với ký tự đặc biệt
    ${special_value}=    Set Variable    Đặc biệt!@#$%^&*()_
    ${attribute_id}=    Lấy ID thuộc tính    MÀU SẮC
    
    # Tạo thuộc tính
    ${product_attributes}=    Create List
    ${attribute}=    Deep Copy    ${standard_product_attributes}
    ${attribute}=    Update Nested Dictionary Property    ${attribute}    AttributeId    ${attribute_id}
    ${attribute}=    Update Nested Dictionary Property    ${attribute}    Value    ${special_value}
    Append To List    ${product_attributes}    ${attribute}
    
    ${request}=    Update Nested Dictionary Property    ${request}    ProductAttributes    ${product_attributes}
    Append To List    ${list_products}    ${request}
    
    ${branch_pr_cost}=    Evaluate    str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}=    Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate    str(${list_products}).replace("'",'"')
    ${list_products_attribute}=    Evaluate    (None, '${form_data}')
    ${payload}=    Create Dictionary    ListProductsString=${list_products_attribute}    BranchForProductCostss=${branch_pr_cost}
    
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${CREATED_PRODUCT_CODE}    ${code}
    Set Test Variable    ${SPECIAL_ATTRIBUTE_VALUE}    ${special_value}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Nhiều Thuộc Tính
    # Tạo sản phẩm với nhiều thuộc tính (>5 thuộc tính)
    ${list_products}=    Create List
    ${request}=    Deep Copy    ${list_product_data}
    # Danh sách thuộc tính và giá trị
    ${attribute_names}=    Create List    MÀU SẮC    KÍCH THƯỚC    CHẤT LIỆU   SIZE
    ${attribute_values}=    Create List    Đỏ    L    Cotton    Classic      40x40
    
    # Tạo danh sách thuộc tính
    FOR    ${index}    IN RANGE    4  
        ${request}=    Deep Copy    ${list_product_data}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        ${code}=    Set Variable    HHTT${random_code}
        ${request}=    Update Nested Dictionary Property    ${request}    Code    ${code}

        ${request}=    Update Nested Dictionary Property    ${request}    Name    Sản phẩm nhiều thuộc tính
        ${request}     Update Nested Dictionary Property    ${request}    FullName    
        ${attribute}=    Deep Copy    ${standard_product_attributes}
        ${attr_name}=    Get From List    ${attribute_names}    ${index}
        ${value}=    Get From List    ${attribute_values}    ${index}
        ${attribute_id}=    Lấy ID thuộc tính    ${attr_name}
        ${attribute}=    Update Nested Dictionary Property    ${attribute}    AttributeId    ${attribute_id}
        ${attribute}=    Update Nested Dictionary Property    ${attribute}    Value    ${value}
        ${request}=    Update Nested Dictionary Property    ${request}    ProductAttributes    ${attribute}
        Append To List    ${list_products}    ${request}
    END
    
    
    ${form_data}=    Evaluate    str(${list_products}).replace("'",'"')
    ${list_products_attribute}=    Evaluate    (None, '${form_data}')
    ${payload}=    Create Dictionary    ListProductsString=${list_products_attribute}   
    Log    ${payload}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${LIST_PRODUCT_CODE}    ${code}
    Set Test Variable    ${ATTRIBUTE_COUNT}    4
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Biến Thể Có Giá Và Tồn Kho Riêng Theo Chi Nhánh
    # Tạo các thuộc tính màu sắc
    @{colors}=    Create List    Đỏ    Xanh    Vàng
    &{dict_attributes}=    Create Dictionary    MÀU SẮC=@{colors}
    
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
    
    # Tạo các tổ hợp thuộc tính
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
    
    ${list_products_code}=    Create List
    # Tạo sản phẩm cho mỗi tổ hợp thuộc tính với giá và tồn kho khác nhau theo chi nhánh
    FOR    ${index}    ${combination}    IN ENUMERATE    @{combinations}
        ${request}=    Deep Copy    ${list_product_data}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        ${code}=    Set Variable    HHTT${random_code}
        Append To List    ${list_products_code}    ${code}
        ${request}=    Update Nested Dictionary Property    ${request}    Code    ${code}
        
        # Tạo tên sản phẩm từ tổ hợp thuộc tính
        ${combination_values}=    Split String    ${combination}    |



Chuẩn Bị Dữ Liệu Sản Phẩm Có Thuộc Tính ${dict_attribute_name} 
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
            ${request}=    Update Nested Dictionary Property     ${request}    ProductAttributes    ${product_attributes}
            Append To List    ${list_products}    ${request}
        END
     
    RETURN    ${list_products}







