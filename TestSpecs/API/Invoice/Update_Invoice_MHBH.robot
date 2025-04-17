*** Settings ***
Documentation     Test cases API cho phần cập nhật thanh toán hóa đơn
Resource          ../../../Keywords/Invoice/PaymentUpdateKeywords.robot
Resource          ../../../TestData/Invoice/PaymentUpdateData.robot
Resource          ../../../TestData/CommonData.robot
Library           ../../../Resources/DatabaseLibrary.py
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    PaymentUpdateTest

*** Test Cases ***
RT-PU-001 Cập nhật thanh toán tiền mặt cho hóa đơn
    [Documentation]    Kiểm tra cập nhật thanh toán bằng tiền mặt cho hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID}
    ...    - Thanh toán bổ sung bằng tiền mặt: 50,000đ
    ...    - Logic cập nhật:
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Công nợ của hóa đơn được cập nhật: Giảm đi 50,000đ
    ...    - Lịch sử thanh toán được lưu vào DB
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Thanh toán mới được thêm vào hóa đơn
    ...    - Công nợ hóa đơn giảm đúng số tiền
    ...    - Mô tả thanh toán lưu đúng nội dung
    Given Chuẩn Bị Dữ Liệu Thanh Toán ${EXISTING_INVOICE_ID} với phương thức ${PAYMENT_CASH} số tiền ${PAYMENT_UPDATE_AMOUNT}
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 200
    And Thanh toán ${EXISTING_INVOICE_ID} với phương thức ${PAYMENT_CASH} số tiền ${PAYMENT_UPDATE_AMOUNT} được lưu trong CSDL
    And Xác Thực Thông Tin Chi Tiết Thanh Toán Trong CSDL    ${EXISTING_INVOICE_ID}    ${PAYMENT_CASH}    ${PAYMENT_UPDATE_AMOUNT}    ${PAYMENT_DESCRIPTION_1}

RT-PU-002 Cập nhật thanh toán bằng thẻ cho hóa đơn
    [Documentation]    Kiểm tra cập nhật thanh toán bằng thẻ cho hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID}
    ...    - Thanh toán bổ sung bằng thẻ: 50,000đ
    ...    - Tài khoản thẻ: ${DEFAULT_BANK_ACCOUNT_ID}
    ...    - Logic cập nhật:
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Công nợ của hóa đơn được cập nhật: Giảm đi 50,000đ
    ...    - Thông tin tài khoản thẻ được lưu
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Thanh toán mới được thêm vào hóa đơn
    ...    - Thông tin tài khoản thẻ được lưu chính xác
    Given Chuẩn Bị Dữ Liệu Thanh Toán Bằng Thẻ
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 200
    And Thanh toán ${EXISTING_INVOICE_ID} với phương thức ${PAYMENT_CARD} số tiền ${PAYMENT_UPDATE_AMOUNT} được lưu trong CSDL
    And Xác Thực Dữ Liệu Thanh Toán Thẻ Trong CSDL    ${EXISTING_INVOICE_ID}    ${PAYMENT_UPDATE_AMOUNT}    ${DEFAULT_BANK_ACCOUNT_ID}

RT-PU-003 Cập nhật thanh toán bằng chuyển khoản cho hóa đơn
    [Documentation]    Kiểm tra cập nhật thanh toán bằng chuyển khoản cho hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID}
    ...    - Thanh toán bổ sung bằng chuyển khoản: 50,000đ
    ...    - Tài khoản: ${DEFAULT_BANK_ACCOUNT_ID}
    ...    - Logic cập nhật:
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Công nợ của hóa đơn được cập nhật: Giảm đi 50,000đ
    ...    - Thông tin tài khoản được lưu
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Thanh toán mới được thêm vào hóa đơn
    ...    - Thông tin tài khoản được lưu chính xác
    Given Chuẩn Bị Dữ Liệu Thanh Toán ${EXISTING_INVOICE_ID} với phương thức ${PAYMENT_TRANSFER} số tiền ${PAYMENT_UPDATE_AMOUNT}
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 200
    And Thanh toán ${EXISTING_INVOICE_ID} với phương thức ${PAYMENT_TRANSFER} số tiền ${PAYMENT_UPDATE_AMOUNT} được lưu trong CSDL

