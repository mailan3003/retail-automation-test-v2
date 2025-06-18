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

# Supplier customer data
${EXISTING_TAX_CODE}    0123456789
${SUPPLIER_CUSTOMER_TYPE}    1
${NON_SUPPLIER_CUSTOMER_TYPE}    0








