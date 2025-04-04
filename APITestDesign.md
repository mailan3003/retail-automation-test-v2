# API Test Case Design Guide

## 1. Test Case Structure

### 1.1 File Organization
```
robotframework-tests/
├── TestSpecs/
│   └── API/
│       └── {Module}/
│           └── {Feature}Test.robot
├── TestData/
│   ├── CommonData.robot
│   └── {Module}/
│       └── {Feature}Data.robot
├── Keywords/
│   └── {Module}/
│       └── {Feature}Keywords.robot
└── Env.robot
```

### 1.2 Test Case Pattern
```robotframework
RT-{Module}-{Number} {Description}
    [Documentation]    Description of test purpose
    Given {Prepare Data Step}
    When {Execute Action Step}
    Then {Verify Response Code}
    And {Additional Verification Steps}
```

## 2. Test Case Implementation

### 2.1 Test Data Management
1. Common Data (`TestData/CommonData.robot`):
```robotframework
*** Variables ***
${CONSTANT_NAME}    value
&{DICTIONARY_NAME}    key=value
@{LIST_NAME}    item1    item2
```

2. Feature-specific Data (`TestData/{Module}/{Feature}Data.robot`):
```robotframework
*** Variables ***
${TEST_DATA}    {"key": "value"}
```

### 2.2 Keyword Implementation
1. Create Keywords (`Keywords/{Module}/{Feature}Keywords.robot`):
```robotframework
*** Keywords ***
Prepare Test Data
    ${request_data}=    Create Test Data
    Set Test Variable    ${REQUEST_DATA}    ${request_data}

Send API Request
    ${response}=    POST    ${API_URL}    json=${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
```

### 2.3 Test Case Creation
1. Test Case Structure:
```robotframework
RT-XX-001 Test scenario description
    [Documentation]    Detailed test purpose with example data
    Given Prepare Test Data
    When Send API Request
    Then Response Status Code Should Be 200
    And Response Data Should Match Request    ${REQUEST_DATA}
```

## 3. Best Practices

### 3.1 Test Case Organization
- Use consistent ID format: `RT-{Module}-{Number}`
- Clear descriptive names
- Comprehensive documentation
- Follow Given-When-Then pattern

### 3.2 Data Management
- Keep test data separate from test logic
- Use variables for reusable data
- Store common data in `CommonData.robot`
- Use descriptive variable names
- Preparation keywords should reuse variables from `CommonInvoiceData.robot` and modify them to fit specific test needs

### 3.3 Verification Steps
1. Status Code Verification:
```robotframework
Response Status Code Should Be ${expected_code}
```

2. Error Message Verification:
```robotframework
Response Should Have Error ${expected_error}
```

3. Response Data Verification:
```robotframework
Response Data Should Match Request    ${expected_data}
```

### 3.4 Embedded Parameter Pattern
For improved test case readability, prefer using embedded parameters in keywords. This makes test cases more descriptive and self-documenting.

1. Define keywords with embedded parameters:
```robotframework
Chuẩn Bị Dữ Liệu Với Tham Số ${parameter1} Và ${parameter2}
    ${data}=    Create Dictionary    value1=${parameter1}    value2=${parameter2}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Giá Trị Của Trường ${field_name} Là ${expected_value}
    ${actual_value}=    Get From Dictionary    ${RESPONSE.json()}    ${field_name}
    Should Be Equal    ${actual_value}    ${expected_value}
```

2. Call keywords with embedded parameters in test cases:
```robotframework
RT-XX-001 Test case with embedded parameters
    [Documentation]    Test case using embedded parameters for better readability
    Given Chuẩn Bị Dữ Liệu Với Tham Số value1 Và value2
    When Gửi Yêu Cầu API
    Then Response Status Code Should Be 200
    And Giá Trị Của Trường field_name Là expected_value
```

This pattern is particularly useful for:
- Making test cases more descriptive and self-documenting
- Reducing the need for intermediate variables
- Improving test case readability in reports
- Following natural language conventions for Given-When-Then steps

Example for data validation:
```robotframework
RT-IN-006 Tạo hóa đơn với chiết khấu
    [Documentation]    Kiểm tra tạo hóa đơn với chiết khấu
    Given Chuẩn Bị Dữ Liệu Hóa Đơn với tổng điểm 100000 thiết lập chiết khấu 10000 điểm MoneyPerPoint là 10000 và cấu hình tính điểm thưởng trên giá chưa giảm là True
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200 
    And Điểm thưởng của hóa đơn là 10
```

## 4. Example Implementation

