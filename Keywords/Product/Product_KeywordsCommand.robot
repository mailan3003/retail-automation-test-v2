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
Library           String

*** Variables ***
${PRODUCT_API_ENDPOINT}     products/addmany
${WARRANTY_API_SAVE_ENDPOINT}    warranty/save
${PRODUCT_UPDATE_API_ENDPOINT}   api/products/photo
${PRODUCT_DELETE_API_ENDPOINT}   api/products/{0}
${REQUEST_FILES}    ${None}

*** Keywords ***
# Tạo request  
Gửi Yêu Cầu Tạo Sản Phẩm
    ${response}=    Call API With Form Data    ${PRODUCT_API_ENDPOINT}    ${REQUEST_DATA}    ${REQUEST_FILES}
    Set Test Variable    ${RESPONSE}    ${response}
    IF    '${RESPONSE.status_code}' == '200'
        ${product_id}=    Set Variable     ${RESPONSE.json()["Data"][0]["Id"]}
        ${product_code}=    Set Variable    ${RESPONSE.json()["Data"][0]["Code"]}
        Set Test Variable    ${CREATED_PRODUCT_ID}    ${product_id}
        Set Test Variable    ${CREATED_PRODUCT_CODE}    ${product_code}
    END
    RETURN    ${response}
 
Tạo danh sách tổ hợp thuộc tính
    [Arguments]    ${dict_attribute_name}
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
    RETURN    ${combinations}    ${attribute_names}
 
Lấy Thông tin Chi Nhánh
    [Arguments]    ${name_branch}
    ${query}=    Set Variable    SELECT Id FROM Branch WHERE Name = ?
    ${result}=    Fetch One    ${query}     ${name_branch}
    RETURN    ${result[0]}

Lấy thông tin thuốc từ danh mục thuốc
    [Arguments]    ${product_id}
    ${query}=    Set Variable    SELECT Id,Code,Name,RegistrationNo,ActiveElement,Content,PackagingSize,GlobalManufacturerId FROM GlobalMedicine WHERE Id=?
    ${result}=    Select One Master    ${query}    ${product_id}
    RETURN    ${result}

Lấy thông tin hãng sản xuất nhà thuốc
    [Arguments]    ${manufacturer_id}
    ${query}=    Set Variable    SELECT Id, Name FROM GlobalManufacturer WHERE Id = ?
    ${result}=    Select One Master    ${query}    ${manufacturer_id}
    RETURN    ${result}

Lấy ID thuộc tính  
    [Arguments]    ${attribute_name}
    ${query}=    Set Variable    SELECT Id FROM Attribute WHERE Name=? AND RetailerId= ?
    ${result}=    Fetch One    ${query}     ${attribute_name}    ${RETAILER_ID}
    RETURN    ${result[0]}
# Validate 
Xác Thực Sản Phẩm Có Ghi Chú Đặt Hàng
    ${query}=    Set Variable    SELECT OrderTemplate FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin ghi chú đặt hàng cho sản phẩm đã tạo
    Should Be Equal    ${result[0]}    ${RANDOM_GHICHU}

Xác Thực Sản Phẩm Có Mô Tả Ghi Chú
    ${query}=    Set Variable    SELECT Description FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin mô tả ghi chú cho sản phẩm đã tạo
    Should Be Equal    ${result[0]}    ${RANDOM_GHICHU}

