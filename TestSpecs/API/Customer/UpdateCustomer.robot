*** Settings ***
Suite Setup       Init Test Environment   ${ENV}    MHQL
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../TestData/Customer/CustomerCommonData.robot
Resource          ../../../Keywords/Customer/UpdateCustomerKeywords.robot
Resource          ../../../Keywords/Customer/CustomerCommonKeywords.robot
Resource          ../../../Keywords/Customer/CreateCustomerKeywords.robot
Resource          ../../../Keywords/Utilities/RequestHelper.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Utilities/Utilities.robot
Library           ../../../Resources/DatabaseLibrary.py

*** Test Cases ***
RT-CU-001 Cập Nhật Thông Tin Cơ Bản Khách Hàng Thành Công
    [Documentation]    Kiểm tra cập nhật thông tin cơ bản khách hàng thành công với các trường hợp:
    ...    - Cập nhật tên khách hàng
    ...    - Cập nhật số điện thoại
    ...    ...    - Số điện thoại mới chưa tồn tại trong hệ thống
    ...    - Cập nhật email
    ...    ...    - Email mới chưa tồn tại trong hệ thống
    ...    - Cập nhật mã số thuế
    ...    - Cập nhật nhóm khách hàng
    [Template]    Test Update Customer Basic Info Success
    # customer_code    new_name    new_phone    new_email    new_tax_code    new_group_id    expected_status
    ${customer_1}    ${new_name_1}    ${new_phone_1}    ${new_email_1}    ${new_tax_code_1}    ${group_1}    200
    ${customer_2}    ${new_name_2}    ${new_phone_2}    ${new_email_2}    ${new_tax_code_2}    ${group_2}    200

RT-CU-002 Cập Nhật Thông Tin Cơ Bản Khách Hàng Thất Bại Do Thiếu Quyền
    [Documentation]    Kiểm tra cập nhật thông tin cơ bản khách hàng thất bại khi không có quyền Customer._Update
    Given Khách Hàng ${customer_1} Đã Tồn Tại Trong Hệ Thống
    And Người Dùng Không Có Quyền Customer._Update
    When Gửi Yêu Cầu Cập Nhật Thông Tin Khách Hàng ${customer_1}
    Then Response Status Code Should Be 403
    And Response Should Have Error "Không có quyền cập nhật khách hàng"

RT-CU-003 Cập Nhật Thông Tin Cơ Bản Khách Hàng Thất Bại Do Không Tồn Tại
    [Documentation]    Kiểm tra cập nhật thông tin cơ bản khách hàng thất bại khi khách hàng không tồn tại
    Given Khách Hàng ${non_existent_customer} Không Tồn Tại Trong Hệ Thống
    When Gửi Yêu Cầu Cập Nhật Thông Tin Khách Hàng ${non_existent_customer}
    Then Response Status Code Should Be 404
    And Response Should Have Error "Không tìm thấy khách hàng"

RT-CU-004 Cập Nhật Thông Tin Cơ Bản Khách Hàng Thất Bại Do Trùng Số Điện Thoại
    [Documentation]    Kiểm tra cập nhật thông tin cơ bản khách hàng thất bại khi số điện thoại mới đã tồn tại
    Given Khách Hàng ${customer_1} Đã Tồn Tại Trong Hệ Thống
    And Khách Hàng ${customer_2} Đã Tồn Tại Với Số Điện Thoại ${existing_phone}
    When Gửi Yêu Cầu Cập Nhật Số Điện Thoại Khách Hàng ${customer_1} Thành ${existing_phone}
    Then Response Status Code Should Be 409
    And Response Should Have Error "Số điện thoại đã tồn tại trong hệ thống"

RT-CU-005 Cập Nhật Thông Tin Cơ Bản Khách Hàng Thất Bại Do Trùng Email
    [Documentation]    Kiểm tra cập nhật thông tin cơ bản khách hàng thất bại khi email mới đã tồn tại
    Given Khách Hàng ${customer_1} Đã Tồn Tại Trong Hệ Thống
    And Khách Hàng ${customer_2} Đã Tồn Tại Với Email ${existing_email}
    When Gửi Yêu Cầu Cập Nhật Email Khách Hàng ${customer_1} Thành ${existing_email}
    Then Response Status Code Should Be 409
    And Response Should Have Error "Email đã tồn tại trong hệ thống"

