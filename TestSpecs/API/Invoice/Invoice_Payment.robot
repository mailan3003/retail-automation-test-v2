*** Settings ***
Documentation     Test cases API cho phần tạo phiếu thu khi tạo hóa đơn
Resource          ../../../Keywords/Invoice/ReceiptCreationKeywords.robot
Resource          ../../../Keywords/Invoice/RefundProcessingKeywords.robot
Resource          ../../../Keywords/Invoice/InventoryUpdateKeywords.robot
Resource          ../../../Keywords/Invoice/PaymentUpdateKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py


*** Variables ***
@{list_payment_method}   ${PAYMENT_CASH}    ${PAYMENT_CARD}
@{list_payment_amount}   50000      50000
@{list_payment_amount_1}   30000      30000
@{list_payment_method_voucher}  ${PAYMENT_VOUCHER}   ${PAYMENT_VOUCHER}  
@{list_payment_amount_voucher}  100000      100000
*** Test Cases ***
RT-RC-001 Tạo phiếu thu tiền mặt khi tạo hóa đơn
    [Documentation]    Kiểm tra tạo phiếu thu tiền mặt khi tạo hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán: tiền mặt
    ...    - Số tiền thanh toán: 100,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Phiếu thu được tạo trong DB với số tiền 100,000đ
    ...    - Mã phiếu thu bắt đầu với tiền tố "PT"
    ...    - Ngày tạo phiếu thu là ngày hiện tại
    ...    - Tổng tiền thanh toán của hóa đơn = 100,000đ
    ...    - Công nợ của hóa đơn = 0
    [Tags]    payment      smoke   apiinvoice
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Thanh Toán Phương Thức ${PAYMENT_CASH} Với Số Tiền 100000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Phiếu Thu Được Tạo Với Số Tiền 100000
    And Xác Thực Phiếu Thu Có Mã Phù Hợp
    And Xác Thực Ngày Tạo Phiếu Thu Là Ngày Hiện Tại
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 100000
    And Xác Thực Công Nợ Của Hóa Đơn 0

RT-RC-002 Tạo phiếu thu với thanh toán bằng thẻ
    [Documentation]    Kiểm tra tạo phiếu thu với thanh toán bằng thẻ
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán: thẻ
    ...    - Số tiền thanh toán: 100,000đ
    ...    - Tài khoản ngân hàng: ${BANK_ACCOUNT_ID}
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Phiếu thu được tạo trong DB với số tiền 100,000đ
    ...    - Thanh toán bằng thẻ được ghi nhận trong DB
    ...    - Tổng tiền thanh toán của hóa đơn = 100,000đ
    ...    - Công nợ của hóa đơn = 0
    [Tags]    payment      smoke   apiinvoice
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Thanh Toán Phương Thức ${PAYMENT_CARD} Với Số Tiền 100000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Phiếu Thu Được Tạo Với Số Tiền 100000
    And Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${PAYMENT_CARD} Với Số Tiền 100000
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 100000
    And Xác Thực Công Nợ Của Hóa Đơn 0

RT-RC-003 Tạo phiếu thu với thanh toán bằng chuyển khoản
    [Tags]    payment      smoke   apiinvoice
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
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Thanh Toán Phương Thức ${PAYMENT_TRANSFER} Với Số Tiền 100000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Phiếu Thu Được Tạo Với Số Tiền 100000
    And Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${PAYMENT_TRANSFER} Với Số Tiền 100000
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 100000
    And Xác Thực Công Nợ Của Hóa Đơn 0

RT-RC-004 Tạo phiếu thu với nhiều phương thức thanh toán
    [Tags]    payment      smoke   apiinvoice
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
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Phương Thức @{list_payment_method} Với Số Tiền @{list_payment_amount}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${PAYMENT_CASH} Với Số Tiền 50000
    And Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${PAYMENT_CARD} Với Số Tiền 50000
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 100000
    And Xác Thực Công Nợ Của Hóa Đơn 0

