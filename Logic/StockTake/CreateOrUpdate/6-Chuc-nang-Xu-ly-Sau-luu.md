# Xử lý sự kiện sau lưu trong DoCreateOrUpdateAsync

## Mục đích
Phần xử lý sự kiện sau lưu trong phương thức `DoCreateOrUpdateAsync` có nhiệm vụ theo dõi và xử lý các sự kiện liên quan đến phiếu kiểm kho sau khi đã lưu trữ thông tin vào cơ sở dữ liệu. Quá trình này đảm bảo việc cập nhật tồn kho sản phẩm, ghi nhận lịch sử thay đổi và thực hiện các tác vụ hậu xử lý khác.

## Quy trình chính

### 1. Tải thông tin chi tiết phiếu kiểm kho
- Sau khi tạo mới hoặc cập nhật phiếu kiểm kho, gọi phương thức `StockTakeDetailService.GetAll()` để tải danh sách chi tiết phiếu kiểm kho mới nhất.
- Gán danh sách chi tiết vào đối tượng `stockTake.StockTakeDetails` để sử dụng trong các bước tiếp theo.

### 2. Xử lý dược quốc gia (nếu có)
- Nếu phiếu kiểm kho có trạng thái là "Approval" (đã hoàn thành), gọi phương thức `NationalPharmacyProcess` để xử lý thông tin liên quan đến dược quốc gia.
- Phương thức này chỉ được thực thi nếu hệ thống đang sử dụng tính năng quản lý dược quốc gia.

### 3. Sử dụng TrackingHelper để theo dõi sự kiện
- Khởi tạo đối tượng `TrackingHelper` với ngữ cảnh xác thực hiện tại.
- Gọi phương thức `Enqueue` để đưa thông tin phiếu kiểm kho vào hàng đợi xử lý:
  - `stockTake`: Đối tượng phiếu kiểm kho đã được lưu trữ.
  - `ImpactDirection.Add`: Hướng tác động là thêm (kể cả khi cập nhật).
  - `isUpdate`: Xác định đây là cập nhật hay tạo mới.
  - `transDateOrigin`: Ngày điều chỉnh gốc (nếu có).

## Phương thức TrackingHelper.Enqueue

### Mục đích
Đưa thông tin phiếu kiểm kho vào hàng đợi xử lý để cập nhật tồn kho và ghi nhận lịch sử thay đổi.

### Quy trình
1. Ghi log thông tin phiếu kiểm kho.
2. Xác định loại tác động (thêm/xóa).
3. Tạo các đối tượng theo dõi tồn kho cho từng sản phẩm trong phiếu kiểm kho.
4. Đối với sản phẩm có quản lý lô hàng, tạo các đối tượng theo dõi lô hàng.
5. Đối với sản phẩm có quản lý số serial, tạo các đối tượng theo dõi số serial.
6. Gửi tất cả các đối tượng theo dõi vào hàng đợi xử lý.

## Xử lý InventoryTracking

### Mục đích
Ghi nhận lịch sử thay đổi tồn kho cho từng sản phẩm trong phiếu kiểm kho.

### Thông tin lưu trữ
- `DocumentId`: ID phiếu kiểm kho.
- `DocumentCode`: Mã phiếu kiểm kho.
- `DocumentType`: Loại tài liệu (StockTake).
- `ProductId`: ID sản phẩm.
- `ProductCode`: Mã sản phẩm.
- `BranchId`: ID chi nhánh.
- `TransDate`: Ngày điều chỉnh.
- `Quantity`: Số lượng thay đổi (ActualCount - SystemCount).
- `EndingStocks`: Số lượng tồn kho sau khi thay đổi.
- `ImpactDirection`: Hướng tác động (Add/Remove).

## Xử lý BatchExpireTracking

### Mục đích
Ghi nhận lịch sử thay đổi tồn kho cho từng lô hàng trong phiếu kiểm kho.

