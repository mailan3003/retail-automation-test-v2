# Phân tích Business Logic của phương thức CreateInvoice

### 14. Kiểm tra thông tin thanh toán
- **Xác thực phương thức thanh toán**:
  - Hệ thống kiểm tra danh sách thanh toán trong hóa đơn (`invoice.Payments`)
  - Nếu danh sách thanh toán không rỗng, hệ thống sẽ duyệt qua từng phương thức thanh toán
  - Đối với các phương thức thanh toán qua thẻ (`PaymentType.Card`) hoặc chuyển khoản (`PaymentType.Transfer`):
    - Kiểm tra xem thanh toán có liên kết với tài khoản ngân hàng không (`p.AccountId != null && p.AccountId > 0`)
    - Nếu có, hệ thống sẽ xác thực tài khoản ngân hàng thông qua `BankAccountService.ValidateBankAccount(p.AccountId.Value)`
    - Quá trình xác thực tài khoản ngân hàng bao gồm:
      - Kiểm tra tài khoản ngân hàng có tồn tại trong hệ thống không
      - Nếu tài khoản không tồn tại, hệ thống sẽ hiển thị thông báo lỗi: "Tài khoản ngân hàng được chọn không tồn tại hoặc đã bị xóa khỏi hệ thống." (`KVMessage.account_NotFound`)
      - Nếu tài khoản tồn tại nhưng không phải tài khoản toàn cục (`!bank.IsGlobal`):
        - Hệ thống sẽ kiểm tra xem tài khoản có được phép sử dụng tại chi nhánh hiện tại không
        - Thực hiện truy vấn để xác minh tài khoản được phép sử dụng tại chi nhánh hiện tại:
          ```sql
          SELECT * FROM BankAccountBranch 
          WHERE BankAccountId = @accountId 
          AND RetailerId = @retailerId
          ```
        - Tương đương với truy vấn Entity Framework:
          ```csharp
          var bankAccountBranches = await BankAccountBranchService.GetAll()
              .Where(b => b.BankAccountId == accountId && b.RetailerId == AuthService.Context.RetailerId)
              .ToListAsync();
          ```
        - Nếu không tìm thấy bản ghi nào, tức là tài khoản không được phép sử dụng tại chi nhánh hiện tại
        - Trong trường hợp này, hệ thống sẽ hiển thị thông báo lỗi: "Số tài khoản {số tài khoản} không được áp dụng cho thanh toán tại chi nhánh {tên chi nhánh}" (`KVMessage.BankAccountNotInBranch`)
    - Việc xác thực này đảm bảo tài khoản ngân hàng hợp lệ và được phép sử dụng tại chi nhánh hiện tại trước khi xử lý thanh toán 