*** Settings ***
Documentation     Test API kiểm tra và xác thực đầu vào khi tạo hóa đơn
Resource          ../../../Keywords/Invoice/InputValidationKeywords.robot
Resource          ../../../Keywords/Invoice/UpdateInvoiceKeywords.robot
Resource          ../../../Keywords/Invoice/PrescriptionValidationKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Utilities/Utilities.robot
Resource          ../../../Keywords/Utilities/DataUtilities.robot
Resource          ../../../Keywords/Utilities/RequestHelper.robot
Resource          ../../../TestData/Invoice/UpdateInvoiceData.robot
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    InvoiceValidationTest

*** Test Cases ***
RT-IV-001 Tạo hóa đơn thành công với dữ liệu hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn thành công với dữ liệu đầu vào hợp lệ
    [Tags]        smoke   apiinvoice   invoicevalidate   regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200
    And Nội dung phản hồi trả về phải tồn tại Id


RT-IV-002 Kiểm tra mã hóa đơn trùng
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với mã UUID đã tồn tại
    ...    - Source: InvoiceService.cs > CreateInvoiceAsync() line ~1550
    ...    - Logic: Kiểm tra UUID trùng lặp trong Redis cache
    ...    - UUID: 550e8400-e29b-41d4-a716-446655440000 đã tồn tại
    ...    - Kỳ vọng: Lỗi "Mã hóa đơn online bị trùng"
    [Tags]     invoicevalidate    duplicate    uuid    AIGenerated    test7777
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Trùng Uuid
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải bao gồm lỗi "Mã hóa đơn online bị trùng"

RT-IV-003 Kiểm tra thiếu thông tin chi nhánh
    [Documentation]     ...    Kiểm tra lỗi khi tạo hóa đơn thiếu thông tin chi nhán 
    [Tags]    invoicevalidate    smoke    apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thiếu Chi Nhánh
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Có lỗi khi cập nhật dữ liệu"

RT-IV-004 Kiểm tra chi nhánh không hợp lệ
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với chi nhánh không tồn tại
    [Tags]    invoicevalidate    smoke     apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Chi Nhánh Không Tồn Tại
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Có lỗi khi cập nhật dữ liệu"

RT-IV-005 Kiểm tra khách hàng không thuộc chi nhánh
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với khách hàng không thuộc chi nhánh
    [Tags]    invoicevalidate    smoke    vlxd 
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Chi Nhánh Khác
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Khách hàng không thuộc chi nhánh hiện tại."

RT-IV-006 Kiểm tra khách hàng không tồn tại
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với khách hàng không tồn tại
    [Tags]    invoicevalidate    smoke    apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Không Tồn Tại
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Khách hàng không hoạt động hoặc đã bị xóa khỏi hệ thống."


RT-IV-007 Kiểm tra thiếu thông tin người bán
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn thiếu thông tin người bán
    [Tags]    invoicevalidate    smoke     apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thiếu Người Bán
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Người bán không tồn tại hoặc đã bị xóa khỏi hệ thống"

RT-IV-008 Kiểm tra người bán không hợp lệ
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với người bán không tồn tại
    [Tags]    invoicevalidate    smoke     apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Người Bán Không Tồn Tại
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Người bán không tồn tại hoặc đã bị xóa khỏi hệ thống"

RT-IV-009 Kiểm tra ngày tạo hóa đơn trong tương lai
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với ngày trong tương lai
    [Tags]    invoicevalidate    smoke     apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Ngày Trong Tương Lai
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Vượt quá thời gian hiện tại"

