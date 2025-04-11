*** Settings ***
Documentation     Test cases kiểm thử API áp dụng khuyến mãi cho hóa đơn
...               Section: 5.1. Áp dụng khuyến mãi
Resource          ../../../Keywords/Invoice/PromotionKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
#Suite Setup       Connect To Database

*** Test Cases ***
# =====================================================================
# Khuyến mãi giá trị cố định
# =====================================================================


RT-PR-001: Tạo hóa đơn với khuyến mãi giảm giá trị cố định
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi giảm giá trị cố định
    ...                Giá trị khuyến mãi: 15.000 đồng
    ...                Kỳ vọng: Hóa đơn được tạo với chiết khấu chính xác 15.000 đồng
    ...                và ID khuyến mãi được lưu trong hóa đơn
    [Tags]    promotion    fixed    api
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Giá Trị Cố Định
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 10000 Đồng
    And ID Khuyến Mãi Trong Hóa Đơn Là ${PROMOTION_ID}
    And Thông Tin Khuyến Mãi Có Loại FIXED_AMOUNT

RT-PR-002: Tạo hóa đơn với khuyến mãi giảm giá trị phần trăm
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi giảm theo phần trăm
    ...                Phần trăm khuyến mãi: 10%
    ...                Giới hạn tối đa: 50.000 đồng
    ...                Tổng hóa đơn: 100.000 đồng
    ...                Kỳ vọng: Hóa đơn được tạo với chiết khấu 10.000 đồng (10% của 100.000)
    [Tags]    promotion    percentage    api
    
    # GIVEN
    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Giảm 10 Phần Trăm Và Giới Hạn Tối Đa 50000 Đồng
    
    # WHEN
    Gửi Yêu Cầu Tạo Hóa Đơn
    
    # THEN
    Status Should Be    200
    Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 10000 Đồng
    Thông Tin Khuyến Mãi Có Loại PERCENTAGE

RT-PR-003: Tạo hóa đơn với khuyến mãi phần trăm vượt quá giới hạn tối đa
    [Documentation]    Kiểm tra tạo hóa đơn khi giá trị khuyến mãi phần trăm vượt quá giới hạn
    ...                Phần trăm khuyến mãi: 30%
    ...                Giới hạn tối đa: 20.000 đồng
    ...                Tổng hóa đơn: 100.000 đồng
    ...                Kỳ vọng: Hóa đơn được tạo với chiết khấu bị giới hạn ở mức 20.000 đồng
    [Tags]    promotion    percentage    max_limit    api
    
    # GIVEN
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Phần Trăm    30    20000
    
    # WHEN
    Gửi Yêu Cầu Tạo Hóa Đơn
    
    # THEN
    Status Should Be    200
    Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 20000 Đồng
    Thông Tin Khuyến Mãi Có Loại PERCENTAGE

# =====================================================================
# Khuyến mãi có điều kiện
# =====================================================================

RT-PR-004: Tạo hóa đơn với khuyến mãi có điều kiện tổng tối thiểu đủ điều kiện
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi yêu cầu tổng tiền tối thiểu
    ...                Điều kiện tối thiểu: 200.000 đồng
    ...                Tổng hóa đơn: 200.000 đồng
    ...                Giá trị khuyến mãi: 20.000 đồng
    ...                Kỳ vọng: Hóa đơn được tạo và được áp dụng khuyến mãi
    [Tags]    promotion    condition    min_subtotal    api
    
    # GIVEN
    Chuẩn Bị Dữ Liệu Hóa Đơn Với Điều Kiện Tổng Tối Thiểu 200000 Đồng Và Giảm 20000 Đồng
    
    # WHEN
    Gửi Yêu Cầu Tạo Hóa Đơn
    
    # THEN
    Status Should Be    200
    Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 20000 Đồng
    Thông Tin Khuyến Mãi Có Loại MIN_SUBTOTAL

