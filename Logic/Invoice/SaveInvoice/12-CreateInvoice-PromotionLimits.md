# Phân tích Business Logic của phương thức CreateInvoice

### 11. Kiểm tra giới hạn sử dụng khuyến mãi
- **Mục đích**: Đảm bảo khách hàng không sử dụng một khuyến mãi quá số lần cho phép
- **Điều kiện áp dụng**:
  - Chỉ kiểm tra khi hóa đơn có khuyến mãi (`invoice.InvoicePromotions != null && invoice.InvoicePromotions.Any()`)
  - Chỉ áp dụng cho khách hàng đã đăng ký (`invoice.CustomerId > 0`)
  - Không áp dụng cho khách vãng lai hoặc khách hàng không có ID

- **Quy trình kiểm tra**:
  1. **Lọc khuyến mãi cần kiểm tra**:
     - Hệ thống chỉ xét các khuyến mãi có:
       - Thiết lập giới hạn sử dụng (`LimitPromotionUsage = true`)
       - Chế độ chặn được bật (`LimitPromotionUsageType = (int)EnumLimitPromotionUsageTypes.Blocking`)
     ```csharp
     var listPType = invoice.InvoicePromotions.Where(p => 
         p.LimitPromotionUsage.HasValue && p.LimitPromotionUsage == true &&
         p.LimitPromotionUsageType.HasValue && p.LimitPromotionUsageType == (int)EnumLimitPromotionUsageTypes.Blocking
     ).ToList();
     ```

  2. **Kiểm tra lịch sử sử dụng**:
     - Nếu có khuyến mãi cần kiểm tra, hệ thống truy vấn lịch sử sử dụng của khách hàng:
     ```csharp
     var invPromo = await InvoicePromotionService.GetUsePromotionByCustomer(
         invoice.RetailerId,
         invoice.CustomerId.Value,
         listPType.Select(a => a.PromotionId.Value).ToList()
     );
     ```
     - Hệ thống lọc theo:
       - Cửa hàng hiện tại
       - Khách hàng đang xét
       - Chỉ tính các hóa đơn hợp lệ (không bị hủy hoặc thất bại)
       - Chỉ xét các khuyến mãi trong danh sách cần kiểm tra

  3. **Xử lý vi phạm**:
     - Nếu phát hiện khách hàng đã sử dụng khuyến mãi vượt giới hạn:
     ```csharp
     throw new KvValidateCustomerException(
         string.Format(KVMessage.customerError_promotionBlock, 
         invPromo.Select(p => p.PromotionInfo).Distinct().Join(","))
     );
     ```
     - Thông báo lỗi sẽ hiển thị: "Khách hàng đã được hưởng các khuyến mại: [Tên các khuyến mãi], vui lòng kiểm tra lại." 

## Test Data JSON cho các trường hợp thất bại

### 1. Khách hàng đã sử dụng khuyến mãi vượt quá giới hạn
```json
{
  "Invoice": {
    "RetailerId": 123,
    "CustomerId": 456,
    "InvoicePromotions": [
      {
        "PromotionId": 10,
        "LimitPromotionUsage": true,
        "LimitPromotionUsageType": 1,
        "PromotionInfo": "Giảm giá 50%"
      },
      {
        "PromotionId": 20,
        "LimitPromotionUsage": true,
        "LimitPromotionUsageType": 1,
        "PromotionInfo": "Mua 1 tặng 1"
      }
    ]
  },
  "CustomerPromotionHistory": [
    {
      "CustomerId": 456,
      "PromotionId": 10,
      "PromotionInfo": "Giảm giá 50%",
      "UseCount": 3
    },
    {
      "CustomerId": 456,
      "PromotionId": 20,
      "PromotionInfo": "Mua 1 tặng 1",
      "UseCount": 2
    }
  ],
  "ExpectedError": {
    "Type": "KvValidateCustomerException",
    "Message": "Khách hàng đã được hưởng các khuyến mại: Giảm giá 50%, Mua 1 tặng 1, vui lòng kiểm tra lại."
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi phát hiện khách hàng đã sử dụng các khuyến mãi có giới hạn sử dụng, ngăn chặn việc sử dụng quá mức quy định.

### 2. Bỏ qua kiểm tra với khách vãng lai
```json
{
  "Invoice": {
    "RetailerId": 123,
    "CustomerId": null,
    "InvoicePromotions": [
      {
        "PromotionId": 10,
        "LimitPromotionUsage": true,
        "LimitPromotionUsageType": 1,
        "PromotionInfo": "Giảm giá 50%"
      }
    ]
  },
  "ExpectedResult": {
    "Success": true
  }
}
```
**Kết quả kiểm tra**: Hệ thống bỏ qua kiểm tra giới hạn sử dụng khuyến mãi với khách vãng lai (không có CustomerId), cho phép áp dụng khuyến mãi.

### 3. Bỏ qua kiểm tra với khuyến mãi không có giới hạn hoặc không chặn
```json
{
  "Invoice": {
    "RetailerId": 123,
    "CustomerId": 456,
    "InvoicePromotions": [
      {
        "PromotionId": 10,
        "LimitPromotionUsage": false,
        "PromotionInfo": "Giảm giá 50%"
      },
      {
        "PromotionId": 20,
        "LimitPromotionUsage": true,
        "LimitPromotionUsageType": 2,
        "PromotionInfo": "Mua 1 tặng 1"
      }
    ]
  },
  "ExpectedResult": {
    "Success": true
  }
}
```
**Kết quả kiểm tra**: Hệ thống bỏ qua kiểm tra đối với các khuyến mãi không thiết lập giới hạn sử dụng hoặc không thiết lập chế độ chặn, cho phép áp dụng khuyến mãi bình thường.

---
**Điều hướng**
- Trước đó: [11-CreateInvoice-DeliveryTime.md](./11-CreateInvoice-DeliveryTime.md)
- Tiếp theo: [13-CreateInvoice-Prescription.md](./13-CreateInvoice-Prescription.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 