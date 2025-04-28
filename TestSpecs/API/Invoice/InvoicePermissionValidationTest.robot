*** Settings ***
Resource    ../../../Keywords/Utilities/ResponseHelper.robot
Resource    ../../../Keywords/Invoice/InvoicePermissionValidationKeywords.robot

*** Test Cases ***
RT-INPV-001 Kiểm tra quyền tạo hóa đơn của người dùng
    [Documentation]    Kiểm tra quyền Invoice._Create khi tạo hóa đơn mới
    [Tags]    invoice    validation    permission    create
    Given Chuẩn bị dữ liệu hóa đơn mặc định cho kiểm tra quyền
    When Gửi yêu cầu tạo hóa đơn với token admin
    Then Response Status Code Should Be 200
    And Response Should Have Id exist

RT-INPV-002 Kiểm tra quyền thay đổi người bán khi người tạo khác người bán
    [Documentation]    Kiểm tra quyền Invoice.ModifySeller khi người tạo khác người bán
    [Tags]    invoice    validation    permission    seller
    Given Chuẩn bị dữ liệu hóa đơn với người bán ${invoice_permission_validation_other_seller}
    When Gửi yêu cầu tạo hóa đơn với token admin
    Then Response Status Code Should Be 200
    And Response Should Have SoldById With value ${invoice_permission_validation_other_seller}

RT-INPV-003 Kiểm tra quyền truy cập chi nhánh của người dùng
    [Documentation]    Kiểm tra quyền truy cập chi nhánh khi tạo hóa đơn
    [Tags]    invoice    validation    permission    branch
    Given Chuẩn bị dữ liệu hóa đơn với chi nhánh ${invoice_permission_validation_main_branch}
    When Gửi yêu cầu tạo hóa đơn với token admin
    Then Response Status Code Should Be 200
    And Response Should Have BranchId With value ${invoice_permission_validation_main_branch}

RT-INPV-004 Kiểm tra quyền tạo hóa đơn từ đơn hàng
    [Documentation]    Kiểm tra quyền Order.MakeInvoice khi tạo hóa đơn từ đơn hàng
    [Tags]    invoice    validation    permission    order
    Given Chuẩn bị dữ liệu hóa đơn từ đơn hàng ${invoice_permission_validation_ongoing_order_id}
    When Gửi yêu cầu tạo hóa đơn với token admin
    Then Response Status Code Should Be 200
    And Response Should Have OrderId With value ${invoice_permission_validation_ongoing_order_id}

RT-INPV-005 Kiểm tra điều kiện về ngày không được trước ngày khóa sổ
    [Documentation]    Kiểm tra validate ngày tạo hóa đơn không được trước ngày khóa sổ
    [Tags]    invoice    validation    date    book_closing
    Given Chuẩn bị dữ liệu hóa đơn với ngày ${invoice_permission_validation_past_date}
    When Gửi yêu cầu tạo hóa đơn với token admin
    Then Response Status Code Should Be 400
    And Response Should Have Error "Ngày tạo hóa đơn không được trước ngày khóa sổ"

RT-INPV-006 Kiểm tra điều kiện về ngày không được lớn hơn ngày hiện tại khi NotAllowModifyInvoiceDate
    [Documentation]    Kiểm tra validate ngày hóa đơn không được lớn hơn ngày hiện tại khi có cấu hình NotAllowModifyInvoiceDate
    [Tags]    invoice    validation    date    future
    Given Chuẩn bị dữ liệu hóa đơn với ngày ${invoice_permission_validation_future_date}
    And Chuẩn bị dữ liệu hóa đơn với cấu hình NotAllowModifyInvoiceDate=${invoice_permission_validation_not_allow_modify_date}
    When Gửi yêu cầu tạo hóa đơn với token admin
    Then Response Status Code Should Be 400
    And Response Should Have Error "Ngày hóa đơn không được lớn hơn ngày hiện tại"

