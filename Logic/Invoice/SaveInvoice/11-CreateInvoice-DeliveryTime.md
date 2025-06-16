# Phân tích Business Logic của phương thức CreateInvoice

### 10. Kiểm tra thời gian giao hàng dự kiến
- **Quy trình xác thực thời gian giao hàng**:
  - **Điều kiện kiểm tra**:
    - Hệ thống chỉ kiểm tra khi `isValid = false` (bỏ qua kiểm tra khi đã xác thực ở nơi khác)
    - Hóa đơn có thông tin giao hàng (`invoice.DeliveryDetail != null`)
    - Thời gian giao hàng dự kiến được thiết lập (`invoice.DeliveryDetail.ExpectedDelivery != null`)
    - Thời gian giao hàng dự kiến không hợp lệ (`invoice.DeliveryDetail.ExpectedDelivery <= invoice.PurchaseDate`)
  
  - **Xử lý và thông báo lỗi**:
    - Khi thời gian giao hàng không hợp lệ, hệ thống:
      - Ném ngoại lệ `KvValidateDeliveryInfoException`
      - Hiển thị thông báo: "Thời gian giao hàng phải sau thời gian hóa đơn" (`Labels.cod_invalidExpecteDeliveryInvoice`)
    - Mã nguồn thực hiện:
      ```csharp
      if (!isValid && invoice.DeliveryDetail != null && invoice.DeliveryDetail.ExpectedDelivery != null && 
          invoice.DeliveryDetail.ExpectedDelivery <= invoice.PurchaseDate)
      {
          throw new KvValidateDeliveryInfoException(Labels.cod_invalidExpecteDeliveryInvoice);
      }
      ``` 

## Test Data JSON cho các trường hợp thất bại

### 1. Thời gian giao hàng sớm hơn thời gian hóa đơn
```json
{
  "Invoice": {
    "PurchaseDate": "2023-08-15T14:00:00",
    "DeliveryDetail": {
      "ExpectedDelivery": "2023-08-15T10:00:00"
    }
  },
  "IsValid": false,
  "ExpectedError": {
    "Type": "KvValidateDeliveryInfoException",
    "Message": "Thời gian giao hàng phải sau thời gian hóa đơn"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi thời gian giao hàng dự kiến sớm hơn thời gian tạo hóa đơn.

### 2. Thời gian giao hàng trùng với thời gian hóa đơn
```json
{
  "Invoice": {
    "PurchaseDate": "2023-08-15T14:00:00",
    "DeliveryDetail": {
      "ExpectedDelivery": "2023-08-15T14:00:00"
    }
  },
  "IsValid": false,
  "ExpectedError": {
    "Type": "KvValidateDeliveryInfoException",
    "Message": "Thời gian giao hàng phải sau thời gian hóa đơn"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi thời gian giao hàng dự kiến trùng với thời gian tạo hóa đơn.

### 3. Bỏ qua kiểm tra khi isValid = true
```json
{
  "Invoice": {
    "PurchaseDate": "2023-08-15T14:00:00",
    "DeliveryDetail": {
      "ExpectedDelivery": "2023-08-15T10:00:00"
    }
  },
  "IsValid": true,
  "ExpectedResult": {
    "Success": true
  }
}
```
**Kết quả kiểm tra**: Hệ thống bỏ qua kiểm tra thời gian giao hàng khi isValid = true, cho phép lưu hóa đơn với thời gian giao hàng không hợp lệ.

---
**Điều hướng**
- Trước đó: [10-CreateInvoice-CustomerAndChannel.md](./10-CreateInvoice-CustomerAndChannel.md)
- Tiếp theo: [12-CreateInvoice-PromotionLimits.md](./12-CreateInvoice-PromotionLimits.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 