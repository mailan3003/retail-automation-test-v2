# Xử lý thuộc tính đặc thù của sản phẩm mới

## Giới thiệu
Ngoài các thuộc tính cơ bản, sản phẩm trong hệ thống còn có thể có các thuộc tính đặc thù phụ thuộc vào loại sản phẩm, ngành hàng, và cài đặt của doanh nghiệp. Tài liệu này mô tả quy trình xử lý và ghi log các thuộc tính đặc thù này khi thêm sản phẩm mới.

## Các thuộc tính đặc thù và quy trình xử lý

### 1. Xử lý thuộc tính sản phẩm (Product Attributes)

```csharp
var logAttrs = string.Empty;
var listProductAttributeByProductId = lsProductAttributes
    .FirstOrDefault(x => x.Key.Id == listObjReturn[i].Id).Value;
if (listProductAttributeByProductId != null && listProductAttributeByProductId.Count > 0)
{
    var attributeIds = listProductAttributeByProductId.Select(x => x.AttributeId).ToList();
    var attributes = await AttributeService.GetAll().WhereIn(attributeIds, x => x.Id)
        .ToListAsync();
    logAttrs = $", {Labels.auditTrailProduct_IncludeAttribute}:<div>";
    logAttrs = listProductAttributeByProductId.Aggregate(logAttrs,
        (current, itemProductAttr) =>
            current +
            $"- {attributes.FirstOrDefault(x => x.Id == itemProductAttr.AttributeId)?.Name}: {itemProductAttr.Value}<br>");
    logAttrs += "</div>";
}
```

- Lấy danh sách thuộc tính của sản phẩm từ danh sách đã được chuẩn bị trước
- Nếu sản phẩm có thuộc tính:
  - Lấy danh sách ID thuộc tính để truy vấn thông tin chi tiết
  - Tạo chuỗi HTML hiển thị danh sách thuộc tính với định dạng "-Tên thuộc tính: Giá trị"
  - Thông tin này sẽ được hiển thị trong lịch sử thao tác

### 2. Xử lý thông tin kho hàng

```csharp
var onHandStr = string.Empty;
var logWarehouseOnHand = string.Empty;
if (isUsingWarehouse && reqProductReturn.ProductWithWarehouseStockTakes != null) 
{
    var warehouseIds = reqProductReturn.ProductWithWarehouseStockTakes.Select(o => o.BranchId).ToList();
    var warehouses = await BranchService.GetAllOld().WhereIn(warehouseIds, e => e.Id).ToListAsync();
    var defaultWh = WarehouseService.GetAll().Where(e => e.Type == (byte)WarehouseType.DefaultDirectSale).FirstOrDefault();
    var isExistDefaultWh = defaultWh != null;
    if (warehouses != null && warehouses.Any())
    {
        warehouses = warehouses.OrderBy(e => e.MasterId).ThenByDescending(e => e.CreatedDate).ToList();
        logWarehouseOnHand = $",{Labels.currentOnHand}: <div>";
        foreach (var wh in warehouses)
        {
            var cWhProductOnHand = reqProductReturn.ProductWithWarehouseStockTakes.Where(e => e.BranchId == wh.Id).FirstOrDefault();
            if (cWhProductOnHand != null)
            {
                var cWhName = wh.Name;
                if (wh.Id == CurrentBranchId)
                {
                    cWhName = isExistDefaultWh ? defaultWh.Name : Labels.WarehouseDefault;
                }
                logWarehouseOnHand += $"- {cWhName}: {cWhProductOnHand.OnHand}<br>";
            }
        }

        logWarehouseOnHand += "</div>";

        var totalOnHand = reqProductReturn.ProductWithWarehouseStockTakes.Sum(p => p.OnHand ?? 0);
        onHandStr = (listObjReturn[i].ProductType == (byte)ProductType.Purchased)
        ? $", {Labels.stocktake_Onhand}: {NumberHelper.Normallize(totalOnHand, EnumCurrency.Quantity)}"
        : "";
    }
}
else
{
    onHandStr = (listObjReturn[i].ProductType == (byte)ProductType.Purchased)
    ? $", {Labels.stocktake_Onhand}: {NumberHelper.Normallize(reqProductReturn.OnHand, EnumCurrency.Quantity)}"
    : "";
}
```

