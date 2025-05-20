# Xác thực số lượng thực tế trong ValidateActualCount

## Mục đích
Phương thức `ValidateActualCount` trong lớp `StockTakeValidate` có nhiệm vụ kiểm tra tính hợp lệ của số lượng thực tế (ActualCount) trong chi tiết phiếu kiểm kho. Phương thức đảm bảo rằng số lượng nhập vào không vượt quá giới hạn tối đa cho phép, tránh việc nhập sai số lượng quá lớn có thể gây ảnh hưởng đến hệ thống hoặc gây nhầm lẫn trong báo cáo tồn kho. Đây là một bước quan trọng trong quy trình xác thực dữ liệu phiếu kiểm kho.

## Quy trình chính

### 1. Kiểm tra tính hợp lệ của dữ liệu đầu vào
- Xác thực xem danh sách chi tiết kiểm kê có tồn tại hay không:
  ```csharp
  if (stockTakeDetails == null) throw new KvValidateStockTakeException(KVMessage.stocktake_EmptyDetail);
  ```
- Nếu danh sách là null, phương thức sẽ ném ra ngoại lệ với thông báo "Chi tiết phiếu kiểm kho trống".

### 2. Lọc các sản phẩm có số lượng không hợp lệ
- Sử dụng LINQ để lọc và xác định các sản phẩm có số lượng thực tế vượt quá giới hạn tối đa:
  ```csharp
  var invalidProducts = stockTakeDetails
      .Where(s => s.ActualCount >= MaxActualCount)
      .Select(p => p.ProductCode)
      .Join(", ");
  ```
- Phương thức `Where` lọc các chi tiết có ActualCount >= MaxActualCount (10,000,000,000,000)
- Phương thức `Select` lấy ra mã sản phẩm của các chi tiết không hợp lệ
- Phương thức `Join` kết hợp các mã sản phẩm thành một chuỗi, phân cách bởi dấu phẩy

### 3. Xử lý khi phát hiện số lượng không hợp lệ
- Kiểm tra xem danh sách sản phẩm không hợp lệ có rỗng không:
  ```csharp
  if (!string.IsNullOrEmpty(invalidProducts))
  {
      throw new KvValidateStockTakeException(string.Format(KVMessage.stocktake_InvalidActualCount, invalidProducts));
  }
  ```
- Nếu có sản phẩm với số lượng không hợp lệ, phương thức sẽ ném ra ngoại lệ "Phiếu kiểm kho không đúng, mã {0} sô lượng thực tế vượt quá giới hạn".

## Phụ thuộc

### Hằng số và đối tượng dữ liệu
- **MaxActualCount**: Hằng số xác định giới hạn tối đa cho số lượng thực tế (10,000,000,000,000).
- **StockTakeDetail**: Đối tượng chứa thông tin chi tiết phiếu kiểm kho, bao gồm ActualCount là số lượng thực tế.
- **KVMessage**: Lớp chứa các thông báo lỗi được định nghĩa trước, cụ thể là:
  - **stocktake_EmptyDetail**: Thông báo khi danh sách chi tiết là null
  - **stocktake_InvalidActualCount**: Thông báo khi phát hiện số lượng thực tế không hợp lệ

## Xử lý ngoại lệ
- `KvValidateStockTakeException`: Được ném ra trong hai trường hợp:
  - Khi danh sách chi tiết kiểm kê là null
  - Khi phát hiện có sản phẩm với số lượng thực tế vượt quá giới hạn tối đa

## Các quy tắc nghiệp vụ

1. **Quy tắc về giới hạn số lượng**:
   - Số lượng thực tế (ActualCount) không được vượt quá 10,000,000,000,000.
   - Giới hạn này được xác định bằng hằng số MaxActualCount trong lớp StockTakeValidate.

2. **Quy tắc về báo lỗi**:
   - Khi phát hiện sản phẩm có số lượng vượt quá giới hạn, hệ thống sẽ báo lỗi và liệt kê rõ các mã sản phẩm không hợp lệ.
   - Người dùng cần sửa lại số lượng thực tế để đảm bảo nằm trong giới hạn cho phép.

3. **Quy tắc về kiểm tra dữ liệu**:
   - Kiểm tra được thực hiện trước khi phiếu kiểm kho được lưu vào cơ sở dữ liệu.
   - Đảm bảo tính hợp lệ của dữ liệu số lượng ngay từ đầu quy trình.

## Lưu ý quan trọng
1. Phương thức này là một phần quan trọng trong quy trình xác thực phiếu kiểm kho, thường được gọi sau khi kiểm tra tính trùng lặp của sản phẩm.
2. Giới hạn tối đa 10,000,000,000,000 là một con số rất lớn, nhưng vẫn cần thiết để tránh các vấn đề liên quan đến tràn số hoặc nhập liệu sai.
3. Phương thức không sửa đổi dữ liệu đầu vào, chỉ kiểm tra và báo lỗi nếu phát hiện vấn đề.
4. Trong thực tế, việc nhập số lượng lớn như vậy thường là do lỗi nhập liệu, và việc kiểm tra này giúp phát hiện sớm các lỗi đó.

## Cấu trúc dữ liệu StockTakeDetail
- **ProductId**: ID của sản phẩm.
- **ProductCode**: Mã sản phẩm, được sử dụng để xác định sản phẩm trong thông báo lỗi.
- **ProductName**: Tên sản phẩm.
- **ActualCount**: Số lượng thực tế được kiểm kê, đây là giá trị được kiểm tra.
- **SystemCount**: Số lượng theo hệ thống.
- **IsDraft**: Cờ xác định chi tiết là bản nháp hay chính thức.

## Dữ liệu kiểm thử

### Trường hợp 1: Danh sách với số lượng hợp lệ
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
      "ActualCount": 9999999,
      "SystemCount": 6
    },
    {
      "ProductId": 1003,
      "ProductCode": "SP003",
      "ProductName": "Sản phẩm 3",
      "ActualCount": 0,
      "SystemCount": 12
    }
  ],
  "Result": "Thành công, tất cả số lượng thực tế đều hợp lệ"
}
```

### Trường hợp 2: Danh sách có sản phẩm với số lượng không hợp lệ
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
      "ActualCount": 15000000000000,
      "SystemCount": 6
    },
    {
      "ProductId": 1003,
      "ProductCode": "SP003",
      "ProductName": "Sản phẩm 3",
      "ActualCount": 5,
      "SystemCount": 12
    }
  ],
  "Error": "KvValidateStockTakeException: Số lượng thực tế của sản phẩm SP002 không hợp lệ"
}
```

### Trường hợp 3: Danh sách có nhiều sản phẩm với số lượng không hợp lệ
```json
{
  "StockTakeDetails": [
    {
      "ProductId": 1001,
      "ProductCode": "SP001",
      "ProductName": "Sản phẩm 1",
      "ActualCount": 20000000000000,
      "SystemCount": 8
    },
    {
      "ProductId": 1002,
      "ProductCode": "SP002",
      "ProductName": "Sản phẩm 2",
      "ActualCount": 10000000000000,
      "SystemCount": 6
    },
    {
      "ProductId": 1003,
      "ProductCode": "SP003",
      "ProductName": "Sản phẩm 3",
      "ActualCount": 5,
      "SystemCount": 12
    }
  ],
  "Error": "KvValidateStockTakeException: Số lượng thực tế của sản phẩm SP001, SP002 không hợp lệ"
}
```

### Trường hợp 4: Danh sách chi tiết là null
```json
{
  "StockTakeDetails": null,
  "Error": "KvValidateStockTakeException: Chi tiết phiếu kiểm kho không được để trống"
}
``` 