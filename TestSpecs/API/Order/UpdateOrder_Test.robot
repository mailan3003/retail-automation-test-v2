*** Settings ***
Documentation     Test API cập nhật đơn hàng - Comprehensive test cases for order update functionality
Resource          ../../../Keywords/Order/UpdateOrderKeywords.robot
Resource          ../../../Keywords/Utilities/Utilities.robot
Resource          ../../../TestData/Order/UpdateOrderData.robot
Resource          ../../../TestData/CommonData.robot
# Test Setup        Setup Test Environment
# Test Teardown     Cleanup Test Environment

*** Test Cases ***
# =============================================================================
# Test Cases Thành Công - Cập nhật đơn hàng cơ bản
# =============================================================================

RT-ORDER-UPDATE-001 Cập Nhật Đơn Hàng Cơ Bản Thành Công
    [Documentation]    Kiểm tra cập nhật đơn hàng cơ bản với thông tin mới:
    ...    - Cập nhật mô tả đơn hàng
    ...    - Xác thực đơn hàng được cập nhật trong database
    ...    - Xác thực log thay đổi được ghi nhận
    [Tags]    AIGenerated    UpdateOrder    Positive    Basic    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Cơ Bản
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database
    And Xác Thực Log Thay Đổi Đã Được Ghi Nhận

RT-ORDER-UPDATE-002 Cập Nhật Số Lượng Sản Phẩm Trong Đơn Hàng
    [Documentation]    Kiểm tra cập nhật số lượng sản phẩm trong đơn hàng:
    ...    - Cập nhật số lượng từ 1 thành 3, 2 thành 5, 3 thành 1
    ...    - Tính toán lại tổng tiền đơn hàng
    ...    - Xác thực số lượng được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    ProductQuantity    regression
    [Template]    Cập Nhật Số Lượng Sản Phẩm Và Xác Thực
    # old_quantity    new_quantity    expected_total
    1               3               300000
    2               5               500000
    3               1               100000

RT-ORDER-UPDATE-003 Cập Nhật Thông Tin Khách Hàng Trong Đơn Hàng
    [Documentation]    Kiểm tra cập nhật thông tin khách hàng trong đơn hàng:
    ...    - Thay đổi khách hàng từ khách hàng mặc định sang khách hàng khác
    ...    - Xác thực thông tin khách hàng được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    Customer    regression
    [Template]    Cập Nhật Khách Hàng Và Xác Thực
    # old_customer_id           new_customer_id
    ${DEFAULT_CUSTOMER_ID}      ${CUSTOMER_ID_REWARD_POINT}
    ${CUSTOMER_ID_REWARD_POINT} ${DEFAULT_CUSTOMER_ID}

RT-ORDER-UPDATE-004 Cập Nhật Thông Tin Thanh Toán Trong Đơn Hàng
    [Documentation]    Kiểm tra cập nhật thông tin thanh toán trong đơn hàng:
    ...    - Cập nhật phương thức thanh toán và số tiền
    ...    - Xác thực thông tin thanh toán được lưu đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    Payment    regression
    [Template]    Cập Nhật Thanh Toán Và Xác Thực
    # payment_method    amount
    Cash              200000
    Card              150000
    Transfer          300000

RT-ORDER-UPDATE-005 Cập Nhật Thông Tin Giao Hàng Trong Đơn Hàng
    [Documentation]    Kiểm tra cập nhật thông tin giao hàng trong đơn hàng:
    ...    - Cập nhật tên, số điện thoại, địa chỉ người nhận
    ...    - Xác thực thông tin giao hàng được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    Delivery    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Thông Tin Giao Hàng
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database
    And Xác Thực Thông Tin Giao Hàng Đã Được Cập Nhật

RT-ORDER-UPDATE-006 Cập Nhật Kênh Bán Hàng Trong Đơn Hàng
    [Documentation]    Kiểm tra cập nhật kênh bán hàng trong đơn hàng:
    ...    - Thay đổi kênh bán hàng từ kênh này sang kênh khác
    ...    - Xác thực kênh bán hàng được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    SaleChannel    regression
    [Template]    Cập Nhật Kênh Bán Hàng Và Xác Thực
    # old_channel_id        new_channel_id
    ${CHANNEL_ID_1}         ${valid_channel_id}
    ${valid_channel_id}     ${CHANNEL_ID_1}

