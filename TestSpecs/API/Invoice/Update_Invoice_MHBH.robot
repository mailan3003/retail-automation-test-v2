*** Settings ***
Documentation     Test cases API cho phần cập nhật thanh toán hóa đơn
Resource          ../../../Keywords/Invoice/DeliveryUpdateKeywords.robot
Resource          ../../../Keywords/Invoice/ReceiptCreationKeywords.robot
Resource          ../../../Keywords/Invoice/DiscountProcessingKeywords.robot
Resource          ../../../Keywords/Invoice/InventoryUpdateExtendedKeywords.robot
Resource          ../../../Keywords/Invoice/PaymentUpdateKeywords.robot
Resource          ../../../Keywords/Utilities/Utilities.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource    ../../../Keywords/Invoice/InventoryUpdateKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py
*** Variables ***
${product_id_update}     1000014348
*** Test Cases ***
RT-PU-001 Cập nhật thanh toán tiền mặt cho hóa đơn
    [Documentation]    Kiểm tra cập nhật thanh toán bằng tiền mặt cho hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID}
    ...    - Thanh toán bổ sung bằng tiền mặt: 50,000đ
    ...    - Logic cập nhật:
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Công nợ của hóa đơn được cập nhật: Giảm đi 50,000đ
    ...    - Lịch sử thanh toán được lưu vào DB
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Thanh toán mới được thêm vào hóa đơn
    ...    - Công nợ hóa đơn giảm đúng số tiền
    ...    - Mô tả thanh toán lưu đúng nội dung
    [Tags]    apiinvoice    update_invoice    update_payment    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Hóa Đơn Thanh Toán Phương Thức ${PAYMENT_CASH} Với Số Tiền 10000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Thanh toán ${INVOICE_ID} với phương thức ${PAYMENT_CASH} số tiền 10000 được lưu trong CSDL
    And Xác Thực Trạng Thái Hóa Đơn ${INVOICE_CODE} Là Trạng Thái Hủy
   And Xác Thực Trạng Thái Hóa Đơn ${INVOICE_CODE}.01 Là Trạng Thái Hoàn Thành

RT-PU-002 Cập nhật thanh toán bằng thẻ cho hóa đơn
    [Documentation]    Kiểm tra cập nhật thanh toán bằng thẻ cho hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID}
    ...    - Thanh toán bổ sung bằng thẻ: 50,000đ
    ...    - Tài khoản thẻ: ${DEFAULT_BANK_ACCOUNT_ID}
    ...    - Logic cập nhật:
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Công nợ của hóa đơn được cập nhật: Giảm đi 50,000đ
    ...    - Thông tin tài khoản thẻ được lưu
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Thanh toán mới được thêm vào hóa đơn
    ...    - Thông tin tài khoản thẻ được lưu chính xác
        [Tags]    apiinvoice    update_invoice   update_payment    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Hóa Đơn Thanh Toán Phương Thức ${PAYMENT_CARD} Với Số Tiền 5300
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Thanh toán ${INVOICE_ID} với phương thức ${PAYMENT_CARD} số tiền 5300 được lưu trong CSDL
    And Xác Thực Trạng Thái Hóa Đơn ${INVOICE_CODE} Là Trạng Thái Hủy
    And Xác Thực Trạng Thái Hóa Đơn ${INVOICE_CODE}.01 Là Trạng Thái Hoàn Thành

RT-PU-003 Cập nhật hóa đơn thêm khách hàng và thanh toán
    [Documentation]    Kiểm tra cập nhật hóa đơn thêm khách hàng và thanh toán
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID}
    ...    - Thanh toán bổ sung bằng chuyển khoản: 50,000đ
    ...    - Tài khoản: ${DEFAULT_BANK_ACCOUNT_ID}
    ...    - Logic cập nhật:
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Công nợ của hóa đơn được cập nhật: Giảm đi 50,000đ
    ...    - Thông tin tài khoản được lưu
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Thanh toán mới được thêm vào hóa đơn
    ...    - Thông tin tài khoản được lưu chính xác
    [Tags]    apiinvoice    update_invoice    update_payment    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Hóa Đơn Thanh Toán Phương Thức ${PAYMENT_TRANSFER} Với Số Tiền 5300 Với Khách Hàng ${CUSTOMER_ID}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Thanh toán ${INVOICE_ID} với phương thức ${PAYMENT_TRANSFER} số tiền 5300 được lưu trong CSDL
    And Xác Thực Trạng Thái Hóa Đơn ${INVOICE_CODE} Là Trạng Thái Hủy
    And Xác Thực Trạng Thái Hóa Đơn ${INVOICE_CODE}.01 Là Trạng Thái Hoàn Thành
    And Thông tin khách hàng trong hóa đơn là ${CUSTOMER_ID}

