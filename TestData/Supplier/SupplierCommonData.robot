*** Settings ***
Resource          ../../TestData/CommonData.robot
Resource          ../../Config/Env_${ENV}.robot


*** Variables ***
&{STANDARD_SUPPLIER_REQUEST}    Supplier=${STANDARD_SUPPLIER_BODY}

&{STANDARD_SUPPLIER_BODY}       BranchId=${DEFAULT_BRANCH_ID}
    ...  Debt=0
    ...  Type=0
    ...  Name="Tên NCC"
    ...  Phone="0332553503"
    ...  RetailerId=${RETAILER_ID}
    ...  LocationName=${EMPTY}
    ...  AdministrativeAreaId=null
    ...  WardName=${EMPTY}
    ...  SupplierGroupDetails=[]
