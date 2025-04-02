*** Settings ***
Documentation     Keywords cho test cases API phần cập nhật công nợ và điểm thưởng
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/DebtPointUpdateData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Library           ../../Resources/DatabaseLibrary.py

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    ${data}=    Set Variable    ${NO_PAYMENT_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Một Phần
    ${data}=    Set Variable    ${PARTIAL_PAYMENT_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Đầy Đủ
    ${data}=    Set Variable    ${FULL_PAYMENT_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Thừa
    ${data}=    Set Variable    ${EXCESS_PAYMENT_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Có Công Nợ
    ${data}=    Set Variable    ${DEBT_CUSTOMER_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Tích Điểm Và Thanh Toán Một Phần
    ${data}=    Set Variable    ${POINT_AND_DEBT_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Bằng Điểm
    ${data}=    Set Variable    ${PAYMENT_WITH_POINT_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Điểm Thưởng Theo Sản Phẩm
    ${data}=    Set Variable    ${PRODUCT_POINT_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

# Keywords với tham số nhúng
Chuẩn Bị Dữ Liệu Hóa Đơn với tổng tiền ${total} và thanh toán ${payment_amount}
    ${data}=    Set Variable    ${PARTIAL_PAYMENT_INVOICE_REQUEST}
    ${invoice}=    Set Variable    ${data.Invoice}
    Set To Dictionary    ${invoice}    Total=${total}
    
    ${payment}=    Set Variable    ${data.Payments[0]}
    Set To Dictionary    ${payment}    Amount=${payment_amount}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn với khách hàng có công nợ ${debt_amount} và tổng tiền ${total}
    ${data}=    Set Variable    ${DEBT_CUSTOMER_INVOICE_REQUEST}
    ${invoice}=    Set Variable    ${data.Invoice}
    Set To Dictionary    ${invoice}    Total=${total}
    Set To Dictionary    ${invoice}    CustomerDebt=${debt_amount}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn với điểm thưởng theo hóa đơn ${money_per_point} và thanh toán ${payment_amount}
    ${data}=    Set Variable    ${POINT_AND_DEBT_INVOICE_REQUEST}
    ${invoice}=    Set Variable    ${data.Invoice}
    Set To Dictionary    ${invoice}    MoneyPerPoint=${money_per_point}
    
    ${payment}=    Set Variable    ${data.Payments[0]}
    Set To Dictionary    ${payment}    Amount=${payment_amount}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn thanh toán bằng điểm với giá trị ${point_amount}
    ${data}=    Set Variable    ${PAYMENT_WITH_POINT_INVOICE_REQUEST}
    ${payment}=    Set Variable    ${data.Payments[0]}
    Set To Dictionary    ${payment}    Amount=${point_amount}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn với sản phẩm có điểm thưởng ${point_value} và số lượng ${quantity}
    ${data}=    Set Variable    ${PRODUCT_POINT_INVOICE_REQUEST}
    ${product}=    Create Dictionary
    ...    ProductId=${PRODUCT_1}
    ...    Quantity=${quantity}
    ...    Price=100000
    ...    Point=${point_value}
    
    ${details}=    Create List    ${product}
    Set To Dictionary    ${data.Invoice}    InvoiceDetails=${details}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Gửi Yêu Cầu Tạo Hóa Đơn
    ${response}=    Call API    invoices    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}

# Database verification keywords
Xác Thực Hóa Đơn Trong CSDL
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}
    ${query}=    Set Variable    SELECT Id FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy hóa đơn ID ${invoice_id} trong CSDL

Xác Thực Công Nợ Khách Hàng
    [Arguments]    ${customer_id}    ${expected_debt}
    ${query}=    Set Variable    SELECT Debt FROM Customer WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${customer_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy khách hàng ID ${customer_id} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_debt}    Nợ khách hàng không chính xác. Mong đợi: ${expected_debt}, Thực tế: ${result[0]}

Xác Thực Công Nợ Của Hóa Đơn
    [Arguments]    ${expected_debt}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${query}=    Set Variable    SELECT Debt FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy hóa đơn ID ${invoice_id} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_debt}    Công nợ của hóa đơn không chính xác. Mong đợi: ${expected_debt}, Thực tế: ${result[0]}

Xác Thực Điểm Thưởng Trong Hóa Đơn
    [Arguments]    ${expected_point}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${query}=    Set Variable    SELECT Point FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy hóa đơn ID ${invoice_id} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_point}    Điểm thưởng của hóa đơn không chính xác. Mong đợi: ${expected_point}, Thực tế: ${result[0]}

Xác Thực Điểm Khả Dụng Của Khách Hàng
    [Arguments]    ${customer_id}    ${expected_point}
    ${query}=    Set Variable    SELECT AvailablePoint FROM Customer WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${customer_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy khách hàng ID ${customer_id} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_point}    Điểm khả dụng của khách hàng không chính xác. Mong đợi: ${expected_point}, Thực tế: ${result[0]}

Xác Thực Lịch Sử Điểm Của Khách Hàng
    [Arguments]    ${customer_id}    ${expected_point}    ${type}=Increase
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${query}=    Set Variable    SELECT Point, Type FROM PointTracking WHERE InvoiceId = ? AND CustomerId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${customer_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy lịch sử điểm cho hóa đơn ID ${invoice_id} và khách hàng ID ${customer_id}
    Should Be Equal As Numbers    ${result[0]}    ${expected_point}    Số điểm trong lịch sử không chính xác. Mong đợi: ${expected_point}, Thực tế: ${result[0]}
    Should Be Equal    ${result[1]}    ${type}    Loại điểm không chính xác. Mong đợi: ${type}, Thực tế: ${result[1]}

Xác Thực Thanh Toán Của Hóa Đơn
    [Arguments]    ${expected_payment}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${query}=    Set Variable    SELECT TotalPayment FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy hóa đơn ID ${invoice_id} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_payment}    Tổng thanh toán của hóa đơn không chính xác. Mong đợi: ${expected_payment}, Thực tế: ${result[0]}

Xác Thực Chi Tiết Thanh Toán
    [Arguments]    ${method}    ${expected_amount}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${query}=    Set Variable    SELECT Amount FROM Payment WHERE InvoiceId = ? AND Method = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${method}
    Should Not Be Equal    ${result}    None    Không tìm thấy phương thức thanh toán ${method} cho hóa đơn ID ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    ${expected_amount}    Số tiền thanh toán bằng ${method} không chính xác. Mong đợi: ${expected_amount}, Thực tế: ${result[0]}

Xác Thực Không Có Thanh Toán Bằng Phương Thức
    [Arguments]    ${method}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ? AND Method = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${method}
    Should Be Equal As Numbers    ${result[0]}    0    Tìm thấy phương thức thanh toán ${method} cho hóa đơn ID ${invoice_id} khi không mong đợi

# Embedded keywords for verification
Công nợ khách hàng ${customer_id} tăng ${expected_debt}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${query}=    Set Variable    SELECT Debt FROM Customer WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${customer_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy khách hàng ID ${customer_id} trong CSDL
    Should Be True    ${result[0]} >= ${expected_debt}    Nợ khách hàng không tăng đúng mức. Mong đợi tối thiểu: ${expected_debt}, Thực tế: ${result[0]}

Công nợ của hóa đơn là ${expected_debt}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực Công Nợ Của Hóa Đơn    ${expected_debt}

Tổng thanh toán của hóa đơn là ${expected_payment}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực Thanh Toán Của Hóa Đơn    ${expected_payment}

Điểm thưởng của hóa đơn là ${expected_point}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực Điểm Thưởng Trong Hóa Đơn    ${expected_point}

Điểm khả dụng của khách hàng ${customer_id} tăng ${expected_point}
    Xác Thực Điểm Khả Dụng Của Khách Hàng    ${customer_id}    ${expected_point} 