

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
     ${request}    Update Dictionary Property    ${request}    RouteOfAdministration   Đường Miệng
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
         ${request}    Update Dictionary Property    ${request}   RouteOfAdministration   Đường Miệng
        ${request}    Update Dictionary Property    ${request}    GlobalManufacturerCountryId    2
        ${request}    Update Dictionary Property    ${request}    Unit    ${item_name}
        ${request}    Update Dictionary Property    ${request}    ConversionValue    ${item_value}
        ${request}    Update Dictionary Property    ${request}    ProductUnits    ${list_unit_body}
         Append To List   ${list_product_code}    ${code}
        Append To List   ${list_product_body}    ${request}
    END
    
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${list_product_body}).replace("'",'"')
    ${list_products}     Evaluate    (None, '${form_data}')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${LIST_PRODUCT_CODE}    ${list_product_code}
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
    ${request}    Update Dictionary Property    ${request}    RouteOfAdministration   Đường Miệng
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
Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Có Giá Vốn ${cost_price} Áp Dụng Ở Chi Nhánh ${list_branch_name}
    ${product_info}=    Lấy thông tin thuốc từ danh mục thuốc    1
    ${manufacturer_info}=    Lấy thông tin hãng sản xuất nhà thuốc  ${product_info[7]}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    TGTK${random_code}    
    ${request}    Update Dictionary Property    ${request}    IsBatchExpireControl    true
    ${request}    Update Dictionary Property    ${request}    AllowsSale    true
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
    ${request}    Update Dictionary Property    ${request}    RouteOfAdministration   Đường Miệng
    ${request}    Update Dictionary Property    ${request}    GlobalManufacturerCountryId    2
    ${request}    Update Dictionary Property    ${request}    Cost   ${cost_price}
    ${list_branch_cost}=    Create List
    FOR    ${branch_name}    IN    @{list_branch_name}
        ${branch_id}    Lấy Thông tin Chi Nhánh    ${branch_name}
        ${branch_cost}    Deep Copy    ${branch_for_cost}
        ${branch_cost}    Update Dictionary Property    ${branch_cost}    Id    ${branch_id}
        ${branch_cost}    Update Dictionary Property    ${branch_cost}    Name    ${branch_name}
        Append To List    ${list_branch_cost}    ${branch_cost}
    END
    ${branch_pr_cost}     Evaluate     str(${list_branch_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '${branch_pr_cost}')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Kinh Doanh Ở Chi Nhánh ${list_branch_name}
    ${product_info}=    Lấy thông tin thuốc từ danh mục thuốc    1
    ${manufacturer_info}=    Lấy thông tin hãng sản xuất nhà thuốc  ${product_info[7]}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    TGTK${random_code}
    ${request}    Update Dictionary Property    ${request}    IsBatchExpireControl    true
    ${request}    Update Dictionary Property    ${request}    isActive   false
    ${request}    Update Dictionary Property    ${request}    Name    ${product_info[2]}
    ${request}    Update Dictionary Property    ${request}    CategoryId        ${CATEGORY_ID_NHA_THUOC}
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
    ${request}    Update Dictionary Property    ${request}    RouteOfAdministration   Đường Miệng
    ${request}    Update Dictionary Property    ${request}    GlobalManufacturerCountryId    2
    ${branch_id_list}=    Create List
    FOR    ${branch_name}    IN    @{list_branch_name}
        ${branch_id}    Lấy Thông tin Chi Nhánh    ${branch_name}
        Append To List    ${branch_id_list}    ${branch_id}
    END
    ${branch_id_list}    Evaluate    (None, '${branch_id_list}')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    ListBranchsSelected=${branch_id_list}
    Log   ${payload}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Không Bán Trực Tiếp
    ${product_info}=    Lấy thông tin thuốc từ danh mục thuốc    1
    ${manufacturer_info}=    Lấy thông tin hãng sản xuất nhà thuốc  ${product_info[7]}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    TNKD${random_code}
    ${request}    Update Dictionary Property    ${request}    IsBatchExpireControl    true
    ${request}    Update Dictionary Property    ${request}    AllowsSale    false
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
    ${request}    Update Dictionary Property    ${request}    RouteOfAdministration   Đường Miệng
    ${request}    Update Dictionary Property    ${request}    GlobalManufacturerCountryId    2
    ${request}    Update Dictionary Property    ${request}    isActive    false
    
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Trọng Lượng ${weight} ${unit}
    ${unit}   Set Variable If    '${unit}' == 'g'    2      3
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
    ${request}    Update Dictionary Property    ${request}    RouteOfAdministration   Đường Miệng
    ${request}    Update Dictionary Property    ${request}    GlobalManufacturerCountryId    2
    ${request}    Update Dictionary Property    ${request}    Weight    ${weight}
    ${request}    Update Dictionary Property    ${request}    Type4    ${unit}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request}
    
    
