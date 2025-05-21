*** Settings ***
Documentation     Test cases API cho phần xử lý giảm giá hóa đơn
Resource          ../../../Keywords/Invoice/DiscountProcessingKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Utilities/RequestHelper.robot
Resource          ../../../Keywords/Utilities/DataUtilities.robot

*** Variables ***


*** Keywords ***

*** Test Cases ***
RT-DP-001 Tạo hóa đơn với giảm giá cơ bản
    [Documentation]    Kiểm tra tạo hóa đơn với giảm giá cơ bản:
    ...    - Giá trị giảm giá: 10.000đ
    ...    - Tỷ lệ giảm giá: 10%
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Kỳ vọng: Giảm giá được lưu chính xác trong CSDL theo cấu hình tiền tệ
    ...    - Chuẩn hóa: Giảm giá được làm tròn theo cấu hình số chữ số thập phân
    ...    - Kết quả: 10000đ nếu cấu hình là 0 chữ số thập phân
    [Tags]    discount      apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Giảm Giá 10000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Giảm Giá Hóa Đơn Trong CSDL Với Giảm Giá 10000
    And Tổng tiền hóa đơn phải bằng 90000


RT-DP-003 Tạo hóa đơn với tỷ lệ giảm giá phần trăm    
    [Documentation]    Kiểm tra tạo hóa đơn với tỷ lệ giảm giá phần trăm:
    ...    - Tỷ lệ giảm giá: 15%
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Kỳ vọng: Tỷ lệ giảm giá được làm tròn theo CURRENCY_DECIMAL_PLACE_FOR_PRODUCT (2 chữ số)
    ...    - Chuẩn hóa: Từ 15% thành 15% nếu cấu hình là 2 chữ số thập phân
    ...    - Kết quả: 85000đ nếu cấu hình là 0 chữ số thập phân
    [Tags]    discount      apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giảm Giá Tỷ Lệ 15 %
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Giảm Giá Hóa Đơn Trong CSDL Với Tỷ Lệ Giảm Giá 15
    And Tổng tiền hóa đơn phải bằng 85000


RT-DP-008 Tạo hóa đơn với giảm giá giá trị lớn
    [Documentation]    Kiểm tra tạo hóa đơn với giảm giá giá trị lớn:
    ...    - Giá trị giảm giá: 100.000đ (lớn hơn giá trị sản phẩm)
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Kỳ vọng: Giảm giá được chấp nhận và lưu đúng vào CSDL
    ...    - Kết quả: 0đ nếu cấu hình là 0 chữ số thập phân
    [Tags]    discount      apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Giảm Giá 100000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Giảm Giá Hóa Đơn Trong CSDL Với Giảm Giá 100000
    And Tổng tiền hóa đơn phải bằng 0

RT-DP-009 Tạo hóa đơn với tỷ lệ giảm giá 100%
    [Documentation]    Kiểm tra tạo hóa đơn với tỷ lệ giảm giá 100%:
    ...    - Tỷ lệ giảm giá: 100%
    ...    - Giá trị giảm giá: 100.000đ (bằng giá trị sản phẩm)
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Kỳ vọng: Tỷ lệ giảm giá 100% được chấp nhận và lưu đúng vào CSDL
    ...    - Kết quả: 0đ nếu cấu hình là 0 chữ số thập phân
    [Tags]    discount      apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giảm Giá Tỷ Lệ 100 %
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Giảm Giá Hóa Đơn Trong CSDL Với Tỷ Lệ Giảm Giá 100
    And Tổng tiền hóa đơn phải bằng 0
# New test cases for discount processing and total calculation
RT-DP-010 Tính tổng tiền hàng cơ bản
    [Documentation]    Kiểm tra tính tổng tiền hàng cơ bản:
    ...    - Sản phẩm: 1 sản phẩm với giá 100000.55đ, số lượng 2.5
    ...    - Kỳ vọng: Tổng tiền = 100000.55đ * 2.5 = 250000.55
    ...    - Chuẩn hóa: Tổng tiền được làm tròn lên theo cấu hình CurrencyDecimalPlace (0 chữ số)
    ...    - Kết quả: 250001đ nếu cấu hình là 0 chữ số thập phân
    [Tags]    discount      apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Đơn Giá 100000.55 Số Lượng 2.5
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Tổng tiền hóa đơn phải bằng 250001

