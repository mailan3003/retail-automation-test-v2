*** Settings ***
Documentation    Test cases cho chức năng xử lý ngoại lệ và lỗi trong hệ thống KiotViet
...              Bao gồm các loại ngoại lệ: KvValidateException, KvValidateCustomerException,
...              KvValidateUserException, KvValidatePartnerDeliveryException, 
...              KvValidateSaleChannelException, KvValidateInvoiceException
Suite Setup       Init Test Environment    ${ENV}    MHBH
Resource         ../../../Keywords/Order/ExceptionHandling_Keywords.robot
Resource         ../../../Keywords/Order/OrderCommandKeywords.robot
Resource         ../../../TestData/Order/ExceptionHandlingData.robot
Resource         ../../../TestData/CommonData.robot
Resource         ../../../Keywords/Utilities/Utilities.robot
Resource    ../../../Keywords/Login/Login.robot

*** Test Cases ***

RT-EXC-001 Xử lý ngoại lệ xác thực chung với các điều kiện khác nhau
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateException với nhiều điều kiện:
    ...    - Sản phẩm trùng lặp trong đơn hàng (loại trừ sản phẩm khuyến mãi)
    ...    - Không có quyền tạo đơn hàng (Order._Create)
    ...    - Không có quyền cập nhật đơn hàng (Order._Update)
    ...    - Trả về mã lỗi 420 với thông báo cụ thể từ KVMessage
    [Tags]    AIGenerated    ExceptionHandling    KvValidateException    Negative
    [Template]    Kiểm Tra Ngoại Lệ Xác Thực Chung
    # condition                                    expected_error_message
    Sản phẩm trùng lặp                            Sản phẩm bị trùng

RT-EXC-002 Xử lý ngoại lệ liên quan đến khách hàng với các trường hợp khác nhau
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateCustomerException với nhiều điều kiện:
    ...    - Khách hàng không tồn tại trong hệ thống
    ...    - Khách hàng không hoạt động (IsActive = false)
    ...    - ID khách hàng không hợp lệ (âm hoặc không phải số)
    ...    - Trả về mã lỗi 420 với thông báo cụ thể về khách hàng
    [Tags]    AIGenerated    ExceptionHandling    KvValidateCustomerException    Negative
    [Template]    Kiểm Tra Ngoại Lệ Khách Hàng
    # customer_condition                           expected_error_message
    Khách hàng không tồn tại                      Khách hàng không hoạt động hoặc đã bị xóa khỏi hệ thống.
    Khách hàng không hoạt động                    Khách hàng không hoạt động hoặc đã bị xóa khỏi hệ thống.
    ID khách hàng không hợp lệ                    Có lỗi trong quá trình ghi nhận thông tin. Xin vui lòng Lưu lại thông tin khách hàng một lần nữa
    Không thể cập nhật thông tin hóa đơn          Không thể cập nhật thông tin hóa đơn liên quan đến khách hàng
RT-EXC-003 Xử lý ngoại lệ liên quan đến nhân viên bán hàng với các trường hợp khác nhau
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateUserException với nhiều điều kiện:
    ...    - Nhân viên bán hàng không tồn tại trong hệ thống
    ...    - Nhân viên bán hàng không hoạt động (IsActive = false)
    ...    - Hiển thị tên nhân viên cụ thể trong thông báo lỗi
    ...    - Trả về mã lỗi 420 với thông báo cụ thể về nhân viên
    [Tags]    AIGenerated    ExceptionHandling    KvValidateUserException    Negative
    [Template]    Kiểm Tra Ngoại Lệ Nhân Viên Bán Hàng
    # user_condition                               expected_error_message
    Nhân viên không tồn tại                       Người bán không tồn tại hoặc đã bị xóa khỏi hệ thống
    Nhân viên không hoạt động                     Người bán không tồn tại hoặc đã bị xóa khỏi hệ thống

RT-EXC-004 Xử lý ngoại lệ liên quan đến đối tác giao hàng với các trường hợp khác nhau
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidatePartnerDeliveryException với nhiều điều kiện:
    ...    - Đối tác giao hàng không hợp lệ hoặc không hoạt động
    ...    - Phương thức thanh toán COD không hợp lệ
    ...    - Cấu hình không cho phép sử dụng COD với đối tác KiotViet
    ...    - Chỉ kiểm tra khi UsingCod = 1
    ...    - Trả về mã lỗi 420 với thông báo cụ thể về đối tác giao hàng
    [Tags]    AIGenerated    ExceptionHandling    KvValidatePartnerDeliveryException    Negative
    [Template]    Kiểm Tra Ngoại Lệ Đối Tác Giao Hàng
    # delivery_condition                           expected_error_message
    Đối tác giao hàng không hợp lệ                Đối tác giao hàng không hợp lệ hoặc không hoạt động
    Phương thức COD không hợp lệ                  Phương thức thanh toán COD không hợp lệ
    Cấu hình không cho phép COD                   Cấu hình không cho phép sử dụng COD với đối tác KiotViet

