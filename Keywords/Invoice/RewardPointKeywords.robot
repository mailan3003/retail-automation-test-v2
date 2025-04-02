*** Settings ***
Documentation     Keywords cho test cases API phần tính điểm thưởng
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/RewardPointData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Library           ../../Resources/DatabaseLibrary.py

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    ${data}=    Set Variable    ${STANDARD_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Tích Điểm Theo Hóa Đơn
    [Arguments]    ${money_per_point}=10000
    ${data}=    Set Variable    ${INVOICE_REWARD_TYPE_REQUEST}
    ${invoice}=    Set Variable    ${data.Invoice}
    Set To Dictionary    ${invoice}    MoneyPerPoint=${money_per_point}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Tích Điểm Theo Sản Phẩm
    [Arguments]    ${data}=${PRODUCT_REWARD_TYPE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Có Điểm Thưởng
    [Arguments]    ${point_value}=10    ${product_id}=${PRODUCT_1}
    ${invoice}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    # Cập nhật thông tin sản phẩm với điểm thưởng
    &{product_with_point}=    Create Dictionary
    ...    ProductId=${product_id}
    ...    Quantity=1
    ...    Price=100000
    ...    Point=${point_value}
    
    ${details}=    Create List    ${product_with_point}
    Set To Dictionary    ${invoice.Invoice}    InvoiceDetails=${details}
    Set To Dictionary    ${invoice.Invoice}    RewardPoint_Type=Product
    Set Test Variable    ${REQUEST_DATA}    ${invoice}
    RETURN    ${invoice}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Không Tích Điểm
    ${invoice}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    # Cập nhật thông tin sản phẩm không tích điểm
    &{product_without_point}=    Create Dictionary
    ...    ProductId=${PRODUCT_1}
    ...    Quantity=1
    ...    Price=100000
    ...    UsePoint=False
    
    ${details}=    Create List    ${product_without_point}
    Set To Dictionary    ${invoice.Invoice}    InvoiceDetails=${details}
    Set To Dictionary    ${invoice.Invoice}    RewardPoint_Type=Product
    Set Test Variable    ${REQUEST_DATA}    ${invoice}
    RETURN    ${invoice}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Sản Phẩm Khác Nhau
    ${data}=    Set Variable    ${INVOICE_WITH_MIXED_PRODUCTS_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu
    [Arguments]    ${include_discount_in_point}=True    ${discount_amount}=10000
    ${data}=    Set Variable    ${INVOICE_WITH_DISCOUNT_REQUEST}
    Set To Dictionary    ${data.Invoice}    Discount=${discount_amount}
    Set To Dictionary    ${data.Invoice}    RewardPoint_ForDiscountInvoice=${include_discount_in_point}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Không Tích Điểm Trên Giá Đã Giảm
    ${data}=    Set Variable    ${INVOICE_NO_DISCOUNT_POINT_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Điểm
    [Arguments]    ${promotion_point}=20
    ${data}=    Set Variable    ${INVOICE_WITH_PROMOTION_POINT_REQUEST}
    # Cập nhật giá trị điểm khuyến mãi
    Set To Dictionary    ${data.Promotions}    PromotionValue=${promotion_point}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Điểm Theo Sản Phẩm
    [Arguments]    ${promotion_point}=5    ${product_id}=${PRODUCT_1}
    ${data}=    Set Variable    ${INVOICE_WITH_PRODUCT_PROMOTION_REQUEST}
    # Cập nhật giá trị điểm khuyến mãi và sản phẩm
    Set To Dictionary    ${data.Promotions}    PromotionValue=${promotion_point}
    Set To Dictionary    ${data.Promotions}    ProductId=${product_id}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Không Có Khách Hàng
    ${data}=    Set Variable    ${INVOICE_WITHOUT_CUSTOMER_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Bằng Điểm
    [Arguments]    ${point_amount}=20000    ${include_point_in_reward}=True
    ${data}=    Set Variable    ${INVOICE_WITH_POINT_PAYMENT_REQUEST}
    # Cập nhật số điểm dùng để thanh toán
    Set To Dictionary    ${data.Payments[0]}    Amount=${point_amount}
    Set To Dictionary    ${data.Invoice}    RewardPoint_ForInvoiceUsingRewardPoint=${include_point_in_reward}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Bằng Voucher
    [Arguments]    ${voucher_amount}=20000    ${include_voucher_in_reward}=True
    ${data}=    Set Variable    ${INVOICE_WITH_VOUCHER_REQUEST}
    # Cập nhật số tiền voucher
    Set To Dictionary    ${data.Payments[0]}    Amount=${voucher_amount}
    Set To Dictionary    ${data.Invoice}    RewardPoint_ForInvoiceUsingVoucher=${include_voucher_in_reward}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Phụ Phí Và Thuế
    [Arguments]    ${surcharge}=5000    ${tax}=10000
    ${data}=    Set Variable    ${INVOICE_WITH_SURCHARGE_TAX_REQUEST}
    # Cập nhật phụ phí và thuế
    Set To Dictionary    ${data.Invoice}    Surcharge=${surcharge}
    Set To Dictionary    ${data.Invoice}    TotalTax=${tax}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhóm Khách Hàng
    [Arguments]    ${money_per_point}=5000    ${customer_group_id}=1001
    ${data}=    Set Variable    ${INVOICE_WITH_CUSTOMER_GROUP_REQUEST}
    # Cập nhật thông tin nhóm khách hàng và tỷ lệ tiền/điểm
    Set To Dictionary    ${data.Invoice}    MoneyPerPoint=${money_per_point}
    Set To Dictionary    ${data.Invoice}    CustomerGroupId=${customer_group_id}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Cả Khuyến Mãi Hóa Đơn Và Sản Phẩm
    [Arguments]    ${invoice_promotion_point}=20    ${product_promotion_point}=5
    ${data}=    Set Variable    ${INVOICE_WITH_BOTH_PROMOTIONS_REQUEST}
    # Cập nhật giá trị điểm khuyến mãi
    Set To Dictionary    ${data.Promotions}    PromotionValue=${invoice_promotion_point}
    Set To Dictionary    ${data.ProductPromotions}    PromotionValue=${product_promotion_point}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Gửi Yêu Cầu Tạo Hóa Đơn
    ${response}=    Call API    invoices    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}

Tính Điểm Thưởng Dự Kiến Theo Hóa Đơn
    [Arguments]    ${total}=100000    ${money_per_point}=10000    ${surcharge}=0    ${tax}=0    ${discount_included}=True    ${discount}=0
    
    # Tính tổng tiền dùng để tính điểm
    ${point_amount}=    Set Variable    ${total}
    
    # Trừ phụ phí và thuế
    ${point_amount}=    Evaluate    ${point_amount} - ${surcharge} - ${tax}
    
    # Nếu không tính điểm trên chiết khấu và có chiết khấu
    ${discount_amount}=    Set Variable    ${0}
    IF    ${discount_included} == ${FALSE} and ${discount} > ${0}
        ${discount_amount}=    Set Variable    ${discount}
        ${point_amount}=    Evaluate    ${point_amount} + ${discount}
    END
    
    # Tính điểm = Tổng tiền chia cho giá trị tiền của 1 điểm, làm tròn xuống
    ${expected_point}=    Evaluate    math.floor(${point_amount} / ${money_per_point})    math
    
    RETURN    ${expected_point}

Tính Điểm Thưởng Dự Kiến Theo Sản Phẩm
    [Arguments]    ${point}=10    ${quantity}=1    ${use_point}=True
    
    # Nếu không tích điểm cho sản phẩm
    IF    ${use_point} == ${FALSE}
        RETURN    0
    END
    
    # Tính điểm = Số điểm mỗi sản phẩm nhân với số lượng
    ${expected_point}=    Evaluate    ${point} * ${quantity}
    
    RETURN    ${expected_point}

Tính Tổng Điểm Thưởng Dự Kiến
    [Arguments]    ${invoice_point}=0    ${promotion_point}=0    ${product_point}=0
    
    # Tính tổng điểm = điểm từ hóa đơn + điểm từ khuyến mãi + điểm từ sản phẩm
    ${total_point}=    Evaluate    ${invoice_point} + ${promotion_point} + ${product_point}
    
    RETURN    ${total_point}

Tính Tổng Điểm Từ Nhiều Sản Phẩm
    [Arguments]    @{product_points}
    
    ${total}=    Set Variable    ${0}
    FOR    ${point}    IN    @{product_points}
        ${total}=    Evaluate    ${total} + ${point}
    END
    
    RETURN    ${total}

Xác Thực Điểm Thưởng Trong Hóa Đơn
    [Arguments]    ${invoice_id}    ${expected_point}
    ${query}=    Set Variable    SELECT Point FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy hóa đơn ID ${invoice_id} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_point}    Điểm thưởng trong hóa đơn không chính xác. Mong đợi: ${expected_point}, Thực tế: ${result[0]}

Xác Thực Điểm Thưởng Chi Tiết Trong Hóa Đơn
    [Arguments]    ${invoice_id}    ${product_id}    ${expected_point}
    ${query}=    Set Variable    SELECT Point FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${product_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy chi tiết hóa đơn (InvoiceId=${invoice_id}, ProductId=${product_id}) trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_point}    Điểm thưởng trong chi tiết hóa đơn không chính xác. Mong đợi: ${expected_point}, Thực tế: ${result[0]}

Xác Thực Điểm Thưởng Khuyến Mãi
    [Arguments]    ${invoice_id}    ${promotion_type}    ${expected_point}
    ${query}=    Set Variable    SELECT PromotionValue FROM InvoicePromotion WHERE InvoiceId = ? AND PromotionType = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${promotion_type}
    Should Not Be Equal    ${result}    None    Không tìm thấy khuyến mãi tặng điểm (InvoiceId=${invoice_id}, PromotionType=${promotion_type}) trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_point}    Điểm thưởng khuyến mãi không chính xác. Mong đợi: ${expected_point}, Thực tế: ${result[0]}

Xác Thực Điểm Thưởng Khuyến Mãi Sản Phẩm
    [Arguments]    ${invoice_id}    ${product_id}    ${promotion_type}    ${expected_point}
    ${query}=    Set Variable    SELECT PromotionValue FROM ProductPromotion WHERE InvoiceId = ? AND ProductId = ? AND PromotionType = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${product_id}    ${promotion_type}
    Should Not Be Equal    ${result}    None    Không tìm thấy khuyến mãi tặng điểm cho sản phẩm (InvoiceId=${invoice_id}, ProductId=${product_id}) trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_point}    Điểm thưởng khuyến mãi sản phẩm không chính xác. Mong đợi: ${expected_point}, Thực tế: ${result[0]}

Xác Thực Thông Tin Lịch Sử Điểm
    [Arguments]    ${invoice_id}    ${customer_id}    ${expected_point}    ${is_increase}=True    ${description}=None
    ${point_type}=    Set Variable    Increase
    IF    ${is_increase} == ${FALSE}
        ${point_type}=    Set Variable    Decrease
    END
    
    ${query}=    Set Variable    SELECT CustomerId, Point, Type FROM PointTracking WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin lịch sử điểm (InvoiceId=${invoice_id}) trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${customer_id}    Khách hàng trong lịch sử điểm không chính xác
    Should Be Equal As Numbers    ${result[1]}    ${expected_point}    Số điểm trong lịch sử không chính xác. Mong đợi: ${expected_point}, Thực tế: ${result[1]}
    Should Be Equal    ${result[2]}    ${point_type}    Loại thay đổi điểm không chính xác
    
    # Kiểm tra mô tả nếu được cung cấp
    IF    "${description}" != "None"
        ${description_query}=    Set Variable    SELECT Description FROM PointTracking WHERE InvoiceId = ?
        ${description_result}=    Fetch One    ${description_query}    ${invoice_id}
        Should Contain    ${description_result[0]}    ${description}    Mô tả trong lịch sử điểm không chứa nội dung mong đợi
    END

Xác Thực Điểm Khả Dụng Của Khách Hàng
    [Arguments]    ${customer_id}    ${expected_point}
    ${query}=    Set Variable    SELECT AvailablePoint FROM Customer WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${customer_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy khách hàng ID ${customer_id} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_point}    Điểm khả dụng của khách hàng không chính xác. Mong đợi: ${expected_point}, Thực tế: ${result[0]}

Xác Thực Không Có Lịch Sử Điểm
    [Arguments]    ${invoice_id}
    ${query}=    Set Variable    SELECT COUNT(*) FROM PointTracking WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    0    Tìm thấy lịch sử điểm cho hóa đơn không kỳ vọng có tích điểm 

# New keywords with embedded parameters
Chuẩn Bị Dữ Liệu Hóa Đơn với tổng điểm ${total} thiết lập chiết khấu ${discount} điểm MoneyPerPoint là ${money_per_point} và cấu hình tính điểm thưởng trên giá chưa giảm là ${use_original_price}
    ${include_discount}=    Set Variable    ${FALSE}
    IF    '${use_original_price}' == 'True'
        ${include_discount}=    Set Variable    ${FALSE}
    ELSE
        ${include_discount}=    Set Variable    ${TRUE}
    END
    
    ${data}=    Set Variable    ${INVOICE_WITH_DISCOUNT_REQUEST}
    ${invoice}=    Set Variable    ${data.Invoice}
    Set To Dictionary    ${invoice}    Total=${total}
    Set To Dictionary    ${invoice}    Discount=${discount}
    Set To Dictionary    ${invoice}    MoneyPerPoint=${money_per_point}
    Set To Dictionary    ${invoice}    RewardPoint_ForDiscountInvoice=${include_discount}
    
    # Cập nhật thông tin sản phẩm
    ${product}=    Set Variable    ${invoice.InvoiceDetails[0]}
    ${price}=    Evaluate    ${total} - ${discount}
    Set To Dictionary    ${product}    Price=${price}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Điểm thưởng của hóa đơn là ${expected_point}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực Điểm Thưởng Trong Hóa Đơn    ${invoice_id}    ${expected_point}

Chuẩn Bị Dữ Liệu Hóa Đơn với sản phẩm có điểm thưởng là ${point_value} và số lượng là ${quantity}
    ${invoice}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Có Điểm Thưởng    ${point_value}    ${PRODUCT_1}
    Set To Dictionary    ${REQUEST_DATA.Invoice.InvoiceDetails[0]}    Quantity=${quantity}
    RETURN    ${invoice}

Chuẩn Bị Dữ Liệu Hóa Đơn với tổng tiền ${total} MoneyPerPoint là ${money_per_point} phụ phí ${surcharge} và thuế ${tax}
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Phụ Phí Và Thuế    ${surcharge}    ${tax}
    ${invoice}=    Set Variable    ${data.Invoice}
    Set To Dictionary    ${invoice}    Total=${total}
    Set To Dictionary    ${invoice}    MoneyPerPoint=${money_per_point}
    
    # Cập nhật thông tin sản phẩm
    ${product}=    Set Variable    ${invoice.InvoiceDetails[0]}
    ${price}=    Evaluate    ${total} - ${surcharge} - ${tax}
    Set To Dictionary    ${product}    Price=${price}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn nhóm khách hàng VIP với MoneyPerPoint là ${money_per_point}
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhóm Khách Hàng    ${money_per_point}    1001
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn với thanh toán voucher ${voucher_amount} và cấu hình tích điểm trên voucher là ${include_voucher}
    ${include_voucher_bool}=    Set Variable    ${TRUE}
    IF    '${include_voucher}' == 'False'
        ${include_voucher_bool}=    Set Variable    ${FALSE}
    END
    
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Bằng Voucher    ${voucher_amount}    ${include_voucher_bool}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn với khuyến mãi tặng ${promotion_point} điểm
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Điểm    ${promotion_point}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn với khuyến mãi sản phẩm tặng ${promotion_point} điểm
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Điểm Theo Sản Phẩm    ${promotion_point}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Điểm thưởng chi tiết của sản phẩm ${product_id} là ${expected_point}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực Điểm Thưởng Chi Tiết Trong Hóa Đơn    ${invoice_id}    ${product_id}    ${expected_point}

Khuyến mãi điểm của hóa đơn ${promotion_type} có giá trị là ${expected_point}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực Điểm Thưởng Khuyến Mãi    ${invoice_id}    ${promotion_type}    ${expected_point}

Lịch sử điểm của khách hàng ${customer_id} được ghi nhận với ${expected_point} điểm
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực Thông Tin Lịch Sử Điểm    ${invoice_id}    ${customer_id}    ${expected_point}

Không có lịch sử điểm nào được tạo
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực Không Có Lịch Sử Điểm    ${invoice_id} 