# Truy vấn thông tin lô hàng trong GetListProductBatchExpireByProduct

## Mục đích
Phương thức `GetListProductBatchExpireByProduct` trong lớp `StockTakeService` có nhiệm vụ truy vấn thông tin về lô và hạn sử dụng của sản phẩm từ cơ sở dữ liệu. Đây là một bước quan trọng trong việc chuẩn bị dữ liệu cho phiếu kiểm kho, đặc biệt với các sản phẩm được quản lý theo lô và hạn sử dụng. Phương thức này đảm bảo rằng hệ thống có thông tin đầy đủ về các lô hàng hiện có để so sánh với dữ liệu kiểm kho thực tế.

## Quy trình chính

### 1. Lọc sản phẩm có quản lý lô/hạn sử dụng
- Xác định các sản phẩm có cờ quản lý lô/hạn sử dụng từ danh sách chi tiết phiếu kiểm kho:
  ```csharp
  var listItemDetailBatchExpire = itemDetails.Where(x => x.IsBatchExpireControl == true).ToList();
  ```
- Chỉ những sản phẩm có cờ `IsBatchExpireControl = true` mới được xử lý.

### 2. Xác định danh sách ID sản phẩm cần truy vấn
- Tạo danh sách ID sản phẩm, bao gồm cả ID sản phẩm chính và ID đơn vị master:
  ```csharp
  var listAllProductIds = listItemDetailBatchExpire.Select(x => x.ProductId)
      .Union(listItemDetailBatchExpire
          .Where(m => m.MasterUnitId.HasValue)
          .Select(m => m.MasterUnitId.Value));
  ```
- Sử dụng `Union` để loại bỏ các ID trùng lặp.
- Đảm bảo lấy cả ID sản phẩm chính (ProductId) và ID đơn vị master (MasterUnitId) nếu có.

### 3. Truy vấn thông tin lô/hạn sử dụng từ cơ sở dữ liệu
- Thực hiện truy vấn LINQ để lấy thông tin lô/hạn sử dụng cho danh sách ID sản phẩm:
  ```csharp
  var result = await ProductBatchExpireService.GetAll()
      .Where(x => listAllProductIds.Contains(x.ProductId))
      .ToListAsync();
  ```
- Sử dụng `ProductBatchExpireService` để truy cập bảng lô/hạn sử dụng.

### 4. Chuẩn hóa thông tin FullNameVirgule
- Với mỗi bản ghi lô/hạn sử dụng, chuẩn hóa trường FullNameVirgule để đảm bảo định dạng đúng:
  ```csharp
  result.ForEach(p => p.FullNameVirgule = StockTakeNormalize.NormalizeSpecialCharacters(p.FullNameVirgule));
  ```
- Sử dụng `StockTakeNormalize.NormalizeSpecialCharacters` để chuẩn hóa chuỗi, loại bỏ các ký tự đặc biệt không hợp lệ.

### 5. Trả về kết quả
- Trả về danh sách các đối tượng `ProductBatchExpire` đã được chuẩn hóa.

## Phụ thuộc

### Dịch vụ và lớp tiện ích
- **ProductBatchExpireService**: Cung cấp phương thức truy vấn thông tin lô/hạn sử dụng từ cơ sở dữ liệu.
- **StockTakeNormalize**: Cung cấp phương thức `NormalizeSpecialCharacters` để chuẩn hóa chuỗi.

### Đối tượng dữ liệu
- **ProductBatchExpire**: Đối tượng chứa thông tin về lô và hạn sử dụng của sản phẩm.
- **StockTakeDetail**: Đối tượng chi tiết phiếu kiểm kho, chứa thông tin về sản phẩm.

## Xử lý ngoại lệ
- Phương thức không có xử lý ngoại lệ đặc biệt. Các ngoại lệ từ truy vấn cơ sở dữ liệu sẽ được truyền lên lớp gọi để xử lý.

## Các quy tắc nghiệp vụ

1. **Quy tắc về phạm vi áp dụng**:
   - Chỉ áp dụng cho sản phẩm có cờ `IsBatchExpireControl = true`.
   - Lấy thông tin lô/hạn sử dụng cho cả sản phẩm chính và sản phẩm có đơn vị master.