RT-EXC-005 Xử lý ngoại lệ liên quan đến kênh bán hàng với các trường hợp khác nhau
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateSaleChannelException với nhiều điều kiện:
    ...    - Kênh bán hàng không tồn tại trong hệ thống
    ...    - Kênh bán hàng không hoạt động (IsActive = false)
    ...    - Kênh bán hàng không thuộc cùng retailer
    ...    - Trả về mã lỗi 420 với thông báo cụ thể về kênh bán hàng
    [Tags]    AIGenerated    ExceptionHandling    KvValidateSaleChannelException    Negative
    [Template]    Kiểm Tra Ngoại Lệ Kênh Bán Hàng
    # channel_condition                            expected_error_message
    Kênh bán hàng không tồn tại                   	Kênh bán không tồn tại
    Kênh bán hàng không hoạt động                 	Kênh bán không tồn tại
    Kênh bán hàng không thuộc retailer            	Kênh bán không tồn tại

RT-EXC-006 Xử lý ngoại lệ liên quan đến hóa đơn với các trường hợp khác nhau
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateInvoiceException với nhiều điều kiện:
    ...    - Trùng lặp mã đơn hàng online
    ...    - Xung đột UUID đơn hàng
    ...    - Hiển thị thông tin cụ thể về mã đơn hàng bị trùng lặp
    ...    - Trả về mã lỗi 420 với thông báo cụ thể về hóa đơn
    [Tags]    AIGenerated    ExceptionHandling    KvValidateInvoiceException    Negative12345
    [Template]    Kiểm Tra Ngoại Lệ Hóa Đơn
    # invoice_condition                            expected_error_message
    Trùng lặp mã đơn hàng online                  Trùng lặp mã đơn hàng online
    Xung đột UUID đơn hàng                        Xung đột UUID đơn hàng

RT-EXC-007 Xử lý ngoại lệ trùng lặp sản phẩm với điều kiện loại trừ khuyến mãi
    [Documentation]    Kiểm tra xử lý ngoại lệ trùng lặp sản phẩm:
    ...    - Sử dụng KvValidateException với thông báo ProductDuplicated
    ...    - Phát sinh khi phát hiện sản phẩm trùng lặp trong đơn hàng
    ...    - Loại trừ các sản phẩm thuộc khuyến mãi
    ...    - Xác thực trong database không có sản phẩm trùng lặp được lưu
    [Tags]    AIGenerated    ExceptionHandling    ProductDuplicated    Negative
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Sản Phẩm Trùng Lặp Không Phải Khuyến Mãi
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Sản phẩm bị trùng"
    And Xác Thực Không Có Đơn Hàng Nào Được Tạo Trong Database

RT-EXC-008 Xử lý ngoại lệ quyền hạn với kiểm tra AuthService
    [Documentation]    Kiểm tra xử lý ngoại lệ quyền hạn:
    ...    - Sử dụng KvValidateException với thông báo _invalid_Permission
    ...    - Phát sinh khi người dùng không có quyền tạo hoặc cập nhật đơn hàng
    ...    - Kiểm tra quyền dựa trên AuthService.CheckPermissionExactly
    ...    - Xác thực Order._Create và Order._Update permissions
    [Tags]    AIGenerated    ExceptionHandling    Permission    Negative
    [Template]    Kiểm Tra Ngoại Lệ Quyền Hạn
    # permission_type                              expected_error_message
    Không có quyền Order._Create                  _invalid_Permission
    Không có quyền Order._Update                  _invalid_Permission
    Không có quyền Invoice.ModifySeller           _invalid_Permission

