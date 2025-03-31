*** Settings ***
Resource    ../../../Keywords/Utilities/ResponseHelper.robot
Resource    ../../../Keywords/Invoice/InvoiceInventoryValidationKeywords.robot
Resource    ../../../TestData/CommonData.robot
Resource    ../../../TestData/Invoice/InvoiceInventoryValidationData.robot

*** Test Cases ***
RT-INIV-001 Kiểm tra tạo hóa đơn thành công với số lượng tồn kho đủ
    [Documentation]    Kiểm tra tạo hóa đơn khi số lượng tồn kho đủ
    [Tags]    invoice    validation    inventory    stock
    Given Chuẩn bị dữ liệu hóa đơn mặc định cho kiểm tra tồn kho
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist

RT-INIV-002 Kiểm tra tạo hóa đơn thất bại khi không đủ tồn kho
    [Documentation]    Kiểm tra không cho phép tạo hóa đơn khi số lượng không đủ
    [Tags]    invoice    validation    inventory    out_of_stock
    Given Chuẩn bị dữ liệu hóa đơn với sản phẩm hết hàng
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 400
    And Response Should Have Error "Sản phẩm không đủ số lượng tồn kho"

RT-INIV-003 Kiểm tra tạo hóa đơn thành công khi không đủ tồn kho nhưng cho phép bán âm
    [Documentation]    Kiểm tra cho phép tạo hóa đơn khi không đủ tồn kho nhưng có cấu hình AllowSellWhenOutStock
    [Tags]    invoice    validation    inventory    allow_out_of_stock
    Given Chuẩn bị dữ liệu hóa đơn với sản phẩm hết hàng
    And Chuẩn bị dữ liệu hóa đơn với cấu hình AllowSellWhenOutStock=${invoice_inventory_validation_allow_out_of_stock}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist

RT-INIV-004 Kiểm tra tạo hóa đơn thất bại khi số serial không tồn tại
    [Documentation]    Kiểm tra không cho phép tạo hóa đơn khi số serial không tồn tại
    [Tags]    invoice    validation    inventory    serial    not_exist
    Given Chuẩn bị dữ liệu hóa đơn với sản phẩm theo serial
    And Chuẩn bị dữ liệu hóa đơn với serial SERIAL_NOT_EXIST
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 400
    And Response Should Have Error "Số serial không tồn tại trong kho"

RT-INIV-005 Kiểm tra tạo hóa đơn thất bại khi số serial đã sử dụng
    [Documentation]    Kiểm tra không cho phép tạo hóa đơn khi số serial đã được sử dụng
    [Tags]    invoice    validation    inventory    serial    used
    Given Chuẩn bị dữ liệu hóa đơn với sản phẩm theo serial
    And Chuẩn bị dữ liệu hóa đơn với serial ${invoice_inventory_validation_used_serial}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 400
    And Response Should Have Error "Số serial đã được sử dụng bởi chứng từ khác"

RT-INIV-006 Kiểm tra tạo hóa đơn thành công với số serial hợp lệ
    [Documentation]    Kiểm tra cho phép tạo hóa đơn khi số serial hợp lệ và chưa sử dụng
    [Tags]    invoice    validation    inventory    serial    valid
    Given Chuẩn bị dữ liệu hóa đơn với sản phẩm theo serial
    And Chuẩn bị dữ liệu hóa đơn với serial ${invoice_inventory_validation_available_serial}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist

RT-INIV-007 Kiểm tra tạo hóa đơn thất bại khi sản phẩm combo không đủ tồn kho
    [Documentation]    Kiểm tra không cho phép tạo hóa đơn khi sản phẩm con trong combo không đủ tồn kho
    [Tags]    invoice    validation    inventory    combo    out_of_stock
    Given Chuẩn bị dữ liệu hóa đơn với sản phẩm combo
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 400
    And Response Should Have Error "Sản phẩm con trong combo không đủ số lượng tồn kho"

RT-INIV-008 Kiểm tra tạo hóa đơn thành công khi sản phẩm combo không đủ tồn kho nhưng cho phép bán âm
    [Documentation]    Kiểm tra cho phép tạo hóa đơn khi sản phẩm con trong combo không đủ tồn kho nhưng có cấu hình AllowSellWhenOutStock
    [Tags]    invoice    validation    inventory    combo    allow_out_of_stock
    Given Chuẩn bị dữ liệu hóa đơn với sản phẩm combo
    And Chuẩn bị dữ liệu hóa đơn với cấu hình AllowSellWhenOutStock=${invoice_inventory_validation_allow_out_of_stock}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist

