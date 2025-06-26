*** Settings ***
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource    ../../../Keywords/Invoice/EInvoice_VLXD_Keywords.robot
Resource    ../../../Keywords/Utilities/RequestHelper.robot
Resource    ../../../Keywords/Utilities/ResponseHelper.robot
Resource    ../../../TestData/Invoice/EInvoice_VLXD_Data.robot
Resource    ../../../Keywords/Login/Login.robot

*** Test Cases ***

RT-INPV-01 Tạo hóa đơn điện tử thành công ở chi nhánh trung tâm với NCC HDDT Viettel
    [Documentation]    Test case tạo hóa đơn điện tử thành công với nhà cung cấp Viettel
    ...    - Mục đích: Kiểm tra luồng tạo hóa đơn điện tử hoàn chỉnh từ hóa đơn thường
    ...    - Tham số đầu vào:
    ...    - Sản phẩm: Đơn giá 68000 VND, số lượng 1
    ...    - Chi nhánh: ${BRANCH_TRUNG_TAM} (chi nhánh trung tâm)
    ...    - NCC HDDT: ${PARTNER_TYPE_VT} (Viettel)
    ...    - Template: ${E_INVOICE_TEMPLATE_VT} (template Viettel)
    ...    - Các bước thực hiện:
    ...    - 1. Chuẩn bị dữ liệu hóa đơn với UUID duy nhất
    ...    - 2. Gửi request tạo hóa đơn thường
    ...    - 3. Xác thực response có chứa Invoice ID
    ...    - 4. Chuẩn bị dữ liệu hóa đơn điện tử với Viettel
    ...    - 5. Gửi request tạo hóa đơn điện tử với branch_id tùy chỉnh
    ...    - 6. Xác thực tạo thành công hóa đơn điện tử
    ...    - Kết quả mong đợi:
    ...    - Status code: 200
    ...    - Response có chứa id = 0 (thành công)
    ...    - Hóa đơn điện tử được tạo trong database với Status = 1 hoặc 2
    [Tags]    apieinvoicemultibranch
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá 68000 VND Số Lượng 1 Chi Nhánh ${BRANCH_TRUNG_TAM}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử Với NCC HDDT ${PARTNER_TYPE_VT} Và Template HDDT ${E_INVOICE_TEMPLATE_VT}
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử Với Custom BranchId    ${BRANCH_TRUNG_TAM}
    Then Response Status Code Should Be 200
    And Nội Dung Phản Hồi Phải Tồn Tại Code HDDT
    And Xác Thực Hóa Đơn Điện Tử Đã Tạo Thành Công

RT-INPV-02 Tạo hóa đơn điện tử thành công ở chi nhánh A với NCC HDDT KiotViet
    [Documentation]    Test case tạo hóa đơn điện tử thành công với nhà cung cấp KiotViet ở chi nhánh A
    ...    - Mục đích: Kiểm tra luồng tạo hóa đơn điện tử hoàn chỉnh từ hóa đơn thường ở chi nhánh A
    ...    - Tham số đầu vào:
    ...    - Sản phẩm: Đơn giá 68000 VND, số lượng 1
    ...    - Chi nhánh: ${BRANCH_CHI_NHANH_A} (1000000062 - chi nhánh A)
    ...    - NCC HDDT: ${PARTNER_TYPE_KV} (4 - KiotViet)
    ...    - Template: ${E_INVOICE_TEMPLATE_KV} (2_C25MKV - template KiotViet)
    ...    - Các bước thực hiện:
    ...    - 1. Chuẩn bị dữ liệu hóa đơn với UUID duy nhất cho chi nhánh A
    ...    - 2. Gửi request tạo hóa đơn thường với branch_id = 1000000062
    ...    - 3. Xác thực response có chứa Invoice ID > 0
    ...    - 4. Chuẩn bị dữ liệu hóa đơn điện tử với KiotViet (PartnerType=4, Template=2_C25MKV)
    ...    - 5. Gửi request tạo hóa đơn điện tử với branch_id tùy chỉnh = 1000000062
    ...    - 6. Xác thực tạo thành công hóa đơn điện tử trong database
    ...    - Kết quả mong đợi:
    ...    - Status code: 200 (thành công)
    ...    - Response có chứa id = 0 (thành công tạo hóa đơn điện tử)
    ...    - Hóa đơn điện tử được tạo trong database với Status = 1 hoặc 2
    ...    - UUID hóa đơn được lưu trong bảng EInvoice với Code = ${INVOICE_UUID}
    [Tags]    apieinvoicemultibranch
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá 68000 VND Số Lượng 1 Chi Nhánh ${BRANCH_CHI_NHANH_A}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử Với NCC HDDT ${PARTNER_TYPE_KV} Và Template HDDT ${E_INVOICE_TEMPLATE_KV}
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử Với Custom BranchId    ${BRANCH_CHI_NHANH_A}
    Then Response Status Code Should Be 200
    And Nội Dung Phản Hồi Phải Tồn Tại Code HDDT
    And Xác Thực Hóa Đơn Điện Tử Đã Tạo Thành Công

