# Robotframework-tests

This repository contains automation tests for the project using Robot Framework.

## Project Structure

- **Env.robot** - Common variables used across tests
- **Keywords/** - Robot Framework keyword definitions
  - **Utilities/** - Common/shared keywords
  - Other files - API-specific keyword implementations
- **TestData/** - Test data storage
  - **CommonData.robot** - Shared test data
  - Other files - Test case specific data
- **TestSpecs/** - Robot Framework test cases in Given-When-Then format
  - **API/** - API test cases
  - **E2E/** - End-to-end test cases
- **table_descriptions.sql** - Database schema definition
- **Prompts.md** - AI prompt collection

## Test Case Standards

### Naming Conventions
- Test case format: `RT-<API Endpoint>-<TestNumber>`
  - RT: Standard prefix
  - API Endpoint: The endpoint being tested
  - TestNumber: Sequential number
- Test file format: `Test<API Endpoint>.robot`
- Location: `TestSpecs/API/<API Endpoint>API/`
- Keywords file format: `<API Endpoint>Keywords.robot`
- Location: `Keywords/<API Enpoint>API/`
- Test data file format: `<API Endpoint>Data.robot`
- Location: `TestData/<API Endpoint>Data.robot`

### Example Test Case

```robotframework
*** Test Cases ***
RT-CreateInvoice-1
    Given customer ${customer_1}, product ${product_common_1} exist in the system
    And the customer has debt amount x
    When we Post /api/invoices with ${valid_invoice_data} with total value y
    Then the API return 200 and customer debt is calculated correctly to x + y
```

### Test Case Template
```robotframework
*** Settings ***
Resource          Env.robot
Resource          TestData/CommonData.robot
Resource          Keywords/Invoice/CreateInvoiceKeywords.robot

*** Test Cases ***
    # Test cases go here
```

## Best Practices

1. Test Data Management
   - Use predefined variables (e.g., ${customer_1})
   - Reuse common test data when possible
   - Don't insert new test data - use existing data
   - Data in the test data file must have the name with prefix with the file name. for example in CreateInvoiceData.robot file all data must has name prefixed with create_invoice.

2. Test Structure
   - Follow Given-When-Then format
   - Include cleanup functions
   - Make test cases self-descriptive
   - Store all test data in TestData folder

3. Implementation Guidelines
   - Tests should manage their own data
   - Use existing database state
   - Update existing data instead of creating new

## Running Tests

1. Install Robot Framework:
```sh
pip install robotframework
```

2. Run specific tests:
```sh
cd TestSpecs/API
robot .
```

3. Run all tests:
```sh
robot TestSpecs
```

## Contributing

Please fork the repository and submit pull requests for contributions.

## License

MIT License
