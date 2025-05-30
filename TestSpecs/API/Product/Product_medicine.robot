*** Settings ***
Documentation     Test API tạo sản phẩm
Suite Setup       Init Test Environment   ${ENV}   MHQL
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Product/CreateProductKeywords.robot
Resource          ../../../Keywords/Product/InputValidationKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Product/Product_Medicine_Keywords.robot
Resource          ../../../Keywords/Product/Product_KeywordsCommand.robot
Resource          ../../../Config/Env_api.robot



*** Variables ***
@{value_attribute_1}   L  M   
&{dict_attribute_name_1}    SIZE=@{value_attribute_1}
@{name_unit}     hai    nửa
@{value}    1    3
@{list_branch_name}    Chi nhánh trung tâm    Nhánh A
@{list_shelves}    Vị trí 1    Vị trí 2
@{list_pricebook}    Bảng giá chi nhánh    Bảng giá đặt hàng
@{list_price}    10000    20000.76
*** Test Cases ***
RT-PRODUCT-008 Tạo Sản Phẩm Là Thuốc
    [Documentation]    Test tạo sản phẩm là thuốc với thông tin đầy đủ theo yêu cầu GPP
    [Tags]    AIGenerated    CreateProduct    Positive    nhathuoc   
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Là Thuốc
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Tự Động Được Cấu Hình Quản Lý Lô Và Hạn Sử Dụng
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-009 Tạo Sản Phẩm Thuốc Có Nhiều Đơn Vị Tính
    [Documentation]    Test tạo sản phẩm là thuốc với nhiều đơn vị tính (hộp, vỉ, viên)
    [Tags]    AIGenerated    CreateProduct    Positive    nhathuoc   
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Có Đơn Vị Tính ${name_unit} Với Giá Trị ${value}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Con Được Tạo Với Đúng Tỷ Lệ Quy Đổi ${value}
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-010 Tạo Sản Phẩm Thuốc Với Giới Hạn Tồn Kho
    [Documentation]    Test tạo sản phẩm là thuốc với cấu hình giới hạn tồn kho tối thiểu và tối đa
    [Tags]    AIGenerated    CreateProduct    Positive    nhathuoc
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Giới Hạn Tồn Kho
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Có Giới Hạn Tồn Kho Tối Thiểu 10 Và Tối Đa 100 Ở Chi Nhánh Chi Nhánh Trung Tâm
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

Tạo Sản Phẩm Thuốc Với Có Giá Vốn Áp Dung The Chi Nhánh
    [Documentation]    Test tạo sản phẩm là thuốc với cấu hình giá vốn áp dụng theo chi nhánh
    [Tags]    AIGenerated    CreateProduct    Positive    nhathuoc
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Có Giá Vốn 60000 Áp Dụng Ở Chi Nhánh ${list_branch_name}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Có Giá Vốn 60000 Ở Chi Nhánh Chi nhánh trung tâm
    And Xác Thực Sản Phẩm Có Giá Vốn 60000 Ở Chi Nhánh Nhánh A
    And Xác Thực Sản Phẩm Có Giá Vốn 0 Ở Chi Nhánh Nhánh B
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

