*** Variables ***
# Error Messages
${KV_MESSAGE_PRESCRIPTION_EMPTY}          Bạn chưa nhập thông tin đơn thuốc
${KV_MESSAGE_INVOICE_PRODUCT_NO_DESCRIPTION}    Hàng hóa thiếu ghi chú
${KV_MESSAGE_MEDICINE_PRODUCT_CODE_SOLD_OUT}    đã bán hết số lượng trong đơn, vui lòng xóa sản phẩm để tạo đơn.
${KV_MESSAGE_PRESCRIPTION_CODE_LENGTH_ERROR}    Mã đơn thuốc không được dài quá 50 ký tự
${KV_MESSAGE_PRESCRIPTION_CODE_ALREADY_EXIST}    Mã đơn thuốc đã tồn tại trong hệ thống
${KV_MESSAGE_PRESCRIPTION_CODE_IS_NOT_VALID}    Mã đơn thuốc không hợp lệ

# Test Data Constants
${PRODUCT_MEDICINE_CODE_ID}    1000017642

# Base pharmacy invoice data
&{PHARMACY_INVOICE_BASE}
...    Code=HD_TEST_001
...    BranchId=1000000001
...    SoldById=1000000001
...    CustomerId=1000000001
...    UsingPrescription=1
...    UsingGlobalPrescription=0

# Invoice with global prescription
&{PHARMACY_INVOICE_WITH_GLOBAL_PRESCRIPTION}
...    Code=HD_TEST_001
...    BranchId=1000000001
...    SoldById=1000000001
...    CustomerId=1000000001
...    UsingPrescription=1
...    UsingGlobalPrescription=1

# Standard prescription details
&{STANDARD_PRESCRIPTION_DETAIL}
...    DoctorId=1000000001
...    ClinicId=1000000001

# Prescription drug detail with note
&{PRESCRIPTION_DRUG_DETAIL_WITH_NOTE}
...    ProductId=${PRODUCT_MEDICINE_CODE_ID}
...    Quantity=1
...    Price=100000
...    Note=Uống 1 viên/ngày sau bữa ăn

# Standard payment
&{STANDARD_PAYMENT}
...    Method=Cash
...    Amount=100000

# Complete patient information
&{COMPLETE_PATIENT}
...    Id=0
...    Code=BN001
...    Name=Nguyễn Văn A
...    ContactNumber=0987654321
...    Address=123 Đường ABC
...    Email=patient@example.com
...    Gender=1
...    BirthDate=1990-01-01
...    IdentityCard=123456789

# Prescription with long code (more than 50 characters)
&{PRESCRIPTION_WITH_LONG_CODE}
...    Id=0
...    Code=PRESCRIPTION_CODE_WITH_MORE_THAN_FIFTY_CHARACTERS_TO_TEST_VALIDATION
...    DoctorId=1000000001
...    ClinicId=1000000001
...    Diagnosis=Viêm họng
...    Note=Uống thuốc đều đặn

# Prescription with existing code in system
&{PRESCRIPTION_WITH_EXISTING_CODE}
...    Id=0
...    Code=EXISTING_CODE
...    DoctorId=1000000001
...    ClinicId=1000000001
...    Diagnosis=Cảm cúm
...    Note=Uống thuốc sau khi ăn

# Prescription with ID but no code
&{PRESCRIPTION_WITH_ID_BUT_NO_CODE}
...    Id=1000000001
...    Code=${EMPTY}
...    DoctorId=1000000001
...    ClinicId=1000000001
...    Diagnosis=Đau đầu
...    Note=Uống thuốc khi đau

# Complete prescription with all details
&{COMPLETE_PRESCRIPTION}
...    Id=0
...    Code=PRESC001
...    DoctorId=1000000001
...    DoctorName=Bác sĩ Nguyễn Văn B
...    ClinicId=1000000001
...    ClinicName=Phòng khám Đa khoa ABC
...    Diagnosis=Viêm xoang
...    Note=Uống thuốc đều đặn, không uống rượu bia
...    Date=2023-05-20
...    UsageNote=Sau ăn 30 phút
...    ExpiredDate=2023-06-20
