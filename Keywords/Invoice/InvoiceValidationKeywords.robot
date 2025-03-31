*** Settings ***
Resource    Keywords/Utilities/ResponseHelper.robot
Resource    Keywords/Utilities/RequestHelper.robot
Resource    Keywords/Utilities/Utilities.robot
Resource    TestData/CommonData.robot
Resource    TestData/Invoice/InvoiceData.robot

Resource    Env.robot


*** Keywords ***
Chuẩn bị dữ liệu tạo hóa đơn hợp lệ
    ${base_data}=    Evaluate    json.loads('''${VALID_INVOICE_DATA}''')    json
    ${request}=    Set Variable    ${base_data}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn bị dữ liệu hóa đơn với mã ${code}
    Chuẩn bị dữ liệu tạo hóa đơn hợp lệ    
    Set To Dictionary    ${REQUEST_DATA}    Code=${code}    

Chuẩn bị dữ liệu hóa đơn offline có UUID trùng
    Chuẩn bị dữ liệu tạo hóa đơn hợp lệ    
    Set To Dictionary    ${REQUEST_DATA}    Code=${INVOICE_SAME_UUID}
    Set To Dictionary    ${REQUEST_DATA}    UUID=existing-uuid-123    

Chuẩn bị dữ liệu hóa đơn offline với mã ${code}
    Chuẩn bị dữ liệu tạo hóa đơn hợp lệ    
    Set To Dictionary    ${REQUEST_DATA}    Code=${code}
    Set To Dictionary    ${REQUEST_DATA}    IsOffline=${TRUE}

Chuẩn bị dữ liệu hóa đơn Shopee với mã ${code}
    Chuẩn bị dữ liệu tạo hóa đơn hợp lệ    
    Set To Dictionary    ${REQUEST_DATA}    Code=${code}
    Set To Dictionary    ${REQUEST_DATA}    SaleChannelId=1

Chuẩn bị dữ liệu hóa đơn Lazada với mã ${code}
    Chuẩn bị dữ liệu tạo hóa đơn hợp lệ    
    Set To Dictionary    ${REQUEST_DATA}    Code=${code}
    Set To Dictionary    ${REQUEST_DATA}    SaleChannelId=2

Chuẩn bị dữ liệu hóa đơn Facebook với mã ${code}
    Chuẩn bị dữ liệu tạo hóa đơn hợp lệ    
    Set To Dictionary    ${REQUEST_DATA}    Code=${code}
    Set To Dictionary    ${REQUEST_DATA}    SaleChannelId=3

Chuẩn bị dữ liệu hóa đơn Instagram với mã ${code}
    Chuẩn bị dữ liệu tạo hóa đơn hợp lệ    
    Set To Dictionary    ${REQUEST_DATA}    Code=${code}
    Set To Dictionary    ${REQUEST_DATA}    SaleChannelId=4

Chuẩn bị dữ liệu hóa đơn TikTok với mã ${code}
    Chuẩn bị dữ liệu tạo hóa đơn hợp lệ    
    Set To Dictionary    ${REQUEST_DATA}    Code=${code}
    Set To Dictionary    ${REQUEST_DATA}    SaleChannelId=5

Gửi yêu cầu tạo hóa đơn
    #${response}=    POST    ${API_URL}/invoices    json=${REQUEST_DATA}
    ${response}=     Call API    invoices    ${REQUEST_DATA}    
    Set Test Variable    ${RESPONSE}    ${response}
