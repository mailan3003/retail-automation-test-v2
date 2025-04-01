*** Settings ***
Resource    ../Utilities/Utilities.robot
Resource    ../Utilities/RequestHelper.robot
Resource    ../Utilities/ResponseHelper.robot
Resource    ../../TestData/Invoice/InputValidationData.robot
Library     Collections
Library     String
Library     DateTime

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_REQUEST})
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Không Hợp Lệ
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_REQUEST})
    Set To Dictionary    ${data["Invoice"]}    Code=${INVALID_CODE_PREFIX_INVOICE.Code}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Trùng
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_REQUEST})
    Set To Dictionary    ${data["Invoice"]}    Code=${DUPLICATED_CODE_INVOICE.Code}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Dài
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_REQUEST})
    Set To Dictionary    ${data["Invoice"]}    Code=${LONG_CODE_INVOICE.Code}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật
    [Arguments]    ${update_invoice}=${UPDATE_INVOICE}
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_REQUEST})
    Set To Dictionary    ${data}    Invoice=${update_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Từ Đơn Hàng
    [Arguments]    ${order_invoice}=${ORDER_INVOICE}
    ${data}=    Evaluate    dict(${ORDER_INVOICE_REQUEST})
    Set To Dictionary    ${data}    Invoice=${order_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Không Tồn Tại
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_REQUEST})
    Set To Dictionary    ${data}    Invoice=${NONEXISTENT_CUSTOMER_INVOICE}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Chi Nhánh Khác
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_REQUEST})
    Set To Dictionary    ${data}    Invoice=${OTHER_BRANCH_CUSTOMER_INVOICE}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Bằng Điểm
    ${data}=    Evaluate    dict(${POINT_PAYMENT_INVOICE_REQUEST})
    ${payment}=    Create Dictionary    &{POINT_PAYMENT}
    ${payments}=    Create List    ${payment}
    Set To Dictionary    ${data}    Payments=${payments}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn COD
    [Arguments]    ${delivery_info}=${VALID_DELIVERY_INFO}
    ${data}=    Evaluate    dict(${COD_INVOICE_REQUEST})
    ${payment}=    Create Dictionary    &{COD_PAYMENT}
    ${payments}=    Create List    ${payment}
    Set To Dictionary    ${data}    Payments=${payments}
    Set To Dictionary    ${data}    DeliveryDetail=${delivery_info}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Hết Hàng
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_REQUEST})
    ${details}=    Create List    ${OUT_OF_STOCK_PRODUCT}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Serial Không Hợp Lệ
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_REQUEST})
    ${details}=    Create List    ${INVALID_SERIAL_PRODUCT}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Serial Trùng
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_REQUEST})
    ${details}=    Create List    ${DUPLICATE_SERIAL_PRODUCT}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Theo Lô
    [Arguments]    ${batch_product}=${BATCH_PRODUCT}
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_REQUEST})
    ${details}=    Create List    ${batch_product}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Vượt Quá
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_REQUEST})
    ${payment}=    Create Dictionary    &{OVERPAYMENT}
    ${payments}=    Create List    ${payment}
    Set To Dictionary    ${data}    Payments=${payments}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sổ Giá
    [Arguments]    ${pricebook_invoice}=${PRICEBOOK_INVOICE}
    ${data}=    Evaluate    dict(${PRICEBOOK_INVOICE_REQUEST})
    Set To Dictionary    ${data}    Invoice=${pricebook_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Voucher Và Khuyến Mãi
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_REQUEST})
    Set To Dictionary    ${data}    Invoice=${VOUCHER_PROMOTION_INVOICE}
    
    # Thêm thanh toán bằng voucher
    ${payment}=    Create Dictionary    &{VOUCHER_PAYMENT}
    ${payments}=    Create List    ${payment}
    Set To Dictionary    ${data}    Payments=${payments}
    
    # Thêm khuyến mãi
    ${promotion}=    Create Dictionary    &{STANDARD_PROMOTION}
    ${promotions}=    Create List    ${promotion}
    Set To Dictionary    ${data}    Promotions=${promotions}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Gửi Yêu Cầu Tạo Hóa Đơn
    ${headers}=    Create Auth Headers
    ${response}=    POST    ${API_URL}/invoices    json=${REQUEST_DATA}    headers=${headers}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response} 