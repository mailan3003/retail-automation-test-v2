


*** Settings ***
Resource    ../../Keywords/LanTest/Lan_CreateProduct_Keywords.robot
Resource    ../../Keywords/Utilities/ResponseHelper.robot
Suite Setup          Init Test Environment   ${ENV}    MHQL
Resource    ../../Keywords/Login/Login.robot



*** Test Cases ***


Tạo Sản Phẩm Cơ Bản Thành Công
    [Documentation]    Test tạo sản phẩm cơ bản thành công với các thông tin tối thiểu bắt buộc như tên, danh mục, đơn vị tính, giá bán
    [Tags]    lantesttt       
    Given Chuẩn bị dữ liệu tạo sản phẩm 
    When Gửi yêu cầu tạo sản phẩm Mới
    Then Mã trạng thái phải là 200
    And Xác thực sản phẩm đã được tạo trong DB
    [Teardown]     Xóa sản phẩm vừa tạo  ${DB_PRD_CODE}

    # RT-PRODUCT-001 Tạo Sản Phẩm Cơ Bản Thành Công
    # [Documentation]    Test tạo sản phẩm cơ bản thành công với các thông tin tối thiểu bắt buộc như tên, danh mục, đơn vị tính, giá bán
    # [Tags]    AIGenerated    CreateProduct434      regression        lantest       
    # Given Chuẩn Bị Dữ Liệu Sản Phẩm Cơ Bản 
    # When Gửi Yêu Cầu Tạo Sản Phẩm
    # Then Mã Trạng Thái Phải Là 200
    # And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    # [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 