### 4.1 Simple Test Case
```robotframework
RT-IN-001 Create invoice successfully
    RT-IN-001 - Tạo hóa đơn thành công với các sản phẩm
    [Documentation]    Kiểm tra tạo hóa đơn với nhiều sản phẩm:
    ...    - Source: InvoiceService.cs > CreateInvoiceAsync() line ~1550
    ...    - Logic: Calculates total from product details
    ...    - Code: decimal calTotal = invoice.InvoiceDetails.Sum(x => x.Quantity * x.Price);
    ...    - SP1: 2 x 100,000đ = 200,000đ
    ...    - SP2: 1 x 150,000đ = 150,000đ  
    ...    - Tổng tiền: 350,000đ
    [Template]    Create Basic Invoice With Products And Verify
    # product details in format: id,qty,price|id,qty,price     expected_total
    ${product_1},2,100000|${product_2},1,150000               350000
    Given Prepare Valid Invoice Data
    When Send Create Invoice Request
    Then Response Status Code Should Be 200
    And Response Data Should Match Request    ${REQUEST_DATA}
```

### 4.2 Negative Test Case
```robotframework
RT-IN-002 Create invoice fails with invalid data
    [Documentation]    Verify invoice creation fails with invalid data
    Given Prepare Invalid Invoice Data
    When Send Create Invoice Request
    Then Response Status Code Should Be 420
    And Response Should Have Error "Invalid data"
```

## 5. Common Utilities

### 5.1 Request Helper
- POST requests
- Authentication headers
- Session management

### 5.2 Response Helper
- Status code verification
- Response validation
- Error message handling

### 5.3 Environment Configuration
```robotframework
*** Variables ***
${API_URL}    https://api.example.com
${AUTH_TOKEN}    token_value
```

## 6. Test Categories

### 6.1 Positive Tests
- Valid data scenarios
- Optional fields
- Different data combinations

### 6.2 Negative Tests
- Invalid data
- Missing required fields
- Business rule violations
- Authorization errors

## 7. Test Case Checklist

- [ ] Unique test case ID
- [ ] Clear description
- [ ] Documented prerequisites
- [ ] Well-defined test data
- [ ] Clear verification steps
- [ ] Error scenarios covered
- [ ] Business rules validated
- [ ] Reuse common test data in CommonData.robot

## 8. Common Patterns

### 8.1 Data Preparation
```robotframework
Prepare Test Data
    ${base_data}=    Evaluate    json.loads('''${TEMPLATE_DATA}''')    json
    Set To Dictionary    ${base_data}    field=value
    ${request_data}=    Evaluate    json.dumps(${base_data})    json
    RETURN    ${request_data}
```

### 8.2 Efficient Request Data Cloning and Modification
When you need to create variations of a standard request for different test cases, it's efficient to use a JSON-based deep copy approach. This ensures complete isolation between requests while keeping the code concise:

```robotframework
*** Settings ***
Library    json

*** Keywords ***
Chuẩn Bị Dữ Liệu Với Tham Số Tùy Chỉnh
    [Arguments]    ${code}    ${channel_id}=${EMPTY}
    # Tạo bản sao sâu của request chuẩn bằng JSON serialization
    ${request_json}=    Evaluate    json.dumps(${STANDARD_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    # Truy cập và sửa đổi trực tiếp các thuộc tính lồng nhau
    Set To Dictionary    ${request["Invoice"]}    Code=${code}
    
    # Chỉ cập nhật kênh bán nếu được cung cấp
    Run Keyword If    '${channel_id}' != '${EMPTY}'    Set To Dictionary    ${request["Invoice"]}    SaleChannelId=${channel_id}
    
    # Xóa thuộc tính nếu cần
    # Remove From Dictionary    ${request["Invoice"]}    PropertyToRemove
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}
```

This pattern offers several advantages:
- **Complete isolation**: Changes to one request won't affect others
- **Clean code**: Direct access to nested properties makes the code more readable
- **Flexibility**: Easily add, modify, or remove properties as needed
- **Reusability**: Standard request structure is defined once and reused

Example usage in a test case:
```robotframework
RT-XX-001 Test case with custom invoice code
    [Documentation]    Tests with a custom invoice code
    Given Chuẩn Bị Dữ Liệu Với Tham Số Tùy Chỉnh    HD_CUSTOM_001    2
    When Gửi Yêu Cầu API
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
```

### 8.3 Response Verification
```robotframework
Verify Response
    [Arguments]    ${response}    ${expected_data}
    Status Should Be    200    ${response}
    Dictionary Should Contain Key    ${response.json()}    key
    Should Be Equal    ${response.json()['field']}    ${expected_data['field']}
```

### 8.4 Combining Deep Cloning with Embedded Parameters

The deep cloning approach can be combined with embedded parameters to create highly readable and flexible test cases. This pattern is especially useful for complex data structures that need to be modified in multiple ways:

