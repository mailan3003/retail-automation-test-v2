*** Settings ***
Resource    ../Utilities/RequestHelper.robot
Resource    ../Utilities/ResponseHelper.robot
Resource    ../Utilities/Utilities.robot
Resource    ../../TestData/CommonData.robot
Resource    ../../TestData/Invoice/InvoiceCodeValidationData.robot
Resource    ../../Env.robot

*** Keywords ***
Chuẩn bị dữ liệu hóa đơn mặc định
    ${invoice_data}=    Evaluate    json.loads('''${invoice_code_validation_default_data}''')    json
    Set Test Variable    ${REQUEST_DATA}    ${invoice_data}

Chuẩn bị dữ liệu hóa đơn với mã ${code}
    Chuẩn bị dữ liệu hóa đơn mặc định
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    Code=${code}

Chuẩn bị dữ liệu hóa đơn với mã ${code} và UUID ${uuid}
    Chuẩn bị dữ liệu hóa đơn với mã ${code}
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    UUID=${uuid}

Chuẩn bị dữ liệu hóa đơn với mã ${code} và trạng thái ${status}
    Chuẩn bị dữ liệu hóa đơn với mã ${code}
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    Status=${status}

Chuẩn bị dữ liệu hóa đơn offline với mã ${code}
    Chuẩn bị dữ liệu hóa đơn với mã ${code}
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    IsOffline=${TRUE}

Chuẩn bị dữ liệu hóa đơn kênh bán ${sale_channel_id} với mã ${code}
    Chuẩn bị dữ liệu hóa đơn với mã ${code}
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    SaleChannelId=${sale_channel_id}

Chuẩn bị dữ liệu hóa đơn bảo hành với mã ${code}
    Chuẩn bị dữ liệu hóa đơn với mã ${code}
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    IsWarranty=${TRUE}

Chuẩn bị dữ liệu hóa đơn clone với mã ${code} và mã gốc ${original_code}
    Chuẩn bị dữ liệu hóa đơn với mã ${code}
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    CompareCode=${original_code}
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    IsClone=${TRUE}

Chuẩn bị dữ liệu hóa đơn cập nhật với mã ${code} và mã gốc ${original_code}
    Chuẩn bị dữ liệu hóa đơn với mã ${code}
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    CompareCode=${original_code}
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    IsUpdate=${TRUE}

Gửi yêu cầu tạo hóa đơn
    ${response}=     Call API    invoices    ${REQUEST_DATA}    
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response} 