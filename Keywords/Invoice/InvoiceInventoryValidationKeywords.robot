*** Settings ***
Resource    ../Utilities/RequestHelper.robot
Resource    ../Utilities/ResponseHelper.robot
Resource    ../../TestData/CommonData.robot
Resource    ../../TestData/Invoice/InvoiceInventoryValidationData.robot
Resource    ../../Env.robot

*** Keywords ***
Chuẩn bị dữ liệu hóa đơn mặc định cho kiểm tra tồn kho
    ${invoice_data}=    Evaluate    json.loads('''${invoice_inventory_validation_default_data}''')    json
    Set Test Variable    ${REQUEST_DATA}    ${invoice_data}

Chuẩn bị dữ liệu hóa đơn với sản phẩm hết hàng
    Chuẩn bị dữ liệu hóa đơn mặc định cho kiểm tra tồn kho
    ${details}=    Create List
    ${detail}=    Create Dictionary    ProductId=${invoice_inventory_validation_out_of_stock_product_id}    ProductCode=${invoice_inventory_validation_out_of_stock_code}    Quantity=${invoice_inventory_validation_qty_exceed}    Price=100000
    Append To List    ${details}    ${detail}
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    InvoiceDetails=${details}

Chuẩn bị dữ liệu hóa đơn với cấu hình AllowSellWhenOutStock=${value}
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    AllowSellWhenOutStock=${value}

Chuẩn bị dữ liệu hóa đơn với sản phẩm theo serial
    Chuẩn bị dữ liệu hóa đơn mặc định cho kiểm tra tồn kho
    ${details}=    Create List
    ${detail}=    Create Dictionary    ProductId=${invoice_inventory_validation_serial_product_id}    ProductCode=${invoice_inventory_validation_serial_code}    Quantity=1    Price=100000
    Append To List    ${details}    ${detail}
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    InvoiceDetails=${details}

Chuẩn bị dữ liệu hóa đơn với serial ${serial}
    ${serials}=    Create List    ${serial}
    ${details}=    Get From Dictionary    ${REQUEST_DATA["Invoice"]}    InvoiceDetails
    Set To Dictionary    ${details[0]}    SerialNumbers=${serials}

Chuẩn bị dữ liệu hóa đơn với sản phẩm combo
    Chuẩn bị dữ liệu hóa đơn mặc định cho kiểm tra tồn kho
    ${details}=    Create List
    ${detail}=    Create Dictionary    ProductId=${invoice_inventory_validation_combo_product_id}    ProductCode=${invoice_inventory_validation_combo_code}    Quantity=${invoice_inventory_validation_combo_qty}    Price=200000
    Append To List    ${details}    ${detail}
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    InvoiceDetails=${details}

Chuẩn bị dữ liệu hóa đơn với sản phẩm theo lô
    Chuẩn bị dữ liệu hóa đơn mặc định cho kiểm tra tồn kho
    ${details}=    Create List
    ${detail}=    Create Dictionary    ProductId=${invoice_inventory_validation_batch_product_id}    ProductCode=${invoice_inventory_validation_batch_code}    Quantity=${invoice_inventory_validation_batch_qty}    Price=150000    BatchId=${invoice_inventory_validation_batch_id}    BatchName=${invoice_inventory_validation_batch_name}
    Append To List    ${details}    ${detail}
    Set To Dictionary    ${REQUEST_DATA["Invoice"]}    InvoiceDetails=${details}

Chuẩn bị dữ liệu hóa đơn với lô hết hạn ${expire_date}
    ${details}=    Get From Dictionary    ${REQUEST_DATA["Invoice"]}    InvoiceDetails
    Set To Dictionary    ${details[0]}    ExpireDate=${expire_date}

Gửi yêu cầu tạo hóa đơn
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${AUTH_TOKEN}
    ${response}=    POST    ${API_URL}/invoices    ${REQUEST_DATA}    ${headers}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response} 