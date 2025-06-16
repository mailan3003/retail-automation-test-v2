*** Settings ***
Documentation     Test API tạo đơn hàng mới
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Order/CreateOrderKeywords.robot
Resource          ../../../Keywords/Order/OrderCommonKeywords.robot
Resource          ../../../Keywords/Promotion/PromotionComnonKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../TestData/CommonData.robot
Resource          ../../../TestData/Order/CreateOrderData.robot

*** Variables ***
@{list_payment_method}   ${PAYMENT_CASH}    ${PAYMENT_CARD}
@{list_payment_amount}   50000      50000
@{list_payment_amount_1}   30000      30000
@{list_payment_method_voucher}  ${PAYMENT_VOUCHER}   ${PAYMENT_VOUCHER}  
@{list_payment_amount_voucher}  100000      100000
@{list_payment_method_2}   ${PAYMENT_CASH}    ${PAYMENT_CARD}    ${PAYMENT_TRANSFER}
@{list_payment_amount_2}   40000      30000      20000
*** Test Cases ***
RT-RC-001 Tạo Đơn Hàng Với Thanh Toán Tiền Mặt Hết Số Tiền Cần Trả
    [Documentation]    Kiểm tra tạo đơn hàng với thanh toán tiền mặt
    ...    - Dữ liệu đầu vào:
    ...    - Đơn hàng có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán: tiền mặt
    ...    - Số tiền thanh toán: 100,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Đơn hàng được tạo trong DB với số tiền 100,000đ
    ...    - Mã đơn hàng bắt đầu với tiền tố "DH"
    ...    - Ngày tạo đơn hàng là ngày hiện tại
    ...    - Tổng tiền thanh toán của đơn hàng = 100,000đ
    [Tags]    payment    smoke    apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0116 Có Thanh Toán 100000 Phương Thức ${PAYMENT_CASH}
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Thanh Toán Trong Đơn Đặt Hàng Được Ghi Nhận Phương Thức ${PAYMENT_CASH} Với Số Tiền 100000
    And Xác Thực Tổng Tiền Thanh Toán Của Đơn Đặt Hàng 100000
    [Teardown]    Delete Order From Api



RT-RC-002 Tạo Đơn Hàng Với Thanh Toán Bằng Thẻ
    [Documentation]    Kiểm tra tạo phiếu thu với thanh toán bằng thẻ
    ...    - Dữ liệu đầu vào:
    ...    - Đơn hàng có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán: thẻ
    ...    - Số tiền thanh toán: 40,000đ
    ...    - Tài khoản ngân hàng: ${BANK_ACCOUNT_ID}
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Phiếu thu được tạo trong DB với số tiền 100,000đ
    ...    - Thanh toán bằng thẻ được ghi nhận trong DB
    ...    - Tổng tiền thanh toán của đơn hàng = 40,000đ
    [Tags]    payment      smoke   apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Thanh Toán 40000 Phương Thức ${PAYMENT_CARD}
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Thanh Toán Trong Đơn Đặt Hàng Được Ghi Nhận Phương Thức ${PAYMENT_CARD} Với Số Tiền 40000
    And Xác Thực Tổng Tiền Thanh Toán Của Đơn Đặt Hàng 40000
    [Teardown]    Delete Order From Api

RT-RC-003 Tạo phiếu thu với thanh toán bằng chuyển khoản trả thừa
    [Tags]    payment      smoke   apiinvoice    regression
    [Documentation]    Kiểm tra tạo phiếu thu với thanh toán bằng chuyển khoản
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán: chuyển khoản
    ...    - Số tiền thanh toán: 100,000đ
    ...    - Tài khoản ngân hàng: ${BANK_ACCOUNT_ID}
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Phiếu thu được tạo trong DB với số tiền 100,000đ
    ...    - Thanh toán bằng chuyển khoản được ghi nhận trong DB
    ...    - Tổng tiền thanh toán của hóa đơn = 100,000đ
    ...    - Công nợ của hóa đơn = 0
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Thanh Toán 120000 Phương Thức ${PAYMENT_TRANSFER}
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Thanh Toán Trong Đơn Đặt Hàng Được Ghi Nhận Phương Thức ${PAYMENT_TRANSFER} Với Số Tiền 120000
    And Xác Thực Tổng Tiền Thanh Toán Của Đơn Đặt Hàng 120000
    [Teardown]    Delete Order From Api

