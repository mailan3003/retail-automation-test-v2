*** Settings ***
Documentation     Dữ liệu liên quan đến bảo hành sản phẩm
Resource          ../CommonData.robot

*** Variables ***
# Warranty product data
${WARRANTY_PRODUCT_ID}           1000014799
${WARRANTY_PRODUCT_CODE}         HBH06 

${WARRANTY_PRODUCT_SERIAL_ID}    1000014421
${WARRANTY_PRODUCT_SERIAL_CODE}  SIBH02

${WARRANTY_PRODUCT_BATCH_ID}         1000015927
${WARRANTY_PRODUCT_BATCH_NAME}       ABC
${WARRANTY_PRODUCT_BATCH_CODE}       LD01

${WARRANTY_PRODUCT_ID_2}         1000017356
${WARRANTY_PRODUCT_CODE_2}       	DVBH03 

# Warranty ticket data 
${WARRANTY_TICKET_PREFIX}        BH
${WARRANTY_TICKET_STATUS_NEW}    1
${WARRANTY_TICKET_STATUS_PROCESSING}    2
${WARRANTY_TICKET_STATUS_COMPLETED}      3
${WARRANTY_TICKET_STATUS_CANCELLED}      4

# Serial numbers
${WARRANTY_SERIAL_NUMBER}        IMBT02 
@{warranty_name}     Toàn bộ sản phẩm    Phần cứng       1 đổi 1
@{number_time}       35       5      2
@{number_time_type}    Ngày       Tháng     Năm