*** Settings ***
Documentation     Test API tạo sản phẩm
Resource          ../../../Keywords/Product/CreateProductKeywords.robot
Resource          ../../../Keywords/Product/InputValidationKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot



*** Variables ***
@{value_attribute_1}   L  M   S
&{dict_attribute_name_1}    SIZE=@{value_attribute_1}
@{name_unit}     hai    nửa
@{value}    2    3
@{tax_rates}    0    5    8    10    Không chịu thuế
@{invalid_tax_ids}    999    -1    0
*** Test Cases ***


RT-PRODUCT-009 Tạo Sản Phẩm Với Thuế
    [Documentation]    Test tạo sản phẩm có thuế
    [Tags]    AIGenerated    CreateProduct    Positive     
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế 5 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế Theo Dữ Liệu Đã Gửi

RT-PRODUCT-010 Tạo Sản Phẩm Với Thuế 0%
    [Documentation]    Test tạo sản phẩm có thuế 0%
    [Tags]    AIGenerated    CreateProduct    Positive    VAT
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế 0 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế 0 Theo Dữ Liệu Đã Gửi

RT-PRODUCT-011 Tạo Sản Phẩm Với Thuế 8%
    [Documentation]    Test tạo sản phẩm có thuế 8%
    [Tags]    AIGenerated    CreateProduct    Positive    VAT
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế 8 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế 8 Theo Dữ Liệu Đã Gửi

RT-PRODUCT-012 Tạo Sản Phẩm Với Thuế 10%
    [Documentation]    Test tạo sản phẩm có thuế 10%
    [Tags]    AIGenerated    CreateProduct    Positive    VAT
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế 10 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế 10 Theo Dữ Liệu Đã Gửi

RT-PRODUCT-013 Tạo Sản Phẩm Không Chịu Thuế
    [Documentation]    Test tạo sản phẩm không chịu thuế
    [Tags]    AIGenerated    CreateProduct    Positive    VAT
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế Không chịu thuế %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế Không chịu thuế Theo Dữ Liệu Đã Gửi

RT-PRODUCT-014 Tạo Nhiều Sản Phẩm Với Các Mức Thuế Khác Nhau
    [Documentation]    Test tạo nhiều sản phẩm với các mức thuế khác nhau
    [Tags]    AIGenerated    CreateProduct    Positive    VAT    Template
    [Template]    Tạo Sản Phẩm Và Xác Thực Thuế
    # tax_rate
    0 %
    5 %
    8 %
    10 %
    Không chịu thuế %

RT-PRODUCT-015 Tạo Sản Phẩm Dịch Vụ Với Thuế
    [Documentation]    Test tạo sản phẩm dịch vụ có thuế
    [Tags]    AIGenerated    CreateProduct    Positive    VAT    Service
    Given Chuẩn Bị Dữ Liệu Hàng Dịch Vụ Với Thuế 5 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế 5 Theo Dữ Liệu Đã Gửi
    And Xác Thực Sản Phẩm Có Loại Là Dịch Vụ

RT-PRODUCT-016 Cập Nhật Thuế Cho Sản Phẩm
    [Documentation]    Test cập nhật mức thuế cho sản phẩm đã tạo
    [Tags]    AIGenerated    CreateProduct    Positive    VAT    Update
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế 5 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Có Thuế 5 Theo Dữ Liệu Đã Gửi
    When Chuẩn Bị Dữ Liệu Cập Nhật Thuế 10 % Cho Sản Phẩm
    And Gửi Yêu Cầu Cập Nhật Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Có Thuế 10 Theo Dữ Liệu Đã Gửi

RT-PRODUCT-017 Tạo Sản Phẩm Với Mã Thuế Không Hợp Lệ
    [Documentation]    Test tạo sản phẩm với mã thuế không tồn tại
    [Tags]    AIGenerated    CreateProduct    Negative    VAT    InvalidData
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Mã Thuế Không Hợp Lệ 999
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Mã thuế không tồn tại"

RT-PRODUCT-018 Tạo Sản Phẩm Combo Với Thuế
    [Documentation]    Test tạo sản phẩm combo có thuế
    [Tags]    AIGenerated    CreateProduct    Positive    VAT    Combo
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Combo Với Thuế 10 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế 10 Theo Dữ Liệu Đã Gửi
    And Xác Thực Sản Phẩm Có Loại Là Combo

RT-PRODUCT-019 Cập Nhật Thuế Sản Phẩm Không Tồn Tại
    [Documentation]    Test cập nhật thuế với sản phẩm không tồn tại
    [Tags]    AIGenerated    CreateProduct    Negative    VAT    InvalidData
    Given Chuẩn Bị Dữ Liệu Cập Nhật Thuế Cho Sản Phẩm Không Tồn Tại
    When Gửi Yêu Cầu Cập Nhật Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Không tìm thấy sản phẩm"

