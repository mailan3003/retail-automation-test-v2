*** Settings ***

Resource    ../../Keywords/Utilities/ResponseHelper.robot
Resource    ../../Keywords/LanTest/Branch_keywords.robot

*** Test Cases ***
RT-BRANCH-001 Tạo thành công chi nhánh mới
    [Tags]    lanbranch
    Given Chuẩn bị dữ liệu tạo chi nhánh
    When Gửi yêu cầu tạo chi nhánh
    Then Mã trạng thái phải là 200
    And Trong db tồn tại chi nhánh với tên vừa tạo
    [Teardown]    Xóa chi nhánh vừa tạo

RT-BRANCH-002 Tạo không thành công chi nhánh mới với tên đã tồn tại
    [Tags]    lanbranch
    Given Chuẩn bị dữ liệu tạo chi nhánh với tên đã tồn tại
    When Gửi yêu cầu tạo chi nhánh
    Then Mã trạng thái phải là 420
    And Kiểm tra message lỗi    Chi nhánh đã tồn tại

RT-BRANCH-003 Tạo không thành công chi nhánh mới bỏ trống trường tên
    [Tags]    lanbranch
    Given Chuẩn bị dữ liệu tạo chi nhánh với trường tên rỗng
    When Gửi yêu cầu tạo chi nhánh
    Then Mã trạng thái phải là 420
    And Kiểm tra message lỗi    Bạn chưa nhập tên chi nhánh


RT-BRANCH-004 Tạo không thành công chi nhánh mới bỏ trống số điện thoại
    [Tags]    lanbranch
    Given Chuẩn bị dữ liệu tạo chi nhánh với trường sđt rỗng
    When Gửi yêu cầu tạo chi nhánh
    Then Mã trạng thái phải là 420
    And Kiểm tra message lỗi    Bạn chưa nhập số điện thoại

RT-BRANCH-005 Tạo không thành công chi nhánh mới với field lỗi
    [Tags]    lanbranch
    Given Chuẩn bị dữ liệu tạo chi nhánh với field lỗi    Name    ${EMPTY}
    When Gửi yêu cầu tạo chi nhánh
    Then Mã trạng thái phải là 420
    And Kiểm tra message lỗi    Bạn chưa nhập tên chi nhánh

RT-BRANCH-007 Chuyển trạng thái hoạt động sang ngừng hoạt động
    [Documentation]    Trạng thái hoạt động ban đầu là 0, chuyển sang 1
    [Tags]    lanbranch
    Given Chuẩn bị dữ liệu chi nhánh    ${BRANCH_INACTIVE_ID}    false
    When Gửi yêu cầu chuyển trạng thái chi nhánh
    Then Mã trạng thái phải là 200
    And Chuyển trạng thái hoạt động thành công    ${BRANCH_INACTIVE_ID}    1
    [Teardown]    Trả lại trạng thái chi nhánh ban đầu    ${BRANCH_INACTIVE_ID}    0

RT-BRANCH-006 Chuyển trạng thái ngừng hoạt động sang hoạt động
    [Documentation]    Trạng thái hoạt động ban đầu là 1, chuyển sang 0
    [Tags]    lanbranch
    Given Chuẩn bị dữ liệu chi nhánh    ${BRANCH_ACTIVE_ID}    true
    When Gửi yêu cầu chuyển trạng thái chi nhánh
    Then Mã trạng thái phải là 200
    And Chuyển trạng thái hoạt động thành công    ${BRANCH_ACTIVE_ID}    0
    [Teardown]    Trả lại trạng thái chi nhánh ban đầu    ${BRANCH_ACTIVE_ID}    1






