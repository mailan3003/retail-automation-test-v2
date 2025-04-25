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

---
**Điều hướng**
- Trước đó: [16-CreateInvoice-CustomerDelivery.md](./16-CreateInvoice-CustomerDelivery.md)
- Tiếp theo: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 