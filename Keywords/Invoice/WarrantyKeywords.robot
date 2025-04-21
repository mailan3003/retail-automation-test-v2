*** Settings ***
Documentation     Keywords for handling warranty-related invoice operations
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../../Keywords/Invoice/InventoryUpdateKeywords.robot
Resource          ../../TestData/Invoice/WarrantyData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           Collections
Library           String
Library           OperatingSystem
Library           DateTime
*** Keywords ***
#### GIVEN keywords
Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Có Thời Hạn ${warranty_type} Là ${number_time} ${number_time_type}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn có sản phẩm bảo hành với thời gian ${number_time} ${number_time_type}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${warranty_data}=    Deep Copy    ${invoice_warranty_body}
    ${uuid}       Generate Random String    15    WA[NUMBERS]
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    ProductId    ${WARRANTY_PRODUCT_ID}
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    UseWarranty    ${TRUE}
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    Uuid    ${uuid}
    ${warranty_data}=    Update Info Warranty    ${warranty_data}  ${warranty_type}   ${number_time}    ${number_time_type}   ${WARRANTY_PRODUCT_ID}   
    ${warranty_data}     Update Nested Dictionary Property    ${warranty_data}    InvoiceDetailUuid    ${uuid} 
    ${warranty_data}   Create List    ${warranty_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails     ${data_product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails.ProductWarranty   ${warranty_data}

    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceWarranties   ${warranty_data}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Update Info Warranty
    [Arguments]    ${invoice_warranty_body}      ${warranty_type}    ${number_time}    ${time_type}   ${product_id}
    ${warranty_data}=    Deep Copy    ${invoice_warranty_body}
    ${time_type_value}   Transform Time Type    ${time_type}
    ${current_date}=    Get Current Date     result_format=%Y-%m-%d
    ${warranty_type_value}    Transform Warranty Type   ${warranty_type}
    ${expire_date}    Evaluate    ${number_time} * 365
    ${calculated_expire_date}=    Run Keyword If    '${time_type_value}'=='1'    Add Time To Date    ${current_date}    ${number_time} days    result_format=%Y-%m-%d
    ...    ELSE IF    '${time_type_value}'=='2'    Evaluate    datetime.datetime.strptime('${current_date}', '%Y-%m-%d').replace(month=((datetime.datetime.strptime('${current_date}', '%Y-%m-%d').month - 1 + ${number_time}) % 12) + 1, year=datetime.datetime.strptime('${current_date}', '%Y-%m-%d').year + ((datetime.datetime.strptime('${current_date}', '%Y-%m-%d').month - 1 + ${number_time}) // 12)).strftime('%Y-%m-%d')    modules=datetime
    ...    ELSE IF    '${time_type_value}'=='3'        Add Time To Date    ${current_date}    ${expire_date} days    result_format=%Y-%m-%d
    ${warranty_data}     Update Nested Dictionary Property    ${warranty_data}    ProductId    ${product_id}
    ${warranty_data}=    Update Nested Dictionary Property    ${warranty_data}    WarrantyType    ${warranty_type_value}
    ${warranty_data}=    Update Nested Dictionary Property    ${warranty_data}    NumberTime    ${number_time}
    ${warranty_data}=    Update Nested Dictionary Property    ${warranty_data}    TimeType    ${time_type_value}
    ${warranty_data}=    Update Nested Dictionary Property    ${warranty_data}    ExpireDate    ${calculated_expire_date}
    RETURN    ${warranty_data}

Transform Time Type
    [Arguments]    ${time_type}
    ${time_type_value}=    Run Keyword If    '${time_type}'=='Ngày'    Set Variable    1
    ...  ELSE IF    '${time_type}'=='Tháng'    Set Variable    2
    ...  ELSE IF    '${time_type}'=='Năm'    Set Variable    3
    ...  ELSE    Set Variable    ${time_type}
    RETURN    ${time_type_value}

Transform Warranty Type
    [Arguments]    ${warranty_type}
    ${warranty_type_value}=    Run Keyword If    '${warranty_type}'=='Bảo Hành'    Set Variable    1
    ...  ELSE IF    '${warranty_type}'=='Bảo Trì'    Set Variable    3
    ...  ELSE    Set Variable    ${warranty_type}
    RETURN    ${warranty_type_value}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${warranty_product_id} Nhiều Thời Hạn BH ${warranty_name} ${number_time} ${number_time_type} Và BT ${number_time_bao_tri} ${number_time_type_bao_tri}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với sản phẩm chỉnh sửa bảo hành
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${warranty_data}=    Deep Copy    ${invoice_warranty_body}
    ${warranty_bao_tri}=    Deep Copy    ${invoice_warranty_body}
    ${uuid}       Generate Random String    15    WA[NUMBERS]
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    ProductId    ${warranty_product_id}
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    UseWarranty    ${TRUE}
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    Uuid    ${uuid}
    ${warranty_data_list}=    Create List
    FOR    ${item_warranty_name}    ${item_number_time}    ${item_number_time_type}    IN ZIP    ${warranty_name}    ${number_time}    ${number_time_type}
        ${warranty_data}=    Update Info Warranty    ${warranty_data}   1   ${item_number_time}    ${item_number_time_type}   ${warranty_product_id}  
        ${warranty_data}     Update Nested Dictionary Property    ${warranty_data}    Description    ${item_warranty_name}
        ${warranty_data}     Update Nested Dictionary Property    ${warranty_data}    InvoiceDetailUuid    ${uuid} 
        Append To List    ${warranty_data_list}    ${warranty_data}
    END
    ${warranty_bao_tri_list}   Update Info Warranty    ${warranty_bao_tri}   3   ${number_time_bao_tri}    ${number_time_type_bao_tri}   ${warranty_product_id}   
    ${warranty_bao_tri_list}=    Update Nested Dictionary Property    ${warranty_bao_tri_list}    InvoiceDetailUuid    ${uuid}
    Append To List    ${warranty_data_list}    ${warranty_bao_tri_list}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails     ${data_product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails.ProductWarranty   ${warranty_data_list}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceWarranties  ${warranty_data_list}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}
Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Serial ${product_id} Có Imei ${serial_number} Bảo Hành ${number_time} ${number_time_type}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn có sản phẩm bảo hành với serial và tạo phiếu bảo hành tự động
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${warranty_data}=    Deep Copy    ${invoice_warranty_body}
    ${number_time_type_value}   Transform Time Type    ${number_time_type}
    ${uuid}       Generate Random String    15    WA[NUMBERS]
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    ProductId    ${product_id}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    IsLotSerialControl   ${true}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    SerialNumbers   ${serial_number}
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    UseWarranty    ${TRUE}
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    Uuid    ${uuid}
    ${warranty_data}     Update Info Warranty    ${warranty_data}   1   ${number_time}    ${number_time_type_value}   ${product_id}   
    ${warranty_data}     Update Nested Dictionary Property    ${warranty_data}    InvoiceDetailUuid    ${uuid} 
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails     ${data_product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails.ProductWarranty   ${warranty_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceWarranties   ${warranty_data}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}      ${request} 
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${product_id} Thời hạn Bảo Hành ${number_time} ${number_time_type} Và ${product_id_2} Thời hạn Bảo Hành ${number_time_2} ${number_time_type_2}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn có sản phẩm bảo hành với thời hạn khác nhau
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_product_2}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${warranty_data}=    Deep Copy    ${invoice_warranty_body}
    ${warranty_data_2}=    Deep Copy    ${invoice_warranty_body}
    ${uuid}       Generate Random String    15    WA[NUMBERS]
    ${uuid_2}       Generate Random String    15    WA[NUMBERS]
    ${number_time_type_value}   Transform Time Type    ${number_time_type}    
    ${number_time_type_value_2}   Transform Time Type    ${number_time_type_2}    
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    ProductId    ${product_id}
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    UseWarranty    ${TRUE}
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    Uuid    ${uuid}         

    ${data_product_2}=    Update Nested Dictionary Property    ${data_product_2}    ProductId    ${product_id_2}
    ${data_product_2}=    Update Nested Dictionary Property    ${data_product_2}    UseWarranty    ${TRUE}
    ${data_product_2}=    Update Nested Dictionary Property    ${data_product_2}    Uuid    ${uuid_2}

    ${warranty_data_list}=    Create List

    ${warranty_data}=    Update Info Warranty    ${warranty_data}   1   ${number_time}    ${number_time_type_value}   ${product_id}   
    ${warranty_data}     Update Nested Dictionary Property    ${warranty_data}    InvoiceDetailUuid    ${uuid} 
    Append To List    ${warranty_data_list}    ${warranty_data}

    ${warranty_data_2}=    Update Info Warranty    ${warranty_data_2}   1   ${number_time_2}    ${number_time_type_value_2}   ${product_id_2}   
    ${warranty_data_2}     Update Nested Dictionary Property    ${warranty_data_2}    InvoiceDetailUuid    ${uuid_2} 
    Append To List    ${warranty_data_list}    ${warranty_data_2}
    ${data_product}    Update Nested Dictionary Property    ${data_product}    ProductWarranty    ${warranty_data}
    ${data_product_2}    Update Nested Dictionary Property    ${data_product_2}    ProductWarranty    ${warranty_data_2}
    ${data_product_list}=    Create List    ${data_product}    ${data_product_2}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails     ${data_product_list}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceWarranties   ${warranty_data_list}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}      ${request} 
    RETURN    ${request}


Chuẩn Bị Dữ liệu Hóa Đơn Với Hàng Lodate ${product_code} Có Lô ${batch_name} Thời hạn Bảo Trì ${number_time} ${number_time_type}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với hàng lodate và thời hạn bảo trì
    ${query_1}=    Set Variable    SELECT ID FROM Product WHERE Code = ?
    ${query_2}=    Set Variable    SELECT ID FROM ProductBatchExpire WHERE BatchName = ? AND ProductId = ?
    ${result}=    Fetch One    ${query_1}    ${product_code}
    ${result_batch}=    Fetch One    ${query_2}    ${batch_name}    ${result[0]}
    Set Test Variable    ${product_id}    ${result[0]} 
    Set Test Variable    ${product_batch_id}    ${result_batch[0]}
    ${number_time_type_value}   Transform Time Type    ${number_time_type}    
    ${uuid}       Generate Random String    15    WA[NUMBERS]
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${warranty_data}=    Deep Copy    ${invoice_warranty_body}
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    ProductId    ${product_id}
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    IsBatchExpireControl   ${true}
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    ProductBatchExpireId   ${product_batch_id}
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    UseWarranty    ${TRUE}
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    Uuid    ${uuid}
    ${warranty_data}     Update Info Warranty    ${warranty_data}   3   ${number_time}    ${number_time_type_value}   ${product_id}   
    ${warranty_data}     Update Nested Dictionary Property    ${warranty_data}    InvoiceDetailUuid    ${uuid} 
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails     ${data_product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails.ProductWarranty   ${warranty_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceWarranties   ${warranty_data}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}      ${request} 
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn ${number_line} Dòng Với Sản Phẩm ${product_id} Thời hạn Bảo Hành ${number_time} ${number_time_type} 
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với hàng hóa nhiều dòng có bảo hành
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${warranty_data}=    Deep Copy    ${invoice_warranty_body}
    ${uuid}       Generate Random String    15    WA[NUMBERS]
    ${number_time_type_value}   Transform Time Type    ${number_time_type}    
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    ProductId    ${product_id}
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    UseWarranty    ${TRUE}
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    IsMaster    ${TRUE}
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    Uuid    ${uuid}

    ${warranty_data}     Update Info Warranty    ${warranty_data}   1   ${number_time}    ${number_time_type_value}   ${product_id}   
    ${warranty_data}     Update Nested Dictionary Property    ${warranty_data}    InvoiceDetailUuid    ${uuid} 
    ${data_product}    Update Nested Dictionary Property    ${data_product}    ProductWarranty    ${warranty_data}
    ${data_product_list}=    Create List    ${data_product}
    ${warranty_data_list}=    Create List      ${warranty_data}
    FOR    ${item_number_line}    IN RANGE    ${number_line}
        ${data_product_new}=    Deep Copy    ${data_product}
        ${warranty_data_new}=    Deep Copy    ${warranty_data}
        ${uuid_2}       Generate Random String    15    WA[NUMBERS]
        ${data_product_new}=    Update Nested Dictionary Property    ${data_product_new}    IsMaster    ${FALSE}
        ${data_product_new}=    Update Nested Dictionary Property    ${data_product_new}    ProductWarranty    ${warranty_data_new}
        ${data_product_new}=    Update Nested Dictionary Property    ${data_product_new}    Uuid    ${uuid_2}
        ${warranty_data_new}=    Update Nested Dictionary Property    ${warranty_data_new}    InvoiceDetailUuid    ${uuid_2}
        Append To List    ${data_product_list}    ${data_product_new}
        Append To List    ${warranty_data_list}    ${warranty_data_new}
    END

    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails     ${data_product_list}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceWarranties   ${warranty_data_list}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}      ${request} 
    RETURN    ${request}
        


#### THEN keywords for verification
Xác Thực Hóa Đơn Có Sản Phẩm ${product_id} BHBT Trong CSDL
    [Documentation]    Xác thực hóa đơn có sản phẩm bảo hành được lưu trong CSDL
    ${query_details}=    Set Variable    SELECT Id FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ? AND UseWarranty = 1
    ${result_details}=    Fetch One    ${query_details}    ${INVOICE_ID}    ${product_id}
    Should Not Be Equal    ${result_details}    None    Không tìm thấy chi tiết hóa đơn với sản phẩm bảo hành ID: ${product_id}


Xác Thực Hóa Đơn Có ${number_line} Sản Phẩm ${product_id} BHBT Trong CSDL
    [Documentation]    Xác thực hóa đơn có sản phẩm bảo hành được lưu trong CSDL
    ${number_line_value}    Evaluate    ${number_line} + 1
    ${query_details}=    Set Variable    SELECT COUNT(Id) FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ? AND UseWarranty = 1
    ${result_details}=    Fetch One    ${query_details}    ${INVOICE_ID}    ${product_id}
    Should Be Equal   ${result_details[0]}    ${number_line_value}    Số lượng sản phẩm bảo hành không khớp: ${result_details[0]} != ${number_line_value}


Xác Thực Thông Sản Phẩm ${product_id} Chứa Nhiều Thời Hạn BHBT ${warranty_name} ${number_time} ${number_time_type} Được Lưu Trong CSDL
    [Documentation]    Xác thực thông tin sản phẩm chứa nhiều thời hạn bảo hành được lưu trong CSDL
    ${number_time_type_list}    Create List
    FOR     ${item_number_time_type}    IN      @{number_time_type}
        ${number_time_type_value}   Transform Time Type    ${item_number_time_type}
        ${number_time_type_value}    Convert To Number    ${number_time_type_value}
        Append To List    ${number_time_type_list}    ${number_time_type_value}
    END
    ${query_details}=    Set Variable    SELECT Description, NumberTime, TimeType FROM InvoiceWarranty WHERE InvoiceId = ? AND ProductId = ? AND WarrantyType = 1
    ${result_details}=    Fetch All    ${query_details}    ${INVOICE_ID}    ${product_id}
    Should Not Be Equal    ${result_details}    None    Không tìm thấy chi tiết hóa đơn với sản phẩm bảo hành ID: ${product_id}
    ${result_details_list_name}=    Create List
    ${result_details_list_number_time}=    Create List
    ${result_details_list_number_time_type}=    Create List
    FOR    ${item_result_details}    IN    @{result_details}
        ${item_result_details_list_number_time}=    Convert To String    ${item_result_details[1]}
        Append To List    ${result_details_list_name}    ${item_result_details[0]}
        Append To List    ${result_details_list_number_time}    ${item_result_details_list_number_time}
        Append To List    ${result_details_list_number_time_type}    ${item_result_details[2]}
    END
    Should Be Equal    ${result_details_list_name}        ${warranty_name}
    Should Be Equal    ${result_details_list_number_time}    ${number_time}        
    Should Be Equal   ${result_details_list_number_time_type}    ${number_time_type_list}

Xác Thực Thông Tin ${warranty_type} Sản Phẩm ${product_id} Được Lưu Với Thời Hạn ${warranty_period} ${warranty_period_type}
    [Documentation]    Xác thực thông tin bảo hành được lưu với thời hạn ${warranty_period} ${warranty_period_type}
    ${warranty_period_type_value}   Transform Time Type    ${warranty_period_type}
    ${warranty_type_value}      Transform Warranty Type    ${warranty_type}
    ${query}=    Set Variable    SELECT Id, NumberTime,TimeType FROM InvoiceWarranty WHERE InvoiceId = ? AND ProductId = ? AND WarrantyType = ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}    ${product_id}    ${warranty_type_value}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin bảo hành
    Should Be Equal As Numbers     ${result[1]}    ${warranty_period}    Thời hạn bảo hành không khớp: ${result[1]} != ${warranty_period}
    Should Be Equal As Numbers    ${result[2]}    ${warranty_period_type_value}    Loại thời hạn bảo hành không khớp: ${result[2]} != ${warranty_period_type_value}
    ${query_inventory}=    Set Variable    SELECT OnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result_inventory}=    Fetch One    ${query_inventory}    ${WARRANTY_PRODUCT_ID}    ${DEFAULT_BRANCH_ID}
    Should Not Be Equal    ${result_inventory}    None    Không tìm thấy thông tin tồn kho của sản phẩm bảo hành


Xác Thực Thông Tin ${warranty_type} Có ${number_line} Dòng Sản Phẩm ${product_id} Được Lưu Với Thời Hạn ${warranty_period} ${warranty_period_type}
    [Documentation]    Xác thực thông tin bảo hành được lưu với thời hạn ${warranty_period} ${warranty_period_type}
    ${warranty_period_type_value}   Transform Time Type    ${warranty_period_type}
    ${warranty_type_value}      Transform Warranty Type    ${warranty_type}
    ${query}=    Set Variable    SELECT Id, NumberTime,TimeType FROM InvoiceWarranty WHERE InvoiceId = ? AND ProductId = ? AND WarrantyType = ?
    ${result}=    Fetch All    ${query}    ${INVOICE_ID}    ${product_id}    ${warranty_type_value}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin bảo hành
    ${result_length}=    Get Length    ${result}
    FOR    ${item_result}    IN    @{result}
        Should Be Equal As Numbers     ${item_result[1]}    ${warranty_period}    Thời hạn bảo hành không khớp: ${item_result[1]} != ${warranty_period}
        Should Be Equal As Numbers    ${item_result[2]}    ${warranty_period_type_value}    Loại thời hạn bảo hành không khớp: ${item_result[2]} != ${warranty_period_type_value}
    END
    ${number_line_value}    Evaluate    ${number_line} + 1
    Should Be Equal    ${result_length}    ${number_line_value}    Số lượng sản phẩm bảo hành không khớp: ${result_length} != ${number_line_value}


Xác Thực Hóa Đơn Có Sản Phẩm BHBT Serial Trong CSDL
    [Documentation]    Xác thực hóa đơn có sản phẩm bảo hành có serial được lưu trong CSDL
    ${invoice_id}=    Get Response Property    id
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}
    
    ${query}=    Set Variable    SELECT Id, Code, Total FROM Invoices WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy hóa đơn với ID: ${invoice_id}
    
    ${query_details}=    Set Variable    SELECT ProductId FROM InvoiceDetails WHERE InvoiceId = ? AND ProductId = ?
    ${result_details}=    Fetch One    ${query_details}    ${invoice_id}    ${WARRANTY_PRODUCT_SERIAL_ID}
    Should Not Be Equal    ${result_details}    None    Không tìm thấy chi tiết hóa đơn với sản phẩm bảo hành ID: ${WARRANTY_PRODUCT_SERIAL_ID}
    
    ${query_serial}=    Set Variable    SELECT Status FROM Serials WHERE SerialNumber = 'BH001' AND ProductId = ?
    ${result_serial}=    Fetch One    ${query_serial}    ${WARRANTY_PRODUCT_SERIAL_ID}
    Should Not Be Equal    ${result_serial}    None    Không tìm thấy thông tin serial BH001
    ${serial_status}=    Set Variable    ${result_serial[0]}
    Should Be Equal As Numbers    ${serial_status}    2    Serial BH001 chưa được chuyển sang trạng thái đã bán (2)


Xác Thực Phiếu Bảo Hành Được Tạo Tự Động
    [Documentation]    Xác thực phiếu bảo hành được tạo tự động
    ${query}=    Set Variable    SELECT Id, InvoiceId FROM WarrantyTickets WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy phiếu bảo hành tự động được tạo cho hóa đơn với ID: ${INVOICE_ID}
    ${warranty_ticket_id}=    Set Variable    ${result[0]}
    Set Test Variable    ${WARRANTY_TICKET_ID}    ${warranty_ticket_id}

Xác Thực Thông Tin ${product_id} Serial ${serial_number} Trong Phiếu Bảo Hành
    [Documentation]    Xác thực thông tin serial ${serial_number} trong phiếu bảo hành
    ${query}=    Set Variable    SELECT SerialNumbers FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}    ${product_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin chi tiết phiếu bảo hành
    ${serial_number_result}=    Set Variable    ${result[0]}
    Should Be Equal    ${serial_number_result}    ${serial_number}    Serial không khớp: ${serial_number_result} != ${serial_number}

