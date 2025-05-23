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
${PRODUCT_UPDATE_API_ENDPOINT}   products/photo
${PRODUCT_DELETE_API_ENDPOINT}   products/{0}
${REQUEST_FILES}    ${None}

*** Keywords ***
# Tạo request  
Gửi Yêu Cầu Tạo Sản Phẩm
    ${response}=    Call API With Form Data    ${API_MAN_URL}    ${PRODUCT_API_ENDPOINT}    ${REQUEST_DATA}    ${REQUEST_FILES}
    Set Test Variable    ${RESPONSE}    ${response}
    IF    '${RESPONSE.status_code}' == '200'
        ${product_id}=    Set Variable     ${RESPONSE.json()["Data"][0]["Id"]}
        ${product_code}=    Set Variable    ${RESPONSE.json()["Data"][0]["Code"]}
        Set Test Variable    ${CREATED_PRODUCT_ID}    ${product_id}
        Set Test Variable    ${CREATED_PRODUCT_CODE}    ${product_code}
    END
    RETURN    ${response}

Gửi Yêu Cầu Tạo Sản Phẩm Từ MHBH
    ${response}=    Call API With Form Data    ${API_URL}    ${PRODUCT_API_ENDPOINT}    ${REQUEST_DATA}    ${REQUEST_FILES}
    Set Test Variable    ${RESPONSE}    ${response}
    IF    '${RESPONSE.status_code}' == '200'
        ${product_id}=    Set Variable     ${RESPONSE.json()["Data"][0]["Id"]}
        ${product_code}=    Set Variable    ${RESPONSE.json()["Data"][0]["Code"]}
        Set Test Variable    ${CREATED_PRODUCT_ID}    ${product_id}
        Set Test Variable    ${CREATED_PRODUCT_CODE}    ${product_code}
    END
    RETURN    ${response}

Gửi Yêu Cầu Cập Nhật Sản Phẩm
    ${response}=    Call API With Form Data    ${API_MAN_URL}   ${PRODUCT_UPDATE_API_ENDPOINT}    ${REQUEST_DATA}    ${REQUEST_FILES}
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
    ${query}=    Set Variable    SELECT Id FROM Branch WHERE Name = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}     ${name_branch}    ${RETAILER_ID}
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
Xác Thực Sản Phẩm Có Ghi Chú Đặt Hàng ${note}
    ${query}=    Set Variable    SELECT OrderTemplate FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin ghi chú đặt hàng cho sản phẩm đã tạo
    Should Be Equal    ${result[0]}    ${note}

Xác Thực Sản Phẩm Có Mô Tả Ghi Chú ${note}
    ${query}=    Set Variable    SELECT Description FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin mô tả ghi chú cho sản phẩm đã tạo
    Should Be Equal    ${result[0]}    ${note}

Xác Thực Sản Phẩm Có Giá Vốn ${cost} Ở Chi Nhánh ${branch_name}
    ${branch_id}   Lấy Thông tin Chi Nhánh    ${branch_name}
    ${query}=    Set Variable    SELECT Cost FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}    ${branch_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin giá vốn
    Should Be Equal As Numbers    ${result[0]}    ${cost}

Lây thông tin giá vốn của sản phẩm 
    [Arguments]    ${product_id}    ${branch_name}
    ${branch_id}   Lấy Thông tin Chi Nhánh    ${branch_name}
    ${query}=    Set Variable    SELECT Cost FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${branch_id}
    RETURN    ${result[0]}

Xác Thực Sản Phẩm Có Trọng Lượng ${weight} ${unit}
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

Xác Thực Sản Phẩm Có Lưu Trữ ${list_shelves_id} Vị Trí
    FOR    ${shelves_id}    IN    @{list_shelves_id}
        ${query}=    Set Variable    SELECT COUNT(*) FROM ProductShelves WHERE ProductId = ? AND ShelvesId = ?
        ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}    ${shelves_id}
        Should Not Be Equal    ${result}    None    Không tìm thấy thông tin vị trí lưu trữ
        Should Be True    ${result[0]} > 0
    END

