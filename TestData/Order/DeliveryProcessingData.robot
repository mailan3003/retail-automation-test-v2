*** Settings ***
Documentation     Dữ liệu test cho chức năng xử lý giao hàng
Resource          ../CommonData.robot
Library           String

*** Variables ***

# Dữ liệu cơ bản cho đơn hàng COD với giao hàng
&{BASE_COD_ORDER_WITH_DELIVERY}
...    Id=0
...    Code=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng COD với giao hàng
...    Total=200000
...    Status=1
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${DEFAULT_USER_ID}
...    UsingCod=1
...    OrderDetails=@{STANDARD_PRODUCT_ORDER_DETAILS_COD}
...    DeliveryDetail=&{STANDARD_DELIVERY_DETAIL}

# Chi tiết sản phẩm cho đơn hàng COD
&{PRODUCT_ORDER_DETAIL_COD}
...    ProductId=${PRODUCT_1}
...    Quantity=2
...    Price=100000
...    Total=200000
...    Discount=0
...    DiscountRatio=0
...    Note=${EMPTY}

@{STANDARD_PRODUCT_ORDER_DETAILS_COD}    &{PRODUCT_ORDER_DETAIL_COD}

# Thông tin giao hàng chuẩn với đối tác mặc định
&{STANDARD_DELIVERY_DETAIL}
...    ReceiverName=Nguyễn Văn A
...    ReceiverPhone=0987654321
...    ReceiverAddress=123 Đường Lê Lợi
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID_1}
...    UseDefaultPartner=${TRUE}
...    DeliveryPrice=20000
...    Status=0
...    Note=Giao hàng trong giờ hành chính

# Thông tin giao hàng tự vận chuyển
&{SELF_DELIVERY_DETAIL}
...    ReceiverName=Trần Thị B
...    ReceiverPhone=0912345678
...    ReceiverAddress=456 Đường Nguyễn Huệ
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID_1}
...    UseDefaultPartner=${FALSE}
...    DeliveryPrice=15000
...    Status=0
...    Note=Tự giao hàng

# Thông tin giao hàng với ánh xạ địa điểm
&{LOCATION_MAPPING_DELIVERY_DETAIL}
...    ReceiverName=Lê Văn C
...    ReceiverPhone=0923456789
...    ReceiverAddress=789 Đường Hai Bà Trưng
...    LocationName=Quận 1
...    WardName=Phường Bến Nghé
...    UseDefaultPartner=${TRUE}
...    DeliveryPrice=25000
...    Status=0

# Thông tin giao hàng với ngày dự kiến
&{EXPECTED_DELIVERY_DETAIL}
...    ReceiverName=Phạm Thị D
...    ReceiverPhone=0934567890
...    ReceiverAddress=321 Đường Võ Văn Tần
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID_1}
...    UseDefaultPartner=${TRUE}
...    ExpectedDelivery=2024-12-31T10:00:00Z
...    DeliveryPrice=30000
...    Status=0

# Gói hàng mẫu
&{DELIVERY_PACKAGE_1}
...    PackageName=Gói 1
...    Weight=2.5
...    Length=30
...    Width=20
...    Height=15
...    Note=Hàng dễ vỡ

&{DELIVERY_PACKAGE_2}
...    PackageName=Gói 2
...    Weight=1.8
...    Length=25
...    Width=15
...    Height=10
...    Note=Hàng thường

@{MULTIPLE_DELIVERY_PACKAGES}    &{DELIVERY_PACKAGE_1}    &{DELIVERY_PACKAGE_2}

# Thông tin giao hàng với nhiều gói
&{MULTIPLE_PACKAGES_DELIVERY_DETAIL}
...    ReceiverName=Hoàng Văn E
...    ReceiverPhone=0945678901
...    ReceiverAddress=654 Đường Pasteur
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID_1}
...    UseDefaultPartner=${TRUE}
...    DeliveryPrice=40000
...    Status=0
...    ListDeliveryPackage=@{MULTIPLE_DELIVERY_PACKAGES}

# Thanh toán phí giao hàng
&{DELIVERY_PAYMENT}
...    Id=0
...    Method=Cash
...    Amount=50000
...    Note=Thanh toán phí giao hàng

# Thông tin giao hàng với thanh toán phí
&{DELIVERY_WITH_PAYMENT_DETAIL}
...    ReceiverName=Vũ Thị F
...    ReceiverPhone=0956789012
...    ReceiverAddress=987 Đường Cách Mạng Tháng 8
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID_1}
...    UseDefaultPartner=${TRUE}
...    DeliveryPrice=50000
...    Status=0
...    DeliveryPayment=&{DELIVERY_PAYMENT}

# Thông tin giao hàng không hợp lệ - đối tác không hoạt động
&{INACTIVE_PARTNER_DELIVERY_DETAIL}
...    ReceiverName=Nguyễn Văn G
...    ReceiverPhone=0967890123
...    ReceiverAddress=111 Đường Điện Biên Phủ
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID_1}
...    UseDefaultPartner=${TRUE}
...    DeliveryBy=${KV_PARTNER_DELIVERY_ID_WRONG_SCOPE}
...    DeliveryPrice=20000
...    Status=0

