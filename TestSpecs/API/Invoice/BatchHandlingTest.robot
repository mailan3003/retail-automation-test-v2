*** Settings ***
Documentation     Test cases API cho phần xử lý lô hàng (batch) nâng cao
Resource          ../../../Keywords/Invoice/BatchHandlingKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    BatchHandlingTest

*** Test Cases ***
RT-BH-001 Cập nhật tồn kho theo lô với quy tắc FIFO
    [Documentation]    Kiểm tra cập nhật tồn kho theo lô với quy tắc FIFO (First In First Out)
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${product_batch}, Số lượng=5, Giá=100,000đ, BatchProcessingType=FIFO
    ...    - Logic xử lý: BatchExpireService.UpdateBatchQuantity() với quy tắc FIFO
    ...    - Code: Lô có ngày nhập sớm nhất được xuất trước
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Các lô được xuất theo thứ tự thời gian nhập hàng (lô nhập trước xuất trước)
    Given Chuẩn Bị Dữ Liệu Xử Lý Lô Theo FIFO
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Các lô được xuất theo quy tắc FIFO

RT-BH-002 Cập nhật tồn kho theo lô với quy tắc FEFO
    [Documentation]    Kiểm tra cập nhật tồn kho theo lô với quy tắc FEFO (First Expired First Out)
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${product_batch}, Số lượng=6, Giá=100,000đ, BatchProcessingType=FEFO
    ...    - Logic xử lý: BatchExpireService.UpdateBatchQuantity() với quy tắc FEFO
    ...    - Code: Lô có ngày hết hạn sớm nhất được xuất trước
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Các lô được xuất theo thứ tự ngày hết hạn (lô gần hết hạn xuất trước)
    Given Chuẩn Bị Dữ Liệu Xử Lý Lô Theo FEFO
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Các lô được xuất theo quy tắc FEFO

RT-BH-003 Cập nhật tồn kho theo lô với quy tắc LIFO
    [Documentation]    Kiểm tra cập nhật tồn kho theo lô với quy tắc LIFO (Last In First Out)
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${product_batch}, Số lượng=4, Giá=100,000đ, BatchProcessingType=LIFO
    ...    - Logic xử lý: BatchExpireService.UpdateBatchQuantity() với quy tắc LIFO
    ...    - Code: Lô có ngày nhập gần đây nhất được xuất trước
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Các lô được xuất theo thứ tự thời gian nhập hàng ngược (lô nhập sau xuất trước)
    Given Chuẩn Bị Dữ Liệu Xử Lý Lô Theo LIFO
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Các lô được xuất theo quy tắc LIFO

RT-BH-004 Cập nhật tồn kho theo lô với ưu tiên lô có chi phí thấp
    [Documentation]    Kiểm tra cập nhật tồn kho theo lô với ưu tiên lô có chi phí thấp
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${product_batch}, Số lượng=3, Giá=100,000đ, BatchProcessingType=LowestCost
    ...    - Logic xử lý: BatchExpireService.UpdateBatchQuantity() với ưu tiên lô chi phí thấp
    ...    - Code: Lô có giá vốn thấp nhất được xuất trước
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Các lô được xuất theo thứ tự giá vốn tăng dần (lô giá thấp xuất trước)
    Given Chuẩn Bị Dữ Liệu Xử Lý Lô Theo Chi Phí Thấp Nhất
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Các lô được xuất theo thứ tự giá vốn tăng dần

RT-BH-005 Cập nhật tồn kho với lô tự chọn thủ công
    [Documentation]    Kiểm tra cập nhật tồn kho với lô tự chọn thủ công
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${product_batch}, Số lượng=2, Giá=100,000đ, BatchId=${batch_specific}
    ...    - Logic xử lý: BatchExpireService.UpdateBatchQuantity() với lô chỉ định cụ thể
    ...    - Code: Chỉ cập nhật lô được chỉ định
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Chỉ lô được chỉ định giảm số lượng, các lô khác không thay đổi
    Given Chuẩn Bị Dữ Liệu Xử Lý Lô Thủ Công
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Chỉ lô được chỉ định giảm số lượng

RT-BH-006 Cập nhật số lượng lô khi hóa đơn bị hủy
    [Documentation]    Kiểm tra cập nhật số lượng lô khi hóa đơn bị hủy
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${product_batch}, Số lượng=3, Giá=100,000đ, BatchId=${batch_1}
    ...    - Logic xử lý: 
    ...      1. Tạo hóa đơn với batch.Quantity -= invoiceDetail.Quantity
    ...      2. Hủy hóa đơn với batch.Quantity += invoiceDetail.Quantity
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng lô ban đầu giảm 3 đơn vị, sau đó tăng lại 3 đơn vị khi hủy
    ...    - Lịch sử xuất nhập lô được ghi nhận đúng
    Given Chuẩn Bị Dữ Liệu Xử Lý Lô Cần Hủy
    And Lưu Số Lượng Ban Đầu Của Lô ${batch_1}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Số lượng lô ${batch_1} đã giảm 3 đơn vị
    When Gửi Yêu Cầu Hủy Hóa Đơn
    Then Response Status Code Should Be 200
    And Số lượng lô ${batch_1} đã tăng lại 3 đơn vị

RT-BH-007 Cập nhật lô khi có ngày hết hạn
    [Documentation]    Kiểm tra xử lý lô khi có ngày hết hạn
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${product_batch}, Số lượng=2, Giá=100,000đ, BatchId=new, ExpireDate=2024-06-30
    ...    - Logic xử lý: BatchExpireService.CreateBatchExpire() và UpdateBatchQuantity()
    ...    - Code: Tạo lô mới với ngày hết hạn và giảm số lượng
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Lô mới được tạo với ngày hết hạn đúng
    ...    - Số lượng lô mới giảm 2 đơn vị
    Given Chuẩn Bị Dữ Liệu Xử Lý Lô Có Ngày Hết Hạn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Lô mới được tạo với ngày hết hạn đúng
    And Số lượng lô mới đã giảm 2 đơn vị 