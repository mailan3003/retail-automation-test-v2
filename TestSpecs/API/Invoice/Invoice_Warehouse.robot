*** Settings ***

Resource     ../../../Keywords/Invoice/InvoiceWarehouseKeywords.robot
Resource     ../../../Keywords/Invoice/InventoryUpdateKeywords.robot
Resource     ../../../Keywords/Utilities/ResponseHelper.robot
Resource     ../../../Keywords/Utilities/RequestHelper.robot
Resource     ../../../Keywords/Utilities/DataUtilities.robot

Library      ../../../Resources/DatabaseLibrary.py
Test Teardown     Tear Down Delete Hóa Đơn

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    InvoiceWarehouseTest

*** Test Cases ***
RT-IWH-001 Tạo hóa đơn gian hàng với sản phẩm từ kho bán hàng
    [Tags]    warehouse    smoke      dakho
    [Documentation]    Kiểm tra tạo hóa đơn gian hàng với sản phẩm từ kho chính
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ${PRODUCT_CODE_1}, Số lượng=2.51, Giá=100,000đ, Kho=${MAIN_WAREHOUSE_ID}
    ...    - Logic xử lý: InvoiceWarehouseService.CreateInvoiceWithWarehouse()
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - InvoiceWarehouseDetail được tạo với WarehouseId=${MAIN_WAREHOUSE_ID}
    ...    - Số lượng tồn kho tại kho chính giảm 1 đơn vị
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Mã WH00001 có Số Lượng 2.51 Kho Bán Hàng
    And Xem Thông Tin Tổng Tồn Kho Của Sản Phẩm ${product_id}
    And Xem Thông Tin Tồn Kho Của Sản Phẩm ${product_id} Tại Kho Bán Hàng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Chi Tiết Hóa Đơn Có Thông Tin Kho Bán Hàng
    And Tổng tồn kho sản phẩm ${product_id} đã giảm 2.51 đơn vị
    And Tồn kho sản phẩm ${product_id} đã giảm 2.51 đơn vị Tại Kho Bán Hàng

RT-IWH-002 Tạo hóa đơn gian hàng với sản phẩm từ kho phụ
    [Tags]    warehouse    smoke     dakho
    [Documentation]    Kiểm tra tạo hóa đơn gian hàng với sản phẩm từ kho phụ
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ${PRODUCT_CODE_1}, Số lượng=1, Giá=100,000đ, Kho=${SECONDARY_WAREHOUSE_ID}
    ...    - Logic xử lý: InvoiceWarehouseService.CreateInvoiceWithWarehouse()
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - InvoiceWarehouseDetail được tạo với WarehouseId=${SECONDARY_WAREHOUSE_ID}
    ...    - Số lượng tồn kho tại kho phụ giảm 1 đơn vị
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Mã WH0002 có Số Lượng 3.01 Kho Kho 1
    And Xem Thông Tin Tổng Tồn Kho Của Sản Phẩm ${product_id}
    And Xem Thông Tin Tồn Kho Của Sản Phẩm ${product_id} Tại Kho Kho 1
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Chi Tiết Hóa Đơn Có Thông Tin Kho Kho 1
    And Tồn kho sản phẩm ${product_id} đã giảm 3.01 đơn vị Tại Kho Kho 1
    And Tổng tồn kho sản phẩm ${product_id} đã giảm 3.01 đơn vị


RT-IWH-006 Tạo hóa đơn gian hàng với hàng imei  
    [Documentation]    Kiểm tra tạo hóa đơn gian hàng với sản phẩm chưa có tồn kho (AllowSellWhenOutOfStock=true)
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ${PRODUCT_CODE_NO_STOCK}, Số lượng=2, Giá=100,000đ, Kho=${MAIN_WAREHOUSE_ID}
    ...    - Logic xử lý: InvoiceWarehouseService.CreateInvoiceWithWarehouse()
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - InvoiceWarehouseDetail được tạo với WarehouseId=${MAIN_WAREHOUSE_ID}
    ...    - Số lượng tồn kho tại kho chính giảm xuống giá trị âm
    [Tags]    warehouse    smoke     dakho
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm WHSI000001 Với Serial MI0001 Tại Kho Bán Hàng    
    And Xem Thông Tin Tổng Tồn Kho Của Sản Phẩm ${product_id}
    And Xem Thông Tin Tồn Kho Của Sản Phẩm ${product_id} Tại Kho Bán Hàng 
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Chi Tiết Hóa Đơn Có Thông Tin Kho Bán Hàng
    And Tổng tồn kho sản phẩm ${product_id} đã giảm 1 đơn vị
    And Tồn kho sản phẩm ${product_id} đã giảm 1 đơn vị Tại Kho Bán Hàng
    And Serial MI0001 chuyển sang trạng thái đã bán

