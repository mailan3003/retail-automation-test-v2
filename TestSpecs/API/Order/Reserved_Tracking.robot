*** Settings ***
Documentation     Test cases cho chức năng xử lý khuyến mãi và chiết khấu trong đơn hàng
Suite Setup       Init Test Environment   ${ENV}    MHQL
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../TestData/CommonData.robot
Resource          ../../../Keywords/Order/OrderCommonKeywords.robot
Resource          ../../../Keywords/Order/UpdateOrderKeywords.robot
Resource          ../../../Keywords/Order/CreateOrderKeywords.robot
Resource          ../../../Keywords/Utilities/Utilities.robot
*** Variables ***
@{list_product_code}    HH0080     HH0079      
@{list_product_code_2}    HH0081     HH0082
@{list_product_code_3}    HH0083     HH0084
@{list_product_code_4}    HH0085     HH0086
@{list_product_code_5}    HH0087     HH0088
@{list_product_code_6}    HH0089     HH0090
@{list_quantity}    10.5          5
${product_code_add}     LD01
${quantity_add}    2.333
@{list_product_code_am}    HHT00001    HHTQD00001
@{list_quantity_am}    4    1


*** Test Cases ***
RT-RESERVED-001 Kiểm Tra Số Lượng Đặt Hàng Cho Sản Phẩm Thường
    [Documentation]    Kiểm tra số lượng đặt hàng được tính đúng cho sản phẩm thường:
    ...    - Tạo đơn hàng với sản phẩm thường
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    ...    - Kiểm tra số lượng đặt hàng khớp với số lượng trong đơn hàng
    [Tags]    AIGenerated    Reserved    Tracking    Normal    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm HH0078 Có Số Lượng Đặt Hàng 10.5
    And Lấy Số Lượng Đặt Hàng Của Sản Phẩm HH0078
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng Của Sản Phẩm HH0078 Được Cập Nhập Thêm 10.5
    And Xác Định Order Tracking HH0078 Đặt Hàng Thêm 10.5 Được Lưu Trong Database
    [Teardown]    Delete Order From Api

RT-RESERVED-002 Kiểm Tra Số Lượng Đặt Hàng Cho Sản Phẩm Serial
    [Documentation]    Kiểm tra số lượng đặt hàng được tính đúng cho sản phẩm serial:
    ...    - Tạo đơn hàng với sản phẩm quản lý theo serial
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    ...    - Kiểm tra từng serial được đánh dấu là đã đặt hàng
    [Tags]    AIGenerated    Reserved    Tracking    Serial    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm SI001 Có Số Lượng Đặt Hàng 2
    And Lấy Số Lượng Đặt Hàng Của Sản Phẩm SI001
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng Của Sản Phẩm SI001 Được Cập Nhập Thêm 2
    And Xác Định Order Tracking SI001 Đặt Hàng Thêm 2 Được Lưu Trong Database
     [Teardown]    Delete Order From Api

RT-RESERVED-003 Kiểm Tra Số Lượng Đặt Hàng Cho Sản Phẩm Theo Lô
    [Documentation]    Kiểm tra số lượng đặt hàng được tính đúng cho sản phẩm theo lô:
    ...    - Tạo đơn hàng với sản phẩm quản lý theo lô
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    ...    - Kiểm tra số lượng đặt hàng được trừ đúng từ lô tương ứng
    [Tags]    AIGenerated    Reserved    Tracking    Batch    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm LD01 Có Số Lượng Đặt Hàng 2.333
    And Lấy Số Lượng Đặt Hàng Của Sản Phẩm LD01
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng Của Sản Phẩm LD01 Được Cập Nhập Thêm 2.333
    And Xác Định Order Tracking LD01 Đặt Hàng Thêm 2.333 Được Lưu Trong Database
    [Teardown]    Delete Order From Api


