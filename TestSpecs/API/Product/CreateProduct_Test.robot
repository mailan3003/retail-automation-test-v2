*** Settings ***
Documentation     Test API tạo sản phẩm
Resource          ../../../Keywords/Product/CreateProductKeywords.robot
Resource          ../../../Keywords/Product/InputValidationKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot

Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    CreateProductTest

*** Test Cases ***
RT-PRODUCT-001 Tạo Sản Phẩm Cơ Bản Thành Công
    [Documentation]    Test tạo sản phẩm cơ bản thành công với các thông tin tối thiểu bắt buộc như tên, danh mục, đơn vị tính, giá bán
    [Tags]    AIGenerated    CreateProduct        Positive4354
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Cơ Bản 
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    #And Xác Thực Sản Phẩm Có Thông Tin Chính Xác Theo Dữ Liệu Đã Gửi

RT-PRODUCT-002 Tạo Sản Phẩm Với Mã Tự Động
    [Documentation]    Test tạo sản phẩm khi không cung cấp mã, hệ thống sẽ tự sinh mã
    [Tags]    AIGenerated    CreateProduct    Positive   
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Không Có Mã
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Được Tạo Với Mã Tự Sinh

RT-PRODUCT-003 Tạo Sản Phẩm Với Nhiều Đơn Vị Tính
    [Documentation]    Test tạo sản phẩm có nhiều đơn vị tính với tỷ lệ quy đổi
    [Tags]    AIGenerated    CreateProduct    Positive    UnitConversion
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Nhiều Đơn Vị Tính
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Con Được Tạo Với Đúng Tỷ Lệ Quy Đổi

RT-PRODUCT-004 Tạo Sản Phẩm Với Tồn Kho Ban Đầu
    [Documentation]    Test tạo sản phẩm với tồn kho ban đầu
    [Tags]    AIGenerated    CreateProduct    Positive    Inventory   
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Tồn Kho 50.5 Ban Đầu   
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Tồn Kho 50.5 Ở Chi Nhánh Chi nhánh trung tâm

RT-PRODUCT-005 Tạo Sản Phẩm Quản Lý Lô Và Hạn Sử Dụng
    [Documentation]    Test tạo sản phẩm có quản lý theo lô và hạn sử dụng
    [Tags]    AIGenerated    CreateProduct    Positive    BatchExpiry   
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Quản Lý Lô Và Hạn Sử Dụng
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Được Cấu Hình Quản Lý Lô Và Hạn Sử Dụng

RT-PRODUCT-006 Tạo Sản Phẩm Quản Lý Serial
    [Documentation]    Test tạo sản phẩm có quản lý theo serial
    [Tags]    AIGenerated    CreateProduct    Positive    Serial   
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Quản Lý Serial
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Được Cấu Hình Quản Lý Serial

RT-PRODUCT-007 Tạo Sản Phẩm Với Thuộc Tính
    [Documentation]    Test tạo sản phẩm có thuộc tính
    [Tags]    AIGenerated    CreateProduct    Positive    Attributes
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuộc Tính Theo Dữ Liệu Đã Gửi

RT-PRODUCT-008 Tạo Sản Phẩm Là Thuốc
    [Documentation]    Test tạo sản phẩm là thuốc với thông tin đầy đủ theo yêu cầu GPP
    [Tags]    AIGenerated    CreateProduct    Positive    Medicine
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Là Thuốc
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Tự Động Được Cấu Hình Quản Lý Lô Và Hạn Sử Dụng

RT-PRODUCT-009 Tạo Sản Phẩm Với Thuế
    [Documentation]    Test tạo sản phẩm có thuế
    [Tags]    AIGenerated    CreateProduct    Positive     
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế 5 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế Theo Dữ Liệu Đã Gửi

RT-PRODUCT-010 Tạo Sản Phẩm Loại Combo
    [Documentation]    Test tạo sản phẩm loại combo
    [Tags]    AIGenerated    CreateProduct    Positive    Combo       
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Loại Combo
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Combo Có Chứa Các Thành Phần Theo Dữ Liệu Đã Gửi

