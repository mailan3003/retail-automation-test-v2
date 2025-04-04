*** Settings ***
Documentation     Test cases API cho phần cập nhật tồn kho khi tạo hóa đơn - Phần mở rộng
Resource          ../../../Keywords/Invoice/InventoryUpdateKeywords.robot
Resource          ../../../Keywords/Invoice/InventoryUpdateExtendedKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    InventoryUpdateExtendedTest

*** Test Cases ***
RT-INU-010 Cập nhật tồn kho khi tạo hóa đơn với nhiều loại sản phẩm tồn kho
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với nhiều loại sản phẩm tồn kho khác nhau
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm thường: ID=${PRODUCT_1}, Số lượng=3, Giá=100,000đ
    ...    - Sản phẩm lô: ID=${product_batch}, Số lượng=2, Giá=150,000đ, BatchId=${batch_1}, BatchName=LOT001
    ...    - Sản phẩm Serial: ID=${PRODUCT_2}, Số lượng=1, Giá=200,000đ, SerialNumbers=SN005
    ...    - Logic xử lý: 
    ...    1. Với sản phẩm thường: productBranch.OnHand -= invoiceDetail.Quantity
    ...    2. Với sản phẩm lô: batch.Quantity -= invoiceDetail.Quantity
    ...    3. Với sản phẩm serial: serial.Status = SerialStatus.Sold
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Sản phẩm thường: Tồn kho giảm 3 đơn vị, lịch sử ghi nhận -3
    ...    - Sản phẩm lô: Tồn kho giảm 2 đơn vị, lô giảm 2 đơn vị
    ...    - Sản phẩm Serial: Serial SN005 chuyển sang trạng thái đã bán
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Nhiều Loại Tồn Kho
    And Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm ${PRODUCT_1}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Tồn kho nhiều sản phẩm đã được cập nhật đúng

RT-INU-011 Cập nhật tồn kho khi tạo hóa đơn với sản phẩm combo số lượng lớn
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với sản phẩm combo số lượng lớn
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm combo ID=${COMBO_PRODUCT_1_ID}, Số lượng=5, Giá=150,000đ, IsCombo=true
    ...    - Thiết lập combo: 
    ...       + Sản phẩm thành phần 1: ID=${COMBO_PRODUCT_1_MATTERIAL_1_ID}, Số lượng=1
    ...       + Sản phẩm thành phần 2: ID=${COMBO_PRODUCT_1_MATTERIAL_2_ID}, Số lượng=1
    ...    - Logic xử lý: ProductBranchService.UpdateInventory()
    ...    - Code: Với mỗi sản phẩm con: productBranch.OnHand -= (combo.Quantity * childProduct.Quantity)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Sản phẩm thành phần 1: Tồn kho giảm 5 đơn vị (5 * 1)
    ...    - Sản phẩm thành phần 2: Tồn kho giảm 5 đơn vị (5 * 1)
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Combo Số Lượng Lớn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Tồn kho combo ${COMBO_PRODUCT_1_ID} đã giảm với số lượng 5

RT-INU-012 Cập nhật tồn kho khi tạo hóa đơn với nhiều lô cho một sản phẩm
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với nhiều lô cho một sản phẩm
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${product_batch}, Số lượng=3, Giá=100,000đ
    ...    - Chi tiết lô: 
    ...       + Lô 1: BatchId=${batch_1}, BatchName=LOT001, Số lượng=2
    ...       + Lô 2: BatchId=8889, BatchName=LOT002, Số lượng=1
    ...    - Logic xử lý: BatchExpireService.UpdateBatchQuantity()
    ...    - Code: Với mỗi lô: batch.Quantity -= batch.DetailQuantity
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tồn kho sản phẩm giảm tổng 3 đơn vị
    ...    - Số lượng lô LOT001 giảm 2 đơn vị
    ...    - Số lượng lô LOT002 giảm 1 đơn vị
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Lô Cho Một Sản Phẩm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Các lô của sản phẩm ${product_batch} đã giảm theo chi tiết [{"BatchId": ${batch_1}, "BatchName": "LOT001", "Quantity": 2}, {"BatchId": 8889, "BatchName": "LOT002", "Quantity": 1}]

RT-INU-013 Cập nhật tồn kho khi tạo hóa đơn với đơn vị chuyển đổi không chuẩn
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với đơn vị chuyển đổi không chuẩn (số thập phân)
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${PRODUCT_1}, Số lượng=1.5, Giá=100,000đ, UnitId=3, ConversionValue=0.5
    ...    - Logic xử lý: ProductBranchService.UpdateInventory()
    ...    - Code: productBranch.OnHand -= (invoiceDetail.Quantity * invoiceDetail.ConversionValue)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng tồn kho giảm 0.75 đơn vị (1.5 * 0.5)
    ...    - Lịch sử tồn kho được ghi nhận với DocumentType=Invoice, Value=-0.75
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Đơn Vị Chuyển Đổi Không Chuẩn
    And Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm ${PRODUCT_1}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Tồn kho sản phẩm ${PRODUCT_1} đã giảm với đơn vị chuyển đổi 1.5 x 0.5

