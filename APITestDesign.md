# API Test Case Design Guide

## 1. Test Case Structure

### 1.1 File Organization
```
robotframework-tests/
├── Config/                                 # Store configuration files
├── Env.robot                               # Global environment variables
├── Keywords/                               # All keywords used in the project
│   ├── Database/                           # Common keywords for working with Database
│   ├── Utilities/                          # Common utility keywords
│   │   ├── RequestHelper.robot             # Utilities for handling requests
│   │   ├── ResponseHelper.robot            # Utilities for handling responses
│   │   └── Utilities.robot                 # Other common utilities
│   └── {API Name}/                           # Each API module has its own folder (eg, Invoice for InvoiceAPI)
│       └── {Feature}Keywords.robot         # Feature-specific keywords
├── Resources/                              # External libraries
│   └── DatabaseLibrary.py                  # Library to execute database query 
├── TestData/                               # All test data used in the project
│   ├── CommonData.robot                    # Common test data
│   └── {API Name}/                           # Each API module has its own test data folder (eg, Invoice for InvoiceAPI)
│       └── {Feature}Data.robot             # Feature-specific test data
└── TestSpecs/                              # All test specifications
    ├── API/                                # API test specifications
    │   └── {API Name}/                       # Each API module (eg, Invoice for InvoiceAPI)
    │       └── {Feature}Test.robot         # Feature-specific API tests
    └── E2E/                                # End-to-end test specifications
        └── {Feature}Test.robot             # Feature-specific E2E tests
```
### 1.2 Test Case Generation Crititical Rules

**Before creating a test case, must review `@CommonData.robot`, `@Env.robot`, and all files in the `@Utilities` folder to**
- Understand the environnment variable, commond data and common keywords
- Reuse those common data, keywords, variable instead of create new ones

#### Structure and Organization
- **Test cases must strictly follow the Given-When-Then (GWT) pattern without any preparation or calculation code**
- **Test cases must be written in Vietnamese**
- **Each test case ID should follow the format: `RT-{Module}-{Number}`**
- **Test case description must include test logic with specific example data and clear expected results**
- Include source code references in documentation when testing specific algorithms or calculations
- **Similar test case must group into one test case with multiple assert**
 - For example successful test case with multiple condition should be grouped to 1 test case with multiple assert

#### Grouping Similar Test Cases with Templates
- **Use templates to group similar test cases that test the same condition with different values**
  ```robotframework
  RT-XX-001 Test successful scenarios with multiple conditions
      [Documentation]    Test successful cases with multiple conditions
      [Template]    Test Various Successful Conditions
      # Value   expected_result
      Value 1    Result 1
      Value 2    Result 2
      Value 3    Result 3
  ```
- **Define template keywords that follow the Given-When-Then pattern:**
  ```robotframework
  Test Various Successful Conditions
      [Arguments]    ${condition}    ${expected_result}
      Given Chuẩn Bị Dữ Liệu Với ${condition}
      When Gửi Yêu Cầu API
      Then Response Status Code Should Be 200
      And Xác Thực ${expected_result}
  ```
- **For error cases, use a separate template that handles error verification:**
  ```robotframework
  RT-XX-002 Test error scenarios with multiple conditions
      [Documentation]    Test error cases with multiple conditions
      [Template]    Test Various Error Conditions
      # condition   expected_error
      Invalid Input A    Error message A
      Invalid Input B    Error message B
  ```

#### Single Given Statement with Multiple Embedded Parameters for multiple conditions
- **Use a single Given statement with multiple embedded parameters for readability and conciseness:**
  ```robotframework
  Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Người Nhận "${receiver}" Số Điện Thoại "${phone}" Địa Chỉ "${address}"
  ```
- **Similarly, use verification steps with multiple embedded parameters:**
  ```robotframework
  And Xác Thực Thông Tin Người Nhận "${receiver}" Số Điện Thoại "${phone}" Địa Chỉ "${address}"
  ```
- **Create descriptive keywords with embedded parameters for both setup and verification:**
  ```robotframework
  Chuẩn Bị Dữ Liệu Hóa Đơn Với Gói Hàng Kích Thước "${dimensions}" Trọng Lượng ${weight} Loại ${type}
  Xác Thực Thông Tin Kích Thước Gói Hàng "${dimensions}" Trọng Lượng ${weight} Loại ${type}
  ```
