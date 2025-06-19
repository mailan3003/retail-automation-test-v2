*** Settings ***
Resource          ../../Config/Env_${ENV}.robot
Resource          ../../TestData/CommonData.robot
Resource          ../../Keywords/CommonKeywords.robot
Resource          ../../Keywords/Product/ProductCommonKeywords.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Library           BuiltIn
Library           Collections
Library           DateTime
Library           ../../Resources/DatabaseLibrary.py
Library           json

*** Variables ***
${CUSTOMER_ENDPOINT}    customers

*** Keywords ***

Gửi Yêu Cầu Tạo Khách Hàng
    ${response}=    Call API Man With BranchId   ${CUSTOMER_ENDPOINT}    ${REQUEST_DATA} 
    Run Keyword If    ${response.status_code} == 200    Set Test Variable    ${CUSTOMER_ID}    ${response.json()["Id"]}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}

Gửi Yêu Tạo Khách Hàng Ở MHBH
    ${response}=    Call API    ${CUSTOMER_ENDPOINT}    ${REQUEST_DATA} 
    Run Keyword If    ${response.status_code} == 200    Set Test Variable    ${CUSTOMER_ID}    ${response.json()["Id"]}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}

Xóa Khách Hàng From API
    ${endpoint}=    Set Variable    ${CUSTOMER_ENDPOINT}/${CUSTOMER_ID}
    ${response}=    Delete Data   ${endpoint}     
    RETURN    ${response}

Lấy Id Khách Hàng Theo Mã Khách Hàng
    [Arguments]    ${customer_code}
    ${sql_query}=    Set Variable    SELECT Id FROM Customer WHERE Code = ? AND RetailerId = ?
    ${customer_id}=    Fetch One    ${sql_query}    ${customer_code}    ${RETAILER_ID}
    Should Not Be Equal    ${customer_id}    ${None}    Khách hàng không tồn tại trong CSDL
    Set Test Variable    ${CUSTOMER_ID}    ${customer_id[0]}
    RETURN    ${CUSTOMER_ID}


Lấy Công Nợ Của Khách Hàng
    [Arguments]    ${customer_code}
    ${sql_query}=    Set Variable    SELECT Debt FROM Customer WHERE Code = ? AND RetailerId = ?
    ${debt}=    Fetch One    ${sql_query}    ${customer_code}    ${RETAILER_ID}
    Should Not Be Equal    ${debt}    ${None}    Khách hàng không tồn tại trong CSDL
    Set Test Variable    ${DEBT_CUSTOMER}    ${debt[0]}
    RETURN   ${debt[0]}

Lấy ID Nhóm Khách Hàng Theo Tên Nhóm
    [Arguments]    ${customer_group_name}
    ${sql_query}=    Set Variable    SELECT Id FROM CustomerGroup WHERE Name = ? AND RetailerId = ?
    ${customer_group_id}=    Fetch One    ${sql_query}    ${customer_group_name}    ${RETAILER_ID}
    Should Not Be Equal    ${customer_group_id}    ${None}    Nhóm khách hàng không tồn tại trong CSDL
    Set Test Variable    ${CUSTOMER_GROUP_ID}    ${customer_group_id[0]}
    RETURN    ${CUSTOMER_GROUP_ID}

Công Nợ Của Khách Hàng ${customer_code} Phải Là ${expected_debt}
    [Documentation]    Kiểm tra công nợ của khách hàng
    ${query}=    Set Variable    SELECT Debt FROM Customer WHERE Code = ? AND RetailerId = ?
    ${debt}=    Fetch One    ${query}    ${customer_code}    ${RETAILER_ID}
    Should Be Equal As Numbers    ${debt[0]}    ${expected_debt}    Công nợ của khách hàng không phải là ${expected_debt}


Công Nợ Của Khách Hàng ${customer_code} Sau Thanh Toán ${payment_amount}
    ${query}=    Set Variable    SELECT Debt FROM Customer WHERE Code = ? AND RetailerId = ?
    ${debt}=    Fetch One    ${query}    ${customer_code}    ${RETAILER_ID}
    ${debt_after_payment}=    Evaluate   ${DEBT_CUSTOMER} - ${payment_amount}
    Should Be Equal As Numbers    ${debt_after_payment}    ${debt[0]}    Công nợ của khách hàng không phải là ${DEBT_CUSTOMER}