RT-PU-004 Cập nhật thêm hàng hóa cho hóa đơn
    [Documentation]    Kiểm tra cập nhật thêm hàng hóa cho hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID}
    ...    - Thanh toán tiền mặt: 20,000đ
    ...    - Thanh toán thẻ: 30,000đ
    ...    - Logic cập nhật:
    ...    - Cả hai thanh toán được thêm vào hóa đơn
    ...    - Công nợ của hóa đơn được cập nhật: Giảm đi 50,000đ
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Cả hai thanh toán được thêm vào hóa đơn
    ...    - Tổng tiền thanh toán bổ sung là 50,000đ
    [Tags]    apiinvoice    update_invoice    update_payment    regression     
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật
    And Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm ${product_id_update} 
    And Chuẩn Bị Dữ Liệu Cập Nhật Hóa Đơn Thay Đổi ${product_id_update} Với Số Lượng 5.44
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Xác Thực Trạng Thái Hóa Đơn ${INVOICE_CODE} Là Trạng Thái Hủy
    And Xác Thực Trạng Thái Hóa Đơn ${INVOICE_CODE}.01 Là Trạng Thái Hoàn Thành
    And Tồn kho sản phẩm ${product_id_update} đã giảm 5.44 đơn vị
    And Lịch sử tồn kho được tạo với số lượng 5.44 đơn vị cho sản phẩm ${product_id_update}

RT-PU-005 Cập nhật số lượng hàng hóa trong đơn hàng
    [Documentation]    Kiểm tra cập nhật số lượng hàng hóa trong đơn hàng
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID}
    ...    - Số lượng hàng hóa: 200,000đ (lớn hơn công nợ)
    ...    - Logic cập nhật:
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Kỳ vọng: 200
    ...    - Số lượng hàng hóa trong đơn là 200000
    [Tags]    apiinvoice    update_invoice    update_payment    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Hóa Đơn Thay Đổi Số Lượng 200000 Hàng hóa trong đơn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Số lượng hàng hóa trong đơn là 200000
    And Xác Thực Trạng Thái Hóa Đơn ${INVOICE_CODE} Là Trạng Thái Hủy
    And Xác Thực Trạng Thái Hóa Đơn ${INVOICE_CODE}.01 Là Trạng Thái Hoàn Thành
    And Tổng tiền hóa đơn phải bằng ${TOTAL_PRICE} 
    [Teardown]    Tear down Delete Hóa Đơn

RT-PU-006 Cập Nhập Hóa Đơn Không Tồn Tại
    [Documentation]    Kiểm tra cập nhật thanh toán cho hóa đơn không tồn tại
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${INVALID_INVOICE_ID} (không tồn tại)
    ...    - Thanh toán tiền mặt: 50,000đ
    ...    - Logic cập nhật:
    ...    - Hệ thống phát hiện hóa đơn không tồn tại
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 404
    ...    - Thông báo lỗi: "Không tìm thấy hóa đơn"
    [Tags]    apiinvoice    update_invoice1    update_payment    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhập Hóa Đơn Không Tồn Tại
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 500

RT-PU-007 Cập nhật với hóa đơn đã hủy 
    [Documentation]    Cập nhật với hóa đơn đã hủy        
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID}
    ...    - Thanh toán tiền mặt: -10,000đ
    [Tags]    apiinvoice    update_invoice    update_payment    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhập Hóa Đơn Đã Hủy
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 420
    And Response Should Have Error "Không sửa được hóa đơn ở trạng thái Đã hủy

