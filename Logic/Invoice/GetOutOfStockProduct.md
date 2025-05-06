# Phân tích Business Logic của phương thức GetOutOfStockProduct

## Tổng quan

- **Mục đích**: Kiểm tra và trả về danh sách các sản phẩm theo lô đã hết tồn kho hoặc không đủ số lượng
- **Đầu vào**: 
  + dictClosestOnhand: Dictionary<long, double> - Chứa số lượng tồn kho của các lô
  + dictBatchUsing: Dictionary<long, (double Quantity, string ProductCode, string BatchName, DateTime ExpireDate, bool IsUpdate, string ProductName, double ConversionValue)> - Chứa thông tin các lô đang sử dụng
- **Đầu ra**: string - Chuỗi chứa danh sách các sản phẩm hết tồn kho, phân cách bằng dấu phẩy

## Quy trình xử lý chi tiết

### 1. Tìm các lô hết tồn kho

```csharp
var lstOutOfStock = dictBatchUsing.Where(k =>
{
    dictClosestOnhand.TryGetValue(k.Key, out var onHand);
    return k.Value.Quantity > onHand + (KVConst.ToleranceOnHand * k.Value.ConversionValue);
}).ToList();
```

- Duyệt qua từng lô trong dictBatchUsing
- Với mỗi lô:
  + Lấy số lượng tồn kho từ dictClosestOnhand
  + Tính toán số lượng tồn kho cho phép = số tồn + (dung sai * hệ số chuyển đổi)
  + So sánh với số lượng cần sử dụng
  + Nếu số lượng cần > số lượng cho phép, thêm vào danh sách hết tồn
- Lưu ý:
  + Sử dụng TryGetValue để tránh lỗi khi lô không có trong dictClosestOnhand
  + Có tính đến dung sai tồn kho (ToleranceOnHand) và hệ số chuyển đổi đơn vị

### 2. Tạo chuỗi kết quả

```csharp
string productNames = String.Empty;
if (lstOutOfStock != null && lstOutOfStock.Count > 0)
{
    var lstNames = lstOutOfStock.Select(p => p.Value.ProductCode + " " + p.Value.ProductName).ToList();
    productNames = String.Join(",", lstNames);
}
```

- Nếu có sản phẩm hết tồn:
  + Tạo danh sách tên sản phẩm theo format: "{mã_sản_phẩm} {tên_sản_phẩm}"
  + Nối các tên bằng dấu phẩy
- Nếu không có sản phẩm hết tồn:
  + Trả về chuỗi rỗng

## Các trường hợp đặc biệt

1. **Lô không có trong dictClosestOnhand**:
   - TryGetValue trả về 0 cho onHand
   - Lô sẽ được coi là hết tồn kho

2. **Số lượng tồn bằng số lượng cần**:
   - Không được coi là hết tồn kho
   - Cho phép bán hết số lượng tồn

3. **Có dung sai tồn kho**:
   - Số lượng cho phép = số tồn + (dung sai * hệ số chuyển đổi)
   - Giúp xử lý các trường hợp chênh lệch nhỏ về số lượng

4. **Nhiều lô cùng sản phẩm hết tồn**:
   - Sản phẩm chỉ xuất hiện một lần trong kết quả
   - Tên sản phẩm không bao gồm thông tin lô

## Ý nghĩa nghiệp vụ

- Đảm bảo không bán quá số lượng tồn kho thực tế
- Cung cấp thông tin rõ ràng về các sản phẩm không đủ số lượng
- Hỗ trợ kiểm soát tồn kho chặt chẽ theo lô
- Cho phép dung sai nhỏ trong quản lý tồn kho

## Lưu ý quan trọng

- Phương thức này là một phần của quy trình kiểm tra tồn kho theo lô
- Kết quả được sử dụng để thông báo lỗi cho người dùng
- Cần đảm bảo thông tin sản phẩm trong kết quả dễ đọc và đầy đủ
- Có tính đến các yếu tố như dung sai và hệ số chuyển đổi đơn vị

---
**Điều hướng**
- Quay lại: [19-4-MakeInvoice-BatchProcessing.md](./19-4-MakeInvoice-BatchProcessing.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 