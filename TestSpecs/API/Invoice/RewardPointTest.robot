*** Settings ***
Documentation     Test cases API cho phần tính điểm thưởng khi tạo hóa đơn
Resource          ../../../Keywords/Invoice/RewardPointKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    RewardPointTest

*** Test Cases ***
RT-RP-001 Tạo hóa đơn với tích điểm theo hóa đơn
    [Documentation]    Kiểm tra tính điểm thưởng thành công khi RewardPoint_Type = Invoice
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ 
    ...    - MoneyPerPoint = 10,000đ (Mỗi 10,000đ tương đương 1 điểm)
    ...    - Không có phụ phí và thuế
    ...    - Logic tính điểm:
    ...    - Điểm = Floor(Tổng tiền / MoneyPerPoint) = Floor(100,000 / 10,000) = 10 điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với 10 điểm thưởng
    ...    - Lịch sử điểm được cập nhật
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tích Điểm Theo Hóa Đơn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Điểm thưởng của hóa đơn là 10
    And Lịch sử điểm của khách hàng ${DEFAULT_CUSTOMER_ID} được ghi nhận với 10 điểm

RT-RP-002 Tạo hóa đơn với tích điểm theo sản phẩm
    [Documentation]    Kiểm tra tính điểm thưởng thành công khi RewardPoint_Type = Product
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm có Point = 10, Quantity = 1
    ...    - Logic tính điểm:
    ...    - Điểm = Sum(Số lượng * Point) = 1 * 10 = 10 điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với 10 điểm thưởng
    ...    - Chi tiết hóa đơn được ghi nhận điểm
    Given Chuẩn Bị Dữ Liệu Hóa Đơn với sản phẩm có điểm thưởng là 10 và số lượng là 1
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Điểm thưởng của hóa đơn là 10
    And Điểm thưởng chi tiết của sản phẩm ${PRODUCT_1} là 10

RT-RP-003 Tạo hóa đơn với sản phẩm không tích điểm
    [Documentation]    Kiểm tra tính điểm thưởng khi sản phẩm có UsePoint = False
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm có UsePoint = False
    ...    - Logic tính điểm:
    ...    - Điểm = 0 (không tích điểm cho sản phẩm có UsePoint = False)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với 0 điểm thưởng
    ...    - Chi tiết hóa đơn có điểm = 0
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Không Tích Điểm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Điểm thưởng của hóa đơn là 0
    And Điểm thưởng chi tiết của sản phẩm ${PRODUCT_1} là 0

RT-RP-004 Tạo hóa đơn với nhiều sản phẩm có điểm thưởng khác nhau
    [Documentation]    Kiểm tra tính điểm thưởng khi có nhiều sản phẩm với điểm thưởng khác nhau
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm 1: Point = 10, Quantity = 1, UsePoint = True 
    ...    - Sản phẩm 2: UsePoint = False
    ...    - Logic tính điểm:
    ...    - Điểm = Sum(Điểm sản phẩm có tích điểm) = 10 điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với 10 điểm thưởng
    ...    - Chi tiết hóa đơn 1 có 10 điểm, chi tiết hóa đơn 2 có 0 điểm
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Sản Phẩm Khác Nhau
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Điểm thưởng của hóa đơn là 10
    And Điểm thưởng chi tiết của sản phẩm ${PRODUCT_1} là 10

RT-RP-005 Tạo hóa đơn với chiết khấu và tích điểm trên giá đã giảm
    [Documentation]    Kiểm tra tính điểm thưởng khi hóa đơn có chiết khấu và RewardPoint_ForDiscountInvoice = True
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền ban đầu = 100,000đ, Chiết khấu = 10,000đ, Tổng sau giảm = 90,000đ
    ...    - MoneyPerPoint = 10,000đ
    ...    - RewardPoint_ForDiscountInvoice = True (tính điểm trên giá đã giảm)
    ...    - Logic tính điểm:
    ...    - Điểm = Floor(Tổng sau giảm / MoneyPerPoint) = Floor(90,000 / 10,000) = 9 điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với 9 điểm thưởng
    Given Chuẩn Bị Dữ Liệu Hóa Đơn với tổng điểm 100000 thiết lập chiết khấu 10000 điểm MoneyPerPoint là 10000 và cấu hình tính điểm thưởng trên giá chưa giảm là False
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Điểm thưởng của hóa đơn là 9

