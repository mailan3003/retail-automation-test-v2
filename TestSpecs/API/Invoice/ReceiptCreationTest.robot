*** Settings ***
Documentation     Test cases API cho phần tạo phiếu thu khi tạo hóa đơn
Resource          ../../../Keywords/Invoice/ReceiptCreationKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    ReceiptCreationTest
*** Variables ***
@{list_payment_method}   ${PAYMENT_CASH}    ${PAYMENT_CARD}
@{list_payment_amount}   50000      50000
@{list_payment_amount_1}   30000      30000
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
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Thanh Toán Phương Thức ${PAYMENT_CARD} Với Số Tiền 100000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Phiếu Thu Được Tạo Với Số Tiền 100000
    And Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${PAYMENT_CARD} Với Số Tiền 100000
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 100000
    And Xác Thực Công Nợ Của Hóa Đơn 0

RT-RC-003 Tạo phiếu thu với thanh toán bằng chuyển khoản
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
    #And Xác Thực Tiền Thừa Của Hóa Đơn    None    20000   không có mục lưu DB tính tiền thừa 
    And Xác Thực Công Nợ Của Hóa Đơn 0

RT-RC-006 Tạo phiếu thu với thanh toán thiếu
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
    Given Chuẩn Bị Hóa Đơn Thanh Toán Số Tiền 50000 Sử Dụng Điểm 50
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 50000
    And Xác Thực Công Nợ Của Hóa Đơn 50000 
    And Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${PAYMENT_POINT} Với Số Tiền 50000


RT-RC-010 Kiểm tra không tạo phiếu thu khi thanh toán bằng 0 đồng
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
   # And Xác Thực Không Có Phiếu Thu Được Tạo    # payment k để null nên vẫn sinh ra phiêu thanh toán 0 dồng trong D
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 0   
    And Xác Thực Công Nợ Của Hóa Đơn 100000

RT-RC-011 Tạo phiếu thu với số tiền lớn
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
    [Tags]    payment    point    combined    AIGenerated
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

RT-RC-020 Tạo hóa đơn với số dư nợ lớn hơn công nợ cho phép
    [Documentation]    Kiểm tra xử lý khi tạo hóa đơn có số dư nợ vượt quá công nợ cho phép
    ...    - Dữ liệu đầu vào:
    ...    - Khách hàng có giới hạn công nợ 50,000đ
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán: tiền mặt
    ...    - Số tiền thanh toán: 20,000đ (còn nợ 80,000đ > giới hạn 50,000đ)
    ...    - Kỳ vọng:
    ...    - Status code: 400
    ...    - Response có thông báo lỗi về giới hạn công nợ
    [Tags]    payment    debt_limit    validation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Vượt Giới Hạn Công Nợ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 400
    And Nội dung phản hồi trả về phải có thông báo lỗi công nợ

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

RT-RC-022 Tạo hóa đơn với mã voucher không hợp lệ
    [Documentation]    Kiểm tra xử lý khi tạo hóa đơn thanh toán bằng voucher không hợp lệ
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán: Voucher
    ...    - Mã voucher: INVALID_VOUCHER (không tồn tại)
    ...    - Kỳ vọng:
    ...    - Status code: 400
    ...    - Response có thông báo lỗi về voucher không hợp lệ
    [Tags]    payment    voucher    validation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Bằng Voucher Không Hợp Lệ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 400
    And Nội dung phản hồi trả về phải có thông báo lỗi voucher không hợp lệ

RT-RC-023 Tạo hóa đơn và cập nhật thông tin công nợ khách hàng
    [Documentation]    Kiểm tra cập nhật thông tin công nợ khách hàng khi tạo hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Khách hàng có công nợ ban đầu = 0đ
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán: tiền mặt
    ...    - Số tiền thanh toán: 50,000đ (còn nợ 50,000đ)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Công nợ của hóa đơn = 50,000đ
    ...    - Công nợ của khách hàng được cập nhật thêm 50,000đ
    [Tags]    payment    debt    customer    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Công Nợ Khách Hàng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Phiếu Thu Được Tạo Với Số Tiền 50000
    And Xác Thực Công Nợ Của Hóa Đơn 50000
    And Xác Thực Công Nợ Khách Hàng Tăng 50000
