# Phân tích Business Logic của phương thức CreateInvoice

### 16. Kiểm tra kho hàng
- **Xác định và kiểm tra trạng thái kho hàng**:
  - Hệ thống xác định ID kho hàng (`whId`) dựa trên thông tin trong hóa đơn:
    ```csharp
    var whId = invoice.WareHouse != null && invoice.WareHouse.Type != (byte)WarehouseType.DefaultDirectSale 
               ? invoice.WareHouse.Id 
               : invoice.BranchId;
    ```
  - Hệ thống sử dụng một trong hai giá trị:
    - ID của kho hàng được chỉ định (`invoice.WareHouse.Id`) nếu hóa đơn có thông tin kho hàng và không phải kho bán hàng mặc định
    - ID chi nhánh (`invoice.BranchId`) nếu không có kho hàng cụ thể hoặc là kho bán hàng mặc định
  
  - Sau khi xác định kho hàng, hệ thống gọi `WarehouseService.ValidateStatusOfWarehouse(whId)` để kiểm tra tính hợp lệ của kho hàng
  
  - Quy trình kiểm tra kho hàng bao gồm:
    1. Kiểm tra xem cửa hàng có đang sử dụng hoặc đã từng sử dụng tính năng quản lý kho không
    2. Nếu có, tiếp tục kiểm tra trạng thái kho hàng hiện tại
    3. Lấy thông tin kho hàng từ cơ sở dữ liệu dựa trên ID kho hàng
    4. Kiểm tra các điều kiện về trạng thái kho:
       - Nếu kho hàng không còn hoạt động: Hiển thị thông báo "{tên kho} không hợp lệ" (KVMessage.WarehouseIsDeleted)
       - Nếu kho hàng bị hạn chế truy cập: Hiển thị thông báo "{tên kho} đã ngừng hoạt động" (KVMessage.WarehouseIsDeactived)
  
  - Việc kiểm tra này đảm bảo rằng:
    - Kho hàng được sử dụng trong hóa đơn phải tồn tại
    - Kho hàng đang hoạt động (không bị xóa)
    - Kho hàng không bị hạn chế truy cập (không bị vô hiệu hóa)
  
  - Nếu kho hàng không đáp ứng các điều kiện trên, quá trình tạo/cập nhật hóa đơn sẽ bị dừng lại và hiển thị thông báo lỗi tương ứng 

## Test Data JSON cho các trường hợp thất bại

### 1. Kho hàng không còn hoạt động (đã bị xóa)
```json
{
  "Invoice": {
    "WareHouse": {
      "Id": 123,
      "Type": 1,
      "Name": "Kho Hàng A"
    },
    "BranchId": 10
  },
  "Warehouse": {
    "Id": 123,
    "Name": "Kho Hàng A",
    "IsDeleted": true,
    "IsActive": true
  },
  "ExpectedError": {
    "Type": "KvValidateWarehouseException",
    "Message": "Kho Hàng A không hợp lệ"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi phát hiện kho hàng được chỉ định trong hóa đơn đã bị xóa.

### 2. Kho hàng đã ngừng hoạt động (bị vô hiệu hóa)
```json
{
  "Invoice": {
    "WareHouse": {
      "Id": 123,
      "Type": 1,
      "Name": "Kho Hàng A"
    },
    "BranchId": 10
  },
  "Warehouse": {
    "Id": 123,
    "Name": "Kho Hàng A",
    "IsDeleted": false,
    "IsActive": false
  },
  "ExpectedError": {
    "Type": "KvValidateWarehouseException",
    "Message": "Kho Hàng A đã ngừng hoạt động"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi phát hiện kho hàng được chỉ định trong hóa đơn đã bị vô hiệu hóa.

### 3. Sử dụng kho bán hàng mặc định nhưng chi nhánh đã bị xóa
```json
{
  "Invoice": {
    "WareHouse": {
      "Id": 456,
      "Type": 0,
      "Name": "Kho bán hàng mặc định"
    },
    "BranchId": 10
  },
  "Warehouse": {
    "Id": 10,
    "Name": "Chi nhánh Hà Nội",
    "IsDeleted": true,
    "IsActive": true
  },
  "ExpectedError": {
    "Type": "KvValidateWarehouseException",
    "Message": "Chi nhánh Hà Nội không hợp lệ"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi sử dụng kho bán hàng mặc định nhưng chi nhánh tương ứng đã bị xóa.

### 4. Không chỉ định kho hàng và chi nhánh đã bị vô hiệu hóa
```json
{
  "Invoice": {
    "WareHouse": null,
    "BranchId": 10
  },
  "Warehouse": {
    "Id": 10,
    "Name": "Chi nhánh Hà Nội",
    "IsDeleted": false,
    "IsActive": false
  },
  "ExpectedError": {
    "Type": "KvValidateWarehouseException",
    "Message": "Chi nhánh Hà Nội đã ngừng hoạt động"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi không chỉ định kho hàng cụ thể nhưng chi nhánh mặc định đã bị vô hiệu hóa.

---
**Điều hướng**
- Trước đó: [16-CreateInvoice-CustomerDelivery.md](./16-CreateInvoice-CustomerDelivery.md)
- Tiếp theo: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 