Điểm Của Khách Hàng ${customer_code} Giảm ${reward_point} Sau Khi Thực Hiện Giao Dịch ${document_id}
    ${customer_id}=    Lấy Id Khách Hàng Theo Mã Khách Hàng    ${customer_code}
    ${query}=    Set Variable    SELECT Value FROM PointTracking WHERE PartnerId = ? AND DocumentId = ?
    ${result}=    Fetch One    ${query}    ${customer_id}     ${document_id}
    Should Not Be Equal    ${result}    ${None}    Điểm khách hàng không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}  -${reward_point}   Điểm khách hàng không phải là ${result[0]}



Xác Thực Thông Tin Khách Hàng Đã Được Tạo Với Tên ${name} Số Điện Thoại ${phone} Email ${email}
    ${customer_id}=    Get From Dictionary    ${RESPONSE.json()}    Id
    ${query}=    Set Variable    SELECT Name, ContactNumber, Email FROM Customer WHERE Id = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${customer_id}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khách hàng
    Should Be Equal    ${result[0]}    ${name}    Tên khách hàng không khớp
    Should Be Equal    ${result[1]}    ${phone}    Số điện thoại không khớp
    Should Be Equal    ${result[2]}    ${email}    Email không khớp

Xác Thực Thông Tin Khách Hàng Đầy Đủ Đã Được Tạo Với Tên ${name} Số Điện Thoại ${phone} Email ${email} Địa Chỉ ${address} Mã Số Thuế ${tax_code} Giới Tính ${gender} Ngày Sinh ${birth_date}
    ${customer_id}=    Get From Dictionary    ${RESPONSE.json()}    Id
    ${query}=    Set Variable    SELECT Name, ContactNumber, Email, Address, TaxCode, Gender, BirthDate FROM Customer WHERE Id = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${customer_id}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khách hàng
    Should Be Equal    ${result[0]}    ${name}    Tên khách hàng không khớp
    Should Be Equal    ${result[1]}    ${phone}    Số điện thoại không khớp
    Should Be Equal    ${result[2]}    ${email}    Email không khớp
    Should Be Equal    ${result[3]}    ${address}    Địa chỉ không khớp
    Should Be Equal    ${result[4]}    ${tax_code}    Mã số thuế không khớp
    Should Be Equal    ${result[5]}    ${gender}    Giới tính không khớp
    Should Be Equal    ${result[6]}    ${birth_date}    Ngày sinh không khớp

Xác Thực Khách Hàng Thuộc Nhóm ${group_name}
    ${group_id}=    Lấy ID Nhóm Khách Hàng Theo Tên Nhóm    ${group_name}
    ${query}=    Set Variable    SELECT Id FROM CustomerGroupDetail WHERE GroupId = ? AND CustomerId = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${group_id}    ${CUSTOMER_ID}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    None    Khách hàng không thuộc nhóm ${group_name}

Xác Thực Địa Chỉ Khách Hàng Đầy Đủ ${address} Tỉnh/Thành ${province_id} Quận/Huyện ${district_id} Phường/Xã ${ward_id}
    ${customer_id}=    Get From Dictionary    ${RESPONSE.json()}    Id
    ${query}=    Set Variable    SELECT Address, LocationId, DistrictId, WardId FROM Customer WHERE Id = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${customer_id}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khách hàng
    Should Be Equal    ${result[0]}    ${address}    Địa chỉ không khớp
    Should Be Equal As Numbers    ${result[1]}    ${province_id}    Tỉnh/Thành không khớp
    Should Be Equal As Numbers    ${result[2]}    ${district_id}    Quận/Huyện không khớp
    Should Be Equal As Numbers    ${result[3]}    ${ward_id}    Phường/Xã không khớp

Xác Thực Ghi Chú Khách Hàng ${comments}
    ${customer_id}=    Get From Dictionary    ${RESPONSE.json()}    Id
    ${query}=    Set Variable    SELECT Comments FROM Customer WHERE Id = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${customer_id}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khách hàng
    Should Be Equal    ${result[0]}    ${comments}    Ghi chú không khớp

