# Phân tích Business Logic của phương thức CreateInvoice

### 14. Kiểm tra thông tin thanh toán

#### Xác thực phương thức thanh toán

Hệ thống thực hiện kiểm tra kỹ lưỡng các phương thức thanh toán trong hóa đơn để đảm bảo tính hợp lệ:

1. **Quy trình kiểm tra cơ bản**:
   - Hệ thống kiểm tra danh sách thanh toán (`invoice.Payments`)
   - Chỉ thực hiện kiểm tra khi danh sách thanh toán không rỗng (`invoice.Payments != null && invoice.Payments.Any()`)

2. **Xác thực tài khoản ngân hàng cho thanh toán thẻ/chuyển khoản**:
   - Hệ thống duyệt qua từng phương thức thanh toán trong danh sách (`foreach(var p in invoice.Payments)`)
   - **Điều kiện áp dụng**: 
     - Thanh toán có chọn tài khoản ngân hàng (`p.AccountId != null && p.AccountId > 0`)
     - Phương thức thanh toán là thẻ hoặc chuyển khoản (`p.Method == PaymentType.Card.ToString() || p.Method == PaymentType.Transfer.ToString()`)
   
3. **Quy trình xác thực tài khoản ngân hàng (ValidateBankAccount)**:
   - Khi đáp ứng các điều kiện trên, hệ thống gọi phương thức `BankAccountService.ValidateBankAccount(p.AccountId.Value)`
   - Phương thức này thực hiện các kiểm tra sau:
     - **Kiểm tra tồn tại**: Xác minh tài khoản ngân hàng tồn tại trong hệ thống
       - Nếu không tồn tại: Hiển thị thông báo "Tài khoản ngân hàng được chọn không tồn tại hoặc đã bị xóa khỏi hệ thống." (`KVMessage.account_NotFound`)
     - **Kiểm tra quyền sử dụng tại chi nhánh**:
       - **Điều kiện kiểm tra**: Tài khoản tồn tại nhưng không phải tài khoản toàn cục (`!bank.IsGlobal`)
       - Truy vấn danh sách chi nhánh được phép sử dụng tài khoản:
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
       - Kiểm tra chi nhánh hiện tại có trong danh sách được phép:
         ```csharp
         if (!branchBank.Any(b => b.BranchId == AuthService.Context.BranchId))
         ```
       - Nếu không được phép: Hiển thị thông báo "Số tài khoản {số tài khoản} không được áp dụng cho thanh toán tại chi nhánh {tên chi nhánh}" (`KVMessage.BankAccountNotInBranch`)

> **Mục đích**: Đảm bảo tài khoản ngân hàng hợp lệ và được phép sử dụng tại chi nhánh hiện tại trước khi xử lý thanh toán.

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
  "branchBank": [],
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

---
**Điều hướng**
- Trước đó: [14-CreateInvoice-SalesPersonCheck.md](./14-CreateInvoice-SalesPersonCheck.md)
- Tiếp theo: [16-CreateInvoice-CustomerDelivery.md](./16-CreateInvoice-CustomerDelivery.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 