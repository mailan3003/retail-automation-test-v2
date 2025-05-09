*** Settings ***
Documentation     Keywords cho test API tạo sản phẩm
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Product/CreateProductData.robot
Library           ../../Resources/DatabaseLibrary.py
Library           String

*** Variables ***
${API_URL}       https://api-man.kvpos.com

*** Keywords ***
# Keywords chuẩn bị dữ liệu
Chuẩn Bị Dữ Liệu Sản Phẩm Cơ Bản
    ${request}=    Deep Copy    ${SAN_PHAM_CO_BAN}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Không Có Mã
    ${request}=    Deep Copy    ${SAN_PHAM_CO_BAN}
    Set To Dictionary    ${request}    Code=${EMPTY}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Nhiều Đơn Vị Tính
    ${request}=    Deep Copy    ${SAN_PHAM_NHIEU_DON_VI_TINH}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Tồn Kho Ban Đầu
    ${request}=    Deep Copy    ${SAN_PHAM_VOI_TON_KHO}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Quản Lý Lô Và Hạn Sử Dụng
    ${request}=    Deep Copy    ${SAN_PHAM_QUAN_LY_LO}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Quản Lý Serial
    ${request}=    Deep Copy    ${SAN_PHAM_QUAN_LY_SERIAL}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính
    ${request}=    Deep Copy    ${SAN_PHAM_CO_THUOC_TINH}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Là Thuốc
    ${request}=    Deep Copy    ${SAN_PHAM_LA_THUOC}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế
    ${request}=    Deep Copy    ${SAN_PHAM_CO_THUE}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Loại Combo
    ${request}=    Deep Copy    ${SAN_PHAM_COMBO}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    COMBO${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# Keywords cho các trường hợp lỗi
Chuẩn Bị Dữ Liệu Sản Phẩm Thiếu Tên
    ${request}=    Deep Copy    ${SAN_PHAM_THIEU_TEN}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Mã Đã Tồn Tại
    ${request}=    Deep Copy    ${SAN_PHAM_MA_TON_TAI}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Giá Bán Âm
    ${request}=    Deep Copy    ${SAN_PHAM_GIA_AM}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo 201 Sản Phẩm
    ${list_products}=    Create List
    FOR    ${i}    IN RANGE    201
        ${product}=    Deep Copy    ${SAN_PHAM_CO_BAN}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        ${product_code}=    Set Variable    SP${random_code}
        Set To Dictionary    ${product}    Code=${product_code}
        Append To List    ${list_products}    ${product}
    END
    ${request}=    Create Dictionary    ListProducts=${list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo 51 Sản Phẩm Combo
    ${list_products}=    Create List
    FOR    ${i}    IN RANGE    51
        ${product}=    Deep Copy    ${SAN_PHAM_COMBO}
        ${random_code}=    Generate Random String    6    [NUMBERS]
        ${product_code}=    Set Variable    COMBO${random_code}
        Set To Dictionary    ${product}    Code=${product_code}
        Append To List    ${list_products}    ${product}
    END
    ${request}=    Create Dictionary    ListProducts=${list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Tỷ Lệ Quy Đổi Không Hợp Lệ
    ${request}=    Deep Copy    ${SAN_PHAM_TY_LE_QUY_DOI_AM}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Danh Mục Không Tồn Tại
    ${request}=    Deep Copy    ${SAN_PHAM_DANH_MUC_KHONG_TON_TAI}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Là Thuốc Thiếu Thông Tin
    ${request}=    Deep Copy    ${SAN_PHAM_THUOC_THIEU_THONG_TIN}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Mô Tả Quá Dài
    ${request}=    Deep Copy    ${SAN_PHAM_MO_TA_QUA_DAI}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Sản Phẩm Combo Với Thành Phần Không Tồn Tại
    ${request}=    Deep Copy    ${SAN_PHAM_COMBO_THANH_PHAN_KHONG_TON_TAI}
    ${random_code}=    Generate Random String    6    [NUMBERS]
    ${product_code}=    Set Variable    SP${random_code}
    Set To Dictionary    ${request}    Code=${product_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# Keywords xử lý API
Gửi Yêu Cầu Tạo Sản Phẩm
    ${list_products}=    Create List    ${REQUEST_DATA}
    ${branch_pr_cost}=        Set Variable     [{"Id":${BRANCH_ID},"Name":"Chi nhánh trung tâm"}]
    ${request}=    Create Dictionary    ListProducts=${list_products}
    
   ${payload}    Create Dictionary    ListProducts=${request}     BranchForProductCostss=${branch_pr_cost}
    
    # Gọi API với form-data
    ${response}=    Call API Man   products/addmany      ${payload} 
    
    Set Test Variable    ${RESPONSE}    ${response}
    IF    '${RESPONSE.status_code}' == '200'
        ${product_id}=    Set Variable    ${RESPONSE.json()[0]['Id']}
        ${product_code}=    Set Variable    ${RESPONSE.json()[0]['Code']}
        Set Test Variable    ${CREATED_PRODUCT_ID}    ${product_id}
        Set Test Variable    ${CREATED_PRODUCT_CODE}    ${product_code}
    END
    RETURN    ${response}

# Keywords xác thực kết quả
Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    ${query}=    Set Variable    SELECT Id, Code, Name FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    Set Test Variable    ${DB_PRODUCT_ID}    ${result[0]}
    Set Test Variable    ${DB_PRODUCT_CODE}    ${result[1]}
    Set Test Variable    ${DB_PRODUCT_NAME}    ${result[2]}

Xác Thực Sản Phẩm Có Thông Tin Chính Xác Theo Dữ Liệu Đã Gửi
    Should Be Equal As Strings    ${DB_PRODUCT_CODE}    ${REQUEST_DATA['Code']}
    Should Be Equal As Strings    ${DB_PRODUCT_NAME}    ${REQUEST_DATA['Name']}

Xác Thực Sản Phẩm Được Tạo Với Mã Tự Sinh
    Should Not Be Empty    ${DB_PRODUCT_CODE}

Xác Thực Sản Phẩm Con Được Tạo Với Đúng Tỷ Lệ Quy Đổi
    ${query}=    Set Variable    SELECT Id FROM Product WHERE MasterProductId = ?
    ${results}=    Fetch All    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Empty    ${results}    Không tìm thấy sản phẩm con cho sản phẩm cha đã tạo
    
    FOR    ${result}    IN    @{results}
        ${child_id}=    Set Variable    ${result[0]}
        ${unit_query}=    Set Variable    SELECT ConversionValue FROM Product WHERE Id = ?
        ${unit_result}=    Fetch One    ${unit_query}    ${child_id}
        Should Be Equal As Numbers    ${unit_result[0]}    ${DON_VI_TINH_PHU['ConversionValue']}
    END

Xác Thực Sản Phẩm Có Tồn Kho Ban Đầu Theo Dữ Liệu Đã Gửi
    ${query}=    Set Variable    SELECT OnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}    ${TON_KHO_BAN_DAU['BranchId']}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin tồn kho cho sản phẩm đã tạo
    Should Be Equal As Numbers    ${result[0]}    ${TON_KHO_BAN_DAU['OnHand']}

Xác Thực Sản Phẩm Được Cấu Hình Quản Lý Lô Và Hạn Sử Dụng
    ${query}=    Set Variable    SELECT IsBatchExpireControl FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    Should Be Equal As Strings    ${result[0]}    1

Xác Thực Sản Phẩm Được Cấu Hình Quản Lý Serial
    ${query}=    Set Variable    SELECT IsLotSerialControl FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm đã tạo trong database
    Should Be Equal As Strings    ${result[0]}    1

Xác Thực Sản Phẩm Có Thuộc Tính Theo Dữ Liệu Đã Gửi
    ${query}=    Set Variable    SELECT AttributeName, AttributeValue FROM ProductAttribute WHERE ProductId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thuộc tính cho sản phẩm đã tạo
    Should Be Equal As Strings    ${result[0]}    ${THUOC_TINH['AttributeName']}
    Should Be Equal As Strings    ${result[1]}    ${THUOC_TINH['AttributeValue']}

Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    ${query}=    Set Variable    SELECT IsMedicineProduct, RegistrationNo FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm thuốc đã tạo trong database
    Should Be Equal As Strings    ${result[0]}    1
    Should Be Equal As Strings    ${result[1]}    ${SAN_PHAM_LA_THUOC['RegistrationNo']}

Xác Thực Sản Phẩm Tự Động Được Cấu Hình Quản Lý Lô Và Hạn Sử Dụng
    ${query}=    Set Variable    SELECT IsBatchExpireControl FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm thuốc đã tạo trong database
    Should Be Equal As Strings    ${result[0]}    1

Xác Thực Sản Phẩm Có Thuế Theo Dữ Liệu Đã Gửi
    ${query}=    Set Variable    SELECT TaxId FROM Product WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin thuế cho sản phẩm đã tạo
    Should Be Equal As Strings    ${result[0]}    ${SAN_PHAM_CO_THUE['TaxId']}

Xác Thực Sản Phẩm Combo Có Chứa Các Thành Phần Theo Dữ Liệu Đã Gửi
    ${query}=    Set Variable    SELECT MaterialId, Quantity FROM ProductComboDetail WHERE ComboId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_PRODUCT_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thành phần cho sản phẩm combo đã tạo
    Should Be Equal As Strings    ${result[0]}    ${THANH_PHAN_COMBO['ProductId']}
    Should Be Equal As Numbers    ${result[1]}    ${THANH_PHAN_COMBO['Quantity']}

Xác Thực Lỗi "${error_message}"
    Should Be Equal As Strings    ${RESPONSE.status_code}    420
    Should Contain    ${RESPONSE.text}    ${error_message} 