RT-IWH-007 Tạo hóa đơn gian hàng với hàng imei  
    [Tags]    warehouse    smoke     dakho
    [Documentation]    Kiểm tra tạo hóa đơn gian hàng với sản phẩm chưa có tồn kho (AllowSellWhenOutOfStock=false)
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ${PRODUCT_CODE_NO_STOCK_DENIED}, Số lượng=2, Giá=100,000đ, Kho=${MAIN_WAREHOUSE_ID}
    ...    - Logic xử lý: InvoiceWarehouseService.CreateInvoiceWithWarehouse()
    ...    - Kỳ vọng:
    ...    - Status code: 400
    ...    - Thông báo lỗi: "Sản phẩm không đủ tồn kho"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm WHSI00002 Với Serial KHO6 Tại Kho Kho 2    
    And Xem Thông Tin Tổng Tồn Kho Của Sản Phẩm ${product_id}
    And Xem Thông Tin Tồn Kho Của Sản Phẩm ${product_id} Tại Kho Kho 2 
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Chi Tiết Hóa Đơn Có Thông Tin Kho Bán Hàng
    And Tổng tồn kho sản phẩm ${product_id} đã giảm 1 đơn vị
    And Tồn kho sản phẩm ${product_id} đã giảm 1 đơn vị Tại Kho Kho 2
    And Serial KHO6 chuyển sang trạng thái đã bán

RT-IWH-008 Tạo hóa đơn gian hàng với hàng lodate 
    [Tags]    warehouse    smoke      dakho
    [Documentation]    Kiểm tra tạo hóa đơn gian hàng với hàng lodate 
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ${PRODUCT_CODE_1}, Số lượng=1, Giá=100,000đ, Kho=${NONEXISTENT_WAREHOUSE_ID}
    ...    - Logic xử lý: InvoiceWarehouseService.CreateInvoiceWithWarehouse()
    ...    - Kỳ vọng:
    ...    - Status code: 400
    ...    - Thông báo lỗi: "Kho không tồn tại"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Theo Lô WHLD0002 Với Lo1 Số Lượng 2.5 Tại Kho Bán Hàng
    And Xem Thông Tin Tổng Tồn Kho Của Sản Phẩm ${product_id} 
    And Xem Thông Tin Tồn Kho Của Sản Phẩm ${product_id} Tại Kho Bán Hàng 
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Chi Tiết Hóa Đơn Có Thông Tin Kho Bán Hàng
    And Số lượng lô ${product_batch_id} đã giảm 2.5 đơn vị
    And Tổng tồn kho sản phẩm ${product_id} đã giảm 2.5 đơn vị
    And Tồn kho sản phẩm ${product_id} đã giảm 2.5 đơn vị Tại Kho Bán Hàng

RT-IWH-008 Tạo hóa đơn gian hàng với hàng lodate Kho phụ
    [Tags]    warehouse    smoke   dakho 
    [Documentation]    Kiểm tra tạo hóa đơn gian hàng với hàng lodate 
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ${PRODUCT_CODE_1}, Số lượng=1, Giá=100,000đ, Kho=${NONEXISTENT_WAREHOUSE_ID}
    ...    - Logic xử lý: InvoiceWarehouseService.CreateInvoiceWithWarehouse()
    ...    - Kỳ vọng:
    ...    - Status code: 400
    ...    - Thông báo lỗi: "Kho không tồn tại"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Theo Lô WHLD0003 Với Lo1 Số Lượng 1.55 Tại Kho Kho 2
    And Xem Thông Tin Tổng Tồn Kho Của Sản Phẩm ${product_id} 
    And Xem Thông Tin Tồn Kho Của Sản Phẩm ${product_id} Tại Kho Kho 2 
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Chi Tiết Hóa Đơn Có Thông Tin Kho Bán Hàng
    And Số lượng lô ${product_batch_id} đã giảm 1.55 đơn vị
    And Tổng tồn kho sản phẩm ${product_id} đã giảm 1.55 đơn vị
    And Tồn kho sản phẩm ${product_id} đã giảm 1.55 đơn vị Tại Kho Kho 2