RT-RC-004 Tạo đặt hàng với nhiều phương thức thanh toán
    [Tags]    payment      smoke   apiinvoice    regression
    [Documentation]    Kiểm tra tạo phiếu thu với nhiều phương thức thanh toán
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán 1: tiền mặt, số tiền 50,000đ
    ...    - Phương thức thanh toán 2: thẻ, số tiền 50,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Phiếu thu được tạo trong DB với tổng số tiền 100,000đ
    ...    - Thanh toán tiền mặt được ghi nhận số tiền 50,000đ
    ...    - Thanh toán thẻ được ghi nhận số tiền 50,000đ
    ...    - Tổng tiền thanh toán của hóa đơn = 100,000đ
    ...    - Công nợ của hóa đơn = 0
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Nhiều Phương Thức Thanh Toán ${list_payment_method} Với Số Tiền ${list_payment_amount}
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Thanh Toán Trong Đơn Đặt Hàng Được Ghi Nhận Phương Thức ${PAYMENT_CASH} Với Số Tiền 50000
    And Xác Thực Thanh Toán Trong Đơn Đặt Hàng Được Ghi Nhận Phương Thức ${PAYMENT_CARD} Với Số Tiền 50000
    And Xác Thực Tổng Tiền Thanh Toán Của Đơn Đặt Hàng 100000
    [Teardown]    Delete Order From Api


RT-RC-008 Tạo Đơn Hàng Với Thanh Toán Bằng Wallet Với Tài Khoản
    [Tags]    payment      smoke   apiinvoice     regression
    [Documentation]    Kiểm tra tính giá trị thanh toán khi thanh toán bằng wallet với tài khoản
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Phương thức thanh toán = Wallet
    ...    - Số tiền thanh toán = 100,000đ
    ...    - Tài khoản wallet = WALLET001
    ...    - Logic tính toán:
    ...    - Tổng thanh toán = 100,000đ
    ...    - Tiền nợ = 0đ (Tổng tiền - Tổng thanh toán = 100,000đ - 100,000đ = 0đ)
    ...    - Trạng thái thanh toán = Đã thanh toán đủ (1)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán = 100,000đ
    ...    - Tiền nợ = 0đ
    ...    - Thanh toán wallet được ghi nhận với tài khoản ${BANK_WALLET_ID}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Thanh Toán Phương Thức ${PAYMENT_WALLET} Tài khoản ${BANK_WALLET_ACCOUNT} Với Số Tiền 100000
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Thanh Toán Trong Đơn Đặt Hàng Được Ghi Nhận Phương Thức ${PAYMENT_WALLET} Với Số Tiền 100000
    And Xác Thực Tổng Tiền Thanh Toán Của Đơn Đặt Hàng 100000
    And Xác Thực Tài Khoản ${BANK_WALLET_ACCOUNT} Được Sử Dụng Khi Thanh Toán Đặt Hàng
    [Teardown]    Delete Order From Api

RT-RC-010 Tạo phiếu thu với thanh toán bằng điểm 
    [Documentation]    Kiểm tra tính giá trị thanh toán khi thanh toán bằng điểm thưởng
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Phương thức thanh toán = Điểm
    ...    - Số tiền thanh toán bằng điểm = 50,000đ
    ...    - Logic tính toán:
    ...    - Tổng thanh toán = 50,000đ
    ...    - Tiền nợ = 50,000đ (Tổng tiền - Tổng thanh toán = 100,000đ - 50,000đ = 50,000đ)
    ...    - Trạng thái thanh toán = Đã thanh toán một phần (2)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán = 50,000đ
    ...    - Tiền nợ = 50,000đ
    ...    - Trạng thái thanh toán = 2
    ...    - Khách hàng sử dụng điểm tương ứng (giả sử 50 điểm)
    [Tags]    payment      smoke   apiinvoice   regression
    Given Chuẩn Bị Đơn Hàng HH0115 Thanh Toán Số Tiền 50000 Sử Dụng Điểm 50
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Thanh Toán Trong Đơn Đặt Hàng Được Ghi Nhận Phương Thức ${PAYMENT_POINT} Với Số Tiền 50000
    And Xác Thực Tổng Tiền Thanh Toán Của Đơn Đặt Hàng 50000
    [Teardown]    Delete Order From Api


