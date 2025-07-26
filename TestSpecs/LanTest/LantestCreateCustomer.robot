*** Settings ***
Suite Setup       Init Test Environment   ${ENV}    MHQL
Resource           ../../Keywords/Login/Login.robot


*** Settings ***
Resource    ../../Keywords/LanTest/LanTest_Chuanbidata_Keywords.robot
Resource    ../../Keywords/LanTest/LanTest_action_Keywords.robot
Resource    ../../Config/Env_${ENV}.robot
Resource    ../../TestData/Customer/CustomerCommonData.robot
Library    ../../Resources/DatabaseLibrary.py
Resource    ../../TestData/LanTest/Lan_testdata.robot
Library           BuiltIn
Library           Collections
Library           DateTime
Library           json

Library    OperatingSystem

*** Test Case ***
TC-01 Tạo khách hàng thành công với thông tin cơ bản
    [Documentation]    Tạo khách hàng thành công với thông tin cơ bản về tên, sđt, email, facebook
    [Tags]    Lantesttt
    Given Chuẩn bị dữ liệu khách hàng với tên ${Customer_Name} Số điện thoại ${Customer_Phone} email ${Customer_Email} facebook ${Customer_Facebook}
    When Gửi yêu cầu tạo mới khách hàng
    Then Mã trạng thái phải là 200
    And Xác thực thông tin khách hàng đã được tạo với tên ${Customer_Name} facebook ${Customer_Facebook}
    And Xác Thực Khách Hàng Có SDT ${Customer_Phone} Email ${Customer_Email}
    [Teardown]    Xóa khách hàng được tạo từ API



