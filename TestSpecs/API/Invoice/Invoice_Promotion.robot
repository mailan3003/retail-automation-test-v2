*** Settings ***
Documentation     Test cases kiểm thử API áp dụng khuyến mãi cho hóa đơn
...               Section: 5.1. Áp dụng khuyến mãi
Resource          ../../../Keywords/Invoice/PromotionKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Utilities/RequestHelper.robot
#Suite Setup       Connect To Database

*** Test Cases ***
# =====================================================================
# Khuyến mãi giá trị cố định
# =====================================================================


RT-PR-001: Tạo hóa đơn với khuyến mãi giảm giá trị cố định
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi giảm giá trị cố định
    ...                Giá trị khuyến mãi: 10.000 đồng
    ...                Kỳ vọng: Hóa đơn được tạo với chiết khấu chính xác 10.000 đồng
    ...                và ID khuyến mãi được lưu trong hóa đơn
    [Tags]    promotion    fixed    apiinvoice    smoke    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Giá Trị Cố Định 10000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 10000 Đồng
    And ID Khuyến Mãi Trong Hóa Đơn Là ${VALID_PROMOTION_ID}
    And Thông Tin Khuyến Mãi Có Loại 1

RT-PR-002: Tạo hóa đơn với khuyến mãi giảm giá trị phần trăm
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi giảm theo phần trăm
    ...                Phần trăm khuyến mãi: 5%
    ...                Tổng hóa đơn: 1000.000 đồng
    ...                Kỳ vọng: Hóa đơn được tạo với chiết khấu 5.000 đồng (5% của 100.000)
    [Tags]    promotion    percentage    apiinvoice    smoke    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Phần Trăm Với KM ID ${PROMOTION_ID_PERCENTAGE} 
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 50000 Đồng
    And Thông Tin Khuyến Mãi Có Loại 1

# RT-PR-003: Tạo hóa đơn với khuyến mãi phần trăm vượt quá giới hạn tối đa
#     [Documentation]    Kiểm tra tạo hóa đơn khi giá trị khuyến mãi phần trăm vượt quá giới hạn
#     ...                Phần trăm khuyến mãi: 30%
#     ...                Giới hạn tối đa: 20.000 đồng
#     ...                Tổng hóa đơn: 100.000 đồng
#     ...                Kỳ vọng: Hóa đơn được tạo với chiết khấu bị giới hạn ở mức 20.000 đồng
#     [Tags]    promotion    percentage    max_limit    api
    
#     # GIVEN
#     ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Phần Trăm    30    20000
    
#     # WHEN
#     Gửi Yêu Cầu Tạo Hóa Đơn
    
#     # THEN
#                     Status Should Be    200
#     Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 20000 Đồng
#  Thông Tin Khuyến Mãi Có Loại PERCENTAGE

# =====================================================================
# Khuyến mãi có điều kiện
# =====================================================================

RT-PR-004: Tạo hóa đơn với khuyến mãi hàng hóa và hóa đơn giảm giá hóa đơn phần trăm
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi hàng hóa và hóa đơn giảm giá hóa đơn phần trăm
    ...                Hóa đơn có sản phẩm ProductId là ${PRODUCT_ID_PROMOTION}
    ...                Điều kiện tối thiểu: 4000000 đồng
    ...                Tổng hóa đơn: 4000000 đồng
    ...                Giá trị khuyến mãi: 5%
    ...                Kỳ vọng: Hóa đơn được tạo và được áp dụng khuyến mãi
    [Tags]    promotion    condition    min_subtotal    apiinvoice    smoke    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi HH HĐ Giảm Giá Hóa Đơn Chiết Khẩu Với KM ID ${PROMOTION_ID_HD_HH_PERCENTAGE} có Sản Phẩm ${PRODUCT_ID_PROMOTION}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 200000 Đồng
    And Thông Tin Khuyến Mãi Có Loại 15

# RT-PR-005: Tạo hóa đơn với khuyến mãi có điều kiện tổng tối thiểu không đủ điều kiện
#     [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi yêu cầu tổng tiền tối thiểu
#     ...                nhưng tổng tiền không đủ điều kiện
#     ...                Điều kiện tối thiểu: 1000000 đồng
#     ...                Tổng hóa đơn: 500000 đồng
#     ...                Kỳ vọng: Hóa đơn được tạo nhưng không được áp dụng khuyến mãi
#     [Tags]    promotion    condition    min_subtotal    api
    