RT-INPV-03 Tạo hóa đơn điện tử sử dụng template HDDT bị lỗi ở chi nhánh trung tâm
    [Documentation]    Test case tạo hóa đơn điện tử sử dụng template HDDT bị lỗi ở chi nhánh trung tâm
    ...    - Mục đích: Kiểm tra lỗi khi tạo hóa đơn điện tử với template HDDT không hợp lệ hoặc bị lỗi ở chi nhánh trung tâm
    ...    - Tham số đầu vào:
    ...    - Sản phẩm: Đơn giá 68000 VND, số lượng 1
    ...    - Chi nhánh: ${BRANCH_TRUNG_TAM} (1000000028 - chi nhánh trung tâm)
    ...    - NCC HDDT: ${PARTNER_TYPE_VT} (2 - Viettel)
    ...    - Template: 99b93352-b1e9-4af2-92fd-eb5c3410642d (template bị lỗi hoặc không hợp lệ)
    ...    - Các bước thực hiện:
    ...    - 1. Chuẩn bị dữ liệu hóa đơn với UUID duy nhất cho chi nhánh trung tâm
    ...    - 2. Gửi request tạo hóa đơn thường với branch_id = 1000000028
    ...    - 3. Xác thực response có chứa Invoice ID > 0
    ...    - 4. Chuẩn bị dữ liệu hóa đơn điện tử với Viettel và template bị lỗi
    ...    - 5. Gửi request tạo hóa đơn điện tử với branch_id tùy chỉnh = 1000000028
    ...    - 6. Xác thực hệ thống trả về lỗi do template không hợp lệ
    ...    - Kết quả mong đợi:
    ...    - Status code: 420 (lỗi - template HDDT không hợp lệ)
    ...    - Hệ thống từ chối tạo hóa đơn điện tử với template bị lỗi
    ...    - Đảm bảo tính toàn vẹn dữ liệu khi template không hợp lệ
    ...    - Ngăn chặn việc tạo hóa đơn điện tử với template không tồn tại hoặc bị lỗi
    [Tags]    apieinvoicemultibranch
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá 68000 VND Số Lượng 1 Chi Nhánh ${BRANCH_TRUNG_TAM}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử Với NCC HDDT ${PARTNER_TYPE_VT} Và Template HDDT 99b93352-b1e9-4af2-92fd-eb5c3410642d
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử Với Custom BranchId    ${BRANCH_TRUNG_TAM}
    Then Response Status Code Should Be 420

