*** Settings ***
Documentation     Test API cập nhật đơn hàng - Comprehensive test cases for order update functionality
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Order/UpdateOrderKeywords.robot
Resource          ../../../Keywords/Order/OrderCommonKeywords.robot
Resource          ../../../Keywords/Order/CreateOrderKeywords.robot
Resource          ../../../Keywords/Utilities/Utilities.robot
Resource          ../../../TestData/Order/CreateOrderData.robot
Resource          ../../../TestData/CommonData.robot



*** Test Cases ***
RT-ORDER-UPDATE-010 Chuyển Chi Nhánh Xử Lý Đặt Hàng 
    [Documentation]    Chuyển Chi Nhánh Xử Lý Đặt Hàng 
    [Tags]    AIGenerated    UpdateOrder    Positive    BranchTransfer        regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản DV249 Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Chuyển Chi Nhánh Xử Lý Đặt Hàng Thành Nhánh A Thanh Toán Có Cập Nhật Theo
    And Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Chi Nhánh Xử Lý Đã Được Chuyển Thành Nhánh A  
    [Teardown]    Delete Order From Api

RT-ORDER-UPDATE-011 Chuyển Chi Nhánh Xử Lý Đặt Hàng Là Chi Nhánh Đã Xóa
    [Documentation]    Kiểm tra Chi Nhánh Xử Lý Đặt Hàng Thành Nhánh Thanh Toán Không Cập Nhật Theo
    [Tags]    AIGenerated    UpdateOrder    Positive    BranchTransfer        regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0171 Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Chuyển Chi Nhánh Xử Lý Đặt Hàng Thành Nhánh Thanh Toán Không Cập Nhật Theo
    And Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Chi nhánh xử lý không tồn tại hoặc đã bị xoá"
    [Teardown]    Delete Order From Api

Chuyển Chi Nhánh Xử Lý Đặt Hàng là Chi Nhánh Ngừng Hoạt Động
    [Documentation]    Chuyển Chi Nhánh Xử Lý Đặt Hàng Là Chi Nhánh Ngừng Hoạt Động
    [Tags]    AIGenerated    UpdateOrder    Positive    BranchTransfer        regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0174 Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Chuyển Chi Nhánh Xử Lý Đặt Hàng Thành Chi nhánh ngừng hoạt động Thanh Toán Không Cập Nhật Theo
    And Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Chi nhánh xử lý đã ngừng hoạt động"
    [Teardown]    Delete Order From Api


Chuyển Chi Nhánh Đơn Có Thanh Toán Thanh Toán Có Cập Nhật Theo
    [Documentation]    Chuyển Chi Nhánh Đơn Có Thanh Toán Thanh Toán Có Cập Nhật Theo
    ...    - Xác thực chi nhánh xử lý đã được chuyển thành nhánh A
    ...    - Xác thực phiếu thanh toán ở nhánh A
    [Tags]    AIGenerated    UpdateOrder    Positive    BranchTransfer        regression
    Given Chuẩn Bị Đơn Hàng Sản Phẩm HH0053 Có Khách Hàng ${EMPTY} Thanh Toán Với Số Tiền 5000
    And Chuẩn Bị Dữ Liệu Chuyển Chi Nhánh Xử Lý Đặt Hàng Thành Nhánh A Thanh Toán Có Cập Nhật Theo
    And Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Chi Nhánh Xử Lý Đã Được Chuyển Thành Nhánh A  
    And Xác Thực Phiếu Thanh Toán Ở Nhánh A
    [Teardown]    Delete Order From Api
 

Chuyển Chi Nhánh Đơn Có Thanh Toán Thanh Toán Không Cập Nhật Theo
    [Documentation]    Chuyển Chi Nhánh Đơn Có Thanh Toán Thanh Toán Không Cập Nhật Theo
    ...    - Xác thực chi nhánh xử lý đã được chuyển thành nhánh A
    ...    - Xác thực phiếu thanh toán ở chi nhánh trung tâm
    [Tags]    AIGenerated    UpdateOrder    Positive    BranchTransfer        regression
    Given Chuẩn Bị Đơn Hàng Sản Phẩm HH0053 Có Khách Hàng ${EMPTY} Thanh Toán Với Số Tiền 10000
    And Chuẩn Bị Dữ Liệu Chuyển Chi Nhánh Xử Lý Đặt Hàng Thành Nhánh A Thanh Toán Không Cập Nhật Theo
    And Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Chi Nhánh Xử Lý Đã Được Chuyển Thành Nhánh A  
    And Xác Thực Phiếu Thanh Toán Ở Chi nhánh trung tâm
    [Teardown]    Delete Order From Api
    
