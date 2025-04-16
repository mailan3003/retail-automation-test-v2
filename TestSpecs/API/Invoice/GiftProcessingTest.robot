*** Settings ***
Documentation     Test cases API cho phần xử lý quà tặng
Resource          ../../../Keywords/Invoice/GiftProcessingKeywords.robot
Resource          ../../../Keywords/Invoice/InventoryUpdateKeywords.robot
Resource          ../../../Keywords/Invoice/PromotionKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Utilities/RequestHelper.robot
Resource          ../../../Keywords/Utilities/DataUtilities.robot
Library           ../../../Resources/DatabaseLibrary.py
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    GiftProcessingTest

*** Test Cases ***
RT-GP-001 Tạo hóa đơn thành công với quà tặng sản phẩm
    [Documentation]    Kiểm tra tạo hóa đơn thành công với quà tặng sản phẩm theo hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền: 100,0000đ
    ...    - Khuyến mãi: InvoiceProductGift (loại 2)
    ...    - Sản phẩm quà tặng: ID=${PRODUCT_2}, số lượng=3    
    ...    - Điều kiện: tổng hóa đơn >= 100,0000đ
    ...    - Logic xử lý: InvoiceService.ProcessPromotionGift() tạo InvoiceDetail mới cho quà tặng
    ...    - Quà tặng được thêm vào hóa đơn với:
    ...      + Giá=0
    ...      + Liên kết với SalePromotionId
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Sản phẩm quà tặng được thêm vào hóa đơn với giá 0đ
    ...    - Thông tin khuyến mãi được lưu trong bảng InvoicePromotion
    ...    - Sản phẩm quà tặng được trừ khỏi tồn kho
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Khuyến mãi ${PROMOTION_GIFT_ID} Với Quà Tặng Sản Phẩm HTKM04 
    And Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm ${product_promotion_id}
    When Gửi Yêu Cầu Tạo Hóa Đơn 
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Quà Tặng Sản Phẩm    ${INVOICE_ID}    ${product_promotion_id}    ${quantity_promotion}  
    And Thông Tin Khuyến Mãi Có Loại 2
    And Tồn kho sản phẩm ${product_promotion_id} đã giảm ${quantity_promotion} đơn vị



RT-GP-002 Tạo hóa đơn thành công với quà tặng sản phẩm theo sản phẩm
    [Documentation]    Kiểm tra tạo hóa đơn thành công với quà tặng theo sản phẩm cụ thể
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_GIFT001"
    ...    - Chi tiết sản phẩm:
    ...      + ProductId=${PRODUCT_1}, Quantity=1, Price=100,000đ
    ...    - Khuyến mãi: ProductGift (loại 6)
    ...    - Sản phẩm quà tặng: ID=${PRODUCT_2}, số lượng=12
    ...    - Điều kiện: mua sản phẩm PRODUCT_1 với số lượng >= 1
    ...    - Logic xử lý: InvoiceService.ProcessPromotionGift() tạo InvoiceDetail mới cho quà tặng theo sản phẩm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Sản phẩm quà tặng được thêm vào hóa đơn với giá 0đ
    ...    - Thông tin khuyến mãi được lưu trong bảng InvoicePromotion với loại 6
    Given Chuẩn bị dữ liệu khuyến mãi ${PROMOTION_GIFT_ID_2} mua hàng HH0036 tặng sản phẩm NK001 
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Quà Tặng Sản Phẩm    ${INVOICE_ID}    ${product_promotion_id}    ${quantity_promotion}  
    And Thông Tin Khuyến Mãi Có Loại 6
    And ID Khuyến Mãi Trong Hóa Đơn Là ${PROMOTION_GIFT_ID_2}

RT-GP-003 Tạo hóa đơn thành công với quà tặng voucher
    [Documentation]    Kiểm tra tạo hóa đơn thành công với quà tặng voucher theo hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_GIFT001"
    ...    - Tổng tiền: 100,000đ
    ...    - Khuyến mãi: InvoiceVoucherGift (loại 9)
    ...    - Voucher: giá trị=100,000đ, số lượng=1
    ...    - Logic xử lý: 
    ...      + InvoiceService.ProcessPromotionGift() 
    ...      + VoucherService.CreateVoucher() tạo voucher mới
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Voucher mới được tạo với giá trị 100,000đ
    ...    - Thông tin voucher được liên kết với hóa đơn trong bảng InvoiceVoucher
    ...    - Trạng thái voucher là Kích hoạt (1)
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Khuyến Mãi ${PROMOTION_GIFT_ID_3} Với Quà Tặng Voucher
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Xác Thực Quà Tặng Voucher  ${INVOICE_ID}       
    And Thông Tin Khuyến Mãi Có Loại 9