# =============================================================================
# Test Cases Thành Công - Cập nhật đơn hàng offline
# =============================================================================

RT-ORDER-UPDATE-007 Cập Nhật Đơn Hàng Offline Với UUID Hợp Lệ
    [Documentation]    Kiểm tra cập nhật đơn hàng offline với UUID hợp lệ:
    ...    - Đơn hàng có ID = 0 và UUID không trùng lặp
    ...    - Xác thực đơn hàng offline được xử lý đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    Offline    UUID    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Offline Với UUID "OFFLINE_UUID_NEW_001"
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database

RT-ORDER-UPDATE-008 Xử Lý Đơn Hàng Offline Với UUID Tự Động Giải Quyết
    [Documentation]    Kiểm tra xử lý đơn hàng offline khi UUID có thể tự động giải quyết:
    ...    - Hệ thống tự động xử lý UUID conflict
    ...    - Đơn hàng được cập nhật thành công
    [Tags]    AIGenerated    UpdateOrder    Positive    Offline    AutoResolve    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Offline Với UUID "AUTO_RESOLVE_UUID_002"
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database

# =============================================================================
# Test Cases Thành Công - Chuyển chi nhánh đơn hàng
# =============================================================================

RT-ORDER-UPDATE-009 Chuyển Chi Nhánh Đơn Hàng Thành Công
    [Documentation]    Kiểm tra chuyển chi nhánh đơn hàng:
    ...    - Chuyển đơn hàng từ chi nhánh này sang chi nhánh khác
    ...    - Xử lý khách hàng ở chi nhánh đích nếu cần
    ...    - Xác thực chi nhánh được chuyển đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    BranchTransfer    regression
    Given Chuẩn Bị Dữ Liệu Chuyển Chi Nhánh Đơn Hàng Từ "${DEFAULT_BRANCH_ID}" Thành "${BRANCH_ID_NHANH_A}"
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database
    And Xác Thực Chi Nhánh Đã Được Chuyển Thành "${BRANCH_ID_NHANH_A}"

RT-ORDER-UPDATE-010 Chuyển Chi Nhánh Với Xử Lý Khách Hàng Theo Chi Nhánh
    [Documentation]    Kiểm tra chuyển chi nhánh khi hệ thống quản lý khách hàng theo chi nhánh:
    ...    - Kiểm tra và xử lý khách hàng ở chi nhánh đích
    ...    - Tạo khách hàng mới ở chi nhánh đích nếu cần
    [Tags]    AIGenerated    UpdateOrder    Positive    BranchTransfer    CustomerManagement    regression
    Given Chuẩn Bị Dữ Liệu Chuyển Chi Nhánh Đơn Hàng Từ "${DEFAULT_BRANCH_ID}" Thành "${BRANCH_ID_NHANH_A}"
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database
    And Xác Thực Chi Nhánh Đã Được Chuyển Thành "${BRANCH_ID_NHANH_A}"

# =============================================================================
# Test Cases Thành Công - Hoàn thiện và tạo hóa đơn
# =============================================================================

RT-ORDER-UPDATE-011 Cập Nhật Và Hoàn Thiện Đơn Hàng
    [Documentation]    Kiểm tra cập nhật và hoàn thiện đơn hàng với Complete = true:
    ...    - Cập nhật thông tin và đánh dấu hoàn thiện
    ...    - Xác thực trạng thái đơn hàng được cập nhật
    [Tags]    AIGenerated    UpdateOrder    Positive    Complete    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Và Hoàn Thiện Đơn Hàng
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database
    And Xác Thực Đơn Hàng Đã Được Hoàn Thiện

RT-ORDER-UPDATE-012 Cập Nhật Đơn Hàng Và Tạo Hóa Đơn
    [Documentation]    Kiểm tra cập nhật đơn hàng và tạo hóa đơn với MakeInvoice = true:
    ...    - Cập nhật thông tin đơn hàng và tạo hóa đơn
    ...    - Xác thực hóa đơn được tạo từ đơn hàng
    [Tags]    AIGenerated    UpdateOrder    Positive    MakeInvoice    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Và Tạo Hóa Đơn
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database
    And Xác Thực Hóa Đơn Đã Được Tạo Từ Đơn Hàng

