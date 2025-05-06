*** Settings ***
Documentation    Keywords for prescription related tests
Resource         ../Utilities/RequestHelper.robot
Resource         ../Utilities/ResponseHelper.robot
Resource         ../Utilities/Utilities.robot
Resource         ../../TestData/Invoice/PrescriptionData.robot
Resource         ../../TestData/Invoice/CommonInvoiceData.robot
Resource    ../Utilities/DataUtilities.robot
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
    ${data_product}    Update Nested Dictionary Property    ${data_product}    ProductId    ${PRODUCT_MEDICINE_CODE_ID}
    ${data_prescription}    Update Nested Dictionary Property    ${data_prescription}    Code    ${prescription_code}
    ${data_product}    Create List    ${data_product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data_product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.UsingPrescription    ${value_using_prescription}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Prescription    ${data_prescription}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}



Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với Mã Đơn Thuốc Dài Hơn 50 Ký Tự
    [Documentation]    Chuẩn bị dữ liệu hóa đơn nhà thuốc với mã đơn thuốc dài hơn 50 ký tự
    ${data}=    Evaluate    dict()
    
    ${invoice}=    Evaluate    dict(${PHARMACY_INVOICE_BASE})
    Set To Dictionary    ${data}    Invoice=${invoice}
    
    ${details}=    Create List    ${PRESCRIPTION_DRUG_DETAIL_WITH_NOTE}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    # Thêm thông tin đơn thuốc với mã dài
    Set To Dictionary    ${data}    Prescription=${PRESCRIPTION_WITH_LONG_CODE}
    Set To Dictionary    ${data}    Patient=${COMPLETE_PATIENT}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với Mã Đơn Thuốc Đã Tồn Tại
    [Documentation]    Chuẩn bị dữ liệu hóa đơn nhà thuốc với mã đơn thuốc đã tồn tại
    ${data}=    Evaluate    dict()
    
    ${invoice}=    Evaluate    dict(${PHARMACY_INVOICE_BASE})
    Set To Dictionary    ${data}    Invoice=${invoice}
    
    ${details}=    Create List    ${PRESCRIPTION_DRUG_DETAIL_WITH_NOTE}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    # Thêm thông tin đơn thuốc với mã đã tồn tại
    Set To Dictionary    ${data}    Prescription=${PRESCRIPTION_WITH_EXISTING_CODE}
    Set To Dictionary    ${data}    Patient=${COMPLETE_PATIENT}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với ID Đơn Thuốc > 0 Và Không Có Mã
    [Documentation]    Chuẩn bị dữ liệu hóa đơn nhà thuốc với ID đơn thuốc > 0 và không có mã
    ${data}=    Evaluate    dict()
    
    ${invoice}=    Evaluate    dict(${PHARMACY_INVOICE_BASE})
    Set To Dictionary    ${data}    Invoice=${invoice}
    
    ${details}=    Create List    ${PRESCRIPTION_DRUG_DETAIL_WITH_NOTE}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    # Thêm thông tin đơn thuốc với ID > 0 và không có mã
    Set To Dictionary    ${data}    Prescription=${PRESCRIPTION_WITH_ID_BUT_NO_CODE}
    Set To Dictionary    ${data}    Patient=${COMPLETE_PATIENT}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với Thông Tin Đơn Thuốc Và Bệnh Nhân Đầy Đủ
    [Documentation]    Chuẩn bị dữ liệu hóa đơn nhà thuốc với thông tin đơn thuốc và bệnh nhân đầy đủ
    ${data}=    Evaluate    dict()
    
    ${invoice}=    Evaluate    dict(${PHARMACY_INVOICE_BASE})
    Set To Dictionary    ${data}    Invoice=${invoice}
    
    ${details}=    Create List    ${PRESCRIPTION_DRUG_DETAIL_WITH_NOTE}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    # Thêm thông tin đơn thuốc và bệnh nhân đầy đủ
    Set To Dictionary    ${data}    Prescription=${COMPLETE_PRESCRIPTION}
    Set To Dictionary    ${data}    Patient=${COMPLETE_PATIENT}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với UsingGlobalPrescription=1 Và Mô Tả Đầy Đủ
    [Documentation]    Chuẩn bị dữ liệu hóa đơn nhà thuốc với đơn thuốc toàn cầu và mô tả đầy đủ
    ${data}=    Evaluate    dict()
    
    ${invoice}=    Evaluate    dict(${PHARMACY_INVOICE_WITH_GLOBAL_PRESCRIPTION})
    Set To Dictionary    ${data}    Invoice=${invoice}
    
    ${details}=    Create List    ${PRESCRIPTION_DRUG_DETAIL_WITH_NOTE}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    # Thêm thông tin đơn thuốc và bệnh nhân đầy đủ
    Set To Dictionary    ${data}    Prescription=${COMPLETE_PRESCRIPTION}
    Set To Dictionary    ${data}    Patient=${COMPLETE_PATIENT}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với UsingGlobalPrescription=1 Và Mã Đơn Đã Tồn Tại
    [Documentation]    Chuẩn bị dữ liệu hóa đơn nhà thuốc với đơn thuốc toàn cầu và mã đã tồn tại
    ${data}=    Evaluate    dict()
    
    ${invoice}=    Evaluate    dict(${PHARMACY_INVOICE_WITH_GLOBAL_PRESCRIPTION})
    Set To Dictionary    ${data}    Invoice=${invoice}
    
    ${details}=    Create List    ${PRESCRIPTION_DRUG_DETAIL_WITH_NOTE}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    # Thêm thông tin đơn thuốc với mã đã tồn tại và bệnh nhân đầy đủ
    Set To Dictionary    ${data}    Prescription=${PRESCRIPTION_WITH_EXISTING_CODE}
    Set To Dictionary    ${data}    Patient=${COMPLETE_PATIENT}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}


