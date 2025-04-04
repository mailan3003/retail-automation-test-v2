*** Settings ***
Documentation     Test cases API cho phần xử lý thông tin giao hàng
Resource          ../../../TestData/CommonData.robot
Resource          ../../../TestData/Invoice/DeliveryInfoData.robot
Resource          ../../../Keywords/Invoice/DeliveryInfoKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Utilities/RequestHelper.robot
Resource          ../../../Keywords/Utilities/DataUtilities.robot
Suite Setup       Suite Setup 
Suite Teardown    Suite Teardown
Test Setup        Test Setup
Test Teardown     Test Teardown
Library           Collections
Library           OperatingSystem
Library           json

*** Variables ***
${SUITE_NAME}    DeliveryInfoTest

*** Keywords ***
Suite Setup
    [Documentation]    Thực hiện trước khi chạy suite
    Set Suite Variable    ${SUITE_NAME}    ${SUITE_NAME}

Suite Teardown
    [Documentation]    Thực hiện sau khi hoàn thành suite
    Log     nothing

Test Setup
    [Documentation]    Thực hiện trước mỗi test case
    Log    Bắt đầu test case    console=True

Test Teardown
    [Documentation]    Thực hiện sau mỗi test case
    Log    Kết thúc test case    console=True

*** Test Cases ***
RT-DI-001 Tạo hóa đơn thành công với giao hàng COD đầy đủ thông tin
    [Documentation]    Kiểm tra tạo hóa đơn với giao hàng COD đầy đủ thông tin:
    ...    - Đơn hàng có UsingCod = 1
    ...    - Thông tin đầy đủ: Nguyễn Văn A, 0987654321, 123 Đường Test
    ...    - Hệ thống sẽ chuyển đổi từ DeliveryDetail sang DeliveryInfo và DeliveryPackage
    ...    - Đơn vị vận chuyển mặc định sẽ được tự động gán
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Giao Hàng COD
    When Gửi Yêu Cầu Tạo Hóa Đơn Có Giao Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Thông Tin Giao Hàng Trong Response
    And Xác Thực Thông Tin Giao Hàng Trong DB
    And Xác Thực Chi Tiết Thông Tin Giao Hàng    "1,Phường Ba Ngòi,Thành phố Cam Ranh, Khánh Hòa 03322553899"
    And Xác Thực Thông Tin Gói Hàng Trong DB
    #And Xác Thực Thông Tin Đơn Vị Vận Chuyển    ${DEFAULT_PARTNER_DELIVERY_ID} TODO

RT-DI-002 Tạo hóa đơn thất bại với giao hàng COD thiếu tên người nhận
    [Documentation]    Kiểm tra tạo hóa đơn với giao hàng COD thiếu tên người nhận:
    ...    - Thông tin thiếu ReceiverName
    ...    - Hệ thống sẽ trả về lỗi thiếu thông tin bắt buộc
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Giao Hàng COD Thiếu Thông Tin Người Nhận
    When Gửi Yêu Cầu Tạo Hóa Đơn Có Giao Hàng
    Then Response Status Code Should Be 420
    And Response Should Have Error "Đối tác giao hàng không hợp lệ. Vui lòng kiểm tra lại."

RT-DI-003 Tạo hóa đơn thất bại với giao hàng COD thiếu số điện thoại
    [Documentation]    Kiểm tra tạo hóa đơn với giao hàng COD thiếu số điện thoại:
    ...    - Thông tin thiếu ReceiverPhone
    ...    - Hệ thống sẽ trả về lỗi thiếu thông tin bắt buộc
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Giao Hàng COD Thiếu Số Điện Thoại
    When Gửi Yêu Cầu Tạo Hóa Đơn Có Giao Hàng
    Then Response Status Code Should Be 420
    And Response Should Have Error "Đối tác giao hàng không hợp lệ. Vui lòng kiểm tra lại."

RT-DI-004 Tạo hóa đơn thất bại với giao hàng COD thiếu địa chỉ giao hàng
    [Documentation]    Kiểm tra tạo hóa đơn với giao hàng COD thiếu địa chỉ:
    ...    - Thông tin thiếu ReceiverAddress
    ...    - Hệ thống sẽ trả về lỗi thiếu thông tin bắt buộc
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Giao Hàng COD Thiếu Địa Chỉ
    When Gửi Yêu Cầu Tạo Hóa Đơn Có Giao Hàng
    Then Response Status Code Should Be 420
    And Response Should Have Error "Đối tác giao hàng không hợp lệ. Vui lòng kiểm tra lại."

