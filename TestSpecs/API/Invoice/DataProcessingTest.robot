*** Settings ***
Documentation     Test cases API cho phần xử lý dữ liệu đầu vào khi tạo hóa đơn
Resource          ../../../Keywords/Invoice/DataProcessingKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    DataProcessingTest

*** Test Cases ***
RT-DP-001 Tính tổng tiền hóa đơn từ chi tiết sản phẩm
    [Documentation]    Kiểm tra tính toán chính xác tổng tiền hóa đơn từ chi tiết sản phẩm
    ...    - Dữ liệu đầu vào: 
    ...    - Sản phẩm 1: ID=${PRODUCT_1}, Số lượng=1, Giá=100,000đ
    ...    - Logic xử lý: InvoiceService.CalculateInvoiceTotal() 
    ...    - Code: decimal calTotal = invoice.InvoiceDetails.Sum(x => x.Quantity * x.Price);
    ...    - Tổng tiền = 1 * 100,000đ = 100,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền trong DB được lưu đúng: 100,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Tổng Tiền Hóa Đơn    ${INVOICE_ID}    100000

RT-DP-002 Làm tròn số tiền lên theo cấu hình
    [Documentation]    Kiểm tra làm tròn số tiền lên theo cấu hình hệ thống
    ...    - Dữ liệu đầu vào: 
    ...    - Sản phẩm 1: ID=${PRODUCT_1}, Số lượng=1, Giá=100,500đ (số lẻ)
    ...    - Logic xử lý: InvoiceService.RoundMoney() làm tròn số tiền theo cấu hình
    ...    - Code: return Math.Ceiling(amount / roundUnit) * roundUnit;
    ...    - Với roundUnit=1000, tổng tiền sau làm tròn = 101,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền trong DB được làm tròn lên: 101,000đ thay vì 100,500đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Làm Tròn Lên
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Tổng Tiền Hóa Đơn    ${INVOICE_ID}    101000

RT-DP-003 Làm tròn số tiền xuống theo cấu hình
    [Documentation]    Kiểm tra làm tròn số tiền xuống theo cấu hình hệ thống
    ...    - Dữ liệu đầu vào: 
    ...    - Sản phẩm 1: ID=${PRODUCT_1}, Số lượng=1, Giá=100,400đ (số lẻ)
    ...    - Logic xử lý: InvoiceService.RoundMoney() làm tròn số tiền theo cấu hình
    ...    - Code: return Math.Floor(amount / roundUnit) * roundUnit;
    ...    - Với roundUnit=1000, tổng tiền sau làm tròn = 100,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tổng tiền trong DB được làm tròn xuống: 100,000đ thay vì 100,400đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Làm Tròn Xuống
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Tổng Tiền Hóa Đơn    ${INVOICE_ID}    100000

RT-DP-004 Tính thuế VAT của hóa đơn
    [Documentation]    Kiểm tra tính thuế VAT của hóa đơn
    ...    - Dữ liệu đầu vào: 
    ...    - Sản phẩm 1: ID=${product_with_vat}, Số lượng=1, Giá=100,000đ, Thuế suất=10%
    ...    - Logic xử lý: InvoiceService.CalculateVAT() 
    ...    - Code: VAT = invoice.InvoiceDetails.Sum(x => x.Quantity * x.Price * x.VATRate / 100);
    ...    - Thuế VAT = 1 * 100,000đ * 10% = 10,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Thuế VAT trong DB được lưu đúng: 10,000đ
    ...    - Cờ thuế VAT được bật (IsVAT=1)
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Thuế Hóa Đơn    ${INVOICE_ID}    10000

RT-DP-005 Tính chiết khấu theo phần trăm cho sản phẩm
    [Documentation]    Kiểm tra tính chiết khấu theo phần trăm cho sản phẩm
    ...    - Dữ liệu đầu vào: 
    ...    - Sản phẩm 1: ID=${PRODUCT_1}, Số lượng=1, Giá=100,000đ, Tỷ lệ chiết khấu=10%
    ...    - Logic xử lý: InvoiceService.CalculateDiscount() 
    ...    - Code: discount = detail.Price * detail.Quantity * detail.DiscountRate / 100;
    ...    - Tiền chiết khấu = 100,000đ * 1 * 10% = 10,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Chiết khấu trong DB được lưu đúng: 10,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Phần Trăm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Chiết Khấu Hóa Đơn    ${INVOICE_ID}    10000

RT-DP-006 Tính chiết khấu cố định cho sản phẩm
    [Documentation]    Kiểm tra tính chiết khấu cố định cho sản phẩm
    ...    - Dữ liệu đầu vào: 
    ...    - Sản phẩm 1: ID=${PRODUCT_1}, Số lượng=1, Giá=100,000đ, Chiết khấu=10,000đ
    ...    - Logic xử lý: InvoiceService.CalculateDiscount() 
    ...    - Code: discount = detail.Discount;
    ...    - Tiền chiết khấu = 10,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Chiết khấu trong DB được lưu đúng: 10,000đ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Cố Định
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Chiết Khấu Hóa Đơn    ${INVOICE_ID}    10000

