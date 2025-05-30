*** Settings ***
Documentation     Test cases cho chức năng xử lý khuyến mãi và chiết khấu trong đơn hàng
Resource          ../../../TestData/CommonData.robot
Resource          ../../../TestData/Order/PromotionOrderData.robot
Resource          ../../../Keywords/Order/PromotionOrderKeywords.robot
Resource          ../../../Keywords/Utilities/Utilities.robot

*** Test Cases ***
RT-PROMOTION-ORDER-001 Tạo Đơn Hàng Với Khuyến Mãi Hợp Lệ Thành Công
    [Documentation]    Test tạo đơn hàng với khuyến mãi hợp lệ
    ...                Kiểm tra việc phân tích thuộc tính OrderPromotions để lấy danh sách khuyến mãi
    ...                Lọc các khuyến mãi mới (Id = 0 và PromotionId != null)
    ...                Gọi KvPromotionService.CheckIsDeletedCampaignByIds để kiểm tra tính hợp lệ
    ...                Kỳ vọng: Đơn hàng được tạo thành công với khuyến mãi được áp dụng
    [Tags]    AIGenerated    PromotionOrder    Positive    ValidPromotion    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Khuyến Mãi Hợp Lệ
    When Gửi Yêu Cầu Tạo Đơn Hàng Có Khuyến Mãi
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Có Khuyến Mãi Đã Được Tạo Trong Database
    And Xác Thực Khuyến Mãi Hợp Lệ Được Áp Dụng Đúng

RT-PROMOTION-ORDER-002 Lỗi Khi Tạo Đơn Hàng Với Khuyến Mãi Đã Bị Xóa
    [Documentation]    Test lỗi khi tạo đơn hàng với khuyến mãi đã bị xóa
    ...                Kiểm tra việc phát hiện khuyến mãi đã bị xóa qua KvPromotionService
    ...                Thu thập thông tin tên khuyến mãi từ PromotionInfo
    ...                Phát sinh ngoại lệ KvValidateException với thông báo PromotionsAreDeletedNotification
    ...                Kỳ vọng: Trả về lỗi với thông báo khuyến mãi đã bị xóa
    [Tags]    AIGenerated    PromotionOrder    Negative    DeletedPromotion    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Khuyến Mãi Đã Bị Xóa
    When Gửi Yêu Cầu Tạo Đơn Hàng Có Khuyến Mãi
    Then Mã Trạng Thái Phải Là 420
    And PromotionOrderKeywords.Phản Hồi Phải Chứa Lỗi "PromotionsAreDeletedNotification"
    And Phản Hồi Phải Chứa Lỗi Khuyến Mãi Đã Bị Xóa "${DELETE_PROMOTION_NAME}"

RT-PROMOTION-ORDER-003 Tạo Đơn Hàng Với Nhiều Khuyến Mãi Hợp Lệ Thành Công
    [Documentation]    Test tạo đơn hàng với nhiều khuyến mãi hợp lệ cùng lúc
    ...                Kiểm tra việc xử lý nhiều khuyến mãi trong OrderPromotions
    ...                Xác thực tất cả khuyến mãi đều hợp lệ qua KvPromotionService
    ...                Kỳ vọng: Đơn hàng được tạo với tất cả khuyến mãi được áp dụng
    [Tags]    AIGenerated    PromotionOrder    Positive    MultiplePromotions    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Nhiều Khuyến Mãi Hợp Lệ
    When Gửi Yêu Cầu Tạo Đơn Hàng Có Khuyến Mãi
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Có Khuyến Mãi Đã Được Tạo Trong Database
    And Xác Thực Nhiều Khuyến Mãi Được Áp Dụng Đúng

RT-PROMOTION-ORDER-004 Tạo Đơn Hàng Với Khuyến Mãi Cho Nhóm Khách Hàng Thành Công
    [Documentation]    Test tạo đơn hàng với khuyến mãi áp dụng cho nhóm khách hàng cụ thể
    ...                Kiểm tra việc áp dụng khuyến mãi dựa trên nhóm khách hàng
    ...                Xác thực khuyến mãi được áp dụng đúng cho khách hàng thuộc nhóm
    ...                Kỳ vọng: Đơn hàng được tạo với khuyến mãi nhóm khách hàng được áp dụng
    [Tags]    AIGenerated    PromotionOrder    Positive    CustomerGroupPromotion    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Khuyến Mãi Cho Nhóm Khách Hàng
    When Gửi Yêu Cầu Tạo Đơn Hàng Có Khuyến Mãi
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Có Khuyến Mãi Đã Được Tạo Trong Database
    And Xác Thực Khuyến Mãi Cho Nhóm Khách Hàng Được Áp Dụng

