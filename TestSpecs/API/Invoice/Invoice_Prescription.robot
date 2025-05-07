*** Settings ***
Documentation    Test cases for pharmacy prescription validation in invoices
Resource         ../../../Keywords/Invoice/PrescriptionKeywords.robot
Resource         ../../../Keywords/Utilities/ResponseHelper.robot
Resource         ../../../Keywords/Utilities/DataUtilities.robot
Resource         ../../../Keywords/Utilities/RequestHelper.robot
Resource         ../../../TestData/Invoice/PrescriptionData.robot
Resource    ../../../Keywords/Invoice/InventoryUpdateKeywords.robot
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
    [Teardown]    Tear down Delete Hóa Đơn
RT-PR-003 Kiểm tra thiếu thông tin đơn thuốc và bệnh nhân
    [Documentation]    Kiểm tra lỗi khi không cung cấp thông tin đơn thuốc và bệnh nhân
    [Tags]    prescription     nhathuoc   
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với UsingPrescription=1 Không Có Thông Tin Đơn Thuốc Và Bệnh Nhân
    When Gửi Yêu Cầu Tạo Hóa Đơn Với BranchId   
    Then Response Status Code Should Be 420
    And Response Should Have Error "${KV_MESSAGE_PRESCRIPTION_EMPTY}"

RT-PR-004 Kiểm tra thiếu thông tin đơn thuốc
    [Documentation]    Kiểm tra lỗi khi không cung cấp thông tin đơn thuốc nhưng có thông tin bệnh nhân
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với UsingPrescription=1 Thiếu Thông Tin Đơn Thuốc
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 400
    And Response Should Have Error "${KV_MESSAGE_PRESCRIPTION_EMPTY}"
    And Xác Thực Hóa Đơn Không Tồn Tại Trong DB

RT-PR-005 Kiểm tra thiếu thông tin bệnh nhân
    [Documentation]    Kiểm tra lỗi khi không cung cấp thông tin bệnh nhân nhưng có thông tin đơn thuốc
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với UsingPrescription=1 Thiếu Thông Tin Bệnh Nhân
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 400
    And Response Should Have Error "${KV_MESSAGE_PRESCRIPTION_EMPTY}"
    And Xác Thực Hóa Đơn Không Tồn Tại Trong DB

RT-PR-006 Kiểm tra thiếu mô tả cách dùng thuốc khi sử dụng đơn thuốc toàn cầu
    [Documentation]    Kiểm tra lỗi khi sử dụng đơn thuốc toàn cầu nhưng không có mô tả cách dùng cho thuốc
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với UsingGlobalPrescription=1 Và Thuốc Không Có Mô Tả
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 400
    And Response Should Have Error "${KV_MESSAGE_INVOICE_PRODUCT_NO_DESCRIPTION}"
    And Xác Thực Hóa Đơn Không Tồn Tại Trong DB

RT-PR-007 Kiểm tra xác thực thuốc hết hạn
    [Documentation]    Kiểm tra lỗi khi có thuốc hết hạn trong đơn thuốc
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với Thuốc Hết Hạn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 400
    And Response Should Have Error Containing "${KV_MESSAGE_MEDICINE_PRODUCT_CODE_SOLD_OUT}"
    And Xác Thực Hóa Đơn Không Tồn Tại Trong DB

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
    [Teardown]    Tear down Delete Hóa Đơn

RT-PR-009 Kiểm tra xác thực mã đơn thuốc đã tồn tại
    [Documentation]    Kiểm tra lỗi khi mã đơn thuốc đã tồn tại trong hệ thống
    [Tags]    prescription     nhathuoc       
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với Mã Đơn Thuốc Đã Tồn Tại
    When Gửi Yêu Cầu Tạo Hóa Đơn Với BranchId
    Then Mã trạng thái phải là 420
    And Response Should Have Error "Mã đơn thuốc DT000001 đã tồn tại trong hệ thống"


RT-PR-010 Kiểm tra xác thực mã đơn thuốc không hợp lệ
    [Documentation]    Kiểm tra lỗi khi ID đơn thuốc > 0 nhưng không có mã đơn thuốc
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với ID Đơn Thuốc > 0 Và Không Có Mã
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 400
    And Response Should Have Error "${KV_MESSAGE_PRESCRIPTION_CODE_IS_NOT_VALID}"
    And Xác Thực Hóa Đơn Không Tồn Tại Trong DB

RT-PR-011 Kiểm tra thành công với thông tin đơn thuốc và bệnh nhân đầy đủ
    [Documentation]    Kiểm tra tạo thành công hóa đơn với thông tin đơn thuốc và bệnh nhân đầy đủ
    [Tags]    prescription     nhathuoc        
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với Thông Tin Đơn Thuốc Và Bệnh Nhân Đầy Đủ
    When Gửi Yêu Cầu Tạo Hóa Đơn Với BranchId
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id

RT-PR-012 Kiểm tra thành công với đơn thuốc toàn cầu
    [Documentation]    Kiểm tra tạo thành công hóa đơn với đơn thuốc toàn cầu và các sản phẩm có mô tả đầy đủ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với UsingGlobalPrescription=1 Và Mô Tả Đầy Đủ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Được Tạo Thành Công Trong DB
    And Xác Thực Thông Tin Đơn Thuốc Toàn Cầu Được Lưu Trong DB

RT-PR-013 Kiểm tra thành công với mã đơn thuốc trong đơn thuốc toàn cầu
    [Documentation]    Kiểm tra tạo thành công hóa đơn với mã đơn thuốc trong đơn thuốc toàn cầu dù mã đã tồn tại
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với UsingGlobalPrescription=1 Và Mã Đơn Đã Tồn Tại
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Được Tạo Thành Công Trong DB 