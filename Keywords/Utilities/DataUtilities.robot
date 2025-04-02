*** Settings ***
Documentation     Utility functions for data manipulation
Library           Collections
Library           String
Library           json

*** Keywords ***
Deep Copy
    [Documentation]    Creates a deep copy of any data structure using JSON serialization
    [Arguments]    ${data}
    ${json_data}=    Evaluate    json.dumps(${data})    json
    ${copied_data}=    Evaluate    json.loads($json_data)    json
    RETURN    ${copied_data}

Update Dictionary Property
    [Documentation]    Updates a property in a dictionary, useful for request modification
    [Arguments]    ${dictionary}    ${property_name}    ${property_value}
    Set To Dictionary    ${dictionary}    ${property_name}=${property_value}
    RETURN    ${dictionary}

Update Nested Dictionary Property
    [Documentation]    Updates a nested property in a dictionary using a dot-notation path
    [Arguments]    ${dictionary}    ${property_path}    ${property_value}
    @{parts}=    Split String    ${property_path}    .
    ${parts_count}=    Get Length    ${parts}
    ${current}=    Set Variable    ${dictionary}
    
    # Navigate to the correct level, stopping at the parent
    FOR    ${i}    IN RANGE    0    ${parts_count-1}
        ${part}=    Get From List    ${parts}    ${i}
        ${current}=    Get From Dictionary    ${current}    ${part}
    END
    
    # Set the value at the final level
    ${last_part}=    Get From List    ${parts}    ${parts_count-1}
    Set To Dictionary    ${current}    ${last_part}=${property_value}
    
    RETURN    ${dictionary}

Remove Nested Dictionary Property
    [Documentation]    Removes a nested property from a dictionary using a dot-notation path
    [Arguments]    ${dictionary}    ${property_path}
    @{parts}=    Split String    ${property_path}    .
    ${parts_count}=    Get Length    ${parts}
    ${current}=    Set Variable    ${dictionary}
    
    # Navigate to the correct level, stopping at the parent
    FOR    ${i}    IN RANGE    0    ${parts_count-1}
        ${part}=    Get From List    ${parts}    ${i}
        ${current}=    Get From Dictionary    ${current}    ${part}
    END
    
    # Remove the key at the final level
    ${last_part}=    Get From List    ${parts}    ${parts_count-1}
    Remove From Dictionary    ${current}    ${last_part}
    
    RETURN    ${dictionary}

Add List Item
    [Documentation]    Adds an item to a list at a specified path in a dictionary
    [Arguments]    ${dictionary}    ${list_path}    ${item}
    @{parts}=    Split String    ${list_path}    .
    ${parts_count}=    Get Length    ${parts}
    ${current}=    Set Variable    ${dictionary}
    
    # Navigate to the correct level
    FOR    ${i}    IN RANGE    0    ${parts_count}
        ${part}=    Get From List    ${parts}    ${i}
        ${current}=    Get From Dictionary    ${current}    ${part}
    END
    
    # Append to the list
    Append To List    ${current}    ${item}
    
    RETURN    ${dictionary}

Create Invoice Detail
    [Documentation]    Creates a standard invoice detail dictionary
    [Arguments]    ${product_id}    ${quantity}    ${price}    ${discount}=0
    ${detail}=    Create Dictionary    ProductId=${product_id}    Quantity=${quantity}    Price=${price}    Discount=${discount}
    RETURN    ${detail}

Add Invoice Detail
    [Documentation]    Adds a product detail to the invoice request
    [Arguments]    ${request}    ${product_id}    ${quantity}    ${price}    ${discount}=0
    ${detail}=    Create Invoice Detail    ${product_id}    ${quantity}    ${price}    ${discount}
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${detail}
    RETURN    ${request}

Get Nested Property
    [Documentation]    Gets a nested property from a dictionary using a dot-notation path
    [Arguments]    ${dictionary}    ${property_path}
    @{parts}=    Split String    ${property_path}    .
    ${current}=    Set Variable    ${dictionary}
    
    # Navigate through the path
    FOR    ${part}    IN    @{parts}
        ${current}=    Get From Dictionary    ${current}    ${part}
    END
    
    RETURN    ${current} 