RT-IV-010 Kiểm tra khách hàng không có nợ không thanh toán vượt quá hạn mức
    [Documentation]    Kiểm tra cảnh báo khi tạo hóa đơn với khách hàng không có nợ  không thanh toán  gian bật không cho phép nợ
    [Tags]     API KHONG CHAN
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng KHN0002 Thay Toán 0 Gian Bật Không Cho Phép Nợ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Khách hàng có công nợ quá hạn"
RT-IV-010 Kiểm tra khách hàng có nợ thanh toán không đủ
    [Documentation]    Kiểm tra cảnh báo khi tạo hóa đơn với khách hàng có nợ thanh toán không đủ
    [Tags]    API KHONG CHAN
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng KHN0001 Thay Toán 5000 Gian Bật Không Cho Phép Nợ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Khách hàng có công nợ quá hạn"

RT-IV-016 Kiểm tra giá bán âm
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với giá bán âm
    [Tags]         GIÁ BÁN API K CHĂN NHẬP ÂM
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Giá Bán Âm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Giá bán không được nhỏ hơn 0"

RT-IV-017 Kiểm tra sản phẩm không còn hoạt động
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với sản phẩm đã ngừng kinh doanh    
    [Tags]    invoicevalidate    smoke     apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Đã Ngừng Kinh Doanh
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Một số hàng hóa có trong đơn hàng đã ngừng kinh doanh ở chi nhánh hiện tại: ATDD00009"

RT-IV-019 Kiểm tra sản phẩm hết hàng
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với sản phẩm hết hàng
    [Tags]    invoicevalidate    smoke     nhathuoc        
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Hết Hàng Gian Không Cho Phép Bán Âm
    When Gửi Yêu Cầu Tạo Hóa Đơn Với BranchId
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Không đủ số lượng tồn kho cho sản phẩm Hàng hóa hết hàng"

RT-IV-020 Kiểm tra sản phẩm Không Đủ Tồn Kho
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với sản phẩm không đủ tồn kho
    [Tags]    invoicevalidate    smoke     nhathuoc         
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm HHAM00002 Gian Không Cho Phép Bán Âm
    When Gửi Yêu Cầu Tạo Hóa Đơn Với BranchId
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Không đủ số lượng tồn kho cho sản phẩm Hàng hóa không đủ tồn"


RT-IV-021 Kiểm tra sản phẩm combo không đủ hàng
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với sản phẩm combo mà các thành phần không đủ hàng
    [Tags]    invoicevalidate    smoke     nhathuoc         
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm COMBO0001 Gian Không Cho Phép Bán Âm
    When Gửi Yêu Cầu Tạo Hóa Đơn Với BranchId
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Hàng hóa : thành phần TPCB0001 không đủ tồn kho"

RT-IV-022 Kiểm tra thanh toán với số tiền âm
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với phương thức thanh toán có số tiền âm
    [Tags]    API THANH TOÁN ĐUOC      test44
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Phương Thức Thanh Toán Có Số Tiền Âm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Số tiền thanh toán không được nhỏ hơn 0"

RT-IV-023 Kiểm tra thanh toán với số tiền bằng không
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với phương thức thanh toán có số tiền bằng 0
    [Tags]   API THANH TOÁN ĐUOC  
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Phương Thức Thanh Toán Có Số Tiền Bằng 0
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Số tiền thanh toán phải lớn hơn 0"

RT-IV-024 Kiểm tra thanh toán thẻ thiếu thông tin tài khoản
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với phương thức thanh toán thẻ nhưng thiếu thông tin tài khoản
    [Tags]    API VAN TAO DUOC          
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Phương Thức Thanh Toán Thẻ Thiếu Thông Tin Tài Khoản
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Vui lòng chọn tài khoản ngân hàng"

RT-IV-025 Kiểm tra sản phẩm bảo hành không có thông tin bảo hành
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với sản phẩm không cấu hình bảo hành mà lại truyền thông tin bảo hành
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm BHBT: ID=${WARRANTY_PRODUCT_ID}, Số lượng=1, Giá=5,000,000đ
    ...    - Cấu hình bảo hành: HasWarranty=${False}, 
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Sản phẩm có bảo hành nhưng chưa cấu hình thời hạn bảo hành"
    [Tags]  API TAO DUOC
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Bảo Hành Không Có Thời Hạn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Sản phẩm có bảo hành nhưng chưa cấu hình thời hạn bảo hành"

