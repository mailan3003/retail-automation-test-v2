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

# add test cases here

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

RT-PD-019 Kiểm tra danh sách vật liệu rỗng
    [Documentation]    Kiểm tra xử lý khi danh sách vật liệu rỗng
    ...    - Source: ProductAPI.cs > ValidateListFormula
    ...    - Logic: Kiểm tra nếu danh sách vật liệu rỗng thì không cần xác thực
    ...    - Dữ liệu đầu vào: Sản phẩm với danh sách vật liệu rỗng
    ...    - Kỳ vọng: Tạo thành công, status code 200
    [Tags]    productvalidate    formulavalidation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Danh Sách Vật Liệu Rỗng
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And InputValidationKeywords.Nội dung phản hồi trả về phải tồn tại Id

RT-PD-020 Kiểm tra sản phẩm tự tham chiếu chính nó
    [Documentation]    Kiểm tra xử lý khi sản phẩm tự tham chiếu chính nó trong công thức
    ...    - Source: ProductAPI.cs > ValidateListFormula
    ...    - Logic: Kiểm tra nếu sản phẩm tự tham chiếu chính nó trong công thức
    ...    - Dữ liệu đầu vào: Sản phẩm với vật liệu là chính nó
    ...    - Kỳ vọng: Lỗi "${PRODUCT_CODE}: ${ERROR_RECURSIVE_FORMULA}"
    [Tags]    productvalidate    formulavalidation1    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Vật Liệu Là Chính Nó
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi ${PRODUCT_CODE}: ${ERROR_RECURSIVE_FORMULA}

RT-PD-021 Kiểm tra sử dụng sản phẩm đơn vị con trong công thức
    [Documentation]    Kiểm tra xử lý khi sử dụng sản phẩm đơn vị con trong công thức
    ...    - Source: ProductAPI.cs > ValidateListFormula
    ...    - Logic: Kiểm tra nếu có sản phẩm đơn vị con trong danh sách vật liệu
    ...    - Dữ liệu đầu vào: Sản phẩm với vật liệu là sản phẩm đơn vị con
    ...    - Kỳ vọng: Lỗi "${ERROR_SUB_UNIT_IN_FORMULA}"
    [Tags]    productvalidate    formulavalidation2    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Vật Liệu Là Đơn Vị Con
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi ${ERROR_SUB_UNIT_IN_FORMULA}

RT-PD-022 Kiểm tra vòng lặp đệ quy trong công thức
    [Documentation]    Kiểm tra xử lý khi phát hiện vòng lặp đệ quy trong công thức
    ...    - Source: ProductAPI.cs > ValidateListFormula
    ...    - Logic: Kiểm tra nếu có vòng lặp đệ quy trong cấu trúc công thức
    ...    - Dữ liệu đầu vào: Sản phẩm A chứa B, B chứa A trong công thức
    ...    - Kỳ vọng: Lỗi "${ERROR_RECURSIVE_FORMULA}"
    [Tags]    productvalidate    formulavalidation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Vòng Lặp Đệ Quy
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi ${ERROR_RECURSIVE_FORMULA}

RT-PD-023 Kiểm tra độ sâu công thức vượt quá giới hạn
    [Documentation]    Kiểm tra xử lý khi độ sâu công thức vượt quá giới hạn cho phép
    ...    - Source: ProductAPI.cs > ValidateListFormula
    ...    - Logic: Kiểm tra nếu tổng độ sâu của công thức vượt quá MaxFormulaLevelSupported
    ...    - Dữ liệu đầu vào: Sản phẩm với cấu trúc công thức quá sâu
    ...    - Kỳ vọng: Lỗi "${ERROR_FORMULA_DEPTH}"
    [Tags]    productvalidate    formulavalidation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Công Thức Quá Sâu
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi ${ERROR_FORMULA_DEPTH}

RT-PD-024 Kiểm tra công thức hợp lệ
    [Documentation]    Kiểm tra xử lý khi công thức hợp lệ
    ...    - Source: ProductAPI.cs > ValidateListFormula
    ...    - Logic: Kiểm tra công thức với các điều kiện hợp lệ
    ...    - Dữ liệu đầu vào: Sản phẩm với công thức hợp lệ (không tự tham chiếu, không đơn vị con, không vòng lặp, độ sâu trong giới hạn)
    ...    - Kỳ vọng: Tạo thành công, status code 200
    [Tags]    productvalidate    formulavalidation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Công Thức Hợp Lệ
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And InputValidationKeywords.Nội dung phản hồi trả về phải tồn tại Id

RT-PD-025 Kiểm tra đơn vị tính trống
    [Documentation]    Kiểm tra xử lý khi đơn vị tính của sản phẩm con bị trống
    ...    - Source: ProductAPI.cs > GetProductFromProductByBranch
    ...    - Logic: Kiểm tra nếu sản phẩm có MasterUnitId nhưng Unit trống
    ...    - Dữ liệu đầu vào: Sản phẩm con với Unit trống
    ...    - Kỳ vọng: Lỗi "${ERROR_NOT_INPUT_UNIT}"
    [Tags]    productvalidate    unitvalidation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Con Với Đơn Vị Trống
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi ${ERROR_NOT_INPUT_UNIT}

