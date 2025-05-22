# Tích hợp với hệ thống bên ngoài sau khi thêm sản phẩm

## Giới thiệu
Sau khi hoàn tất việc thêm sản phẩm mới vào hệ thống, cần thực hiện các bước đồng bộ và thông báo đến các hệ thống bên ngoài để đảm bảo dữ liệu nhất quán trong toàn bộ hệ sinh thái. Tài liệu này mô tả các quy trình tích hợp với hệ thống bên ngoài sau khi thêm sản phẩm mới.

## Quy trình tích hợp với hệ thống bên ngoài

### 1. Đồng bộ dữ liệu với Elasticsearch

```csharp
if (AppConfigInfo.EnableEsIntegration)
{
    // Gom nhóm danh sách sản phẩm đã thêm
    var productIds = listObjReturn.Select(p => p.Id).ToList();
    
    // Tạo yêu cầu đồng bộ sản phẩm với Elasticsearch
    var syncRequest = new SyncProductsRequest
    {
        ProductIds = productIds,
        RetailerId = CurrentRetailerId,
        Action = SyncAction.Create
    };
    
    // Gửi yêu cầu đồng bộ
    await ElasticSearchIntegrationService.SyncProductsAsync(syncRequest);
    
    // Đồng bộ thông tin bảng giá
    var pricebookIds = listObjReturn.SelectMany(p => p.ListPriceBookDetail?.Select(pb => pb.PriceBookId) ?? new List<long>()).Distinct().ToList();
    if (pricebookIds.Any())
    {
        var syncPricebookRequest = new SyncPriceBooksRequest
        {
            PricebookIds = pricebookIds,
            RetailerId = CurrentRetailerId,
            Action = SyncAction.Update
        };
        await ElasticSearchIntegrationService.SyncPriceBooksAsync(syncPricebookRequest);
    }
}
```

- Kiểm tra nếu tích hợp Elasticsearch được kích hoạt trong cấu hình hệ thống
- Lấy danh sách ID sản phẩm đã thêm mới để đồng bộ
- Tạo yêu cầu đồng bộ sản phẩm với Elasticsearch:
  - Danh sách ID sản phẩm cần đồng bộ
  - ID của nhà bán lẻ hiện tại
  - Loại hành động là "Tạo mới" (Create)
- Gửi yêu cầu đồng bộ sản phẩm đến dịch vụ tích hợp Elasticsearch
- Xử lý đồng bộ thông tin bảng giá:
  - Lấy danh sách ID bảng giá độc nhất từ tất cả sản phẩm đã thêm
  - Tạo yêu cầu đồng bộ bảng giá với Elasticsearch
  - Gửi yêu cầu đồng bộ bảng giá đến dịch vụ tích hợp Elasticsearch

### 2. Tích hợp với cơ sở dữ liệu dược quốc gia (cho ngành dược)

```csharp
if (AuthService.Context.IsActiveGppDrugStore && firstProduct.IsMedicineProduct == true)
{
    // Kiểm tra yêu cầu đồng bộ với CSDL Dược quốc gia
    if (req.IsSyncNationalPharmacy)
    {
        // Chuẩn bị dữ liệu đồng bộ
        var syncRequest = new SyncNationalPharmacyRequest
        {
            ProductIds = listObjReturn.Select(p => p.Id).ToList(),
            RetailerId = CurrentRetailerId,
            BranchId = CurrentBranchId,
            UserId = CurrentUserId,
            Action = NationalPharmacySyncAction.Create
        };
        
        // Gửi yêu cầu đồng bộ
        await NationalPharmacyIntegrationService.SyncProductsAsync(syncRequest);
        
        // Ghi log đồng bộ
        var logSyncToNational = new AuditTrailLog
        {
            FunctionId = (int)FunctionType.Product,
            Action = (int)AuditTrailAction.Update,
            Content = $"Đồng bộ {listObjReturn.Count} sản phẩm thuốc mới lên cơ sở dữ liệu dược quốc gia",
            TransGuid = Guid.NewGuid().ToString()
        };
        await AuditTrailService.AddLog(logSyncToNational);
    }
}
```