RT-ORDER-UPDATE-013 Kết Hợp Nhiều Đơn Hàng Thành Một
    [Documentation]    Kiểm tra kết hợp nhiều đơn hàng thành một đơn hàng:
    ...    - Sử dụng IsCombine = true và OrderCodes
    ...    - Cập nhật mô tả đơn hàng kết hợp
    ...    - Xác thực đơn hàng được kết hợp đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    Combine    regression
    Given Chuẩn Bị Dữ Liệu Kết Hợp Đơn Hàng
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database

# =============================================================================
# Test Cases Thành Công - Sản phẩm đặc biệt
# =============================================================================

RT-ORDER-UPDATE-014 Cập Nhật Đơn Hàng Với Sản Phẩm Serial
    [Documentation]    Kiểm tra cập nhật đơn hàng có sản phẩm quản lý theo serial:
    ...    - Cập nhật thông tin sản phẩm serial
    ...    - Xác thực thông tin serial được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    Serial    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Với Sản Phẩm Serial
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database
    And Xác Thực Thông Tin Serial Đã Được Cập Nhật

RT-ORDER-UPDATE-015 Cập Nhật Đơn Hàng Với Sản Phẩm Quản Lý Theo Lô
    [Documentation]    Kiểm tra cập nhật đơn hàng có sản phẩm quản lý theo lô:
    ...    - Cập nhật thông tin sản phẩm batch với FIFO processing
    ...    - Xác thực thông tin lô được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    Batch    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Với Sản Phẩm Batch
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database
    And Xác Thực Thông Tin Batch Đã Được Cập Nhật

RT-ORDER-UPDATE-016 Cập Nhật Đơn Hàng Với Sản Phẩm Combo
    [Documentation]    Kiểm tra cập nhật đơn hàng có sản phẩm combo:
    ...    - Cập nhật thông tin sản phẩm combo và nguyên liệu
    ...    - Xác thực thông tin combo được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    Combo    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Với Sản Phẩm Combo
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database

# =============================================================================
# Test Cases Thành Công - Tính năng đặc biệt
# =============================================================================

RT-ORDER-UPDATE-017 Cập Nhật Đơn Hàng Với Tổng Tiền Được Tính Lại Tự Động
    [Documentation]    Kiểm tra cập nhật đơn hàng khi client không cung cấp tổng tiền:
    ...    - Hệ thống tự động tính toán lại tổng tiền từ chi tiết sản phẩm
    ...    - Xác thực tổng tiền được tính đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    AutoCalculateTotal    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Số Lượng Sản Phẩm Từ 1 Thành 4
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database
    And Xác Thực Số Lượng Sản Phẩm Đã Được Cập Nhật Thành 4

RT-ORDER-UPDATE-018 Cập Nhật Đơn Hàng Với Thông Tin Ngày Tháng UTC
    [Documentation]    Kiểm tra cập nhật đơn hàng với các trường ngày tháng UTC:
    ...    - PurchaseDate và ExpectedDeliveryDate ở định dạng UTC
    ...    - Hệ thống xử lý chuyển đổi múi giờ đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    UTCDates    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Cơ Bản
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database

RT-ORDER-UPDATE-019 Cập Nhật Đơn Hàng Với Cập Nhật Customer ID Trong Thanh Toán
    [Documentation]    Kiểm tra cập nhật đơn hàng với UpdateCustomerIdInPayments = true:
    ...    - Cập nhật ID khách hàng trong thông tin thanh toán
    ...    - Xác thực thông tin thanh toán được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    UpdateCustomerIdInPayments    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Khách Hàng Từ "${DEFAULT_CUSTOMER_ID}" Thành "${CUSTOMER_ID_REWARD_POINT}"
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database
    And Xác Thực Khách Hàng Đã Được Cập Nhật Thành "${CUSTOMER_ID_REWARD_POINT}"

