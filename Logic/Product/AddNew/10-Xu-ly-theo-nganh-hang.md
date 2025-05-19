# Xử lý thông tin sản phẩm theo đặc thù ngành hàng

## Giới thiệu
Hệ thống hỗ trợ nhiều loại ngành hàng khác nhau, mỗi ngành có những yêu cầu và đặc thù riêng đối với thông tin sản phẩm. Tài liệu này mô tả quy trình xử lý thông tin sản phẩm theo đặc thù ngành hàng khi thêm sản phẩm mới.

## Quy trình xử lý theo ngành hàng

### 1. Ngành dược phẩm (GPP DrugStore)

```csharp
if (AuthService.Context.IsActiveGppDrugStore)
{
    if (listObjReturn[i].IsMedicineProduct == true)
    {
        log.Content = string.Format(Labels.auditTrailProduct_AddMedicineProduct,
            listObjReturn[i].Code, listObjReturn[i].Name,
            NormallizeProductPrice((double)listObjReturn[i].BasePrice),
            NormallizeProductPrice((double)productCost), onHandStr, productMaterials, unitName,
            content, weightStr, posLog, logWarehouseOnHand, logAttrs , shelvesStr,
            logShortName, logRegistrationNo, logActiveElement, logContent,
            logGlobalManufacturerName, logGlobalManufacturerCountryName, logPackagingSize,
            logRouteOfAdministration, logBarcode);
    }
    else
    {
        log.Content = string.Format(Labels.auditTrailProduct_AddMedicineOtherProduct,
            listObjReturn[i].Code, listObjReturn[i].Name,
            NormallizeProductPrice((double)listObjReturn[i].BasePrice),
            NormallizeProductPrice((double)productCost), onHandStr, productMaterials, unitName,
            content, weightStr, posLog, logWarehouseOnHand, logAttrs , shelvesStr,
            logGlobalManufacturerName, logGlobalManufacturerCountryName, logPackagingSize,
            logBarcode);
    }
}
```

- Kiểm tra nếu cửa hàng thuộc ngành dược phẩm (GPP DrugStore)
- Nếu sản phẩm là thuốc (`IsMedicineProduct` = true):
  - Sử dụng mẫu log đặc biệt cho sản phẩm thuốc, bao gồm các thông tin đặc thù như:
    - Tên viết tắt (Short Name)
    - Số đăng ký (Registration No)
    - Hoạt chất (Active Element)
    - Hàm lượng (Content)
    - Đường dùng (Route of Administration)
- Nếu sản phẩm không phải thuốc:
  - Sử dụng mẫu log cho sản phẩm không phải thuốc trong ngành dược, chỉ bao gồm một số thông tin cần thiết

#### 1.1. Xử lý đồng bộ lên cơ sở dữ liệu dược quốc gia

```csharp
if (AuthService.Context.IsActiveGppDrugStore && listObjReturn[i].IsMedicineProduct == true
    && (globalMedicineId == null || globalMedicineId == 0))
{
    log.Content = $"{log.Content}<br/>{(req.IsSyncNationalPharmacy ? Labels.product_Medicine_SyncToNationalDatabase : Labels.product_Medicine_NotSyncToNationalDatabase)}";
}
```

- Kiểm tra nếu sản phẩm là thuốc và chưa có ID thuốc toàn cầu
- Thêm thông tin về việc đồng bộ hoặc không đồng bộ lên cơ sở dữ liệu dược quốc gia vào nội dung log
- Thông tin này giúp truy vết việc đồng bộ dữ liệu và đảm bảo tính minh bạch

### 2. Ngành xây dựng (Construction)

```csharp
var isConstruction = CurrentIndustryId == (int)IndustryList.Construction;

if (isConstruction
    && listObjReturn[i].ProductExtraMaterials != null
    && listObjReturn[i].ProductExtraMaterials.Any()
    && listObjReturn[i].ProductExtraMaterials.FirstOrDefault() != null)
{
    var extraMaterial = listObjReturn[i]?.ProductExtraMaterials.FirstOrDefault();
    var measure = extraMaterial?.Type2 == (int)ProductMasterialType2.m ? "m" : "cm";
    var size = extraMaterial.Attribute1 != null && extraMaterial.Attribute2 != null ? $"{extraMaterial.Attribute1} x {extraMaterial.Attribute2} {measure}" : string.Empty;
    log.Content += $", {Labels.constructionMaterialSize}: {size}";
}
```

- Kiểm tra nếu ngành hàng hiện tại là ngành xây dựng
- Xử lý thông tin đặc thù cho vật liệu xây dựng:
  - Kiểm tra xem sản phẩm có thông tin vật liệu bổ sung
  - Xác định đơn vị đo: mét (m) hoặc centimet (cm) dựa vào loại vật liệu
  - Tính toán kích thước vật liệu từ các thuộc tính bổ sung (Attribute1, Attribute2)
  - Thêm thông tin kích thước vật liệu vào nội dung log

### 3. Xử lý thương hiệu sản phẩm (cho tất cả ngành hàng)

```csharp
string logTradeMark = string.Empty;
if (listObjReturn[i].TradeMarkId.HasValue)
{
    var trademark = await TradeMarkService.GetByIdAsync(listObjReturn[i].TradeMarkId.Value);
    logTradeMark = trademark != null
        ? string.Format(Labels.auditTrailProduct_Trademark, trademark.Name)
        : string.Empty;
}
```