- **Ensure embedded parameters are clearly named and maintain readability in Vietnamese**

#### Data Management
- **Must reuse common test data to minimize the number of test data**
- Each API module should have its own CommonData file (e.g., `InvoiceCommonData.robot`) with:
  - Standard request body variables
  - Reusable test data constants
- **For test data specific for the test case only, or new common test data must use mpc to get the id, code of appropriated records in the database (record has column RetailerId is the value of robot framework variable ${RETAILER_ID})**
 
- **Always use deep copy of standard request body templates when preparing test data:**
  ```robotframework
  ${request}=    Evaluate    json.loads(json.dumps(${STANDARD_REQUEST}))    json
  ```

- **Modify only necessary fields in the copied request body for your specific test case**
- **Reference environment variables from `Env.robot` for API endpoints and configuration**

#### Keyword Design
- **Use embedded parameters in keywords to improve readability:**
  ```robotframework
  Chuẩn Bị Dữ Liệu Hóa Đơn Với ${product_count} Sản Phẩm Tổng Giá Trị ${total}
  ```
- **Create reusable, descriptive keywords that clearly communicate their purpose**
- **Keep keywords focused on a single responsibility**
- **Use keyword documentation to explain complex logic**
- **Keywords must NEVER appear in test specification files** 
  ✓ Place keywords in the appropriate module/feature keywords file
  ✗ Do not define keywords in test spec files
- **Test cases must strictly follow Given-When-Then without preparations**
- **API Request Handling: All test cases MUST use the Call API keyword defined in Utilities.robot (`@Utilities.robot`) - never implement custom API call methods or place this keyword in other files**
- **Verification keywords must be clear about what and how it is verified** 
```robotframework
  Chuẩn Bị Dữ Liệu Hóa Đơn Với ${product_count} Sản Phẩm Tổng Giá Trị ${total}
  Xác Thực Mã Sản Phẩm ${product_code} Đã Được Chuẩn Hóa thành ${normalized_product_code}
  ```

#### Validation
- Never call APIs to set up test data or validate test results
- Always verify that expected data is correctly inserted/updated in the database
- Include verification steps for both API response and database state
- Use database queries to verify data integrity and consistency

#### Efficiency Tips
- Group similar test cases with templates when appropriate
- Follow established patterns for common test scenarios (batch processing, inventory, etc.)
- Reuse existing utility keywords rather than creating duplicate functionality
- Organize test data logically with clear naming conventions

### 1.3 Test Case Pattern
```robotframework
RT-{Module}-{Number} {Description}
    [Documentation]    Description of test purpose
    Given {Prepare Data Step}
    When {Execute Action Step}
    Then {Verify Response Code}
    And {Additional Verification Steps}
```

### 1.3 Test Grouping (IMPORTANT)

#### Grouping Similar Test Cases
Test cases with similar conditions but testing the same feature MUST be grouped into a single test case with multiple assertions.

❌ INCORRECT APPROACH (DO NOT DO THIS):
```robotframework
RT-XX-001 Test successful scenario with condition A
    [Documentation]    Test successful case A
    Given Prepare Test Data for Condition A
    When Execute Action
    Then Verify Result A

RT-XX-002 Test successful scenario with condition B
    [Documentation]    Test successful case B
    Given Prepare Test Data for Condition B
    When Execute Action
    Then Verify Result B
```

✅ CORRECT APPROACH (DO THIS):
```robotframework
RT-XX-001 Test successful scenarios with multiple conditions
    [Documentation]    Test successful cases with multiple conditions
    [Template]    Test Various Successful Conditions
    # condition   expected_result
    Condition A    Result A
    Condition B    Result B
    Condition C    Result C
```

#### When to Create Separate Test Cases
Only create separate test cases when testing:
1. Fundamentally different features
2. Error/failure scenarios (each distinct error should have its own test case)
3. Different API endpoints

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
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py

*** Keywords ***
Prepare Test Data
    ${request_data}=    Create Test Data
    Set Test Variable    ${REQUEST_DATA}    ${request_data}