RT-RP-006 Tạo hóa đơn với chiết khấu và không tích điểm trên giá đã giảm
    [Documentation]    Kiểm tra tính điểm thưởng khi hóa đơn có chiết khấu và RewardPoint_ForDiscountInvoice = False
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền ban đầu = 100,000đ, Chiết khấu = 10,000đ, Tổng sau giảm = 90,000đ
    ...    - MoneyPerPoint = 10,000đ
    ...    - RewardPoint_ForDiscountInvoice = False (tính điểm trên giá chưa giảm)
    ...    - Logic tính điểm:
    ...    - Điểm = Floor(Tổng trước giảm / MoneyPerPoint) = Floor(100,000 / 10,000) = 10 điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với 10 điểm thưởng
    Given Chuẩn Bị Dữ Liệu Hóa Đơn với tổng điểm 100000 thiết lập chiết khấu 10000 điểm MoneyPerPoint là 10000 và cấu hình tính điểm thưởng trên giá chưa giảm là True
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Điểm thưởng của hóa đơn là 10

RT-RP-007 Tạo hóa đơn không có khách hàng
    [Documentation]    Kiểm tra tính điểm thưởng khi hóa đơn không có khách hàng
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền = 100,000đ
    ...    - CustomerId = 0 (không có khách hàng)
    ...    - MoneyPerPoint = 10,000đ
    ...    - Logic tính điểm:
    ...    - Điểm = 0 (không tích điểm cho hóa đơn không có khách hàng)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với 0 điểm thưởng
    ...    - Không có lịch sử điểm được tạo
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Không Có Khách Hàng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Điểm thưởng của hóa đơn là 0
    And Không có lịch sử điểm nào được tạo

RT-RP-008 Tạo hóa đơn với khuyến mãi tặng điểm
    [Documentation]    Kiểm tra tính điểm thưởng khi hóa đơn có khuyến mãi tặng điểm
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền = 100,000đ
    ...    - MoneyPerPoint = 10,000đ
    ...    - Khuyến mãi PromotionType = PROMOTION_INVOICE_DONATE_POINT, PromotionValue = 20
    ...    - Logic tính điểm:
    ...    - Điểm từ hóa đơn = Floor(100,000 / 10,000) = 10 điểm
    ...    - Điểm từ khuyến mãi = 20 điểm
    ...    - Tổng điểm = 10 + 20 = 30 điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với 30 điểm thưởng
    ...    - Thông tin khuyến mãi tặng điểm được lưu vào DB
    Given Chuẩn Bị Dữ Liệu Hóa Đơn với khuyến mãi tặng 20 điểm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Điểm thưởng của hóa đơn là 30
    And Khuyến mãi điểm của hóa đơn PROMOTION_INVOICE_DONATE_POINT có giá trị là 20

RT-RP-009 Tạo hóa đơn với khuyến mãi tặng điểm theo sản phẩm
    [Documentation]    Kiểm tra tính điểm thưởng khi hóa đơn có khuyến mãi tặng điểm theo sản phẩm
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm: Point = 10, Quantity = 1
    ...    - Khuyến mãi PromotionType = PROMOTION_PRODUCT_DONATE_POINT, PromotionValue = 5, ProductId = sản phẩm
    ...    - Logic tính điểm:
    ...    - Điểm từ sản phẩm = 10 * 1 = 10 điểm
    ...    - Điểm từ khuyến mãi = 5 điểm
    ...    - Tổng điểm = 10 + 5 = 15 điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với 15 điểm thưởng
    ...    - Thông tin khuyến mãi tặng điểm được lưu vào DB
    Given Chuẩn Bị Dữ Liệu Hóa Đơn với khuyến mãi sản phẩm tặng 5 điểm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Điểm thưởng của hóa đơn là 15
    And Điểm thưởng chi tiết của sản phẩm ${PRODUCT_1} là 10
    And Khuyến mãi điểm của hóa đơn PROMOTION_PRODUCT_DONATE_POINT có giá trị là 5