RT-RESERVED-003 Kiểm Tra Số Lượng Đặt Hàng Cho Sản Phẩm Đơn Vị Tính
    [Documentation]    Kiểm tra số lượng đặt hàng được tính đúng cho sản phẩm đơn vị tính:
    ...    - Tạo đơn hàng với sản phẩm đơn vị tính
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    [Tags]    AIGenerated    Reserved    Tracking    Batch    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm LD01 Có Số Lượng Đặt Hàng 2.333
    And Lấy Số Lượng Đặt Hàng Của Sản Phẩm LD01
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng Của Sản Phẩm LD01 Được Cập Nhập Thêm 2.333
    And Xác Định Order Tracking LD01 Đặt Hàng Thêm 2.333 Được Lưu Trong Database
    [Teardown]    Delete Order From Api

RT-RESERVED-004 Kiểm Tra Số Lượng Đặt Hàng Cho Sản Phẩm Dịch Vụ
    [Documentation]    Kiểm tra số lượng đặt hàng được tính đúng cho sản phẩm dịch vụ:
    ...    - Tạo đơn hàng với sản phẩm dịch vụ
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    [Tags]    AIGenerated    Reserved    Tracking    Batch    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm DV001 Có Số Lượng Đặt Hàng 2.333
    And Lấy Số Lượng Đặt Hàng Của Sản Phẩm DV001
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng Của Sản Phẩm DV001 Được Cập Nhập Thêm 2.333
    And Xác Định Order Tracking DV001 Đặt Hàng Thêm 2.333 Được Lưu Trong Database
    [Teardown]    Delete Order From Api


RT-RESERVED-004 Kiểm Tra Số Lượng Đặt Hàng Cho Sản Phẩm Combo
    [Documentation]    Kiểm tra số lượng đặt hàng được tính đúng cho sản phẩm combo:
    ...    - Tạo đơn hàng với sản phẩm combo
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    [Tags]    AIGenerated    Reserved    Tracking    Batch    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm Combo025 Có Số Lượng Đặt Hàng 10.5
    And Lấy Số Lượng Đặt Hàng Của Sản Phẩm Combo025
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng Của Sản Phẩm Combo025 Được Cập Nhập Thêm 10.5
    And Xác Định Order Tracking Combo025 Đặt Hàng Thêm 10.5 Được Lưu Trong Database
    [Teardown]    Delete Order From Api

RT-RESERVED-004 Kiểm Tra Số Lượng Đặt Hàng Khi Hủy Đơn
    [Documentation]    Kiểm tra số lượng đặt hàng được hoàn lại khi hủy đơn:
    ...    - Tạo đơn hàng với các loại sản phẩm khác nhau
    ...    - Hủy đơn hàng
    ...    - Xác thực số lượng đặt hàng được hoàn lại trong bảng Reserved
    [Tags]    AIGenerated    Reserved    Tracking    Cancel    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Sản Phẩm ${list_product_code} Với Số Lượng Đặt Hàng ${list_quantity}
    And Lấy Số Lượng Đặt Hàng ${list_product_code}
    And Gửi Yêu Cầu Tạo Đơn Hàng
    And Xác Thực Số Lượng Đặt Hàng Của ${list_product_code} Được Cập Nhập Thêm ${list_quantity}
    When Delete Order From Api
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng ${list_quantity} Của ${list_product_code} Được Hoàn Lại
    [Teardown]    Delete Order From Api

RT-RESERVED-005 Kiểm Tra Số Lượng Đặt Hàng Khi Cập Nhật Đơn Thêm Hàng Hóa
    [Documentation]    Kiểm tra số lượng đặt hàng được cập nhật đúng khi cập nhật đơn:
    ...    - Tạo đơn hàng với các loại sản phẩm khác nhau
    ...    - Cập nhật đơn hàng
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    [Tags]    AIGenerated    Reserved    Tracking    Update    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Sản Phẩm ${list_product_code_2} Với Số Lượng Đặt Hàng ${list_quantity}
    And Lấy Số Lượng Đặt Hàng ${list_product_code_2}
    And Gửi Yêu Cầu Tạo Đơn Hàng
    And Xác Thực Số Lượng Đặt Hàng Của ${list_product_code_2} Được Cập Nhập Thêm ${list_quantity}
    And Lấy Số Lượng Đặt Hàng Của Sản Phẩm ${product_code_add}
    And Chuẩn Bị Dữ Liệu Đặt Hàng Thêm ${product_code_add} Với Số Lượng ${quantity_add}
    And Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng Của Sản Phẩm ${product_code_add} Được Cập Nhập Thêm ${quantity_add}
    And Xác Định Order Tracking ${product_code_add} Đặt Hàng Thêm ${quantity_add} Được Lưu Trong Database
    [Teardown]    Delete Order From Api