RT-INIV-009 Kiểm tra tạo hóa đơn thất bại khi thông tin lô để trống
    [Documentation]    Kiểm tra không cho phép tạo hóa đơn khi thông tin lô bị để trống
    [Tags]    invoice    validation    inventory    batch    empty
    Given Chuẩn bị dữ liệu hóa đơn với sản phẩm theo lô
    And Set To Dictionary    ${REQUEST_DATA["Invoice"]["InvoiceDetails"][0]}    BatchId=${None}
    And Set To Dictionary    ${REQUEST_DATA["Invoice"]["InvoiceDetails"][0]}    BatchName=${None}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 400
    And Response Should Have Error "Thông tin lô không được để trống"

RT-INIV-010 Kiểm tra tạo hóa đơn thất bại khi lô không tồn tại
    [Documentation]    Kiểm tra không cho phép tạo hóa đơn khi lô không tồn tại trong hệ thống
    [Tags]    invoice    validation    inventory    batch    not_exist
    Given Chuẩn bị dữ liệu hóa đơn với sản phẩm theo lô
    And Set To Dictionary    ${REQUEST_DATA["Invoice"]["InvoiceDetails"][0]}    BatchId=999999
    And Set To Dictionary    ${REQUEST_DATA["Invoice"]["InvoiceDetails"][0]}    BatchName=LOT_NOT_EXIST
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 400
    And Response Should Have Error "Lô không tồn tại trong hệ thống"

RT-INIV-011 Kiểm tra tạo hóa đơn thất bại khi lô đã hết hạn
    [Documentation]    Kiểm tra không cho phép tạo hóa đơn khi lô đã hết hạn
    [Tags]    invoice    validation    inventory    batch    expired
    Given Chuẩn bị dữ liệu hóa đơn với sản phẩm theo lô
    And Chuẩn bị dữ liệu hóa đơn với lô hết hạn ${invoice_inventory_validation_expired_date}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 400
    And Response Should Have Error "Lô đã hết hạn sử dụng"

RT-INIV-012 Kiểm tra tạo hóa đơn thất bại khi số lượng vượt quá tồn kho của lô
    [Documentation]    Kiểm tra không cho phép tạo hóa đơn khi số lượng vượt quá tồn của lô
    [Tags]    invoice    validation    inventory    batch    quantity
    Given Chuẩn bị dữ liệu hóa đơn với sản phẩm theo lô
    And Set To Dictionary    ${REQUEST_DATA["Invoice"]["InvoiceDetails"][0]}    Quantity=${invoice_inventory_validation_qty_exceed}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 400
    And Response Should Have Error "Lô không đủ số lượng tồn kho"

RT-INIV-013 Kiểm tra tạo hóa đơn thành công với lô còn hạn và đủ số lượng
    [Documentation]    Kiểm tra cho phép tạo hóa đơn khi lô còn hạn và đủ số lượng
    [Tags]    invoice    validation    inventory    batch    valid
    Given Chuẩn bị dữ liệu hóa đơn với sản phẩm theo lô
    And Chuẩn bị dữ liệu hóa đơn với lô hết hạn ${invoice_inventory_validation_expire_date}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist

RT-INIV-014 Kiểm tra tạo hóa đơn thành công khi số lượng vượt quá tồn kho của lô nhưng cho phép bán âm
    [Documentation]    Kiểm tra cho phép tạo hóa đơn khi số lượng vượt quá tồn của lô nhưng có cấu hình AllowSellWhenOutStock
    [Tags]    invoice    validation    inventory    batch    allow_out_of_stock
    Given Chuẩn bị dữ liệu hóa đơn với sản phẩm theo lô
    And Set To Dictionary    ${REQUEST_DATA["Invoice"]["InvoiceDetails"][0]}    Quantity=${invoice_inventory_validation_qty_exceed}
    And Chuẩn bị dữ liệu hóa đơn với cấu hình AllowSellWhenOutStock=${invoice_inventory_validation_allow_out_of_stock}
    When Gửi yêu cầu tạo hóa đơn
    Then Response Status Code Should Be 200
    And Response Should Have Id exist 