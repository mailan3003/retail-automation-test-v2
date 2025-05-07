*** Settings ***
Documentation     Keywords for prescription validation test cases
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../../TestData/Invoice/PrescriptionData.robot
Resource          ../Utilities/DataUtilities.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           ../../Resources/RedisLibrary.py    ${REDIS_HOST}    ${REDIS_PORT}    ${REDIS_DB}    ${REDIS_PASSWORD}
Library           Collections
Library           String
Library           json

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Không Có Thông Tin Đơn Thuốc Và Bệnh Nhân
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    # Thiết lập cho nhà thuốc GPP
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.UsingPrescription    1
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Prescription    ${EMPTY_PRESCRIPTION}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Patient    ${EMPTY_PATIENT}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    HD_TEST_EMPTY_PRESCRIPTION
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Toàn Cục Với Sản Phẩm Thiếu Mô Tả
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    # Thiết lập cho nhà thuốc GPP với đơn thuốc toàn cục
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.UsingPrescription    1
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.UsingGlobalPrescription    1
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Prescription    ${COMPLETE_PRESCRIPTION}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Patient    ${COMPLETE_PATIENT}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Medicines    ${LIST_MEDICINE_WITH_DESCRIPTION}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${LIST_INVOICE_DETAILS_WITHOUT_NOTE}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    HD_TEST_NO_DESCRIPTION
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với Mã Đơn Thuốc Quá Dài
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    # Thiết lập cho nhà thuốc GPP với mã đơn thuốc dài
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.UsingPrescription    1
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Prescription    ${PRESCRIPTION_WITH_LONG_CODE}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Patient    ${COMPLETE_PATIENT}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    HD_TEST_LONG_CODE
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Đơn Thuốc Đã Tồn Tại
    [Arguments]    ${existing_code}=DT001
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    # Thiết lập cho nhà thuốc GPP với mã đơn thuốc đã tồn tại
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.UsingPrescription    1
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.UsingGlobalPrescription    0
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Prescription    ${COMPLETE_PRESCRIPTION}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Patient    ${COMPLETE_PATIENT}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    HD_TEST_EXISTING_CODE
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với Mã Đơn Thuốc ID Không Code
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    # Thiết lập cho nhà thuốc GPP với đơn thuốc có ID nhưng không có mã
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.UsingPrescription    1
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Prescription    ${PRESCRIPTION_WITH_ID_NO_CODE}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Patient    ${COMPLETE_PATIENT}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    HD_TEST_ID_NO_CODE
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}