*** Settings ***
Documentation     Test API tạo sản phẩm
Resource          ../../../Keywords/Product/CreateProductKeywords.robot
Resource          ../../../Keywords/Product/InputValidationKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Product/Product_KeywordsCommand.robot
*** Variables ***
@{value_attribute_1}   L  M   S
&{dict_attribute_name_1}    SIZE=@{value_attribute_1}
@{name_unit}     hai    nửa
@{value}    1    3
*** Test Cases ***
RT-PRODUCT-001 Tạo Sản Phẩm Cơ Bản Thành Công
    [Documentation]    Test tạo sản phẩm cơ bản thành công với các thông tin tối thiểu bắt buộc như tên, danh mục, đơn vị tính, giá bán
    [Tags]    AIGenerated    CreateProduct434      regression       
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Cơ Bản 
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database

RT-PRODUCT-002 Tạo Sản Phẩm Với Mã Tự Động
    [Documentation]    Test tạo sản phẩm khi không cung cấp mã, hệ thống sẽ tự sinh mã
    [Tags]    AIGenerated    CreateProduct    Positive     regression 
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Không Có Mã
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Được Tạo Với Mã Tự Sinh

RT-PRODUCT-003 Tạo Sản Phẩm Với Nhiều Đơn Vị Tính
    [Documentation]    Test tạo sản phẩm có nhiều đơn vị tính với tỷ lệ quy đổi
    [Tags]    AIGenerated    CreateProduct    Positive    UnitConversion      regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Tính Và List Quy Đổi ${name_unit} Với ${value}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Con Được Tạo Với Đúng Tỷ Lệ Quy Đổi ${value}

RT-PRODUCT-004 Tạo Sản Phẩm Với Tồn Kho Ban Đầu
    [Documentation]    Test tạo sản phẩm với tồn kho ban đầu
    [Tags]    AIGenerated    CreateProduct    Positive    Inventory      regression 
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Tồn Kho 50.5 Ban Đầu   
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Tồn Kho 50.5 Ở Chi Nhánh Chi nhánh trung tâm

RT-PRODUCT-005 Tạo Sản Phẩm Quản Lý Lô Và Hạn Sử Dụng
    [Documentation]    Test tạo sản phẩm có quản lý theo lô và hạn sử dụng
    [Tags]    AIGenerated    CreateProduct    Positive    BatchExpiry      regression 
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Quản Lý Lô Và Hạn Sử Dụng
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Được Cấu Hình Quản Lý Lô Và Hạn Sử Dụng

RT-PRODUCT-006 Tạo Sản Phẩm Quản Lý Serial
    [Documentation]    Test tạo sản phẩm có quản lý theo serial
    [Tags]    AIGenerated    CreateProduct    Positive    Serial        regression 
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Quản Lý Serial
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Được Cấu Hình Quản Lý Serial

RT-PRODUCT-007 Tạo Sản Phẩm Với Thuộc Tính
    [Documentation]    Test tạo sản phẩm có thuộc tính
    [Tags]    AIGenerated    CreateProduct    Positive    Attributes      regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính ${dict_attribute_name_1}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có ${LIST_PRODUCTS_CODE} Được Tạo Ra 


RT-PRODUCT-010 Tạo Sản Phẩm Loại Combo
    [Documentation]    Test tạo sản phẩm loại combo
    [Tags]    AIGenerated    CreateProduct    Positive    Combo          regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Loại Combo
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Combo Có Chứa Các Thành Phần ${PRODUCT_ID_MATERIAL} Với Số Lượng 5




RT-PRODUCT-021 Tạo Sản Phẩm Loại Dịch Vụ
    [Documentation]    Test tạo sản phẩm loại dịch vụ
    [Tags]    AIGenerated    CreateProduct    Positive    Service    regression
    Given Chuẩn Bị Dữ Liệu Hàng Dịch Vụ
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Loại Là Dịch Vụ

