*** Settings ***
Documentation     Test cases API cho phần tính điểm thưởng hàng hóa
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Invoice/RewardPointKeywords.robot
Resource          ../../../Keywords/Invoice/InvoiceCommonKeywords.robot
Resource          ../../../Keywords/Utilities/Utilities.robot
Resource          ../../../Keywords/Utilities/RequestHelper.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../TestData/CommonData.robot

Test Teardown     Delete Invoice From API


*** Keywords ***
*** Test Cases ***
RT-RP-001 Tính điểm thưởng theo sản phẩm có điểm cố định
    [Documentation]    Kiểm tra tính điểm thưởng theo sản phẩm có điểm cố định:
    ...    - Source: InvoiceService.cs > CalculatePoint() line ~8295
    ...    - Logic: Tổng điểm = Tổng (Điểm của sản phẩm * Số lượng)
    ...    - Sản phẩm: Điểm cố định = 5 điểm
    ...    - Số lượng: 1
    ...    - Điểm dự kiến: 5 điểm
    [Tags]    apiinvoice    reward-point    positive    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tích Điểm Theo Sản Phẩm ${PRODUCT_CODE_REWARD_POINT} Có Điểm Cố Định
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Điểm Thưởng Hóa Đơn 5
    And Xác Thực Bản Ghi Điểm Thưởng Được Tạo 5

RT-RP-005 Tính điểm thưởng theo sản phẩm có số lượng lớn
    [Documentation]    Kiểm tra tính điểm thưởng theo sản phẩm có số lượng lớn:
    ...    - Source: InvoiceService.cs > CalculatePoint() line ~8295
    ...    - Logic: Tổng điểm = Tổng (Điểm của sản phẩm * Số lượng)
    ...    - Sản phẩm: Điểm cố định = 5 điểm
    ...    - Số lượng: 5
    ...    - Điểm dự kiến: 362.5 điểm (5 điểm * 72.5)
    ...    - Số lẻ: 0.5
    [Tags]    apiinvoice    reward-point    positive    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${PRODUCT_CODE_REWARD_POINT} Có Tích Điểm Với Số Lượng 72.5
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Xác Thực Điểm Thưởng Hóa Đơn 362
    And Xác Thực Bản Ghi Điểm Thưởng Được Tạo 362

RT-RP-006 Tính điểm thưởng theo sản phẩm hỗn hợp
    [Documentation]    Kiểm tra tính điểm thưởng với hóa đơn chứa sản phẩm có tích điểm và không tích điểm:
    ...    - Source: InvoiceService.cs > CalculatePoint() line ~8295
    ...    - Logic: Tổng điểm = Tổng (Điểm của các sản phẩm tích điểm * Số lượng)
    ...    - Sản phẩm 1: IsRewardPoint = True, Điểm = 5 (tính theo giá)
    ...    - Sản phẩm 2: IsRewardPoint = False, Điểm = 0
    ...    - Điểm dự kiến:5 điểm
    [Tags]    apiinvoice    reward-point    positive    regression
    
    # GIVEN: Chuẩn bị dữ liệu hóa đơn với sản phẩm có tích điểm và không tích điểm
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tích Điểm Sản Phẩm ${PRODUCT_CODE_REWARD_POINT} Và Không Tích Điểm Sản Phẩm ${PRODUCT_1_CODE}  
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Điểm Thưởng Hóa Đơn 5
    And Xác Thực Bản Ghi Điểm Thưởng Được Tạo 5

RT-RP-007 Tính điểm thưởng theo nhiều sản phẩm tích điểm
    [Documentation]    Kiểm tra tính điểm thưởng với hóa đơn chứa sản phẩm có tích điểm và không tích điểm:
    ...    - Source: InvoiceService.cs > CalculatePoint() line ~8295
    ...    - Logic: Tổng điểm = Tổng (Điểm của các sản phẩm tích điểm * Số lượng)
    ...    - Sản phẩm 1: IsRewardPoint = True, Điểm = 5 (tính theo giá)
    ...    - Sản phẩm 2: IsRewardPoint = True, Điểm = 7 (tính theo giá)
    ...    - Điểm dự kiến:15 điểm
    [Tags]    apiinvoice    reward-point    positive    regression
    
    # GIVEN: Chuẩn bị dữ liệu hóa đơn với sản phẩm có tích điểm và không tích điểm
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tích Điểm Sản Phẩm ${PRODUCT_CODE_REWARD_POINT} Và Tích Điểm Sản Phẩm ${PRODUCT_CODE_REWARD_POINT_7}    
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Điểm Thưởng Hóa Đơn 12
    And Xác Thực Bản Ghi Điểm Thưởng Được Tạo 12

