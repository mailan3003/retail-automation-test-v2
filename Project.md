# KiotViet API Testing Project Documentation

## 1. Project Overview
This project contains automated API tests for KiotViet's Invoice API using Robot Framework. The tests validate business flows, edge cases, and data handling.

## 2. Directory Structure
robotframework-tests/ 
├── TestSpecs/
│   └── API/
│       └── InvoiceAPI/
│           └── CreateInvoiceTest.robot 
├── Keywords/
│   ├── InvoiceAPI/
│   │   └── CreateInvoiceKeywords.robot 
│   └── Utilities/
│       ├── RequestHelper.robot 
│       └── ResponseHelper.robot 
├── TestData/
│   ├── CommonData.robot 
│   └── InvoiceAPI/ 
│       └── CreateInvoiceData.robot 
└── Project.md

## 3. Test Case Organization

### 3.1 ID Convention
- Format: `RT-IN-{number}`
  - RT: RobotTest prefix
  - IN: Invoice module
  - Number ranges:
    - 001-099: Basic functionality tests
    - 101-199: Combined scenarios
    - 201-299: Edge cases 
    - 301-399: Complex business rules
    - 401-499: Validation tests

### 3.2 Test Categories and Examples

#### Basic Functionality (001-099)
```robotframework
RT-IN-001 - Tạo hóa đơn thành công với các sản phẩm
    [Documentation]    Kiểm tra tạo hóa đơn với nhiều sản phẩm:
    ...    - SP1: 2 x 100,000đ = 200,000đ
    ...    - SP2: 1 x 150,000đ = 150,000đ
    [Template]    Create Basic Invoice With Products And Verify
    ${product_1},2,100000|${product_2},1,150000    350000
```

## 4. Test Categories

### 4.1 Basic Functionality (001-099)
- Create invoice with products
- Payment methods
- Tax calculation
- Simple discounts
- Example:

### 4.2 Combined Scenarios (101-199)
- Multiple payments
- Tax + promotions
- Complex pricing
- Example:

### 4.3 Edge Cases (201-299)
- Maximum values
- Zero values
- Special characters
- Example:

### 4.4 Complex Rules (301-399)
- Multi-tier promotions
- Points calculation
- Warranty handling
- Example:

### 4.5 Validation Tests (401-499)
- Missing required fields
- Invalid values
- Business rule violations
- Example:

## 5. Test Data Management

### 5.1 Request Templates
Store in TestData/InvoiceAPI/CreateInvoiceData.robot:

### 5.2 Common Variables
Store in TestData/CommonData.robot:

## 6. Keywords Structure

### 6.1 Basic Operations

### 6.2 Business Logic Keywords

### 6.3 Verification Keywords

## 7. Best Practices

### 7.1 Test Case Organization
- Group related tests together
- Order from simple to complex
- Clear separation of categories
- Use descriptive names

### 7.2 Test Data
- Use variables for repeated values
- Group related data
- Use meaningful variable names
- Keep data close to tests

### 7.3 Keywords
- Reusable components
- Clear arguments
- Proper verification
- Error handling

### 7.4 Documentation
- Clear test purpose
- Input data
- Expected results
- Business rules

## 8. Execution Guidelines

### 8.1 Required Setup
- Python 3.7+
- Robot Framework
- Required libraries
- API access configured

### 8.2 Running Tests

### 8.3 Viewing Results
- Report: results/report.html
- Log: results/log.html
- Output: results/output.xml

## 9. Maintenance Guidelines

### 9.1 Adding Tests
- Choose appropriate category/ID
- Create test data if needed
- Implement keywords if needed
- Add test case
- Update documentation

### 9.2 Modifying Tests
- Maintain ID convention
- Update documentation
- Verify dependencies
- Test changes
- Update Project.md

### 9.3 Review Process
- Code review
- Documentation review
- Test execution
- Results verification
- Final approval