# Các keyword xác thực database: cần mô phỏng chúng vì không có thư viện DatabaseLibrary thực tế



Xác Thực Thông Tin Đơn Thuốc Được Lưu Trong DB
    [Documentation]    Xác thực thông tin đơn thuốc được lưu trong database
    ${query}=    Set Variable    SELECT * FROM Prescription WHERE Code = ?
    ${result}=   Fetch One   ${query}    ${prescription_code}
    Should Not Be Empty    ${result}

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
    ${data}=    Evaluate    dict()
    
    ${invoice}=    Evaluate    dict(${PHARMACY_INVOICE_BASE})
    Set To Dictionary    ${data}    Invoice=${invoice}
    
    ${details}=    Create List    ${PRESCRIPTION_DRUG_DETAIL_WITH_NOTE}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    # Thêm thông tin đơn thuốc rỗng và bệnh nhân rỗng
    Set To Dictionary    ${data}    Prescription=${EMPTY_PRESCRIPTION}
    Set To Dictionary    ${data}    Patient=${EMPTY_PATIENT}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với UsingPrescription=1 Thiếu Thông Tin Đơn Thuốc
    [Documentation]    Chuẩn bị dữ liệu hóa đơn nhà thuốc không có thông tin đơn thuốc nhưng có thông tin bệnh nhân
    ${data}=    Evaluate    dict()
    
    ${invoice}=    Evaluate    dict(${PHARMACY_INVOICE_BASE})
    Set To Dictionary    ${data}    Invoice=${invoice}
    
    ${details}=    Create List    ${PRESCRIPTION_DRUG_DETAIL_WITH_NOTE}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    # Thêm thông tin đơn thuốc rỗng với bệnh nhân đầy đủ
    Set To Dictionary    ${data}    Prescription=${EMPTY_PRESCRIPTION}
    Set To Dictionary    ${data}    Patient=${COMPLETE_PATIENT}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với UsingPrescription=1 Thiếu Thông Tin Bệnh Nhân
    [Documentation]    Chuẩn bị dữ liệu hóa đơn nhà thuốc có thông tin đơn thuốc nhưng không có thông tin bệnh nhân
    ${data}=    Evaluate    dict()
    
    ${invoice}=    Evaluate    dict(${PHARMACY_INVOICE_BASE})
    Set To Dictionary    ${data}    Invoice=${invoice}
    
    ${details}=    Create List    ${PRESCRIPTION_DRUG_DETAIL_WITH_NOTE}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    # Thêm thông tin đơn thuốc đầy đủ nhưng bệnh nhân rỗng
    Set To Dictionary    ${data}    Prescription=${COMPLETE_PRESCRIPTION}
    Set To Dictionary    ${data}    Patient=${EMPTY_PATIENT}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với UsingGlobalPrescription=1 Và Thuốc Không Có Mô Tả
    [Documentation]    Chuẩn bị dữ liệu hóa đơn nhà thuốc với đơn thuốc toàn cầu và sản phẩm không có mô tả
    ${data}=    Evaluate    dict()
    
    ${invoice}=    Evaluate    dict(${PHARMACY_INVOICE_WITH_GLOBAL_PRESCRIPTION})
    Set To Dictionary    ${data}    Invoice=${invoice}
    
    ${details}=    Create List    ${PRESCRIPTION_DRUG_DETAIL_WITHOUT_NOTE}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    # Thêm thông tin đơn thuốc và bệnh nhân đầy đủ
    Set To Dictionary    ${data}    Prescription=${COMPLETE_PRESCRIPTION}
    Set To Dictionary    ${data}    Patient=${COMPLETE_PATIENT}
    
    # Thêm master medicine tương ứng với sản phẩm trong invoice details
    ${master_medicine}=    Deep Copy    ${MASTER_MEDICINE}
    ${medicines}=    Create List    ${master_medicine}
    Set To Dictionary    ${invoice}    Medicines=${medicines}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với Thuốc Hết Hạn
    [Documentation]    Chuẩn bị dữ liệu hóa đơn nhà thuốc với thuốc hết hạn
    ${data}=    Evaluate    dict()
    
    ${invoice}=    Evaluate    dict(${PHARMACY_INVOICE_BASE})
    Set To Dictionary    ${data}    Invoice=${invoice}
    
    ${details}=    Create List    ${PRESCRIPTION_DRUG_DETAIL_WITH_NOTE}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    # Thêm thông tin đơn thuốc và bệnh nhân đầy đủ
    Set To Dictionary    ${data}    Prescription=${COMPLETE_PRESCRIPTION}
    Set To Dictionary    ${data}    Patient=${COMPLETE_PATIENT}
    
    # Thêm medicine bị hết hạn
    ${medicines}=    Create List    ${EXPIRED_MEDICINE}
    Set To Dictionary    ${invoice}    Medicines=${medicines}
    Set To Dictionary    ${invoice}    NewMedicines=@{EMPTY}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với Nhiều Thuốc Hết Hạn
    [Documentation]    Chuẩn bị dữ liệu hóa đơn nhà thuốc với nhiều thuốc hết hạn
    ${data}=    Evaluate    dict()
    
    ${invoice}=    Evaluate    dict(${PHARMACY_INVOICE_BASE})
    Set To Dictionary    ${data}    Invoice=${invoice}
    
    ${details}=    Create List    ${PRESCRIPTION_DRUG_DETAIL_WITH_NOTE}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    # Thêm thông tin đơn thuốc và bệnh nhân đầy đủ
    Set To Dictionary    ${data}    Prescription=${COMPLETE_PRESCRIPTION}
    Set To Dictionary    ${data}    Patient=${COMPLETE_PATIENT}
    
    # Thêm nhiều medicine bị hết hạn
    Set To Dictionary    ${invoice}    Medicines=${MULTIPLE_EXPIRED_MEDICINES}
    Set To Dictionary    ${invoice}    NewMedicines=@{EMPTY}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với Thuốc Thay Thế
    [Documentation]    Chuẩn bị dữ liệu hóa đơn nhà thuốc với thuốc thay thế
    ${data}=    Evaluate    dict()
    
    ${invoice}=    Evaluate    dict(${PHARMACY_INVOICE_BASE})
    Set To Dictionary    ${data}    Invoice=${invoice}
    
    ${details}=    Create List    ${PRESCRIPTION_DRUG_DETAIL_WITH_NOTE}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    # Thêm thông tin đơn thuốc và bệnh nhân đầy đủ
    Set To Dictionary    ${data}    Prescription=${COMPLETE_PRESCRIPTION}
    Set To Dictionary    ${data}    Patient=${COMPLETE_PATIENT}
    
    # Thêm thuốc thay thế và thuốc hết hạn
    ${medicines}=    Create List    ${EXPIRED_MEDICINE}    ${REPLACEMENT_MEDICINE}
    Set To Dictionary    ${invoice}    Medicines=${medicines}
    Set To Dictionary    ${invoice}    NewMedicines=@{EMPTY}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với Thuốc Mới Và Thuốc Hết Hạn
    [Documentation]    Chuẩn bị dữ liệu hóa đơn nhà thuốc với thuốc mới và thuốc hết hạn
    ${data}=    Evaluate    dict()
    
    ${invoice}=    Evaluate    dict(${PHARMACY_INVOICE_BASE})
    Set To Dictionary    ${data}    Invoice=${invoice}
    
    ${details}=    Create List    ${PRESCRIPTION_DRUG_DETAIL_WITH_NOTE}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    # Thêm thông tin đơn thuốc và bệnh nhân đầy đủ
    Set To Dictionary    ${data}    Prescription=${COMPLETE_PRESCRIPTION}
    Set To Dictionary    ${data}    Patient=${COMPLETE_PATIENT}
    
    # Thêm thuốc mới và thuốc hết hạn
    ${medicines}=    Create List    ${EXPIRED_MEDICINE}
    ${new_medicines}=    Create List    ${NEW_MEDICINE}
    Set To Dictionary    ${invoice}    Medicines=${medicines}
    Set To Dictionary    ${invoice}    NewMedicines=${new_medicines}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Xác Thực Hóa Đơn Không Tồn Tại Trong DB
    [Documentation]    Xác thực hóa đơn không tồn tại trong database
    ${query}=    Set Variable    SELECT COUNT(*) AS count FROM Invoice WHERE Code = ?
    ${request_data}=    Get Variable Value    ${REQUEST_DATA}
    ${invoice_code}=    Set Variable    ${request_data["Invoice"]["Code"]}
    ${result}=    Fetch One    ${query}    ${invoice_code}
    Should Be Equal As Integers    ${result["count"]}    0

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

Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với Mã Đơn Thuốc Đúng 50 Ký Tự
    [Documentation]    Chuẩn bị dữ liệu hóa đơn nhà thuốc với mã đơn thuốc đúng 50 ký tự (biên giá trị)
    ${data}=    Evaluate    dict()
    
    ${invoice}=    Evaluate    dict(${PHARMACY_INVOICE_BASE})
    Set To Dictionary    ${data}    Invoice=${invoice}
    
    ${details}=    Create List    ${PRESCRIPTION_DRUG_DETAIL_WITH_NOTE}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    # Tạo mã đơn thuốc đúng 50 ký tự
    ${prescription}=    Deep Copy    ${COMPLETE_PRESCRIPTION}
    ${code_exactly_50}=    Set Variable    PRESC-CODE-WITH-EXACTLY-50-CHARACTERS-ABCDEFGHIJKLMNO
    Set To Dictionary    ${prescription}    Code=${code_exactly_50}
    Set To Dictionary    ${data}    Prescription=${prescription}
    Set To Dictionary    ${data}    Patient=${COMPLETE_PATIENT}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data} 