RT-RP-008 Không tích điểm cho hóa đơn không có khách hàng
    [Documentation]    Kiểm tra không tích điểm cho hóa đơn không có khách hàng:
    ...    - Source: InvoiceService.cs > CalculatePoint() line ~8295
    ...    - Logic: Nếu CustomerId = 0, không tích điểm
    ...    - CustomerId = 0 (khách vãng lai)
    ...    - Điểm dự kiến: 0 điểm
    [Tags]    apiinvoice    reward-point    negative    regression
    
    # GIVEN: Chuẩn bị dữ liệu hóa đơn không có khách hàng
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Không Có Khách Hàng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Không Có Điểm Thưởng
    And Xác Thực Không Có Bản Ghi Điểm Thưởng

# RT-RP-009 Tính điểm thưởng khi có khuyến mãi tặng điểm theo hóa đơn  # đã có bên khuyến mãi
#     [Documentation]    Kiểm tra tính điểm thưởng khi có khuyến mãi tặng điểm theo hóa đơn:
#     ...    - Source: InvoiceService.cs > CalculatePromotionPoint() line ~4815
#     ...    - Logic: Điểm khuyến mãi theo hóa đơn được cộng vào tổng điểm
#     ...    - Tổng tiền: 100,000đ (Điểm cơ bản: 10 điểm)
#     ...    - Khuyến mãi: Type=12 (InvoicePointGift), Value=10 (điểm)
#     ...    - Điểm dự kiến: 20 điểm (10 điểm cơ bản + 10 điểm khuyến mãi)
#     [Tags]    api    invoice    reward-point    promotion    positive
    
#     # GIVEN: Chuẩn bị dữ liệu hóa đơn với khuyến mãi tặng điểm theo hóa đơn
#     ${request}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Điểm Theo Hóa Đơn
    
#     # WHEN: Gửi yêu cầu tạo hóa đơn
#     Gửi Yêu Cầu Tạo Hóa Đơn
    
#     # THEN: Hóa đơn được tạo thành công với điểm thưởng tương ứng
#     Response Status Code Should Be 200
#     Xác Thực Điểm Thưởng Hóa Đơn    20
#     Xác Thực Bản Ghi Điểm Thưởng Được Tạo    20

# RT-RP-010 Tính điểm thưởng khi có khuyến mãi tặng điểm theo sản phẩm
#     [Documentation]    Kiểm tra tính điểm thưởng khi có khuyến mãi tặng điểm theo sản phẩm:
#     ...    - Source: InvoiceService.cs > CalculatePromotionPoint() line ~4815
#     ...    - Logic: Điểm khuyến mãi theo sản phẩm được cộng vào tổng điểm
#     ...    - Tổng tiền: 100,000đ (Điểm cơ bản: 10 điểm)
#     ...    - Khuyến mãi: Type=13 (ProductPointGift), Value=20 (điểm), ProductId=${PRODUCT_1}
#     ...    - Điểm dự kiến: 30 điểm (10 điểm cơ bản + 20 điểm khuyến mãi sản phẩm)
#     [Tags]    api    invoice    reward-point    promotion    positive
    
#     # GIVEN: Chuẩn bị dữ liệu hóa đơn với khuyến mãi tặng điểm theo sản phẩm
#     ${request}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Điểm Theo Sản Phẩm
    
#     # WHEN: Gửi yêu cầu tạo hóa đơn
#     Gửi Yêu Cầu Tạo Hóa Đơn
    
#     # THEN: Hóa đơn được tạo thành công với điểm thưởng tương ứng
#     Response Status Code Should Be 200
#     Xác Thực Điểm Thưởng Hóa Đơn    30
#     Xác Thực Bản Ghi Điểm Thưởng Được Tạo    30

