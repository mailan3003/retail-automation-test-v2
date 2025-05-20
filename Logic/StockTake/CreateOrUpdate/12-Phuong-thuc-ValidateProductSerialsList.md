# Xác thực serial sản phẩm trong ValidateProductSerialsList

## Mục đích
Phương thức `ValidateProductSerialsList` trong lớp `StockTakeService` có nhiệm vụ xác thực tính hợp lệ của danh sách serial sản phẩm trong phiếu kiểm kho. Phương thức kiểm tra kỹ lưỡng để đảm bảo rằng số lượng serial khớp với số lượng thực tế, không có serial trùng lặp giữa các chi nhánh, và serial có trạng thái hợp lệ để có thể kiểm kê. Đây là một phần quan trọng trong quy trình xác thực phiếu kiểm kho cho sản phẩm quản lý theo số serial.

## Quy trình chính

### 1. Tổng hợp thông tin serial từ cơ sở dữ liệu
- Gọi phương thức `GetAllSerialInDb` để lấy thông tin về tất cả các serial liên quan đến sản phẩm:
  ```csharp
  var allProductSerials = GetAllSerialInDb(itemDetails, retailerId);
  ```
- Truy vấn này sử dụng SQL nâng cao (SQL thuần với OPENJSON) để lấy thông tin serial một cách hiệu quả.

### 2. Phân loại thông tin serial
- Chia thông tin serial thành hai nhóm: các serial tại chi nhánh hiện tại và các serial tại chi nhánh khác:
  ```csharp
  var productSerials = allProductSerials.Where(x => lstProductId.Contains(x.ProductId) && x.BranchId == branchId).ToList();
  var serialOnOtherBranch = allProductSerials.Where(a =>
      a.BranchId != branchId &&
      (a.Status == (int)SerialState.InStock || a.Status == (int)SerialState.Sent))
      .ToList();
  ```
- Chỉ xem xét các serial có trạng thái tồn kho (InStock) hoặc đã gửi (Sent) tại chi nhánh khác.

### 3. Lọc các sản phẩm cần kiểm tra serial
- Xác định danh sách các sản phẩm có quản lý serial để tiến hành kiểm tra:
  ```csharp
  var listProductSerials = itemDetails.Where(x => x.IsLotSerialControl == true).ToList();
  if (!listProductSerials.Any()) return;
  ```
- Nếu không có sản phẩm nào quản lý serial, kết thúc phương thức.

### 4. Xác thực từng sản phẩm có quản lý serial
- Lặp qua từng chi tiết sản phẩm có quản lý serial:
  ```csharp
  foreach (var detail in listProductSerials)
  {
      var serialNumbers = detail.SerialNumbers;
      var isNullSerialNumbers = string.IsNullOrWhiteSpace(serialNumbers);
      // Tiếp tục xác thực...
  }
  ```

### 5. Kiểm tra sự phù hợp giữa serial và số lượng thực tế
- Nếu số lượng thực tế > 0 nhưng không có serial, ném ra ngoại lệ:
  ```csharp
  if (isNullSerialNumbers && detail.ActualCount != 0)
  {
      throw new KvValidateStockTakeException(KVMessage.InvalidSerialQuantity);
  }
  ```
- Nếu có serial, xác thực số lượng serial phù hợp với số lượng thực tế:
  ```csharp
  StockTakeValidate.ValidateSerialActualCount(serialNumbers, detail.ActualCount);
  ```

### 6. Xác thực từng serial riêng lẻ
- Với mỗi serial trong danh sách, thực hiện hai kiểm tra chính:
  ```csharp
  foreach (var serial in serialNumbers.Split(','))
  {
      await ValidateSerialExitsOnOtherBranch(serialOnOtherBranch, detail.ProductId, serial);
      StockTakeValidate.ValidateSerialState(productSerials, detail.ProductId, serial);
  }
  ```
  - Kiểm tra 1: Serial không tồn tại ở chi nhánh khác
  - Kiểm tra 2: Serial có trạng thái hợp lệ

## Phụ thuộc

### Phương thức trợ giúp
- **GetAllSerialInDb**: Lấy thông tin serial từ cơ sở dữ liệu.
- **ValidateSerialExitsOnOtherBranch**: Kiểm tra sự tồn tại của serial ở chi nhánh khác.
- **StockTakeValidate.ValidateSerialState**: Kiểm tra trạng thái của serial.
- **StockTakeValidate.ValidateSerialActualCount**: Kiểm tra sự khớp nhau giữa số lượng serial và số lượng thực tế.

### Đối tượng dữ liệu
- **SerialCheckDto**: Đối tượng chứa thông tin về serial, bao gồm ProductId, SerialNumber, Status, BranchId.
- **StockTakeDetail**: Đối tượng chi tiết phiếu kiểm kho, chứa thông tin về sản phẩm và serial.

## Xử lý ngoại lệ
- `KvValidateStockTakeException`: Được ném ra trong các trường hợp:
  - Số lượng thực tế > 0 nhưng không có serial.
  - Số lượng serial không khớp với số lượng thực tế.
  - Serial đã tồn tại ở chi nhánh khác.
  - Serial có trạng thái không hợp lệ.

## Các quy tắc nghiệp vụ

