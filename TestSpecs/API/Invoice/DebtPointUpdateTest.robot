*** Settings ***
Documentation     Test cases API cho phần cập nhật công nợ và điểm thưởng
Resource          ../../../Keywords/Invoice/DebtPointUpdateKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    DebtPointUpdateTest

*** Test Cases ***
RT-DPU-001 Tạo hóa đơn không thanh toán và tăng công nợ khách hàng
    [Documentation]    Kiểm tra cập nhật công nợ khi tạo hóa đơn mà không thanh toán
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Không có thanh toán
    ...    - Logic xử lý:
    ...    - Công nợ khách hàng = Công nợ cũ + (Tổng tiền - Tổng thanh toán)
    ...    - Công nợ cũ = 0đ
    ...    - Công nợ mới = 0đ + (100,000đ - 0đ) = 100,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Công nợ khách hàng tăng 100,000đ
    ...    - Hóa đơn có công nợ = 100,000đ
    ...    - Hóa đơn có tổng thanh toán = 0đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong CSDL
    And Công nợ khách hàng ${DEFAULT_CUSTOMER_ID} tăng 100000
    And Công nợ của hóa đơn là 100000
    And Tổng thanh toán của hóa đơn là 0

RT-DPU-002 Tạo hóa đơn với thanh toán một phần và tăng công nợ khách hàng
    [Documentation]    Kiểm tra cập nhật công nợ khi tạo hóa đơn thanh toán một phần
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Thanh toán tiền mặt = 50,000đ
    ...    - Logic xử lý:
    ...    - Công nợ khách hàng = Công nợ cũ + (Tổng tiền - Tổng thanh toán)
    ...    - Công nợ cũ = 0đ
    ...    - Công nợ mới = 0đ + (100,000đ - 50,000đ) = 50,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Công nợ khách hàng tăng 50,000đ
    ...    - Hóa đơn có công nợ = 50,000đ
    ...    - Hóa đơn có tổng thanh toán = 50,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Một Phần
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong CSDL
    And Công nợ khách hàng ${DEFAULT_CUSTOMER_ID} tăng 50000
    And Công nợ của hóa đơn là 50000
    And Tổng thanh toán của hóa đơn là 50000
    And Xác Thực Chi Tiết Thanh Toán    ${PAYMENT_CASH}    50000

RT-DPU-003 Tạo hóa đơn với thanh toán đầy đủ và không tăng công nợ
    [Documentation]    Kiểm tra không cập nhật công nợ khi tạo hóa đơn thanh toán đầy đủ
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Thanh toán tiền mặt = 100,000đ
    ...    - Logic xử lý:
    ...    - Công nợ khách hàng = Công nợ cũ + (Tổng tiền - Tổng thanh toán)
    ...    - Công nợ cũ = 0đ 
    ...    - Công nợ mới = 0đ + (100,000đ - 100,000đ) = 0đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Công nợ khách hàng không thay đổi
    ...    - Hóa đơn có công nợ = 0đ
    ...    - Hóa đơn có tổng thanh toán = 100,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Đầy Đủ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong CSDL
    And Xác Thực Công Nợ Khách Hàng    ${DEFAULT_CUSTOMER_ID}    0
    And Công nợ của hóa đơn là 0
    And Tổng thanh toán của hóa đơn là 100000
    And Xác Thực Chi Tiết Thanh Toán    ${PAYMENT_CASH}    100000

RT-DPU-004 Tạo hóa đơn với thanh toán thừa và hiển thị dư tiền
    [Documentation]    Kiểm tra cập nhật khi tạo hóa đơn thanh toán thừa
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Thanh toán tiền mặt = 150,000đ
    ...    - Logic xử lý:
    ...    - Công nợ khách hàng = Công nợ cũ + (Tổng tiền - Tổng thanh toán)
    ...    - Công nợ cũ = 0đ
    ...    - Công nợ mới = 0đ + min(0, 100,000đ - 150,000đ) = 0đ (công nợ không âm)
    ...    - Tiền dư = 150,000đ - 100,000đ = 50,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Công nợ khách hàng không thay đổi
    ...    - Hóa đơn có công nợ = 0đ
    ...    - Hóa đơn có tổng thanh toán = 100,000đ (chỉ ghi nhận đúng số tiền cần thanh toán)
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Thừa
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong CSDL
    And Xác Thực Công Nợ Khách Hàng    ${DEFAULT_CUSTOMER_ID}    0
    And Công nợ của hóa đơn là 0
    And Tổng thanh toán của hóa đơn là 100000
    And Xác Thực Chi Tiết Thanh Toán    ${PAYMENT_CASH}    150000

