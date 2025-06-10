*** Settings ***
Documentation     Test API tạo sản phẩm
Suite Setup       Init Test Environment   ${ENV}    MHQL
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Product/CreateProductKeywords.robot
Resource          ../../../Keywords/Product/InputValidationKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Product/Product_KeywordsCommand.robot
*** Variables ***
@{value_attribute_1}   L  M   S
&{dict_attribute_name_1}    SIZE=@{value_attribute_1}
@{name_unit}     hai    nửa
@{value}    1    3
@{list_name_branch}    Chi nhánh trung tâm   Nhánh A
@{list_shelves}    Vị trí 1    Vị trí 2
@{list_pricebook}    Bảng giá chi nhánh    Bảng giá đặt hàng
@{list_price}    1000.05    200000
@{list_price_variant}    1000.05    200000      540000
&{dict_product_tp_cb}   	TPC001=4     TPC002=5.98
&{dict_product_tp}    TP001=1.55     TP002=2.7
&{dict_product_tp_cb_combo}   		FTSX00003=7   	DTCombo07=1

*** Test Cases ***
RT-PRODUCT-001 Tạo Sản Phẩm Cơ Bản Thành Công
    [Documentation]    Test tạo sản phẩm cơ bản thành công với các thông tin tối thiểu bắt buộc như tên, danh mục, đơn vị tính, giá bán
    [Tags]    AIGenerated    CreateProduct434      regression       
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Cơ Bản 
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-002 Tạo Sản Phẩm Với Mã Tự Động
    [Documentation]    Test tạo sản phẩm khi không cung cấp mã, hệ thống sẽ tự sinh mã
    [Tags]    AIGenerated    CreateProduct    Positive     regression 
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Không Có Mã
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Được Tạo Với Mã Tự Sinh
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
RT-PRODUCT-003 Tạo Sản Phẩm Với Nhiều Đơn Vị Tính
    [Documentation]    Test tạo sản phẩm có nhiều đơn vị tính với tỷ lệ quy đổi
    [Tags]    AIGenerated    CreateProduct    Positive    UnitConversion      regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Nhiều Đơn Vị Tính ${name_unit} Và Giá Trị Quy Đổi ${value}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Con Được Tạo Với Đúng Tỷ Lệ Quy Đổi ${value}
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
RT-PRODUCT-004 Tạo Sản Phẩm Với Tồn Kho Ban Đầu
    [Documentation]    Test tạo sản phẩm với tồn kho ban đầu
    [Tags]    AIGenerated    CreateProduct    Positive    Inventory      regression 
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Tồn Kho 50.5 Ban Đầu   
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Tồn Kho 50.5 Ở Chi Nhánh Chi nhánh trung tâm
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
RT-PRODUCT-005 Tạo Sản Phẩm Quản Lý Lô Và Hạn Sử Dụng
    [Documentation]    Test tạo sản phẩm có quản lý theo lô và hạn sử dụng
    [Tags]    AIGenerated    CreateProduct    Positive    BatchExpiry      regression 
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Quản Lý Lô Và Hạn Sử Dụng
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Được Cấu Hình Quản Lý Lô Và Hạn Sử Dụng
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
RT-PRODUCT-006 Tạo Sản Phẩm Quản Lý Serial
    [Documentation]    Test tạo sản phẩm có quản lý theo serial
    [Tags]    AIGenerated    CreateProduct    Positive    Serial        regression 
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Quản Lý Serial
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Được Cấu Hình Quản Lý Serial
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
RT-PRODUCT-007 Tạo Sản Phẩm Với Thuộc Tính
    [Documentation]    Test tạo sản phẩm có thuộc tính
    [Tags]    AIGenerated    CreateProduct    Positive    Attributes      regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính ${dict_attribute_name_1}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có ${LIST_PRODUCTS_CODE} Được Tạo Ra 
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-010 Tạo Sản Phẩm Loại Combo
    [Documentation]    Test tạo sản phẩm loại combo
    [Tags]    AIGenerated    CreateProduct    Positive    Combo          regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Loại Combo
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Combo Có Chứa Các Thành Phần ${PRODUCT_ID_MATERIAL} Với Số Lượng 5
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
Tạo Sản Phẩm Loại Combo Với Nhiều Hàng Thành Phần
    [Documentation]    Test tạo sản phẩm loại combo với nhiều hàng thành phần
    [Tags]    AIGenerated    CreateProduct    Positive    Combo          regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Loại Combo Có Thành Phần ${dict_product_tp_cb}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Hàng Thành Phần ${LIST_MATERIAL_ID} Với Số Lượng ${LIST_MATERIAL_QUANTITY}
    And Xác Thực Sản Phẩm Có Giá Vốn ${TOTAL_COST} Ở Chi Nhánh Chi nhánh trung tâm
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
Tạo Sản Phẩm Loại Sản Xuất Hàng Thành Phần Là Hàng Combo Khác
    [Documentation]    Test tạo sản phẩm loại sản xuất hàng thành phần là hàng combo 
    [Tags]    AIGenerated    CreateProduct    Positive    Manufactured          regression17
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Loại Hàng Sản Xuất Với Hàng Thành Phần ${dict_product_tp_cb_combo}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Mã sản phẩm đã tồn tại"