### Thông tin lưu trữ
- `DocumentId`: ID phiếu kiểm kho.
- `DocumentCode`: Mã phiếu kiểm kho.
- `DocumentType`: Loại tài liệu (StockTake).
- `ProductId`: ID sản phẩm.
- `ProductBatchExpireId`: ID lô hàng.
- `BatchName`: Tên lô hàng.
- `ExpireDate`: Ngày hết hạn.
- `BranchId`: ID chi nhánh.
- `TransDate`: Ngày điều chỉnh.
- `Quantity`: Số lượng thay đổi.
- `EndingStocks`: Số lượng tồn kho sau khi thay đổi.
- `ImpactDirection`: Hướng tác động (Add/Remove).

## Xử lý ImeiTracking

### Mục đích
Ghi nhận lịch sử thay đổi tồn kho cho từng số serial trong phiếu kiểm kho.

### Thông tin lưu trữ
- `DocumentId`: ID phiếu kiểm kho.
- `DocumentCode`: Mã phiếu kiểm kho.
- `DocumentType`: Loại tài liệu (StockTake).
- `ProductId`: ID sản phẩm.
- `SerialNumber`: Số serial.
- `BranchId`: ID chi nhánh.
- `TransDate`: Ngày điều chỉnh.
- `ImpactDirection`: Hướng tác động (Add/Remove).

## Phụ thuộc

### Dịch vụ và lớp tiện ích
- **StockTakeDetailService**: Quản lý chi tiết phiếu kiểm kho.
- **TrackingHelper**: Hỗ trợ theo dõi sự kiện.
- **Log**: Ghi log quá trình xử lý.

### Đối tượng
- **InventoryTracking**: Đại diện cho một bản ghi theo dõi tồn kho.
- **BatchExpireTracking**: Đại diện cho một bản ghi theo dõi lô hàng.
- **ImeiTracking**: Đại diện cho một bản ghi theo dõi số serial.

## Xử lý ngoại lệ
- Các lỗi trong quá trình theo dõi sự kiện sẽ được ghi log nhưng không ảnh hưởng đến quá trình lưu trữ phiếu kiểm kho.

## Các quy tắc nghiệp vụ

1. **Quy tắc về hướng tác động**:
   - Khi tạo mới phiếu kiểm kho, hướng tác động là `ImpactDirection.Add`.
   - Khi cập nhật phiếu kiểm kho, hướng tác động cũng là `ImpactDirection.Add` nhưng có cờ `isUpdate = true`.

2. **Quy tắc về ngày điều chỉnh**:
   - Nếu phiếu kiểm kho có ngày điều chỉnh, sử dụng ngày điều chỉnh làm ngày giao dịch.
   - Nếu không có ngày điều chỉnh, sử dụng ngày hiện tại làm ngày giao dịch.

3. **Quy tắc về tính toán số lượng thay đổi**:
   - Đối với tồn kho thông thường: `Quantity = ActualCount - SystemCount`.
   - Đối với lô hàng: `Quantity = BatchActualCount - BatchSystemCount`.
   - Đối với số serial: Số lượng luôn là 1, nhưng xác định thêm hoặc xóa dựa trên sự tồn tại trong hệ thống.

4. **Quy tắc về tình trạng số serial**:
   - Nếu số serial không có trong hệ thống nhưng có trong phiếu kiểm kho, đánh dấu là "InStock".
   - Nếu số serial có trong hệ thống nhưng không có trong phiếu kiểm kho, đánh dấu là "NotFound".

5. **Quy tắc về chuyển đổi đơn vị**:
   - Nếu sản phẩm có đơn vị chuyển đổi, số lượng sẽ được tính toán lại dựa trên giá trị chuyển đổi.

## Lưu ý quan trọng
1. Việc xử lý sự kiện sau lưu được thực hiện trong một khối `using` để đảm bảo tài nguyên được giải phóng đúng cách.
2. Quá trình theo dõi tồn kho được thực hiện bất đồng bộ thông qua hàng đợi, không chặn quá trình lưu trữ phiếu kiểm kho.
3. Các thông tin theo dõi được sử dụng để cập nhật tồn kho sản phẩm, cập nhật thông tin lô hàng và số serial.
4. Trường hợp chuyển trạng thái từ "Generator" sang "Approval" được xử lý như một phiếu kiểm kho mới, không phải cập nhật.

