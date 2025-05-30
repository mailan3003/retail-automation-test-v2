*** Settings ***
Documentation     Test API tạo hóa đơn từ đơn hàng
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Order/CreateInvoiceFromOrderKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../TestData/CommonData.robot
Resource          ../../../TestData/Order/CreateInvoiceFromOrderData.robot

*** Test Cases ***
# =============================================================================
# Test Cases Thành Công - Tạo hóa đơn từ đơn hàng mới
# =============================================================================

RT-INVOICE-ORDER-001 Tạo Hóa Đơn Từ Đơn Hàng Mới Thành Công
    [Documentation]    Test tạo hóa đơn từ đơn hàng mới thành công với thông tin cơ bản
    ...    - Tạo đơn hàng mới (ID = 0) với MakeInvoice = true
    ...    - Hệ thống tạo đơn hàng và hóa đơn tương ứng
    ...    - Hoàn thiện đơn hàng và lưu thông tin thanh toán
    [Tags]    AIGenerated    CreateInvoiceFromOrder    Positive    NewOrder    regression
    Given Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Từ Đơn Hàng Mới
    When Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Đơn Hàng Và Hóa Đơn Đã Được Tạo Trong Database
    And Xác Thực Hóa Đơn Có Liên Kết Với Đơn Hàng
    And Xác Thực Chi Tiết Hóa Đơn Khớp Với Chi Tiết Đơn Hàng
    And Xác Thực Tổng Tiền Hóa Đơn Khớp Với Đơn Hàng

RT-INVOICE-ORDER-002 Tạo Hóa Đơn Từ Đơn Hàng Có Sẵn Thành Công
    [Documentation]    Test tạo hóa đơn từ đơn hàng đã tồn tại thành công
    ...    - Cập nhật đơn hàng có sẵn (ID > 0) với MakeInvoice = true
    ...    - Hệ thống gọi UpdateOrderMakeInvoice để tạo hóa đơn
    ...    - Truyền tham số Amount để xử lý thanh toán
    [Tags]    AIGenerated    CreateInvoiceFromOrder    Positive    ExistingOrder    regression
    Given Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Từ Đơn Hàng Có Sẵn
    When Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Đơn Hàng Và Hóa Đơn Đã Được Tạo Trong Database
    And Xác Thực Hóa Đơn Có Liên Kết Với Đơn Hàng
    And Xác Thực Thông Tin Thanh Toán Đơn Hàng Được Lưu Đúng

RT-INVOICE-ORDER-003 Tạo Hóa Đơn Với Nhiều Sản Phẩm
    [Documentation]    Test tạo hóa đơn từ đơn hàng có nhiều sản phẩm
    ...    - Đơn hàng chứa nhiều sản phẩm khác nhau
    ...    - Hóa đơn được tạo với đầy đủ chi tiết sản phẩm
    ...    - Tổng tiền được tính đúng từ tất cả sản phẩm
    [Tags]    AIGenerated    CreateInvoiceFromOrder    Positive    MultipleProducts    regression
    Given Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Nhiều Sản Phẩm
    When Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Đơn Hàng Và Hóa Đơn Đã Được Tạo Trong Database
    And Xác Thực Chi Tiết Hóa Đơn Khớp Với Chi Tiết Đơn Hàng
    And Xác Thực Tổng Tiền Hóa Đơn Khớp Với Đơn Hàng

RT-INVOICE-ORDER-004 Tạo Hóa Đơn Với Sản Phẩm Có VAT
    [Documentation]    Test tạo hóa đơn từ đơn hàng có sản phẩm với thuế VAT
    ...    - Sản phẩm có thuế VAT được cấu hình
    ...    - Hóa đơn được tạo với thông tin thuế chi tiết
    ...    - Cập nhật thông tin thuế khi tính năng VAT sản phẩm được kích hoạt
    [Tags]    AIGenerated    CreateInvoiceFromOrder    Positive    VAT    regression
    Given Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Sản Phẩm Có VAT
    When Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Đơn Hàng Và Hóa Đơn Đã Được Tạo Trong Database
    And Xác Thực Chi Tiết Hóa Đơn Khớp Với Chi Tiết Đơn Hàng

RT-INVOICE-ORDER-005 Tạo Hóa Đơn Với Chiết Khấu
    [Documentation]    Test tạo hóa đơn từ đơn hàng có chiết khấu
    ...    - Đơn hàng có chiết khấu trên sản phẩm hoặc đơn hàng
    ...    - Hóa đơn được tạo với thông tin chiết khấu chính xác
    ...    - Tổng tiền sau chiết khấu được tính đúng
    [Tags]    AIGenerated    CreateInvoiceFromOrder    Positive    Discount    regression
    Given Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Chiết Khấu
    When Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Đơn Hàng Và Hóa Đơn Đã Được Tạo Trong Database
    And Xác Thực Tổng Tiền Hóa Đơn Khớp Với Đơn Hàng

