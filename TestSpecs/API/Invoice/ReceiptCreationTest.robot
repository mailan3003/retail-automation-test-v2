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
   # And Xác Thực Tiền Thừa Của Hóa Đơn    None    9899999
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
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Phương Thức Thanh Toán    30000    30000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${PAYMENT_CASH} Với Số Tiền 30000
    And Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${PAYMENT_CARD} Với Số Tiền 30000
    And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 60000
    And Xác Thực Công Nợ Của Hóa Đơn 40000 