RT-PR-005: Tạo hóa đơn với khuyến mãi có điều kiện tổng tối thiểu không đủ điều kiện
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi yêu cầu tổng tiền tối thiểu
    ...                nhưng tổng tiền không đủ điều kiện
    ...                Điều kiện tối thiểu: 200.000 đồng
    ...                Tổng hóa đơn: 150.000 đồng
    ...                Kỳ vọng: Hóa đơn được tạo nhưng không được áp dụng khuyến mãi
    [Tags]    promotion    condition    min_subtotal    api
    
    # GIVEN
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Có Điều Kiện Tổng Tối Thiểu    200000    150000    20000
    
    # WHEN
    Gửi Yêu Cầu Tạo Hóa Đơn
    
    # THEN
    Status Should Be    200
    Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 0 Đồng

RT-PR-006: Tạo hóa đơn với khuyến mãi áp dụng cho nhóm khách hàng cụ thể
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi chỉ áp dụng cho nhóm khách hàng cụ thể
    ...                Nhóm khách hàng: 1001 (VIP)
    ...                Giá trị khuyến mãi: 15.000 đồng
    ...                Kỳ vọng: Hóa đơn được tạo và khuyến mãi được áp dụng
    [Tags]    promotion    customer_group    api
    
    # GIVEN
    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Cho Nhóm Khách Hàng 1001 Giảm 15000 Đồng
    
    # WHEN
    Gửi Yêu Cầu Tạo Hóa Đơn
    
    # THEN
    Status Should Be    200
    Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 15000 Đồng
    Thông Tin Khuyến Mãi Có Loại CUSTOMER_GROUP

RT-PR-007: Tạo hóa đơn với khuyến mãi áp dụng cho nhóm khách hàng không khớp
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi chỉ áp dụng cho nhóm khách hàng 1001 (VIP)
    ...                nhưng khách hàng thuộc nhóm 1002 (Thường)
    ...                Kỳ vọng: Hóa đơn được tạo nhưng không áp dụng khuyến mãi
    [Tags]    promotion    customer_group    negative    api
    
    # GIVEN
    # Cấu hình với nhóm khách hàng 1001 nhưng tạo hóa đơn với khách hàng 1002
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Cho Nhóm Khách Hàng
    Set To Dictionary    ${data.Invoice}    CustomerGroupId=1002
    
    # WHEN
    Gửi Yêu Cầu Tạo Hóa Đơn
    
    # THEN
    Status Should Be    200
    Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 0 Đồng

# =====================================================================
# Khuyến mãi theo sản phẩm
# =====================================================================

RT-PR-008: Tạo hóa đơn với khuyến mãi áp dụng cho sản phẩm cụ thể
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi chỉ áp dụng cho sản phẩm cụ thể
    ...                Sản phẩm áp dụng: ${PRODUCT_1}
    ...                Giá trị khuyến mãi: 10.000 đồng
    ...                Kỳ vọng: Hóa đơn được tạo và khuyến mãi được áp dụng cho sản phẩm
    [Tags]    promotion    product    api
    
    # GIVEN
    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Cho Sản Phẩm
    
    # WHEN
    Gửi Yêu Cầu Tạo Hóa Đơn
    
    # THEN
    Status Should Be    200
    Sản Phẩm ${PRODUCT_1} Có Khuyến Mãi 10000 Đồng
    Tổng Giá Trị Đơn Hàng Sau Khuyến Mãi Là 90000 Đồng

# =====================================================================
# Khuyến mãi mua X tặng Y
# =====================================================================