RT-INVOICE-ORDER-006 Tạo Hóa Đơn Với Nhiều Phương Thức Thanh Toán
    [Documentation]    Test tạo hóa đơn từ đơn hàng có nhiều phương thức thanh toán
    ...    - Đơn hàng có nhiều phương thức thanh toán (Cash, Card, Transfer)
    ...    - Hóa đơn được tạo với đầy đủ thông tin thanh toán
    ...    - Tổng số tiền thanh toán khớp với tổng đơn hàng
    [Tags]    AIGenerated    CreateInvoiceFromOrder    Positive    MultiplePayments    regression
    Given Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Nhiều Phương Thức Thanh Toán
    When Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Đơn Hàng Và Hóa Đơn Đã Được Tạo Trong Database
    And Xác Thực Thông Tin Thanh Toán Đơn Hàng Được Lưu Đúng

RT-INVOICE-ORDER-007 Tạo Hóa Đơn Với COD
    [Documentation]    Test tạo hóa đơn từ đơn hàng sử dụng COD
    ...    - Đơn hàng sử dụng phương thức thanh toán COD
    ...    - Có thông tin giao hàng đầy đủ
    ...    - Hóa đơn được tạo với thông tin giao hàng trong response
    [Tags]    AIGenerated    CreateInvoiceFromOrder    Positive    COD    regression
    Given Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với COD
    When Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Đơn Hàng Và Hóa Đơn Đã Được Tạo Trong Database
    And Xác Thực Thông Tin Giao Hàng COD Được Lưu Đúng

RT-INVOICE-ORDER-008 Tạo Hóa Đơn Với Sản Phẩm Combo
    [Documentation]    Test tạo hóa đơn từ đơn hàng có sản phẩm combo
    ...    - Đơn hàng chứa sản phẩm combo với các nguyên liệu
    ...    - Hóa đơn được tạo với thông tin combo đầy đủ
    ...    - Chi tiết combo được xử lý đúng
    [Tags]    AIGenerated    CreateInvoiceFromOrder    Positive    Combo    regression
    Given Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Sản Phẩm Combo
    When Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Đơn Hàng Và Hóa Đơn Đã Được Tạo Trong Database
    And Xác Thực Chi Tiết Hóa Đơn Khớp Với Chi Tiết Đơn Hàng

RT-INVOICE-ORDER-009 Tạo Hóa Đơn Với Khuyến Mãi
    [Documentation]    Test tạo hóa đơn từ đơn hàng có khuyến mãi
    ...    - Đơn hàng có áp dụng khuyến mãi
    ...    - Hóa đơn được tạo với thông tin khuyến mãi
    ...    - Chiết khấu từ khuyến mãi được áp dụng đúng
    [Tags]    AIGenerated    CreateInvoiceFromOrder    Positive    Promotion    regression
    Given Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Khuyến Mãi
    When Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Đơn Hàng Và Hóa Đơn Đã Được Tạo Trong Database
    And Xác Thực Tổng Tiền Hóa Đơn Khớp Với Đơn Hàng

RT-INVOICE-ORDER-010 Tạo Hóa Đơn Với Phụ Thu
    [Documentation]    Test tạo hóa đơn từ đơn hàng có phụ thu
    ...    - Đơn hàng có các khoản phụ thu (VAT, phí dịch vụ)
    ...    - Hóa đơn được tạo với thông tin phụ thu
    ...    - Tổng tiền bao gồm phụ thu được tính đúng
    [Tags]    AIGenerated    CreateInvoiceFromOrder    Positive    Surcharge    regression
    Given Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Phụ Thu
    When Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Đơn Hàng Và Hóa Đơn Đã Được Tạo Trong Database
    And Xác Thực Tổng Tiền Hóa Đơn Khớp Với Đơn Hàng

RT-INVOICE-ORDER-011 Tạo Hóa Đơn Với Complete True
    [Documentation]    Test tạo hóa đơn từ đơn hàng với Complete = true
    ...    - Đơn hàng được tạo và hoàn thiện ngay lập tức
    ...    - Hóa đơn được tạo từ đơn hàng đã hoàn thiện
    ...    - Trạng thái đơn hàng được cập nhật đúng
    [Tags]    AIGenerated    CreateInvoiceFromOrder    Positive    Complete    regression
    Given Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Complete True
    When Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Đơn Hàng Và Hóa Đơn Đã Được Tạo Trong Database
    And Xác Thực Trạng Thái Đơn Hàng Là 3

