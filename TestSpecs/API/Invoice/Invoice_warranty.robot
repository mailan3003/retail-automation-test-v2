*** Settings ***
Documentation     Test cases API cho hóa đơn hàng hóa có bảo hành bảo trì
Suite Setup       Init Test Environment   ${ENV}   MHBH
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Invoice/WarrantyKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Library           ../../../Resources/DatabaseLibrary.py
Resource          ../../../Keywords/Invoice/InvoiceCommonKeywords.robot
Test Teardown     Delete Invoice From API



*** Test Cases ***
## Phần tạo hóa đơn chứa hàng BHBT và sinh ra phiếu bảo hành
RT-IWR-001 Tạo hóa đơn thành công với sản phẩm chỉnh sửa bảo hành 
    [Documentation]    Kiểm tra tạo hóa đơn thành công với sản phẩm chỉnh sửa bảo hành 
    ...    - Dữ liệu đầu vào:
    ...    - Cấu hình bảo hành: HasWarranty=${TRUE}, WarrantyPeriod=12 (tháng)
    ...    - Logic xử lý: WarrantyService.CreateWarrantyFromInvoice()
    ...    - Code: foreach(product in invoice.Details.Where(x => x.HasWarranty)) { CreateWarranty(); }
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công trong CSDL
    ...    - Thông tin bảo hành được lưu trong bảng InvoiceWarranties với WarrantyPeriod=12
    ...    - Tồn kho sản phẩm BHBT được cập nhật giảm 1 đơn vị
    [Tags]    warranty    apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Có Thời Hạn Bảo Hành Là 12 Tháng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Hóa Đơn Có Sản Phẩm ${WARRANTY_PRODUCT_CODE} BHBT Trong CSDL
    And Xác Thực Thông Tin Bảo Hành Sản Phẩm ${WARRANTY_PRODUCT_CODE} Được Lưu Với Thời Hạn 12 Tháng

RT-IWR-002 Tạo hóa đơn thành công có sản phẩm BHBT nhập serial tự động sinh phiếu bảo hành
    [Documentation]    Kiểm tra tạo hóa đơn thành công với sản phẩm BHBT có serial tự động sinh phiếu bảo hành
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm BHBT có serial: ID=${WARRANTY_PRODUCT_SERIAL_CODE}, Số lượng=1, Giá=10,000,000đ
    ...    - SerialNumbers=BH001, IsLotSerialControl=${TRUE}
    ...    - Cấu hình bảo hành: HasWarranty=${TRUE}, WarrantyPeriod=24 (tháng), AutoCreateWarrantyTicket=${TRUE}
    ...    - Logic xử lý: 
    ...    1. WarrantyService.CreateWarrantyFromInvoice() - tạo thông tin bảo hành
    ...    2. WarrantyTicketService.CreateWarrantyTicketFromInvoice() - tạo phiếu bảo hành
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công trong CSDL
    ...    - Thông tin bảo hành được lưu trong bảng InvoiceWarranties với WarrantyPeriod=24
    ...    - Phiếu bảo hành được tạo tự động trong bảng WarrantyTickets
    ...    - Phiếu bảo hành có thông tin serial BH001
    ...    - Tồn kho sản phẩm BHBT giảm 1 đơn vị, serial BH001 chuyển sang trạng thái đã bán
    [Tags]    warranty    apiinvoice    regression  
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Serial ${WARRANTY_PRODUCT_SERIAL_CODE} Có Imei ${WARRANTY_SERIAL_NUMBER} Bảo Hành 35 Ngày
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Hóa Đơn Có Sản Phẩm ${WARRANTY_PRODUCT_SERIAL_CODE} BHBT Trong CSDL
    And Xác Thực Thông Tin Bảo Hành Sản Phẩm ${WARRANTY_PRODUCT_SERIAL_CODE} Được Lưu Với Thời Hạn 35 Ngày
    And Xác Thực Thông Tin ${WARRANTY_PRODUCT_SERIAL_CODE} Serial ${WARRANTY_SERIAL_NUMBER} Trong Phiếu Bảo Hành

RT-IWR-003 Tạo hóa đơn thành công với sản phẩm BHBT có thời hạn bảo hành khác nhau
    [Documentation]    Kiểm tra tạo hóa đơn thành công với nhiều sản phẩm BHBT có thời hạn bảo hành khác nhau
    ...    - Dữ liệu đầu vào:
    ...    - Logic xử lý: WarrantyService.CreateWarrantyFromInvoice()
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công trong CSDL
    ...    - Thông tin bảo hành được lưu cho cả 2 sản phẩm với thời hạn tương ứng
    ...    - Tồn kho cả 2 sản phẩm BHBT được cập nhật giảm mỗi loại 1 đơn vị
    [Tags]    warranty    apiinvoice    regression  
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${WARRANTY_PRODUCT_CODE_2} Nhiều Thời Hạn BH @{warranty_name} @{number_time} @{number_time_type} Và BT 1 Năm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Hóa Đơn Có Sản Phẩm ${WARRANTY_PRODUCT_CODE_2} BHBT Trong CSDL
    And Xác Thực Thông Sản Phẩm ${WARRANTY_PRODUCT_CODE_2} Chứa Nhiều Thời Hạn BHBT @{warranty_name} @{number_time} @{number_time_type} Được Lưu Trong CSDL
    And Xác Thực Thông Tin Bảo Trì Sản Phẩm ${WARRANTY_PRODUCT_CODE_2} Được Lưu Với Thời Hạn 1 Năm