RT-INPV-04 Tạo hóa đơn điện tử với hóa đơn đã phát hành ở chi nhánh trung tâm
    [Documentation]    Test case tạo hóa đơn điện tử với hóa đơn đã phát hành ở chi nhánh trung tâm
    ...    - Mục đích: Kiểm tra lỗi khi tạo hóa đơn điện tử trùng lặp với hóa đơn đã được phát hành trước đó ở chi nhánh A
    ...    - Tham số đầu vào:
    ...    - Sản phẩm: Đơn giá 68000 VND, số lượng 1
    ...    - Chi nhánh: ${BRANCH_TRUNG_TAM} (1000000028 - chi nhánh trung tâm)
    ...    - NCC HDDT: ${PARTNER_TYPE_VT} (2 - Viettel)
    ...    - Template: ${E_INVOICE_TEMPLATE_VT} 
    ...    - Các bước thực hiện:
    ...    - 1. Chuẩn bị dữ liệu hóa đơn với UUID duy nhất cho chi nhánh A
    ...    - 2. Gửi request tạo hóa đơn thường với branch_id = 1000000028
    ...    - 3. Xác thực response có chứa Invoice ID > 0
    ...    - 4. Chuẩn bị dữ liệu hóa đơn điện tử với KiotViet (PartnerType=4, Template=2_C25MKV)
    ...    - 5. Gửi request tạo hóa đơn điện tử lần thứ nhất với branch_id = 1000000028 (thành công)
    ...    - 6. Gửi request tạo hóa đơn điện tử lần thứ hai với cùng branch_id = 1000000028 (trùng lặp)
    ...    - Kết quả mong đợi:
    ...    - Status code: 420 (lỗi - hóa đơn đã được phát hành)
    ...    - Hệ thống từ chối tạo hóa đơn điện tử trùng lặp
    ...    - Đảm bảo tính duy nhất của hóa đơn điện tử trong cùng chi nhánh
    ...    - Ngăn chặn việc tạo nhiều hóa đơn điện tử cho cùng một hóa đơn gốc
    [Tags]    apieinvoicemultibranch
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá 68000 VND Số Lượng 1 Chi Nhánh ${BRANCH_TRUNG_TAM}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử Với NCC HDDT ${PARTNER_TYPE_VT} Và Template HDDT ${E_INVOICE_TEMPLATE_VT}
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử Với Custom BranchId    ${BRANCH_TRUNG_TAM}
    And Xác Thực Hóa Đơn Điện Tử Đã Tạo Thành Công
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử Với Custom BranchId    ${BRANCH_TRUNG_TAM}
    Then Response Status Code Should Be 420 
    And Nội dung phản hồi phải chứa message DataExisted
    
RT-INPV-05 Tạo hóa đơn điện tử với hóa đơn đã phát hành ở chi nhánh A
    [Documentation]    Test case tạo hóa đơn điện tử với hóa đơn đã phát hành ở chi nhánh A
    ...    - Mục đích: Kiểm tra lỗi khi tạo hóa đơn điện tử trùng lặp với hóa đơn đã được phát hành trước đó ở chi nhánh A
    ...    - Tham số đầu vào:
    ...    - Sản phẩm: Đơn giá 68000 VND, số lượng 1
    ...    - Chi nhánh: ${BRANCH_CHI_NHANH_A} (1000000062 - chi nhánh A)
    ...    - NCC HDDT: ${PARTNER_TYPE_KV} (4 - KiotViet)
    ...    - Template: ${E_INVOICE_TEMPLATE_KV} (2_C25MKV - template KiotViet)
    ...    - Các bước thực hiện:
    ...    - 1. Chuẩn bị dữ liệu hóa đơn với UUID duy nhất cho chi nhánh A
    ...    - 2. Gửi request tạo hóa đơn thường với branch_id = 1000000062
    ...    - 3. Xác thực response có chứa Invoice ID > 0
    ...    - 4. Chuẩn bị dữ liệu hóa đơn điện tử với KiotViet (PartnerType=4, Template=2_C25MKV)
    ...    - 5. Gửi request tạo hóa đơn điện tử lần thứ nhất với branch_id = 1000000062 (thành công)
    ...    - 6. Gửi request tạo hóa đơn điện tử lần thứ hai với cùng branch_id = 1000000062 (trùng lặp)
    ...    - Kết quả mong đợi:
    ...    - Status code: 420 (lỗi - hóa đơn đã được phát hành)
    ...    - Hệ thống từ chối tạo hóa đơn điện tử trùng lặp
    ...    - Đảm bảo tính duy nhất của hóa đơn điện tử trong cùng chi nhánh
    ...    - Ngăn chặn việc tạo nhiều hóa đơn điện tử cho cùng một hóa đơn gốc
    [Tags]    apieinvoicemultibranch
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá 68000 VND Số Lượng 1 Chi Nhánh ${BRANCH_CHI_NHANH_A}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử Với NCC HDDT ${PARTNER_TYPE_KV} Và Template HDDT ${E_INVOICE_TEMPLATE_KV}
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử Với Custom BranchId    ${BRANCH_CHI_NHANH_A}
    And Xác Thực Hóa Đơn Điện Tử Đã Tạo Thành Công
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử Với Custom BranchId    ${BRANCH_CHI_NHANH_A}
    Then Response Status Code Should Be 420
    And Nội dung phản hồi phải chứa message DataExisted

