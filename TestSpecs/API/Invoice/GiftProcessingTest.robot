*** Settings ***
Documentation     Test cases API cho phần xử lý quà tặng
Resource          ../../../Keywords/Invoice/GiftProcessingKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    GiftProcessingTest

*** Test Cases ***
RT-GP-001 Tạo hóa đơn thành công với quà tặng sản phẩm
    [Documentation]    Kiểm tra tạo hóa đơn thành công với quà tặng sản phẩm theo hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_GIFT001"
    ...    - Tổng tiền: 100,000đ
    ...    - Khuyến mãi: InvoiceProductGift (loại 2)
    ...    - Sản phẩm quà tặng: ID=${PRODUCT_2}, số lượng=1
    ...    - Điều kiện: tổng hóa đơn >= 100,000đ
    ...    - Logic xử lý: InvoiceService.ProcessPromotionGift() tạo InvoiceDetail mới cho quà tặng
    ...    - Quà tặng được thêm vào hóa đơn với:
    ...      + Giá = 0đ
    ...      + Ghi chú: "Quà tặng từ khuyến mãi"
    ...      + Liên kết với SalePromotionId
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Sản phẩm quà tặng được thêm vào hóa đơn với giá 0đ
    ...    - Thông tin khuyến mãi được lưu trong bảng InvoicePromotion
    ...    - Sản phẩm quà tặng được trừ khỏi tồn kho
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Quà Tặng Sản Phẩm
    When Gửi Yêu Cầu Tạo Hóa Đơn Với Quà Tặng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Quà Tặng Sản Phẩm    ${INVOICE_ID}    ${PRODUCT_2}    1
    And Xác Thực Ghi Chú Quà Tặng    ${INVOICE_ID}    ${PRODUCT_2}

RT-GP-002 Tạo hóa đơn thành công với quà tặng sản phẩm theo sản phẩm
    [Documentation]    Kiểm tra tạo hóa đơn thành công với quà tặng theo sản phẩm cụ thể
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_GIFT001"
    ...    - Chi tiết sản phẩm:
    ...      + ProductId=${PRODUCT_1}, Quantity=1, Price=100,000đ
    ...    - Khuyến mãi: ProductGift (loại 6)
    ...    - Sản phẩm quà tặng: ID=${PRODUCT_2}, số lượng=1
    ...    - Điều kiện: mua sản phẩm PRODUCT_1 với số lượng >= 1
    ...    - Logic xử lý: InvoiceService.ProcessPromotionGift() tạo InvoiceDetail mới cho quà tặng theo sản phẩm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Sản phẩm quà tặng được thêm vào hóa đơn với giá 0đ
    ...    - Thông tin khuyến mãi được lưu trong bảng InvoicePromotion với loại 6
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Quà Tặng Sản Phẩm Theo Sản Phẩm
    When Gửi Yêu Cầu Tạo Hóa Đơn Với Quà Tặng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Quà Tặng Sản Phẩm Theo Sản Phẩm    ${INVOICE_ID}    ${PRODUCT_2}    1

RT-GP-003 Tạo hóa đơn thành công với quà tặng voucher
    [Documentation]    Kiểm tra tạo hóa đơn thành công với quà tặng voucher theo hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_GIFT001"
    ...    - Tổng tiền: 100,000đ
    ...    - Khuyến mãi: InvoiceVoucherGift (loại 9)
    ...    - Voucher: giá trị=50,000đ, số lượng=1, hạn sử dụng=30 ngày
    ...    - Logic xử lý: 
    ...      + InvoiceService.ProcessPromotionGift() 
    ...      + VoucherService.CreateVoucher() tạo voucher mới
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Voucher mới được tạo với giá trị 50,000đ
    ...    - Thông tin voucher được liên kết với hóa đơn trong bảng InvoiceVoucher
    ...    - Trạng thái voucher là Kích hoạt (1)
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Quà Tặng Voucher
    When Gửi Yêu Cầu Tạo Hóa Đơn Với Quà Tặng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Quà Tặng Voucher    ${INVOICE_ID}    50000    1

RT-GP-004 Tạo hóa đơn thành công với quà tặng voucher theo sản phẩm
    [Documentation]    Kiểm tra tạo hóa đơn thành công với quà tặng voucher theo sản phẩm cụ thể
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_GIFT001"
    ...    - Chi tiết sản phẩm:
    ...      + ProductId=${PRODUCT_1}, Quantity=1, Price=100,000đ
    ...    - Khuyến mãi: ProductVoucherGift (loại 10)
    ...    - Voucher: giá trị=50,000đ, số lượng=1, hạn sử dụng=30 ngày
    ...    - Logic xử lý: 
    ...      + InvoiceService.ProcessPromotionGift() 
    ...      + VoucherService.CreateVoucher() tạo voucher mới
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Voucher mới được tạo với giá trị 50,000đ
    ...    - Thông tin voucher được liên kết với hóa đơn trong bảng InvoiceVoucher
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Quà Tặng Voucher Theo Sản Phẩm
    When Gửi Yêu Cầu Tạo Hóa Đơn Với Quà Tặng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Quà Tặng Voucher Theo Sản Phẩm    ${INVOICE_ID}    50000    1