Xác Thực Sản Phẩm Có Giá Vốn ${cost} Ở Chi Nhánh ${branch_name}
    ${branch_id}   Lấy Thông tin Chi Nhánh    ${branch_name}
    ${query}=    Set Variable    SELECT Cost FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}    ${branch_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin giá vốn
    Should Be Equal As Numbers    ${result[0]}    ${cost}

Xác Thực Sản Phẩm Có Trọng Lượng ${weight} Kg
    ${query}=    Set Variable    SELECT Weight FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin trọng lượng
    Should Be Equal As Numbers    ${result[0]}    ${weight}

Xác Thực Sản Phẩm Có Thương Hiệu Đúng
    ${query}=    Set Variable    SELECT TradeMarkId FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin thương hiệu
    Should Be Equal As Strings    ${result[0]}    ${BRAND_ID}

Xác Thực Sản Phẩm Có Vị Trí Lưu Trữ Đúng
    ${query}=    Set Variable    SELECT COUNT(*) FROM ProductShelves WHERE ProductId = ? AND ShelvesId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}    ${SHELF_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin vị trí lưu trữ
    Should Be True    ${result[0]} > 0



Xác Thực Sản Phẩm Có Loại Là Hàng Sản Xuất Và Có Hàng ${product_material_id} Với Số Lượng ${product_material_quantity} 
    ${query}=    Set Variable    SELECT ProductType FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    Should Be Equal As Numbers    ${result[0]}    2    # 2 là loại hàng sản xuất
    ${product_material_quantity}   Convert To Number   ${product_material_quantity}
    ${query_1}=    Set Variable    SELECT MaterialId, Quantity FROM ProductFormula WHERE ProductId = ?
    ${result1}=    Fetch One    ${query_1}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result1}    None    Không tìm thấy thành phần cho sản phẩm combo đã tạo
    Should Be Equal As Strings    ${result1[0]}   ${product_material_id}
    Should Be Equal As Numbers    ${result1[1]}    ${product_material_quantity}


Xác Thực Tên Sản Phẩm Được Chuẩn Hóa Đúng
    ${query}=    Set Variable    SELECT Name FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    ${normalized_name}=    Set Variable    ${result[0]}
    
    # Kiểm tra tên có được chuẩn hóa đúng
    # Tên có thể sẽ được chuẩn hóa nhưng vẫn giữ nội dung chính
    Should Contain    ${normalized_name}    Sản phẩm
    Should Contain    ${normalized_name}    Tiếng Việt

# Thêm các keywords đang bị lỗi
Xác Thực Sản Phẩm Có Loại Là Dịch Vụ
    ${query}=    Set Variable    SELECT ProductType FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    Should Be Equal As Numbers    ${result[0]}    3    # 3 là loại dịch vụ


Xác Thực Sản Phẩm Có Kích Thước ${width}x${height} ${unit}
    ${unit}    Run Keyword If    "${unit}" == "cm"    Set Variable    1    ELSE IF    "${unit}" == "m"
    ...   Set Variable    2   ELSE    Set Variable    0
    ${result}=    Lấy thông tin kích thước sản phẩm    ${CREATED_PRODUCT_ID}
    Should Be Equal As Numbers    ${result[0]}    ${width}
    Should Be Equal As Numbers    ${result[1]}    ${height}
    Should Be Equal As Numbers    ${result[2]}    ${unit}


Xác Thực Sản Phẩm ${list_product_code} Có Kích Thước ${width}x${height} ${unit}
    ${unit}    Run Keyword If    "${unit}" == "cm"    Set Variable    1    ELSE IF    "${unit}" == "m"
    ...   Set Variable    2   ELSE    Set Variable    0
    FOR    ${product_code}    IN    @{list_product_code}
        ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
        ${result}=    Lấy thông tin kích thước sản phẩm    ${product_id}
        Should Be Equal As Numbers    ${result[0]}    ${width}
        Should Be Equal As Numbers    ${result[1]}    ${height}
        Should Be Equal As Numbers    ${result[2]}    ${unit}
    END

Lấy thông tin kích thước sản phẩm
    [Arguments]    ${product_id}
    ${query}=    Set Variable    SELECT Attribute1, Attribute2, Type2 FROM ProductExtraMaterial WHERE ProductId = ?
    ${result}=    Fetch One    ${query}    ${product_id}
    RETURN    ${result}

Xác Thực Sản Phẩm Có Hình Ảnh Được Lưu Trữ
    ${query}=    Set Variable    SELECT COUNT(*) FROM ProductImage WHERE ProductId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin hình ảnh cho sản phẩm đã tạo
    Should Be True    ${result[0]} > 0