RT-PRODUCT-021 Tạo Sản Phẩm Loại Dịch Vụ
    [Documentation]    Test tạo sản phẩm loại dịch vụ
    [Tags]    AIGenerated    CreateProduct    Positive    Service    regression
    Given Chuẩn Bị Dữ Liệu Hàng Dịch Vụ
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Loại Là Dịch Vụ
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-022 Tạo Sản Phẩm Loại Hàng Sản Xuất
    [Documentation]    Test tạo sản phẩm loại hàng sản xuất
    [Tags]    AIGenerated    CreateProduct    Positive    Manufactured    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Loại Hàng Sản Xuất
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Loại Là Hàng Sản Xuất Và Có Hàng ${PRODUCT_ID_MATERIAL} Với Số Lượng 5
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 


Tạo Sản Phẩm Hàng Sản Xuất Có Nhiều Hàng Thành Phần
    [Documentation]    Test tạo sản phẩm hàng sản xuất có nhiều hàng thành phần
    [Tags]    AIGenerated    CreateProduct    Positive    Manufactured    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Loại Hàng Sản Xuất Với Hàng Thành Phần ${dict_product_tp}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Hàng Thành Phần ${LIST_MATERIAL_ID} Với Số Lượng ${LIST_MATERIAL_QUANTITY}
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 


RT-PRODUCT-023 Tạo Sản Phẩm Có Vị Trí Lưu Trữ
    [Documentation]    Test tạo sản phẩm có vị trí lưu trữ
    [Tags]    AIGenerated    CreateProduct    Positive    Location    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Vị Trí Lưu Trữ
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Vị Trí Lưu Trữ Đúng
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