Tạo Sản Phẩm Thuốc Kinh Doanh theo Chi Nhánh
    [Documentation]    Test tạo sản phẩm là thuốc với cấu hình kinh doanh theo chi nhánh
    [Tags]    AIGenerated    CreateProduct    Positive    nhathuoc
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Kinh Doanh Ở Chi Nhánh ${list_branch_name}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Có Trạng Thái Đang Kinh Doanh Ở Chi Nhánh ${list_branch_name[0]}
    And Xác Thực Sản Phẩm Có Trạng Thái Đang Kinh Doanh Ở Chi Nhánh ${list_branch_name[1]}
    And Xác Thực Sản Phẩm Có Trạng Thái Ngừng Kinh Doanh Ở Chi Nhánh Nhánh B
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-011 Tạo Sản Phẩm Thuốc Có Trọng Lượng
    [Documentation]    Test tạo sản phẩm là thuốc với thuộc tính
    [Tags]    AIGenerated    CreateProduct    Positive    Medicine    nhathuoc
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Trọng Lượng 500 g
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Có Trọng Lượng 500 g
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
Tạo Sản Phẩm Thuốc Có Hình Ảnh
    [Documentation]    Test tạo sản phẩm là thuốc với hình ảnh
    [Tags]    AIGenerated    CreateProduct    Positive    Medicine    nhathuoc
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Hình Ảnh
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Có Hình Ảnh Được Lưu Trữ
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
Tạo Sản Phẩm Thuốc Có Mô tả ghi chú
    [Documentation]    Test tạo sản phẩm là thuốc với mô tả ghi chú
    [Tags]    AIGenerated    CreateProduct    Positive    Medicine    nhathuoc
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Mô Tả Đặt Hàng 500 Kí Tự Và Ghi Chú 3000 Kí Tự
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Có Ghi Chú Đặt Hàng ${NOTE}
    And Xác Thực Sản Phẩm Có Mô Tả Ghi Chú ${DESCRIPTION}
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
Tạo Sản Phẩm Thuốc Có Vị Trí
    [Documentation]    Test tạo sản phẩm là thuốc với vị trí
    [Tags]    AIGenerated    CreateProduct    Positive    Medicine    nhathuoc
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với ${list_shelves} Vị Trí
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Có Lưu Trữ ${SHELVES_ID} Vị Trí 


RT-PRODUCT-012 Tạo Sản Phẩm Thuốc Không Bán Trực Tiếp
    [Documentation]    Test tạo sản phẩm là thuốc với trạng thái ngừng kinh doanh
    [Tags]    AIGenerated    CreateProduct    Positive    nhathuoc
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Không Bán Trực Tiếp
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Có Trạng Thái Không Bán Trực Tiếp
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

Tạo Sản Phẩm Thuốc Từ Form Khác
    [Documentation]    Test tạo sản phẩm là thuốc từ form khác
    [Tags]    AIGenerated    CreateProduct    Positive    Medicine    nhathuoc
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Từ Form Khác
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
Tạo Sản Phẩm Thuốc Có Barcode
    [Documentation]    Test tạo sản phẩm là thuốc với barcode
    [Tags]    AIGenerated    CreateProduct    Positive    Medicine    nhathuoc
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Mã Barcode 12 Ký Tự
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Sản Phẩm Có Mã Barcode Đúng
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
Tạo Sản Phẩm Thuốc Có Thiết Lập Bảng Giá
    [Documentation]    Test tạo sản phẩm là thuốc với bảng giá
    [Tags]    AIGenerated    CreateProduct    Positive    Medicine    nhathuoc4
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Có Giá 4000.45 Và Bảng Giá ${list_pricebook} Với ${list_price} 
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác
    And Xác Thực Giá Sản Phẩm ${DB_PRODUCT_CODE} Ở Pricebook ${list_pricebook[0]} Là ${list_price[0]}
    And Xác Thực Giá Sản Phẩm ${DB_PRODUCT_CODE} Ở Pricebook ${list_pricebook[1]} Là ${list_price[1]}
    And Xác Thực Giá Sản Phẩm ${DB_PRODUCT_CODE} Là 4000.45
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
RT-PRODUCT-014 Tạo Sản Phẩm Thuốc Không Thành Công Khi Trùng Mã Sản Phẩm
    [Documentation]    Test tạo sản phẩm là thuốc thất bại khi trùng mã sản phẩm đã tồn tại

    [Tags]    AIGenerated    CreateProduct    Negative    nhathuoc
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Mã Trùng Lặp TH00001 
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Mã hàng: TH00001 đã tồn tại"

*** Keywords ***