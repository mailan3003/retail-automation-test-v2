*** Settings ***
Suite Setup       Init Test Environment   ${ENV}    MHQL
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Config/Env_${ENV}.robot
Resource          ../../../TestData/CommonData.robot
Resource          ../../../TestData/Customer/CustomerCommonData.robot
Resource          ../../../Keywords/Customer/CustomerCommonKeywords.robot
Resource          ../../../Keywords/Customer/CreateCustomerKeywords.robot
Resource          ../../../Keywords/Customer/UpdateCustomerKeywords.robot


*** Test Cases ***
# Basic Information Validation Tests
RT-CU-003 Tạo khách hàng thất bại khi thiếu thông tin bắt buộc
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi thiếu thông tin bắt buộc:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi thiếu thông tin bắt buộc
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Fail   regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Có Tên ${EMPTY}
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Bạn chưa nhập Tên khách hàng"
RT-CU-004 Tạo khách hàng thất bại khi số điện thoại đã tồn tại
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi số điện thoại đã tồn tại:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi số điện thoại đã tồn tại
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Fail   regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Số Điện Thoại Đã Tồn Tại "${EXISTING_PHONE}"
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Số điện thoại đã tồn tại trong hệ thống"



RT-CU-005 Tạo khách hàng thất bại khi email không hợp lệ
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi email không hợp lệ:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi email không hợp lệ
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Fail   regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Email Không Hợp Lệ "invalid_email"
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Email không hợp lệ."

RT-CU-011 Tạo khách hàng thất bại khi người phụ trách không tồn tại
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi người phụ trách không tồn tại:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi người phụ trách không tồn tại
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Fail    regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Người Phụ Trách Không Tồn Tại 999999
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi Người phụ trách không tồn tại

    RT-CU-014 Tạo khách hàng thất bại khi mã số thuế nhà cung cấp đã tồn tại
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi mã số thuế nhà cung cấp đã tồn tại:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi mã số thuế nhà cung cấp đã tồn tại
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Fail    regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Mã Số Thuế Đã Tồn Tại "${EXISTING_TAX_CODE}"
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Mã số thuế đã tồn tại trong hệ thống"

RT-CU-027 Tạo khách hàng thất bại khi mã khách hàng đã tồn tại
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi mã khách hàng đã tồn tại:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi mã khách hàng đã tồn tại
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Fail    regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Mã Khách Hàng Đã Tồn Tại "${CUSTOMER_CODE}"
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Mã khách hàng đã tồn tại trong hệ thống"

RT-CU-028 Tạo khách hàng thất bại khi email đã tồn tại
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi email đã tồn tại:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi email đã tồn tại
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Fail    regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Email Đã Tồn Tại "existing@example.com"
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Email đã tồn tại trong hệ thống"

RT-CU-029 Tạo khách hàng thất bại khi thiếu thông tin bắt buộc
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi thiếu thông tin bắt buộc:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi thiếu thông tin bắt buộc
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Fail    regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Thiếu Thông Tin Bắt Buộc
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 400
    And Phản hồi phải chứa lỗi "Thông tin bắt buộc không được để trống"

RT-CU-030 Tạo khách hàng thất bại khi nhóm khách hàng không tồn tại
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi nhóm khách hàng không tồn tại:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi nhóm khách hàng không tồn tại
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Fail    regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Nhóm Khách Hàng Không Tồn Tại "Nhóm Không Tồn Tại"
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Nhóm khách hàng không tồn tại"

RT-CU-031 Tạo khách hàng thất bại khi chi nhánh không tồn tại
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi chi nhánh không tồn tại:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi chi nhánh không tồn tại
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Fail    regression
    Given Chuẩn Bị Dữ Liệu Tạo Khách Hàng Với ID Chi Nhánh 999999
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Chi nhánh không tồn tại"

RT-CU-032 Tạo khách hàng thất bại khi mã số thuế không hợp lệ
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi mã số thuế không hợp lệ:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi mã số thuế không hợp lệ
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Fail    regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Mã Số Thuế Không Hợp Lệ "INVALID_TAX"
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Mã số thuế không hợp lệ"

RT-CU-033 Tạo khách hàng thất bại khi số điện thoại không hợp lệ
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi số điện thoại không hợp lệ:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi số điện thoại không hợp lệ
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Fail    regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Số Điện Thoại Không Hợp Lệ "INVALID_PHONE"
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Số điện thoại không hợp lệ"

RT-CU-034 Tạo khách hàng thất bại khi ngày sinh không hợp lệ
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi ngày sinh không hợp lệ:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi ngày sinh không hợp lệ
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Fail    regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Ngày Sinh Không Hợp Lệ "32-13-2023"
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Ngày sinh không hợp lệ"

RT-CU-035 Tạo khách hàng thành công với thông tin tối thiểu
    [Documentation]    Kiểm tra tạo khách hàng thành công với thông tin tối thiểu:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng mới chỉ với tên (thông tin tối thiểu)
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Success    regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Tên "Khách Hàng Tối Thiểu"
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Tên Khách Hàng "Khách Hàng Tối Thiểu"
    [Teardown]   Xóa Khách Hàng From API