Xác Thực Sản Phẩm Có Trạng Thái ${status} Bán Trực Tiếp
    ${status}    Run Keyword If    "${status}" == "Không"    Set Variable    False    ELSE    Set Variable    True
    ${query}=    Set Variable    SELECT AllowsSale FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin trạng thái bán trực tiếp
    Should Be Equal As Strings    ${result[0]}    ${status}

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


Xác Thực Sản Phẩm Có Hàng Thành Phần ${dict_product_tp} Với Số Lượng ${list_quantity}
    FOR    ${product_material_id}    ${product_material_quantity}    IN ZIP    ${dict_product_tp}    ${list_quantity}
        ${product_material_quantity}   Convert To Number   ${product_material_quantity}
        ${query_1}=    Set Variable    SELECT MaterialId, Quantity FROM ProductFormula WHERE ProductId = ? AND MaterialId = ?
        ${result1}=    Fetch One    ${query_1}    ${CREATED_PRODUCT_ID}    ${product_material_id}
        Should Not Be Equal    ${result1}    None    Không tìm thấy thành phần cho sản phẩm combo đã tạo
        Should Be Equal As Strings    ${result1[0]}   ${product_material_id}
        Should Be Equal As Numbers    ${result1[1]}    ${product_material_quantity}
    END
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

Xác Thực Sản Phẩm Có Điểm Thưởng ${point}
    ${query}=    Set Variable    SELECT RewardPoint FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    Should Be Equal As Numbers    ${result[0]}    ${point}

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


