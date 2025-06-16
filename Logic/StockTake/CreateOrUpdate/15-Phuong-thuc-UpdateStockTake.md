# Cập nhật phiếu kiểm kho trong UpdateStockTake

## Mục đích
Phương thức `UpdateStockTake` trong lớp `StockTakeService` có nhiệm vụ cập nhật một phiếu kiểm kho đã tồn tại trong cơ sở dữ liệu. Phương thức này thực hiện việc cập nhật thông tin tổng quan của phiếu kiểm kho đồng thời thay thế hoàn toàn các chi tiết cũ bằng chi tiết mới. Đây là một phương thức phức tạp, yêu cầu thực hiện nhiều bước và sử dụng giao dịch để đảm bảo tính nhất quán của dữ liệu.

## Quy trình chính

### 1. Ghi nhận thông tin bắt đầu cập nhật
- Ghi log thông tin cơ bản về hoạt động cập nhật và các thông số quan trọng:
  ```csharp
  Log.Info($"[UPDATE_STOCKTAKE_START] RetailerId: {retailerId}, StockTakeId: {stockTakeId}, UserId: {userId}, IsAdjust: {isAdjust}, IsExistBatchExpireOrLotSerial: {isExistBatchExpireOrLotSerial}");
  ```
- Thông tin log bao gồm: RetailerId, StockTakeId, UserId, trạng thái điều chỉnh (IsAdjust), và trạng thái quản lý lô/hạn sử dụng hoặc serial (IsExistBatchExpireOrLotSerial).

### 2. Xác định phạm vi chi tiết phiếu kiểm kho cũ
- Tìm ID nhỏ nhất và lớn nhất của các chi tiết phiếu kiểm kho hiện tại:
  ```csharp
  var minIdStockTakeDetailOld = stockTakeUpdate.StockTakeDetails.Min(x => x.Id);
  var maxIdStockTakeDetailOld = stockTakeUpdate.StockTakeDetails.Max(x => x.Id);
  
  Log.Info($"[STOCKTAKEDETAIL_OLD] MinId: {minIdStockTakeDetailOld}, MaxId: {maxIdStockTakeDetailOld}");
  ```
- Thông tin này sẽ được sử dụng để xác định phạm vi chi tiết cần xóa sau khi thêm chi tiết mới.

### 3. Chuẩn hóa thông tin phiếu kiểm kho
- Sử dụng `StockTakeNormalize.NormalizeStocTake` để chuẩn hóa thông tin chung của phiếu kiểm kho:
  ```csharp
  StockTakeNormalize.NormalizeStocTake(entity, stockTakeUpdate, AuthService.Context.User.Id, isAdjust, isExistBatchExpireOrLotSerial);
  ```
- Các thông tin được chuẩn hóa bao gồm: mã phiếu, ngày tạo, mô tả, chi nhánh, lịch sử gần đây, ID phiếu gốc, trạng thái, v.v.

### 4. Cập nhật phiếu kiểm kho chính
- Cập nhật thông tin phiếu kiểm kho trong cơ sở dữ liệu:
  ```csharp
  await UpdateAsyncWithEvent(stockTakeUpdate);
  ```
- Phương thức `UpdateAsyncWithEvent` thực hiện cập nhật và phát sự kiện tương ứng.

### 5. Thực hiện giao dịch để cập nhật chi tiết phiếu kiểm kho
- Bắt đầu giao dịch để đảm bảo tính nhất quán khi thực hiện nhiều thao tác:
  ```csharp
  using (var trans = Db.Database.BeginTransaction())
  {
      try
      {
          // Các thao tác cập nhật chi tiết
          trans.Commit();
      }
      catch (Exception ex)
      {
          trans.Rollback();
          throw;
      }
  }
  ```

### 6. Thêm chi tiết phiếu kiểm kho mới
- Thêm các chi tiết mới vào cơ sở dữ liệu:
  ```csharp
  await AddNewStockTakeDetail(itemDetails, stockTakeUpdate.Id, AuthService.Context.RetailerId);
  
  Log.Info($"[ADD_STOCKTAKEDETAIL] Inserted {itemDetails.Count} items for StockTakeId: {stockTakeId}");
  ```
- Phương thức `AddNewStockTakeDetail` thực hiện việc thêm mới các chi tiết.

### 7. Xóa chi tiết phiếu kiểm kho cũ
- Xác định phương thức xóa dựa trên ID của chi tiết mới và cũ:
  ```csharp
  var minIdStockTakeDetailCurrent = itemDetails.Min(x => x.Id);
  var isSmallerComparison = maxIdStockTakeDetailOld < minIdStockTakeDetailCurrent;
  var compareId = isSmallerComparison ? maxIdStockTakeDetailOld : minIdStockTakeDetailOld;
  ```
- Thực hiện xóa các chi tiết cũ:
  ```csharp
  await RemoveStockTakeDetailOld(stockTakeUpdate.Id, compareId, isSmallerComparison);
  
  Log.Info($"[REMOVE_STOCKTAKEDETAIL_OLD_SQL] DELETE FROM StockTakeDetail WHERE StockTakeId = {stockTakeId} AND Id {(isSmallerComparison ? "<=" : ">=")} {compareId}");
  ```
