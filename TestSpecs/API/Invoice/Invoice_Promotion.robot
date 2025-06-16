*** Settings ***
Documentation     Test cases kiểm thử API áp dụng khuyến mãi cho hóa đơn
...               Section: 5.1. Áp dụng khuyến mãi
Suite Setup       Init Test Environment   ${ENV}   MHBH
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Invoice/PromotionKeywords.robot
Resource          ../../../Keywords/Invoice/InvoiceCommonKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Utilities/RequestHelper.robot


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
    And ID Khuyến Mãi Trong Hóa Đơn Là ${PROMOTION_CODE_FIXED} 
    And Thông Tin Khuyến Mãi Có Loại 1
    [Teardown]   Delete Invoice From API

RT-PR-002: Tạo hóa đơn với khuyến mãi giảm giá trị phần trăm
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi giảm theo phần trăm
    ...                Phần trăm khuyến mãi: 5%
    ...                Tổng hóa đơn: 1000.000 đồng
    ...                Kỳ vọng: Hóa đơn được tạo với chiết khấu 5.000 đồng (5% của 100.000)
    [Tags]    promotion    percentage    apiinvoice    smoke    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Phần Trăm Với KM ${PROMOTION_CODE_PERCENTAGE} 
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 50000 Đồng
    And Thông Tin Khuyến Mãi Có Loại 1
    [Teardown]   Delete Invoice From API



RT-PR-004: Tạo hóa đơn với khuyến mãi hàng hóa và hóa đơn giảm giá hóa đơn phần trăm
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi hàng hóa và hóa đơn giảm giá hóa đơn phần trăm
    ...                Hóa đơn có sản phẩm ProductId là ${PRODUCT_ID_PROMOTION}
    ...                Điều kiện tối thiểu: 4000000 đồng
    ...                Tổng hóa đơn: 4000000 đồng
    ...                Giá trị khuyến mãi: 5%
    ...                Kỳ vọng: Hóa đơn được tạo và được áp dụng khuyến mãi
    [Tags]    promotion    condition    min_subtotal    apiinvoice    smoke    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi HH HĐ Giảm Giá Hóa Đơn Chiết Khẩu Với KM ${PROMOTION_CODE_HD_HH_PERCENTAGE} có Sản Phẩm ${PRODUCT_CODE_PROMOTION}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 200000 Đồng
    And Thông Tin Khuyến Mãi Có Loại 15
    [Teardown]   Delete Invoice From API

RT-PR-006: Tạo hóa đơn với khuyến mãi áp dụng cho nhóm khách hàng cụ thể
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi chỉ áp dụng cho nhóm khách hàng cụ thể
    ...                Nhóm khách hàng: 1001 (VIP)
    ...                Giá trị khuyến mãi: 10.000 đồng
    ...                Kỳ vọng: Hóa đơn được tạo và khuyến mãi được áp dụng
    [Tags]    promotion    customer_group    apiinvoice    smoke    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi ${PROMOTION_CODE_GROUP_CUSTOMER} Cho Khách Hàng ${CUSTOMER_CODE_GROUP_CUSTOMER}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 10000 Đồng
    [Teardown]   Delete Invoice From API



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

    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi ${PROMOTION_CODE_DISCOUNT_PRODUCT} Cho Sản Phẩm GHDUQD005
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Tổng Giá Trị Đơn Hàng Sau Khuyến Mãi Là ${total_invoice_value} Đồng
    And Thông Tin Khuyến Mãi Có Loại 3
    [Teardown]   Delete Invoice From API

# =====================================================================
# Khuyến mãi mua X tặng Y
# =====================================================================


RT-PR-012: Tạo hóa đơn với nhiều khuyến mãi cùng lúc
    [Documentation]    Kiểm tra tạo hóa đơn với nhiều khuyến mãi cùng lúc
    ...                Khuyến mãi 1: Giảm giá cố định 10.000 đồng
    ...                Khuyến mãi 2: Giảm giá phần trăm 5%
    ...                Tổng hóa đơn: 100.000 đồng
    ...                Kỳ vọng: Giảm giá = 10.000 + 5% x 100.000 = 15.000 đồng
    [Tags]    promotion    multiple    apiinvoice    smoke    regression

    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Khuyến Mãi ${PROMOTION_CODE_FIXED} Và ${PROMOTION_CODE_PERCENTAGE} 
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là 60000 Đồng
    And Hóa Đơn Có 2 Khuyến Mãi Được Áp Dụng
    [Teardown]   Delete Invoice From API

