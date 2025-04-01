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

### 8.2 Response Verification
```robotframework
Verify Response
    [Arguments]    ${response}    ${expected_data}
    Status Should Be    200    ${response}
    Dictionary Should Contain Key    ${response.json()}    key
    Should Be Equal    ${response.json()['field']}    ${expected_data['field']}
```

## 9. Maintenance Tips

1. Keep test data updated
2. Regular review of test cases
3. Monitor API changes
4. Update authentication tokens
5. Maintain documentation