RT-INPV-007 Kiểm tra điều kiện về ngày thanh toán không được trước ngày hóa đơn
    [Documentation]    Kiểm tra validate ngày thanh toán không được trước ngày hóa đơn
    [Tags]    invoice    validation    date    payment
    Given Chuẩn bị dữ liệu hóa đơn với ngày 2024-03-01T00:00:00.000Z
    And Chuẩn bị dữ liệu hóa đơn với ngày thanh toán 2024-02-28T00:00:00.000Z
    When Gửi yêu cầu tạo hóa đơn với token admin
    Then Response Status Code Should Be 400
    And Response Should Have Error "Ngày thanh toán không được trước ngày hóa đơn"

RT-INPV-008 Kiểm tra điều kiện về ngày giao hàng dự kiến không được trước ngày hóa đơn
    [Documentation]    Kiểm tra validate ngày giao hàng dự kiến không được trước ngày hóa đơn
    [Tags]    invoice    validation    date    delivery
    Given Chuẩn bị dữ liệu hóa đơn với ngày 2024-03-01T00:00:00.000Z
    And Chuẩn bị dữ liệu hóa đơn với giao hàng dự kiến 2024-02-28T00:00:00.000Z
    When Gửi yêu cầu tạo hóa đơn với token admin
    Then Response Status Code Should Be 400
    And Response Should Have Error "Ngày giao hàng dự kiến không được trước ngày hóa đơn"

RT-INPV-009 Kiểm tra điều kiện về trạng thái đơn hàng không được là Finalized
    [Documentation]    Kiểm tra không cho phép tạo hóa đơn từ đơn hàng đã hoàn thành
    [Tags]    invoice    validation    order    finalized
    Given Chuẩn bị dữ liệu hóa đơn từ đơn hàng ${invoice_permission_validation_finalized_order_id}
    When Gửi yêu cầu tạo hóa đơn với token admin
    Then Response Status Code Should Be 400
    And Response Should Have Error "Không thể tạo hóa đơn từ đơn hàng đã hoàn thành"

RT-INPV-010 Kiểm tra điều kiện về trạng thái đơn hàng không được là Void
    [Documentation]    Kiểm tra không cho phép tạo hóa đơn từ đơn hàng đã hủy
    [Tags]    invoice    validation    order    void
    Given Chuẩn bị dữ liệu hóa đơn từ đơn hàng ${invoice_permission_validation_void_order_id}
    When Gửi yêu cầu tạo hóa đơn với token admin
    Then Response Status Code Should Be 400
    And Response Should Have Error "Không thể tạo hóa đơn từ đơn hàng đã hủy"

RT-INPV-011 Kiểm tra điều kiện về thời gian tạo hóa đơn không được trước thời gian tạo đơn hàng
    [Documentation]    Kiểm tra thời gian tạo hóa đơn không được trước thời gian tạo đơn hàng
    [Tags]    invoice    validation    date    order
    Given Chuẩn bị dữ liệu hóa đơn từ đơn hàng ${invoice_permission_validation_ongoing_order_id}
    And Chuẩn bị dữ liệu hóa đơn với ngày ${invoice_permission_validation_past_date}
    When Gửi yêu cầu tạo hóa đơn với token admin
    Then Response Status Code Should Be 400
    And Response Should Have Error "Thời gian tạo hóa đơn không được trước thời gian tạo đơn hàng"

RT-INPV-012 Kiểm tra quyền truy cập chi nhánh khi kho cấp 2
    [Documentation]    Kiểm tra quyền truy cập vào kho master khi tạo hóa đơn từ kho cấp 2
    [Tags]    invoice    validation    permission    branch    sub_branch
    Given Chuẩn bị dữ liệu hóa đơn với chi nhánh ${invoice_permission_validation_sub_branch}
    When Gửi yêu cầu tạo hóa đơn với token admin
    Then Response Status Code Should Be 200
    And Response Should Have BranchId With value ${invoice_permission_validation_sub_branch}