Xác Thực Sản Phẩm Có Trạng Thái ${status} Kinh Doanh Ở Chi Nhánh ${branch_name}
    ${status}    Run Keyword If    "${status}" == "Ngừng"    Set Variable    False    ELSE    Set Variable    True
    ${branch_id}   Lấy Thông tin Chi Nhánh    ${branch_name}
    ${query}=    Set Variable    SELECT IsActive FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}    ${branch_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    Should Be Equal As Strings    ${result[0]}    ${status}

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
    ${query}=    Set Variable    SELECT RegistrationNo, ActiveElement, Content, PackagingSize, GlobalManufacturerName, GlobalManufacturerCountryName, GlobalManufacturerId, RouteOfAdministration, GlobalManufacturerCountryId FROM ProductMedicine WHERE ProductId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm thuốc đã tạo trong database
    ${product_info}=    Lấy thông tin thuốc từ danh mục thuốc    1
    ${manufacturer_info}=    Lấy thông tin hãng sản xuất nhà thuốc  ${product_info[7]}
    Should Be Equal As Strings    ${result[0]}    ${product_info[3]}
    Should Be Equal As Strings    ${result[1]}    ${product_info[4]}
    Should Be Equal As Strings    ${result[2]}    ${product_info[5]}
    Should Be Equal As Strings    ${result[3]}    ${product_info[6]}
    Should Be Equal As Strings    ${result[4]}    ${manufacturer_info[1]}
    Should Be Equal As Strings    ${result[5]}    Ấn Độ
    Should Be Equal As Strings    ${result[6]}    ${product_info[7]}
    Should Be Equal As Strings    ${result[7]}    Đường Miệng
    Should Be Equal As Strings    ${result[8]}    2
        

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
    ${query}=    Set Variable    SELECT Id, Code, Name, BasePrice,Unit FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    Should Be Equal As Strings    ${result[1]}    ${REQUEST_DATA["ListProductsString"][0]["Code"]}
    Should Be Equal As Strings    ${result[2]}    ${REQUEST_DATA["ListProductsString"][0]["Name"]}
    Should Be Equal As Numbers    ${result[3]}    ${REQUEST_DATA["ListProductsString"][0]["BasePrice"]}
    Should Be Equal As Strings    ${result[4]}    ${REQUEST_DATA["ListProductsString"][0]["Unit"]}


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

Xác Thực Sản Phẩm ${list_product_code} Có DVT ${list_value} Tồn Kho ${list_onhand} Ở ${list_name_branch}
    FOR    ${product_code}    ${on_hand}      ${value}      ${name_branch}    IN ZIP    ${list_product_code}    ${list_onhand}     ${list_value}        ${list_name_branch}
        ${branch_id}=    Lấy Thông tin Chi Nhánh    ${name_branch}
        ${onhand_values}=    Evaluate    round(${on_hand} / ${value}, 3)
        ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
        Wait Until Keyword Succeeds    10x    1s    Thông tin tồn kho sản phẩm    ${product_id}    ${branch_id}    ${onhand_values}
    END

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


Xác Thực Sản Phẩm ${list_product_code} Có DVT ${list_value} Tồn Kho ${onhand} Và ${total_onhand} Ở Kho Bán Hàng 
    FOR    ${product_code}      ${value}    IN ZIP  ${list_product_code}         ${list_value}
        ${onhand_values}=    Evaluate    round(${on_hand} / ${value}, 3)
        ${total_onhand_values}=    Evaluate    round(${total_onhand} / ${value}, 3)
        ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
        Wait Until Keyword Succeeds    10x    1s    Tồn Kho ${onhand_values} và ${total_onhand_values} của ${product_id} 
    END


Xác Thực Sản Phẩm Thuộc Tính ${list_product_code} Có DVT ${list_value} Tồn Kho ${list_onhand} Ở ${list_kho_hang}
    ${list_onhand_dvt}=    Create List
    FOR    ${onhand}    ${value}    IN ZIP    ${list_onhand}    ${list_value}
        ${onhand_dvt}=    Evaluate    round(${onhand} / ${value}, 3)
        Append To List    ${list_onhand_dvt}    ${onhand_dvt}
    END
    ${list_product_onhand_dvt}=    Combine Lists    ${list_onhand}    ${list_onhand_dvt}
    
    FOR    ${product_code}    ${on_hand}       ${name_branch}    IN ZIP   ${list_product_code}  ${list_product_onhand_dvt}         ${list_kho_hang}
        ${branch_id}=    Lấy Thông tin Chi Nhánh    ${name_branch}
        ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
        Wait Until Keyword Succeeds    10x    1s    Thông tin tồn kho sản phẩm    ${product_id}    ${branch_id}    ${on_hand}
    END
Xác Thực Sản Phẩm Ở Kho Bán Hàng Có Tồn Kho ${onhand} Và ${total_onhand}
   Wait Until Keyword Succeeds    10x    1s    Tồn Kho ${onhand} và ${total_onhand} của ${CREATED_PRODUCT_ID} 

Xác Thực Sản Phẩm ${list_product_code} Ở Kho Bán Hàng Có Tồn Kho ${onhand} Và ${total_onhand}
  FOR    ${product_code}     IN ZIP    ${list_product_code}   
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    Wait Until Keyword Succeeds    10x    1s    Tồn Kho ${onhand} và ${total_onhand} của ${product_id} 
  END

Xác Thực Sản Phẩm ${list_product_code} Tồn ${list_onhand} Ở Kho ${list_name_branch}
  FOR   ${index}     ${product_code}     IN ENUMERATE    ${list_product_code}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}[${index}]
    ${ton_kho_list}=    Get From List    ${list_onhand}   ${index}
    ${ton_kho_values}=    Split String    ${ton_kho_list}    ,
    FOR    ${item_tonkho}    ${name_branch}    IN ZIP    ${ton_kho_values}    ${list_name_branch}
    ${branch_id}  Run Keyword If    "${name_branch}" == "Kho bán hàng"    Set Variable    ${DEFAULT_BRANCH_ID}    ELSE    Lấy Thông tin Chi Nhánh    ${name_branch}
    Wait Until Keyword Succeeds    10x    1s    Thông tin tồn kho sản phẩm    ${product_id}    ${branch_id}     ${item_tonkho}
    END
  END