Kiểm Tra Số Lượng Đặt Hàng Khi Cập Nhật Đơn Xóa Hàng Hóa
    [Documentation]    Kiểm tra số lượng đặt hàng được cập nhật đúng khi xóa hàng hóa:
    ...    - Tạo đơn hàng với các loại sản phẩm khác nhau
    ...    - Xóa hàng hóa
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    [Tags]    AIGenerated    Reserved    Tracking    Delete    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Sản Phẩm ${list_product_code_3} Với Số Lượng Đặt Hàng ${list_quantity}
    And Lấy Số Lượng Đặt Hàng ${list_product_code_3}
    And Gửi Yêu Cầu Tạo Đơn Hàng
    And Chuẩn Bị Dữ Liệu Đặt Hàng Xóa ${list_product_code_3}[0] Khỏi Đơn
    And Lấy Số Lượng Đặt Hàng Của Sản Phẩm ${list_product_code_3}[0]
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Hàng ${list_product_code_3}[0] Đặt Hàng Giảm ${list_quantity}[0]
    [Teardown]    Delete Order From Api


Kiểm Tra Số Lượng Đặt Hàng Khi Cập Nhật Đơn Update Số Lượng Hàng Hóa
    [Documentation]    Kiểm tra số lượng đặt hàng được cập nhật đúng khi cập nhật số lượng hàng hóa:
    ...    - Tạo đơn hàng với các loại sản phẩm khác nhau
    ...    - Cập nhật số lượng hàng hóa
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    [Tags]    AIGenerated    Reserved    Tracking    Update    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Sản Phẩm ${list_product_code} Với Số Lượng Đặt Hàng ${list_quantity}
    And Lấy Số Lượng Đặt Hàng Của Sản Phẩm ${list_product_code}[0]
    And Gửi Yêu Cầu Tạo Đơn Hàng
    And Chuẩn Bị Dữ Liệu Đặt Hàng Update ${list_product_code}[0] Với Số Lượng 103.44
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng Của Sản Phẩm ${list_product_code}[0] Được Cập Nhập Thêm 103.44
    [Teardown]    Delete Order From Api

Kiểm Tra Số Lượng Đặt Hàng Khi Cập Nhật Đơn Update Thêm Dòng Hàng Hóa
    [Documentation]    Kiểm tra số lượng đặt hàng được cập nhật đúng khi cập nhật thêm dòng hàng hóa:
    ...    - Tạo đơn hàng với các loại sản phẩm khác nhau
    ...    - Cập nhật đơn hàng
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    [Tags]    AIGenerated    Reserved    Tracking    Update    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Sản Phẩm ${list_product_code} Với Số Lượng Đặt Hàng ${list_quantity}
    And Gửi Yêu Cầu Tạo Đơn Hàng
    And Lấy Số Lượng Đặt Hàng Của Sản Phẩm ${list_product_code}[1]
    And Chuẩn Bị Dữ Liệu Cập Nhật Thêm 2 Dòng Cho Sản Phẩm ${list_product_code}[1] Với Số Lượng Mỗi Dòng 3
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng Của Sản Phẩm ${list_product_code}[1] Được Cập Nhập Thêm ${TOTAL_QUANTITY}
    [Teardown]    Delete Order From Api
    
    
    

