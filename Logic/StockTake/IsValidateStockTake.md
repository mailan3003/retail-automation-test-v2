# Xác thực phiếu kiểm kho trong IsValidateStockTake

## Mục đích
Phương thức `IsValidateStockTake` trong lớp `StockTakeService` có nhiệm vụ thực hiện tất cả các kiểm tra xác thực cần thiết cho phiếu kiểm kho trước khi tiến hành các thao tác tạo mới hoặc cập nhật. Phương thức này đảm bảo tính nhất quán và hợp lệ của dữ liệu phiếu kiểm kho.

## Quy trình chính

### 1. Kiểm tra tồn tại của phiếu kiểm kho khi cập nhật
- Nếu `stockTakeValidateInfo.StockTakeId > 0` và `!stockTakeValidateInfo.IsUpdateStockTake`, ném ra ngoại lệ `KVMessage.not_existing_stocktake` "Phiếu kiểm kho không tồn tại".
- Kiểm tra này đảm bảo không thể thực hiện thao tác cập nhật trên một phiếu không tồn tại.

### 2. Kiểm tra trạng thái hủy
- Nếu `stockTakeValidateInfo.IsMan` và `stockTakeValidateInfo.Status` là "Cancel", ném ra ngoại lệ `KVMessage.cancel_stocktake` "Phiếu kiểm kho {0} đã bị hủy".
- Điều này ngăn người dùng thao tác trên phiếu kiểm kho đã bị hủy.

### 3. Xác thực sản phẩm trùng lặp
- Gọi `StockTakeValidate.ValidateDuplicateProduct(itemDetails)` để kiểm tra xem có sản phẩm nào bị trùng lặp trong danh sách hay không (xem thêm chi tiết tại [ValidateDuplicateProduct.md](Logic/StockTake/ValidateDuplicateProduct.md)).
- Nếu phát hiện sản phẩm trùng lặp, ngoại lệ sẽ được ném ra.

### 4. Xác thực số lượng thực tế
- Gọi `StockTakeValidate.ValidateActualCount(itemDetails)` để kiểm tra số lượng thực tế của các sản phẩm có hợp lệ không (xem thêm chi tiết tại [ValidateActualCount.md](Logic/StockTake/ValidateActualCount.md)).
- Đảm bảo số lượng thực tế không vượt quá giới hạn cho phép.

### 5. Xử lý đặc biệt cho phiếu sao chép
Nếu `stockTakeValidateInfo.IsCloneStockTake` là true:
- Lấy thông tin kho hiện tại thông qua `WarehouseService.GetWHArchiveByIdAsync(entity.BranchId)`.
- Xác định chi nhánh hiện tại dựa trên thông tin kho.
- Gọi `StockTakeValidate.ValidateBranchWhenClone` để kiểm tra xem phiếu kiểm kho chỉ được sao chép trong cùng một chi nhánh, không cho phép sao chép từ chi nhánh khác. Nếu phát hiện việc sao chép từ chi nhánh khác, hệ thống sẽ ném ra ngoại lệ `KvValidateBranchException` với thông báo "Chi nhánh hiện tại đã thay đổi. Vui lòng tải lại trang và thực hiện lại" (xem thêm chi tiết tại [ValidateBranchWhenClone.md](Logic/StockTake/ValidateBranchWhenClone.md)).
- Tạo mã phiếu mới thông qua `GetNewCodeWhenClone(stockTakeValidateInfo.StockTakeCode)`.
- Cập nhật mã phiếu trong đối tượng `entity` và `stockTakeValidateInfo`.

### 6. Xác thực mã phiếu kiểm kho
- Gọi `ValidateStockTakeCode(stockTakeValidateInfo.StockTakeCode, stockTakeValidateInfo.IsUpdateStockTake, stockTakeValidateInfo.StockTakeId)` để thực hiện các kiểm tra xác thực mã phiếu kiểm kho (xem thêm chi tiết tại [ValidateStockTakeCode.md](ValidateStockTakeCode.md)):
  - Kiểm tra mã phiếu kiểm kho có hợp lệ không.
  - Kiểm tra mã phiếu kiểm kho có trùng lặp không.
  - Kiểm tra độ dài mã phiếu kiểm kho.

