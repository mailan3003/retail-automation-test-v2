# Phân tích Business Logic của phương thức GetDictBatchUsing

## Tổng quan

- **Mục đích**: Thu thập và tổng hợp thông tin về các lô sản phẩm được sử dụng trong hóa đơn
- **Đầu vào**: Đối tượng hóa đơn (Invoice)
- **Đầu ra**: Dictionary<long, (double Quantity, string ProductCode, string BatchName, DateTime ExpireDate, bool IsUpdate, string ProductName, double ConversionValue)>
  + Key: ID của lô sản phẩm
  + Value: Tuple chứa thông tin chi tiết về lô sản phẩm

## Quy trình xử lý chi tiết

### 1. Thu thập thông tin sản phẩm theo lô

```csharp
var productIds = invoice.InvoiceDetails.Select(d => d.ProductId).Distinct();
var dictBatchProduct = ProductService.GetProductsWithoutPermission()
    .Where(p => p.RetailerId == invoice.RetailerId && productIds.Contains(p.Id) &&
                p.IsBatchExpireControl == true)
    .Select(p => new { p.Id, p.ConversionValue, p.MasterUnitId })
    .ToDictionary(p => p.Id);
```

- Lấy danh sách ID các sản phẩm duy nhất từ chi tiết hóa đơn
- Truy vấn thông tin sản phẩm từ ProductService với các điều kiện:
  + Thuộc cùng nhà bán lẻ với hóa đơn
  + ID sản phẩm nằm trong danh sách đã lấy
  + Sản phẩm có quản lý theo lô (IsBatchExpireControl = true)
- Lưu thông tin sản phẩm vào dictionary với:
  + Key: ID sản phẩm
  + Value: Object chứa (Id, ConversionValue, MasterUnitId)

### 2. Thu thập thông tin lô sản phẩm từ database

```csharp
var batchProductIds = dictBatchProduct.Keys.ToList();
var batchIds = invoice.InvoiceDetails
    .Where(d => batchProductIds.Contains(d.ProductId))
    .Select(d => d.ProductBatchExpireId ?? 0)
    .Distinct()
    .ToList();
var dictDb = Db.ProductBatchExpires
    .Where(pbe => pbe.RetailerId == invoice.RetailerId && batchIds.Contains(pbe.Id))
    .ToDictionary(pbe => pbe.Id, pbe => new { pbe.ProductId, pbe.ExpireDate });
```

- Lấy danh sách ID các lô sản phẩm từ chi tiết hóa đơn
- Truy vấn thông tin lô từ bảng ProductBatchExpires với điều kiện:
  + Thuộc cùng nhà bán lẻ
  + ID lô nằm trong danh sách đã lấy
- Lưu thông tin vào dictionary với:
  + Key: ID lô
  + Value: Object chứa (ProductId, ExpireDate)

### 3. Xử lý từng chi tiết hóa đơn

```csharp
var dictBatchUsing = new Dictionary<long, (double Quantity, string ProductCode, string BatchName, DateTime ExpireDate, bool IsUpdate, string ProductName, double ConversionValue)>();
foreach (var detail in invoice.InvoiceDetails.Where(d => batchProductIds.IndexOf(d.ProductId) != -1))
{
    // Xử lý từng chi tiết
}
```

- Khởi tạo dictionary kết quả
- Duyệt qua các chi tiết hóa đơn có sản phẩm quản lý theo lô

### 4. Kiểm tra điều kiện hợp lệ

```csharp
if (!detail.ProductBatchExpireId.HasValue)
{
    throw new KvValidateInvoiceException(string.Format(KVMessage.batchExpire_EmptyBatch, detail.ProductCode));
}

if (detail.Quantity <= 0)
{
    var batchName = detail.ProductBatchExpire?.BatchName ?? ProductBatchExpireService.GetAll()
                        .Where(be =>
                            be.Id == detail.ProductBatchExpireId && be.RetailerId == invoice.RetailerId)
                        .Select(be => be.FullName).FirstOrDefault();
    throw new KvValidateInvoiceException(string.Format(KVMessage.batchExpire_EmptyQuantity, detail.ProductCode, batchName));
}
```

- Kiểm tra lô sản phẩm phải được chỉ định (ProductBatchExpireId phải có giá trị)
  + Test case 1: ProductBatchExpireId = null -> Throw exception "{ProductCode}: chưa nhập lô cho sản phẩm"
  + Test case 2: ProductBatchExpireId = 0 -> Throw exception "{ProductCode}: chưa nhập lô cho sản phẩm"
  + Test case 3: ProductBatchExpireId = valid value -> Continue

