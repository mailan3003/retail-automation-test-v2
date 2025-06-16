*** Settings ***
Documentation     Test API tạo sản phẩm 
Suite Setup       Init Test Environment   ${ENV}     MHQL
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Product/Product_dakho_Keywords.robot
Resource          ../../../Keywords/Product/InputValidationKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Product/ProductCommonKeywords.robot


*** Variables ***
@{list_kho_hang}    Kho 1    Kho 2    
@{list_ton_kho}    100    22.777    
@{name_unit}    Cái     Hộp   Nửa Hộp   
@{value}    1      6           0.5
@{value_attribute_1}   L  M   
@{value_attribute_2}   Đỏ  Xanh
&{dict_attribute_name}    SIZE=@{value_attribute_1}    COLOUR=@{value_attribute_2}
@{attribute_kho_hang}     Kho bán hàng    Kho 1    Kho 2    
@{attribute_ton_kho}       1,2,3       2.5,1,0     0,55,1       5,11.334,9.88     
@{list_ton_kho_0}    0    0    
@{list_ton_kho_negative}    -4    -4    
*** Test Cases ***

RT-PRODUCT-1 Tạo Sản Phẩm Với Quản Lý Đa Kho
    [Documentation]    Kiểm tra tạo sản phẩm có quản lý đa kho với kho chính có tồn kho 5.75 và
    ...    kho phụ có tồn kho cụ thể
    [Tags]    AIGenerated    CreateProduct    Positive    dakho
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Kho Chính Có 5.75 Và Kho Phụ ${list_kho_hang} Với Tồn Kho ${list_ton_kho}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Tồn Kho 100 Ở Chi Nhánh Kho 1
    And Xác Thực Sản Phẩm Có Tồn Kho 22.777 Ở Chi Nhánh Kho 2
    And Xác Thực Sản Phẩm Ở Kho Bán Hàng Có Tồn Kho 5.75 Và ${TOTAL_ONHAND}
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
RT-PRODUCT-2 Tạo Sản Phẩm Đa kho Kho chính =0
    [Documentation]    Kiểm tra tạo sản phẩm đa kho với kho chính có tồn kho 0 và
    ...    kho phụ có tồn kho cụ thể
    [Tags]    AIGenerated    CreateProduct    Positive     dakho 
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Kho Chính Có 0 Và Kho Phụ ${list_kho_hang} Với Tồn Kho ${list_ton_kho}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Tồn Kho 100 Ở Chi Nhánh Kho 1
    And Xác Thực Sản Phẩm Có Tồn Kho 22.777 Ở Chi Nhánh Kho 2
    And Xác Thực Sản Phẩm Ở Kho Bán Hàng Có Tồn Kho 0 Và ${TOTAL_ONHAND}
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
RT-PRODUCT-3 Tạo Sản Phẩm Đơn Vị Tính Và Quy Đổi Đa Kho
    [Documentation]    Kiểm tra tạo sản phẩm với đơn vị tính, quy đổi đa kho, kho chính tồn 2 và
    ...    kho phụ có tồn kho cụ thể
    [Tags]    AIGenerated    CreateProduct    Positive    dakho   
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Đơn Vị Tính ${name_unit} Có ${value} Kho Chính Tồn 2 Kho Phụ ${list_kho_hang} Tồn ${list_ton_kho}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm ${LIST_PRODUCTS_CODE} Có DVT ${value} Tồn Kho ${list_ton_kho} Ở ${list_kho_hang}
    And Xác Thực Sản Phẩm ${LIST_PRODUCTS_CODE} Có DVT ${value} Tồn Kho 2 Và ${TOTAL_ONHAND} Ở Kho Bán Hàng 
    [Teardown]     Delete Nhiều Sản Phẩm  ${LIST_PRODUCTS_CODE} 
RT-PRODUCT-4 Tạo Sản Phẩm Đa Kho Có Thuộc Tính
    [Documentation]    Kiểm tra tạo sản phẩm đa kho có thuộc tính với kho chính tồn 5 và
    ...    kho phụ có tồn kho cụ thể
    [Tags]    AIGenerated    CreateProduct    Positive    dakho     Serial
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuộc Tính ${dict_attribute_name} Kho Chính Tồn 5 Kho Phụ ${list_kho_hang} Tồn ${list_ton_kho}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm ${LIST_PRODUCTS_CODE} Tồn ${list_ton_kho} Ở Kho ${list_kho_hang}
    And Xác Thực Sản Phẩm ${LIST_PRODUCTS_CODE} Ở Kho Bán Hàng Có Tồn Kho 5 Và ${TOTAL_ONHAND}
    [Teardown]     Delete Nhiều Sản Phẩm  ${LIST_PRODUCTS_CODE} 

RT-PRODUCT-5 Tạo Sản Phẩm Đa Kho Có Đơn Vị Tính Và Thuộc Tính
    [Documentation]    Kiểm tra tạo sản phẩm đa kho có đơn vị tính và thuộc tính với kho chính tồn 1 và
    ...    kho phụ có tồn kho cụ thể
    [Tags]    AIGenerated    CreateProduct    Positive    dakho    MultiBranch
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuộc Tính ${dict_attribute_name} Đơn Vị ${name_unit} Có ${value} Và Kho Chính Tồn 1 Kho Phụ ${list_kho_hang} Tồn ${list_ton_kho}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Thuộc Tính ${LIST_PRODUCTS_CODE} Có DVT ${value} Tồn Kho ${list_ton_kho} Ở ${list_kho_hang}
    [Teardown]     Delete Nhiều Sản Phẩm  ${LIST_PRODUCTS_CODE} 
RT-PRODUCT-6 Tạo Sản Phẩm Đa Kho Thuộc Tính Mỗi Loại Có Tồn Kho Khác Nhau
    [Documentation]    Kiểm tra tạo sản phẩm đa kho có thuộc tính với mỗi loại có tồn kho khác nhau
    ...    tương ứng với các kho
    [Tags]    AIGenerated    CreateProduct    Positive    dakho    MultiBranch
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuộc Tính ${dict_attribute_name} Có Tồn Kho ${attribute_ton_kho} Tương Ứng với Các Kho ${attribute_kho_hang}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm ${LIST_PRODUCTS_CODE} Tồn ${attribute_ton_kho} Ở Kho ${attribute_kho_hang}
    [Teardown]     Delete Nhiều Sản Phẩm  ${LIST_PRODUCTS_CODE} 
RT-PRODUCT-7 Tạo Sản Phẩm Đa Kho Với Tồn Kho Tất Cả Các Kho Bằng 0
    [Documentation]    Kiểm tra tạo sản phẩm đa kho với tồn kho tất cả các kho đều bằng 0
    [Tags]    AIGenerated    CreateProduct    Positive    dakho    MultiBranch
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Kho Chính Có 0 Và Kho Phụ ${list_kho_hang} Với Tồn Kho ${list_ton_kho_0}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Tồn Kho 0 Ở Chi Nhánh Kho 1
    And Xác Thực Sản Phẩm Có Tồn Kho 0 Ở Chi Nhánh Kho 2
    And Xác Thực Sản Phẩm Ở Kho Bán Hàng Có Tồn Kho 0 Và ${TOTAL_ONHAND}
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 



*** Keywords ***



