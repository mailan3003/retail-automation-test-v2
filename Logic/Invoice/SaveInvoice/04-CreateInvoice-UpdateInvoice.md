# Phân tích Business Logic của phương thức CreateInvoice

### 3. Xử lý hóa đơn cập nhật
- **Xác định và đánh dấu hóa đơn cập nhật**:
  - Hệ thống xác định hóa đơn cập nhật dựa trên hai điều kiện:
    - `invoice.UpdateInvoiceId > 0`: Tồn tại ID của hóa đơn gốc cần cập nhật
    - `!string.IsNullOrEmpty(invoice.Code) && invoice.Code.StartsWith(Invoice.UpdatePrefix)`: Mã hóa đơn bắt đầu bằng tiền tố "Update_"
  - Đánh dấu `isUpdateInvoice = true` và điều chỉnh thời gian mua hàng: `invoice.PurchaseDate = invoice.PurchaseDate.AddMilliseconds(10)` để đảm bảo hóa đơn cập nhật luôn có thời gian sau hóa đơn gốc
  - Trích xuất mã hóa đơn gốc từ mã hóa đơn cập nhật (ví dụ: từ "Update_HD001" lấy ra "HD001")
  - Lấy thông tin giao hàng của hóa đơn gốc: `existOldInvoiceDeliveryInfo = await DeliveryInfoService.GetLastByInvoiceIdAsync(invoice.UpdateInvoiceId)`

- **Xử lý thanh toán cho hóa đơn cập nhật**:
  - Nếu có danh sách thanh toán, hệ thống lọc bỏ các thanh toán đã được đánh dấu cập nhật:
    `invoice.Payments = invoice.Payments.Where(p => !p.IsUpdate).ToList()`
  - Điều này giúp tránh tạo bản ghi thanh toán trùng lặp trong quá trình cập nhật

- **Xác thực tính nhất quán giữa hóa đơn gốc và hóa đơn cập nhật**:
  - Hệ thống gọi phương thức `validateWithOldData(invoice, existOldInvoiceDeliveryInfo)` để thực hiện các kiểm tra sau:
  
  - **Kiểm tra thông tin giao hàng**:
    - Nếu hóa đơn gốc có thông tin giao hàng với đối tác vận chuyển mặc định (`UseDefaultPartner == true`)
    - Và trạng thái giao hàng khác Void (`Status != (byte)DeliveryStatus.Void`)
    - Nhưng hóa đơn cập nhật không sử dụng đối tác vận chuyển mặc định (không có thông tin giao hàng hoặc không dùng đối tác mặc định)
    - Trạng thái giao hàng khác "Đã hủy" (DeliveryStatus.Void)
    - Hệ thống sẽ ném ngoại lệ với thông báo "Có thay đổi mới hơn từ server. Bạn cần cập nhật trước khi tạo thay đổi mới"
  
  - **Kiểm tra thay đổi khách hàng**:
    - Hệ thống truy vấn hóa đơn gốc từ database
    - Nếu hóa đơn gốc có khách hàng (`oldInvoice.CustomerId > 0`)
    - Và khách hàng đã thay đổi trong hóa đơn cập nhật (`oldInvoice.CustomerId != invoice.CustomerId`)
    - Và hóa đơn gốc đã có thanh toán (`oldInvoice.TotalPayment > 0`)
    - Hệ thống sẽ ném ngoại lệ KvValidateException với thông báo "Có thay đổi mới hơn từ server" (OverwriteNewerCopyNotAllowed), ngăn việc thay đổi khách hàng khi hóa đơn đã có thanh toán
  
  - **Kiểm tra hóa đơn trả hàng**:
    - Nếu hóa đơn gốc đã hoàn thành (`oldInvoice.Status == (int)InvoiceState.Issued`)
    - Và đã có hóa đơn trả hàng liên kết (`listReturn != null && listReturn.Any() && oldInvoice.Returns.Any()`)
    - Hệ thống sẽ ném ngoại lệ với thông báo "Hóa đơn đã có trả hàng, không thể mở phiếu để cập nhật" 

## Test Data JSON cho các trường hợp thất bại

### 1. Thay đổi thông tin giao hàng của hóa đơn đã có giao hàng
```json
{
  "Invoice": {
    "Id": 10,
    "UpdateInvoiceId": 5,
    "Code": "Update_HD001",
    "DeliveryDetail": {
      "UseDefaultPartner": false
    }
  },
  "ExistOldInvoiceDeliveryInfo": {
    "UseDefaultPartner": true,
    "Status": 1
  },
  "ExpectedError": {
    "Type": "KvValidateException",
    "Message": "Có thay đổi mới hơn từ server. Bạn cần cập nhật trước khi tạo thay đổi mới"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi cố gắng thay đổi thông tin đối tác vận chuyển của hóa đơn đã có giao hàng.

### 2. Thay đổi khách hàng của hóa đơn đã thanh toán
```json
{
  "Invoice": {
    "Id": 10,
    "UpdateInvoiceId": 5,
    "Code": "Update_HD001",
    "CustomerId": 200
  },
  "OldInvoice": {
    "Id": 5,
    "CustomerId": 100,
    "TotalPayment": 500000
  },
  "ExpectedError": {
    "Type": "KvValidateException",
    "Message": "Có thay đổi mới hơn từ server"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi cố gắng thay đổi khách hàng của hóa đơn đã có thanh toán.

### 3. Cập nhật hóa đơn đã có trả hàng
```json
{
  "Invoice": {
    "Id": 10,
    "UpdateInvoiceId": 5,
    "Code": "Update_HD001"
  },
  "OldInvoice": {
    "Id": 5,
    "Status": 3,
    "Returns": [
      { "Id": 1, "Code": "RT001" }
    ]
  },
  "ListReturn": [
    { "Id": 1, "Code": "RT001", "InvoiceId": 5 }
  ],
  "ExpectedError": {
    "Type": "KvValidateException",
    "Message": "Hóa đơn đã có trả hàng, không thể mở phiếu để cập nhật"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi cố gắng cập nhật hóa đơn đã hoàn thành và có trả hàng liên kết.

---
**Điều hướng**
- Trước đó: [03-CreateInvoice-DuplicateInvoice.md](./03-CreateInvoice-DuplicateInvoice.md)
- Tiếp theo: [05-CreateInvoice-VersionConflict.md](./05-CreateInvoice-VersionConflict.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 