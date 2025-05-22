# Xác thực ngày điều chỉnh so với ngày hiện tại trong ValidateAdjustmentDateWithDateNow

## Mục đích
Phương thức `ValidateAdjustmentDateWithDateNow` trong lớp `StockTakeValidate` có nhiệm vụ kiểm tra tính hợp lệ của ngày điều chỉnh (AdjustmentDate) của phiếu kiểm kho so với ngày hiện tại. Phương thức đảm bảo rằng người dùng không thể điều chỉnh phiếu kiểm kho với ngày trong tương lai, giúp duy trì tính chính xác và logic của dữ liệu trong hệ thống kiểm kho.

## Quy trình chính

### Kiểm tra và xác thực ngày điều chỉnh
- Kiểm tra null và so sánh thời gian:
  ```csharp
  if (adjustmentDate == null) return;
  var isAdjustmentDateError = RoughCompareTime((DateTime)adjustmentDate, DateTime.Now) <= 0;
  if (!isAdjustmentDateError)
  {
      throw new KvValidateStockTakeException(KVMessage.GreaterThanNow);
  }
  ```
- Phương thức bỏ qua kiểm tra nếu ngày điều chỉnh là null
- Sử dụng `RoughCompareTime` để so sánh với độ chênh lệch cho phép (~500ms)
- Ném ngoại lệ nếu ngày điều chỉnh nằm trong tương lai "Vượt quá thời gian hiện tại"

## Dữ liệu kiểm thử

### Trường hợp 1: Ngày điều chỉnh null
```json
{
  "Input": {
    "AdjustmentDate": null
  },
  "Result": "Thành công, bỏ qua kiểm tra ngày điều chỉnh"
}
```

### Trường hợp 2: Ngày điều chỉnh trong quá khứ
```json
{
  "Input": {
    "AdjustmentDate": "2023-01-15T10:00:00"
  },
  "CurrentDate": "2023-01-20T10:00:00",
  "Result": "Thành công, ngày điều chỉnh hợp lệ"
}
```

### Trường hợp 3: Ngày điều chỉnh là ngày hiện tại
```json
{
  "Input": {
    "AdjustmentDate": "2023-01-20T10:00:00"
  },
  "CurrentDate": "2023-01-20T10:00:00",
  "Result": "Thành công, ngày điều chỉnh hợp lệ"
}
```

### Trường hợp 4: Ngày điều chỉnh trong tương lai
```json
{
  "Input": {
    "AdjustmentDate": "2023-01-25T10:00:00"
  },
  "CurrentDate": "2023-01-20T10:00:00",
  "Error": "KvValidateStockTakeException: Vượt quá thời gian hiện tại"
}
```

### Trường hợp 5: Ngày điều chỉnh có chênh lệch nhỏ so với hiện tại
```json
{
  "Input": {
    "AdjustmentDate": "2023-01-20T10:00:00.400"
  },
  "CurrentDate": "2023-01-20T10:00:00",
  "Result": "Thành công, chênh lệch thời gian trong phạm vi cho phép"
}
``` 