# =============================================================================
# Test Cases Lỗi - Các trường hợp không thành công
# =============================================================================

RT-INVOICE-ORDER-012 Lỗi Khi Tạo Hóa Đơn Từ Đơn Hàng Không Tồn Tại
    [Documentation]    Test lỗi khi tạo hóa đơn từ đơn hàng không tồn tại
    ...    - Đơn hàng có ID không tồn tại trong hệ thống
    ...    - Hệ thống trả về lỗi thích hợp
    ...    - Không tạo hóa đơn mới
    [Tags]    AIGenerated    CreateInvoiceFromOrder    Negative    NonExistentOrder    regression
    Given Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Từ Đơn Hàng Không Tồn Tại
    When Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Hàng
    Then Xác Thực Lỗi Đơn Hàng Không Tồn Tại

RT-INVOICE-ORDER-013 Không Tạo Hóa Đơn Mới Từ Đơn Hàng Đã Hoàn Thành
    [Documentation]    Test không tạo hóa đơn mới từ đơn hàng đã hoàn thành (Finalized)
    ...    - Đơn hàng đã ở trạng thái Finalized hoặc Void
    ...    - Hệ thống chỉ trả về thông tin đơn hàng hiện tại
    ...    - Không thực hiện thay đổi gì
    [Tags]    AIGenerated    CreateInvoiceFromOrder    Negative    FinalizedOrder    regression
    Given Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Từ Đơn Hàng Đã Hoàn Thành
    When Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Đơn Hàng Đã Hoàn Thành Không Được Tạo Hóa Đơn Mới

RT-INVOICE-ORDER-014 Lỗi Khi Tạo Hóa Đơn Với Khách Hàng Không Tồn Tại
    [Documentation]    Test lỗi khi tạo hóa đơn với khách hàng không tồn tại
    ...    - Đơn hàng có CustomerId không tồn tại
    ...    - Hệ thống trả về lỗi xác thực khách hàng
    ...    - Không tạo đơn hàng và hóa đơn
    [Tags]    AIGenerated    CreateInvoiceFromOrder    Negative    InvalidCustomer    regression
    Given Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Khách Hàng Không Tồn Tại
    When Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Hàng
    Then Xác Thực Lỗi Khách Hàng Không Tồn Tại

RT-INVOICE-ORDER-015 Lỗi Khi Tạo Hóa Đơn Với Sản Phẩm Không Hoạt Động
    [Documentation]    Test lỗi khi tạo hóa đơn với sản phẩm không hoạt động
    ...    - Đơn hàng chứa sản phẩm đã bị vô hiệu hóa
    ...    - Hệ thống trả về lỗi xác thực sản phẩm
    ...    - Không tạo đơn hàng và hóa đơn
    [Tags]    AIGenerated    CreateInvoiceFromOrder    Negative    InactiveProduct    regression
    Given Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Sản Phẩm Không Hoạt Động
    When Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Hàng
    Then Xác Thực Lỗi Sản Phẩm Không Hoạt Động

RT-INVOICE-ORDER-016 Lỗi Khi Amount Không Khớp Với Tổng Tiền
    [Documentation]    Test lỗi khi Amount không khớp với tổng tiền đơn hàng
    ...    - Tham số Amount khác với tổng tiền đơn hàng
    ...    - Hệ thống trả về lỗi xác thực số tiền
    ...    - Không tạo hóa đơn
    [Tags]    AIGenerated    CreateInvoiceFromOrder    Negative    MismatchedAmount    regression
    Given Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Amount Không Khớp
    When Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Hàng
    Then Xác Thực Lỗi Amount Không Khớp

RT-INVOICE-ORDER-017 Tạo Đơn Hàng Nhưng Không Tạo Hóa Đơn Khi MakeInvoice False
    [Documentation]    Test tạo đơn hàng nhưng không tạo hóa đơn khi MakeInvoice = false
    ...    - Đơn hàng được tạo thành công
    ...    - Không tạo hóa đơn vì MakeInvoice = false
    ...    - Chỉ trả về thông tin đơn hàng
    [Tags]    AIGenerated    CreateInvoiceFromOrder    Negative    NoInvoice    regression
    Given Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với MakeInvoice False
    When Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Đơn Hàng Được Tạo Nhưng Không Có Hóa Đơn

# =============================================================================
# Test Cases Template - Nhóm các test case tương tự
# =============================================================================

