*** Settings ***
Resource          ../../TestData/CommonData.robot
Resource          ../../Config/Env_${ENV}.robot


*** Variables ***
&{STANDARD_CUSTOMER_REQUEST}    Customer=${STANDARD_CUSTOMER_BODY}    isMergedSupplier=false    isCreateNewSupplier=false    MergedSupplierId=0    SkipValidateEmail=true

&{STANDARD_CUSTOMER_BODY}   
    ...  BranchId=${DEFAULT_BRANCH_ID}
    ...  IsActive=${TRUE}
    ...  Type=0
    ...  Name=Tạo Khách Hàng
    ...  Organization=${EMPTY}
    ...  ContactNumber=${EMPTY}
    ...  SubNumber=${EMPTY}
    ...  Code=${EMPTY}
    ...  BirthDate=${EMPTY}
    ...  Gender=1
    ...  Address=${EMPTY}
    ...  LocationId=213
    ...  WardId=8056
    ...  Comments=${EMPTY}
    ...  TaxCode=${EMPTY}
    ...  IdentificationNumber=${EMPTY}
    ...  AdministrativeAreaId=${EMPTY}
    ...  CustomerGroupDetails=@{EMPTY}
    ...  EmployeeInChargeIds=@{EMPTY}
    ...  RetailerId=${RETAILER_ID}

&{STANDARD_CUSTOMER_DETAILS_GROUP}   
      ...   GroupId=0
    



# Test data for existing customers
${EXISTING_PHONE}    0985456321
${EXISTING_EMAIL}    testerkv@gmail.com

# Test data for customer types
${CUSTOMER_NAME}    Khách Hàng Test
${CUSTOMER_PHONE}    093553566
${CUSTOMER_EMAIL}    test@example.com
${CUSTOMER_ADDRESS}    123 Đường ABC, Quận 1, TP.HCM
${CUSTOMER_TAX_CODE}    123456789
${CUSTOMER_GENDER}    1
${CUSTOMER_BIRTH_DATE}    01-01-1990
${CUSTOMER_COMMENTS}    Ghi chú test cho khách hàng
${CUSTOMER_CMT}    1234567890087

# Location data
${PROVINCE_ID}    213
${DISTRICT_ID}    8056
${WARD_ID}    8056








