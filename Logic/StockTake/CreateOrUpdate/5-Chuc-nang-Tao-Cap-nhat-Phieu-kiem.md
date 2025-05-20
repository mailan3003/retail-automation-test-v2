# Tạo mới hoặc cập nhật phiếu kiểm kho trong DoCreateOrUpdateAsync

## Mục đích
Phần tạo mới hoặc cập nhật phiếu kiểm kho trong phương thức `DoCreateOrUpdateAsync` có nhiệm vụ lưu trữ thông tin phiếu kiểm kho vào cơ sở dữ liệu. Quá trình này xử lý các trường hợp tạo mới hoặc cập nhật phiếu kiểm kho dựa trên kết quả xác định từ các bước trước.

## Quy trình chính

### 1. Xác định loại thao tác: tạo mới hoặc cập nhật
- Sử dụng biến `isUpdateStockTake` đã được xác định ở các bước trước để quyết định thao tác cần thực hiện.

### 2. Trường hợp cập nhật phiếu kiểm kho
Nếu `isUpdateStockTake = true`, thực hiện các bước sau:

#### 2.1. Chuẩn bị thông tin cập nhật
- Gọi phương thức `UpdateStockTake` với các tham số:
  - `entity`: Dữ liệu phiếu kiểm kho từ client.
  - `stockTake`: Đối tượng phiếu kiểm kho hiện có từ cơ sở dữ liệu.
  - `itemDetails`: Danh sách chi tiết sản phẩm đã được chuẩn hóa.
  - `isAdjust`: Cờ xác định việc điều chỉnh tồn kho.
  - `isExistBatchExpireControl || isExistLotSerialControl`: Cờ xác định có sản phẩm quản lý lô hàng hoặc số serial không.

#### 2.2. Chuẩn hóa thông tin phiếu kiểm kho
- Gọi `StockTakeNormalize.NormalizeStocTake` để chuẩn hóa các thông tin cơ bản của phiếu kiểm kho.

#### 2.3. Cập nhật phiếu kiểm kho vào cơ sở dữ liệu
- Gọi `UpdateAsyncWithEvent` để lưu phiếu kiểm kho đã cập nhật vào cơ sở dữ liệu.

#### 2.4. Xử lý chi tiết phiếu kiểm kho
- Thực hiện trong một giao dịch cơ sở dữ liệu (`transaction`):
  - Thêm mới các chi tiết phiếu kiểm kho bằng `AddNewStockTakeDetail`.
  - Xóa các chi tiết phiếu kiểm kho cũ bằng `RemoveStockTakeDetailOld`.

### 3. Trường hợp tạo mới phiếu kiểm kho
Nếu `isUpdateStockTake = false`, thực hiện các bước sau:

#### 3.1. Tạo đối tượng phiếu kiểm kho mới
- Khởi tạo đối tượng `StockTake` mới với các thông tin cơ bản:
  - `CreatedBy`: ID người dùng hiện tại.
  - `RetailerId`: ID nhà bán lẻ hiện tại.

#### 3.2. Chuẩn bị thông tin thêm mới
- Gọi phương thức `AddNewStockTake` với các tham số:
  - `entity`: Dữ liệu phiếu kiểm kho từ client.
  - `stockTake`: Đối tượng phiếu kiểm kho mới tạo.
  - `itemDetails`: Danh sách chi tiết sản phẩm đã được chuẩn hóa.
  - `isAdjust`: Cờ xác định việc điều chỉnh tồn kho.
  - `isExistBatchExpireControl || isExistLotSerialControl`: Cờ xác định có sản phẩm quản lý lô hàng hoặc số serial không.
  - `isCheckPermission`: Cờ xác định việc kiểm tra quyền hạn.

#### 3.3. Chuẩn hóa thông tin phiếu kiểm kho
- Gọi `StockTakeNormalize.NormalizeStocTake` để chuẩn hóa các thông tin cơ bản của phiếu kiểm kho.

#### 3.4. Thêm phiếu kiểm kho vào cơ sở dữ liệu
- Gọi `AddAsyncWithEvent` hoặc `AddNotGuardAsyncWithEvent` (tùy thuộc vào việc kiểm tra quyền hạn) để lưu phiếu kiểm kho mới vào cơ sở dữ liệu.

#### 3.5. Thêm chi tiết phiếu kiểm kho
- Gọi `AddNewStockTakeDetail` để thêm các chi tiết phiếu kiểm kho vào cơ sở dữ liệu.