RT-RC-005 Tạo phiếu thu với thanh toán thừa
    [Tags]    payment      smoke   apiinvoice
    [Documentation]    Kiểm tra tạo phiếu thu với thanh toán thừa tính vào công nợ khách hàng 
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán: tiền mặt
    ...    - Số tiền thanh toán: 120,000đ (thừa 20,000đ)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Phiếu thu được tạo trong DB với số tiền 120,000đ
    ...    - Tổng tiền thanh toán của hóa đơn = 120,000đ
    ...    - Tiền thừa của hóa đơn = 20,000đ
    ...    - Công nợ của hóa đơn = 0
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Thanh Toán Phương Thức ${PAYMENT_CASH} Với Số Tiền 120000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Phiếu Thu Được Tạo Với Số Tiền 120000
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 120000
    And Xác Thực Công Nợ Của Hóa Đơn 0

RT-RC-006 Tạo phiếu thu với thanh toán thiếu
    [Tags]    payment      smoke   apiinvoice
    [Documentation]    Kiểm tra tạo phiếu thu với thanh toán thiếu
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán: tiền mặt
    ...    - Số tiền thanh toán: 80,000đ (thiếu 20,000đ)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Phiếu thu được tạo trong DB với số tiền 80,000đ
    ...    - Tổng tiền thanh toán của hóa đơn = 80,000đ
    ...    - Công nợ của hóa đơn = 20,000đ
    ...    - Trạng thái thanh toán: 1 (có thanh toán)
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Thanh Toán Phương Thức ${PAYMENT_CASH} Với Số Tiền 80000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Phiếu Thu Được Tạo Với Số Tiền 80000
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 80000
    And Xác Thực Công Nợ Của Hóa Đơn 20000
    And Xác Thực Trạng Thái Thanh Toán Của Hóa Đơn 1

#RT-RC-007 Tạo phiếu thu với mô tả phiếu này không nằm trong 
    # [Documentation]    Kiểm tra tạo phiếu thu với mô tả chi tiết
    # ...    - Dữ liệu đầu vào:
    # ...    - Hóa đơn có tổng tiền = 100,000đ
    # ...    - Phương thức thanh toán: tiền mặt
    # ...    - Số tiền thanh toán: 100,000đ
    # ...    - Mô tả: "Thu tiền hóa đơn bán hàng chi tiết cho khách ${RECEIPT_CUSTOMER_NAME}"
    # ...    - Kỳ vọng:
    # ...    - Status code: 200
    # ...    - Phiếu thu được tạo trong DB với số tiền 100,000đ
    # ...    - Mô tả của phiếu thu trùng khớp với mô tả đầu vào
    # Given Chuẩn Bị Dữ Liệu Thanh Toán Với Mô Tả Chi Tiết    Thu tiền hóa đơn bán hàng chi tiết cho khách ${RECEIPT_CUSTOMER_NAME}
    # When Gửi Yêu Cầu Tạo Hóa Đơn
    # Then Mã trạng thái phải là 200
    # And Nội dung phản hồi trả về phải tồn tại Id
    # And Xác Thực Phiếu Thu Được Tạo Với Số Tiền 100000
    # And Xác Thực Phiếu Thu Có Mô Tả Chính Xác    None    Thu tiền hóa đơn bán hàng chi tiết cho khách ${RECEIPT_CUSTOMER_NAME}

