*** Settings ***
Documentation     Dữ liệu cho test cases API tính tổng tiền hóa đơn
Resource          ../CommonData.robot
Resource          ./CommonInvoiceData.robot

*** Variables ***
# Định nghĩa chi tiết sản phẩm
&{DISCOUNTED_PRODUCT_DETAIL}    
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    Discount=10000

&{PRODUCT_WITH_TAX_DETAIL}    
...    ProductId=${PRODUCT_WITH_VAT_1_ID}
...    Quantity=1
...    Price=100000
...    Discount=0



# Mã hóa đơn cho các trường hợp test
${INVOICE_CODE_SINGLE_PRODUCT}      HD_SINGLE_PRODUCT
${INVOICE_CODE_DISCOUNTED_PRODUCT}  HD_DISCOUNTED_PRODUCT
${INVOICE_CODE_MULTIPLE_PRODUCTS}   HD_MULTIPLE_PRODUCTS
${INVOICE_CODE_INVOICE_DISCOUNT}    HD_INVOICE_DISCOUNT
${INVOICE_CODE_SURCHARGE}           HD_SURCHARGE
${INVOICE_CODE_PERCENT_SURCHARGE}   HD_PERCENT_SURCHARGE
${INVOICE_CODE_TAX}                 HD_TAX
${INVOICE_CODE_QUANTITY}            HD_QUANTITY
${INVOICE_CODE_COMPLEX}             HD_COMPLEX
${INVOICE_CODE_COMBO}               HD_COMBO





# Combo product components
&{COMBO_COMPONENT_1}
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000

&{COMBO_COMPONENT_2}
...    ProductId=${PRODUCT_2}
...    Quantity=1
...    Price=150000

# Sản phẩm
${PRODUCT_1}                       SP0001
${PRODUCT_2}                       SP0002

# Giá trị kỳ vọng cho tổng tiền
${EXPECTED_TOTAL_SINGLE_PRODUCT}        100000
${EXPECTED_TOTAL_SINGLE_DISCOUNTED}     90000
${EXPECTED_TOTAL_MULTIPLE_PRODUCTS}     300000
${EXPECTED_TOTAL_INVOICE_DISCOUNT}      280000
${EXPECTED_TOTAL_WITH_SURCHARGE}        110000
${EXPECTED_TOTAL_PERCENT_SURCHARGE}     110000
${EXPECTED_TOTAL_WITH_TAX}              110000
${EXPECTED_TOTAL_COMBO}                 250000 