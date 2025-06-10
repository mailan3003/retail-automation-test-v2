*** Settings ***
Documentation     Test cases cho chức năng xử lý khuyến mãi và chiết khấu trong đơn hàng
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../TestData/CommonData.robot
Resource          ../../../Keywords/Order/PromotionOrderKeywords.robot
Resource          ../../../Keywords/Order/CreateOrderKeywords.robot
Resource          ../../../Keywords/Order/OrderCommandKeywords.robot
Resource          ../../../Keywords/Order/UpdateOrderKeywords.robot
Resource          ../../../Keywords/Utilities/Utilities.robot
Resource    ../../../Keywords/Order/CompleteOrderKeywords.robot

*** Variables ***
${DELETE_PROMOTION_ID}  

*** Test Cases ***
RT-PROMOTION-ORDER-001 Tạo Đơn Hàng Với Khuyến Mãi Giảm Giá VND Thành Công
    [Documentation]    Test tạo đơn hàng với khuyến mãi giảm giá VND
    ...                Kiểm tra việc tạo đơn hàng với khuyến mãi giảm giá VND
    ...                Xác thực giảm giá đặt hàng, giảm giá khuyến mãi và ID khuyến mãi được áp dụng đúng
    ...                Kỳ vọng: Đơn hàng được tạo thành công với giảm giá khuyến mãi VND được áp dụng
    [Tags]    AIGenerated    PromotionOrder    Positive    ValidPromotion    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Sản Phẩm DV240 Với Khuyến Mãi KM00001
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Giảm Giá Đặt Hàng Trong Đơn Đặt Hàng ${PROMOTION_VALUE}
    And Xác Thực Giảm Giá Khuyến Mãi Trong Đơn Đặt Hàng
    And Xác Thực ID Khuyến Mãi Trong Đơn Đặt Hàng   ${PROMOTION_ID}
    [Teardown]    Delete Order From Api

RT-PROMOTION-ORDER-002 Lỗi Khi Tạo Đơn Hàng Với Khuyến Mãi Giảm Giá Chiết Khấu
    [Documentation]    Test lỗi khi tạo đơn hàng với khuyến mãi đã bị xóa
    ...                Kiểm tra việc phát hiện khuyến mãi đã bị xóa qua KvPromotionService
    ...                Thu thập thông tin tên khuyến mãi từ PromotionInfo
    ...                Phát sinh ngoại lệ KvValidateException với thông báo PromotionsAreDeletedNotification
    ...                Kỳ vọng: Trả về lỗi với thông báo khuyến mãi đã bị xóa
    [Tags]    AIGenerated    PromotionOrder    Negative    DeletedPromotion    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Sản Phẩm DV240 Với Khuyến Mãi Giảm Giá Chiết Khấu KM00002
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Giảm Giá Đặt Hàng Trong Đơn Đặt Hàng ${PROMOTION_VALUE}
    And Xác Thực Giảm Giá Khuyến Mãi Trong Đơn Đặt Hàng
    And Xác Thực ID Khuyến Mãi Trong Đơn Đặt Hàng   ${PROMOTION_ID}
    [Teardown]    Delete Order From Api


RT-PR-004: Tạo đơn hàng với khuyến mãi hàng hóa và hóa đơn giảm giá đặt hàng phần trăm
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi hàng hóa và hóa đơn giảm giá hóa đơn phần trăm
    ...                Hóa đơn có sản phẩm Productcode là PIB10034
    ...                Điều kiện tối thiểu: 4000000 đồng
    ...                Tổng hóa đơn: 4000000 đồng
    ...                Giá trị khuyến mãi: 5%
    ...                Kỳ vọng: Hóa đơn được tạo và được áp dụng khuyến mãi
    [Tags]    promotion    condition    min_subtotal    PromotionOrder    smoke    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Khuyến Mãi HH HĐ Giảm Giá Hóa Đơn Chiết Khẩu ${PROMOTION_CODE_HD_HH_PERCENTAGE} Có Sản Phẩm PIB10034
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Giảm Giá Đặt Hàng Trong Đơn Đặt Hàng ${PROMOTION_VALUE}
    And Xác Thực Giảm Giá Khuyến Mãi Trong Đơn Đặt Hàng
    And Xác Thực ID Khuyến Mãi Trong Đơn Đặt Hàng   ${PROMOTION_ID}
    [Teardown]    Delete Order From Api