### 4. Tải danh sách chi tiết phiếu kiểm kho
- Sau khi tạo mới hoặc cập nhật phiếu kiểm kho, gọi `StockTakeDetailService.GetAll()` để tải danh sách chi tiết phiếu kiểm kho mới nhất.

### 5. Xử lý liên quan đến dược quốc gia (nếu có)
- Nếu phiếu kiểm kho có trạng thái là "Approval", gọi `NationalPharmacyProcess` để xử lý thông tin liên quan đến dược quốc gia.

## Phương thức UpdateStockTake

### Mục đích
Cập nhật thông tin phiếu kiểm kho hiện có và chi tiết phiếu kiểm kho.

### Quy trình
1. Ghi log bắt đầu cập nhật.
2. Lấy ID nhỏ nhất và lớn nhất của chi tiết phiếu kiểm kho cũ.
3. Chuẩn hóa thông tin phiếu kiểm kho.
4. Cập nhật phiếu kiểm kho vào cơ sở dữ liệu.
5. Trong một giao dịch cơ sở dữ liệu:
   - Thêm mới các chi tiết phiếu kiểm kho.
   - Xóa các chi tiết phiếu kiểm kho cũ.
6. Ghi log hoàn thành cập nhật.

## Phương thức AddNewStockTake

### Mục đích
Tạo mới phiếu kiểm kho và chi tiết phiếu kiểm kho.

### Quy trình
1. Chuẩn hóa thông tin phiếu kiểm kho.
2. Đặt `StockTakeDetails = null` để tránh lưu trữ dữ liệu trùng lặp.
3. Thêm phiếu kiểm kho vào cơ sở dữ liệu (có hoặc không kiểm tra quyền hạn).
4. Thêm các chi tiết phiếu kiểm kho vào cơ sở dữ liệu.

## Phương thức AddNewStockTakeDetail

### Mục đích
Thêm chi tiết phiếu kiểm kho vào cơ sở dữ liệu.

### Quy trình
1. Cập nhật thông tin cơ bản cho các chi tiết phiếu kiểm kho:
   - `StockTakeId`: ID phiếu kiểm kho.
   - `RetailerId`: ID nhà bán lẻ.
   - `ModifiedDate`: Thời gian hiện tại.
2. Ghi log bắt đầu thêm mới.
3. Sử dụng `Db.BulkInsertAsync` để thêm đồng thời tất cả các chi tiết phiếu kiểm kho.
4. Ghi log hoàn thành thêm mới.

## Phương thức RemoveStockTakeDetailOld

### Mục đích
Xóa các chi tiết phiếu kiểm kho cũ khỏi cơ sở dữ liệu.

### Quy trình
1. Thực thi lệnh SQL trực tiếp để xóa các chi tiết phiếu kiểm kho dựa trên ID phiếu kiểm kho và ID chi tiết phiếu kiểm kho.

## Phụ thuộc

### Dịch vụ và lớp tiện ích
- **StockTakeNormalize**: Chuẩn hóa thông tin phiếu kiểm kho.
- **StockTakeDetailService**: Quản lý chi tiết phiếu kiểm kho.
- **Log**: Ghi log quá trình xử lý.

### Đối tượng
- **StockTake**: Đại diện cho một phiếu kiểm kho.
- **StockTakeDetail**: Đại diện cho một chi tiết phiếu kiểm kho.
- **TrackingHelper**: Hỗ trợ theo dõi sự kiện.

## Xử lý ngoại lệ
- Nếu xảy ra lỗi trong quá trình thêm mới hoặc cập nhật, giao dịch cơ sở dữ liệu sẽ được roll back và lỗi sẽ được log lại.
- Lỗi sẽ được truyền lên các lớp xử lý cao hơn.

## Các quy tắc nghiệp vụ

1. **Quy tắc về cập nhật phiếu kiểm kho**:
   - Khi cập nhật phiếu kiểm kho, các chi tiết cũ sẽ bị xóa và thay thế bằng chi tiết mới.
   - Việc xác định chi tiết cũ dựa trên ID lớn nhất và nhỏ nhất của chi tiết phiếu kiểm kho cũ.

2. **Quy tắc về trạng thái phiếu kiểm kho**:
   - Nếu `isAdjust = true`, trạng thái phiếu kiểm kho sẽ được đặt thành "Approval".
   - Nếu không, trạng thái phiếu kiểm kho sẽ được đặt thành "Generator".