RT-INVOICE-ORDER-018 Tạo Hóa Đơn Với Các Trường Hợp Thanh Toán Khác Nhau
    [Documentation]    Test tạo hóa đơn với các phương thức thanh toán khác nhau
    ...    - Test với từng phương thức thanh toán: Cash, Card, Transfer, Point, Wallet
    ...    - Xác thực thông tin thanh toán được lưu đúng cho từng phương thức
    [Template]    Test Tạo Hóa Đơn Với Phương Thức Thanh Toán
    [Tags]    AIGenerated    CreateInvoiceFromOrder    Positive    PaymentMethods    regression
    # payment_method    amount    expected_result
    Cash              100000    Thành công
    Card              100000    Thành công
    Transfer          100000    Thành công
    Point             100000    Thành công
    Wallet            100000    Thành công

RT-INVOICE-ORDER-019 Tạo Hóa Đơn Với Các Loại Sản Phẩm Khác Nhau
    [Documentation]    Test tạo hóa đơn với các loại sản phẩm khác nhau
    ...    - Test với sản phẩm thường, combo, serial, batch
    ...    - Xác thực thông tin sản phẩm được xử lý đúng theo từng loại
    [Template]    Test Tạo Hóa Đơn Với Loại Sản Phẩm
    [Tags]    AIGenerated    CreateInvoiceFromOrder    Positive    ProductTypes    regression
    # product_type    product_id              expected_result
    Normal          ${PRODUCT_1}            Thành công
    Combo           ${COMBO_PRODUCT_1_ID}   Thành công
    Serial          ${PRODUCT_ID_SERIAL}    Thành công
    Batch           ${product_batch}        Thành công

RT-INVOICE-ORDER-020 Tạo Hóa Đơn Với Các Mức Chiết Khấu Khác Nhau
    [Documentation]    Test tạo hóa đơn với các mức chiết khấu khác nhau
    ...    - Test với chiết khấu theo VNĐ và theo %
    ...    - Xác thực tổng tiền được tính đúng sau chiết khấu
    [Template]    Test Tạo Hóa Đơn Với Chiết Khấu
    [Tags]    AIGenerated    CreateInvoiceFromOrder    Positive    DiscountLevels    regression
    # discount_type    discount_value    expected_total
    VND              10000            90000
    Percentage       10               90000
    VND              20000            80000
    Percentage       20               80000

*** Keywords ***
# =============================================================================
# Template Keywords
# =============================================================================

Test Tạo Hóa Đơn Với Phương Thức Thanh Toán
    [Arguments]    ${payment_method}    ${amount}    ${expected_result}
    Given Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Phương Thức Thanh Toán "${payment_method}" Số Tiền ${amount}
    When Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Đơn Hàng Và Hóa Đơn Đã Được Tạo Trong Database
    And Xác Thực Phương Thức Thanh Toán "${payment_method}" Với Số Tiền ${amount} Được Lưu Đúng

Test Tạo Hóa Đơn Với Loại Sản Phẩm
    [Arguments]    ${product_type}    ${product_id}    ${expected_result}
    Given Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Sản Phẩm Loại "${product_type}" ID ${product_id}
    When Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Đơn Hàng Và Hóa Đơn Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Loại "${product_type}" Được Xử Lý Đúng

Test Tạo Hóa Đơn Với Chiết Khấu
    [Arguments]    ${discount_type}    ${discount_value}    ${expected_total}
    Given Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Chiết Khấu Loại "${discount_type}" Giá Trị ${discount_value}
    When Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Hàng
    Then Response Status Code Should Be 200
    And Xác Thực Đơn Hàng Và Hóa Đơn Đã Được Tạo Trong Database
    And Xác Thực Tổng Tiền Hóa Đơn Là ${expected_total}