Send API Request    
    ${response}=    Call API    api_endpoint    ${REQUEST_DATA}    
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

### 3.4 Verification Keyword Best Practices

#### 3.4.1 Verification Keyword Naming Guidelines
Verification keywords must clearly communicate both WHAT is being verified and HOW it is being verified. Follow these patterns:

```robotframework
Xác Thực [OBJECT] ${parameter} [CONDITION] [EXPECTED_STATE]
```

Where:
- **OBJECT**: The specific element or field being verified (e.g., Mã Sản Phẩm, Tên Sản Phẩm)
- **parameter**: Embedded parameter showing what value is being tested (e.g., ${product_code})
- **CONDITION**: The context or condition being tested (e.g., Đã Được Chuẩn Hóa)
- **EXPECTED_STATE**: The expected outcome or state (e.g., Không Chứa Ký Tự Đặc Biệt)

**Examples of GOOD verification keyword names:**
```robotframework
Xác Thực Mã Sản Phẩm ${product_code} Đã Được Chuẩn Hóa Thành Mã Không Chứa Ký Tự Đặc Biệt
Xác Thực Tên Sản Phẩm ${product_name} Đã Được Chuẩn Hóa Theo Định Dạng Unicode NFC
Xác Thực Mô Tả Sản Phẩm ${product_code} Đã Được Chuẩn Hóa HTML Không Còn Thẻ p Trống
Xác Thực Lỗi Trùng Tên Đơn Vị Cùng Một Sản Phẩm
```

**Examples of BAD verification keyword names (too generic):**
```robotframework
Kiểm Tra Mã Sản Phẩm     # Không nêu rõ đang xác thực điều gì về mã sản phẩm
Xác Thực Tên Sản Phẩm     # Không nêu rõ đang xác thực điều gì về tên sản phẩm
Xác Thực Lỗi              # Quá mơ hồ, không nêu rõ loại lỗi nào
```

#### 3.4.2 Verification Keyword Implementation Guidelines
Every verification statement should include:
1. A clear assertion message explaining what's being checked
2. Detailed error messages that help diagnose failures
3. Logging of actual vs. expected values when appropriate

**Example implementation:**
```robotframework
Xác Thực Mã Sản Phẩm ${product_code} Đã Được Chuẩn Hóa Thành Mã Không Chứa Ký Tự Đặc Biệt
    # 1. Fetch the data to verify
    ${result}=    Fetch One    ${QUERY_GET_PRODUCT_BY_CODE}    ${product_code}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm với mã ${product_code}
    
    # 2. Extract the specific field to verify
    ${db_code}=    Set Variable    ${result[1]}
    
    # 3. Perform specific verification with detailed error messages
    Should Not Contain    ${db_code}    #    Mã sản phẩm vẫn chứa ký tự đặc biệt #
    Should Not Contain    ${db_code}    @    Mã sản phẩm vẫn chứa ký tự đặc biệt @
    Should Not Contain    ${db_code}    &    Mã sản phẩm vẫn chứa ký tự đặc biệt &
    
    # 4. Log important values for debugging
    Log    Mã sản phẩm gốc [${product_code}] đã được chuẩn hóa thành [${db_code}]
```

#### 3.4.3 Error Verification Guidelines
When verifying error conditions, always include:
1. The expected HTTP status code
2. The exact error message expected
3. A clear description of the error condition

Example:
```robotframework
Xác Thực Lỗi Mô Tả Vượt Giới Hạn 30000 Ký Tự
    Response Status Code Should Be 420    API phải trả về lỗi nghiệp vụ (mã 420) khi mô tả vượt quá 30000 ký tự
    Response Should Have Error "Mô tả sản phẩm vượt quá giới hạn cho phép"    Thông báo lỗi phải nêu rõ mô tả vượt giới hạn
```

### 3.5 Embedded Parameter Pattern
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

### 6.3 Inventory Management Tests
- Inventory update with different product types (regular, batch, serial)
- Inventory reservation and release
- Batch handling with different strategies (FIFO, FEFO, LIFO, lowest cost)
- Multi-branch inventory operations
- Handling negative inventory and permissions