RT-DPU-005 Tạo hóa đơn với khách hàng đã có công nợ
    [Documentation]    Kiểm tra cập nhật công nợ khách hàng đã có nợ từ trước
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Không có thanh toán
    ...    - Khách hàng đã có công nợ = 50,000đ
    ...    - Logic xử lý:
    ...    - Công nợ khách hàng = Công nợ cũ + (Tổng tiền - Tổng thanh toán)
    ...    - Công nợ cũ = 50,000đ
    ...    - Công nợ mới = 50,000đ + (100,000đ - 0đ) = 150,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Công nợ khách hàng tăng lên 150,000đ
    ...    - Hóa đơn có công nợ = 100,000đ
    ...    - Hóa đơn có tổng thanh toán = 0đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Có Công Nợ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong CSDL
    And Xác Thực Công Nợ Khách Hàng    ${DEBT_CUSTOMER_ID}    150000
    And Công nợ của hóa đơn là 100000
    And Tổng thanh toán của hóa đơn là 0

RT-DPU-006 Tạo hóa đơn với công nợ và tích điểm theo hóa đơn
    [Documentation]    Kiểm tra cập nhật công nợ và điểm thưởng theo hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Thanh toán tiền mặt = 50,000đ
    ...    - MoneyPerPoint = 10,000đ (Mỗi 10,000đ tương đương 1 điểm)
    ...    - Logic xử lý:
    ...    - Công nợ khách hàng = Công nợ cũ + (Tổng tiền - Tổng thanh toán)
    ...    - Công nợ mới = 0đ + (100,000đ - 50,000đ) = 50,000đ
    ...    - Điểm = Floor(Tổng tiền / MoneyPerPoint) = Floor(100,000 / 10,000) = 10 điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Công nợ khách hàng tăng 50,000đ
    ...    - Hóa đơn có công nợ = 50,000đ
    ...    - Hóa đơn có tổng thanh toán = 50,000đ
    ...    - Hóa đơn được ghi nhận với 10 điểm thưởng
    ...    - Điểm khả dụng của khách hàng tăng 10 điểm
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tích Điểm Và Thanh Toán Một Phần
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong CSDL
    And Công nợ khách hàng ${DEFAULT_CUSTOMER_ID} tăng 50000
    And Công nợ của hóa đơn là 50000
    And Tổng thanh toán của hóa đơn là 50000
    And Điểm thưởng của hóa đơn là 10
    And Xác Thực Lịch Sử Điểm Của Khách Hàng    ${DEFAULT_CUSTOMER_ID}    10
    And Xác Thực Điểm Khả Dụng Của Khách Hàng    ${DEFAULT_CUSTOMER_ID}    10

RT-DPU-007 Tạo hóa đơn thanh toán bằng điểm thưởng
    [Documentation]    Kiểm tra thanh toán bằng điểm thưởng và không cập nhật công nợ
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Thanh toán bằng điểm = 20,000đ (tương đương 200 điểm với tỷ lệ 100đ/điểm)
    ...    - Logic xử lý:
    ...    - Khách hàng đã có sẵn đủ điểm (>= 200 điểm)
    ...    - Điểm khả dụng của khách hàng = Điểm cũ - Điểm sử dụng = Điểm cũ - 200
    ...    - Công nợ khách hàng = Công nợ cũ + (Tổng tiền - Tổng thanh toán)
    ...    - Công nợ mới = 0đ + (100,000đ - 20,000đ) = 80,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Công nợ khách hàng tăng 80,000đ
    ...    - Hóa đơn có công nợ = 80,000đ
    ...    - Hóa đơn có tổng thanh toán = 20,000đ
    ...    - Điểm khả dụng của khách hàng giảm 200 điểm
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Bằng Điểm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong CSDL
    And Công nợ khách hàng ${DEFAULT_CUSTOMER_ID} tăng 80000
    And Công nợ của hóa đơn là 80000
    And Tổng thanh toán của hóa đơn là 20000
    And Xác Thực Chi Tiết Thanh Toán    Point    20000
    And Xác Thực Lịch Sử Điểm Của Khách Hàng    ${DEFAULT_CUSTOMER_ID}    200    Decrease

