*** Settings ***
Documentation     Test cases API cho phần cập nhật tồn kho khi tạo hóa đơn
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Invoice/InventoryUpdateKeywords.robot
Resource          ../../../Keywords/Invoice/InvoiceCommonKeywords.robot
Resource          ../../../Keywords/Utilities/RequestHelper.robot
Library           ../../../Resources/DatabaseLibrary.py
Test Teardown     Delete Invoice From API
*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    InventoryUpdateTest

*** Test Cases ***
RT-INU-001 Cập nhật tồn kho khi tạo hóa đơn với sản phẩm thường
    [Tags]    inventory    smoke   apiinvoice    regression
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với sản phẩm thường
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ${PRODUCT_CODE_NOMAL}, Số lượng=5, Giá=100,000đ
    ...    - Logic xử lý: ProductBranchService.UpdateInventory()
    ...    - Code: productBranch.OnHand -= invoiceDetail.Quantity
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng tồn kho giảm 5 đơn vị
    ...    - Lịch sử tồn kho được ghi nhận với DocumentType=Invoice, Value=-5
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Mã ${PRODUCT_CODE_NOMAL} có Số Lượng 5
    And Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm ${PRODUCT_CODE_NOMAL}    
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Tồn kho sản phẩm ${PRODUCT_CODE_NOMAL} đã giảm 5 đơn vị
    And Lịch sử tồn kho được tạo với số lượng 5 đơn vị cho sản phẩm ${PRODUCT_CODE_NOMAL} 

RT-INU-002 Cập nhật tồn kho khi tạo hóa đơn với số lượng thập phân
    [Tags]    inventory    smoke   apiinvoice    regression
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với số lượng thập phân
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${PRODUCT_CODE_DECIMAL}, Số lượng=100.555, Giá=100,000đ
    ...    - Logic xử lý: ProductBranchService.UpdateInventory()
    ...    - Code: productBranch.OnHand -= invoiceDetail.Quantity
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng tồn kho giảm 100 đơn vị
    ...    - Lịch sử tồn kho được ghi nhận với DocumentType=Invoice, Value=-100
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Mã ${PRODUCT_CODE_DECIMAL} có Số Lượng 100.555
    And Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm ${PRODUCT_CODE_DECIMAL}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Tồn kho sản phẩm ${PRODUCT_CODE_DECIMAL} đã giảm 100.555 đơn vị
    And Lịch sử tồn kho được tạo với số lượng 100.555 đơn vị cho sản phẩm ${PRODUCT_CODE_DECIMAL}

RT-INU-003 Cập nhật tồn kho khi tạo hóa đơn với sản phẩm combo
    [Tags]    inventory    smoke   apiinvoice    regression
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với sản phẩm combo
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm combo ${PRODUCT_CODE_COMBO}, Số lượng=1, Giá=150,000đ
    ...    - Logic xử lý: ProductBranchService.UpdateInventory()
    ...    - Code: Với mỗi sản phẩm con: productBranch.OnHand -= (combo.Quantity * childProduct.Quantity)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tồn kho các sản phẩm con trong combo giảm theo định mức
    ...    - Lịch sử tồn kho được ghi nhận cho từng sản phẩm con
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Mã ${PRODUCT_CODE_COMBO} có Số Lượng 2
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Sản phẩm con trong combo ${PRODUCT_CODE_COMBO} đã giảm tồn kho 2 lần số lượng


RT-INU-006 Cập nhật tồn kho khi tạo hóa đơn với đơn vị chuyển đổi
    [Tags]    inventory    smoke   apiinvoice    regression
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với đơn vị chuyển đổi
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ${PRODUCT_CODE_QD}, Số lượng=2, Giá=100,000đ, UnitId=2, ConversionValue=12
    ...    - Logic xử lý: ProductBranchService.UpdateInventory()
    ...    - Code: productBranch.OnHand -= (invoiceDetail.Quantity * invoiceDetail.ConversionValue)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng tồn kho giảm 24 đơn vị (2 * 12)
    ...    - Lịch sử tồn kho được ghi nhận với DocumentType=Invoice, Value=-24
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Mã ${PRODUCT_CODE_QD} có Số Lượng 2
    And Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm ${PRODUCT_CODE_DVCB} 
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Tồn kho sản phẩm ${PRODUCT_CODE_DVCB} đã giảm theo đơn vị chuyển đổi 2 x 5.5