RT-PRODUCT-022 Tạo Sản Phẩm Loại Hàng Sản Xuất
    [Documentation]    Test tạo sản phẩm loại hàng sản xuất
    [Tags]    AIGenerated    CreateProduct    Positive    Manufactured    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Loại Hàng Sản Xuất
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Loại Là Hàng Sản Xuất Và Có Hàng ${PRODUCT_ID_MATERIAL} Với Số Lượng 5

RT-PRODUCT-023 Tạo Sản Phẩm Có Vị Trí Lưu Trữ
    [Documentation]    Test tạo sản phẩm có vị trí lưu trữ
    [Tags]    AIGenerated    CreateProduct    Positive    Location    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Vị Trí Lưu Trữ
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Vị Trí Lưu Trữ Đúng

RT-PRODUCT-024 Tạo Sản Phẩm Có Thương Hiệu
    [Documentation]    Test tạo sản phẩm có thương hiệu
    [Tags]    AIGenerated    CreateProduct    Positive    Brand    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Thương Hiệu
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thương Hiệu Đúng

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

RT-PRODUCT-027 Tạo Sản Phẩm Có Giá Vốn
    [Documentation]    Test tạo sản phẩm có giá vốn
    [Tags]    AIGenerated    CreateProduct    Positive    Cost    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Giá Vốn 100000
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Giá Vốn 100000 Ở Chi Nhánh Chi nhánh trung tâm
    And Xác Thực Sản Phẩm Có Giá Vốn 0 Ở Chi Nhánh Nhánh A

RT-PRODUCT-028 Tạo Sản Phẩm Ngừng Kinh Doanh
    [Documentation]    Test tạo sản phẩm đã ngừng kinh doanh
    [Tags]    AIGenerated    CreateProduct    Positive    Inactive    regression17
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Ngừng Kinh Doanh
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Trạng Thái Ngừng Kinh Doanh



RT-PRODUCT-031 Tạo Sản Phẩm Với Giá Bán 0
    [Documentation]    Test tạo sản phẩm có giá bán 0
    [Tags]    AIGenerated    CreateProduct    Positive    ZeroPrice    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Giá Bán 0
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Giá Bán 0

RT-PRODUCT-032 Tạo Sản Phẩm Với Giới Hạn Tồn Kho
    [Documentation]    Test tạo sản phẩm có thiết lập giới hạn tồn kho tối thiểu và tối đa
    [Tags]    AIGenerated    CreateProduct    Positive    StockLimit    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Giới Hạn Tồn Kho Tối Thiểu 10 Và Tối Đa 100
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Giới Hạn Tồn Kho Tối Thiểu 10 Và Tối Đa 100 Ở Chi Nhánh Chi Nhánh Trung Tâm

RT-PRODUCT-033 Tạo Sản Phẩm Với Điểm Thưởng
    [Documentation]    Test tạo sản phẩm có tích điểm thưởng
    [Tags]    AIGenerated    CreateProduct    Positive    RewardPoints    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Tích Điểm
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Tích Điểm Thưởng

RT-PRODUCT-034 Tạo Sản Phẩm Với Thời Gian Bảo Hành
    [Documentation]    Test tạo sản phẩm có thời gian bảo hành
    [Tags]    AIGenerated    CreateProduct    Positive    Warranty    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Thời Gian Bảo Hành 12 Tháng
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
   # And Xác Thực Sản Phẩm Có Thời Gian Bảo Hành 12 Tháng

RT-PRODUCT-035 Tạo Sản Phẩm Với Hình Ảnh
    [Documentation]    Test tạo sản phẩm có hình ảnh đính kèm
    [Tags]    AIGenerated    CreateProduct    Positive    Images    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Hình Ảnh
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Hình Ảnh Được Lưu Trữ


RT-PRODUCT-036 Tạo Sản Phẩm Với Mô Tả Ghi Chú Đặt Hàng
    [Documentation]    Test tạo sản phẩm có mô tả ghi chú đặt hàng
    [Tags]    AIGenerated    CreateProduct    Positive    OrderNote    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Ghi Chú Đặt Hàng 500 Ký tự
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Ghi Chú Đặt Hàng ${RANDOM_GHICHU} 

