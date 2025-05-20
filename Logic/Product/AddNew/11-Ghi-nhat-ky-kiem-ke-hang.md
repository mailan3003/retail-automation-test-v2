# Ghi nhật ký kiểm kê hàng khi thêm sản phẩm mới

## Giới thiệu
Trong quá trình thêm sản phẩm mới, hệ thống có thể cần thực hiện kiểm kê hàng ban đầu để xác định số lượng tồn kho. Việc ghi nhật ký kiểm kê hàng (StockTake Log) giúp theo dõi các thay đổi số lượng sản phẩm ban đầu, tạo cơ sở để đối chiếu khi có sự khác biệt giữa số lượng thực tế và số lượng trong hệ thống. Tài liệu này mô tả quy trình ghi nhật ký kiểm kê hàng khi thêm sản phẩm mới.

## Quy trình ghi nhật ký kiểm kê hàng

### 1. Thu thập thông tin chi tiết kiểm kê

```csharp
if (stock != null)
{
    foreach (var item in stock.StockTakeDetails)
    {
        logStockProductDetail +=
            $"- [ProductCode]{item.Product.Code}[/ProductCode] : {NumberHelper.Normallize(item.ActualCount, EnumCurrency.Quantity)}/{NumberHelper.Normallize(item.SystemCount, EnumCurrency.Quantity)}<br>";
    }
```

- Kiểm tra nếu có thông tin kiểm kê (`stock != null`)
- Duyệt qua từng chi tiết kiểm kê trong danh sách `stock.StockTakeDetails`
- Tạo chuỗi HTML hiển thị thông tin kiểm kê với định dạng:
  - Mã sản phẩm (được đánh dấu đặc biệt với thẻ `[ProductCode]` để có thể kích hoạt tính năng liên kết)
  - Số lượng thực tế / Số lượng trong hệ thống
- Các giá trị số lượng được định dạng theo chuẩn tiền tệ (số lượng) sử dụng `NumberHelper.Normallize`

### 2. Tạo bản ghi nhật ký kiểm kê

```csharp
var logStock = new AuditTrailLog
{
    FunctionId = (int)FunctionType.StockTake,
    Action = (int)AuditTrailAction.Create,
    Content =
        $"{Labels.auditTrailProduct_StockeCreate}: [StockTakeCode]{stock.Code}[/StockTakeCode], " +
        $"{Labels.auditTrailProduct_BlanceCreatedate}: {DateFormat(stock.AdjustmentDate ?? default(DateTime))}" +
        $", {Labels.auditTrail_Include}:<div>{logStockProductDetail}</div>",
    TransGuid = stock.CrudGuid
};
```

- Tạo một đối tượng `AuditTrailLog` mới để ghi nhật ký kiểm kê
- Thiết lập các thuộc tính của nhật ký:
  - `FunctionId`: Loại chức năng là kiểm kê hàng (`FunctionType.StockTake`)
  - `Action`: Loại hành động là tạo mới (`AuditTrailAction.Create`)
  - `Content`: Nội dung nhật ký bao gồm:
    - Mã phiếu kiểm kê (được đánh dấu với thẻ `[StockTakeCode]` để hỗ trợ liên kết)
    - Ngày điều chỉnh, được định dạng bằng phương thức `DateFormat`
    - Chi tiết sản phẩm kiểm kê (sử dụng biến `logStockProductDetail` đã tạo ở bước trước)
  - `TransGuid`: Mã giao dịch duy nhất, sử dụng giá trị `CrudGuid` của phiếu kiểm kê

### 3. Lưu nhật ký vào hệ thống

```csharp
await AuditTrailService.AddLog(logStock);
```

- Gọi phương thức `AddLog` của `AuditTrailService` để lưu nhật ký kiểm kê vào hệ thống
- Phương thức này được gọi bất đồng bộ (async) để không chặn luồng chính của ứng dụng
- Nhật ký sẽ được lưu vào cơ sở dữ liệu và có thể được truy xuất sau này qua chức năng lịch sử thao tác

## Vai trò của nhật ký kiểm kê

Nhật ký kiểm kê có những vai trò quan trọng sau:

1. **Truy xuất nguồn gốc**: Cho phép theo dõi ai đã tạo phiếu kiểm kê và khi nào
2. **Kiểm soát hàng tồn ban đầu**: Ghi lại số lượng khai báo ban đầu của sản phẩm khi thêm vào hệ thống
3. **Đối chiếu sai lệch**: Cung cấp cơ sở đối chiếu khi có sự khác biệt giữa số lượng thực tế và số lượng hệ thống
4. **Tuân thủ quy định**: Hỗ trợ các yêu cầu pháp lý về lưu trữ thông tin kiểm kê hàng hóa
5. **Báo cáo và thống kê**: Cung cấp dữ liệu cho báo cáo kiểm kê và phân tích xu hướng tồn kho

Khi thêm sản phẩm mới vào hệ thống, việc ghi nhật ký kiểm kê là một phần quan trọng trong quy trình đảm bảo tính minh bạch và chính xác của dữ liệu hàng hóa.

---
**Điều hướng**
- Trang tổng quan: [Tổng quan quy trình thêm sản phẩm](./0-Tong-quan-Product-AddMany.md)
- Trước đó: [Xử lý theo ngành hàng](./10-Xu-ly-theo-nganh-hang.md) 