*** Settings ***
Documentation     Test cases API cho phần xử lý mã hóa đơn
Resource          ../../../Keywords/Invoice/InvoiceCodeKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    InvoiceCodeTest

*** Test Cases ***
RT-IC-001 Tạo hóa đơn thành công với mã hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn thành công với mã hợp lệ
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_TEST_0001" (bắt đầu bằng tiền tố HD hợp lệ)
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService.ValidateInvoiceCode kiểm tra tính hợp lệ của mã hóa đơn
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Response chứa ID hóa đơn được tạo thành công
    ...    - Hóa đơn được lưu vào CSDL với mã hóa đơn đúng
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Hợp Lệ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Mã Hóa Đơn    ${INVOICE_ID}    ${VALID_INVOICE_CODE}

RT-IC-002 Tạo hóa đơn thành công với mã Facebook
    [Documentation]    Kiểm tra tạo hóa đơn thành công với mã có tiền tố Facebook (FB)
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "FB_TEST_0001" (bắt đầu bằng tiền tố FB)
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - SaleChannelId: 2 (Facebook)
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService.ValidateInvoiceCode xác thực mã hóa đơn với kênh bán Facebook
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Response chứa ID hóa đơn được tạo thành công
    ...    - Hóa đơn được lưu vào CSDL với mã FB_TEST_0001
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Facebook
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Mã Hóa Đơn    ${INVOICE_ID}    ${VALID_FACEBOOK_CODE}

RT-IC-003 Tạo hóa đơn thành công với mã Lazada
    [Documentation]    Kiểm tra tạo hóa đơn thành công với mã có tiền tố Lazada (LZD)
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "LZD_TEST_0001" (bắt đầu bằng tiền tố LZD)
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - SaleChannelId: 3 (Lazada)
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService.ValidateInvoiceCode xác thực mã hóa đơn với kênh bán Lazada
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Response chứa ID hóa đơn được tạo thành công
    ...    - Hóa đơn được lưu vào CSDL với mã LZD_TEST_0001
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Lazada
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Mã Hóa Đơn    ${INVOICE_ID}    ${VALID_LAZADA_CODE}

RT-IC-004 Tạo hóa đơn thất bại với tiền tố mã không hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi mã hóa đơn không bắt đầu bằng tiền tố hợp lệ
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "XX_TEST_0001" (không bắt đầu bằng tiền tố hợp lệ: HD, LZD, FB)
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService.ValidateInvoiceCode kiểm tra mã có bắt đầu bằng HD, LZD, FB hoặc tiền tố theo cấu hình
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Mã hóa đơn không hợp lệ"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Tiền Tố Không Hợp Lệ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Mã hóa đơn không hợp lệ"

RT-IC-005 Tạo hóa đơn thất bại với mã chứa ký tự đặc biệt
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi mã hóa đơn chứa ký tự đặc biệt
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD@#$_0001" (chứa ký tự đặc biệt @#$)
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService.ValidateInvoiceCode kiểm tra mã không chứa ký tự đặc biệt
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Mã hóa đơn chứa ký tự không hợp lệ"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Chứa Ký Tự Đặc Biệt
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Mã hóa đơn chứa ký tự không hợp lệ"

RT-IC-006 Tạo hóa đơn thất bại với mã rỗng
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi mã hóa đơn bị bỏ trống và không có cấu hình sinh mã tự động
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "" (chuỗi rỗng)
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService.ValidateInvoiceCode kiểm tra mã không được rỗng khi không dùng cấu hình sinh mã tự động
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Mã hóa đơn không được để trống"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Rỗng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Mã hóa đơn không được để trống"

RT-IC-007 Tạo hóa đơn thất bại với mã chứa khoảng trắng
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi mã hóa đơn chứa khoảng trắng
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD TEST 0001" (chứa khoảng trắng)
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService.ValidateInvoiceCode kiểm tra mã không chứa khoảng trắng
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Mã hóa đơn không được chứa khoảng trắng"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Chứa Khoảng Trắng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Mã hóa đơn không được chứa khoảng trắng"

RT-IC-008 Tạo hóa đơn thất bại với mã đã tồn tại
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi mã hóa đơn đã tồn tại trong hệ thống
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HDSDO_000179" (mã đã tồn tại trong DB)
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService kiểm tra xem mã hóa đơn đã tồn tại trong DB chưa
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Mã hóa đơn đã tồn tại"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Đã Tồn Tại
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Mã hóa đơn đã tồn tại"

RT-IC-009 Tạo hóa đơn thất bại với mã quá dài
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi mã hóa đơn vượt quá 50 ký tự
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HDSDO_012345678901234567890123456789012345678901234567890" (51 ký tự)
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService.ValidateInvoiceCode kiểm tra độ dài mã hóa đơn <= 50 ký tự
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Không thể sao chép do mã hóa đơn mới vượt quá 50 kí tự"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Quá Dài
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Không thể sao chép do mã hóa đơn mới vượt quá 50 kí tự"

RT-IC-010 Tạo hóa đơn thành công với sinh mã tự động
    [Documentation]    Kiểm tra tạo hóa đơn thành công khi hệ thống sinh mã tự động
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: null (không cung cấp, hệ thống sẽ sinh tự động)
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService.GetInvoiceCodeAsync sinh mã tự động theo cấu hình của hệ thống
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Response chứa ID hóa đơn được tạo thành công
    ...    - Hóa đơn được lưu vào CSDL với mã được sinh tự động, bắt đầu bằng HD
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sinh Mã Tự Động
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Mã Tự Động    ${INVOICE_ID}

RT-IC-011 Tạo hóa đơn thành công với mã theo phân quyền
    [Documentation]    Kiểm tra tạo hóa đơn thành công khi sử dụng tiền tố mã theo phân quyền
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: null (không cung cấp, hệ thống sẽ sinh tự động)
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - PermissionPrefix: "ABC" (tiền tố theo phân quyền người dùng)
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService.GetInvoiceCodeAsync sinh mã tự động theo tiền tố phân quyền
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Response chứa ID hóa đơn được tạo thành công
    ...    - Hóa đơn được lưu vào CSDL với mã được sinh tự động, bắt đầu bằng ABC
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Theo Phân Quyền
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Mã Tự Động Theo Phân Quyền    ${INVOICE_ID}    ABC 