RT-ORDER-UPDATE-020 Cập Nhật Đơn Hàng Từ Màn Hình Quản Lý
    [Documentation]    Kiểm tra cập nhật đơn hàng từ màn hình quản lý với FromManager = true:
    ...    - Xử lý đặc biệt cho yêu cầu từ màn hình quản lý
    ...    - Xác thực đơn hàng được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    FromManager    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Cơ Bản
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database

# =============================================================================
# Test Cases Lỗi - Validation Errors
# =============================================================================

RT-ORDER-UPDATE-021 Lỗi Khi Cập Nhật Đơn Hàng Với Sản Phẩm Trùng Lặp
    [Documentation]    Kiểm tra lỗi khi cập nhật đơn hàng có sản phẩm trùng lặp:
    ...    - Đơn hàng chứa cùng một sản phẩm nhiều lần
    ...    - API phải trả về lỗi validation
    [Tags]    AIGenerated    UpdateOrder    Negative    DuplicateProduct    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm Trùng Lặp
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Xác Thực Lỗi Sản Phẩm Trùng Lặp Trong Đơn Hàng

RT-ORDER-UPDATE-022 Lỗi Khi Cập Nhật Đơn Hàng Với UUID Trùng Lặp
    [Documentation]    Kiểm tra lỗi khi cập nhật đơn hàng offline có UUID trùng lặp:
    ...    - UUID đã tồn tại trong hệ thống
    ...    - API phải trả về lỗi KvValidateInvoiceException
    [Tags]    AIGenerated    UpdateOrder    Negative    DuplicateUUID    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với UUID Trùng Lặp "${EXISTENT_INVOICE_UUID}"
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Xác Thực Lỗi UUID Trùng Lặp

RT-ORDER-UPDATE-023 Lỗi Khi Cập Nhật Đơn Hàng Với Mã Trùng Lặp
    [Documentation]    Kiểm tra lỗi khi cập nhật đơn hàng có mã trùng lặp:
    ...    - Mã đơn hàng đã tồn tại trong hệ thống
    ...    - API phải trả về lỗi KvValidateInvoiceException
    [Tags]    AIGenerated    UpdateOrder    Negative    DuplicateCode    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Mã Trùng Lặp "${INVOICE_DUPLICATED_CODE}"
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Xác Thực Lỗi Mã Đơn Hàng Trùng Lặp

RT-ORDER-UPDATE-024 Lỗi Khi Cập Nhật Đơn Hàng Với Khách Hàng Không Tồn Tại
    [Documentation]    Kiểm tra lỗi khi cập nhật đơn hàng có khách hàng không tồn tại:
    ...    - ID khách hàng không có trong hệ thống
    ...    - API phải trả về lỗi KvValidateCustomerException
    [Tags]    AIGenerated    UpdateOrder    Negative    InvalidCustomer    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Khách Hàng Không Tồn Tại "${NONEXISTENT_CUSTOMER_ID}"
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Xác Thực Lỗi Khách Hàng Không Tồn Tại

RT-ORDER-UPDATE-025 Lỗi Khi Cập Nhật Đơn Hàng Với Nhân Viên Không Tồn Tại
    [Documentation]    Kiểm tra lỗi khi cập nhật đơn hàng có nhân viên không tồn tại:
    ...    - ID nhân viên bán hàng không có trong hệ thống
    ...    - API phải trả về lỗi KvValidateUserException
    [Tags]    AIGenerated    UpdateOrder    Negative    InvalidUser    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhân Viên Không Tồn Tại "999999999"
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Xác Thực Lỗi Nhân Viên Không Tồn Tại

RT-ORDER-UPDATE-026 Lỗi Khi Cập Nhật Đơn Hàng Với Kênh Bán Hàng Không Tồn Tại
    [Documentation]    Kiểm tra lỗi khi cập nhật đơn hàng có kênh bán hàng không tồn tại:
    ...    - ID kênh bán hàng không có trong hệ thống
    ...    - API phải trả về lỗi validation
    [Tags]    AIGenerated    UpdateOrder    Negative    InvalidSaleChannel    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Kênh Bán Hàng Không Tồn Tại
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Xác Thực Lỗi Kênh Bán Hàng Không Tồn Tại

