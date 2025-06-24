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
Resource          ../Product/ProductCommonKeywords.robot
Library           ../../Resources/DatabaseLibrary.py

*** Variables ***

*** Keywords ***
Chuẩn Bị Dữ Liệu Khách Hàng Với Tên ${name} Số Điện Thoại ${phone} Email ${email} Và Facebook ${facebook}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary    ${request["Customer"]}    Name=${name}    ContactNumber=${phone}    Email=${email}    Facebook=${facebook}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Có 2 Số Điện Thoại ${phone1} Và ${phone2}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary    ${request["Customer"]}    ContactNumber=${phone1}    SubNumber=${phone2}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Khách Hàng Đầy Đủ Với Tên ${name} Số Điện Thoại ${phone} Email ${email} Địa Chỉ ${address} Mã Số Thuế ${tax_code} Giới Tính ${gender} Ngày Sinh ${birth_date}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary    ${request["Customer"]}    Name=${name}    ContactNumber=${phone}    Email=${email}    Address=${address}    TaxCode=${tax_code}    Gender=${gender}    BirthDate=${birth_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Khách Hàng Với Tên ${name}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary    ${request["Customer"]}    Name=${name}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Khách Hàng Với Mã Khách Hàng ${customer_code}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary    ${request["Customer"]}       Code=${customer_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Khách Hàng Với Số Điện Thoại "${phone}"
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary    ${request["Customer"]}       ContactNumber=${phone}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Khách Hàng Với Email ${email}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary    ${request["Customer"]}      Email=${email}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Khách Hàng Với Ngày Sinh ${birth_date}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary    ${request["Customer"]}      BirthDate=${birth_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}



Chuẩn Bị Dữ Liệu Khách Hàng Với ID Nhóm Khách Hàng ${group_id}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
     ${group_details}=    Deep Copy    ${STANDARD_CUSTOMER_DETAILS_GROUP}
    Set To Dictionary    ${group_details}    GroupId=${group_id}
    ${group_details_list}=    Create List    ${group_details}
    Set To Dictionary    ${request["Customer"]}    CustomerGroupDetails=${group_details_list}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Khách Hàng Với Nhóm Khách Hàng ${group_name}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    ${group_id}=    Lấy ID Nhóm Khách Hàng Theo Tên Nhóm   ${group_name}
    ${group_details}=    Deep Copy    ${STANDARD_CUSTOMER_DETAILS_GROUP}
    Set To Dictionary    ${group_details}    GroupId=${group_id}
    ${group_details_list}=    Create List    ${group_details}
    Set To Dictionary    ${request["Customer"]}    CustomerGroupDetails=${group_details_list}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Khách Hàng Với Nhiều Nhóm Khách Hàng ${list_group_names}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    ${group_ids}=    Create List
    FOR    ${group_name}    IN    @{list_group_names}
        ${group_id}=    Lấy ID Nhóm Khách Hàng Theo Tên Nhóm   ${group_name}
        ${group_details}=    Deep Copy    ${STANDARD_CUSTOMER_DETAILS_GROUP}
        Set To Dictionary    ${group_details}    GroupId=${group_id}
        ${group_ids}=    Create List    ${group_ids}    ${group_details}
    END
    Set To Dictionary    ${request["Customer"]}    CustomerGroupDetails=${group_ids}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Khách Hàng Với Địa Chỉ Đầy Đủ ${address} Tỉnh/Thành ${province_id} Quận/Huyện ${district_id} Phường/Xã ${ward_id}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary    ${request["Customer"]}      Address=${address}    LocationId=${province_id}    DistrictId=${district_id}    WardId=${ward_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Khách Hàng Với Địa Chỉ 2 Cấp ${address} Tỉnh/Thành ${province_id} Phường/Xã ${ward_id}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary    ${request["Customer"]}      Address=${address}    LocationId=${province_id}    WardId=${ward_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Khách Hàng Với Ghi Chú ${comments}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary    ${request["Customer"]}       Comments=${comments}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Khách Hàng Với Người Phụ Trách ${sold_by_name}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    ${sold_by_id}=    Lấy Thông tin Người Dùng Theo Tên    ${sold_by_name}
    ${sold_by_ids}=    Create List    ${sold_by_id}
    Set To Dictionary    ${request["Customer"]}    EmployeeInChargeIds=${sold_by_ids}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Khách Hàng Với Nhiều Người Phụ Trách ${list_sold_by_names}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    ${sold_by_ids}=    Create List
    FOR    ${sold_by_name}    IN    @{list_sold_by_names}
        ${sold_by_id}=    Lấy Thông tin Người Dùng Theo Tên    ${sold_by_name}
        ${sold_by_ids}=    Create List    ${sold_by_ids}    ${sold_by_id}
    END
    Set To Dictionary    ${request["Customer"]}    EmployeeInChargeIds=${sold_by_ids}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}
Chuẩn Bị Dữ Liệu Khách Hàng Với Người Phụ Trách Theo ID ${sold_by_id}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    ${sold_by_ids}=    Create List    ${sold_by_id}
    Set To Dictionary    ${request["Customer"]}    EmployeeInChargeIds=${sold_by_ids}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}



Chuẩn Bị Khách Hàng Với Loại Khách Hàng ${customer_type} Có MST ${tax_code} CMT ${cmt} Và Tên Công Ty ${company_name}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    ${customer_type}=    Run Keyword If    "${customer_type}" == "Cá Nhân"    Set Variable   0   
    ...    ELSE IF    "${customer_type}" == "Công Ty"    Set Variable   1
    ...    ELSE    Set Variable   5
    Set To Dictionary    ${request["Customer"]}    Type=${customer_type}    TaxCode=${tax_code}    IdentificationNumber=${cmt}    Organization=${company_name}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Khách Hàng Là NCC Nhà Cung Cấp Tạo Mới NCC
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary   ${request}    isMergedSupplier=true    isCreateNewSupplier=true    MergedSupplierId=0
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Khách Hàng ${ten} Và ${phone} Và Địa Chỉ ${address} NCC Nhà Cung Cấp Đã Tồn Tại ${supplier_code}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary   ${request}    isMergedSupplier=true    isCreateNewSupplier=false    MergedSupplierId=${supplier_code}    
    Set To Dictionary    ${request["Customer"]}    Name=${ten}    ContactNumber=${phone}    Address=${address}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Khách Hàng ${code} Là NCC Nhà Cung Cấp Đã Tồn Tại ${supplier_code}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary   ${request}    isMergedSupplier=true    isCreateNewSupplier=false    MergedSupplierId=${supplier_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Khách Hàng Là NCC Nhà Cung Cấp Đã Tồn Tại ${supplier_code}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary   ${request}    isMergedSupplier=true    isCreateNewSupplier=false    MergedSupplierId=${supplier_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Khách Hàng ${ten} Và ${phone} Và Địa Chỉ ${address} Là NCC Nhà Cung Cấp Đã Tồn Tại ${supplier_code}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary   ${request}    isMergedSupplier=true    isCreateNewSupplier=false    MergedSupplierId=${supplier_code}
    Set To Dictionary    ${request["Customer"]}    Name=${ten}    ContactNumber=${phone}    Address=${address}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo Khách Hàng Với Chi Nhánh ${branch_name}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    ${branch_id}=    Lấy Thông tin Chi Nhánh  ${branch_name}
    Set To Dictionary    ${request["Customer"]}    BranchId=${branch_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Tạo Khách Hàng Với ID Chi Nhánh ${branch_id}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary    ${request["Customer"]}    BranchId=${branch_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn bị Dữ Liệu Tạo Khách Hàng Địa Chỉ ${address} Tỉnh/Thành ${province_id} Quận/Huyện ${district_id} Phường/Xã ${ward_id}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary    ${request["Customer"]}    Address=${address}    LocationId=${province_id}    DistrictId=${district_id}    WardId=${ward_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Khách Hàng Với Có Avatar ${avatar_url}
    ${request}=    Deep Copy    ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary    ${request["Customer"]}    Avatar=${avatar_url}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

