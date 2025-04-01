*** Settings ***
Documentation     Dữ liệu kiểm thử cho test case xử lý mã hóa đơn
Resource          ../CommonData.robot

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
${INVALID_SPECIAL_CHAR_CODE} HD@#$_0001
${INVALID_EMPTY_CODE}        ${EMPTY}
${INVALID_WHITESPACE_CODE}   HD TEST 0001
${INVALID_LONG_CODE}         HDSDO_012345678901234567890123456789012345678901234567890

# Dữ liệu yêu cầu tạo hóa đơn tiêu chuẩn
&{STANDARD_INVOICE_DATA}
...    Code=${VALID_INVOICE_CODE}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{EMPTY}

&{STANDARD_INVOICE_DETAILS}
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    Discount=0

# Dữ liệu yêu cầu tạo hóa đơn với mã FB
&{FACEBOOK_INVOICE_DATA}
...    Code=${VALID_FACEBOOK_CODE}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    SaleChannelId=2
...    InvoiceDetails=@{EMPTY}

# Dữ liệu yêu cầu tạo hóa đơn với mã LZD
&{LAZADA_INVOICE_DATA}
...    Code=${VALID_LAZADA_CODE}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    SaleChannelId=3
...    InvoiceDetails=@{EMPTY}

# Dữ liệu yêu cầu tạo hóa đơn với mã không hợp lệ
&{INVALID_PREFIX_INVOICE_DATA}
...    Code=${INVALID_INVOICE_CODE}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{EMPTY}

# Dữ liệu yêu cầu tạo hóa đơn với mã chứa ký tự đặc biệt
&{SPECIAL_CHAR_INVOICE_DATA}
...    Code=${INVALID_SPECIAL_CHAR_CODE}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{EMPTY}

# Dữ liệu yêu cầu tạo hóa đơn với mã rỗng
&{EMPTY_CODE_INVOICE_DATA}
...    Code=${INVALID_EMPTY_CODE}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{EMPTY}

# Dữ liệu yêu cầu tạo hóa đơn với mã có khoảng trắng
&{WHITESPACE_CODE_INVOICE_DATA}
...    Code=${INVALID_WHITESPACE_CODE}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{EMPTY}

# Dữ liệu yêu cầu tạo hóa đơn với mã đã tồn tại
&{DUPLICATE_CODE_INVOICE_DATA}
...    Code=${INVOICE_DUPLICATED_CODE}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{EMPTY}

# Dữ liệu yêu cầu tạo hóa đơn với mã quá dài
&{LONG_CODE_INVOICE_DATA}
...    Code=${INVALID_LONG_CODE}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{EMPTY}

# Dữ liệu tạo hóa đơn với mã tự động
&{AUTO_CODE_INVOICE_DATA}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{EMPTY}

# Dữ liệu kiểm tra mã tự động theo phân quyền
&{PERMISSION_CODE_INVOICE_DATA}
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PermissionPrefix=ABC
...    InvoiceDetails=@{EMPTY}

*** Keywords ***
Tạo Dữ Liệu Tiêu Chuẩn Cho Test Mã Hóa Đơn
    # Tạo danh sách chi tiết hóa đơn với 1 sản phẩm
    ${invoice_details}=    Create List    ${STANDARD_INVOICE_DETAILS}
    
    # Tạo bản sao của dữ liệu hóa đơn tiêu chuẩn để không ảnh hưởng biến gốc
    ${standard_invoice}=    Copy Dictionary    ${STANDARD_INVOICE_DATA}
    
    # Cập nhật chi tiết hóa đơn vào dữ liệu
    Set To Dictionary    ${standard_invoice}    InvoiceDetails=${invoice_details}
    
    RETURN    ${standard_invoice} 