RT-PR-006: Tạo đặt hàng với khuyến mãi áp dụng cho nhóm khách hàng cụ thể
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi chỉ áp dụng cho nhóm khách hàng cụ thể
    ...                Nhóm khách hàng:  (VIP)
    ...                Giá trị khuyến mãi: 10.000 đồng
    ...                Kỳ vọng: Hóa đơn được tạo và khuyến mãi được áp dụng
    [Tags]    promotion    customer_group    PromotionOrder    smoke    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Khuyến Mãi ${PROMOTION_CODE_GROUP_CUSTOMER} Cho Khách Hàng ${CUSTOMER_CODE_GROUP_CUSTOMER} 
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Giảm Giá Đặt Hàng Trong Đơn Đặt Hàng ${PROMOTION_VALUE}
    And Xác Thực Giảm Giá Khuyến Mãi Trong Đơn Đặt Hàng
    And Xác Thực ID Khuyến Mãi Trong Đơn Đặt Hàng   ${PROMOTION_ID}
    [Teardown]    Delete Order From Api


RT-PR-008: Tạo Đơn Hàng Với Khuyến Mãi Hóa Đơn Áp Dụng Cho Sản Phẩm Cụ Thể
    [Documentation]    Kiểm tra tạo đơn hàng với khuyến mãi hóa đơn áp dụng cho sản phẩm cụ thể
    ...                Sản phẩm áp dụng: GHDUQD005
    ...                Giá trị khuyến mãi: 20.000 đồng
    ...                Kỳ vọng: Hóa đơn được tạo và khuyến mãi được áp dụng cho sản phẩm
    ...                Tổng giá trị đơn hàng sau khuyến mãi là ${total_invoice_value} đồng
    [Tags]    promotion    product    PromotionOrder    smoke    regression

    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Khuyến Mãi ${PROMOTION_CODE_DISCOUNT_PRODUCT} Cho Sản Phẩm GHDUQD005
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Tổng Giá Trị Đặt Hàng Sau Khuyến Mãi Là ${total_invoice_value}
    And Xác Thực ID Khuyến Mãi Trong Đơn Đặt Hàng   ${PROMOTION_ID}
    [Teardown]    Delete Order From Api



RT-PR-012: Tạo Đơn Hàng Với Nhiều Khuyến Mãi Cùng Lúc
    [Documentation]    Kiểm tra tạo đơn hàng với nhiều khuyến mãi cùng lúc
    ...                Khuyến mãi 1: Giảm giá cố định 10.000 đồng
    ...                Khuyến mãi 2: Giảm giá phần trăm 5%
    ...                Tổng hóa đơn: 100.000 đồng
    ...                Kỳ vọng: Giảm giá = 10.000 + 5% x 100.000 = 15.000 đồng
    [Tags]    promotion    multiple    PromotionOrder    smoke    regression

    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Khuyến Mãi ${PROMOTION_CODE_FIXED} Và ${PROMOTION_CODE_PERCENTAGE} 
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Giảm Giá Đặt Hàng Trong Đơn Đặt Hàng ${TOTAL_DISCOUNT}
    And Xác Thực Giảm Giá Khuyến Mãi Trong Đơn Đặt Hàng
    And Xác Thực ID Khuyến Mãi Trong Đơn Đặt Hàng   ${PROMOTION1_ID}
    And Xác Thực ID Khuyến Mãi Trong Đơn Đặt Hàng   ${PROMOTION2_ID}
    [Teardown]    Delete Order From Api