Xác Thực Trạng Thái Khách Hàng Không Hoạt Động
    ${customer_id}=    Get From Dictionary    ${RESPONSE.json()}    Id
    ${query}=    Set Variable    SELECT IsActive FROM Customer WHERE Id = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${customer_id}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khách hàng
    Should Be Equal    ${result[0]}    ${false}    Trạng thái không khớp

Xác Thực Người Phụ Trách Khách Hàng ${sold_by_name}
    ${sold_by_id}=    Lấy Thông tin Người Dùng Theo Tên    ${sold_by_name}
    ${query}=    Set Variable    SELECT * FROM CustomerToManageByUser WHERE CustomerId = ? AND UserId = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${CUSTOMER_ID}    ${sold_by_id}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    None    Khách hàng không có người phụ trách ${sold_by_name}

Xác Thực Khách Hàng Là Nhà Cung Cấp
    ${query}=    Set Variable    SELECT CustomerType FROM Customer WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CUSTOMER_ID}
    Should Not Be Equal    ${result}    None    Khách hàng không tồn tại
    Should Be Equal As Numbers    ${result[0]}    ${SUPPLIER_CUSTOMER_TYPE}    Loại khách hàng không đúng

Xác Thực Thông Tin Nhà Cung Cấp Đầy Đủ
    [Arguments]    ${name}    ${phone}    ${email}    ${address}    ${tax_code}    ${sold_by_id}
    ${query}=    Set Variable    SELECT Name, Phone, Email, Address, TaxCode, SoldById, CustomerType FROM Customer WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CUSTOMER_ID}
    Should Not Be Equal    ${result}    None    Khách hàng không tồn tại
    Should Be Equal    ${result[0]}    ${name}    Tên khách hàng không đúng
    Should Be Equal    ${result[1]}    ${phone}    Số điện thoại không đúng
    Should Be Equal    ${result[2]}    ${email}    Email không đúng
    Should Be Equal    ${result[3]}    ${address}    Địa chỉ không đúng
    Should Be Equal    ${result[4]}    ${tax_code}    Mã số thuế không đúng
    Should Be Equal As Numbers    ${result[5]}    ${sold_by_id}    Người phụ trách không đúng
    Should Be Equal As Numbers    ${result[6]}    ${SUPPLIER_CUSTOMER_TYPE}    Loại khách hàng không đúng

Xác Thực Khách Hàng Có 2 Số Điện Thoại
    [Arguments]    ${phone1}    ${phone2}
    ${customer_id}=    Get From Dictionary    ${RESPONSE.json()}    Id
    ${query}=    Set Variable    SELECT ContactNumber, SubNumber FROM Customer WHERE Id = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${customer_id}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khách hàng
    Should Be Equal    ${result[0]}    ${phone1}    Số điện thoại chính không khớp
    Should Be Equal    ${result[1]}    ${phone2}    Số điện thoại phụ không khớp

Xác Thực Mã Khách Hàng
    [Arguments]    ${customer_code}
    ${customer_id}=    Get From Dictionary    ${RESPONSE.json()}    Id
    ${query}=    Set Variable    SELECT Code FROM Customer WHERE Id = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${customer_id}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khách hàng
    Should Be Equal    ${result[0]}    ${customer_code}    Mã khách hàng không khớp

Xác Thực Khách Hàng Thuộc Nhiều Nhóm ${group_names}
    FOR    ${group_name}    IN    @{group_names}
        ${group_id}=    Lấy ID Nhóm Khách Hàng Theo Tên Nhóm    ${group_name}
        ${query}=    Set Variable    SELECT Id FROM CustomerGroupDetail WHERE CustomerId = ? AND GroupId = ?
        ${result}=    Fetch One    ${query}    ${CUSTOMER_ID}    ${group_id}
        Should Not Be Equal    ${result}    None    Khách hàng không thuộc nhóm ${group_name}
    END