RT-PD-026 Kiểm tra đơn vị tính nhiều cấp
    [Documentation]    Kiểm tra xử lý khi sản phẩm con có sản phẩm cha cũng là sản phẩm con
    ...    - Source: ProductAPI.cs > GetProductFromProductByBranch
    ...    - Logic: Kiểm tra nếu sản phẩm cha có MasterUnitId không null
    ...    - Dữ liệu đầu vào: Sản phẩm con với sản phẩm cha cũng là sản phẩm con
    ...    - Kỳ vọng: Lỗi "${ERROR_INVALID_MASTER_UNIT}"
    [Tags]    productvalidate    unitvalidation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Con Với Sản Phẩm Cha Là Sản Phẩm Con
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi ${ERROR_INVALID_MASTER_UNIT}

RT-PD-028 Kiểm tra trùng tên đơn vị với sản phẩm con khác
    [Documentation]    Kiểm tra xử lý khi sản phẩm con có tên đơn vị trùng với sản phẩm con khác
    ...    - Source: ProductAPI.cs > GetProductFromProductByBranch
    ...    - Logic: Kiểm tra nếu sản phẩm con có tên đơn vị trùng với sản phẩm con khác của cùng sản phẩm cha
    ...    - Dữ liệu đầu vào: Sản phẩm con với tên đơn vị giống sản phẩm con khác
    ...    - Kỳ vọng: Lỗi "${ERROR_DUPLICATE_UNIT}"
    [Tags]    productvalidate    unitvalidation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Con Với Tên Đơn Vị Trùng Sản Phẩm Con Khác
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi ${ERROR_DUPLICATE_UNIT}

RT-PD-029 Kiểm tra đơn vị tính hợp lệ
    [Documentation]    Kiểm tra xử lý khi đơn vị tính hợp lệ
    ...    - Source: ProductAPI.cs > GetProductFromProductByBranch
    ...    - Logic: Kiểm tra với đơn vị tính hợp lệ (không trống, không trùng, không nhiều cấp)
    ...    - Dữ liệu đầu vào: Sản phẩm con với đơn vị tính hợp lệ
    ...    - Kỳ vọng: Tạo thành công, status code 200
    [Tags]    productvalidate    unitvalidation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Con Với Đơn Vị Tính Hợp Lệ
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And InputValidationKeywords.Nội dung phản hồi trả về phải tồn tại Id

RT-PD-033 Kiểm tra xác thực thuộc tính sản phẩm không tồn tại
    [Documentation]    Kiểm tra xử lý khi thuộc tính không tồn tại trong hệ thống
    ...    - Source: ProductAPI.cs > ValidateProductAttributes
    ...    - Logic: Ném ngoại lệ khi có thuộc tính không tồn tại
    ...    - Dữ liệu đầu vào: Sản phẩm với thuộc tính có ID không tồn tại trong DB
    ...    - Kỳ vọng: Lỗi "${ERROR_ATTRIBUTE_NOT_FOUND}"
    [Tags]    productvalidate    attributevalidation1    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuộc Tính Không Tồn Tại
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi ${ERROR_ATTRIBUTE_NOT_FOUND}

RT-PD-035 Kiểm tra mô tả sản phẩm rỗng
    [Documentation]    Kiểm tra xử lý khi mô tả sản phẩm rỗng
    ...    - Source: ProductAPI.cs > ValidateMaxSizeDescription
    ...    - Logic: Bỏ qua xác thực nếu mô tả rỗng
    ...    - Dữ liệu đầu vào: Sản phẩm với mô tả rỗng
    ...    - Kỳ vọng: Tạo thành công, status code 200
    [Tags]    productvalidate    descriptionvalidation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Mô Tả Rỗng
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 200

RT-PD-036 Kiểm tra mô tả sản phẩm vượt quá giới hạn kích thước
    [Documentation]    Kiểm tra xử lý khi mô tả sản phẩm vượt quá giới hạn kích thước
    ...    - Source: ProductAPI.cs > ValidateMaxSizeDescription
    ...    - Logic: Tính toán kích thước mô tả bằng Unicode encoding và so sánh với MaxSizeProductDescription
    ...    - Dữ liệu đầu vào: Sản phẩm với mô tả có kích thước vượt quá giới hạn
    ...    - Kỳ vọng: Lỗi "${ERROR_DESCRIPTION_SIZE}"
    [Tags]    productvalidate    descriptionvalidation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Mô Tả Vượt Quá Giới Hạn
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi ${ERROR_DESCRIPTION_SIZE}

RT-PD-037 Kiểm tra mô tả sản phẩm hợp lệ
    [Documentation]    Kiểm tra xử lý khi mô tả sản phẩm hợp lệ
    ...    - Source: ProductAPI.cs > ValidateMaxSizeDescription
    ...    - Logic: Tính toán kích thước mô tả bằng Unicode encoding và so sánh với MaxSizeProductDescription
    ...    - Dữ liệu đầu vào: Sản phẩm với mô tả có kích thước trong giới hạn
    ...    - Kỳ vọng: Tạo thành công, status code 200
    [Tags]    productvalidate    descriptionvalidation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Mô Tả Hợp Lệ
    When Gửi Yêu Cầu Thêm Sản Phẩm
    Then Mã Trạng Thái Phải Là 200