RT-EXC-009 Xử lý ngoại lệ với thông báo lỗi rõ ràng và cụ thể
    [Documentation]    Kiểm tra thông báo lỗi rõ ràng và cụ thể:
    ...    - Thông báo lỗi cần rõ ràng, cụ thể để người dùng dễ dàng hiểu và khắc phục
    ...    - Hiển thị tên nhân viên cụ thể khi có lỗi liên quan đến nhân viên bán hàng
    ...    - Hiển thị thông tin cụ thể về mã đơn hàng bị trùng lặp
    ...    - Sử dụng các hằng số từ KVMessage để đảm bảo tính nhất quán
    [Tags]    AIGenerated    ExceptionHandling    ErrorMessage    Negative
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhân Viên Bán Hàng Không Tồn Tại "${NONEXISTENT_USER_ID}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Người bán không tồn tại hoặc đã bị xóa khỏi hệ thống"
    And Xác Thực Thông Báo Lỗi Sử Dụng Hằng Số Từ KVMessage

RT-EXC-010 Xử lý ngoại lệ với mã HTTP phù hợp
    [Documentation]    Kiểm tra mã HTTP được trả về phù hợp:
    ...    - Đảm bảo thông tin lỗi được trả về client với mã HTTP phù hợp
    ...    - KvValidateException trả về mã 420 (Business Logic Error)
    ...    - Các ngoại lệ khác cũng trả về mã 420 với thông báo cụ thể
    ...    - Xác thực cấu trúc response chứa thông tin lỗi đầy đủ
    [Tags]    AIGenerated    ExceptionHandling    HTTPStatus    Negative
    [Template]    Kiểm Tra Mã HTTP Của Ngoại Lệ
    # exception_type                               expected_http_code
    KvValidateException                           420
    KvValidateCustomerException                   420
    KvValidateUserException                       420
    KvValidatePartnerDeliveryException            420
    KvValidateSaleChannelException                420
    KvValidateInvoiceException                    420

RT-EXC-011 Xử lý ngoại lệ với điều kiện đặc biệt cho sản phẩm khuyến mãi
    [Documentation]    Kiểm tra xử lý ngoại lệ với điều kiện đặc biệt:
    ...    - Một số lỗi như trùng lặp sản phẩm có thể bỏ qua trong trường hợp đặc biệt
    ...    - Sản phẩm khuyến mãi được phép trùng lặp
    ...    - Xác thực logic loại trừ sản phẩm khuyến mãi khỏi kiểm tra trùng lặp
    [Tags]    AIGenerated    ExceptionHandling    PromotionProduct    Positive
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Sản Phẩm Trùng Lặp Thuộc Khuyến Mãi
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Phản Hồi Phải Chứa ID Đơn Hàng Hợp Lệ
    And Xác Thực Đơn Hàng Được Tạo Thành Công Với Sản Phẩm Khuyến Mãi Trùng Lặp

RT-EXC-012 Xử lý ngoại lệ với tự động tạo UUID mới khi xung đột
    [Documentation]    Kiểm tra xử lý ngoại lệ với tự động tạo UUID mới:
    ...    - Đối với lỗi trùng lặp mã đơn hàng online hoặc UUID
    ...    - Hệ thống có thể tự động tạo UUID mới trong một số trường hợp
    ...    - Xác thực logic tự động xử lý xung đột UUID
    [Tags]    AIGenerated    ExceptionHandling    UUIDConflict    AutoResolve
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với UUID Xung Đột Có Thể Tự Động Xử Lý
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Phản Hồi Phải Chứa UUID Mới Được Tạo Tự Động
    And Xác Thực UUID Mới Khác Với UUID Gốc Bị Xung Đột

RT-EXC-013 Xử lý ngoại lệ với kiểm tra quyền sớm để tránh xử lý không cần thiết
    [Documentation]    Kiểm tra xử lý ngoại lệ với kiểm tra quyền sớm:
    ...    - Lỗi quyền hạn cần được kiểm tra sớm để tránh xử lý không cần thiết
    ...    - Kiểm tra quyền trước khi thực hiện các validation khác
    ...    - Xác thực không có side effect khi thiếu quyền
    [Tags]    AIGenerated    ExceptionHandling    EarlyPermissionCheck    Negative
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Người Dùng Không Có Quyền
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "_invalid_Permission"
    And Xác Thực Không Có Dữ Liệu Nào Được Xử Lý Trong Database
    And Xác Thực Thời Gian Phản Hồi Nhanh Do Kiểm Tra Quyền Sớm