#     # GIVEN
#     Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi ${VALID_PROMOTION_ID} Có Tổng Hóa Đơn 500000
#     When Gửi Yêu Cầu Tạo Hóa Đơn
#     Then Mã Trạng Thái Phải Là 200
#     And Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 0 Đồng

RT-PR-006: Tạo hóa đơn với khuyến mãi áp dụng cho nhóm khách hàng cụ thể
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi chỉ áp dụng cho nhóm khách hàng cụ thể
    ...                Nhóm khách hàng: 1001 (VIP)
    ...                Giá trị khuyến mãi: 10.000 đồng
    ...                Kỳ vọng: Hóa đơn được tạo và khuyến mãi được áp dụng
    [Tags]    promotion    customer_group    apiinvoice    smoke    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi ${PROMOTION_ID_GROUP_CUSTOMER} Cho Khách Hàng ${CUSTOMER_GROUP_PROMOTION_ID} 
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 10000 Đồng


# RT-PR-007: Tạo hóa đơn với khuyến mãi áp dụng cho nhóm khách hàng không khớp
#     [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi chỉ áp dụng cho nhóm khách hàng 1001 (VIP)
#     ...                nhưng khách hàng thuộc nhóm 1002 (Thường)
#     ...                Kỳ vọng: Hóa đơn được tạo nhưng không áp dụng khuyến mãi
#     [Tags]    promotion    customer_group    negative    api
    
#     # GIVEN
#     # Cấu hình với nhóm khách hàng 1001 nhưng tạo hóa đơn với khách hàng 1002
#     ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Cho Nhóm Khách Hàng
#     Set To Dictionary    ${data.Invoice}    CustomerGroupId=1002
    
#     # WHEN
#     Gửi Yêu Cầu Tạo Hóa Đơn
    
#     # THEN
#     Status Should Be    200
#     Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 0 Đồng

# =====================================================================
# Khuyến mãi theo sản phẩm
# =====================================================================

RT-PR-008: Tạo hóa đơn với khuyến mãi hóa đơn áp dụng cho sản phẩm cụ thể
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi hóa đơn áp dụng cho sản phẩm cụ thể
    ...                Sản phẩm áp dụng: PIB10034
    ...                Giá trị khuyến mãi: 20.000 đồng
    ...                Kỳ vọng: Hóa đơn được tạo và khuyến mãi được áp dụng cho sản phẩm
    ...                Tổng giá trị đơn hàng sau khuyến mãi là ${total_invoice_value} đồng
    [Tags]    promotion    product    apiinvoice    smoke    regression

    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi ${PROMOTION_ID_DISCOUNT_PRODUCT} Cho Sản Phẩm GHDUQD005
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Tổng Giá Trị Đơn Hàng Sau Khuyến Mãi Là ${total_invoice_value} Đồng
    And Thông Tin Khuyến Mãi Có Loại 3

# =====================================================================
# Khuyến mãi mua X tặng Y
# =====================================================================

# RT-PR-009: Tạo hóa đơn với khuyến mãi mua X tặng Y đủ điều kiện    Đã có bên tặng
#     [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi mua X sản phẩm tặng Y sản phẩm
#     ...                Điều kiện: Mua tối thiểu 2 sản phẩm, tặng thêm 1 sản phẩm
#     ...                Kỳ vọng: Hóa đơn được tạo và được tặng thêm 1 sản phẩm
#     [Tags]    promotion    buy_x_get_y    api
    
#     # GIVEN
#     Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Mua 2 Tặng 1 Cho Sản Phẩm ${PRODUCT_1}
    
#     # WHEN
#     Gửi Yêu Cầu Tạo Hóa Đơn
    
#     # THEN
#     Status Should Be    200
#     # Xác minh trong DB là sản phẩm có số lượng tăng thêm 1

# # =====================================================================
# # Khuyến mãi tặng sản phẩm
# # =====================================================================

# RT-PR-010: Tạo hóa đơn với khuyến mãi tặng sản phẩm
#     [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi tặng sản phẩm
#     ...                Sản phẩm quà tặng: ${PRODUCT_2}
#     ...                Số lượng: 1
#     ...                Kỳ vọng: Hóa đơn được tạo và có sản phẩm quà tặng với giá 0đ
#     [Tags]    promotion    gift_product    api
    
#     # GIVEN
#     Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Sản Phẩm ${PRODUCT_2} Với Số Lượng 1
    