RT-RP-011 Tính điểm thưởng không tính phụ phí và thuế
    [Documentation]    Kiểm tra tính điểm thưởng không tính phần phụ phí và thuế:
    ...    - Source: InvoiceService.cs > CalculatePoint() line ~8295
    ...    - Logic: Tổng điểm = (Tổng tiền - Phụ phí - Thuế) / Tỷ lệ tiền/điểm
    ...    - Tổng tiền hóa đơn: 115,000đ
    ...    - Phụ phí: 10,000đ
    ...    - Thuế: 5,000đ
    ...    - Tổng tiền tính điểm: 100,000đ
    ...    - Tỷ lệ: 10,000đ = 1 điểm
    ...    - Điểm dự kiến: 10 điểm
    [Tags]    
    
    # GIVEN: Chuẩn bị dữ liệu hóa đơn với phụ phí và thuế
    ${request}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Phụ Phí Và Thuế
    
    # WHEN: Gửi yêu cầu tạo hóa đơn
    Gửi Yêu Cầu Tạo Hóa Đơn
    
    # THEN: Hóa đơn được tạo thành công với điểm thưởng tương ứng
    Response Status Code Should Be 200
    Xác Thực Điểm Thưởng Hóa Đơn    10
    Xác Thực Bản Ghi Điểm Thưởng Được Tạo    10

# RT-RP-012 Tích điểm thưởng với số lẻ được làm tròn xuống   Đã sửa case trên có mục số lẻ
#     [Documentation]    Kiểm tra cách xử lý điểm thưởng khi tính toán ra số lẻ:
#     ...    - Source: InvoiceService.cs > CalculatePoint() line ~8295
#     ...    - Logic: Điểm thưởng được làm tròn xuống (floor) nếu là số thập phân
#     ...    - Tổng tiền: 105,000đ
#     ...    - Tỷ lệ: 10,000đ = 1 điểm
#     ...    - Điểm dự kiến: 10 điểm (105,000 / 10,000 = 10.5 → làm tròn xuống thành 10)
#     [Tags]    api    invoice    reward-point    positive    rounding
    
#     # GIVEN: Chuẩn bị dữ liệu hóa đơn với tổng tiền lẻ
#     ${request}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Tổng Tiền Lẻ
    
#     # WHEN: Gửi yêu cầu tạo hóa đơn
#     Gửi Yêu Cầu Tạo Hóa Đơn
    
#     # THEN: Hóa đơn được tạo thành công với điểm thưởng làm tròn xuống
#     Response Status Code Should Be 200
#     Xác Thực Điểm Thưởng Hóa Đơn    10
#     Xác Thực Bản Ghi Điểm Thưởng Được Tạo    10

# RT-RP-013 Giới hạn điểm thưởng tối đa cho mỗi hóa đơn     không có logic này
#     [Documentation]    Kiểm tra giới hạn điểm thưởng tối đa cho mỗi hóa đơn:
#     ...    - Source: InvoiceService.cs > CalculatePoint() line ~8295
#     ...    - Logic: Tổng điểm không vượt quá giới hạn tối đa (nếu có)
#     ...    - Tổng tiền: 1,000,000đ
#     ...    - Tỷ lệ: 10,000đ = 1 điểm
#     ...    - Điểm dự kiến: 100 điểm
#     ...    - Giới hạn điểm tối đa: 50 điểm
#     ...    - Điểm cuối cùng: 50 điểm
#     [Tags]    api    invoice    reward-point    positive    maximum-limit
    
#     # GIVEN: Cập nhật cấu hình giới hạn điểm tối đa và chuẩn bị dữ liệu hóa đơn
#     # Cập nhật cấu hình giới hạn điểm tối đa
#     ${query_update}=    Set Variable    UPDATE PosSetting SET RewardPoint_MaximumPointPerInvoice = 50 WHERE RetailerId = ?
#     Execute Sql    ${query_update}    ${RETAILER_ID}
    
#     ${request}=    Deep Copy    ${invoice_request_body}
    
#     # Cập nhật cấu hình tích điểm
#     ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPointType    ${REWARD_TYPE_INVOICE}
#     ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPoint_MoneyPerPoint    ${REWARD_POINTS_MONEY_RATIO}
    
#     # Thêm thông tin sản phẩm
#     ${product}=    Create Invoice Detail    ${PRODUCT_1}    10    100000    0
#     ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product}
#     ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Total    1000000
    
