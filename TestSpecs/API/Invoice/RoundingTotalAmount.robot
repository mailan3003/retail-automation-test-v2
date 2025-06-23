*** Settings ***
Documentation     Test cases API
Resource          ../../../Keywords/Invoice/RoundingTotalAmountKeyword.robot
Library           ../../../Resources/DatabaseLibrary.py

*** Keywords ***


*** Test Cases ***
RT-QT-01 Làm tròn lên (Round up) với Rounding Amount 0.03
    [Documentation]    Kiểm tra tính năng làm tròn xuống
    ...    - Chuẩn bị dữ liệu:
    ...    - Tạo hóa đơn với tổng tiền cần thanh toán là 53000.52 PHP
    ...    - Kỳ vọng:
    ...    - Mã trạng thái phải là 200
    ...    - INVOICE_ID phải tồn tại trong CSDL
    ...    - Tổng tiền hóa đơn trước khi làm tròn phải là 53000.52 PHP
    ...    - Tổng tiền hóa đơn sau khi làm tròn phải là 53000.55 PHP
    ...    - Chênh lệch làm tròn phải là 0.03

    [Tags]    apiroundingtotalamount

    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá 53000.52 PHP Số Lượng 1 Phương Thức Thanh Toán ${PAYMENT_CASH} Với Rounding Amount 0.03
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Tổng Tiền Hóa Đơn Trước Làm Tròn 53000.52
    And Xác Thực Tổng Tiền Hóa Đơn Sau Khi Làm Tròn Phải 53000.55
    And Xác Thực Chênh lệch làm tròn 0.03

RT-QT-02 Làm tròn lên (Round up) với Rounding Amount NULL
    [Documentation]    Kiểm tra tính năng làm tròn xuống
    ...    - Chuẩn bị dữ liệu:
    ...    - Tạo hóa đơn với tổng tiền cần thanh toán là 53000.52 PHP
    ...    - Kỳ vọng:
    ...    - Mã trạng thái phải là 200
    ...    - INVOICE_ID phải tồn tại trong CSDL
    ...    - Tổng tiền hóa đơn trước khi làm tròn phải là 53000.52 PHP
    ...    - Tổng tiền hóa đơn sau khi làm tròn phải là 53000.55 PHP
    ...    - Chênh lệch làm tròn phải là NULL

    [Tags]    apiroundingtotalamount

    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá 53000.52 PHP Số Lượng 1 Phương Thức Thanh Toán ${PAYMENT_CASH} Với Rounding Amount NULL
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Tổng Tiền Hóa Đơn Trước Làm Tròn 53000.52
    And Xác Thực Tổng Tiền Hóa Đơn Sau Khi Làm Tròn Phải 53000.52
    And Xác Thực Chênh lệch làm tròn NULL

RT-QT-03 Làm tròn lên (Round up) với Rounding Amount 0
    [Documentation]    Kiểm tra tính năng làm tròn xuống
    ...    - Chuẩn bị dữ liệu:
    ...    - Tạo hóa đơn với tổng tiền cần thanh toán là 53000.52 PHP
    ...    - Kỳ vọng:
    ...    - Mã trạng thái phải là 200
    ...    - INVOICE_ID phải tồn tại trong CSDL
    ...    - Tổng tiền hóa đơn trước khi làm tròn phải là 53000.52 PHP
    ...    - Tổng tiền hóa đơn sau khi làm tròn phải là 53000.55 PHP
    ...    - Chênh lệch làm tròn phải là 0

    [Tags]    apiroundingtotalamount

    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá 53000.52 PHP Số Lượng 1 Phương Thức Thanh Toán ${PAYMENT_CASH} Với Rounding Amount 0
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Tổng Tiền Hóa Đơn Trước Làm Tròn 53000.52
    And Xác Thực Tổng Tiền Hóa Đơn Sau Khi Làm Tròn Phải 53000.52
    And Xác Thực Chênh lệch làm tròn None

RT-QT-04 Làm tròn lên (Round up) với Rounding Amount Invaild
    [Documentation]    Kiểm tra tính năng làm tròn xuống
    ...    - Chuẩn bị dữ liệu:
    ...    - Tạo hóa đơn với tổng tiền cần thanh toán là 53000.52 PHP
    ...    - Kỳ vọng:
    ...    - Mã trạng thái phải là 200
    ...    - INVOICE_ID phải tồn tại trong CSDL
    ...    - Tổng tiền hóa đơn trước khi làm tròn phải là 53000.52 PHP
    ...    - Tổng tiền hóa đơn sau khi làm tròn phải là 53000.52 PHP
    ...    - Chênh lệch làm tròn phải là None

    [Tags]    apiroundingtotalamount

    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá 53000.52 PHP Số Lượng 1 Phương Thức Thanh Toán ${PAYMENT_CASH} Với Rounding Amount abc
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Tổng Tiền Hóa Đơn Trước Làm Tròn 53000.52
    And Xác Thực Tổng Tiền Hóa Đơn Sau Khi Làm Tròn Phải 53000.52
    And Xác Thực Chênh lệch làm tròn None