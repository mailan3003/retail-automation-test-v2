*** Settings ***
Documentation     Keywords cho test cases API phần cập nhật tồn kho
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Mã ${ma_hh} có Số Lượng ${quantity}
    ${query_1}=    Set Variable    SELECT ID FROM Product WHERE Code = ?
    ${result}=    Fetch One    ${query_1}    ${ma_hh}
    Set Test Variable    ${product_id}    ${result[0]}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery} 
    ${data_product}=    Set Variable    ${STANDARD_INVOICE_DETAIL} 
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    ${quantity}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductId    ${product_id}
        ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Có Số Lượng ${quantity}
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Cho Cập Nhật Tồn Kho
    ${detail}=    Set Variable    ${data["Invoice"]["InvoiceDetails"][0]}
    Set To Dictionary    ${detail}    Quantity=${quantity}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Combo
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Cho Cập Nhật Tồn Kho
    ${details}=    Create List    ${COMBO_PRODUCT_DETAIL}
    Set To Dictionary    ${data["Invoice"]}    InvoiceDetails=${details}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Theo Serial ${ma_hh} Với Serial ${serial_number}
    ${query_1}=    Set Variable    SELECT ID FROM Product WHERE Code = ?
    ${result}=    Fetch One    ${query_1}    ${ma_hh}
    Set Test Variable    ${product_id}    ${result[0]}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery} 
    ${data_product}=    Set Variable    ${STANDARD_INVOICE_DETAIL} 
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductId    ${product_id}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    IsLotSerialControl   ${true}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    SerialNumbers   ${serial_number}
        ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Theo Lô ${ma_hh} với ${batch_name} số lượng ${quantity}
    ${query_1}=    Set Variable    SELECT ID FROM Product WHERE Code = ?
    ${query_2}=    Set Variable    SELECT ID FROM ProductBatchExpire WHERE BatchName = ? AND ProductId = ?
    ${result}=    Fetch One    ${query_1}    ${ma_hh}
    ${result_batch}=    Fetch One    ${query_2}    ${batch_name}    ${result[0]}
    Set Test Variable    ${product_id}    ${result[0]} 
    Set Test Variable    ${product_batch_id}    ${result_batch[0]}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery} 
    ${data_product}=    Set Variable    ${STANDARD_INVOICE_DETAIL} 
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductId    ${product_id}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    ${quantity}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    IsBatchExpireControl   ${true}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductBatchExpireId   ${product_batch_id}
     ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}
