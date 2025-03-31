*** Settings ***
Resource    ../../../Keywords/Utilities/ResponseHelper.robot
Resource    ../../../Keywords/Invoice/InvoicePermissionValidationKeywords.robot
Resource    ../../../TestData/CommonData.robot
Resource    ../../../TestData/Invoice/InvoicePermissionValidationData.robot

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