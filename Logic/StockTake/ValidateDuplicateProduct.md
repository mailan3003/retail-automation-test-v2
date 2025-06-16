# Xác thực sản phẩm trùng lặp trong ValidateDuplicateProduct

## Mục đích
Phương thức `ValidateDuplicateProduct` trong lớp `StockTakeValidate` được thiết kế để đảm bảo tính duy nhất của sản phẩm trong một phiếu kiểm kho. Phương thức này kiểm tra xem có bất kỳ sản phẩm nào được liệt kê hai lần hoặc nhiều hơn trong danh sách chi tiết kiểm kê hay không. Việc kiểm tra này là bước quan trọng trong quy trình xác thực dữ liệu phiếu kiểm kho, giúp tránh tình trạng nhập liệu sai, tính toán lặp hoặc nhầm lẫn về số lượng sản phẩm.

## Quy trình chính

### 1. Kiểm tra tính hợp lệ của dữ liệu đầu vào
- Xác thực xem danh sách chi tiết kiểm kê có tồn tại hay không:
  ```csharp
  if (stockTakeDetails == null) throw new KvValidateStockTakeException(KVMessage.stocktake_EmptyDetail);
  ```
- Nếu danh sách là null, phương thức sẽ ném ra ngoại lệ với thông báo "Chi tiết phiếu kiểm kho trống".

### 2. Tìm kiếm các sản phẩm trùng lặp
- Sử dụng LINQ để nhóm các sản phẩm theo mã sản phẩm và tìm các nhóm có nhiều hơn một mục:
  ```csharp
  var duplicateProducts = stockTakeDetails
      .GroupBy(item => item.ProductCode)
      .Where(g => g.Count() > 1)
      .Select(p => p.Key)
      .Join(", ");
  ```
- Phương thức `GroupBy` tạo ra các nhóm dựa trên `ProductCode`
- Phương thức `Where` lọc các nhóm có số lượng phần tử > 1
- Phương thức `Select` lấy ra mã sản phẩm (key) của các nhóm đã lọc
- Phương thức `Join` kết hợp các mã sản phẩm thành một chuỗi, phân cách bởi dấu phẩy

### 3. Xử lý khi phát hiện sản phẩm trùng lặp
- Kiểm tra xem danh sách sản phẩm trùng lặp có rỗng không:
  ```csharp
  if (!string.IsNullOrEmpty(duplicateProducts))
  {
      throw new KvValidateStockTakeException(string.Format(KVMessage.stocktake_DuplicateErr, duplicateProducts));
  }
  ```
- Nếu có sản phẩm trùng lặp, phương thức sẽ ném ra ngoại lệ với thông báo "Phiếu kiểm kho không đúng, mã {0} trùng lặp".

## Phụ thuộc

### Đối tượng dữ liệu
- **StockTakeDetail**: Đối tượng chứa thông tin chi tiết phiếu kiểm kho, bao gồm ProductCode là mã sản phẩm.
- **KVMessage**: Lớp chứa các thông báo lỗi được định nghĩa trước, cụ thể là:
  - **stocktake_EmptyDetail**: Thông báo khi danh sách chi tiết là null
  - **stocktake_DuplicateErr**: Thông báo khi phát hiện sản phẩm trùng lặp

## Xử lý ngoại lệ
- `KvValidateStockTakeException`: Được ném ra trong hai trường hợp:
  - Khi danh sách chi tiết kiểm kê là null
  - Khi phát hiện có sản phẩm trùng lặp trong danh sách

## Các quy tắc nghiệp vụ

1. **Quy tắc về tính duy nhất của sản phẩm**:
   - Mỗi sản phẩm chỉ được xuất hiện một lần trong phiếu kiểm kho.
   - Việc nhận diện sản phẩm dựa vào mã sản phẩm (ProductCode).

2. **Quy tắc về báo lỗi**:
   - Khi phát hiện sản phẩm trùng lặp, hệ thống sẽ báo lỗi và liệt kê rõ các mã sản phẩm bị trùng.
   - Người dùng cần sửa lại phiếu kiểm kho để đảm bảo không có sản phẩm trùng lặp.