RT-RP-010 Tạo hóa đơn với số lượng sản phẩm lớn
    [Documentation]    Kiểm tra tính điểm thưởng khi có số lượng sản phẩm lớn
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm có Point = 10, Quantity = 5
    ...    - Logic tính điểm:
    ...    - Điểm = Số lượng * Point = 5 * 10 = 50 điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với 50 điểm thưởng
    Given Chuẩn Bị Dữ Liệu Hóa Đơn với sản phẩm có điểm thưởng là 10 và số lượng là 5
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Điểm thưởng của hóa đơn là 50
    And Điểm thưởng chi tiết của sản phẩm ${PRODUCT_1} là 50

RT-RP-011 Tạo hóa đơn với phụ phí và thuế
    [Documentation]    Kiểm tra tính điểm thưởng khi hóa đơn có phụ phí và thuế
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền = 100,000đ
    ...    - Phụ phí = 5,000đ
    ...    - Thuế = 10,000đ
    ...    - MoneyPerPoint = 10,000đ
    ...    - Logic tính điểm:
    ...    - Điểm = Floor((Tổng tiền - Phụ phí - Thuế) / MoneyPerPoint) = Floor((100,000 - 5,000 - 10,000) / 10,000) = 8 điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với 8 điểm thưởng
    Given Chuẩn Bị Dữ Liệu Hóa Đơn với tổng tiền 100000 MoneyPerPoint là 10000 phụ phí 5000 và thuế 10000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Điểm thưởng của hóa đơn là 8

RT-RP-012 Tạo hóa đơn với tổng tiền không tích điểm
    [Documentation]    Kiểm tra tính điểm thưởng khi tổng tiền không đủ để tích điểm
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền = 9,000đ
    ...    - MoneyPerPoint = 10,000đ
    ...    - Logic tính điểm:
    ...    - Điểm = Floor(9,000 / 10,000) = 0 điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với 0 điểm thưởng
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tích Điểm Theo Hóa Đơn
    # Cập nhật tổng tiền hóa đơn
    Set To Dictionary    ${REQUEST_DATA.Invoice}    Total=9000
    # Cập nhật giá sản phẩm
    Set To Dictionary    ${REQUEST_DATA.Invoice.InvoiceDetails[0]}    Price=9000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Điểm thưởng của hóa đơn là 0

RT-RP-013 Tạo hóa đơn với nhóm khách hàng có tỷ lệ điểm đặc biệt
    [Documentation]    Kiểm tra tính điểm thưởng khi khách hàng thuộc nhóm VIP có tỷ lệ quy đổi điểm đặc biệt
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền = 100,000đ
    ...    - MoneyPerPoint = 5,000đ (nhóm VIP: 5,000đ = 1 điểm, gấp đôi thông thường)
    ...    - CustomerGroupId = 1001 (nhóm VIP)
    ...    - Logic tính điểm:
    ...    - Điểm = Floor(100,000 / 5,000) = 20 điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với 20 điểm thưởng
    ...    - Lịch sử điểm được cập nhật
    Given Chuẩn Bị Dữ Liệu Hóa Đơn nhóm khách hàng VIP với MoneyPerPoint là 5000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Điểm thưởng của hóa đơn là 20
    And Lịch sử điểm của khách hàng ${DEFAULT_CUSTOMER_ID} được ghi nhận với 20 điểm

RT-RP-014 Tạo hóa đơn với thanh toán bằng voucher
    [Documentation]    Kiểm tra tính điểm thưởng khi hóa đơn thanh toán bằng voucher và RewardPoint_ForInvoiceUsingVoucher = True
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền = 100,000đ
    ...    - Thanh toán bằng voucher = 20,000đ
    ...    - MoneyPerPoint = 10,000đ
    ...    - RewardPoint_ForInvoiceUsingVoucher = True (tích điểm cho cả phần thanh toán bằng voucher)
    ...    - Logic tính điểm:
    ...    - Điểm = Floor(100,000 / 10,000) = 10 điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với 10 điểm thưởng
    ...    - Lịch sử điểm được cập nhật
    Given Chuẩn Bị Dữ Liệu Hóa Đơn với thanh toán voucher 20000 và cấu hình tích điểm trên voucher là True
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Điểm thưởng của hóa đơn là 10
    And Lịch sử điểm của khách hàng ${DEFAULT_CUSTOMER_ID} được ghi nhận với 10 điểm 