#     # WHEN
#     Gửi Yêu Cầu Tạo Hóa Đơn
    
#     # THEN
#     Status Should Be    200
#     Sản Phẩm Quà Tặng ${PRODUCT_2} Có Trong Hóa Đơn Với Số Lượng 1
#     Thông Tin Khuyến Mãi Có Loại GIFT_PRODUCT

# # =====================================================================
# # Khuyến mãi tặng voucher
# # =====================================================================

# RT-PR-011: Tạo hóa đơn với khuyến mãi tặng voucher
#     [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi tặng voucher
#     ...                Giá trị voucher: 50.000 đồng
#     ...                Kỳ vọng: Hóa đơn được tạo và có voucher kèm theo
#     [Tags]    promotion    gift_voucher    api
    
#     # GIVEN
#     Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Voucher Trị Giá 50000 Đồng
    
#     # WHEN
#     Gửi Yêu Cầu Tạo Hóa Đơn
    
#     # THEN
#     Status Should Be    200
#     Voucher Được Tạo Với Giá Trị 50000 Đồng
#     Thông Tin Khuyến Mãi Có Loại GIFT_VOUCHER

# =====================================================================
# Kết hợp nhiều khuyến mãi
# =====================================================================

RT-PR-012: Tạo hóa đơn với nhiều khuyến mãi cùng lúc
    [Documentation]    Kiểm tra tạo hóa đơn với nhiều khuyến mãi cùng lúc
    ...                Khuyến mãi 1: Giảm giá cố định 10.000 đồng
    ...                Khuyến mãi 2: Giảm giá phần trăm 5%
    ...                Tổng hóa đơn: 100.000 đồng
    ...                Kỳ vọng: Giảm giá = 10.000 + 5% x 100.000 = 15.000 đồng
    [Tags]    promotion    multiple    apiinvoice    smoke    regression

    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Khuyến Mãi ${PROMOTION_ID_FIXED} Và ${PROMOTION_ID_PERCENTAGE} 
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 60000 Đồng
    And Hóa Đơn Có 2 Khuyến Mãi Được Áp Dụng

# =====================================================================
# Khuyến mãi hàng hóa mua hàng giảm giá hàng
# =====================================================================

RT-PR-013: Tạo hóa đơn với khuyến mãi hàng hóa mua hàng giảm giá hàng Phần Trăm
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi mua hàng giảm giá hàng
    ...                Mua sản phẩm HH0035 được giảm giá 20% cho sản phẩm NK002
    ...                Kỳ vọng: Hóa đơn được tạo với sản phẩm NK002 được giảm giá 5%
    [Tags]    promotion    discount_product    apiinvoice    smoke    regression
    
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Khuyễn Mãi Hàng Hóa ${PROMOTION_ID_13} Mua Hàng HH0035 Giảm Giá Hàng NK002
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Sản Phẩm ${product_id_promotion} Có Chiết Khấu Khuyến Mãi 5%
    And Sản Phẩm ${product_id_promotion} Có Khuyến Mãi 4500 Đồng
    And Thông Tin Khuyến Mãi Có Loại 5

RT-PR-014: Tạo hóa đơn với khuyến mãi hàng hóa mua hàng giảm giá cố định cho hàng
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi mua hàng giảm giá cố định cho hàng
    ...                Mua sản phẩm HH0035 được giảm 50.000 đồng cho sản phẩm 	NK002 
    ...                Kỳ vọng: Hóa đơn được tạo với sản phẩm NK002 được giảm 30.000 đồng
    [Tags]    promotion    discount_product_fixed    apiinvoice    smoke    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Khuyễn Mãi Hàng Hóa ${PROMOTION_ID_14} Mua Hàng HH0035 Giảm Giá Hàng NK002
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Sản Phẩm ${product_id_promotion} Có Khuyến Mãi 30000 Đồng
    And Thông Tin Khuyến Mãi Có Loại 5

# =====================================================================
# Khuyến mãi giá bán theo sản phẩm
# =====================================================================

RT-PR-015: Tạo hóa đơn với khuyến mãi giá bán giảm giá VND theo số lượng mua 
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi giá bán theo sản phẩm
    ...                Sản phẩm ${PRODUCT_ID_PROMOTION} được áp dụng giá bán giảm giá VND
    ...                Kỳ vọng: Hóa đơn được tạo với sản phẩm có giá bán theo khuyến mãi
    [Tags]    promotion    product_price    apiinvoice    smoke    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi ${PROMOTION_ID_15} Giảm Giá Theo Số Lượng Mua PIB10010
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Sản Phẩm ${product_id_promotion} Có Khuyến Mãi 40000 Đồng
    And Thông Tin Khuyến Mãi Có Loại 8

