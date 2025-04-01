*** Settings ***
Documentation     Test cases API cho phần xác thực dữ liệu đầu vào khi tạo hóa đơn
Resource          ../../../Keywords/Invoice/InputValidationKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    InputValidationTest

*** Test Cases ***
RT-IV-001 Tạo hóa đơn thành công với dữ liệu hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn thành công với dữ liệu đầu vào hợp lệ
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_TEST_001" (bắt đầu bằng tiền tố hợp lệ)
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Response chứa ID hóa đơn được tạo thành công
    ...    - Hóa đơn được lưu vào CSDL
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Chi Tiết Hóa Đơn    ${INVOICE_ID}    ${PRODUCT_1}    1

RT-IV-002 Tạo hóa đơn thất bại với mã không hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi mã hóa đơn không bắt đầu bằng tiền tố hợp lệ
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "XX_INVALID_001" (không bắt đầu bằng tiền tố hợp lệ: HDO, LZD, FB)
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService kiểm tra mã hóa đơn có bắt đầu bằng tiền tố hợp lệ
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Mã hóa đơn không hợp lệ"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Không Hợp Lệ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Mã hóa đơn không hợp lệ"

RT-IV-003 Tạo hóa đơn thất bại với mã đã tồn tại
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi mã hóa đơn đã tồn tại trong hệ thống
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HDSDO_000179" (mã đã tồn tại trong hệ thống)
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService kiểm tra xem mã hóa đơn đã tồn tại trong DB chưa
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Mã hóa đơn đã tồn tại"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Trùng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Mã hóa đơn đã tồn tại"

RT-IV-004 Tạo hóa đơn thất bại với mã dài quá 50 ký tự
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi mã hóa đơn vượt quá 50 ký tự
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HDSDO_012345678901234567890123456789012345678901234567890" (51 ký tự)
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService kiểm tra độ dài mã hóa đơn <= 50 ký tự
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Không thể sao chép do mã hóa đơn mới vượt quá 50 kí tự"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Dài
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Không thể sao chép do mã hóa đơn mới vượt quá 50 kí tự"

RT-IV-005 Cập nhật hóa đơn đã tồn tại
    [Documentation]    Kiểm tra cập nhật thành công hóa đơn đã tồn tại trong hệ thống
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_UPDT001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - UpdateInvoiceId: 1001 (ID hóa đơn cần cập nhật)
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService kiểm tra hóa đơn cần cập nhật tồn tại và không ở trạng thái Void/Failed
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Response chứa ID hóa đơn được cập nhật thành công
    ...    - Hóa đơn mới được lưu vào CSDL
    ...    - Hóa đơn cũ được đánh dấu là đã cập nhật
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Hóa Đơn Cập Nhật    ${INVOICE_ID}    1001

RT-IV-006 Cập nhật hóa đơn đã hủy
    [Documentation]    Kiểm tra cập nhật thất bại khi hóa đơn gốc đã hủy
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_UPDT002"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - UpdateInvoiceId: 521838 (ID của hóa đơn đã hủy)
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService.ValidateInvoiceToVoid kiểm tra trạng thái hóa đơn gốc
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Không thể cập nhật hóa đơn đã hủy"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật    ${UPDATE_VOID_INVOICE}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Không thể cập nhật hóa đơn đã hủy"

RT-IV-007 Cập nhật hóa đơn không tồn tại
    [Documentation]    Kiểm tra cập nhật thất bại khi hóa đơn gốc không tồn tại
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_UPDT003"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - UpdateInvoiceId: 123456789 (ID không tồn tại)
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService kiểm tra tồn tại của hóa đơn cần cập nhật
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Hóa đơn cần cập nhật không tồn tại"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật    ${UPDATE_NONEXISTENT_INVOICE}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Hóa đơn cần cập nhật không tồn tại"

