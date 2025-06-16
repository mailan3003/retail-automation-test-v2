# Khởi tạo và thiết lập trong DoCreateOrUpdateAsync

## Mục đích
Phần khởi tạo và thiết lập trong phương thức `DoCreateOrUpdateAsync` có nhiệm vụ chuẩn bị các thông số cần thiết và xác định các điều kiện ban đầu trước khi tiến hành các bước xử lý chính của phiếu kiểm kho.

## Quy trình chính

### 1. Xác định Branch ID
- Nếu `entity.BranchId` là 0, sử dụng Branch ID từ ngữ cảnh xác thực (`AuthService.Context.BranchId`).
- Nếu không, sử dụng `entity.BranchId` đã được cung cấp.

### 2. Kiểm tra trạng thái kho hàng
- Kiểm tra xem tính năng kho hàng có được kích hoạt không thông qua `WarehouseService.IsActiveWarehouseToggle()`.
- Nếu không đang trong quá trình xóa kho hàng (`isDeleteWarehouse = false`), hệ thống sẽ xác thực trạng thái của kho hàng thông qua `WarehouseService.ValidateStatusOfWarehouse(branchId)`.

### 3. Xác định Master Branch ID
- Nếu đang sử dụng tính năng kho hàng hoặc đang xóa kho hàng, hệ thống sẽ tìm Master Branch ID từ cơ sở dữ liệu.
- Nếu không tìm thấy Master Branch ID, sử dụng Branch ID hiện tại từ ngữ cảnh xác thực.

### 4. Lấy thông tin cơ bản của phiếu kiểm kho
- Lấy mã phiếu kiểm kho (`stockTakeCode`) và ID phiếu kiểm kho (`stockTakeId`) từ đối tượng entity.
- Kiểm tra xem mã phiếu có phải là mã sao chép không qua `StockTakeValidate.IsCloneStockTake(stockTakeCode)`.

### 5. Kiểm tra phiếu kiểm kho mới hay cập nhật
- Gọi `GetByIdAsync(stockTakeId)` để kiểm tra xem phiếu kiểm kho đã tồn tại trong cơ sở dữ liệu chưa.
- Xác định cờ `isUpdateStockTake` dựa trên kết quả trả về.
- Xác định cờ `isChangeStatusFromDraft` nếu đang cập nhật phiếu từ trạng thái "Generator" sang "Approval".

### 6. Kiểm tra thay đổi ngày điều chỉnh
- Nếu đang cập nhật phiếu kiểm kho và có sự thay đổi về ngày điều chỉnh, lưu lại ngày điều chỉnh cũ để sử dụng trong quá trình theo dõi sự kiện.

## Phụ thuộc

### Dịch vụ
- **WarehouseService**: Kiểm tra trạng thái kho hàng và tính năng kho hàng.
- **BranchService**: Truy vấn thông tin chi nhánh.
- **StockTakeValidate**: Xác thực mã phiếu kiểm kho có phải là mã sao chép không.

### Đối tượng
- **AuthService.Context**: Cung cấp thông tin ngữ cảnh xác thực hiện tại.
- **DateTimeHelper**: Hỗ trợ so sánh ngày tháng.

## Xử lý ngoại lệ
- Nếu việc xác thực trạng thái kho hàng thất bại, phương thức `ValidateStatusOfWarehouse` sẽ ném ra ngoại lệ.
- Các lỗi liên quan đến truy vấn cơ sở dữ liệu sẽ được truyền lên các lớp xử lý cao hơn.

## Lưu ý quan trọng
1. Việc xác định Master Branch ID đặc biệt quan trọng khi hệ thống đang sử dụng tính năng kho hàng.
2. Cờ `isChangeStatusFromDraft` ảnh hưởng đến cách hệ thống theo dõi sự kiện sau này.
3. Ngày điều chỉnh cũ (`oldAdjustmentDate`) được sử dụng cho việc theo dõi sự kiện khi cập nhật phiếu kiểm kho.

## Dữ liệu kiểm thử

### Trường hợp 1: Tạo mới phiếu kiểm kho
```json
{
  "entity": {
    "Id": 0,
    "BranchId": 0,
    "Code": "KK0001",
    "AdjustmentDate": "2023-01-01T00:00:00"
  },
  "itemDetails": [],
  "isAdjust": true,
  "checkPermission": true,
  "isMan": false,
  "isDeleteWarehouse": false
}
```

### Trường hợp 2: Cập nhật phiếu kiểm kho
```json
{
  "entity": {
    "Id": 1,
    "BranchId": 2,
    "Code": "KK0001",
    "AdjustmentDate": "2023-01-02T00:00:00"
  },
  "itemDetails": [],
  "isAdjust": true,
  "checkPermission": true,
  "isMan": false,
  "isDeleteWarehouse": false
}
```

### Trường hợp 3: Xóa kho hàng
```json
{
  "entity": {
    "Id": 0,
    "BranchId": 3,
    "Code": "KK0002",
    "AdjustmentDate": "2023-01-01T00:00:00"
  },
  "itemDetails": [],
  "isAdjust": true,
  "checkPermission": true,
  "isMan": false,
  "isDeleteWarehouse": true
}
```

### Trường hợp 4: Sao chép phiếu kiểm kho
```json
{
  "entity": {
    "Id": 0,
    "BranchId": 0,
    "Code": "COPY-KK0001",
    "AdjustmentDate": "2023-01-01T00:00:00"
  },
  "itemDetails": [],
  "isAdjust": false,
  "checkPermission": true,
  "isMan": false,
  "isDeleteWarehouse": false
}
``` 