## Xử lý dược quốc gia

### Mục đích
Gửi thông tin phiếu kiểm kho tới hệ thống quản lý dược quốc gia nếu hệ thống đang sử dụng tính năng này.

### Quy trình
1. Kiểm tra xem hệ thống có đang sử dụng tính năng quản lý dược quốc gia không.
2. Nếu có, chuẩn bị dữ liệu phiếu kiểm kho theo định dạng yêu cầu.
3. Gửi dữ liệu tới API của hệ thống quản lý dược quốc gia.
4. Xử lý kết quả trả về từ API.

## Dữ liệu kiểm thử

### Trường hợp 1: Phiếu kiểm kho thông thường
```json
{
  "entity": {
    "Id": 1,
    "BranchId": 1,
    "Code": "KK0001",
    "Description": "Phiếu kiểm kho thông thường",
    "AdjustmentDate": "2023-01-01T00:00:00",
    "Status": 2  // Approval
  },
  "itemDetails": [
    {
      "ProductId": 1,
      "ProductCode": "SP001",
      "SystemCount": 8,
      "ActualCount": 10
    }
  ]
}
```

### Trường hợp 2: Phiếu kiểm kho với lô hàng
```json
{
  "entity": {
    "Id": 2,
    "BranchId": 1,
    "Code": "KK0002",
    "Description": "Phiếu kiểm kho với lô hàng",
    "AdjustmentDate": "2023-01-01T00:00:00",
    "Status": 2  // Approval
  },
  "itemDetails": [
    {
      "ProductId": 1,
      "ProductCode": "SP001",
      "IsBatchExpireControl": true,
      "SystemCount": 8,
      "ActualCount": 10,
      "ProductBatchExpireActualList": [
        {
          "Id": 1,
          "BatchName": "Lô 1",
          "ExpireDate": "2023-12-31T00:00:00",
          "ActualCount": 10
        }
      ],
      "ProductBatchExpireSystemList": [
        {
          "Id": 1,
          "BatchName": "Lô 1",
          "ExpireDate": "2023-12-31T00:00:00",
          "SystemCount": 8
        }
      ]
    }
  ]
}
```

### Trường hợp 3: Phiếu kiểm kho với số serial
```json
{
  "entity": {
    "Id": 3,
    "BranchId": 1,
    "Code": "KK0003",
    "Description": "Phiếu kiểm kho với số serial",
    "AdjustmentDate": "2023-01-01T00:00:00",
    "Status": 2  // Approval
  },
  "itemDetails": [
    {
      "ProductId": 1,
      "ProductCode": "SP001",
      "IsLotSerialControl": true,
      "SystemCount": 1,
      "ActualCount": 2,
      "SerialNumbers": "SN001,SN002",
      "SystemSerialNumbers": "SN001"
    }
  ]
}
```

### Trường hợp 4: Phiếu kiểm kho với đơn vị chuyển đổi
```json
{
  "entity": {
    "Id": 4,
    "BranchId": 1,
    "Code": "KK0004",
    "Description": "Phiếu kiểm kho với đơn vị chuyển đổi",
    "AdjustmentDate": "2023-01-01T00:00:00",
    "Status": 2  // Approval
  },
  "itemDetails": [
    {
      "ProductId": 1,
      "ProductCode": "SP001",
      "MasterUnitId": 100,
      "ConversionValue": 12,
      "SystemCount": 5,
      "ActualCount": 10
    }
  ]
}
```

### Trường hợp 5: Phiếu kiểm kho cập nhật với thay đổi ngày điều chỉnh
```json
{
  "entity": {
    "Id": 5,
    "BranchId": 1,
    "Code": "KK0005",
    "Description": "Phiếu kiểm kho cập nhật",
    "AdjustmentDate": "2023-01-02T00:00:00",  // Ngày mới
    "Status": 2  // Approval
  },
  "itemDetails": [
    {
      "ProductId": 1,
      "ProductCode": "SP001",
      "SystemCount": 8,
      "ActualCount": 12
    }
  ],
  "oldAdjustmentDate": "2023-01-01T00:00:00"  // Ngày cũ
}
``` 