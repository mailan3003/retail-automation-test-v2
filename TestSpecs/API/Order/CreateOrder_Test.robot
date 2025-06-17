*** Settings ***
Documentation     Test API tạo đơn hàng mới
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Order/CreateOrderKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Order/OrderCommonKeywords.robot
Resource          ../../../TestData/CommonData.robot
Resource          ../../../TestData/Order/CreateOrderData.robot
Resource          ../../../Keywords/Invoice/Invoice_VLXD_Keywords.robot


*** Variables ***
@{list_product_code}    HH0040     HH0041   
@{list_payment_method}    Cash    Transfer
@{list_payment_amount}    100000    200000
@{list_surcharge_code}    ${SURCHARGE_1_CODE}    ${SURCHARGE_2_CODE}
*** Test Cases ***
RT-ORDER-001 Tạo Đơn Hàng Mới Thành Công Với Thông Tin Cơ Bản
    [Documentation]    Test tạo đơn hàng mới thành công với thông tin cơ bản: sản phẩm, khách hàng, nhân viên bán hàng
    [Tags]    AIGenerated    CreateOrder    Positive    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản HH0115
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Thông Tin Chi Tiết Đơn Hàng
    [Teardown]    Delete Order From Api

RT-ORDER-002 Tạo Đơn Hàng Với Nhiều Sản Phẩm
    [Documentation]    Test tạo đơn hàng mới với nhiều sản phẩm khác nhau
    [Tags]    AIGenerated    CreateOrder    Positive    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Sản Phẩm ${list_product_code}
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Tổng Tiền Đơn Hàng Được Tính Đúng

RT-ORDER-003 Tạo Đơn Hàng Với Chiết Khấu
    [Documentation]    Test tạo đơn hàng mới có áp dụng chiết khấu
    [Tags]    AIGenerated    CreateOrder    Positive    Discount    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Chiết Khấu 10 %
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Chiết Khấu Đơn Hàng Được Tính Đúng
    [Teardown]    Delete Order From Api

Tạo Đơn Giảm Giá VND
    
    [Tags]    AIGenerated    CreateOrder    Positive    Discount   regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Giảm Giá 10000
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Chiết Khấu Đơn Hàng Được Tính Đúng
    [Teardown]    Delete Order From Api

Tạo Đơn Với Khách Hàng 
    [Documentation]    Test tạo đơn hàng mới với khách hàng 
    [Tags]    AIGenerated    CreateOrder    Negative    InvalidCustomer    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Khách Hàng CTKH264
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Khách Hàng Trong Đơn Đặt Hàng Là CTKH264
    [Teardown]    Delete Order From Api



RT-ORDER-008 Tạo Đơn Hàng Với Mô Tả Đơn Hàng
    [Documentation]    Test tạo đơn hàng mới có mô tả đơn hàng
    [Tags]    AIGenerated    CreateOrder    Positive    Description    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Mô Tả Đơn Hàng 200 Ký Tự
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Mô Tả Đơn Hàng Được Cập Nhật Đúng
    [Teardown]    Delete Order From Api

RT-ORDER-005 Tạo Đơn Hàng Với Người Nhận Đặt Hợp Lệ
    
    [Tags]    AIGenerated    CreateOrder    Positive    ValidReceiver    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Người Nhận Đặt son.dx
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Người Nhận Đặt Trong Đơn Hàng là son.dx
    [Teardown]    Delete Order From Api

RT-ORDER-005 Tạo Đơn Hàng Với Kênh Bán Hợp Lệ
    [Documentation]    Test tạo đơn hàng mới có kênh bán hợp lệ
    [Tags]    AIGenerated    CreateOrder    Positive    ValidSaleChannel    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Kênh Bán Kênh 3
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Kênh Bán Trong Đơn Đặt Hàng Là Kênh 3
    [Teardown]    Delete Order From Api

RT-ORDER-005 Tạo Đơn Hàng Bảng Giá
    
    [Tags]    AIGenerated    CreateOrder    Positive    ValidPriceBook    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Bảng Giá Bảng giá chi nhánh
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    [Teardown]    Delete Order From Api

Tạo Đơn Hàng Với Ngày Dự Kiến Giao Hàng Thời Gian Tương Lai
    [Documentation]    Test tạo đơn hàng mới có ngày dự kiến giao hàng thời gian tương lai
    [Tags]    AIGenerated    CreateOrder    Positive    ExpectedDeliveryDate    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Thời Gian Giao Hàng Sau 2 Ngày So Với Ngày Hiện Tại
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Thời Gian Giao Hàng Đã Được Cập Nhật Thành Sau 2 Ngày So Với Ngày Hiện Tại