RT-PR-016: Tạo hóa đơn với khuyến mãi giá bán theo sản phẩm giá bán theo %
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi giá bán theo sản phẩm
    ...                Sản phẩm ${PRODUCT_ID_PROMOTION} được áp dụng giá bán giảm giá %
    ...                Kỳ vọng: Hóa đơn được tạo với sản phẩm có giá bán theo khuyến mãi
    [Tags]    promotion    product_price    limited_quantity    apiinvoice    smoke    regression
    
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi ${PROMOTION_ID_16} Giảm Giá Theo Số Lượng Mua PIB10010
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Sản Phẩm ${product_id_promotion} Có Chiết Khấu Khuyến Mãi 20%
    And Sản Phẩm ${product_id_promotion} Có Khuyến Mãi 60000 Đồng
    Thông Tin Khuyến Mãi Có Loại 8

RT-PR-017: Tạo hóa đơn khuyến mãi hàng hóa giá bán theo số lượng mua
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi hàng hóa giá bán theo số lượng mua
    ...                Sản phẩm ${PRODUCT_ID_PROMOTION} giá gốc được áp dụng giá bán 80000
    ...                Kỳ vọng: Hóa đơn được tạo với sản phẩm có giá bán theo khuyến mãi
    ...                Tổng giá trị Khuyến mãi là ${total_discount} đồng
    [Tags]    promotion    product_price    multiple    apiinvoice    smoke    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi ${PROMOTION_ID_17} Giá Bán Theo Số Lượng Mua PIB10010
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Sản Phẩm ${product_id_promotion} Có Khuyến Mãi 20000 Đồng
    And Thông Tin Khuyến Mãi Có Loại 8



# =====================================================================
# Các trường hợp không áp dụng khuyến mãi
# =====================================================================

# RT-PR-018: Tạo hóa đơn với khuyến mãi đã hết hạn
#     [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi đã hết hạn
#     ...                Thời gian hết hạn khuyến mãi: 31/12/2022
#     ...                Thời gian hiện tại: > 31/12/2022
#     ...                Kỳ vọng: Hóa đơn được tạo nhưng không áp dụng khuyến mãi
#     [Tags]    promotion    expired    negative    api
    
#     Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Phần Trăm Với KM ID ${PROMOTION_ID_18}    
#     When Gửi Yêu Cầu Tạo Hóa Đơn
#     Then Mã Trạng Thái Phải Là 200
#     And Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là null Đồng

# RT-PR-019: Tạo hóa đơn với khuyến mãi không hoạt động
#     [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi không hoạt động
#     ...                Trạng thái khuyến mãi: Không hoạt động
#     ...                Kỳ vọng: Hóa đơn được tạo nhưng không áp dụng khuyến mãi
#     [Tags]    promotion    inactive    negative    api
    
#     Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Phần Trăm Với KM ID ${PROMOTION_ID_18}    
#     When Gửi Yêu Cầu Tạo Hóa Đơn
#     Then Mã Trạng Thái Phải Là 200
#     And Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là null Đồng

# RT-PR-015: Tạo hóa đơn với mã khuyến mãi không tồn tại
#     [Documentation]    Kiểm tra tạo hóa đơn với mã khuyến mãi không tồn tại
#     ...                Mã khuyến mãi: 9999 (không tồn tại)
#     ...                Kỳ vọng: Hóa đơn được tạo nhưng không áp dụng khuyến mãi
#     [Tags]    promotion    not_found    negative    api
    
#     # GIVEN
#     ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Giá Trị Cố Định
#     Set To Dictionary    ${data.Promotions}    Id=9999
    
#     # WHEN
#     Gửi Yêu Cầu Tạo Hóa Đơn
    
#     # THEN
#     Status Should Be    200
#     Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 0 Đồng

# RT-PR-016: Tạo hóa đơn với khuyến mãi đang được tạm khóa
#     [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi đang bị tạm khóa
#     ...                Trạng thái khuyến mãi: Tạm khóa
#     ...                Kỳ vọng: Hóa đơn được tạo nhưng không áp dụng khuyến mãi
#     [Tags]    promotion    suspended    negative    api
    