RT-INPV-06 Tạo Hóa đơn điện tử sử dụng template HDDT bị lỗi ở chi nhánh A
    [Documentation]    Test case tạo hóa đơn điện tử sử dụng template HDDT bị lỗi ở chi nhánh A
    ...    - Mục đích: Kiểm tra lỗi khi tạo hóa đơn điện tử với template HDDT không hợp lệ hoặc bị lỗi ở chi nhánh A
    ...    - Sản phẩm: Đơn giá 68000 VND, số lượng 1
    ...    - Chi nhánh: ${BRANCH_CHI_NHANH_A} (1000000062 - chi nhánh A)
    ...    - NCC HDDT: ${PARTNER_TYPE_KV} (2 - KiotViet)
    ...    - Template: 99b93352-b1e9-4af2-92fd-eb5c3410642d (template bị lỗi hoặc không hợp lệ)
    ...    - Các bước thực hiện:
    ...    - 1. Chuẩn bị dữ liệu hóa đơn với UUID duy nhất cho chi nhánh trung tâm
    ...    - 2. Gửi request tạo hóa đơn thường với branch_id = 1000000062
    ...    - 3. Xác thực response có chứa Invoice ID > 0
    ...    - 4. Chuẩn bị dữ liệu hóa đơn điện tử với Viettel và template bị lỗi
    ...    - 5. Gửi request tạo hóa đơn điện tử với branch_id tùy chỉnh = 1000000062
    ...    - 6. Xác thực hệ thống trả về lỗi do template không hợp lệ
    ...    - Kết quả mong đợi:
    ...    - Status code: 420 (lỗi - template HDDT không hợp lệ)
    ...    - Hệ thống từ chối tạo hóa đơn điện tử với template bị lỗi
    ...    - Đảm bảo tính toàn vẹn dữ liệu khi template không hợp lệ
    [Tags]    apieinvoicemultibranch
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá 68000 VND Số Lượng 1 Chi Nhánh ${BRANCH_CHI_NHANH_A}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử Với NCC HDDT ${PARTNER_TYPE_KV} Và Template HDDT 99b93352-b1e9-4af2-92fd-eb5c3410642d
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử Với Custom BranchId    ${BRANCH_CHI_NHANH_A}
    Then Response Status Code Should Be 420

