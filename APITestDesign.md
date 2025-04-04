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