- Kiểm tra nếu chức năng quản lý nhiều kho được kích hoạt và sản phẩm có dữ liệu tồn kho theo kho
- Truy vấn thông tin chi tiết của các kho từ danh sách ID kho được cung cấp
- Kiểm tra kho mặc định cho bán hàng trực tiếp
- Tạo chuỗi HTML hiển thị số lượng tồn kho tại mỗi kho với định dạng "- Tên kho: Số lượng"
- Tính tổng số lượng tồn kho và định dạng thành chuỗi để hiển thị
- Nếu không quản lý nhiều kho: hiển thị số lượng tồn kho tổng của sản phẩm

### 3. Xử lý thông tin kệ hàng

```csharp
var shelvesStr = string.Empty;
if (reqProductReturn.ProductShelves != null && reqProductReturn.ProductShelves.Any())
{
    var shelvesIds = reqProductReturn.ProductShelves.Select(s => s.ShelvesId).ToList();
    var lsShelvesStr = (await ShelvesService.GetAll().WhereIn(shelvesIds, s => s.Id)
            .Select(s => s.Name ?? string.Empty).Where(s => !string.IsNullOrEmpty(s))
            .ToListAsync())
        .Join(", ");
    shelvesStr = $", {Labels.product_Shelves}: {lsShelvesStr}";
}
```

- Kiểm tra nếu sản phẩm có thông tin kệ hàng
- Lấy danh sách ID kệ hàng để truy vấn thông tin chi tiết
- Tạo chuỗi danh sách tên kệ hàng, phân cách bởi dấu phẩy
- Thông tin kệ hàng sẽ được hiển thị trong lịch sử thao tác

### 4. Xử lý thành phần nguyên liệu (cho sản phẩm chế biến)

```csharp
var productMaterials = new StringBuilder();
var productCost = decimal.Zero;
if (listObjReturn[i].ProductType != (byte)ProductType.Service &&
    listObjReturn[i].Formula != null && listObjReturn[i].Formula.Any())
{
    int productFormulaHistoryId =
        listObjReturn[i].Formula.FirstOrDefault().ProductFormulaHistoryId;
    if (productFormulaHistoryId > 0)
    {
        productMaterials.Append(
            $", {Labels.auditTrail_CodeHistoryReturn}: {productFormulaHistoryId}, {Labels.auditTrail_Include}:<div>");
    }
    else
    {
        productMaterials.Append($", {Labels.auditTrail_Include}:<div>");
    }

    foreach (var item in reqProductReturn.ProductFormulas)
    {
        item.Cost = NumberHelper.RoundProductPrice(item.Cost, currentCurrency.CurrencyDecimalPlaceForProduct) ?? 0;
        productMaterials.Append(
            $"- [ProductCode]{item.MaterialCode}[/ProductCode] : {NumberHelper.Normallize(item.Quantity, EnumCurrency.Quantity)}*{NormallizeProductPrice((double)item.Cost)}<br>");
        productCost += NumberHelper.RoundTotalPrice(item.Cost * (decimal)item.Quantity, currentCurrency.CurrencyDecimalPlace) ?? 0;
    }

    productMaterials.Append("</div>");
}
else
{
    productCost = NumberHelper.RoundProductPrice(reqProductReturn.Cost, currentCurrency.CurrencyDecimalPlaceForProduct) ?? 0;
}
```

- Kiểm tra nếu sản phẩm không phải là dịch vụ và có công thức chế biến
- Lấy ID lịch sử công thức sản phẩm nếu có
- Tạo chuỗi HTML hiển thị danh sách nguyên liệu với định dạng "- Mã nguyên liệu: Số lượng * Giá"
- Tính tổng giá vốn của sản phẩm bằng cách cộng dồn giá vốn của các nguyên liệu
- Nếu không có công thức: sử dụng giá vốn được cung cấp trực tiếp

### 5. Xử lý trọng lượng sản phẩm

```csharp
var product = listObjReturn[i];
var productExtraMaterial = product.ProductExtraMaterials?.FirstOrDefault();
var weightStr = product.Weight.HasValue && product.Weight > 0
    ? $", {Labels.product_Weight}: {product.Weight.Value * product.ConversionValue}{GetProductWeightUnitName(productExtraMaterial?.Type4)}"
    : string.Empty;
```

