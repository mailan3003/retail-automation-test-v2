# Xác thực hoàn thành phiếu kiểm kho trong ValidateStockTakeComplete

## Mục đích
Phương thức `ValidateStockTakeComplete` trong lớp `StockTakeService` có nhiệm vụ kiểm tra tính hợp lệ của việc hoàn thành (phê duyệt) một phiếu kiểm kho. Phương thức này thực hiện nhiều kiểm tra quan trọng bao gồm: xác thực quyền hạn của người dùng, kiểm tra ngày điều chỉnh hợp lệ, và đảm bảo ngày điều chỉnh không nằm trong kỳ đóng sổ. Việc xác thực này đảm bảo tính nhất quán và chính xác của dữ liệu khi phiếu kiểm kho được phê duyệt.

## Quy trình chính

### 1. Kiểm tra quyền hạn người dùng
- Kiểm tra xem người dùng có quyền hoàn thành phiếu kiểm kho không:
  ```csharp
  var isCheckPermission = checkPermission.GetValueOrDefault(false);
  var isStockTakeFinishPermission = AuthService.CheckPermission(StockTake.Finish, cBranchId);
  if (isCheckPermission && !isStockTakeFinishPermission)
  {
      throw new KvUnauthorizedException(KVMessage._invalid_Permission);
  }
  ```
- Nếu người dùng không có quyền và cờ `checkPermission` được bật, phương thức sẽ ném ra ngoại lệ về quyền hạn

### 2. Kiểm tra ngày đóng sổ
- Xác thực rằng ngày điều chỉnh không nằm trong kỳ đóng sổ:
  ```csharp
  var closeBookMessageStockTake = string.Format(KVMessage._canNotCreateBeforeBookClosing, Labels.stocktake_Lbl);
  await BranchService.ValidCloseDate(adjustmentDate, closeBookMessageStockTake, branchId);
  ```
- Sử dụng `BranchService.ValidCloseDate` để kiểm tra kỳ đóng sổ của chi nhánh (xem thêm chi tiết tại [ValidCloseDate.md](../Branch/ValidCloseDate.md))

### 3. Kiểm tra ngày điều chỉnh so với ngày hiện tại
- Đảm bảo ngày điều chỉnh không nằm trong tương lai bằng cách gọi phương thức `ValidateAdjustmentDateWithDateNow` (xem thêm chi tiết tại [ValidateAdjustmentDateWithDateNow.md](ValidateAdjustmentDateWithDateNow.md)):
  ```csharp
  StockTakeValidate.ValidateAdjustmentDateWithDateNow(adjustmentDate);
  ```
- Nếu ngày điều chỉnh nằm trong tương lai, phương thức sẽ ném ra ngoại lệ

### 4. Kiểm tra ngày điều chỉnh với quy trình nghiệp vụ
- Xác thực ngày điều chỉnh phù hợp với quy trình nghiệp vụ:
  ```csharp
  if (adjustmentDate != null && adjustmentDate != DateTime.MinValue)
  {
      var purchaseDateNew = adjustmentDate ?? DateTime.Now;
      InvoiceService.ValidateUpdateOrDeletePurchaseDate(purchaseDateNew, DateTime.Now, TypeDirection.Add);
  }
  ```
- Kiểm tra xem ngày điều chỉnh có phù hợp với các quy tắc nghiệp vụ liên quan đến hóa đơn không (xem thêm chi tiết tại [ValidateUpdateOrDeletePurchaseDate.md](../Invoice/ValidateUpdateOrDeletePurchaseDate.md))

## Dữ liệu kiểm thử

### Trường hợp 1: Người dùng có quyền hoàn thành phiếu kiểm kho
```json
{
  "Input": {
    "AdjustmentDate": "2023-01-15T10:00:00",
    "BranchId": 1,
    "CheckPermission": true
  },
  "UserPermissions": ["StockTake.Finish"],
  "ClosedDate": "2022-12-31T00:00:00",
  "Result": "Thành công, có thể hoàn thành phiếu kiểm kho"
}
```

### Trường hợp 2: Người dùng không có quyền hoàn thành phiếu kiểm kho
```json
{
  "Input": {
    "AdjustmentDate": "2023-01-15T10:00:00",
    "BranchId": 1,
    "CheckPermission": true
  },
  "UserPermissions": [],
  "ClosedDate": "2022-12-31T00:00:00",
  "Error": "KvUnauthorizedException: Bạn không có quyền hoàn thành phiếu kiểm kho"
}
```

### Trường hợp 3: Hoàn thành phiếu với ngày điều chỉnh nằm trong kỳ đóng sổ
```json
{
  "Input": {
    "AdjustmentDate": "2022-12-15T10:00:00",
    "BranchId": 1,
    "CheckPermission": true
  },
  "UserPermissions": ["StockTake.Finish"],
  "ClosedDate": "2022-12-31T00:00:00",
  "Error": "KvValidateStockTakeException: Không thể tạo phiếu kiểm kho trước ngày đóng sổ"
}
```

### Trường hợp 4: Hoàn thành phiếu với ngày điều chỉnh trong tương lai
```json
{
  "Input": {
    "AdjustmentDate": "2023-12-31T10:00:00",
    "BranchId": 1,
    "CheckPermission": true
  },
  "UserPermissions": ["StockTake.Finish"],
  "ClosedDate": "2022-12-31T00:00:00",
  "CurrentDate": "2023-01-15T10:00:00",
  "Error": "KvValidateStockTakeException: Ngày thực hiện không được lớn hơn ngày hiện tại"
}
```

### Trường hợp 5: Vô hiệu hóa kiểm tra quyền hạn
```json
{
  "Input": {
    "AdjustmentDate": "2023-01-15T10:00:00",
    "BranchId": 1,
    "CheckPermission": false
  },
  "UserPermissions": [],
  "ClosedDate": "2022-12-31T00:00:00",
  "Result": "Thành công, có thể hoàn thành phiếu kiểm kho (bỏ qua kiểm tra quyền hạn)"
}
``` 