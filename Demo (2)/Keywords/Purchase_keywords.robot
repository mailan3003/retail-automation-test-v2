*** Settings ***
Resource    ../Data/Purchase_data.robot
Resource    ../../Keywords/Utilities/DataUtilities.robot
Library    RequestsLibrary
Library    Process
Library    JSONLibrary
Resource    ../Data/env_live.robot


*** Variables ***
${endpoint_purchaseOrder_detail}    purchaseOrders/{0}?Includes=PurchaseOrderDetails%2CSupplier%2CPaidAmount%2CBranch%2CUser%2CPurchasePayments
${endpoint_supplier_detail}    suppliers/{0}?Includes=SupplierGroupDetails
${endpoint_product_detail}    products/{0}/initialdata?Includes=ProductAttributes&ProductType=2    
${endpoint_delete_purchaseOrder}    purchaseOrders?Id={0}&IsVoidPayment=false&CompareStatus=3

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
    ${response}=    POST On Session    session    url=purchaseOrders    json=${REQUEST_DATA}    expected_status=anything 
    Set Test Variable    ${RESPONSE}    ${response}
 
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

Kiểm tra message lỗi chứa ${expected_message}
    ${message}=    Set Variable    ${RESPONSE.json()["ResponseStatus"]["Message"]}
    Should Be Equal As Strings    ${message}    ${expected_message}
    