RT-INU-014 Cập nhật tồn kho khi tạo hóa đơn với nhiều chi nhánh
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với nhiều chi nhánh khác nhau
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm 1: ID=${PRODUCT_1}, Số lượng=2, Giá=100,000đ, BranchId=${DEFAULT_BRANCH_ID}
    ...    - Sản phẩm 2: ID=${PRODUCT_2}, Số lượng=1, Giá=150,000đ, BranchId=${OTHER_BRANCH_ID}
    ...    - Logic xử lý: ProductBranchService.UpdateInventory()
    ...    - Code: productBranch.OnHand -= invoiceDetail.Quantity WHERE BranchId = invoiceDetail.BranchId
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng tồn kho sản phẩm 1 ở chi nhánh ${DEFAULT_BRANCH_ID} giảm 2 đơn vị
    ...    - Số lượng tồn kho sản phẩm 2 ở chi nhánh ${OTHER_BRANCH_ID} giảm 1 đơn vị
    ...    - Lịch sử tồn kho được ghi nhận với BranchId phù hợp
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Chi Nhánh
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Tồn kho đã được cập nhật cho nhiều chi nhánh

RT-INU-015 Cập nhật tồn kho với quy tắc FIFO cho sản phẩm lô
    [Documentation]    Kiểm tra cập nhật tồn kho với quy tắc FIFO (First Expired, First Out) cho sản phẩm lô
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${product_batch}, Số lượng=5, Giá=100,000đ, ProcessingType=FIFO
    ...    - Logic xử lý: BatchExpireService.UpdateBatchQuantity() theo quy tắc FIFO
    ...    - Code: Lấy danh sách lô theo thứ tự ngày hết hạn tăng dần và xuất theo thứ tự
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tồn kho giảm 5 đơn vị
    ...    - Các lô được xuất theo thứ tự ngày hết hạn (lô gần hết hạn được xuất trước)
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Xử Lý FIFO
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Tồn kho đã được cập nhật theo quy tắc FIFO cho sản phẩm ${product_batch} với số lượng 5
    
RT-INU-016 Cập nhật tồn kho không thành công khi tổng số lượng lô không đủ
    [Documentation]    Kiểm tra lỗi khi cập nhật tồn kho với số lượng lớn hơn tổng số lượng lô có sẵn
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${product_batch}, Số lượng=1000, Giá=100,000đ
    ...    - Cấu hình: AllowSellWhenOutStock=false
    ...    - Logic xử lý: BatchExpireService.ValidateBatchQuantity()
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Error message chứa thông tin "Sản phẩm [...] không đủ số lượng lô"
    ...    - Không có thay đổi tồn kho
    ${data}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    ${details}=    Create List    
    @{details}=    Create List
    ${product_detail}=    Create Dictionary    ProductId=${product_batch}    ProductCode=BATCH001    Quantity=1000    Price=100000    BatchId=${batch_1}    BatchName=LOT001
    Append To List    ${details}    ${product_detail}
    ${data}=    Update Nested Dictionary Property    ${data}    Invoice.InvoiceDetails    ${details}
    ${data}=    Update Nested Dictionary Property    ${data}    Invoice.Code    HD_BATCH_ERROR_001
    ${data}=    Update Nested Dictionary Property    ${data}    Invoice.AllowSellWhenOutStock    ${FALSE}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Contain Property With Value    responseStatus.errorCode    INSUFFICIENT_BATCH_QUANTITY
    
RT-INU-017 Cập nhật tồn kho không thành công khi serial đã được bán
    [Documentation]    Kiểm tra lỗi khi cập nhật tồn kho với serial đã được bán
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${PRODUCT_1}, Số lượng=1, Giá=100,000đ, SerialNumbers=SN003,SN004
    ...    - Logic xử lý: SerialService.ValidateSerialStatus()
    ...    - Code: if (serial.Status == SerialStatus.Sold) throw new ValidationException()
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Error message chứa thông tin về serial đã bán
    ...    - Không có thay đổi tồn kho
    ${data}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    ${details}=    Create List    
    @{details}=    Create List
    ${product_detail}=    Create Dictionary    ProductId=${PRODUCT_1}    ProductCode=${PRODUCT_1_CODE}    Quantity=1    Price=100000    SerialNumbers=SN003,SN004
    Append To List    ${details}    ${product_detail}
    ${data}=    Update Nested Dictionary Property    ${data}    Invoice.InvoiceDetails    ${details}
    ${data}=    Update Nested Dictionary Property    ${data}    Invoice.Code    HD_SERIAL_ERROR_001
    Set Test Variable    ${REQUEST_DATA}    ${data}
    
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Contain Property With Value    responseStatus.errorCode    SERIAL_ALREADY_SOLD 