RT-RESERVED-006 Kiểm Tra Số Lượng Đặt Hàng Khi Hoàn Thiện Đơn
    [Documentation]    Kiểm tra số lượng đặt hàng được cập nhật đúng khi hoàn thiện đơn:
    ...    - Tạo đơn hàng với các loại sản phẩm khác nhau
    ...    - Hoàn thiện đơn hàng
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    [Tags]    AIGenerated    Reserved    Tracking    Complete    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm HH0088 Có Số Lượng Đặt Hàng 10.5
    And Lấy Số Lượng Đặt Hàng Của Sản Phẩm HH0088
    And Gửi Yêu Cầu Tạo Đơn Hàng
    And Chuẩn Bị Cập Nhật Trạng Thái Đơn Hàng Sang Đã Xác Nhận
    And Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng Của Sản Phẩm HH0088 Được Cập Nhập Thêm 10.5
    [Teardown]    Delete Order From Api

RT-RESERVED-007 Kiểm Tra Số Lượng Đặt Hàng Khi Tạo Hóa Đơn
    [Documentation]    Kiểm tra số lượng đặt hàng được cập nhật đúng khi tạo hóa đơn:
    ...    - Tạo đơn hàng với các loại sản phẩm khác nhau
    ...    - Tạo hóa đơn
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    [Tags]    AIGenerated    Reserved    Tracking    Invoice    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Sản Phẩm ${list_product_code_4} Với Số Lượng Đặt Hàng ${list_quantity}
    And Lấy Số Lượng Đặt Hàng ${list_product_code_4}
    And Gửi Yêu Cầu Tạo Đơn Hàng
    And Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Và Tạo Hóa Đơn
    And Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng Của ${list_product_code_4} Là ${LIST_RESERVED_IN_DB} 
    [Teardown]    Delete Order From Api


    
RT-RESERVED-008 Kiểm Tra Số Lượng Đặt Hàng Khi Tạo Hóa Đơn Lấy 1 Phần
    [Documentation]    Kiểm tra số lượng đặt hàng được cập nhật đúng khi tạo hóa đơn lấy 1 phần:
    ...    - Tạo đơn hàng với các loại sản phẩm khác nhau
    ...    - Tạo hóa đơn từ đơn hàng
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    [Tags]    AIGenerated    Reserved    Tracking    Invoice    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Sản Phẩm ${list_product_code_5} Với Số Lượng Đặt Hàng ${list_quantity}
    And Lấy Số Lượng Đặt Hàng ${list_product_code_5}
    And Gửi Yêu Cầu Tạo Đơn Hàng
    And Chuẩn Bị Dữ Liệu Hóa Đơn Lấy 1 Phần Đặt Hàng ${list_product_code_5}[0] Với Số Lượng ${list_quantity}[0]
    And Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng của Sản Phẩm ${list_product_code_5}[0] Là ${LIST_RESERVED_IN_DB}[0] 
    ${quantity_2}=    Evaluate    ${LIST_RESERVED_IN_DB}[1] + ${list_quantity}[1]
    And Xác Thực Số Lượng Đặt Hàng của Sản Phẩm ${list_product_code_5}[1] Là ${quantity_2} 
    [Teardown]    Delete Order From Api

RT-RESERVED-009 Kiểm Tra Số Lượng Đặt Hàng Khi Tạo Hóa Đơn Lấy 1 Phần Kết Thúc Đơn
    [Documentation]    Kiểm tra số lượng đặt hàng được cập nhật đúng khi tạo hóa đơn lấy 1 phần kết thúc đơn:
    ...    - Tạo đơn hàng với các loại sản phẩm khác nhau
    ...    - Tạo hóa đơn từ đơn hàng
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    [Tags]    AIGenerated    Reserved    Tracking    Invoice    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Sản Phẩm ${list_product_code_6} Với Số Lượng Đặt Hàng ${list_quantity}
    And Lấy Số Lượng Đặt Hàng ${list_product_code_6}
    And Gửi Yêu Cầu Tạo Đơn Hàng
    And Chuẩn Bị Dữ Liệu Hóa Đơn Lấy 1 Phần Đặt Hàng ${list_product_code_6}[0] Với Số Lượng 1
    And Gửi Yêu Cầu Tạo Hóa Đơn
    And Chuẩn Bị Dữ Liệu Hoàn Thành Đơn Hàng
    And Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng Của ${list_product_code_6} Là ${LIST_RESERVED_IN_DB} 
    [Teardown]    Delete Order From Api



