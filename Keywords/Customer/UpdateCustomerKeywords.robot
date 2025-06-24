
*** Settings ***
Resource          ../../TestData/Customer/CustomerCommonData.robot
Resource          ../../Keywords/Customer/CustomerCommonKeywords.robot
Resource          ../../Keywords/Customer/CreateCustomerKeywords.robot
Resource          ../../Keywords/Product/ProductCommonKeywords.robot
Resource          ../CommonKeywords.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Resource    ../Product/ProductCommonKeywords.robot
Library           ../../Resources/DatabaseLibrary.py


*** Keywords ***

Chuẩn Bị Khách Hàng Cơ Bản 
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Gửi Yêu Cầu Tạo Khách Hàng

Chuẩn Bị Khách Hàng Là Nhà Cung Cấp
    Chuẩn Bị Dữ Liệu Khách Hàng Là NCC Nhà Cung Cấp Tạo Mới NCC
    Gửi Yêu Cầu Tạo Khách Hàng



Chuẩn Bị Cập Nhật Khách Hàng mã ${code} Tên ${name} Giới Tính ${gender} Ngày Sinh ${birth_date}
    ${request}=    Deep Copy    ${REQUEST_DATA}
    Set To Dictionary    ${request["Customer"]}  Id=${CUSTOMER_ID}   Name=${name}    Gender=${gender}    BirthDate=${birth_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Cập Nhật Khách Hàng Với Số Điện Thoại ${phone}
    ${request}=    Deep Copy    ${REQUEST_DATA}
    Set To Dictionary    ${request["Customer"]}    Id=${CUSTOMER_ID}    ContactNumber=${phone}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Cập Nhật Khách Hàng Với Email ${email}
    ${request}=    Deep Copy    ${REQUEST_DATA}
    Set To Dictionary    ${request["Customer"]}    Id=${CUSTOMER_ID}    Email=${email}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Cập Nhật Khách Hàng Với Địa Chỉ "${address}" Tỉnh/Thành "${province_id}" Quận/Huyện "${district_id}" Phường/Xã "${ward_id}"
    ${request}=    Deep Copy    ${REQUEST_DATA}
    Set To Dictionary    ${request["Customer"]}    Id=${CUSTOMER_ID}    Address=${address}    LocationId=${province_id}    DistrictId=${district_id}    WardId=${ward_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Cập Nhật Khách Hàng Với Mã Số Thuế ${tax_code}
    ${request}=    Deep Copy    ${REQUEST_DATA}
    Set To Dictionary    ${request["Customer"]}    Id=${CUSTOMER_ID}    TaxCode=${tax_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Cập Nhật Khách Hàng Với Nhóm Khách Hàng ${group_name}
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${group_id}=    Lấy ID Nhóm Khách Hàng Theo Tên Nhóm   ${group_name}
    ${group_ids}=    Create List    ${group_id}
    Set To Dictionary    ${request["Customer"]}    Id=${CUSTOMER_ID}    CustomerGroupDetails=${group_ids}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Cập Nhật Khách Hàng Với Nhiều Nhóm Khách Hàng ${list_group_names}
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${group_ids}=    Create List
    FOR    ${group_name}    IN    @{list_group_names}
        ${group_id}=    Lấy ID Nhóm Khách Hàng Theo Tên Nhóm   ${group_name}
        ${group_ids}=    Create List    ${group_ids}    ${group_id}
    END
    Set To Dictionary    ${request["Customer"]}    Id=${CUSTOMER_ID}    CustomerGroupDetails=${group_ids}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Cập Nhật Khách Hàng Với Người Phụ Trách ${sold_by_name}
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${sold_by_id}=    Lấy Thông tin Người Dùng Theo Tên    ${sold_by_name}
    ${sold_by_ids}=    Create List    ${sold_by_id}
    Set To Dictionary    ${request["Customer"]}    Id=${CUSTOMER_ID}    EmployeeInChargeIds=${sold_by_ids}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Cập Nhật Khách Hàng Với Nhiều Người Phụ Trách ${list_sold_by_names}
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${sold_by_ids}=    Create List
    FOR    ${sold_by_name}    IN    @{list_sold_by_names}
        ${sold_by_id}=    Lấy Thông tin Người Dùng Theo Tên    ${sold_by_name}
        ${sold_by_ids}=    Create List    ${sold_by_ids}    ${sold_by_id}
    END
    Set To Dictionary    ${request["Customer"]}    Id=${CUSTOMER_ID}    EmployeeInChargeIds=${sold_by_ids}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Cập Nhật Khách Hàng Với Ghi Chú "${comments}"
    ${request}=    Deep Copy    ${REQUEST_DATA}
    Set To Dictionary    ${request["Customer"]}    Id=${CUSTOMER_ID}    Comments=${comments}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Cập Nhật Khách Hàng Với Avatar ${avatar_url}
    ${request}=    Deep Copy    ${REQUEST_DATA}
    Set To Dictionary    ${request["Customer"]}    Id=${CUSTOMER_ID}    Avatar=${avatar_url}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Cập Nhật Khách Hàng Với Chi Nhánh ${branch_name}
    ${request}=    Deep Copy    ${REQUEST_DATA}
    ${branch_id}=    Lấy Thông tin Chi Nhánh  ${branch_name}
    Set To Dictionary    ${request["Customer"]}    Id=${CUSTOMER_ID}    BranchId=${branch_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Cập Nhật Khách Hàng Với ID Chi Nhánh ${branch_id}
    ${request}=    Deep Copy    ${REQUEST_DATA}
    Set To Dictionary    ${request["Customer"]}    Id=${CUSTOMER_ID}    BranchId=${branch_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Cập Nhật Khách Hàng ${customer_id}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary    ${request["Customer"]}    Id=${customer_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}


Chuẩn Bị Cập Nhật Khách Hàng Với Trạng Thái ${status} Hoạt Động
    ${status}      Set Variable If    "${status}" == "Có"    1    0
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary    ${request["Customer"]}    IsActive=${status}
    Set Test Variable    ${REQUEST_DATA}    ${request}