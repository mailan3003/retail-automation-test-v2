*** Settings ***
Documentation     Test cases API cho phần xử lý hoàn tiền khi tạo hóa đơn
Resource          ../../../Keywords/Invoice/RefundProcessingKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    RefundProcessingTest
    # Thiết lập cấu hình mặc định cho các test case
    Thiết Lập Cấu Hình ChangeToDebt    ${TRUE}

*** Test Cases ***
RT-RP-001 Tạo hóa đơn với thanh toán đúng số tiền
    [Documentation]    Kiểm tra tạo hóa đơn với thanh toán đúng số tiền (không phát sinh tiền thừa)
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn: 100,000đ
    ...    - Thanh toán tiền mặt: 100,000đ
    ...    - Logic:
    ...    - Không phát sinh tiền thừa, không tạo phiếu chi
    ...    - Hóa đơn được tạo bình thường với TotalPayment = Total
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với Total = TotalPayment = 100,000đ
    ...    - Không có phiếu chi được tạo
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cơ Bản
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực Tổng Thanh Toán Trong Hóa Đơn    ${invoice_id}    100000
    Xác Thực Không Có Phiếu Chi Được Tạo    ${invoice_id}

RT-RP-002 Tạo hóa đơn với thanh toán vượt quá và cấu hình chuyển tiền thừa thành công nợ
    [Documentation]    Kiểm tra tạo hóa đơn với thanh toán vượt quá và cấu hình chuyển tiền thừa thành công nợ
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn: 100,000đ
    ...    - Thanh toán tiền mặt: 120,000đ
    ...    - Cấu hình: ChangeToDebt = true (tiền thừa chuyển thành công nợ)
    ...    - Logic:
    ...    - Phát sinh tiền thừa 20,000đ
    ...    - Tiền thừa được chuyển thành công nợ âm của khách hàng
    ...    - Không tạo phiếu chi
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với Total = 100,000đ, TotalPayment = 120,000đ
    ...    - Khách hàng có công nợ âm (Debt = -20,000đ)
    ...    - Không có phiếu chi được tạo
    Given Thiết Lập Cấu Hình Chuyển Tiền Thừa Thành Công Nợ Là bật
    And Chuẩn Bị Dữ Liệu Hóa Đơn Với Số Tiền 100000 Và Thanh Toán 120000 Cho Khách Hàng có mã
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tiền Thừa 20000 Được Chuyển Thành Công Nợ Âm

RT-RP-003 Tạo hóa đơn với thanh toán vượt quá và cấu hình trả lại tiền thừa
    [Documentation]    Kiểm tra tạo hóa đơn với thanh toán vượt quá và cấu hình trả lại tiền thừa
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn: 100,000đ
    ...    - Thanh toán tiền mặt: 120,000đ
    ...    - Cấu hình: ChangeToDebt = false (trả lại tiền thừa)
    ...    - Logic:
    ...    - Phát sinh tiền thừa 20,000đ
    ...    - Tiền thừa được trả lại cho khách hàng
    ...    - Tạo phiếu chi với số tiền 20,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với Total = 100,000đ, TotalPayment = 100,000đ
    ...    - Phiếu chi được tạo với Amount = -20,000đ, Method = Cash
    Given Thiết Lập Cấu Hình Chuyển Tiền Thừa Thành Công Nợ Là tắt
    And Chuẩn Bị Dữ Liệu Hóa Đơn Với Số Tiền 100000 Và Thanh Toán 120000 Cho Khách Hàng có mã
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tiền Thừa Trả Lại Là 20000

RT-RP-004 Tạo hóa đơn cho khách lẻ với thanh toán vượt quá
    [Documentation]    Kiểm tra tạo hóa đơn cho khách lẻ (không có khách hàng) với thanh toán vượt quá
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn: 100,000đ
    ...    - Thanh toán tiền mặt: 120,000đ
    ...    - CustomerId = 0 (khách lẻ)
    ...    - Cấu hình: ChangeToDebt = true (không ảnh hưởng vì khách lẻ)
    ...    - Logic:
    ...    - Phát sinh tiền thừa 20,000đ
    ...    - Không thể chuyển thành công nợ vì là khách lẻ
    ...    - Tạo phiếu chi với số tiền 20,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với Total = 100,000đ, TotalPayment = 100,000đ
    ...    - Phiếu chi được tạo với Amount = -20,000đ, Method = Cash
    Given Thiết Lập Cấu Hình Chuyển Tiền Thừa Thành Công Nợ Là bật
    And Chuẩn Bị Dữ Liệu Hóa Đơn Với Số Tiền 100000 Và Thanh Toán 120000 Cho Khách Hàng khách lẻ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tiền Thừa Trả Lại Là 20000

RT-RP-005 Tạo hóa đơn với thanh toán vượt quá bằng nhiều phương thức thanh toán
    [Documentation]    Kiểm tra tạo hóa đơn với thanh toán vượt quá bằng nhiều phương thức thanh toán
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn: 100,000đ
    ...    - Thanh toán tiền mặt: 70,000đ
    ...    - Thanh toán thẻ: 50,000đ
    ...    - Tổng thanh toán: 120,000đ (vượt quá 20,000đ)
    ...    - Cấu hình: ChangeToDebt = false (trả lại tiền thừa)
    ...    - Logic:
    ...    - Phát sinh tiền thừa 20,000đ
    ...    - Tạo phiếu chi tiền mặt với số tiền 20,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với Total = 100,000đ, TotalPayment = 100,000đ
    ...    - Phiếu chi được tạo với Amount = -20,000đ, Method = Cash
    Given Thiết Lập Cấu Hình Chuyển Tiền Thừa Thành Công Nợ Là tắt
    And Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Vượt Quá Nhiều Phương Thức    70000    50000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    ${invoice_id}=    Xác Thực Hóa Đơn Được Tạo Thành Công
    Xác Thực Tiền Thừa Khi Thanh Toán Nhiều Phương Thức    ${invoice_id}    120000    100000

