*** Variables ***
# Mã hóa đơn tiêu chuẩn để cập nhật thanh toán
${STANDARD_INVOICE_CODE}    HDTT_001

# Thông tin thanh toán tiêu chuẩn
${PAYMENT_STANDARD_AMOUNT}    100000
${PAYMENT_UPDATE_AMOUNT}      50000
${PAYMENT_TOTAL_AMOUNT}       150000

# IDs cho API tests
${EXISTING_INVOICE_ID}    520107862
${INVALID_INVOICE_ID}     999999999

# Các phương thức thanh toán
${PAYMENT_CASH}         Cash
${PAYMENT_CARD}         Card
${PAYMENT_TRANSFER}     Transfer
${PAYMENT_VOUCHER}      Voucher
${PAYMENT_POINT}        Point
${PAYMENT_COD}          COD

# Mô tả thanh toán
${PAYMENT_DESCRIPTION_1}    Thanh toán bổ sung
${PAYMENT_DESCRIPTION_2}    Thanh toán nợ

# Dữ liệu yêu cầu thanh toán tiêu chuẩn
&{STANDARD_PAYMENT_UPDATE_REQUEST}    
...    InvoiceId=${EXISTING_INVOICE_ID}
...    Payments=@{EMPTY}

# Dữ liệu phương thức thanh toán tiền mặt
&{CASH_PAYMENT_REQUEST}
...    Method=${PAYMENT_CASH}
...    Amount=${PAYMENT_UPDATE_AMOUNT}
...    Description=${PAYMENT_DESCRIPTION_1}

# Dữ liệu phương thức thanh toán bằng thẻ
&{CARD_PAYMENT_REQUEST}
...    Method=${PAYMENT_CARD}
...    Amount=${PAYMENT_UPDATE_AMOUNT}
...    AccountId=${DEFAULT_BANK_ACCOUNT_ID}
...    Description=${PAYMENT_DESCRIPTION_1}

# Dữ liệu phương thức thanh toán bằng chuyển khoản
&{TRANSFER_PAYMENT_REQUEST}
...    Method=${PAYMENT_TRANSFER}
...    Amount=${PAYMENT_UPDATE_AMOUNT}
...    AccountId=${DEFAULT_BANK_ACCOUNT_ID}
...    Description=${PAYMENT_DESCRIPTION_1}

# Dữ liệu phương thức thanh toán bằng điểm tích lũy
&{POINT_PAYMENT_REQUEST}
...    Method=${PAYMENT_POINT}
...    Amount=${PAYMENT_UPDATE_AMOUNT}
...    Points=50
...    Description=${PAYMENT_DESCRIPTION_1}

# Dữ liệu phương thức thanh toán bằng voucher
&{VOUCHER_PAYMENT_REQUEST}
...    Method=${PAYMENT_VOUCHER}
...    Amount=${PAYMENT_UPDATE_AMOUNT}
...    VoucherCode=VOUCHER001
...    Description=${PAYMENT_DESCRIPTION_1}

# Dữ liệu phương thức thanh toán bằng COD
&{COD_PAYMENT_REQUEST}
...    Method=${PAYMENT_COD}
...    Amount=${PAYMENT_UPDATE_AMOUNT}
...    Description=${PAYMENT_DESCRIPTION_1}

# Yêu cầu cập nhật thanh toán nhiều phương thức
&{MULTI_METHODS_PAYMENT_UPDATE_REQUEST}
...    InvoiceId=${EXISTING_INVOICE_ID}
...    Payments=@{EMPTY}

# Yêu cầu cập nhật thanh toán với số tiền lớn hơn công nợ
&{OVERPAYMENT_UPDATE_REQUEST}
...    InvoiceId=${EXISTING_INVOICE_ID}
...    Payments=@{EMPTY}

# Yêu cầu cập nhật thanh toán với hóa đơn không tồn tại
&{INVALID_INVOICE_PAYMENT_UPDATE_REQUEST}
...    InvoiceId=${INVALID_INVOICE_ID}
...    Payments=@{EMPTY}

# Yêu cầu cập nhật thanh toán với số tiền âm
&{NEGATIVE_AMOUNT_PAYMENT_UPDATE_REQUEST}
...    InvoiceId=${EXISTING_INVOICE_ID}
...    Payments=@{EMPTY}

# Yêu cầu cập nhật thanh toán với số tiền bằng 0
&{ZERO_AMOUNT_PAYMENT_UPDATE_REQUEST}
...    InvoiceId=${EXISTING_INVOICE_ID}
...    Payments=@{EMPTY}

# Thanh toán với số tiền âm
&{NEGATIVE_AMOUNT_PAYMENT}
...    Method=${PAYMENT_CASH}
...    Amount=-10000
...    Description=Hoàn tiền

# Thanh toán với số tiền bằng 0
&{ZERO_AMOUNT_PAYMENT}
...    Method=${PAYMENT_CASH}
...    Amount=0
...    Description=Ghi chú 