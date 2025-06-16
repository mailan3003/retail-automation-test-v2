# Phân tích Business Logic của phương thức CreateInvoice

### 5. Kiểm tra khuyến mãi
- **Quy trình xác thực khuyến mãi**:
  - Hệ thống kiểm tra danh sách khuyến mãi trong hóa đơn: `invoice.InvoicePromotions != null && invoice.InvoicePromotions.Any()`
  - Chỉ xử lý các khuyến mãi mới (chưa có Id): `newPromotions = invoice.InvoicePromotions.Where(p => p.Id == 0 && p.PromotionId != null).ToList()`
  - Nếu có khuyến mãi mới, hệ thống sẽ tiến hành kiểm tra tính hợp lệ

- **Quy trình xác minh trạng thái khuyến mãi**:
  - Trích xuất danh sách ID khuyến mãi: `promotionIds = newPromotions.Select(p => (long)p.PromotionId).ToList()`
  - Kiểm tra với hệ thống khuyến mãi: `validateResult = await KvPromotionService.CheckIsDeletedCampaignByIds(promotionIds)`
    - API khuyến mãi sẽ kiểm tra danh sách ID khuyến mãi với cơ sở dữ liệu
    - Trả về danh sách ID hợp lệ (ValidIdList) và danh sách ID đã bị xóa (DeletedIdList)
    - Một ID được coi là hợp lệ nếu tìm thấy chiến dịch khuyến mãi tương ứng trong cơ sở dữ liệu
    - Một ID được coi là đã bị xóa nếu không tìm thấy chiến dịch khuyến mãi tương ứng
  - Xác định các khuyến mãi đã bị xóa: `deletedPromotions = newPromotions.Where(p => validateResult.DeletedIdList.Contains((long)p.PromotionId)).ToList()`

- **Xử lý thông báo lỗi khuyến mãi**:
  - Khi phát hiện khuyến mãi đã bị xóa, hệ thống sẽ:
    - Trích xuất tên khuyến mãi từ thông tin chi tiết (lấy phần trước dấu ":")
    - Tổng hợp danh sách tên khuyến mãi không hợp lệ: `deletedPromotionNamesString = string.Join(", ", deletedPromotionNames)`
    - Hiển thị thông báo lỗi rõ ràng cho người dùng: `throw new KvValidateException(string.Format(KVMessage.PromotionsAreDeletedNotification, deletedPromotionNamesString))` với nội dung "Chương trình khuyến mại {0} ngừng hoạt động, vui lòng áp dụng khuyến mại khác!"

- **Lợi ích của cơ chế kiểm tra khuyến mãi**:
  - Đảm bảo tính nhất quán trong chính sách khuyến mãi
  - Ngăn chặn việc áp dụng khuyến mãi đã hết hạn hoặc bị hủy
  - Cung cấp thông báo chi tiết giúp người dùng hiểu rõ vấn đề
  - Tăng tính minh bạch trong quá trình xử lý hóa đơn 

## Test Data JSON cho các trường hợp thất bại

### 1. Áp dụng khuyến mãi đã bị xóa
```json
{
  "Invoice": {
    "InvoicePromotions": [
      {
        "Id": 0,
        "PromotionId": 123,
        "Name": "Giảm giá 50%: CT001",
        "Value": 25000
      },
      {
        "Id": 0,
        "PromotionId": 456,
        "Name": "Tặng quà: CT002",
        "Value": 0
      }
    ]
  },
  "KvPromotionServiceResult": {
    "ValidIdList": [],
    "DeletedIdList": [123, 456]
  },
  "ExpectedError": {
    "Type": "KvValidateException",
    "Message": "Chương trình khuyến mại Giảm giá 50%, Tặng quà ngừng hoạt động, vui lòng áp dụng khuyến mại khác!"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi phát hiện các chương trình khuyến mãi đã bị xóa hoặc ngừng hoạt động.

### 2. Áp dụng khuyến mãi đã bị xóa và khuyến mãi còn hiệu lực
```json
{
  "Invoice": {
    "InvoicePromotions": [
      {
        "Id": 0,
        "PromotionId": 123,
        "Name": "Giảm giá 50%: CT001",
        "Value": 25000
      },
      {
        "Id": 0,
        "PromotionId": 456,
        "Name": "Tặng quà: CT002",
        "Value": 0
      },
      {
        "Id": 0,
        "PromotionId": 789,
        "Name": "Mua 1 tặng 1: CT003",
        "Value": 15000
      }
    ]
  },
  "KvPromotionServiceResult": {
    "ValidIdList": [789],
    "DeletedIdList": [123, 456]
  },
  "ExpectedError": {
    "Type": "KvValidateException",
    "Message": "Chương trình khuyến mại Giảm giá 50%, Tặng quà ngừng hoạt động, vui lòng áp dụng khuyến mại khác!"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi chỉ với các chương trình khuyến mãi đã ngừng hoạt động, mặc dù vẫn có khuyến mãi hợp lệ trong danh sách.

---
**Điều hướng**
- Trước đó: [05-CreateInvoice-VersionConflict.md](./05-CreateInvoice-VersionConflict.md)
- Tiếp theo: [07-CreateInvoice-UUIDCheck.md](./07-CreateInvoice-UUIDCheck.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 