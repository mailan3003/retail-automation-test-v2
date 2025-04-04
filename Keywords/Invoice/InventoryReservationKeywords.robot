*** Settings ***
Documentation     Keywords cho test cases API phần quản lý đặt giữ (reservation) tồn kho
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/InventoryReservationData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           Collections
Library           json

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Với Chế Độ Đặt Giữ
    ${data}=    Evaluate    json.loads('''${RESERVATION_STANDARD_DATA}''')    json
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Đặt Trước
    ${data}=    Evaluate    json.loads('''${RESERVATION_DRAFT_DATA}''')    json
    Set Test Variable    ${REQUEST_DATA}    ${data}
    Set Test Variable    ${RESERVATION_INVOICE_ID}    0
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Chế Độ Đặt Giữ Và Kiểm Tra Tồn Thực Tế
    ${data}=    Evaluate    json.loads('''${ACTUALRESERVED_CHECK_DATA}''')    json
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Đặt Hàng Với Cập Nhật OnOrder
    ${data}=    Evaluate    json.loads('''${ORDER_RESERVATION_DATA}''')    json
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Cần Hủy
    ${data}=    Evaluate    json.loads('''${INVOICE_TO_CANCEL_DATA}''')    json
    Set Test Variable    ${REQUEST_DATA}    ${data}
    Set Test Variable    ${INVOICE_TO_CANCEL_ID}    0
    RETURN    ${data}

Xem Thông Tin Tồn Kho Và Đặt Giữ Của Sản Phẩm ${product_id}
    ${query}=    Set Variable    SELECT BranchId, ProductId, OnHand, Reserved FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${BRANCH_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin tồn kho và đặt giữ ban đầu
    ${initial_onhand}=    Set Variable    ${result[2]}
    ${initial_reserved}=    Set Variable    ${result[3]}
    Set Test Variable    ${INITIAL_ONHAND}    ${initial_onhand}
    Set Test Variable    ${INITIAL_RESERVED}    ${initial_reserved}
    RETURN    ${result}

Xem Thông Tin Tồn Kho Thực Tế Của Sản Phẩm ${product_id}
    ${query}=    Set Variable    SELECT BranchId, ProductId, OnHand, Reserved, ActualReserved FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${BRANCH_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin tồn kho thực tế ban đầu
    ${initial_onhand}=    Set Variable    ${result[2]}
    ${initial_reserved}=    Set Variable    ${result[3]}
    ${initial_actual_reserved}=    Set Variable    ${result[4]}
    Set Test Variable    ${INITIAL_ONHAND}    ${initial_onhand}
    Set Test Variable    ${INITIAL_RESERVED}    ${initial_reserved}
    Set Test Variable    ${INITIAL_ACTUAL_RESERVED}    ${initial_actual_reserved}
    RETURN    ${result}

Xem Thông Tin OnOrder Và Reserved Của Sản Phẩm ${product_id}
    ${query}=    Set Variable    SELECT BranchId, ProductId, OnHand, Reserved, OnOrder FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${BRANCH_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin OnOrder và Reserved ban đầu
    ${initial_onhand}=    Set Variable    ${result[2]}
    ${initial_reserved}=    Set Variable    ${result[3]}
    ${initial_onorder}=    Set Variable    ${result[4]}
    Set Test Variable    ${INITIAL_ONHAND}    ${initial_onhand}
    Set Test Variable    ${INITIAL_RESERVED}    ${initial_reserved}
    Set Test Variable    ${INITIAL_ONORDER}    ${initial_onorder}
    RETURN    ${result}

Gửi Yêu Cầu Tạo Đặt Giữ
    ${response}=    Call API    invoices    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    ${invoice_id}=    Set Variable If    ${RESPONSE.status_code} == 200    ${RESPONSE.json()["Id"]}    0
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}

Gửi Yêu Cầu Tạo Đặt Trước
    ${response}=    Call API    invoices    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    ${invoice_id}=    Set Variable If    ${RESPONSE.status_code} == 200    ${RESPONSE.json()["Id"]}    0
    Set Test Variable    ${RESERVATION_INVOICE_ID}    ${invoice_id}
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}

Gửi Yêu Cầu Xác Nhận Hóa Đơn Đặt Trước
    ${invoice_data}=    Create Dictionary    Id=${RESERVATION_INVOICE_ID}    Status=1
    ${confirm_data}=    Create Dictionary    Invoice=${invoice_data}
    ${response}=    Call API PUT    invoices/${RESERVATION_INVOICE_ID}    ${confirm_data}
    Set Test Variable    ${RESPONSE}    ${response}

Gửi Yêu Cầu Đặt Hàng
    ${response}=    Call API    invoices    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    ${invoice_id}=    Set Variable If    ${RESPONSE.status_code} == 200    ${RESPONSE.json()["Id"]}    0
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}

Gửi Yêu Cầu Hủy Hóa Đơn
    ${invoice_data}=    Create Dictionary    Id=${INVOICE_ID}    Status=4
    ${cancel_data}=    Create Dictionary    Invoice=${invoice_data}
    ${response}=    Call API PUT    invoices/${INVOICE_ID}    ${cancel_data}
    Set Test Variable    ${RESPONSE}    ${response}

