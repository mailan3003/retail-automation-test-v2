*** Settings ***
Documentation     Test cases API cho phần tính giá trị thanh toán khi tạo hóa đơn
Resource          ../../../Keywords/Invoice/PaymentCalculationKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    PaymentCalculationTest

*** Test Cases ***
RT-PC-001 Tạo hóa đơn với thanh toán tiền mặt đầy đủ
    [Documentation]    Kiểm tra tính giá trị thanh toán khi thanh toán tiền mặt đầy đủ
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Phương thức thanh toán = Tiền mặt
    ...    - Số tiền thanh toán = 100,000đ
    ...    - Logic tính toán:
    ...    - Tổng thanh toán = 100,000đ
    ...    - Tiền nợ = 0đ (Tổng tiền - Tổng thanh toán = 100,000đ - 100,000đ = 0đ)
    ...    - Trạng thái thanh toán = Đã thanh toán đủ (1)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán = 100,000đ
    ...    - Tiền nợ = 0đ
    ...    - Trạng thái thanh toán = 1
    ...    - Phiếu thu được tạo với số tiền = 100,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tổng tiền thanh toán của hóa đơn là 100000
    And Tiền nợ của hóa đơn là 0
    And Trạng thái thanh toán của hóa đơn là 1
    And Phiếu thu được tạo với số tiền 100000

RT-PC-002 Tạo hóa đơn với thanh toán thẻ đầy đủ
    [Documentation]    Kiểm tra tính giá trị thanh toán khi thanh toán bằng thẻ đầy đủ
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Phương thức thanh toán = Thẻ
    ...    - Số tiền thanh toán = 100,000đ
    ...    - Logic tính toán:
    ...    - Tổng thanh toán = 100,000đ
    ...    - Tiền nợ = 0đ (Tổng tiền - Tổng thanh toán = 100,000đ - 100,000đ = 0đ)
    ...    - Trạng thái thanh toán = Đã thanh toán đủ (1)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán = 100,000đ
    ...    - Tiền nợ = 0đ
    ...    - Trạng thái thanh toán = 1
    ...    - Không có phiếu thu tiền mặt được tạo
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Bằng Thẻ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tổng tiền thanh toán của hóa đơn là 100000
    And Tiền nợ của hóa đơn là 0
    And Trạng thái thanh toán của hóa đơn là 1
    And Thanh toán Card có số tiền 100000
    And Không có phiếu thu nào được tạo

RT-PC-003 Tạo hóa đơn với nhiều phương thức thanh toán
    [Documentation]    Kiểm tra tính giá trị thanh toán khi thanh toán bằng nhiều phương thức
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Phương thức thanh toán 1 = Tiền mặt, Số tiền = 50,000đ
    ...    - Phương thức thanh toán 2 = Thẻ, Số tiền = 50,000đ
    ...    - Logic tính toán:
    ...    - Tổng thanh toán = 50,000đ + 50,000đ = 100,000đ
    ...    - Tiền nợ = 0đ (Tổng tiền - Tổng thanh toán = 100,000đ - 100,000đ = 0đ)
    ...    - Trạng thái thanh toán = Đã thanh toán đủ (1)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán = 100,000đ
    ...    - Tiền nợ = 0đ
    ...    - Trạng thái thanh toán = 1
    ...    - Phiếu thu được tạo với số tiền = 50,000đ (chỉ tính phần tiền mặt)
    ...    - Số lượng thanh toán = 2
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Nhiều Phương Thức
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tổng tiền thanh toán của hóa đơn là 100000
    And Tiền nợ của hóa đơn là 0
    And Trạng thái thanh toán của hóa đơn là 1
    And Số lượng thanh toán của hóa đơn là 2
    And Thanh toán Cash có số tiền 50000
    And Thanh toán Card có số tiền 50000
    And Phiếu thu được tạo với số tiền 50000

