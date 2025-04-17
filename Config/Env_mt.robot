*** Setting ***
Variables    config/config.yaml
*** Variable ***
*** Testsuite ***
*** Keyword ***
Fill env from config.yaml
    ${BRANCH_ID}    Get From Dictionary    ${configs['kiotviet']['${kv_environment}']['zones']['${kv_zone}']['retailers']['${kv_retailer}']}		branch_id
    ${LATESTBRANCH}    Get From Dictionary    ${configs['kiotviet']['${kv_environment}']['zones']['${kv_zone}']['retailers']['${kv_retailer}']}		lastest_branch

    ${USER_NAME}    Get From Dictionary    ${configs['kiotviet']['${kv_environment}']['zones']['${kv_zone}']['retailers']['${kv_retailer}']['users']['${user}']}		username
    ${USER_PASSWORD}    Get From Dictionary    ${configs['kiotviet']['${kv_environment}']['zones']['${kv_zone}']['retailers']['${kv_retailer}']['users']['${user}']}		password
    ${RETAILER_NAME}    Get From Dictionary    ${configs['kiotviet']['${kv_environment}']['zones']['${kv_zone}']['retailers']['${kv_retailer}']}		code
    ${API_URL}    Get From Dictionary    ${configs['kiotviet']['${kv_environment}']['config']}		api_url
    ${FACING_URL_TMPL}    Get From Dictionary        ${configs['kiotviet']['${kv_environment}']['config']}		facing_url_tmpl
    ${SALE_API_URL}    Get From Dictionary    ${configs['kiotviet']['${kv_environment}']['config']}		sale_api_url
    ${PROMO_API}    Get From Dictionary    ${configs['kiotviet']['${kv_environment}']['config']}		promotion_api_url
    ${WARRANTY_API}    Get From Dictionary    ${configs['kiotviet']['${kv_environment}']['config']}		warranty_api_url
    ${MOBILE_API_URL}    Get From Dictionary    ${configs['kiotviet']['${kv_environment}']['config']}		mobile_api_url
    ${TIMESHEET_API}    Get From Dictionary    ${configs['kiotviet']['${kv_environment}']['config']}		timesheet_api_url
    ${API_PUBLIC}         Get From Dictionary    ${configs['kiotviet']['${kv_environment}']['config']}      api_public
    ${API_GET_TOKEN}      Get From Dictionary    ${configs['kiotviet']['${kv_environment}']['config']}      api_get_token
    ${API_SHIPPING}       Get From Dictionary    ${configs['kiotviet']['${kv_environment}']['config']}      api_shipping
    ${API_QLKV}             Get From Dictionary    ${configs['kiotviet']['${kv_environment}']['config']}    api_qlkv

    ${ENVIRONMENT}    Set Variable  ${kv_environment}


    ${FACING_URL}   Replace String  ${FACING_URL_TMPL}  %%RETAILER_CODE%%   ${RETAILER_NAME}

    Set Global Variable    \${API_URL}    ${API_URL}
    Set Global Variable    \${BRANCH_ID}    ${BRANCH_ID}
    Set Global Variable    \${LATESTBRANCH}    ${LATESTBRANCH}
    Set Global Variable    \${URL}    ${FACING_URL}
    Set Global Variable    \${PASSWORD}    ${USER_PASSWORD}
    Set Global Variable    \${RETAILER_NAME}    ${RETAILER_NAME}
    Set Global Variable    \${SALE_API_URL}    ${SALE_API_URL}
    Set Global Variable    \${PROMO_API}    ${PROMO_API}
    Set Global Variable    \${WARRANTY_API}    ${WARRANTY_API}
    Set Global Variable    \${MOBILE_API_URL}    ${MOBILE_API_URL}
    Set Global Variable    \${BROWSER}    Chrome
    Set Global Variable    \${IS_HEADLESS_BROWSER}    ${headless_browser}
    Set Global Variable    \${TIMESHEET_API}    ${TIMESHEET_API}
    Set Global Variable    \${API_GET_TOKEN}   ${API_GET_TOKEN}
    Set Global Variable    \${API_PUBLIC}    ${API_PUBLIC}
    Set Global Variable    \${API_SHIPPING}    ${API_SHIPPING}
    Set Global Variable    \${API_QLKV}   ${API_QLKV}
    Set Global Variable    \${REMOTE_URL}    ${remote}

    Set Global Variable    \${USER_NAME}    ${USER_NAME}
    Set Global Variable    \${USER_PASSWORD}    ${USER_PASSWORD}
    Set Global Variable    \${env}    NOTUSE
