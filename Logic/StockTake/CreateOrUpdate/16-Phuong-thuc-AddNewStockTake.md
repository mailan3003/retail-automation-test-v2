# Tạo mới phiếu kiểm kho trong AddNewStockTake

## Mục đích
Phương thức `AddNewStockTake` trong lớp `StockTakeService` có nhiệm vụ tạo mới một phiếu kiểm kho và các chi tiết liên quan trong cơ sở dữ liệu. Phương thức thực hiện đầy đủ quy trình từ chuẩn hóa dữ liệu, lưu trữ phiếu kiểm kho chính, đến thêm các chi tiết phiếu kiểm kho. Nó cũng xử lý các trường hợp đặc biệt như kiểm tra quyền hạn người dùng khi cần thiết.

## Quy trình chính

### 1. Chuẩn hóa thông tin phiếu kiểm kho
- Sử dụng `StockTakeNormalize.NormalizeStocTake` để chuẩn hóa thông tin chung của phiếu kiểm kho:
  ```csharp
  StockTakeNormalize.NormalizeStocTake(entity, stockTakeAddNew, AuthService.Context.User.Id, isAdjust, isExistBatchExpireOrLotSerial);
  ```
- Các thông tin được chuẩn hóa bao gồm: mã phiếu, ngày tạo, mô tả, chi nhánh, lịch sử gần đây, ID phiếu gốc, trạng thái, v.v.

### 2. Tối ưu hóa dữ liệu trước khi lưu trữ
- Đặt trường StockTakeDetails thành null để tránh lưu trữ không cần thiết:
  ```csharp
  stockTakeAddNew.StockTakeDetails = null;
  ```
- Điều này giúp giảm dung lượng dữ liệu khi lưu trữ phiếu kiểm kho chính.

### 3. Lưu trữ phiếu kiểm kho chính
- Dựa vào tham số `checkPermission`, lựa chọn phương thức thêm mới phù hợp:
  ```csharp
  if (checkPermission)
  {
      await AddAsyncWithEvent(stockTakeAddNew);
  }
  else
  {
      await AddNotGuardAsyncWithEvent(stockTakeAddNew);
  }
  ```
- Nếu `checkPermission = true` (mặc định), sử dụng `AddAsyncWithEvent` để thêm mới có kiểm tra quyền hạn.
- Nếu `checkPermission = false`, sử dụng `AddNotGuardAsyncWithEvent` để thêm mới không kiểm tra quyền hạn.

### 4. Thêm chi tiết phiếu kiểm kho
- Gọi phương thức `AddNewStockTakeDetail` để thêm các chi tiết phiếu kiểm kho:
  ```csharp
  await AddNewStockTakeDetail(itemDetails, stockTakeAddNew.Id, AuthService.Context.RetailerId);
  ```
- Phương thức này cập nhật từng chi tiết với ID của phiếu kiểm kho chính vừa tạo, sau đó thực hiện thêm mới hàng loạt.

## Phụ thuộc

### Dịch vụ và lớp tiện ích
- **StockTakeNormalize**: Cung cấp phương thức `NormalizeStocTake` để chuẩn hóa thông tin phiếu kiểm kho.
- **AddAsyncWithEvent**: Thêm mới phiếu kiểm kho có kiểm tra quyền hạn và phát sự kiện.
- **AddNotGuardAsyncWithEvent**: Thêm mới phiếu kiểm kho không kiểm tra quyền hạn và phát sự kiện.
- **AddNewStockTakeDetail**: Thêm chi tiết phiếu kiểm kho vào cơ sở dữ liệu.

### Đối tượng dữ liệu
- **StockTake**: Đối tượng phiếu kiểm kho chính.
- **StockTakeDetail**: Đối tượng chi tiết phiếu kiểm kho.

## Xử lý ngoại lệ
- Phương thức không có xử lý ngoại lệ đặc biệt. Các ngoại lệ từ các phương thức gọi sẽ được truyền lên lớp gọi để xử lý.

## Các quy tắc nghiệp vụ

