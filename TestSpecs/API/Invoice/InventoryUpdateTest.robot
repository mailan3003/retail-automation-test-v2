*** Settings ***
Documentation     Test cases API cho phần cập nhật tồn kho khi tạo hóa đơn
Resource          ../../../Keywords/Invoice/InventoryUpdateKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    InventoryUpdateTest

*** Test Cases ***
RT-INU-001 Cập nhật tồn kho khi tạo hóa đơn với sản phẩm thường
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với sản phẩm thường
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${PRODUCT_1}, Số lượng=5, Giá=100,000đ
    ...    - Logic xử lý: ProductBranchService.UpdateInventory()
    ...    - Code: productBranch.OnHand -= invoiceDetail.Quantity
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng tồn kho giảm 5 đơn vị
    ...    - Lịch sử tồn kho được ghi nhận với DocumentType=Invoice, Value=-5
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Có Số Lượng 5
    And Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm ${PRODUCT_1}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Tồn kho sản phẩm ${PRODUCT_1} đã giảm 5 đơn vị
    And Lịch sử tồn kho được tạo với số lượng 5 đơn vị cho sản phẩm ${PRODUCT_1}

RT-INU-002 Cập nhật tồn kho khi tạo hóa đơn với số lượng lớn
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với số lượng lớn
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${PRODUCT_1}, Số lượng=100, Giá=100,000đ
    ...    - Logic xử lý: ProductBranchService.UpdateInventory()
    ...    - Code: productBranch.OnHand -= invoiceDetail.Quantity
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng tồn kho giảm 100 đơn vị
    ...    - Lịch sử tồn kho được ghi nhận với DocumentType=Invoice, Value=-100
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Có Số Lượng 100
    And Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm ${PRODUCT_1}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Tồn kho sản phẩm ${PRODUCT_1} đã giảm 100 đơn vị
    And Lịch sử tồn kho được tạo với số lượng 100 đơn vị cho sản phẩm ${PRODUCT_1}

RT-INU-003 Cập nhật tồn kho khi tạo hóa đơn với sản phẩm combo
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với sản phẩm combo
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm combo ID=${COMBO_PRODUCT_ID}, Số lượng=1, Giá=150,000đ
    ...    - Logic xử lý: ProductBranchService.UpdateInventory()
    ...    - Code: Với mỗi sản phẩm con: productBranch.OnHand -= (combo.Quantity * childProduct.Quantity)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tồn kho các sản phẩm con trong combo giảm theo định mức
    ...    - Lịch sử tồn kho được ghi nhận cho từng sản phẩm con
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Combo
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Sản phẩm con trong combo ${COMBO_PRODUCT_ID} đã giảm tồn kho

RT-INU-004 Cập nhật tồn kho khi tạo hóa đơn với sản phẩm theo serial
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với sản phẩm theo serial
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${PRODUCT_1}, Số lượng=1, Giá=100,000đ, Serial=SN001,SN002
    ...    - Logic xử lý: SerialService.UpdateSerialStatus()
    ...    - Code: serial.Status = SerialStatus.Sold; serial.DocumentId = invoice.Id; serial.DocumentType = DocumentType.Invoice
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Serial được chuyển sang trạng thái đã bán (Status=2)
    ...    - Serial được liên kết với hóa đơn và có DocumentType=3 (Invoice)
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Theo Serial
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Serial SN001 chuyển sang trạng thái đã bán

RT-INU-005 Cập nhật tồn kho khi tạo hóa đơn với sản phẩm theo lô
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với sản phẩm theo lô
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${product_batch}, Số lượng=1, Giá=100,000đ, BatchId=${batch_1}, BatchName=LOT001
    ...    - Logic xử lý: BatchExpireService.UpdateBatchQuantity()
    ...    - Code: batch.Quantity -= invoiceDetail.Quantity
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng lô giảm 1 đơn vị
    ...    - Lịch sử lô được ghi nhận với DocumentType=Invoice, Value=-1
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Theo Lô
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Số lượng lô ${batch_1} đã giảm 1 đơn vị

