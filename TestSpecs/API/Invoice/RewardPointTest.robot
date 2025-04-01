*** Settings ***
Documentation     Test cấc test case API liên quan đến tính điểm thưởng khi tạo hóa đơn
Resource          ../../../Keywords/Invoice/RewardPointKeywords.robot
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    RewardPointTest

*** Test Cases ***
RT-RP-001 Tính điểm theo hóa đơn với sản phẩm được cấu hình tích điểm
    [Documentation]    Kiểm tra tính điểm theo hóa đơn khi tất cả sản phẩm được cấu hình tích điểm
    Given Prepare Invoice With Invoice Reward Type
    When Send Create Invoice Request
    Then Response Status Code Should Be 200
    ${expected_points}=    Calculate Expected Invoice Type Reward Points    ${REQUEST_DATA}
    And Response Should Have Correct Reward Points    ${expected_points}

RT-RP-002 Tính điểm theo hóa đơn với một số sản phẩm không được tích điểm
    [Documentation]    Kiểm tra tính điểm theo hóa đơn khi có sản phẩm không được cấu hình tích điểm
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}    ${PRODUCT_WITHOUT_REWARD_POINT}
    Given Prepare Invoice With Invoice Reward Type    ${details}
    When Send Create Invoice Request
    Then Response Status Code Should Be 200
    ${expected_points}=    Calculate Expected Invoice Type Reward Points    ${REQUEST_DATA}
    And Response Should Have Correct Reward Points    ${expected_points}

RT-RP-003 Tính điểm theo hóa đơn với tất cả sản phẩm không được tích điểm
    [Documentation]    Kiểm tra tính điểm theo hóa đơn khi không có sản phẩm nào được cấu hình tích điểm
    ${details}=    Create List    ${PRODUCT_WITHOUT_REWARD_POINT}
    Given Prepare Invoice With Invoice Reward Type    ${details}
    When Send Create Invoice Request
    Then Response Status Code Should Be 200
    And Response Should Have Correct Reward Points    0

RT-RP-004 Tính điểm theo hóa đơn với số tiền chia không đủ cho 1 điểm
    [Documentation]    Kiểm tra tính điểm theo hóa đơn khi tổng tiền không đủ để đổi thành 1 điểm hoàn chỉnh
    &{detail}=    Create Dictionary
    ...    ProductId=${PRODUCT_1}
    ...    Quantity=1
    ...    Price=5000
    ...    IsRewardPoint=True
    ${details}=    Create List    ${detail}
    Given Prepare Invoice With Invoice Reward Type    ${details}
    When Send Create Invoice Request
    Then Response Status Code Should Be 200
    And Response Should Have Correct Reward Points    0

RT-RP-005 Tính điểm theo sản phẩm với sản phẩm có điểm thưởng
    [Documentation]    Kiểm tra tính điểm theo sản phẩm khi sản phẩm có cấu hình điểm thưởng
    Given Prepare Invoice With Product Reward Type
    When Send Create Invoice Request
    Then Response Status Code Should Be 200
    ${expected_points}=    Calculate Expected Product Type Reward Points    ${REQUEST_DATA}
    And Response Should Have Correct Reward Points    ${expected_points}

RT-RP-006 Tính điểm theo sản phẩm với sản phẩm không có điểm thưởng
    [Documentation]    Kiểm tra tính điểm theo sản phẩm khi sản phẩm không có cấu hình điểm thưởng
    ${details}=    Create List    ${PRODUCT_WITHOUT_REWARD_POINT}
    Given Prepare Invoice With Product Reward Type    ${details}
    When Send Create Invoice Request
    Then Response Status Code Should Be 200
    And Response Should Have Correct Reward Points    0

RT-RP-007 Tính điểm theo sản phẩm với một sản phẩm có nhiều số lượng
    [Documentation]    Kiểm tra tính điểm theo sản phẩm khi một sản phẩm có nhiều số lượng
    &{detail}=    Create Dictionary
    ...    ProductId=${PRODUCT_1}
    ...    Quantity=5
    ...    Price=100000
    ...    IsRewardPoint=True
    ...    RewardPoint=10
    ${details}=    Create List    ${detail}
    Given Prepare Invoice With Product Reward Type    ${details}
    When Send Create Invoice Request
    Then Response Status Code Should Be 200
    And Response Should Have Correct Reward Points    50