RT-INPV-07 Tạo hóa đơn điện tử thành công với hóa đơn đã hủy ở chi nhánh trung tâm
    [Documentation]    Test case tạo hóa đơn điện tử thành công với hóa đơn đã hủy ở chi nhánh trung tâm
    ...    - Mục đích: Kiểm tra khả năng tạo hóa đơn điện tử từ hóa đơn đã được hủy trước đó ở chi nhánh trung tâm
    ...    - Tham số đầu vào:
    ...    - Sản phẩm: Đơn giá 68000 VND, số lượng 1
    ...    - Chi nhánh: ${BRANCH_TRUNG_TAM} (1000000028 - chi nhánh trung tâm)
    ...    - NCC HDDT: ${PARTNER_TYPE_VT} (2 - Viettel)
    ...    - Template: ${E_INVOICE_TEMPLATE_VT} (2/3117_C25MLL - template Viettel)
    ...    - Các bước thực hiện:
    ...    - 1. Chuẩn bị dữ liệu hóa đơn với UUID duy nhất cho chi nhánh trung tâm
    ...    - 2. Gửi request tạo hóa đơn thường với branch_id = 1000000028
    ...    - 3. Xác thực response có chứa Invoice ID > 0
    ...    - 4. Cập nhật trạng thái hóa đơn sang "Hủy" trong database
    ...    - 5. Chuẩn bị dữ liệu hóa đơn điện tử với Viettel (PartnerType=2, Template=2/3117_C25MLL)
    ...    - 6. Gửi request tạo hóa đơn điện tử với branch_id tùy chỉnh = 1000000028
    ...    - 7. Xác thực tạo thành công hóa đơn điện tử từ hóa đơn đã hủy
    ...    - Kết quả mong đợi:
    ...    - Status code: 200 (thành công)
    ...    - Response có chứa id = 0 (thành công tạo hóa đơn điện tử)
    ...    - Hóa đơn điện tử được tạo thành công từ hóa đơn đã hủy
    ...    - UUID hóa đơn được lưu trong bảng EInvoice với Code = ${INVOICE_UUID}
    ...    - Chứng minh hệ thống cho phép tạo hóa đơn điện tử từ hóa đơn đã hủy
    [Tags]    apieinvoicemultibranch
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá 68000 VND Số Lượng 1 Chi Nhánh ${BRANCH_TRUNG_TAM}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Cập Nhật Hóa Đơn Sang Trạng Thái Hủy
    And Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử Với NCC HDDT ${PARTNER_TYPE_VT} Và Template HDDT ${E_INVOICE_TEMPLATE_VT}
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử Với Custom BranchId    ${BRANCH_TRUNG_TAM}
    Then Response Status Code Should Be 200
    And Nội Dung Phản Hồi Phải Tồn Tại Code HDDT
    And Xác Thực Hóa Đơn Điện Tử Đã Tạo Thành Công

RT-INPV-08 Tạo hóa đơn điện tử thành công với hóa đơn đã hủy ở chi nhánh A
    [Documentation]    Test case tạo hóa đơn điện tử thành công với hóa đơn đã hủy ở chi nhánh A
    ...    - Mục đích: Kiểm tra khả năng tạo hóa đơn điện tử từ hóa đơn đã được hủy trước đó ở chi nhánh A
    ...    - Tham số đầu vào:
    ...    - Sản phẩm: Đơn giá 68000 VND, số lượng 1
    ...    - Chi nhánh: ${BRANCH_CHI_NHANH_A} (1000000062 - chi nhánh A)
    ...    - NCC HDDT: ${PARTNER_TYPE_KV} (4 - KiotViet)
    ...    - Template: ${E_INVOICE_TEMPLATE_KV} (2_C25MKV - template KiotViet)
    ...    - Các bước thực hiện:
    ...    - 1. Chuẩn bị dữ liệu hóa đơn với UUID duy nhất cho chi nhánh A
    ...    - 2. Gửi request tạo hóa đơn thường với branch_id = 1000000062
    ...    - 3. Xác thực response có chứa Invoice ID > 0
    ...    - 4. Cập nhật trạng thái hóa đơn sang "Hủy" trong database
    ...    - 5. Chuẩn bị dữ liệu hóa đơn điện tử với KiotViet (PartnerType=4, Template=2_C25MKV)
    ...    - 6. Gửi request tạo hóa đơn điện tử với branch_id tùy chỉnh = 1000000062
    ...    - 7. Xác thực tạo thành công hóa đơn điện tử từ hóa đơn đã hủy
    ...    - Kết quả mong đợi:
    ...    - Status code: 200 (thành công)
    ...    - Response có chứa id = 0 (thành công tạo hóa đơn điện tử)
    ...    - Hóa đơn điện tử được tạo thành công từ hóa đơn đã hủy
    ...    - UUID hóa đơn được lưu trong bảng EInvoice với Code = ${INVOICE_UUID}
    ...    - Chứng minh hệ thống cho phép tạo hóa đơn điện tử từ hóa đơn đã hủy ở chi nhánh A
    [Tags]    apieinvoicemultibranch
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá 68000 VND Số Lượng 1 Chi Nhánh ${BRANCH_CHI_NHANH_A}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Cập Nhật Hóa Đơn Sang Trạng Thái Hủy
    And Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử Với NCC HDDT ${PARTNER_TYPE_KV} Và Template HDDT ${E_INVOICE_TEMPLATE_KV}
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử Với Custom BranchId    ${BRANCH_CHI_NHANH_A}
    Then Response Status Code Should Be 200
    And Nội Dung Phản Hồi Phải Tồn Tại Code HDDT
    And Xác Thực Hóa Đơn Điện Tử Đã Tạo Thành Công