RT-PC-004 Tạo hóa đơn với thanh toán thừa
    [Documentation]    Kiểm tra tính giá trị thanh toán khi thanh toán thừa
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Phương thức thanh toán = Tiền mặt
    ...    - Số tiền thanh toán = 120,000đ
    ...    - Logic tính toán:
    ...    - Tổng thanh toán = 120,000đ
    ...    - Tiền nợ = 0đ (Tổng tiền - Tổng thanh toán + Tiền thừa = 100,000đ - 120,000đ + 20,000đ = 0đ)
    ...    - Tiền thừa = 20,000đ (Tổng thanh toán - Tổng tiền = 120,000đ - 100,000đ = 20,000đ)
    ...    - Trạng thái thanh toán = Đã thanh toán đủ (1)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán = 120,000đ
    ...    - Tiền nợ = 0đ
    ...    - Tiền thừa = 20,000đ
    ...    - Trạng thái thanh toán = 1
    ...    - Phiếu thu được tạo với số tiền = 120,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Thừa
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tổng tiền thanh toán của hóa đơn là 120000
    And Tiền nợ của hóa đơn là 0
    And Tiền thừa của hóa đơn là 20000
    And Trạng thái thanh toán của hóa đơn là 1
    And Phiếu thu được tạo với số tiền 120000

RT-PC-005 Tạo hóa đơn với thanh toán thiếu
    [Documentation]    Kiểm tra tính giá trị thanh toán khi thanh toán thiếu
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Phương thức thanh toán = Tiền mặt
    ...    - Số tiền thanh toán = 80,000đ
    ...    - Logic tính toán:
    ...    - Tổng thanh toán = 80,000đ
    ...    - Tiền nợ = 20,000đ (Tổng tiền - Tổng thanh toán = 100,000đ - 80,000đ = 20,000đ)
    ...    - Trạng thái thanh toán = Đã thanh toán một phần (2)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán = 80,000đ
    ...    - Tiền nợ = 20,000đ
    ...    - Trạng thái thanh toán = 2
    ...    - Phiếu thu được tạo với số tiền = 80,000đ
    ...    - Công nợ khách hàng tăng 20,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Thiếu
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tổng tiền thanh toán của hóa đơn là 80000
    And Tiền nợ của hóa đơn là 20000
    And Trạng thái thanh toán của hóa đơn là 2
    And Phiếu thu được tạo với số tiền 80000
    And Công nợ của khách hàng tăng 20000

RT-PC-006 Tạo hóa đơn với thanh toán bằng điểm thưởng
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
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Bằng Điểm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tổng tiền thanh toán của hóa đơn là 50000
    And Tiền nợ của hóa đơn là 50000
    And Trạng thái thanh toán của hóa đơn là 2
    And Thanh toán Point có số tiền 50000
    And Khách hàng sử dụng 50 điểm để thanh toán

RT-PC-007 Tạo hóa đơn với thanh toán bằng voucher
    [Documentation]    Kiểm tra tính giá trị thanh toán khi thanh toán bằng voucher
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Phương thức thanh toán 1 = Voucher, Số tiền = 20,000đ
    ...    - Phương thức thanh toán 2 = Tiền mặt, Số tiền = 80,000đ
    ...    - Logic tính toán:
    ...    - Tổng thanh toán = 20,000đ + 80,000đ = 100,000đ
    ...    - Tiền nợ = 0đ (Tổng tiền - Tổng thanh toán = 100,000đ - 100,000đ = 0đ)
    ...    - Trạng thái thanh toán = Đã thanh toán đủ (1)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán = 100,000đ
    ...    - Tiền nợ = 0đ
    ...    - Trạng thái thanh toán = 1
    ...    - Voucher được sử dụng với giá trị 20,000đ
    ...    - Phiếu thu được tạo với số tiền = 80,000đ (chỉ tính phần tiền mặt)
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Bằng Voucher
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tổng tiền thanh toán của hóa đơn là 100000
    And Tiền nợ của hóa đơn là 0
    And Trạng thái thanh toán của hóa đơn là 1
    And Số lượng thanh toán của hóa đơn là 2
    And Thanh toán Voucher có số tiền 20000
    And Thanh toán Cash có số tiền 80000
    And Voucher VOUCHER001 được sử dụng với giá trị 20000
    And Phiếu thu được tạo với số tiền 80000

