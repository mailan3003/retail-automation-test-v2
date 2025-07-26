*** Variables ***

${URL}    https://api-man1.kiotviet.vn/api/
${RETAILER}    testz23
${username}    admin
${password}    Kiotviet123456
${AUTH}
${DEFAULT_BRANCH_ID}    30

&{HEADERS}    
...    content-type=application/json;charset=utf-8
...    retailer=${RETAILER}
...    Authorization=${AUTH}
...    BranchId=30