RT-ORDER-009 Tạo Đơn Hàng Với Ngày Dự Kiến Giao Hàng
    [Documentation]    Test tạo đơn hàng mới có ngày dự kiến giao hàng về quá khứ
    [Tags]    AIGenerated    CreateOrder    Positive    ExpectedDeliveryDate    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Thời Gian Giao Hàng Trước 2 Ngày So Với Ngày Hiện Tại
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Ngày dự kiến giao phải ở trong tương lai"


RT-ORDER-029 Tạo Đơn Hàng Thay Đổi Ngày Bán Về Quá Khứ
    [Documentation]    Test tạo đơn hàng mới với các trường ngày tháng UTC
    [Tags]    AIGenerated    CreateOrder    Positive    UTCDates    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Ngày Bán Trước 2 Ngày So Với Ngày Hiện Tại
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Ngày Bán Hàng Đã Được Cập Nhật Thành Trước 2 Ngày So Với Ngày Hiện Tại

RT-ORDER-029 Tạo Đơn Hàng Thay Đổi Ngày Bán Tương Lai
    [Documentation]    Test tạo đơn hàng mới với các trường ngày tháng UTC
    [Tags]    AIGenerated    CreateOrder    Positive    UTCDates    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Ngày Bán Sau 2 Ngày So Với Ngày Hiện Tại
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Vượt quá thời gian hiện tại"

RT-ORDER-001 Tạo đơn hàng với thuế VAT mặc định
    [Documentation]    Kiểm tra tạo hóa đơn với thuế VAT mặc định
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm: SP040943, SL=1, Giá=100,000đ
    ...    - Không chỉ định thuế VAT (sử dụng mặc định 10%)
    ...    - Logic xử lý:
    ...    - Tổng tiền trước thuế = 100,000đ
    ...    - Tiền thuế = 100,000đ * 10% = 10,000đ
    ...    - Tổng tiền sau thuế = 110,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được lưu vào CSDL với thông tin thuế chính xác
    ...    - Tổng tiền trước thuế = 100,000đ
    ...    - Tiền thuế = 10,000đ
    ...    - Tổng tiền sau thuế = 110,000đ
    [Tags]    CreateOrder    vat    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm HH0115 Có Thuế VAT 
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Thông Tin Thuế Trong Đơn Đặt Hàng ${TOTAL_TAX}
    [Teardown]    Delete Order From Api

RT-ORDER-005 Tính thuế trực tiếp VAT của Đặt Hàng
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
    [Tags]    CreateOrder    vlxd    payment  
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Thuế Trực Tiếp Mặc Định Với Sản Phẩm HHVATTT001   
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Thông Tin Thuế Trong Đơn Đặt Hàng -${TOTAL_TAX}
    And Xác Thực Tổng tiền Trong Đơn Đặt Hàng Là 99600
    [Teardown]    Delete Order From Api

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
    [Tags]    CreateOrder    vlxd    construction_materials
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm ${PRODUCT_CODE_VLXD} Và Kích Thước 3x4x4x4
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Kích Thước 3x4x4x4 Sản Phẩm ${PRODUCT_CODE_VLXD} Trong Đơn Đặt Hàng
    [Teardown]    Delete Order From Api

RT-VLXD-002 Tạo hóa đơn có nhiều sản phẩm VLXD với kích thước khác nhau
    [Documentation]    Kiểm tra tạo hóa đơn có nhiều sản phẩm VLXD với kích thước khác nhau
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm VLXD 1: Kích thước 100x50x20
    ...    - Sản phẩm VLXD 2: Kích thước 200x100x30
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công với các sản phẩm VLXD
    ...    - Thông tin kích thước từng sản phẩm được lưu chính xác
    [Tags]    CreateOrder   vlxd    multiple_products4324
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm ${PRODUCT_CODE_VLXD_2} Kích Thước 100x50x20x5 Và ${PRODUCT_CODE_VLXD_3} Kích Thước 200x100x30
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Kích Thước 100x50x20x5 Sản Phẩm ${PRODUCT_CODE_VLXD_2} Trong Đơn Đặt Hàng
    And Xác Thực Sản Phẩm Gạch ${PRODUCT_CODE_VLXD_3} Có Kích Thước 200x100x30 Trong Đơn Đặt Hàng
    [Teardown]    Delete Order From Api