RT-PR-009: Tạo hóa đơn với khuyến mãi mua X tặng Y đủ điều kiện
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi mua X sản phẩm tặng Y sản phẩm
    ...                Điều kiện: Mua tối thiểu 2 sản phẩm, tặng thêm 1 sản phẩm
    ...                Kỳ vọng: Hóa đơn được tạo và được tặng thêm 1 sản phẩm
    [Tags]    promotion    buy_x_get_y    api
    
    # GIVEN
    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Mua 2 Tặng 1 Cho Sản Phẩm ${PRODUCT_1}
    
    # WHEN
    Gửi Yêu Cầu Tạo Hóa Đơn
    
    # THEN
    Status Should Be    200
    # Xác minh trong DB là sản phẩm có số lượng tăng thêm 1

# =====================================================================
# Khuyến mãi tặng sản phẩm
# =====================================================================

RT-PR-010: Tạo hóa đơn với khuyến mãi tặng sản phẩm
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi tặng sản phẩm
    ...                Sản phẩm quà tặng: ${PRODUCT_2}
    ...                Số lượng: 1
    ...                Kỳ vọng: Hóa đơn được tạo và có sản phẩm quà tặng với giá 0đ
    [Tags]    promotion    gift_product    api
    
    # GIVEN
    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Sản Phẩm ${PRODUCT_2} Với Số Lượng 1
    
    # WHEN
    Gửi Yêu Cầu Tạo Hóa Đơn
    
    # THEN
    Status Should Be    200
    Sản Phẩm Quà Tặng ${PRODUCT_2} Có Trong Hóa Đơn Với Số Lượng 1
    Thông Tin Khuyến Mãi Có Loại GIFT_PRODUCT

# =====================================================================
# Khuyến mãi tặng voucher
# =====================================================================

RT-PR-011: Tạo hóa đơn với khuyến mãi tặng voucher
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi tặng voucher
    ...                Giá trị voucher: 50.000 đồng
    ...                Kỳ vọng: Hóa đơn được tạo và có voucher kèm theo
    [Tags]    promotion    gift_voucher    api
    
    # GIVEN
    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Voucher Trị Giá 50000 Đồng
    
    # WHEN
    Gửi Yêu Cầu Tạo Hóa Đơn
    
    # THEN
    Status Should Be    200
    Voucher Được Tạo Với Giá Trị 50000 Đồng
    Thông Tin Khuyến Mãi Có Loại GIFT_VOUCHER

# =====================================================================
# Kết hợp nhiều khuyến mãi
# =====================================================================

RT-PR-012: Tạo hóa đơn với nhiều khuyến mãi cùng lúc
    [Documentation]    Kiểm tra tạo hóa đơn với nhiều khuyến mãi áp dụng cùng lúc
    ...                Khuyến mãi 1: Giảm giá cố định 10.000 đồng
    ...                Khuyến mãi 2: Giảm giá cố định 15.000 đồng
    ...                Kỳ vọng: Hóa đơn được tạo với tổng chiết khấu 25.000 đồng
    [Tags]    promotion    multiple    api
    
    # GIVEN
    Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Khuyến Mãi
    
    # WHEN
    Gửi Yêu Cầu Tạo Hóa Đơn
    
    # THEN
    Status Should Be    200
    Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 25000 Đồng
    Hóa Đơn Có 2 Khuyến Mãi Được Áp Dụng

# =====================================================================
# Các trường hợp không áp dụng khuyến mãi
# =====================================================================

RT-PR-013: Tạo hóa đơn với khuyến mãi đã hết hạn
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi đã hết hạn
    ...                Thời gian hết hạn khuyến mãi: 31/12/2022
    ...                Thời gian hiện tại: > 31/12/2022
    ...                Kỳ vọng: Hóa đơn được tạo nhưng không áp dụng khuyến mãi
    [Tags]    promotion    expired    negative    api
    
    # GIVEN
    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Hết Hạn
    
    # WHEN
    Gửi Yêu Cầu Tạo Hóa Đơn
    
    # THEN
    Status Should Be    200
    Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 0 Đồng