RT-RESERVED-010 Kiểm Tra Số Lượng Đặt Hàng Khi Tạo Hóa Đơn Và Lấy 1 Phần Lấy Tiếp
    [Documentation]    Kiểm tra số lượng đặt hàng được cập nhật đúng khi tạo hóa đơn và lấy 1 phần lấy tiếp:
    ...    - Tạo đơn hàng với các loại sản phẩm khác nhau
    ...    - Tạo hóa đơn từ đơn hàng
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    [Tags]    AIGenerated    Reserved    Tracking    Invoice    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Sản Phẩm ${list_product_code} Với Số Lượng Đặt Hàng ${list_quantity}
    And Gửi Yêu Cầu Tạo Đơn Hàng
    And Chuẩn Bị Dữ Liệu Hóa Đơn Lấy 1 Phần Đặt Hàng ${list_product_code}[0] Với Số Lượng 1
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Lấy Tiếp Phần Đặt Hàng ${list_product_code}[0] Với Số Lượng 2
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    


RT-RESERVED-011 Kiểm Tra Số Lượng Đặt Hàng Khi Tạo Hóa Đơn Với Hàng Imei
    [Documentation]    Kiểm tra số lượng đặt hàng được cập nhật đúng khi tạo hóa đơn:
    ...    - Tạo đơn hàng với các loại sản phẩm khác nhau
    ...    - Tạo hóa đơn
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    [Tags]    AIGenerated    Reserved    Tracking    Invoice    regression43
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Sản Phẩm ${list_product_code} Với Số Lượng Đặt Hàng ${list_quantity}
    And Gửi Yêu Cầu Tạo Đơn Hàng
    And Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Theo Serial ${list_product_code}[0] Với Serial ${list_serial_number}[0]
    And Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200

RT-RESERVED-011 Kiểm Tra Số Lượng Đặt Hàng Khi Tạo Hóa Đơn Với Hàng Lô
    [Documentation]    Kiểm tra số lượng đặt hàng được cập nhật đúng khi tạo hóa đơn:
    ...    - Tạo đơn hàng với các loại sản phẩm khác nhau
    ...    - Tạo hóa đơn
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    [Tags]    AIGenerated    Reserved    Tracking    Invoice    regression43
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Sản Phẩm ${list_product_code} Với Số Lượng Đặt Hàng ${list_quantity}
    And Gửi Yêu Cầu Tạo Đơn Hàng
    And Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Và Tạo Hóa Đơn
    And Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200


### Exception Handling
Kiểm Tra Đặt Hàng Gian Hàng Thiết Lập Không Được Phép Bán Âm
    [Documentation]    Kiểm tra đặt hàng gian hàng thiết lập không được phép bán âm
    ...    - Tạo đơn hàng với các loại sản phẩm khác nhau
    ...    - Tạo Đơn Hàng
    ...    - Lỗi 420
    ...    - Lỗi "${name_product}: Đặt hàng quá số lượng cho phép"
    [Tags]    AIGenerated    Reserved    Tracking    Invoice    nhathuoc
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm HHT00001 Có Số Lượng Đặt Hàng 7
    And Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Hàng hóa không đặt âm (Cái): Đặt hàng quá số lượng cho phép"

Kiểm Tra Tổng đặt Hàng Lớn Hơn Số lượng Tồn Kho
    [Documentation]    Kiểm tra tổng đặt hàng lớn hơn số lượng tồn kho
    ...    - Tạo đơn hàng với các hàng đơn vị và Hàng quy đổi
    ...    - Tạo Đơn Hàng
    ...    - Lỗi 420
    ...    - Lỗi "Tổng đặt hàng lớn hơn số lượng tồn kho"
    [Tags]    AIGenerated    Reserved    Tracking    Invoice    nhathuoc
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Sản Phẩm ${list_product_code_am} Với Số Lượng Đặt Hàng ${list_quantity_am}
    And Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Hàng hóa không đặt âm (Hộp): Đặt hàng quá số lượng cho phép"

    
    
    
    
    
    
    