RT-INU-007 Cập nhật tồn kho khi tạo hóa đơn với hàng dịch vụ
    [Tags]    inventory    smoke   apiinvoice    regression
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với hàng dịch vụ
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm 1: ${PRODUCT_CODE_SERVICE} Số lượng=2, Giá=100,000đ
    ...    - Logic xử lý: ProductBranchService.UpdateInventory()
    ...    - Code: Với mỗi sản phẩm: productBranch.OnHand -= invoiceDetail.Quantity
    ...    - Kỳ vọng:
    ...    - Status code: 200

    ...    - Lịch sử tồn kho được ghi nhận cho từng sản phẩm
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Mã ${PRODUCT_CODE_SERVICE} có Số Lượng 2
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Lịch sử tồn kho được tạo với số lượng 2 đơn vị cho sản phẩm ${PRODUCT_CODE_SERVICE} 

RT-INU-008 Cập nhật tồn kho âm khi cho phép bán hàng khi hết tồn
    [Tags]    inventory    smoke   apiinvoice    regression
    [Documentation]    Kiểm tra cập nhật tồn kho âm khi cho phép bán hàng khi hết tồn
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ${PRODUCT_CODE_AM}, Số lượng=1000, Giá=100,000đ
    ...    - Cấu hình: AllowSellWhenOutStock=true
    ...    - Logic xử lý: ProductBranchService.UpdateInventory()
    ...    - Code: if (productBranch.AllowSellWhenOutStock) productBranch.OnHand -= invoiceDetail.Quantity
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng tồn kho giảm 1000 đơn vị (tồn kho âm)
    ...    - Lịch sử tồn kho được ghi nhận với DocumentType=Invoice, Value=-1000
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Mã ${PRODUCT_CODE_AM} có Số Lượng 5
    And Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm ${PRODUCT_CODE_AM}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Tồn kho sản phẩm ${PRODUCT_CODE_AM} đã giảm 5 đơn vị
    And Lịch sử tồn kho được tạo với số lượng 5 đơn vị cho sản phẩm ${PRODUCT_CODE_AM}


RT-INU-005 Cập nhật tồn kho khi tạo hóa đơn với sản phẩm theo lô
    [Tags]    inventory    smoke   apiinvoice    regression
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với sản phẩm theo lô
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ${PRODUCT_BATCH_NAME}, Số lượng=1, Giá=100,000đ,  BatchName=${BATCH_NAME}
    ...    - Logic xử lý: BatchExpireService.UpdateBatchQuantity()
    ...    - Code: batch.Quantity -= invoiceDetail.Quantity
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng lô giảm 1 đơn vị
    ...    - Lịch sử lô được ghi nhận với DocumentType=Invoice, Value=-1
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Theo Lô ${PRODUCT_BATCH_NAME} với ${BATCH_NAME} số lượng 1
    And Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm ${PRODUCT_BATCH_NAME}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Số lượng lô ${product_batch_id} đã giảm 1 đơn vị

RT-INU-004 Cập nhật tồn kho khi tạo hóa đơn với sản phẩm theo serial
    [Tags]    inventory    smoke   apiinvoice    regression
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với sản phẩm theo serial
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm  ${PRODUCT_CODE_SERIAL} Số lượng=1, Giá=100,000đ, Serial=${SERIAL_NUMBER}
    ...    - Logic xử lý: SerialService.UpdateSerialStatus()
    ...    - Code: serial.Status = SerialStatus.Sold; serial.DocumentId = invoice.Id; serial.DocumentType = DocumentType.Invoice
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Serial được chuyển sang trạng thái đã bán (Status=0)
    ...    - Serial được liên kết với hóa đơn và có DocumentType=1 (Invoice)
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Theo Serial ${PRODUCT_CODE_SERIAL} Với Serial ${SERIAL_NUMBER}
    And Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm ${PRODUCT_CODE_SERIAL}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Tồn kho sản phẩm ${PRODUCT_CODE_SERIAL} đã giảm 1 đơn vị
    And Serial ${SERIAL_NUMBER} chuyển sang trạng thái đã bán
 
