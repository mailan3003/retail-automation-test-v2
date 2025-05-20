# Chuẩn hóa dữ liệu serial trong NormalizeSystemSerialNumbers

## Mục đích
Phương thức `NormalizeSystemSerialNumbers` trong lớp `StockTakeService` có nhiệm vụ truy vấn và tổng hợp thông tin số serial hiện có trong hệ thống cho các sản phẩm, sau đó gán vào trường `SystemSerialNumbers` của chi tiết phiếu kiểm kho. Việc này giúp người dùng so sánh được số serial thực tế kiểm kê với số serial hiện có trong hệ thống, phát hiện sự chênh lệch và điều chỉnh kho hàng cho chính xác.

## Quy trình chính

### 1. Xác định các sản phẩm có quản lý serial
- Lọc các sản phẩm có cờ quản lý serial từ danh sách chi tiết:
  ```csharp
  var listProductIdBySerial = itemDetails
      .Where(x => x.IsLotSerialControl == true)
      .Select(id => id.ProductId);
  ```
- Chỉ các sản phẩm có cờ `IsLotSerialControl = true` mới được xử lý.

### 2. Truy vấn thông tin serial từ cơ sở dữ liệu
- Thực hiện truy vấn LINQ để lấy thông tin tất cả serial hiện có của các sản phẩm tại chi nhánh chỉ định:
  ```csharp
  var dictProductSerials = Db.ProductSerials
      .Where(x => x.BranchId == branchId && listProductIdBySerial.Contains(x.ProductId) && x.Status > 0)
      .Select(ps => new { ps.ProductId, ps.SerialNumber })
      .ToList()
      .GroupBy(g => g.ProductId)
      .Select(v => new
      {
          v.Key,
          serials = v.Aggregate(string.Empty, (current, sr) => current + ("," + sr.SerialNumber)).Trim(',')
      })
      .ToDictionary(k => k.Key, v => v.serials);
  ```
- Chỉ lấy các serial có trạng thái > 0 (đang tồn kho).
- Kết quả là một từ điển (Dictionary) lưu trữ danh sách các serial theo ProductId.

### 3. Gom nhóm và chuẩn hóa thông tin serial
- Sử dụng LINQ Aggregate để nối các serial thành một chuỗi duy nhất, phân cách bởi dấu phẩy:
  ```csharp
  serials = v.Aggregate(string.Empty, (current, sr) => current + ("," + sr.SerialNumber)).Trim(',')
  ```
- Chuỗi kết quả được cắt bỏ dấu phẩy ở đầu và cuối.

### 4. Cập nhật thông tin vào chi tiết phiếu kiểm kho
- Lặp qua các chi tiết phiếu kiểm kho có quản lý serial và gán thông tin serial từ từ điển:
  ```csharp
  foreach (var item in itemDetails.Where(x => x.IsLotSerialControl == true))
  {
      dictProductSerials.TryGetValue(item.ProductId, out var beforeSerials);
      item.SystemSerialNumbers = beforeSerials;
  }
  ```
- Sử dụng `TryGetValue` để đảm bảo an toàn khi truy xuất từ điển.
- Giá trị `beforeSerials` có thể là `null` nếu không có serial nào cho sản phẩm đó.

## Phụ thuộc

### Dịch vụ và đối tượng dữ liệu
- **Db.ProductSerials**: Bảng dữ liệu chứa thông tin serial của sản phẩm.
- **StockTakeDetail**: Đối tượng chi tiết phiếu kiểm kho, chứa thông tin sản phẩm và serial.

## Xử lý ngoại lệ
- Phương thức không có xử lý ngoại lệ đặc biệt. Các ngoại lệ từ truy vấn cơ sở dữ liệu sẽ được truyền lên lớp gọi để xử lý.
- Sử dụng `TryGetValue` để tránh lỗi khi không tìm thấy key trong từ điển.

## Các quy tắc nghiệp vụ

1. **Quy tắc về phạm vi áp dụng**:
   - Chỉ áp dụng cho sản phẩm có cờ `IsLotSerialControl = true`.
   - Chỉ lấy thông tin serial tại chi nhánh hiện tại.

2. **Quy tắc về trạng thái serial**:
   - Chỉ lấy các serial có trạng thái > 0, tức là đang tồn kho.
   - Serial có trạng thái = 0 (không tồn tại hoặc đã xuất) không được đưa vào danh sách.

3. **Quy tắc về định dạng dữ liệu**:
   - Danh sách serial được lưu trữ dưới dạng chuỗi, các serial cách nhau bởi dấu phẩy.
   - Không có khoảng trắng giữa các serial.
   - Không có dấu phẩy thừa ở đầu hoặc cuối chuỗi.

4. **Quy tắc về hiển thị dữ liệu**:
   - Trường `SystemSerialNumbers` sẽ được gán giá trị `null` nếu không có serial nào được tìm thấy.
   - Trường `SystemSerialNumbers` sẽ được sử dụng để hiển thị và so sánh với trường `SerialNumbers` (serial thực tế).

## Lưu ý quan trọng
1. Phương thức này là một phần của quy trình chuẩn hóa dữ liệu trong quá trình tạo hoặc cập nhật phiếu kiểm kho.
2. Kết quả từ phương thức này được sử dụng để hiển thị thông tin serial hiện có trong hệ thống cho người dùng khi thực hiện kiểm kho.
3. Truy vấn được thực hiện trực tiếp trên Db.ProductSerials thay vì thông qua service để tối ưu hiệu suất.
4. Việc gom nhóm và nối chuỗi được thực hiện trong bộ nhớ sau khi lấy dữ liệu từ cơ sở dữ liệu để tối ưu hiệu suất truy vấn.

## Cấu trúc dữ liệu
- **ProductId**: ID của sản phẩm.
- **SerialNumber**: Số serial của sản phẩm.
- **Status**: Trạng thái của serial (> 0 là đang tồn kho).
- **BranchId**: ID của chi nhánh mà serial đang tồn tại.

## Dữ liệu kiểm thử

### Trường hợp 1: Sản phẩm có nhiều serial tồn kho
```json
{
  "ItemDetail": {
    "ProductId": 1001,
    "ProductCode": "SP001",
    "IsLotSerialControl": true,
    "SerialNumbers": "SN001,SN002",
    "SystemSerialNumbers": "SN001,SN003,SN004"
  },
  "ProductSerials": [
    {
      "ProductId": 1001,
      "SerialNumber": "SN001",
      "Status": 1,
      "BranchId": 1
    },
    {
      "ProductId": 1001,
      "SerialNumber": "SN003",
      "Status": 1,
      "BranchId": 1
    },
    {
      "ProductId": 1001,
      "SerialNumber": "SN004",
      "Status": 1,
      "BranchId": 1
    }
  ]
}
```

### Trường hợp 2: Sản phẩm không có serial tồn kho
```json
{
  "ItemDetail": {
    "ProductId": 1002,
    "ProductCode": "SP002",
    "IsLotSerialControl": true,
    "SerialNumbers": "SN005,SN006",
    "SystemSerialNumbers": null
  },
  "ProductSerials": []
}
```

### Trường hợp 3: Sản phẩm có serial nhưng đã xuất kho
```json
{
  "ItemDetail": {
    "ProductId": 1003,
    "ProductCode": "SP003",
    "IsLotSerialControl": true,
    "SerialNumbers": "SN007",
    "SystemSerialNumbers": null
  },
  "ProductSerials": [
    {
      "ProductId": 1003,
      "SerialNumber": "SN007",
      "Status": 0, // Đã xuất kho, không được tính là serial tồn kho
      "BranchId": 1
    }
  ]
}
``` 