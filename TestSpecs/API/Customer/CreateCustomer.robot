*** Settings ***
Suite Setup       Init Test Environment   ${ENV}    MHQL
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../TestData/Customer/CustomerCommonData.robot
Resource          ../../../Keywords/Customer/CreateCustomerKeywords.robot
Resource          ../../../Keywords/Customer/CustomerCommonKeywords.robot
Resource          ../../../Keywords/Utilities/RequestHelper.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Utilities/Utilities.robot
Resource          ../../../Keywords/Utilities/DataUtilities.robot
Library           ../../../Resources/DatabaseLibrary.py

*** Variables ***
@{list_group_names}    Nhóm1    Nhóm2    
@{MULTIPLE_EMPLOYEES}   son.dx    tester
${url_avatar}    Images/Anh1.jpg
${SUPPLIER_CODE}   	HVXF001
*** Test Cases ***
RT-CU-001 Tạo khách hàng thành công với thông tin cơ bản
    [Documentation]    Kiểm tra tạo khách hàng thành công với thông tin cơ bản:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng mới với thông tin cơ bản
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Success
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Tên "${CUSTOMER_NAME}" Số Điện Thoại "${CUSTOMER_PHONE}" Email "${CUSTOMER_EMAIL}"
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Thông Tin Khách Hàng Đã Được Tạo Với Tên "${CUSTOMER_NAME}" Số Điện Thoại "${CUSTOMER_PHONE}" Email "${CUSTOMER_EMAIL}"
    [Teardown]   Xóa Khách Hàng From API

RT-CU-002 Tạo khách hàng thành công với đầy đủ thông tin
    [Documentation]    Kiểm tra tạo khách hàng thành công với đầy đủ thông tin:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng mới với đầy đủ thông tin
    ...    - Code: POST /customers
    Given Chuẩn Bị Dữ Liệu Khách Hàng Đầy Đủ Với Tên "${CUSTOMER_NAME}" Số Điện Thoại "${CUSTOMER_PHONE}" Email "${CUSTOMER_EMAIL}" Địa Chỉ "${CUSTOMER_ADDRESS}" Mã Số Thuế "${CUSTOMER_TAX_CODE}" Giới Tính ${CUSTOMER_GENDER} Ngày Sinh "${CUSTOMER_BIRTH_DATE}"
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Thông Tin Khách Hàng Đầy Đủ Đã Được Tạo Với Tên "${CUSTOMER_NAME}" Số Điện Thoại "${CUSTOMER_PHONE}" Email "${CUSTOMER_EMAIL}" Địa Chỉ "${CUSTOMER_ADDRESS}" Mã Số Thuế "${CUSTOMER_TAX_CODE}" Giới Tính ${CUSTOMER_GENDER} Ngày Sinh "${CUSTOMER_BIRTH_DATE}"


RT-CU-007 Tạo khách hàng thành công với nhóm khách hàng
    [Documentation]    Kiểm tra tạo khách hàng thành công với nhóm khách hàng:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng mới với nhóm khách hàng
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Nhóm Khách Hàng Nhóm1
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Khách Hàng Thuộc Nhóm Nhóm1
    [Teardown]   Xóa Khách Hàng From API

RT-CU-008 Tạo khách hàng thành công với nhiều nhóm khách hàng
    [Documentation]    Kiểm tra tạo khách hàng thành công với nhóm khách hàng:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng mới với nhóm khách hàng
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create   
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Nhiều Nhóm Khách Hàng ${list_group_names}
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Khách Hàng Thuộc Nhiều Nhóm ${list_group_names}
    [Teardown]   Xóa Khách Hàng From API

RT-CU-008 Tạo khách hàng thành công với địa chỉ đầy đủ
    [Documentation]    Kiểm tra tạo khách hàng thành công với địa chỉ đầy đủ:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng mới với địa chỉ đầy đủ
    ...    - Code: POST /customers
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Địa Chỉ Đầy Đủ "${CUSTOMER_ADDRESS}" Tỉnh/Thành "${PROVINCE_ID}" Quận/Huyện "${DISTRICT_ID}" Phường/Xã "${WARD_ID}"
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Địa Chỉ Khách Hàng Đầy Đủ "${CUSTOMER_ADDRESS}" Tỉnh/Thành "${PROVINCE_ID}" Quận/Huyện "${DISTRICT_ID}" Phường/Xã "${WARD_ID}"

RT-CU-009 Tạo khách hàng thành công với ghi chú
    [Documentation]    Kiểm tra tạo khách hàng thành công với ghi chú:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng mới với ghi chú
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create   
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Ghi Chú ${CUSTOMER_COMMENTS}
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Ghi Chú Khách Hàng "${CUSTOMER_COMMENTS}"
    [Teardown]   Xóa Khách Hàng From API

RT-CU-010 Tạo khách hàng thành công với người phụ trách
    [Documentation]    Kiểm tra tạo khách hàng thành công với người phụ trách:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng mới với người phụ trách
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Success    regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Người Phụ Trách son.dx
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Người Phụ Trách Khách Hàng son.dx
    [Teardown]   Xóa Khách Hàng From API

RT-CU-011 Tạo khách hàng Với Nhiều Người Phụ Trách
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi người phụ trách không tồn tại:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi người phụ trách không tồn tại
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Success    regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Nhiều Người Phụ Trách ${MULTIPLE_EMPLOYEES}
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Nhiều Người Phụ Trách Khách Hàng ${MULTIPLE_EMPLOYEES}
    [Teardown]   Xóa Khách Hàng From API