RT-PC-008 Tạo hóa đơn với thanh toán COD
    [Documentation]    Kiểm tra tính giá trị thanh toán khi thanh toán COD
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Phương thức thanh toán = COD
    ...    - Số tiền thanh toán = 100,000đ
    ...    - Thông tin giao hàng = Được cung cấp đầy đủ
    ...    - Logic tính toán:
    ...    - Tổng thanh toán = 100,000đ
    ...    - Tiền nợ = 0đ (hóa đơn COD không tính công nợ)
    ...    - Trạng thái thanh toán = Đã thanh toán đủ (1)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán = 100,000đ
    ...    - Tiền nợ = 0đ
    ...    - Trạng thái thanh toán = 1
    ...    - Không có phiếu thu được tạo
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán COD
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tổng tiền thanh toán của hóa đơn là 100000
    And Tiền nợ của hóa đơn là 0
    And Trạng thái thanh toán của hóa đơn là 1
    And Thanh toán COD có số tiền 100000
    And Không có phiếu thu nào được tạo

RT-PC-009 Tạo hóa đơn với giảm giá
    [Documentation]    Kiểm tra tính giá trị thanh toán khi hóa đơn có giảm giá
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền ban đầu = 100,000đ
    ...    - Giảm giá = 10,000đ
    ...    - Tổng tiền sau giảm = 90,000đ
    ...    - Phương thức thanh toán = Tiền mặt
    ...    - Số tiền thanh toán = 90,000đ
    ...    - Logic tính toán:
    ...    - Tổng thanh toán = 90,000đ
    ...    - Tiền nợ = 0đ (Tổng tiền - Tổng thanh toán = 90,000đ - 90,000đ = 0đ)
    ...    - Trạng thái thanh toán = Đã thanh toán đủ (1)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền = 90,000đ
    ...    - Tiền giảm giá = 10,000đ
    ...    - Tổng tiền thanh toán = 90,000đ
    ...    - Tiền nợ = 0đ
    ...    - Trạng thái thanh toán = 1
    ...    - Phiếu thu được tạo với số tiền = 90,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Có Giảm Giá
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tổng tiền thanh toán của hóa đơn là 90000
    And Tiền nợ của hóa đơn là 0
    And Trạng thái thanh toán của hóa đơn là 1
    And Phiếu thu được tạo với số tiền 90000

RT-PC-010 Tạo hóa đơn với thuế và phụ phí
    [Documentation]    Kiểm tra tính giá trị thanh toán khi hóa đơn có thuế và phụ phí
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền ban đầu = 100,000đ
    ...    - Phụ phí = 5,000đ
    ...    - Thuế = 10,000đ
    ...    - Tổng tiền cuối = 115,000đ
    ...    - Phương thức thanh toán = Tiền mặt
    ...    - Số tiền thanh toán = 115,000đ
    ...    - Logic tính toán:
    ...    - Tổng thanh toán = 115,000đ
    ...    - Tiền nợ = 0đ (Tổng tiền - Tổng thanh toán = 115,000đ - 115,000đ = 0đ)
    ...    - Trạng thái thanh toán = Đã thanh toán đủ (1)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền = 115,000đ
    ...    - Phụ phí = 5,000đ
    ...    - Thuế = 10,000đ
    ...    - Tổng tiền thanh toán = 115,000đ
    ...    - Tiền nợ = 0đ
    ...    - Trạng thái thanh toán = 1
    ...    - Phiếu thu được tạo với số tiền = 115,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Có Thuế và Phụ Phí
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tổng tiền thanh toán của hóa đơn là 115000
    And Tiền nợ của hóa đơn là 0
    And Trạng thái thanh toán của hóa đơn là 1
    And Phiếu thu được tạo với số tiền 115000