RT-IV-026 Kiểm tra sản phẩm serial không tồn tại
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với sản phẩm serial nhưng số serial không tồn tại
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm BHBT có serial: ID=${WARRANTY_PRODUCT_SERIAL_ID}, Số lượng=1, Giá=10,000,000đ
    ...    - SerialNumbers="SERIAL_INVALID", IsLotSerialControl=${TRUE}
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Số serial không tồn tại trong hệ thống"
    [Tags]    apiinvoice    validation    permission    regression

    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Serial Không Tồn Tại
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Serial 88888 không tồn tại trong hệ thống, đã bán, không thuộc chi nhánh hiện tại hoặc nằm trong giao dịch offline chưa được đồng bộ. Bạn hãy đồng bộ các giao dịch offline."

RT-IV-027 Kiểm tra sản phẩm serial đã bán
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với sản phẩm serial đã được bán
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm BHBT có serial: ID=${PRODUCT_ID_SERIAL}, Số lượng=1, Giá=10,000,000đ
    ...    - SerialNumbers=${SERIAL_SOLD}, IsLotSerialControl=${TRUE}
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Serial đã được bán hoặc không khả dụng"
    [Tags]    invoicevalidate    apiinvoice     regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Serial Đã Bán
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Serial GSU1Y không tồn tại trong hệ thống, đã bán, không thuộc chi nhánh hiện tại hoặc nằm trong giao dịch offline chưa được đồng bộ. Bạn hãy đồng bộ các giao dịch offline."

Kiểm tra sản phẩm serial số lượng không hợp lệ
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với sản phẩm serial số lượng không hợp lệ
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm BHBT có serial: ID=${PRODUCT_ID_SERIAL}, Số lượng=2, Giá=10,000,000đ
    ...    - SerialNumbers=${SERIAL_SOLD}, IsLotSerialControl=${TRUE}
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Số lượng Serial không hợp lệ"
    [Tags]    invoicevalidate    apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Serial Số Lượng Không Hợp Lệ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Số lượng Serial không hợp lệ"


RT-IV-028 Kiểm tra sản phẩm lô date hết hạn
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với sản phẩm lô date đã hết hạn
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm lô date: ID=${LODATE_WARRANTY_PRODUCT_ID}, Số lượng=1, Giá=3,000,000đ
    ...    - Thông tin lô: BatchId=${EXPIRED_BATCH_ID}, BatchName="EXPIRED-LOT", ExpiryDate=ngày đã qua
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Lô hàng đã hết hạn sử dụng"
    [Tags]  API TAO DUOC
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Lô Date Hết Hạn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Lô hàng đã hết hạn sử dụng"

RT-IV-029 Kiểm tra sản phẩm lô date không đủ số lượng
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với sản phẩm lô date không đủ số lượng
    ...    - Dữ liệu đầu vào:
    ...    - Sản phẩm lô date: ID=${LODATE_WARRANTY_PRODUCT_ID}, Số lượng=100, Giá=3,000,000đ
    ...    - Thông tin lô: BatchId=${BATCH_ID}, BatchName=${WARRANTY_PRODUCT_BATCH_NAME}, Tồn kho=10
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Số lượng trong lô không đủ để bán"
    [Tags]    invoicevalidate    apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Lô Date FTLD00003 Không Đủ Số Lượng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error ": số lô DFL - 27/04/2025 không đủ số lượng tồn kho."
    
RT-IV-030 Kiểm tra điều kiện về ngày không được trước ngày khóa sổ
    [Documentation]    Kiểm tra validate ngày tạo hóa đơn không được trước ngày khóa sổ
    [Tags]     invoicevalidate    apiinvoice      regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Ngày Trước Ngày Khóa Sổ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Bạn không thể bán hàng trước ngày khóa sổ 26/04/2025"