- Kiểm tra nếu sản phẩm có ID thương hiệu
- Truy vấn thông tin chi tiết của thương hiệu từ cơ sở dữ liệu
- Định dạng chuỗi thông tin thương hiệu để hiển thị trong log
- Thông tin thương hiệu áp dụng cho tất cả các ngành hàng

### 4. Xử lý mã sản phẩm (tự động hoặc nhập tay)

```csharp
if (listCodeUserInput.Contains(listObjReturn[i].Code))
{
    log.Content = string.Format(Labels.auditTrailProduct_AddProduct, listObjReturn[i].Code,
    listObjReturn[i].Name, NormallizeProductPrice((double)listObjReturn[i].BasePrice),
    NormallizeProductPrice((double)productCost), onHandStr, productMaterials, unitName,
    content, weightStr, posLog, logWarehouseOnHand, logAttrs , shelvesStr, logBarcode, logTradeMark);
}
else
{
    log.Content = string.Format(Labels.auditTrailProduct_AddProductWithCode, listObjReturn[i].Code, logBarcode, $" {Labels.auditTrailProduct_CodeAutoGen}",
    listObjReturn[i].Name, unitName, logTradeMark, content, NormallizeProductPrice((double)listObjReturn[i].BasePrice), NormallizeProductPrice((double)productCost),
    onHandStr, shelvesStr, logWarehouseOnHand, logAttrs,
    productMaterials, weightStr, posLog);
}
```

- Kiểm tra nếu mã sản phẩm nằm trong danh sách mã do người dùng nhập (không phải tự động tạo)
- Nếu mã do người dùng nhập: sử dụng mẫu log thông thường
- Nếu mã tự động tạo: sử dụng mẫu log đặc biệt với ghi chú về việc mã được tạo tự động
- Mẫu log khác nhau để dễ dàng phân biệt giữa sản phẩm có mã do người dùng nhập và mã tự động

### 5. Xử lý thông tin phạm vi chi phí sản phẩm

```csharp
if (branchNameForProductCosts != null && branchNameForProductCosts.Count > 0)
{
    if (isUsingProductBranchSelect && listObjReturn[i].Formula != null && listObjReturn[i].Formula.Count > 0)
    {
        var logProductCostScopeForProductManu = req.IsUpdateAllSystem ? string.Format(Labels.auditTrailProductManufacture_CostScope_AllSystem) : string.Format(Labels.auditTrailProductManufacture_CostScope_Branch, branchNameForProductCosts.Join(", "));
        log.Content = $"{log.Content}<br/>{logProductCostScopeForProductManu}";
    } else {
        var logProductCostScope = req.IsUpdateAllSystem ? string.Format(Labels.auditTrailProduct_CostScope_AllSystem) : string.Format(Labels.auditTrailProduct_CostScope_Branch, branchNameForProductCosts.Join(", "));
        log.Content = $"{log.Content}<br/>{logProductCostScope}";
    }
}
```

- Kiểm tra nếu có thông tin chi nhánh cho chi phí sản phẩm
- Nếu sử dụng tính năng chọn chi nhánh cho sản phẩm và sản phẩm là sản phẩm chế biến (có công thức):
  - Tạo log về phạm vi chi phí đặc biệt cho sản phẩm chế biến
  - Hiển thị toàn hệ thống hoặc danh sách chi nhánh áp dụng
- Nếu là sản phẩm thông thường:
  - Tạo log về phạm vi chi phí cho sản phẩm thông thường
  - Hiển thị toàn hệ thống hoặc danh sách chi nhánh áp dụng

### 6. Xử lý thông tin chi nhánh áp dụng sản phẩm

```csharp
if (isUsingProductBranchSelect && branchIdForProduct != null && !req.isAddFromOtherForm)
{
    string branchNameApplyProduct = $"{Labels.branchApplyProduct} ";
    if (lstBranchActive.Count > 1)
    {
        if (branchIdForProduct.Count > 0)
        {
            foreach (var item in lstBranchActive)
            {
                if (branchIdForProduct.Contains(item.Id))
                {
                    branchNameApplyProduct += $"{item.Name}, ";
                }
            }
            log.Content = $"{log.Content}<br/>{branchNameApplyProduct.Trim(' ').Trim(',')}";
        }
        else
        {
            log.Content = $"{log.Content}<br/>{Labels.branchApplyProduct} {Labels.allOutletsCapitalize}";
        }
    }
}
```

- Kiểm tra nếu sử dụng tính năng chọn chi nhánh cho sản phẩm và có thông tin chi nhánh
- Nếu có nhiều chi nhánh hoạt động (>1) và danh sách chi nhánh áp dụng không rỗng:
  - Duyệt qua danh sách chi nhánh hoạt động
  - Tạo chuỗi danh sách chi nhánh áp dụng sản phẩm
  - Thêm thông tin chi nhánh áp dụng vào nội dung log
- Nếu danh sách chi nhánh áp dụng rỗng: hiển thị thông báo áp dụng cho tất cả chi nhánh 

---
**Điều hướng**
- Trang tổng quan: [Tổng quan quy trình thêm sản phẩm](./0-Tong-quan-Product-AddMany.md)
- Trước đó: [Tích hợp với hệ thống ngoài](./9-Tich-hop-voi-he-thong-ngoai.md)
- Tiếp theo: [Ghi nhật ký kiểm kê hàng](./11-Ghi-nhat-ky-kiem-ke-hang.md) 