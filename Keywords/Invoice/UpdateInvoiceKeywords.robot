*** Settings ***
Documentation     Keywords for update invoice validation tests
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../../TestData/Invoice/UpdateInvoiceData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Resource          ../../Config/Env_api.robot
Library           ../../Resources/DatabaseLibrary.py
Library           ../../Resources/RedisLibrary.py    ${REDIS_HOST}    ${REDIS_PORT}    ${REDIS_DB}    ${REDIS_PASSWORD}
Library           Collections
Library           json
Library           RequestsLibrary

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật Tiêu Chuẩn
    ${request}=    Deep Copy    ${UPDATE_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật Với Thay Đổi Thông Tin Giao Hàng
    ${request}=    Deep Copy    ${invoice_request_body}
    ${delivery_detail}=    Deep Copy    ${default_delivery_detail_body}
    ${delivery_detail}=    Update Nested Dictionary Property    ${delivery_detail}    UseDefaultPartner    ${TRUE}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.DeliveryDetail    ${delivery_detail}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.UpdateInvoiceId    ${UPDATE_INVOICE_ID_USE_DEFAULT_PARTNER}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    ${UPDATE_INVOICE_CODE_USE_DEFAULT_PARTNER}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật Với Thay Đổi Khách Hàng Đã Thanh Toán
    ${request}=    Deep Copy    ${invoice_request_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.UpdateInvoiceId    ${UPDATE_INVOICE_ID_WRONG_CUSTOMER}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    ${UPDATE_INVOICE_CODE_WRONG_CUSTOMER}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.CustomerId    ${UPDATE_INVOICE_CUSTOMER_ID_WRONG_CUSTOMER}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật Với Hóa Đơn Đã Có Trả Hàng
    ${request}=    Deep Copy    ${invoice_request_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.UpdateInvoiceId    ${UPDATE_INVOICE_ID_CONTAIN_RETURN}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    ${UPDATE_INVOICE_ID_CONTAIN_RETURN_CODE}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}