RT-RC-022 Tạo hóa đơn với mã voucher không hợp lệ
    [Documentation]    Kiểm tra xử lý khi tạo hóa đơn thanh toán bằng voucher không hợp lệ
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn có tổng tiền = 100,000đ
    ...    - Phương thức thanh toán: Voucher
    ...    - Mã voucher: INVALID_VOUCHER (không tồn tại)
    ...    - Kỳ vọng:
    ...    - Status code: 400
    ...    - Response có thông báo lỗi về voucher không hợp lệ
    [Tags]    payment    voucher    validation    AIGenerated
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Bằng Voucher Không Hợp Lệ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 400
    And Nội dung phản hồi trả về phải có thông báo lỗi voucher không hợp lệ

RT-CD-001 Tạo hóa đơn với khách hàng không còn hoạt động
    [Documentation]    Kiểm tra xử lý khi tạo hóa đơn với khách hàng không còn hoạt động
    ...    - Source: if (invoice.Id <= 0 && (customer == null || customer.IsActive != true || customer.isDeleted == true))
    ...    - Logic: Kiểm tra trạng thái IsActive của khách hàng
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn mới (Id=0)
    ...    - Khách hàng có IsActive=False, IsDeleted=False
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Khách hàng không hoạt động hoặc đã bị xóa khỏi hệ thống."
    [Tags]    invoicevalidate    customer    validation    AIGenerated    apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Không Hoạt Động
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Khách hàng không hoạt động hoặc đã bị xóa khỏi hệ thống."

RT-CD-002 Tạo hóa đơn với khách hàng đã bị xóa
    [Documentation]    Kiểm tra xử lý khi tạo hóa đơn với khách hàng đã bị xóa
    ...    - Source: if (invoice.Id <= 0 && (customer == null || customer.IsActive != true || customer.isDeleted == true))
    ...    - Logic: Kiểm tra trạng thái IsDeleted của khách hàng
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn mới (Id=0)
    ...    - Khách hàng có IsActive=True, IsDeleted=True
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Khách hàng không hoạt động hoặc đã bị xóa khỏi hệ thống."
    [Tags]    invoicevalidate    customer    validation    AIGenerated   apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Đã Bị Xóa
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Khách hàng không hoạt động hoặc đã bị xóa khỏi hệ thống."


RT-SV-001 Tạo hóa đơn mới với người bán không hoạt động
    [Documentation]    Kiểm tra xử lý khi tạo hóa đơn mới với người bán không còn hoạt động
    ...    - Source: if (soldby == null || (invoice.Id <= 0 && soldby.Status != UserStatus.Active))
    ...    - Logic: Kiểm tra trạng thái hoạt động của người bán khi tạo hóa đơn mới
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn mới (Id=0)
    ...    - Người bán: GivenName=${INACTIVE_SOLD_BY_NAME}, Status=0, IsActive=false
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Người bán ${INACTIVE_SOLD_BY_NAME} đã bị ngừng hoạt động"
    [Tags]    invoicevalidate    salesperson    validation    AIGenerated     apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Người Bán Không Hoạt Động
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Người bán ${INACTIVE_SOLD_BY_NAME} đã bị ngừng hoạt động"

RT-CV-001 Tạo hóa đơn với ID khách hàng không hợp lệ
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với ID khách hàng không hợp lệ (âm)
    ...    - Source: CreateInvoice - CustomerAndChannel logic
    ...    - Điều kiện: invoice.CustomerId != null && invoice.CustomerId < -0.0000001
    ...    - Kỳ vọng: Hệ thống ném ngoại lệ KvValidateCustomerException
    [Tags]    invoicevalidate    customer    validation    AIGenerated    apiinvoice     regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với ID Khách Hàng Không Hợp Lệ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Có lỗi trong quá trình ghi nhận thông tin. Xin vui lòng Lưu lại thông tin khách hàng một lần nữa."