RT-INPV-09 Tạo hóa đơn điện tử thành công với hóa đơn giao hàng ở chi nhánh trung tâm
    [Documentation]    Test case tạo hóa đơn điện tử thành công với hóa đơn giao hàng ở chi nhánh trung tâm
    ...    - Mục đích: Kiểm tra khả năng tạo hóa đơn điện tử từ hóa đơn đã được chuyển sang hình thức giao hàng ở chi nhánh trung tâm
    ...    - Tham số đầu vào:
    ...    - Sản phẩm: Đơn giá 68000 VND, số lượng 1
    ...    - Chi nhánh: ${BRANCH_TRUNG_TAM} (1000000028 - chi nhánh trung tâm)
    ...    - NCC HDDT: ${PARTNER_TYPE_VT} (2 - Viettel)
    ...    - Template: ${E_INVOICE_TEMPLATE_VT} (2/3117_C25MLL - template Viettel)
    ...    - Các bước thực hiện:
    ...    - 1. Chuẩn bị dữ liệu hóa đơn với UUID duy nhất cho chi nhánh trung tâm
    ...    - 2. Gửi request tạo hóa đơn thường với branch_id = 1000000028
    ...    - 3. Xác thực response có chứa Invoice ID > 0
    ...    - 4. Cập nhật hóa đơn sang hình thức giao hàng trong database
    ...    - 5. Chuẩn bị dữ liệu hóa đơn điện tử với Viettel (PartnerType=2, Template=2/3117_C25MLL)
    ...    - 6. Gửi request tạo hóa đơn điện tử với branch_id tùy chỉnh = 1000000028
    ...    - 7. Xác thực tạo thành công hóa đơn điện tử từ hóa đơn giao hàng
    ...    - Kết quả mong đợi:
    ...    - Status code: 200 (thành công)
    ...    - Response có chứa id = 0 (thành công tạo hóa đơn điện tử)
    ...    - Hóa đơn điện tử được tạo thành công từ hóa đơn giao hàng
    ...    - UUID hóa đơn được lưu trong bảng EInvoice với Code = ${INVOICE_UUID}
    ...    - Chứng minh hệ thống cho phép tạo hóa đơn điện tử từ hóa đơn giao hàng ở chi nhánh trung tâm
    [Tags]    apieinvoicemultibranch
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Cơ Bản Chi Nhánh ${BRANCH_TRUNG_TAM}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử Với NCC HDDT ${PARTNER_TYPE_VT} Và Template HDDT ${E_INVOICE_TEMPLATE_VT}
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử Với Custom BranchId    ${BRANCH_TRUNG_TAM}
    Then Response Status Code Should Be 200
    And Nội Dung Phản Hồi Phải Tồn Tại Code HDDT
    And Xác Thực Hóa Đơn Điện Tử Đã Tạo Thành Công