Xác Thực Nhiều Người Phụ Trách Khách Hàng ${employee_names}
    FOR    ${employee_name}    IN    @{employee_names}
        ${employee_id}=    Lấy Thông tin Người Dùng Theo Tên    ${employee_name}
        ${query}=    Set Variable    SELECT * FROM CustomerToManageByUser WHERE CustomerId = ? AND UserId = ?
        ${result}=    Fetch One    ${query}    ${CUSTOMER_ID}    ${employee_id}
        Should Not Be Equal    ${result}    None    Khách hàng không có người phụ trách ${employee_name}
    END

Xác Thực Chi Nhánh Khách Hàng ${branch_name}
    ${branch_id}=    Lấy Thông tin Chi Nhánh    ${branch_name}
    ${query}=    Set Variable    SELECT BranchId FROM Customer WHERE Id = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${CUSTOMER_ID}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khách hàng
    Should Be Equal As Numbers    ${result[0]}    ${branch_id}    Chi nhánh không khớp

Xác Thực ID Chi Nhánh Khách Hàng
    [Arguments]    ${branch_id}
    ${customer_id}=    Get From Dictionary    ${RESPONSE.json()}    Id
    ${query}=    Set Variable    SELECT BranchId FROM Customer WHERE Id = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${customer_id}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khách hàng
    Should Be Equal As Numbers    ${result[0]}    ${branch_id}    ID chi nhánh không khớp

Xác Thực Avatar Khách Hàng
    [Arguments]    ${url_avatar}
    ${query}=    Set Variable    SELECT Avatar FROM Customer WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CUSTOMER_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khách hàng
    Should Contain    ${result[0]}    ${url_avatar}    Avatar không chứa đường dẫn cdn2

Xác Thực Khách Hàng Cá Nhân Với MST
    [Arguments]    ${tax_code}    ${identification_number}
    ${customer_id}=    Get From Dictionary    ${RESPONSE.json()}    Id
    ${query}=    Set Variable    SELECT TaxCode, IdentificationNumber, Type FROM Customer WHERE Id = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${customer_id}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khách hàng
    Should Be Equal    ${result[0]}    ${tax_code}    Mã số thuế không khớp
    Should Be Equal    ${result[1]}    ${identification_number}    Số CMT không khớp
    Should Be Equal As Numbers    ${result[2]}    ${NON_SUPPLIER_CUSTOMER_TYPE}    Loại khách hàng không đúng

Xác Thực Khách Hàng Công Ty Với MST
    [Arguments]    ${tax_code}    ${identification_number}    ${company_name}
    ${customer_id}=    Get From Dictionary    ${RESPONSE.json()}    Id
    ${query}=    Set Variable    SELECT TaxCode, IdentificationNumber, Organization, Type FROM Customer WHERE Id = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${customer_id}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khách hàng
    Should Be Equal    ${result[0]}    ${tax_code}    Mã số thuế không khớp
    Should Be Equal    ${result[1]}    ${identification_number}    Số CMT không khớp
    Should Be Equal    ${result[2]}    ${company_name}    Tên công ty không khớp
    Should Be Equal As Numbers    ${result[3]}    ${SUPPLIER_CUSTOMER_TYPE}    Loại khách hàng không đúng

Xác Thực Khách Hàng Là Nhà Cung Cấp Mới
    ${query}=    Set Variable    SELECT Id FROM CustomerSupplierCombine WHERE CustomerId = ?
    ${result}=    Fetch One    ${query}    ${CUSTOMER_ID}   
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khách hàng

Xác Thực Khách Hàng Liên Kết Với Nhà Cung Cấp
    [Arguments]    ${supplier_code}
    ${query}=    Set Variable    SELECT Id FROM CustomerSupplierCombine WHERE CustomerId = ? AND SupplierId = ?
    ${result}=    Fetch One    ${query}    ${CUSTOMER_ID}    ${SUPPLIER_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khách hàng
    Should Be Equal    ${result[0]}    ${supplier_code}    Mã nhà cung cấp không khớp

Xác Thực Tên Khách Hàng
    [Arguments]    ${name}
    ${customer_id}=    Get From Dictionary    ${RESPONSE.json()}    Id
    ${query}=    Set Variable    SELECT Name FROM Customer WHERE Id = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${customer_id}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khách hàng
    Should Be Equal    ${result[0]}    ${name}    Tên khách hàng không khớp
