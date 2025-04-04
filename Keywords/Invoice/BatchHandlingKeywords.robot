*** Settings ***
Documentation     Keywords cho test cases API phần xử lý lô hàng (batch) nâng cao
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/BatchHandlingData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           Collections
Library           json

*** Keywords ***
Chuẩn Bị Dữ Liệu Xử Lý Lô Theo FIFO
    ${data}=    Evaluate    json.loads('''${BATCH_FIFO_DATA}''')    json
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Xử Lý Lô Theo FEFO
    ${data}=    Evaluate    json.loads('''${BATCH_FEFO_DATA}''')    json
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Xử Lý Lô Theo LIFO
    ${data}=    Evaluate    json.loads('''${BATCH_LIFO_DATA}''')    json
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Xử Lý Lô Theo Chi Phí Thấp Nhất
    ${data}=    Evaluate    json.loads('''${BATCH_LOWEST_COST_DATA}''')    json
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Xử Lý Lô Thủ Công
    ${data}=    Evaluate    json.loads('''${BATCH_MANUAL_DATA}''')    json
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Xử Lý Lô Cần Hủy
    ${data}=    Evaluate    json.loads('''${BATCH_CANCEL_DATA}''')    json
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Xử Lý Lô Có Ngày Hết Hạn
    ${data}=    Evaluate    json.loads('''${BATCH_EXPIRE_DATE_DATA}''')    json
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Gửi Yêu Cầu Tạo Hóa Đơn
    ${response}=    Call API    invoices    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    ${invoice_id}=    Set Variable If    ${RESPONSE.status_code} == 200    ${RESPONSE.json()["Id"]}    0
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}

Gửi Yêu Cầu Hủy Hóa Đơn
    ${invoice_data}=    Create Dictionary    Id=${INVOICE_ID}    Status=4
    ${cancel_data}=    Create Dictionary    Invoice=${invoice_data}
    ${response}=    Call API PUT    invoices/${INVOICE_ID}    ${cancel_data}
    Set Test Variable    ${RESPONSE}    ${response}