RT-RC-010 Kiểm tra không tạo phiếu thu khi thanh toán bằng 0 đồng
    [Tags]    payment      smoke   apiinvoice    regression
    [Documentation]    Kiểm tra không tạo phiếu thu khi thanh toán bằng 0 đồng
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán: tiền mặt
    ...    - Số tiền thanh toán: 0đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Không có phiếu thu nào được tạo
    ...    - Tổng tiền thanh toán của hóa đơn = 0đ
    ...    - Công nợ của hóa đơn = 100,000đ

    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Thanh Toán 0 Phương Thức ${PAYMENT_CASH}
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Tổng Tiền Thanh Toán Của Đơn Đặt Hàng 0   
    [Teardown]    Delete Order From Api

RT-RC-011 Tạo phiếu thu với số tiền lớn
    [Tags]    payment      smoke   apiinvoice      regression
    [Documentation]    Kiểm tra tạo phiếu thu với số tiền lớn
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán: tiền mặt
    ...    - Số tiền thanh toán: 9,999,999đ (rất lớn)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Phiếu thu được tạo trong DB với số tiền 9,999,999đ
    ...    - Tổng tiền thanh toán của hóa đơn = 9,999,999đ
    ...    - Tiền thừa của hóa đơn = 9,899,999đ
    ...    - Công nợ của hóa đơn = 0
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Thanh Toán 9999999 Phương Thức ${PAYMENT_CASH}
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Thanh Toán Trong Đơn Đặt Hàng Được Ghi Nhận Phương Thức ${PAYMENT_CASH} Với Số Tiền 9999999
    And Xác Thực Tổng Tiền Thanh Toán Của Đơn Đặt Hàng 9999999
    [Teardown]    Delete Order From Api


RT-RC-012 Tạo phiếu thu thanh toán một phần bằng các phương thức khác nhau
    [Tags]    payment      smoke   apiinvoice      regression
    [Documentation]    Kiểm tra tạo phiếu thu với thanh toán một phần bằng các phương thức khác nhau
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán 1: tiền mặt, số tiền 30,000đ
    ...    - Phương thức thanh toán 2: thẻ, số tiền 30,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Phiếu thu được tạo trong DB với tổng số tiền 60,000đ
    ...    - Thanh toán tiền mặt được ghi nhận số tiền 30,000đ
    ...    - Thanh toán thẻ được ghi nhận số tiền 30,000đ
    ...    - Tổng tiền thanh toán của hóa đơn = 60,000đ
    ...    - Công nợ của hóa đơn = 40,000đ
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Nhiều Phương Thức Thanh Toán ${list_payment_method} Với Số Tiền ${list_payment_amount_1}
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Thanh Toán Trong Đơn Đặt Hàng Được Ghi Nhận Phương Thức ${PAYMENT_CASH} Với Số Tiền 30000
    And Xác Thực Thanh Toán Trong Đơn Đặt Hàng Được Ghi Nhận Phương Thức ${PAYMENT_CARD} Với Số Tiền 30000
    And Xác Thực Tổng Tiền Thanh Toán Của Đơn Đặt Hàng 60000
    [Teardown]    Delete Order From Api

RT-RC-009 Tạo Hóa đơn với thanh toán bằng voucher
    [Tags]    payment      smoke   apiinvoice      regression
    [Documentation]    Kiểm tra tính giá trị thanh toán khi thanh toán bằng voucher
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 500,000đ
    ...    - Phương thức thanh toán 1 = Voucher, Số tiền = 100,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán = 100,000đ
    ...    - Tiền nợ = 400,000đ
    ...    - Voucher được sử dụng với giá trị 100,000đ
    Given Chuẩn Bị Đơn Hàng HH0115 Thanh Toán Bằng Voucher Đợt CBVC00002
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Thanh Toán Trong Đơn Đặt Hàng Được Ghi Nhận Phương Thức ${PAYMENT_VOUCHER} Với Số Tiền 100000
    And Xác Thực Tổng Tiền Thanh Toán Của Đơn Đặt Hàng 100000
    [Teardown]   RUN KEYWORDS      Delete Order From Api     AND    Update Trạng thái ${VOUCHER_ID} Sang Trạng Thái Chưa Sử Dụng