### 7. Xác thực trạng thái khi cập nhật
- Nếu `stockTakeValidateInfo.IsUpdateStockTake` là true, gọi `StockTakeValidate.ValidateStatusWhenUpdate(stockTakeValidateInfo.Status)` để kiểm tra xem trạng thái phiếu có cho phép cập nhật không (xem thêm chi tiết tại [ValidateStatusWhenUpdate.md](Logic/StockTake/ValidateStatusWhenUpdate.md)).
- Ngăn chặn việc cập nhật phiếu kiểm kho đã ở trạng thái "Approval".

### 8. Xác thực điều kiện hoàn thành phiếu kiểm kho
- Nếu `stockTakeValidateInfo.IsAdjust` là true, gọi `ValidateStockTakeComplete(entity.AdjustmentDate, stockTakeValidateInfo.BranchId, stockTakeValidateInfo.CheckPermission)` để thực hiện các kiểm tra xác thực khi hoàn thành phiếu kiểm kho (xem thêm chi tiết tại [ValidateStockTakeComplete.md](ValidateStockTakeComplete.md)):
  - Kiểm tra quyền hạn người dùng khi hoàn thành phiếu.
  - Kiểm tra ngày đóng sổ.
  - Kiểm tra ngày điều chỉnh so với thời gian hiện tại.

## Phụ thuộc

### Dịch vụ và lớp tiện ích
- **StockTakeValidate**: Cung cấp các phương thức xác thực dữ liệu phiếu kiểm kho.
- **WarehouseService**: Truy vấn thông tin kho hàng.

### Phương thức trợ giúp
- **ValidateStockTakeCode**: Xác thực mã phiếu kiểm kho.
- **GetNewCodeWhenClone**: Tạo mã mới khi sao chép phiếu kiểm kho.
- **ValidateStockTakeComplete**: Xác thực các điều kiện khi hoàn thành phiếu kiểm kho.

## Xử lý ngoại lệ
- `KvValidateStockTakeException`: Được ném ra khi có lỗi xác thực phiếu kiểm kho.
- `KvValidateProductException`: Được ném ra khi có lỗi xác thực sản phẩm.
- `KvValidateBranchException`: Được ném ra khi có lỗi xác thực chi nhánh.
- `KvUnauthorizedException`: Được ném ra khi không có quyền hạn thực hiện thao tác.

## Các quy tắc nghiệp vụ

1. **Quy tắc về tồn tại phiếu**:
   - Không thể cập nhật phiếu kiểm kho không tồn tại.
   - Không thể thao tác trên phiếu kiểm kho đã bị hủy.

2. **Quy tắc về sản phẩm**:
   - Không được có sản phẩm trùng lặp trong một phiếu kiểm kho.
   - Số lượng thực tế không được vượt quá giới hạn cho phép.

3. **Quy tắc về sao chép phiếu**:
   - Chỉ có thể sao chép phiếu kiểm kho trong cùng một chi nhánh.
   - Mã phiếu kiểm kho mới sẽ được tạo theo quy tắc đặc biệt.

4. **Quy tắc về mã phiếu**:
   - Mã phiếu không được trùng lặp.
   - Mã phiếu không được rỗng khi cập nhật.
   - Mã phiếu không được vượt quá độ dài quy định.

5. **Quy tắc về trạng thái**:
   - Không thể cập nhật phiếu kiểm kho đã ở trạng thái "Approval".

6. **Quy tắc về hoàn thành phiếu**:
   - Người dùng phải có quyền hạn để hoàn thành phiếu kiểm kho.
   - Ngày điều chỉnh không được lớn hơn ngày hiện tại.
   - Ngày điều chỉnh phải sau ngày đóng sổ.

## Lưu ý quan trọng
1. Phương thức này được gọi từ `DoCreateOrUpdateAsync` và là bước đầu tiên trong quy trình xác thực phiếu kiểm kho.
2. Việc xác thực được thực hiện tuần tự, nếu một bước xác thực thất bại, quy trình sẽ dừng lại và ném ra ngoại lệ.
3. Một số xác thực yêu cầu truy vấn đến cơ sở dữ liệu, do đó phương thức được đánh dấu là `async`.
4. Đối tượng `stockTakeValidateInfo` chứa tất cả thông tin cần thiết cho quá trình xác thực.