RT-PRODUCT-037 Tạo Sản Phẩm Với Mô Tả Ghi Chú
    [Documentation]    Test tạo sản phẩm có mô tả ghi chú
    [Tags]    AIGenerated    CreateProduct    Positive    Note    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Ghi Chú 5000 Ký tự
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Mô Tả Ghi Chú ${RANDOM_GHICHU} 

   

RT-PRODUCT-038 Tạo Sản Phẩm Không Cung Cấp Tên
    [Documentation]    Test tạo sản phẩm không cung cấp tên sản phẩm
    [Tags]    AIGenerated    CreateProduct    Negative    MissingName    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Không Có Tên
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
   # And Phản hồi phải chứa lỗi "Tên hàng hóa không được để trống"


RT-PRODUCT-042 Tạo Sản Phẩm Với Tên Có Ký Tự Đặc Biệt
    [Documentation]    Test tạo sản phẩm với tên có ký tự đặc biệt như unicode, emoji, ký tự đặc biệt
    [Tags]    AIGenerated    CreateProduct    Positive    SpecialChars    regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Tên Với Ký Tự Đặc Biệt
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Tên Sản Phẩm Được Chuẩn Hóa Đúng

RT-PRODUCT-043 Tạo Sản Phẩm Với Nhiều Thuộc Tính Tổ Hợp
    [Documentation]    Test tạo sản phẩm với nhiều thuộc tính tổ hợp (Màu sắc, Kích thước) tạo ra các biến thể sản phẩm
    [Tags]    AIGenerated    CreateProduct    Positive    MultipleAttributes    
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Nhiều Thuộc Tính Tổ Hợp
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Tất Cả Biến Thể Sản Phẩm Đã Được Tạo Thành Công
    And Xác Thực Biến Thể Sản Phẩm Được Gắn Với Sản Phẩm Gốc Đúng

RT-PRODUCT-044 Tạo Sản Phẩm Với Thuộc Tính Có Giá Bán Khác Nhau
    [Documentation]    Test tạo sản phẩm với các biến thể có giá bán khác nhau
    [Tags]    AIGenerated    CreateProduct    Positive    VariantPricing    
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Các Biến Thể Có Giá Khác Nhau
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Các Biến Thể Có Giá Bán Theo Cấu Hình

RT-PRODUCT-045 Tạo Sản Phẩm Với Thuộc Tính Có Tồn Kho Khác Nhau
    [Documentation]    Test tạo sản phẩm với các biến thể có tồn kho ban đầu khác nhau
    [Tags]    AIGenerated    CreateProduct    Positive    VariantInventory    
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Các Biến Thể Có Tồn Kho Khác Nhau
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Các Biến Thể Có Tồn Kho Theo Cấu Hình
    And Xác Thực Tổng Tồn Kho Sản Phẩm Chính Bằng Tổng Các Biến Thể

RT-PRODUCT-046 Tạo Sản Phẩm Với Thuộc Tính Có Mã Vạch Riêng
    [Documentation]    Test tạo sản phẩm với các biến thể có mã vạch riêng
    [Tags]    AIGenerated    CreateProduct    Positive    VariantBarcodes    
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Các Biến Thể Có Mã Vạch Riêng
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Các Biến Thể Có Mã Vạch Theo Cấu Hình

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

RT-PRODUCT-049 Tạo Sản Phẩm Với Mã Biến Thể Tự Động
    [Documentation]    Test tạo sản phẩm với mã biến thể được tạo tự động dựa trên mã sản phẩm gốc
    [Tags]    AIGenerated    CreateProduct    Positive    VariantCoding    
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Mã Biến Thể Tự Động
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Mã Các Biến Thể Được Tạo Dựa Trên Mã Sản Phẩm Gốc


*** Keywords ***