RT-INU-006 Cập nhật tồn kho khi tạo hóa đơn với đơn vị chuyển đổi
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với đơn vị chuyển đổi
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${PRODUCT_1}, Số lượng=2, Giá=100,000đ, UnitId=2, ConversionValue=12
    ...    - Logic xử lý: ProductBranchService.UpdateInventory()
    ...    - Code: productBranch.OnHand -= (invoiceDetail.Quantity * invoiceDetail.ConversionValue)
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng tồn kho giảm 24 đơn vị (2 * 12)
    ...    - Lịch sử tồn kho được ghi nhận với DocumentType=Invoice, Value=-24
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Đơn Vị Chuyển Đổi
    And Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm ${PRODUCT_1}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Tồn kho sản phẩm ${PRODUCT_1} đã giảm theo đơn vị chuyển đổi 2 x 12

RT-INU-007 Cập nhật tồn kho khi tạo hóa đơn với nhiều sản phẩm
    [Documentation]    Kiểm tra cập nhật tồn kho khi tạo hóa đơn với nhiều sản phẩm
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm 1: ID=${PRODUCT_1}, Số lượng=5, Giá=100,000đ
    ...    - Sản phẩm 2: ID=${PRODUCT_1}, Số lượng=100, Giá=100,000đ
    ...    - Logic xử lý: ProductBranchService.UpdateInventory()
    ...    - Code: Với mỗi sản phẩm: productBranch.OnHand -= invoiceDetail.Quantity
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng tồn kho của sản phẩm 1 giảm 5 đơn vị
    ...    - Số lượng tồn kho của sản phẩm 2 giảm 100 đơn vị
    ...    - Lịch sử tồn kho được ghi nhận cho từng sản phẩm
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Sản Phẩm
    And Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm ${PRODUCT_1}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Lịch sử tồn kho được tạo với số lượng 5 đơn vị cho sản phẩm ${PRODUCT_1}
    And Lịch sử tồn kho được tạo với số lượng 100 đơn vị cho sản phẩm ${PRODUCT_1}

RT-INU-008 Cập nhật tồn kho âm khi cho phép bán hàng khi hết tồn
    [Documentation]    Kiểm tra cập nhật tồn kho âm khi cho phép bán hàng khi hết tồn
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${product_out_of_stock}, Số lượng=1000, Giá=100,000đ
    ...    - Cấu hình: AllowSellWhenOutStock=true
    ...    - Logic xử lý: ProductBranchService.UpdateInventory()
    ...    - Code: if (productBranch.AllowSellWhenOutStock) productBranch.OnHand -= invoiceDetail.Quantity
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng tồn kho giảm 1000 đơn vị (tồn kho âm)
    ...    - Lịch sử tồn kho được ghi nhận với DocumentType=Invoice, Value=-1000
    Given Chuẩn Bị Dữ Liệu Cho Phép Bán Âm Khi Hết Tồn Kho
    And Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm ${product_out_of_stock}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Tồn kho sản phẩm ${product_out_of_stock} đã giảm 1000 đơn vị
    And Lịch sử tồn kho được tạo với số lượng 1000 đơn vị cho sản phẩm ${product_out_of_stock}

RT-INU-009 Cập nhật số lượng đặt hàng khi tạo hóa đơn từ đơn hàng
    [Documentation]    Kiểm tra cập nhật số lượng đặt hàng khi tạo hóa đơn từ đơn hàng
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${PRODUCT_1}, Số lượng=5, Giá=100,000đ
    ...    - OrderId=${ORDER_ID}
    ...    - Logic xử lý: OrderDetailService.UpdateDeliveredQuantity(), ProductBranchService.UpdateOnOrder()
    ...    - Code: orderDetail.DeliveredQuantity += invoiceDetail.Quantity; productBranch.OnOrder -= invoiceDetail.Quantity
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng đã giao (DeliveredQuantity) tăng 5 đơn vị
    ...    - Số lượng đặt hàng (OnOrder) giảm 5 đơn vị
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Từ Đơn Hàng
    And Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm ${PRODUCT_1}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Tồn kho sản phẩm ${PRODUCT_1} đã giảm 5 đơn vị
    And Lịch sử tồn kho được tạo với số lượng 5 đơn vị cho sản phẩm ${PRODUCT_1}
    And Số lượng đặt hàng của sản phẩm ${PRODUCT_1} được giảm 5 đơn vị 