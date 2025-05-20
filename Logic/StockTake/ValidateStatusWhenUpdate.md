# Xác thực trạng thái khi cập nhật phiếu kiểm kho trong ValidateStatusWhenUpdate

## Mục đích
Phương thức `ValidateStatusWhenUpdate` trong lớp `StockTakeValidate` có nhiệm vụ kiểm tra tính hợp lệ của trạng thái phiếu kiểm kho khi thực hiện cập nhật. Phương thức này đảm bảo rằng người dùng không thể cập nhật phiếu kiểm kho đã được phê duyệt (Approval), giúp duy trì tính nhất quán và bảo vệ dữ liệu kiểm kho đã hoàn thành khỏi các thay đổi không mong muốn. Đây là một phần quan trọng trong quy trình quản lý vòng đời của phiếu kiểm kho.

## Quy trình chính

### Quy trình xác thực trạng thái
- Phương thức nhận vào trạng thái hiện tại của phiếu kiểm kho cần cập nhật với giá trị mặc định là 0 (Generator - trạng thái nháp):
  ```csharp
  public void ValidateStatusWhenUpdate(int? stockTakeStatus = 0)
  ```

- Kiểm tra và xử lý trạng thái phê duyệt:
  ```csharp
  if (stockTakeStatus == (int)StockTakeStatus.Approval)
  {
      throw new KvValidateStockTakeException(KVMessage.orderSupplier_MsgInvalidStatus);
  }
  ```
  - So sánh `stockTakeStatus` với `StockTakeStatus.Approval`
  - Ném ngoại lệ `KvValidateStockTakeException` nếu phiếu đã được phê duyệt

## Phụ thuộc

### Đối tượng dữ liệu và thông báo lỗi
- **StockTakeStatus**: Enum định nghĩa các trạng thái của phiếu kiểm kho:
  - **Generator (0)**: Trạng thái nháp, phiếu đang được tạo
  - **Approval (1)**: Trạng thái đã phê duyệt, phiếu đã hoàn thành và không thể thay đổi
  - **Cancel (2)**: Trạng thái đã hủy
- **KVMessage.orderSupplier_MsgInvalidStatus**: Thông báo lỗi được hiển thị khi cố gắng cập nhật phiếu kiểm kho đã được phê duyệt.

## Xử lý ngoại lệ
- `KvValidateStockTakeException`: Được ném ra khi phát hiện phiếu kiểm kho đang ở trạng thái đã phê duyệt.


## Dữ liệu kiểm thử

### Trường hợp 1: Cập nhật phiếu kiểm kho ở trạng thái nháp
```json
{
  "Input": {
    "StockTakeStatus": 0
  },
  "Result": "Thành công, trạng thái phiếu kiểm kho hợp lệ để cập nhật"
}
```

### Trường hợp 2: Cập nhật phiếu kiểm kho ở trạng thái đã phê duyệt
```json
{
  "Input": {
    "StockTakeStatus": 1
  },
  "Error": "KvValidateStockTakeException: Không thể cập nhật phiếu kiểm kho đã được phê duyệt"
}
```

### Trường hợp 3: Cập nhật phiếu kiểm kho ở trạng thái đã hủy
```json
{
  "Input": {
    "StockTakeStatus": 2
  },
  "Result": "Thành công, trạng thái phiếu kiểm kho hợp lệ để cập nhật"
}
```

### Trường hợp 4: Cập nhật phiếu kiểm kho không xác định trạng thái
```json
{
  "Input": {
    "StockTakeStatus": null
  },
  "Result": "Thành công, trạng thái phiếu kiểm kho hợp lệ để cập nhật"
}
``` 