RT-CV-002 Tạo hóa đơn với kênh bán không tồn tại
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với kênh bán không tồn tại trong DB
    ...    - Source: CreateInvoice - CustomerAndChannel logic
    ...    - Điều kiện: invoice.SaleChannelId > 0 nhưng saleChannelInDB == null
    ...    - Kỳ vọng: Hệ thống ném ngoại lệ KvValidateSaleChannelException
    [Tags]    invoicevalidate    salechannel    validation    AIGenerated    apiinvoice      regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Kênh Bán Không Tồn Tại
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Kênh bán không tồn tại"

RT-CV-003 Tạo hóa đơn với kênh bán không thuộc cửa hàng hiện tại
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với kênh bán không thuộc cửa hàng hiện tại
    ...    - Source: CreateInvoice - CustomerAndChannel logic
    ...    - Điều kiện: saleChannelInDB.RetailerId != CurrentRetailerId
    ...    - Kỳ vọng: Hệ thống ném ngoại lệ KvValidateSaleChannelException
    [Tags]    invoicevalidate    salechannel    validation    AIGenerated    apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Kênh Bán Khác Cửa Hàng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Kênh bán không tồn tại"

RT-CV-004 Tạo hóa đơn với kênh bán không hoạt động
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với kênh bán không hoạt động
    ...    - Source: CreateInvoice - CustomerAndChannel logic
    ...    - Điều kiện: saleChannelInDB.IsActive == false
    ...    - Kỳ vọng: Hệ thống ném ngoại lệ KvValidateSaleChannelException
    [Tags]    invoicevalidate    salechannel    validation    AIGenerated    apiinvoice     regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Kênh Bán Không Hoạt Động
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Kênh bán không tồn tại"

# Update invoice validation test cases
RT-IV-031 Kiểm tra thay đổi thông tin giao hàng của hóa đơn đã có giao hàng
    [Documentation]    Kiểm tra lỗi khi cập nhật hóa đơn với việc thay đổi thông tin giao hàng của hóa đơn đã có giao hàng
    ...    - Source: InvoiceService.cs > validateWithOldData() line ~1600
    ...    - Logic: Kiểm tra khi thay đổi thông tin đối tác vận chuyển của hóa đơn đã có giao hàng
    ...    - Hóa đơn gốc: Id=${UPDATE_INVOICE_ID_USE_DEFAULT_PARTNER}, DeliveryInfoId=${DELIVERY_DETAIL_ID_USE_DEFAULT_PARTNER}, DeliveryInfo.UseDefaultPartner=true, Status=1
    ...    - Hóa đơn cập nhật: Id=${UPDATE_INVOICE_ID_USE_DEFAULT_PARTNER}, DeliveryInfoId=${DELIVERY_DETAIL_ID_USE_DEFAULT_PARTNER}, UpdateInvoiceId=${UPDATE_INVOICE_ID_USE_DEFAULT_PARTNER}, Code=${UPDATE_INVOICE_CODE_USE_DEFAULT_PARTNER}, DeliveryDetail.UseDefaultPartner=false
    ...    - Kỳ vọng: Lỗi "Có thay đổi mới hơn từ server"
    [Tags]    invoicevalidate     update-invoice    apiinvoice    AIGenerated     regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật Với Thay Đổi Thông Tin Giao Hàng
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Có thay đổi mới hơn từ server. Bạn cần cập nhật trước khi tạo thay đổi mới"