RT-IWH-009 Tạo hóa đơn gian hàng với sản phẩm combo
    [Tags]    warehouse    smoke   dakho 
    [Documentation]    Kiểm tra tạo hóa đơn gian hàng với sản phẩm combo từ nhiều kho
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm combo ${PRODUCT_CODE_COMBO}, Số lượng=1, Giá=250,000đ
    ...    - Thành phần 1: ${COMBO_MATERIAL_1_CODE}, Kho=${MAIN_WAREHOUSE_ID}
    ...    - Thành phần 2: ${COMBO_MATERIAL_2_CODE}, Kho=${SECONDARY_WAREHOUSE_ID}
    ...    - Logic xử lý: InvoiceWarehouseService.CreateInvoiceWithWarehouse()
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - InvoiceWarehouseDetail được tạo cho từng thành phần với WarehouseId tương ứng
    ...    - Số lượng tồn kho tại các kho giảm tương ứng
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Mã WHCOMBO001 có Số Lượng 2 Kho Bán Hàng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Chi Tiết Hóa Đơn Có Thông Tin Kho Bán Hàng
    And Sản phẩm con trong combo ${product_id} đã giảm tồn kho 2 lần số lượng tại kho Bán Hàng


RT-IWH-0011 Tạo hóa đơn gian hàng với sản phẩm combo kho phụ
    [Tags]    warehouse    smoke    dakho
    [Documentation]    Kiểm tra tạo hóa đơn gian hàng với sản phẩm combo từ nhiều kho
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm combo ${PRODUCT_CODE_COMBO}, Số lượng=1, Giá=250,000đ
    ...    - Thành phần 1: ${COMBO_MATERIAL_1_CODE}, Kho=${MAIN_WAREHOUSE_ID}
    ...    - Thành phần 2: ${COMBO_MATERIAL_2_CODE}, Kho=${SECONDARY_WAREHOUSE_ID}
    ...    - Logic xử lý: InvoiceWarehouseService.CreateInvoiceWithWarehouse()
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - InvoiceWarehouseDetail được tạo cho từng thành phần với WarehouseId tương ứng
    ...    - Số lượng tồn kho tại các kho giảm tương ứng
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Mã WHCOM0002 có Số Lượng 1 Kho Kho 1
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Chi Tiết Hóa Đơn Có Thông Tin Kho Kho 1
    And Sản phẩm con trong combo ${product_id} đã giảm tồn kho 1 lần số lượng tại kho Kho 1

RT-IWH-010 Tạo hóa đơn gian hàng với sản phẩm theo nhiều dòng
    [Tags]    warehouse    smoke    dakho
    [Documentation]    Kiểm tra tạo hóa đơn gian hàng với sản phẩm theo lô từ nhiều kho
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ${PRODUCT_BATCH_CODE}, Lô=${BATCH_NAME_1}, Số lượng=2, Giá=100,000đ, Kho=${MAIN_WAREHOUSE_ID}
    ...    - Sản phẩm ${PRODUCT_BATCH_CODE}, Lô=${BATCH_NAME_2}, Số lượng=3, Giá=100,000đ, Kho=${SECONDARY_WAREHOUSE_ID}
    ...    - Logic xử lý: InvoiceWarehouseService.CreateInvoiceWithWarehouse()
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - InvoiceWarehouseDetail được tạo với WarehouseId tương ứng cho từng lô
    ...    - Số lượng tồn kho của từng lô tại các kho giảm tương ứng
    Given Chuẩn Bị Dữ Liêu Hóa Đơn Với Sản Phẩm WHND0001 Có 10 Dòng Số Lượng Mỗi Dòng 3 Tại Kho Bán Hàng
    And Xem Thông Tin Tổng Tồn Kho Của Sản Phẩm ${product_id}
    And Xem Thông Tin Tồn Kho Của Sản Phẩm ${product_id} Tại Kho Bán Hàng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Chi Tiết Hóa Đơn Có Thông Tin Kho Bán Hàng
    And Tổng tồn kho sản phẩm ${product_id} đã giảm ${TOTAL_QUANTITY} đơn vị
    And Tồn kho sản phẩm ${product_id} đã giảm ${TOTAL_QUANTITY} đơn vị Tại Kho Bán Hàng

