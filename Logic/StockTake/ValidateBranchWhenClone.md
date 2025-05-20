# Xác thực chi nhánh khi sao chép phiếu kiểm kho trong ValidateBranchWhenClone

## Mục đích
Phương thức `ValidateBranchWhenClone` trong lớp `StockTakeValidate` có nhiệm vụ kiểm tra tính hợp lệ của chi nhánh khi thực hiện sao chép (clone) một phiếu kiểm kho. Phương thức đảm bảo rằng phiếu kiểm kho chỉ được sao chép trong cùng một chi nhánh, không cho phép sao chép phiếu kiểm kho từ chi nhánh này sang chi nhánh khác. Việc này giúp duy trì tính chính xác và nhất quán của dữ liệu kiểm kho giữa các chi nhánh.

## Quy trình chính

### 1. Kiểm tra chi nhánh khi sao chép
- Hệ thống sẽ kiểm tra xem bạn đang ở chi nhánh nào và phiếu kiểm kho bạn muốn sao chép thuộc chi nhánh nào:
  ```csharp
  public void ValidateBranchWhenClone(int branchId, int currentBranchId)
  ```

- Hệ thống so sánh chi nhánh của phiếu kiểm kho với chi nhánh hiện tại của bạn:
  ```csharp
  if (branchId != currentBranchId)
  ```
- Nếu khác nhau, nghĩa là bạn đang cố gắng sao chép phiếu kiểm kho từ một chi nhánh khác

- Nếu phát hiện bạn đang cố sao chép từ chi nhánh khác, hệ thống sẽ hiển thị thông báo:
  ```csharp
  throw new KvValidateBranchException(KVMessage.transfer_InvalidBranch);
  ```
- Thông báo "Chi nhánh hiện tại đã thay đổi. Vui lòng tải lại trang và thực hiện lại" sẽ được hiển thị

## Dữ liệu kiểm thử

### Trường hợp 1: Chi nhánh hợp lệ - Cùng chi nhánh
```json
{
  "Input": {
    "BranchId": 1,
    "CurrentBranchId": 1
  },
  "Result": "Thành công, chi nhánh hợp lệ cho sao chép"
}
```

### Trường hợp 2: Chi nhánh không hợp lệ - Khác chi nhánh
```json
{
  "Input": {
    "BranchId": 2,
    "CurrentBranchId": 1
  },
  "Error": "KvValidateBranchException: Không thể sao chép phiếu kiểm kho từ chi nhánh khác"
}
```

### Trường hợp 3: Ứng dụng trong quy trình IsValidateStockTake
```json
{
  "StockTakeValidateInfo": {
    "IsCloneStockTake": true,
    "BranchId": 1,
    "CurrentBranchId": 1
  },
  "ValidationSteps": [
    "Kiểm tra trùng lặp sản phẩm: Thành công",
    "Kiểm tra số lượng thực tế: Thành công",
    "Kiểm tra chi nhánh khi sao chép: Thành công"
  ],
  "Result": "Phiếu kiểm kho hợp lệ để sao chép"
}
``` 