RT-IV-032 Kiểm tra thay đổi khách hàng khi hóa đơn đã có thanh toán
    [Documentation]    Kiểm tra lỗi khi cập nhật hóa đơn với việc thay đổi khách hàng của hóa đơn đã có thanh toán
    ...    - Source: InvoiceService.cs > validateWithOldData() line ~1625
    ...    - Logic: Kiểm tra khi thay đổi khách hàng của hóa đơn đã có thanh toán
    ...    - Hóa đơn gốc: Id=${UPDATE_INVOICE_ID_WRONG_CUSTOMER}, CustomerId=${UPDATE_INVOICE_OLD_CUSTOMER_ID}, TotalPayment=${UPDATE_INVOICE_ID_WRONG_CUSTOMER_TOTAL_PAYMENT}
    ...    - Hóa đơn cập nhật: Id=${UPDATE_INVOICE_ID_WRONG_CUSTOMER}, UpdateInvoiceId=${UPDATE_INVOICE_ID_WRONG_CUSTOMER}, Code=${UPDATE_INVOICE_CODE_WRONG_CUSTOMER}, CustomerId=${UPDATE_INVOICE_CUSTOMER_ID_WRONG_CUSTOMER}
    ...    - Kỳ vọng: Lỗi "Có thay đổi mới hơn từ server. Bạn cần cập nhật trước khi tạo thay đổi mới"
    [Tags]    invoicevalidate     update-invoice    apiinvoice    AIGenerated     regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật Với Thay Đổi Khách Hàng Đã Thanh Toán
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Có thay đổi mới hơn từ server. Bạn cần cập nhật trước khi tạo thay đổi mới"

RT-IV-033 Kiểm tra cập nhật hóa đơn đã có trả hàng
    [Documentation]    Kiểm tra lỗi khi cập nhật hóa đơn đã có trả hàng
    ...    - Source: InvoiceService.cs > validateWithOldData() line ~1650
    ...    - Logic: Kiểm tra cập nhật hóa đơn đã hoàn thành và có trả hàng liên kết
    ...    - Hóa đơn gốc: Id=${UPDATE_INVOICE_ID_CONTAIN_RETURN}
    ...    - Hóa đơn cập nhật: Id=${UPDATE_INVOICE_ID_CONTAIN_RETURN}, UpdateInvoiceId=${UPDATE_INVOICE_ID_CONTAIN_RETURN}, Code=${UPDATE_INVOICE_ID_CONTAIN_RETURN_CODE}
    ...    - Kỳ vọng: Lỗi "Hóa đơn đã có trả hàng, không thể mở phiếu để cập nhật"
    [Tags]    invoicevalidate     update-invoice    apiinvoice    AIGenerated     regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật Với Hóa Đơn Đã Có Trả Hàng
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Hóa đơn đã có trả hàng, không thể mở phiếu để cập nhật"

RT-VC-001 Kiểm tra xung đột phiên bản khi cập nhật thông tin đối tác vận chuyển
    [Documentation]    Kiểm tra xử lý xung đột phiên bản khi cập nhật đối tác vận chuyển
    ...    - Source: CreateInvoice - Phần 4. Kiểm tra xung đột phiên bản
    ...    - Logic: Nếu hóa đơn hiện tại sử dụng đối tác vận chuyển mặc định (di?.UseDefaultPartner == true)
    ...    - Nhưng yêu cầu cập nhật không sử dụng đối tác vận chuyển mặc định (DeliveryDetail.UseDefaultPartner == false)
    ...    - Hệ thống sẽ báo lỗi "Có thay đổi mới hơn từ server"
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn hiện tại: Id=${UPDATE_INVOICE_ID_USE_DEFAULT_PARTNER}, Code=${UPDATE_INVOICE_CODE_USE_DEFAULT_PARTNER}, DeliveryInfo.UseDefaultPartner=true
    ...    - Hóa đơn cập nhật: Id=${UPDATE_INVOICE_ID_USE_DEFAULT_PARTNER}, Code=${UPDATE_INVOICE_CODE_USE_DEFAULT_PARTNER}, DeliveryDetail.UseDefaultPartner=false
    ...    - Kỳ vọng: Lỗi "Có thay đổi mới hơn từ server. Bạn cần cập nhật trước khi tạo thay đổi mới"
    [Tags]    invoicevalidate    versionconflict    delivery-partner    AIGenerated        apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật Với Xung Đột Đối Tác Vận Chuyển
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Có thay đổi mới hơn từ server. Bạn cần cập nhật trước khi tạo thay đổi mới"