RT-PC-011 Tạo hóa đơn với khách hàng có công nợ tối đa
    [Documentation]    Kiểm tra tính giá trị thanh toán với khách hàng đã đạt hạn mức công nợ tối đa
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Khách hàng đã có công nợ = 900,000đ
    ...    - Hạn mức công nợ = 1,000,000đ
    ...    - Thanh toán = 0đ
    ...    - Logic tính toán:
    ...    - Tổng thanh toán = 0đ
    ...    - Tiền nợ = 100,000đ (Tổng tiền - Tổng thanh toán = 100,000đ - 0đ = 100,000đ)
    ...    - Trạng thái thanh toán = Chưa thanh toán (3)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán = 0đ
    ...    - Tiền nợ = 100,000đ
    ...    - Trạng thái thanh toán = 3
    ...    - Không có phiếu thu được tạo
    ...    - Công nợ khách hàng tăng 100,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Khách Hàng Có Công Nợ Tối Đa
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tổng tiền thanh toán của hóa đơn là 0
    And Tiền nợ của hóa đơn là 100000
    And Trạng thái thanh toán của hóa đơn là 3
    And Không có phiếu thu nào được tạo
    And Công nợ của khách hàng tăng 100000

RT-PC-012 Cập nhật thanh toán cho hóa đơn có sẵn
    [Documentation]    Kiểm tra cập nhật thanh toán cho hóa đơn đã tạo
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn đã tạo với tổng tiền = 100,000đ
    ...    - Thanh toán ban đầu = 50,000đ
    ...    - Tiền nợ ban đầu = 50,000đ
    ...    - Trạng thái ban đầu = Đã thanh toán một phần (2)
    ...    - Số tiền thanh toán bổ sung = 50,000đ
    ...    - Logic tính toán:
    ...    - Tổng thanh toán mới = 50,000đ + 50,000đ = 100,000đ
    ...    - Tiền nợ mới = 0đ (Tổng tiền - Tổng thanh toán = 100,000đ - 100,000đ = 0đ)
    ...    - Trạng thái thanh toán mới = Đã thanh toán đủ (1)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán = 100,000đ
    ...    - Tiền nợ = 0đ
    ...    - Trạng thái thanh toán = 1
    ...    - Phiếu thu bổ sung được tạo với số tiền = 50,000đ
    Given Chuẩn Bị Dữ Liệu Cập Nhật Thanh Toán Cho Hóa Đơn
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 200
    And Tổng tiền thanh toán của hóa đơn là 100000
    And Tiền nợ của hóa đơn là 0
    And Trạng thái thanh toán của hóa đơn là 1
    And Phiếu thu được tạo với số tiền 50000

RT-PC-013 Tạo hóa đơn với tổng tiền là 0
    [Documentation]    Kiểm tra tính giá trị thanh toán khi tổng tiền là 0
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 0đ (có thể do khuyến mãi 100%)
    ...    - Logic tính toán:
    ...    - Tổng thanh toán = 0đ
    ...    - Tiền nợ = 0đ
    ...    - Trạng thái thanh toán = Đã thanh toán đủ (1)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán = 0đ
    ...    - Tiền nợ = 0đ
    ...    - Trạng thái thanh toán = 1
    ...    - Không có phiếu thu được tạo
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tổng Tiền Bằng 0
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tổng tiền thanh toán của hóa đơn là 0
    And Tiền nợ của hóa đơn là 0
    And Trạng thái thanh toán của hóa đơn là 1
    And Không có phiếu thu nào được tạo

RT-PC-014 Tạo hóa đơn không có thanh toán
    [Documentation]    Kiểm tra tính giá trị thanh toán khi không có thanh toán nào
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Không có thanh toán nào
    ...    - Logic tính toán:
    ...    - Tổng thanh toán = 0đ
    ...    - Tiền nợ = 100,000đ (Tổng tiền - Tổng thanh toán = 100,000đ - 0đ = 100,000đ)
    ...    - Trạng thái thanh toán = Chưa thanh toán (3)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán = 0đ
    ...    - Tiền nợ = 100,000đ
    ...    - Trạng thái thanh toán = 3
    ...    - Không có phiếu thu được tạo
    ...    - Công nợ khách hàng tăng 100,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Không Có Thanh Toán
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tổng tiền thanh toán của hóa đơn là 0
    And Tiền nợ của hóa đơn là 100000
    And Trạng thái thanh toán của hóa đơn là 3
    And Không có phiếu thu nào được tạo
    And Công nợ của khách hàng tăng 100000