Tạo Sản Phẩm Có Chứa Nhiều Vị Trí Lưu Trữ
    [Documentation]    Test tạo sản phẩm có chứa nhiều vị trí lưu trữ
    [Tags]    AIGenerated    CreateProduct    Positive    MultipleLocations    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có ${list_shelves} Vị Trí Lưu Trữ 
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Lưu Trữ ${SHELVES_ID} Vị Trí
     [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-024 Tạo Sản Phẩm Có Thương Hiệu
    [Documentation]    Test tạo sản phẩm có thương hiệu
    [Tags]    AIGenerated    CreateProduct    Positive    Brand    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Thương Hiệu
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thương Hiệu Đúng
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-025 Tạo Sản Phẩm Có Trọng Lượng
    [Documentation]    Test tạo sản phẩm có trọng lượng
    [Tags]    AIGenerated    CreateProduct    Positive    Weight    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Trọng Lượng 1.5 Kg
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Trọng Lượng 1.5 Kg

RT-PRODUCT-026 Tạo Sản Phẩm Có Mã Barcode
    [Documentation]    Test tạo sản phẩm có mã barcode
    [Tags]    AIGenerated    CreateProduct    Positive    Barcode    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Mã Barcode
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Mã Barcode Đúng
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-027 Tạo Sản Phẩm Có Giá Vốn Ở Một chi nhánh
    [Documentation]    Test tạo sản phẩm có giá vốn
    [Tags]    AIGenerated    CreateProduct    Positive    Cost    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Giá Vốn 100000
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Giá Vốn 100000 Ở Chi Nhánh Chi nhánh trung tâm
    And Xác Thực Sản Phẩm Có Giá Vốn 0 Ở Chi Nhánh Nhánh A
    And Xác Thực Sản Phẩm Có Giá Vốn 0 Ở Chi Nhánh Nhánh B
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-028 Tạo Sản Phẩm Không Được Bán Trực Tiếp
    [Documentation]    Test tạo sản phẩm không được bán trực tiếp
    [Tags]    AIGenerated    CreateProduct    Positive    Inactive    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Không Được Bán Trực Tiếp
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Trạng Thái Không Bán Trực Tiếp
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

Tạo Sản Phẩm Kinh Doanh Theo Chi Nhánh
    [Documentation]    Test tạo sản phẩm kinh doanh theo chi nhánh
    [Tags]    AIGenerated    CreateProduct    Positive    Branch    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Kinh Doanh Theo Chi Nhánh ${list_name_branch}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Trạng Thái Đang Kinh Doanh Ở Chi Nhánh ${list_name_branch[0]}
    And Xác Thực Sản Phẩm Có Trạng Thái Đang Kinh Doanh Ở Chi Nhánh ${list_name_branch[1]}
    And Xác Thực Sản Phẩm Có Trạng Thái Ngừng Kinh Doanh Ở Chi Nhánh Nhánh B
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-031 Tạo Sản Phẩm Với Giá Vốn Áp Dụng Nhiều Chi Nhánh
    [Documentation]    Test tạo sản phẩm có giá bán 0
    [Tags]    AIGenerated    CreateProduct    Positive    ZeroPrice    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Giá Vốn 3000.77 Áp Dụng Cho Chi Nhánh ${list_name_branch}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Giá Vốn 3000.77 Ở Chi Nhánh ${list_name_branch[0]}
    And Xác Thực Sản Phẩm Có Giá Vốn 3000.77 Ở Chi Nhánh ${list_name_branch[1]}
    And Xác Thực Sản Phẩm Có Giá Vốn 0 Ở Chi Nhánh Nhánh B
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
RT-PRODUCT-031 Tạo Sản Phẩm Với Giá Bán 0
    [Documentation]    Test tạo sản phẩm có giá bán 0
    [Tags]    AIGenerated    CreateProduct    Positive    ZeroPrice    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Giá Bán 0
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Giá Bán 0
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-031 Tạo Sản Phẩm Với Giá Bán Và Thiết Lập Bảng Giá
    [Documentation]    Test tạo sản phẩm có giá bán 0
    [Tags]    AIGenerated    CreateProduct    Positive    ZeroPrice    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Giá 4000.44 Và Giá Bảng Giá ${list_pricebook} Với ${list_price}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Giá Sản Phẩm ${CREATED_PRODUCT_CODE} Là 4000.44
    And Xác Thực Giá Sản Phẩm ${CREATED_PRODUCT_CODE} Ở Pricebook ${list_pricebook[0]} Là ${list_price[0]}
    And Xác Thực Giá Sản Phẩm ${CREATED_PRODUCT_CODE} Ở Pricebook ${list_pricebook[1]} Là ${list_price[1]}
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-032 Tạo Sản Phẩm Với Giới Hạn Tồn Kho
    [Documentation]    Test tạo sản phẩm có thiết lập giới hạn tồn kho tối thiểu và tối đa
    [Tags]    AIGenerated    CreateProduct    Positive    StockLimit    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Giới Hạn Tồn Kho Tối Thiểu 10 Và Tối Đa 100
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Giới Hạn Tồn Kho Tối Thiểu 10 Và Tối Đa 100 Ở Chi Nhánh Chi Nhánh Trung Tâm
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-033 Tạo Sản Phẩm Tích Điểm
    [Documentation]    Test tạo sản phẩm có tích điểm thưởng
    [Tags]    AIGenerated    CreateProduct    Positive    RewardPoints    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Tích Điểm
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Tích Điểm Thưởng
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-033 Tạo Sản Phẩm Tích Điểm Và Có Điểm Thưởng
    [Documentation]    Test tạo sản phẩm tích điểm và có điểm thưởng
    [Tags]    AIGenerated    CreateProduct    Positive    RewardPoints    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Tích Điểm Với Số Điểm 5
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Điểm Thưởng 5
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-033 Tạo Sản Phẩm Tích Điểm Và Có Điểm Thưởng Số Lẻ
    [Documentation]    Test tạo sản phẩm tích điểm và có điểm thưởng
    [Tags]    AIGenerated    CreateProduct    Positive    RewardPoints    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Tích Điểm Với Số Điểm 5.55
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 500

Tạo Sản Phẩm Với Nhóm Hàng Không Tồn Tại
    [Documentation]    Chuẩn bị dữ liệu sản phẩm có nhóm hàng
    [Tags]    AIGenerated    CreateProduct    Positive    Group    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Nhóm Hàng Không Tồn Tại
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Có lỗi khi cập nhật dữ liệu"

Tạo Sản Phẩm Để Trống Nhóm Hàng
    [Documentation]    Chuẩn bị dữ liệu sản phẩm để trống nhóm hàng
    [Tags]    AIGenerated    CreateProduct    Positive    Group    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Để Trống Nhóm Hàng
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 500



RT-PRODUCT-035 Tạo Sản Phẩm Với Hình Ảnh
    [Documentation]    Test tạo sản phẩm có hình ảnh đính kèm
    [Tags]    AIGenerated    CreateProduct    Positive    Images    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Hình Ảnh
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Hình Ảnh Được Lưu Trữ
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 


RT-PRODUCT-036 Tạo Sản Phẩm Với Mô Tả Ghi Chú Đặt Hàng
    [Documentation]    Test tạo sản phẩm có mô tả ghi chú đặt hàng
    [Tags]    AIGenerated    CreateProduct    Positive    OrderNote    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Ghi Chú Đặt Hàng 500 Ký tự
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Ghi Chú Đặt Hàng ${RANDOM_GHICHU} 
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-037 Tạo Sản Phẩm Với Mô Tả Ghi Chú
    [Documentation]    Test tạo sản phẩm có mô tả ghi chú
    [Tags]    AIGenerated    CreateProduct    Positive    Note    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Ghi Chú 5000 Ký tự
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Mô Tả Ghi Chú ${RANDOM_GHICHU} 
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
   

RT-PRODUCT-038 Tạo Sản Phẩm Không Cung Cấp Tên
    [Documentation]    Test tạo sản phẩm không cung cấp tên sản phẩm
    [Tags]    AIGenerated    CreateProduct    Negative    MissingName    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Tên 0 Ký Tự
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    #And Phản hồi phải chứa lỗi "Property: Name Error: Name is required"
RT-PRODUCT-038 Tạo Sản Phẩm Có Tên Hàng Hóa Dài
    [Documentation]    Test tạo sản phẩm có tên hàng hóa dài
    [Tags]    AIGenerated    CreateProduct    Negative        regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Tên 3000 Ký Tự
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Tên đầy đủ của hàng hóa ( Tên hàng+Thuộc tính+Đơn vị tính) không vượt quá 500 kí tự"

RT-PRODUCT-042 Tạo Sản Phẩm Với Tên Có Ký Tự Đặc Biệt
    [Documentation]    Test tạo sản phẩm với tên có ký tự đặc biệt như unicode, emoji, ký tự đặc biệt
    [Tags]    AIGenerated    CreateProduct    Positive    SpecialChars    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Tên Với Ký Tự Đặc Biệt
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Tên Sản Phẩm Được Chuẩn Hóa Đúng
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-044 Tạo Sản Phẩm Với Thuộc Tính Có Giá Bán Khác Nhau
    [Documentation]    Test tạo sản phẩm với các biến thể có giá bán khác nhau
    [Tags]    AIGenerated    CreateProduct    Positive    VariantPricing    
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Các Biến Thể ${dict_attribute_name_1} Có Giá Khác Nhau ${list_price_variant}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Các Biến Thể Có Giá Bán ${list_price_variant} Theo Cấu Hình
    [Teardown]     Delete Nhiều Sản Phẩm  ${LIST_PRODUCT_CODE} 
RT-PRODUCT-045 Tạo Sản Phẩm Với Thuộc Tính Có Tồn Kho Khác Nhau
    [Documentation]    Test tạo sản phẩm với các biến thể có tồn kho ban đầu khác nhau
    [Tags]    AIGenerated    CreateProduct    Positive    VariantInventory    
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Các Biến Thể Có Tồn Kho Khác Nhau
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Các Biến Thể Có Tồn Kho Theo Cấu Hình
    And Xác Thực Tổng Tồn Kho Sản Phẩm Chính Bằng Tổng Các Biến Thể
    [Teardown]     Delete Nhiều Sản Phẩm  ${LIST_PRODUCT_CODE} 

RT-PRODUCT-046 Tạo Sản Phẩm Với Thuộc Tính Có Mã Vạch Riêng
    [Documentation]    Test tạo sản phẩm với các biến thể có mã vạch riêng
    [Tags]    AIGenerated    CreateProduct    Positive    VariantBarcodes    
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Các Biến Thể Có Mã Vạch Riêng
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Các Biến Thể Có Mã Vạch Theo Cấu Hình
    [Teardown]     Xóa Sản Phẩm  ${LIST_PRODUCT_CODE} 

RT-PRODUCT-047 Kiểm Tra Lỗi Khi Tạo Sản Phẩm Với Tổ Hợp Thuộc Tính Trùng
    [Documentation]    Test tạo sản phẩm có tổ hợp thuộc tính bị trùng lặp sẽ báo lỗi
    [Tags]    AIGenerated    CreateProduct    Negative    DuplicateAttributes    
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Tổ Hợp Thuộc Tính Trùng Lặp
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Không thể tạo biến thể do có tổ hợp thuộc tính trùng lặp"

RT-PRODUCT-048 Tạo Sản Phẩm Với Tên Biến Thể Tự Động
    [Documentation]    Test tạo sản phẩm với tên biến thể được tạo tự động dựa trên giá trị thuộc tính
    [Tags]    AIGenerated    CreateProduct    Positive    VariantNaming    
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Tên Biến Thể Tự Động
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Tên Các Biến Thể Được Tạo Đúng Theo Cấu Trúc
    [Teardown]     Delete Nhiều Sản Phẩm  ${LIST_PRODUCT_CODE} 

RT-PRODUCT-049 Tạo Sản Phẩm Với Mã Biến Thể Tự Động
    [Documentation]    Test tạo sản phẩm với mã biến thể được tạo tự động dựa trên mã sản phẩm gốc
    [Tags]    AIGenerated    CreateProduct    Positive    VariantCoding    
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Mã Biến Thể Tự Động
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Mã Các Biến Thể Được Tạo Dựa Trên Mã Sản Phẩm Gốc
    [Teardown]     Delete Nhiều Sản Phẩm  ${LIST_PRODUCT_CODE} 

Tạo Sản Phẩm Ở MHBH
    [Documentation]    Test tạo sản phẩm ở MHBH
    [Tags]    AIGenerated    CreateProduct    Positive    MHBH    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Ở MHBH
    When Gửi Yêu Cầu Tạo Sản Phẩm Từ MHBH
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

Tạo Sản Phẩm Ở Form Khác
    [Documentation]    Test tạo sản phẩm ở form khác
    [Tags]    AIGenerated    CreateProduct    Positive    OtherForm    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Ở Form Khác
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-050 Tạo Sản Phẩm Với Nhiều Hình Ảnh
    [Documentation]    Test tạo sản phẩm với nhiều hình ảnh đính kèm
    [Tags]    AIGenerated    CreateProduct    Positive    MultipleImages    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Nhiều Hình Ảnh
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Nhiều Hình Ảnh Được Lưu Trữ
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
RT-PRODUCT-051 Tạo Sản Phẩm Với Hình Ảnh Ghim Chính
    [Documentation]    Test tạo sản phẩm với hình ảnh đính kèm và chọn làm ảnh ghim chính
    [Tags]    AIGenerated    CreateProduct    Positive    PinnedImage    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Hình Ảnh Ghim Chính
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Hình Ảnh Được Lưu Trữ
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-052 Tạo Sản Phẩm Với Hình Ảnh Từ URL
    [Documentation]    Test tạo sản phẩm với hình ảnh được lấy từ URL
    [Tags]    AIGenerated    CreateProduct    Positive    ImageFromURL    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Hình Ảnh Từ URL
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Hình Ảnh Từ URL Được Lưu Trữ
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
RT-PRODUCT-053 Tạo Sản Phẩm Với Hình Ảnh Có Định Dạng Khác Nhau
    [Documentation]    Test tạo sản phẩm với hình ảnh có nhiều định dạng khác nhau (jpg, png, jpeg)
    [Tags]    AIGenerated    CreateProduct    Positive    ImageFormats    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Hình Ảnh Nhiều Định Dạng
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Hình Ảnh Với Các Định Dạng Khác Nhau
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 


RT-PRODUCT-057 Tạo Sản Phẩm Với Đơn Vị Tính Cơ Bản
    [Documentation]    Test tạo sản phẩm với đơn vị tính cơ bản
    [Tags]    AIGenerated    CreateProduct    Positive    UnitManagement    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Tính Cơ Bản thùng
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Đơn Vị Tính thùng
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-059 Tạo Sản Phẩm Với Đơn Vị Tính Có Giá Bán Khác Nhau
    [Documentation]    Test tạo sản phẩm với các đơn vị tính có giá bán khác nhau
    [Tags]    AIGenerated    CreateProduct    Positive    UnitManagement    regression
    @{unit_names}    Create List    cai    hop    thung
    @{conversion_values}    Create List    1    12    144
    @{prices}    Create List    10000    110000    1300000
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Tính ${unit_names} Có Giá Trị Quy Đổi ${conversion_values} Và Giá Bán ${prices}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Giá Bán Theo Đơn Vị Tính ${unit_names} Là ${prices}
    [Teardown]      Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 


RT-PRODUCT-060 Tạo Sản Phẩm Với Đơn Vị Tính Có Mã Vạch Riêng
    [Documentation]    Test tạo sản phẩm với các đơn vị tính có mã vạch riêng
    [Tags]    AIGenerated    CreateProduct    Positive    UnitManagement    regression
    @{unit_names}    Create List    chai    loc   
    @{conversion_values}    Create List    1    6    
    @{barcodes}    Create List    8935001701638    8935001701645    
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Tính ${unit_names} Có Giá Trị Quy Đổi ${conversion_values} Và Mã Vạch ${barcodes}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Mã Vạch Theo Đơn Vị Tính ${unit_names} Là ${barcodes}
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 


RT-PRODUCT-061 Tạo Sản Phẩm Với Đơn Vị Tính Và Tồn Kho Tính Theo Quy Đổi
    [Documentation]    Test tạo sản phẩm với tồn kho theo đơn vị tính cơ bản và kiểm tra tồn kho đơn vị quy đổi
    [Tags]    AIGenerated    CreateProduct    Positive    UnitManagement    regression
    @{unit_names}    Create List    kg    ta    tan
    @{conversion_values}    Create List    1    100    1000
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Tính ${unit_names} Có Giá Trị Quy Đổi ${conversion_values} Và Tồn Kho 1000
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Tồn Kho Đơn Vị "kg" Là 1000
    And Xác Thực Sản Phẩm Có Tồn Kho Đơn Vị "ta" Là 10
    And Xác Thực Sản Phẩm Có Tồn Kho Đơn Vị "tan" Là 1
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 


RT-PRODUCT-062 Tạo Sản Phẩm Với Đơn Vị Tính Và Giá Vốn Tính Theo Quy Đổi
    [Documentation]    Test tạo sản phẩm với giá vốn theo đơn vị tính cơ bản và kiểm tra giá vốn đơn vị quy đổi
    [Tags]    AIGenerated    CreateProduct    Positive    UnitManagement    regression
    @{unit_names}    Create List    m    cuon    cay
    @{conversion_values}    Create List    1    10    100
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Tính ${unit_names} Có Giá Trị Quy Đổi ${conversion_values} Và Giá Vốn 5000
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Giá Vốn Đơn Vị "m" Là 5000
    And Xác Thực Sản Phẩm Có Giá Vốn Đơn Vị "cuon" Là 50000
    And Xác Thực Sản Phẩm Có Giá Vốn Đơn Vị "cay" Là 500000
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 


Tạo Sản Phẩm Với Đơn Vị Tính Và Có Điểm Khác Nhau    
    [Documentation]    Test tạo sản phẩm với đơn vị tính và có điểm khác nhau
    [Tags]    AIGenerated    CreateProduct    Positive    UnitManagement    regression
    @{unit_names}    Create List    kg    ta    tan
    @{conversion_values}    Create List    1   0.5   0.01
    @{different_points}    Create List    10    20    5
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Tính ${unit_names} Có Giá Trị Quy Đổi ${conversion_values} Và Điểm Khác Nhau ${different_points}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm ${LIST_PRODUCT_CODE} Có Điểm ${different_points}
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 


Tạo Sản Phẩm Với Đơn Vị Tính Và Có Bán Trực Tiếp Khác Nhau 
    [Documentation]    Test tạo sản phẩm với đơn vị tính và có bán trực tiếp khác nhau lớn
    [Tags]    AIGenerated    CreateProduct    Positive    UnitManagement    regression
    @{unit_names}    Create List    kg    ta    tan
    @{conversion_values}    Create List    1   0.5   0.01
    @{direct_selling}    Create List    Không    Không     Có
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Tính ${unit_names} Có Giá Trị Quy Đổi ${conversion_values} Và ${direct_selling} Bán Trực Tiếp
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm ${LIST_PRODUCT_CODE} Trạng Thái ${direct_selling} Bán Trực Tiếp 
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 


RT-PRODUCT-065 Tạo Sản Phẩm Với Số Lượng Đơn Vị Tính Lớn
    [Documentation]    Test tạo sản phẩm với số lượng đơn vị tính tối đa cho phép
    [Tags]    AIGenerated    CreateProduct    Positive    UnitManagement    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Số Lượng Đơn Vị Tính 50
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Đúng Số Lượng Đơn Vị Tính Tối Đa
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 



RT-PRODUCT-066 Tạo Sản Phẩm Với Số Lượng Đơn Vị Tính Vượt Tối Đa
    [Documentation]    Test tạo sản phẩm với số lượng đơn vị tính vượt tối đa cho phép
    [Tags]    AIGenerated    CreateProduct    Positive    UnitManagement    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Số Lượng Đơn Vị Tính 201
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Hệ thống chỉ hỗ trợ tạo tối đa 200 hàng hóa cùng loại"


RT-PRODUCT-066 Tạo Sản Phẩm Với Tên Đơn Vị Tính Đặc Biệt
    [Documentation]    Test tạo sản phẩm với tên đơn vị tính có ký tự đặc biệt
    [Tags]    AIGenerated    CreateProduct    Positive    UnitManagement    regression
    @{unit_names}    Create List    hộp-nhỏ    lốc 6    thùng(24)
    @{conversion_values}    Create List    1    6    24
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Nhiều Đơn Vị Tính ${unit_names} Và Giá Trị Quy Đổi ${conversion_values}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Con Được Tạo Với Đúng Tỷ Lệ Quy Đổi ${conversion_values}
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 


RT-PRODUCT-072 Tạo Sản Phẩm Với Thuộc Tính Chứa Ký Tự Đặc Biệt
    [Documentation]    Test tạo sản phẩm với giá trị thuộc tính chứa ký tự đặc biệt
    [Tags]    AIGenerated    CreateProduct    Positive    SpecialCharsAttribute    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính Chứa Ký Tự Đặc Biệt
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuộc Tính Với Ký Tự Đặc Biệt Được Lưu Đúng

RT-PRODUCT-073 Tạo Sản Phẩm Với Số Lượng Thuộc Tính Lớn
    [Documentation]    Test tạo sản phẩm với số lượng thuộc tính lớn (>5 thuộc tính)
    [Tags]    AIGenerated    CreateProduct    Positive    ManyAttributes    regression133
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Nhiều Thuộc Tính
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Đầy Đủ Các Thuộc Tính Đã Cấu Hình
    [Teardown]     Delete Nhiều Sản Phẩm    ${LIST_PRODUCT_CODE} 


RT-PRODUCT-075 Tạo Sản Phẩm Với Thiết Lập Trạng Thái Kinh Doanh Khác Nhau Cho Biến Thể
    [Documentation]    Test tạo sản phẩm với các biến thể có trạng thái kinh doanh khác nhau
    [Tags]    AIGenerated    CreateProduct    Positive    VariantStatus    regression1
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Biến Thể Có Trạng Thái Kinh Doanh Khác Nhau
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Biến Thể Có Trạng Thái Kinh Doanh Đúng Theo Cấu Hình
    [Teardown]     Delete Nhiều Sản Phẩm    ${LIST_PRODUCT_CODE} 
RT-PRODUCT-076 Cập Nhật Thuộc Tính Cho Sản Phẩm Đã Tồn Tại
    [Documentation]    Test cập nhật thuộc tính cho sản phẩm đã tồn tại
    [Tags]    AIGenerated    CreateProduct    Positive    UpdateAttributes    regression1
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Cơ Bản
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    When Chuẩn Bị Dữ Liệu Cập Nhật Sản Phẩm Với Thuộc Tính Mới
    And Gửi Yêu Cầu Cập Nhật Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Có Thuộc Tính Mới Được Cập Nhật

RT-PRODUCT-077 Tạo Sản Phẩm Với Thuộc Tính Có Ảnh Hưởng Đến Mã Vạch
    [Documentation]    Test tạo sản phẩm với thuộc tính ảnh hưởng đến mã vạch của biến thể
    [Tags]    AIGenerated    CreateProduct    Positive    BarcodeAttributes    regression1
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính Ảnh Hưởng Đến Mã Vạch
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Mã Vạch Của Biến Thể Được Tạo Theo Đúng Quy Tắc
    [Teardown]     Delete Nhiều Sản Phẩm    ${LIST_PRODUCT_CODE} 

RT-PRODUCT-078 Tạo Sản Phẩm Với Thuộc Tính Quá Dài
    [Documentation]    Test tạo sản phẩm với giá trị thuộc tính quá dài
    [Tags]    AIGenerated    CreateProduct    Negative    LongAttributeValue    regression1
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính Có Giá Trị Quá Dài
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Giá trị thuộc tính không được vượt quá 255 ký tự"

RT-PRODUCT-079 Tạo Sản Phẩm Với Thuộc Tính Bị Trùng Tên
    [Documentation]    Test tạo sản phẩm với hai thuộc tính có tên trùng nhau
    [Tags]    AIGenerated    CreateProduct    Negative    DuplicateAttributeName    regression1
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính Bị Trùng Tên
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Không thể có hai thuộc tính cùng tên"

RT-PRODUCT-080 Tạo Biến Thể Vượt Quá Số Lượng Cho Phép
    [Documentation]    Test tạo sản phẩm với số lượng biến thể vượt quá giới hạn cho phép
    [Tags]    AIGenerated    CreateProduct    Negative    TooManyVariants    regression1
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Số Lượng Biến Thể Vượt Quá Giới Hạn
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Số lượng biến thể vượt quá giới hạn cho phép"

RT-PRODUCT-081 Thêm Biến Thể Bổ Sung Cho Sản Phẩm Đã Có Thuộc Tính
    [Documentation]    Test thêm biến thể bổ sung cho sản phẩm đã có thuộc tính
    [Tags]    AIGenerated    CreateProduct    Positive    AddVariants    regression1
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính Cơ Bản
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    When Chuẩn Bị Dữ Liệu Thêm Biến Thể Cho Sản Phẩm
    And Gửi Yêu Cầu Thêm Biến Thể1
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Biến Thể Mới Được Thêm Thành Công

*** Keywords ***

