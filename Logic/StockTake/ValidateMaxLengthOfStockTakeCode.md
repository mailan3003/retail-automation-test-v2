# Xác thực độ dài mã phiếu kiểm kho trong ValidateMaxLengthOfStockTakeCode

## Mục đích
Phương thức `ValidateMaxLengthOfStockTakeCode` trong lớp `StockTakeValidate` có nhiệm vụ kiểm tra và đảm bảo rằng độ dài của mã phiếu kiểm kho không vượt quá giới hạn cho phép. Việc giới hạn độ dài mã phiếu kiểm kho giúp duy trì tính nhất quán và dễ quản lý trong hệ thống, đồng thời đảm bảo khả năng hiển thị và xử lý dữ liệu ổn định trên các giao diện người dùng và báo cáo.

## Quy trình chính

### 1. Định nghĩa giới hạn độ dài
- Định nghĩa hằng số độ dài tối đa cho mã phiếu kiểm kho:
  ```csharp
  const int maxCodeLength = 40;
  ```

### 2. Kiểm tra độ dài mã phiếu
- Kiểm tra độ dài của mã phiếu kiểm kho:
  ```csharp
  if (stockTakeCode.Length > maxCodeLength)
  ```

### 3. Xử lý khi vượt quá giới hạn
- Ném ra ngoại lệ với thông báo lỗi:
  ```csharp
  throw new KvValidateStockTakeException(KVMessage.stocktake_CodeMaxLength);
  ```

## Dữ liệu kiểm thử

### Trường hợp 1: Mã phiếu kiểm kho có độ dài hợp lệ
```json
{
  "Input": {
    "StockTakeCode": "KK001-2023"
  },
  "Result": "Thành công, độ dài mã phiếu kiểm kho hợp lệ"
}
```

### Trường hợp 2: Mã phiếu kiểm kho có độ dài chính xác 40 ký tự
```json
{
  "Input": {
    "StockTakeCode": "KK001-2023-ChiNhanhA-PhieuKiemKhoThang12"
  },
  "Result": "Thành công, độ dài mã phiếu kiểm kho hợp lệ"
}
```

### Trường hợp 3: Mã phiếu kiểm kho có độ dài vượt quá 40 ký tự
```json
{
  "Input": {
    "StockTakeCode": "KK001-2023-ChiNhanhA-PhieuKiemKhoThang12-QuaMucQuyDinh"
  },
  "Error": "KvValidateStockTakeException: Mã phiếu kiểm kho không được vượt quá 40 ký tự"
}
```

### Trường hợp 4: Mã phiếu kiểm kho có độ dài ngắn
```json
{
  "Input": {
    "StockTakeCode": "KK1"
  },
  "Result": "Thành công, độ dài mã phiếu kiểm kho hợp lệ"
}
``` 