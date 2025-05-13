*** Settings ***
Documentation     Test API kiểm tra và xác thực đầu vào khi thêm sản phẩm
Resource          ../../../Keywords/Product/InputValidationKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Utilities/Utilities.robot
Resource          ../../../Keywords/Utilities/DataUtilities.robot
Resource          ../../../Keywords/Utilities/RequestHelper.robot
Resource          ../../../TestData/Product/ProductInputData.robot
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    ProductInputValidationTest

*** Test Cases ***

RT-PD-002 Kiểm tra định dạng JSON không hợp lệ
    [Documentation]    Kiểm tra xử lý khi định dạng JSON không hợp lệ
    ...    - Source: ProductAPI.cs > ProductAddMany
    ...    - Logic: Bắt lỗi từ JsonConvert.DeserializeObject và ném KvValidateProductException
    ...    - Dữ liệu đầu vào: JSON không hợp lệ "{không phải JSON hợp lệ}"
    ...    - Kỳ vọng: Lỗi 500
    [Tags]    productvalidate    apierror    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với JSON Không Hợp Lệ
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 500

RT-PD-003 Kiểm tra vượt quá giới hạn sản phẩm combo
    [Documentation]    Kiểm tra lỗi khi thêm quá 50 sản phẩm combo cùng lúc
    ...    - Source: ProductAPI.cs > ProductAddMany
    ...    - Logic: Kiểm tra nếu req.ListProducts.Count > 50 và ProductType = Manufactured
    ...    - Dữ liệu đầu vào: Danh sách 51 sản phẩm combo (ProductType = 2)
    ...    - Kỳ vọng: Lỗi "${ERROR_PRODUCT_LIMIT_COMBO}"
    [Tags]    productvalidate    limit    AIGenerated
    Given Chuẩn Bị Dữ Liệu Với 51 Sản Phẩm Combo
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi ${ERROR_PRODUCT_LIMIT_COMBO}

RT-PD-004 Kiểm tra vượt quá giới hạn tổng số sản phẩm
    [Documentation]    Kiểm tra lỗi khi thêm quá 200 sản phẩm cùng lúc
    ...    - Source: ProductAPI.cs > ProductAddMany
    ...    - Logic: Kiểm tra nếu req.ListProducts.Count > 200
    ...    - Dữ liệu đầu vào: Danh sách 201 sản phẩm
    ...    - Kỳ vọng: Lỗi "${ERROR_PRODUCT_LIMIT}"
    [Tags]    productvalidate    limit    AIGenerated
    Given Chuẩn Bị Dữ Liệu Với 201 Sản Phẩm
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi ${ERROR_PRODUCT_LIMIT}

RT-PD-005 Kiểm tra định dạng chi nhánh không hợp lệ
    [Documentation]    Kiểm tra xử lý khi định dạng chi nhánh không hợp lệ
    ...    - Source: ProductAPI.cs > ProductAddMany
    ...    - Logic: Bắt lỗi từ JsonConvert.DeserializeObject của BranchForProductCostss
    ...    - Dữ liệu đầu vào: formData["BranchForProductCostss"] = "{không phải JSON hợp lệ}"
    ...    - Kỳ vọng: Lỗi "Dữ liệu không hợp lệ"
    [Tags]    productvalidate    apierror    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Định Dạng Chi Nhánh Không Hợp Lệ
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 500

RT-PD-006 Kiểm tra lỗi khi đơn vị tính trùng nhau trong cùng sản phẩm
    [Documentation]    Kiểm tra xử lý khi có đơn vị tính trùng nhau trong cùng sản phẩm
    ...    - Source: ProductAPI.cs > ProductAddMany
    ...    - Logic: Kiểm tra tính nhất quán của đơn vị
    ...    - Dữ liệu đầu vào: Sản phẩm với các đơn vị tính trùng nhau (chiếc, Chiếc)
    ...    - Kỳ vọng: Lỗi "${ERROR_DUPLICATE_UNIT}"
    [Tags]    productvalidate    unitvalidation1    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Trùng Tên
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi ${ERROR_DUPLICATE_UNIT}

RT-PD-007 Kiểm tra thành công khi đơn vị tính không trùng nhau trong cùng sản phẩm
    [Documentation]    Kiểm tra xử lý thành công khi đơn vị tính không trùng nhau trong cùng sản phẩm
    ...    - Source: ProductAPI.cs > ProductAddMany
    ...    - Logic: Kiểm tra tính nhất quán của đơn vị
    ...    - Dữ liệu đầu vào: Sản phẩm với các đơn vị tính khác nhau (Chiếc, Hộp, Thùng)
    ...    - Kỳ vọng: Tạo thành công, status code 200
    [Tags]    productvalidate    unitvalidation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Đơn Vị Không Trùng
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And InputValidationKeywords.Nội dung phản hồi trả về phải tồn tại Id

RT-PD-008 Kiểm tra trùng lặp mã sản phẩm
    [Documentation]    Kiểm tra xử lý khi có mã sản phẩm trùng lặp trong hệ thống
    ...    - Source: ProductAPI.cs > GetProductFromProductByBranch
    ...    - Logic: Kiểm tra nếu có sản phẩm trong DB trùng mã với danh sách đầu vào
    ...    - Dữ liệu đầu vào: Sản phẩm với mã đã tồn tại trong hệ thống
    ...    - Kỳ vọng: Lỗi "Mã hàng đã tồn tại"
    [Tags]    productvalidate    duplicatevalidation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Mã Trùng Lặp
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi ${ErrorMessage}

