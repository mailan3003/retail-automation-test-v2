*** Settings ***
Resource    ../Data/Purchase_data.robot
Resource    ../../Keywords/Utilities/DataUtilities.robot
Library    RequestsLibrary
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
    # ${response}=    POST On Session    session    url=purchaseOrders    json=${REQUEST_DATA}
    # Set Test Variable    ${RESPONSE}    ${response}
    ${response}=    Run Keyword And Ignore Error    POST    url=${URL}purchaseOrders    json=${REQUEST_DATA}    headers=${HEADERS}    raise_exception=False
    Set Test Variable    ${RESPONSE}    ${response[1]}


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

    