# =====================================================================
# Khuyến mãi hàng hóa mua hàng giảm giá hàng
# =====================================================================

RT-PR-013: Tạo hóa đơn với khuyến mãi hàng hóa mua hàng giảm giá hàng Phần Trăm
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi mua hàng giảm giá hàng
    ...                Mua sản phẩm HH0035 được giảm giá 20% cho sản phẩm NK002
    ...                Kỳ vọng: Hóa đơn được tạo với sản phẩm NK002 được giảm giá 5%
    [Tags]    promotion    discount_product    apiinvoice    smoke    regression
    
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Khuyễn Mãi Hàng Hóa ${PROMOTION_CODE_13} Mua Hàng HH0035 Giảm Giá Hàng NK002
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Sản Phẩm NK002 Có Chiết Khấu Khuyến Mãi 5%
    And Sản Phẩm NK002 Có Khuyến Mãi 4500 Đồng
    And Thông Tin Khuyến Mãi Có Loại 5
    [Teardown]   Delete Invoice From API

RT-PR-014: Tạo hóa đơn với khuyến mãi hàng hóa mua hàng giảm giá cố định cho hàng
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi mua hàng giảm giá cố định cho hàng
    ...                Mua sản phẩm HH0035 được giảm 50.000 đồng cho sản phẩm 	NK002 
    ...                Kỳ vọng: Hóa đơn được tạo với sản phẩm NK002 được giảm 30.000 đồng
    [Tags]    promotion    discount_product_fixed    apiinvoice    smoke    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Khuyễn Mãi Hàng Hóa ${PROMOTION_CODE_14} Mua Hàng HH0035 Giảm Giá Hàng NK002
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Sản Phẩm NK002 Có Khuyến Mãi 30000 Đồng
    And Thông Tin Khuyến Mãi Có Loại 5
    [Teardown]   Delete Invoice From API

# =====================================================================
# Khuyến mãi giá bán theo sản phẩm
# =====================================================================

RT-PR-015: Tạo hóa đơn với khuyến mãi giá bán giảm giá VND theo số lượng mua 
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi giá bán theo sản phẩm
    ...                Sản phẩm ${PRODUCT_ID_PROMOTION} được áp dụng giá bán giảm giá VND
    ...                Kỳ vọng: Hóa đơn được tạo với sản phẩm có giá bán theo khuyến mãi
    [Tags]    promotion    product_price    apiinvoice    smoke    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi ${PROMOTION_CODE_15} Giảm Giá Theo Số Lượng Mua PIB10010
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Sản Phẩm PIB10010 Có Khuyến Mãi 40000 Đồng
    And Thông Tin Khuyến Mãi Có Loại 8
    [Teardown]   Delete Invoice From API

RT-PR-016: Tạo hóa đơn với khuyến mãi giá bán theo sản phẩm giá bán theo %
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi giá bán theo sản phẩm
    ...                Sản phẩm ${PRODUCT_ID_PROMOTION} được áp dụng giá bán giảm giá %
    ...                Kỳ vọng: Hóa đơn được tạo với sản phẩm có giá bán theo khuyến mãi
    [Tags]    promotion    product_price    limited_quantity    apiinvoice    smoke    regression
    
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi ${PROMOTION_CODE_16} Giảm Giá Theo Số Lượng Mua PIB10010
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Sản Phẩm PIB10010 Có Chiết Khấu Khuyến Mãi 20%
    And Sản Phẩm PIB10010 Có Khuyến Mãi 60000 Đồng
    And Thông Tin Khuyến Mãi Có Loại 8
    [Teardown]   Delete Invoice From API

RT-PR-017: Tạo hóa đơn khuyến mãi hàng hóa giá bán theo số lượng mua
    [Documentation]    Kiểm tra tạo hóa đơn với khuyến mãi hàng hóa giá bán theo số lượng mua
    ...                Sản phẩm ${PRODUCT_ID_PROMOTION} giá gốc được áp dụng giá bán 80000
    ...                Kỳ vọng: Hóa đơn được tạo với sản phẩm có giá bán theo khuyến mãi
    ...                Tổng giá trị Khuyến mãi là ${total_discount} đồng
    [Tags]    promotion    product_price    multiple    apiinvoice    smoke    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi ${PROMOTION_CODE_17} Giá Bán Theo Số Lượng Mua PIB10010
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Sản Phẩm PIB10010 Có Khuyến Mãi 20000 Đồng
    And Thông Tin Khuyến Mãi Có Loại 8
    [Teardown]   Delete Invoice From API



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