# RT-RC-008 Tạo phiếu thu trực tiếp không qua hóa đơn
#     [Documentation]    Kiểm tra tạo phiếu thu trực tiếp không qua hóa đơn
#     ...    - Dữ liệu đầu vào:
#     ...    - Phiếu thu trực tiếp cho khách hàng
#     ...    - Số tiền: 100,000đ
#     ...    - Loại phiếu thu: 3 (phiếu thu khác)
#     ...    - Kỳ vọng:
#     ...    - Status code: 200
#     ...    - Phiếu thu được tạo trong DB với số tiền 100,000đ
#     ...    - Loại phiếu thu: 3 (phiếu thu khác)
#     Given Chuẩn Bị Dữ Liệu Thanh Toán Trực Tiếp    ${RECEIPT_CUSTOMER_ID}    100000    ${RECEIPT_DESCRIPTION}
#     When Gửi Yêu Cầu Tạo Phiếu Thu Trực Tiếp
#     Then Mã trạng thái phải là 200
#     And Nội dung phản hồi trả về phải tồn tại Id
#     And Xác Thực Phiếu Thu Trực Tiếp Được Tạo    None    100000    ${RECEIPT_TYPE_OTHER}

# RT-RC-009 Tạo phiếu thu thanh toán công nợ
#     [Documentation]    Kiểm tra tạo phiếu thu thanh toán công nợ
#     ...    - Dữ liệu đầu vào:
#     ...    - Phiếu thu thanh toán công nợ cho khách hàng
#     ...    - Số tiền: 100,000đ
#     ...    - Loại phiếu thu: 2 (phiếu thu thanh toán công nợ)
#     ...    - Kỳ vọng:
#     ...    - Status code: 200
#     ...    - Phiếu thu được tạo trong DB với số tiền 100,000đ
#     ...    - Loại phiếu thu: 2 (phiếu thu thanh toán công nợ)
#     Given Chuẩn Bị Dữ Liệu Thanh Toán Công Nợ    ${RECEIPT_CUSTOMER_ID}    100000    ${RECEIPT_DESCRIPTION}
#     When Gửi Yêu Cầu Tạo Phiếu Thu Trực Tiếp
#     Then Mã trạng thái phải là 200
#     And Nội dung phản hồi trả về phải tồn tại Id
#     And Xác Thực Phiếu Thu Trực Tiếp Được Tạo    None    100000    ${RECEIPT_TYPE_PAYMENT}
RT-RC-008 Tạo Hóa đơn với thanh toán bằng wallet với tài khoản
    [Tags]    payment      smoke   apiinvoice
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
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Phương Thức ${PAYMENT_WALLET} Tài khoản ${BANK_WALLET_ID} Với Số Tiền 100000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 100000
    And Xác Thực Công Nợ Của Hóa Đơn 0
    And Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${PAYMENT_WALLET} Với Số Tiền 100000
    And Xác Thực Tài Khoản Wallet ${BANK_WALLET_ID} Được Sử Dụng Khi Thanh Toán

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
    [Tags]    payment      smoke   apiinvoice
    Given Chuẩn Bị Hóa Đơn Thanh Toán Số Tiền 50000 Sử Dụng Điểm 50
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 50000
    And Xác Thực Công Nợ Của Hóa Đơn 50000 
    And Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${PAYMENT_POINT} Với Số Tiền 50000


RT-RC-010 Kiểm tra không tạo phiếu thu khi thanh toán bằng 0 đồng
    [Tags]    payment      smoke   apiinvoice
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

    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Thanh Toán Phương Thức ${PAYMENT_CASH} Với Số Tiền 0
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 0   
    And Xác Thực Công Nợ Của Hóa Đơn 100000

RT-RC-011 Tạo phiếu thu với số tiền lớn
    [Tags]    payment      smoke   apiinvoice
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
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Thanh Toán Phương Thức ${PAYMENT_CASH} Với Số Tiền 9999999
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Phiếu Thu Được Tạo Với Số Tiền 9999999
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 9999999
    And Xác Thực Công Nợ Của Hóa Đơn 0

RT-RC-012 Tạo phiếu thu thanh toán một phần bằng các phương thức khác nhau
    [Tags]    payment      smoke   apiinvoice
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
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Phương Thức @{list_payment_method} Với Số Tiền @{list_payment_amount_1}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${PAYMENT_CASH} Với Số Tiền 30000
    And Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${PAYMENT_CARD} Với Số Tiền 30000
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 60000
    And Xác Thực Công Nợ Của Hóa Đơn 40000 