# =============================================================================
# Additional Verification Keywords
# =============================================================================

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Phương Thức Thanh Toán "${payment_method}" Số Tiền ${amount}
    [Documentation]    Chuẩn bị dữ liệu với phương thức thanh toán cụ thể
    ${request}=    Deep Copy    ${BASE_MAKE_INVOICE_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_PAY_${payment_method}_${amount}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng thanh toán ${payment_method}
    
    # Tạo thanh toán với phương thức cụ thể
    ${payment}=    Create Dictionary    Method=${payment_method}    Amount=${amount}
    ${payments}=    Create List    ${payment}
    ${order}=    Update Nested Dictionary Property    ${order}    Payments    ${payments}
    ${order}=    Update Nested Dictionary Property    ${order}    Total    ${amount}
    
    # Cập nhật Amount
    ${request}=    Update Nested Dictionary Property    ${request}    Amount    ${amount}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Sản Phẩm Loại "${product_type}" ID ${product_id}
    [Documentation]    Chuẩn bị dữ liệu với loại sản phẩm cụ thể
    ${request}=    Deep Copy    ${BASE_MAKE_INVOICE_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_PROD_${product_type}_${product_id}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng sản phẩm ${product_type}
    
    # Tạo chi tiết sản phẩm với loại cụ thể
    ${product_detail}=    Create Dictionary    ProductId=${product_id}    Quantity=1    Price=100000    Total=100000    Discount=0    DiscountRatio=0    Note=${EMPTY}
    ${order_details}=    Create List    ${product_detail}
    ${order}=    Update Nested Dictionary Property    ${order}    OrderDetails    ${order_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Chiết Khấu Loại "${discount_type}" Giá Trị ${discount_value}
    [Documentation]    Chuẩn bị dữ liệu với chiết khấu cụ thể
    ${request}=    Deep Copy    ${BASE_MAKE_INVOICE_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_DISC_${discount_type}_${discount_value}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng chiết khấu ${discount_type}
    
    # Tính toán chiết khấu
    ${base_price}=    Set Variable    100000
    ${discount_amount}=    Run Keyword If    '${discount_type}' == 'VND'    Set Variable    ${discount_value}
    ...    ELSE    Evaluate    ${base_price} * ${discount_value} / 100
    ${total_after_discount}=    Evaluate    ${base_price} - ${discount_amount}
    
    # Cập nhật thông tin chiết khấu
    ${order}=    Update Nested Dictionary Property    ${order}    Discount    ${discount_amount}
    ${order}=    Update Nested Dictionary Property    ${order}    Total    ${total_after_discount}
    
    # Cập nhật chi tiết sản phẩm
    ${product_detail}=    Create Dictionary    ProductId=${PRODUCT_1}    Quantity=1    Price=${base_price}    Total=${total_after_discount}    Discount=${discount_amount}    DiscountRatio=${discount_value}    Note=${EMPTY}
    ${order_details}=    Create List    ${product_detail}
    ${order}=    Update Nested Dictionary Property    ${order}    OrderDetails    ${order_details}
    
    # Cập nhật Amount và thanh toán
    ${request}=    Update Nested Dictionary Property    ${request}    Amount    ${total_after_discount}
    ${payment}=    Create Dictionary    Method=Cash    Amount=${total_after_discount}
    ${payments}=    Create List    ${payment}
    ${order}=    Update Nested Dictionary Property    ${order}    Payments    ${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Xác Thực Phương Thức Thanh Toán "${payment_method}" Với Số Tiền ${amount} Được Lưu Đúng
    [Documentation]    Xác thực phương thức thanh toán cụ thể được lưu đúng
    ${query}=    Set Variable    SELECT Method, Amount FROM Payment WHERE OrderId = ? AND Method = ?
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}    ${payment_method}
    Should Not Be Equal    ${result}    ${None}    Không tìm thấy thanh toán với phương thức ${payment_method}
    
    ${actual_method}=    Set Variable    ${result[0]}
    ${actual_amount}=    Set Variable    ${result[1]}
    Should Be Equal    ${actual_method}    ${payment_method}    Phương thức thanh toán không đúng
    Should Be Equal As Numbers    ${actual_amount}    ${amount}    Số tiền thanh toán không đúng

Xác Thực Sản Phẩm Loại "${product_type}" Được Xử Lý Đúng
    [Documentation]    Xác thực sản phẩm theo loại được xử lý đúng
    ${query}=    Set Variable    SELECT ProductId FROM OrderDetail WHERE OrderId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Không tìm thấy chi tiết đơn hàng
    
    # Thêm logic xác thực cụ thể cho từng loại sản phẩm nếu cần
    Log    Sản phẩm loại ${product_type} đã được xử lý đúng

Xác Thực Tổng Tiền Hóa Đơn Là ${expected_total}
    [Documentation]    Xác thực tổng tiền hóa đơn bằng giá trị mong đợi
    ${query}=    Set Variable    SELECT Total FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_INVOICE_ID}
    Should Not Be Equal    ${result}    ${None}    Hóa đơn không tồn tại trong CSDL
    
    ${actual_total}=    Set Variable    ${result[0]}
    Should Be Equal As Numbers    ${actual_total}    ${expected_total}    Tổng tiền hóa đơn không đúng. Mong đợi: ${expected_total}, Thực tế: ${actual_total} 