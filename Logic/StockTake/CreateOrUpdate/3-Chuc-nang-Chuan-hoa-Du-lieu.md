# Chuẩn hóa và xác thực dữ liệu từ server trong DoCreateOrUpdateAsync

## Mục đích
Phần chuẩn hóa và xác thực dữ liệu từ server trong phương thức `DoCreateOrUpdateAsync` có nhiệm vụ làm sạch, hoàn thiện và xác thực dữ liệu dựa trên thông tin có sẵn trong cơ sở dữ liệu. Quá trình này đảm bảo dữ liệu được xử lý chính xác trước khi lưu trữ.

## Quy trình chính

### 1. Lấy danh sách sản phẩm từ cơ sở dữ liệu
- Trích xuất danh sách ID sản phẩm từ `itemDetails`.
- Gọi phương thức `GetListProductById` để lấy thông tin chi tiết của các sản phẩm từ cơ sở dữ liệu (xem thêm chi tiết tại [GetListProductById.md](../GetListProductById.md)).

### 2. Xác thực sản phẩm
- Gọi `StockTakeValidate.ValidateProductNotExistInDb` để kiểm tra tất cả sản phẩm trong `itemDetails` tồn tại trong cơ sở dữ liệu (xem thêm chi tiết tại [ValidateProductNotExistInDb.md](Logic/StockTake/ValidateProductNotExistInDb.md)).

### 3. Cập nhật thông tin sản phẩm từ cơ sở dữ liệu
- Gọi `StockTakeNormalize.UpdateProductInfoFromDb` để cập nhật các thông tin của sản phẩm như (xem thêm chi tiết tại [UpdateProductInfoFromDb.md](Logic/StockTake/UpdateProductInfoFromDb.md)):
  - Giá trị chuyển đổi đơn vị (`ConversionValue`)
  - ID đơn vị chính (`MasterUnitId`)
  - Cờ quản lý lô hàng và hạn sử dụng (`IsBatchExpireControl`)
  - Cờ quản lý số serial (`IsLotSerialControl`)
  - Mã sản phẩm (`ProductCode`) nếu chưa có

### 4. Xử lý sản phẩm có quản lý lô hàng và hạn sử dụng
- Kiểm tra xem có sản phẩm nào có quản lý lô hàng và hạn sử dụng không.
- Nếu có:
  - Gọi `StockTakeValidate.ValidateProductBatchExpireActualList` để xác thực danh sách lô và hạn sử dụng.
  - Gọi `NormalizeProductBatchExpireSystem` để chuẩn hóa thông tin lô hàng trong hệ thống.

### 5. Xử lý sản phẩm có quản lý số serial
- Kiểm tra xem có sản phẩm nào có quản lý số serial không.
- Nếu có:
  - Gọi `StockTakeNormalize.NormalizeImeiData` để chuẩn hóa dữ liệu IMEI.
  - Gọi `ValidateProductSerialsList` để xác thực danh sách số serial.
  - Gọi `NormalizeSystemSerialNumbers` để chuẩn hóa các số serial của hệ thống.

### 6. Xử lý thông tin đơn vị sản phẩm
- Lấy danh sách ID đơn vị chính của các sản phẩm.
- Kết hợp với danh sách ID sản phẩm ban đầu để tạo danh sách các ID sản phẩm cần xử lý.

### 7. Lấy thông tin tồn kho từ cơ sở dữ liệu
- Nếu số lượng ID sản phẩm vượt quá giới hạn (`SqlExceptionHelper.MaxIdParamsIQueryableExtensions`):
  - Chia nhỏ danh sách ID thành các nhóm.
  - Xử lý từng nhóm riêng biệt.
- Nếu đang sử dụng tính năng kho hàng hoặc đang xóa kho hàng:
  - Lấy thông tin tồn kho từ chi nhánh chính và chi nhánh hiện tại.
- Nếu không:
  - Chỉ lấy thông tin tồn kho từ chi nhánh hiện tại.

### 8. Chuẩn hóa thông tin tồn kho hệ thống
- Gọi `StockTakeNormalize.NormalizeProductSystemFromDb` để cập nhật các thông tin tồn kho hệ thống cho từng sản phẩm trong `itemDetails`.

## Phụ thuộc

### Dịch vụ và lớp tiện ích
- **ProductService**: Truy xuất thông tin sản phẩm từ cơ sở dữ liệu.
- **ProductBranchService**: Truy xuất thông tin tồn kho sản phẩm.
- **StockTakeValidate**: Cung cấp các phương thức xác thực cho phiếu kiểm kho.
- **StockTakeNormalize**: Cung cấp các phương thức chuẩn hóa dữ liệu.

