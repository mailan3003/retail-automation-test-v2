# Xác thực mã phiếu kiểm kho trùng lặp khi cập nhật trong ValidateDuplicateCodeWhenUpdateStockTake

## Mục đích
Phương thức `ValidateDuplicateCodeWhenUpdateStockTake` trong lớp `StockTakeService` có nhiệm vụ kiểm tra tính duy nhất của mã phiếu kiểm kho khi cập nhật phiếu. Phương thức này đảm bảo rằng khi thay đổi mã của một phiếu kiểm kho, mã mới không trùng lặp với mã của các phiếu kiểm kho khác trong hệ thống, đồng thời vẫn cho phép giữ nguyên mã cũ nếu không thay đổi.

## Quy trình chính

### 1. Truy vấn cơ sở dữ liệu kiểm tra trùng lặp với loại trừ phiếu hiện tại
- Thực hiện truy vấn để kiểm tra xem mã phiếu kiểm kho đã tồn tại cho phiếu khác trong hệ thống chưa:
  ```csharp
  var isExistCode = await _getAll().AnyAsync(c =>
      c.Code.Equals(stockTakeCode, StringComparison.CurrentCulture) && c.Id != stockTakeId &&
      c.RetailerId == AuthService.Context.RetailerId);
  ```
- Truy vấn sử dụng phương thức `AnyAsync` để kiểm tra sự tồn tại của mã
- Điều kiện `c.Id != stockTakeId` loại trừ phiếu hiện tại đang được cập nhật
- So sánh mã phiếu được thực hiện phân biệt chữ hoa chữ thường (CurrentCulture)

### 2. Xử lý khi phát hiện mã trùng lặp
- Nếu mã phiếu đã tồn tại ở phiếu khác, phương thức sẽ ném ra ngoại lệ:
  ```csharp
  if (isExistCode)
  {
      throw new KvValidateStockTakeException(string.Format(KVMessage._GlobalDuplicateData, stockTakeCode));
  }
  ```
- Thông báo lỗi "{0} đã tồn tại" bao gồm mã phiếu kiểm kho bị trùng, giúp người dùng dễ dàng xác định vấn đề

## Dữ liệu kiểm thử

### Trường hợp 1: Cập nhật phiếu kiểm kho với mã mới chưa tồn tại
```json
{
  "Input": {
    "StockTakeCode": "KK002",
    "StockTakeId": 1
  },
  "ExistingCodes": [
    {"Id": 1, "Code": "KK001"},
    {"Id": 2, "Code": "KK003"}
  ],
  "Result": "Thành công, mã phiếu kiểm kho hợp lệ"
}
```

### Trường hợp 2: Cập nhật phiếu kiểm kho giữ nguyên mã cũ
```json
{
  "Input": {
    "StockTakeCode": "KK001",
    "StockTakeId": 1
  },
  "ExistingCodes": [
    {"Id": 1, "Code": "KK001"},
    {"Id": 2, "Code": "KK002"}
  ],
  "Result": "Thành công, mã phiếu kiểm kho hợp lệ"
}
```

### Trường hợp 3: Cập nhật phiếu kiểm kho với mã đã tồn tại ở phiếu khác
```json
{
  "Input": {
    "StockTakeCode": "KK002",
    "StockTakeId": 1
  },
  "ExistingCodes": [
    {"Id": 1, "Code": "KK001"},
    {"Id": 2, "Code": "KK002"}
  ],
  "Error": "KvValidateStockTakeException: Mã KK002 đã tồn tại trong hệ thống"
}
```

### Trường hợp 4: Cập nhật phiếu kiểm kho với mã trùng nhưng khác người bán lẻ
```json
{
  "Input": {
    "StockTakeCode": "KK002",
    "StockTakeId": 1,
    "RetailerId": 2
  },
  "ExistingCodes": [
    {"Id": 3, "Code": "KK002", "RetailerId": 1}
  ],
  "Result": "Thành công, mã phiếu kiểm kho hợp lệ"
}
``` 