RT-CU-006 Cập Nhật Thông Tin Cơ Bản Khách Hàng Thất Bại Do Định Dạng Email Không Hợp Lệ
    [Documentation]    Kiểm tra cập nhật thông tin cơ bản khách hàng thất bại khi email không đúng định dạng
    Given Khách Hàng ${customer_1} Đã Tồn Tại Trong Hệ Thống
    When Gửi Yêu Cầu Cập Nhật Email Khách Hàng ${customer_1} Thành ${invalid_email}
    Then Response Status Code Should Be 400
    And Response Should Have Error "Email không đúng định dạng"

RT-CU-007 Cập Nhật Thông Tin Cơ Bản Khách Hàng Thất Bại Do Định Dạng Số Điện Thoại Không Hợp Lệ
    [Documentation]    Kiểm tra cập nhật thông tin cơ bản khách hàng thất bại khi số điện thoại không đúng định dạng
    Given Khách Hàng ${customer_1} Đã Tồn Tại Trong Hệ Thống
    When Gửi Yêu Cầu Cập Nhật Số Điện Thoại Khách Hàng ${customer_1} Thành ${invalid_phone}
    Then Response Status Code Should Be 400
    And Response Should Have Error "Số điện thoại không đúng định dạng"

RT-CU-008 Cập Nhật Thông Tin Cơ Bản Khách Hàng Thất Bại Do Mã Số Thuế Vượt Quá Độ Dài Cho Phép
    [Documentation]    Kiểm tra cập nhật thông tin cơ bản khách hàng thất bại khi mã số thuế vượt quá 50 ký tự
    Given Khách Hàng ${customer_1} Đã Tồn Tại Trong Hệ Thống
    When Gửi Yêu Cầu Cập Nhật Mã Số Thuế Khách Hàng ${customer_1} Thành ${too_long_tax_code}
    Then Response Status Code Should Be 400
    And Response Should Have Error "Mã số thuế không được vượt quá 50 ký tự"

RT-CU-009 Cập Nhật Thông Tin Cơ Bản Khách Hàng Thất Bại Do Tên Khách Hàng Trống
    [Documentation]    Kiểm tra cập nhật thông tin cơ bản khách hàng thất bại khi tên khách hàng trống
    Given Khách Hàng ${customer_1} Đã Tồn Tại Trong Hệ Thống
    When Gửi Yêu Cầu Cập Nhật Tên Khách Hàng ${customer_1} Thành ${empty_name}
    Then Response Status Code Should Be 400
    And Response Should Have Error "Tên khách hàng không được để trống"

RT-CU-010 Cập Nhật Thông Tin Cơ Bản Khách Hàng Thất Bại Do Nhóm Khách Hàng Không Tồn Tại
    [Documentation]    Kiểm tra cập nhật thông tin cơ bản khách hàng thất bại khi nhóm khách hàng không tồn tại
    Given Khách Hàng ${customer_1} Đã Tồn Tại Trong Hệ Thống
    And Nhóm Khách Hàng ${non_existent_group} Không Tồn Tại Trong Hệ Thống
    When Gửi Yêu Cầu Cập Nhật Nhóm Khách Hàng ${customer_1} Thành ${non_existent_group}
    Then Response Status Code Should Be 404
    And Response Should Have Error "Không tìm thấy nhóm khách hàng" 


RT-CU-010 Tạo khách hàng thành công với trạng thái không hoạt động
    [Documentation]    Kiểm tra tạo khách hàng thành công với trạng thái không hoạt động:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng mới với trạng thái không hoạt động
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Trạng Thái Không Hoạt Động
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Trạng Thái Khách Hàng Không Hoạt Động
    [Teardown]   Xóa Khách Hàng From API