RT-VC-002 Kiểm tra xung đột phiên bản khi cập nhật trạng thái hóa đơn
    [Documentation]    Kiểm tra xử lý xung đột phiên bản khi cập nhật trạng thái hóa đơn
    ...    - Source: CreateInvoice - Phần 4. Kiểm tra xung đột phiên bản
    ...    - Logic: Nếu trạng thái hóa đơn hiện tại khác với trạng thái trong yêu cầu cập nhật (inv.Status != invoice.Status)
    ...    - Hệ thống sẽ báo lỗi "Có thay đổi mới hơn từ server"
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn hiện tại: Id=${UPDATE_INVOICE_ID}, Status=1 (Đã hoàn thành)
    ...    - Hóa đơn cập nhật: Id=${UPDATE_INVOICE_ID}, Status=3 (Đang xử lý)
    ...    - Kỳ vọng: Lỗi "Có thay đổi mới hơn từ server. Bạn cần cập nhật trước khi tạo thay đổi mới"
    [Tags]    invoicevalidate    versionconflict    status    AIGenerated        apiinvoice    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật Với Xung Đột Trạng Thái
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Có thay đổi mới hơn từ server. Bạn cần cập nhật trước khi tạo thay đổi mới"

RT-VC-003 Kiểm tra xung đột phiên bản khi cập nhật không có thông tin giao hàng
    [Documentation]    Kiểm tra xử lý xung đột phiên bản khi cập nhật không có thông tin giao hàng
    ...    - Source: CreateInvoice - Phần 4. Kiểm tra xung đột phiên bản
    ...    - Logic: Nếu hóa đơn hiện tại sử dụng đối tác vận chuyển mặc định (di?.UseDefaultPartner == true)
    ...    - Nhưng yêu cầu cập nhật không có thông tin giao hàng (invoice.DeliveryDetail == null)
    ...    - Hệ thống sẽ báo lỗi "Có thay đổi mới hơn từ server"
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn hiện tại: Id=${UPDATE_INVOICE_ID_USE_DEFAULT_PARTNER}, Code=${UPDATE_INVOICE_CODE_USE_DEFAULT_PARTNER}, DeliveryInfo.UseDefaultPartner=true
    ...    - Hóa đơn cập nhật: Id=${UPDATE_INVOICE_ID_USE_DEFAULT_PARTNER}, DeliveryDetail=null
    ...    - Kỳ vọng: Lỗi "Có thay đổi mới hơn từ server. Bạn cần cập nhật trước khi tạo thay đổi mới"
    [Tags]    invoicevalidate    versionconflict    delivery-info    AIGenerated        apiinvoice     regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật Với Thiếu Thông Tin Giao Hàng
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Có thay đổi mới hơn từ server. Bạn cần cập nhật trước khi tạo thay đổi mới"

# UUID Check Test Cases
RT-IV-UUID-001 Kiểm tra UUID trùng lặp với cùng khách hàng và tổng tiền
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với UUID trùng lặp cùng khách hàng và tổng tiền
    ...    - Source: InvoiceService.cs > CheckUuidAsync() 
    ...    - Logic: Kiểm tra UUID trùng lặp và so sánh thông tin khách hàng, tổng tiền
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn mới: UUID="${DUPLICATE_UUID}", CustomerId=${DUPLICATE_CUSTOMER_ID}, Total=${STANDARD_INVOICE_TOTAL}
    ...    - Hóa đơn đã tồn tại: UUID="${DUPLICATE_UUID}", CustomerId=${DUPLICATE_CUSTOMER_ID}, Total=${STANDARD_INVOICE_TOTAL}
    ...    - Kỳ vọng: Lỗi "Mã hóa đơn online bị trùng: HD050 - HD001"
    [Tags]    invoicevalidate    duplicate    uuid2    AIGenerated  apiinvoice    regression
    Given Tạo hóa đơn với UUID trùng lặp
    And Chuẩn Bị Dữ Liệu Hóa Đơn Với Trùng Uuid Trong Cơ sở dữ liệu
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải bao gồm lỗi "Mã hóa đơn online bị trùng"

