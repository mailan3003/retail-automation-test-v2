*** Variables ***
${RETAILER}    testz23
${RETAILER_ID}    861751
${URL}    https://api-man1.kiotviet.vn/api/
${ENDPOINT}    account/login
${DEFAULT_BRANCH_ID}    30

&{HEADERS}    accept=application/json, text/plain, */*
...           accept-language=vi,en-US;q=0.9,en;q=0.8,zh-CN;q=0.7,zh;q=0.6
...           content-type=application/json;charset=utf-8
# ...           fingerprintkey=
# ...           latestbranchid=30
# ...           origin=https://testz23.kiotviet.vn
# ...           referer=https://testz23.kiotviet.vn/
...           retailer=${RETAILER}


&{MODEL}
...    RememberMe=${TRUE}
...    ShowCaptcha=${FALSE}
...    UserName=admin
...    Password=Kiotviet123456
...    Language=vi-VN
...    LatestBranchId=30

${IsManageSide}     true,
${FingerPrintKey}     9260aa1de596f0d80658143cbe38c670_Chrome_Desktop_Máy tính Windows


${DEFAULT_CATEGORY_ID}    1472597