Kiểm tra thông tin chi tiết phiếu
    # ${PRODUCT_ID1}=    Convert To Integer    ${PRODUCT_ID1}
    ${purchase_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${endpoint}=    Format String    ${endpoint_purchaseOrder_detail}    ${purchase_id}
    ${result_detail}=    GET On Session    session    ${endpoint}
    
    # Parse response content to JSON
    ${json}=    Convert String To Json    ${result_detail.content}
    # Nếu Convert String To Json không được, thay bằng:
    # ${json}=    Evaluate    ${result_detail.json()}    json

    # Kiểm tra mã phiếu nhập hàng
    ${purchase_code}=    Set Variable    ${RESPONSE.json()["Code"]}
    ${pur_detail_code}=    Set Variable    ${json["Code"]}
    Should Be Equal As Strings    ${purchase_code}    ${pur_detail_code}    Mã phiếu nhập không khớp

    # Kiểm tra chi tiết hàng hóa
    ${pur_detail_productName1}=    Get Value From Json    ${json}    $.PurchaseOrderDetails[?(@.ProductId==${PRODUCT_ID1})].ProductName
    ${pur_detail_productName2}=    Get Value From Json    ${json}    $.PurchaseOrderDetails[?(@.ProductId==${PRODUCT_ID2})].ProductName
    ${pur_detail_productName3}=    Get Value From Json    ${json}    $.PurchaseOrderDetails[?(@.ProductId==${PRODUCT_ID3})].ProductName
    Should Not Be Empty    ${pur_detail_productName1}    Không có hàng hóa thứ 1
    Should Not Be Empty    ${pur_detail_productName2}    Không có hàng hóa thứ 2
    Should Not Be Empty    ${pur_detail_productName3}    Không có hàng hóa thứ 3
    # Kiểm tra tổng số lượng hàng nhập
    ${purchase_quantity}=    Set Variable    ${RESPONSE.json()["TotalQuantity"]}
    ${pur_detail_quantity}=    Get Value From Json    ${json}    $.TotalQuantity
    ${quantity}=         Set Variable    ${pur_detail_quantity[0]}
    Should Be Equal As Numbers    ${purchase_quantity}    ${quantity}    Số lượng hàng nhập không bằng nhau
    # Kiểm tra tổng tiền hàng
    ${purchase_subtotal}=    Set Variable    ${RESPONSE.json()["SubTotal"]}
    ${pur_detail_subtotal}=    Get Value From Json    ${json}    $.SubTotal
    ${subtotal}=         Set Variable    ${pur_detail_subtotal[0]}
    Should Be Equal As Numbers    ${purchase_subtotal}    ${subtotal}    Tổng tiền hàng không bằng nhau
    # Kiểm tra tổng tiền cần trả NCC
    ${purchase_total}=    Set Variable    ${RESPONSE.json()["Total"]}
    ${pur_detail_total}=    Get Value From Json    ${json}    $.Total
    ${total}=         Set Variable    ${pur_detail_total[0]}
    Should Be Equal As Numbers    ${purchase_total}    ${total}    Tổng tiền cần trả NCC không bằng nhau
    ${SupplierOldDebt}=    Get Value From Json    ${json}    $.SupplierOldDebt
    ${SupplierOldDebt}=         Set Variable    ${SupplierOldDebt[0]}
    Set Test Variable    ${SUPPLIEROLDDEBT}    ${SupplierOldDebt}
    Set Test Variable    ${TOTAL}    ${total}
    # ${allDetails}=    Get Value From Json    ${json}    $.PurchaseOrderDetails[?(@.ProductId==${PRODUCT_ID1})].ProductName
    # Log    ${allDetails}
    # ${ids}=    Get Value From Json    ${json}    $.PurchaseOrderDetails[*].ProductId
    # Log    ${ids}
    # Log    ${json}

Kiểm tra công nợ NCC
    ${supplier_id}=    Set Variable    ${RESPONSE.json()["SupplierId"]}
    ${endpoint}=    Format String    ${endpoint_supplier_detail}    ${supplier_id}
    ${result_detail}=    GET On Session    session    ${endpoint}
    # ${json}=    Convert String To Json    ${result_detail.content}
    ${supplier_debt}=    Set Variable    ${result_detail.json()["Debt"]}
    # ${debt}=    Set Variable    ${supplier_debt[0]}  
    ${SUM}=    Evaluate    ${SUPPLIEROLDDEBT} + ${TOTAL}
    Log    Tổng nợ + tổng đơn: ${SUM}
    Should Be Equal As Numbers    ${SUM}    ${supplier_debt}    Công nợ sau khi nhập hàng của NCC không đúng
    # Kiểm tra công nợ trước đó của NCC (trong chi tiết phieus nhập hàng), sau đó check với trong chi tiết NCC

Lấy tồn kho hàng hóa trước khi nhập hàng
    ${endpoint1}=    Format String    ${endpoint_product_detail}    ${PRODUCT_ID1}
    ${endpoint2}=    Format String    ${endpoint_product_detail}    ${PRODUCT_ID2}
    ${endpoint3}=    Format String    ${endpoint_product_detail}    ${PRODUCT_ID3}
    ${result1}=    GET On Session    session    ${endpoint1}
    ${onhand_before_product1}=    Set Variable    ${result1.json()["Product"]["OnHand"]}
    Set Test Variable    ${ONHAND_BEF_PRODUCT1}    ${onhand_before_product1}
    ${result2}=    GET On Session    session    ${endpoint2}
    ${onhand_before_product2}=    Set Variable    ${result2.json()["Product"]["OnHand"]}
    Set Test Variable    ${ONHAND_BEF_PRODUCT2}    ${onhand_before_product2}
    ${result3}=    GET On Session    session    ${endpoint3}
    ${onhand_before_product3}=    Set Variable    ${result3.json()["Product"]["OnHand"]}
    Set Test Variable    ${ONHAND_BEF_PRODUCT3}    ${onhand_before_product3}
Kiểm tra tồn kho hàng hóa sau khi nhập hàng
    ${endpoint1}=    Format String    ${endpoint_product_detail}    ${PRODUCT_ID1}
    ${endpoint2}=    Format String    ${endpoint_product_detail}    ${PRODUCT_ID2}
    ${endpoint3}=    Format String    ${endpoint_product_detail}    ${PRODUCT_ID3}

    ${result1}=    GET On Session    session    ${endpoint1}
    ${onhand_after_product1}=    Set Variable    ${result1.json()["Product"]["OnHand"]}
    Set Test Variable    ${ONHAND_AFT_PRODUCT1}    ${onhand_after_product1}

    ${result2}=    GET On Session    session    ${endpoint2}
    ${onhand_after_product2}=    Set Variable    ${result2.json()["Product"]["OnHand"]}
    Set Test Variable    ${ONHAND_AFT_PRODUCT2}    ${onhand_after_product2}

    ${result3}=    GET On Session    session    ${endpoint3}
    ${onhand_after_product3}=    Set Variable    ${result3.json()["Product"]["OnHand"]}
    Set Test Variable    ${ONHAND_AFT_PRODUCT3}    ${onhand_after_product3}
    
    ${compare_onhand1}=    Evaluate    ${ONHAND_BEF_PRODUCT1} + ${QUANTITY1}
    Should Be Equal As Numbers    ${compare_onhand1}    ${onhand_after_product1}

    ${compare_onhand2}=    Evaluate    ${ONHAND_BEF_PRODUCT2} + ${QUANTITY2}
    Should Be Equal As Numbers    ${compare_onhand2}    ${onhand_after_product2}

    ${compare_onhand3}=    Evaluate    ${ONHAND_BEF_PRODUCT3} + ${QUANTITY3}
    Should Be Equal As Numbers    ${compare_onhand3}    ${onhand_after_product3}

Xóa phiếu nhập hàng
    ${purchase_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${endpoint}=    Format String    ${endpoint_delete_purchaseOrder}    ${purchase_id}
    ${result}=    DELETE On Session    session    ${endpoint}

