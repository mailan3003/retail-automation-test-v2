# Xác thực dữ liệu trong DoCreateOrUpdateAsync

## Mục đích
Phần xác thực dữ liệu trong phương thức `DoCreateOrUpdateAsync` có nhiệm vụ đảm bảo tính hợp lệ của tất cả dữ liệu đầu vào trước khi tiến hành các bước xử lý tiếp theo. Quá trình này giúp ngăn chặn các lỗi dữ liệu và đảm bảo tính toàn vẹn của hệ thống.

## Quy trình chính

### 1. Chuẩn bị thông tin xác thực
- Tạo đối tượng `stockTakeValidateInfo` chứa các thông tin cần thiết cho quá trình xác thực:
  - `Status`: Trạng thái hiện tại của phiếu kiểm kho (nếu đang cập nhật)
  - `IsAdjust`: Cờ xác định việc điều chỉnh tồn kho
  - `IsCloneStockTake`: Cờ xác định việc sao chép phiếu kiểm kho
  - `IsUpdateStockTake`: Cờ xác định việc cập nhật phiếu kiểm kho
  - `CheckPermission`: Cờ xác định việc kiểm tra quyền hạn
  - `BranchId`: ID chi nhánh
  - `StockTakeCode`: Mã phiếu kiểm kho
  - `StockTakeId`: ID phiếu kiểm kho
  - `IsMan`: Cờ xác định thao tác thủ công

### 2. Gọi phương thức xác thực
- Gọi phương thức `IsValidateStockTake` để thực hiện các kiểm tra sau (xem thêm chi tiết tại [IsValidateStockTake.md](../IsValidateStockTake.md)):

#### 2.1. Kiểm tra tồn tại của phiếu kiểm kho
- Nếu `StockTakeId > 0` và `!IsUpdateStockTake`, ném ra ngoại lệ "phiếu kiểm kho không tồn tại".

#### 2.2. Kiểm tra trạng thái hủy
- Nếu `IsMan` và `Status` là "Cancel", ném ra ngoại lệ "phiếu kiểm kho đã bị hủy".

#### 2.3. Kiểm tra trùng lặp sản phẩm
- Gọi `StockTakeValidate.ValidateDuplicateProduct` để kiểm tra sản phẩm trùng lặp trong danh sách sản phẩm.

#### 2.4. Kiểm tra số lượng thực tế
- Gọi `StockTakeValidate.ValidateActualCount` để đảm bảo số lượng thực tế của sản phẩm không vượt quá giới hạn cho phép.

#### 2.5. Xử lý sao chép phiếu kiểm kho
- Nếu `IsCloneStockTake`, kiểm tra quyền hạn chi nhánh và tạo mã phiếu mới.

#### 2.6. Xác thực mã phiếu kiểm kho
- Gọi `ValidateStockTakeCode` để kiểm tra tính hợp lệ của mã phiếu kiểm kho:
  - Kiểm tra mã rỗng
  - Kiểm tra độ dài mã
  - Kiểm tra trùng lặp mã

#### 2.7. Kiểm tra trạng thái khi cập nhật
- Nếu `IsUpdateStockTake`, gọi `StockTakeValidate.ValidateStatusWhenUpdate` để đảm bảo không cập nhật phiếu đã hoàn thành.

#### 2.8. Xác thực điều chỉnh phiếu kiểm kho
- Nếu `IsAdjust`, gọi `ValidateStockTakeComplete` để kiểm tra:
  - Quyền hạn hoàn thành phiếu kiểm kho
  - Ngày đóng sổ
  - Ngày điều chỉnh so với thời gian hiện tại

## Phụ thuộc

### Dịch vụ và lớp tiện ích
- **StockTakeValidate**: Cung cấp các phương thức xác thực cho phiếu kiểm kho.
- **BranchService**: Xác thực quyền hạn chi nhánh và ngày đóng sổ.
- **WarehouseService**: Lấy thông tin kho hàng.

### Đối tượng
- **AuthService.Context**: Cung cấp thông tin ngữ cảnh xác thực hiện tại.
- **StockTakeValidateInfo**: Đối tượng chứa các thông tin cần thiết cho quá trình xác thực.