RT-DP-011 Tính tổng tiền hàng có giảm giá sản phẩm
    [Documentation]    Kiểm tra tính tổng tiền hàng có giảm giá sản phẩm:
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ, giảm giá 10.000đ, số lượng 2
    ...    - Kỳ vọng: Tổng tiền = (100.000đ - 10.000đ) * 2.33 = 209700đ
    ...    - Chuẩn hóa: Tổng tiền được làm tròn lên theo cấu hình CurrencyDecimalPlace (0 chữ số)
    ...    - Kết quả: 209700đ nếu cấu hình là 0 chữ số thập phân
    [Tags]    discount      apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Đơn Giá 100000 Giảm Giá 10000 Số Lượng 2.33
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Tổng tiền hóa đơn phải bằng 209700

RT-DP-012 Tính tổng tiền hàng có giảm giá hóa đơn
    [Documentation]    Kiểm tra tính tổng tiền hàng có giảm giá hóa đơn:
    ...    - Sản phẩm: 2 sản phẩm với giá 100.000đ và 200.000đ
    ...    - Giảm giá hóa đơn: 30.000đ
    ...    - Kỳ vọng: Tổng tiền = (100.000đ + 200.000đ) - 30.000đ = 270.000đ
    ...    - Chuẩn hóa: Tổng tiền được làm tròn lên theo cấu hình CurrencyDecimalPlace (0 chữ số)
    ...    - Kết quả: 270000đ nếu cấu hình là 0 chữ số thập phân
    [Tags]    discount      apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Hai Sản Phẩm Và Giảm Giá Hóa Đơn 30000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Tổng tiền hóa đơn phải bằng 270000
    
RT-DP-013 Tính tổng tiền hàng có phụ phí cố định
    [Documentation]    Kiểm tra tính tổng tiền hàng có phụ phí cố định:
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Giảm giá: 5.000đ
    ...    - Phụ phí cố định: 10.000đ
    ...    - Kỳ vọng: Tổng tiền = 100.000đ - 5.000đ + 10.000đ = 105.000đ
    ...    - Chuẩn hóa: Tổng tiền được làm tròn lên theo cấu hình CurrencyDecimalPlace (0 chữ số)
    ...    - Kết quả: 105000đ nếu cấu hình là 0 chữ số thập phân
    [Tags]    discount      apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giảm Giá 5000 Phụ Phí Cố Định 10000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Tổng tiền hóa đơn phải bằng 105000
    
RT-DP-014 Tính tổng tiền hàng có phụ phí phần trăm
    [Documentation]    Kiểm tra tính tổng tiền hàng có phụ phí tính theo phần trăm:
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Giảm giá: 15.000đ
    ...    - Phụ phí: 13% của tổng tiền sản phẩm
    ...    - Kỳ vọng: Tổng tiền = 100.000đ - 15.000đ + (100.000đ - 15.000đ) * 13% = 85000đ
    ...    - Chuẩn hóa: Tổng tiền được làm tròn lên theo cấu hình CurrencyDecimalPlace (0 chữ số)
    ...    - Kết quả: 85000đ nếu cấu hình là 0 chữ số thập phân
    [Tags]    discount      apiinvoice    regression
        Given Chuẩn Bị Dữ Liệu Hóa Đơn Giảm Giá 15000 Phụ Phí Phần Trăm 13
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Tổng tiền hóa đơn phải bằng 85000
    
RT-DP-015 Tính tổng tiền hàng có giảm giá theo mã coupon
    [Documentation]    Kiểm tra tính tổng tiền hàng có giảm giá theo mã coupon:
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Mã coupon: Giảm 20.000đ
    ...    - Kỳ vọng: Tổng tiền = 100.000đ - 20.000đ = 80.000đ
    ...    - Chuẩn hóa: Tổng tiền được làm tròn lên theo cấu hình CurrencyDecimalPlace (0 chữ số)
    ...    - Kết quả: 80000đ nếu cấu hình là 0 chữ số thập phân
    [Tags]    discount    apiinvoice    coupon    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Áp Đợt Coupon BHCP00004 và Giảm Giá 50000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Tổng tiền hóa đơn phải bằng 0
    
RT-DP-016 Tính tổng tiền hàng có giảm giá theo mã coupon phần trăm
    [Documentation]    Kiểm tra tính tổng tiền hàng có giảm giá theo mã coupon phần trăm:
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Mã coupon: Giảm 15% tổng giá trị đơn hàng
    ...    - Kỳ vọng: Tổng tiền = 100.000đ - (100.000đ * 15%) = 85.000đ
    ...    - Chuẩn hóa: Tổng tiền được làm tròn lên theo cấu hình CurrencyDecimalPlace (0 chữ số)
    ...    - Kết quả: 85000đ nếu cấu hình là 0 chữ số thập phân
    [Tags]    discount    apiinvoice    coupon    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Áp Đợt Coupon BHCP00004
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Tổng tiền hóa đơn phải bằng 95000
    