Xác Thực Số Lượng Đặt Giữ Giảm ${quantity} Đơn Vị
    [Arguments]    ${product_id}
    ${query}=    Set Variable    SELECT BranchId, ProductId, OnHand, Reserved FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${BRANCH_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin đặt giữ
    ${new_reserved}=    Set Variable    ${result[3]}
    ${expected_reserved}=    Evaluate    ${INITIAL_RESERVED} - ${quantity}
    Should Be Equal As Numbers    ${new_reserved}    ${expected_reserved}    Số lượng đặt giữ không giảm đúng

Xác Thực Số Lượng Đặt Giữ Tăng ${quantity} Đơn Vị
    [Arguments]    ${product_id}
    ${query}=    Set Variable    SELECT BranchId, ProductId, OnHand, Reserved FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${BRANCH_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin đặt giữ
    ${new_reserved}=    Set Variable    ${result[3]}
    ${expected_reserved}=    Evaluate    ${INITIAL_RESERVED} + ${quantity}
    Should Be Equal As Numbers    ${new_reserved}    ${expected_reserved}    Số lượng đặt giữ không tăng đúng

Xác Thực Tồn Kho Không Thay Đổi
    [Arguments]    ${product_id}
    ${query}=    Set Variable    SELECT BranchId, ProductId, OnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${BRANCH_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin tồn kho
    ${new_onhand}=    Set Variable    ${result[2]}
    Should Be Equal As Numbers    ${new_onhand}    ${INITIAL_ONHAND}    Tồn kho đã thay đổi

Xác Thực Số Lượng Đặt Hàng Giảm ${quantity} Đơn Vị
    [Arguments]    ${product_id}
    ${query}=    Set Variable    SELECT BranchId, ProductId, OnOrder FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${BRANCH_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin đặt hàng
    ${new_onorder}=    Set Variable    ${result[2]}
    ${expected_onorder}=    Evaluate    ${INITIAL_ONORDER} - ${quantity}
    Should Be Equal As Numbers    ${new_onorder}    ${expected_onorder}    Số lượng đặt hàng không giảm đúng

Xác Thực Tồn Kho Thực Tế Tăng ${quantity} Đơn Vị
    [Arguments]    ${product_id}
    ${query}=    Set Variable    SELECT BranchId, ProductId, ActualReserved FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${BRANCH_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin tồn kho thực tế
    ${new_actual_reserved}=    Set Variable    ${result[2]}
    ${expected_actual_reserved}=    Evaluate    ${INITIAL_ACTUAL_RESERVED} + ${quantity}
    Should Be Equal As Numbers    ${new_actual_reserved}    ${expected_actual_reserved}    Tồn kho thực tế không tăng đúng

Xác Thực Tồn Kho Tăng ${quantity} Đơn Vị
    [Arguments]    ${product_id}
    ${query}=    Set Variable    SELECT BranchId, ProductId, OnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${BRANCH_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin tồn kho
    ${new_onhand}=    Set Variable    ${result[2]}
    ${expected_onhand}=    Evaluate    ${INITIAL_ONHAND} + ${quantity}
    Should Be Equal As Numbers    ${new_onhand}    ${expected_onhand}    Tồn kho không tăng đúng

Xác Thực Lịch Sử Tồn Kho Hủy Hóa Đơn
    [Arguments]    ${product_id}    ${quantity}
    ${query}=    Set Variable    SELECT DocumentId, DocumentType, ProductId, Value FROM InventoryTracking WHERE DocumentId = ? AND ProductId = ? AND DocumentType = 11
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}    ${product_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy lịch sử tồn kho hủy hóa đơn
    Should Be Equal As Numbers    ${result[0]}    ${INVOICE_ID}    ID hóa đơn không khớp
    Should Be Equal As Numbers    ${result[2]}    ${product_id}    ID sản phẩm không khớp
    ${expected_value}=    Evaluate    ${quantity}
    Should Be Equal As Numbers    ${result[3]}    ${expected_value}    Giá trị thay đổi tồn kho khi hủy không khớp

# Keywords với embedded parameters
Số lượng đặt giữ sản phẩm ${product_id} đã giảm ${quantity} đơn vị
    Xác Thực Số Lượng Đặt Giữ Giảm ${quantity} Đơn Vị    ${product_id}

Số lượng đặt giữ sản phẩm ${product_id} đã tăng ${quantity} đơn vị
    Xác Thực Số Lượng Đặt Giữ Tăng ${quantity} Đơn Vị    ${product_id}

Tồn kho sản phẩm ${product_id} không thay đổi
    Xác Thực Tồn Kho Không Thay Đổi    ${product_id}

Số lượng đặt hàng (OnOrder) của sản phẩm ${product_id} đã giảm ${quantity} đơn vị
    Xác Thực Số Lượng Đặt Hàng Giảm ${quantity} Đơn Vị    ${product_id}

Tồn kho thực tế (ActualReserved) của sản phẩm ${product_id} đã tăng ${quantity} đơn vị
    Xác Thực Tồn Kho Thực Tế Tăng ${quantity} Đơn Vị    ${product_id}

Tồn kho sản phẩm ${product_id} đã tăng lại ${quantity} đơn vị
    Xác Thực Tồn Kho Tăng ${quantity} Đơn Vị    ${product_id}

Lịch sử tồn kho hủy hóa đơn được ghi nhận với giá trị +${quantity}
    Xác Thực Lịch Sử Tồn Kho Hủy Hóa Đơn    ${PRODUCT_1}    ${quantity} 