RT-EXC-014 Xử lý ngoại lệ với điều kiện cụ thể cho đối tác giao hàng
    [Documentation]    Kiểm tra xử lý ngoại lệ với điều kiện cụ thể:
    ...    - Một số lỗi như lỗi liên quan đến đối tác giao hàng chỉ được kiểm tra khi có điều kiện cụ thể
    ...    - Chỉ kiểm tra khi UsingCod = 1
    ...    - Xác thực logic điều kiện kiểm tra đối tác giao hàng
    [Tags]    AIGenerated    ExceptionHandling    ConditionalCheck    DeliveryPartner
    [Template]    Kiểm Tra Ngoại Lệ Đối Tác Giao Hàng Theo Điều Kiện
    # using_cod    delivery_partner_status         expected_result
    0             Không hợp lệ                    Thành công (không kiểm tra)
    1             Không hợp lệ                    Lỗi 420
    1             Hợp lệ                          Thành công

RT-EXC-015 Xử lý ngoại lệ với các loại ngoại lệ hệ thống
    [Documentation]    Kiểm tra xử lý các loại ngoại lệ hệ thống:
    ...    - KvValidateOrderException: Lỗi liên quan đến đơn hàng
    ...    - KvException: Lỗi chung của hệ thống
    ...    - Xác thực các ngoại lệ được xử lý đúng cách
    [Tags]    AIGenerated    ExceptionHandling    SystemException    Negative
    [Template]    Kiểm Tra Ngoại Lệ Hệ Thống
    # exception_type                               test_condition                          expected_error
    KvValidateOrderException                      Đơn hàng không tồn tại                 Đơn hàng không tồn tại
    KvException                                   Lỗi hệ thống chung                     Lỗi hệ thống

RT-EXC-016 Kiểm tra và xác thực VAT sản phẩm với các điều kiện khác nhau
    [Documentation]    Kiểm tra chức năng xác thực VAT sản phẩm:
    ...    - Gọi TaxService.IsActiveProductVATToggle để kiểm tra tính kích hoạt
    ...    - Nếu tính năng không được kích hoạt, đặt TotalTax về null
    ...    - Xác thực logic xử lý VAT theo cấu hình hệ thống
    [Tags]    AIGenerated    DataValidation    VAT    Positive
    [Template]    Kiểm Tra Xác Thực VAT Sản Phẩm
    # vat_toggle_status    expected_total_tax
    Kích hoạt             10000
    Không kích hoạt       ${None}

RT-EXC-017 Kiểm tra trùng lặp sản phẩm với điều kiện loại trừ khuyến mãi chi tiết
    [Documentation]    Kiểm tra xác thực trùng lặp sản phẩm với các điều kiện:
    ...    - So sánh ProductId của các sản phẩm trong đơn hàng
    ...    - Loại trừ sản phẩm thuộc khuyến mãi (SalePromotionId != null)
    ...    - Loại trừ sản phẩm không phải sản phẩm chính (IsMaster = false)
    ...    - Phát sinh KvValidateException với thông báo ProductDuplicated
    [Tags]    AIGenerated    DataValidation    ProductDuplicate    Negative
    [Template]    Kiểm Tra Trùng Lặp Sản Phẩm Với Điều Kiện
    # product_condition                         expected_result
    Sản phẩm thường trùng lặp                 Lỗi ProductDuplicated
    Sản phẩm khuyến mãi trùng lặp             Thành công
    Sản phẩm không phải Master trùng lặp      Thành công

RT-EXC-018 Kiểm tra xác thực khuyến mãi với các trạng thái khác nhau
    [Documentation]    Kiểm tra xác thực khuyến mãi trong đơn hàng:
    ...    - Lọc các khuyến mãi mới (Id = 0 và PromotionId != null)
    ...    - Gọi KvPromotionService.CheckIsDeletedCampaignByIds
    ...    - Phát sinh KvValidateException nếu khuyến mãi đã bị xóa
    [Tags]    AIGenerated    DataValidation    Promotion    Negative
    [Template]    Kiểm Tra Xác Thực Khuyến Mãi
    # promotion_condition                       expected_result
    Khuyến mãi hợp lệ                         Thành công
    Khuyến mãi đã bị xóa                      Lỗi khuyến mãi không hợp lệ
    Khuyến mãi hết hạn                        Lỗi khuyến mãi hết hạn

