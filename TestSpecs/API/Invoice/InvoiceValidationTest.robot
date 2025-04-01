*** Settings ***
Documentation     Test API kiểm tra và xác thực đầu vào khi tạo hóa đơn
Resource          ../../../Keywords/Invoice/InvoiceValidationKeywords.robot
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    InvoiceValidationTest

*** Test Cases ***
RT-IV-001 Tạo hóa đơn thành công với dữ liệu hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn thành công với dữ liệu đầu vào hợp lệ
    Given Prepare Standard Invoice Request
    When Send Create Invoice Request
    Then Response Status Code Should Be 200
    And Response Should Have Data.Id exist

RT-IV-002 Kiểm tra mã hóa đơn trùng
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với mã đã tồn tại
    Given Prepare Invoice With Duplicate Code
    When Send Create Invoice Request
    Then Response Status Code Should Be 409
    And Response Should Have Error "Mã hóa đơn đã tồn tại"

RT-IV-003 Kiểm tra mã hóa đơn quá dài
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với mã quá dài
    Given Prepare Invoice With Long Code
    When Send Create Invoice Request
    Then Response Status Code Should Be 400
    And Response Should Have Error "Mã hóa đơn không được vượt quá 50 ký tự"

RT-IV-004 Kiểm tra thiếu thông tin chi nhánh
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn thiếu thông tin chi nhánh
    Given Prepare Invoice With Missing Branch
    When Send Create Invoice Request
    Then Response Status Code Should Be 400
    And Response Should Have Error "Vui lòng chọn chi nhánh"

RT-IV-005 Kiểm tra chi nhánh không hợp lệ
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với chi nhánh không tồn tại
    Given Prepare Invoice With Invalid Branch
    When Send Create Invoice Request
    Then Response Status Code Should Be 404
    And Response Should Have Error "Chi nhánh không tồn tại"

RT-IV-006 Kiểm tra khách hàng không thuộc chi nhánh
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với khách hàng không thuộc chi nhánh
    Given Prepare Invoice With Customer From Other Branch
    When Send Create Invoice Request
    Then Response Status Code Should Be 400
    And Response Should Have Error "Khách hàng không thuộc chi nhánh đang chọn"

RT-IV-007 Kiểm tra thiếu thông tin người bán
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn thiếu thông tin người bán
    Given Prepare Invoice With Missing Sold By
    When Send Create Invoice Request
    Then Response Status Code Should Be 400
    And Response Should Have Error "Vui lòng chọn người bán hàng"

RT-IV-008 Kiểm tra người bán không hợp lệ
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với người bán không tồn tại
    Given Prepare Invoice With Invalid Sold By
    When Send Create Invoice Request
    Then Response Status Code Should Be 404
    And Response Should Have Error "Người bán không tồn tại"

RT-IV-009 Kiểm tra ngày tạo hóa đơn trong tương lai
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với ngày trong tương lai
    Given Prepare Invoice With Future Date
    When Send Create Invoice Request
    Then Response Status Code Should Be 400
    And Response Should Have Error "Ngày mua hàng không được lớn hơn ngày hiện tại"

RT-IV-010 Kiểm tra khách hàng có công nợ quá hạn
    [Documentation]    Kiểm tra cảnh báo khi tạo hóa đơn với khách hàng có công nợ quá hạn
    Given Prepare Invoice With Debt Customer
    When Send Create Invoice Request
    Then Response Status Code Should Be 400
    And Response Should Have Error "Khách hàng có công nợ quá hạn, vui lòng thanh toán trước khi mua"

RT-IV-011 Kiểm tra khách hàng vượt hạn mức nợ
    [Documentation]    Kiểm tra cảnh báo khi tạo hóa đơn với khách hàng vượt hạn mức nợ
    Given Prepare Invoice With Debt Limit Customer
    When Send Create Invoice Request
    Then Response Status Code Should Be 400
    And Response Should Have Error "Khách hàng đã vượt hạn mức nợ cho phép"

RT-IV-012 Kiểm tra hóa đơn không có sản phẩm
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn không có sản phẩm
    Given Prepare Invoice With No Details
    When Send Create Invoice Request
    Then Response Status Code Should Be 400
    And Response Should Have Error "Vui lòng chọn ít nhất một sản phẩm"

