*** Settings ***
Documentation     Test cases API cho phần xử lý hóa đơn vlxd và VAT khâu trừ
Suite Setup       Init Test Environment   ${ENV}   MHBH
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Invoice/Invoice_VLXD_Keywords.robot
Resource          ../../../Keywords/Invoice/InvoiceVATKeywords.robot
Resource          ../../../Keywords/Invoice/DiscountProcessingKeywords.robot
Resource          ../../../Keywords/Invoice/RewardPointKeywords.robot
Resource          ../../../Keywords/Invoice/InvoiceCommonKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py
Test Teardown     Delete Invoice From API

*** Keywords ***

*** Test Cases ***
RT-VLXD-001 Tạo hóa đơn có hàng hóa vật liệu xây dựng
    [Documentation]    Kiểm tra tạo hóa đơn có hàng hóa vật liệu xây dựng (hàng có kích thước)
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm VLXD: Sản phẩm có kích thước (chiều dài, rộng, cao)
    ...    - Số lượng: 1
    ...    - Giá: 100,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công với sản phẩm VLXD
    ...    - Thông tin kích thước sản phẩm được lưu chính xác
    [Tags]    invoice    vlxd    construction_materials
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${PRODUCT_CODE_VLXD} Và Kích Thước 3x4x4x4
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Kích Thước 3x4x4x4 Sản Phẩm ${PRODUCT_CODE_VLXD} Trong DB

RT-VLXD-002 Tạo hóa đơn có nhiều sản phẩm VLXD với kích thước khác nhau
    [Documentation]    Kiểm tra tạo hóa đơn có nhiều sản phẩm VLXD với kích thước khác nhau
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm VLXD 1: Kích thước 100x50x20
    ...    - Sản phẩm VLXD 2: Kích thước 200x100x30
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công với các sản phẩm VLXD
    ...    - Thông tin kích thước từng sản phẩm được lưu chính xác
    [Tags]    invoice    vlxd    multiple_products
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${PRODUCT_CODE_VLXD_2} Kích Thước 100x50x20x5 Và ${PRODUCT_CODE_VLXD_3} Kích Thước 200x100x30
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Kích Thước 100x50x20x5 Sản Phẩm ${PRODUCT_CODE_VLXD_2} Trong DB
    And Xác thực Sản Phẩm Gạch ${PRODUCT_CODE_VLXD_3} Có Kích Thước 200x100x30 Trong DB

RT-VLXD-003 Tạo hóa đơn VLXD là hàng gạch
    [Documentation]    Kiểm tra tạo hóa đơn VLXD là hàng gạch
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm VLXD: Sản phẩm có kích thước
    ...    - Thanh toán: Tiền mặt 100,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công với sản phẩm VLXD
    ...    - Thanh toán được ghi nhận chính xác
    [Tags]    invoice    vlxd    payment
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Gạch ${PRODUCT_CODE_VLXD_2} Và Kích Thước 30x40x5
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác thực Sản Phẩm Gạch ${PRODUCT_CODE_VLXD_2} Có Kích Thước 30x40x5 Trong DB

RT-VLXD-004 Tạo hóa đơn VLXD Có nhiều dòng hàng
    [Documentation]    Kiểm tra tạo hóa đơn VLXD có nhiều dòng hàng
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm VLXD: Sản phẩm có kích thước
    ...    - Thêm 1 dòng hàng khác với sản phẩm khác
    ...    - Thanh toán: Tiền mặt 100,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công với sản phẩm VLXD
    ...    - Thanh toán được ghi nhận chính xác
    [Tags]    invoice    vlxd    payment
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${PRODUCT_CODE_VLXD_2} Có 10 Dòng Với Kích Thước 30x40x5
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Sản Phẩm ${PRODUCT_CODE_VLXD_2} Có 10 Dòng Với Kích Thước 30x40x5 Trong DB

RT-VLXD-005 Tạo hóa đơn VLXD gợi ý nhiều dòng
    [Documentation]    Kiểm tra tạo hóa đơn VLXD gợi ý nhiều dòng
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm VLXD: Sản phẩm có kích thước
    ...    - Thêm 1 dòng hàng khác với sản phẩm khác
    ...    - Thanh toán: Tiền mặt 100,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công với sản phẩm VLXD
    ...    - Thanh toán được ghi nhận chính xác
    [Tags]    invoice    vlxd    payment
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${PRODUCT_CODE_VLXD_2} Có 5 Gợi ý và Kích Thước 30x40x5
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Sản Phẩm ${PRODUCT_CODE_VLXD_2} Có 5 Dòng Với Kích Thước 30x40x5 Trong DB

    
RT-DP-005 Tính thuế VAT của hóa đơn
    [Documentation]    Kiểm tra tính thuế VAT của hóa đơn
    ...    - Dữ liệu đầu vào: 
    ...    - Sản phẩm 1: ID=${product_with_vat}, Số lượng=1, Giá=100,000đ, Thuế suất=2%
    ...    - Logic xử lý: InvoiceService.CalculateVAT() 
    ...    - Code: VAT = invoice.InvoiceDetails.Sum(x => x.Quantity * x.Price * x.VATRate / 100);
    ...    - Thuế VAT = 1 * 100,000đ * 2% = 2,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Thuế VAT trong DB được lưu đúng: -2,000đ
    ...    - Cờ thuế VAT được bật (IsVAT=1)
    [Tags]    invoice    vlxd    payment
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế Trực Tiếp Mặc Định Với Sản Phẩm HHVATTT001   
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Thông Tin Thuế -${TOTAL_TAX}
    And Tổng tiền hóa đơn phải bằng 99600



RT-DP-006 Tạo hóa đơn có tích điểm theo hóa đơn
    [Documentation]    Kiểm tra tạo hóa đơn có tích điểm theo hóa đơn
    ...    - Dữ liệu đầu vào: 
    ...    - Sản phẩm: Code=${PRODUCT_CODE_VLXD_2}, Số lượng=1
    ...    - Khách hàng 
    ...    - Tích điểm theo hóa đơn: 100000 được 1 điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công
    ...    - Điểm tích lũy được ghi nhận chính xác trong DB
    [Tags]    invoice    loyalty    points    vlxd
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${PRODUCT_CODE_VLXD_2} Với Khách Hàng ${CUSTOMER_ID_WITH_LOYALTY}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Điểm Thưởng Hóa Đơn 10
    And Xác Thực Bản Ghi Điểm Thưởng Được Tạo 10

RT-DP-007 Tạo hóa đơn có tích điểm theo hóa đơn giảm giá
    [Documentation]    Kiểm tra tạo hóa đơn có tích điểm theo hóa đơn giảm giá
    ...    - Dữ liệu đầu vào: 
    ...    - Sản phẩm: Code=${PRODUCT_CODE_VLXD_2}, Số lượng=1
    ...    - Khách hàng 
    ...    - Tích điểm theo hóa đơn: 100000 được 1 điểm
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công
    ...    - Điểm tích lũy được ghi nhận chính xác trong DB
    [Tags]    invoice    loyalty    points    vlxd
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tích Điểm Với Sản Phẩm ${PRODUCT_CODE_VLXD_2} Có Giảm Giá 10000 và Khách Hàng ${CUSTOMER_CODE_WITH_LOYALTY_2}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Điểm Thưởng Hóa Đơn 9
    And Xác Thực Bản Ghi Điểm Thưởng Được Tạo 9
        