### Đối tượng
- **SqlExceptionHelper**: Quản lý giới hạn tham số trong các truy vấn SQL.
- **ProductStockStakeInfo**: Chứa thông tin sản phẩm cho phiếu kiểm kho.
- **ProductBranchStockStakeInfo**: Chứa thông tin tồn kho sản phẩm.

## Xử lý ngoại lệ
- `KvValidateProductException`: Được ném ra khi có lỗi xác thực sản phẩm.
- `KvValidateStockTakeException`: Được ném ra khi có lỗi xác thực phiếu kiểm kho.
- `KvValidatePurchaseOrderException`: Được ném ra khi có lỗi liên quan đến số serial hoặc lô hàng không hợp lệ.

## Các quy tắc nghiệp vụ

1. **Quy tắc về tồn tại sản phẩm**:
   - Tất cả sản phẩm trong phiếu kiểm kho phải tồn tại trong cơ sở dữ liệu.

2. **Quy tắc về số serial**:
   - Số serial phải thuộc về sản phẩm có quản lý số serial (`IsLotSerialControl = true`).
   - Số serial không được trùng lặp trên nhiều chi nhánh.
   - Số lượng số serial phải bằng số lượng thực tế của sản phẩm.

3. **Quy tắc về lô hàng và hạn sử dụng**:
   - Thông tin lô hàng chỉ áp dụng cho sản phẩm có quản lý lô hàng (`IsBatchExpireControl = true`).
   - Tổng số lượng các lô phải bằng số lượng thực tế của sản phẩm.
   - Không được có lô hàng trùng lặp cho một sản phẩm.

4. **Quy tắc về xử lý danh sách ID lớn**:
   - Khi số lượng ID sản phẩm vượt quá giới hạn (`SqlExceptionHelper.MaxIdParamsIQueryableExtensions`), danh sách sẽ được chia nhỏ để xử lý.

## Lưu ý quan trọng
1. Quá trình chuẩn hóa đảm bảo dữ liệu từ client được bổ sung đầy đủ thông tin từ cơ sở dữ liệu.
2. Việc xử lý tồn kho phụ thuộc vào việc hệ thống có đang sử dụng tính năng kho hàng hay không.
3. Các sản phẩm có quản lý lô hàng hoặc số serial cần được xử lý đặc biệt.
4. Cần xử lý riêng biệt trường hợp danh sách ID sản phẩm quá lớn để tránh lỗi SQL.

## Dữ liệu kiểm thử

### Trường hợp 1: Sản phẩm với số serial
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
      "ActualCount": 2,
      "SerialNumbers": "SN001,SN002"
    }
  ],
  "isAdjust": true
}
```

### Trường hợp 2: Sản phẩm với lô hàng và hạn sử dụng
```json
{
  "entity": {
    "Id": 0,
    "BranchId": 1,
    "Code": "KK0001"
  },
  "itemDetails": [
    {
      "ProductId": 2,
      "ProductCode": "SP002",
      "ActualCount": 10,
      "ProductBatchExpireActualList": [
        {
          "BatchName": "Lô 1",
          "ExpireDate": "2023-12-31T00:00:00",
          "ActualCount": 5
        },
        {
          "BatchName": "Lô 2",
          "ExpireDate": "2024-06-30T00:00:00",
          "ActualCount": 5
        }
      ]
    }
  ],
  "isAdjust": true
}
```

### Trường hợp 3: Danh sách sản phẩm lớn (mô phỏng)
```json
{
  "entity": {
    "Id": 0,
    "BranchId": 1,
    "Code": "KK0001"
  },
  "itemDetails": [
    {"ProductId": 1, "ActualCount": 10},
    {"ProductId": 2, "ActualCount": 20},
    {"ProductId": 3, "ActualCount": 30},
    // ... (nhiều sản phẩm khác, số lượng vượt quá SqlExceptionHelper.MaxIdParamsIQueryableExtensions)
  ],
  "isAdjust": true
}
```

### Trường hợp 4: Lỗi số serial không khớp với số lượng thực tế
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
      "ActualCount": 3,  // Không khớp với số lượng serial (2)
      "SerialNumbers": "SN001,SN002"
    }
  ],
  "isAdjust": true
}
```

### Trường hợp 5: Lỗi lô hàng không khớp với số lượng thực tế
```json
{
  "entity": {
    "Id": 0,
    "BranchId": 1,
    "Code": "KK0001"
  },
  "itemDetails": [
    {
      "ProductId": 2,
      "ProductCode": "SP002",
      "ActualCount": 15,  // Không khớp với tổng số lượng các lô (10)
      "ProductBatchExpireActualList": [
        {
          "BatchName": "Lô 1",
          "ExpireDate": "2023-12-31T00:00:00",
          "ActualCount": 5
        },
        {
          "BatchName": "Lô 2",
          "ExpireDate": "2024-06-30T00:00:00",
          "ActualCount": 5
        }
      ]
    }
  ],
  "isAdjust": true
}
``` 