RT-INPV-013 Kiểm tra quyền truy cập khi khách hàng thuộc chi nhánh quản lý
    [Documentation]    Kiểm tra quyền truy cập khi khách hàng thuộc chi nhánh quản lý với ManagerCustomerByBranch = true
    [Tags]    invoice    validation    permission    customer    branch
    Given Chuẩn bị dữ liệu hóa đơn với khách hàng ${DEBT_CUSTOMER_ID}
    And Chuẩn bị dữ liệu hóa đơn với chi nhánh ${invoice_permission_validation_main_branch}
    When Gửi yêu cầu tạo hóa đơn với token admin
    Then Response Status Code Should Be 200
    And Response Should Have CustomerId With value ${DEBT_CUSTOMER_ID}

RT-INPV-014 Kiểm tra validate định dạng ngày hóa đơn phải có giá trị
    [Documentation]    Kiểm tra validate ngày tạo hóa đơn phải có giá trị
    [Tags]    invoice    validation    date    required
    Given Chuẩn bị dữ liệu hóa đơn mặc định cho kiểm tra quyền
    And Set To Dictionary    ${REQUEST_DATA["Invoice"]}    PurchaseDate=${None}
    When Gửi yêu cầu tạo hóa đơn với token admin
    Then Response Status Code Should Be 400
    And Response Should Have Error "Ngày tạo hóa đơn không được để trống"

RT-INPV-015 Kiểm tra validate ngày tạo hóa đơn phải nhỏ hơn hoặc bằng ngày hiện tại
    [Documentation]    Kiểm tra validate ngày tạo hóa đơn phải nhỏ hơn hoặc bằng ngày hiện tại
    [Tags]    invoice    validation    date    future
    Given Chuẩn bị dữ liệu hóa đơn với ngày ${invoice_permission_validation_future_date}
    When Gửi yêu cầu tạo hóa đơn với token admin
    Then Response Status Code Should Be 400
    And Response Should Have Error "Ngày tạo hóa đơn phải nhỏ hơn hoặc bằng ngày hiện tại" 
    

RT-INPV-016 Kiểm tra quyền phát hành hóa đơn điện tử
    [Documentation]    Kiểm tra quyền phát hành hóa đơn điện tử với tài khoản không có quyền
    ...    - Dữ liệu đầu vào: Hóa đơn hợp lệ, tài khoản không có quyền phát hành hóa đơn điện tử
    ...    - Logic kiểm tra: InvoiceService.ValidateEInvoicePermission kiểm tra quyền phát hành
    ...    - Kỳ vọng: Trả về lỗi 403 và thông báo không có quyền phát hành
    [Tags]    invoice    validation    permission    einvoice
    Given Chuẩn bị dữ liệu hóa đơn mặc định cho kiểm tra quyền
    And Set To Dictionary    ${REQUEST_DATA["Invoice"]}    IsEInvoice=${TRUE}
    When Gửi yêu cầu tạo hóa đơn với token user không có quyền phát hành
    Then Response Status Code Should Be 403
    And Response Should Have Error "Bạn không có quyền phát hành hóa đơn điện tử"

RT-INPV-017 Kiểm tra xác thực thông tin tài khoản VNPT eInvoice
    [Documentation]    Kiểm tra xác thực thông tin tài khoản VNPT eInvoice khi phát hành hóa đơn điện tử
    ...    - Dữ liệu đầu vào: Hóa đơn hợp lệ, cấu hình VNPT thiếu username
    ...    - Logic kiểm tra: InvoiceService.ValidateEInvoiceProvider kiểm tra thông tin cấu hình
    ...    - Kỳ vọng: Trả về lỗi 400 và thông báo thiếu thông tin đăng nhập
    [Tags]    invoice    validation    einvoice    vnpt
    Given Chuẩn bị dữ liệu hóa đơn mặc định cho kiểm tra quyền
    And Set To Dictionary    ${REQUEST_DATA["Invoice"]}    IsEInvoice=${TRUE}
    And Set To Dictionary    ${REQUEST_DATA["Invoice"]}    EInvoiceProvider=1
    When Gửi yêu cầu tạo hóa đơn với token admin
    Then Response Status Code Should Be 400
    And Response Should Have Error "Thiếu thông tin đăng nhập VNPT eInvoice"