RT-CU-013 Tạo khách hàng thành công với đầy đủ thông tin nhà cung cấp
    [Documentation]    Kiểm tra tạo khách hàng thành công với đầy đủ thông tin nhà cung cấp:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng mới với đầy đủ thông tin nhà cung cấp
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Success    
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Đầy Đủ Thông Tin Nhà Cung Cấp "${CUSTOMER_NAME}" "${CUSTOMER_PHONE}" "${CUSTOMER_EMAIL}" "${CUSTOMER_ADDRESS}" "${CUSTOMER_TAX_CODE}" "${SOLD_BY_ID}"
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Thông Tin Nhà Cung Cấp Đầy Đủ "${CUSTOMER_NAME}" "${CUSTOMER_PHONE}" "${CUSTOMER_EMAIL}" "${CUSTOMER_ADDRESS}" "${CUSTOMER_TAX_CODE}" "${SOLD_BY_ID}"
    [Teardown]   Xóa Khách Hàng From API


RT-CU-015 Tạo khách hàng thành công với 2 số điện thoại
    [Documentation]    Kiểm tra tạo khách hàng thành công với 2 số điện thoại:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng mới với số điện thoại chính và số phụ
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    
    Given Chuẩn Bị Dữ Liệu Có 2 Số Điện Thoại 0123456789 Và 0987654321
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Khách Hàng Có 2 Số Điện Thoại 123456789 Và 0987654321
    [Teardown]   Xóa Khách Hàng From API

RT-CU-016 Tạo khách hàng thành công với mã khách hàng tùy chỉnh
    [Documentation]    Kiểm tra tạo khách hàng thành công với mã khách hàng tùy chỉnh:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng mới với mã khách hàng được chỉ định
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Success    regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Mã Khách Hàng MJ-KH001
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Mã Khách Hàng MJ-KH001
    [Teardown]   Xóa Khách Hàng From API

RT-CU-016 Tạo khách hàng thành công với mã khách hàng dài 50 ký tự
    [Documentation]    Kiểm tra tạo khách hàng thành công với mã khách hàng tùy chỉnh:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng mới với mã khách hàng được chỉ định
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Success    regression
    ${random_code}=    Generate Random String   50   [NUMBERS]
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Mã Khách Hàng ${random_code}
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Mã Khách Hàng ${random_code}
    [Teardown]   Xóa Khách Hàng From API

RT-CU-017 Tạo khách hàng thành công với tên khách hàng dài 255 ký tự
    [Documentation]    Kiểm tra tạo khách hàng thành công với tên khách hàng dài 255 ký tự:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng mới với tên khách hàng được chỉ định
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Success    regression
    ${random_name}=    Generate Random String   255   [NUMBERS]
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Tên ${random_name}
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Tên Khách Hàng ${random_name}
    [Teardown]   Xóa Khách Hàng From API

RT-CU-020 Tạo khách hàng thành công với chi nhánh tùy chỉnh
    [Documentation]    Kiểm tra tạo khách hàng thành công với chi nhánh tùy chỉnh:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng mới thuộc chi nhánh được chỉ định
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Success    regression
    Given Chuẩn Bị Dữ Liệu Tạo Khách Hàng Với Chi Nhánh Nhánh A
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Chi Nhánh Khách Hàng Nhánh A
    [Teardown]   Xóa Khách Hàng From API


RT-CU-022 Tạo khách hàng thành công với avatar
    [Documentation]    Kiểm tra tạo khách hàng thành công với avatar:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng mới với ảnh đại diện
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Success    regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Có Avatar ${url_avatar}
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Avatar Khách Hàng  ${url_avatar}
    [Teardown]   Xóa Khách Hàng From API

RT-CU-023 Tạo khách hàng Cá Nhân Có MST
    [Documentation]    Kiểm tra tạo khách hàng cá nhân có mã số thuế:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng cá nhân có mã số thuế
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Success   
    Given Chuẩn Bị Khách Hàng Với Loại Khách Hàng Cá Nhân Có MST ${CUSTOMER_TAX_CODE} CMT ${CUSTOMER_CMT} Và Tên Công Ty ${EMPTY}
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Khách Hàng Cá Nhân Có Mã Số Thuế ${CUSTOMER_TAX_CODE}
    [Teardown]   Xóa Khách Hàng From API

RT-CU-024 Tạo khách hàng Công Ty Có MST
    [Documentation]    Kiểm tra tạo khách hàng công ty có mã số thuế:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng công ty có mã số thuế
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Success   
    Given Chuẩn Bị Khách Hàng Với Loại Khách Hàng Công Ty Có MST ${CUSTOMER_TAX_CODE} CMT ${CUSTOMER_CMT} Và Tên Công Ty ${EMPTY}
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Khách Hàng Công Ty Có Mã Số Thuế ${CUSTOMER_TAX_CODE}
    [Teardown]   Xóa Khách Hàng From API

RT-CU-025 Tạo khách hàng là nhà cung cấp mới
    [Documentation]    Kiểm tra tạo khách hàng là nhà cung cấp mới:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng mới với vai trò là nhà cung cấp
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Success    regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Là NCC Nhà Cung Cấp Tạo Mới NCC
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Khách Hàng Là Nhà Cung Cấp Mới
    [Teardown]   Xóa Khách Hàng From API

RT-CU-026 Tạo khách hàng liên kết với nhà cung cấp đã tồn tại
    [Documentation]    Kiểm tra tạo khách hàng liên kết với nhà cung cấp đã tồn tại:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng mới liên kết với nhà cung cấp đã có
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Success   
    Given Chuẩn Bị Dữ Liệu Khách Hàng Là NCC Nhà Cung Cấp Đã Tồn Tại ${SUPPLIER_CODE}
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Khách Hàng Liên Kết Với Nhà Cung Cấp ${SUPPLIER_CODE}
    [Teardown]   Xóa Khách Hàng From API