## 7. Test Case Checklist

- [ ] Unique test case ID
- [ ] Clear description
- [ ] Documented prerequisites
- [ ] Well-defined test data
- [ ] Clear verification steps
- [ ] Error scenarios covered
- [ ] Business rules validated
- [ ] Reuse common test data in CommonData.robot
- [ ] Ưu tiên embedded param in keywords

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

### 8.3 Pattern kiểm thử cho quản lý lô (batch) và đặt giữ (reservation)

Khi kiểm thử các tính năng liên quan đến quản lý lô và đặt giữ, chúng ta nên sử dụng các pattern sau:

#### 8.3.1. Kiểm thử đặt giữ (Reservation Testing)

1. **Cấu trúc cơ bản cho test case đặt giữ**:
   ```
   [Test Case]
   1. Chuẩn bị dữ liệu hóa đơn với ReservationMode=1
   2. Lưu trạng thái ban đầu của Reserved và OnHand
   3. Gửi yêu cầu tạo đặt giữ
   4. Xác thực Reserved thay đổi, OnHand không thay đổi
   ```

2. **Kiểm tra lifecycle đầy đủ của đặt giữ**:
   ```
   [Test Case]
   1. Tạo đặt giữ (Reserved +)
   2. Xác nhận đặt giữ (Reserved -, OnHand -)
   3. Tùy chọn: Hủy đặt giữ (Reserved -, OnHand không đổi)
   ```

#### 8.3.2. Kiểm thử xử lý lô (Batch Testing)

1. **Cấu trúc cơ bản cho test case xử lý lô**:
   ```
   [Test Case]
   1. Chuẩn bị dữ liệu hóa đơn với BatchProcessingType="[FIFO|FEFO|LIFO|LowestCost]"
   2. Lưu trạng thái ban đầu của các lô
   3. Gửi yêu cầu tạo hóa đơn
   4. Xác thực lô được xuất theo đúng thứ tự quy định
   ```

2. **Kiểm tra lifecycle đầy đủ của lô**:
   ```
   [Test Case]
   1. Tạo lô mới với ngày hết hạn
   2. Xuất lô
   3. Tùy chọn: Hủy xuất lô
   ```

#### 8.3.3. Kết hợp kiểm thử lô và đặt giữ

Có thể kết hợp cả hai pattern trên để kiểm thử các trường hợp phức tạp hơn:
   ```
   [Test Case]
   1. Tạo đặt giữ với lô cụ thể (Reserved +, lô không thay đổi)
   2. Xác nhận đặt giữ (Reserved -, lô giảm)
   ```

### 8.4 Response Verification
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

## 8. Test Implementation Strategies

### 8.1 Inventory Update Testing

Khi kiểm thử cập nhật tồn kho, cần triển khai các chiến lược sau:

1. **Chuẩn bị dữ liệu tồn kho ban đầu**:
   ```robotframework
   Xem Thông Tin Tồn Kho Ban Đầu Của Sản Phẩm ${product_id}
       ${query}=    Set Variable    SELECT BranchId, ProductId, OnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
       ${result}=    Fetch One    ${query}    ${product_id}    ${BRANCH_ID}
       Should Not Be Equal    ${result}    None    Không tìm thấy thông tin tồn kho ban đầu
       ${initial_onhand}=    Set Variable    ${result[2]}
       Set Test Variable    ${INITIAL_ONHAND}    ${initial_onhand}
       RETURN    ${initial_onhand}
   ```

2. **Xác thực thay đổi tồn kho**:
   ```robotframework
   Xác Thực Số Lượng Tồn Kho Giảm ${quantity} Đơn Vị
       [Arguments]    ${product_id}
       ${query}=    Set Variable    SELECT BranchId, ProductId, OnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
       ${result}=    Fetch One    ${query}    ${product_id}    ${BRANCH_ID}
       Should Not Be Equal    ${result}    None    Không tìm thấy thông tin tồn kho
       ${new_onhand}=    Set Variable    ${result[2]}
       ${expected_onhand}=    Evaluate    ${INITIAL_ONHAND} - ${quantity}
       Should Be Equal As Numbers    ${new_onhand}    ${expected_onhand}    Số lượng tồn kho không giảm đúng
   ```