- Phương thức `RemoveStockTakeDetailOld` thực hiện việc xóa các chi tiết cũ dựa trên điều kiện.

### 8. Hoàn thành giao dịch và ghi log kết quả
- Commit giao dịch nếu tất cả các thao tác thành công:
  ```csharp
  trans.Commit();
  
  Log.Info($"[UPDATE_STOCKTAKE_SUCCESS] StockTakeId: {stockTakeId}");
  ```
- Ghi log thông tin kết thúc cập nhật phiếu kiểm kho.

## Phụ thuộc

### Dịch vụ và lớp tiện ích
- **StockTakeNormalize**: Cung cấp phương thức `NormalizeStocTake` để chuẩn hóa thông tin phiếu kiểm kho.
- **UpdateAsyncWithEvent**: Cập nhật thông tin phiếu kiểm kho trong cơ sở dữ liệu và phát sự kiện.
- **AddNewStockTakeDetail**: Thêm chi tiết phiếu kiểm kho mới vào cơ sở dữ liệu.
- **RemoveStockTakeDetailOld**: Xóa chi tiết phiếu kiểm kho cũ từ cơ sở dữ liệu.
- **Log**: Ghi log thông tin quá trình thực hiện.

### Đối tượng dữ liệu
- **StockTake**: Đối tượng phiếu kiểm kho chính.
- **StockTakeDetail**: Đối tượng chi tiết phiếu kiểm kho.

## Xử lý ngoại lệ
- Sử dụng khối `try-catch` để bắt và xử lý các ngoại lệ trong quá trình cập nhật:
  ```csharp
  try
  {
      // Các thao tác cập nhật
  }
  catch (Exception ex)
  {
      trans.Rollback();
      Log.Error($"[UPDATE_STOCKTAKE_ERROR] StockTakeId: {stockTakeId}, Message: {ex.Message}, StackTrace: {ex.StackTrace}");
      throw;
  }
  ```
- Nếu có lỗi xảy ra, giao dịch sẽ được rollback và ngoại lệ được ghi log trước khi ném lại cho lớp gọi.

## Các quy tắc nghiệp vụ

1. **Quy tắc về quản lý giao dịch**:
   - Tất cả các thao tác cập nhật chi tiết phiếu kiểm kho phải được thực hiện trong một giao dịch.
   - Nếu có lỗi xảy ra trong quá trình cập nhật, toàn bộ giao dịch phải được rollback.

2. **Quy tắc về phương pháp cập nhật**:
   - Thay vì cập nhật từng chi tiết, phương thức này thay thế hoàn toàn các chi tiết cũ bằng chi tiết mới.
   - Các chi tiết mới được thêm vào trước, sau đó các chi tiết cũ sẽ bị xóa.

3. **Quy tắc về xác định phạm vi xóa chi tiết cũ**:
   - Nếu ID của chi tiết mới lớn hơn ID lớn nhất của chi tiết cũ, xóa tất cả các chi tiết có ID <= max ID cũ.
   - Nếu ID của chi tiết mới nhỏ hơn ID nhỏ nhất của chi tiết cũ, xóa tất cả các chi tiết có ID >= min ID cũ.

4. **Quy tắc về ghi log**:
   - Ghi log đầy đủ thông tin về quá trình cập nhật, bao gồm cả thông tin bắt đầu, số lượng chi tiết được thêm, SQL xóa chi tiết cũ, và kết quả cập nhật.
   - Nếu có lỗi, ghi log chi tiết về lỗi để phục vụ việc gỡ lỗi.

## Lưu ý quan trọng
1. Phương thức này thực hiện cả việc cập nhật thông tin chung của phiếu kiểm kho và thay thế toàn bộ chi tiết.
2. Việc xử lý ID của chi tiết cũ và mới đóng vai trò quan trọng trong việc xác định phạm vi xóa chi tiết cũ.
3. Giao dịch được sử dụng để đảm bảo tính nhất quán của dữ liệu, tránh trường hợp chi tiết mới được thêm nhưng chi tiết cũ không bị xóa.
4. Ghi log chi tiết giúp theo dõi quá trình thực hiện và phát hiện lỗi nếu có.

## Ví dụ log quá trình thực hiện
```
[UPDATE_STOCKTAKE_START] RetailerId: 1, StockTakeId: 101, UserId: 1, IsAdjust: true, IsExistBatchExpireOrLotSerial: false
[STOCKTAKEDETAIL_OLD] MinId: 1001, MaxId: 1010
[ADD_STOCKTAKEDETAIL] Inserted 5 items for StockTakeId: 101
[REMOVE_STOCKTAKEDETAIL_OLD_SQL] DELETE FROM StockTakeDetail WHERE StockTakeId = 101 AND Id <= 1010
[UPDATE_STOCKTAKE_SUCCESS] StockTakeId: 101
```

## Ví dụ log lỗi
```
[UPDATE_STOCKTAKE_START] RetailerId: 1, StockTakeId: 101, UserId: 1, IsAdjust: true, IsExistBatchExpireOrLotSerial: false
[STOCKTAKEDETAIL_OLD] MinId: 1001, MaxId: 1010
[UPDATE_STOCKTAKE_ERROR] StockTakeId: 101, Message: Duplicate key value violates unique constraint, StackTrace: ...
``` 