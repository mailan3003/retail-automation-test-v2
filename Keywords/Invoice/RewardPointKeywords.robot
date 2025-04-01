*** Settings ***
Resource    ../Utilities/Utilities.robot
Resource    ../Utilities/RequestHelper.robot
Resource    ../Utilities/ResponseHelper.robot
Resource    ../../TestData/Invoice/RewardPointData.robot
Library     Collections
Library     String
Library     DateTime

*** Keywords ***
Prepare Invoice With Invoice Reward Type
    [Arguments]    ${invoice_details}=${None}
    ${data}=    Evaluate    dict(${INVOICE_REWARD_TYPE_DATA})
    
    # Add invoice details if provided, otherwise use standard details
    ${details}=    Run Keyword If    '${invoice_details}' == '${None}'    
    ...    Create List    ${STANDARD_INVOICE_DETAIL}
    ...    ELSE    Set Variable    ${invoice_details}
    
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Product Reward Type
    [Arguments]    ${invoice_details}=${None}
    ${data}=    Evaluate    dict(${PRODUCT_REWARD_TYPE_DATA})
    
    # Add invoice details if provided, otherwise use standard details
    ${details}=    Run Keyword If    '${invoice_details}' == '${None}'    
    ...    Create List    ${PRODUCT_WITH_REWARD_POINT}
    ...    ELSE    Set Variable    ${invoice_details}
    
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Promotion Point
    [Arguments]    ${promotion}=${INVOICE_POINT_PROMOTION}
    ${data}=    Evaluate    dict(${INVOICE_WITH_PROMOTION_POINT_DATA})
    
    # Add standard invoice detail
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    # Add promotion
    ${promotions}=    Create List    ${promotion}
    Set To Dictionary    ${data}    Promotions=${promotions}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Product With Promotion Point
    [Arguments]    ${promotion}=${PRODUCT_POINT_PROMOTION}
    ${data}=    Evaluate    dict(${PRODUCT_WITH_PROMOTION_POINT_DATA})
    
    # Add product with reward point
    ${details}=    Create List    ${PRODUCT_WITH_REWARD_POINT}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    # Add promotion
    ${promotions}=    Create List    ${promotion}
    Set To Dictionary    ${data}    Promotions=${promotions}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Send Create Invoice Request
    ${headers}=    Create Auth Headers
    ${response}=    POST    ${API_URL}/invoices    json=${REQUEST_DATA}    headers=${headers}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}

Calculate Expected Invoice Type Reward Points
    [Arguments]    ${invoice_data}
    ${total_without_tax}=    Set Variable    0
    ${money_per_point}=    Set Variable    ${invoice_data['PosSetting']['RewardPoint_MoneyPerPoint']}
    
    # Sum up all eligible products for reward points
    FOR    ${detail}    IN    @{invoice_data['InvoiceDetails']}
        ${is_reward_point}=    Set Variable    ${detail.get('IsRewardPoint', False)}
        ${include_in_total}=    Set Variable    ${True if ${is_reward_point} == ${True} else ${False}}
        
        IF    ${include_in_total}
            ${item_total}=    Evaluate    ${detail['Price']} * ${detail['Quantity']}
            ${total_without_tax}=    Evaluate    ${total_without_tax} + ${item_total}
        END
    END
    
    # Calculate total points
    ${expected_points}=    Evaluate    int(${total_without_tax} / ${money_per_point})
    RETURN    ${expected_points}

Calculate Expected Product Type Reward Points
    [Arguments]    ${invoice_data}
    ${total_points}=    Set Variable    0
    
    # Sum up points from each eligible product
    FOR    ${detail}    IN    @{invoice_data['InvoiceDetails']}
        ${is_reward_point}=    Set Variable    ${detail.get('IsRewardPoint', False)}
        ${reward_point}=    Set Variable    ${detail.get('RewardPoint', 0)}
        
        IF    ${is_reward_point} and ${reward_point} > 0
            ${item_points}=    Evaluate    ${reward_point} * ${detail['Quantity']}
            ${total_points}=    Evaluate    ${total_points} + ${item_points}
        END
    END
    
    RETURN    ${total_points}

Calculate Expected Promotion Points
    [Arguments]    ${invoice_data}    ${base_points}
    ${total_promotion_points}=    Set Variable    0
    
    FOR    ${promotion}    IN    @{invoice_data['Promotions']}
        # Invoice point gift type
        IF    ${promotion['Type']} == 2 and ${promotion['ApplyFor']} == 1
            # Fixed point value
            IF    '${promotion.get("PointValue", "0")}' != '0'
                ${promotion_points}=    Set Variable    ${promotion['PointValue']}
            # Percentage of base points
            ELSE IF    '${promotion.get("PointPercentage", "0")}' != '0'
                ${percentage}=    Set Variable    ${promotion['PointPercentage']}
                ${promotion_points}=    Evaluate    int((${percentage} * ${base_points}) / 100)
            END
            ${total_promotion_points}=    Evaluate    ${total_promotion_points} + ${promotion_points}
        # Product point gift type
        ELSE IF    ${promotion['Type']} == 3 and ${promotion['ApplyFor']} == 2
            ${apply_product_ids}=    Set Variable    ${promotion['ApplyProductIds']}
            ${percentage}=    Set Variable    ${promotion['PointPercentage']}
            
            FOR    ${detail}    IN    @{invoice_data['InvoiceDetails']}
                ${product_id}=    Set Variable    ${detail['ProductId']}
                ${should_apply}=    Evaluate    '${product_id}' in '${apply_product_ids}'
                
                IF    ${should_apply}
                    ${reward_point}=    Set Variable    ${detail.get('RewardPoint', 0)}
                    ${product_points}=    Evaluate    ${reward_point} * ${detail['Quantity']}
                    ${promotion_points}=    Evaluate    int((${percentage} * ${product_points}) / 100)
                    ${total_promotion_points}=    Evaluate    ${total_promotion_points} + ${promotion_points}
                END
            END
        END
    END
    
    RETURN    ${total_promotion_points}

Response Should Have Correct Reward Points
    [Arguments]    ${expected_points}
    ${actual_points}=    Get From Dictionary    ${RESPONSE.json()}    RewardPoint
    Should Be Equal As Numbers    ${actual_points}    ${expected_points} 