#     # GIVEN
#     ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Giá Trị Cố Định
#     Set To Dictionary    ${data.Promotions}    Status=2    # Giả sử 2 là trạng thái tạm khóa
    
#     # WHEN
#     Gửi Yêu Cầu Tạo Hóa Đơn
    
#     # THEN
#     Status Should Be    200
#     Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 0 Đồng

# RT-PR-017: Tạo hóa đơn với khuyến mãi chưa đến thời gian bắt đầu
#     [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi chưa đến thời gian bắt đầu
#     ...                Thời gian bắt đầu: Tương lai (so với thời điểm hiện tại)
#     ...                Kỳ vọng: Hóa đơn được tạo nhưng không áp dụng khuyến mãi
#     [Tags]    promotion    future    negative    api
    
#     # GIVEN
#     ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Giá Trị Cố Định
#     ${future_date}=    Evaluate    (datetime.datetime.now() + datetime.timedelta(days=30)).strftime('%Y-%m-%d')    modules=datetime
#     Set To Dictionary    ${data.Promotions}    StartDate=${future_date}
    
#     # WHEN
#     Gửi Yêu Cầu Tạo Hóa Đơn
    
#     # THEN
#     Status Should Be    200
#     Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 0 Đồng

# # =====================================================================
# # Các trường hợp ưu tiên khuyến mãi
# # =====================================================================

# RT-PR-018: Tạo hóa đơn với nhiều khuyến mãi và ưu tiên theo giá trị lớn nhất
#     [Documentation]    Kiểm tra tạo hóa đơn với nhiều khuyến mãi nhưng hệ thống chỉ áp dụng
#     ...                khuyến mãi có giá trị lớn nhất khi chế độ cấu hình là HIGHEST_VALUE
#     ...                Khuyến mãi 1: Giảm giá cố định 10.000 đồng
#     ...                Khuyến mãi 2: Giảm giá cố định 20.000 đồng
#     ...                Chế độ ưu tiên: HIGHEST_VALUE
#     ...                Kỳ vọng: Hệ thống chọn khuyến mãi 2 (20.000 đồng)
#     [Tags]    promotion    priority    highest_value    api
    
#     # GIVEN
#     ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Khuyến Mãi
#     # Giả sử chế độ ưu tiên là HIGHEST_VALUE và đã cài đặt trong hệ thống
    
#     # WHEN
#     Gửi Yêu Cầu Tạo Hóa Đơn
    
#     # THEN
#     Status Should Be    200
#     Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 20000 Đồng
#     Hóa Đơn Có 1 Khuyến Mãi Được Áp Dụng 

# =====================================================================
# Đánh giá khuyến mãi, voucher và điểm thưởng
# =====================================================================

# RT-PR-018: Tạo hóa đơn với khuyến mãi tặng điểm thưởng theo hóa đơn
#     [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi tặng điểm thưởng theo hóa đơn
#     ...                Khuyến mãi: Tặng 10 điểm thưởng (Type 12 - InvoicePointGift)
#     ...                Tổng tiền hóa đơn: 100,000đ (tích lũy cơ bản 10 điểm với tỷ lệ 10,000đ = 1 điểm)
#     ...                Kỳ vọng: Hóa đơn được tạo với tổng 20 điểm (10 điểm cơ bản + 10 điểm khuyến mãi)
#     [Tags]    promotion    reward_point    api    AIGenerated    regression
    
#     Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Điểm Theo Hóa Đơn
#     When Gửi Yêu Cầu Tạo Hóa Đơn
#     Then Mã Trạng Thái Phải Là 200
#     And Xác Thực Điểm Thưởng Hóa Đơn 20
#     And Thông Tin Khuyến Mãi Có Loại 12

# RT-PR-019: Tạo hóa đơn với khuyến mãi tặng điểm thưởng theo sản phẩm
#     [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi tặng điểm thưởng theo sản phẩm
#     ...                Khuyến mãi: Tặng 20 điểm thưởng cho sản phẩm cụ thể (Type 13 - ProductPointGift)
#     ...                Tổng tiền hóa đơn: 100,000đ (tích lũy cơ bản 10 điểm với tỷ lệ 10,000đ = 1 điểm)
#     ...                Kỳ vọng: Hóa đơn được tạo với tổng 30 điểm (10 điểm cơ bản + 20 điểm khuyến mãi)
#     [Tags]    promotion    reward_point    api    AIGenerated    regression
    