RT-RP-008 Tính điểm theo sản phẩm với nhiều sản phẩm khác nhau
    [Documentation]    Kiểm tra tính điểm theo sản phẩm khi có nhiều sản phẩm khác nhau có điểm thưởng
    &{detail1}=    Create Dictionary
    ...    ProductId=${PRODUCT_1}
    ...    Quantity=2
    ...    Price=100000
    ...    IsRewardPoint=True
    ...    RewardPoint=10
    &{detail2}=    Create Dictionary
    ...    ProductId=${PRODUCT_2}
    ...    Quantity=1
    ...    Price=100000
    ...    IsRewardPoint=True
    ...    RewardPoint=5
    ${details}=    Create List    ${detail1}    ${detail2}
    Given Prepare Invoice With Product Reward Type    ${details}
    When Send Create Invoice Request
    Then Response Status Code Should Be 200
    And Response Should Have Correct Reward Points    25

RT-RP-009 Tính điểm khuyến mãi theo hóa đơn với giá trị cố định
    [Documentation]    Kiểm tra tính điểm khuyến mãi theo hóa đơn với giá trị điểm tặng cố định
    Given Prepare Invoice With Promotion Point
    When Send Create Invoice Request
    Then Response Status Code Should Be 200
    ${base_points}=    Calculate Expected Invoice Type Reward Points    ${REQUEST_DATA}
    ${promotion_points}=    Calculate Expected Promotion Points    ${REQUEST_DATA}    ${base_points}
    ${total_points}=    Evaluate    ${base_points} + ${promotion_points}
    And Response Should Have Correct Reward Points    ${total_points}

RT-RP-010 Tính điểm khuyến mãi theo hóa đơn với tỷ lệ phần trăm
    [Documentation]    Kiểm tra tính điểm khuyến mãi theo hóa đơn với tỷ lệ phần trăm trên điểm thưởng cơ bản
    &{promotion}=    Create Dictionary
    ...    Id=1001
    ...    Type=2
    ...    ApplyFor=1
    ...    PointPercentage=20
    Given Prepare Invoice With Promotion Point    ${promotion}
    When Send Create Invoice Request
    Then Response Status Code Should Be 200
    ${base_points}=    Calculate Expected Invoice Type Reward Points    ${REQUEST_DATA}
    ${promotion_points}=    Calculate Expected Promotion Points    ${REQUEST_DATA}    ${base_points}
    ${total_points}=    Evaluate    ${base_points} + ${promotion_points}
    And Response Should Have Correct Reward Points    ${total_points}

RT-RP-011 Tính điểm khuyến mãi theo sản phẩm với tỷ lệ phần trăm
    [Documentation]    Kiểm tra tính điểm khuyến mãi theo sản phẩm với tỷ lệ phần trăm trên điểm thưởng của sản phẩm
    Given Prepare Product With Promotion Point
    When Send Create Invoice Request
    Then Response Status Code Should Be 200
    ${base_points}=    Calculate Expected Product Type Reward Points    ${REQUEST_DATA}
    ${promotion_points}=    Calculate Expected Promotion Points    ${REQUEST_DATA}    ${base_points}
    ${total_points}=    Evaluate    ${base_points} + ${promotion_points}
    And Response Should Have Correct Reward Points    ${total_points}

RT-RP-012 Tính điểm với nhiều loại khuyến mãi cùng lúc
    [Documentation]    Kiểm tra tính điểm khi áp dụng nhiều loại khuyến mãi cùng lúc
    ${data}=    Evaluate    dict(${INVOICE_WITH_PROMOTION_POINT_DATA})
    
    # Add standard invoice detail
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    # Add multiple promotions
    &{promotion1}=    Create Dictionary
    ...    Id=1001
    ...    Type=2
    ...    ApplyFor=1
    ...    PointValue=50
    &{promotion2}=    Create Dictionary
    ...    Id=1002
    ...    Type=3
    ...    ApplyFor=2
    ...    PointPercentage=10
    ...    ApplyProductIds=${PRODUCT_1}
    
    ${promotions}=    Create List    ${promotion1}    ${promotion2}
    Set To Dictionary    ${data}    Promotions=${promotions}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    
    When Send Create Invoice Request
    Then Response Status Code Should Be 200
    ${base_points}=    Calculate Expected Invoice Type Reward Points    ${REQUEST_DATA}
    ${promotion_points}=    Calculate Expected Promotion Points    ${REQUEST_DATA}    ${base_points}
    ${total_points}=    Evaluate    ${base_points} + ${promotion_points}
    And Response Should Have Correct Reward Points    ${total_points}

RT-RP-013 Tính điểm với hóa đơn không đủ điều kiện khuyến mãi
    [Documentation]    Kiểm tra tính điểm khi hóa đơn không đủ điều kiện để nhận khuyến mãi điểm
    &{promotion}=    Create Dictionary
    ...    Id=1001
    ...    Type=2
    ...    ApplyFor=1
    ...    PointValue=50
    ...    MinValue=1000000
    
    ${data}=    Evaluate    dict(${INVOICE_WITH_PROMOTION_POINT_DATA})
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${promotions}=    Create List    ${promotion}
    Set To Dictionary    ${data}    Promotions=${promotions}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    
    When Send Create Invoice Request
    Then Response Status Code Should Be 200
    ${base_points}=    Calculate Expected Invoice Type Reward Points    ${REQUEST_DATA}
    And Response Should Have Correct Reward Points    ${base_points}