RT-EXC-019 Kiểm tra xác thực đối tác giao hàng với điều kiện COD chi tiết
    [Documentation]    Kiểm tra xác thực đối tác giao hàng với COD:
    ...    - Kiểm tra khi đơn hàng sử dụng COD và đối tác giao hàng mặc định
    ...    - Xác thực cấu hình cho phép sử dụng COD với đối tác KiotViet
    ...    - Kiểm tra phương thức thanh toán hợp lệ
    ...    - Chỉ kiểm tra khi UsingCod = 1
    [Tags]    AIGenerated    DataValidation    DeliveryPartner    COD
    [Template]    Kiểm Tra Xác Thực Đối Tác Giao Hàng COD
    # using_cod    partner_status    cod_config    expected_result
    1             Hợp lệ           Cho phép       Thành công
    1             Không hợp lệ     Cho phép       Lỗi đối tác không hợp lệ
    1             Hợp lệ           Không cho phép Lỗi cấu hình COD
    0             Không hợp lệ     Cho phép       Thành công (không kiểm tra)

RT-EXC-020 Kiểm tra xác thực khách hàng với các trường hợp cập nhật
    [Documentation]    Kiểm tra xác thực khách hàng trong các trường hợp:
    ...    - Kiểm tra giá trị ID khách hàng (CustomerId)
    ...    - Kiểm tra khi đơn hàng được cập nhật (không phải chuyển chi nhánh)
    ...    - Xác thực tính tồn tại và hoạt động của khách hàng
    ...    - Xử lý trường hợp ID khách hàng null hoặc <= 0
    [Tags]    AIGenerated    DataValidation    Customer    Update
    [Template]    Kiểm Tra Xác Thực Khách Hàng Cập Nhật
    # customer_id    is_branch_transfer    expected_result
    ${VALID_CUSTOMER_ID}      ${False}              Thành công
    ${NONEXISTENT_CUSTOMER_ID}    ${False}          Lỗi khách hàng không tồn tại
    ${INACTIVE_CUSTOMER_ID}       ${False}          Lỗi khách hàng không hoạt động
    ${INVALID_CUSTOMER_ID}        ${False}          Lỗi ID khách hàng không hợp lệ
    ${NONEXISTENT_CUSTOMER_ID}    ${True}           Thành công (bỏ qua kiểm tra)

RT-EXC-021 Kiểm tra xác thực nhân viên bán hàng với trạng thái hoạt động
    [Documentation]    Kiểm tra xác thực nhân viên bán hàng:
    ...    - Kiểm tra khi SoldById > 0
    ...    - Xác thực tính tồn tại của nhân viên qua UserService
    ...    - Kiểm tra trạng thái hoạt động (quan trọng khi tạo đơn hàng mới)
    ...    - Phát sinh KvValidateUserException nếu không hợp lệ
    [Tags]    AIGenerated    DataValidation    SalesUser    Active
    [Template]    Kiểm Tra Xác Thực Nhân Viên Bán Hàng
    # sold_by_id    is_new_order    expected_result
    ${SOLD_BY_ID}             ${True}         Thành công
    ${NONEXISTENT_USER_ID}    ${True}         Lỗi nhân viên không tồn tại
    ${INACTIVE_USER_ID}       ${True}         Lỗi nhân viên không hoạt động
    ${INACTIVE_USER_ID}       ${False}        Thành công (không kiểm tra trạng thái)
    0                         ${True}         Thành công (bỏ qua kiểm tra)

RT-EXC-022 Kiểm tra xác thực quyền hạn với các loại quyền khác nhau
    [Documentation]    Kiểm tra xác thực quyền hạn:
    ...    - Kiểm tra quyền Order._Create cho đơn hàng mới
    ...    - Kiểm tra quyền Order._Update cho cập nhật đơn hàng
    ...    - Kiểm tra quyền Invoice.ModifySeller khi thay đổi nhân viên
    ...    - Khôi phục SoldById về giá trị ban đầu nếu không có quyền
    [Tags]    AIGenerated    DataValidation    Permission    Authorization
    [Template]    Kiểm Tra Xác Thực Quyền Hạn Chi Tiết
    # order_type    permission_type              has_permission    expected_result
    Mới           Order._Create                ${True}           Thành công
    Mới           Order._Create                ${False}          Lỗi không có quyền
    Cập nhật      Order._Update                ${True}           Thành công
    Cập nhật      Order._Update                ${False}          Lỗi không có quyền
    Thay đổi NV   Invoice.ModifySeller         ${True}           Thành công
    Thay đổi NV   Invoice.ModifySeller         ${False}          SoldById được khôi phục