RT-PRODUCT-011 Tạo Sản Phẩm Thiếu Tên
    [Documentation]    Test tạo sản phẩm khi thiếu tên (bắt buộc)
    [Tags]    AIGenerated    CreateProduct    Negative    Validation
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thiếu Tên
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Tên sản phẩm không được để trống"

RT-PRODUCT-012 Tạo Sản Phẩm Với Mã Đã Tồn Tại
    [Documentation]    Test tạo sản phẩm khi mã đã tồn tại trong hệ thống
    [Tags]    AIGenerated    CreateProduct    Negative    Validation
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Mã Đã Tồn Tại
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Mã sản phẩm đã tồn tại"

RT-PRODUCT-013 Tạo Sản Phẩm Với Giá Bán Âm
    [Documentation]    Test tạo sản phẩm với giá bán là số âm
    [Tags]    AIGenerated    CreateProduct    Negative    Validation
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Giá Bán Âm
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Giá bán phải lớn hơn hoặc bằng 0"

RT-PRODUCT-014 Tạo Sản Phẩm Vượt Quá Số Lượng Cho Phép
    [Documentation]    Test tạo quá nhiều sản phẩm trong một request (tối đa 200)
    [Tags]    AIGenerated    CreateProduct    Negative    Validation
    Given Chuẩn Bị Dữ Liệu Tạo 201 Sản Phẩm
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Số lượng sản phẩm vượt quá giới hạn cho phép"

RT-PRODUCT-015 Tạo Sản Phẩm Combo Vượt Quá Số Lượng Cho Phép
    [Documentation]    Test tạo quá nhiều sản phẩm combo trong một request (tối đa 50)
    [Tags]    AIGenerated    CreateProduct    Negative    Validation
    Given Chuẩn Bị Dữ Liệu Tạo 51 Sản Phẩm Combo
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Số lượng sản phẩm combo vượt quá giới hạn cho phép"

RT-PRODUCT-016 Tạo Sản Phẩm Với Tỷ Lệ Quy Đổi Không Hợp Lệ
    [Documentation]    Test tạo sản phẩm có đơn vị tính với tỷ lệ quy đổi không hợp lệ (0 hoặc số âm)
    [Tags]    AIGenerated    CreateProduct    Negative    Validation
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Tỷ Lệ Quy Đổi Không Hợp Lệ
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Tỷ lệ quy đổi phải lớn hơn 0"

RT-PRODUCT-017 Tạo Sản Phẩm Với Danh Mục Không Tồn Tại
    [Documentation]    Test tạo sản phẩm với ID danh mục không tồn tại
    [Tags]    AIGenerated    CreateProduct    Negative    Validation
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Danh Mục Không Tồn Tại
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Danh mục không tồn tại"

RT-PRODUCT-018 Tạo Sản Phẩm Là Thuốc Nhưng Thiếu Thông Tin Bắt Buộc
    [Documentation]    Test tạo sản phẩm là thuốc nhưng thiếu thông tin bắt buộc theo quy định GPP
    [Tags]    AIGenerated    CreateProduct    Negative    Validation    Medicine
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Là Thuốc Thiếu Thông Tin
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Sản phẩm thuốc cần có đầy đủ thông tin theo quy định GPP"

RT-PRODUCT-019 Tạo Sản Phẩm Với Mô Tả Quá Dài
    [Documentation]    Test tạo sản phẩm với mô tả vượt quá 30000 ký tự
    [Tags]    AIGenerated    CreateProduct    Negative    Validation
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Mô Tả Quá Dài
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Mô tả sản phẩm vượt quá giới hạn cho phép"

RT-PRODUCT-020 Tạo Sản Phẩm Combo Với Thành Phần Không Tồn Tại
    [Documentation]    Test tạo sản phẩm combo với thành phần không tồn tại trong hệ thống
    [Tags]    AIGenerated    CreateProduct    Negative    Validation    Combo
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Combo Với Thành Phần Không Tồn Tại
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Thành phần sản phẩm không tồn tại" 