RT-PROMOTION-ORDER-005 Tạo Đơn Hàng Với Sản Phẩm Khuyến Mãi Trùng Lặp ProductId Thành Công
    [Documentation]    Test tạo đơn hàng với sản phẩm khuyến mãi có thể trùng lặp ProductId
    ...                Kiểm tra việc xử lý đặc biệt cho sản phẩm khuyến mãi (SalePromotionId != null)
    ...                Cho phép trùng lặp ProductId cho sản phẩm khuyến mãi
    ...                Đảm bảo không bị ảnh hưởng bởi quy tắc kiểm tra trùng lặp sản phẩm
    ...                Kỳ vọng: Đơn hàng được tạo với sản phẩm khuyến mãi trùng lặp được xử lý đúng
    [Tags]    AIGenerated    PromotionOrder    Positive    DuplicatePromotionProduct    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Sản Phẩm Khuyến Mãi Trùng Lặp
    When Gửi Yêu Cầu Tạo Đơn Hàng Có Khuyến Mãi
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Có Khuyến Mãi Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Khuyến Mãi Trùng Lặp Được Xử Lý Đúng

RT-PROMOTION-ORDER-006 Tạo Đơn Hàng Với Các Giá Trị Chiết Khấu Và Phụ Thu Khác Nhau
    [Documentation]    Test tạo đơn hàng với các giá trị chiết khấu và phụ thu khác nhau
    ...                Kiểm tra việc xử lý chiết khấu (Discount) và phụ thu (Surcharge)
    ...                Tính toán tổng tiền đơn hàng sau khi áp dụng chiết khấu và phụ thu
    ...                Sử dụng NumberHelper.RoundTotalPrice để làm tròn giá trị tiền tệ
    [Tags]    AIGenerated    PromotionOrder    Positive    DiscountSurcharge    regression
    [Template]    Test Tạo Đơn Hàng Với Chiết Khấu Và Phụ Thu
    # discount    surcharge
    10000         5000
    20000         0
    0             15000
    50000         10000

RT-PROMOTION-ORDER-007 Tạo Đơn Hàng Với Tổng Tiền Bằng 0 Được Tính Toán Lại Thành Công
    [Documentation]    Test tạo đơn hàng với tổng tiền = 0 để kiểm tra tính toán lại
    ...                Nếu tổng tiền đơn hàng (Total) bằng 0, thực hiện tính toán lại:
    ...                - Tính tổng giá trị sản phẩm: (Price - Discount) * Quantity
    ...                - Trừ chiết khấu đơn hàng: - (Discount ?? 0)
    ...                - Cộng phụ thu: + (Surcharge ?? 0)
    ...                - Áp dụng làm tròn tiền tệ theo cấu hình hiện tại
    ...                Kỳ vọng: Tổng tiền được tính toán lại đúng
    [Tags]    AIGenerated    PromotionOrder    Positive    TotalRecalculation    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Tổng Tiền Bằng 0
    When Gửi Yêu Cầu Tạo Đơn Hàng Có Khuyến Mãi
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Có Khuyến Mãi Đã Được Tạo Trong Database
    And Xác Thực Tổng Tiền Đơn Hàng Được Tính Toán Lại Đúng

RT-PROMOTION-ORDER-008 Tạo Đơn Hàng Với Giá Trị Tiền Tệ Thập Phân Được Làm Tròn Đúng
    [Documentation]    Test tạo đơn hàng với giá trị tiền tệ thập phân
    ...                Kiểm tra việc sử dụng NumberHelper.RoundTotalPrice để làm tròn
    ...                Áp dụng cấu hình CurrencyDecimalPlace hiện tại
    ...                Đảm bảo tất cả giá trị tiền tệ được làm tròn theo cấu hình
    ...                Kỳ vọng: Giá trị tiền tệ được làm tròn đúng theo cấu hình
    [Tags]    AIGenerated    PromotionOrder    Positive    CurrencyRounding    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Giá Trị Tiền Tệ Thập Phân
    When Gửi Yêu Cầu Tạo Đơn Hàng Có Khuyến Mãi
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Có Khuyến Mãi Đã Được Tạo Trong Database
    And Xác Thực Giá Trị Tiền Tệ Được Làm Tròn Đúng Theo Cấu Hình

RT-PROMOTION-ORDER-009 Tạo Đơn Hàng Với PromotionInfo Có Các Định Dạng Khác Nhau
    [Documentation]    Test tạo đơn hàng với PromotionInfo có các định dạng khác nhau
    ...                Kiểm tra việc xử lý PromotionInfo với định dạng có dấu hai chấm ":"
    ...                Quy trình xử lý PromotionInfo khá phức tạp, cần lưu ý định dạng dữ liệu
    ...                Sử dụng dấu hai chấm để tách tên khuyến mãi
    [Tags]    AIGenerated    PromotionOrder    Positive    PromotionInfoFormat    regression
    [Template]    Test Tạo Đơn Hàng Với PromotionInfo Định Dạng
    # format_type
    complex
    with_colon
    malformed

