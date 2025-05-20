# Xử lý thông tin lô hàng trong DoCreateOrUpdateAsync

## Mục đích
Phần xử lý thông tin lô hàng trong phương thức `DoCreateOrUpdateAsync` có nhiệm vụ quản lý thông tin về lô hàng và hạn sử dụng của sản phẩm trong phiếu kiểm kho. Đây là một bước quan trọng để đảm bảo việc theo dõi chính xác các sản phẩm có quản lý lô hàng.

## Quy trình chính

### 1. Kiểm tra sự tồn tại của sản phẩm quản lý lô hàng
- Kiểm tra biến `isExistBatchExpireControl` để xác định có sản phẩm nào có quản lý lô hàng không.
- Nếu không có sản phẩm quản lý lô hàng, bỏ qua bước xử lý lô hàng.

### 2. Lấy danh sách lô hàng từ cơ sở dữ liệu
- Gọi phương thức `GetListProductBatchExpireByProduct` để truy vấn thông tin lô hàng hiện có của các sản phẩm.
- Phương thức này lọc các sản phẩm có thuộc tính `IsBatchExpireControl = true` và truy vấn thông tin lô của chúng.

### 3. Chuẩn hóa và tạo mới lô hàng
- Gọi phương thức `StockTakeNormalize.GetListProductBatchExpireAddNew` để:
  - Chuẩn hóa thông tin lô hàng hiện có.
  - Xác định các lô hàng mới cần được tạo.
  - Cập nhật thông tin lô hàng trong `itemDetails`.

### 4. Lưu trữ lô hàng mới vào cơ sở dữ liệu
- Kiểm tra xem có lô hàng mới nào cần thêm vào cơ sở dữ liệu không.
- Nếu có, sử dụng `Db.BulkInsertAsync` để thêm đồng thời tất cả các lô hàng mới.

### 5. Cập nhật thông tin lô hàng sau khi thêm mới
- Gọi phương thức `StockTakeNormalize.NormalizeProductBatchExpireAddNew` để cập nhật ID của các lô hàng mới trong `itemDetails`.
- Phương thức này đảm bảo các lô hàng mới được liên kết chính xác với sản phẩm tương ứng.

## Phụ thuộc

### Dịch vụ và lớp tiện ích
- **StockTakeNormalize**: Cung cấp các phương thức chuẩn hóa thông tin lô hàng.
- **ProductBatchExpireService**: Truy vấn thông tin lô hàng từ cơ sở dữ liệu.

### Đối tượng
- **ProductBatchExpire**: Đại diện cho một lô hàng trong cơ sở dữ liệu.
- **ProductBatchExpireActual**: Thông tin về lô hàng được gửi từ client.

## Cấu trúc dữ liệu ProductBatchExpire
- **Id**: ID của lô hàng.
- **ProductId**: ID của sản phẩm.
- **BatchName**: Tên lô hàng.
- **ExpireDate**: Ngày hết hạn.
- **DisplayType**: Kiểu hiển thị.
- **RetailerId**: ID của nhà bán lẻ.
- **CreatedDate**: Ngày tạo.
- **FullNameVirgule**: Tên đầy đủ của lô hàng (kết hợp tên lô và ngày hết hạn).

## Xử lý ngoại lệ
- Các lỗi liên quan đến thêm mới lô hàng vào cơ sở dữ liệu sẽ được truyền lên các lớp xử lý cao hơn.

## Các quy tắc nghiệp vụ

1. **Quy tắc về chuẩn hóa tên lô hàng**:
   - Tên lô hàng được chuẩn hóa để loại bỏ các ký tự đặc biệt và không hợp lệ.

2. **Quy tắc về xác định lô hàng mới**:
   - Lô hàng được xác định là mới nếu không tìm thấy lô tương tự (cùng tên lô và ngày hết hạn) trong cơ sở dữ liệu.
   - Lô hàng mới được đánh dấu với `Id = -1` trước khi thêm vào cơ sở dữ liệu.

