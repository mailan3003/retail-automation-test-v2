*** Settings ***
Resource    ../Data/Purchase_data.robot
Resource    ../../Keywords/Utilities/DataUtilities.robot
Library    RequestsLibrary
Library    Process
Resource    ../Data/env_live.robot

*** Keywords ***
Chuẩn bị dữ liệu phiếu nhập hàng với nhiều hàng hóa
    ${request}=    Create Dictionary   
    Update Dictionary Property    ${request}    PurchaseOrder    ${PURCHASE_ORDER}
    Update Dictionary Property    ${request}    BranchId    ${DEFAULT_BRANCH_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    PurchaseOrder.PurchaseOrderExpensesOthers    ${EXPENSE}
    ${request}=    Update Nested Dictionary Property    ${request}    PurchaseOrder.Payments    ${PAYMENTS}
    Set To Dictionary    ${request}    Complete=True
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Gửi yêu cầu nhập hàng
    ${response}=    POST On Session    session    url=purchaseOrders    json=${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}

Gửi yêu cầu nhập hàng thất bại
    # ${result}=    Run Keyword And Ignore Error    POST On Session    session    purchaseOrders    json=${REQUEST_DATA}
    # ${status}=    Set Variable    ${result[0]}
    # ${response}=  Set Variable    ${result[1]}

    # Run Keyword If    '${status}' == 'FAIL'    Log    ⚠️ Gọi API thất bại nhưng tiếp tục xử lý
    # Run Keyword If    '${status}' == 'FAIL'    Log    ${response}    # In ra chuỗi lỗi

    # # Nếu thành công thì mới xử lý như đối tượng Response
    # Run Keyword If    '${status}' == 'PASS'    Log    Status code: ${response.status_code}
    # Run Keyword If    '${status}' == 'PASS'    Log    Body: ${response.text}

    ${result}=    Run Keyword And Ignore Error    POST On Session    session    purchaseOrders    json=${REQUEST_DATA}
    ${status}=    Set Variable    ${result[0]}
    ${response}=  Set Variable    ${result[1]}

    IF    '${status}' == 'FAIL'
        Log    ❌ API call FAIL
        Log    Exception: ${response}

        ${json_body}=    Get Json From Error Message    ${response}
        Log    ✅ Extracted Message: ${json_body["ResponseStatus"]["Message"]}
    ELSE
        Log    ✅ API call SUCCESS
        Log    Status: ${response.status_code}
        Log    Body: ${response.text}
    END


Get Json From Error Message
    [Arguments]    ${error_message}
    ${msg}=        Convert To String    ${error_message}
    ${start}=      Evaluate    "${msg}".find("{")
    Run Keyword If    ${start} == -1    Fail    Không tìm thấy JSON trong chuỗi lỗi!
    ${json_str}=   Evaluate    "${msg}"[${start}:]
    ${json}=       Evaluate    json.loads("""${json_str}""")    json
    [Return]       ${json}
 
Mã trạng thái trả về là ${status_code}
    Should Be Equal As Numbers    ${status_code}    ${RESPONSE.status_code}

Kiểm tra phiếu nhập hàng được tạo thông qua list danh sách
    ${request}=    Create Dictionary
    ${includes}=    Create List    
    ...    Branch
    ...    Total
    ...    PaidAmount
    ...    TotalQuantity
    ...    TotalProductType
    ...    SubTotal
    ...    Supplier
    ...    User
    ...    OrderSupplier
    ...    User1
    ...    PurchaseReturns
    ...    DiscountPayment
    Set To Dictionary    ${request}    format=json
    Set To Dictionary    ${request}    ForSummaryRow=true
    Update Dictionary Property    ${request}    Includes    ${includes}
    Set To Dictionary    ${request}    $inlinecount=allpages
    Set To Dictionary    ${request}    $format=json
    Set To Dictionary    ${request}    $filter=(BranchId eq 30 and PurchaseDate eq 'month' and (Status eq 1 or Status eq 3))
    Set To Dictionary    ${request}    $top=15
    Set To Dictionary    ${request}    $skip=0
    ${response_list}=    POST On Session    session    url=purchaseOrders/list    json=${request}
    ${purchase_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${purchase_code}=    Set Variable    ${RESPONSE.json()["Code"]}
    ${pur_id}=    Set Variable    ${response_list.json()["Data"][1]["Id"]}  
    ${pur_code}=    Set Variable    ${response_list.json()["Data"][1]["Code"]}   
    Should Be Equal As Strings    ${purchase_id}    ${pur_id}
    Should Be Equal As Strings    ${purchase_code}    ${pur_code}

Chuẩn bị dữ liệu phiếu nhập hàng với Id hàng hóa = 0
    ${product_detail01}=    Deep Copy    ${PRODUCT1}
    ${product_detail02}=    Deep Copy    ${PRODUCT2}
    Update Dictionary Property    ${product_detail01}    ProductId    0
    ${purchase_product_list}=    Create List    ${product_detail01}    ${product_detail02}
    Log    purchase_product_detail: ${purchase_product_list}
    ${purchase_order_detail}=    Deep Copy    ${PURCHASE_ORDER}
    Update Dictionary Property    ${purchase_order_detail}    PurchaseOrderDetails    ${purchase_product_list}
    Update Dictionary Property    ${purchase_order_detail}    PurchaseOrderExpensesOthers    ${EXPENSE}
    Update Dictionary Property    ${purchase_order_detail}    Payments    ${PAYMENTS}
    ${request_body}=    Create Dictionary    
    Update Dictionary Property    ${request_body}    PurchaseOrder    ${purchase_order_detail}
    Set To Dictionary    ${request_body}    Complete=True
    Log    requestbody: ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request_body}

# ${product_id}=    Set Variable    ${RESPONSE.json()["OrderDetails"][0]["ProductId"]}

Kiểm tra mã lỗi trả về là


Kiểm tra message lỗi chứa ${expected_message}
    ${body}=    Convert To String    ${RESPONSE.content}
    ${message}=    Evaluate    json.loads('''${body}''')["ResponseStatus"]["Message"]    json
    Log    MESSAGE LỖI: ${message}
    Should Contain    ${message}    ${expected_message}
    