3. **Xác thực lịch sử tồn kho**:
   ```robotframework
   Xác Thực Lịch Sử Tồn Kho
       [Arguments]    ${product_id}    ${quantity}    ${document_type}
       ${query}=    Set Variable    SELECT DocumentId, DocumentType, ProductId, Value FROM InventoryTracking WHERE DocumentId = ? AND ProductId = ? AND DocumentType = ?
       ${result}=    Fetch One    ${query}    ${INVOICE_ID}    ${product_id}    ${document_type}
       Should Not Be Equal    ${result}    None    Không tìm thấy lịch sử tồn kho
       ${expected_value}=    Evaluate    -${quantity}
       Should Be Equal As Numbers    ${result[3]}    ${expected_value}    Giá trị thay đổi tồn kho không khớp
   ```

### 8.2 Batch Handling Testing

Khi kiểm thử xử lý lô, cần triển khai các chiến lược sau:

1. **Chuẩn bị kiểm tra xử lý lô theo quy tắc cụ thể**:
   ```robotframework
   Chuẩn Bị Dữ Liệu Xử Lý Lô Theo ${processing_type}
       ${data}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
       ${details}=    Create List    
       ${product_detail}=    Create Dictionary    ProductId=${product_batch}    ProductCode=BATCH001    Quantity=${quantity}    Price=100000    BatchProcessingType=${processing_type}
       Append To List    ${details}    ${product_detail}
       ${data}=    Update Nested Dictionary Property    ${data}    Invoice.InvoiceDetails    ${details}
       ${data}=    Update Nested Dictionary Property    ${data}    Invoice.Code    HD_BATCH_${processing_type}_001
       Set Test Variable    ${REQUEST_DATA}    ${data}
       RETURN    ${data}
   ```

2. **Xác thực lô được xuất theo quy tắc**:
   ```robotframework
   Xác Thực Lô Được Xuất Theo Quy Tắc ${processing_type}
       [Arguments]    ${product_id}    ${quantity}
       # Lấy danh sách lô theo thứ tự phù hợp với quy tắc processing_type
       ${batches}=    Lấy Danh Sách Lô Theo Quy Tắc    ${product_id}    ${processing_type}
       
       # Lấy lịch sử xuất lô
       ${tracking_results}=    Fetch All    SELECT BatchExpireId, Value FROM BatchExpireTracking WHERE DocumentId = ? AND DocumentType = 3    ${INVOICE_ID}
       
       # Xác thực lô được xuất theo đúng thứ tự quy định
       # Chi tiết thực hiện tùy thuộc vào từng quy tắc processing_type
   ```

### 8.3 Reservation Testing

Khi kiểm thử đặt giữ, cần triển khai các chiến lược sau:

1. **Chuẩn bị dữ liệu hóa đơn với chế độ đặt giữ**:
   ```robotframework
   Chuẩn Bị Dữ Liệu Hóa Đơn Với Chế Độ Đặt Giữ
       ${data}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
       ${data}=    Update Nested Dictionary Property    ${data}    Invoice.ReservationMode    1
       ${data}=    Update Nested Dictionary Property    ${data}    Invoice.Status    3
       Set Test Variable    ${REQUEST_DATA}    ${data}
       RETURN    ${data}
   ```

2. **Xác thực số lượng đặt giữ**:
   ```robotframework
   Xác Thực Số Lượng Đặt Giữ Tăng ${quantity} Đơn Vị
       [Arguments]    ${product_id}
       ${query}=    Set Variable    SELECT BranchId, ProductId, OnHand, Reserved FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
       ${result}=    Fetch One    ${query}    ${product_id}    ${BRANCH_ID}
       Should Not Be Equal    ${result}    None    Không tìm thấy thông tin đặt giữ
       ${new_reserved}=    Set Variable    ${result[3]}
       ${expected_reserved}=    Evaluate    ${INITIAL_RESERVED} + ${quantity}
       Should Be Equal As Numbers    ${new_reserved}    ${expected_reserved}    Số lượng đặt giữ không tăng đúng
   ```