RT-EXC-023 Kiểm tra xác thực kênh bán hàng với retailer
    [Documentation]    Kiểm tra xác thực kênh bán hàng:
    ...    - Kiểm tra khi đơn hàng chỉ định SaleChannelId
    ...    - Xác thực tính tồn tại và hoạt động của kênh bán hàng
    ...    - Đảm bảo kênh bán hàng thuộc cùng retailer với đơn hàng
    ...    - Phát sinh KvValidateSaleChannelException nếu không hợp lệ
    [Tags]    AIGenerated    DataValidation    SaleChannel    Retailer
    [Template]    Kiểm Tra Xác Thực Kênh Bán Hàng
    # channel_id                    expected_result
    ${CHANNEL_ID_1}                 Thành công
    ${NONEXISTENT_CHANNEL_ID}       Lỗi kênh không tồn tại
    ${INACTIVE_CHANNEL_ID}          Lỗi kênh không hoạt động
    ${OTHER_RETAILER_CHANNEL_ID}    Lỗi kênh không thuộc retailer
    ${None}                         Thành công (bỏ qua kiểm tra)

RT-EXC-024 Kiểm tra xác thực với tham số isValid để bỏ qua kiểm tra
    [Documentation]    Kiểm tra chức năng bỏ qua xác thực:
    ...    - Tham số isValid có thể được truyền vào để bỏ qua một số kiểm tra
    ...    - Sử dụng trong trường hợp xử lý đơn hàng preview
    ...    - Xác thực logic điều kiện bỏ qua kiểm tra
    [Tags]    AIGenerated    DataValidation    SkipValidation    Preview
    [Template]    Kiểm Tra Bỏ Qua Xác Thực Với IsValid
    # is_valid    validation_type              expected_result
    ${True}       Tất cả kiểm tra              Thành công (bỏ qua)
    ${False}      Kiểm tra khách hàng          Lỗi khách hàng không hợp lệ
    ${False}      Kiểm tra nhân viên           Lỗi nhân viên không hợp lệ
    ${False}      Kiểm tra quyền hạn           Lỗi không có quyền

RT-EXC-025 Kiểm tra xác thực tổng hợp với nhiều điều kiện lỗi
    [Documentation]    Kiểm tra xác thực tổng hợp với nhiều lỗi:
    ...    - Kiểm tra thứ tự ưu tiên của các loại xác thực
    ...    - Xác thực lỗi đầu tiên được phát hiện và trả về
    ...    - Đảm bảo không có side effect khi có lỗi xác thực
    [Tags]    AIGenerated    DataValidation    MultipleErrors    Priority
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Lỗi Xác Thực
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi Đầu Tiên Theo Thứ Tự Ưu Tiên
    And Xác Thực Không Có Dữ Liệu Nào Được Lưu Trong Database

RT-EXC-026 Kiểm tra xác thực với dữ liệu biên và giá trị đặc biệt
    [Documentation]    Kiểm tra xác thực với các giá trị biên:
    ...    - ID = 0, null, âm
    ...    - Chuỗi rỗng, null, quá dài
    ...    - Xác thực xử lý các trường hợp đặc biệt
    [Tags]    AIGenerated    DataValidation    BoundaryValues    EdgeCases
    [Template]    Kiểm Tra Xác Thực Giá Trị Biên
    # field_name     field_value    expected_result
    CustomerId       0              Thành công (khách hàng mặc định)
    CustomerId       -1             Lỗi ID không hợp lệ
    SoldById         0              Thành công (không có nhân viên)
    SoldById         -1             Lỗi ID không hợp lệ
    SaleChannelId    ${None}        Thành công (kênh mặc định)
    Code             ${EMPTY}       Thành công (tự động tạo)
    Code             ${None}        Thành công (tự động tạo)

*** Keywords ***
Kiểm Tra Ngoại Lệ Xác Thực Chung
    [Arguments]    ${condition}    ${expected_error_message}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Điều Kiện "${condition}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "${expected_error_message}"
    And Xác Thực Loại Ngoại Lệ Là "KvValidateException"

Kiểm Tra Ngoại Lệ Khách Hàng
    [Arguments]    ${customer_condition}    ${expected_error_message}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Khách Hàng "${customer_condition}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "${expected_error_message}"
    And Xác Thực Loại Ngoại Lệ Là "KvValidateCustomerException"

Kiểm Tra Ngoại Lệ Nhân Viên Bán Hàng
    [Arguments]    ${user_condition}    ${expected_error_message}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhân Viên "${user_condition}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "${expected_error_message}"
    And Xác Thực Loại Ngoại Lệ Là "KvValidateUserException"