3. **Quy tắc về tên đầy đủ của lô hàng**:
   - Tên đầy đủ của lô hàng được tạo theo định dạng: `{BatchName} - {ExpireDate:dd/MM/yyyy}`.
   - Nếu `BatchName` rỗng, chỉ hiển thị ngày hết hạn.

4. **Quy tắc về cập nhật thông tin lô hàng**:
   - Sau khi thêm mới lô hàng, các ID của lô hàng mới được cập nhật vào `itemDetails` để đảm bảo tính nhất quán.

5. **Quy tắc về chuyển đổi định dạng dữ liệu**:
   - Danh sách lô hàng được chuyển đổi sang định dạng JSON để lưu trữ trong `ProductBatchExpireActual`.
   - Tên đầy đủ của tất cả các lô hàng được nối lại và lưu trong `ProductBatchExpireActualFullName`.

## Lưu ý quan trọng
1. Quá trình xử lý lô hàng chỉ áp dụng cho các sản phẩm có thuộc tính `IsBatchExpireControl = true`.
2. Việc thêm mới lô hàng được thực hiện bằng cách sử dụng `BulkInsertAsync` để tối ưu hiệu suất.
3. Cần xử lý cẩn thận vấn đề trùng lặp lô hàng để tránh lỗi cơ sở dữ liệu.
4. Thông tin về lô hàng được lưu trữ dưới dạng JSON trong trường `ProductBatchExpireActual` của `StockTakeDetail`.

## Dữ liệu kiểm thử

### Trường hợp 1: Thêm mới lô hàng
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
      "IsBatchExpireControl": true,
      "ActualCount": 10,
      "ProductBatchExpireActualList": [
        {
          "BatchName": "Lô mới 1",
          "ExpireDate": "2023-12-31T00:00:00",
          "ActualCount": 5
        },
        {
          "BatchName": "Lô mới 2",
          "ExpireDate": "2024-06-30T00:00:00",
          "ActualCount": 5
        }
      ]
    }
  ],
  "isAdjust": true
}
```

### Trường hợp 2: Sử dụng lô hàng đã tồn tại
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
      "IsBatchExpireControl": true,
      "ActualCount": 10,
      "ProductBatchExpireActualList": [
        {
          "BatchName": "Lô đã tồn tại",  // Giả sử lô này đã tồn tại trong hệ thống
          "ExpireDate": "2023-12-31T00:00:00",
          "ActualCount": 10
        }
      ]
    }
  ],
  "isAdjust": true
}
```

### Trường hợp 3: Kết hợp lô hàng mới và lô hàng đã tồn tại
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
      "IsBatchExpireControl": true,
      "ActualCount": 15,
      "ProductBatchExpireActualList": [
        {
          "BatchName": "Lô đã tồn tại",  // Giả sử lô này đã tồn tại trong hệ thống
          "ExpireDate": "2023-12-31T00:00:00",
          "ActualCount": 5
        },
        {
          "BatchName": "Lô mới",
          "ExpireDate": "2024-06-30T00:00:00",
          "ActualCount": 10
        }
      ]
    }
  ],
  "isAdjust": true
}
```

### Trường hợp 4: Lô hàng không có tên
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
      "IsBatchExpireControl": true,
      "ActualCount": 10,
      "ProductBatchExpireActualList": [
        {
          "BatchName": "",  // Lô không có tên
          "ExpireDate": "2023-12-31T00:00:00",
          "ActualCount": 10
        }
      ]
    }
  ],
  "isAdjust": true
}
```

### Trường hợp 5: Nhiều sản phẩm với lô hàng
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
      "IsBatchExpireControl": true,
      "ActualCount": 10,
      "ProductBatchExpireActualList": [
        {
          "BatchName": "Lô 1 - SP1",
          "ExpireDate": "2023-12-31T00:00:00",
          "ActualCount": 10
        }
      ]
    },
    {
      "ProductId": 2,
      "ProductCode": "SP002",
      "IsBatchExpireControl": true,
      "ActualCount": 15,
      "ProductBatchExpireActualList": [
        {
          "BatchName": "Lô 1 - SP2",
          "ExpireDate": "2024-01-31T00:00:00",
          "ActualCount": 15
        }
      ]
    }
  ],
  "isAdjust": true
}
``` 