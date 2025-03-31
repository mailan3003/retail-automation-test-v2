*** Settings ***
Resource    ../Utilities/RequestHelper.robot
Resource    ../Utilities/ResponseHelper.robot
Resource    ../../TestData/CommonData.robot
Resource    ../../TestData/Invoice/InvoicePermissionValidationData.robot
Resource    ../../Env.robot

*** Keywords ***
Chuẩn bị dữ liệu hóa đơn mặc định cho kiểm tra quyền
    ${invoice_data}=    Evaluate    json.loads('''${invoice_permission_validation_default_data}''')    json
    Set Test Variable    ${REQUEST_DATA}    ${invoice_data}

Chuẩn bị dữ liệu hóa đơn với người bán ${seller_id}
    Chuẩn bị dữ liệu hóa đơn mặc định cho kiểm tra quyền
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    SoldById=${seller_id}

Chuẩn bị dữ liệu hóa đơn với chi nhánh ${branch_id}
    Chuẩn bị dữ liệu hóa đơn mặc định cho kiểm tra quyền
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    BranchId=${branch_id}

Chuẩn bị dữ liệu hóa đơn với ngày ${purchase_date}
    Chuẩn bị dữ liệu hóa đơn mặc định cho kiểm tra quyền
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    PurchaseDate=${purchase_date}

Chuẩn bị dữ liệu hóa đơn từ đơn hàng ${order_id}
    Chuẩn bị dữ liệu hóa đơn mặc định cho kiểm tra quyền
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    OrderId=${order_id}

Chuẩn bị dữ liệu hóa đơn với khách hàng ${customer_id}
    Chuẩn bị dữ liệu hóa đơn mặc định cho kiểm tra quyền
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    CustomerId=${customer_id}

Chuẩn bị dữ liệu hóa đơn với ngày thanh toán ${payment_date}
    Chuẩn bị dữ liệu hóa đơn mặc định cho kiểm tra quyền
    ${payments}=    Get From Dictionary    ${REQUEST_DATA["Invoice"]}    Payments
    Set To Dictionary    ${payments[0]}    TransDate=${payment_date}

Chuẩn bị dữ liệu hóa đơn với giao hàng dự kiến ${delivery_date}
    Chuẩn bị dữ liệu hóa đơn mặc định cho kiểm tra quyền
    ${delivery_info}=    Create Dictionary    ExpectedDeliveryDate=${delivery_date}
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    DeliveryInfo=${delivery_info}

Chuẩn bị dữ liệu hóa đơn với cấu hình NotAllowModifyInvoiceDate=${value}
    Chuẩn bị dữ liệu hóa đơn mặc định cho kiểm tra quyền
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    NotAllowModifyInvoiceDate=${value}

Gửi yêu cầu tạo hóa đơn với token ${token_type}
    ${token}=    Set Variable If    "${token_type}" == "admin"    ${AUTH_TOKEN}    invalid_token
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    POST    ${API_URL}/invoices    ${REQUEST_DATA}    ${headers}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response} 