RT-PU-004 Cập nhật thanh toán nhiều phương thức cho hóa đơn
    [Documentation]    Kiểm tra cập nhật thanh toán nhiều phương thức cho hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID}
    ...    - Thanh toán tiền mặt: 20,000đ
    ...    - Thanh toán thẻ: 30,000đ
    ...    - Logic cập nhật:
    ...    - Cả hai thanh toán được thêm vào hóa đơn
    ...    - Công nợ của hóa đơn được cập nhật: Giảm đi 50,000đ
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Cả hai thanh toán được thêm vào hóa đơn
    ...    - Tổng tiền thanh toán bổ sung là 50,000đ
    Given Chuẩn Bị Dữ Liệu Thanh Toán ${EXISTING_INVOICE_ID} với 2 phương thức thanh toán tổng 50000
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 200
    And Hóa đơn ${EXISTING_INVOICE_ID} có tổng 2 phương thức thanh toán
    And Hóa đơn ${EXISTING_INVOICE_ID} có tổng tiền thanh toán là 50000

RT-PU-005 Cập nhật thanh toán vượt quá công nợ cho hóa đơn
    [Documentation]    Kiểm tra cập nhật thanh toán vượt quá công nợ cho hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID}
    ...    - Thanh toán tiền mặt: 200,000đ (lớn hơn công nợ)
    ...    - Logic cập nhật:
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Công nợ của hóa đơn trở thành âm
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Công nợ hóa đơn trở thành âm (dư)
    Given Chuẩn Bị Dữ Liệu Thanh Toán Vượt Quá Công Nợ
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 200
    And Thanh toán ${EXISTING_INVOICE_ID} với phương thức ${PAYMENT_CASH} số tiền 200000 được lưu trong CSDL
    And Hóa đơn ${EXISTING_INVOICE_ID} có công nợ là 0

RT-PU-006 Cập nhật thanh toán cho hóa đơn không tồn tại
    [Documentation]    Kiểm tra cập nhật thanh toán cho hóa đơn không tồn tại
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${INVALID_INVOICE_ID} (không tồn tại)
    ...    - Thanh toán tiền mặt: 50,000đ
    ...    - Logic cập nhật:
    ...    - Hệ thống phát hiện hóa đơn không tồn tại
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 404
    ...    - Thông báo lỗi: "Không tìm thấy hóa đơn"
    Given Chuẩn Bị Dữ Liệu Thanh Toán Với Hóa Đơn Không Tồn Tại
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 404
    And Response Should Have Error "Không tìm thấy hóa đơn"

RT-PU-007 Cập nhật thanh toán với số tiền âm
    [Documentation]    Kiểm tra cập nhật thanh toán với số tiền âm
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID}
    ...    - Thanh toán tiền mặt: -10,000đ
    ...    - Logic cập nhật:
    ...    - Số tiền âm được coi là hoàn tiền
    ...    - Công nợ của hóa đơn tăng lên 10,000đ
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Thanh toán âm được thêm vào hóa đơn
    ...    - Công nợ hóa đơn tăng lên
    Given Chuẩn Bị Dữ Liệu Thanh Toán Với Số Tiền Âm
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 200
    And Thanh toán ${EXISTING_INVOICE_ID} với phương thức ${PAYMENT_CASH} số tiền -10000 được lưu trong CSDL

RT-PU-008 Cập nhật thanh toán với số tiền bằng 0
    [Documentation]    Kiểm tra cập nhật thanh toán với số tiền bằng 0
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID}
    ...    - Thanh toán tiền mặt: 0đ
    ...    - Logic cập nhật:
    ...    - Hệ thống từ chối thêm thanh toán với số tiền bằng 0
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 400
    ...    - Thông báo lỗi: "Số tiền thanh toán phải khác 0"
    Given Chuẩn Bị Dữ Liệu Thanh Toán Với Số Tiền 0
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 400
    And Response Should Have Error "Số tiền thanh toán phải khác 0"