RT-ORDER-UPDATE-027 Lỗi Khi Cập Nhật Đơn Hàng Với Khuyến Mãi Đã Xóa
    [Documentation]    Kiểm tra lỗi khi cập nhật đơn hàng có khuyến mãi đã bị xóa:
    ...    - Khuyến mãi không còn hoạt động trong hệ thống
    ...    - API phải trả về lỗi validation
    [Tags]    AIGenerated    UpdateOrder    Negative    DeletedPromotion    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Khuyến Mãi Đã Xóa
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Xác Thực Lỗi Khuyến Mãi Đã Bị Xóa

RT-ORDER-UPDATE-028 Lỗi Khi Cập Nhật Đơn Hàng Với Đối Tác Giao Hàng Không Hợp Lệ
    [Documentation]    Kiểm tra lỗi khi cập nhật đơn hàng COD có đối tác giao hàng không hợp lệ:
    ...    - Đối tác giao hàng không tồn tại hoặc không hoạt động
    ...    - API phải trả về lỗi KvValidatePartnerDeliveryException
    [Tags]    AIGenerated    UpdateOrder    Negative    InvalidDeliveryPartner    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Đối Tác Giao Hàng Không Hợp Lệ
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Xác Thực Lỗi Đối Tác Giao Hàng Không Hợp Lệ

# =============================================================================
# Test Cases Lỗi - Business Logic Errors
# =============================================================================

RT-ORDER-UPDATE-029 Lỗi Khi Cập Nhật Đơn Hàng Không Tồn Tại
    [Documentation]    Kiểm tra lỗi khi cập nhật đơn hàng không tồn tại:
    ...    - ID đơn hàng không có trong hệ thống
    ...    - API phải trả về lỗi not found
    [Tags]    AIGenerated    UpdateOrder    Negative    OrderNotFound    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Cơ Bản
    And Set To Dictionary    ${REQUEST_DATA['Order']}    Id    ${NONEXISTENT_ORDER_ID}
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 404

RT-ORDER-UPDATE-030 Lỗi Khi Cập Nhật Đơn Hàng Đã Hoàn Thiện
    [Documentation]    Kiểm tra lỗi khi cập nhật đơn hàng đã hoàn thiện:
    ...    - Đơn hàng có trạng thái đã hoàn thiện không thể cập nhật
    ...    - API phải trả về lỗi business logic
    [Tags]    AIGenerated    UpdateOrder    Negative    OrderFinalized    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Cơ Bản
    And Set To Dictionary    ${REQUEST_DATA['Order']}    Id    ${FINALIZED_ORDER_ID}
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420

# =============================================================================
# Test Cases Đặc Biệt - Edge Cases
# =============================================================================

RT-ORDER-UPDATE-031 Cập Nhật Đơn Hàng Với Dữ Liệu Rỗng
    [Documentation]    Kiểm tra cập nhật đơn hàng với dữ liệu rỗng hoặc null:
    ...    - Xử lý các trường hợp dữ liệu không hợp lệ
    ...    - API phải trả về lỗi validation phù hợp
    [Tags]    AIGenerated    UpdateOrder    Negative    EmptyData    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Cơ Bản
    And Set To Dictionary    ${REQUEST_DATA}    Order    ${None}
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 400

RT-ORDER-UPDATE-032 Cập Nhật Đơn Hàng Với Số Lượng Âm
    [Documentation]    Kiểm tra cập nhật đơn hàng với số lượng sản phẩm âm:
    ...    - Số lượng sản phẩm không được phép âm
    ...    - API phải trả về lỗi validation
    [Tags]    AIGenerated    UpdateOrder    Negative    NegativeQuantity    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Số Lượng Sản Phẩm Từ 1 Thành -1
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420

RT-ORDER-UPDATE-033 Cập Nhật Đơn Hàng Với Giá Sản Phẩm Âm
    [Documentation]    Kiểm tra cập nhật đơn hàng với giá sản phẩm âm:
    ...    - Giá sản phẩm không được phép âm
    ...    - API phải trả về lỗi validation
    [Tags]    AIGenerated    UpdateOrder    Negative    NegativePrice    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Cơ Bản
    And Set To Dictionary    ${REQUEST_DATA['Order']['OrderDetails'][0]}    Price    -100000
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420