3. **Quy tắc về ngày điều chỉnh**:
   - Nếu phiếu kiểm kho có sản phẩm quản lý lô hàng hoặc số serial và ngày điều chỉnh nhỏ hơn ngày tạo, ngày điều chỉnh sẽ được cập nhật thành ngày tạo.

4. **Quy tắc về quyền hạn**:
   - Nếu `checkPermission = true`, hệ thống sẽ kiểm tra quyền hạn người dùng trước khi thêm mới phiếu kiểm kho.
   - Nếu `checkPermission = false`, hệ thống sẽ bỏ qua việc kiểm tra quyền hạn.

## Lưu ý quan trọng
1. Việc thêm mới chi tiết phiếu kiểm kho được thực hiện bằng cách sử dụng `BulkInsertAsync` để tối ưu hiệu suất.
2. Khi cập nhật phiếu kiểm kho, cần đảm bảo các chi tiết cũ được xóa hoàn toàn để tránh dữ liệu trùng lặp.
3. Quá trình tạo mới hoặc cập nhật phiếu kiểm kho được log lại chi tiết để hỗ trợ việc debug và theo dõi.
4. Việc xử lý thông tin liên quan đến dược quốc gia chỉ được thực hiện khi phiếu kiểm kho có trạng thái là "Approval".

## Dữ liệu kiểm thử

### Trường hợp 1: Tạo mới phiếu kiểm kho
```json
{
  "entity": {
    "Id": 0,
    "BranchId": 1,
    "Code": "KK0001",
    "Description": "Phiếu kiểm kho mới",
    "AdjustmentDate": "2023-01-01T00:00:00"
  },
  "itemDetails": [
    {
      "ProductId": 1,
      "ProductCode": "SP001",
      "ActualCount": 10
    }
  ],
  "isAdjust": true,
  "checkPermission": true
}
```

### Trường hợp 2: Cập nhật phiếu kiểm kho
```json
{
  "entity": {
    "Id": 1,  // Giả sử phiếu này đã tồn tại
    "BranchId": 1,
    "Code": "KK0001",
    "Description": "Phiếu kiểm kho đã cập nhật",
    "AdjustmentDate": "2023-01-02T00:00:00"
  },
  "itemDetails": [
    {
      "ProductId": 1,
      "ProductCode": "SP001",
      "ActualCount": 15
    },
    {
      "ProductId": 2,
      "ProductCode": "SP002",
      "ActualCount": 20
    }
  ],
  "isAdjust": true,
  "checkPermission": true
}
```

### Trường hợp 3: Tạo mới phiếu kiểm kho không điều chỉnh tồn kho
```json
{
  "entity": {
    "Id": 0,
    "BranchId": 1,
    "Code": "KK0002",
    "Description": "Phiếu kiểm kho tạm",
    "AdjustmentDate": null
  },
  "itemDetails": [
    {
      "ProductId": 1,
      "ProductCode": "SP001",
      "ActualCount": 10
    }
  ],
  "isAdjust": false,
  "checkPermission": true
}
```

### Trường hợp 4: Tạo mới phiếu kiểm kho với sản phẩm quản lý lô hàng
```json
{
  "entity": {
    "Id": 0,
    "BranchId": 1,
    "Code": "KK0003",
    "Description": "Phiếu kiểm kho với lô hàng",
    "AdjustmentDate": "2023-01-01T00:00:00"
  },
  "itemDetails": [
    {
      "ProductId": 1,
      "ProductCode": "SP001",
      "IsBatchExpireControl": true,
      "ActualCount": 10,
      "ProductBatchExpireActualList": [
        {
          "BatchName": "Lô 1",
          "ExpireDate": "2023-12-31T00:00:00",
          "ActualCount": 10
        }
      ]
    }
  ],
  "isAdjust": true,
  "checkPermission": true
}
```

### Trường hợp 5: Tạo mới phiếu kiểm kho không kiểm tra quyền hạn
```json
{
  "entity": {
    "Id": 0,
    "BranchId": 1,
    "Code": "KK0004",
    "Description": "Phiếu kiểm kho không kiểm tra quyền hạn",
    "AdjustmentDate": "2023-01-01T00:00:00"
  },
  "itemDetails": [
    {
      "ProductId": 1,
      "ProductCode": "SP001",
      "ActualCount": 10
    }
  ],
  "isAdjust": true,
  "checkPermission": false
}
``` 