RT-PC-015 Tạo hóa đơn với kết hợp voucher và khuyến mãi
    [Documentation]    Kiểm tra tính giá trị thanh toán khi kết hợp voucher và khuyến mãi
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền ban đầu = 100,000đ
    ...    - Giảm giá từ khuyến mãi = 10,000đ
    ...    - Giảm giá từ voucher = 20,000đ
    ...    - Tổng tiền sau giảm = 70,000đ
    ...    - Phương thức thanh toán = Tiền mặt
    ...    - Số tiền thanh toán = 70,000đ
    ...    - Logic tính toán:
    ...    - Tổng thanh toán = 70,000đ
    ...    - Tiền nợ = 0đ (Tổng tiền - Tổng thanh toán = 70,000đ - 70,000đ = 0đ)
    ...    - Trạng thái thanh toán = Đã thanh toán đủ (1)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền = 70,000đ
    ...    - Tiền giảm giá = 30,000đ
    ...    - Tổng tiền thanh toán = 70,000đ
    ...    - Tiền nợ = 0đ
    ...    - Trạng thái thanh toán = 1
    ...    - Phiếu thu được tạo với số tiền = 70,000đ
    ...    - Voucher được sử dụng với giá trị 20,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Kết Hợp Voucher Và Khuyến Mãi
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tổng tiền của hóa đơn là 70000
    And Tiền giảm giá của hóa đơn là 30000
    And Tổng tiền thanh toán của hóa đơn là 70000
    And Tiền nợ của hóa đơn là 0
    And Trạng thái thanh toán của hóa đơn là 1
    And Phiếu thu được tạo với số tiền 70000
    And Voucher VOUCHER001 được sử dụng với giá trị 20000

RT-PC-016 Hủy hóa đơn đã thanh toán
    [Documentation]    Kiểm tra tính giá trị thanh toán khi hủy hóa đơn đã thanh toán
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn đã tạo với tổng tiền = 100,000đ
    ...    - Thanh toán = 100,000đ
    ...    - Tiền nợ = 0đ
    ...    - Trạng thái thanh toán = Đã thanh toán đủ (1)
    ...    - Logic tính toán khi hủy:
    ...    - Trạng thái hóa đơn = Đã hủy
    ...    - Phiếu chi được tạo hoàn tiền khách = 100,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Trạng thái hóa đơn = Đã hủy
    ...    - Phiếu chi được tạo với số tiền = 100,000đ
    Given Chuẩn Bị Dữ Liệu Hủy Hóa Đơn Đã Thanh Toán
    When Gửi Yêu Cầu Hủy Hóa Đơn
    Then Response Status Code Should Be 200
    And Trạng thái của hóa đơn là Đã hủy
    And Phiếu chi được tạo với số tiền 100000

RT-PC-017 Hủy hóa đơn thanh toán một phần
    [Documentation]    Kiểm tra tính giá trị thanh toán khi hủy hóa đơn thanh toán một phần
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn đã tạo với tổng tiền = 100,000đ
    ...    - Thanh toán = 50,000đ
    ...    - Tiền nợ = 50,000đ
    ...    - Trạng thái thanh toán = Đã thanh toán một phần (2)
    ...    - Logic tính toán khi hủy:
    ...    - Trạng thái hóa đơn = Đã hủy
    ...    - Phiếu chi được tạo hoàn tiền khách = 50,000đ
    ...    - Công nợ của khách hàng giảm = 50,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Trạng thái hóa đơn = Đã hủy
    ...    - Phiếu chi được tạo với số tiền = 50,000đ
    ...    - Công nợ của khách hàng giảm 50,000đ
    Given Chuẩn Bị Dữ Liệu Hủy Hóa Đơn Thanh Toán Một Phần
    When Gửi Yêu Cầu Hủy Hóa Đơn
    Then Response Status Code Should Be 200
    And Trạng thái của hóa đơn là Đã hủy
    And Phiếu chi được tạo với số tiền 50000
    And Công nợ của khách hàng giảm 50000