RT-IV-008 Tạo hóa đơn từ đơn hàng hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn thành công từ đơn hàng hợp lệ
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_ORDER001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - OrderId: 130047 (ID đơn hàng hợp lệ)
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService kiểm tra đơn hàng tồn tại, thuộc cùng retailer và có trạng thái hợp lệ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Response chứa ID hóa đơn được tạo thành công
    ...    - Hóa đơn được lưu vào CSDL
    ...    - Trường OrderId trong hóa đơn được set đúng
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Từ Đơn Hàng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Hóa Đơn Từ Đơn Hàng    ${INVOICE_ID}    130047

RT-IV-009 Tạo hóa đơn từ đơn hàng không tồn tại
    [Documentation]    Kiểm tra tạo hóa đơn thất bại từ đơn hàng không tồn tại
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_ORDER002"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - OrderId: 123456789 (ID đơn hàng không tồn tại)
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService kiểm tra tồn tại của đơn hàng
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Đơn hàng không tồn tại"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Từ Đơn Hàng    ${INVALID_ORDER_INVOICE}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Đơn hàng không tồn tại"

RT-IV-010 Tạo hóa đơn từ đơn hàng đã hoàn thành
    [Documentation]    Kiểm tra tạo hóa đơn thất bại từ đơn hàng đã hoàn thành
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_ORDER003"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - OrderId: 1300473 (ID đơn hàng đã hoàn thành/finalized)
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService kiểm tra trạng thái đơn hàng không được là Finalized hoặc Void
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Đơn hàng đã hoàn thành, không thể tạo hóa đơn"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Từ Đơn Hàng    ${FINALIZED_ORDER_INVOICE}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Đơn hàng đã hoàn thành, không thể tạo hóa đơn"

RT-IV-011 Tạo hóa đơn với khách hàng không tồn tại
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi khách hàng không tồn tại
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_CUST001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 123456789 (ID khách hàng không tồn tại)
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: CustomerService kiểm tra tồn tại của khách hàng
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Khách hàng không tồn tại"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Không Tồn Tại
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Khách hàng không tồn tại"

RT-IV-012 Tạo hóa đơn với khách hàng thuộc chi nhánh khác
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi khách hàng thuộc chi nhánh khác
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_CUST002"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 1005 (ID khách hàng thuộc chi nhánh khác)
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService kiểm tra khách hàng thuộc cùng chi nhánh khi cài đặt ManagerCustomerByBranch được bật
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Khách hàng thuộc chi nhánh khác"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Chi Nhánh Khác
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Khách hàng thuộc chi nhánh khác"

RT-IV-013 Tạo hóa đơn với thanh toán bằng điểm
    [Documentation]    Kiểm tra tạo hóa đơn thành công khi thanh toán bằng điểm thưởng
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_POINT001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Phương thức thanh toán: "Point"
    ...    - Số tiền thanh toán: 100,000đ
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService kiểm tra tính năng tích điểm được bật, chức năng đổi điểm được bật và khách hàng có đủ điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Response chứa ID hóa đơn được tạo thành công
    ...    - Hóa đơn được lưu vào CSDL
    ...    - Thanh toán bằng điểm được lưu trong DB
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Bằng Điểm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Thanh Toán Hóa Đơn    ${INVOICE_ID}    Point    100000

RT-IV-014 Tạo hóa đơn COD với thông tin giao hàng hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn COD thành công với thông tin giao hàng hợp lệ
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_COD001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - UsingCod: 1 (bật chế độ COD)
    ...    - Phương thức thanh toán: "COD"
    ...    - Số tiền thanh toán: 100,000đ
    ...    - Thông tin giao hàng:
    ...        - Tên người nhận: "Test Receiver"
    ...        - SĐT: "0987654321"
    ...        - Địa chỉ: "123 Test Street"
    ...        - Đơn vị vận chuyển: ID=1, UseDefaultPartner=true
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: InvoiceService.ConvertInvoiceDelivery kiểm tra và chuyển đổi thông tin giao hàng
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Response chứa ID hóa đơn được tạo thành công
    ...    - Hóa đơn được lưu vào CSDL
    ...    - Thông tin giao hàng được lưu trong DB
    Given Chuẩn Bị Dữ Liệu Hóa Đơn COD
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Thanh Toán Hóa Đơn    ${INVOICE_ID}    COD    100000
    And Xác Thực Thông Tin Giao Hàng    ${INVOICE_ID}