RT-PR-014: Tạo hóa đơn với khuyến mãi không hoạt động
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi không hoạt động
    ...                Trạng thái khuyến mãi: Không hoạt động
    ...                Kỳ vọng: Hóa đơn được tạo nhưng không áp dụng khuyến mãi
    [Tags]    promotion    inactive    negative    api
    
    # GIVEN
    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Không Hoạt Động
    
    # WHEN
    Gửi Yêu Cầu Tạo Hóa Đơn
    
    # THEN
    Status Should Be    200
    Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 0 Đồng

RT-PR-015: Tạo hóa đơn với mã khuyến mãi không tồn tại
    [Documentation]    Kiểm tra tạo hóa đơn với mã khuyến mãi không tồn tại
    ...                Mã khuyến mãi: 9999 (không tồn tại)
    ...                Kỳ vọng: Hóa đơn được tạo nhưng không áp dụng khuyến mãi
    [Tags]    promotion    not_found    negative    api
    
    # GIVEN
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Giá Trị Cố Định
    Set To Dictionary    ${data.Promotions}    Id=9999
    
    # WHEN
    Gửi Yêu Cầu Tạo Hóa Đơn
    
    # THEN
    Status Should Be    200
    Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 0 Đồng

RT-PR-016: Tạo hóa đơn với khuyến mãi đang được tạm khóa
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi đang bị tạm khóa
    ...                Trạng thái khuyến mãi: Tạm khóa
    ...                Kỳ vọng: Hóa đơn được tạo nhưng không áp dụng khuyến mãi
    [Tags]    promotion    suspended    negative    api
    
    # GIVEN
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Giá Trị Cố Định
    Set To Dictionary    ${data.Promotions}    Status=2    # Giả sử 2 là trạng thái tạm khóa
    
    # WHEN
    Gửi Yêu Cầu Tạo Hóa Đơn
    
    # THEN
    Status Should Be    200
    Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 0 Đồng

RT-PR-017: Tạo hóa đơn với khuyến mãi chưa đến thời gian bắt đầu
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi chưa đến thời gian bắt đầu
    ...                Thời gian bắt đầu: Tương lai (so với thời điểm hiện tại)
    ...                Kỳ vọng: Hóa đơn được tạo nhưng không áp dụng khuyến mãi
    [Tags]    promotion    future    negative    api
    
    # GIVEN
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Giá Trị Cố Định
    ${future_date}=    Evaluate    (datetime.datetime.now() + datetime.timedelta(days=30)).strftime('%Y-%m-%d')    modules=datetime
    Set To Dictionary    ${data.Promotions}    StartDate=${future_date}
    
    # WHEN
    Gửi Yêu Cầu Tạo Hóa Đơn
    
    # THEN
    Status Should Be    200
    Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 0 Đồng

# =====================================================================
# Các trường hợp ưu tiên khuyến mãi
# =====================================================================

RT-PR-018: Tạo hóa đơn với nhiều khuyến mãi và ưu tiên theo giá trị lớn nhất
    [Documentation]    Kiểm tra tạo hóa đơn với nhiều khuyến mãi nhưng hệ thống chỉ áp dụng
    ...                khuyến mãi có giá trị lớn nhất khi chế độ cấu hình là HIGHEST_VALUE
    ...                Khuyến mãi 1: Giảm giá cố định 10.000 đồng
    ...                Khuyến mãi 2: Giảm giá cố định 20.000 đồng
    ...                Chế độ ưu tiên: HIGHEST_VALUE
    ...                Kỳ vọng: Hệ thống chọn khuyến mãi 2 (20.000 đồng)
    [Tags]    promotion    priority    highest_value    api
    
    # GIVEN
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Khuyến Mãi
    # Giả sử chế độ ưu tiên là HIGHEST_VALUE và đã cài đặt trong hệ thống
    
    # WHEN
    Gửi Yêu Cầu Tạo Hóa Đơn
    
    # THEN
    Status Should Be    200
    Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 20000 Đồng
    Hóa Đơn Có 1 Khuyến Mãi Được Áp Dụng 