RT-PU-009 Cập nhật thanh toán không có phương thức thanh toán
    [Documentation]    Kiểm tra cập nhật thanh toán không có phương thức thanh toán
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID}
    ...    - Không có phương thức thanh toán nào
    ...    - Logic cập nhật:
    ...    - Hệ thống từ chối yêu cầu do không có phương thức thanh toán
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 400
    ...    - Thông báo lỗi: "Phương thức thanh toán không được để trống"
    Given Chuẩn Bị Dữ Liệu Thanh Toán Tiêu Chuẩn
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 400
    And Response Should Have Error "Phương thức thanh toán không được để trống"

RT-PU-010 Cập nhật thanh toán 3 phương thức khác nhau cho hóa đơn
    [Documentation]    Kiểm tra cập nhật thanh toán với 3 phương thức khác nhau
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID}
    ...    - Thanh toán tiền mặt: 20,000đ
    ...    - Thanh toán thẻ: 20,000đ
    ...    - Thanh toán chuyển khoản: 10,000đ
    ...    - Logic cập nhật:
    ...    - Cả ba thanh toán được thêm vào hóa đơn
    ...    - Công nợ của hóa đơn được cập nhật: Giảm đi 50,000đ
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Cả ba thanh toán được thêm vào hóa đơn
    ...    - Tổng tiền thanh toán bổ sung là 50,000đ
    Given Chuẩn Bị Dữ Liệu Thanh Toán ${EXISTING_INVOICE_ID} với 3 phương thức thanh toán tổng 50000
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 200
    And Hóa đơn ${EXISTING_INVOICE_ID} có tổng 3 phương thức thanh toán
    And Hóa đơn ${EXISTING_INVOICE_ID} có tổng tiền thanh toán là 50000

RT-PU-011 Cập nhật thanh toán cho hóa đơn đã thanh toán đủ
    [Documentation]    Kiểm tra cập nhật thanh toán cho hóa đơn đã thanh toán đủ
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID} (đã thanh toán đủ)
    ...    - Thanh toán tiền mặt: 50,000đ
    ...    - Logic cập nhật:
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Công nợ của hóa đơn trở thành âm
    ...    - Trạng thái hóa đơn vẫn là "Đã thanh toán"
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Công nợ hóa đơn trở thành âm (dư)
    ...    - Trạng thái hóa đơn vẫn là "Đã thanh toán"
    Given Chuẩn Bị Dữ Liệu Thanh Toán Tiền Mặt
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 200
    And Thanh toán ${EXISTING_INVOICE_ID} với phương thức ${PAYMENT_CASH} số tiền ${PAYMENT_UPDATE_AMOUNT} được lưu trong CSDL
    And Hóa đơn ${EXISTING_INVOICE_ID} có trạng thái là ${STATUS_COMPLETED}

RT-PU-012 Cập nhật thanh toán cho hóa đơn chưa thanh toán đủ
    [Documentation]    Kiểm tra cập nhật thanh toán cho hóa đơn chưa thanh toán đủ
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID} (chưa thanh toán đủ)
    ...    - Công nợ hiện tại: 100,000đ
    ...    - Thanh toán tiền mặt: 50,000đ
    ...    - Logic cập nhật:
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Công nợ của hóa đơn giảm còn 50,000đ
    ...    - Trạng thái hóa đơn vẫn là "Chưa thanh toán đủ"
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Công nợ hóa đơn giảm còn 50,000đ
    ...    - Trạng thái hóa đơn vẫn là "Chưa thanh toán đủ"
    Given Chuẩn Bị Dữ Liệu Thanh Toán Tiền Mặt
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 200
    And Thanh toán ${EXISTING_INVOICE_ID} với phương thức ${PAYMENT_CASH} số tiền ${PAYMENT_UPDATE_AMOUNT} được lưu trong CSDL
    And Hóa đơn ${EXISTING_INVOICE_ID} có trạng thái là ${STATUS_PROCESSING}