RT-RC-009 Tạo Hóa đơn với thanh toán bằng voucher
    [Tags]    payment      smoke   apiinvoice
    [Documentation]    Kiểm tra tính giá trị thanh toán khi thanh toán bằng voucher
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 500,000đ
    ...    - Phương thức thanh toán 1 = Voucher, Số tiền = 100,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán = 100,000đ
    ...    - Tiền nợ = 400,000đ
    ...    - Voucher được sử dụng với giá trị 100,000đ
    Given Chuẩn Bị Hóa Đơn Thanh Toán Bằng Voucher Đợt CBVC00002
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 100000
    And Xác Thực Công Nợ Của Hóa Đơn 400000 
    And Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${PAYMENT_VOUCHER} Với Số Tiền 100000

RT-RC-013 Kiểm tra thanh toán với số tiền 0 đồng vẫn tạo phiếu thu
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
    [Tags]    payment    AIGenerated   
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Thanh Toán Phương Thức ${PAYMENT_CASH} Với Số Tiền 0
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Phiếu Thu Được Tạo Với Số Tiền 0
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 0
    And Xác Thực Công Nợ Của Hóa Đơn 100000

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
    [Tags]    payment    point    cash    apiinvoice    smoke
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Điểm Thưởng Và Tiền Mặt
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${PAYMENT_POINT} Với Số Tiền 25000
    And Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${PAYMENT_CASH} Với Số Tiền 75000
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 100000
    And Xác Thực Công Nợ Của Hóa Đơn 0

RT-RC-015 Thanh toán bằng voucher kết hợp với phương thức khác
    [Documentation]    Kiểm tra tính toán thanh toán khi kết hợp voucher với phương thức khác
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán 1: Voucher, mã voucher VOUCHER001, số tiền 30,000đ
    ...    - Phương thức thanh toán 2: Thẻ, số tiền 70,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán của hóa đơn = 100,000đ
    ...    - Thanh toán bằng voucher được ghi nhận số tiền 30,000đ
    ...    - Thanh toán bằng thẻ được ghi nhận số tiền 70,000đ
    ...    - Công nợ của hóa đơn = 0
    [Tags]    payment    voucher    combined    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Voucher Và Thẻ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${PAYMENT_VOUCHER} Với Số Tiền 30000
    And Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${PAYMENT_CARD} Với Số Tiền 70000
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 100000
    And Xác Thực Công Nợ Của Hóa Đơn 0

RT-RC-016 Tạo phiếu thu với tiền thừa khi thanh toán thẻ
    [Documentation]    Kiểm tra tạo phiếu thu với thanh toán thẻ thừa tính vào công nợ khách hàng
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán: thẻ
    ...    - Số tiền thanh toán: 120,000đ (thừa 20,000đ)
    ...    - Tài khoản thẻ: ${BANK_ACCOUNT_ID}
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Phiếu thu được tạo trong DB với số tiền 120,000đ
    ...    - Tổng tiền thanh toán của hóa đơn = 120,000đ
    ...    - Công nợ của hóa đơn = 0
    [Tags]    payment    card    overpayment    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Phương Thức ${PAYMENT_CARD} Tài khoản ${BANK_ACCOUNT_ID} Với Số Tiền 120000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Phiếu Thu Được Tạo Với Số Tiền 120000
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 120000
    And Xác Thực Công Nợ Của Hóa Đơn 0
    And Xác Thực Tài Khoản Wallet ${BANK_ACCOUNT_ID} Được Sử Dụng Khi Thanh Toán