# Prescription Validation Test Cases
RT-IV-PRESC-002 Kiểm tra hóa đơn thuốc thiếu mô tả cách dùng
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn nhà thuốc GPP có đơn thuốc toàn cục nhưng sản phẩm thiếu mô tả cách dùng
    ...    - Source: InvoiceService.cs > CreateInvoiceAsync() - Phần xử lý thông tin đơn thuốc
    ...    - Logic: Khi UsingGlobalPrescription=1, mỗi sản phẩm IsMaster=true phải có Note
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn với UsingPrescription=1, UsingGlobalPrescription=1
    ...    - Sản phẩm có IsMaster=true, Note=null
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Hàng hóa thiếu ghi chú"
    [Tags]    invoicevalidate    prescription    AIGenerated   nhathuoc
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Toàn Cục Với Sản Phẩm Thiếu Mô Tả
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Hàng hóa thiếu ghi chú"


RT-IV-PRESC-005 Kiểm tra hóa đơn có đơn thuốc với ID nhưng không có mã
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn nhà thuốc GPP có đơn thuốc với Id>0 nhưng không có mã
    ...    - Source: InvoiceService.cs > CreateInvoiceAsync() - Phần xử lý thông tin đơn thuốc
    ...    - Logic: Hệ thống kiểm tra đơn thuốc có Id>0 phải có mã
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn với UsingPrescription=1, đơn thuốc có Id=123 nhưng Code=null
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Mã đơn thuốc không hợp lệ"
    [Tags]    invoicevalidate    prescription    AIGenerated    nhathuoc
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Nhà Thuốc Với Mã Đơn Thuốc ID Không Code
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải chứa lỗi "Mã đơn thuốc không hợp lệ"

# Promotion Limits Test Cases
RT-IV-PL-001 Kiểm tra giới hạn sử dụng khuyến mãi khi khách hàng đã sử dụng khuyến mãi vượt quá giới hạn
    [Documentation]    Kiểm tra lỗi khi tạo hóa đơn với khuyến mãi mà khách hàng đã sử dụng vượt quá giới hạn
    ...    - Source: InvoiceService.cs > CreateInvoiceAsync() - Phần kiểm tra giới hạn sử dụng khuyến mãi
    ...    - Logic: Hệ thống kiểm tra giới hạn sử dụng khuyến mãi của khách hàng
    ...    - Điều kiện: 
    ...    - Hóa đơn có khuyến mãi (invoice.InvoicePromotions != null && invoice.InvoicePromotions.Any())
    ...    - Khách hàng đã đăng ký (invoice.CustomerId > 0)
    ...    - Khuyến mãi có thiết lập giới hạn sử dụng (LimitPromotionUsage = true)
    ...    - Chế độ chặn được bật (LimitPromotionUsageType = 2)
    ...    - Dữ liệu đầu vào:
    ...    - Hóa đơn với CustomerId=${LIMITED_CUSTOMER_ID}, có khuyến mãi với LimitPromotionUsage=true, LimitPromotionUsageType=2
    ...    - Khách hàng đã sử dụng khuyến mãi này
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi bao gồm: "Khách hàng đã được hưởng các khuyến mại:" và "vui lòng kiểm tra lại."
    [Tags]    invoicevalidate    promotion    limits    AIGenerated   test424344
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Có Giới Hạn Sử Dụng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 420
    And Phản hồi phải bao gồm lỗi "Khách hàng đã được hưởng các khuyến mại"
    And Phản hồi phải bao gồm lỗi "vui lòng kiểm tra lại."

