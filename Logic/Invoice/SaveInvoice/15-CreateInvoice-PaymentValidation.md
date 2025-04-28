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
          var branchBank = await BankAccountBranchService.GetAll()
              .Where(b => b.BankAccountId == accountId && b.RetailerId == AuthService.Context.RetailerId)
              .ToListAsync();
          ```
        - Nếu không tìm thấy bản ghi nào trong danh sách `branchBank` hoặc không có bản ghi nào có `BranchId` trùng với chi nhánh hiện tại (`AuthService.Context.BranchId`), tức là tài khoản không được phép sử dụng tại chi nhánh hiện tại:
          ```csharp
          if (!branchBank.Any(b => b.BranchId == AuthService.Context.BranchId))
          ```
        - Trong trường hợp này, hệ thống sẽ hiển thị thông báo lỗi: "Số tài khoản {số tài khoản} không được áp dụng cho thanh toán tại chi nhánh {tên chi nhánh}" (`KVMessage.BankAccountNotInBranch`)
    - Việc xác thực này đảm bảo tài khoản ngân hàng hợp lệ và được phép sử dụng tại chi nhánh hiện tại trước khi xử lý thanh toán 

## Test Data JSON cho các trường hợp thất bại

### 1. Tài khoản ngân hàng không tồn tại
```json
{
  "Invoice": {
    "Payments": [
      {
        "PaymentType": 2,
        "AccountId": 123,
        "Amount": 500000
      }
    ]
  },
  "ValidateBankAccountResult": {
    "IsValid": false,
    "ErrorMessage": "Tài khoản ngân hàng được chọn không tồn tại hoặc đã bị xóa khỏi hệ thống."
  },
  "ExpectedError": {
    "Type": "KvValidateBankAccountException",
    "Message": "Tài khoản ngân hàng được chọn không tồn tại hoặc đã bị xóa khỏi hệ thống."
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi tài khoản ngân hàng được sử dụng cho thanh toán không tồn tại trong hệ thống.

### 2. Tài khoản ngân hàng không được phép sử dụng tại chi nhánh hiện tại
```json
{
  "Invoice": {
    "Payments": [
      {
        "PaymentType": 3,
        "AccountId": 456,
        "Amount": 500000
      }
    ]
  },
  "BankAccount": {
    "Id": 456,
    "AccountNumber": "0123456789",
    "IsGlobal": false
  },
  "CurrentBranch": {
    "Id": 10,
    "Name": "Chi nhánh Hà Nội"
  },
  "BankAccountBranches": [],
  "AuthServiceContext": {
    "RetailerId": 789
  },
  "ExpectedError": {
    "Type": "KvValidateBankAccountException",
    "Message": "Số tài khoản 0123456789 không được áp dụng cho thanh toán tại chi nhánh Chi nhánh Hà Nội"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi tài khoản ngân hàng không được phép sử dụng tại chi nhánh hiện tại.

### 3. Nhiều phương thức thanh toán với tài khoản không hợp lệ
```json
{
  "Invoice": {
    "Payments": [
      {
        "PaymentType": 2,
        "AccountId": 123,
        "Amount": 300000
      },
      {
        "PaymentType": 3,
        "AccountId": 456,
        "Amount": 200000
      }
    ]
  },
  "ValidateBankAccountResults": [
    {
      "AccountId": 123,
      "IsValid": true
    },
    {
      "AccountId": 456,
      "IsValid": false,
      "ErrorMessage": "Tài khoản ngân hàng được chọn không tồn tại hoặc đã bị xóa khỏi hệ thống."
    }
  ],
  "ExpectedError": {
    "Type": "KvValidateBankAccountException",
    "Message": "Tài khoản ngân hàng được chọn không tồn tại hoặc đã bị xóa khỏi hệ thống."
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi một trong nhiều phương thức thanh toán sử dụng tài khoản ngân hàng không hợp lệ.

### 4. Thanh toán qua thẻ hoặc chuyển khoản không chọn tài khoản
```json
{
  "Invoice": {
    "Payments": [
      {
        "PaymentType": 2,
        "AccountId": null,
        "Amount": 500000
      }
    ]
  },
  "ExpectedError": {
    "Type": "KvValidateBankAccountException",
    "Message": "Vui lòng chọn tài khoản ngân hàng để thanh toán"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi thanh toán qua thẻ hoặc chuyển khoản nhưng không chọn tài khoản ngân hàng.

---
**Điều hướng**
- Trước đó: [14-CreateInvoice-SalesPersonCheck.md](./14-CreateInvoice-SalesPersonCheck.md)
- Tiếp theo: [16-CreateInvoice-CustomerDelivery.md](./16-CreateInvoice-CustomerDelivery.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 