RT-RP-006 Tạo hóa đơn với thanh toán vượt quá bằng thẻ
    [Documentation]    Kiểm tra tạo hóa đơn với thanh toán vượt quá bằng thẻ
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn: 100,000đ
    ...    - Thanh toán thẻ: 120,000đ
    ...    - Cấu hình: ChangeToDebt = false (trả lại tiền thừa)
    ...    - Logic:
    ...    - Phát sinh tiền thừa 20,000đ
    ...    - Tạo phiếu chi tiền mặt với số tiền 20,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với Total = 100,000đ, TotalPayment = 100,000đ
    ...    - Phiếu chi được tạo với Amount = -20,000đ, Method = Cash
    Given Thiết Lập Cấu Hình Chuyển Tiền Thừa Thành Công Nợ Là tắt
    And Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Vượt Quá Bằng Phương Thức Card Với Số Tiền 120000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tiền Thừa Trả Lại Là 20000

RT-RP-007 Tạo hóa đơn với tiền thừa nhỏ
    [Documentation]    Kiểm tra tạo hóa đơn với tiền thừa nhỏ
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn: 100,000đ
    ...    - Thanh toán tiền mặt: 100,100đ (thừa 100đ)
    ...    - Cấu hình: ChangeToDebt = true (tiền thừa chuyển thành công nợ)
    ...    - Logic:
    ...    - Phát sinh tiền thừa nhỏ 100đ
    ...    - Tiền thừa được chuyển thành công nợ âm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với Total = 100,000đ, TotalPayment = 100,100đ
    ...    - Khách hàng có công nợ âm (Debt = -100đ)
    Given Thiết Lập Cấu Hình Chuyển Tiền Thừa Thành Công Nợ Là bật
    And Chuẩn Bị Dữ Liệu Hóa Đơn Với Số Tiền 100000 Và Thanh Toán 100100 Cho Khách Hàng có mã
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tiền Thừa 100 Được Chuyển Thành Công Nợ Âm

RT-RP-008 Tạo hóa đơn với tiền thừa lớn
    [Documentation]    Kiểm tra tạo hóa đơn với tiền thừa lớn
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn: 100,000đ
    ...    - Thanh toán tiền mặt: 500,000đ (thừa 400,000đ)
    ...    - Cấu hình: ChangeToDebt = false (trả lại tiền thừa)
    ...    - Logic:
    ...    - Phát sinh tiền thừa lớn 400,000đ
    ...    - Tạo phiếu chi với số tiền 400,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với Total = 100,000đ, TotalPayment = 100,000đ
    ...    - Phiếu chi được tạo với Amount = -400,000đ, Method = Cash
    Given Thiết Lập Cấu Hình Chuyển Tiền Thừa Thành Công Nợ Là tắt
    And Chuẩn Bị Dữ Liệu Hóa Đơn Với Số Tiền 100000 Và Thanh Toán 500000 Cho Khách Hàng có mã
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tiền Thừa Trả Lại Là 400000

RT-RP-009 Tạo hóa đơn cho khách có mã với tiền thừa khi ChangeToDebt tắt
    [Documentation]    Kiểm tra tạo hóa đơn cho khách có mã với tiền thừa khi cấu hình không chuyển tiền thừa thành công nợ
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn: 100,000đ
    ...    - Thanh toán tiền mặt: 150,000đ (thừa 50,000đ)
    ...    - CustomerId = khách có mã
    ...    - Cấu hình: ChangeToDebt = false (trả lại tiền thừa)
    ...    - Logic:
    ...    - Phát sinh tiền thừa 50,000đ
    ...    - Tạo phiếu chi với số tiền 50,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với Total = 100,000đ, TotalPayment = 100,000đ
    ...    - Phiếu chi được tạo với Amount = -50,000đ, Method = Cash
    ...    - Không có công nợ âm được tạo
    Given Thiết Lập Cấu Hình Chuyển Tiền Thừa Thành Công Nợ Là tắt
    And Chuẩn Bị Dữ Liệu Hóa Đơn Với Số Tiền 100000 Và Thanh Toán 150000 Cho Khách Hàng có mã
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tiền Thừa 50000 Được Trả Lại Bằng Tiền Mặt

RT-RP-010 Tạo hóa đơn cho khách có mã với tiền thừa khi ChangeToDebt bật
    [Documentation]    Kiểm tra tạo hóa đơn cho khách có mã với tiền thừa khi cấu hình chuyển tiền thừa thành công nợ
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn: 100,000đ
    ...    - Thanh toán tiền mặt: 150,000đ (thừa 50,000đ)
    ...    - CustomerId = khách có mã
    ...    - Cấu hình: ChangeToDebt = true (chuyển tiền thừa thành công nợ)
    ...    - Logic:
    ...    - Phát sinh tiền thừa 50,000đ
    ...    - Tiền thừa được chuyển thành công nợ âm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được ghi nhận với Total = 100,000đ, TotalPayment = 150,000đ
    ...    - Khách hàng có công nợ âm (Debt = -50,000đ)
    ...    - Không có phiếu chi được tạo
    Given Thiết Lập Cấu Hình Chuyển Tiền Thừa Thành Công Nợ Là bật
    And Chuẩn Bị Dữ Liệu Hóa Đơn Với Số Tiền 100000 Và Thanh Toán 150000 Cho Khách Hàng có mã
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tiền Thừa 50000 Được Chuyển Thành Công Nợ Âm 