Kiểm Tra Ngoại Lệ Đối Tác Giao Hàng
    [Arguments]    ${delivery_condition}    ${expected_error_message}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Đối Tác Giao Hàng "${delivery_condition}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "${expected_error_message}"
    And Xác Thực Loại Ngoại Lệ Là "KvValidatePartnerDeliveryException"

Kiểm Tra Ngoại Lệ Kênh Bán Hàng
    [Arguments]    ${channel_condition}    ${expected_error_message}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Kênh Bán Hàng "${channel_condition}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "${expected_error_message}"
    And Xác Thực Loại Ngoại Lệ Là "KvValidateSaleChannelException"

Kiểm Tra Ngoại Lệ Hóa Đơn
    [Arguments]    ${invoice_condition}    ${expected_error_message}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Hóa Đơn "${invoice_condition}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "${expected_error_message}"
    And Xác Thực Loại Ngoại Lệ Là "KvValidateInvoiceException"

Kiểm Tra Ngoại Lệ Quyền Hạn
    [Arguments]    ${permission_type}    ${expected_error_message}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Quyền Hạn "${permission_type}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "${expected_error_message}"
    And Xác Thực Loại Ngoại Lệ Là "KvValidateException"

Kiểm Tra Mã HTTP Của Ngoại Lệ
    [Arguments]    ${exception_type}    ${expected_http_code}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Gây Ra Ngoại Lệ "${exception_type}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là ${expected_http_code}
    And Xác Thực Cấu Trúc Response Chứa Thông Tin Lỗi Đầy Đủ

Kiểm Tra Ngoại Lệ Đối Tác Giao Hàng Theo Điều Kiện
    [Arguments]    ${using_cod}    ${delivery_partner_status}    ${expected_result}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với UsingCod "${using_cod}" Và Đối Tác "${delivery_partner_status}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Run Keyword If    '${expected_result}' == 'Thành công (không kiểm tra)'    Mã Trạng Thái Phải Là 200
    ...    ELSE IF    '${expected_result}' == 'Lỗi 420'    Mã Trạng Thái Phải Là 420
    ...    ELSE IF    '${expected_result}' == 'Thành công'    Mã Trạng Thái Phải Là 200

Kiểm Tra Ngoại Lệ Hệ Thống
    [Arguments]    ${exception_type}    ${test_condition}    ${expected_error}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Gây Ra "${exception_type}" Với Điều Kiện "${test_condition}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "${expected_error}"
    And Xác Thực Loại Ngoại Lệ Là "${exception_type}"

Kiểm Tra Xác Thực VAT Sản Phẩm
    [Arguments]    ${vat_toggle_status}    ${expected_total_tax}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với VAT Toggle "${vat_toggle_status}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực TotalTax Trong Response Là "${expected_total_tax}"
    And Xác Thực Cấu Hình VAT Được Áp Dụng Đúng

Kiểm Tra Trùng Lặp Sản Phẩm Với Điều Kiện
    [Arguments]    ${product_condition}    ${expected_result}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm "${product_condition}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Run Keyword If    '${expected_result}' == 'Thành công'
    ...    Mã Trạng Thái Phải Là 200
    ...    ELSE
    ...    Run Keywords
    ...    Mã Trạng Thái Phải Là 420
    ...    AND    Phản Hồi Phải Chứa Lỗi "${expected_result}"

Kiểm Tra Xác Thực Khuyến Mãi
    [Arguments]    ${promotion_condition}    ${expected_result}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Khuyến Mãi "${promotion_condition}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Run Keyword If    '${expected_result}' == 'Thành công'
    ...    Mã Trạng Thái Phải Là 200
    ...    ELSE
    ...    Run Keywords
    ...    Mã Trạng Thái Phải Là 420
    ...    AND    Phản Hồi Phải Chứa Lỗi "${expected_result}"

Kiểm Tra Xác Thực Đối Tác Giao Hàng COD
    [Arguments]    ${using_cod}    ${partner_status}    ${cod_config}    ${expected_result}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với COD "${using_cod}" Đối Tác "${partner_status}" Cấu Hình "${cod_config}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Run Keyword If    '${expected_result}' == 'Thành công' or '${expected_result}' == 'Thành công (không kiểm tra)'
    ...    Then Mã Trạng Thái Phải Là 200
    ...    ELSE
    ...    Run Keywords
    ...    Then Mã Trạng Thái Phải Là 420
    ...    AND    Phản Hồi Phải Chứa Lỗi "${expected_result}"