RT-PU-008 Cập nhật thanh toán tổng tiền hàng trong đơn 
    [Documentation]    Kiểm tra cập nhật thanh toán tổng tiền hàng trong đơn là 0
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID}
    ...    - Thanh toán tiền mặt: 0đ
    ...    - Logic cập nhật:
    ...    - Hệ thống từ chối thêm thanh toán với số tiền bằng 0
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 400
    ...    - Thông báo lỗi: "Số tiền thanh toán phải khác 0"
    [Tags]    apiinvoice    update_invoice    update_payment    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Hóa Đơn Thay Đổi Thành Tiền 5550000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Xác Thực Trạng Thái Hóa Đơn ${INVOICE_CODE} Là Trạng Thái Hủy
    And Xác Thực Trạng Thái Hóa Đơn ${INVOICE_CODE}.01 Là Trạng Thái Hoàn Thành
    And Tổng tiền hóa đơn phải bằng 5550000 

RT-PU-009 Cập nhật thanh toán không có phương thức thanh toán
    [Documentation]    Kiểm tra cập nhật thanh toán không có phương thức thanh toán
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID}
    ...    - Không có phương thức thanh toán nào
    ...    - Logic cập nhật:
    ...    - Hệ thống từ chối yêu cầu do không có phương thức thanh toán
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 400
    ...    - Thông báo lỗi: "Phương thức thanh toán không được để trống"
    Given Chuẩn Bị Dữ Liệu Thanh Toán Tiêu Chuẩn
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 400
    And Response Should Have Error "Phương thức thanh toán không được để trống"

RT-PU-010 Cập nhật thanh toán 3 phương thức khác nhau cho hóa đơn
    [Documentation]    Kiểm tra cập nhật thanh toán với 3 phương thức khác nhau
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID}
    ...    - Thanh toán tiền mặt: 20,000đ
    ...    - Thanh toán thẻ: 20,000đ
    ...    - Thanh toán chuyển khoản: 10,000đ
    ...    - Logic cập nhật:
    ...    - Cả ba thanh toán được thêm vào hóa đơn
    ...    - Công nợ của hóa đơn được cập nhật: Giảm đi 50,000đ
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Cả ba thanh toán được thêm vào hóa đơn
    ...    - Tổng tiền thanh toán bổ sung là 50,000đ
    Given Chuẩn Bị Dữ Liệu Thanh Toán ${EXISTING_INVOICE_ID} với 3 phương thức thanh toán tổng 50000
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 200
    And Hóa đơn ${EXISTING_INVOICE_ID} có tổng 3 phương thức thanh toán
    And Hóa đơn ${EXISTING_INVOICE_ID} có tổng tiền thanh toán là 50000

RT-PU-011 Cập nhật thanh toán cho hóa đơn đã thanh toán đủ
    [Documentation]    Kiểm tra cập nhật thanh toán cho hóa đơn đã thanh toán đủ
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID} (đã thanh toán đủ)
    ...    - Thanh toán tiền mặt: 50,000đ
    ...    - Logic cập nhật:
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Công nợ của hóa đơn trở thành âm
    ...    - Trạng thái hóa đơn vẫn là "Đã thanh toán"
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Công nợ hóa đơn trở thành âm (dư)
    ...    - Trạng thái hóa đơn vẫn là "Đã thanh toán"
    Given Chuẩn Bị Dữ Liệu Thanh Toán Tiền Mặt
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 200
    And Thanh toán ${EXISTING_INVOICE_ID} với phương thức ${PAYMENT_CASH} số tiền ${PAYMENT_UPDATE_AMOUNT} được lưu trong CSDL
    And Hóa đơn ${EXISTING_INVOICE_ID} có trạng thái là ${STATUS_COMPLETED}

RT-PU-012 Cập nhật thanh toán cho hóa đơn chưa thanh toán đủ
    [Documentation]    Kiểm tra cập nhật thanh toán cho hóa đơn chưa thanh toán đủ
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID} (chưa thanh toán đủ)
    ...    - Công nợ hiện tại: 100,000đ
    ...    - Thanh toán tiền mặt: 50,000đ
    ...    - Logic cập nhật:
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Công nợ của hóa đơn giảm còn 50,000đ
    ...    - Trạng thái hóa đơn vẫn là "Chưa thanh toán đủ"
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Công nợ hóa đơn giảm còn 50,000đ
    ...    - Trạng thái hóa đơn vẫn là "Chưa thanh toán đủ"
    Given Chuẩn Bị Dữ Liệu Thanh Toán Tiền Mặt
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 200
    And Thanh toán ${EXISTING_INVOICE_ID} với phương thức ${PAYMENT_CASH} số tiền ${PAYMENT_UPDATE_AMOUNT} được lưu trong CSDL
    And Hóa đơn ${EXISTING_INVOICE_ID} có trạng thái là ${STATUS_PROCESSING}

