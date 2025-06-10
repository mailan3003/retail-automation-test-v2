*** Settings ***
Documentation     Test API tạo sản phẩm
Suite Setup       Init Test Environment   ${ENV}    MHQL
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Product/CreateProductKeywords.robot
Resource          ../../../Keywords/Product/InputValidationKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Product/Product_KeywordsCommand.robot
*** Variables ***
*** Test Cases ***
RT-PRODUCT-034 Tạo Sản Phẩm Với Thời Gian Bảo Hành
    [Documentation]    Test tạo sản phẩm có thời gian bảo hành
    [Tags]    AIGenerated    CreateProduct    Positive    Warranty    regression1789
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Thời Gian Bảo Hành Là 12 Tháng
    When Gửi Yêu Cầu Tạo Sản Phẩm
    And Save Warranty For Many Product  
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thời Gian Bảo Hành 12 Tháng
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

Tạo Sản Phẩm Serial Với Thời Gian Bảo Hành
    [Documentation]    Test tạo sản phẩm có thời gian bảo hành
    [Tags]    AIGenerated    CreateProduct    Positive    Warranty    regression178
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Serial Với Thời Gian Bảo Hành Là 12 Tháng
    When Gửi Yêu Cầu Tạo Sản Phẩm
    And Save Warranty For Many Product  
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thời Gian Bảo Hành 12 Tháng
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

Tạo Sản Phẩm Lôdate Với Thời Gian Bảo Hành
    [Documentation]    Test tạo sản phẩm có thời gian bảo hành
    [Tags]    AIGenerated    CreateProduct    Positive    Warranty    regression178
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Lôdate Với Thời Gian Bảo Hành Là 12 Tháng
    When Gửi Yêu Cầu Tạo Sản Phẩm
    And Save Warranty For Many Product  
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thời Gian Bảo Hành 12 Tháng
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

Tạo Sản Phẩm Hàng Đơn Vị Tính Có Bảo Hành
    [Documentation]    Test tạo sản phẩm có thời gian bảo hành
    [Tags]    AIGenerated    CreateProduct    Positive    Warranty    regression178
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Hàng Đơn Vị Tính Có Bảo Hành Là 12 Tháng
    When Gửi Yêu Cầu Tạo Sản Phẩm
    And Save Warranty For Many Product  
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thời Gian Bảo Hành 12 Tháng
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

Tạo Sản Phẩm Thuộc Tính Với Thời Gian Bảo Hành
    [Documentation]    Test tạo sản phẩm có thời gian bảo hành
    [Tags]    AIGenerated    CreateProduct    Positive    Warranty    regression178
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuộc Tính Với Thời Gian Bảo Hành Là 12 Tháng
    When Gửi Yêu Cầu Tạo Sản Phẩm
    And Save Warranty For Many Product  
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thời Gian Bảo Hành 12 Tháng
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

