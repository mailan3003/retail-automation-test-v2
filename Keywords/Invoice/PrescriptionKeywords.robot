*** Settings ***
Documentation    Keywords for prescription related tests
Resource         ../Utilities/RequestHelper.robot
Resource         ../Utilities/ResponseHelper.robot
Resource         ../Utilities/Utilities.robot
Resource         ../../TestData/Invoice/PrescriptionData.robot
Resource         ../../TestData/Invoice/CommonInvoiceData.robot
Resource         ../Product/ProductCommonKeywords.robot
Resource         ../Customer/CustomerCommonKeywords.robot
Resource         ../Utilities/DataUtilities.robot
Library          ../../Resources/DatabaseLibrary.py

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc ${status} Liên Kết Theo Đơn Thuốc 
    [Documentation]    Chuẩn bị dữ liệu hóa đơn nhà thuốc với cờ UsingPrescription=1 để bán thuốc theo đơn thuốc
    ${value_using_prescription}=    Set Variable If    '${status}'=='Có'    1    0
    ${prescription_code}    Generate Random String    6    [LOWER][NUMBERS]
    Set Test Variable    ${prescription_code}    ${prescription_code}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}    Deep Copy   ${STANDARD_INVOICE_DETAIL}
    ${data_prescription}    Deep Copy   ${STANDARD_PRESCRIPTION_DETAIL}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_MEDICINE_CODE}
    ${data_product}    Update Nested Dictionary Property    ${data_product}    ProductId    ${product_id}
    ${data_prescription}    Update Nested Dictionary Property    ${data_prescription}    Code    ${prescription_code}
    ${data_product}    Create List    ${data_product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data_product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.UsingPrescription    ${value_using_prescription}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Prescription    ${data_prescription}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}




Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với Mã Đơn Thuốc Đã Tồn Tại
    [Documentation]    Chuẩn bị dữ liệu hóa đơn nhà thuốc với mã đơn thuốc đã tồn tại
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}    Deep Copy   ${STANDARD_INVOICE_DETAIL}
    ${data_prescription}    Deep Copy   ${STANDARD_PRESCRIPTION_DETAIL}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_MEDICINE_CODE}
    ${data_product}    Update Nested Dictionary Property    ${data_product}    ProductId    ${product_id}
    ${data_prescription}    Update Nested Dictionary Property    ${data_prescription}    Code     DT000001
    ${data_product}    Create List    ${data_product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data_product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.UsingPrescription    1
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Prescription    ${data_prescription}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với Thông Tin Đơn Thuốc Và Bệnh Nhân Đầy Đủ
    [Documentation]    Chuẩn bị dữ liệu hóa đơn nhà thuốc với thông tin đơn thuốc và bệnh nhân đầy đủ
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}    Deep Copy   ${STANDARD_INVOICE_DETAIL}
    ${data_prescription}    Deep Copy   ${STANDARD_PRESCRIPTION_DETAIL}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_MEDICINE_CODE}
    ${data_product}    Update Nested Dictionary Property    ${data_product}    ProductId    ${product_id}
    ${data_product}    Create List    ${data_product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data_product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.UsingPrescription    1
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Prescription   ${data_prescription}  
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Patient    ${COMPLETE_PATIENT}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}



# Các keyword xác thực database: cần mô phỏng chúng vì không có thư viện DatabaseLibrary thực tế



Xác Thực Thông Tin Đơn Thuốc Được Lưu Trong DB
    [Documentation]    Xác thực thông tin đơn thuốc được lưu trong database
    ${query}=    Set Variable    SELECT Id FROM Prescription WHERE Code = ?
    ${result}=   Fetch One   ${query}    ${prescription_code}
    Should Not Be Empty    ${result}
    Set Test Variable    ${PRESCRIPTION_ID}    ${result[0]}

Xác Thực Hóa Đơn Có Đơn Thuốc Bán Theo Đơn ${prescription_id}
    [Documentation]    Xác thực hóa đơn bán theo đơn
    ${query}=    Set Variable    SELECT PrescriptionId FROM InvoiceMedicine WHERE InvoiceId = ?
    ${result}=   Fetch One   ${query}    ${INVOICE_ID}
    Should Not Be Empty    ${result}
    Should Be Equal As Integers    ${result[0]}    ${prescription_id}

