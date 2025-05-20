

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
${CATEGORY_ID_NHA_THUOC}    1000000751
${ROA_ID_NHA_THUOC}    1000000001
*** Keywords ***
Chuẩn Bị Dữ Liệu Sản Phẩm Là Thuốc
  ${product_info}=    Lấy thông tin thuốc từ danh mục thuốc    1
  ${manufacturer_info}=    Lấy thông tin hãng sản xuất nhà thuốc  ${product_info[7]}
   ${request}=    Deep Copy     ${list_product_data}
     ${random_code}=    Generate Random String    6    [NUMBERS]
     ${request}    Update Dictionary Property    ${request}    Code    T${random_code}
     ${request}    Update Dictionary Property    ${request}    IsBatchExpireControl    true
     ${request}    Update Dictionary Property    ${request}    Name    ${product_info[2]}
     ${request}    Update Dictionary Property    ${request}    CategoryId    ${CATEGORY_ID_NHA_THUOC}
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
     ${request}    Update Dictionary Property    ${request}    GlobalRoaId    ${ROA_ID_NHA_THUOC}
     ${request}    Update Dictionary Property    ${request}    RouteOfAdministration   ${ROA_ID_NHA_THUOC}
     ${request}    Update Dictionary Property    ${request}    GlobalManufacturerCountryId    2
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Có Đơn Vị Tính ${name_unit} Với Giá Trị ${value}
    ${product_info}=    Lấy thông tin thuốc từ danh mục thuốc    1
    ${manufacturer_info}=    Lấy thông tin hãng sản xuất nhà thuốc  ${product_info[7]}
    ${list_products}      Deep Copy    ${list_product_data}
    ${list_unit_body}=    Create List
    ${list_product_body}=    Create List
    ${list_product_code}=    Create List
    FOR    ${item_name}   ${item_value}  IN ZIP   ${name_unit}    ${value}
        ${unit_body}    Deep Copy    ${PRODUCT_UNITS}
        ${unit_body}    Update Dictionary Property    ${unit_body}    Unit    ${item_name}
        ${unit_body}    Update Dictionary Property    ${unit_body}    ConversionValue    ${item_value}
        Append To List    ${list_unit_body}    ${unit_body}
    END
    
    FOR    ${item_name}   ${item_value}  IN ZIP    ${name_unit}  ${value}
        ${request}=    Deep Copy     ${list_product_data}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        ${code}=    Set Variable    TDV${random_code}
        ${request}    Update Dictionary Property    ${request}    Code    ${code}
        ${request}    Update Dictionary Property    ${request}    IsBatchExpireControl    true
        ${request}    Update Dictionary Property    ${request}    Name    ${product_info[2]}
        ${request}    Update Dictionary Property    ${request}    CategoryId    ${CATEGORY_ID_NHA_THUOC}
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
        ${request}    Update Dictionary Property    ${request}    GlobalRoaId    ${ROA_ID_NHA_THUOC}
        ${request}    Update Dictionary Property    ${request}    RouteOfAdministration   ${ROA_ID_NHA_THUOC}
        ${request}    Update Dictionary Property    ${request}    GlobalManufacturerCountryId    2
        ${request}    Update Dictionary Property    ${request}    Unit    ${item_name}
        ${request}    Update Dictionary Property    ${request}    ConversionValue    ${item_value}
         Append To List   ${list_product_code}    ${code}
        Append To List   ${list_product_body}    ${request}
    END
    ${list_products}    Update Dictionary Property    ${list_products}    ProductUnits    ${list_unit_body}
    
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Giới Hạn Tồn Kho
    ${product_info}=    Lấy thông tin thuốc từ danh mục thuốc    1
    ${manufacturer_info}=    Lấy thông tin hãng sản xuất nhà thuốc  ${product_info[7]}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    TGTK${random_code}
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
    ${request}    Update Dictionary Property    ${request}    MinQuantity    10
    ${request}    Update Dictionary Property    ${request}    MaxQuantity    100
    
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Ngừng Kinh Doanh
    ${product_info}=    Lấy thông tin thuốc từ danh mục thuốc    1
    ${manufacturer_info}=    Lấy thông tin hãng sản xuất nhà thuốc  ${product_info[7]}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    TNKD${random_code}
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
    ${request}    Update Dictionary Property    ${request}    isActive    false
    
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Tồn Kho Ban Đầu 20
    ${product_info}=    Lấy thông tin thuốc từ danh mục thuốc    1
    ${manufacturer_info}=    Lấy thông tin hãng sản xuất nhà thuốc  ${product_info[7]}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    TTK${random_code}
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
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request}
    
Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Mã Trùng Lặp ${product_code}
    ${product_info}=    Lấy thông tin thuốc từ danh mục thuốc    1
    ${manufacturer_info}=    Lấy thông tin hãng sản xuất nhà thuốc  ${product_info[7]}
    ${request}=    Deep Copy     ${list_product_data}
    ${request}    Update Dictionary Property    ${request}    Code    ${product_code}
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
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request}