Chuẩn Bị Dữ Liệu Hóa Đơn Với Đơn Vị Chuyển Đổi
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Cho Cập Nhật Tồn Kho
    ${details}=    Create List    ${CONVERSION_PRODUCT_DETAIL}
    Set To Dictionary    ${data["Invoice"]}    InvoiceDetails=${details}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Sản Phẩm
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Cho Cập Nhật Tồn Kho
    ${details}=    Create List    ${STANDARD_PRODUCT_DETAIL}    ${LARGE_QUANTITY_PRODUCT_DETAIL}
    Set To Dictionary    ${data["Invoice"]}    InvoiceDetails=${details}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Cho Phép Bán Âm Khi Hết Tồn Kho
    ${data}=    Evaluate    json.loads('''${ALLOW_NEGATIVE_INVENTORY_DATA}''')    json
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Từ Đơn Hàng
    ${data}=    Evaluate    json.loads('''${ORDER_TO_INVOICE_DATA}''')    json
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Gửi Yêu Cầu Tạo Hóa Đơn
    ${response}=    Call API    invoices    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    ${invoice_id}=    Set Variable If    ${RESPONSE.status_code} == 200    ${RESPONSE.json()["Id"]}    0
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}

Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm ${product_id}
    ${query}=    Set Variable    SELECT BranchId, ProductId, OnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${BRANCH_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin tồn kho ban đầu
    ${initial_onhand}=    Set Variable    ${result[2]}
    Set Test Variable    ${INITIAL_ONHAND}    ${initial_onhand}
    RETURN    ${initial_onhand}

Xác Thực Số Lượng Tồn Kho Giảm ${quantity} Đơn Vị
    [Arguments]    ${product_id}
    ${query}=    Set Variable    SELECT BranchId, ProductId, OnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${BRANCH_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin tồn kho
    ${new_onhand}=    Set Variable    ${result[2]}
    ${expected_onhand}=    Evaluate    ${INITIAL_ONHAND} - ${quantity}
    Should Be Equal As Numbers    ${new_onhand}    ${expected_onhand}    Số lượng tồn kho không giảm đúng

Xác Thực Lịch Sử Tồn Kho Hóa Đơn Với ${quantity} Đơn Vị Của ${product_id}
    ${query}=    Set Variable    SELECT DocumentId, DocumentType, ProductId, Quantity FROM InventoryTracking WHERE DocumentId = ? AND ProductId = ? AND DocumentType = 1
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}    ${product_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy lịch sử tồn kho
    Should Be Equal As Numbers    ${result[0]}    ${INVOICE_ID}    ID hóa đơn không khớp
    Should Be Equal As Numbers    ${result[2]}    ${product_id}    ID sản phẩm không khớp
    ${expected_value}=    Evaluate    -${quantity}
    Should Be Equal As Numbers    ${result[3]}    ${expected_value}    Giá trị thay đổi tồn kho không khớp

Xác Thực Cập Nhật Số Lượng Đặt Hàng
    [Arguments]    ${product_id}    ${quantity}
    ${query}=    Set Variable    SELECT OnOrder FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${BRANCH_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin đặt hàng
    
    # Tính số lượng đặt hàng mong đợi sau khi trừ số lượng đã xuất
    ${query_old_order}=    Set Variable    SELECT OnOrder FROM OrderDetail WHERE OrderId = ? AND ProductId = ?
    ${old_order}=    Fetch One    ${query_old_order}    ${ORDER_ID}    ${product_id}
    Should Not Be Equal    ${old_order}    None    Không tìm thấy thông tin đặt hàng cũ
    
    ${query_new_order}=    Set Variable    SELECT DeliveredQuantity FROM OrderDetail WHERE OrderId = ? AND ProductId = ?
    ${new_order}=    Fetch One    ${query_new_order}    ${ORDER_ID}    ${product_id}
    Should Not Be Equal    ${new_order}    None    Không tìm thấy thông tin đặt hàng mới
    
    # Xác thực số lượng đã xuất đủ
    Should Be Equal As Numbers    ${new_order[0]}    ${quantity}    Số lượng đã xuất không khớp

Xác Thực Cập Nhật Trạng Thái Serial
    [Arguments]    ${serial_number}
    ${query}=    Set Variable    SELECT Status, DocumentId, DocumentType FROM ProductSerial WHERE SerialNumber = ?
    ${result}=    Fetch One    ${query}    ${serial_number}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin serial
    Should Be Equal As Numbers    ${result[0]}    0    Trạng thái serial không phải là Sold
    Should Be Equal As Numbers    ${result[1]}    ${INVOICE_ID}    ID hóa đơn không khớp
    Should Be Equal As Numbers    ${result[2]}    1    Loại chứng từ không phải là Invoice

Xác Thực Cập Nhật Số Lượng Lô
    [Arguments]    ${batch_id}    ${quantity}
    ${query}=    Set Variable    SELECT ProductBatchExpireId, Quantity FROM BatchExpireTracking WHERE DocumentId = ? AND ProductBatchExpireId = ? AND DocumentType = 1
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}    ${batch_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy lịch sử lô
    Should Be Equal As Numbers    ${result[0]}    ${batch_id}    ID lô không khớp
    ${expected_value}=    Evaluate    -${quantity}
    Should Be Equal As Numbers    ${result[1]}    ${expected_value}    Giá trị thay đổi số lượng lô không khớp

Xác Thực Cập Nhật Tồn Kho Sản Phẩm Con Của Combo
    [Arguments]    ${combo_id}   ${amount}
    # Lấy danh sách sản phẩm con trong combo
    ${query}=    Set Variable    SELECT MaterialId, Quantity FROM ProductFormula WHERE ProductId = ?
    ${results}=    Fetch All    ${query}    ${combo_id}
    Should Not Be Equal    ${results}    None    Không tìm thấy thông tin sản phẩm con trong combo
    
    # Với mỗi sản phẩm con, xác thực tồn kho đã giảm
    FOR    ${result}    IN    @{results}
        ${child_product_id}=    Set Variable    ${result[0]}
        ${child_quantity}=    Set Variable    ${result[1]}
        
        # Lấy thông tin tồn kho hiện tại
        ${query}=    Set Variable    SELECT OnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
        ${current_onhand}=    Fetch One    ${query}    ${child_product_id}    ${BRANCH_ID}
        Should Not Be Equal    ${current_onhand}    None    Không tìm thấy thông tin tồn kho sản phẩm con
        
        # Lấy lịch sử tồn kho để kiểm tra
        ${query}=    Set Variable    SELECT Quantity FROM InventoryTracking WHERE DocumentId = ? AND ProductId = ? AND DocumentType = 7
        ${tracking}=    Fetch One    ${query}    ${INVOICE_ID}    ${child_product_id}
        Should Not Be Equal    ${tracking}    None    Không tìm thấy lịch sử tồn kho sản phẩm con
        
        # Kiểm tra giá trị âm (xuất kho)
        ${expected_value}=    Evaluate    -${child_quantity}*${amount}
        Should Be Equal As Numbers    ${tracking[0]}    ${expected_value}    Giá trị thay đổi tồn kho sản phẩm con không khớp
    END

Xác Thực Cập Nhật Tồn Kho Đơn Vị Chuyển Đổi
    [Arguments]    ${product_id}    ${quantity}    ${conversion_value}
    # Tính số lượng dự kiến giảm theo đơn vị cơ bản
    ${expected_decrease}=    Evaluate    ${quantity} * ${conversion_value}
    
    # Kiểm tra số lượng trong lịch sử tồn kho
    ${query}=    Set Variable    SELECT Quantity FROM InventoryTracking WHERE DocumentId = ? AND ProductId = ? AND DocumentType = 1
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}    ${product_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy lịch sử tồn kho
    ${expected_value}=    Evaluate    -${expected_decrease}
    Should Be Equal As Numbers    ${result[0]}    ${expected_value}    Giá trị thay đổi tồn kho theo đơn vị chuyển đổi không khớp
    
    # Kiểm tra số lượng tồn kho hiện tại
    ${query}=    Set Variable    SELECT OnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${BRANCH_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin tồn kho
    
    # Số lượng tồn ban đầu đã được lưu trong biến ${INITIAL_ONHAND}
    ${expected_onhand}=    Evaluate    ${INITIAL_ONHAND} - ${expected_decrease}
    Should Be Equal As Numbers    ${result[0]}    ${expected_onhand}    Số lượng tồn kho không giảm đúng theo đơn vị chuyển đổi

# Keywords với embedded parameters
Tồn kho sản phẩm ${product_id} đã giảm ${quantity} đơn vị
    Wait Until Keyword Succeeds    3x    5s    Xác Thực Số Lượng Tồn Kho Giảm ${quantity} Đơn Vị    ${product_id}

Lịch sử tồn kho được tạo với số lượng ${quantity} đơn vị cho sản phẩm ${product_id}
    Wait Until Keyword Succeeds    3x    5s    Xác Thực Lịch Sử Tồn Kho Hóa Đơn Với ${quantity} Đơn Vị Của ${product_id}

Số lượng đặt hàng của sản phẩm ${product_id} được giảm ${quantity} đơn vị
    Xác Thực Cập Nhật Số Lượng Đặt Hàng    ${product_id}    ${quantity}

Sản phẩm con trong combo ${combo_id} đã giảm tồn kho ${amount} lần số lượng
    Wait Until Keyword Succeeds    3x    5s    Xác Thực Cập Nhật Tồn Kho Sản Phẩm Con Của Combo    ${combo_id}    ${amount}

Serial ${serial_number} chuyển sang trạng thái đã bán
    Wait Until Keyword Succeeds    3x    5s    Xác Thực Cập Nhật Trạng Thái Serial    ${serial_number}

Số lượng lô ${batch_id} đã giảm ${quantity} đơn vị
    Wait Until Keyword Succeeds    3x    5s    Xác Thực Cập Nhật Số Lượng Lô    ${batch_id}    ${quantity}

Tồn kho sản phẩm ${product_id} đã giảm theo đơn vị chuyển đổi ${quantity} x ${conversion_value}
    Wait Until Keyword Succeeds    3x    5s    Xác Thực Cập Nhật Tồn Kho Đơn Vị Chuyển Đổi    ${product_id}    ${quantity}    ${conversion_value} 


Tear down Delete Hóa Đơn
    Delete Data    /invoices/${INVOICE_ID}?IsVoidPayment=true