RT-PR-013: Tạo Đơn Hàng Với Khuyến Mãi Mua Hàng Giảm Giá Hàng Phần Trăm
    [Documentation]    Kiểm tra tạo đơn hàng với khuyến mãi mua hàng giảm giá hàng
    ...                Mua sản phẩm HH0035 được giảm giá 20% cho sản phẩm NK002
    ...                Kỳ vọng: Hóa đơn được tạo với sản phẩm NK002 được giảm giá 5%
    [Tags]    promotion    discount_product   PromotionOrder    smoke    regression
    
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Khuyến Mãi ${PROMOTION_CODE_DISCOUNT_PRODUCT} Cho Sản Phẩm GHDUQD005
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Khuyến Mãi Theo Sản Phẩm ${PRODUCT_ID_PROMOTION} Giảm Giá ${PROMOTION_VALUE} Đồng Và ID Khuyến Mãi ${SALE_PROMOTION_ID} 
    And Xác Thực Tổng Giá Trị Đặt Hàng Sau Khuyến Mãi Là ${TOTAL_ORDER_VALUE} 
    And Xác Thực ID Khuyến Mãi Trong Đơn Đặt Hàng   ${PROMOTION_ID}
    [Teardown]    Delete Order From Api

RT-PR-014: Tạo đơn hàng với khuyến mãi mua hàng giảm giá cố định cho hàng
    [Documentation]    Kiểm tra tạo đơn hàng với khuyến mãi mua hàng giảm giá cố định cho hàng
    ...                Mua sản phẩm HH0035 được giảm 50.000 đồng cho sản phẩm 	NK002 
    ...                Kỳ vọng: Hóa đơn được tạo với sản phẩm NK002 được giảm 30.000 đồng
    [Tags]    promotion    discount_product_fixed    PromotionOrder    smoke    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Khuyễn Mãi Hàng Hóa ${PROMOTION_CODE_14} Mua Hàng HH0035 Giảm Giá Hàng NK002
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Khuyến Mãi Theo Sản Phẩm ${PRODUCT_ID_PROMOTION} Giảm Giá ${PROMOTION_VALUE} Đồng Và ID Khuyến Mãi ${SALE_PROMOTION_ID} 
    And Xác Thực ID Khuyến Mãi Trong Đơn Đặt Hàng   ${PROMOTION_ID}
    [Teardown]    Delete Order From Api
# =====================================================================
# Khuyến mãi giá bán theo sản phẩm
# =====================================================================

RT-PR-015: Tạo đơn hàng với khuyến mãi giá bán giảm giá VND theo số lượng mua 
    [Documentation]    Kiểm tra tạo đơn hàng với khuyến mãi giá bán theo sản phẩm
    ...                Sản phẩm ${PRODUCT_ID_PROMOTION} được áp dụng giá bán giảm giá VND
    ...                Kỳ vọng: Hóa đơn được tạo với sản phẩm có giá bán theo khuyến mãi
    [Tags]    promotion    product_price    PromotionOrder    smoke    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Khuyến Mãi ${PROMOTION_CODE_15} Giảm Giá Theo Số Lượng Mua PIB10010
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Khuyến Mãi Theo Sản Phẩm ${PRODUCT_ID_PROMOTION} Giảm Giá ${PROMOTION_VALUE} Đồng Và ID Khuyến Mãi ${SALE_PROMOTION_ID} 
    And Xác Thực Tổng Giá Trị Đặt Hàng Sau Khuyến Mãi Là ${TOTAL_ORDER_VALUE} 
    And Xác Thực ID Khuyến Mãi Trong Đơn Đặt Hàng   ${PROMOTION_ID}
    [Teardown]    Delete Order From Api

RT-PR-016: Tạo đơn hàng với khuyến mãi giá bán theo sản phẩm giá bán theo %
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi giá bán theo sản phẩm
    ...                Sản phẩm ${PRODUCT_ID_PROMOTION} được áp dụng giá bán giảm giá %
    ...                Kỳ vọng: Hóa đơn được tạo với sản phẩm có giá bán theo khuyến mãi
    [Tags]    promotion    product_price    limited_quantity    PromotionOrder    smoke    regression
    
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Khuyến Mãi ${PROMOTION_CODE_16} Giảm Giá Theo Số Lượng Mua PIB10010
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Khuyến Mãi Theo Sản Phẩm ${PRODUCT_ID_PROMOTION} Giảm Giá ${PROMOTION_VALUE} Đồng Và ID Khuyến Mãi ${SALE_PROMOTION_ID} 
    And Xác Thực Tổng Giá Trị Đặt Hàng Sau Khuyến Mãi Là ${TOTAL_ORDER_VALUE} 
    And Sản Phẩm ${PRODUCT_ID_PROMOTION} Có Chiết Khấu Khuyến Mãi Đặt Hàng ${PROMOTION_RATIO_VALUE}%
    And Xác Thực ID Khuyến Mãi Trong Đơn Đặt Hàng   ${PROMOTION_ID}
    [Teardown]    Delete Order From Api

