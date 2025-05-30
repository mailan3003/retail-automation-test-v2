*** Settings ***
Documentation     Test cases cho chức năng xử lý khuyến mãi và chiết khấu trong đơn hàng
Resource          ../../../TestData/CommonData.robot
Resource          ../../../TestData/Order/PromotionOrderData.robot
Resource          ../../../Keywords/Order/PromotionOrderKeywords.robot
Resource          ../../../Keywords/Utilities/Utilities.robot

*** Test Cases ***
RT-RESERVED-001 Kiểm Tra Số Lượng Đặt Hàng Cho Sản Phẩm Thường
    [Documentation]    Kiểm tra số lượng đặt hàng được tính đúng cho sản phẩm thường:
    ...    - Tạo đơn hàng với sản phẩm thường
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    ...    - Kiểm tra số lượng đặt hàng khớp với số lượng trong đơn hàng
    [Tags]    AIGenerated    Reserved    Tracking    Normal    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm Thường
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng Được Cập Nhật Trong Bảng Reserved
    And Xác Thực Số Lượng Đặt Hàng Khớp Với Số Lượng Trong Đơn Hàng

RT-RESERVED-002 Kiểm Tra Số Lượng Đặt Hàng Cho Sản Phẩm Serial
    [Documentation]    Kiểm tra số lượng đặt hàng được tính đúng cho sản phẩm serial:
    ...    - Tạo đơn hàng với sản phẩm quản lý theo serial
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    ...    - Kiểm tra từng serial được đánh dấu là đã đặt hàng
    [Tags]    AIGenerated    Reserved    Tracking    Serial    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm Serial
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng Được Cập Nhật Trong Bảng Reserved
    And Xác Thực Serial Được Đánh Dấu Là Đã Đặt Hàng

RT-RESERVED-003 Kiểm Tra Số Lượng Đặt Hàng Cho Sản Phẩm Theo Lô
    [Documentation]    Kiểm tra số lượng đặt hàng được tính đúng cho sản phẩm theo lô:
    ...    - Tạo đơn hàng với sản phẩm quản lý theo lô
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    ...    - Kiểm tra số lượng đặt hàng được trừ đúng từ lô tương ứng
    [Tags]    AIGenerated    Reserved    Tracking    Batch    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm Theo Lô
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng Được Cập Nhật Trong Bảng Reserved
    And Xác Thực Số Lượng Đặt Hàng Được Trừ Đúng Từ Lô

RT-RESERVED-004 Kiểm Tra Số Lượng Đặt Hàng Khi Hủy Đơn
    [Documentation]    Kiểm tra số lượng đặt hàng được hoàn lại khi hủy đơn:
    ...    - Tạo đơn hàng với các loại sản phẩm khác nhau
    ...    - Hủy đơn hàng
    ...    - Xác thực số lượng đặt hàng được hoàn lại trong bảng Reserved
    [Tags]    AIGenerated    Reserved    Tracking    Cancel    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Loại Sản Phẩm
    When Gửi Yêu Cầu Tạo Đơn Hàng
    And Gửi Yêu Cầu Hủy Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng Được Hoàn Lại Trong Bảng Reserved

RT-RESERVED-005 Kiểm Tra Số Lượng Đặt Hàng Khi Cập Nhật Đơn
    [Documentation]    Kiểm tra số lượng đặt hàng được cập nhật đúng khi cập nhật đơn:
    ...    - Tạo đơn hàng với các loại sản phẩm khác nhau
    ...    - Cập nhật đơn hàng
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    [Tags]    AIGenerated    Reserved    Tracking    Update    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Loại Sản Phẩm
    When Gửi Yêu Cầu Tạo Đơn Hàng
    And Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng Được Cập Nhật Trong Bảng Reserved
    
RT-RESERVED-006 Kiểm Tra Số Lượng Đặt Hàng Khi Hoàn Thiện Đơn
    [Documentation]    Kiểm tra số lượng đặt hàng được cập nhật đúng khi hoàn thiện đơn:
    ...    - Tạo đơn hàng với các loại sản phẩm khác nhau
    ...    - Hoàn thiện đơn hàng
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    [Tags]    AIGenerated    Reserved    Tracking    Complete    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Loại Sản Phẩm
    When Gửi Yêu Cầu Tạo Đơn Hàng
    And Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng Được Cập Nhật Trong Bảng Reserved


RT-RESERVED-007 Kiểm Tra Số Lượng Đặt Hàng Khi Tạo Hóa Đơn
    [Documentation]    Kiểm tra số lượng đặt hàng được cập nhật đúng khi tạo hóa đơn:
    ...    - Tạo đơn hàng với các loại sản phẩm khác nhau
    ...    - Tạo hóa đơn
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    [Tags]    AIGenerated    Reserved    Tracking    Invoice    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Loại Sản Phẩm
    When Gửi Yêu Cầu Tạo Đơn Hàng
    And Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng Được Cập Nhật Trong Bảng Reserved
    
RT-RESERVED-008 Kiểm Tra Số Lượng Đặt Hàng Khi Tạo Hóa Đơn Từ Đơn Hàng
    [Documentation]    Kiểm tra số lượng đặt hàng được cập nhật đúng khi tạo hóa đơn từ đơn hàng:
    ...    - Tạo đơn hàng với các loại sản phẩm khác nhau
    ...    - Tạo hóa đơn từ đơn hàng
    ...    - Xác thực số lượng đặt hàng được cập nhật trong bảng Reserved
    [Tags]    AIGenerated    Reserved    Tracking    Invoice    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Loại Sản Phẩm
    When Gửi Yêu Cầu Tạo Đơn Hàng
    And Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Số Lượng Đặt Hàng Được Cập Nhật Trong Bảng Reserved

RT-RESERVED-009 Kiểm Tra Số Lượng Đặt Hàng Khi Tạo Hóa Đơn Từ Đơn Hàng



    
    
    
    
    
    
    
