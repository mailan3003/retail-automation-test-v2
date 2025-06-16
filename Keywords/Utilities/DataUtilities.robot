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

Update Value Item
    [Documentation]    Updates an value in a specified index and path in a dictionary
    [Arguments]    ${dictionary}    ${list_path}     ${property_name}    ${property_value}
    @{parts}=    Split String    ${list_path}    .
    ${parts_count}=    Get Length    ${parts}
    ${current}=    Set Variable    ${dictionary}
    
    # Navigate to the correct level
    FOR    ${i}    IN RANGE    0    ${parts_count}
        ${part}=    Get From List    ${parts}    ${i}
        ${current}=    Get From Dictionary    ${current}    ${part}
        Log    ${current}
    END
    
    # Get the item at the specified index
 
    # Update the property in the item
    Set To Dictionary    ${current}    ${property_name}=${property_value}
    
    RETURN    ${dictionary}

Update List Item By Property
    [Documentation]    Updates an item in a list by finding it using a property value and then updating another property
    [Arguments]    ${dictionary}    ${list_path}    ${search_property}    ${search_value}    ${update_property}    ${update_value}
    @{parts}=    Split String    ${list_path}    .
    ${parts_count}=    Get Length    ${parts}
    ${current}=    Set Variable    ${dictionary}
    
    # Navigate to the correct level
    FOR    ${i}    IN RANGE    0    ${parts_count}
        ${part}=    Get From List    ${parts}    ${i}
        ${current}=    Get From Dictionary    ${current}    ${part}
    END
    
    # Find the item with the matching property
    ${list_length}=    Get Length    ${current}
    FOR    ${i}    IN RANGE    0    ${list_length}
        ${item}=    Get From List    ${current}    ${i}
        ${item_value}=    Get From Dictionary    ${item}    ${search_property}
        IF    $item_value == $search_value
            # Update the property in the found item
            Set To Dictionary    ${item}    ${update_property}=${update_value}
            RETURN    ${dictionary}
        END
    END
    
    # If no matching item was found
    Log    Warning: No item found with ${search_property}=${search_value} in ${list_path}    WARN
    RETURN    ${dictionary}

Remove List Item
    [Documentation]    Removes an item from a list at a specified index and path in a dictionary
    [Arguments]    ${dictionary}    ${list_path}    ${index}
    @{parts}=    Split String    ${list_path}    .
    ${parts_count}=    Get Length    ${parts}
    ${current}=    Set Variable    ${dictionary}
    
    # Navigate to the correct level
    FOR    ${i}    IN RANGE    0    ${parts_count}
        ${part}=    Get From List    ${parts}    ${i}
        ${current}=    Get From Dictionary    ${current}    ${part}
    END
    
    # Remove the item at the specified index
    Remove From List    ${current}    ${index}
    
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

Find Index In List
    [Documentation]    Finds the index of an item in a list by matching a property value
    [Arguments]    ${list}    ${property_name}    ${property_value}
    ${list_length}=    Get Length    ${list}
    FOR    ${i}    IN RANGE    0    ${list_length}
        ${item}=    Get From List    ${list}    ${i}
        ${item_value}=    Get From Dictionary    ${item}    ${property_name}
        IF    $item_value == $property_value
            RETURN    ${i}
        END
    END
    RETURN   ${i}

Remove Item From List
    [Documentation]    Removes an item from a list by matching a property value
    [Arguments]    ${list}    ${property_name}    ${property_value}
    ${index}=    Find Index In List    ${list}    ${property_name}    ${property_value}
    Remove From List    ${list}    ${index}
    RETURN    ${list}