# Thông tin giao hàng thiếu trường bắt buộc
&{MISSING_REQUIRED_DELIVERY_DETAIL}
...    ReceiverName=${EMPTY}
...    ReceiverPhone=${EMPTY}
...    ReceiverAddress=${EMPTY}
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID_1}
...    UseDefaultPartner=${TRUE}
...    DeliveryPrice=20000
...    Status=0

# Thông tin giao hàng với địa điểm không tồn tại
&{INVALID_LOCATION_DELIVERY_DETAIL}
...    ReceiverName=Lê Thị I
...    ReceiverPhone=0989012345
...    ReceiverAddress=333 Đường Không Tồn Tại
...    LocationName=Quận Không Tồn Tại
...    WardName=Phường Không Có
...    UseDefaultPartner=${TRUE}
...    DeliveryPrice=20000
...    Status=0

# Thông tin giao hàng với ký tự đặc biệt
&{SPECIAL_CHARS_DELIVERY_DETAIL}
...    ReceiverName=Nguyễn Thị Ánh Xuân
...    ReceiverPhone=0901234567
...    ReceiverAddress=606 Đường Võ Thị Sáu, P.Tân Định, Q.1, TP.HCM
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID_1}
...    UseDefaultPartner=${TRUE}
...    DeliveryPrice=20000
...    Note=Giao hàng cho bà Xuân - chú ý: hàng dễ vỡ!
...    Status=0

# Thông tin giao hàng với giá trị null
&{NULL_VALUES_DELIVERY_DETAIL}
...    ReceiverName=Phan Văn U
...    ReceiverPhone=0912345678
...    ReceiverAddress=707 Đường Cách Mạng Tháng 8
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID_1}
...    UseDefaultPartner=${TRUE}
...    DeliveryPrice=25000
...    Weight=${None}
...    Length=${None}
...    Width=${None}
...    Height=${None}
...    ExpectedDelivery=${None}
...    Note=${None}
...    Status=0

# Thông tin giao hàng chi tiết cho log
&{DETAILED_LOGGING_DELIVERY_DETAIL}
...    ReceiverName=Trịnh Văn T
...    ReceiverPhone=0990123456
...    ReceiverAddress=505 Đường Lý Thường Kiệt
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID_1}
...    UseDefaultPartner=${TRUE}
...    DeliveryPrice=50000
...    Weight=3.5
...    Length=40
...    Width=30
...    Height=20
...    ServiceAdd=Giao hàng nhanh
...    ExpectedDelivery=2024-12-25T09:00:00Z
...    Note=Giao hàng cẩn thận
...    Status=0

# Request cơ bản cho đơn hàng COD với giao hàng
&{BASE_COD_ORDER_REQUEST}
...    Order=&{BASE_COD_ORDER_WITH_DELIVERY}
...    Complete=${FALSE}
...    MakeInvoice=${FALSE}

# SQL queries cho xác thực
${QUERY_GET_ORDER_COD}    SELECT Id, Code, UsingCod, Total FROM [Order] WHERE Id = ? AND UsingCod = 1 AND RetailerId = ?
${QUERY_GET_DELIVERY_INFO}    SELECT ReceiverName, ReceiverPhone, ReceiverAddress, UseDefaultPartner, DeliveryPrice FROM DeliveryInfo WHERE OrderId = ? AND RetailerId = ?
${QUERY_GET_DELIVERY_LOG}    SELECT Action, Details FROM AuditTrail WHERE EntityId = ? AND EntityType = 'Order' AND Action LIKE '%Delivery%'
${QUERY_GET_LOCATION_MAPPING}    SELECT LocationId, WardId FROM DeliveryInfo WHERE OrderId = ? AND LocationId IS NOT NULL AND WardId IS NOT NULL
${QUERY_GET_EXPECTED_DELIVERY}    SELECT ExpectedDelivery FROM DeliveryInfo WHERE OrderId = ? AND ExpectedDelivery IS NOT NULL
${QUERY_GET_DELIVERY_PACKAGES}    SELECT COUNT(*) as PackageCount FROM DeliveryPackage WHERE OrderId = ?
${QUERY_GET_DELIVERY_PAYMENT}    SELECT Method, Amount, Note FROM DeliveryPayment WHERE OrderId = ? AND Amount > 0
${QUERY_GET_SELF_DELIVERY}    SELECT ReceiverName, ReceiverPhone, UseDefaultPartner, DeliveryBy FROM DeliveryInfo WHERE OrderId = ? AND UseDefaultPartner = 0
${QUERY_GET_PARTNER_DELIVERY}    SELECT UseDefaultPartner, DeliveryBy FROM DeliveryInfo WHERE OrderId = ? AND UseDefaultPartner = 1
${QUERY_GET_DELIVERY_COUNT}    SELECT COUNT(*) as DeliveryCount FROM DeliveryInfo WHERE OrderId = ? 