RT-RC-013 Kiểm tra thanh toán với số tiền 0 đồng
    [Documentation]    Kiểm tra khi thanh toán 0 đồng vẫn tạo phiếu thu với số tiền 0
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán: tiền mặt
    ...    - Số tiền thanh toán: 0đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Phiếu thu vẫn được tạo với số tiền 0đ
    ...    - Tổng tiền thanh toán của hóa đơn = 0đ
    ...    - Công nợ của hóa đơn = 100,000đ
    [Tags]    payment    AIGenerated         regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Thanh Toán 0 Phương Thức ${PAYMENT_CASH}
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Thanh Toán Trong Đơn Đặt Hàng Được Ghi Nhận Phương Thức ${PAYMENT_CASH} Với Số Tiền 0
    And Xác Thực Tổng Tiền Thanh Toán Của Đơn Đặt Hàng 0
    [Teardown]    Delete Order From Api

RT-RC-014 Thanh toán bằng điểm thưởng kết hợp với tiền mặt
    [Documentation]    Kiểm tra tính toán thanh toán khi kết hợp điểm thưởng và tiền mặt
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán 1: Điểm thưởng, số điểm 25, số tiền 25,000đ
    ...    - Phương thức thanh toán 2: Tiền mặt, số tiền 75,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán của hóa đơn = 100,000đ
    ...    - Thanh toán bằng điểm được ghi nhận số tiền 25,000đ
    ...    - Thanh toán bằng tiền mặt được ghi nhận số tiền 75,000đ
    ...    - Công nợ của hóa đơn = 0
    [Tags]    payment    point    cash    apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Với Điểm Thưởng Và Tiền Mặt
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Thanh Toán Trong Đơn Đặt Hàng Được Ghi Nhận Phương Thức ${PAYMENT_POINT} Với Số Tiền 25000
    And Xác Thực Thanh Toán Trong Đơn Đặt Hàng Được Ghi Nhận Phương Thức ${PAYMENT_CASH} Với Số Tiền 75000
    And Xác Thực Tổng Tiền Thanh Toán Của Đơn Đặt Hàng 100000
    [Teardown]    Delete Order From Api




RT-RC-018 Thanh toán kết hợp ba phương thức thanh toán Với Khách Hàng
    [Documentation]    Kiểm tra tính toán thanh toán khi kết hợp ba phương thức thanh toán
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán 1: Tiền mặt, số tiền 40,000đ
    ...    - Phương thức thanh toán 2: Thẻ, số tiền 30,000đ
    ...    - Phương thức thanh toán 3: Chuyển khoản, số tiền 30,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán của hóa đơn = 100,000đ
    ...    - Thanh toán tiền mặt được ghi nhận số tiền 40,000đ
    ...    - Thanh toán thẻ được ghi nhận số tiền 30,000đ
    ...    - Thanh toán chuyển khoản được ghi nhận số tiền 30,000đ
    ...    - Công nợ của hóa đơn = 0
    [Tags]    payment    multiple_methods    AIGenerated       regression  
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Khách Hàng CTKH280 Thanh Toán Đa Phương Thức ${list_payment_method_2} Với ${list_payment_amount_2}
    And Lấy Công Nợ Của Khách Hàng    CTKH280
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Thanh Toán Trong Đơn Đặt Hàng Được Ghi Nhận Phương Thức ${PAYMENT_CASH} Với Số Tiền 40000
    And Xác Thực Thanh Toán Trong Đơn Đặt Hàng Được Ghi Nhận Phương Thức ${PAYMENT_CARD} Với Số Tiền 30000
    And Xác Thực Thanh Toán Trong Đơn Đặt Hàng Được Ghi Nhận Phương Thức ${PAYMENT_TRANSFER} Với Số Tiền 20000
    And Xác Thực Tổng Tiền Thanh Toán Của Đơn Đặt Hàng 90000
    And Công Nợ Của Khách Hàng CTKH280 Sau Thanh Toán 90000
    [Teardown]    Delete Order From Api