Chuẩn Bị Dữ Liệu Sản Phẩm Có Mã Barcode ${n} Ký Tự
    ${product_info}=    Lấy thông tin thuốc từ danh mục thuốc    1
    ${manufacturer_info}=    Lấy thông tin hãng sản xuất nhà thuốc  ${product_info[7]}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${random_barcode}=    Generate Random String    ${n}    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    TGTK${random_code}
    ${request}    Update Dictionary Property    ${request}    Barcode    ${random_barcode}
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
    ${request}    Update Dictionary Property    ${request}    RouteOfAdministration   Đường Miệng
    ${request}    Update Dictionary Property    ${request}    GlobalManufacturerCountryId    2
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${BARCODE}    ${random_barcode}
    RETURN    ${REQUEST_DATA}
   

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
    ${request}    Update Dictionary Property    ${request}    RouteOfAdministration   Đường Miệng
    ${request}    Update Dictionary Property    ${request}    GlobalManufacturerCountryId    2
    
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Từ Form Khác
    ${product_info}=    Lấy thông tin thuốc từ danh mục thuốc    1
    ${manufacturer_info}=    Lấy thông tin hãng sản xuất nhà thuốc  ${product_info[7]}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    TGTK${random_code}
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
    ${request}    Update Dictionary Property    ${request}    RouteOfAdministration   Đường Miệng
    ${request}    Update Dictionary Property    ${request}    GlobalManufacturerCountryId    2
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}       isAddFromOtherForm=True
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request}
    
Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Hình Ảnh
    ${product_info}=    Lấy thông tin thuốc từ danh mục thuốc    1
    ${manufacturer_info}=    Lấy thông tin hãng sản xuất nhà thuốc  ${product_info[7]}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    TGTK${random_code}
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
    ${request}    Update Dictionary Property    ${request}    RouteOfAdministration   Đường Miệng
    ${request}    Update Dictionary Property    ${request}    GlobalManufacturerCountryId    2
    ${files}=    Create Dictionary
    ${stream}=    Get File For Streaming Upload    Images/Anh1.jpg
    ${files}=    Set To Dictionary    ${files}    ProductImage=${stream}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}         BranchForProductCostss=${branch_pr_cost}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${REQUEST_FILES}    ${files}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Mô Tả Đặt Hàng ${n} Kí Tự và Ghi Chú ${m} Kí Tự
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    TGTK${random_code}
    ${note}=    Generate Random String    ${n}    [NUMBERS]
    ${description}=    Generate Random String    ${m}    [NUMBERS]
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
    ${request}    Update Dictionary Property    ${request}    RouteOfAdministration   Đường Miệng
    ${request}    Update Dictionary Property    ${request}    GlobalManufacturerCountryId    2
    ${request}    Update Dictionary Property    ${request}    OrderTemplate    ${note}
    ${request}    Update Dictionary Property    ${request}    Description    ${description}
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}   
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${DESCRIPTION}    ${description}
    Set Test Variable    ${NOTE}    ${note}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với ${list_shelves} Vị Trí
    ${product_info}=    Lấy thông tin thuốc từ danh mục thuốc    1
    ${manufacturer_info}=    Lấy thông tin hãng sản xuất nhà thuốc  ${product_info[7]}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    TGTK${random_code}
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
    ${request}    Update Dictionary Property    ${request}    RouteOfAdministration   Đường Miệng
    ${request}    Update Dictionary Property    ${request}    GlobalManufacturerCountryId    2
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
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}   
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    Set Test Variable    ${SHELVES_ID}    ${shelves_id}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Có Giá ${price} Và Bảng Giá ${list_pricebook} Với ${list_price} 
    ${product_info}=    Lấy thông tin thuốc từ danh mục thuốc    1
    ${manufacturer_info}=    Lấy thông tin hãng sản xuất nhà thuốc  ${product_info[7]}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    TGTK${random_code}
    ${request}=    Deep Copy     ${list_product_data}
    ${request}    Update Dictionary Property    ${request}    Code    ${product_code}
    ${request}    Update Dictionary Property    ${request}    Price    ${price}
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
    ${request}    Update Dictionary Property    ${request}    RouteOfAdministration   Đường Miệng
    ${request}    Update Dictionary Property    ${request}    GlobalManufacturerCountryId    2
    ${request_pricebook}    Create List
    FOR    ${item}  ${price}   IN ZIP    ${list_pricebook}    ${list_price}
        ${id_pricebook}=    Get Pricebook Id    ${item}
        ${price_body}     Deep Copy    ${Pricebook_body_standard}    
        ${price_body}    Update Dictionary Property    ${price_body}    PriceBookId    ${id_pricebook}
        ${price_body}    Update Dictionary Property    ${price_body}    Price    ${price}
        ${price_body}    Update Dictionary Property    ${price_body}    Name    ${item}
        Append To List    ${request_pricebook}    ${price_body}
    END
    ${request}    Update Dictionary Property    ${request}    ListPriceBookDetail    ${request_pricebook}
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}   
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request}

    
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    