RT-RC-017 Thanh toán chuyển khoản với nhiều tài khoản
    [Documentation]    Kiểm tra tính toán thanh toán khi sử dụng nhiều tài khoản chuyển khoản
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán 1: Chuyển khoản, tài khoản 1, số tiền 50,000đ
    ...    - Phương thức thanh toán 2: Chuyển khoản, tài khoản 2, số tiền 50,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán của hóa đơn = 100,000đ
    ...    - Thanh toán tài khoản 1 được ghi nhận số tiền 50,000đ
    ...    - Thanh toán tài khoản 2 được ghi nhận số tiền 50,000đ
    ...    - Công nợ của hóa đơn = 0
    [Tags]    payment    transfer    multiple_accounts    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Tài Khoản Chuyển Khoản
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 100000
    And Xác Thực Thanh Toán Chuyển Khoản Nhiều Tài Khoản
    And Xác Thực Công Nợ Của Hóa Đơn 0

RT-RC-018 Thanh toán kết hợp ba phương thức thanh toán
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
    [Tags]    payment    multiple_methods    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Ba Phương Thức Thanh Toán
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${PAYMENT_CASH} Với Số Tiền 40000
    And Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${PAYMENT_CARD} Với Số Tiền 30000
    And Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${PAYMENT_TRANSFER} Với Số Tiền 30000
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 100000
    And Xác Thực Công Nợ Của Hóa Đơn 0

RT-RC-019 Tạo phiếu thu với tất cả số tiền thanh toán bằng điểm thưởng
    [Documentation]    Kiểm tra tạo phiếu thu với toàn bộ số tiền thanh toán bằng điểm thưởng
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán: Điểm thưởng
    ...    - Số điểm sử dụng: 100
    ...    - Số tiền thanh toán: 100,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Phiếu thu được tạo trong DB với số tiền 100,000đ
    ...    - Thanh toán điểm được ghi nhận với 100 điểm
    ...    - Tổng tiền thanh toán của hóa đơn = 100,000đ
    ...    - Công nợ của hóa đơn = 0
    [Tags]    payment    point    AIGenerated
    Given Chuẩn Bị Hóa Đơn Thanh Toán Số Tiền 100000 Sử Dụng Điểm 100
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Phiếu Thu Được Tạo Với Số Tiền 100000
    And Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${PAYMENT_POINT} Với Số Tiền 100000
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 100000
    And Xác Thực Công Nợ Của Hóa Đơn 0
    And Xác Thực Điểm Khách Hàng Sử Dụng 100


RT-RC-021 Tạo hóa đơn với điểm khách hàng không đủ
    [Documentation]    Kiểm tra xử lý khi tạo hóa đơn thanh toán bằng điểm nhưng điểm không đủ
    ...    - Dữ liệu đầu vào:
    ...    - Khách hàng có 50 điểm (tương đương 50,000đ)
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán: Điểm thưởng
    ...    - Số điểm sử dụng: 100 (> số điểm hiện có)
    ...    - Kỳ vọng:
    ...    - Status code: 400
    ...    - Response có thông báo lỗi về điểm không đủ
    [Tags]    payment    point    validation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Bằng Điểm Không Đủ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 400
    And Nội dung phản hồi trả về phải có thông báo lỗi điểm không đủ


# Các test case mới cho phần xử lý thanh toán bằng Voucher
RT-GP-010 Thanh toán hóa đơn thành công với Voucher
    [Documentation]    Kiểm tra thanh toán hóa đơn thành công với Voucher
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_VOUCHER001"
    ...    - Tổng tiền: 100,000đ
    ...    - Thanh toán: Voucher 100,000đ
    ...    - Logic xử lý: 
    ...      + InvoiceService.CreateInvoice() tạo Payment với Method="Voucher"
    ...      + VoucherService.ValidateVoucher() xác thực voucher hợp lệ
    ...      + InvoiceVoucherService.BulkCreateInvoiceVoucherAsync() cập nhật trạng thái voucher
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công
    ...    - Thanh toán Voucher được ghi nhận với số tiền 100,000đ
    ...    - Voucher được đánh dấu đã sử dụng (status=1) và gắn với hóa đơn
    [Tags]    payment    voucher    AIGenerated    
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Bằng Voucher ${VOUCHER_CAMPAIGN_ID_1}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Xác Thực Thanh Toán Voucher Hóa Đơn    ${INVOICE_ID}    ${voucher_id}    100000
    And Xác Thực Trạng Thái Voucher Đã Sử Dụng    ${voucher_id}