RT-IV-015 Tạo hóa đơn COD với thông tin giao hàng thiếu
    [Documentation]    Kiểm tra tạo hóa đơn COD thất bại khi thiếu thông tin giao hàng
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_COD001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - UsingCod: 1 (bật chế độ COD)
    ...    - Thông tin giao hàng thiếu (không có ReceiverName):
    ...        - SĐT: "0987654321"
    ...        - Địa chỉ: "123 Test Street"
    ...        - Đơn vị vận chuyển: ID=1, UseDefaultPartner=true
    ...    - Logic kiểm tra: InvoiceService.ConvertInvoiceDelivery kiểm tra thông tin người nhận đầy đủ
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Thiếu thông tin người nhận"
    # Tạo DeliveryInfo không hợp lệ - thiếu thông tin người nhận
    &{invalid_delivery_info}=    Create Dictionary
    ...    ReceiverPhone=0987654321
    ...    ReceiverAddress=123 Test Street
    ...    LocationId=${DEFAULT_LOCATION_ID}
    ...    WardId=${DEFAULT_WARD_ID}
    ...    DeliveryBy=1
    ...    UseDefaultPartner=true
    ...    Status=0
    
    Given Chuẩn Bị Dữ Liệu Hóa Đơn COD    ${invalid_delivery_info}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Thiếu thông tin người nhận"

RT-IV-016 Tạo hóa đơn với sản phẩm lô hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn thành công với sản phẩm quản lý theo lô
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm theo lô: ID=6666, SL=1, Giá=100,000đ, BatchId=8888
    ...    - Logic kiểm tra: InvoiceService.ValidateBatchInvoice kiểm tra lô còn hạn sử dụng, có đủ số lượng
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Response chứa ID hóa đơn được tạo thành công
    ...    - Hóa đơn được lưu vào CSDL
    ...    - Thông tin lô được lưu trong DB
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Theo Lô
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Thông Tin Lô    ${INVOICE_ID}    6666    8888

RT-IV-017 Tạo hóa đơn với sản phẩm lô đã hết hạn
    [Documentation]    Kiểm tra tạo hóa đơn thất bại với sản phẩm lô đã hết hạn
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm theo lô: ID=6666, SL=1, Giá=100,000đ, BatchId=9999 (lô đã hết hạn)
    ...    - Logic kiểm tra: InvoiceService.ValidateBatchInvoice kiểm tra lô chưa hết hạn sử dụng
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Lô đã hết hạn"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Theo Lô    ${EXPIRED_BATCH_PRODUCT}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Lô đã hết hạn"

RT-IV-018 Tạo hóa đơn với thanh toán vượt quá tổng tiền
    [Documentation]    Kiểm tra tạo hóa đơn khi có thanh toán vượt quá tổng tiền
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Thanh toán: Phương thức=Cash, Số tiền=200,000đ (vượt quá tổng tiền hóa đơn)
    ...    - Logic kiểm tra: InvoiceService xử lý tiền thừa theo cấu hình (trả lại khách hoặc chuyển thành công nợ âm)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Response chứa ID hóa đơn được tạo thành công
    ...    - Hóa đơn được lưu vào CSDL với giá trị tiền thừa
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Vượt Quá
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Thanh Toán Hóa Đơn    ${INVOICE_ID}    Cash    200000
    And Xác Thực Tiền Thừa    ${INVOICE_ID}    100000