RT-INPV-10 Tạo hóa đơn điện tử thành công với hóa đơn giao hàng ở chi nhánh A
    [Documentation]    Test case tạo hóa đơn điện tử thành công với hóa đơn giao hàng ở chi nhánh A
    ...    - Mục đích: Kiểm tra khả năng tạo hóa đơn điện tử từ hóa đơn đã được chuyển sang hình thức giao hàng ở chi nhánh A
    ...    - Tham số đầu vào:
    ...    - Sản phẩm: Đơn giá 68000 VND, số lượng 1
    ...    - Chi nhánh: ${BRANCH_CHI_NHANH_A} (1000000062 - chi nhánh A)
    ...    - NCC HDDT: ${PARTNER_TYPE_KV} (4 - KiotViet)
    ...    - Template: ${E_INVOICE_TEMPLATE_KV} (2_C25MKV - template KiotViet)
    ...    - Các bước thực hiện:
    ...    - 1. Chuẩn bị dữ liệu hóa đơn với UUID duy nhất cho chi nhánh A
    ...    - 2. Gửi request tạo hóa đơn thường với branch_id = 1000000062
    ...    - 3. Xác thực response có chứa Invoice ID > 0
    ...    - 4. Cập nhật hóa đơn sang hình thức giao hàng trong database
    ...    - 5. Chuẩn bị dữ liệu hóa đơn điện tử với KiotViet (PartnerType=4, Template=2_C25MKV)
    ...    - 6. Gửi request tạo hóa đơn điện tử với branch_id tùy chỉnh = 1000000062
    ...    - 7. Xác thực tạo thành công hóa đơn điện tử từ hóa đơn giao hàng
    ...    - Kết quả mong đợi:
    ...    - Status code: 200 (thành công)
    ...    - Response có chứa id = 0 (thành công tạo hóa đơn điện tử)
    ...    - Hóa đơn điện tử được tạo thành công từ hóa đơn giao hàng
    ...    - UUID hóa đơn được lưu trong bảng EInvoice với Code = ${INVOICE_UUID}
    ...    - Chứng minh hệ thống cho phép tạo hóa đơn điện tử từ hóa đơn giao hàng ở chi nhánh A
    [Tags]    apieinvoicemultibranch
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Cơ Bản Chi Nhánh ${BRANCH_TRUNG_TAM}
    When Gửi Yêu Cầu Tạo Hóa Đơn
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Cập nhật hóa đơn sang hình thức giao hàng
    And Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử Với NCC HDDT ${PARTNER_TYPE_KV} Và Template HDDT ${E_INVOICE_TEMPLATE_KV}
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử Với Custom BranchId    ${BRANCH_CHI_NHANH_A}
    Then Response Status Code Should Be 200
    And Nội Dung Phản Hồi Phải Tồn Tại Code HDDT
    And Xác Thực Hóa Đơn Điện Tử Đã Tạo Thành Công

RT-INPV-11 Tạo hóa đơn điện tử với user không có quyền xuất hóa đơn điện tử ở chi nhánh trung tâm
#  API không chặn lỗi user không có quyền xuất hóa đơn điện tử
    [Documentation]    Test case tạo hóa đơn điện tử với user không có quyền xuất hóa đơn điện tử ở chi nhánh trung tâm
    ...    - Mục đích: Kiểm tra khả năng tạo hóa đơn điện tử khi user autotest không có quyền xuất hóa đơn điện tử ở chi nhánh trung tâm
    ...    - Tham số đầu vào:
    ...    - User: autotest (user không có quyền xuất hóa đơn điện tử)
    ...    - Sản phẩm: Đơn giá 68000 VND, số lượng 1
    ...    - Chi nhánh: ${BRANCH_TRUNG_TAM} (1000000028 - chi nhánh trung tâm)
    ...    - NCC HDDT: ${PARTNER_TYPE_VT} (2 - Viettel)
    ...    - Template: ${E_INVOICE_TEMPLATE_VT} (2/3117_C25MLL - template Viettel)
    ...    - Các bước thực hiện:
    ...    - 1. Thiết lập session cho user autotest với branch_id = 1000000028
    ...    - 2. Chuẩn bị dữ liệu hóa đơn với UUID duy nhất cho chi nhánh trung tâm
    ...    - 3. Gửi request tạo hóa đơn thường với user autotest
    ...    - 4. Xác thực response có chứa Invoice ID > 0
    ...    - 5. Chuẩn bị dữ liệu hóa đơn điện tử với Viettel (PartnerType=2, Template=2/3117_C25MLL)
    ...    - 6. Gửi request tạo hóa đơn điện tử với user autotest
    ...    - 7. Xác thực tạo thành công hóa đơn điện tử mặc dù user không có quyền
    ...    - Kết quả mong đợi:
    ...    - Status code: 200 (thành công)
    ...    - Response có chứa id = 0 (thành công tạo hóa đơn điện tử)
    ...    - Hóa đơn điện tử được tạo thành công bởi user không có quyền
    ...    - Chứng minh API không chặn lỗi user không có quyền xuất hóa đơn điện tử
    ...    - Hệ thống cho phép tạo hóa đơn điện tử bất kể quyền của user
    [Tags]    apieinvoicemultibranch

    Given Thiết Lập Session Cho User Autotest with branch_id   autotest    Autotest1    ${BRANCH_TRUNG_TAM}
    And Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá 68000 VND Số Lượng 1 Chi Nhánh ${BRANCH_TRUNG_TAM}
    When Gửi Yêu Cầu Tạo Hóa Đơn Với User Autotest
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử Với NCC HDDT ${PARTNER_TYPE_VT} Và Template HDDT ${E_INVOICE_TEMPLATE_VT}
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử Với User Autotest
    Then Response Status Code Should Be 200