RT-IWH-011 Tạo hóa đơn gian hàng với sản phẩm theo nhiều dòng kho phụ
    [Tags]    warehouse    smoke   dakho
    [Documentation]    Kiểm tra tạo hóa đơn gian hàng với sản phẩm theo lô từ nhiều kho
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ${PRODUCT_BATCH_CODE}, Lô=${BATCH_NAME_1}, Số lượng=2, Giá=100,000đ, Kho=${MAIN_WAREHOUSE_ID}
    ...    - Sản phẩm ${PRODUCT_BATCH_CODE}, Lô=${BATCH_NAME_2}, Số lượng=3, Giá=100,000đ, Kho=${SECONDARY_WAREHOUSE_ID}
    ...    - Logic xử lý: InvoiceWarehouseService.CreateInvoiceWithWarehouse()
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - InvoiceWarehouseDetail được tạo với WarehouseId tương ứng cho từng lô
    ...    - Số lượng tồn kho của từng lô tại các kho giảm tương ứng
    Given Chuẩn Bị Dữ Liêu Hóa Đơn Với Sản Phẩm WHND0002 Có 10 Dòng Số Lượng Mỗi Dòng 3 Tại Kho Kho 1
    And Xem Thông Tin Tổng Tồn Kho Của Sản Phẩm ${product_id}
    And Xem Thông Tin Tồn Kho Của Sản Phẩm ${product_id} Tại Kho Kho 1
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Chi Tiết Hóa Đơn Có Thông Tin Kho Kho 1
    And Tổng tồn kho sản phẩm ${product_id} đã giảm ${TOTAL_QUANTITY} đơn vị
    And Tồn kho sản phẩm ${product_id} đã giảm ${TOTAL_QUANTITY} đơn vị Tại Kho Kho 1

RT-IWH-012 Tạo hóa đơn với kho hàng đã bị xóa
    [Tags]    warehouse    negative    AIGenerated    dakho
    [Documentation]    Kiểm tra tạo hóa đơn với kho hàng đã bị xóa (IsActive = false)
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn với kho hàng đã bị xóa
    ...    - Logic xử lý: WarehouseService.ValidateStatusOfWarehouse
    ...    - Mã nguồn: Kiểm tra nếu kho hàng không còn hoạt động (IsActive = false)
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "${DELETED_WAREHOUSE_NAME} không hợp lệ"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Kho Hàng Đã Bị Xóa
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 420
    And Thông Báo Lỗi Phải Chứa "${DELETED_WAREHOUSE_NAME} không hợp lệ"

RT-IWH-013 Tạo hóa đơn với kho hàng đã ngừng hoạt động
    [Tags]    warehouse    negative    AIGenerated    dakho
    [Documentation]    Kiểm tra tạo hóa đơn với kho hàng đã ngừng hoạt động (LimitAccess = true)
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn với kho hàng đã ngừng hoạt động
    ...    - Logic xử lý: WarehouseService.ValidateStatusOfWarehouse
    ...    - Mã nguồn: Kiểm tra nếu kho hàng bị hạn chế truy cập (LimitAccess = true)
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "{INACTIVE_WAREHOUSE_NAME} đã ngừng hoạt động"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Kho Hàng Đã Ngừng Hoạt Động
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 420
    And Thông Báo Lỗi Phải Chứa "${INACTIVE_WAREHOUSE_NAME} đã ngừng hoạt động"

RT-IWH-014 Tạo hóa đơn với kho bán hàng mặc định nhưng chi nhánh đã bị xóa
    [Tags]    warehouse    negative    AIGenerated    dakho
    [Documentation]    Kiểm tra tạo hóa đơn với kho bán hàng mặc định nhưng chi nhánh đã bị xóa
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn với kho bán hàng mặc định Type=1 (Chi Nhánh)
    ...    - Chi nhánh đã bị xóa (IsActive = false)
    ...    - Logic xử lý: Hệ thống xác định whId=invoice.BranchId và kiểm tra trạng thái
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "${DELETED_WAREHOUSE_NAME} không hợp lệ"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Kho Bán Hàng Mặc Định Chi Nhánh Đã Bị Xóa
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 420
    And Thông Báo Lỗi Phải Chứa "${DELETED_WAREHOUSE_NAME} không hợp lệ"

RT-IWH-015 Tạo hóa đơn không chỉ định kho hàng và chi nhánh đã bị vô hiệu hóa
    [Tags]    warehouse    negative    AIGenerated    dakho
    [Documentation]    Kiểm tra tạo hóa đơn không chỉ định kho hàng và chi nhánh đã bị vô hiệu hóa
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn không chỉ định kho hàng cụ thể (WareHouse = null)
    ...    - Chi nhánh đã bị vô hiệu hóa (IsActive = false)
    ...    - Logic xử lý: Hệ thống xác định whId=invoice.BranchId và kiểm tra trạng thái
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "${INACTIVE_WAREHOUSE_NAME} đã ngừng hoạt động"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Không Chỉ Định Kho Hàng Chi Nhánh Đã Bị Vô Hiệu Hóa
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 420
    And Thông Báo Lỗi Phải Chứa "${INACTIVE_WAREHOUSE_NAME} đã ngừng hoạt động"

