*** Settings ***
Documentation     Dữ liệu cho test cases cập nhật thông tin giao hàng
Resource          ../CommonData.robot

*** Variables ***
# Dữ liệu cập nhật vận chuyển cơ bản
&{STANDARD_DELIVERY_UPDATE}    
...    InvoiceId=${EXISTENT_INVOICE_ID}    
...    Status=2    
...    Description=Cập nhật trạng thái đang giao hàng

# Thông tin người nhận cập nhật
&{UPDATED_RECEIVER_INFO}    
...    ReceiverName=Nguyễn Thị B    
...    ReceiverPhone=0912345678    
...    ReceiverAddress=456 Đường Lê Lợi, Q3    
...    LocationId=${DEFAULT_LOCATION_ID}    
...    WardId=${DEFAULT_WARD_ID}    
...    Note=Gọi trước khi giao 30 phút

# Thông tin cập nhật phí giao hàng
&{UPDATED_SHIPPING_FEE}    
...    ShippingFee=35000    
...    Note=Điều chỉnh phí do khu vực xa

# Thông tin cập nhật miễn phí giao hàng
&{UPDATED_FREE_SHIPPING}    
...    ShippingFee=0    
...    IsFreeShip=${TRUE}    
...    Note=Khách VIP, miễn phí giao hàng

# Cập nhật trạng thái giao hàng
&{DELIVERY_STATUS_PROCESSING}    
...    Status=${STATUS_PROCESSING}    
...    Note=Đang giao hàng

&{DELIVERY_STATUS_COMPLETED}    
...    Status=${STATUS_COMPLETED}    
...    Note=Đã giao hàng thành công

&{DELIVERY_STATUS_CANCELLED}    
...    Status=${STATUS_CANCELLED}    
...    Note=Đã hủy giao hàng theo yêu cầu khách

# Cập nhật mã vận đơn
&{UPDATED_TRACKING_CODE}    
...    TrackingCode=TRACK123456789    
...    Note=Đã cập nhật mã vận đơn mới

# Cập nhật đối tác giao hàng
&{UPDATED_DELIVERY_PARTNER}    
...    DeliveryBy=2    
...    PartnerId=${DELIVERY_PARTNER_2}    
...    Note=Chuyển sang đối tác giao hàng khác

# Cập nhật thông tin giao một phần
&{PARTIAL_DELIVERY_INFO}    
...    IsPartialDelivery=${TRUE}    
...    PartialDeliveryAmount=50000    
...    Note=Giao một phần sản phẩm

# Cập nhật ngày giao dự kiến
&{EXPECTED_DELIVERY_DATE}    
...    ExpectedDeliveryDate=2024-06-15    
...    Note=Dự kiến giao vào ngày 15/06/2024

# Cập nhật với mã hóa đơn không tồn tại
&{NONEXISTENT_INVOICE_UPDATE}    
...    InvoiceId=${NONEXISTENT_INVOICE_ID}    
...    Status=2    
...    Description=Cập nhật trạng thái đang giao hàng

# Cập nhật với trạng thái không hợp lệ
&{INVALID_STATUS_UPDATE}    
...    InvoiceId=${EXISTENT_INVOICE_ID}    
...    Status=9    
...    Description=Cập nhật trạng thái không hợp lệ 