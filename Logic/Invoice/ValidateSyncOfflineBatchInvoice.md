# Phân tích Business Logic của phương thức ValidateSyncOfflineBatchInvoice

## Tổng quan

- **Mục đích**: Xác thực và kiểm tra tồn kho theo lô cho hóa đơn offline khi đồng bộ lên hệ thống
- **Đầu vào**: Đối tượng hóa đơn (Invoice)
- **Đầu ra**: Void (throw exception nếu có lỗi)

## Quy trình xử lý chi tiết

### 1. Kiểm tra điều kiện tiền đề

```csharp
var isAnyBatchExpireDetail = invoice?.InvoiceDetails?.Any(id => id.ProductBatchExpireId.HasValue) ?? false;
if (isAnyBatchExpireDetail)
{
    // Tiếp tục xử lý
}
```

- Kiểm tra xem hóa đơn có chứa sản phẩm theo lô không
- Nếu không có sản phẩm theo lô, kết thúc xử lý
- Nếu có, tiếp tục các bước kiểm tra tiếp theo

### 2. Thu thập thông tin lô sử dụng

```csharp
var dictBatchUsing = GetDictBatchUsing(invoice);
if (!dictBatchUsing.Any())
{
    return;
}
```

- Gọi phương thức `GetDictBatchUsing` để lấy danh sách các lô được sử dụng trong hóa đơn (xem chi tiết tại [GetDictBatchUsing.md](./GetDictBatchUsing.md))
- Kết quả trả về là một Dictionary chứa:
  + Key: ID của lô sản phẩm
  + Value: Tuple chứa thông tin (Số lượng, Mã sản phẩm, Tên lô, Ngày hết hạn, Trạng thái cập nhật, Tên sản phẩm, Giá trị chuyển đổi)
- Nếu không có lô nào được sử dụng, kết thúc xử lý

### 3. Lấy thông tin tồn kho theo lô

```csharp
var batchIds = dictBatchUsing.Keys.ToList();
var batchIdsParam = string.Join(",", batchIds);
var purchaseDate = DateTime.Now;
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

- Lấy danh sách ID các lô cần kiểm tra
- Gọi stored procedure `pr_GetClosestBatchOnhand` để lấy số lượng tồn kho gần nhất của các lô với các tham số:
  + RetailerId: ID nhà bán lẻ
  + BranchId: ID chi nhánh
  + batchIdsParam: Chuỗi ID các lô, phân cách bởi dấu phẩy
  + BatchGetClosestDocumentTypeParam: Các loại chứng từ cần xét
  + purchaseDate: Ngày mua hàng (lấy thời điểm hiện tại)
  + isUsingWarehoue: Cờ có sử dụng kho hàng hay không
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

### 5. Kiểm tra tồn kho và xử lý lỗi

```csharp
string lstOutStockProducts = GetOutOfStockProduct(dictClosestOnhand, dictBatchUsing);
if (!string.IsNullOrEmpty(lstOutStockProducts))
{
    string errMsg = KVMessage.batchExpire_SyncOutOfStock + ": " + lstOutStockProducts;
    throw new KvValidateInvoiceException(errMsg);
}
```

- Gọi phương thức `GetOutOfStockProduct` để kiểm tra các sản phẩm hết tồn kho (xem chi tiết tại [GetOutOfStockProduct.md](./GetOutOfStockProduct.md))
- Tham số đầu vào:
  + dictClosestOnhand: Dictionary chứa số lượng tồn kho của các lô
  + dictBatchUsing: Dictionary chứa thông tin các lô được sử dụng trong hóa đơn
- Nếu có sản phẩm hết tồn kho:
  + Tạo thông báo lỗi với danh sách sản phẩm hết tồn kho
  + Ném ngoại lệ `KvValidateInvoiceException` với thông báo lỗi

## Các trường hợp đặc biệt

1. **Hóa đơn không có sản phẩm theo lô**:
   - Kết thúc xử lý ngay, không cần kiểm tra thêm
   - Không ném ngoại lệ

2. **Lô chưa có giao dịch**:
   - Lấy số tồn trực tiếp từ bảng `ProductBatchExpireBranches`
   - Đảm bảo không bỏ sót việc kiểm tra tồn kho của bất kỳ lô nào

3. **Sản phẩm hết tồn kho**:
   - Ném ngoại lệ với thông báo chi tiết các sản phẩm hết tồn
   - Ngăn không cho đồng bộ hóa đơn lên hệ thống

## Ý nghĩa nghiệp vụ

- Đảm bảo tính chính xác của dữ liệu khi đồng bộ hóa đơn offline lên hệ thống
- Ngăn chặn việc bán quá số lượng tồn kho thực tế của các lô
- Hỗ trợ quản lý chặt chẽ hàng hóa theo lô/hạn sử dụng
- Đặc biệt quan trọng đối với các mặt hàng như dược phẩm, thực phẩm

## Lưu ý quan trọng

- Phương thức này chỉ xử lý cho hóa đơn offline hoặc omni
- Cần đảm bảo lấy đúng số tồn kho tại thời điểm đồng bộ
- Xử lý riêng cho các lô chưa có giao dịch
- Thông báo lỗi cần rõ ràng để người dùng biết cần xử lý thế nào