1. **Quy tắc về kiểm tra quyền hạn**:
   - Mặc định (`checkPermission = true`), phương thức sẽ kiểm tra quyền hạn người dùng khi thêm mới phiếu kiểm kho.
   - Trong một số trường hợp đặc biệt (`checkPermission = false`), có thể bỏ qua kiểm tra quyền hạn để phục vụ các tính năng hệ thống.

2. **Quy tắc về chuẩn hóa dữ liệu**:
   - Dữ liệu phiếu kiểm kho phải được chuẩn hóa trước khi lưu trữ.
   - Nếu phiếu kiểm kho được điều chỉnh (isAdjust = true), trạng thái và ngày điều chỉnh sẽ được thiết lập tương ứng.

3. **Quy tắc về tối ưu hóa dữ liệu**:
   - Trường StockTakeDetails được đặt thành null để tránh lưu trữ dữ liệu không cần thiết.
   - Các chi tiết sẽ được lưu trữ riêng biệt thông qua phương thức AddNewStockTakeDetail.

4. **Quy tắc về thứ tự thao tác**:
   - Lưu trữ phiếu kiểm kho chính trước để có ID hợp lệ.
   - Sau đó cập nhật ID phiếu kiểm kho cho các chi tiết và lưu trữ chi tiết.

## Lưu ý quan trọng
1. Phương thức này là một phần của quy trình tạo mới phiếu kiểm kho trong hệ thống.
2. Tham số `checkPermission` đóng vai trò quan trọng trong việc quyết định có kiểm tra quyền hạn người dùng hay không.
3. Phương thức không sử dụng giao dịch rõ ràng, nhưng các phương thức con có thể sử dụng giao dịch.
4. ID của phiếu kiểm kho chính sẽ được tự động tạo bởi hệ thống khi thêm mới.

## Trường hợp sử dụng
1. **Phiếu kiểm kho thông thường**: Người dùng tạo phiếu kiểm kho thông qua giao diện người dùng, `checkPermission = true`.
2. **Phiếu kiểm kho hệ thống**: Hệ thống tự động tạo phiếu kiểm kho (ví dụ: khi xóa sản phẩm), `checkPermission = false`.
3. **Phiếu kiểm kho từ API**: Phiếu kiểm kho được tạo thông qua API, `checkPermission = true` hoặc `false` tùy thuộc vào ngữ cảnh.

## Ví dụ dữ liệu

### Trường hợp 1: Phiếu kiểm kho thông thường
```json
{
  "Entity": {
    "Code": "KK0001",
    "Description": "Phiếu kiểm kho tháng 1/2023",
    "CreatedDate": "2023-01-15T10:00:00",
    "BranchId": 1
  },
  "StockTakeAddNew": {
    "Id": 0,
    "RetailerId": 1,
    "CreatedBy": 1
  },
  "ItemDetails": [
    {
      "ProductId": 1001,
      "ProductCode": "SP001",
      "ActualCount": 10,
      "SystemCount": 8
    },
    {
      "ProductId": 1002,
      "ProductCode": "SP002",
      "ActualCount": 5,
      "SystemCount": 6
    }
  ],
  "IsAdjust": true,
  "IsExistBatchExpireOrLotSerial": false,
  "CheckPermission": true
}
```

### Trường hợp 2: Phiếu kiểm kho hệ thống
```json
{
  "Entity": {
    "Code": "KK-SYS-001",
    "Description": "Phiếu kiểm kho tự động khi xóa sản phẩm",
    "CreatedDate": "2023-02-10T14:30:00",
    "BranchId": 2
  },
  "StockTakeAddNew": {
    "Id": 0,
    "RetailerId": 1,
    "CreatedBy": 1
  },
  "ItemDetails": [
    {
      "ProductId": 2001,
      "ProductCode": "SP-DEL",
      "ActualCount": 0,
      "SystemCount": 12
    }
  ],
  "IsAdjust": true,
  "IsExistBatchExpireOrLotSerial": false,
  "CheckPermission": false
}
``` 