RT-DI-005 Tạo hóa đơn thành công với đơn vị vận chuyển được chỉ định
    [Documentation]    Kiểm tra tạo hóa đơn với đơn vị vận chuyển được chỉ định:
    ...    - DeliveryDetail.DeliveryBy = ${PARTNER_DELIVERY_1_ID} (Giao Hàng Nhanh)
    ...    - UseDefaultPartner = false
    ...    - Hệ thống sẽ sử dụng đơn vị vận chuyển đã chỉ định
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Đơn Vị Vận Chuyển Cụ Thể
    When Gửi Yêu Cầu Tạo Hóa Đơn Có Giao Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Thông Tin Giao Hàng Trong Response
    And Xác Thực Thông Tin Giao Hàng Trong DB
    And Xác Thực Thông Tin Đơn Vị Vận Chuyển    ${PARTNER_DELIVERY_1_ID}

RT-DI-006 Tạo hóa đơn thành công với đơn vị vận chuyển mặc định
    [Documentation]    Kiểm tra tạo hóa đơn với đơn vị vận chuyển mặc định:
    ...    - DeliveryDetail.UseDefaultPartner = true
    ...    - Hệ thống sẽ tìm kiếm hoặc tạo đơn vị vận chuyển mặc định
    ...    - Cập nhật thông tin DeliveryBy từ đơn vị mặc định
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Giao Hàng COD mặc định
    When Gửi Yêu Cầu Tạo Hóa Đơn Có Giao Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Thông Tin Giao Hàng Trong Response
    And Xác Thực Thông Tin Giao Hàng Trong DB
    And Xác Thực Thông Tin Đơn Vị Vận Chuyển    ${PARTNER_DELIVERY_1_ID}

RT-DI-007 Tạo hóa đơn thành công với giao hàng từ Facebook
    [Documentation]    Kiểm tra tạo hóa đơn giao hàng từ Facebook:
    ...    - Đơn hàng từ kênh Facebook (SaleChannelId = 2)
    ...    - Hệ thống sẽ cập nhật địa chỉ lấy hàng từ chi nhánh
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Từ Facebook
    When Gửi Yêu Cầu Tạo Hóa Đơn Có Giao Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Thông Tin Giao Hàng Trong Response
    And Xác Thực Thông Tin Giao Hàng Trong DB
    And Xác Thực Thông Tin Gói Hàng Trong DB
    And Xác Thực Địa Chỉ Lấy Hàng Từ Chi Nhánh

RT-DI-008 Cập nhật hóa đơn thành công với thông tin giao hàng mới
    [Documentation]    Kiểm tra cập nhật hóa đơn với thông tin giao hàng mới:
    ...    - Đơn hàng đã tồn tại (Id > 0)
    ...    - Hệ thống kiểm tra thông tin giao hàng hiện có
    ...    - Tạo thông tin giao hàng mới với IsCurrent = true
    ...    - Đánh dấu thông tin giao hàng cũ IsCurrent = false
    Given Chuẩn Bị Dữ Liệu Cập Nhật Hóa Đơn Có Giao Hàng
    #When Gửi Yêu Cầu Cập Nhật Hóa Đơn Có Giao Hàng
    When Gửi Yêu Cầu Tạo Hóa Đơn Có Giao Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Thông Tin Giao Hàng Trong Response
    And Xác Thực Thông Tin Giao Hàng Trong DB
    And Xác Thực Cập Nhật Thông Tin Giao Hàng

RT-DI-009 Tạo hóa đơn thành công với thông tin người nhận tùy chỉnh
    [Documentation]    Kiểm tra tạo hóa đơn với tên người nhận tùy chỉnh:
    ...    - ReceiverName = "Trần Thị B"
    ...    - Hệ thống lưu thông tin người nhận tùy chỉnh vào DeliveryInfo
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Giao Hàng COD Có Người Nhận Trần Thị B
    When Gửi Yêu Cầu Tạo Hóa Đơn Có Giao Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Thông Tin Giao Hàng Trong Response
    And Xác Thực Thông Tin Giao Hàng Trong DB
    And Xác Thực Chi Tiết Thông Tin Giao Hàng    "1,Phường Ba Ngòi,Thành phố Cam Ranh, Khánh Hòa 03322553899"

RT-DI-010 Tạo hóa đơn thành công với số điện thoại tùy chỉnh
    [Documentation]    Kiểm tra tạo hóa đơn với số điện thoại tùy chỉnh:
    ...    - ReceiverPhone = "0123456789"
    ...    - Hệ thống lưu thông tin số điện thoại tùy chỉnh vào DeliveryInfo
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Giao Hàng COD Có Số Điện Thoại 0123456789
    When Gửi Yêu Cầu Tạo Hóa Đơn Có Giao Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Thông Tin Giao Hàng Trong Response
    And Xác Thực Thông Tin Giao Hàng Trong DB
    And Xác Thực Chi Tiết Thông Tin Giao Hàng    "1,Phường Ba Ngòi,Thành phố Cam Ranh, Khánh Hòa 03322553899"