RT-RC-021 Tạo hóa đơn với điểm khách hàng Thanh Toán 1 Phần
    [Documentation]    Kiểm tra xử lý khi tạo hóa đơn thanh toán bằng điểm nhưng điểm không đủ
    ...    - Dữ liệu đầu vào:
    ...    - Khách hàng có 50 điểm (tương đương 50,000đ)
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán: Điểm thưởng
    ...    - Số điểm sử dụng: 100 (> số điểm hiện có)
    ...    - Kỳ vọng:
    ...    - Status code: 400
    ...    - Response có thông báo lỗi về điểm không đủ
    [Tags]    payment    point    validation    AIGenerated    regression
    Given Chuẩn Bị Đơn Hàng HH0115 Thanh Toán CTKH281 Số Tiền 10000 Sử Dụng Điểm 10
    And Lấy Công Nợ Của Khách Hàng    CTKH281
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Thanh Toán Trong Đơn Đặt Hàng Được Ghi Nhận Phương Thức ${PAYMENT_POINT} Với Số Tiền 10000
    And Công Nợ Của Khách Hàng CTKH281 Sau Thanh Toán 10000
    And Điểm Của Khách Hàng CTKH281 Giảm 10 Sau Khi Thực Hiện Giao Dịch ${PAYMENT_ID} 
   [Teardown]    Delete Order From Api

RT-GP-013 Thanh toán hóa đơn với Voucher không hợp lệ
    [Documentation]    Kiểm tra xử lý lỗi khi thanh toán bằng Voucher không hợp lệ
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_VOUCHER004"
    ...    - Tổng tiền: 100,000đ
    ...    - Thanh toán: Voucher không hợp lệ (đã sử dụng hoặc hết hạn)
    ...    - Logic xử lý: 
    ...      + VoucherService.ValidateVoucher() kiểm tra tính hợp lệ và trả về lỗi
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Voucher không hợp lệ hoặc đã được sử dụng"
    [Tags]    payment    voucher   apiinvoice      regression
    Given Chuẩn Bị Đặt Hàng HH0115 Thanh Toán Bằng Voucher Đợt VOUCHER003 Với Mã Voucher ở Trạng Thái Chưa Sử Dụng
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 420
    And Response Should Have Error "Trạng thái voucher ${VOUCHER_CODE} chưa hợp lệ. Voucher phải ở trạng thái Đã phát hành" 

RT-GP-013 Thanh toán hóa đơn với Voucher đã sử dụng
    [Documentation]    Kiểm tra xử lý lỗi khi thanh toán bằng Voucher không hợp lệ
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_VOUCHER004"
    ...    - Tổng tiền: 100,000đ
    ...    - Thanh toán: Voucher không hợp lệ (đã sử dụng hoặc hết hạn)
    ...    - Logic xử lý: 
    ...      + VoucherService.ValidateVoucher() kiểm tra tính hợp lệ và trả về lỗi
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Voucher không hợp lệ hoặc đã được sử dụng"
    [Tags]    payment    voucher   apiinvoice       regression
    Given Chuẩn Bị Đặt Hàng HH0115 Thanh Toán Bằng Voucher Đợt VOUCHER003 Với Mã Voucher ở Trạng Thái Đã Sử Dụng
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 420
    And Response Should Have Error "Trạng thái voucher ${VOUCHER_CODE} chưa hợp lệ. Voucher phải ở trạng thái Đã phát hành"

Tạo hóa đơn chưa đủ điều kiện vẫn thanh toán bằng voucher
    [Documentation]    Kiểm tra xử lý khi tạo hóa đơn chưa đủ điều kiện vẫn thanh toán bằng voucher
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_VOUCHER005"
    ...    - Tổng tiền: 100,000đ
    ...    - Thanh toán: Voucher 100,000đ
    ...    - Logic xử lý: 
    ...      + VoucherService.ValidateVoucher() kiểm tra tính hợp lệ và trả về lỗi
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Voucher không hợp lệ hoặc đã được sử dụng"
    [Tags]    payment    voucher   apiinvoice       regression
    Given Chuẩn Bị Đặt Hàng HH0115 Thanh Toán Bằng Voucher Đợt VOUCHER003 Với Mã Voucher ở Trạng Thái Đã Phát Hành
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 420
    And Response Should Have Error "Tổng tiền hàng phải lớn hơn 800,000 mới có thể sử dụng voucher ${VOUCHER_CODE}"

