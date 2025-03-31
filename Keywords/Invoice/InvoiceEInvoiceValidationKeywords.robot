*** Settings ***
Resource    ../Utilities/RequestHelper.robot
Resource    ../Utilities/ResponseHelper.robot
Resource    ../../TestData/CommonData.robot
Resource    ../../TestData/Invoice/InvoiceEInvoiceValidationData.robot
Resource    ../../Env.robot

*** Keywords ***
Chuẩn bị dữ liệu hóa đơn mặc định cho hóa đơn điện tử
    ${invoice_data}=    Evaluate    json.loads('''${invoice_einvoice_validation_default_data}''')    json
    Set Test Variable    ${REQUEST_DATA}    ${invoice_data}

Chuẩn bị dữ liệu hóa đơn với kết nối VNPT
    Chuẩn bị dữ liệu hóa đơn mặc định cho hóa đơn điện tử
    ${einvoice}=    Create Dictionary    Username=${invoice_einvoice_validation_vnpt_username}    Password=${invoice_einvoice_validation_vnpt_password}    Type=VNPT
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    EInvoice=${einvoice}

Chuẩn bị dữ liệu hóa đơn VNPT với tài khoản không hợp lệ
    Chuẩn bị dữ liệu hóa đơn mặc định cho hóa đơn điện tử
    ${einvoice}=    Create Dictionary    Username=${invoice_einvoice_validation_vnpt_empty_username}    Password=${invoice_einvoice_validation_vnpt_empty_password}    Type=VNPT
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    EInvoice=${einvoice}

Chuẩn bị dữ liệu hóa đơn VNPT với mẫu số ${template_no}
    Chuẩn bị dữ liệu hóa đơn với kết nối VNPT
    ${einvoice}=    Get From Dictionary    ${REQUEST_DATA["Invoice"]}    EInvoice
    Set To Dictionary    ${einvoice}    TemplateNo=${template_no}

Chuẩn bị dữ liệu hóa đơn với kết nối MISA
    Chuẩn bị dữ liệu hóa đơn mặc định cho hóa đơn điện tử
    ${einvoice}=    Create Dictionary    Token=${invoice_einvoice_validation_misa_token}    Type=MISA
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    EInvoice=${einvoice}

Chuẩn bị dữ liệu hóa đơn MISA với token không hợp lệ
    Chuẩn bị dữ liệu hóa đơn mặc định cho hóa đơn điện tử
    ${einvoice}=    Create Dictionary    Token=${invoice_einvoice_validation_misa_empty_token}    Type=MISA
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    EInvoice=${einvoice}

Chuẩn bị dữ liệu hóa đơn MISA với mẫu số ${template_no}
    Chuẩn bị dữ liệu hóa đơn với kết nối MISA
    ${einvoice}=    Get From Dictionary    ${REQUEST_DATA["Invoice"]}    EInvoice
    Set To Dictionary    ${einvoice}    TemplateNo=${template_no}

Chuẩn bị dữ liệu hóa đơn với số hóa đơn ${invoice_no}
    ${einvoice}=    Get From Dictionary    ${REQUEST_DATA["Invoice"]}    EInvoice
    Set To Dictionary    ${einvoice}    InvoiceNo=${invoice_no}

Gửi yêu cầu tạo hóa đơn điện tử
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AUTH_TOKEN}
    ${response}=    POST    ${API_URL}/invoices    ${REQUEST_DATA}    ${headers}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response} 