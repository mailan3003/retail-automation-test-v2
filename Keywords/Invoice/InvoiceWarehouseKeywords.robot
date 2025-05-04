*** Settings ***
Resource    ../Utilities/RequestHelper.robot
Resource    ../Utilities/ResponseHelper.robot
Resource    ../Utilities/DataUtilities.robot
Resource    ../Utilities/Utilities.robot
Resource    ../../TestData/CommonData.robot
Resource    ../../TestData/Invoice/CommonInvoiceData.robot
Resource    ../../TestData/Invoice/InvoiceWarehouseData.robot
Resource    ../../Config/Env_api.robot
Library     ../../Resources/DatabaseLibrary.py
Library     RequestsLibrary
Library     Collections

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Mã ${ma_hh} có Số Lượng ${quantity} Kho ${kho}
    ${query_1}=    Set Variable    SELECT ID FROM Product WHERE Code = ?
    ${result}=    Fetch One    ${query_1}    ${ma_hh}
    ${branch_id}   Run Keyword If    '${kho}' == 'Bán Hàng'    Set Variable    ${BRANCH_ID}
    ...    ELSE    Thông tin kho ${kho}
    Set Test Variable    ${product_id}    ${result[0]}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery} 
    ${data_product}=     Deep Copy    ${STANDARD_INVOICE_DETAIL} 
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    ${quantity}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductId    ${product_id}
     ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data_product}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.BranchId    ${branch_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${ma_hh} Với Serial ${serial_number} Tại Kho ${kho}    
    ${query_1}=    Set Variable    SELECT ID FROM Product WHERE Code = ?
    ${result}=    Fetch One    ${query_1}    ${ma_hh}
    Set Test Variable    ${product_id}    ${result[0]}
    ${branch_id}   Run Keyword If    '${kho}' == 'Bán Hàng'    Set Variable    ${BRANCH_ID}
    ...    ELSE    Thông tin kho ${kho}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery} 
    ${data_product}=     Deep Copy     ${STANDARD_INVOICE_DETAIL} 
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductId    ${product_id}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    IsLotSerialControl   ${true}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    SerialNumbers   ${serial_number}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data_product}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.BranchId    ${branch_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Theo Lô ${ma_hh} Với ${batch_name} Số Lượng ${quantity} Tại Kho ${kho}
    ${query_1}=    Set Variable    SELECT ID FROM Product WHERE Code = ?
    ${query_2}=    Set Variable    SELECT ID FROM ProductBatchExpire WHERE BatchName = ? AND ProductId = ?
    ${result}=    Fetch One    ${query_1}    ${ma_hh}
    ${result_batch}=    Fetch One    ${query_2}    ${batch_name}    ${result[0]}
    ${branch_id}   Run Keyword If    '${kho}' == 'Bán Hàng'    Set Variable    ${BRANCH_ID}
    ...    ELSE    Thông tin kho ${kho}
    Set Test Variable    ${product_id}    ${result[0]} 
    Set Test Variable    ${product_batch_id}    ${result_batch[0]}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery} 
    ${data_product}=    Deep Copy    ${STANDARD_INVOICE_DETAIL} 
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductId    ${product_id}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    ${quantity}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    IsBatchExpireControl   ${true}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductBatchExpireId   ${product_batch_id}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data_product}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.BranchId    ${branch_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liêu Hóa Đơn Với Sản Phẩm ${ma_hh} Có ${number} Dòng Số Lượng Mỗi Dòng ${quantity} Tại Kho ${kho}
    ${query_1}=    Set Variable    SELECT ID FROM Product WHERE Code = ?
    ${result}=    Fetch One    ${query_1}    ${ma_hh}
    Set Test Variable    ${product_id}    ${result[0]}
    ${branch_id}   Run Keyword If    '${kho}' == 'Bán Hàng'    Set Variable    ${BRANCH_ID}
    ...    ELSE    Thông tin kho ${kho}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery} 
    ${data_product}=     Deep Copy    ${STANDARD_INVOICE_DETAIL} 
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductId    ${product_id}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    ${quantity}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    IsMaster   ${true}
    ${list_data_product}=    Create List    ${data_product}
    FOR    ${i}    IN RANGE    ${number}
        ${data_product_copy}=    Deep Copy    ${data_product}
        ${data_product_copy}=    Update Nested Dictionary Property     ${data_product_copy}    Quantity    ${quantity}
        ${data_product_copy}=    Update Nested Dictionary Property     ${data_product_copy}    ProductId    ${product_id}
        ${data_product_copy}=    Update Nested Dictionary Property     ${data_product_copy}    IsMaster   ${false}
        Append To List    ${list_data_product}    ${data_product_copy}
    END
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${list_data_product}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.BranchId    ${branch_id}
    ${total_quantity}=    Evaluate    ${quantity} * (${number} + 1)
    Set Test Variable    ${TOTAL_QUANTITY}    ${total_quantity}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}