RT-RP-014 Tính điểm khuyến mãi theo sản phẩm không được cấu hình tích điểm
    [Documentation]    Kiểm tra tính điểm khuyến mãi theo sản phẩm khi sản phẩm không được cấu hình tích điểm
    &{promotion}=    Create Dictionary
    ...    Id=1002
    ...    Type=3
    ...    ApplyFor=2
    ...    PointPercentage=10
    ...    ApplyProductIds=${PRODUCT_2}
    
    ${data}=    Evaluate    dict(${PRODUCT_WITH_PROMOTION_POINT_DATA})
    &{detail}=    Create Dictionary
    ...    ProductId=${PRODUCT_2}
    ...    Quantity=1
    ...    Price=100000
    ...    IsRewardPoint=False
    ${details}=    Create List    ${detail}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${promotions}=    Create List    ${promotion}
    Set To Dictionary    ${data}    Promotions=${promotions}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    
    When Send Create Invoice Request
    Then Response Status Code Should Be 200
    And Response Should Have Correct Reward Points    0

RT-RP-015 Tính điểm với giảm giá trên sản phẩm
    [Documentation]    Kiểm tra tính điểm khi sản phẩm có giảm giá
    ${data}=    Evaluate    dict(${INVOICE_REWARD_TYPE_DATA})
    
    &{detail}=    Create Dictionary
    ...    ProductId=${PRODUCT_1}
    ...    Quantity=1
    ...    Price=100000
    ...    Discount=20000
    ...    IsRewardPoint=True
    
    ${details}=    Create List    ${detail}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    
    When Send Create Invoice Request
    Then Response Status Code Should Be 200
    ${expected_points}=    Calculate Expected Invoice Type Reward Points    ${REQUEST_DATA}
    And Response Should Have Correct Reward Points    ${expected_points}

RT-RP-016 Tính điểm với hóa đơn có thuế
    [Documentation]    Kiểm tra tính điểm khi hóa đơn có thuế, điểm tích lũy không bao gồm thuế
    ${data}=    Evaluate    dict(${INVOICE_REWARD_TYPE_DATA})
    
    &{detail}=    Create Dictionary
    ...    ProductId=${PRODUCT_1}
    ...    Quantity=1
    ...    Price=100000
    ...    IsRewardPoint=True
    ...    TaxRate=${VAT_RATE}
    
    ${details}=    Create List    ${detail}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    
    When Send Create Invoice Request
    Then Response Status Code Should Be 200
    ${expected_points}=    Calculate Expected Invoice Type Reward Points    ${REQUEST_DATA}
    And Response Should Have Correct Reward Points    ${expected_points}

RT-RP-017 Tính điểm với hóa đơn có phụ phí
    [Documentation]    Kiểm tra tính điểm khi hóa đơn có phụ phí, điểm tích lũy không bao gồm phụ phí
    ${data}=    Evaluate    dict(${INVOICE_REWARD_TYPE_DATA})
    
    &{detail}=    Create Dictionary
    ...    ProductId=${PRODUCT_1}
    ...    Quantity=1
    ...    Price=100000
    ...    IsRewardPoint=True
    
    ${details}=    Create List    ${detail}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    &{surcharge}=    Create Dictionary
    ...    Id=1
    ...    Value=10000
    ...    IsPercent=False
    
    @{surcharges}=    Create List    ${surcharge}
    Set To Dictionary    ${data}    Surcharges=${surcharges}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    
    When Send Create Invoice Request
    Then Response Status Code Should Be 200
    ${expected_points}=    Calculate Expected Invoice Type Reward Points    ${REQUEST_DATA}
    And Response Should Have Correct Reward Points    ${expected_points}

RT-RP-018 Không tích điểm khi chức năng tích điểm không được kích hoạt
    [Documentation]    Kiểm tra không tính điểm khi chức năng tích điểm trong cài đặt không được kích hoạt
    ${data}=    Evaluate    dict(${INVOICE_REWARD_TYPE_DATA})
    
    # Disable reward point setting
    ${pos_setting}=    Create Dictionary
    ...    RewardPointType=1
    ...    RewardPoint_IsActive=False
    ...    RewardPoint_MoneyPerPoint=10000
    
    Set To Dictionary    ${data}    PosSetting=${pos_setting}
    
    # Add standard invoice detail
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    
    When Send Create Invoice Request
    Then Response Status Code Should Be 200
    And Response Should Have Correct Reward Points    0 