2. **Quy tắc về đơn vị master**:
   - Nếu sản phẩm có đơn vị master (MasterUnitId có giá trị), thông tin lô/hạn sử dụng sẽ được lấy theo ID của đơn vị master.
   - Điều này đảm bảo lấy đúng thông tin lô cho cả sản phẩm chính và sản phẩm có đơn vị phụ.

3. **Quy tắc về chuẩn hóa dữ liệu**:
   - Trường `FullNameVirgule` cần được chuẩn hóa để loại bỏ các ký tự đặc biệt không hợp lệ.
   - Việc chuẩn hóa giúp đảm bảo hiển thị đúng và so sánh chính xác dữ liệu.

4. **Quy tắc về truy vấn dữ liệu**:
   - Truy vấn được thực hiện một lần duy nhất với tất cả ID sản phẩm để tối ưu hiệu suất.
   - Sử dụng LINQ để lọc dữ liệu từ cơ sở dữ liệu theo danh sách ID.

## Lưu ý quan trọng
1. Phương thức này là bước đầu tiên trong quy trình xử lý lô/hạn sử dụng trong phiếu kiểm kho.
2. Kết quả từ phương thức này được sử dụng trong bước tiếp theo để tìm các lô/hạn sử dụng mới cần thêm vào hệ thống.
3. Việc xử lý đúng đơn vị master là rất quan trọng để đảm bảo thông tin lô/hạn sử dụng chính xác.
4. Việc chuẩn hóa `FullNameVirgule` giúp tránh các vấn đề khi so sánh chuỗi do ký tự đặc biệt.

## Cấu trúc dữ liệu ProductBatchExpire
- **Id**: ID của bản ghi lô/hạn sử dụng.
- **ProductId**: ID của sản phẩm.
- **BatchName**: Tên lô.
- **ExpireDate**: Ngày hết hạn.
- **DisplayType**: Kiểu hiển thị.
- **RetailerId**: ID của người bán lẻ.
- **CreatedDate**: Ngày tạo.
- **FullNameVirgule**: Tên đầy đủ của lô/hạn sử dụng theo định dạng "Tên lô - Ngày hết hạn".

## Dữ liệu kiểm thử

### Trường hợp 1: Sản phẩm có lô/hạn sử dụng
```json
{
  "ItemDetails": [
    {
      "ProductId": 1001,
      "ProductCode": "SP001",
      "IsBatchExpireControl": true,
      "MasterUnitId": null
    }
  ],
  "Result": [
    {
      "Id": 101,
      "ProductId": 1001,
      "BatchName": "LOT001",
      "ExpireDate": "2023-12-31T00:00:00",
      "DisplayType": 1,
      "RetailerId": 1,
      "CreatedDate": "2022-01-01T00:00:00",
      "FullNameVirgule": "LOT001 - 31/12/2023"
    },
    {
      "Id": 102,
      "ProductId": 1001,
      "BatchName": "LOT002",
      "ExpireDate": "2024-06-30T00:00:00",
      "DisplayType": 1,
      "RetailerId": 1,
      "CreatedDate": "2022-01-01T00:00:00",
      "FullNameVirgule": "LOT002 - 30/06/2024"
    }
  ]
}
```

### Trường hợp 2: Sản phẩm có đơn vị master
```json
{
  "ItemDetails": [
    {
      "ProductId": 2002,
      "ProductCode": "SP-SLAVE",
      "IsBatchExpireControl": true,
      "MasterUnitId": 2001
    }
  ],
  "Result": [
    {
      "Id": 201,
      "ProductId": 2001,
      "BatchName": "LOT-A",
      "ExpireDate": "2023-12-31T00:00:00",
      "DisplayType": 1,
      "RetailerId": 1,
      "CreatedDate": "2022-01-01T00:00:00",
      "FullNameVirgule": "LOT-A - 31/12/2023"
    }
  ]
}
```

### Trường hợp 3: Không có sản phẩm quản lý lô/hạn sử dụng
```json
{
  "ItemDetails": [
    {
      "ProductId": 3001,
      "ProductCode": "SP-NO-BATCH",
      "IsBatchExpireControl": false,
      "MasterUnitId": null
    }
  ],
  "Result": []
}
``` 