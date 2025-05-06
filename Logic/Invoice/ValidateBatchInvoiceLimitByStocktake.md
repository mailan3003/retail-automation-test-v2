# Phân tích Business Logic của phương thức ValidateBatchInvoiceLimitByStocktake

## Tổng quan

- **Mục đích**: Kiểm tra tồn kho theo kiểm kê cho các lô sản phẩm trong hóa đơn
- **Đầu vào**: 
  + invoice: Đối tượng hóa đơn cần kiểm tra
  + batchIds: Danh sách ID các lô cần kiểm tra
  + purchaseDate: Thời gian mua hàng mới
  + oldPurchaseDate: Thời gian mua hàng cũ
- **Đầu ra**: Void (throw exception nếu có lỗi)

## Quy trình xử lý chi tiết

### 1. Lấy thông tin kiểm kê

```csharp
var stocktake = await Db.Stocktakes
    .Where(s => s.RetailerId == invoice.RetailerId && 
                s.BranchId == invoice.BranchId &&
                s.Status == (int)StocktakeState.Finalized &&
                s.StocktakeDate <= purchaseDate)
    .OrderByDescending(s => s.StocktakeDate)
    .FirstOrDefaultAsync();
```

- Truy vấn thông tin kiểm kê gần nhất với các điều kiện:
  + Thuộc cùng nhà bán lẻ và chi nhánh với hóa đơn
  + Đã hoàn thành (Status = Finalized)
  + Thời gian kiểm kê <= thời gian mua hàng mới
- Sắp xếp theo thời gian kiểm kê giảm dần và lấy bản ghi đầu tiên

### 2. Lấy số tồn kho từ kiểm kê

```csharp
var stocktakeDetails = await Db.StocktakeDetails
    .Where(sd => sd.StocktakeId == stocktake.Id &&
                 batchIds.Contains(sd.ProductBatchExpireId ?? 0))
    .ToDictionaryAsync(sd => sd.ProductBatchExpireId ?? 0, sd => sd.EndingStocks);
```

- Truy vấn chi tiết kiểm kê cho các lô cần kiểm tra
- Chuyển kết quả thành Dictionary với:
  + Key: ID lô sản phẩm
  + Value: Số lượng tồn kho cuối kỳ

### 3. Lấy số tồn kho từ giao dịch

```csharp
var batchIdsParam = string.Join(",", batchIds);
var isUsingWarehoue = await WarehouseService.IsActiveWarehouseToggle();
var dictClosestOnhand = Db.pr_GetClosestBatchOnhand(
    invoice.RetailerId, 
    invoice.BranchId, 
    batchIdsParam,
    BatchGetClosestDocumentTypeParam, 
    purchaseDate, 
    isUsingWarehoue
).ToDictionary(r => r.ProductBatchExpireId, r => r.EndingStocks);
```

- Gọi stored procedure `pr_GetClosestBatchOnhand` để lấy số lượng tồn kho gần nhất của các lô
- Kết quả được chuyển thành Dictionary với:
  + Key: ID lô sản phẩm
  + Value: Số lượng tồn kho

### 4. Xử lý các lô chưa có giao dịch

```csharp
var batchWithoutTransAfterIds = batchIds.Where(bId => !dictClosestOnhand.ContainsKey(bId)).ToList();
if (batchWithoutTransAfterIds.Any())
{
    var remains = Db.ProductBatchExpireBranches
        .Where(pbeb =>
            pbeb.RetailerId == invoice.RetailerId && 
            pbeb.BranchId == invoice.BranchId &&
            batchWithoutTransAfterIds.Contains(pbeb.ProductBatchExpireId))
        .Select(pbeb => new { pbeb.ProductBatchExpireId, pbeb.OnHand });
    foreach (var itm in remains)
    {
        dictClosestOnhand[itm.ProductBatchExpireId] = itm.OnHand;
    }
}
```

- Lọc ra các lô chưa có trong kết quả tồn kho (chưa có giao dịch)
- Với những lô này, truy vấn trực tiếp số tồn từ bảng `ProductBatchExpireBranches`
- Bổ sung thông tin tồn kho của các lô này vào dictionary tồn kho

### 5. Kiểm tra tồn kho

```csharp
var dictBatchUsing = GetDictBatchUsing(invoice);
string lstOutStockProducts = GetOutOfStockProduct(dictClosestOnhand, dictBatchUsing);
if (!string.IsNullOrEmpty(lstOutStockProducts))
{
    throw new KvValidateInvoiceException(KVMessage.batchExpire_OutOfStock + ": " + lstOutStockProducts);
}
```

- Gọi phương thức `GetDictBatchUsing` để lấy thông tin các lô đang sử dụng
- Gọi phương thức `GetOutOfStockProduct` để kiểm tra các sản phẩm hết tồn kho
- Nếu có sản phẩm hết tồn kho:
  + Tạo thông báo lỗi với danh sách sản phẩm hết tồn kho
  + Ném ngoại lệ `KvValidateInvoiceException`

## Các trường hợp đặc biệt

1. **Không có kiểm kê**:
   - Nếu không tìm thấy kiểm kê nào, sử dụng số tồn kho từ giao dịch
   - Không ném ngoại lệ

2. **Lô chưa có giao dịch**:
   - Lấy số tồn trực tiếp từ bảng `ProductBatchExpireBranches`
   - Đảm bảo không bỏ sót việc kiểm tra tồn kho của bất kỳ lô nào

3. **Sản phẩm hết tồn kho**:
   - Ném ngoại lệ với thông báo chi tiết các sản phẩm hết tồn
   - Ngăn không cho tạo/cập nhật hóa đơn

## Ý nghĩa nghiệp vụ

- Đảm bảo tính chính xác của việc quản lý hàng hóa theo lô/hạn sử dụng
- Ngăn chặn việc bán sản phẩm đã hết hạn hoặc không còn tồn kho trong lô
- Hỗ trợ tuân thủ quy định về truy xuất nguồn gốc sản phẩm
- Đảm bảo nguyên tắc FIFO (First In First Out) trong quản lý hàng tồn kho
- Đặc biệt quan trọng đối với các ngành như dược phẩm, thực phẩm, hàng có hạn sử dụng

## Lưu ý quan trọng

- Phương thức này xử lý cho hóa đơn có thời gian mua hàng mới > thời gian mua hàng cũ
- Cần đảm bảo lấy đúng số tồn kho tại thời điểm xác thực
- Xử lý riêng cho các lô chưa có giao dịch
- Thông báo lỗi cần rõ ràng để người dùng biết cần xử lý thế nào

---
**Điều hướng**
- Quay lại: [19-4-4-MakeInvoice-ValidateBatchInvoice.md](./19-4-4-MakeInvoice-ValidateBatchInvoice.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 