RT-INU-009 Cập nhật tồn kho khi tạo hóa đơn với nhiều sản phẩm
    [Tags]    inventory    smoke   apiinvoice    regression4355s
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với nhiều sản phẩm khác nhau
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm 1: GHDU003, Số lượng=3, Giá=100,000đ
    ...    - Sản phẩm 2: GHDU004, Số lượng=2.5, Giá=150,000đ
    ...    - Logic xử lý: ProductBranchService.UpdateInventory() cho từng sản phẩm
    ...    - Code: productBranch.OnHand -= invoiceDetail.Quantity
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng tồn kho sản phẩm 1 giảm 3 đơn vị
    ...    - Số lượng tồn kho sản phẩm 2 giảm 2.5 đơn vị
    ...    - Lịch sử tồn kho được ghi nhận cho cả hai sản phẩm
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm GHDU003 Số Lượng 3 Và Hàng Hóa GHDU004 Số Lượng 2.5
    And Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm GHDU003
    And Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm GHDU004
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Tồn kho sản phẩm GHDU003 đã giảm 3 đơn vị
    And Tồn kho sản phẩm GHDU004 đã giảm 2.5 đơn vị
    And Lịch sử tồn kho được tạo với số lượng 3 đơn vị cho sản phẩm GHDU003
    And Lịch sử tồn kho được tạo với số lượng 2.5 đơn vị cho sản phẩm GHDU004

RT-INU-009 Cập nhật tồn kho khi tạo hóa đơn với sản phẩm nhiều dòng
    [Tags]    inventory    smoke   apiinvoice    regression
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với nhiều sản phẩm khác nhau
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm 1: ${PRODUCT_CODE_NOMAL}, Số lượng=3, Giá=100,000đ
    ...     Thêm 5 dòng sản phẩm 1 mỗi dòng số lương 3 vào hóa đơn
    ...    - Logic xử lý: ProductBranchService.UpdateInventory() cho từng sản phẩm
    ...    - Code: productBranch.OnHand -= invoiceDetail.Quantity
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng tồn kho sản phẩm  giảm 18 đơn vị
    Given Chuẩn Bị Dữ Liêu Hóa Đơn Với Sản Phẩm HH0080 Có 5 Dòng Số Lượng Mỗi Dòng 2
    And Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm HH0080 
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Tồn kho sản phẩm HH0080 đã giảm ${TOTAL_QUANTITY} đơn vị
    And Lịch sử tồn kho được tạo với số lượng ${TOTAL_QUANTITY} đơn vị cho sản phẩm HH0080


# RT-INU-009 Cập nhật số lượng đặt hàng khi tạo hóa đơn từ đơn hàng    Chuyển sang file khác
#     [Documentation]    Kiểm tra cập nhật số lượng đặt hàng khi tạo hóa đơn từ đơn hàng
#     ...    - Dữ liệu đầu vào:
#     ...    - Sản phẩm ID=${PRODUCT_1}, Số lượng=5, Giá=100,000đ
#     ...    - OrderId=${ORDER_ID}
#     ...    - Logic xử lý: OrderDetailService.UpdateDeliveredQuantity(), ProductBranchService.UpdateOnOrder()
#     ...    - Code: orderDetail.DeliveredQuantity += invoiceDetail.Quantity; productBranch.OnOrder -= invoiceDetail.Quantity
#     ...    - Kỳ vọng:
#     ...    - Status code: 200
#     ...    - Số lượng đã giao (DeliveredQuantity) tăng 5 đơn vị
#     ...    - Số lượng đặt hàng (OnOrder) giảm 5 đơn vị
#     Given Chuẩn Bị Dữ Liệu Hóa Đơn Từ Đơn Hàng
#     And Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm ${PRODUCT_1}
#     When Gửi Yêu Cầu Tạo Hóa Đơn
#     Then Response Status Code Should Be 200
#     And Tồn kho sản phẩm ${PRODUCT_1} đã giảm 5 đơn vị
#     And Lịch sử tồn kho được tạo với số lượng 5 đơn vị cho sản phẩm ${PRODUCT_1}
#     And Số lượng đặt hàng của sản phẩm ${PRODUCT_1} được giảm 5 đơn vị 

RT-INU-010 Cập nhật tồn kho khi tạo hóa đơn với sản phẩm combo 2 cấp 
    [Tags]    inventory    smoke   apiinvoice  test4723754    regression
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với sản phẩm combo
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm combo ${PRODUCT_CODE_COMBO}, Số lượng=1, Giá=150,000đ
    ...    - Logic xử lý: ProductBranchService.UpdateInventory()
    ...    - Code: Với mỗi sản phẩm con: productBranch.OnHand -= (combo.Quantity * childProduct.Quantity)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tồn kho các sản phẩm con trong combo giảm theo định mức
    ...    - Lịch sử tồn kho được ghi nhận cho từng sản phẩm con cấp 1
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Mã COMBOC2 có Số Lượng 2
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Sản phẩm con trong combo COMBOC2 đã giảm tồn kho 2 lần số lượng