RT-PU-013 Cập nhật thanh toán đủ cho hóa đơn chưa thanh toán
    [Documentation]    Kiểm tra cập nhật thanh toán đủ cho hóa đơn chưa thanh toán
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID} (chưa thanh toán)
    ...    - Công nợ hiện tại: 100,000đ
    ...    - Thanh toán tiền mặt: 100,000đ
    ...    - Logic cập nhật:
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Công nợ của hóa đơn giảm về 0
    ...    - Trạng thái hóa đơn chuyển sang "Đã thanh toán"
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Công nợ hóa đơn giảm về 0
    ...    - Trạng thái hóa đơn chuyển sang "Đã thanh toán"
    Given Chuẩn Bị Dữ Liệu Thanh Toán ${EXISTING_INVOICE_ID} với phương thức ${PAYMENT_CASH} số tiền 100000
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 200
    And Thanh toán ${EXISTING_INVOICE_ID} với phương thức ${PAYMENT_CASH} số tiền 100000 được lưu trong CSDL
    And Hóa đơn ${EXISTING_INVOICE_ID} có công nợ là 0
    And Hóa đơn ${EXISTING_INVOICE_ID} có trạng thái là ${STATUS_COMPLETED}

RT-PU-014 Cập nhật hoàn tiền cho hóa đơn đã thanh toán
    [Documentation]    Kiểm tra cập nhật hoàn tiền cho hóa đơn đã thanh toán
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID} (đã thanh toán)
    ...    - Công nợ hiện tại: 0đ
    ...    - Thanh toán tiền mặt: -50,000đ (hoàn tiền)
    ...    - Logic cập nhật:
    ...    - Thanh toán âm (hoàn tiền) được thêm vào hóa đơn
    ...    - Công nợ của hóa đơn tăng lên 50,000đ
    ...    - Trạng thái hóa đơn chuyển sang "Chưa thanh toán đủ"
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Thanh toán âm được thêm vào hóa đơn
    ...    - Công nợ hóa đơn tăng lên 50,000đ
    ...    - Trạng thái hóa đơn chuyển sang "Chưa thanh toán đủ"
    Given Chuẩn Bị Dữ Liệu Thanh Toán Với Số Tiền Âm
    When Gửi Yêu Cầu Cập Nhật Thanh Toán
    Then Response Status Code Should Be 200
    And Thanh toán ${EXISTING_INVOICE_ID} với phương thức ${PAYMENT_CASH} số tiền -10000 được lưu trong CSDL
    And Hóa đơn ${EXISTING_INVOICE_ID} có trạng thái là ${STATUS_PROCESSING}

RT-PU-015 Cập nhật mô tả hóa đơn
    [Documentation]    Kiểm tra cập nhật mô tả hóa đơn
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có ID = ${EXISTING_INVOICE_ID}
    ...    - Mô tả: "Thanh toán nợ"
    ...    - Logic cập nhật:
    ...    - Mô tả thanh toán được lưu chính xác
    ...    - Kỳ vọng:
    ...    - Mã trạng thái: 200
    ...    - Thanh toán được thêm vào hóa đơn
    ...    - Mô tả thanh toán lưu đúng nội dung
    [Tags]    apiinvoice    update_invoice    update_payment    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Hóa Đơn Cập Nhập Mô Tả Hóa Đơn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Xác Thực Trạng Thái Hóa Đơn ${INVOICE_CODE} Là Trạng Thái Hủy
    And Xác Thực Trạng Thái Hóa Đơn ${INVOICE_CODE}.01 Là Trạng Thái Hoàn Thành
    And Ghi Chú Được Cập Nhật Thành ${DESCRIPTION}