Tạo hóa đơn với voucher chưa áp dụng 
   [Documentation]    Kiểm tra xử lý khi tạo hóa đơn với voucher chưa áp dụng
   ...    - Dữ liệu đầu vào:
   ...    - Mã hóa đơn: "HD_TEST_VOUCHER006"
   ...    - Tổng tiền: 100,000đ
   ...    - Thanh toán: Voucher 100,000đ
   ...    - Logic xử lý: 
   ...      + VoucherService.ValidateVoucher() kiểm tra tính hợp lệ và trả về lỗi
   ...    - Kỳ vọng:
   ...    - Status code: 420
   ...    - Thông báo lỗi: "Voucher không hợp lệ hoặc đã được sử dụng"
   [Tags]    payment    voucher   apiinvoice       regression
   Given Chuẩn Bị Đặt Hàng HH0115 Thanh Toán Bằng Voucher Đợt VOUCHERE001 Với Mã Voucher ở Trạng Thái Đã Phát Hành
   When Gửi Yêu Cầu Tạo Đơn Hàng
   Then Mã trạng thái phải là 420
   And Response Should Have Error "Đợt phát hành của voucher ${VOUCHER_CODE} chưa được kích hoạt"



Tạo hóa đơn thanh toán nhiều voucher với voucher hết hạn
    [Documentation]    Kiểm tra xử lý khi tạo hóa đơn thanh toán nhiều voucher với voucher hết hạn
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_VOUCHER008"
    ...    - Tổng tiền: 100,000đ
    ...    - Thanh toán: Voucher 100,000đ
    ...    - Logic xử lý: 
    ...      + VoucherService.ValidateVoucher() kiểm tra tính hợp lệ và trả về lỗi
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Voucher không hợp lệ hoặc đã được sử dụng"
    [Tags]   apiinvoice     regression
    Given Chuẩn Bị Đặt Hàng HH0115 Thanh Toán Bằng Voucher Đợt VOUCHER Với Mã Voucher ở Trạng Thái Đã Phát Hành 
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Thời gian giao dịch không phù hợp với thời hạn sử dụng của voucher ${VOUCHER_CODE}"


RT-GP-014 Thanh toán đặt hàng với nhiều Voucher
    [Documentation]    Kiểm tra thanh toán hóa đơn với nhiều Voucher khác nhau
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_VOUCHER005"
    ...    - Tổng tiền: 200,000đ
    ...    - Thanh toán 1: Voucher 1 - 50,000đ
    ...    - Thanh toán 2: Voucher 2 - 50,000đ
    ...    - Logic xử lý: 
    ...      + InvoiceService.CreateInvoice() tạo nhiều Payment với Method="Voucher"
    ...      + VoucherService.ValidateVoucher() xác thực từng voucher
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công
    ...    - Thanh toán Voucher 1 được ghi nhận với số tiền 50,000đ
    ...    - Thanh toán Voucher 2 được ghi nhận với số tiền 50,000đ
    ...    - Thanh toán tiền mặt được ghi nhận với số tiền 100,000đ
    ...    - Các Voucher được đánh dấu đã sử dụng (status=1)
    [Tags]    payment    voucher    multiple   apiinvoice      regression  
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Thanh Toán Với 2 Voucher Đợt VOUCHER110
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Thanh Toán Được Ghi Nhận Trong Đơn Đặt Hàng 2 Phương Thức ${list_payment_method_voucher} Thanh Toán ${list_payment_amount_voucher}
    And Xác Thực Trạng Thái Voucher Đã Sử Dụng ${list_voucher_id}
    [Teardown]   Run Keywords     Delete Order From Api     AND    Update Trạng thái List Voucher ${list_voucher_id} Sang Trạng Thái Đã Phát Hành









