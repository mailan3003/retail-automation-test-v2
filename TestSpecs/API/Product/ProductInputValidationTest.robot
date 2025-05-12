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
    [Tags]    productvalidate    unitvalidation    AIGenerated
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