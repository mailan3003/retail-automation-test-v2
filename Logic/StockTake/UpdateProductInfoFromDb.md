# Phương thức UpdateProductInfoFromDb

## Mục đích
Phương thức này cập nhật thông tin sản phẩm trong chi tiết phiếu kiểm kho dựa trên dữ liệu từ cơ sở dữ liệu. Nó đảm bảo rằng các chi tiết kiểm kê được làm giàu với thông tin chính xác về sản phẩm như giá trị quy đổi, đơn vị chính, thông tin về lô/hạn sử dụng và quản lý số serial.

## Quy trình
1. Khởi tạo danh sách để theo dõi các mã sản phẩm có lỗi
2. Duyệt qua từng chi tiết trong danh sách kiểm kê
3. Tìm thông tin sản phẩm tương ứng từ danh sách cơ sở dữ liệu
4. Kiểm tra sản phẩm có tồn tại không:
   - Nếu không tìm thấy sản phẩm trong danh sách từ cơ sở dữ liệu (productInfo == null)
   - Lấy tên sản phẩm từ chi tiết kiểm kê, nếu không có thì sử dụng ID sản phẩm
   - Ném ngoại lệ KvValidateProductException với thông báo "Sản phẩm {0} không tồn tại" được định dạng với tên sản phẩm
   - Ngoại lệ này sẽ dừng quá trình cập nhật và thông báo cho người dùng biết sản phẩm không hợp lệ
5. Cập nhật các thông tin sản phẩm cho chi tiết kiểm kê:
   - Giá trị quy đổi (ConversionValue)
   - ID đơn vị chính (MasterUnitId)
   - Cờ kiểm soát lô/hạn sử dụng (IsBatchExpireControl)
   - Cờ kiểm soát số serial (IsLotSerialControl)
   - Mã sản phẩm (ProductCode) nếu chưa có
6. Kiểm tra tính hợp lệ của số serial và lô hạn sử dụng
7. Nếu có sự không phù hợp giữa cấu hình sản phẩm và dữ liệu nhập vào, thêm mã sản phẩm vào danh sách lỗi. Cụ thể:
   - Nếu sản phẩm không được cấu hình quản lý số serial (IsLotSerialControl = false) nhưng có nhập số serial
   - Hoặc nếu sản phẩm không được cấu hình quản lý lô/hạn sử dụng (IsBatchExpireControl = false) nhưng có nhập thông tin lô/hạn sử dụng
   - Mã sản phẩm sẽ được thêm vào danh sách lỗi nếu chưa tồn tại trong danh sách
8. Cuối cùng, nếu có lỗi, ném ngoại lệ với thông báo tương ứng

## Tham số
- `itemDetails` (List<StockTakeDetail>): Danh sách chi tiết phiếu kiểm kho cần cập nhật thông tin
- `listProductFromDb` (List<ProductStockStakeInfo>): Danh sách thông tin sản phẩm từ cơ sở dữ liệu

## Xử lý ngoại lệ
- Ném ngoại lệ `KvValidateProductException` với thông báo "Sản phẩm {0} không tồn tại" nếu không tìm thấy sản phẩm
- Ném ngoại lệ `KvValidatePurchaseOrderException` với thông báo tùy thuộc vào số lượng sản phẩm không hợp lệ:
  - Nếu chỉ có một sản phẩm: "Hàng hoá {0} đã cập nhật trong quá trình tạo phiếu. Hãy kiểm tra lại thông tin."
  - Nếu có nhiều sản phẩm: "Hàng hoá {0} đã cập nhật trong quá trình tạo phiếu. Hãy kiểm tra lại thông tin."

## Mã nguồn

```csharp
public void UpdateProductInfoFromDb(List<StockTakeDetail> itemDetails, List<ProductStockStakeInfo> listProductFromDb)
{
    var errorProductCode = new List<string>();
    foreach (var detail in itemDetails)
    {
        var productInfo = listProductFromDb.FirstOrDefault(p => p.Id == detail.ProductId);
        if (productInfo == null)
        {
            var productName = string.IsNullOrEmpty(detail.ProductName) ? detail.ProductId.ToString(CultureInfo.InvariantCulture) : detail.ProductName;
            throw new KvValidateProductException(string.Format(KVMessage.Product_Not_Exists, productName));
        }
        detail.ConversionValue = productInfo.ConversionValue;
        detail.MasterUnitId = productInfo.MasterUnitId;
        detail.IsBatchExpireControl = productInfo.IsBatchExpireControl;
        detail.IsLotSerialControl = productInfo.IsLotSerialControl;
        if (string.IsNullOrEmpty(detail.ProductCode))
        {
            detail.ProductCode = productInfo.Code;
        }

        if (((productInfo.IsLotSerialControl != true && !string.IsNullOrWhiteSpace(detail.SerialNumbers)) || (productInfo.IsBatchExpireControl != true && detail.ProductBatchExpireActualList != null))
            && !errorProductCode.Contains(detail.ProductCode))
        {
            errorProductCode.Add(detail.ProductCode);
        }
    }
    if (errorProductCode.Any())
    {
        string errorProductCodes = errorProductCode.Count > 1 ? string.Join(", ", errorProductCode) : errorProductCode[0];
        var errorMessage = errorProductCode.Count < 2 ? string.Format(KVMessage.HasInvalidSerialCode, errorProductCodes) : string.Format(KVMessage.HaveInvalidSerialCode, errorProductCodes);
        throw new KvValidatePurchaseOrderException(errorMessage);
    }
}
```

## Dữ liệu kiểm thử

### Tình huống 1: Cập nhật thông tin sản phẩm thành công
- itemDetails: 3 sản phẩm với ProductId 1, 2, 3
- listProductFromDb: 3 ProductStockStakeInfo tương ứng với thông tin đầy đủ
- Kết quả: Chi tiết kiểm kê được cập nhật với thông tin sản phẩm chính xác, không có ngoại lệ

### Tình huống 2: Sản phẩm không tồn tại
- itemDetails: 1 chi tiết với ProductId 1 và ProductName "Sản phẩm test"
- listProductFromDb: Không có sản phẩm nào
- Kết quả: Ném ngoại lệ KvValidateProductException với thông báo "Sản phẩm Sản phẩm test không tồn tại"

### Tình huống 3: Thiết lập số serial/lô không phù hợp
- itemDetails: 2 chi tiết với SerialNumbers đã thiết lập nhưng sản phẩm không được cấu hình quản lý serial (IsLotSerialControl = false)
- listProductFromDb: 2 sản phẩm tương ứng
- Kết quả: Ném ngoại lệ KvValidatePurchaseOrderException với thông báo "Hàng hoá [mã sản phẩm] đã cập nhật trong quá trình tạo phiếu. Hãy kiểm tra lại thông tin." 