Xác Thực Sản Phẩm Có Thời Gian Bảo Hành ${month} Tháng
    ${query}=    Set Variable    SELECT NumberTime, TimeType FROM GenuineGuarantee WHERE ProductId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin bảo hành cho sản phẩm đã tạo
    Should Be Equal As Numbers    ${result[0]}    ${month}
    Should Be Equal As Numbers    ${result[1]}    2


Xác Thực Sản Phẩm Có Tích Điểm Thưởng
    ${query}=    Set Variable    SELECT IsRewardPoint FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    Should Be Equal As Strings    ${result[0]}    True
Xác Thực Sản Phẩm Có Giá Bán ${price}
    ${query}=    Set Variable    SELECT BasePrice FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    Should Be Equal As Numbers    ${result[0]}    ${price}

Xác Thực Sản Phẩm Có Giới Hạn Tồn Kho Tối Thiểu ${min_stock} Và Tối Đa ${max_stock} Ở Chi Nhánh ${branch_name}
    ${branch_id}   Lấy Thông tin Chi Nhánh    ${branch_name}
    ${query}=    Set Variable    SELECT MinQuantity, MaxQuantity FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}    ${branch_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    Should Be Equal As Numbers    ${result[0]}    ${min_stock}
    Should Be Equal As Numbers    ${result[1]}    ${max_stock}


Xác Thực Sản Phẩm Có Trạng Thái Ngừng Kinh Doanh
    ${query}=    Set Variable    SELECT IsActive FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    Should Be Equal As Strings    ${result[0]}    0

Xác Thực Sản Phẩm Được Cấu Hình Quản Lý Lô Và Hạn Sử Dụng
    ${query}=    Set Variable    SELECT IsBatchExpireControl FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    Should Be Equal As Strings    ${result[0]}    True

Xác Thực Sản Phẩm Được Cấu Hình Quản Lý Serial
    ${query}=    Set Variable    SELECT IsLotSerialControl FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    Should Be Equal As Strings    ${result[0]}    True

Xác Thực Sản Phẩm Có ${list_product_code} Được Tạo Ra 
    FOR    ${code}    IN    @{list_product_code}
        ${product_id}=    Lấy Thông tin Sản Phẩm    ${code}
        ${query2}=    Set Variable    SELECT AttributeId, Value FROM ProductAttribute WHERE ProductId = ?
        ${result2}=    Fetch One    ${query2}    ${product_id}
        Should Not Be Equal    ${result2}    None    Không tìm thấy thuộc tính cho sản phẩm đã tạo
    END

Xác Thực Sản Phẩm Có ${list_product_code} Được Tạo Ra Có ${dict_attribute_name}
    ${combinations}    ${attribute_names}=    Tạo danh sách tổ hợp thuộc tính    ${dict_attribute_name}
    FOR    ${index}    ${code}    IN ENUMERATE    @{list_product_code}
        ${product_id}=    Lấy Thông tin Sản Phẩm    ${code}
        ${query2}=    Set Variable    SELECT AttributeId, Value FROM ProductAttribute WHERE ProductId = ?
        ${result2}=    Fetch All   ${query2}    ${product_id}
        Should Not Be Equal    ${result2}    None    Không tìm thấy thuộc tính cho sản phẩm đã tạo
        
        # Lấy combination tương ứng với sản phẩm hiện tại
        ${combination}=    Get From List    ${combinations}    ${index}
        ${combination_values}=    Split String    ${combination}    |
        
        # Kiểm tra từng thuộc tính trong kết quả truy vấn
        FOR    ${attr_result}    IN    @{result2}
            ${attr_id}=    Set Variable    ${attr_result[0]}
            ${attr_value}=    Set Variable    ${attr_result[1]}
            # Kiểm tra giá trị thuộc tính có nằm trong combination không
            Should Contain    ${combination}    ${attr_value}    Giá trị thuộc tính ${attr_value} không khớp với tổ hợp thuộc tính
        END
    END

Xác Thực Sản Phẩm Có ${List_product_code} Được Tạo Ra Có Đơn Vị ${list_unit} Và ${list_value}
    FOR    ${code}    ${unit}    ${value}    IN ZIP    ${List_product_code}    ${list_unit}    ${list_value}
        ${value}     Convert To Number      ${value}
        ${query}=    Set Variable    SELECT Id, Unit, ConversionValue FROM Product WHERE Code = ?
        ${result}=    Fetch One    ${query}    ${code}
        Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
        Should Be Equal As Strings    ${result[1]}    ${unit}
        Should Be Equal As Numbers    ${result[2]}    ${value}
    END

    

Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    ${query}=    Set Variable    SELECT * FROM ProductMedicine WHERE ProductId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm thuốc đã tạo trong database

Xác Thực Sản Phẩm Tự Động Được Cấu Hình Quản Lý Lô Và Hạn Sử Dụng
    ${query}=    Set Variable    SELECT IsBatchExpireControl FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm thuốc đã tạo trong database
    Should Be Equal As Strings    ${result[0]}    True



# Keywords xác thực kết quả
Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    ${query}=    Set Variable    SELECT Id, Code, Name FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    Set Test Variable    ${DB_PRODUCT_ID}    ${result[0]}
    Set Test Variable    ${DB_PRODUCT_CODE}    ${result[1]}
    Set Test Variable    ${DB_PRODUCT_NAME}    ${result[2]}

Xác Thực Sản Phẩm Có Thông Tin Chính Xác Theo Dữ Liệu Đã Gửi
    Should Be Equal As Strings    ${DB_PRODUCT_CODE}    ${REQUEST_DATA["ListProductsString"][0]["Code"]}
    Should Be Equal As Strings    ${DB_PRODUCT_NAME}    ${REQUEST_DATA["ListProductsString"][0]["Name"]}

Xác Thực Sản Phẩm Được Tạo Với Mã Tự Sinh
    Should Not Be Empty    ${DB_PRODUCT_CODE}

Xác Thực Sản Phẩm Con Được Tạo Với Đúng Tỷ Lệ Quy Đổi ${conversion_value}
    ${query}=    Set Variable    SELECT Id FROM Product WHERE MasterProductId = ?
    ${results}=    Fetch All    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Empty    ${results}    Không tìm thấy sản phẩm con cho sản phẩm cha đã tạo
    
    FOR    ${result}    ${code}    ${item_value}  IN ZIP    ${results}      ${LIST_PRODUCT_CODE}     ${conversion_value}
        ${child_id}=    Set Variable    ${result[0]}
        ${unit_query}=    Set Variable    SELECT ConversionValue FROM Product WHERE Code = ?
        ${unit_result}=    Fetch One    ${unit_query}    ${code}
        ${item_value}=    Convert To Number    ${item_value}
        Should Be Equal As Numbers    ${unit_result[0]}    ${item_value}
    END
#dakho   
Xác Thực Sản Phẩm Có Tồn Kho ${on_hand} Ở Chi Nhánh ${name_branch}
    ${branch_id}=    Lấy Thông tin Chi Nhánh    ${name_branch}
    Wait Until Keyword Succeeds    10x    1s    Thông tin tồn kho sản phẩm    ${CREATED_PRODUCT_ID}    ${branch_id}    ${on_hand}

Thông tin tồn kho sản phẩm 
    [Arguments]    ${product_id}    ${branch_id}    ${on_hand}
    ${query}=    Set Variable    SELECT OnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${branch_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin tồn kho cho sản phẩm đã tạo
    Should Be Equal As Numbers    ${result[0]}    ${on_hand}

Tồn Kho ${onhand} và ${total_onhand} của ${product_id}
    ${query}=    Set Variable    SELECT OnHand, TotalOnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${branch_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin tồn kho cho sản phẩm đã tạo
    Should Be Equal As Numbers    ${result[0]}    ${onhand}
    Should Be Equal As Numbers    ${result[1]}    ${total_onhand}


Xác Thực Sản Phẩm Ở Kho Bán Hàng Có Tồn Kho ${onhand} Và ${total_onhand}
   Wait Until Keyword Succeeds    10x    1s    Tồn Kho ${onhand} và ${total_onhand} của ${CREATED_PRODUCT_ID} 

Xác Thực Sản Phẩm ${list_product_code} Ở Kho Bán Hàng Có Tồn Kho ${list_onhand} Và ${list_total_onhand}
  FOR    ${product_code}    ${onhand}    ${total_onhand}    IN ZIP    ${list_product_code}    ${list_onhand}    ${list_total_onhand}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    Wait Until Keyword Succeeds    10x    1s    Tồn Kho ${onhand} và ${total_onhand} của ${product_id} 
  END

Xác Thực Sản Phẩm ${list_product_code} Tồn ${list_onhand} Ở Kho ${list_name_branch}
  FOR     ${product_code}    ${index}    IN ENUMERATE    ${list_product_code}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}[${index}]
    ${ton_kho_list}=    Get From List    ${list_onhand}   ${index}
    ${ton_kho_values}=    Split String    ${ton_kho_list}    ,
    FOR    ${ton_kho_value}    ${name_branch}    IN ZIP    ${ton_kho_values}    ${list_name_branch}
    ${branch_id}=    Lấy Thông tin Chi Nhánh    ${name_branch}
    Wait Until Keyword Succeeds    10x    1s    Tồn Kho ${ton_kho_value} của ${product_id} Ở Chi Nhánh ${branch_id}
    END
  END

Lấy Thông tin Sản Phẩm  
    [Arguments]    ${product_code}
    ${query}=    Set Variable    SELECT Id FROM Product WHERE Code = ?
    ${result}=    Fetch One    ${query}    ${product_code}
    RETURN    ${result[0]}

Xác Thực Tất Cả Sản Phẩm ${list_product_code} Có Thuế ${tax_rate} %
    ${tax_ID}     Run Keyword If  '${tax_rate}'=='0'     Set Variable    1
    ...     ELSE IF   '${tax_rate}'=='5'     Set Variable    2
    ...     ELSE IF   '${tax_rate}'=='8'     Set Variable    3
    ...     ELSE IF   '${tax_rate}'=='10'     Set Variable    4
    ...     ELSE IF   '${tax_rate}'=='Không chịu thuế'     Set Variable   5
    
    FOR    ${code}    IN    @{list_product_code}
        ${query}=    Set Variable    SELECT p.Id FROM Product p JOIN ProductTax t ON p.Id = t.Id WHERE p.Code = ? AND t.TaxId = ?
        ${result}=    Fetch One    ${query}    ${code}    ${tax_ID}
        Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm ${code} với thuế ${tax_rate}% trong database
    END

Xác Thực Sản Phẩm Có Thuế ${tax_rate} Theo Dữ Liệu Đã Gửi
    ${tax_ID}     Run Keyword If  '${tax_rate}'=='0'     Set Variable    1
    ...     ELSE IF   '${tax_rate}'=='5'     Set Variable    2
    ...     ELSE IF   '${tax_rate}'=='8'     Set Variable    3
    ...     ELSE IF   '${tax_rate}'=='10'     Set Variable    4
    ...     ELSE IF   '${tax_rate}'=='Không chịu thuế'     Set Variable   5
    ${query}=    Set Variable    SELECT TaxId FROM ProductTax WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin thuế cho sản phẩm đã tạo
    Should Be Equal As Strings    ${result[0]}     ${tax_ID}  

Xác Thực Sản Phẩm Combo Có Chứa Các Thành Phần ${product_material_id} Với Số Lượng ${product_material_quantity} 
    ${query}=    Set Variable    SELECT MaterialId, Quantity FROM ProductFormula WHERE ProductId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thành phần cho sản phẩm combo đã tạo
    Should Be Equal As Strings    ${result[0]}   ${product_material_id}
    Should Be Equal As Numbers    ${result[1]}    ${product_material_quantity}
Xác Thực Lỗi "${error_message}"
    Should Be Equal As Strings    ${RESPONSE.status_code}    420
    Should Contain    ${RESPONSE.text}    ${error_message} 