Chuyển Chi Nhánh Với Gian Hàng Không Thiết lập Cho Phép Chuyển Chi Nhánh
    [Documentation]    Chuyển Chi Nhánh Với Gian Hàng Không Thiết lập Cho Phép Chuyển Chi Nhánh
    [Tags]    API Không chặn nếu gian hàng không được thiết lập
    Given Chuẩn Bị Đơn Đặt hàng Với Hàng HGB0003 Với Số Lượng 1 Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Chuyển Chi Nhánh Xử Lý Đặt Hàng Thành Nhánh A Thanh Toán Có Cập Nhật Theo
    And Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Gian hàng không thiết lập cho phép chuyển chi nhánh"
    [Teardown]    Delete Order From Api
  

Chuyển Chi Nhánh Với Đơn Có Khuyến mãi
    [Documentation]    Chuyển Chi Nhánh Với Đơn Có Khuyến mãi
    [Tags]    AIGenerated    UpdateOrder    Positive    BranchTransfer    regression
    Given Chuẩn Bị Đơn Hàng Sản Phẩm DV240 Có Khuyến Mãi KM00001 Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Chuyển Chi Nhánh Xử Lý Đặt Hàng Thành Nhánh A Thanh Toán Có Cập Nhật Theo
    And Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Không thể cập nhật chi nhánh do đơn đặt hàng đã được áp dụng khuyến mại ở chi nhánh này"
    [Teardown]    Delete Order From Api



Chuyển Chi Nhánh Với Đơn ở Trạng Thái Khác Phiếu Tạm
    [Documentation]    Chuyển Chi Nhánh Với Đơn ở Trạng Thái Hoàn Thành
    [Tags]    AIGenerated    UpdateOrder    Positive    BranchTransfer        regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0053 Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Chuyển Chi Nhánh Xử Lý Đặt Hàng Với Đơn Ở Trạng Thái 3 Thành Nhánh A
    And Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Trạng thái đơn hàng không hợp lệ"
    [Teardown]    Delete Order From Api

Chuyển Chi Nhánh với Đơn Có Khách Hàng Gian Quản lý Khách Hàng Theo Chi Nhánh
    [Documentation]    Chuyển Chi Nhánh với Đơn Có Khách Hàng Gian Quản lý Khách Hàng Theo Chi Nhánh
    [Tags]    AIGenerated    UpdateOrder    Positive    BranchTransfer       vlxd
    Given Chuẩn Bị Đơn Hàng Sản Phẩm VLXD0002 Có Khách Hàng KH000003 Thanh Toán Với Số Tiền 0
    And Chuẩn Bị Dữ Liệu Chuyển Chi Nhánh Xử Lý Đặt Hàng Thành Nhánh A Thanh Toán Có Cập Nhật Theo
    And Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Không thể cập nhật chi nhánh do đơn đặt hàng đã được thanh toán"


RT-ORDER-UPDATE-006 Cập Nhật Kênh Bán Hàng Trong Đơn Hàng
    [Documentation]    Kiểm tra cập nhật kênh bán hàng trong đơn hàng:
    ...    - Thay đổi kênh bán hàng từ kênh này sang kênh khác ở MHQL
    ...    - Xác thực kênh bán hàng được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    SaleChannel    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0175 Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Kênh Bán Thành Kênh 3 Ở MHQL
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Kênh Bán Trong Đơn Đặt Hàng Là Kênh 3 
    [Teardown]    Delete Order From Api

RT-ORDER-UPDATE-006 Cập Nhật Người Nhận Đặt Trong Đơn Hàng
    [Documentation]    Kiểm tra cập nhật người nhận đặt trong đơn hàng:
    ...    - Thay đổi người nhận đặt từ người này sang người khác ở MHQL
    ...    - Xác thực người nhận đặt được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    SaleChannel    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0176 Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Người Nhận Đặt Thành son.dx Ở MHQL
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Người Nhận Đặt Trong Đơn Hàng là son.dx
    [Teardown]    Delete Order From Api