Lưu Số Lượng Ban Đầu Của Lô ${batch_id}
    ${query}=    Set Variable    SELECT Id, ProductId, Quantity FROM BatchExpire WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${batch_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin lô
    ${batch_quantity}=    Set Variable    ${result[2]}
    Set Test Variable    ${INITIAL_BATCH_QUANTITY}    ${batch_quantity}
    RETURN    ${batch_quantity}

Lấy Danh Sách Lô Theo Thứ Tự Thời Gian Nhập
    [Arguments]    ${product_id}
    ${query}=    Set Variable    SELECT Id, ProductId, Quantity, CreatedDate FROM BatchExpire WHERE ProductId = ? ORDER BY CreatedDate
    ${results}=    Fetch All    ${query}    ${product_id}
    Should Not Be Equal    ${results}    None    Không tìm thấy thông tin các lô theo thời gian nhập
    Set Test Variable    ${TIME_ORDERED_BATCHES}    ${results}
    RETURN    ${results}

Lấy Danh Sách Lô Theo Thứ Tự Ngày Hết Hạn
    [Arguments]    ${product_id}
    ${query}=    Set Variable    SELECT Id, ProductId, Quantity, ExpireDate FROM BatchExpire WHERE ProductId = ? ORDER BY ExpireDate
    ${results}=    Fetch All    ${query}    ${product_id}
    Should Not Be Equal    ${results}    None    Không tìm thấy thông tin các lô theo ngày hết hạn
    Set Test Variable    ${EXPIRE_ORDERED_BATCHES}    ${results}
    RETURN    ${results}

Lấy Danh Sách Lô Theo Thứ Tự Thời Gian Nhập Ngược
    [Arguments]    ${product_id}
    ${query}=    Set Variable    SELECT Id, ProductId, Quantity, CreatedDate FROM BatchExpire WHERE ProductId = ? ORDER BY CreatedDate DESC
    ${results}=    Fetch All    ${query}    ${product_id}
    Should Not Be Equal    ${results}    None    Không tìm thấy thông tin các lô theo thời gian nhập ngược
    Set Test Variable    ${REVERSE_TIME_ORDERED_BATCHES}    ${results}
    RETURN    ${results}

Lấy Danh Sách Lô Theo Thứ Tự Giá Vốn
    [Arguments]    ${product_id}
    ${query}=    Set Variable    SELECT Id, ProductId, Quantity, Cost FROM BatchExpire WHERE ProductId = ? ORDER BY Cost
    ${results}=    Fetch All    ${query}    ${product_id}
    Should Not Be Equal    ${results}    None    Không tìm thấy thông tin các lô theo giá vốn
    Set Test Variable    ${COST_ORDERED_BATCHES}    ${results}
    RETURN    ${results}

Xác Thực Lô Được Xuất Theo Quy Tắc FIFO
    [Arguments]    ${product_id}    ${quantity}
    # Lấy danh sách lô theo thứ tự thời gian nhập
    Lấy Danh Sách Lô Theo Thứ Tự Thời Gian Nhập    ${product_id}
    
    # Lấy lịch sử xuất lô
    ${query}=    Set Variable    SELECT BatchExpireId, Value FROM BatchExpireTracking WHERE DocumentId = ? AND DocumentType = 3
    ${tracking_results}=    Fetch All    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${tracking_results}    None    Không tìm thấy lịch sử xuất lô
    
    # Tạo từ điển lưu trữ số lượng xuất của từng lô
    ${batch_quantities}=    Create Dictionary
    FOR    ${track}    IN    @{tracking_results}
        ${batch_id}=    Set Variable    ${track[0]}
        ${value}=    Set Variable    ${track[1]}
        Set To Dictionary    ${batch_quantities}    ${batch_id}    ${value}
    END
    
    # Xác thực các lô xuất theo đúng thứ tự FIFO
    ${remaining_quantity}=    Set Variable    ${quantity}
    FOR    ${batch}    IN    @{TIME_ORDERED_BATCHES}
        ${batch_id}=    Set Variable    ${batch[0]}
        ${batch_quantity_original}=    Set Variable    ${batch[2]}
        
        # Nếu còn số lượng cần xuất và lô này có ghi nhận xuất
        IF    ${remaining_quantity} > 0 and "${batch_id}" in ${batch_quantities}
            # Tính số lượng dự kiến xuất từ lô này
            ${batch_expected_quantity}=    Evaluate    min(${remaining_quantity}, ${batch_quantity_original})
            ${remaining_quantity}=    Evaluate    ${remaining_quantity} - ${batch_expected_quantity}
            
            # Kiểm tra số lượng đã xuất từ lô
            ${actual_value}=    Set Variable    ${batch_quantities["${batch_id}"]}
            ${expected_value}=    Evaluate    -${batch_expected_quantity}
            Should Be Equal As Numbers    ${actual_value}    ${expected_value}    Giá trị thay đổi số lượng lô ${batch_id} không khớp với quy tắc FIFO
        END
    END
    
    # Đảm bảo đã xuất đủ số lượng
    Should Be Equal As Numbers    ${remaining_quantity}    0    Không đủ lô để xuất theo quy tắc FIFO

Xác Thực Lô Được Xuất Theo Quy Tắc FEFO
    [Arguments]    ${product_id}    ${quantity}
    # Lấy danh sách lô theo thứ tự ngày hết hạn
    Lấy Danh Sách Lô Theo Thứ Tự Ngày Hết Hạn    ${product_id}
    
    # Lấy lịch sử xuất lô
    ${query}=    Set Variable    SELECT BatchExpireId, Value FROM BatchExpireTracking WHERE DocumentId = ? AND DocumentType = 3
    ${tracking_results}=    Fetch All    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${tracking_results}    None    Không tìm thấy lịch sử xuất lô
    
    # Tạo từ điển lưu trữ số lượng xuất của từng lô
    ${batch_quantities}=    Create Dictionary
    FOR    ${track}    IN    @{tracking_results}
        ${batch_id}=    Set Variable    ${track[0]}
        ${value}=    Set Variable    ${track[1]}
        Set To Dictionary    ${batch_quantities}    ${batch_id}    ${value}
    END
    
    # Xác thực các lô xuất theo đúng thứ tự FEFO
    ${remaining_quantity}=    Set Variable    ${quantity}
    FOR    ${batch}    IN    @{EXPIRE_ORDERED_BATCHES}
        ${batch_id}=    Set Variable    ${batch[0]}
        ${batch_quantity_original}=    Set Variable    ${batch[2]}
        
        # Nếu còn số lượng cần xuất và lô này có ghi nhận xuất
        IF    ${remaining_quantity} > 0 and "${batch_id}" in ${batch_quantities}
            # Tính số lượng dự kiến xuất từ lô này
            ${batch_expected_quantity}=    Evaluate    min(${remaining_quantity}, ${batch_quantity_original})
            ${remaining_quantity}=    Evaluate    ${remaining_quantity} - ${batch_expected_quantity}
            
            # Kiểm tra số lượng đã xuất từ lô
            ${actual_value}=    Set Variable    ${batch_quantities["${batch_id}"]}
            ${expected_value}=    Evaluate    -${batch_expected_quantity}
            Should Be Equal As Numbers    ${actual_value}    ${expected_value}    Giá trị thay đổi số lượng lô ${batch_id} không khớp với quy tắc FEFO
        END
    END
    
    # Đảm bảo đã xuất đủ số lượng
    Should Be Equal As Numbers    ${remaining_quantity}    0    Không đủ lô để xuất theo quy tắc FEFO

Xác Thực Lô Được Xuất Theo Quy Tắc LIFO
    [Arguments]    ${product_id}    ${quantity}
    # Lấy danh sách lô theo thứ tự thời gian nhập ngược
    Lấy Danh Sách Lô Theo Thứ Tự Thời Gian Nhập Ngược    ${product_id}
    
    # Lấy lịch sử xuất lô
    ${query}=    Set Variable    SELECT BatchExpireId, Value FROM BatchExpireTracking WHERE DocumentId = ? AND DocumentType = 3
    ${tracking_results}=    Fetch All    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${tracking_results}    None    Không tìm thấy lịch sử xuất lô
    
    # Tạo từ điển lưu trữ số lượng xuất của từng lô
    ${batch_quantities}=    Create Dictionary
    FOR    ${track}    IN    @{tracking_results}
        ${batch_id}=    Set Variable    ${track[0]}
        ${value}=    Set Variable    ${track[1]}
        Set To Dictionary    ${batch_quantities}    ${batch_id}    ${value}
    END
    
    # Xác thực các lô xuất theo đúng thứ tự LIFO
    ${remaining_quantity}=    Set Variable    ${quantity}
    FOR    ${batch}    IN    @{REVERSE_TIME_ORDERED_BATCHES}
        ${batch_id}=    Set Variable    ${batch[0]}
        ${batch_quantity_original}=    Set Variable    ${batch[2]}
        
        # Nếu còn số lượng cần xuất và lô này có ghi nhận xuất
        IF    ${remaining_quantity} > 0 and "${batch_id}" in ${batch_quantities}
            # Tính số lượng dự kiến xuất từ lô này
            ${batch_expected_quantity}=    Evaluate    min(${remaining_quantity}, ${batch_quantity_original})
            ${remaining_quantity}=    Evaluate    ${remaining_quantity} - ${batch_expected_quantity}
            
            # Kiểm tra số lượng đã xuất từ lô
            ${actual_value}=    Set Variable    ${batch_quantities["${batch_id}"]}
            ${expected_value}=    Evaluate    -${batch_expected_quantity}
            Should Be Equal As Numbers    ${actual_value}    ${expected_value}    Giá trị thay đổi số lượng lô ${batch_id} không khớp với quy tắc LIFO
        END
    END
    
    # Đảm bảo đã xuất đủ số lượng
    Should Be Equal As Numbers    ${remaining_quantity}    0    Không đủ lô để xuất theo quy tắc LIFO

Xác Thực Lô Được Xuất Theo Thứ Tự Giá Vốn
    [Arguments]    ${product_id}    ${quantity}
    # Lấy danh sách lô theo thứ tự giá vốn
    Lấy Danh Sách Lô Theo Thứ Tự Giá Vốn    ${product_id}
    
    # Lấy lịch sử xuất lô
    ${query}=    Set Variable    SELECT BatchExpireId, Value FROM BatchExpireTracking WHERE DocumentId = ? AND DocumentType = 3
    ${tracking_results}=    Fetch All    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${tracking_results}    None    Không tìm thấy lịch sử xuất lô
    
    # Tạo từ điển lưu trữ số lượng xuất của từng lô
    ${batch_quantities}=    Create Dictionary
    FOR    ${track}    IN    @{tracking_results}
        ${batch_id}=    Set Variable    ${track[0]}
        ${value}=    Set Variable    ${track[1]}
        Set To Dictionary    ${batch_quantities}    ${batch_id}    ${value}
    END
    
    # Xác thực các lô xuất theo đúng thứ tự giá vốn
    ${remaining_quantity}=    Set Variable    ${quantity}
    FOR    ${batch}    IN    @{COST_ORDERED_BATCHES}
        ${batch_id}=    Set Variable    ${batch[0]}
        ${batch_quantity_original}=    Set Variable    ${batch[2]}
        
        # Nếu còn số lượng cần xuất và lô này có ghi nhận xuất
        IF    ${remaining_quantity} > 0 and "${batch_id}" in ${batch_quantities}
            # Tính số lượng dự kiến xuất từ lô này
            ${batch_expected_quantity}=    Evaluate    min(${remaining_quantity}, ${batch_quantity_original})
            ${remaining_quantity}=    Evaluate    ${remaining_quantity} - ${batch_expected_quantity}
            
            # Kiểm tra số lượng đã xuất từ lô
            ${actual_value}=    Set Variable    ${batch_quantities["${batch_id}"]}
            ${expected_value}=    Evaluate    -${batch_expected_quantity}
            Should Be Equal As Numbers    ${actual_value}    ${expected_value}    Giá trị thay đổi số lượng lô ${batch_id} không khớp với quy tắc giá vốn
        END
    END
    
    # Đảm bảo đã xuất đủ số lượng
    Should Be Equal As Numbers    ${remaining_quantity}    0    Không đủ lô để xuất theo quy tắc giá vốn

Xác Thực Chỉ Lô Chỉ Định Giảm Số Lượng
    [Arguments]    ${batch_id}    ${quantity}
    # Lấy thông tin số lượng lô chỉ định trước khi xuất
    ${query}=    Set Variable    SELECT Quantity FROM BatchExpire WHERE Id = ?
    ${before_result}=    Fetch One    ${query}    ${batch_id}
    Should Not Be Equal    ${before_result}    None    Không tìm thấy thông tin lô chỉ định trước khi xuất
    
    # Lấy thông tin số lượng lô chỉ định sau khi xuất
    ${tracking_query}=    Set Variable    SELECT BatchExpireId, Value FROM BatchExpireTracking WHERE DocumentId = ? AND DocumentType = 3
    ${tracking_results}=    Fetch All    ${tracking_query}    ${INVOICE_ID}
    Should Not Be Equal    ${tracking_results}    None    Không tìm thấy lịch sử xuất lô
    
    # Kiểm tra chỉ có lô chỉ định được xuất
    ${found}=    Set Variable    ${FALSE}
    FOR    ${track}    IN    @{tracking_results}
        ${current_batch_id}=    Set Variable    ${track[0]}
        ${value}=    Set Variable    ${track[1]}
        
        IF    '${current_batch_id}' == '${batch_id}'
            ${found}=    Set Variable    ${TRUE}
            ${expected_value}=    Evaluate    -${quantity}
            Should Be Equal As Numbers    ${value}    ${expected_value}    Giá trị thay đổi số lượng lô ${batch_id} không khớp
        ELSE
            Fail    Lô ${current_batch_id} không phải là lô được chỉ định nhưng vẫn bị xuất
        END
    END
    
    Should Be True    ${found}    Không tìm thấy lô chỉ định trong lịch sử xuất lô

Xác Thực Số Lượng Lô Giảm
    [Arguments]    ${batch_id}    ${quantity}
    ${query}=    Set Variable    SELECT Id, ProductId, Quantity FROM BatchExpire WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${batch_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin lô
    ${current_quantity}=    Set Variable    ${result[2]}
    ${expected_quantity}=    Evaluate    ${INITIAL_BATCH_QUANTITY} - ${quantity}
    Should Be Equal As Numbers    ${current_quantity}    ${expected_quantity}    Số lượng lô không giảm đúng

Xác Thực Số Lượng Lô Tăng
    [Arguments]    ${batch_id}    ${quantity}
    ${query}=    Set Variable    SELECT Id, ProductId, Quantity FROM BatchExpire WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${batch_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin lô
    ${current_quantity}=    Set Variable    ${result[2]}
    ${expected_quantity}=    Evaluate    ${INITIAL_BATCH_QUANTITY}
    Should Be Equal As Numbers    ${current_quantity}    ${expected_quantity}    Số lượng lô không tăng lại đúng

Xác Thực Lô Mới Được Tạo Với Ngày Hết Hạn
    [Arguments]    ${product_id}    ${batch_name}    ${expire_date}
    ${query}=    Set Variable    SELECT Id, BatchName, ExpireDate FROM BatchExpire WHERE ProductId = ? AND BatchName = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${batch_name}
    Should Not Be Equal    ${result}    None    Không tìm thấy lô mới
    ${actual_expire_date}=    Convert Date    ${result[2]}    result_format=%Y-%m-%d
    Should Be Equal    ${actual_expire_date}    ${expire_date}    Ngày hết hạn lô mới không đúng
    ${new_batch_id}=    Set Variable    ${result[0]}
    Set Test Variable    ${NEW_BATCH_ID}    ${new_batch_id}
    RETURN    ${new_batch_id}

Xác Thực Số Lượng Lô Mới
    [Arguments]    ${quantity}
    ${query}=    Set Variable    SELECT Value FROM BatchExpireTracking WHERE DocumentId = ? AND BatchExpireId = ? AND DocumentType = 3
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}    ${NEW_BATCH_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy lịch sử lô mới
    ${expected_value}=    Evaluate    -${quantity}
    Should Be Equal As Numbers    ${result[0]}    ${expected_value}    Giá trị thay đổi số lượng lô mới không khớp

# Keywords với embedded parameters
Các lô được xuất theo quy tắc FIFO
    Xác Thực Lô Được Xuất Theo Quy Tắc FIFO    ${product_batch}    5

Các lô được xuất theo quy tắc FEFO
    Xác Thực Lô Được Xuất Theo Quy Tắc FEFO    ${product_batch}    6

Các lô được xuất theo quy tắc LIFO
    Xác Thực Lô Được Xuất Theo Quy Tắc LIFO    ${product_batch}    4

Các lô được xuất theo thứ tự giá vốn tăng dần
    Xác Thực Lô Được Xuất Theo Thứ Tự Giá Vốn    ${product_batch}    3

Chỉ lô được chỉ định giảm số lượng
    Xác Thực Chỉ Lô Chỉ Định Giảm Số Lượng    ${batch_specific}    2

Số lượng lô ${batch_id} đã giảm ${quantity} đơn vị
    Xác Thực Số Lượng Lô Giảm    ${batch_id}    ${quantity}

Số lượng lô ${batch_id} đã tăng lại ${quantity} đơn vị
    Xác Thực Số Lượng Lô Tăng    ${batch_id}    ${quantity}

Lô mới được tạo với ngày hết hạn đúng
    Xác Thực Lô Mới Được Tạo Với Ngày Hết Hạn    ${product_batch}    NEW_BATCH    2024-06-30

Số lượng lô mới đã giảm ${quantity} đơn vị
    Xác Thực Số Lượng Lô Mới    ${quantity} 