- Kiểm tra nếu cửa hàng thuộc ngành dược được kích hoạt và sản phẩm đầu tiên là sản phẩm thuốc
- Kiểm tra yêu cầu đồng bộ với cơ sở dữ liệu dược quốc gia từ người dùng
- Nếu yêu cầu đồng bộ:
  - Chuẩn bị dữ liệu đồng bộ với thông tin về sản phẩm, nhà bán lẻ, chi nhánh và người dùng
  - Gửi yêu cầu đồng bộ đến dịch vụ tích hợp với cơ sở dữ liệu dược quốc gia
  - Ghi log về việc đồng bộ sản phẩm thuốc lên cơ sở dữ liệu quốc gia

### 3. Gửi thông báo thay đổi cho POS (Point of Sale)

```csharp
await EventMessageService.SendNotificationForPostouch(EventChange.Product);
```

- Gửi thông báo thay đổi sản phẩm đến hệ thống điểm bán hàng (POS)
- Thông báo này giúp ứng dụng POS cập nhật dữ liệu sản phẩm mới thêm vào hệ thống
- Sử dụng dịch vụ EventMessageService để gửi thông báo với loại sự kiện là Product

### 4. Tích hợp với kênh bán hàng trực tuyến

```csharp
if (AppConfigInfo.EnableEcommerceIntegration && req.ShouldSyncToEcommerce)
{
    // Lọc các sản phẩm cần đồng bộ lên kênh bán hàng trực tuyến
    var ecommerceProducts = listObjReturn
        .Where(p => p.AllowsSale && p.IsPublished && !p.IsDeleted)
        .Select(p => p.Id)
        .ToList();
    
    if (ecommerceProducts.Any())
    {
        // Chuẩn bị dữ liệu đồng bộ
        var syncEcommerceRequest = new SyncEcommerceProductsRequest
        {
            ProductIds = ecommerceProducts,
            RetailerId = CurrentRetailerId,
            BranchId = CurrentBranchId,
            Action = EcommerceSyncAction.Create
        };
        
        // Gửi yêu cầu đồng bộ
        await EcommerceIntegrationService.SyncProductsAsync(syncEcommerceRequest);
    }
}
```

- Kiểm tra nếu tích hợp kênh bán hàng trực tuyến được kích hoạt và người dùng yêu cầu đồng bộ
- Lọc các sản phẩm cần đồng bộ dựa trên các điều kiện:
  - Sản phẩm cho phép bán
  - Sản phẩm được công khai
  - Sản phẩm không bị xóa
- Nếu có sản phẩm cần đồng bộ:
  - Chuẩn bị dữ liệu đồng bộ với thông tin về sản phẩm, nhà bán lẻ và chi nhánh
  - Gửi yêu cầu đồng bộ đến dịch vụ tích hợp kênh bán hàng trực tuyến

### 5. Gửi thông báo cho người dùng

```csharp
// Tạo thông báo thành công
var notificationMessage = new NotificationMessage
{
    Type = NotificationType.Success,
    Content = $"Đã thêm thành công {listObjReturn.Count} sản phẩm mới vào hệ thống",
    Duration = 5000 // Hiển thị trong 5 giây
};

// Gửi thông báo cho người dùng
await NotificationService.SendToUserAsync(CurrentUserId, notificationMessage);

// Nếu có tích hợp với các hệ thống khác, thông báo thêm
if (AppConfigInfo.EnableEsIntegration || req.IsSyncNationalPharmacy)
{
    var integrationMessage = new NotificationMessage
    {
        Type = NotificationType.Info,
        Content = "Dữ liệu sản phẩm đang được đồng bộ với các hệ thống bên ngoài",
        Duration = 5000
    };
    await NotificationService.SendToUserAsync(CurrentUserId, integrationMessage);
}
```

- Tạo thông báo thành công về việc thêm sản phẩm mới
- Gửi thông báo đến người dùng hiện tại
- Nếu có tích hợp với các hệ thống bên ngoài (Elasticsearch, cơ sở dữ liệu dược quốc gia):
  - Tạo thông báo thông tin về việc đồng bộ dữ liệu
  - Gửi thông báo đến người dùng hiện tại

---
**Điều hướng**
- Trang tổng quan: [Tổng quan quy trình thêm sản phẩm](./0-Tong-quan-Product-AddMany.md)
- Trước đó: [Xử lý thuộc tính đặc thù](./8-Xu-ly-thuoc-tinh-dac-thu.md)
- Tiếp theo: [Xử lý theo ngành hàng](./10-Xu-ly-theo-nganh-hang.md) 