RT-DPU-008 Tạo hóa đơn tích điểm theo sản phẩm và công nợ
    [Documentation]    Kiểm tra tích điểm theo sản phẩm và cập nhật công nợ
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Thanh toán tiền mặt = 50,000đ
    ...    - Sản phẩm có Point = 5, Quantity = 1
    ...    - Logic xử lý:
    ...    - Công nợ khách hàng = Công nợ cũ + (Tổng tiền - Tổng thanh toán)
    ...    - Công nợ mới = 0đ + (100,000đ - 50,000đ) = 50,000đ
    ...    - Điểm = Point * Quantity = 5 * 1 = 5 điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Công nợ khách hàng tăng 50,000đ
    ...    - Hóa đơn có công nợ = 50,000đ
    ...    - Hóa đơn có tổng thanh toán = 50,000đ
    ...    - Hóa đơn được ghi nhận với 5 điểm thưởng
    ...    - Điểm khả dụng của khách hàng tăng 5 điểm
    Given Chuẩn Bị Dữ Liệu Hóa Đơn với sản phẩm có điểm thưởng 5 và số lượng 1
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong CSDL
    And Công nợ khách hàng ${DEFAULT_CUSTOMER_ID} tăng 50000
    And Công nợ của hóa đơn là 50000
    And Tổng thanh toán của hóa đơn là 50000
    And Điểm thưởng của hóa đơn là 5
    And Xác Thực Lịch Sử Điểm Của Khách Hàng    ${DEFAULT_CUSTOMER_ID}    5
    And Xác Thực Điểm Khả Dụng Của Khách Hàng    ${DEFAULT_CUSTOMER_ID}    5

RT-DPU-009 Tạo hóa đơn với giao dịch tiền mặt nhiều lần
    [Documentation]    Kiểm tra cập nhật công nợ với nhiều lần thanh toán tiền mặt
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Thanh toán tiền mặt lần 1 = 30,000đ
    ...    - Thanh toán tiền mặt lần 2 = 20,000đ
    ...    - Logic xử lý:
    ...    - Tổng thanh toán = 30,000đ + 20,000đ = 50,000đ
    ...    - Công nợ khách hàng = Công nợ cũ + (Tổng tiền - Tổng thanh toán)
    ...    - Công nợ mới = 0đ + (100,000đ - 50,000đ) = 50,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Công nợ khách hàng tăng 50,000đ
    ...    - Hóa đơn có công nợ = 50,000đ
    ...    - Hóa đơn có tổng thanh toán = 50,000đ
    ...    - DB có 2 bản ghi thanh toán tiền mặt với giá trị 30,000đ và 20,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn với tổng tiền 100000 và thanh toán 50000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong CSDL
    And Công nợ khách hàng ${DEFAULT_CUSTOMER_ID} tăng 50000
    And Công nợ của hóa đơn là 50000
    And Tổng thanh toán của hóa đơn là 50000