RT-PC-018 Tạo hóa đơn với đơn đặt hàng có đặt cọc
    [Documentation]    Kiểm tra tính giá trị thanh toán khi tạo hóa đơn từ đơn đặt hàng có đặt cọc
    ...    - Dữ liệu đầu vào:
    ...    - Đơn đặt hàng có tổng tiền = 100,000đ
    ...    - Tiền đặt cọc = 30,000đ
    ...    - Tạo hóa đơn từ đơn đặt hàng
    ...    - Thanh toán thêm = 70,000đ
    ...    - Logic tính toán:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Tiền đã thanh toán = 30,000đ (từ đặt cọc)
    ...    - Tiền thanh toán thêm = 70,000đ
    ...    - Tổng thanh toán = 100,000đ
    ...    - Tiền nợ = 0đ
    ...    - Trạng thái thanh toán = Đã thanh toán đủ (1)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán = 100,000đ (30,000đ từ đặt cọc + 70,000đ thanh toán thêm)
    ...    - Tiền nợ = 0đ
    ...    - Trạng thái thanh toán = 1
    ...    - Phiếu thu được tạo với số tiền = 70,000đ
    ...    - Đơn đặt hàng được liên kết với hóa đơn
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Từ Đơn Đặt Hàng Có Đặt Cọc
    When Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Đặt Hàng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tổng tiền thanh toán của hóa đơn là 100000
    And Tiền nợ của hóa đơn là 0
    And Trạng thái thanh toán của hóa đơn là 1
    And Phiếu thu được tạo với số tiền 70000
    And Đơn đặt hàng được liên kết với hóa đơn

RT-PC-019 Tạo hóa đơn với thanh toán từ nhiều phiếu
    [Documentation]    Kiểm tra tính giá trị thanh toán khi tạo hóa đơn với thanh toán từ nhiều phiếu
    ...    - Dữ liệu đầu vào:
    ...    - Tổng tiền hóa đơn = 100,000đ
    ...    - Phiếu thanh toán 1 = 30,000đ (Tiền mặt)
    ...    - Phiếu thanh toán 2 = 40,000đ (Thẻ)
    ...    - Phiếu thanh toán 3 = 30,000đ (Chuyển khoản)
    ...    - Logic tính toán:
    ...    - Tổng thanh toán = 30,000đ + 40,000đ + 30,000đ = 100,000đ
    ...    - Tiền nợ = 0đ
    ...    - Trạng thái thanh toán = Đã thanh toán đủ (1)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán = 100,000đ
    ...    - Tiền nợ = 0đ
    ...    - Trạng thái thanh toán = 1
    ...    - Số lượng thanh toán = 3
    ...    - Phiếu thu được tạo với số tiền = 30,000đ (chỉ tính phần tiền mặt)
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Nhiều Phiếu
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Tổng tiền thanh toán của hóa đơn là 100000
    And Tiền nợ của hóa đơn là 0
    And Trạng thái thanh toán của hóa đơn là 1
    And Số lượng thanh toán của hóa đơn là 3
    And Thanh toán Cash có số tiền 30000
    And Thanh toán Card có số tiền 40000
    And Thanh toán Bank có số tiền 30000
    And Phiếu thu được tạo với số tiền 30000

RT-PC-020 Tạo hóa đơn với thanh toán trễ hạn
    [Documentation]    Kiểm tra tính giá trị thanh toán khi thanh toán trễ hạn
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn đã tạo với tổng tiền = 100,000đ
    ...    - Chưa thanh toán
    ...    - Tiền nợ = 100,000đ
    ...    - Hạn thanh toán = 7 ngày trước
    ...    - Thanh toán trễ hạn = 100,000đ
    ...    - Logic tính toán:
    ...    - Tổng thanh toán = 100,000đ
    ...    - Tiền nợ = 0đ
    ...    - Trạng thái thanh toán = Đã thanh toán đủ (1)
    ...    - Trạng thái thanh toán trễ = true
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền thanh toán = 100,000đ
    ...    - Tiền nợ = 0đ
    ...    - Trạng thái thanh toán = 1
    ...    - Trạng thái thanh toán trễ = true
    ...    - Phiếu thu được tạo với số tiền = 100,000đ
    ...    - Công nợ của khách hàng giảm 100,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Trễ Hạn
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 200
    And Tổng tiền thanh toán của hóa đơn là 100000
    And Tiền nợ của hóa đơn là 0
    And Trạng thái thanh toán của hóa đơn là 1
    And Trạng thái thanh toán trễ là true
    And Phiếu thu được tạo với số tiền 100000
    And Công nợ của khách hàng giảm 100000 