RT-DP-017 Tính tổng tiền hàng có giảm giá theo tối đa 100000
    [Documentation]    Kiểm tra tính tổng tiền hàng có giảm giá theo mã coupon với điều kiện áp dụng:
    ...    - Sản phẩm:  sản phẩm với tổng giá 5000000đ
    ...    - Mã coupon: Giảm 100.000đ cho đơn hàng từ 300.000đ
    ...    - Kỳ vọng: Tổng tiền = 300.000đ - 50.000đ = 250.000đ
    ...    - Chuẩn hóa: Tổng tiền được làm tròn lên theo cấu hình CurrencyDecimalPlace (0 chữ số)
    ...    - Kết quả: 250000đ nếu cấu hình là 0 chữ số thập phân
    [Tags]    discount    apiinvoice    coupon    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Đơn Giá 5000000 Áp Đợt Coupon BHCP00004
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Tổng tiền hóa đơn phải bằng 4900000
    
Tạo hóa đơn áp dụng coupon ở trạng thái chưa phát hành
    [Documentation]    Kiểm tra tạo hóa đơn áp dụng coupon ở trạng thái không hợp lệ:
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Mã coupon: Giảm 10.000đ
    ...    - Trạng thái coupon: Không hợp lệ
    ...    - Kỳ vọng: Mã trạng thái phải là 400
    ...    - Nội dung phản hồi trả về phải có thông báo lỗi về coupon không hợp lệ
    [Tags]    discount    apiinvoice    coupon    regression       
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Áp Đợt Coupon COUPON001 Và Trạng Thái Chưa Sử Dụng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 420
    And Response Should Have Error "Trạng thái coupon CPM23LRPX0 chưa hợp lệ. Coupon phải ở trạng thái Đã phát hành"

Tạo hóa đơn áp dụng coupon ở trạng thái đã sử dụng
    [Documentation]    Kiểm tra tạo hóa đơn áp dụng coupon ở trạng thái đã sử dụng:
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Mã coupon: Giảm 10.000đ
    ...    - Trạng thái coupon: Đã sử dụng
    ...    
    ...    - Kỳ vọng: Mã trạng thái phải là 400
    ...    - Nội dung phản hồi trả về phải có thông báo lỗi về coupon không hợp lệ
    [Tags]    discount    apiinvoice    coupon    regression    
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Áp Đợt Coupon COUPON001 Và Trạng Thái Đã Sử Dụng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 420
    And Response Should Have Error "Trạng thái coupon CPCMT5OSH5 chưa hợp lệ. Coupon phải ở trạng thái Đã phát hành"

Tạo hóa đơn không đủ điều kiện vẫn áp dụng coupon
    [Documentation]    Kiểm tra tạo hóa đơn không đủ điều kiện vẫn áp dụng coupon:
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Mã coupon: Giảm 10.000đ
    ...    - Trạng thái coupon: Đã phát hành
    ...    - Kỳ vọng: Mã trạng thái phải là 420
    ...    - Nội dung phản hồi trả về phải có thông báo lỗi về coupon không hợp lệ
    [Tags]    discount    apiinvoice    coupon    regression    
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Áp Đợt Coupon COUPON001
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 420
    And Response Should Have Error "Tổng tiền hàng phải lớn hơn 800,000 mới có thể sử dụng coupon CPDD8VJS9D"

Tạo hóa đơn áp dụng coupon ở đợt phát hành chưa áp dụng
    [Documentation]    Kiểm tra tạo hóa đơn áp dụng coupon ở đợt phát hành chưa áp dụng:
    ...    - Sản phẩm: 1 sản phẩm với giá 100.000đ
    ...    - Mã coupon: Giảm 10.000đ
    ...    - Trạng thái coupon: Đã phát hành
    ...    - Kỳ vọng: Mã trạng thái phải là 420
    ...    - Nội dung phản hồi trả về phải có thông báo lỗi về coupon không hợp lệ
    [Tags]    discount    apiinvoice    coupon    regression        
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Áp Đợt Coupon COUPON002
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 420
    And Response Should Have Error "Đợt phát hành của coupon CPIGVM6HXV chưa được kích hoạt"