Cập Nhật Ghi Chú Đơn Hàng ở MHQL
    [Documentation]    Cập Nhật Ghi Chú Đơn Hàng ở MHQL
    [Tags]    AIGenerated    UpdateOrder    Positive    Description    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0054 Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Ghi Chú 300 Kí Tự Ở MHQL 
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Mô Tả Đơn Hàng Được Cập Nhật Đúng
    [Teardown]    Delete Order From Api
# =============================================================================


RT-ORDER-UPDATE-018 Cập Nhật Đơn Hàng Thời Gian Giao Hàng Về Quá Khứ
    [Documentation]    Kiểm tra cập nhật đơn hàng với các trường ngày tháng UTC:
    ...    - PurchaseDate và ExpectedDeliveryDate ở định dạng UTC
    ...    - Hệ thống xử lý chuyển đổi múi giờ đúng
    [Tags]   APi Không Chặn
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0053 Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Thời Gian Giao Hàng Trước 1 Ngày So Với Hiện Tại MHQL
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Ngày dự kiến giao phải ở trong tương lai"



Cập Nhật Đơn Hàng Thời Gian Giao Hàng Về Tương Lai
    [Documentation]    Kiểm tra cập nhật đơn hàng với các trường ngày tháng UTC:
    ...    - PurchaseDate và ExpectedDeliveryDate ở định dạng UTC
    ...    - Hệ thống xử lý chuyển đổi múi giờ đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    UTCDates434    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0055 Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Thời Gian Giao Hàng Sau 1 Ngày So Với Hiện Tại MHQL
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Thời Gian Giao Hàng Đã Được Cập Nhật Thành Sau 1 Ngày So Với Ngày Hiện Tại
    [Teardown]    Delete Order From Api

Cập Nhật Thời Gian Bán Hàng Về Quá Khứ
    [Documentation]    Kiểm tra cập nhật đơn hàng với các trường ngày tháng UTC:
    ...    - PurchaseDate và ExpectedDeliveryDate ở định dạng UTC
    ...    - Hệ thống xử lý chuyển đổi múi giờ đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    UTCDates    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0056 Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Ngày Bán Hàng Trước 2 Ngày So Với Hiện Tại MHQL
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Ngày Bán Hàng Đã Được Cập Nhật Thành Trước 2 Ngày So Với Ngày Hiện Tại
    [Teardown]    Delete Order From Api


Cập Nhật Đơn Hàng Thời Gian Bán Hàng Tương Lai
    [Documentation]    Kiểm tra cập nhật đơn hàng với các trường ngày tháng UTC:
    ...    - PurchaseDate và ExpectedDeliveryDate ở định dạng UTC
    ...    - Hệ thống xử lý chuyển đổi múi giờ đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    UTCDates    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0263 Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Ngày Bán Hàng Sau 1 Ngày So Với Hiện Tại MHQL
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Vượt quá thời gian hiện tại"
    [Teardown]    Delete Order From Api

Cập Nhật Trạng Thái Đơn Hàng Sang Đã Xác Nhận
    [Documentation]    Cập Nhật Trạng Thái Đơn Hàng
    [Tags]    AIGenerated    UpdateOrder    Positive    OrderStatus    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0058 Để Cập Nhật
    And Chuẩn Bị Cập Nhật Trạng Thái Đơn Hàng Sang Đã Xác Nhận
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Trạng Thái Đơn Hàng Đã Được Cập Là ${STATUS_ID}
    [Teardown]    Delete Order From Api

Cập Nhật Đơn Hàng Về Trạng Thái Hoàn Thành
    [Documentation]    Cập Nhật Đơn Hàng Về Trạng Thái Hoàn Thành MHQL
    [Tags]    AIGenerated    UpdateOrder    Positive    OrderStatus    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0060 Để Cập Nhật
    And Chuẩn Bị Cập Nhật Trạng Thái Đơn Hàng Thành Hoàn Thành MHQL
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Trạng Thái Đơn Hàng Đã Được Cập Là 3
    [Teardown]    Delete Order From Api

