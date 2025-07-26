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
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Tên ${EMPTY}
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Bạn chưa nhập Tên khách hàng"

RT-CU-017 Tạo khách hàng thất bại với tên khách hàng dài 256 ký tự
    [Documentation]    Kiểm tra tạo khách hàng thất bại với tên khách hàng dài 256 ký tự:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng mới với tên khách hàng được chỉ định
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Fail    regression
    ${random_name}=    Generate Random String   256   [NUMBERS]
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Tên ${random_name}
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Có lỗi khi lưu thông tin khách hàng, Vui lòng chờ trong giây lát và thử lại."


RT-CU-004 Tạo khách hàng thất bại khi số điện thoại đã tồn tại
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi số điện thoại đã tồn tại:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi số điện thoại đã tồn tại
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Fail   regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Số Điện Thoại "${EXISTING_PHONE}"
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Số điện thoại ${EXISTING_PHONE} đã tồn tại ${EMPTY} trong hệ thống."



RT-CU-005 Tạo khách hàng thất bại khi email không hợp lệ
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi email không hợp lệ:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi email không hợp lệ
    ...    - Code: POST /customers
    [Tags]   API Không Chặn
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Email invalid_email
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Email không hợp lệ."


RT-CU-011 Tạo khách hàng thất bại khi người phụ trách không tồn tại
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi người phụ trách không tồn tại:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi người phụ trách không tồn tại
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    regression   
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Người Phụ Trách Theo ID 999999
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 500



RT-CU-027 Tạo khách hàng thất bại khi mã khách hàng đã tồn tại
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi mã khách hàng đã tồn tại:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi mã khách hàng đã tồn tại
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Fail    regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Mã Khách Hàng KH127
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Mã khách hàng KH127 đã tồn tại ${EMPTY} trong hệ thống."


RT-CU-016 Tạo khách hàng Không Thành Công Với Mã Khách Hàng Dài 51 Ký Tự
    [Documentation]    Kiểm tra tạo khách hàng thành công với mã khách hàng tùy chỉnh:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Tạo khách hàng mới với mã khách hàng được chỉ định
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Fail    regression
    ${random_code}=    Generate Random String   51   [NUMBERS]
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Mã Khách Hàng ${random_code}
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Vui lòng nhập Mã khách hàng không quá 50 kí tự"



RT-CU-030 Tạo khách hàng thất bại khi nhóm khách hàng không tồn tại
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi nhóm khách hàng không tồn tại:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi nhóm khách hàng không tồn tại
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    Fail    regression
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với ID Nhóm Khách Hàng 325325
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Nhóm khách hàng đã không còn tồn tại trong hệ thống"

RT-CU-031 Tạo khách hàng thất bại khi chi nhánh không tồn tại
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi chi nhánh không tồn tại:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi chi nhánh không tồn tại
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    regression   
    Given Chuẩn Bị Dữ Liệu Tạo Khách Hàng Với ID Chi Nhánh 999999
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Có lỗi khi lưu thông tin khách hàng, Vui lòng chờ trong giây lát và thử lại."


RT-CU-033 Tạo khách hàng thất bại khi số điện thoại đã tồn tại khác nhau khoảng trống
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi số điện thoại không hợp lệ:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi số điện thoại không hợp lệ
    ...    - Code: POST /customers
    [Tags]    AIGenerated    Customer    Create    regression   
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Số Điện Thoại "098 225 6512"
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Số điện thoại 098 225 6512 đã tồn tại ${EMPTY} trong hệ thống."

RT-CU-034 Tạo khách hàng thất bại khi ngày sinh không hợp lệ
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi ngày sinh không hợp lệ:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi ngày sinh không hợp lệ
    ...    - Code: POST /customers
    [Tags]    API Không Chặn    lantestthu
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Ngày Sinh 32-13-2023
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Ngày sinh không hợp lệ"

RT-CU-035 Tạo khách hàng thất bại khi ngày sinh không hợp lệ
    [Documentation]    Kiểm tra tạo khách hàng thất bại khi ngày sinh không hợp lệ:
    ...    - Source: CustomerApi.cs > Post(CustomerCreateOrUpdate req)
    ...    - Logic: Không cho phép tạo khách hàng khi ngày sinh không hợp lệ
    ...    - Code: POST /customers
    [Tags]    API Không Chặn
    Given Chuẩn Bị Dữ Liệu Khách Hàng Với Ngày Sinh 32-13-2023
    When Gửi Yêu Cầu Tạo Khách Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Ngày sinh không hợp lệ"

