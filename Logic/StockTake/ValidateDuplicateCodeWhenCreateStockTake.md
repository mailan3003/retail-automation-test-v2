# Xác thực mã phiếu kiểm kho trùng lặp khi tạo mới trong ValidateDuplicateCodeWhenCreateStockTake

## Mục đích
Phương thức `ValidateDuplicateCodeWhenCreateStockTake` trong lớp `StockTakeService` có nhiệm vụ kiểm tra tính duy nhất của mã phiếu kiểm kho khi tạo mới phiếu. Phương thức này đảm bảo rằng mã phiếu kiểm kho không bị trùng lặp trong hệ thống, giúp duy trì tính nhất quán và khả năng tra cứu dễ dàng của dữ liệu kiểm kho.

## Quy trình chính

### 1. Truy vấn cơ sở dữ liệu kiểm tra trùng lặp
- Thực hiện truy vấn để kiểm tra xem mã phiếu kiểm kho đã tồn tại trong hệ thống chưa:
  ```csharp
  var isExistCode = await _getAll().AnyAsync(c =>
      c.Code.Equals(stockTakeCode, StringComparison.CurrentCulture) &&
      c.RetailerId == AuthService.Context.RetailerId);
  ```
- Truy vấn sử dụng phương thức `AnyAsync` để kiểm tra sự tồn tại của mã trong phạm vi của người bán lẻ hiện tại
- So sánh mã phiếu được thực hiện phân biệt chữ hoa chữ thường (CurrentCulture)

### 2. Xử lý khi phát hiện mã trùng lặp
- Nếu mã phiếu đã tồn tại, phương thức sẽ ném ra ngoại lệ:
  ```csharp
  if (isExistCode)
  {
      throw new KvValidateStockTakeException(string.Format(KVMessage._GlobalDuplicateData, stockTakeCode));
  }
  ```
- Thông báo lỗi "{0} đã tồn tại" bao gồm mã phiếu kiểm kho bị trùng, giúp người dùng dễ dàng xác định vấn đề

## Dữ liệu kiểm thử

### Trường hợp 1: Tạo mới phiếu kiểm kho với mã chưa tồn tại
```json
{
  "Input": {
    "StockTakeCode": "KK001"
  },
  "ExistingCodes": [],
  "Result": "Thành công, mã phiếu kiểm kho hợp lệ"
}
```

### Trường hợp 2: Tạo mới phiếu kiểm kho với mã đã tồn tại
```json
{
  "Input": {
    "StockTakeCode": "KK001"
  },
  "ExistingCodes": ["KK001"],
  "Error": "KvValidateStockTakeException: Mã KK001 đã tồn tại trong hệ thống"
}
```

### Trường hợp 3: Tạo mới phiếu kiểm kho với mã trùng nhưng khác người bán lẻ
```json
{
  "Input": {
    "StockTakeCode": "KK001",
    "RetailerId": 2
  },
  "ExistingCodes": [
    {"Code": "KK001", "RetailerId": 1}
  ],
  "Result": "Thành công, mã phiếu kiểm kho hợp lệ"
}
```

### Trường hợp 4: Tạo mới phiếu kiểm kho với mã trùng nhưng khác chữ hoa/thường
```json
{
  "Input": {
    "StockTakeCode": "kk001"
  },
  "ExistingCodes": ["KK001"],
  "Error": "KvValidateStockTakeException: Mã kk001 đã tồn tại trong hệ thống"
}
``` 