Chuyển trạng thái sang trạng thái Phiếu Tạm
    [Documentation]    Kết Thúc Đơn Đặt Hàng
    [Tags]    AIGenerated    UpdateOrder    Positive    OrderStatus    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0061 Để Cập Nhật
    And Chuẩn Bị Cập Nhật Trạng Thái Đơn Hàng Sang Phiếu Tạm
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Trạng Thái Đơn Hàng Đã Được Cập Là 1
    [Teardown]    Delete Order From Api

Cập Nhập Thông Tin Giao Hàng
    [Documentation]    Cập Nhập Thông Tin Giao Hàng
    [Tags]    AIGenerated    UpdateOrder    Positive        regression
    Given Chuẩn Bị Đơn Hàng HH0053 Có Thông Tin Giao Hàng Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Người Nhận Đơn Hàng MHQL
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Thông Tin Giao Hàng Được Lưu Đúng
    [Teardown]    Delete Order From Api


Cập Nhật Đơn Hàng Phí Giao Hàng
    [Documentation]    Cập Nhật Đơn Hàng Phí Giao Hàng
    [Tags]    AIGenerated    UpdateOrder    Positive    DeliveryFee    regression
    Given Chuẩn Bị Đơn Hàng HH0054 Có Thông Tin Giao Hàng Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Phí Giao Hàng 25000 MHQL
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Phí Giao Hàng Được Cập Nhật Đúng
    [Teardown]    Delete Order From Api

Cập Nhật Đơn Hàng Thu Hộ
    [Documentation]    Cập Nhật Đơn Hàng Thu Hộ
    [Tags]    AIGenerated    UpdateOrder    Positive    DeliveryFee    regression
    Given Chuẩn Bị Đơn Hàng HH0055 Có Thông Tin Giao Hàng Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Không Thu Hộ MHQL
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Không Thu Hộ
    [Teardown]    Delete Order From Api

Cập Nhật Đơn Hàng Mã Vận Đơn
    [Documentation]    Cập Nhật Đơn Hàng Mã Vận Đơn
    [Tags]    AIGenerated    UpdateOrder    Positive    DeliveryFee    regression
    Given Chuẩn Bị Đơn Hàng HH0056 Có Thông Tin Giao Hàng Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Mã Vận Đơn 1234567890 MHQL
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Có Mã Vận Đơn
    [Teardown]    Delete Order From Api

Cập Nhật Đơn Hàng Đối Tác Giao Hàng
    [Documentation]    Cập Nhật Đơn Hàng Đối Tác Giao Hàng
    [Tags]    AIGenerated    UpdateOrder    Positive    DeliveryFee    regression
    Given Chuẩn Bị Đơn Hàng HH0057 Có Thông Tin Giao Hàng Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Đối Tác Giao Hàng DT00002 Ở MHQL
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Có Đối Tác Giao Hàng
    [Teardown]    Delete Order From Api

Cập Nhật Đơn Hàng Gói Hàng
    [Documentation]    Cập Nhật Đơn Hàng Gói Hàng
    [Tags]    AIGenerated    UpdateOrder    Positive    DeliveryFee    regression
    Given Chuẩn Bị Đơn Hàng HH0058 Có Thông Tin Giao Hàng Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Gói Hàng 10x20x30x40 Ở MHQL
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Thông Tin Gói Giao Hàng Được Cập Nhật Đúng
    [Teardown]    Delete Order From Api

Cập Nhật Đơn Hàng Ngày Giao Dự Kiến Và Ghi Chú
    [Documentation]    Cập Nhật Đơn Hàng Ngày Giao Dự Kiến
    [Tags]    AIGenerated    UpdateOrder    Positive    DeliveryFee    regression
    Given Chuẩn Bị Đơn Hàng HH0059 Có Thông Tin Giao Hàng Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Ngày Giao Dự Kiến Và Ghi Chú
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Ngày Giao Dự Kiến Được Cập Nhật Đúng
    And Xác Thực Ghi Chú Giao Hàng Được Cập Nhật Đúng
    [Teardown]    Delete Order From Api
    
    












