*** Variables ***
${AUTH_TOKEN}         eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6InNCeCJ9.eyJpc3MiOiJrdnNzand0Iiwic3ViIjoxMDAwMDAwNDcwLCJpYXQiOjE3NDU0MDIwMzYsImV4cCI6MTc0NzgyMTIzNiwicHJlZmVycmVkX3VzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyJVc2VyIl0sImt2c291cmNlIjoiUmV0YWlsIiwia3Z1c2V0ZmEiOjAsImt2d2FpdG90cCI6MCwia3ZzZXMiOiIyNTdhMjFmZGJlMGU0OTk3YjkxYzM0NTAxYzhmNWQyYyIsImt2dWlkIjoxMDAwMDAwNDcwLCJrdmxhbmciOiJ2aS1WTiIsImt2dXR5cGUiOjAsImt2dWxpbWl0IjoiRmFsc2UiLCJrdnVhZG1pbiI6IlRydWUiLCJrdnVhY3QiOiJUcnVlIiwia3Z1bGltaXR0cmFucyI6IkZhbHNlIiwia3Z1c2hvd3N1bSI6IlRydWUiLCJrdmJpIjoiVHJ1ZSIsImt2Y3R5cGUiOjIsInVzZUJJIjp7IkN1c3RvbWVyQklSZXBvcnRfUmVhZCI6W10sIlNhbGVCSVJlcG9ydF9SZWFkIjpbXSwiUHJvZHVjdEJJUmVwb3J0X1JlYWQiOltdLCJGaW5hbmNlQklSZXBvcnRfUmVhZCI6W119LCJrdmJpZCI6MTAwMDAwMDAyOCwia3ZyaW5kaWQiOjUsImt2cmNvZGUiOiJhdXRvYXBpdmx4ZCIsImt2cmlkIjoxOTgxMiwia3Z1cmlkIjoxOTgxMiwia3ZyZ2lkIjozLCJwZXJtcyI6IiJ9.d8_M0U6ECTA1n_MDQUK_SuvZkEgOlB5Ui4KYnKhVJ-BG-w0iknYWm-P7RxbOSJn4w2Ptyb7ibQIqqYFeR8ZqZYcoTRn_IrPeXvNQajupVSezveko5drEgi1JeauuSsW4yJtcP_zNv4tT-lfoLmdSKcEF0pc0kzdk68_p-1aBNu2WrBN5BL1YUK6N_-V9z4rcYcyHniOA2C2swgJgtfTdhKaDaaUdcQU7P8j_vvbFBjXwIQ6mYEgr2S2_1BprUBJGsngat2A9ZN0_TudLjBw1Rcbx-YSDUOe-blwVFEUaLlynVfC_grfzWbf7-UsF2v3KDCA43KxXRiBEWzzW1d6IiQ
${RETAILER_CODE}      autoapivlxd
${RETAILER_ID}        19812


${USER_ID}          1000000470
${SOLD_BY_ID}       ${USER_ID}

${DEFAULT_BRANCH_ID}        ${BRANCH_ID} 
${BRANCH_ID}        1000000028  
${DEFAULT_USER_ID}          1000000470
${DEFAULT_CUSTOMER_ID}      1000009377
${API_URL}                  https://api-sale.kvpos.com/api/
${API_MAN_URL}               https://api-man.kvpos.com/api/
${WARRANTY_API_URL}       https://api-guarantee.kvpos.com/api/