#     Set Test Variable    ${REQUEST_DATA}    ${request}
    
#     # WHEN: Gửi yêu cầu tạo hóa đơn
#     Gửi Yêu Cầu Tạo Hóa Đơn
    
#     # THEN: Hóa đơn được tạo thành công với sđiểm thưởng bị giới hạn
#     Response Status Code Should Be 200
#     Xác Thực Điểm Thưởng Hóa Đơn    50
#     Xác Thực Bản Ghi Điểm Thưởng Được Tạo    50
    
#     # Khôi phục cấu hình mặc định
#     ${query_restore}=    Set Variable    UPDATE PosSetting SET RewardPoint_MaximumPointPerInvoice = NULL WHERE RetailerId = ?
#     Execute Sql    ${query_restore}    ${RETAILER_ID}

RT-RP-014 Không tích điểm cho sản phẩm có tính điểm phần điểm thưởng bằng 0
    [Documentation]    Kiểm tra không tích điểm cho sản phẩm có giá bằng 0:
    ...    - Source: InvoiceService.cs > CalculatePoint() line ~8295
    ...    - Logic: Sản phẩm có giá = 0 không được tính điểm
    ...    - Sản phẩm 1: Giá = 0đ, Số lượng = 1
    ...    - Sản phẩm 2: Giá = 100,000đ, Số lượng = 1
    ...    - Điểm dự kiến: 10 điểm (chỉ tính điểm cho sản phẩm 2)
    [Tags]    apiinvoice    reward-point    negative    zero-price    regression
    
    # GIVEN: Chuẩn bị dữ liệu hóa đơn với sản phẩm giá 0đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tích Điểm Theo Sản Phẩm ${PRODUCT_CODE_REWARD_POINT_ZERO} Có Điểm Cố Định
    When Gửi Yêu Cầu Tạo Hóa Đơn    
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Điểm Thưởng Hóa Đơn 0
    And Xác Thực Không Có Bản Ghi Điểm Thưởng


# RT-RP-015 Tính lại điểm thưởng sau khi thay đổi thông tin sản phẩm   API k cache
#     [Documentation]    Kiểm tra tính lại điểm thưởng sau khi thay đổi thông tin sản phẩm:
#     ...    - Source: InvoiceService.cs > UpdateInvoiceAsync() > RecalculatePoint()
#     ...    - Logic: Điểm thưởng được tính lại khi cập nhật hóa đơn
#     ...    - Ban đầu: 1 sản phẩm, giá 100,000đ → 10 điểm
#     ...    - Cập nhật: Thêm 1 sản phẩm, giá 50,000đ → Tổng 15 điểm
#     [Tags]    
    
#     # GIVEN: Chuẩn bị dữ liệu hóa đơn ban đầu
#     ${request}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Tích Điểm Theo Hóa Đơn
    
#     # WHEN: Gửi yêu cầu tạo hóa đơn
#     Gửi Yêu Cầu Tạo Hóa Đơn
    
#     # THEN: Hóa đơn được tạo thành công với điểm thưởng ban đầu
#     Response Status Code Should Be 200
#     Xác Thực Điểm Thưởng Hóa Đơn    10
#     ${invoice_id}=    Set Variable    ${INVOICE_ID}
    
#     # GIVEN: Chuẩn bị dữ liệu cập nhật hóa đơn
#     ${update_request}=    Deep Copy    ${RESPONSE.json()}
    
#     # Thêm sản phẩm mới
#     ${new_product}=    Create Invoice Detail    ${PRODUCT_2}    1    50000    0
#     Append To List    ${update_request["InvoiceDetails"]}    ${new_product}
    
#     # Cập nhật tổng tiền
#     ${update_request}=    Update Dictionary Property    ${update_request}    Total    150000
    
#     # WHEN: Gửi yêu cầu cập nhật hóa đơn
#     ${update_response}=    Call API PUT    invoices/${invoice_id}    ${update_request}
#     Set Test Variable    ${RESPONSE}    ${update_response}
    
#     # THEN: Hóa đơn được cập nhật thành công với điểm thưởng được tính lại
#     Response Status Code Should Be 200
#     Xác Thực Điểm Thưởng Hóa Đơn    15
#     Xác Thực Bản Ghi Điểm Thưởng Được Tạo    15 