3. **Quy tắc về kiểm tra dữ liệu**:
   - Kiểm tra được thực hiện trước khi phiếu kiểm kho được lưu vào cơ sở dữ liệu.
   - Đảm bảo tính toàn vẹn của dữ liệu ngay từ đầu quy trình.

## Lưu ý quan trọng
1. Phương thức này là một phần quan trọng trong quy trình xác thực phiếu kiểm kho, thường được gọi tại bước đầu của quy trình.
2. Việc kiểm tra trùng lặp dựa hoàn toàn vào mã sản phẩm (ProductCode), không phải ID hay các thuộc tính khác.
3. Phương thức không sửa đổi dữ liệu đầu vào, chỉ kiểm tra và báo lỗi nếu phát hiện vấn đề.
4. Trong môi trường thực tế, việc phát hiện sản phẩm trùng lặp giúp tránh các vấn đề về tính toán số lượng, giá trị tồn kho không chính xác.

## Cấu trúc dữ liệu StockTakeDetail
- **ProductId**: ID của sản phẩm.
- **ProductCode**: Mã sản phẩm, được sử dụng để xác định trùng lặp.
- **ProductName**: Tên sản phẩm.
- **ActualCount**: Số lượng thực tế được kiểm kê.
- **SystemCount**: Số lượng theo hệ thống.
- **IsDraft**: Cờ xác định chi tiết là bản nháp hay chính thức.

## Dữ liệu kiểm thử

### Trường hợp 1: Danh sách không có sản phẩm trùng lặp
```json
{
  "StockTakeDetails": [
    {
      "ProductId": 1001,
      "ProductCode": "SP001",
      "ProductName": "Sản phẩm 1",
      "ActualCount": 10,
      "SystemCount": 8
    },
    {
      "ProductId": 1002,
      "ProductCode": "SP002",
      "ProductName": "Sản phẩm 2",
      "ActualCount": 5,
      "SystemCount": 6
    },
    {
      "ProductId": 1003,
      "ProductCode": "SP003",
      "ProductName": "Sản phẩm 3",
      "ActualCount": 15,
      "SystemCount": 12
    }
  ],
  "Result": "Thành công, không có sản phẩm trùng lặp"
}
```

### Trường hợp 2: Danh sách có sản phẩm trùng lặp
```json
{
  "StockTakeDetails": [
    {
      "ProductId": 1001,
      "ProductCode": "SP001",
      "ProductName": "Sản phẩm 1",
      "ActualCount": 10,
      "SystemCount": 8
    },
    {
      "ProductId": 1002,
      "ProductCode": "SP002",
      "ProductName": "Sản phẩm 2",
      "ActualCount": 5,
      "SystemCount": 6
    },
    {
      "ProductId": 1001,
      "ProductCode": "SP001",
      "ProductName": "Sản phẩm 1 (trùng lặp)",
      "ActualCount": 7,
      "SystemCount": 8
    }
  ],
  "Error": "KvValidateStockTakeException: Mã sản phẩm SP001 bị trùng lặp trong phiếu kiểm kho"
}
```

### Trường hợp 3: Danh sách có nhiều sản phẩm trùng lặp
```json
{
  "StockTakeDetails": [
    {
      "ProductId": 1001,
      "ProductCode": "SP001",
      "ProductName": "Sản phẩm 1",
      "ActualCount": 10,
      "SystemCount": 8
    },
    {
      "ProductId": 1001,
      "ProductCode": "SP001",
      "ProductName": "Sản phẩm 1 (trùng lặp)",
      "ActualCount": 7,
      "SystemCount": 8
    },
    {
      "ProductId": 1002,
      "ProductCode": "SP002",
      "ProductName": "Sản phẩm 2",
      "ActualCount": 5,
      "SystemCount": 6
    },
    {
      "ProductId": 1002,
      "ProductCode": "SP002",
      "ProductName": "Sản phẩm 2 (trùng lặp)",
      "ActualCount": 3,
      "SystemCount": 6
    }
  ],
  "Error": "KvValidateStockTakeException: Mã sản phẩm SP001, SP002 bị trùng lặp trong phiếu kiểm kho"
}
```

### Trường hợp 4: Danh sách chi tiết là null
```json
{
  "StockTakeDetails": null,
  "Error": "KvValidateStockTakeException: Chi tiết phiếu kiểm kho không được để trống"
}
``` 