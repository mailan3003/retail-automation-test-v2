*** Settings ***
Documentation     Dữ liệu kiểm thử cho test case xử lý mã hóa đơn
Resource          ../CommonData.robot
Resource          ./CommonInvoiceData.robot

*** Variables ***
# Tiền tố mã hóa đơn mặc định
${DEFAULT_INVOICE_PREFIX}    HD
${LAZADA_PREFIX}             LZD
${FACEBOOK_PREFIX}           FB

# Các mã hóa đơn hợp lệ
${VALID_INVOICE_CODE}        HD_TEST_0001
${VALID_FACEBOOK_CODE}       FB_TEST_0001
${VALID_LAZADA_CODE}         LZD_TEST_0001

# Mã hóa đơn không hợp lệ
${INVALID_INVOICE_CODE}      XX_TEST_0001
${INVALID_SPECIAL_CHAR_CODE}    adajdhkaadhada
${INVALID_EMPTY_CODE}        ${EMPTY}
${INVALID_WHITESPACE_CODE}   HD TEST 0001
${INVALID_LONG_CODE}         HDSDO_012345678901234567890123456789012345678901234567890

# Dữ liệu mã hóa đơn
${PERMISSION_PREFIX}         ABC

# Cấu hình kênh bán
${FACEBOOK_SALE_CHANNEL_ID}    1000000042
${LAZADA_SALE_CHANNEL_ID}      3

# Sử dụng STANDARD_INVOICE_REQUEST từ CommonInvoiceData.robot