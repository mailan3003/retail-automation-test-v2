# Xác thực mã phiếu kiểm kho trong ValidateStockTakeCode

## Mục đích
Phương thức `ValidateStockTakeCode` trong quá trình xử lý phiếu kiểm kho có nhiệm vụ kiểm tra tính hợp lệ của mã phiếu kiểm kho (StockTake Code). Phương thức này đảm bảo rằng mã phiếu kiểm kho tuân thủ các quy tắc về độ dài, tính duy nhất và không được để trống khi cập nhật phiếu kiểm kho. Việc xác thực mã phiếu kiểm kho là bước quan trọng trong quy trình tạo mới hoặc cập nhật phiếu, giúp duy trì tính nhất quán và dễ quản lý của dữ liệu.

## Quy trình chính

### 1. Kiểm tra phiếu kiểm kho trống
- Phương thức kiểm tra xem mã phiếu có bị bỏ trống khi cập nhật phiếu kiểm kho không:
  ```csharp
  var isNullStockTakeCode = string.IsNullOrWhiteSpace(stockTakeCode);
  if (isUpdateStockTake && isNullStockTakeCode)
  {
      throw new KvValidateStockTakeException(KVMessage.stocktake_CodeEmpty);
  }
  ```
- Nếu đang thực hiện cập nhật phiếu (`isUpdateStockTake` = true) và mã phiếu trống, hệ thống sẽ ném ra ngoại lệ "Mã phiếu kiểm kho đang bị trống".

### 2. Kiểm tra độ dài mã phiếu
- Khi mã phiếu không trống, phương thức sẽ kiểm tra độ dài của mã phiếu bằng cách gọi phương thức `ValidateMaxLengthOfStockTakeCode`:
  ```csharp
  if (!isNullStockTakeCode)
  {
      StockTakeValidate.ValidateMaxLengthOfStockTakeCode(stockTakeCode);
      // ...
  }
  ```
- Chi tiết về quy trình kiểm tra độ dài mã phiếu được mô tả đầy đủ trong file [ValidateMaxLengthOfStockTakeCode.md](./ValidateMaxLengthOfStockTakeCode.md). Phương thức này đảm bảo mã phiếu không vượt quá giới hạn 40 ký tự và ném ra ngoại lệ nếu vi phạm quy định.

### 3. Kiểm tra tính duy nhất của mã phiếu
- Tùy thuộc vào việc đang tạo mới hay cập nhật phiếu, phương thức sẽ gọi một trong hai hàm kiểm tra trùng lặp:
  ```csharp
  if (isUpdateStockTake)
  {
      await ValidateDuplicateCodeWhenUpdateStockTake(stockTakeCode, stockTakeId);
  }
  else
  {
      await ValidateDuplicateCodeWhenCreateStockTake(stockTakeCode);
  }
  ```

#### 3.1 Kiểm tra trùng lặp khi tạo mới
- Khi tạo mới, phương thức kiểm tra xem mã phiếu đã tồn tại trong hệ thống chưa. Chi tiết về quy trình kiểm tra trùng lặp khi tạo mới được mô tả đầy đủ trong file [ValidateDuplicateCodeWhenUpdateStockTake.md](./ValidateDuplicateCodeWhenUpdateStockTake.md).

#### 3.2 Kiểm tra trùng lặp khi cập nhật
- Khi cập nhật, phương thức kiểm tra xem mã phiếu đã tồn tại cho phiếu kiểm kho khác chưa. Chi tiết về quy trình kiểm tra trùng lặp khi cập nhật được mô tả đầy đủ trong file [ValidateDuplicateCodeWhenCreateStockTake.md](./ValidateDuplicateCodeWhenCreateStockTake.md).

## Dữ liệu kiểm thử

### Trường hợp 1: Tạo mới phiếu kiểm kho với mã hợp lệ
```json
{
  "Input": {
    "StockTakeCode": "KK001",
    "IsUpdateStockTake": false,
    "StockTakeId": 0
  },
  "ExistingCodes": [],
  "Result": "Thành công, mã phiếu kiểm kho hợp lệ"
}
```

### Trường hợp 2: Tạo mới phiếu kiểm kho với mã trùng lặp
```json
{
  "Input": {
    "StockTakeCode": "KK001",
    "IsUpdateStockTake": false,
    "StockTakeId": 0
  },
  "ExistingCodes": ["KK001"],
  "Error": "KvValidateStockTakeException: Mã KK001 đã tồn tại trong hệ thống"
}
```

### Trường hợp 3: Cập nhật phiếu kiểm kho với mã rỗng
```json
{
  "Input": {
    "StockTakeCode": "",
    "IsUpdateStockTake": true,
    "StockTakeId": 1
  },
  "Error": "KvValidateStockTakeException: Mã phiếu kiểm kho không được để trống"
}
```

### Trường hợp 4: Cập nhật phiếu kiểm kho với mã vượt quá độ dài tối đa
```json
{
  "Input": {
    "StockTakeCode": "KK00000000000000000000000000000000000000000",
    "IsUpdateStockTake": true,
    "StockTakeId": 1
  },
  "Error": "KvValidateStockTakeException: Mã phiếu kiểm kho không được vượt quá 40 ký tự"
}
```

### Trường hợp 5: Cập nhật phiếu kiểm kho với mã trùng với phiếu khác
```json
{
  "Input": {
    "StockTakeCode": "KK002",
    "IsUpdateStockTake": true,
    "StockTakeId": 1
  },
  "ExistingCodes": [
    {"Id": 1, "Code": "KK001"},
    {"Id": 2, "Code": "KK002"}
  ],
  "Error": "KvValidateStockTakeException: Mã KK002 đã tồn tại trong hệ thống"
}
```

### Trường hợp 6: Cập nhật phiếu kiểm kho với mã giữ nguyên
```json
{
  "Input": {
    "StockTakeCode": "KK001",
    "IsUpdateStockTake": true,
    "StockTakeId": 1
  },
  "ExistingCodes": [
    {"Id": 1, "Code": "KK001"},
    {"Id": 2, "Code": "KK002"}
  ],
  "Result": "Thành công, mã phiếu kiểm kho hợp lệ"
}
``` 