RT-GP-011 Thanh toán hóa đơn với Voucher vượt quá giá trị hóa đơn
    [Documentation]    Kiểm tra thanh toán hóa đơn với Voucher có giá trị lớn hơn tổng hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_VOUCHER002"
    ...    - Tổng tiền hóa đơn: 50,000đ
    ...    - Thanh toán: Voucher 100,000đ
    ...    - Logic xử lý: 
    ...      + InvoiceService.CreateInvoice() tạo Payment với Method="Voucher"
    ...      + Hệ thống giới hạn số tiền voucher bằng tổng tiền hóa đơn
    ...      + payment.Amount = Math.Min(payment.Amount, total)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công
    ...    - Thanh toán Voucher được ghi nhận với số tiền 50,000đ (= tổng hóa đơn)
    ...    - Voucher được đánh dấu đã sử dụng (status=1)
    [Tags]    payment    voucher    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giá Thấp Thanh Toán Bằng Voucher ${VOUCHER_CAMPAIGN_ID_1}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Xác Thực Thanh Toán Voucher Hóa Đơn    ${INVOICE_ID}    ${voucher_id}    50000
    And Xác Thực Trạng Thái Voucher Đã Sử Dụng    ${voucher_id}

RT-GP-012 Thanh toán hóa đơn kết hợp Voucher và phương thức khác
    [Documentation]    Kiểm tra thanh toán hóa đơn kết hợp Voucher và tiền mặt
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_VOUCHER003"
    ...    - Tổng tiền: 150,000đ
    ...    - Thanh toán 1: Voucher 50,000đ
    ...    - Thanh toán 2: Tiền mặt 100,000đ
    ...    - Logic xử lý: 
    ...      + InvoiceService.CreateInvoice() tạo các Payment với Method khác nhau
    ...      + Hệ thống tổng hợp tất cả các phương thức thanh toán
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công
    ...    - Thanh toán Voucher được ghi nhận với số tiền 50,000đ
    ...    - Thanh toán tiền mặt được ghi nhận với số tiền 100,000đ
    ...    - Trạng thái thanh toán của hóa đơn là "Đã thanh toán" (1)
    [Tags]    payment    voucher    combined    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Kết Hợp Voucher ${VOUCHER_CAMPAIGN_ID_2} Và Tiền Mặt
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Xác Thực Thanh Toán Voucher Hóa Đơn    ${INVOICE_ID}    ${voucher_id}    50000
    And Xác Thực Thanh Toán Tiền Mặt Hóa Đơn    ${INVOICE_ID}    100000
    And Xác Thực Tổng Tiền Thanh Toán Hóa Đơn    ${INVOICE_ID}    150000
    And Xác Thực Trạng Thái Thanh Toán Hóa Đơn    ${INVOICE_ID}    1

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
    [Tags]    payment    voucher   apiinvoice      
    Given Chuẩn Bị Hóa Đơn Thanh Toán Bằng Voucher Đợt VOUCHER003 Với Mã Voucher ở Trạng Thái Chưa Sử Dụng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Trạng thái voucher AA96OU5QFZ chưa hợp lệ. Voucher phải ở trạng thái Đã phát hành"

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
    [Tags]    payment    voucher   apiinvoice      
    Given Chuẩn Bị Hóa Đơn Thanh Toán Bằng Voucher Đợt VOUCHER003 Với Mã Voucher ở Trạng Thái Đã Sử Dụng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Trạng thái voucher AGXDKFPN9Z chưa hợp lệ. Voucher phải ở trạng thái Đã phát hành"

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
    [Tags]    payment    voucher   apiinvoice      
    Given Chuẩn Bị Hóa Đơn Thanh Toán Bằng Voucher Đợt VOUCHER003 Khi Chưa Đủ Điều Kiện
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Tổng tiền hàng phải lớn hơn 800,000 mới có thể sử dụng voucher A64Z6YUHSZ"

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
   [Tags]    payment    voucher   apiinvoice       
   Given Chuẩn Bị Hóa Đơn Thanh Toán Bằng Voucher Đợt VOUCHERE001
   When Gửi Yêu Cầu Tạo Hóa Đơn
   Then Mã Trạng Thái Phải Là 420
   And Response Should Have Error "Đợt phát hành của voucher AZTOV31PPT chưa được kích hoạt"

