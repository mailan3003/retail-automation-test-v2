*** Settings ***
Documentation     Test API tạo sản phẩm
Resource          ../../../Keywords/Product/CreateProductKeywords.robot
Resource          ../../../Keywords/Product/InputValidationKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Product/Product_Medicine_Keywords.robot
Resource          ../../../Keywords/Product/Product_KeywordsCommand.robot
Resource          ../../../Config/Env_api.robot



*** Variables ***
@{value_attribute_1}   L  M   S
&{dict_attribute_name_1}    SIZE=@{value_attribute_1}
@{name_unit}     hai    nửa
@{value}    2    3
*** Test Cases ***
RT-PRODUCT-008 Tạo Sản Phẩm Là Thuốc
    [Documentation]    Test tạo sản phẩm là thuốc với thông tin đầy đủ theo yêu cầu GPP
    [Tags]    AIGenerated    CreateProduct    Positive    Medicine   
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Là Thuốc
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Tự Động Được Cấu Hình Quản Lý Lô Và Hạn Sử Dụng

RT-PRODUCT-009 Tạo Sản Phẩm Thuốc Có Nhiều Đơn Vị Tính
    [Documentation]    Test tạo sản phẩm là thuốc với nhiều đơn vị tính (hộp, vỉ, viên)
    [Tags]    AIGenerated    CreateProduct    Positive    Medicine   
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Có Nhiều Đơn Vị Tính
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Đơn Vị Tính Của Sản Phẩm Thuốc Được Tạo Chính Xác

RT-PRODUCT-010 Tạo Sản Phẩm Thuốc Với Giới Hạn Tồn Kho
    [Documentation]    Test tạo sản phẩm là thuốc với cấu hình giới hạn tồn kho tối thiểu và tối đa
    [Tags]    AIGenerated    CreateProduct    Positive    Medicine
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Giới Hạn Tồn Kho
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Có Giới Hạn Tồn Kho Tối Thiểu 10 Và Tối Đa 100 Ở Chi Nhánh Chi trung

RT-PRODUCT-011 Tạo Sản Phẩm Thuốc Với Thuế
    [Documentation]    Test tạo sản phẩm là thuốc với thuế 5%
    [Tags]    AIGenerated    CreateProduct    Positive    Medicine
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Thuế
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Có Thuế 5 Theo Dữ Liệu Đã Gửi

RT-PRODUCT-012 Tạo Sản Phẩm Thuốc Ngừng Kinh Doanh
    [Documentation]    Test tạo sản phẩm là thuốc với trạng thái ngừng kinh doanh
    [Tags]    AIGenerated    CreateProduct    Positive    Medicine
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Ngừng Kinh Doanh
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Có Trạng Thái Ngừng Kinh Doanh

RT-PRODUCT-013 Tạo Sản Phẩm Thuốc Với Tồn Kho Ban Đầu
    [Documentation]    Test tạo sản phẩm là thuốc với tồn kho ban đầu là 20
    [Tags]    AIGenerated    CreateProduct    Positive    Medicine
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Tồn Kho Ban Đầu 20
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Có Tồn Kho Ban Đầu 20

RT-PRODUCT-014 Tạo Sản Phẩm Thuốc Không Thành Công Khi Trùng Mã Sản Phẩm
    [Documentation]    Test tạo sản phẩm là thuốc thất bại khi trùng mã sản phẩm đã tồn tại
    [Tags]    AIGenerated    CreateProduct    Negative    Medicine
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Mã Trùng Lặp
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Mã hàng đã tồn tại"

*** Keywords ***
