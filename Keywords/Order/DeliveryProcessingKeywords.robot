*** Settings ***
Documentation     Keywords cho test API xử lý giao hàng
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Order/DeliveryProcessingData.robot
Resource          ../../TestData/Order/CreateOrderData.robot
Resource          ../Product/Product_KeywordsCommand.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           Collections
Library           DateTime
Library           json

*** Variables ***
${CREATE_ORDER_ENDPOINT}    orders

*** Keywords ***
# Keywords chuẩn bị dữ liệu
Chuẩn Bị Dữ Liệu Đơn Hàng Có Thông Tin Giao Hàng
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${request}=   Deep Copy   ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Dictionary Property    ${request}    PurchaseDate    ${purchase_date}
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${order_details}=   Deep Copy   ${PRODUCT_ORDER_DETAIL}
    ${request}  Update Dictionary Property    ${request}    OrderDetails    ${order_details}
    ${delivery_info}=   Deep Copy   ${BASIC_DELIVERY_INFO}
    ${request}  Update Dictionary Property    ${request}    DeliveryInfo    ${delivery_info}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Đơn Hàng COD Với Đối Tác Mặc Định
    ${request}=    Deep Copy    ${BASE_COD_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng COD với đối tác mặc định
    ${order}=    Update Nested Dictionary Property    ${order}    DeliveryDetail    ${STANDARD_DELIVERY_DETAIL}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng COD Tự Vận Chuyển
    ${request}=    Deep Copy    ${BASE_COD_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng tự vận chuyển
    ${order}=    Update Nested Dictionary Property    ${order}    Total    150000
    ${order}=    Update Nested Dictionary Property    ${order}    DeliveryDetail    ${SELF_DELIVERY_DETAIL}
    
    # Cập nhật chi tiết sản phẩm
    ${product_detail}=    Create Dictionary    ProductId=${PRODUCT_2}    Quantity=1    Price=150000    Total=150000    Discount=0    DiscountRatio=0    Note=${EMPTY}
    ${order_details}=    Create List    ${product_detail}
    ${order}=    Update Nested Dictionary Property    ${order}    OrderDetails    ${order_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Ánh Xạ Địa Điểm
    ${request}=    Deep Copy    ${BASE_COD_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng với ánh xạ địa điểm
    ${order}=    Update Nested Dictionary Property    ${order}    Total    300000
    ${order}=    Update Nested Dictionary Property    ${order}    DeliveryDetail    ${LOCATION_MAPPING_DELIVERY_DETAIL}
    
    # Cập nhật chi tiết sản phẩm
    ${product_detail}=    Create Dictionary    ProductId=${PRODUCT_1}    Quantity=3    Price=100000    Total=300000    Discount=0    DiscountRatio=0    Note=${EMPTY}
    ${order_details}=    Create List    ${product_detail}
    ${order}=    Update Nested Dictionary Property    ${order}    OrderDetails    ${order_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Ngày Giao Hàng Dự Kiến
    ${request}=    Deep Copy    ${BASE_COD_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng với ngày giao hàng dự kiến
    ${order}=    Update Nested Dictionary Property    ${order}    Total    250000
    ${order}=    Update Nested Dictionary Property    ${order}    DeliveryDetail    ${EXPECTED_DELIVERY_DETAIL}
    
    # Cập nhật chi tiết sản phẩm
    ${product_detail}=    Create Dictionary    ProductId=${PRODUCT_2}    Quantity=1    Price=250000    Total=250000    Discount=0    DiscountRatio=0    Note=${EMPTY}
    ${order_details}=    Create List    ${product_detail}
    ${order}=    Update Nested Dictionary Property    ${order}    OrderDetails    ${order_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Gói Hàng
    ${request}=    Deep Copy    ${BASE_COD_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng với nhiều gói hàng
    ${order}=    Update Nested Dictionary Property    ${order}    Total    500000
    ${order}=    Update Nested Dictionary Property    ${order}    DeliveryDetail    ${MULTIPLE_PACKAGES_DELIVERY_DETAIL}
    
    # Cập nhật chi tiết sản phẩm
    ${product_detail_1}=    Create Dictionary    ProductId=${PRODUCT_1}    Quantity=2    Price=150000    Total=300000    Discount=0    DiscountRatio=0    Note=${EMPTY}
    ${product_detail_2}=    Create Dictionary    ProductId=${PRODUCT_2}    Quantity=1    Price=200000    Total=200000    Discount=0    DiscountRatio=0    Note=${EMPTY}
    ${order_details}=    Create List    ${product_detail_1}    ${product_detail_2}
    ${order}=    Update Nested Dictionary Property    ${order}    OrderDetails    ${order_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Thanh Toán Phí Giao Hàng
    ${request}=    Deep Copy    ${BASE_COD_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng với thanh toán phí giao hàng
    ${order}=    Update Nested Dictionary Property    ${order}    Total    350000
    ${order}=    Update Nested Dictionary Property    ${order}    DeliveryDetail    ${DELIVERY_WITH_PAYMENT_DETAIL}
    
    # Cập nhật chi tiết sản phẩm
    ${product_detail}=    Create Dictionary    ProductId=${PRODUCT_1}    Quantity=3    Price=100000    Total=300000    Discount=0    DiscountRatio=0    Note=${EMPTY}
    ${order_details}=    Create List    ${product_detail}
    ${order}=    Update Nested Dictionary Property    ${order}    OrderDetails    ${order_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Đối Tác Không Hoạt Động
    ${request}=    Deep Copy    ${BASE_COD_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng với đối tác không hoạt động
    ${order}=    Update Nested Dictionary Property    ${order}    DeliveryDetail    ${INACTIVE_PARTNER_DELIVERY_DETAIL}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng COD Không Được Phép
    ${request}=    Deep Copy    ${BASE_COD_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng COD không được phép
    ${delivery_detail}=    Create Dictionary    
    ...    ReceiverName=Trần Văn H    
    ...    ReceiverPhone=0978901234    
    ...    ReceiverAddress=222 Đường Lý Tự Trọng    
    ...    LocationId=${DEFAULT_LOCATION_ID}    
    ...    WardId=${DEFAULT_WARD_ID_1}    
    ...    UseDefaultPartner=${TRUE}    
    ...    DeliveryPrice=20000    
    ...    Status=0
    ${order}=    Update Nested Dictionary Property    ${order}    DeliveryDetail    ${delivery_detail}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Thiếu Thông Tin Giao Hàng
    ${request}=    Deep Copy    ${BASE_COD_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng thiếu thông tin giao hàng
    ${order}=    Update Nested Dictionary Property    ${order}    DeliveryDetail    ${MISSING_REQUIRED_DELIVERY_DETAIL}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Địa Điểm Không Tồn Tại
    ${request}=    Deep Copy    ${BASE_COD_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng với địa điểm không tồn tại
    ${order}=    Update Nested Dictionary Property    ${order}    DeliveryDetail    ${INVALID_LOCATION_DELIVERY_DETAIL}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Không COD Có Thông Tin Giao Hàng
    ${request}=    Deep Copy    ${BASE_COD_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng không COD có thông tin giao hàng
    ${order}=    Update Nested Dictionary Property    ${order}    Total    300000
    ${order}=    Update Nested Dictionary Property    ${order}    UsingCod    0
    
    # Cập nhật chi tiết sản phẩm
    ${product_detail}=    Create Dictionary    ProductId=${PRODUCT_1}    Quantity=3    Price=100000    Total=300000    Discount=0    DiscountRatio=0    Note=${EMPTY}
    ${order_details}=    Create List    ${product_detail}
    ${order}=    Update Nested Dictionary Property    ${order}    OrderDetails    ${order_details}
    
    ${delivery_detail}=    Create Dictionary    
    ...    ReceiverName=Ngô Văn S    
    ...    ReceiverPhone=0989012345    
    ...    ReceiverAddress=404 Đường Đinh Tiên Hoàng    
    ...    LocationId=${DEFAULT_LOCATION_ID}    
    ...    WardId=${DEFAULT_WARD_ID_1}    
    ...    UseDefaultPartner=${TRUE}    
    ...    DeliveryPrice=30000    
    ...    Status=0
    ${order}=    Update Nested Dictionary Property    ${order}    DeliveryDetail    ${delivery_detail}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng COD Không Có Thông Tin Giao Hàng
    ${request}=    Deep Copy    ${BASE_COD_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng COD không có thông tin giao hàng
    ${order}=    Update Nested Dictionary Property    ${order}    Total    250000
    
    # Xóa thông tin giao hàng
    Remove From Dictionary    ${order}    DeliveryDetail
    
    # Cập nhật chi tiết sản phẩm
    ${product_detail}=    Create Dictionary    ProductId=${PRODUCT_2}    Quantity=1    Price=250000    Total=250000    Discount=0    DiscountRatio=0    Note=${EMPTY}
    ${order_details}=    Create List    ${product_detail}
    ${order}=    Update Nested Dictionary Property    ${order}    OrderDetails    ${order_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Để Kiểm Tra Log Giao Hàng
    ${request}=    Deep Copy    ${BASE_COD_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng để kiểm tra log giao hàng
    ${order}=    Update Nested Dictionary Property    ${order}    Total    450000
    ${order}=    Update Nested Dictionary Property    ${order}    DeliveryDetail    ${DETAILED_LOGGING_DELIVERY_DETAIL}
    
    # Cập nhật chi tiết sản phẩm
    ${product_detail}=    Create Dictionary    ProductId=${PRODUCT_1}    Quantity=4    Price=100000    Total=400000    Discount=0    DiscountRatio=0    Note=${EMPTY}
    ${order_details}=    Create List    ${product_detail}
    ${order}=    Update Nested Dictionary Property    ${order}    OrderDetails    ${order_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Ký Tự Đặc Biệt
    ${request}=    Deep Copy    ${BASE_COD_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng với ký tự đặc biệt
    ${order}=    Update Nested Dictionary Property    ${order}    Total    320000
    ${order}=    Update Nested Dictionary Property    ${order}    DeliveryDetail    ${SPECIAL_CHARS_DELIVERY_DETAIL}
    
    # Cập nhật chi tiết sản phẩm
    ${product_detail}=    Create Dictionary    ProductId=${PRODUCT_1}    Quantity=3    Price=100000    Total=300000    Discount=0    DiscountRatio=0    Note=${EMPTY}
    ${order_details}=    Create List    ${product_detail}
    ${order}=    Update Nested Dictionary Property    ${order}    OrderDetails    ${order_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Giá Trị Null
    ${request}=    Deep Copy    ${BASE_COD_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng với giá trị null
    ${order}=    Update Nested Dictionary Property    ${order}    Total    280000
    ${order}=    Update Nested Dictionary Property    ${order}    DeliveryDetail    ${NULL_VALUES_DELIVERY_DETAIL}
    
    # Cập nhật chi tiết sản phẩm
    ${product_detail}=    Create Dictionary    ProductId=${PRODUCT_2}    Quantity=1    Price=280000    Total=280000    Discount=0    DiscountRatio=0    Note=${EMPTY}
    ${order_details}=    Create List    ${product_detail}
    ${order}=    Update Nested Dictionary Property    ${order}    OrderDetails    ${order_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# Keywords gửi yêu cầu API

# Keywords xác thực

Xác Thực Đơn Hàng COD Được Tạo Trong Database
    ${result}=    Fetch One    ${QUERY_GET_ORDER_COD}    ${CREATED_ORDER_ID}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    ${None}    Đơn hàng COD không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[2]}    1    UsingCod phải bằng 1

Xác Thực Thông Tin Giao Hàng Được Lưu Trong Database
    ${result}=    Fetch One    ${QUERY_GET_DELIVERY_INFO}    ${CREATED_ORDER_ID}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    ${None}    Thông tin giao hàng không tồn tại trong CSDL
    Should Not Be Empty    ${result[0]}    ReceiverName không được rỗng
    Should Not Be Empty    ${result[1]}    ReceiverPhone không được rỗng
    Should Not Be Empty    ${result[2]}    ReceiverAddress không được rỗng

Xác Thực Thông Tin Giao Hàng Đối Tác Mặc Định
    ${result}=    Fetch One    ${QUERY_GET_PARTNER_DELIVERY}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Thông tin giao hàng đối tác không tồn tại
    Should Be Equal As Numbers    ${result[0]}    1    UseDefaultPartner phải bằng 1

Xác Thực Thông Tin Giao Hàng Tự Vận Chuyển
    ${result}=    Fetch One    ${QUERY_GET_SELF_DELIVERY}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Thông tin tự giao hàng không tồn tại
    Should Be Equal As Numbers    ${result[2]}    0    UseDefaultPartner phải bằng 0

Xác Thực LocationId Và WardId Được Ánh Xạ Đúng
    ${result}=    Fetch One    ${QUERY_GET_LOCATION_MAPPING}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Không tìm thấy thông tin ánh xạ địa điểm
    Should Not Be Equal    ${result[0]}    ${None}    LocationId không được null
    Should Not Be Equal    ${result[1]}    ${None}    WardId không được null

Xác Thực Ngày Giao Hàng Dự Kiến Được Lưu Đúng
    ${result}=    Fetch One    ${QUERY_GET_EXPECTED_DELIVERY}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Ngày giao hàng dự kiến không tồn tại
    Should Not Be Equal    ${result[0]}    ${None}    ExpectedDelivery không được null

Xác Thực Nhiều Gói Hàng Được Lưu
    ${result}=    Fetch One    ${QUERY_GET_DELIVERY_PACKAGES}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Không tìm thấy thông tin gói hàng
    Should Be True    ${result[0]} > 1    Phải có nhiều hơn 1 gói hàng

Xác Thực Thanh Toán Phí Giao Hàng Được Lưu
    ${result}=    Fetch One    ${QUERY_GET_DELIVERY_PAYMENT}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Thanh toán phí giao hàng không tồn tại
    Should Be Equal    ${result[0]}    Cash    Phương thức thanh toán phải là Cash
    Should Be True    ${result[1]} > 0    Số tiền thanh toán phải lớn hơn 0

Xác Thực Không Có Thông Tin Giao Hàng Được Lưu
    ${result}=    Fetch One    ${QUERY_GET_DELIVERY_COUNT}    ${CREATED_ORDER_ID}
    Should Be Equal As Numbers    ${result[0]}    0    Không được có thông tin giao hàng

Xác Thực Log Giao Hàng Được Tạo
    ${result}=    Fetch All    ${QUERY_GET_DELIVERY_LOG}    ${CREATED_ORDER_ID}
    Should Not Be Empty    ${result}    Log giao hàng phải được tạo
    ${log_found}=    Set Variable    ${FALSE}
    FOR    ${log}    IN    @{result}
        ${action}=    Set Variable    ${log[0]}
        Run Keyword If    'Delivery' in '${action}'    Set Variable    ${TRUE}
    END
    Should Be True    ${log_found}    Phải có log liên quan đến giao hàng

Xác Thực Log Chứa Thông Tin Chi Tiết Giao Hàng
    ${result}=    Fetch All    SELECT Details FROM AuditTrail WHERE EntityId = ? AND Details LIKE '%ReceiverName%' AND Details LIKE '%DeliveryPrice%'    ${CREATED_ORDER_ID}
    Should Not Be Empty    ${result}    Log phải chứa thông tin chi tiết giao hàng

Xác Thực Ký Tự Đặc Biệt Được Lưu Đúng
    ${result}=    Fetch One    SELECT ReceiverName, ReceiverAddress, Note FROM DeliveryInfo WHERE OrderId = ?    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Thông tin giao hàng không tồn tại
    Should Contain    ${result[0]}    Ánh Xuân    Tên người nhận phải chứa ký tự đặc biệt
    Should Contain    ${result[2]}    bà Xuân    Ghi chú phải chứa ký tự đặc biệt

Xác Thực Các Trường Null Được Xử Lý Đúng
    ${result}=    Fetch One    SELECT Weight, Length, Width, Height, ExpectedDelivery, Note FROM DeliveryInfo WHERE OrderId = ?    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Thông tin giao hàng không tồn tại
    # Các trường null được chấp nhận và không gây lỗi

# Keywords xác thực lỗi

Phản Hồi Phải Chứa Lỗi Đối Tác Giao Hàng Không Hoạt Động
    Response Should Have Error    Đối tác giao hàng không hoạt động hoặc không hỗ trợ dịch vụ COD

Phản Hồi Phải Chứa Lỗi Cấu Hình COD Không Được Phép
    Response Should Have Error    Cấu hình hệ thống không cho phép sử dụng COD với đối tác KiotViet

Phản Hồi Phải Chứa Lỗi Thiếu Thông Tin Bắt Buộc
    Response Should Have Error    Thông tin người nhận, số điện thoại và địa chỉ giao hàng là bắt buộc

Phản Hồi Phải Chứa Lỗi Địa Điểm Không Hợp Lệ
    Response Should Have Error    Không tìm thấy thông tin địa điểm hoặc phường/xã được chỉ định 