Tạo hóa đơn với voucher cho nhóm hàng
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
   [Tags]    API_TAODUOC
   Given Chuẩn Bị Hóa Đơn Thanh Toán Bằng Voucher Đợt VOUCHERNH001
   When Gửi Yêu Cầu Tạo Hóa Đơn
   Then Mã Trạng Thái Phải Là 420

Tạo hóa đơn thanh toán nhiều voucher với đợt phát hành không cho phép sử dụng nhiều lần
    [Documentation]    Kiểm tra xử lý khi tạo hóa đơn thanh toán nhiều voucher với đợt phát hành không cho phép sử dụng nhiều lần
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_VOUCHER007"
    ...    - Tổng tiền: 100,000đ
    ...    - Thanh toán: Voucher 100,000đ    
    ...    - Logic xử lý: 
    ...      + VoucherService.ValidateVoucher() kiểm tra tính hợp lệ và trả về lỗi
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Voucher không hợp lệ hoặc đã được sử dụng"
    [Tags] 
    Given Chuẩn Bị Hóa Đơn Thanh Toán Bằng Voucher Đợt VOUCHER010
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420

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
    [Tags]   apiinvoice  test3244
    Given Chuẩn Bị Hóa Đơn Thanh Toán Bằng Voucher Đợt VOUCHER
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Thời gian giao dịch không phù hợp với thời hạn sử dụng của voucher A4UVPWOBFZ"


RT-GP-014 Thanh toán hóa đơn với nhiều Voucher
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
    [Tags]    payment    voucher    multiple   apiinvoice   test43
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Với 2 Voucher Đợt VOUCHERNH001
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Xác Thực Thanh Toán Được Ghi Nhận 2 Phương Thức ${list_payment_method_voucher} Thanh Toán ${list_payment_amount_voucher}
    And Xác Thực Trạng Thái Voucher Đã Sử Dụng ${list_voucher_id}
    [Teardown]   Tear down Delete Hóa Đơn

RT-GP-015 Thanh toán hóa đơn với Voucher và khuyến mãi
    [Documentation]    Kiểm tra thanh toán hóa đơn với Voucher kết hợp khuyến mãi
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_VOUCHER006"
    ...    - Tổng tiền trước KM: 150,000đ
    ...    - Khuyến mãi: 30,000đ
    ...    - Tổng tiền sau KM: 120,000đ
    ...    - Thanh toán: Voucher 50,000đ, Tiền mặt 70,000đ
    ...    - Logic xử lý: 
    ...      + InvoiceService.ProcessPromotionDiscount() áp dụng khuyến mãi
    ...      + InvoiceService.CreateInvoice() tạo Payment với Method="Voucher"
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công
    ...    - Giảm giá khuyến mãi được ghi nhận với số tiền 30,000đ
    ...    - Thanh toán Voucher được ghi nhận với số tiền 50,000đ
    ...    - Thanh toán tiền mặt được ghi nhận với số tiền 70,000đ
    [Tags]    payment    voucher    promotion    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Bằng Voucher Kết Hợp Khuyến Mãi
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Xác Thực Thanh Toán Voucher Hóa Đơn    ${INVOICE_ID}    ${voucher_id}    50000
    And Xác Thực Thanh Toán Tiền Mặt Hóa Đơn    ${INVOICE_ID}    70000
    And Xác Thực Giảm Giá Khuyến Mãi Hóa Đơn    ${INVOICE_ID}    30000