RT-INPV-018 Kiểm tra xác thực template hóa đơn điện tử
    [Documentation]    Kiểm tra xác thực template hóa đơn điện tử khi phát hành
    ...    - Dữ liệu đầu vào: Hóa đơn hợp lệ, template không tồn tại
    ...    - Logic kiểm tra: InvoiceService.ValidateEInvoiceTemplate kiểm tra template
    ...    - Kỳ vọng: Trả về lỗi 404 và thông báo không tìm thấy template
    [Tags]    invoice    validation    einvoice    template
    Given Chuẩn bị dữ liệu hóa đơn mặc định cho kiểm tra quyền
    And Set To Dictionary    ${REQUEST_DATA["Invoice"]}    IsEInvoice=${TRUE}
    And Set To Dictionary    ${REQUEST_DATA["Invoice"]}    EInvoiceTemplateNo=INVALID_TEMPLATE
    When Gửi yêu cầu tạo hóa đơn với token admin
    Then Response Status Code Should Be 404
    And Response Should Have Error "Không tìm thấy mẫu hóa đơn điện tử"

RT-INPV-019 Kiểm tra xác thực trạng thái hóa đơn khi phát hành lại
    [Documentation]    Kiểm tra xác thực trạng thái hóa đơn khi phát hành lại hóa đơn điện tử
    ...    - Dữ liệu đầu vào: Hóa đơn đã phát hành thành công
    ...    - Logic kiểm tra: InvoiceService.ValidateEInvoiceStatus kiểm tra trạng thái
    ...    - Kỳ vọng: Trả về lỗi 400 và thông báo hóa đơn đã phát hành
    [Tags]    invoice    validation    einvoice    status
    Given Chuẩn bị dữ liệu hóa đơn với mã ${INVOICE_SAME_UUID}
    And Set To Dictionary    ${REQUEST_DATA["Invoice"]}    IsEInvoice=${TRUE}
    And Set To Dictionary    ${REQUEST_DATA["Invoice"]}    EInvoiceStatus=1
    When Gửi yêu cầu tạo hóa đơn với token admin
    Then Response Status Code Should Be 400
    And Response Should Have Error "Hóa đơn đã được phát hành thành công"

RT-INPV-020 Kiểm tra quyền hủy hóa đơn điện tử
    [Documentation]    Kiểm tra quyền hủy hóa đơn điện tử với tài khoản không có quyền
    ...    - Dữ liệu đầu vào: Hóa đơn đã phát hành, tài khoản không có quyền hủy
    ...    - Logic kiểm tra: InvoiceService.ValidateCancelEInvoicePermission kiểm tra quyền
    ...    - Kỳ vọng: Trả về lỗi 403 và thông báo không có quyền hủy
    [Tags]    invoice    validation    permission    einvoice    cancel
    Given Chuẩn bị dữ liệu hóa đơn với mã ${INVOICE_VOID_CODE}
    And Set To Dictionary    ${REQUEST_DATA["Invoice"]}    IsEInvoice=${TRUE}
    And Set To Dictionary    ${REQUEST_DATA["Invoice"]}    EInvoiceStatus=1
    And Set To Dictionary    ${REQUEST_DATA["Invoice"]}    Status=3
    When Gửi yêu cầu cập nhật hóa đơn với token user không có quyền hủy
    Then Response Status Code Should Be 403
    And Response Should Have Error "Bạn không có quyền hủy hóa đơn điện tử"