*** Settings ***
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Resource          ../../TestData/Product/ProductInputData.robot

*** Variables ***
${PRODUCT_API_ENDPOINT}     /products/addmany

*** Keywords ***
Chuẩn Bị Dữ Liệu Sản Phẩm Tiêu Chuẩn
    ${branch_pr_cost}=        Set Variable     "Id":${BRANCH_ID},"Name":"Chi nhánh trung tâm"
    ${branch_pr_cost}     Evaluate    (None, '[{${branch_pr_cost}}]')
    ${form_data}=    Evaluate    str(${list_product_data}).replace("'",'"')
    ${list_products}     Evaluate    (None, '[${form_data}]')
    ${payload}    Create Dictionary    ListProducts=${list_products}      BranchForProductCostss=${branch_pr_cost}
    Set Test Variable    ${REQUEST_DATA}    ${payload}
    RETURN    ${REQUEST_DATA}

Gửi Yêu Cầu Thêm Sản Phẩm
    ${response}=    Call API    ${PRODUCT_API_ENDPOINT}    ${REQUEST_DATA}    POST
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}

Nội dung phản hồi trả về phải tồn tại Id
    Dictionary Should Contain Key    ${RESPONSE.json()}    Id
    ${id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Should Be True    ${id} > 0

Chuẩn Bị Dữ Liệu Sản Phẩm Với JSON Không Hợp Lệ
    ${request}=    Create Dictionary    ListProductsString=${INVALID_JSON}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Với 51 Sản Phẩm Combo
    ${list_products}=    Create List
    FOR    ${index}    IN RANGE    51
        ${product}=    Deep Copy    ${COMBO_PRODUCT_TEMPLATE}
        ${product}=    Set To Dictionary    ${product}    Name=Combo Product ${index}
        Append To List    ${list_products}    ${product}
    END
    ${request}=    Create Dictionary    ListProducts=${list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Với 201 Sản Phẩm
    ${list_products}=    Create List
    FOR    ${index}    IN RANGE    201
        ${product}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
        ${product}=    Set To Dictionary    ${product}    Name=Product ${index}    Code=P${index}
        Append To List    ${list_products}    ${product}
    END
    ${request}=    Create Dictionary    ListProducts=${list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Với Định Dạng Chi Nhánh Không Hợp Lệ
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${list_products}=    Create List    ${request_data}
    ${request}=    Create Dictionary    ListProducts=${list_products}    BranchForProductCostss=${INVALID_BRANCH_JSON}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Sản Phẩm Gây Lỗi Trong Giao Dịch DB
    # Tạo dữ liệu sản phẩm không hợp lệ gây lỗi khi lưu vào DB
    # Ví dụ: Tạo sản phẩm với tên quá dài
    ${long_name}=    Evaluate    "A" * 500
    ${request_data}=    Deep Copy    ${STANDARD_PRODUCT_REQUEST}
    ${request_data}=    Set To Dictionary    ${request_data}    Name=${long_name}
    ${list_products}=    Create List    ${request_data}
    ${request}=    Create Dictionary    ListProducts=${list_products}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${REQUEST_DATA} 