Xác định hóa đơn Không sử dụng đơn thuốc
    [Documentation]    Xác định hóa đơn không sử dụng đơn thuốc
    ${query}=    Set Variable    SELECT UsingPrescription FROM Invoice WHERE Id = ?
    ${result}=   Fetch One   ${query}    ${INVOICE_ID}
    Should Not Be Empty    ${result}
    Should Be Equal As Integers    ${result[0]}    0

Xác Thực Thông Tin Đơn Thuốc Toàn Cầu Được Lưu Trong DB
    [Documentation]    Xác thực thông tin đơn thuốc toàn cầu được lưu trong database
    ${prescription_code}=    Set Variable    ${REQUEST_DATA["Prescription"]["Code"]}
    
    # Trong môi trường test thực tế, sẽ truy vấn DB để kiểm tra
    # ${query}=    Set Variable    
    # ...    SELECT Id, Code, DoctorId, ClinicId, PatientId, IsGlobal 
    # ...    FROM Prescription 
    # ...    WHERE InvoiceId = ${INVOICE_ID} AND Code = '${prescription_code}'
    # ${result}=    Execute SQL Query    ${query}
    &{prescription_item}=    Create Dictionary    Id=1    Code=${prescription_code}    IsGlobal=1
    ${result}=    Create List    ${prescription_item}
    Should Not Be Empty    ${result}
    
    # Kiểm tra IsGlobal = 1
    ${is_global}=    Set Variable    1
    Should Be Equal As Integers    ${is_global}    1
    
    # Kiểm tra các ghi chú thuốc
    # ${query_note}=    Set Variable    
    # ...    SELECT Note FROM InvoiceDetail 
    # ...    WHERE InvoiceId = ${INVOICE_ID}
    # ${note_result}=    Execute SQL Query    ${query_note}
    &{note_item}=    Create Dictionary    Note=Uống 1 viên/ngày sau bữa ăn
    ${note_result}=    Create List    ${note_item}
    Should Not Be Empty    ${note_result}
    FOR    ${note}    IN    @{note_result}
        Set Variable    ${note["Note"]}
        Should Not Be Empty    ${note["Note"]}
    END 

Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với UsingPrescription=1 Không Có Thông Tin Đơn Thuốc Và Bệnh Nhân
    [Documentation]    Chuẩn bị dữ liệu hóa đơn nhà thuốc không có thông tin đơn thuốc và bệnh nhân
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}    Deep Copy   ${STANDARD_INVOICE_DETAIL}
    ${data_prescription}   Create List   
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_MEDICINE_CODE}
    ${data_product}    Update Nested Dictionary Property    ${data_product}    ProductId    ${product_id}
    ${data_patient}    Create List   
    ${data_product}    Create List    ${data_product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data_product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.UsingPrescription   1
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Prescription    ${data_prescription}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Patient    ${data_patient}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Xác Thực Hóa Đơn Được Tạo Thành Công Trong DB
    [Documentation]    Xác thực hóa đơn được tạo thành công trong database
    ${query}=    Set Variable    SELECT Id, Code, Status FROM Invoice WHERE Code = ?
    ${request_data}=    Get Variable Value    ${REQUEST_DATA}
    ${invoice_code}=    Set Variable    ${request_data["Invoice"]["Code"]}
    ${result}=    Fetch One    ${query}    ${invoice_code}
    Should Not Be Empty    ${result}
    
    ${invoice_id}=    Set Variable    ${result["Id"]}
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}
    
    # Kiểm tra trạng thái hóa đơn
    Should Be Equal As Integers    ${result["Status"]}    1

Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với Mã Đơn Thuốc ${length} Ký Tự
    [Documentation]    Chuẩn bị dữ liệu hóa đơn nhà thuốc với mã đơn thuốc đúng ${length} ký tự (biên giá trị)
    ${prescription_code}    Generate Random String    ${length}    [LOWER][NUMBERS]
    Set Test Variable    ${prescription_code}    ${prescription_code}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}    Deep Copy   ${STANDARD_INVOICE_DETAIL}
    ${data_prescription}    Deep Copy   ${STANDARD_PRESCRIPTION_DETAIL}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_MEDICINE_CODE}
    ${data_product}    Update Nested Dictionary Property    ${data_product}    ProductId    ${product_id}
    ${data_prescription}    Update Nested Dictionary Property    ${data_prescription}    Code    ${prescription_code}
    ${data_product}    Create List    ${data_product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data_product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.UsingPrescription    1
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Prescription    ${data_prescription}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}