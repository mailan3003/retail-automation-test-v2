*** Settings ***
Documentation    Test cases for pharmacy prescription validation in invoices
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../../Keywords/Login/Login.robot
Resource         ../../../Keywords/Invoice/PrescriptionKeywords.robot
Resource         ../../../Keywords/Utilities/ResponseHelper.robot
Resource         ../../../Keywords/Utilities/DataUtilities.robot
Resource         ../../../Keywords/Utilities/RequestHelper.robot
Resource         ../../../TestData/Invoice/PrescriptionData.robot
Resource         ../../../Keywords/Invoice/InventoryUpdateKeywords.robot
Resource        ../../../Keywords/Invoice/InvoiceCommonKeywords.robot

*** Test Cases ***
RT-PR-001 Kiểm tra tạo hóa đơn theo đơn thuốc
    [Documentation]    Kiểm tra hệ thống tạo hóa đơn theo đơn thuốc
    [Tags]         
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Có Liên Kết Theo Đơn Thuốc 
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Thông Tin Đơn Thuốc Được Lưu Trong DB

RT-PR-002 Tạo hóa đơn với cửa hàng không phải nhà thuốc GPP
    [Documentation]    Kiểm tra hệ thống bỏ qua xác thực đơn thuốc khi cửa hàng không phải nhà thuốc GPP
    [Tags]     prescription      nhathuoc
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Không Liên Kết Theo Đơn Thuốc
    When Gửi Yêu Cầu Tạo Hóa Đơn Với BranchId
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác định hóa đơn Không sử dụng đơn thuốc
    [Teardown]    Delete Invoice From API
RT-PR-003 Kiểm tra thiếu thông tin đơn thuốc và bệnh nhân
    [Documentation]    Kiểm tra lỗi khi không cung cấp thông tin đơn thuốc và bệnh nhân
    [Tags]    prescription     nhathuoc   
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với UsingPrescription=1 Không Có Thông Tin Đơn Thuốc Và Bệnh Nhân
    When Gửi Yêu Cầu Tạo Hóa Đơn Với BranchId   
    Then Response Status Code Should Be 420
    And Response Should Have Error "${KV_MESSAGE_PRESCRIPTION_EMPTY}"

RT-PR-008 Kiểm tra xác thực mã đơn thuốc vượt quá 50 ký tự
    [Documentation]    Kiểm tra lỗi khi mã đơn thuốc vượt quá 50 ký tự
    [Tags]    prescription     nhathuoc       
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với Mã Đơn Thuốc 51 Ký Tự
    When Gửi Yêu Cầu Tạo Hóa Đơn Với BranchId
    Then Mã trạng thái phải là 420
    And Response Should Have Error "Vui lòng nhập Mã đơn thuốc không quá 50 kí tự"

RT-PR-009 Kiểm tra xác thực mã đơn thuốc đúng 50 ký tự
    [Documentation]    Kiểm tra lỗi khi mã đơn thuốc đúng 50 ký tự
    [Tags]    prescription     nhathuoc       
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với Mã Đơn Thuốc 50 Ký Tự
    When Gửi Yêu Cầu Tạo Hóa Đơn Với BranchId
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Thông Tin Đơn Thuốc Được Lưu Trong DB
    And Xác Thực Hóa Đơn Có Đơn Thuốc Bán Theo Đơn ${PRESCRIPTION_ID}
    [Teardown]    Delete Invoice From API

RT-PR-009 Kiểm tra xác thực mã đơn thuốc đã tồn tại
    [Documentation]    Kiểm tra lỗi khi mã đơn thuốc đã tồn tại trong hệ thống
    [Tags]    prescription     nhathuoc       
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với Mã Đơn Thuốc Đã Tồn Tại
    When Gửi Yêu Cầu Tạo Hóa Đơn Với BranchId
    Then Mã trạng thái phải là 420
    And Response Should Have Error "Mã đơn thuốc DT000001 đã tồn tại trong hệ thống"


RT-PR-011 Kiểm tra thành công với thông tin đơn thuốc và bệnh nhân đầy đủ
    [Documentation]    Kiểm tra tạo thành công hóa đơn với thông tin đơn thuốc và bệnh nhân đầy đủ
    [Tags]    prescription     nhathuoc        
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với Thông Tin Đơn Thuốc Và Bệnh Nhân Đầy Đủ
    When Gửi Yêu Cầu Tạo Hóa Đơn Với BranchId
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
     [Teardown]    Delete Invoice From API
