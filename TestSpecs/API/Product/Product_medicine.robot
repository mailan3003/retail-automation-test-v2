*** Settings ***
Documentation     Test API tạo sản phẩm
Resource          ../../../Keywords/Product/CreateProductKeywords.robot
Resource          ../../../Keywords/Product/InputValidationKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Config/Env_api.robot



*** Variables ***
@{value_attribute_1}   L  M   S
&{dict_attribute_name_1}    SIZE=@{value_attribute_1}
@{name_unit}     hai    nửa
@{value}    2    3
*** Test Cases ***

RT-PRODUCT-008 Tạo Sản Phẩm Là Thuốc
    [Documentation]    Test tạo sản phẩm là thuốc với thông tin đầy đủ theo yêu cầu GPP
    [Tags]    AIGenerated    CreateProduct    Positive    Medicine   
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Là Thuốc
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Tự Động Được Cấu Hình Quản Lý Lô Và Hạn Sử Dụng

RT-PRODUCT-009 Tạo Sản Phẩm Thuốc Có Nhiều Đơn Vị Tính
    [Documentation]    Test tạo sản phẩm là thuốc với nhiều đơn vị tính (hộp, vỉ, viên)
    [Tags]    AIGenerated    CreateProduct    Positive    Medicine   Positive4354434
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Có Nhiều Đơn Vị Tính
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Đơn Vị Tính Của Sản Phẩm Thuốc Được Tạo Chính Xác

RT-PRODUCT-010 Tạo Sản Phẩm Thuốc Với Giới Hạn Tồn Kho
    [Documentation]    Test tạo sản phẩm là thuốc với cấu hình giới hạn tồn kho tối thiểu và tối đa
    [Tags]    AIGenerated    CreateProduct    Positive    Medicine
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Giới Hạn Tồn Kho
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Có Giới Hạn Tồn Kho Tối Thiểu 10 Và Tối Đa 100 Ở Chi Nhánh Chi trung

RT-PRODUCT-011 Tạo Sản Phẩm Thuốc Với Thuế
    [Documentation]    Test tạo sản phẩm là thuốc với thuế 5%
    [Tags]    AIGenerated    CreateProduct    Positive    Medicine
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Thuế
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Có Thuế 5 Theo Dữ Liệu Đã Gửi

RT-PRODUCT-012 Tạo Sản Phẩm Thuốc Ngừng Kinh Doanh
    [Documentation]    Test tạo sản phẩm là thuốc với trạng thái ngừng kinh doanh
    [Tags]    AIGenerated    CreateProduct    Positive    Medicine
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Ngừng Kinh Doanh
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Có Trạng Thái Ngừng Kinh Doanh

RT-PRODUCT-013 Tạo Sản Phẩm Thuốc Với Tồn Kho Ban Đầu
    [Documentation]    Test tạo sản phẩm là thuốc với tồn kho ban đầu là 20
    [Tags]    AIGenerated    CreateProduct    Positive    Medicine
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Tồn Kho Ban Đầu 20
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Có Tồn Kho Ban Đầu 20

RT-PRODUCT-014 Tạo Sản Phẩm Thuốc Không Thành Công Khi Trùng Mã Sản Phẩm
    [Documentation]    Test tạo sản phẩm là thuốc thất bại khi trùng mã sản phẩm đã tồn tại
    [Tags]    AIGenerated    CreateProduct    Negative    Medicine
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Mã Trùng Lặp
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Mã hàng đã tồn tại"

*** Keywords ***
Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Có Nhiều Đơn Vị Tính
    ${product_info}=    Lấy thông tin thuốc từ danh mục thuốc    1
    ${manufacturer_info}=    Lấy thông tin hãng sản xuất nhà thuốc  ${product_info[7]}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    TDV${random_code}
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
    
    # Thêm nhiều đơn vị tính
    ${unit1}=    Create Dictionary    Unit=Hộp    ConversionValue=1
    ${unit2}=    Create Dictionary    Unit=Vỉ    ConversionValue=10
    ${unit3}=    Create Dictionary    Unit=Viên    ConversionValue=100
    ${product_units}=    Create List    ${unit1}    ${unit2}    ${unit3}
    ${request}    Update Dictionary Property    ${request}    ProductUnits    ${product_units}
    
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request}

Xác Thực Đơn Vị Tính Của Sản Phẩm Thuốc Được Tạo Chính Xác
    ${query}=    Set Variable    SELECT COUNT(*) FROM ProductUnit WHERE ProductId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy đơn vị tính cho sản phẩm thuốc
    Should Be Equal As Numbers    ${result[0]}    3    Số lượng đơn vị tính không chính xác
    
    ${query_units}=    Set Variable    SELECT Unit, ConversionValue FROM ProductUnit WHERE ProductId = ? ORDER BY ConversionValue ASC
    ${results}=    Fetch All    ${query_units}    ${CREATED_PRODUCT_ID}
    Should Be Equal As Strings    ${results[0][0]}    Viên    Đơn vị viên không được tạo
    Should Be Equal As Numbers    ${results[0][1]}    100    Giá trị quy đổi của viên không chính xác
    
    Should Be Equal As Strings    ${results[1][0]}    Vỉ    Đơn vị vỉ không được tạo
    Should Be Equal As Numbers    ${results[1][1]}    10    Giá trị quy đổi của vỉ không chính xác
    
    Should Be Equal As Strings    ${results[2][0]}    Hộp    Đơn vị hộp không được tạo
    Should Be Equal As Numbers    ${results[2][1]}    1    Giá trị quy đổi của hộp không chính xác

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

Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Thuế
    ${product_info}=    Lấy thông tin thuốc từ danh mục thuốc    1
    ${manufacturer_info}=    Lấy thông tin hãng sản xuất nhà thuốc  ${product_info[7]}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    TTAX${random_code}
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
    ${request}    Update Dictionary Property    ${request}    TaxId    2
    
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
    ${request}    Update Dictionary Property    ${request}    OnHand    20
    
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${request}
    
Xác Thực Sản Phẩm Có Tồn Kho Ban Đầu 20
    ${query}=    Set Variable    SELECT OnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}    ${DEFAULT_BRANCH_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin tồn kho của sản phẩm
    Should Be Equal As Numbers    ${result[0]}    20    Tồn kho ban đầu không chính xác

Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Mã Trùng Lặp
    ${existing_product}=    Fetch One    ${QUERY_GET_PRODUCT_BY_RETAILER}    ${RETAILER_ID}
    Should Not Be Equal    ${existing_product}    None    Không tìm thấy sản phẩm để test trùng lặp mã
    ${product_code}=    Set Variable    ${existing_product[1]}
    
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