RT-GP-004 Tạo hóa đơn thành công với quà tặng voucher theo sản phẩm
    [Documentation]    Kiểm tra tạo hóa đơn thành công với quà tặng voucher theo sản phẩm cụ thể
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_GIFT001"
    ...    - Chi tiết sản phẩm:
    ...      + ProductCode=HKM008, Quantity=1, Price=1000,000đ
    ...    - Khuyến mãi: ProductVoucherGift (loại 10)
    ...    - Logic xử lý: 
    ...      + InvoiceService.ProcessPromotionGift() 
    ...      + VoucherService.CreateVoucher() tạo voucher mới
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Voucher mới được tạo với giá trị 50,000đ
    ...    - Thông tin voucher được liên kết với hóa đơn trong bảng InvoiceVoucher
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Khuyến Mãi ${PROMOTION_GIFT_ID_4} Hàng Hóa HKM008 Quà Tặng Voucher
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Xác Thực Quà Tặng Voucher    ${INVOICE_ID}  
    And Thông Tin Khuyến Mãi Có Loại 10

RT-GP-005 Tạo hóa đơn thành công với quà tặng điểm
    [Documentation]    Kiểm tra tạo hóa đơn thành công với quà tặng điểm theo hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_GIFT001"
    ...    - Tổng tiền: 100,0000đ
    ...    - Khuyến mãi: InvoicePointGift (loại 4)
    ...    - Điểm tặng: 10
    ...    - Logic xử lý: 
    ...      + InvoiceService.CalculatePromotionPoint() 
    ...      + InvoiceService.ProcessPromotionGift()
    ...    - Điểm cơ bản từ hóa đơn: 10 điểm. phần này sẽ đc nếu theo thiết lập điểm theo hóa đơn nếu tích điểm theo hàng hóa thì hàng hóa tích điểm mới đc áp điểm
    ...    - Điểm từ khuyến mãi: 10 điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Điểm thưởng khuyến mãi được lưu trong bảng InvoicePromotion với giá trị 10
    ...    - Tổng điểm hóa đơn là 10 điểm
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Khuyến Mãi ${PROMOTION_GIFT_ID_5} Tặng Điểm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Xác Thực Quà Tặng Điểm    ${INVOICE_ID}    10
    And Thông Tin Khuyến Mãi Có Loại 4
    And Xác Thực Tracking Điểm Theo ${INVOICE_ID} Với Điểm 10

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
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Khuyến Mãi ${PROMOTION_GIFT_ID_6} Tặng Điểm Theo Sản Phẩm HKM009 
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Xác Thực Quà Tặng Điểm    ${INVOICE_ID}    10
    And Thông Tin Khuyến Mãi Có Loại 7
    And Xác Thực Tracking Điểm Theo ${INVOICE_ID} Với Điểm 10

RT-GP-007 Tạo hóa đơn thành công với nhiều quà tặng cùng lúc
    [Documentation]    Kiểm tra tạo hóa đơn thành công với nhiều loại quà tặng cùng lúc
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_GIFT001"
    ...    - Tổng tiền: 100,000đ
    ...    - Khuyến mãi 1: InvoiceProductGift (loại 2) - Tặng sản phẩm PRODUCT_2
    ...    - Khuyến mãi 2: InvoicePointGift (loại 4) - Tặng 10 điểm
    ...    - Logic xử lý: 
    ...      + InvoiceService.ProcessPromotionGift() xử lý cả 2 loại quà tặng
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Sản phẩm quà tặng được thêm vào hóa đơn
    ...    - Điểm thưởng khuyến mãi được thêm vào hóa đơn
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Khuyến Mãi ${PROMOTION_GIFT_ID} Tặng Sản Phẩm HKM007 Và Khuyến Mãi Tặng điểm ${PROMOTION_GIFT_ID_5}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Xác Thực Số Lượng Quà Tặng ${product_promotion_id} Với Số Lượng 3
    And Xác Thực Quà Tặng Điểm Theo ${sale_promotion_id_point} Với Điểm 10
    And Xác Thực Tracking Điểm Theo ${INVOICE_ID} Với Điểm 10


RT-GP-008 Tạo hóa đơn thành công với quà tặng nhiều sản phẩm khác nhau
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
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Khuyến mãi ${PROMOTION_GIFT_ID} Tặng 2 Sản Phẩm HTKM03 Và 1 Sản phẩm HTKM04 
    When Gửi Yêu Cầu Tạo Hóa Đơn 
    Then Mã Trạng Thái Phải Là 200
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Xác Thực Số Lượng Quà Tặng ${product_promotion_id} Với Số Lượng 2
    And Xác Thực Số Lượng Quà Tặng ${product_promotion_id_1} Với Số Lượng 1

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
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Khuyến Mãi ${PROMOTION_GIFT_ID_9} Với Nhiều Voucher
    When Gửi Yêu Cầu Tạo Hóa Đơn 
    Then Mã Trạng Thái Phải Là 200
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Xác Thực Số Lượng Voucher    ${INVOICE_ID}    3 
    And Thông Tin Khuyến Mãi Có Loại 9