RT-BP-001 Tạo hóa đơn thất bại với tài khoản ngân hàng không tồn tại
    [Documentation]    Kiểm tra tạo hóa đơn thất bại với tài khoản ngân hàng không tồn tại
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán: thẻ
    ...    - Tài khoản ngân hàng: Tài khoản không tồn tại (ID: ${INVALID_BANK_ACCOUNT_ID})
    ...    - Logic xử lý:
    ...      + BankAccountService.ValidateBankAccount() kiểm tra tài khoản tồn tại và trả về lỗi
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Tài khoản ngân hàng được chọn không tồn tại hoặc đã bị xóa khỏi hệ thống."
    [Tags]    payment    bank_account    validation2    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Phương Thức ${PAYMENT_CARD} Tài khoản ${INVALID_BANK_ACCOUNT_ID} Với Số Tiền 100000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 420
    And Phản hồi phải chứa lỗi "Tài khoản ngân hàng được chọn không tồn tại hoặc đã bị xóa khỏi hệ thống."

RT-BP-002 Tạo hóa đơn thất bại với tài khoản ngân hàng không được phép sử dụng tại chi nhánh
    [Documentation]    Kiểm tra tạo hóa đơn thất bại với tài khoản ngân hàng không được phép sử dụng tại chi nhánh
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán: chuyển khoản
    ...    - Tài khoản ngân hàng: Tài khoản tồn tại nhưng không được phép sử dụng tại chi nhánh hiện tại
    ...    - Logic xử lý:
    ...      + BankAccountService.ValidateBankAccount() kiểm tra tài khoản tồn tại
    ...      + Hệ thống kiểm tra quyền sử dụng tại chi nhánh và trả về lỗi
    ...      + Query: SELECT * FROM BankAccountBranch WHERE BankAccountId = ? AND RetailerId = ?
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Số tài khoản ${INVALID_BRANCH_BANK_ACCOUNT_NUMBER} không được áp dụng cho thanh toán tại chi nhánh ${DEFAULT_BRANCH_NAME}"
    [Tags]    payment    bank_account    validation2    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Phương Thức ${PAYMENT_TRANSFER} Tài khoản ${INVALID_BRANCH_BANK_ACCOUNT_ID} Với Số Tiền 100000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 420
    And Phản hồi phải chứa lỗi "Số tài khoản ${INVALID_BRANCH_BANK_ACCOUNT_NUMBER} không được áp dụng cho thanh toán tại chi nhánh ${DEFAULT_BRANCH_NAME}"

RT-BP-003 Tạo hóa đơn thất bại khi một trong nhiều phương thức thanh toán có tài khoản ngân hàng không hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi một trong nhiều phương thức thanh toán có tài khoản ngân hàng không hợp lệ
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán 1: thẻ, số tiền 50,000đ, tài khoản ngân hàng ID: ${VALID_BANK_ACCOUNT_ID} (hợp lệ)
    ...    - Phương thức thanh toán 2: chuyển khoản, số tiền 50,000đ, tài khoản ngân hàng ID: ${INVALID_BANK_ACCOUNT_ID} (không tồn tại)
    ...    - Logic xử lý:
    ...      + BankAccountService.ValidateBankAccount() kiểm tra tài khoản tồn tại cho mỗi phương thức thanh toán
    ...      + Phương thức 2 sẽ gây lỗi vì tài khoản không tồn tại
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Tài khoản ngân hàng được chọn không tồn tại hoặc đã bị xóa khỏi hệ thống."
    [Tags]    payment    bank_account    validation2    multiple_payment    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Một Phương Thức Thanh Toán Ngân Hàng Không Hợp Lệ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 420
    And Phản hồi phải chứa lỗi "Tài khoản ngân hàng được chọn không tồn tại hoặc đã bị xóa khỏi hệ thống."
