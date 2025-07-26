*** Settings ***
Resource    ../../Config/Env_${ENV}.robot
Resource    ../../TestData/LanTest/Invoice_data.robot
Resource    ../../Keywords/Utilities/RequestHelper.robot
Resource    ../../Keywords/Utilities/ResponseHelper.robot
Resource    ../Utilities/DataUtilities.robot
Library    JSONLibrary
Library    ../../Keywords/Utilities/utils.py    WITH NAME    utils
Library    ../../Resources/DatabaseLibrary.py

*** Keywords ***
Chuẩn bị dữ liệu hóa đơn cơ bản
    [Arguments]    ${payment_method}    ${payment_amount}    ${account_id}
    ${invoice_body}=    Copy Dictionary    ${INVOICE}
    ${payment}=    Deep Copy    ${PAYMENT_1}
    Update Dictionary Property    ${payment}    Method    ${payment_method}
    Update Dictionary Property    ${payment}    Amount    ${payment_amount}
    Update Dictionary Property    ${payment}    AccountId    ${account_id}

    Set To Dictionary    ${invoice_body}    InvoiceDetails=${invoice_body['InvoiceDetails']}
    Set To Dictionary    ${invoice_body}    Payments=${payment}
    &{wrapped_invoice}=    Create Dictionary    Invoice=${invoice_body}
    Set Test Variable    ${INVOICE_BODY}    ${wrapped_invoice}
    RETURN    ${wrapped_invoice}



Gửi yêu cầu tạo hóa đơn cơ bản
    [Documentation]    Gửi yêu cầu tạo hóa đơn cơ bản
    ${response}=    Call API    invoices    ${INVOICE_BODY}    ${AUTH_TOKEN}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}

Kiểm tra hóa đơn đã tạo thành công
    #Kiểm tra id đã được lưu vào db hay chưa
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${query}=    Set Variable    SELECT Id FROM Invoice WHERE Id = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${RETAILER_ID}
    Should Be Equal As Numbers    ${invoice_id}    ${result[0]}    Khong ton tai Id cua hoa don
    #Kiểm tra mã hóa đơn trùng khớp
    ${query}=    Set Variable    SELECT Code FROM Invoice WHERE Id = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${RETAILER_ID}
    Should Be Equal As Strings    ${RESPONSE.json()["Code"]}    ${result[0]}    Ma hoa don khong khop
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}

Kiểm tra hàng hóa trong hóa đơn
    ${product_id}=    Set Variable    ${RESPONSE.json()["InvoiceDetails"][0]["ProductId"]}
    ${query}=    Set Variable    SELECT ProductId From InvoiceDetail WHERE InvoiceId = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}    ${RETAILER_ID}
    Should Be Equal As Numbers    ${result[0]}    ${product_id}    Ma hang hoa khong khop

Kiểm tra khách hàng trong hóa đơn
    ${customer_id}=    Set Variable    ${RESPONSE.json()["CustomerId"]}
    ${query}=    Set Variable    SELECT CustomerId From Invoice WHERE Id = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}    ${RETAILER_ID}
    Should Be Equal As Numbers    ${result[0]}    ${customer_id}    Ma khach hang khong khop

Kiểm tra phương thức thanh toán trong hóa đơn
    ${payment_method}=    Set Variable    ${RESPONSE.json()["Payments"][0]["Method"]}
    ${payment_amount}=    Set Variable    ${RESPONSE.json()["Payments"][0]["Amount"]}
    ${query}=    Set Variable    SELECT Method from Payment p WHERE RetailerId = ? AND InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${RETAILER_ID}    ${INVOICE_ID}
    Should Be Equal As Strings    ${result[0]}    ${payment_method}    Phuong thuc thanh toan khong khop

    ${query}=    Set Variable    SELECT Amount from Payment p WHERE RetailerId = ? AND InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${RETAILER_ID}    ${INVOICE_ID}
    Should Be Equal As Numbers    ${result[0]}    ${payment_amount}    So tien thanh toan khong khop
    # Kiem tra so tien thanh toan trong hoa don
    ${query}=    Set Variable    SELECT TotalPayment from Invoice i WHERE RetailerId = ? AND Id = ?
    ${result}=    Fetch One    ${query}    ${RETAILER_ID}    ${INVOICE_ID}
    Should Be Equal As Numbers    ${result[0]}    ${payment_amount}    So tien thanh toan khong khop

    ${payments}=    Get From Dictionary    ${RESPONSE.json()}    Payments    default=${None}
    ${has_account_id}=    Evaluate    isinstance(${payments}, list) and len(${payments}) > 0 and 'AccountId' in ${payments}[0]
    # Gán giá trị nếu điều kiện đúng, nhưng không gán trong Run Keyword If
    ${method_account_id}=    Set Variable If    ${has_account_id}    ${payments[0]["AccountId"]}    ${None}
    ${query}=    Set Variable    SELECT AccountId from Payment p WHERE RetailerId = ? AND InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${RETAILER_ID}    ${INVOICE_ID}
    Run Keyword If    ${has_account_id}
    ...    Should Be Equal As Numbers    ${result[0]}    ${method_account_id}    So tai khoan khong khop
    ...    ELSE    
    ...    Log    Không có AccountId trong Payments, bỏ qua xử lý
 
Kiểm tra công nợ hóa đơn
    ${query}=    Set Variable    SELECT debt FROM Invoice WHERE Id = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${RESPONSE.json()["Id"]}    ${RETAILER_ID}
    ${debt}=    Evaluate    ${RESPONSE.json()["Total"]}-${RESPONSE.json()["Payments"][0]["Amount"]} 
    Should Be Equal As Numbers    ${result[0]}    ${debt}   

Kết quả trả về có chứa message lỗi ${error_message}
    # ${message}=    Evaluate    ${RESPONSE.json()["ResponseStatus"]["Message"]}
    Should Be Equal As Strings    ${RESPONSE.json()["ResponseStatus"]["Message"]}    ${error_message}    Thong bao loi khong khop
Xóa hóa đơn sau khi kiểm tra
    Delete Data    invoices/${RESPONSE.json()["Id"]}?IsVoidPayment=true&CompareCode=${RESPONSE.json()["Code"]}
# Convert String Numbers To Integers
#     [Arguments]    ${data}
#     ${converted}=    Evaluate    utils.convert_string_numbers_to_integers(${data})    modules=utils
#     RETURN    ${converted}    