## Cấu trúc dữ liệu StockTakeValidateInfo
- **Status**: Trạng thái hiện tại của phiếu kiểm kho.
- **IsAdjust**: Cờ xác định việc điều chỉnh tồn kho.
- **IsCloneStockTake**: Cờ xác định việc sao chép phiếu kiểm kho.
- **IsUpdateStockTake**: Cờ xác định việc cập nhật phiếu kiểm kho.
- **CheckPermission**: Cờ xác định việc kiểm tra quyền hạn.
- **BranchId**: ID chi nhánh.
- **StockTakeCode**: Mã phiếu kiểm kho.
- **StockTakeId**: ID phiếu kiểm kho.
- **IsMan**: Cờ xác định thao tác thủ công.

## Dữ liệu kiểm thử

### Trường hợp 1: Lỗi phiếu kiểm kho không tồn tại
```json
{
  "entity": {
    "Id": 1
  },
  "itemDetails": [],
  "stockTakeValidateInfo": {
    "StockTakeId": 1,
    "IsUpdateStockTake": false
  }
}
```

### Trường hợp 2: Lỗi phiếu kiểm kho đã bị hủy
```json
{
  "entity": {
    "Id": 1,
    "Code": "KK0001"
  },
  "itemDetails": [],
  "stockTakeValidateInfo": {
    "StockTakeId": 1,
    "IsMan": true,
    "Status": 3,  // Status.Cancel
    "StockTakeCode": "KK0001"
  }
}
```

### Trường hợp 3: Lỗi sản phẩm trùng lặp
```json
{
  "entity": {
    "Id": 0,
    "Code": "KK0001"
  },
  "itemDetails": [
    {
      "ProductId": 1,
      "ProductCode": "SP001"
    },
    {
      "ProductId": 1,
      "ProductCode": "SP001"
    }
  ],
  "stockTakeValidateInfo": {
    "StockTakeId": 0,
    "IsUpdateStockTake": false,
    "StockTakeCode": "KK0001"
  }
}
```

### Trường hợp 4: Lỗi số lượng thực tế vượt quá giới hạn
```json
{
  "entity": {
    "Id": 0,
    "Code": "KK0001"
  },
  "itemDetails": [
    {
      "ProductId": 1,
      "ProductCode": "SP001",
      "ActualCount": 20000000000000
    }
  ],
  "stockTakeValidateInfo": {
    "StockTakeId": 0,
    "IsUpdateStockTake": false,
    "StockTakeCode": "KK0001"
  }
}
```

### Trường hợp 5: Sao chép phiếu kiểm kho
```json
{
  "entity": {
    "Id": 0,
    "BranchId": 1,
    "Code": "COPY-KK0001"
  },
  "itemDetails": [
    {
      "ProductId": 1,
      "ProductCode": "SP001",
      "ActualCount": 10
    }
  ],
  "stockTakeValidateInfo": {
    "StockTakeId": 0,
    "IsUpdateStockTake": false,
    "IsCloneStockTake": true,
    "BranchId": 1,
    "StockTakeCode": "COPY-KK0001"
  }
}
```

### Trường hợp 6: Cập nhật phiếu đã hoàn thành
```json
{
  "entity": {
    "Id": 1,
    "Code": "KK0001"
  },
  "itemDetails": [
    {
      "ProductId": 1,
      "ProductCode": "SP001",
      "ActualCount": 10
    }
  ],
  "stockTakeValidateInfo": {
    "StockTakeId": 1,
    "IsUpdateStockTake": true,
    "Status": 2,  // Status.Approval
    "StockTakeCode": "KK0001"
  }
}
```

### Trường hợp 7: Hoàn thành phiếu kiểm kho
```json
{
  "entity": {
    "Id": 0,
    "Code": "KK0001",
    "AdjustmentDate": "2023-01-01T00:00:00"
  },
  "itemDetails": [
    {
      "ProductId": 1,
      "ProductCode": "SP001",
      "ActualCount": 10
    }
  ],
  "stockTakeValidateInfo": {
    "StockTakeId": 0,
    "IsUpdateStockTake": false,
    "IsAdjust": true,
    "BranchId": 1,
    "CheckPermission": true,
    "StockTakeCode": "KK0001"
  }
}
``` 