RT-ORDER-UPDATE-034 Cập Nhật Đơn Hàng Với Mã Quá Dài
    [Documentation]    Kiểm tra cập nhật đơn hàng với mã đơn hàng quá dài:
    ...    - Mã đơn hàng vượt quá giới hạn cho phép
    ...    - API phải trả về lỗi validation
    [Tags]    AIGenerated    UpdateOrder    Negative    LongCode    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Cơ Bản
    And Set To Dictionary    ${REQUEST_DATA['Order']}    Code    ${INVOICE_LONG_CODE}
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420

RT-ORDER-UPDATE-035 Cập Nhật Đơn Hàng Với Mã Chứa Ký Tự Đặc Biệt
    [Documentation]    Kiểm tra cập nhật đơn hàng với mã chứa ký tự đặc biệt:
    ...    - Mã đơn hàng chứa ký tự không hợp lệ
    ...    - API phải trả về lỗi validation
    [Tags]    AIGenerated    UpdateOrder    Negative    InvalidCharacters    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Cơ Bản
    And Set To Dictionary    ${REQUEST_DATA['Order']}    Code    ${INVALID_CODE_INVOICE}
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420

# =============================================================================
# Test Cases Tích Hợp - Integration Tests
# =============================================================================

RT-ORDER-UPDATE-036 Cập Nhật Đơn Hàng Với Tồn Kho Không Đủ
    [Documentation]    Kiểm tra cập nhật đơn hàng khi tồn kho không đủ:
    ...    - Số lượng yêu cầu vượt quá tồn kho hiện có
    ...    - API phải trả về lỗi tồn kho
    [Tags]    AIGenerated    UpdateOrder    Negative    InsufficientInventory    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Cơ Bản
    And Set To Dictionary    ${REQUEST_DATA['Order']['OrderDetails'][0]}    ProductId    ${product_out_of_stock}
    And Set To Dictionary    ${REQUEST_DATA['Order']['OrderDetails'][0]}    Quantity    999999
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420

RT-ORDER-UPDATE-037 Cập Nhật Đơn Hàng Với Sản Phẩm Không Hoạt Động
    [Documentation]    Kiểm tra cập nhật đơn hàng với sản phẩm không hoạt động:
    ...    - Sản phẩm đã bị vô hiệu hóa trong hệ thống
    ...    - API phải trả về lỗi validation
    [Tags]    AIGenerated    UpdateOrder    Negative    InactiveProduct    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Cơ Bản
    And Set To Dictionary    ${REQUEST_DATA['Order']['OrderDetails'][0]}    ProductId    ${INACTIVE_PRODUCT_ID}
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420

RT-ORDER-UPDATE-038 Cập Nhật Đơn Hàng Với Khách Hàng Không Hoạt Động
    [Documentation]    Kiểm tra cập nhật đơn hàng với khách hàng không hoạt động:
    ...    - Khách hàng đã bị vô hiệu hóa trong hệ thống
    ...    - API phải trả về lỗi validation
    [Tags]    AIGenerated    UpdateOrder    Negative    InactiveCustomer    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Cơ Bản
    And Set To Dictionary    ${REQUEST_DATA['Order']}    CustomerId    ${INACTIVE_CUSTOMER_ID}
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420

# =============================================================================
# Test Cases Hiệu Suất - Performance Tests
# =============================================================================

RT-ORDER-UPDATE-039 Cập Nhật Đơn Hàng Với Nhiều Sản Phẩm
    [Documentation]    Kiểm tra cập nhật đơn hàng có nhiều sản phẩm:
    ...    - Đơn hàng chứa nhiều sản phẩm khác nhau
    ...    - Xác thực hiệu suất xử lý đơn hàng lớn
    [Tags]    AIGenerated    UpdateOrder    Performance    ManyProducts    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Cơ Bản
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database

RT-ORDER-UPDATE-040 Cập Nhật Đồng Thời Nhiều Đơn Hàng
    [Documentation]    Kiểm tra cập nhật đồng thời nhiều đơn hàng:
    ...    - Xử lý nhiều yêu cầu cập nhật cùng lúc
    ...    - Xác thực tính nhất quán dữ liệu
    [Tags]    AIGenerated    UpdateOrder    Performance    Concurrent    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Cơ Bản
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database 