RT-INPV-12 Tạo hóa đơn điện tử với user không có quyền xuất hóa đơn điện tử ở chi nhánh A
#  API không chặn lỗi user không có quyền xuất hóa đơn điện tử
    [Documentation]    Test case tạo hóa đơn điện tử với user không có quyền xuất hóa đơn điện tử ở chi nhánh A
    ...    - Mục đích: Kiểm tra khả năng tạo hóa đơn điện tử khi user autotest không có quyền xuất hóa đơn điện tử ở chi nhánh A
    ...    - Tham số đầu vào:
    ...    - User: autotest (user không có quyền xuất hóa đơn điện tử)
    ...    - Sản phẩm: Đơn giá 68000 VND, số lượng 1
    ...    - Chi nhánh: ${BRANCH_CHI_NHANH_A} (1000000062 - chi nhánh A)
    ...    - NCC HDDT: ${PARTNER_TYPE_KV} (4 - KiotViet)
    ...    - Template: ${E_INVOICE_TEMPLATE_KV} (2_C25MKV - template KiotViet)
    ...    - Các bước thực hiện:
    ...    - 1. Thiết lập session cho user autotest với branch_id = 1000000062
    ...    - 2. Chuẩn bị dữ liệu hóa đơn với UUID duy nhất cho chi nhánh A
    ...    - 3. Gửi request tạo hóa đơn thường với user autotest
    ...    - 4. Xác thực response có chứa Invoice ID > 0
    ...    - 5. Chuẩn bị dữ liệu hóa đơn điện tử với KiotViet (PartnerType=4, Template=2_C25MKV)
    ...    - 6. Gửi request tạo hóa đơn điện tử với user autotest
    ...    - 7. Xác thực tạo thành công hóa đơn điện tử mặc dù user không có quyền
    ...    - Kết quả mong đợi:
    ...    - Status code: 200 (thành công)
    ...    - Response có chứa id = 0 (thành công tạo hóa đơn điện tử)
    ...    - Hóa đơn điện tử được tạo thành công bởi user không có quyền
    ...    - Chứng minh API không chặn lỗi user không có quyền xuất hóa đơn điện tử
    ...    - Hệ thống cho phép tạo hóa đơn điện tử bất kể quyền của user ở chi nhánh A
    [Tags]    apieinvoicemultibranch

    Given Thiết Lập Session Cho User Autotest with branch_id   autotest    Autotest1    ${BRANCH_CHI_NHANH_A}
    And Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá 68000 VND Số Lượng 1 Chi Nhánh ${BRANCH_CHI_NHANH_A}
    When Gửi Yêu Cầu Tạo Hóa Đơn Với User Autotest
    And Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    And Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử Với NCC HDDT ${PARTNER_TYPE_KV} Và Template HDDT ${E_INVOICE_TEMPLATE_KV}
    And Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử Với User Autotest
    Then Response Status Code Should Be 200