Chi Tiết Hóa Đơn Có Thông Tin Kho ${kho}
    ${branch_id}   Run Keyword If    '${kho}' == 'Bán Hàng'    Set Variable    ${BRANCH_ID}
    ...    ELSE    Thông tin kho ${kho}
    ${query_1}=    Set Variable    SELECT COUNT(*) FROM Invoice WHERE Id = ? AND BranchId = ?
    ${result}=    Fetch One    ${query_1}    ${INVOICE_ID}    ${branch_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin hóa đơn theo kho ${kho}

Thông tin kho ${kho}
    ${query_1}=    Set Variable    SELECT ID FROM Branch WHERE Name = ?
    ${result}=    Fetch One    ${query_1}    ${kho}
    Set Test Variable    ${branch_id}    ${result[0]}
    RETURN    ${branch_id}

Xem Thông Tin Tổng Tồn Kho Của Sản Phẩm ${product_id}
    ${query}=    Set Variable    SELECT BranchId, ProductId, TotalOnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${DEFAULT_BRANCH_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin tồn kho ban đầu
    ${initial_onhand}=    Set Variable    ${result[2]}
    Set Test Variable    ${INITIAL_ONHAND_TOTAL}    ${initial_onhand}
    RETURN    ${initial_onhand}

Xem Thông Tin Tồn Kho Của Sản Phẩm ${product_id} Tại Kho ${kho}
    ${branch_id}   Run Keyword If    '${kho}' == 'Bán Hàng'    Set Variable    ${BRANCH_ID}
    ...    ELSE    Thông tin kho ${kho}
    ${query}=    Set Variable    SELECT BranchId, ProductId, OnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${branch_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin tồn kho
    ${initial_onhand}=    Set Variable    ${result[2]}
    Set Test Variable    ${INITIAL_ONHAND}    ${initial_onhand}
    RETURN    ${initial_onhand}

Tồn kho sản phẩm ${product_id} đã giảm ${quantity} đơn vị Tại Kho ${kho}
    Wait Until Keyword Succeeds    10x    1s    Xác Thực Số Lượng Tồn Kho Giảm ${quantity} Đơn Vị Tại Kho ${kho}    ${product_id}

Tổng tồn kho sản phẩm ${product_id} đã giảm ${quantity} đơn vị 
    Wait Until Keyword Succeeds    10x    1s    Xác Thực Tổng Tồn Kho Của Sản Phẩm ${product_id} Giảm ${quantity} Đơn Vị

Xác Thực Số Lượng Tồn Kho Giảm ${quantity} Đơn Vị Tại Kho ${kho}
    [Arguments]    ${product_id}
    ${branch_id}   Run Keyword If    '${kho}' == 'Bán Hàng'    Set Variable    ${BRANCH_ID}
    ...    ELSE    Thông tin kho ${kho}
    ${query}=    Set Variable    SELECT BranchId, ProductId, OnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${branch_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin tồn kho
    ${new_onhand}=    Set Variable    ${result[2]}
    ${expected_onhand}=    Evaluate    ${INITIAL_ONHAND} - ${quantity}
    Should Be Equal As Numbers    ${new_onhand}    ${expected_onhand}    Số lượng tồn kho không giảm đúng

Xác Thực Tổng Tồn Kho Của Sản Phẩm ${product_id} Giảm ${quantity} Đơn Vị
    ${query}=    Set Variable    SELECT BranchId, ProductId, TotalOnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${DEFAULT_BRANCH_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin tồn kho
    ${new_onhand}=    Set Variable    ${result[2]}
    ${expected_onhand}=    Evaluate    ${INITIAL_ONHAND_TOTAL} - ${quantity}
    Should Be Equal As Numbers    ${new_onhand}    ${expected_onhand}    Số lượng tồn kho không giảm đúng

Sản phẩm con trong combo ${product_id} đã giảm tồn kho ${quantity} lần số lượng tại kho ${kho}
   Wait Until Keyword Succeeds    5x    1s    Xác Thực Cập Nhật Tồn Kho Sản Phẩm Con Của Combo Tại Kho    ${kho}    ${product_id}    ${quantity} 

Xác Thực Cập Nhật Tồn Kho Sản Phẩm Con Của Combo Tại Kho
    [Arguments]    ${kho}    ${combo_id}    ${amount}
    # Lấy danh sách sản phẩm con trong combo
    ${query}=    Set Variable    SELECT MaterialId, Quantity FROM ProductFormula WHERE ProductId = ?
    ${results}=    Fetch All    ${query}    ${combo_id}
    Should Not Be Equal    ${results}    None    Không tìm thấy thông tin sản phẩm con trong combo
    
    # Với mỗi sản phẩm con, xác thực tồn kho đã giảm
    FOR    ${result}    IN    @{results}
        ${child_product_id}=    Set Variable    ${result[0]}
        ${child_quantity}=    Set Variable    ${result[1]}
        ${branch_id}   Run Keyword If    '${kho}' == 'Bán Hàng'    Set Variable    ${DEFAULT_BRANCH_ID}
        ...    ELSE    Thông tin kho ${kho}
        # Lấy thông tin tồn kho hiện tại
        ${query}=    Set Variable    SELECT OnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
        ${current_onhand}=    Fetch One    ${query}    ${child_product_id}    ${branch_id}
        Should Not Be Equal    ${current_onhand}    None    Không tìm thấy thông tin tồn kho sản phẩm con
        
        # Lấy lịch sử tồn kho để kiểm tra
        ${query}=    Set Variable    SELECT Quantity FROM InventoryTracking WHERE DocumentId = ? AND ProductId = ? AND DocumentType = 7
        ${tracking}=    Fetch One    ${query}    ${INVOICE_ID}    ${child_product_id}
        Should Not Be Equal    ${tracking}    None    Không tìm thấy lịch sử tồn kho sản phẩm con
        
        # Kiểm tra giá trị âm (xuất kho)
        ${expected_value}=    Evaluate    -${child_quantity}*${amount}
        Should Be Equal As Numbers    ${tracking[0]}    ${expected_value}    Giá trị thay đổi tồn kho sản phẩm con không khớp
    END
# Warehouse validation test keywords
Chuẩn Bị Dữ Liệu Hóa Đơn Với Kho Hàng Đã Bị Xóa
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${warehouse}=    Create Dictionary    Id=${DELETED_WAREHOUSE_ID}    Type=2
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.WareHouse    ${warehouse}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Kho Hàng Đã Ngừng Hoạt Động
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${warehouse}=    Create Dictionary    Id=${INACTIVE_WAREHOUSE_ID}    Type=2
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.WareHouse    ${warehouse}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Kho Bán Hàng Mặc Định Chi Nhánh Đã Bị Xóa
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${warehouse}=    Create Dictionary    Id=${DELETED_BRANCH_ID}    Type=1
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.WareHouse    ${warehouse}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.BranchId    ${DELETED_WAREHOUSE_ID}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Không Chỉ Định Kho Hàng Chi Nhánh Đã Bị Vô Hiệu Hóa
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.WareHouse    ${None}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.BranchId    ${INACTIVE_WAREHOUSE_ID}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Thông Báo Lỗi Phải Chứa "${error_message}"
    Response Should Have Error "${error_message}"