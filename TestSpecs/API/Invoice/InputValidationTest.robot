*** Settings ***
Documentation     Test cases API cho phần xác thực dữ liệu đầu vào khi tạo hóa đơn
Resource          ../../../Keywords/Invoice/InputValidationKeywords.robot
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    InputValidationTest

*** Test Cases ***
RT-IV-001 Tạo hóa đơn thành công với dữ liệu hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn thành công với dữ liệu đầu vào hợp lệ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist

RT-IV-002 Tạo hóa đơn thất bại với mã không hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi mã hóa đơn không bắt đầu bằng tiền tố hợp lệ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Không Hợp Lệ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Mã hóa đơn không hợp lệ"

RT-IV-003 Tạo hóa đơn thất bại với mã đã tồn tại
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi mã hóa đơn đã tồn tại trong hệ thống
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Trùng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Mã hóa đơn đã tồn tại"

RT-IV-004 Tạo hóa đơn thất bại với mã dài quá 50 ký tự
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi mã hóa đơn vượt quá 50 ký tự
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Dài
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Không thể sao chép do mã hóa đơn mới vượt quá 50 kí tự"

RT-IV-005 Cập nhật hóa đơn đã tồn tại
    [Documentation]    Kiểm tra cập nhật thành công hóa đơn đã tồn tại trong hệ thống
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist

RT-IV-006 Cập nhật hóa đơn đã hủy
    [Documentation]    Kiểm tra cập nhật thất bại khi hóa đơn gốc đã hủy
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật    ${UPDATE_VOID_INVOICE}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Không thể cập nhật hóa đơn đã hủy"

RT-IV-007 Cập nhật hóa đơn không tồn tại
    [Documentation]    Kiểm tra cập nhật thất bại khi hóa đơn gốc không tồn tại
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật    ${UPDATE_NONEXISTENT_INVOICE}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Hóa đơn cần cập nhật không tồn tại"

RT-IV-008 Tạo hóa đơn từ đơn hàng hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn thành công từ đơn hàng hợp lệ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Từ Đơn Hàng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist

RT-IV-009 Tạo hóa đơn từ đơn hàng không tồn tại
    [Documentation]    Kiểm tra tạo hóa đơn thất bại từ đơn hàng không tồn tại
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Từ Đơn Hàng    ${INVALID_ORDER_INVOICE}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Đơn hàng không tồn tại"

RT-IV-010 Tạo hóa đơn từ đơn hàng đã hoàn thành
    [Documentation]    Kiểm tra tạo hóa đơn thất bại từ đơn hàng đã hoàn thành
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Từ Đơn Hàng    ${FINALIZED_ORDER_INVOICE}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Đơn hàng đã hoàn thành, không thể tạo hóa đơn"

RT-IV-011 Tạo hóa đơn với khách hàng không tồn tại
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi khách hàng không tồn tại
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Không Tồn Tại
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Khách hàng không tồn tại"

RT-IV-012 Tạo hóa đơn với khách hàng thuộc chi nhánh khác
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi khách hàng thuộc chi nhánh khác
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Chi Nhánh Khác
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Khách hàng thuộc chi nhánh khác"

RT-IV-013 Tạo hóa đơn với thanh toán bằng điểm
    [Documentation]    Kiểm tra tạo hóa đơn thành công khi thanh toán bằng điểm thưởng
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Bằng Điểm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist

RT-IV-014 Tạo hóa đơn COD với thông tin giao hàng hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn COD thành công với thông tin giao hàng hợp lệ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn COD
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist

RT-IV-015 Tạo hóa đơn COD với thông tin giao hàng thiếu
    [Documentation]    Kiểm tra tạo hóa đơn COD thất bại khi thiếu thông tin giao hàng
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

RT-IV-016 Tạo hóa đơn với sản phẩm hết hàng
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi sản phẩm hết hàng
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Hết Hàng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Sản phẩm không đủ số lượng tồn kho"

RT-IV-017 Tạo hóa đơn với serial không hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi serial không hợp lệ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Serial Không Hợp Lệ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Serial không tồn tại hoặc đã bán"

RT-IV-018 Tạo hóa đơn với serial trùng lặp
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi có serial trùng lặp
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Serial Trùng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Serial bị trùng lặp"

RT-IV-019 Tạo hóa đơn với sản phẩm lô hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn thành công với sản phẩm quản lý theo lô
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Theo Lô
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist

RT-IV-020 Tạo hóa đơn với sản phẩm lô đã hết hạn
    [Documentation]    Kiểm tra tạo hóa đơn thất bại với sản phẩm lô đã hết hạn
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Theo Lô    ${EXPIRED_BATCH_PRODUCT}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Lô đã hết hạn"

RT-IV-021 Tạo hóa đơn với thanh toán vượt quá tổng tiền
    [Documentation]    Kiểm tra tạo hóa đơn khi có thanh toán vượt quá tổng tiền
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Vượt Quá
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist

RT-IV-022 Tạo hóa đơn với sổ giá hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn thành công với sổ giá hợp lệ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sổ Giá
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist

RT-IV-023 Tạo hóa đơn với sổ giá không tồn tại
    [Documentation]    Kiểm tra tạo hóa đơn thất bại với sổ giá không tồn tại
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sổ Giá    ${INVALID_PRICEBOOK_INVOICE}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Sổ giá không tồn tại"

RT-IV-024 Tạo hóa đơn với voucher và khuyến mãi khi không cho phép kết hợp
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi sử dụng voucher kết hợp với khuyến mãi không được phép
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Voucher Và Khuyến Mãi
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Không thể sử dụng voucher kết hợp với khuyến mãi"

RT-IV-025 Tạo hóa đơn trùng UUID
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi UUID đã tồn tại
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    Set To Dictionary    ${data}    UUID=${EXISTENT_INVOICE_UUID}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "UUID đã tồn tại"

RT-IV-026 Tạo hóa đơn với sản phẩm combo
    [Documentation]    Kiểm tra tạo hóa đơn thành công với sản phẩm combo
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    &{combo_product}=    Create Dictionary
    ...    ProductId=${COMBO_PRODUCT_ID}
    ...    Quantity=1
    ...    Price=300000
    
    ${details}=    Create List    ${combo_product}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist

RT-IV-027 Tạo hóa đơn với sản phẩm kê đơn không kê đơn
    [Documentation]    Kiểm tra tạo hóa đơn thất bại với sản phẩm kê đơn nhưng không có đơn thuốc
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    &{prescription_product}=    Create Dictionary
    ...    ProductId=${PRESCRIPTION_DRUG_ID}
    ...    Quantity=1
    ...    Price=50000
    
    ${details}=    Create List    ${prescription_product}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Sản phẩm kê đơn phải có đơn thuốc"

RT-IV-028 Tạo hóa đơn với sản phẩm không hoạt động
    [Documentation]    Kiểm tra tạo hóa đơn thất bại với sản phẩm không hoạt động
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    &{inactive_product}=    Create Dictionary
    ...    ProductId=${INACTIVE_PRODUCT_ID}
    ...    Quantity=1
    ...    Price=100000
    
    ${details}=    Create List    ${inactive_product}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Sản phẩm không hoạt động" 