RT-PRODUCT-020 Cập Nhật Thuế Không Hợp Lệ Cho Sản Phẩm
    [Documentation]    Test cập nhật mã thuế không hợp lệ
    [Tags]    AIGenerated    CreateProduct    Negative    VAT    InvalidData
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế 5 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    When Chuẩn Bị Dữ Liệu Cập Nhật Thuế Không Hợp Lệ Cho Sản Phẩm
    And Gửi Yêu Cầu Cập Nhật Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Mã thuế không tồn tại"

RT-PRODUCT-021 Tạo Sản Phẩm Thuốc Với Thuế
    [Documentation]    Test tạo sản phẩm thuốc có thuế
    [Tags]    AIGenerated    CreateProduct    Positive    VAT    Medicine
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Thuế 5 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế 5 Theo Dữ Liệu Đã Gửi
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác

RT-PRODUCT-022 Tạo Sản Phẩm Với Thuế và Đơn Vị Quy Đổi
    [Documentation]    Test tạo sản phẩm có thuế và đơn vị quy đổi
    [Tags]    AIGenerated    CreateProduct    Positive    VAT    Units
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế 10 % Và Đơn Vị Quy Đổi
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế 10 Theo Dữ Liệu Đã Gửi
    And Xác Thực Sản Phẩm Con Được Tạo Với Đúng Tỷ Lệ Quy Đổi ${value}

RT-PRODUCT-023 Tạo Sản Phẩm Với Thuế và Thuộc Tính
    [Documentation]    Test tạo sản phẩm có thuế và thuộc tính
    [Tags]    AIGenerated    CreateProduct    Positive    VAT    Attributes
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế 5 % Và Thuộc Tính
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có ${LIST_PRODUCTS_CODE} Được Tạo Ra
    And Xác Thực Tất Cả Sản Phẩm Con Có Thuế 5 %

*** Keywords ***
Tạo Sản Phẩm Và Xác Thực Thuế
    [Arguments]    ${tax_rate}
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế ${tax_rate}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    ${clean_rate}=    Remove String    ${tax_rate}    %
    And Xác Thực Sản Phẩm Có Thuế ${clean_rate} Theo Dữ Liệu Đã Gửi

Chuẩn Bị Dữ Liệu Hàng Dịch Vụ Với Thuế ${tax_rate} %
    ${tax_ID}     Run Keyword If  '${tax_rate}'=='0'     Set Variable    1
    ...     ELSE IF   '${tax_rate}'=='5'     Set Variable    2
    ...     ELSE IF   '${tax_rate}'=='8'     Set Variable    3
    ...     ELSE IF   '${tax_rate}'=='10'     Set Variable    4
    ...     ELSE IF   '${tax_rate}'=='Không chịu thuế'     Set Variable   5
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    DV${random_code}
    ${request}    Update Dictionary Property    ${request}    ProductType    3
    ${request}    Update Dictionary Property    ${request}    TaxId     ${tax_ID}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}        BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Cập Nhật Thuế ${tax_rate} % Cho Sản Phẩm
    ${tax_ID}     Run Keyword If  '${tax_rate}'=='0'     Set Variable    1
    ...     ELSE IF   '${tax_rate}'=='5'     Set Variable    2
    ...     ELSE IF   '${tax_rate}'=='8'     Set Variable    3
    ...     ELSE IF   '${tax_rate}'=='10'     Set Variable    4
    ...     ELSE IF   '${tax_rate}'=='Không chịu thuế'     Set Variable   5
    ${request}=    Create Dictionary    ProductId=${CREATED_PRODUCT_ID}    TaxId=${tax_ID}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${REQUEST_DATA}

Gửi Yêu Cầu Cập Nhật Sản Phẩm
    ${response}=    Call API    products/updatetax    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}

Xác Thực Sản Phẩm Có Loại Là Dịch Vụ
    ${query}=    Set Variable    SELECT ProductType FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    Should Be Equal As Strings    ${result[0]}    3    Loại sản phẩm không phải là dịch vụ