1. **Quy tắc về phạm vi áp dụng**:
   - Chỉ áp dụng cho sản phẩm có cờ `IsLotSerialControl = true`.
   - Nếu không có sản phẩm nào quản lý serial, bỏ qua quá trình xác thực.

2. **Quy tắc về số lượng và serial**:
   - Nếu số lượng thực tế > 0, phải có danh sách serial tương ứng.
   - Số lượng serial phải khớp chính xác với số lượng thực tế.

3. **Quy tắc về tính duy nhất của serial**:
   - Một serial không thể tồn tại ở nhiều chi nhánh cùng một lúc.
   - Hệ thống kiểm tra sự tồn tại của serial ở tất cả các chi nhánh khác.

4. **Quy tắc về trạng thái serial**:
   - Serial phải có trạng thái hợp lệ để có thể kiểm kê.
   - Serial với trạng thái "Sent" không được phép kiểm kê.

5. **Quy tắc về nhất quán dữ liệu**:
   - Serial phải thuộc về đúng sản phẩm (kiểm tra ProductId).
   - Serial phải tồn tại trong cơ sở dữ liệu hoặc là serial mới được thêm vào.

## Lưu ý quan trọng
1. Phương thức này là một phần quan trọng của quy trình xác thực phiếu kiểm kho, đặc biệt cho các sản phẩm quản lý theo serial.
2. Phương thức sử dụng truy vấn SQL trực tiếp (thông qua GetAllSerialInDb) để tối ưu hiệu suất khi làm việc với số lượng lớn serial.
3. Việc xác thực được thực hiện tuần tự và sẽ dừng lại ngay khi phát hiện lỗi đầu tiên.
4. Các chi tiết sản phẩm không quản lý serial được bỏ qua trong quá trình xác thực này.

## Cấu trúc dữ liệu SerialCheckDto
- **ProductId**: ID của sản phẩm.
- **SerialNumber**: Số serial của sản phẩm.
- **Status**: Trạng thái của serial (InStock, Sent, v.v.).
- **BranchId**: ID của chi nhánh mà serial đang tồn tại.
- **RetailerId**: ID của người bán lẻ.

## Dữ liệu kiểm thử

### Trường hợp 1: Sản phẩm có quản lý serial hợp lệ
```json
{
  "ItemDetail": {
    "ProductId": 1002,
    "ProductCode": "SP002",
    "IsLotSerialControl": true,
    "ActualCount": 2,
    "SerialNumbers": "SN001,SN002"
  },
  "AllSerials": [
    {
      "ProductId": 1002,
      "SerialNumber": "SN001",
      "Status": 1,
      "BranchId": 1,
      "RetailerId": 1
    },
    {
      "ProductId": 1002,
      "SerialNumber": "SN002",
      "Status": 0,
      "BranchId": 1,
      "RetailerId": 1
    }
  ],
  "SerialOnOtherBranch": []
}
```

### Trường hợp 2: Lỗi serial đã tồn tại ở chi nhánh khác
```json
{
  "ItemDetail": {
    "ProductId": 1002,
    "ProductCode": "SP002",
    "IsLotSerialControl": true,
    "ActualCount": 2,
    "SerialNumbers": "SN001,SN003"
  },
  "AllSerials": [
    {
      "ProductId": 1002,
      "SerialNumber": "SN001",
      "Status": 1,
      "BranchId": 1,
      "RetailerId": 1
    },
    {
      "ProductId": 1002,
      "SerialNumber": "SN003",
      "Status": 1,
      "BranchId": 2,
      "RetailerId": 1
    }
  ],
  "SerialOnOtherBranch": [
    {
      "ProductId": 1002,
      "SerialNumber": "SN003",
      "Status": 1,
      "BranchId": 2,
      "RetailerId": 1
    }
  ],
  "Error": "KvValidateStockTakeException: SerialExistsInBranch: SN003, Chi nhánh 2"
}
```

### Trường hợp 3: Lỗi trạng thái serial không hợp lệ
```json
{
  "ItemDetail": {
    "ProductId": 1002,
    "ProductCode": "SP002",
    "IsLotSerialControl": true,
    "ActualCount": 1,
    "SerialNumbers": "SN004"
  },
  "AllSerials": [
    {
      "ProductId": 1002,
      "SerialNumber": "SN004",
      "Status": 2,
      "BranchId": 1,
      "RetailerId": 1
    }
  ],
  "SerialOnOtherBranch": [],
  "Error": "KvValidateStockTakeException: Global_CannotDoCauseOfSerial: SN004"
}
```

### Trường hợp 4: Lỗi số lượng thực tế và số lượng serial không khớp
```json
{
  "ItemDetail": {
    "ProductId": 1002,
    "ProductCode": "SP002",
    "IsLotSerialControl": true,
    "ActualCount": 3,
    "SerialNumbers": "SN001,SN002"
  },
  "AllSerials": [
    {
      "ProductId": 1002,
      "SerialNumber": "SN001",
      "Status": 1,
      "BranchId": 1,
      "RetailerId": 1
    },
    {
      "ProductId": 1002,
      "SerialNumber": "SN002",
      "Status": 1,
      "BranchId": 1,
      "RetailerId": 1
    }
  ],
  "SerialOnOtherBranch": [],
  "Error": "KvValidateStockTakeException: InvalidSerialQuantity"
}
``` 