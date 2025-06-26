*** Settings ***
Resource    ../../../Keywords/Utilities/ResponseHelper.robot
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource    ../../../Keywords/Invoice/EInvoice_Keywords.robot
Resource    ../../../Keywords/Utilities/RequestHelper.robot
Resource    ../../../Keywords/Utilities/ResponseHelper.robot
Resource    ../../../TestData/Invoice/EInvoice.robot
Resource    ../../../Keywords/Login/Login.robot

*** Test Cases ***

RT-INPV-01 Tạo hóa đơn điện tử thành công
    [Documentation]    Tạo hóa đơn điện tử từ hóa đơn đã tạo
    ...    - Dữ liệu đầu vào: Hóa đơn hợp lệ với sản phẩm đơn giá 68000 VND, số lượng 1
    ...    - Logic kiểm tra: Tạo hóa đơn trước, sau đó tạo hóa đơn điện tử với Invoice ID từ response
    ...    - Kỳ vọng: Tạo thành công hóa đơn điện tử với các tham số cố định (Includes, PartnerType, EInvoiceTemplateId)
    [Tags]    apieinvoice   apiroundingtotalamount
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá 68000 VND Số Lượng 1
    When Gửi Yêu Cầu Tạo Hóa Đơn
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử 
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử
    Then Response Status Code Should Be 200
    And Nội Dung Phản Hồi Phải Tồn Tại Code HDDT
    And Xác Thực Hóa Đơn Điện Tử Đã Tạo Thành Công

RT-INPV-02 Tạo hóa đơn điện tử với hóa đơn đã phát hành
    [Documentation]    Tạo hóa đơn điện tử với hóa đơn đã phát hành
    ...    - Dữ liệu đầu vào: Hóa đơn đã phát hành
    ...    - Logic kiểm tra: Tạo hóa đơn điện tử với hóa đơn đã phát hành
    ...    - Kỳ vọng: Tạo không thành công hóa đơn điện tử 
    [Tags]    apieinvoice
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá 68000 VND Số Lượng 1
    When Gửi Yêu Cầu Tạo Hóa Đơn
    And Nội dung phản hồi trả về phải tồn tại Id
    And Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử 
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử
    And Xác Thực Hóa Đơn Điện Tử Đã Tạo Thành Công
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử
    Then Response Status Code Should Be 420

RT-INPV-03 Tạo hóa đơn điện tử với hóa đơn đã phát hành
    [Documentation]    Tạo hóa đơn điện tử với hóa đơn đã phát hành
    ...    - Dữ liệu đầu vào: Hóa đơn đã phát hành
    ...    - Logic kiểm tra: Tạo hóa đơn điện tử với hóa đơn đã phát hành
    ...    - Kỳ vọng: Tạo không thành công hóa đơn điện tử 
    [Tags]    apieinvoice
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá 68000 VND Số Lượng 1
    When Gửi Yêu Cầu Tạo Hóa Đơn
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử 
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử
    Then Response Status Code Should Be 420
    And Nội dung phản hồi phải chứa message DataExisted

RT-INPV-04 Tạo Hóa đơn điện tử không có template HDDT
    [Documentation]    Tạo Hóa đơn điện tử không có template HDDT
    ...    - Dữ liệu đầu vào: Hóa đơn đã phát hành
    ...    - Logic kiểm tra: Tạo hóa đơn điện tử không có template HDDT
    ...    - Kỳ vọng: Tạo không thành công hóa đơn điện tử 
    [Tags]    apieinvoice
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá 68000 VND Số Lượng 1
    When Gửi Yêu Cầu Tạo Hóa Đơn
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử Không Template
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử
    Then Response Status Code Should Be 420

RT-INPV-05 Tạo Hóa đơn điện tử thành công với hóa đơn đã hủy
    [Documentation]     Tạo Hóa đơn điện tử thành công với hóa đơn đã hủy
    ...    - Dữ liệu đầu vào: Hóa đơn đã hủy
    ...    - Logic kiểm tra: Tạo hóa đơn điện tử với hóa đơn đã hủy
    ...    - Kỳ vọng: Tạo không thành công hóa đơn điện tử 
    [Tags]    apieinvoice
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá 68000 VND Số Lượng 1
    When Gửi Yêu Cầu Tạo Hóa Đơn
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Cập Nhật Hóa Đơn Sang Trạng Thái Hủy
    And Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử
    Then Response Status Code Should Be 200
    And Nội Dung Phản Hồi Phải Tồn Tại Code HDDT
    And Xác Thực Hóa Đơn Điện Tử Đã Tạo Thành Công

RT-INPV-06 Tạo Hóa đơn điện tử thành công với hóa đơn giao hàng
    [Documentation]     Tạo Hóa đơn điện tử thành công với hóa đơn giao hàng
    ...    - Dữ liệu đầu vào: Hóa đơn đã giao hàng
    ...    - Logic kiểm tra: Tạo hóa đơn điện tử với hóa đơn giao hàng
    ...    - Kỳ vọng: Tạo thành công hóa đơn điện tử 
    [Tags]    apieinvoice
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Cơ Bản Chi Nhánh ${DEFAULT_BRANCH_ID}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Cập nhật hóa đơn sang hình thức giao hàng
    And Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử
    Then Response Status Code Should Be 200
    And Nội Dung Phản Hồi Phải Tồn Tại Code HDDT
    And Xác Thực Hóa Đơn Điện Tử Đã Tạo Thành Công

RT-INPV-07 Tạo Hóa đơn điện tử với user không có quyền xuất hóa đơn điện tử
#  API không chặn lỗi user không có quyền xuất hóa đơn điện tử
    [Documentation]    Tạo Hóa đơn điện tử với user không có quyền xuất hóa đơn điện tử
    ...    - Dữ liệu đầu vào: Hóa đơn được tạo bởi user autotest
    ...    - Logic kiểm tra: User autotest tạo hóa đơn và thử xuất hóa đơn điện tử
    ...    - Kỳ vọng: Tạothành công hóa đơn điện tử
    [Tags]    apieinvoice

    Given Thiết Lập Session Cho User Autotest    autotest    Autotest1
    And Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá 68000 VND Số Lượng 1
    When Gửi Yêu Cầu Tạo Hóa Đơn Với User Autotest
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử Với User Autotest
    Then Response Status Code Should Be 200