- Lấy thông tin trọng lượng của sản phẩm
- Nếu sản phẩm có trọng lượng > 0: tính toán trọng lượng thực tế (trọng lượng * hệ số chuyển đổi)
- Lấy đơn vị trọng lượng từ thông tin vật liệu bổ sung của sản phẩm
- Tạo chuỗi hiển thị trọng lượng sản phẩm với đơn vị tính

### 6. Xử lý hình ảnh sản phẩm

```csharp
var logImage = string.Empty;
if (globalProductsImages.Any())
{
    var listImgAdd = globalProductsImages.Where(a => a.ProductId == listObjReturn[i].Id).Select(u => u.Image);
    if (listImgAdd.Any())
    {
        logImage = $"<br>{Labels.Image}:";
        foreach (string img in listImgAdd)
        {
            logImage += "<br>";
            logImage += string.Format(Labels.productLog_ImageDetail, img);
        }
    }
}
```

- Kiểm tra nếu có hình ảnh sản phẩm trong danh sách hình ảnh toàn cục
- Lọc ra các hình ảnh thuộc về sản phẩm hiện tại
- Tạo chuỗi HTML hiển thị danh sách đường dẫn hình ảnh
- Thông tin hình ảnh sẽ được hiển thị trong lịch sử thao tác

### 7. Xử lý thông tin đặc thù cho ngành dược

```csharp
string logShortName = string.Empty;
string logRegistrationNo = string.Empty;
string logActiveElement = string.Empty;
string logContent = string.Empty;
string logGlobalManufacturerName = string.Empty;
string logGlobalManufacturerCountryName = string.Empty;
string logPackagingSize = string.Empty;
string logRouteOfAdministration = string.Empty;
if (AuthService.Context.IsActiveGppDrugStore)
{
    if (listObjReturn[i].IsMedicineProduct == true)
    {
        logShortName = string.Format(Labels.auditTrailProduct_ShortName, sampleProduct.ShortName);
        logRegistrationNo = string.Format(Labels.auditTrailProduct_RegistrationNo, sampleProduct.RegistrationNo);
        logActiveElement = string.Format(Labels.auditTrailProduct_ActiveElement, sampleProduct.ActiveElement);
        logContent = string.Format(Labels.auditTrailProduct_Content, sampleProduct.Content);
        logGlobalManufacturerName = string.Format(Labels.auditTrailProduct_GlobalManufacturerName, sampleProduct.GlobalManufacturerName);
        logGlobalManufacturerCountryName = string.Format(Labels.auditTrailProduct_GlobalManufacturerCountryName, sampleProduct.GlobalManufacturerCountryName);
        logPackagingSize = string.Format(Labels.auditTrailProduct_PackagingSize, sampleProduct.PackagingSize);
        logRouteOfAdministration = string.Format(Labels.auditTrailProduct_RouteOfAdministration, sampleProduct.RouteOfAdministration);
    }
    // Xử lý cho sản phẩm không phải thuốc trong ngành dược
    else
    {
        // Lấy và định dạng thông tin nhà sản xuất, quốc gia, quy cách đóng gói...
    }
}
```

- Kiểm tra nếu là cửa hàng thuốc (GPP DrugStore)
- Nếu sản phẩm là thuốc: thu thập và định dạng các thông tin đặc thù của sản phẩm thuốc
  - Tên viết tắt (Short Name)
  - Số đăng ký (Registration No)
  - Hoạt chất (Active Element)
  - Hàm lượng (Content)
  - Nhà sản xuất (Manufacturer)
  - Nước sản xuất (Country)
  - Quy cách đóng gói (Packaging Size)
  - Đường dùng (Route of Administration)
- Nếu không phải thuốc: thu thập thông tin phù hợp với sản phẩm không phải thuốc trong ngành dược 

## Điều hướng tài liệu
- Trước đó: [7-Quan-ly-lich-su-thao-tac.md](./7-Quan-ly-lich-su-thao-tac.md)
- Tiếp theo: [9-Tich-hop-voi-he-thong-ngoai.md](./9-Tich-hop-voi-he-thong-ngoai.md)
- Tổng quan: [0-Tong-quan-Product-AddMany.md](./0-Tong-quan-Product-AddMany.md)