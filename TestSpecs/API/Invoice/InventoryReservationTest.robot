*** Settings ***
Documentation     Test cases API cho phần quản lý đặt giữ (reservation) tồn kho khi tạo hóa đơn
Resource          ../../../Keywords/Invoice/InventoryReservationKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    InventoryReservationTest

*** Test Cases ***
RT-INR-001 Cập nhật số lượng đặt giữ khi tạo hóa đơn
    [Documentation]    Kiểm tra cập nhật số lượng đặt giữ khi tạo hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${PRODUCT_1}, Số lượng=5, Giá=100,000đ, ReservationMode=1
    ...    - Logic xử lý: ProductBranchService.UpdateReservedAsync()
    ...    - Code: productBranch.Reserved -= invoiceDetail.Quantity
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng đặt giữ giảm 5 đơn vị
    ...    - Tồn kho vẫn giữ nguyên (chưa giảm)
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Chế Độ Đặt Giữ
    And Xem Thông Tin Tồn Kho Và Đặt Giữ Của Sản Phẩm ${PRODUCT_1}
    When Gửi Yêu Cầu Tạo Đặt Giữ
    Then Response Status Code Should Be 200
    And Số lượng đặt giữ sản phẩm ${PRODUCT_1} đã giảm 5 đơn vị
    And Tồn kho sản phẩm ${PRODUCT_1} không thay đổi

RT-INR-002 Cập nhật tồn kho và đặt giữ khi xác nhận hóa đơn đặt trước
    [Documentation]    Kiểm tra cập nhật tồn kho và đặt giữ khi xác nhận hóa đơn đặt trước
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${PRODUCT_1}, Số lượng=3, Giá=100,000đ, ReservationMode=1, Status=3 (Đặt trước)
    ...    - Logic xử lý: 
    ...      1. Tạo hóa đơn đặt trước với productBranch.Reserved += invoiceDetail.Quantity
    ...      2. Xác nhận hóa đơn với productBranch.Reserved -= invoiceDetail.Quantity và productBranch.OnHand -= invoiceDetail.Quantity
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng đặt giữ ban đầu tăng 3, sau đó giảm 3 đơn vị khi xác nhận
    ...    - Tồn kho giảm 3 đơn vị khi xác nhận
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Đặt Trước
    And Xem Thông Tin Tồn Kho Và Đặt Giữ Của Sản Phẩm ${PRODUCT_1}
    When Gửi Yêu Cầu Tạo Đặt Trước
    Then Response Status Code Should Be 200
    And Số lượng đặt giữ sản phẩm ${PRODUCT_1} đã tăng 3 đơn vị
    And Tồn kho sản phẩm ${PRODUCT_1} không thay đổi
    When Gửi Yêu Cầu Xác Nhận Hóa Đơn Đặt Trước
    Then Response Status Code Should Be 200
    And Số lượng đặt giữ sản phẩm ${PRODUCT_1} đã giảm 3 đơn vị
    And Tồn kho sản phẩm ${PRODUCT_1} đã giảm 3 đơn vị

RT-INR-003 Kiểm tra tồn kho thực tế (ActualReserved) khi đặt giữ
    [Documentation]    Kiểm tra tồn kho thực tế (ActualReserved) khi đặt giữ
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${PRODUCT_1}, Số lượng=4, Giá=100,000đ, ReservationMode=1
    ...    - Logic xử lý: ProductBranchService.UpdateReservedAsync()
    ...    - Code: productBranch.Reserved -= invoiceDetail.Quantity, productBranch.ActualReserved = productBranch.OnHand - productBranch.Reserved
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng đặt giữ giảm 4 đơn vị
    ...    - ActualReserved tăng 4 đơn vị (số lượng tồn kho thực tế có thể bán)
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Chế Độ Đặt Giữ Và Kiểm Tra Tồn Thực Tế
    And Xem Thông Tin Tồn Kho Thực Tế Của Sản Phẩm ${PRODUCT_1}
    When Gửi Yêu Cầu Tạo Đặt Giữ
    Then Response Status Code Should Be 200
    And Tồn kho thực tế (ActualReserved) của sản phẩm ${PRODUCT_1} đã tăng 4 đơn vị

RT-INR-004 Cập nhật OnOrder và Reserved khi đặt hàng
    [Documentation]    Kiểm tra cập nhật OnOrder và Reserved khi đặt hàng
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${PRODUCT_1}, Số lượng=6, Giá=100,000đ, OrderId=${ORDER_ID}
    ...    - Logic xử lý: 
    ...      1. ProductBranchService.UpdateReservedAsync()
    ...      2. OrderDetailService.UpdateDeliveredQuantity()
    ...    - Code: productBranch.OnOrder -= invoiceDetail.Quantity, productBranch.Reserved += invoiceDetail.Quantity
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng đặt hàng (OnOrder) giảm 6 đơn vị
    ...    - Số lượng đặt giữ (Reserved) tăng 6 đơn vị
    Given Chuẩn Bị Dữ Liệu Đặt Hàng Với Cập Nhật OnOrder
    And Xem Thông Tin OnOrder Và Reserved Của Sản Phẩm ${PRODUCT_1}
    When Gửi Yêu Cầu Đặt Hàng
    Then Response Status Code Should Be 200
    And Số lượng đặt hàng (OnOrder) của sản phẩm ${PRODUCT_1} đã giảm 6 đơn vị
    And Số lượng đặt giữ (Reserved) của sản phẩm ${PRODUCT_1} đã tăng 6 đơn vị

RT-INR-005 Cập nhật tồn kho và đặt giữ khi hủy hóa đơn
    [Documentation]    Kiểm tra cập nhật tồn kho và đặt giữ khi hủy hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm ID=${PRODUCT_1}, Số lượng=2, Giá=100,000đ
    ...    - Logic xử lý: 
    ...      1. Tạo hóa đơn với productBranch.OnHand -= invoiceDetail.Quantity
    ...      2. Hủy hóa đơn với productBranch.OnHand += invoiceDetail.Quantity
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tồn kho ban đầu giảm 2 đơn vị, sau đó tăng lại 2 đơn vị khi hủy
    ...    - Lịch sử tồn kho được ghi nhận khi hủy với giá trị +2
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cần Hủy
    And Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm ${PRODUCT_1}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Tồn kho sản phẩm ${PRODUCT_1} đã giảm 2 đơn vị
    When Gửi Yêu Cầu Hủy Hóa Đơn
    Then Response Status Code Should Be 200
    And Tồn kho sản phẩm ${PRODUCT_1} đã tăng lại 2 đơn vị
    And Lịch sử tồn kho hủy hóa đơn được ghi nhận với giá trị +2 