RT-IV-019 Tạo hóa đơn với sổ giá hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn thành công với sổ giá hợp lệ
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_PB001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - PriceBookId: 520107862 (ID sổ giá hợp lệ)
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: PriceBookService kiểm tra sổ giá tồn tại, còn hoạt động và chưa hết hạn
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Response chứa ID hóa đơn được tạo thành công
    ...    - Hóa đơn được lưu vào CSDL với thông tin sổ giá
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sổ Giá
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Thông Tin Sổ Giá    ${INVOICE_ID}    520107862

RT-IV-020 Tạo hóa đơn với sản phẩm combo
    [Documentation]    Kiểm tra tạo hóa đơn thành công với sản phẩm combo
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm combo: ID=4001, SL=1, Giá=300,000đ
    ...    - Logic kiểm tra: InvoiceService.ValidateComboProduct kiểm tra tồn kho của các thành phần trong combo
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Response chứa ID hóa đơn được tạo thành công
    ...    - Hóa đơn được lưu vào CSDL với thông tin sản phẩm combo
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Combo
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Chi Tiết Hóa Đơn    ${INVOICE_ID}    ${COMBO_PRODUCT_ID}    1
    And Xác Thực Thông Tin Combo    ${INVOICE_ID}

RT-IV-021 Tạo hóa đơn với sản phẩm kê đơn không kê đơn
    [Documentation]    Kiểm tra tạo hóa đơn thất bại với sản phẩm kê đơn nhưng không có đơn thuốc
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm kê đơn: ID=2001, SL=1, Giá=50,000đ (sản phẩm thuốc cần đơn không có thông tin đơn thuốc)
    ...    - Logic kiểm tra: InvoiceService.ValidateInvoiceAsync kiểm tra sản phẩm kê đơn phải có đơn thuốc
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Sản phẩm kê đơn phải có đơn thuốc"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Kê Đơn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Sản phẩm kê đơn phải có đơn thuốc"

RT-IV-022 Tạo hóa đơn với sản phẩm không hoạt động
    [Documentation]    Kiểm tra tạo hóa đơn thất bại với sản phẩm không hoạt động
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm không hoạt động: ID=1033707, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: ProductService kiểm tra sản phẩm có trạng thái hoạt động không
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Sản phẩm không hoạt động"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Không Hoạt Động
    When Gửi Yêu Cầu Tạo Hóa Đơn  
    Then Response Status Code Should Be 420
    And Response Should Have Error "Sản phẩm không hoạt động"

RT-IV-027 Tạo hóa đơn với sản phẩm kê đơn không kê đơn
    [Documentation]    Kiểm tra tạo hóa đơn thất bại với sản phẩm kê đơn nhưng không có đơn thuốc
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm kê đơn: ID=2001, SL=1, Giá=50,000đ (sản phẩm thuốc cần đơn không có thông tin đơn thuốc)
    ...    - Logic kiểm tra: InvoiceService.ValidateInvoiceAsync kiểm tra sản phẩm kê đơn phải có đơn thuốc
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Sản phẩm kê đơn phải có đơn thuốc"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Kê Đơn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Sản phẩm kê đơn phải có đơn thuốc"

RT-IV-028 Tạo hóa đơn với sản phẩm không hoạt động
    [Documentation]    Kiểm tra tạo hóa đơn thất bại với sản phẩm không hoạt động
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn: "HD_TEST_001"
    ...    - Chi nhánh ID: 4316
    ...    - Người bán ID: 4119
    ...    - Khách hàng ID: 629661
    ...    - Sản phẩm không hoạt động: ID=1033707, SL=1, Giá=100,000đ
    ...    - Logic kiểm tra: ProductService kiểm tra sản phẩm có trạng thái hoạt động không
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Sản phẩm không hoạt động"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Không Hoạt Động
    When Gửi Yêu Cầu Tạo Hóa Đơn  
    Then Response Status Code Should Be 420
    And Response Should Have Error "Sản phẩm không hoạt động" 