RT-DPU-010 Tạo hóa đơn với tỷ lệ điểm thưởng đặc biệt
    [Documentation]    Kiểm tra tích điểm với tỷ lệ đặc biệt và cập nhật công nợ
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Thanh toán tiền mặt = 50,000đ
    ...    - MoneyPerPoint = 5,000đ (Mỗi 5,000đ tương đương 1 điểm, tỷ lệ đặc biệt)
    ...    - Logic xử lý:
    ...    - Công nợ khách hàng = Công nợ cũ + (Tổng tiền - Tổng thanh toán)
    ...    - Công nợ mới = 0đ + (100,000đ - 50,000đ) = 50,000đ
    ...    - Điểm = Floor(Tổng tiền / MoneyPerPoint) = Floor(100,000 / 5,000) = 20 điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Công nợ khách hàng tăng 50,000đ
    ...    - Hóa đơn có công nợ = 50,000đ
    ...    - Hóa đơn có tổng thanh toán = 50,000đ
    ...    - Hóa đơn được ghi nhận với 20 điểm thưởng
    ...    - Điểm khả dụng của khách hàng tăng 20 điểm
    Given Chuẩn Bị Dữ Liệu Hóa Đơn với điểm thưởng theo hóa đơn 5000 và thanh toán 50000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong CSDL
    And Công nợ khách hàng ${DEFAULT_CUSTOMER_ID} tăng 50000
    And Công nợ của hóa đơn là 50000
    And Tổng thanh toán của hóa đơn là 50000
    And Điểm thưởng của hóa đơn là 20
    And Xác Thực Lịch Sử Điểm Của Khách Hàng    ${DEFAULT_CUSTOMER_ID}    20
    And Xác Thực Điểm Khả Dụng Của Khách Hàng    ${DEFAULT_CUSTOMER_ID}    20

RT-DPU-011 Tạo hóa đơn với cập nhật công nợ và chi tiết thanh toán
    [Documentation]    Kiểm tra chi tiết thanh toán trong DB và cập nhật công nợ
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Thanh toán tiền mặt = 50,000đ
    ...    - Logic xử lý:
    ...    - Công nợ khách hàng = Công nợ cũ + (Tổng tiền - Tổng thanh toán)
    ...    - Công nợ mới = 0đ + (100,000đ - 50,000đ) = 50,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Công nợ khách hàng tăng 50,000đ
    ...    - Hóa đơn có công nợ = 50,000đ
    ...    - Hóa đơn có tổng thanh toán = 50,000đ
    ...    - Bản ghi thanh toán trong DB có Amount = 50,000đ và Method = Cash
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Một Phần
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong CSDL
    And Công nợ khách hàng ${DEFAULT_CUSTOMER_ID} tăng 50000
    And Công nợ của hóa đơn là 50000
    And Tổng thanh toán của hóa đơn là 50000
    And Xác Thực Chi Tiết Thanh Toán    ${PAYMENT_CASH}    50000
    And Xác Thực Không Có Thanh Toán Bằng Phương Thức    Card

RT-DPU-012 Tạo hóa đơn với thanh toán bằng điểm lớn
    [Documentation]    Kiểm tra thanh toán bằng điểm lớn và cập nhật công nợ
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Thanh toán bằng điểm = 50,000đ (tương đương 500 điểm với tỷ lệ 100đ/điểm)
    ...    - Logic xử lý:
    ...    - Khách hàng đã có sẵn đủ điểm (>= 500 điểm)
    ...    - Điểm khả dụng của khách hàng = Điểm cũ - Điểm sử dụng = Điểm cũ - 500
    ...    - Công nợ khách hàng = Công nợ cũ + (Tổng tiền - Tổng thanh toán)
    ...    - Công nợ mới = 0đ + (100,000đ - 50,000đ) = 50,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Công nợ khách hàng tăng 50,000đ
    ...    - Hóa đơn có công nợ = 50,000đ
    ...    - Hóa đơn có tổng thanh toán = 50,000đ
    ...    - Điểm khả dụng của khách hàng giảm 500 điểm
    Given Chuẩn Bị Dữ Liệu Hóa Đơn thanh toán bằng điểm với giá trị 50000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong CSDL
    And Công nợ khách hàng ${DEFAULT_CUSTOMER_ID} tăng 50000
    And Công nợ của hóa đơn là 50000
    And Tổng thanh toán của hóa đơn là 50000
    And Xác Thực Chi Tiết Thanh Toán    Point    50000
    And Xác Thực Lịch Sử Điểm Của Khách Hàng    ${DEFAULT_CUSTOMER_ID}    500    Decrease 