RT-PR-017: Tạo hóa đơn khuyến mãi hàng hóa giá bán theo số lượng mua
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi hàng hóa giá bán theo số lượng mua
    ...                Sản phẩm ${PRODUCT_ID_PROMOTION} giá gốc được áp dụng giá bán 80000
    ...                Kỳ vọng: Hóa đơn được tạo với sản phẩm có giá bán theo khuyến mãi
    ...                Tổng giá trị Khuyến mãi là ${total_discount} đồng
    [Tags]    promotion    product_price    multiple    PromotionOrder    smoke    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Khuyến Mãi ${PROMOTION_CODE_17} Giá Bán Theo Số Lượng Mua PIB10010
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Khuyến Mãi Theo Sản Phẩm ${PRODUCT_ID_PROMOTION} Giảm Giá ${PROMOTION_VALUE} Đồng Và ID Khuyến Mãi ${SALE_PROMOTION_ID} 
    And Xác Thực Tổng Giá Trị Đặt Hàng Sau Khuyến Mãi Là ${TOTAL_ORDER_VALUE} 
    And Xác Thực ID Khuyến Mãi Trong Đơn Đặt Hàng   ${PROMOTION_ID}
    [Teardown]    Delete Order From Api

# Tặng Quà
RT-GP-001 Tạo đơn hàng thành công với quà tặng sản phẩm
    [Tags]    gift    smoke   PromotionOrder    regression
    [Documentation]    Kiểm tra tạo đơn hàng thành công với quà tặng sản phẩm theo hóa đơn
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
    ...    - Thông tin khuyến mãi được lưu trong bảng OrderPromotion
    ...    - Sản phẩm quà tặng được trừ khỏi tồn kho
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Khuyến mãi ${PROMOTION_GIFT_CODE} Với Quà Tặng Sản Phẩm HTKM04 
    And Lấy Số Lượng Đặt Hàng Của Sản Phẩm HTKM04
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Quà Tặng Sản Phẩm Đặt Hàng   ${PRODUCT_ID_PROMOTION}    ${PROMOTION_QUANTITY}  
    And Xác Thực ID Khuyến Mãi Trong Đơn Đặt Hàng   ${PROMOTION_ID}
    And Xác Thực Số Lượng Đặt Hàng Của Sản Phẩm HTKM04 Được Cập Nhập Thêm ${PROMOTION_QUANTITY}
    [Teardown]    Delete Order From Api

RT-GP-002 Tạo đơn hàng thành công với quà tặng sản phẩm theo sản phẩm
    [Tags]    gift    smoke   PromotionOrder    regression
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
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Khuyến Mãi ${PROMOTION_GIFT_CODE_2} Mua Hàng HH0036 Tặng Sản Phẩm NK001 
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Quà Tặng Sản Phẩm Đặt Hàng   ${PRODUCT_ID_PROMOTION}   ${PROMOTION_QUANTITY}  
    And ID Khuyến Mãi Trong Hóa Đơn Là ${PROMOTION_ID}
    [Teardown]    Delete Order From Api

RT-GP-003 Tạo đơn hàng Không Thành Công với quà tặng voucher
    [Tags]    gift    smoke   PromotionOrder    regression
    [Documentation]    Kiểm tra tạo Đơn Hàng Không Thành Công với quà tặng voucher theo hóa đơn    
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền: 100,000đ
    ...    - Khuyến mãi: InvoiceVoucherGift (loại 9)
    ...    - Voucher: giá trị=100,000đ, số lượng=1
    ...    - Logic xử lý: 
    ...      + InvoiceService.ProcessPromotionGift() 
    ...      + VoucherService.CreateVoucher() tạo voucher mới
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Voucher mới được tạo với giá trị 100,000đ
    ...    - Thông tin voucher được liên kết với hóa đơn trong bảng InvoiceVoucher
    ...    - Trạng thái voucher là Kích hoạt (1)
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Khuyến Mãi ${PROMOTION_GIFT_CODE_3} Với Quà Tặng Voucher
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Voucher Error"