RT-PROMOTION-ORDER-010 Tạo Đơn Hàng Với Log Khuyến Mãi Được Ghi Đúng
    [Documentation]    Test tạo đơn hàng với việc ghi log khuyến mãi
    ...                Khi ghi log đơn hàng, bao gồm thông tin về khuyến mãi đã áp dụng
    ...                Lưu trữ thông tin về chiết khấu và phụ thu trong log
    ...                Kỳ vọng: Log khuyến mãi được ghi đầy đủ và chính xác
    [Tags]    AIGenerated    PromotionOrder    Positive    PromotionLogging    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Khuyến Mãi Hợp Lệ
    When Gửi Yêu Cầu Tạo Đơn Hàng Có Khuyến Mãi
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Có Khuyến Mãi Đã Được Tạo Trong Database
    And Xác Thực Log Khuyến Mãi Được Ghi Đúng

RT-PROMOTION-ORDER-011 Lỗi Khi Tạo Đơn Hàng Với Khuyến Mãi Có PromotionId Null
    [Documentation]    Test lỗi khi tạo đơn hàng với khuyến mãi có PromotionId null
    ...                Kiểm tra việc lọc khuyến mãi mới: chỉ xem xét Id = 0 và PromotionId != null
    ...                Khuyến mãi có PromotionId null không được xử lý
    ...                Kỳ vọng: Khuyến mãi không được áp dụng khi PromotionId null
    [Tags]    AIGenerated    PromotionOrder    Negative    NullPromotionId    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Khuyến Mãi Với PromotionId Null
    When Gửi Yêu Cầu Tạo Đơn Hàng Có Khuyến Mãi
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Có Khuyến Mãi Đã Được Tạo Trong Database
    And Xác Thực Khuyến Mãi Không Được Áp Dụng Khi PromotionId Null

RT-PROMOTION-ORDER-012 Lỗi Khi Tạo Đơn Hàng Với Khuyến Mãi Hết Hạn
    [Documentation]    Test lỗi khi tạo đơn hàng với khuyến mãi hết hạn
    ...                Kiểm tra việc xác thực thời gian hiệu lực của khuyến mãi
    ...                Khuyến mãi hết hạn không được áp dụng cho đơn hàng
    ...                Kỳ vọng: Khuyến mãi hết hạn không được áp dụng
    [Tags]    AIGenerated    PromotionOrder    Negative    ExpiredPromotion    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Khuyến Mãi Hết Hạn
    When Gửi Yêu Cầu Tạo Đơn Hàng Có Khuyến Mãi
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Có Khuyến Mãi Đã Được Tạo Trong Database
    And Xác Thực Khuyến Mãi Hết Hạn Không Được Áp Dụng

RT-PROMOTION-ORDER-013 Lỗi Khi Tạo Đơn Hàng Với Khuyến Mãi Không Hoạt Động
    [Documentation]    Test lỗi khi tạo đơn hàng với khuyến mãi không hoạt động
    ...                Kiểm tra việc xác thực trạng thái hoạt động của khuyến mãi
    ...                Khuyến mãi không hoạt động không được áp dụng cho đơn hàng
    ...                Kỳ vọng: Khuyến mãi không hoạt động không được áp dụng
    [Tags]    AIGenerated    PromotionOrder    Negative    InactivePromotion    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Khuyến Mãi Không Hoạt Động
    When Gửi Yêu Cầu Tạo Đơn Hàng Có Khuyến Mãi
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Có Khuyến Mãi Đã Được Tạo Trong Database
    And Xác Thực Khuyến Mãi Không Hoạt Động Không Được Áp Dụng

*** Keywords ***
Test Tạo Đơn Hàng Với Chiết Khấu Và Phụ Thu
    [Arguments]    ${discount}    ${surcharge}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Chiết Khấu "${discount}" Và Phụ Thu "${surcharge}"
    When Gửi Yêu Cầu Tạo Đơn Hàng Có Khuyến Mãi
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Có Khuyến Mãi Đã Được Tạo Trong Database
    And Xác Thực Chiết Khấu "${discount}" Và Phụ Thu "${surcharge}" Được Tính Đúng

Test Tạo Đơn Hàng Với PromotionInfo Định Dạng
    [Arguments]    ${format_type}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có PromotionInfo Với Định Dạng "${format_type}"
    When Gửi Yêu Cầu Tạo Đơn Hàng Có Khuyến Mãi
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Có Khuyến Mãi Đã Được Tạo Trong Database
    And Xác Thực PromotionInfo Được Xử Lý Đúng Định Dạng 