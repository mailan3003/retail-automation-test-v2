*** Settings ***
Documentation     Keywords mở rộng cho test cases API phần cập nhật tồn kho
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/InventoryUpdateExtendedData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           Collections
Library           json

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Nhiều Loại Tồn Kho
    ${data}=    Deep Copy    ${invoice_request_body_not_delivery}
    # Tạo danh sách chi tiết hóa đơn với sản phẩm có các loại tồn kho khác nhau
    @{details}=    Create List    
    ...    ${MIXED_INVENTORY_TYPE_PRODUCT_DETAIL_1}
    ...    ${MIXED_INVENTORY_TYPE_PRODUCT_DETAIL_2}
    ...    ${MIXED_INVENTORY_TYPE_PRODUCT_DETAIL_3}
    
    ${data}=    Update Nested Dictionary Property    ${data}    Invoice.InvoiceDetails    ${details}
    ${data}=    Update Nested Dictionary Property    ${data}    Invoice.Code    HD_MIXED_INV_001
    ${data}=    Update Nested Dictionary Property    ${data}    Invoice.Total    550000
    
    # Thêm thanh toán
    ${payment}=    Create Dictionary    Method=Cash    Amount=550000
    @{payments}=    Create List    ${payment}
    ${data}=    Update Nested Dictionary Property    ${data}    Invoice.Payments    ${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Combo Số Lượng Lớn
    ${data}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    
    # Thiết lập chi tiết sản phẩm combo với số lượng lớn
    @{details}=    Create List    ${LARGE_COMBO_PRODUCT_DETAIL}
    ${data}=    Update Nested Dictionary Property    ${data}    Invoice.InvoiceDetails    ${details}
    ${data}=    Update Nested Dictionary Property    ${data}    Invoice.Code    HD_LARGE_COMBO_001
    ${data}=    Update Nested Dictionary Property    ${data}    Invoice.Total    750000
    
    # Thêm thanh toán
    ${payment}=    Create Dictionary    Method=Cash    Amount=750000
    @{payments}=    Create List    ${payment}
    ${data}=    Update Nested Dictionary Property    ${data}    Invoice.Payments    ${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Lô Cho Một Sản Phẩm
    ${data}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    
    # Thiết lập chi tiết sản phẩm với nhiều lô
    @{details}=    Create List    ${MULTI_BATCH_PRODUCT_DETAIL}
    ${data}=    Update Nested Dictionary Property    ${data}    Invoice.InvoiceDetails    ${details}
    ${data}=    Update Nested Dictionary Property    ${data}    Invoice.Code    HD_MULTI_BATCH_001
    ${data}=    Update Nested Dictionary Property    ${data}    Invoice.Total    300000
    
    # Thêm thanh toán
    ${payment}=    Create Dictionary    Method=Cash    Amount=300000
    @{payments}=    Create List    ${payment}
    ${data}=    Update Nested Dictionary Property    ${data}    Invoice.Payments    ${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Đơn Vị Chuyển Đổi Không Chuẩn
    ${data}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    
    # Thiết lập chi tiết sản phẩm với đơn vị chuyển đổi không chuẩn
    @{details}=    Create List    ${UNUSUAL_CONVERSION_PRODUCT_DETAIL}
    ${data}=    Update Nested Dictionary Property    ${data}    Invoice.InvoiceDetails    ${details}
    ${data}=    Update Nested Dictionary Property    ${data}    Invoice.Code    HD_UNUSUAL_CONV_001
    ${data}=    Update Nested Dictionary Property    ${data}    Invoice.Total    150000
    
    # Thêm thanh toán
    ${payment}=    Create Dictionary    Method=Cash    Amount=150000
    @{payments}=    Create List    ${payment}
    ${data}=    Update Nested Dictionary Property    ${data}    Invoice.Payments    ${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Chi Nhánh
    ${data}=    Evaluate    json.loads('''${MULTI_BRANCH_INVENTORY_DATA}''')    json
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Xử Lý FIFO
    ${data}=    Evaluate    json.loads('''${ASYNC_INVENTORY_PROCESSING_DATA}''')    json
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Xác Thực Tồn Kho Nhiều Sản Phẩm Khác Loại
    # Xác thực sản phẩm thường
    Xác Thực Số Lượng Tồn Kho Giảm 3 Đơn Vị    ${PRODUCT_1}
    Xác Thực Lịch Sử Tồn Kho Hóa Đơn Với 3 Đơn Vị Của ${PRODUCT_1}
    
    # Xác thực sản phẩm theo lô
    Xác Thực Số Lượng Tồn Kho Giảm 2 Đơn Vị    ${product_batch}
    Xác Thực Lịch Sử Tồn Kho Hóa Đơn Với 2 Đơn Vị Của ${product_batch}
    Xác Thực Cập Nhật Số Lượng Lô    ${batch_1}    2
    
    # Xác thực sản phẩm theo serial
    Xác Thực Cập Nhật Trạng Thái Serial    SN005
    Xác Thực Số Lượng Tồn Kho Giảm 1 Đơn Vị    ${PRODUCT_2}

Xác Thực Tồn Kho Sản Phẩm Combo Số Lượng Lớn
    [Arguments]    ${combo_id}    ${quantity}
    
    # Lấy danh sách sản phẩm con trong combo
    ${query}=    Set Variable    SELECT ChildProductId, Quantity FROM ComboProduct WHERE ComboId = ?
    ${results}=    Fetch All    ${query}    ${combo_id}
    Should Not Be Equal    ${results}    None    Không tìm thấy thông tin sản phẩm con trong combo
    
    # Với mỗi sản phẩm con, xác thực tồn kho đã giảm theo số lượng combo * số lượng thành phần
    FOR    ${result}    IN    @{results}
        ${child_product_id}=    Set Variable    ${result[0]}
        ${child_quantity}=    Set Variable    ${result[1]}
        
        # Tính lượng giảm kỳ vọng
        ${expected_reduction}=    Evaluate    ${quantity} * ${child_quantity}
        
        # Lấy lịch sử tồn kho để kiểm tra
        ${query}=    Set Variable    SELECT Value FROM InventoryTracking WHERE DocumentId = ? AND ProductId = ? AND DocumentType = 3
        ${tracking}=    Fetch One    ${query}    ${INVOICE_ID}    ${child_product_id}
        Should Not Be Equal    ${tracking}    None    Không tìm thấy lịch sử tồn kho sản phẩm con
        
        # Kiểm tra giá trị âm (xuất kho)
        ${expected_value}=    Evaluate    -${expected_reduction}
        Should Be Equal As Numbers    ${tracking[0]}    ${expected_value}    Giá trị thay đổi tồn kho sản phẩm con không khớp
    END

Xác Thực Tồn Kho Nhiều Lô Của Một Sản Phẩm
    [Arguments]    ${product_id}    ${batch_details}
    
    # Chuyển đổi chuỗi JSON chi tiết lô thành đối tượng Python
    ${batches}=    Evaluate    json.loads('''${batch_details}''')    json
    
    # Kiểm tra số lượng tồn kho tổng đã giảm
    ${total_quantity}=    Set Variable    0
    FOR    ${batch}    IN    @{batches}
        ${total_quantity}=    Evaluate    ${total_quantity} + ${batch['Quantity']}
    END
    
    # Xác thực tổng tồn kho đã giảm
    Xác Thực Số Lượng Tồn Kho Giảm ${total_quantity} Đơn Vị    ${product_id}
    Xác Thực Lịch Sử Tồn Kho Hóa Đơn Với ${total_quantity} Đơn Vị Của ${product_id}
    
    # Xác thực từng lô riêng biệt
    FOR    ${batch}    IN    @{batches}
        ${batch_id}=    Set Variable    ${batch['BatchId']}
        ${batch_quantity}=    Set Variable    ${batch['Quantity']}
        
        # Kiểm tra số lượng lô đã giảm
        ${query}=    Set Variable    SELECT Value FROM BatchExpireTracking WHERE DocumentId = ? AND BatchExpireId = ? AND DocumentType = 3
        ${result}=    Fetch One    ${query}    ${INVOICE_ID}    ${batch_id}
        Should Not Be Equal    ${result}    None    Không tìm thấy lịch sử lô ${batch_id}
        
        ${expected_value}=    Evaluate    -${batch_quantity}
        Should Be Equal As Numbers    ${result[0]}    ${expected_value}    Giá trị thay đổi số lượng lô ${batch_id} không khớp
    END

Xác Thực Tồn Kho Với Đơn Vị Chuyển Đổi Không Chuẩn
    [Arguments]    ${product_id}    ${quantity}    ${conversion_value}
    
    # Tính số lượng dự kiến giảm theo đơn vị cơ bản (số thập phân)
    ${expected_decrease}=    Evaluate    ${quantity} * ${conversion_value}
    
    # Kiểm tra số lượng trong lịch sử tồn kho
    ${query}=    Set Variable    SELECT Value FROM InventoryTracking WHERE DocumentId = ? AND ProductId = ? AND DocumentType = 3
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}    ${product_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy lịch sử tồn kho
    
    ${expected_value}=    Evaluate    -${expected_decrease}
    ${actual_value}=    Convert To Number    ${result[0]}
    
    # Sử dụng sai số cho phép trong so sánh số thập phân
    ${diff}=    Evaluate    abs(${actual_value} - ${expected_value})
    Should Be True    ${diff} < 0.001    Giá trị thay đổi tồn kho theo đơn vị chuyển đổi không khớp

Xác Thực Tồn Kho Nhiều Chi Nhánh
    # Kiểm tra chi nhánh mặc định
    ${query}=    Set Variable    SELECT OnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result_main}=    Fetch One    ${query}    ${PRODUCT_1}    ${DEFAULT_BRANCH_ID}
    Should Not Be Equal    ${result_main}    None    Không tìm thấy thông tin tồn kho chi nhánh chính
    
    # Kiểm tra chi nhánh phụ
    ${result_other}=    Fetch One    ${query}    ${PRODUCT_2}    ${OTHER_BRANCH_ID}
    Should Not Be Equal    ${result_other}    None    Không tìm thấy thông tin tồn kho chi nhánh phụ
    
    # Kiểm tra lịch sử tồn kho của từng chi nhánh
    ${query}=    Set Variable    SELECT Value, BranchId FROM InventoryTracking WHERE DocumentId = ? AND ProductId = ? AND DocumentType = 3
    ${result_main_history}=    Fetch One    ${query}    ${INVOICE_ID}    ${PRODUCT_1}
    Should Not Be Equal    ${result_main_history}    None    Không tìm thấy lịch sử tồn kho chi nhánh chính
    Should Be Equal As Numbers    ${result_main_history[0]}    -2    Giá trị thay đổi tồn kho chi nhánh chính không khớp
    Should Be Equal As Numbers    ${result_main_history[1]}    ${DEFAULT_BRANCH_ID}    Chi nhánh trong lịch sử không khớp
    
    ${result_other_history}=    Fetch One    ${query}    ${INVOICE_ID}    ${PRODUCT_2}
    Should Not Be Equal    ${result_other_history}    None    Không tìm thấy lịch sử tồn kho chi nhánh phụ
    Should Be Equal As Numbers    ${result_other_history[0]}    -1    Giá trị thay đổi tồn kho chi nhánh phụ không khớp
    Should Be Equal As Numbers    ${result_other_history[1]}    ${OTHER_BRANCH_ID}    Chi nhánh trong lịch sử không khớp

Xác Thực Xử Lý FIFO Cho Sản Phẩm Lô
    [Arguments]    ${product_id}    ${quantity}
    
    # Kiểm tra tổng số lượng đã giảm
    Xác Thực Số Lượng Tồn Kho Giảm ${quantity} Đơn Vị    ${product_id}
    Xác Thực Lịch Sử Tồn Kho Hóa Đơn Với ${quantity} Đơn Vị Của ${product_id}
    
    # Kiểm tra việc xuất theo thứ tự FIFO
    # 1. Lấy danh sách lô theo thứ tự ngày hết hạn (FIFO)
    ${query}=    Set Variable    SELECT Id, Quantity, ExpiredDate FROM BatchExpire WHERE ProductId = ? ORDER BY ExpiredDate ASC
    ${batches}=    Fetch All    ${query}    ${product_id}
    Should Not Be Equal    ${batches}    None    Không tìm thấy thông tin lô
    
    # 2. Kiểm tra các lô đã xuất theo thứ tự FIFO
    ${remaining_quantity}=    Set Variable    ${quantity}
    FOR    ${batch}    IN    @{batches}
        ${batch_id}=    Set Variable    ${batch[0]}
        ${batch_original_quantity}=    Set Variable    ${batch[1]}
        
        # Kiểm tra lịch sử xuất kho của lô
        ${query}=    Set Variable    SELECT Value FROM BatchExpireTracking WHERE DocumentId = ? AND BatchExpireId = ? AND DocumentType = 3
        ${result}=    Fetch One    ${query}    ${INVOICE_ID}    ${batch_id}
        
        # Nếu còn số lượng cần xuất và lô này có ghi nhận xuất
        ${batch_expected_quantity}=    Set Variable    0
        IF    ${remaining_quantity} > 0 and ${result} != None
            # Tính số lượng dự kiến xuất từ lô này
            ${batch_expected_quantity}=    Evaluate    min(${remaining_quantity}, ${batch_original_quantity})
            ${remaining_quantity}=    Evaluate    ${remaining_quantity} - ${batch_expected_quantity}
            
            # Kiểm tra số lượng đã xuất từ lô
            ${expected_value}=    Evaluate    -${batch_expected_quantity}
            Should Be Equal As Numbers    ${result[0]}    ${expected_value}    Giá trị thay đổi số lượng lô ${batch_id} không khớp với quy tắc FIFO
        END
    END
    
    # Đảm bảo đã xuất đủ số lượng
    Should Be Equal As Numbers    ${remaining_quantity}    0    Không đủ lô để xuất theo quy tắc FIFO

# Keywords với embedded parameters
Tồn kho nhiều sản phẩm đã được cập nhật đúng
    Xác Thực Tồn Kho Nhiều Sản Phẩm Khác Loại

Tồn kho combo ${combo_id} đã giảm với số lượng ${quantity}
    Xác Thực Tồn Kho Sản Phẩm Combo Số Lượng Lớn    ${combo_id}    ${quantity}

Các lô của sản phẩm ${product_id} đã giảm theo chi tiết ${batch_details}
    Xác Thực Tồn Kho Nhiều Lô Của Một Sản Phẩm    ${product_id}    ${batch_details}

Tồn kho sản phẩm ${product_id} đã giảm với đơn vị chuyển đổi ${quantity} x ${conversion_value}
    Xác Thực Tồn Kho Với Đơn Vị Chuyển Đổi Không Chuẩn    ${product_id}    ${quantity}    ${conversion_value}

Tồn kho đã được cập nhật cho nhiều chi nhánh
    Xác Thực Tồn Kho Nhiều Chi Nhánh

Tồn kho đã được cập nhật theo quy tắc FIFO cho sản phẩm ${product_id} với số lượng ${quantity}
    Xác Thực Xử Lý FIFO Cho Sản Phẩm Lô    ${product_id}    ${quantity} 