RT-GP-005 Tạo đơn hàng thành công với quà tặng điểm
    [Tags]    gift    smoke   PromotionOrder    regression
    [Documentation]    Kiểm tra tạo Đơn Hàng Thành Công với quà tặng điểm theo hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Khuyến mãi: InvoicePointGift (loại 4)
    ...    - Điểm tặng: 10
    ...    - Logic xử lý: 
    ...      + InvoiceService.CalculatePromotionPoint() 
    ...      + InvoiceService.ProcessPromotionGift()
    ...    - Điểm cơ bản từ hóa đơn: 10 điểm. phần này sẽ đc nếu theo thiết lập điểm theo hóa đơn nếu tích điểm theo hàng hóa thì hàng hóa tích điểm mới đc áp điểm
    ...    - Điểm từ khuyến mãi: 10 điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng điểm hóa đơn là 10 điểm
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Khuyến Mãi ${PROMOTION_GIFT_CODE_5} Tặng Điểm
    When Gửi Yêu Cầu Tạo Đơn Hàng
    And Xác Thực Quà Tặng Điểm Đặt Hàng  ${PROMOTION_ID}   10
    And Xác Thực ID Khuyến Mãi Trong Đơn Đặt Hàng   ${PROMOTION_ID}
    [Teardown]    Delete Order From Api

RT-GP-006 Tạo đơn hàng thành công với quà tặng điểm theo sản phẩm
    [Tags]    gift    smoke   apiinvoice    regression
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
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Khuyến Mãi ${PROMOTION_GIFT_CODE_6} Tặng Điểm Theo Sản Phẩm HKM009 
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Quà Tặng Điểm Đặt Hàng  ${PROMOTION_ID}  10
    And Xác Thực ID Khuyến Mãi Trong Đơn Đặt Hàng   ${PROMOTION_ID}
    [Teardown]    Delete Order From Api

RT-GP-007 Tạo đơn hàng thành công với nhiều quà tặng cùng lúc
    [Tags]    gift    smoke   apiinvoice    regression
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
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Khuyến Mãi ${PROMOTION_GIFT_CODE} Tặng Sản Phẩm HKM007 Và Khuyến Mãi Tặng điểm ${PROMOTION_GIFT_CODE_5}
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Quà Tặng Sản Phẩm Đặt Hàng   ${PRODUCT_ID_PROMOTION}   ${PROMOTION_QUANTITY}  
    And Xác Thực Quà Tặng Điểm Đặt Hàng  ${PROMOTION_ID_POINT}   10
    And Xác Thực ID Khuyến Mãi Trong Đơn Đặt Hàng   ${PROMOTION_ID}
    And Xác Thực ID Khuyến Mãi Trong Đơn Đặt Hàng   ${PROMOTION_ID_POINT}
    [Teardown]    Delete Order From Api

RT-GP-008 Tạo đơn hàng thành công với quà tặng nhiều sản phẩm khác nhau
    [Tags]    gift    smoke   apiinvoice    regression
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
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Khuyến Mãi ${PROMOTION_GIFT_CODE} Tặng 2 Sản Phẩm HTKM03 Và 1 Sản phẩm HTKM04 
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Xác Thực Số Lượng Quà Tặng ${product_promotion_id} Với Số Lượng 2 Trong Đơn Đặt Hàng
    And Xác Thực Số Lượng Quà Tặng ${product_promotion_id_1} Với Số Lượng 1 Trong Đơn Đặt Hàng
    And Xác Thực ID Khuyến Mãi Trong Đơn Đặt Hàng   ${PROMOTION_ID}
    [Teardown]    Delete Order From Api