## Xử lý ngoại lệ
- `KvValidateStockTakeException`: Được ném ra khi có lỗi xác thực phiếu kiểm kho.
- `KvValidateBranchException`: Được ném ra khi có lỗi xác thực chi nhánh.
- `KvValidateProductException`: Được ném ra khi có lỗi xác thực sản phẩm.
- `KvUnauthorizedException`: Được ném ra khi không có quyền hạn thực hiện thao tác.

## Các quy tắc nghiệp vụ

1. **Quy tắc về mã phiếu kiểm kho**:
   - Mã phiếu không được trùng lặp trong hệ thống
   - Mã phiếu không được rỗng khi cập nhật
   - Mã phiếu không được vượt quá 40 ký tự

2. **Quy tắc về sản phẩm**:
   - Không được có sản phẩm trùng lặp trong một phiếu kiểm kho
   - Số lượng thực tế không được vượt quá 10,000,000,000,000

3. **Quy tắc về ngày tháng**:
   - Ngày điều chỉnh không được lớn hơn ngày hiện tại
   - Ngày điều chỉnh phải sau ngày đóng sổ

4. **Quy tắc về trạng thái**:
   - Không thể cập nhật phiếu đã ở trạng thái "Approval"
   - Không thể thao tác với phiếu đã ở trạng thái "Cancel"

5. **Quy tắc về quyền hạn**:
   - Người dùng phải có quyền "StockTake.Finish" để hoàn thành phiếu kiểm kho
   - Chỉ có thể sao chép phiếu kiểm kho trong cùng một chi nhánh

## Lưu ý quan trọng
1. Việc xác thực dữ liệu là bước quan trọng đầu tiên trước khi tiến hành xử lý dữ liệu.
2. Mỗi quy tắc nghiệp vụ đều có thông báo lỗi tương ứng khi vi phạm.
3. Một số xác thực phụ thuộc vào ngữ cảnh như trạng thái phiếu, loại thao tác (tạo mới/cập nhật).

## Dữ liệu kiểm thử

### Trường hợp 1: Lỗi trùng lặp sản phẩm
```json
{
  "entity": {
    "Id": 0,
    "BranchId": 1,
    "Code": "KK0001"
  },
  "itemDetails": [
    {
      "ProductId": 1,
      "ProductCode": "SP001",
      "ActualCount": 10
    },
    {
      "ProductId": 1,
      "ProductCode": "SP001",
      "ActualCount": 5
    }
  ],
  "isAdjust": true
}
```

### Trường hợp 2: Lỗi số lượng thực tế vượt quá giới hạn
```json
{
  "entity": {
    "Id": 0,
    "BranchId": 1,
    "Code": "KK0001"
  },
  "itemDetails": [
    {
      "ProductId": 1,
      "ProductCode": "SP001",
      "ActualCount": 20000000000000
    }
  ],
  "isAdjust": true
}
```

### Trường hợp 3: Lỗi mã phiếu trùng lặp
```json
{
  "entity": {
    "Id": 0,
    "BranchId": 1,
    "Code": "KK0001"  // Giả sử mã này đã tồn tại trong hệ thống
  },
  "itemDetails": [
    {
      "ProductId": 1,
      "ProductCode": "SP001",
      "ActualCount": 10
    }
  ],
  "isAdjust": true
}
```

### Trường hợp 4: Lỗi ngày điều chỉnh không hợp lệ
```json
{
  "entity": {
    "Id": 0,
    "BranchId": 1,
    "Code": "KK0001",
    "AdjustmentDate": "2025-01-01T00:00:00"  // Ngày trong tương lai
  },
  "itemDetails": [
    {
      "ProductId": 1,
      "ProductCode": "SP001",
      "ActualCount": 10
    }
  ],
  "isAdjust": true
}
```

### Trường hợp 5: Lỗi cập nhật phiếu đã hoàn thành
```json
{
  "entity": {
    "Id": 1,  // Giả sử phiếu này đã ở trạng thái "Approval"
    "BranchId": 1,
    "Code": "KK0001"
  },
  "itemDetails": [
    {
      "ProductId": 1,
      "ProductCode": "SP001",
      "ActualCount": 10
    }
  ],
  "isAdjust": true
}
``` 