```robotframework
*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã ${code} Và Kênh Bán ${channel_id}
    # Tạo bản sao sâu của request chuẩn
    ${request_json}=    Evaluate    json.dumps(${STANDARD_INVOICE_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    # Cập nhật trực tiếp các thuộc tính theo tham số
    Set To Dictionary    ${request["Invoice"]}    Code=${code}
    
    # Chỉ cập nhật kênh bán nếu không rỗng
    Run Keyword If    '${channel_id}' != '${EMPTY}'    Set To Dictionary    ${request["Invoice"]}    SaleChannelId=${channel_id}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Hóa Đơn Có ${count} Sản Phẩm Với Tổng Tiền ${total}
    # Truy xuất trực tiếp thông tin từ response
    ${invoice}=    Set Variable    ${RESPONSE.json()}
    
    # Xác thực thông tin
    Length Should Be    ${invoice["InvoiceDetails"]}    ${count}
    Should Be Equal As Numbers    ${invoice["Total"]}    ${total}
```

Example usage in test cases:
```robotframework
RT-XX-002 Tạo hóa đơn Facebook với mã tùy chỉnh
    [Documentation]    Kiểm tra tạo hóa đơn với mã tùy chỉnh qua kênh Facebook
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã FB_CUSTOM_001 Và Kênh Bán 2
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Hóa Đơn Có 1 Sản Phẩm Với Tổng Tiền 100000

RT-XX-003 Tạo hóa đơn thông thường
    [Documentation]    Kiểm tra tạo hóa đơn thông thường không qua kênh bán
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã HD_TEST_001 Và Kênh Bán ${EMPTY}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Hóa Đơn Có 1 Sản Phẩm Với Tổng Tiền 100000
```

Benefits of combining these patterns:
- **Highly readable test cases**: Test scenarios are self-documenting
- **Reduced duplication**: Deep cloning ensures data isolation while embedded parameters make the code flexible
- **Maintainable**: Changes to standard data structure only need to be made once
- **Natural language**: Tests read like specifications
- **Improved reporting**: Test reports show descriptive steps with actual parameter values

### 8.5 Creating Utility Functions for Data Manipulation

To improve code readability, maintainability, and reduce duplication, create utility functions for data manipulation in a dedicated file (`Keywords/Utilities/DataUtilities.robot`):

```robotframework
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
    [Documentation]    Updates a nested property in a dictionary using a path with dot notation
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
    [Documentation]    Removes a nested property from a dictionary using a path
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
    [Documentation]    Adds an item to a list at the specified path in a dictionary
    [Arguments]    ${dictionary}    ${path}    ${item}
    @{parts}=    Split String    ${path}    .
    ${current}=    Set Variable    ${dictionary}
    
    # Navigate to the target list
    FOR    ${part}    IN    @{parts}
        ${current}=    Get From Dictionary    ${current}    ${part}
    END
    
    # Add the item to the list
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
    [Documentation]    Gets a nested property from a dictionary using a path
    [Arguments]    ${dictionary}    ${property_path}
    @{parts}=    Split String    ${property_path}    .
    ${current}=    Set Variable    ${dictionary}
    
    FOR    ${part}    IN    @{parts}
        ${current}=    Get From Dictionary    ${current}    ${part}
    END
    
    RETURN    ${current}
```

These utility functions can then be used throughout your code, making data preparation keywords cleaner and more maintainable:

```robotframework
Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Hợp Lệ
    # Sao chép sâu STANDARD_INVOICE_REQUEST sử dụng utility function
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    
    # Cập nhật trực tiếp mã hóa đơn
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    ${VALID_INVOICE_CODE}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}
```

For more complex data preparation:

```robotframework
Chuẩn Bị Dữ Liệu Hóa Đơn Phức Tạp
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    HD_COMPLEX_001
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Description    Hóa đơn phức tạp
    ${request}=    Add Invoice Detail    ${request}    ${PRODUCT_1}    2    100000    10000
    ${request}=    Add Invoice Detail    ${request}    ${PRODUCT_2}    1    150000
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}
```

This approach provides:
- **Cleaner code**: Complex operations are wrapped in descriptive functions
- **Better code organization**: Utility functions are centralized in one file
- **Easier maintenance**: Updates to data handling logic only need to be made in one place
- **Improved readability**: Keywords express intention more clearly
- **Consistent data handling**: Common patterns for modifying nested data structures

By importing `DataUtilities.robot` in your test files, you make these utility functions available across all test cases, promoting consistent data handling patterns throughout your test suite.

## 9. Maintenance Tips

1. Keep test data updated
2. Regular review of test cases
3. Monitor API changes
4. Update authentication tokens
5. Maintain documentation