#     Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Điểm Theo Sản Phẩm
#     When Gửi Yêu Cầu Tạo Hóa Đơn
#     Then Mã Trạng Thái Phải Là 200
#     And Xác Thực Điểm Thưởng Hóa Đơn 30
#     And Thông Tin Khuyến Mãi Có Loại 13

# RT-PR-020: Tạo hóa đơn với khuyến mãi tặng voucher
#     [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi tặng voucher
#     ...                Khuyến mãi: Tặng voucher trị giá 50,000đ (Type 9 - InvoiceVoucherGift)
#     ...                Kỳ vọng: Hóa đơn được tạo thành công và có voucher kèm theo
#     ...                Voucher được tạo với giá trị 50,000đ
#     [Tags]    promotion    gift_voucher    api    AIGenerated    regression
    
#     Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Voucher Trị Giá 50000 Đồng
#     When Gửi Yêu Cầu Tạo Hóa Đơn
#     Then Mã Trạng Thái Phải Là 200
#     And Voucher Được Tạo Với Giá Trị 50000 Đồng
#     And Thông Tin Khuyến Mãi Có Loại 9

# RT-PR-021: Tạo hóa đơn với voucher không cho phép kết hợp với khuyến mãi
#     [Documentation]    Kiểm tra khi tạo hóa đơn sử dụng voucher không cho phép kết hợp với khuyến mãi
#     ...                Voucher: Không cho phép kết hợp với khuyến mãi (AllowMergeWithOtherPromotion = false)
#     ...                Khuyến mãi: Giảm giá 10,000đ
#     ...                Kỳ vọng: API trả về lỗi không thể kết hợp voucher với khuyến mãi khác
#     [Tags]    promotion    voucher    negative    vlxd    AIGenerated    regression
    
#     Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Voucher Không Kết Hợp
#     When Gửi Yêu Cầu Tạo Hóa Đơn
#     Then Mã Trạng Thái Phải Là 420
#     And Response Should Have Error "Hệ thống không cho phép áp dụng chương trình khuyến mại hoặc thanh toán bằng điểm khi đã dùng voucher"

RT-PR-022: Tạo hóa đơn với khuyến mãi đã bị xóa
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi đã bị xóa
    ...    - Dữ liệu đầu vào:
    ...    - Khuyến mãi ID=${DELETED_PROMOTION_ID} (đã bị xóa)
    ...    - Tổng tiền hóa đơn: 100,000đ
    ...    - Logic kỳ vọng: Hệ thống từ chối áp dụng khuyến mãi
    ...    - Kỳ vọng: 
    ...    - Status code: 200 
    ...    - Hóa đơn vẫn được tạo nhưng không áp dụng khuyến mãi
    ...    - Giá trị chiết khấu = 0
    [Tags]    promotion    deleted_promotion    negative    apiinvoice    AIGenerated    regression
    
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Đã Bị Xóa
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải bao gồm lỗi "Chương trình khuyến mại"
    And Phản hồi phải bao gồm lỗi "ngừng hoạt động, vui lòng áp dụng khuyến mại khác"

RT-PR-023: Tạo hóa đơn với nhiều khuyến mãi, một số đã bị xóa
    [Documentation]    Kiểm tra tạo hóa đơn với nhiều khuyến mãi, trong đó có khuyến mãi đã bị xóa
    ...    - Dữ liệu đầu vào:
    ...    - Khuyến mãi 1: ID=${VALID_PROMOTION_ID} (hợp lệ)
    ...    - Khuyến mãi 2: ID=${DELETED_PROMOTION_ID} (đã bị xóa)
    ...    - Tổng tiền hóa đơn: 100,000đ
    ...    - Logic kỳ vọng: Hệ thống áp dụng khuyến mãi hợp lệ và bỏ qua khuyến mãi đã xóa
    ...    - Kỳ vọng: 
    ...    - Status code: 200 
    ...    - Hóa đơn được tạo với giá trị chiết khấu từ khuyến mãi hợp lệ = 10,000đ
    ...    - Khuyến mãi đã xóa không được áp dụng
    [Tags]    promotion    multiple    deleted_promotion    negative    apiinvoice    AIGenerated    regression
    
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Hợp Lệ Và Khuyến Mãi Đã Bị Xóa
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải bao gồm lỗi "Chương trình khuyến mại"
    And Phản hồi phải bao gồm lỗi "ngừng hoạt động, vui lòng áp dụng khuyến mại khác"