Lấy Thông tin Sản Phẩm  
    [Arguments]    ${product_code}
    ${query}=    Set Variable    SELECT Id FROM Product WHERE Code = ?
    ${result}=    Fetch One    ${query}    ${product_code}
    RETURN    ${result[0]}


Xác Thực Tất Cả Sản Phẩm ${list_product_code} Có Thuế ${type_tax} Với ${tax_rate} %
    ${tax_ID}  Run Keyword If  '${type_tax}'=='Trực Tiếp'    Lấy taxid từ giá trị thuế trực tiếp    ${tax_rate}
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy taxid từ giá trị thuế    ${tax_rate}
    
    FOR    ${code}    IN    @{list_product_code}
        ${query}=    Set Variable    SELECT p.Id FROM Product p JOIN ProductTax t ON p.Id = t.Id WHERE p.Code = ? AND t.TaxId = ?
        ${result}=    Fetch One    ${query}    ${code}    ${tax_ID}
        Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm ${code} với thuế ${tax_rate}% trong database
    END

Xác Thực Sản Phẩm Có Thuế ${type_tax} Với ${tax_rate} Theo Dữ Liệu Đã Gửi
    ${tax_ID}  Run Keyword If  '${type_tax}'=='Trực Tiếp'    Lấy taxid từ giá trị thuế trực tiếp    ${tax_rate}
    ...     ELSE IF  '${type_tax}'=='Khấu Trừ'    Lấy taxid từ giá trị thuế    ${tax_rate}
    ${query}=    Set Variable    SELECT TaxId FROM ProductTax WHERE ProductId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin thuế cho sản phẩm đã tạo
    Should Be Equal As Strings    ${result[0]}     ${tax_ID}  

Lấy taxid từ giá trị thuế
    [Arguments]    ${tax_rate}
    ${tax_ID}     Run Keyword If  '${tax_rate}'=='0'     Set Variable    1
    ...     ELSE IF   '${tax_rate}'=='5'     Set Variable    2
    ...     ELSE IF   '${tax_rate}'=='8'     Set Variable    3
    ...     ELSE IF   '${tax_rate}'=='10'     Set Variable    4
    ...     ELSE IF   '${tax_rate}'=='KCT'     Set Variable   5
    ...     ELSE IF   '${tax_rate}'=='KKKNT'     Set Variable   12
    ...     ELSE    Set Variable   9999
    RETURN    ${tax_ID}

Lấy taxid từ giá trị thuế trực tiếp
    [Arguments]    ${tax_rate}
    ${tax_ID}     Run Keyword If  '${tax_rate}'=='1'     Set Variable    6
    ...     ELSE IF   '${tax_rate}'=='2'     Set Variable    7
    ...     ELSE IF   '${tax_rate}'=='3'     Set Variable    8
    ...     ELSE IF   '${tax_rate}'=='5'     Set Variable    9
    ...     ELSE    Set Variable   9999
    RETURN    ${tax_ID}

Xác Thực Sản Phẩm Combo Có Chứa Các Thành Phần ${product_material_id} Với Số Lượng ${product_material_quantity} 
    ${query}=    Set Variable    SELECT MaterialId, Quantity FROM ProductFormula WHERE ProductId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thành phần cho sản phẩm combo đã tạo
    Should Be Equal As Strings    ${result[0]}   ${product_material_id}
    Should Be Equal As Numbers    ${result[1]}    ${product_material_quantity}


Xác Thực Lỗi "${error_message}"
    Should Be Equal As Strings    ${RESPONSE.status_code}    420
    Should Contain    ${RESPONSE.text}    ${error_message} 