RT-IWR-004 Tạo hóa đơn với nhiều sản phẩm có thông tin bảo hành
    [Documentation]    Kiểm tra tạo hóa đơn với nhiều sản phẩm có thông tin bảo hành
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm có thông tin bảo hành: ID=${WARRANTY_PRODUCT_ID}, Số lượng=1, Giá=5,000,000đ
    ...    - Cấu hình bảo hành: HasWarranty=${TRUE}, WarrantyPeriod=12 (giá trị mặc định)
    ...    - Tùy chỉnh: CustomWarrantyPeriod=18 (tháng) - tùy chỉnh thời gian bảo hành khác với mặc định
    ...    - Logic xử lý: WarrantyService.CreateWarrantyFromInvoice()
    ...    - Code: warranty.Period = detail.CustomWarrantyPeriod ?? product.WarrantyPeriod;
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công trong CSDL
    ...    - Thông tin bảo hành được lưu với thời hạn tùy chỉnh 18 tháng (không phải 12 tháng mặc định)
    ...    - Tồn kho sản phẩm BHBT được cập nhật giảm 1 đơn vị
    [Tags]    warranty    apiinvoice    regression  
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${WARRANTY_PRODUCT_CODE} Thời hạn Bảo Hành 30 Ngày Và ${WARRANTY_PRODUCT_CODE_2} Thời hạn Bảo Hành 18 Tháng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Hóa Đơn Có Sản Phẩm ${WARRANTY_PRODUCT_CODE} BHBT Trong CSDL
    And Xác Thực Hóa Đơn Có Sản Phẩm ${WARRANTY_PRODUCT_CODE_2} BHBT Trong CSDL
    And Xác Thực Thông Tin Bảo Hành Sản Phẩm ${WARRANTY_PRODUCT_CODE} Được Lưu Với Thời Hạn 30 Ngày
    And Xác Thực Thông Tin Bảo Hành Sản Phẩm ${WARRANTY_PRODUCT_CODE_2} Được Lưu Với Thời Hạn 18 Tháng


RT-IWR-005 Tạo hóa đơn với sản phẩm lô date có bảo hành
    [Documentation]    Kiểm tra tạo hóa đơn với sản phẩm lô date có bảo hành
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm lô date: ID=${LODATE_WARRANTY_PRODUCT_ID}, Số lượng=1, Giá=3,000,000đ
    ...    - Thông tin lô: BatchId=${BATCH_ID}, BatchName="BH-LOT-001", ExpiryDate=ngày hết hạn
    ...    - Cấu hình bảo hành: HasWarranty=${TRUE}, WarrantyPeriod=12 (tháng)
    ...    - Logic xử lý: WarrantyService.CreateWarrantyFromInvoice() + BatchService.UpdateBatchQuantity()
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công trong CSDL
    ...    - Thông tin bảo hành được lưu với thời hạn 12 tháng
    ...    - Tồn kho lô date được cập nhật giảm 1 đơn vị
    ...    - Thông tin lô được ghi nhận trong chi tiết hóa đơn
    [Tags]    warranty    apiinvoice    regression  
    Given Chuẩn Bị Dữ liệu Hóa Đơn Với Hàng Lodate ${WARRANTY_PRODUCT_BATCH_CODE} Có Lô ${WARRANTY_PRODUCT_BATCH_NAME} Thời hạn Bảo Trì 12 Tháng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Hóa Đơn Có Sản Phẩm ${WARRANTY_PRODUCT_BATCH_CODE} BHBT Trong CSDL
    And Xác Thực Thông Tin Bảo Trì Sản Phẩm ${WARRANTY_PRODUCT_BATCH_CODE} Được Lưu Với Thời Hạn 12 Tháng

RT-IWR-006 Tạo hóa đơn với sản phẩm nhiều dòng có bảo hành
    [Documentation]    Kiểm tra tạo hóa đơn với sản phẩm nhiều dòng có bảo hành
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm nhiều dòng: ID=${WARRANTY_PRODUCT_CODE}, Số lượng=1, Giá=10,000,000đ

    ...    - Logic xử lý: WarrantyService.CreateWarrantyFromInvoice() + ProductLineService.ProcessProductLines()
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công trong CSDL
    ...    - Thông tin bảo hành được lưu cho từng dòng sản phẩm với thời hạn tương ứng
    ...    - Tồn kho sản phẩm nhiều dòng được cập nhật giảm 1 đơn vị
    ...    - Thông tin các dòng được ghi nhận trong chi tiết hóa đơn
    [Tags]    warranty    apiinvoice    regression  
    Given Chuẩn Bị Dữ Liệu Hóa Đơn 3 Dòng Với Sản Phẩm ${WARRANTY_PRODUCT_CODE} Thời hạn Bảo Hành 2 Năm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Hóa Đơn Có 3 Sản Phẩm ${WARRANTY_PRODUCT_CODE} BHBT Trong CSDL
    And Xác Thực Thông Tin Bảo Hành Có 3 Dòng Sản Phẩm ${WARRANTY_PRODUCT_CODE} Được Lưu Với Thời Hạn 2 Năm