RT-PD-009 Kiểm tra trùng lặp mã vạch
    [Documentation]    Kiểm tra xử lý khi có mã vạch trùng lặp trong hệ thống
    ...    - Source: ProductAPI.cs > GetProductFromProductByBranch
    ...    - Logic: Kiểm tra nếu có sản phẩm trong DB trùng mã vạch với danh sách đầu vào
    ...    - Dữ liệu đầu vào: Sản phẩm với mã vạch đã tồn tại trong hệ thống
    ...    - Kỳ vọng: Lỗi "${ERROR_DUPLICATE_BARCODE}"
    [Tags]    productvalidate    duplicatevalidation1    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Mã Vạch Trùng Lặp
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi ${ErrorMessage}

RT-PD-010 Kiểm tra công thức sản phẩm không hợp lệ
    [Documentation]    Kiểm tra xử lý khi công thức sản phẩm không hợp lệ
    ...    - Source: ProductAPI.cs > GetProductFromProductByBranch
    ...    - Logic: Gọi productFormulaService.ValidateListFormula() để xác thực danh sách công thức
    ...    - Dữ liệu đầu vào: Sản phẩm với công thức chứa vật liệu không tồn tại
    ...    - Kỳ vọng: Lỗi "${ERROR_INVALID_FORMULA}"
    [Tags]    productvalidate    formulavalidation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Công Thức Không Hợp Lệ
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi ${ERROR_INVALID_FORMULA}

RT-PD-011 Kiểm tra vị trí không tồn tại
    [Documentation]    Kiểm tra xử lý khi vị trí không tồn tại trong hệ thống
    ...    - Source: ProductAPI.cs > GetProductFromProductByBranch
    ...    - Logic: Kiểm tra vị trí tồn tại trong hệ thống
    ...    - Dữ liệu đầu vào: Sản phẩm với bảng giá không tồn tại
    ...    - Kỳ vọng: Lỗi "${ERROR_SHELF_NOT_FOUND}"
    [Tags]    productvalidate    shelfvalidation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Số Lượng Vị Trí Không Tồn Tại
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi ${ERROR_SHELF_NOT_FOUND}

RT-PD-012 Kiểm tra giá trị chuyển đổi đơn vị không hợp lệ
    [Documentation]    Kiểm tra xử lý khi giá trị chuyển đổi đơn vị <= 0
    ...    - Source: ProductAPI.cs > GetProductFromProductByBranch
    ...    - Logic: Kiểm tra nếu ConversionValue <= 0
    ...    - Dữ liệu đầu vào: Sản phẩm với ConversionValue = 0
    ...    - Kỳ vọng: Giá trị mặc định = 1
    [Tags]    productvalidate    unitconversion    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Giá Trị Chuyển Đổi Không Hợp Lệ
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Giá Trị Chuyển Đổi Đã Được Chuẩn Hóa Thành 1

RT-PD-013 Kiểm tra sản phẩm kiểm soát serial có đơn vị phụ
    [Documentation]    Kiểm tra xử lý khi sản phẩm kiểm soát serial có đơn vị phụ
    ...    - Source: ProductAPI.cs > GetProductFromProductByBranch
    ...    - Logic: Kiểm tra nếu sản phẩm có kiểm soát serial thì không được có đơn vị phụ
    ...    - Dữ liệu đầu vào: Sản phẩm kiểm soát serial với đơn vị phụ
    ...    - Kỳ vọng: Lỗi "${ERROR_SERIAL_UNIT}"
    [Tags]    productvalidate    serialvalidation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Serial Với Đơn Vị Phụ
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi ${ERROR_SERIAL_UNIT}

RT-PD-014 Kiểm tra độ dài mã sản phẩm vượt quá giới hạn
    [Documentation]    Kiểm tra xử lý khi độ dài mã sản phẩm > 40 ký tự
    ...    - Source: ProductAPI.cs > GetProductFromProductByBranch
    ...    - Logic: Kiểm tra độ dài mã sản phẩm
    ...    - Dữ liệu đầu vào: Sản phẩm với mã dài 41 ký tự
    ...    - Kỳ vọng: Lỗi "${ERROR_CODE_LENGTH}"
    [Tags]    productvalidate    lengthvalidation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Mã Dài 41 Ký Tự
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi ${ERROR_CODE_LENGTH}

RT-PD-015 Kiểm tra độ dài mã vạch vượt quá giới hạn
    [Documentation]    Kiểm tra xử lý khi độ dài mã vạch > 16 ký tự
    ...    - Source: ProductAPI.cs > GetProductFromProductByBranch
    ...    - Logic: Kiểm tra độ dài mã vạch
    ...    - Dữ liệu đầu vào: Sản phẩm với mã vạch dài 17 ký tự
    ...    - Kỳ vọng: Lỗi "${ERROR_BARCODE_LENGTH}"
    [Tags]    productvalidate    lengthvalidation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Mã Vạch Dài 17 Ký Tự
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi ${ERROR_BARCODE_LENGTH}

RT-PD-018 Kiểm tra độ dài tên sản phẩm vượt quá giới hạn
    [Documentation]    Kiểm tra xử lý khi độ dài tên sản phẩm > 500 ký tự
    ...    - Source: ProductAPI.cs > GetProductFromProductByBranch
    ...    - Logic: Kiểm tra độ dài tên sản phẩm
    ...    - Dữ liệu đầu vào: Sản phẩm với tên dài 501 ký tự
    ...    - Kỳ vọng: Lỗi "${ERROR_NAME_LENGTH}"
    [Tags]    productvalidate    lengthvalidation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Tên Dài 501 Ký Tự
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi ${ERROR_NAME_LENGTH}