- Kiểm tra số lượng phải lớn hơn 0 (Quantity > 0)
  + Test case 1: Quantity = 0 -> Throw exception "{ProductCode}: chưa nhập số lượng cho Lô {BatchName}"
  + Test case 2: Quantity < 0 -> Throw exception "{ProductCode}: chưa nhập số lượng cho Lô {BatchName}"
  + Test case 3: Quantity > 0 -> Continue
  + BatchName được lấy theo thứ tự:
    1. Từ ProductBatchExpire.BatchName nếu có
    2. Nếu không, query từ database với điều kiện Id = ProductBatchExpireId và RetailerId = invoice.RetailerId

- Các ngoại lệ được ném ra dưới dạng KvValidateInvoiceException

### 5. Xác thực lô sản phẩm

```csharp
if (AppServiceConfigInfo.UseCheckProductBatchExpireWithProductId)
{
    var pbeProductId = dictBatchProduct[detail.ProductId].MasterUnitId;
    if (pbeProductId == null || pbeProductId <= 0) pbeProductId = detail.ProductId;
    if (curPbe == null || curPbe.ProductId != pbeProductId)
    {
        var batchName = detail.ProductBatchExpire?.BatchName ?? ProductBatchExpireService.GetAll()
                            .Where(be =>
                                be.Id == detail.ProductBatchExpireId && be.RetailerId == invoice.RetailerId)
                            .Select(be => be.FullName).FirstOrDefault();

        throw new KvValidateInvoiceException($"Hàng hóa {detail.ProductCode} - lô {batchName} không tồn tại.");
    }
}
```

- Nếu cấu hình UseCheckProductBatchExpireWithProductId được bật:
  + Lấy ID sản phẩm gốc (MasterUnitId hoặc ProductId)
  + Kiểm tra lô sản phẩm phải tồn tại và thuộc về sản phẩm gốc
  + Nếu không thỏa mãn, ném ngoại lệ

### 6. Tổng hợp thông tin lô sản phẩm

```csharp
var quantityByMaster = detail.Quantity * dictBatchProduct[detail.ProductId].ConversionValue;
var conversionValue = dictBatchProduct[detail.ProductId].ConversionValue;
var expireDate = curPbe?.ExpireDate ?? default(DateTime);
if (!dictBatchUsing.ContainsKey(detailBatchId))
{
    dictBatchUsing[detailBatchId] = (quantityByMaster, detail.ProductCode, detail.ProductBatchExpire?.BatchName, expireDate, detail.IsUpdate, detail.ProductName, conversionValue);
}
else
{
    var quantity = dictBatchUsing[detailBatchId].Quantity + quantityByMaster;
    dictBatchUsing[detailBatchId] = (quantity, detail.ProductCode, detail.ProductBatchExpire?.BatchName, expireDate, detail.IsUpdate, detail.ProductName, conversionValue);
}
```

- Tính toán số lượng theo đơn vị gốc
- Nếu lô chưa có trong dictionary kết quả:
  + Thêm mới với thông tin đầy đủ
- Nếu lô đã có trong dictionary:
  + Cộng dồn số lượng
  + Cập nhật lại thông tin

## Các trường hợp đặc biệt

1. **Sản phẩm không có lô**:
   - Ném ngoại lệ với thông báo "Chưa chọn lô cho sản phẩm {mã_sản_phẩm}"

2. **Số lượng không hợp lệ**:
   - Ném ngoại lệ với thông báo "Số lượng sản phẩm {mã_sản_phẩm} - lô {tên_lô} phải lớn hơn 0"

3. **Lô không tồn tại hoặc không thuộc sản phẩm**:
   - Ném ngoại lệ với thông báo "Hàng hóa {mã_sản_phẩm} - lô {tên_lô} không tồn tại"

4. **Sản phẩm có nhiều chi tiết cùng lô**:
   - Tổng hợp số lượng của các chi tiết
   - Giữ nguyên các thông tin khác của lô

## Ý nghĩa nghiệp vụ

- Đảm bảo tính chính xác của thông tin lô sản phẩm trong hóa đơn
- Tổng hợp số lượng theo lô để phục vụ kiểm tra tồn kho
- Chuẩn hóa số lượng về đơn vị gốc để tính toán chính xác
- Ngăn chặn các lỗi về lô sản phẩm ngay từ đầu

## Lưu ý quan trọng

- Phương thức này là bước tiền xử lý quan trọng cho việc kiểm tra tồn kho theo lô
- Cần đảm bảo lấy đúng thông tin sản phẩm gốc khi kiểm tra lô
- Xử lý cẩn thận việc tổng hợp số lượng khi có nhiều chi tiết cùng lô
- Thông báo lỗi cần rõ ràng để người dùng dễ dàng xử lý

---
**Điều hướng**
- Quay lại: [19-4-MakeInvoice-BatchProcessing.md](./19-4-MakeInvoice-BatchProcessing.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 