*** Settings ***
Resource    ../../Config/Env_lansb.robot

*** Variables ***
${BRANCH_ID}       ${DEFAULT_BRANCH_ID}

${CUSTOMER_ID}     ${CUSTOMER_ID}
${USER_ID}         ${DEFAULT_USER_ID}
${PRODUCT_ID}      ${DEFAULT_PRODUCT_ID}
${PRICE}           6300000
${QUANTITY}        1

&{SOLD_BY}         Id=${USER_ID}
&{SELLER}          Id=${USER_ID}
&{ORDER_DETAIL}    Price=${PRICE}    ProductId=${PRODUCT_ID}    Quantity=${QUANTITY}
@{ORDER_DETAILS}   ${ORDER_DETAIL}

&{ORDERS}
...    BranchId=${BRANCH_ID}
...    RetailerId=${RETAILER_ID}
...    CustomerId=${CUSTOMER_ID}
...    SoldById=${USER_ID}
...    SoldBy=${SOLD_BY}
...    Seller=${SELLER}
...    OrderDetails=${ORDER_DETAILS}
...    Status=1

&{REQUEST_ORDER}    Order=${ORDERS}