Delete Sản Phẩm ${product_code}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${endpoint}=    Format String    ${PRODUCT_DELETE_API_ENDPOINT}    ${product_id}
    Delete Data    ${endpoint}


Delete Sản Phẩm ${list_product_code}
    FOR    ${product_code}    IN    @{list_product_code}
        Delete Sản Phẩm ${product_code}
    END

Save warranty for product
    [Arguments]    ${payload}
    ${response}=    Call API Man  ${WARRANTY_API_SAVE_ENDPOINT}      ${payload}
    RETURN    ${response}

Get Pricebook Id 
    [Arguments]    ${pricebook_name}
    ${query}=    Set Variable    SELECT Id FROM PriceBook WHERE Name = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${pricebook_name}    ${RETAILER_ID}
    RETURN    ${result[0]}

Xác Thực Giá Sản Phẩm ${product_code} Ở Pricebook ${pricebook_name} Là ${price}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${price}    Convert To Number    ${price}
    ${pricebook_id}=    Get Pricebook Id    ${pricebook_name}
    ${query}=    Set Variable    SELECT Price FROM PriceBookDetail WHERE ProductId = ? AND PriceBookId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${pricebook_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy giá sản phẩm ${product_id} ở pricebook ${pricebook_name}
    Should Be Equal As Numbers    ${result[0]}    ${price}

Xác Thực Giá Sản Phẩm ${product_code} Là ${price}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${price}    Convert To Number    ${price}
    ${query}=    Set Variable    SELECT BasePrice FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${product_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy giá sản phẩm ${product_id}
    Should Be Equal As Numbers    ${result[0]}    ${price}


Xác Thực Tất Cả Biến Thể Sản Phẩm Đã Được Tạo Thành Công
    # Lấy số lượng biến thể dự kiến từ danh sách mã sản phẩm
    ${expected_variant_count}=    Get Length    ${LIST_PRODUCTS_CODE}
    
    # Truy vấn số lượng biến thể thực tế được tạo ra trong cơ sở dữ liệu
    ${query}=    Set Variable    SELECT COUNT(*) FROM Product WHERE MasterProductId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    
    # Xác nhận rằng số lượng biến thể thực tế bằng số lượng dự kiến
    Should Be Equal As Numbers    ${result[0]}    ${expected_variant_count}
    Log    Đã tạo thành công ${result[0]} biến thể sản phẩm

Xác Thực Biến Thể Sản Phẩm Được Gắn Với Sản Phẩm Gốc Đúng
    # Kiểm tra xem các biến thể có liên kết với sản phẩm gốc không
    ${query}=    Set Variable    SELECT Id, Code FROM Product WHERE MasterProductId = ?
    ${results}=    Fetch All    ${query}    ${CREATED_PRODUCT_ID}
    
    # Kiểm tra từng biến thể
    FOR    ${result}    IN    @{results}
        ${variant_id}=    Set Variable    ${result[0]}
        
        # Kiểm tra mối quan hệ thuộc tính
        ${attr_query}=    Set Variable    SELECT COUNT(*) FROM ProductAttribute WHERE ProductId = ?
        ${attr_result}=    Fetch One    ${attr_query}    ${variant_id}
        
        # Một biến thể phải có ít nhất một thuộc tính
        Should Be True    ${attr_result[0]} > 0
    END

Xác Thực Các Biến Thể Có Tồn Kho Theo Cấu Hình
    # Kiểm tra tồn kho của từng biến thể
    ${branch_id}=    Lấy Thông tin Chi Nhánh    Chi nhánh trung tâm
    
    FOR    ${i}    ${inventory}    ${code}    IN ZIP    RANGE    ${VARIANT_INVENTORIES}    ${LIST_PRODUCTS_CODE}
        ${query}=    Set Variable    SELECT OnHand FROM ProductBranch WHERE ProductId = (SELECT Id FROM Product WHERE Code = ?) AND BranchId = ?
        ${result}=    Fetch One    ${query}    ${code}    ${branch_id}
        
        Should Not Be Equal    ${result}    None    Không tìm thấy thông tin tồn kho cho biến thể ${code}
        Should Be Equal As Numbers    ${result[0]}    ${inventory}
    END

Xác Thực Tổng Tồn Kho Sản Phẩm Chính Bằng Tổng Các Biến Thể
    # Tính tổng tồn kho từ các biến thể
    ${total_inventory}=    Evaluate    sum([int(x) for x in $VARIANT_INVENTORIES])
    
    # Lấy tồn kho của sản phẩm chính
    ${branch_id}=    Lấy Thông tin Chi Nhánh    Chi nhánh trung tâm
    ${query}=    Set Variable    SELECT OnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}    ${branch_id}
    
    # Kiểm tra tổng tồn kho
    Should Be Equal As Numbers    ${result[0]}    ${total_inventory}    Tổng tồn kho sản phẩm chính (${result[0]}) không bằng tổng tồn kho các biến thể (${total_inventory})

Xác Thực Các Biến Thể Có Mã Vạch Theo Cấu Hình
    # Kiểm tra mã vạch của từng biến thể
    FOR    ${barcode}    ${code}    IN ZIP    ${VARIANT_BARCODES}    ${LIST_PRODUCTS_CODE}
        ${query}=    Set Variable    SELECT Barcode FROM Product WHERE Code = ?
        ${result}=    Fetch One    ${query}    ${code}
        
        Should Not Be Equal    ${result}    None    Không tìm thấy thông tin mã vạch cho biến thể ${code}
        Should Be Equal    ${result[0]}    ${barcode}
    END

Xác Thực Tên Các Biến Thể Được Tạo Đúng Theo Cấu Trúc
    # Kiểm tra tên của từng biến thể
    ${query}=    Set Variable    SELECT Id, Name FROM Product WHERE MasterProductId = ?
    ${results}=    Fetch All    ${query}    ${CREATED_PRODUCT_ID}
    
    FOR    ${result}    IN    @{results}
        ${variant_id}=    Set Variable    ${result[0]}
        ${variant_name}=    Set Variable    ${result[1]}
        
        # Lấy thông tin thuộc tính của biến thể
        ${attr_query}=    Set Variable    SELECT a.Name, pa.Value FROM ProductAttribute pa JOIN Attribute a ON pa.AttributeId = a.Id WHERE pa.ProductId = ?
        ${attr_results}=    Fetch All    ${attr_query}    ${variant_id}
        
        # Kiểm tra tên biến thể chứa giá trị thuộc tính
        FOR    ${attr_result}    IN    @{attr_results}
            ${attr_name}=    Set Variable    ${attr_result[0]}
            ${attr_value}=    Set Variable    ${attr_result[1]}
            Should Contain    ${variant_name}    ${attr_value}
        END
        
        # Kiểm tra tên biến thể bắt đầu bằng tên sản phẩm gốc
        Should Start With    ${variant_name}    ${BASE_PRODUCT_NAME}
    END

Xác Thực Mã Các Biến Thể Được Tạo Dựa Trên Mã Sản Phẩm Gốc
    # Kiểm tra mã của từng biến thể
    ${query}=    Set Variable    SELECT Code FROM Product WHERE MasterProductId = ?
    ${results}=    Fetch All    ${query}    ${CREATED_PRODUCT_ID}
    
    FOR    ${result}    IN    @{results}
        ${variant_code}=    Set Variable    ${result[0]}
        
        # Kiểm tra mã biến thể bắt đầu bằng mã sản phẩm gốc
        Should Start With    ${variant_code}    ${BASE_PRODUCT_CODE}
    END

Lấy Thông tin Nhóm Hàng 
    [Arguments]    ${group_name}
    ${query}=    Set Variable    SELECT Id FROM Category WHERE Name = ?
    ${result}=    Fetch One    ${query}    ${group_name}
    RETURN    ${result[0]}
