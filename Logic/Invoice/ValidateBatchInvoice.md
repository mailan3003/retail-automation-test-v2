# Phân tích Business Logic của phương thức ValidateBatchInvoice

## Tổng quan

- **Mục đích**: Xác thực và kiểm tra tính hợp lệ của các lô sản phẩm trong hóa đơn thông thường
- **Đầu vào**: 
  + invoice: Đối tượng hóa đơn cần xác thực
  + oldInvoiceTime: Thời gian của hóa đơn cũ (nếu đang cập nhật)
  + oldBatchIds: Mảng ID các lô sản phẩm cũ (nếu đang cập nhật)
  + fromCombine: Cờ đánh dấu hóa đơn được tạo từ việc kết hợp nhiều hóa đơn
- **Đầu ra**: Void (throw exception nếu có lỗi)

## Quy trình xử lý chi tiết

### 1. Kiểm tra điều kiện tiền đề

```csharp
var isUsingWarehouse = await WarehouseService.IsActiveWarehouseToggle();
var isAnyBatchExpireDetail = invoice?.InvoiceDetails?.Any(id=>id.ProductBatchExpireId.HasValue) ?? false;
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

### 3. Xác định thời gian mua hàng

```csharp
var batchIds = dictBatchUsing.Keys.ToList();
var (purchaseDate, oldPurchaseDate) = ExtractInvoicePurchaseDate(invoice, oldInvoiceTime);
```

- Lấy danh sách ID các lô cần kiểm tra
- Xác định thời gian mua hàng của hóa đơn hiện tại và hóa đơn cũ (nếu có)

### 4. Kiểm tra tồn kho theo thời gian

```csharp
if (purchaseDate > oldPurchaseDate)
{
    await ValidateBatchInvoiceLimitByStocktake(invoice, batchIds, purchaseDate, oldPurchaseDate);
}
else
{
    await ValidateBatchInvoiceLimitByPositiveTrans(invoice, batchIds, purchaseDate, oldPurchaseDate, oldBatchIds);
}
```

- Nếu thời gian mua hàng mới > thời gian mua hàng cũ:
  + Gọi `ValidateBatchInvoiceLimitByStocktake` để kiểm tra tồn kho theo kiểm kê (xem chi tiết tại [ValidateBatchInvoiceLimitByStocktake.md](./ValidateBatchInvoiceLimitByStocktake.md))
- Nếu thời gian mua hàng mới <= thời gian mua hàng cũ:
  + Gọi `ValidateBatchInvoiceLimitByPositiveTrans` để kiểm tra tồn kho theo giao dịch dương (xem chi tiết tại [ValidateBatchInvoiceLimitByPositiveTrans.md](./ValidateBatchInvoiceLimitByPositiveTrans.md))

### 5. Kiểm tra hết tồn kho cho hóa đơn mới

```csharp
if (invoice.Id <= 0 && !fromCombine)
{
    await ValidateBatchInvoiceProductOutStock(invoice, dictBatchUsing, purchaseDate, oldPurchaseDate);
}
```

- Chỉ kiểm tra cho hóa đơn mới (Id <= 0) và không phải hóa đơn kết hợp
- Gọi `ValidateBatchInvoiceProductOutStock` để kiểm tra các sản phẩm hết tồn kho (xem chi tiết tại [ValidateBatchInvoiceProductOutStock.md](./ValidateBatchInvoiceProductOutStock.md))

## Các phương thức con

### 1. ValidateBatchInvoiceLimitByStocktake

- **Mục đích**: Kiểm tra tồn kho theo kiểm kê cho các lô sản phẩm
- **Đầu vào**:
  + invoice: Hóa đơn cần kiểm tra
  + batchIds: Danh sách ID các lô cần kiểm tra
  + purchaseDate: Thời gian mua hàng mới
  + oldPurchaseDate: Thời gian mua hàng cũ
- **Xử lý**:
  + Lấy số tồn kho từ bảng kiểm kê
  + Kiểm tra số lượng tồn kho có đủ cho hóa đơn không
  + Ném ngoại lệ nếu không đủ tồn kho

### 2. ValidateBatchInvoiceLimitByPositiveTrans

- **Mục đích**: Kiểm tra tồn kho theo giao dịch dương cho các lô sản phẩm
- **Đầu vào**:
  + invoice: Hóa đơn cần kiểm tra
  + batchIds: Danh sách ID các lô cần kiểm tra
  + purchaseDate: Thời gian mua hàng mới
  + oldPurchaseDate: Thời gian mua hàng cũ
  + oldBatchIds: Danh sách ID các lô cũ
- **Xử lý**:
  + Lấy số tồn kho từ các giao dịch dương
  + Kiểm tra số lượng tồn kho có đủ cho hóa đơn không
  + Xử lý đặc biệt cho các lô cũ
  + Ném ngoại lệ nếu không đủ tồn kho

### 3. ValidateBatchInvoiceProductOutStock

- **Mục đích**: Kiểm tra các sản phẩm hết tồn kho trong hóa đơn
- **Đầu vào**:
  + invoice: Hóa đơn cần kiểm tra
  + dictBatchUsing: Dictionary chứa thông tin các lô đang sử dụng
  + purchaseDate: Thời gian mua hàng mới
  + oldPurchaseDate: Thời gian mua hàng cũ
- **Xử lý**:
  + Lấy số tồn kho hiện tại của các lô
  + Kiểm tra số lượng tồn kho có đủ cho hóa đơn không
  + Ném ngoại lệ nếu có sản phẩm hết tồn kho

## Các trường hợp đặc biệt

1. **Hóa đơn không có sản phẩm theo lô**:
   - Kết thúc xử lý ngay, không cần kiểm tra thêm
   - Không ném ngoại lệ

2. **Hóa đơn kết hợp**:
   - Bỏ qua kiểm tra hết tồn kho
   - Vẫn thực hiện các kiểm tra tồn kho khác

3. **Cập nhật hóa đơn**:
   - Xử lý đặc biệt cho các lô cũ
   - Kiểm tra tồn kho dựa trên thời gian mua hàng

4. **Thời gian mua hàng**:
   - Nếu thời gian mới > thời gian cũ: Kiểm tra theo kiểm kê
   - Nếu thời gian mới <= thời gian cũ: Kiểm tra theo giao dịch dương

## Ý nghĩa nghiệp vụ

- Đảm bảo tính chính xác của việc quản lý hàng hóa theo lô/hạn sử dụng
- Ngăn chặn việc bán sản phẩm đã hết hạn hoặc không còn tồn kho trong lô
- Hỗ trợ tuân thủ quy định về truy xuất nguồn gốc sản phẩm
- Đảm bảo nguyên tắc FIFO (First In First Out) trong quản lý hàng tồn kho
- Đặc biệt quan trọng đối với các ngành như dược phẩm, thực phẩm, hàng có hạn sử dụng

## Lưu ý quan trọng

- Phương thức này xử lý cho hóa đơn thông thường (không phải hóa đơn offline)
- Cần đảm bảo lấy đúng số tồn kho tại thời điểm xác thực
- Xử lý riêng cho các lô chưa có giao dịch
- Thông báo lỗi cần rõ ràng để người dùng biết cần xử lý thế nào
- Cần xử lý đặc biệt khi cập nhật hóa đơn có thay đổi lô sản phẩm