RT-GP-005 Tạo hóa đơn thành công với quà tặng điểm
    [Documentation]    Kiểm tra tạo hóa đơn thành công với quà tặng điểm theo hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_GIFT001"
    ...    - Tổng tiền: 100,000đ
    ...    - Khuyến mãi: InvoicePointGift (loại 4)
    ...    - Điểm tặng: 20
    ...    - Logic xử lý: 
    ...      + InvoiceService.CalculatePromotionPoint() 
    ...      + InvoiceService.ProcessPromotionGift()
    ...    - Điểm cơ bản từ hóa đơn: 10 điểm
    ...    - Điểm từ khuyến mãi: 20 điểm
    ...    - Tổng điểm: 30 điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Điểm thưởng khuyến mãi được lưu trong bảng InvoicePromotion với giá trị 20
    ...    - Tổng điểm hóa đơn là 30 điểm
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Quà Tặng Điểm
    When Gửi Yêu Cầu Tạo Hóa Đơn Với Quà Tặng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Quà Tặng Điểm    ${INVOICE_ID}    20

RT-GP-006 Tạo hóa đơn thành công với quà tặng điểm theo sản phẩm
    [Documentation]    Kiểm tra tạo hóa đơn thành công với quà tặng điểm theo sản phẩm cụ thể
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_GIFT001"
    ...    - Chi tiết sản phẩm:
    ...      + ProductId=${PRODUCT_1}, Quantity=1, Price=100,000đ
    ...    - Khuyến mãi: ProductPointGift (loại 7)
    ...    - Điểm tặng: 15
    ...    - Logic xử lý: 
    ...      + InvoiceService.CalculatePromotionPoint() 
    ...      + InvoiceService.ProcessPromotionGift()
    ...    - Điểm từ khuyến mãi sản phẩm: 15 điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Điểm thưởng khuyến mãi được lưu trong bảng InvoicePromotion với giá trị 15
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Quà Tặng Điểm Theo Sản Phẩm
    When Gửi Yêu Cầu Tạo Hóa Đơn Với Quà Tặng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Quà Tặng Điểm Theo Sản Phẩm    ${INVOICE_ID}    15

RT-GP-007 Tạo hóa đơn thành công với nhiều quà tặng cùng lúc
    [Documentation]    Kiểm tra tạo hóa đơn thành công với nhiều loại quà tặng cùng lúc
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_GIFT001"
    ...    - Tổng tiền: 100,000đ
    ...    - Khuyến mãi 1: InvoiceProductGift (loại 2) - Tặng sản phẩm PRODUCT_2
    ...    - Khuyến mãi 2: InvoicePointGift (loại 4) - Tặng 20 điểm
    ...    - Logic xử lý: 
    ...      + InvoiceService.ProcessPromotionGift() xử lý cả 2 loại quà tặng
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Sản phẩm quà tặng được thêm vào hóa đơn
    ...    - Điểm thưởng khuyến mãi được thêm vào hóa đơn
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Quà Tặng
    When Gửi Yêu Cầu Tạo Hóa Đơn Với Quà Tặng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Nhiều Quà Tặng    ${INVOICE_ID}    ${PRODUCT_2}    20

RT-GP-008 Tạo hóa đơn thành công với quà tặng sản phẩm số lượng lớn
    [Documentation]    Kiểm tra tạo hóa đơn thành công với quà tặng sản phẩm số lượng lớn
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_GIFT002"
    ...    - Tổng tiền: 200,000đ
    ...    - Khuyến mãi: InvoiceProductGift (loại 2)
    ...    - Sản phẩm quà tặng: ID=${PRODUCT_2}, số lượng=3
    ...    - Logic xử lý: InvoiceService.ProcessPromotionGift()
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Sản phẩm quà tặng được thêm vào hóa đơn với số lượng=3
    ...    - Thông tin khuyến mãi được lưu trong bảng InvoicePromotion
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Quà Tặng Số Lượng Lớn    3
    When Gửi Yêu Cầu Tạo Hóa Đơn Với Quà Tặng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Số Lượng Quà Tặng    ${INVOICE_ID}    ${PRODUCT_2}    3

RT-GP-009 Tạo hóa đơn thành công với nhiều voucher quà tặng
    [Documentation]    Kiểm tra tạo hóa đơn thành công với nhiều voucher quà tặng
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_GIFT002"
    ...    - Tổng tiền: 200,000đ
    ...    - Khuyến mãi: InvoiceVoucherGift (loại 9)
    ...    - Voucher: giá trị=20,000đ, số lượng=3, hạn sử dụng=30 ngày
    ...    - Logic xử lý: 
    ...      + InvoiceService.ProcessPromotionGift() 
    ...      + VoucherService.CreateVoucher() tạo nhiều voucher mới
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - 3 voucher mới được tạo với giá trị 20,000đ mỗi voucher
    ...    - Thông tin voucher được liên kết với hóa đơn trong bảng InvoiceVoucher
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Voucher    3
    When Gửi Yêu Cầu Tạo Hóa Đơn Với Quà Tặng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Số Lượng Voucher    ${INVOICE_ID}    3 