RT-DP-007 Áp dụng khuyến mãi cho hóa đơn
    [Documentation]    Kiểm tra áp dụng khuyến mãi cho hóa đơn
    ...    - Dữ liệu đầu vào: 
    ...    - Hóa đơn với PromotionId=${VALID_PROMOTION_ID}
    ...    - Logic xử lý: InvoiceService.ApplyPromotion() 
    ...    - Code: invoice.Discount += promotion.Value; hoặc invoice.Discount += invoice.Total * promotion.Value / 100;
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - PromotionId trong DB được lưu đúng
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Khuyến Mãi Hóa Đơn    ${INVOICE_ID}    ${VALID_PROMOTION_ID}

RT-DP-008 Xử lý nhiều phương thức thanh toán
    [Documentation]    Kiểm tra xử lý nhiều phương thức thanh toán cùng lúc
    ...    - Dữ liệu đầu vào: 
    ...    - Hóa đơn với 2 phương thức thanh toán:
    ...    - Tiền mặt: 100,000đ
    ...    - Thẻ: 100,000đ, AccountId=${DEFAULT_BANK_ACCOUNT_ID}
    ...    - Logic xử lý: InvoiceService.ProcessPayments() 
    ...    - Code: foreach(var payment in invoice.Payments) { ... }
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Nhiều phương thức thanh toán được lưu trong DB
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Phương Thức Thanh Toán
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Nhiều Phương Thức Thanh Toán    ${INVOICE_ID}
    And Xác Thực Thanh Toán Hóa Đơn    ${INVOICE_ID}    Cash    100000
    And Xác Thực Thanh Toán Hóa Đơn    ${INVOICE_ID}    Card    100000

RT-DP-009 Cập nhật số lượng tồn kho khi tạo hóa đơn
    [Documentation]    Kiểm tra cập nhật số lượng tồn kho khi tạo hóa đơn
    ...    - Dữ liệu đầu vào: 
    ...    - Sản phẩm 1: ID=${PRODUCT_1}, Số lượng=5, Giá=100,000đ
    ...    - Logic xử lý: InventoryService.UpdateInventory() 
    ...    - Code: inventory.Quantity -= invoiceDetail.Quantity;
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Số lượng tồn kho được cập nhật trong DB (giảm 5 đơn vị)
    ...    - Lịch sử tồn kho được ghi lại với InvoiceId và số lượng bán=5
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Cập Nhật Tồn Kho
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Cập Nhật Tồn Kho    ${INVOICE_ID}    ${PRODUCT_1}    5

RT-DP-010 Tính công nợ khách hàng khi tạo hóa đơn
    [Documentation]    Kiểm tra tính công nợ khách hàng khi tạo hóa đơn
    ...    - Dữ liệu đầu vào: 
    ...    - Khách hàng ID=${DEBT_CUSTOMER_ID} (có nợ ban đầu)
    ...    - Hóa đơn: tổng tiền 100,000đ, không thanh toán
    ...    - Logic xử lý: CustomerService.UpdateDebt() 
    ...    - Code: customer.Debt += invoice.Total - invoice.TotalPayment;
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Công nợ khách hàng được cập nhật trong DB (tăng thêm 100,000đ)
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Nợ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Công Nợ Khách Hàng    ${INVOICE_ID}    ${DEBT_CUSTOMER_ID}    100000

RT-DP-011 Kiểm tra hạn mức nợ của khách hàng
    [Documentation]    Kiểm tra hạn mức nợ của khách hàng khi tạo hóa đơn
    ...    - Dữ liệu đầu vào: 
    ...    - Khách hàng ID=${DEBT_LIMIT_CUSTOMER_ID} (có nợ gần tới hạn mức)
    ...    - Hóa đơn: tổng tiền 100,000đ, không thanh toán
    ...    - Logic xử lý: CustomerService.CheckDebtLimit() 
    ...    - Code: if (customer.Debt + amount > customer.DebtLimit && customer.UseDebtLimit) throw new Exception("Vượt hạn mức nợ");
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Vượt hạn mức nợ"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Nợ Vượt Hạn Mức
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 420
    And Response Should Have Error "Vượt hạn mức nợ"

RT-DP-012 Bỏ qua cảnh báo hạn mức nợ
    [Documentation]    Kiểm tra bỏ qua cảnh báo hạn mức nợ khi cấu hình cho phép
    ...    - Dữ liệu đầu vào: 
    ...    - Khách hàng ID=${DEBT_WARNING_OFF_CUSTOMER_ID} (tắt cảnh báo hạn mức nợ)
    ...    - Hóa đơn: tổng tiền 100,000đ, không thanh toán
    ...    - Logic xử lý: CustomerService.CheckDebtLimit() 
    ...    - Code: if (!customer.UseDebtLimit) return true; // Bỏ qua kiểm tra nếu tắt cảnh báo
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn được tạo thành công dù vượt hạn mức nợ
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Nợ Không Cảnh Báo
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Response Status Code Should Be 200
    And Xác Thực Hóa Đơn Trong DB
    And Xác Thực Công Nợ Khách Hàng    ${INVOICE_ID}    ${DEBT_WARNING_OFF_CUSTOMER_ID}    100000 