RT-PU-013 Cập nhật thanh toán đủ cho hóa đơn chưa thanh toán
    [Documentation]    Kiểm tra cập nhật thanh toán đủ cho hóa đơn chưa thanh toán
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID} (chưa thanh toán)
    ...    - Công nợ hiện tại: 100,000đ
    ...    - Thanh toán tiền mặt: 100,000đ
    ...    - Logic cập nhật:
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Công nợ của hóa đơn giảm về 0
    ...    - Trạng thái hóa đơn chuyển sang "Đã thanh toán"
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Công nợ hóa đơn giảm về 0
    ...    - Trạng thái hóa đơn chuyển sang "Đã thanh toán"
    Given Chuẩn Bị Dữ Liệu Thanh Toán ${EXISTING_INVOICE_ID} với phương thức ${PAYMENT_CASH} số tiền 100000
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 200
    And Thanh toán ${EXISTING_INVOICE_ID} với phương thức ${PAYMENT_CASH} số tiền 100000 được lưu trong CSDL
    And Hóa đơn ${EXISTING_INVOICE_ID} có công nợ là 0
    And Hóa đơn ${EXISTING_INVOICE_ID} có trạng thái là ${STATUS_COMPLETED}

RT-PU-014 Cập nhật hoàn tiền cho hóa đơn đã thanh toán
    [Documentation]    Kiểm tra cập nhật hoàn tiền cho hóa đơn đã thanh toán
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID} (đã thanh toán)
    ...    - Công nợ hiện tại: 0đ
    ...    - Thanh toán tiền mặt: -50,000đ (hoàn tiền)
    ...    - Logic cập nhật:
    ...    - Thanh toán âm (hoàn tiền) được thêm vào hóa đơn
    ...    - Công nợ của hóa đơn tăng lên 50,000đ
    ...    - Trạng thái hóa đơn chuyển sang "Chưa thanh toán đủ"
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Thanh toán âm được thêm vào hóa đơn
    ...    - Công nợ hóa đơn tăng lên 50,000đ
    ...    - Trạng thái hóa đơn chuyển sang "Chưa thanh toán đủ"
    Given Chuẩn Bị Dữ Liệu Thanh Toán Với Số Tiền Âm
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 200
    And Thanh toán ${EXISTING_INVOICE_ID} với phương thức ${PAYMENT_CASH} số tiền -10000 được lưu trong CSDL
    And Hóa đơn ${EXISTING_INVOICE_ID} có trạng thái là ${STATUS_PROCESSING}

RT-PU-015 Cập nhật thanh toán với mô tả chi tiết
    [Documentation]    Kiểm tra cập nhật thanh toán với mô tả chi tiết
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID}
    ...    - Thanh toán tiền mặt: 50,000đ
    ...    - Mô tả: "Thanh toán nợ"
    ...    - Logic cập nhật:
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Mô tả thanh toán được lưu chính xác
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Mô tả thanh toán lưu đúng nội dung
    Given Chuẩn Bị Dữ Liệu Thanh Toán Tiền Mặt    ${PAYMENT_UPDATE_AMOUNT}    ${PAYMENT_DESCRIPTION_2}
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 200
    And Thanh toán ${EXISTING_INVOICE_ID} với phương thức ${PAYMENT_CASH} số tiền ${PAYMENT_UPDATE_AMOUNT} được lưu trong CSDL
    And Xác Thực Thông Tin Chi Tiết Thanh Toán Trong CSDL    ${EXISTING_INVOICE_ID}    ${PAYMENT_CASH}    ${PAYMENT_UPDATE_AMOUNT}    ${PAYMENT_DESCRIPTION_2} 