RT-IV-013 Kiểm tra thiếu thông tin sản phẩm
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với thông tin sản phẩm không đầy đủ
    Given Prepare Invoice With Missing Product Detail
    When Send Create Invoice Request
    Then Response Status Code Should Be 400
    And Response Should Have Error "Vui lòng chọn sản phẩm"

RT-IV-014 Kiểm tra số lượng sản phẩm bằng không
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với số lượng sản phẩm bằng 0
    Given Prepare Invoice With Zero Quantity
    When Send Create Invoice Request
    Then Response Status Code Should Be 400
    And Response Should Have Error "Số lượng phải lớn hơn 0"

RT-IV-015 Kiểm tra số lượng sản phẩm âm
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với số lượng sản phẩm âm
    Given Prepare Invoice With Negative Quantity
    When Send Create Invoice Request
    Then Response Status Code Should Be 400
    And Response Should Have Error "Số lượng phải lớn hơn 0"

RT-IV-016 Kiểm tra giá bán âm
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với giá bán âm
    Given Prepare Invoice With Negative Price
    When Send Create Invoice Request
    Then Response Status Code Should Be 400
    And Response Should Have Error "Giá bán không được nhỏ hơn 0"

RT-IV-017 Kiểm tra sản phẩm không còn hoạt động
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với sản phẩm đã ngừng kinh doanh
    Given Prepare Invoice With Inactive Product
    When Send Create Invoice Request
    Then Response Status Code Should Be 400
    And Response Should Have Error "Sản phẩm đã ngừng kinh doanh"

RT-IV-018 Kiểm tra sản phẩm không tồn tại
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với sản phẩm không tồn tại
    Given Prepare Invoice With Invalid Product
    When Send Create Invoice Request
    Then Response Status Code Should Be 404
    And Response Should Have Error "Sản phẩm không tồn tại"

RT-IV-019 Kiểm tra sản phẩm hết hàng
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với sản phẩm hết hàng
    Given Prepare Invoice With Out Of Stock Product
    When Send Create Invoice Request
    Then Response Status Code Should Be 400
    And Response Should Have Error "Sản phẩm đã hết hàng"

RT-IV-020 Kiểm tra sản phẩm thuốc kê đơn thiếu thông tin đơn thuốc
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với sản phẩm thuốc kê đơn không có thông tin đơn thuốc
    Given Prepare Invoice With Prescription Drug
    When Send Create Invoice Request
    Then Response Status Code Should Be 400
    And Response Should Have Error "Vui lòng cung cấp thông tin đơn thuốc"

RT-IV-021 Kiểm tra sản phẩm combo không đủ hàng
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với sản phẩm combo mà các thành phần không đủ hàng
    Given Prepare Invoice With Combo Product
    When Send Create Invoice Request
    Then Response Status Code Should Be 400
    And Response Should Have Error "Một hoặc nhiều thành phần trong combo không đủ hàng"

RT-IV-022 Kiểm tra thanh toán với số tiền âm
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với phương thức thanh toán có số tiền âm
    Given Prepare Invoice With Negative Payment Amount
    When Send Create Invoice Request
    Then Response Status Code Should Be 400
    And Response Should Have Error "Số tiền thanh toán không được nhỏ hơn 0"

RT-IV-023 Kiểm tra thanh toán với số tiền bằng không
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với phương thức thanh toán có số tiền bằng 0
    Given Prepare Invoice With Zero Payment Amount
    When Send Create Invoice Request
    Then Response Status Code Should Be 400
    And Response Should Have Error "Số tiền thanh toán phải lớn hơn 0"

RT-IV-024 Kiểm tra thanh toán thẻ thiếu thông tin tài khoản
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với phương thức thanh toán thẻ nhưng thiếu thông tin tài khoản
    Given Prepare Invoice With Card Payment Missing Account
    When Send Create Invoice Request
    Then Response Status Code Should Be 400
    And Response Should Have Error "Vui lòng chọn tài khoản ngân hàng"

RT-IV-025 Kiểm tra thanh toán không đủ
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với số tiền thanh toán không đủ
    Given Prepare Invoice With Insufficient Payment
    When Send Create Invoice Request
    Then Response Status Code Should Be 400
    And Response Should Have Error "Số tiền thanh toán không đủ"