Chuẩn Bị Dữ Liệu Sản Phẩm Với Mã Thuế Không Hợp Lệ ${invalid_tax_id}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    SP${random_code}
    ${request}    Update Dictionary Property    ${request}    TaxId     ${invalid_tax_id}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}          BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Combo Với Thuế ${tax_rate} %
    ${tax_ID}     Run Keyword If  '${tax_rate}'=='0'     Set Variable    1
    ...     ELSE IF   '${tax_rate}'=='5'     Set Variable    2
    ...     ELSE IF   '${tax_rate}'=='8'     Set Variable    3
    ...     ELSE IF   '${tax_rate}'=='10'     Set Variable    4
    ...     ELSE IF   '${tax_rate}'=='Không chịu thuế'     Set Variable   5
    ${request}=    Deep Copy     ${list_product_data}
    ${formula}=     Deep Copy    ${PRODUCT_FORMULAS}
    ${formula}    Create List    ${formula}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    CB${random_code}
    ${request}    Update Dictionary Property    ${request}    ProductType    1
    ${request}    Update Dictionary Property    ${request}    ProductFormulas    ${formula}
    ${request}    Update Dictionary Property    ${request}    TaxId     ${tax_ID}
    ${branch_pr_cost}     Evaluate     str(${branch_for_cost}).replace("'",'"')
    ${branch_pr_cost}     Evaluate    (None, '[${branch_pr_cost}]')
    ${form_data}=    Evaluate     str(${request}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProductsString=${list_products}    BranchForProductCostss=${branch_pr_cost}  
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Cập Nhật Thuế Cho Sản Phẩm Không Tồn Tại
    ${invalid_product_id}=    Set Variable    999999999
    ${request}=    Create Dictionary    ProductId=${invalid_product_id}    TaxId=2
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Cập Nhật Thuế Không Hợp Lệ Cho Sản Phẩm
    ${invalid_tax_id}=    Set Variable    999
    ${request}=    Create Dictionary    ProductId=${CREATED_PRODUCT_ID}    TaxId=${invalid_tax_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${REQUEST_DATA}

Xác Thực Sản Phẩm Có Loại Là Combo
    ${query}=    Set Variable    SELECT ProductType FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    Should Be Equal As Strings    ${result[0]}    1    Loại sản phẩm không phải là combo

Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Thuế ${tax_rate} %
    ${tax_ID}     Run Keyword If  '${tax_rate}'=='0'     Set Variable    1
    ...     ELSE IF   '${tax_rate}'=='5'     Set Variable    2
    ...     ELSE IF   '${tax_rate}'=='8'     Set Variable    3
    ...     ELSE IF   '${tax_rate}'=='10'     Set Variable    4
    ...     ELSE IF   '${tax_rate}'=='Không chịu thuế'     Set Variable   5
    ${product_info}=    Lấy thông tin thuốc từ danh mục thuốc    1
    ${manufacturer_info}=    Lấy thông tin hãng sản xuất nhà thuốc  ${product_info[7]}
    ${request}=    Deep Copy     ${list_product_data}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${request}    Update Dictionary Property    ${request}    Code    T${random_code}
    ${request}    Update Dictionary Property    ${request}    IsBatchExpireControl    true
    ${request}    Update Dictionary Property    ${request}    Name    ${product_info[2]}
    ${request}    Update Dictionary Property    ${request}    CategoryId    1000000751
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

Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế ${tax_rate} % Và Đơn Vị Quy Đổi
    ${tax_ID}     Run Keyword If  '${tax_rate}'=='0'     Set Variable    1
    ...     ELSE IF   '${tax_rate}'=='5'     Set Variable    2
    ...     ELSE IF   '${tax_rate}'=='8'     Set Variable    3
    ...     ELSE IF   '${tax_rate}'=='10'     Set Variable    4
    ...     ELSE IF   '${tax_rate}'=='Không chịu thuế'     Set Variable   5
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

Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế ${tax_rate} % Và Thuộc Tính
    ${tax_ID}     Run Keyword If  '${tax_rate}'=='0'     Set Variable    1
    ...     ELSE IF   '${tax_rate}'=='5'     Set Variable    2
    ...     ELSE IF   '${tax_rate}'=='8'     Set Variable    3
    ...     ELSE IF   '${tax_rate}'=='10'     Set Variable    4
    ...     ELSE IF   '${tax_rate}'=='Không chịu thuế'     Set Variable   5
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

Xác Thực Tất Cả Sản Phẩm Con Có Thuế ${tax_rate} %
    ${tax_ID}     Run Keyword If  '${tax_rate}'=='0'     Set Variable    1
    ...     ELSE IF   '${tax_rate}'=='5'     Set Variable    2
    ...     ELSE IF   '${tax_rate}'=='8'     Set Variable    3
    ...     ELSE IF   '${tax_rate}'=='10'     Set Variable    4
    ...     ELSE IF   '${tax_rate}'=='Không chịu thuế'     Set Variable   5
    
    FOR    ${code}    IN    @{LIST_PRODUCTS_CODE}
        ${query}=    Set Variable    SELECT p.Id FROM Product p JOIN ProductTax t ON p.Id = t.Id WHERE p.Code = ? AND t.TaxId = ?
        ${result}=    Fetch One    ${query}    ${code}    ${tax_ID}
        Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm ${code} với thuế ${tax_rate}% trong database
    END