RT-VLXD-003 Tạo hóa đơn VLXD là hàng gạch
    [Documentation]    Kiểm tra tạo hóa đơn VLXD là hàng gạch
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm VLXD: Sản phẩm có kích thước
    ...    - Thanh toán: Tiền mặt 100,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công với sản phẩm VLXD
    ...    - Thanh toán được ghi nhận chính xác
    [Tags]    CreateOrder    vlxd    payment
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm Gạch ${PRODUCT_CODE_VLXD_2} Và Kích Thước 30x40x5
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác thực Sản Phẩm Gạch ${PRODUCT_CODE_VLXD_2} Có Kích Thước 30x40x5 Trong Đơn Đặt Hàng
    [Teardown]    Delete Order From Api

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
    [Tags]    CreateOrder    vlxd    payment
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm ${PRODUCT_CODE_VLXD_2} Có 10 Dòng Với Kích Thước 30x40x5
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm ${PRODUCT_CODE_VLXD_2} Có 10 Dòng Với Kích Thước 30x40x5 Trong Đơn Đặt Hàng
    [Teardown]    Delete Order From Api

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
    [Tags]    CreateOrder    vlxd    payment
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm ${PRODUCT_CODE_VLXD_2} Có 5 Gợi ý và Kích Thước 30x40x5
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm ${PRODUCT_CODE_VLXD_2} Có 5 Dòng Với Kích Thước 30x40x5 Trong Đơn Đặt Hàng
    [Teardown]    Delete Order From Api

RT-DP-013 Tính tổng tiền hàng có phụ phí cố định
    [Documentation]    Kiểm tra tính tổng tiền hàng có phụ phí cố định:
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Giảm giá: 5.000đ
    ...    - Phụ phí cố định: 10.000đ
    ...    - Kỳ vọng: Tổng tiền = 100.000đ - 5.000đ + 10.000đ = 105.000đ
    ...    - Chuẩn hóa: Tổng tiền được làm tròn lên theo cấu hình CurrencyDecimalPlace (0 chữ số)
    ...    - Kết quả: 105000đ nếu cấu hình là 0 chữ số thập phân
    [Tags]    discount      CreateOrder   regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Giảm Giá 5000 Có Thu Khác ${SURCHARGE_1_CODE}
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Tổng Tiền Trong Đơn Đặt Hàng Là ${TOTAL_ORDER}
    And Xác Định Có Giá Trị Thu Khác ${TOTAL_SURCHARGE} Trong Đơn Đặt Hàng
    And Xác Định Tracking Trong Surcharge Order ${SURCHARGE_1_CODE}
    [Teardown]    Delete Order From Api
    
RT-DP-014 Tính tổng tiền hàng có phụ phí phần trăm
    [Documentation]    Kiểm tra tính tổng tiền hàng có phụ phí tính theo phần trăm:
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Giảm giá: 15.000đ
    ...    - Phụ phí: 13% của tổng tiền sản phẩm
    ...    - Kỳ vọng: Tổng tiền = 100.000đ - 15.000đ + (100.000đ - 15.000đ) * 13% = 85000đ
    ...    - Chuẩn hóa: Tổng tiền được làm tròn lên theo cấu hình CurrencyDecimalPlace (0 chữ số)
    ...    - Kết quả: 85000đ nếu cấu hình là 0 chữ số thập phân
    [Tags]    discount      CreateOrder    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Giảm Giá 15000 Có Thu Khác ${SURCHARGE_2_CODE}
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Tổng Tiền Trong Đơn Đặt Hàng Là ${TOTAL_ORDER}
    And Xác Định Có Giá Trị Thu Khác ${TOTAL_SURCHARGE} Trong Đơn Đặt Hàng
    And Xác Định Tracking Trong Surcharge Order ${SURCHARGE_2_CODE}
    [Teardown]    Delete Order From Api


Tính tổng tiền hàng có nhiều thu khác
    [Documentation]    Kiểm tra tính tổng tiền hàng có phụ phí cố định:
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Giảm giá: 5.000đ
    ...    - Phụ phí cố định: 10.000đ
    ...    - Kỳ vọng: Tổng tiền = 100.000đ - 5.000đ + 10.000đ = 105.000đ
    ...    - Chuẩn hóa: Tổng tiền được làm tròn lên theo cấu hình CurrencyDecimalPlace (0 chữ số)
    ...    - Kết quả: 105000đ nếu cấu hình là 0 chữ số thập phân
    [Tags]    discount      CreateOrder    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Giảm Giá 0 Có Nhiều Thu Khác ${list_surcharge_code}
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Tổng Tiền Trong Đơn Đặt Hàng Là ${TOTAL_ORDER}
    And Xác Định Có Giá Trị Thu Khác ${TOTAL_SURCHARGE} Trong Đơn Đặt Hàng
    And Xác Định Tracking Trong Surcharge Order ${SURCHARGE_2_CODE}
    And Xác Định Tracking Trong Surcharge Order ${SURCHARGE_1_CODE}
    [Teardown]    Delete Order From Api