Kiểm Tra Xác Thực Khách Hàng Cập Nhật
    [Arguments]    ${customer_id}    ${is_branch_transfer}    ${expected_result}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Cập Nhật Với CustomerId "${customer_id}" BranchTransfer "${is_branch_transfer}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Run Keyword If    '${expected_result}' == 'Thành công' or '${expected_result}' == 'Thành công (bỏ qua kiểm tra)'
    ...    Then Mã Trạng Thái Phải Là 200
    ...    ELSE
    ...    Run Keywords
    ...    Then Mã Trạng Thái Phải Là 420
    ...    AND    Phản Hồi Phải Chứa Lỗi "${expected_result}"

Kiểm Tra Xác Thực Nhân Viên Bán Hàng
    [Arguments]    ${sold_by_id}    ${is_new_order}    ${expected_result}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với SoldById "${sold_by_id}" OrderMới "${is_new_order}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Run Keyword If    '${expected_result}' == 'Thành công' or '${expected_result}' == 'Thành công (bỏ qua kiểm tra)' or '${expected_result}' == 'Thành công (không kiểm tra trạng thái)'
    ...    Then Mã Trạng Thái Phải Là 200
    ...    ELSE
    ...    Run Keywords
    ...    Then Mã Trạng Thái Phải Là 420
    ...    AND    Phản Hồi Phải Chứa Lỗi "${expected_result}"

Kiểm Tra Xác Thực Quyền Hạn Chi Tiết
    [Arguments]    ${order_type}    ${permission_type}    ${has_permission}    ${expected_result}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Loại "${order_type}" Quyền "${permission_type}" CóQuyền "${has_permission}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Run Keyword If    '${expected_result}' == 'Thành công'
    ...    Then Mã Trạng Thái Phải Là 200
    ...    ELSE IF    '${expected_result}' == 'SoldById được khôi phục'
    ...    Run Keywords
    ...    Then Mã Trạng Thái Phải Là 200
    ...    AND    Xác Thực SoldById Được Khôi Phục Về Giá Trị Ban Đầu
    ...    ELSE
    ...    Run Keywords
    ...    Then Mã Trạng Thái Phải Là 420
    ...    AND    Phản Hồi Phải Chứa Lỗi "${expected_result}"

Kiểm Tra Xác Thực Kênh Bán Hàng
    [Arguments]    ${channel_id}    ${expected_result}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với SaleChannelId "${channel_id}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Run Keyword If    '${expected_result}' == 'Thành công' or '${expected_result}' == 'Thành công (bỏ qua kiểm tra)'
    ...    Then Mã Trạng Thái Phải Là 200
    ...    ELSE
    ...    Run Keywords
    ...    Then Mã Trạng Thái Phải Là 420
    ...    AND    Phản Hồi Phải Chứa Lỗi "${expected_result}"

Kiểm Tra Bỏ Qua Xác Thực Với IsValid
    [Arguments]    ${is_valid}    ${validation_type}    ${expected_result}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với IsValid "${is_valid}" Kiểm Tra "${validation_type}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Run Keyword If    '${expected_result}' == 'Thành công (bỏ qua)'
    ...    Then Mã Trạng Thái Phải Là 200
    ...    ELSE
    ...    Run Keywords
    ...    Then Mã Trạng Thái Phải Là 420
    ...    AND    Phản Hồi Phải Chứa Lỗi "${expected_result}"

Kiểm Tra Xác Thực Giá Trị Biên
    [Arguments]    ${field_name}    ${field_value}    ${expected_result}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Trường "${field_name}" Giá Trị "${field_value}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Run Keyword If    '${expected_result}' == 'Thành công (khách hàng mặc định)' or '${expected_result}' == 'Thành công (không có nhân viên)' or '${expected_result}' == 'Thành công (kênh mặc định)' or '${expected_result}' == 'Thành công (tự động tạo)'
    ...    Then Mã Trạng Thái Phải Là 200
    ...    ELSE
    ...    Run Keywords
    ...    Then Mã Trạng Thái Phải Là 420
    ...    AND    Phản Hồi Phải Chứa Lỗi "${expected_result}"

Kiểm Tra Ngoại Lệ Hệ Thống
    [Arguments]    ${exception_type}    ${test_condition}    ${expected_error}
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Gây Ra "${exception_type}" Với Điều Kiện "${test_condition}"
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "${expected_error}"
    And Xác Thực Loại Ngoại Lệ Là "${exception_type}"

${VALID_CUSTOMER_ID}=    Set Variable    ${DEFAULT_CUSTOMER_ID} 