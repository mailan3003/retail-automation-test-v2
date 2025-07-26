*** Settings ***
Resource    ../Env_live.robot
Suite Setup    Get token
Resource    ../Keywords/Login_keywords.robot
Resource    ../Keywords/Product_keywords.robot


*** Variables ***
@{COLOR}    Blue    Red    Yellow
@{SIZE}    S    M    L
&{list_attribuites}    COLOR=@{COLOR}    SIZE=@{SIZE}


*** Test Cases ***
Tạo sản phẩm thành công
    Given Chuẩn bị dữ liệu sản phẩm cơ bản
    When Gửi yêu cầu tạo sản phẩm
    Then Lấy danh sách sản phẩm
    [Teardown]    Xóa sản phẩm đầu tiên trong danh sách

Tạo sản phẩm với nhiều thuộc tính thành công
    Given Chuẩn bị dữ liệu sản phẩm với thuộc tính ${list_attribuites}
    When Gửi yêu cầu tạo sản phẩm