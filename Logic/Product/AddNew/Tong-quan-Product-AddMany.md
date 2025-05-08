# Phân tích Business Logic của phương thức Post(ProductAddMany req)

## Tổng quan quy trình

### 1. Mục đích và chức năng
Phương thức `Post(ProductAddMany req)` trong `ProductApi` là điểm vào chính cho chức năng thêm nhiều sản phẩm cùng lúc vào hệ thống KiotViet, hỗ trợ nhiều loại sản phẩm (thường, dịch vụ, combo) với đầy đủ thuộc tính, chi nhánh, giá vốn, tồn kho và hình ảnh.

### 2. Đối tượng đầu vào
- **Dữ liệu chính**:
  - `ListProducts`: Danh sách đối tượng `ProductByBranchWithWarranty`
  - `ListProductsString`: Chuỗi JSON thay thế khi dữ liệu quá lớn
  - `RequestStream`: Luồng dữ liệu yêu cầu cho file upload

- **Dữ liệu tùy chọn**:
  - `PinnedImageId`: ID hình ảnh được ghim làm ảnh chính
  - `CloneProductId`: ID sản phẩm nguồn để nhân bản
  - `IsUpdateAllSystem`: Cờ đánh dấu cập nhật toàn hệ thống
  - `ListBranchsSelected`: Danh sách chi nhánh được chọn 
  - `BranchForProductCosts`: Danh sách chi nhánh áp dụng giá vốn
  - `CommissionIds`: Danh sách ID hoa hồng áp dụng cho sản phẩm

## Quy trình xử lý

### 1. Phân tích dữ liệu và xác thực ban đầu
```csharp
// Trích xuất form data
var formData = await RequestUtils.GetFormDataAsync(req.RequestStream);

// Phân tích JSON từ nhiều nguồn
try { 
    if (formData != null) {
        if (!string.IsNullOrWhiteSpace(formData["ListProductsString"])) {
            req.ListProducts = JsonConvert.DeserializeObject<List<ProductByBranchWithWarranty>>(formData["ListProductsString"]); 
        }
        else if(!string.IsNullOrWhiteSpace(formData["ListProducts"])) {
            req.ListProducts = JsonConvert.DeserializeObject<List<ProductByBranchWithWarranty>>(formData["ListProducts"]);  
        }            
    }
    else if (!string.IsNullOrWhiteSpace(req.ListProductsString)) {
        req.ListProducts = JsonConvert.DeserializeObject<List<ProductByBranchWithWarranty>>(req.ListProductsString); 
    }
}
catch (Exception ex) {
    throw new KvValidateProductException(KVMessage.invalidRequestParams, ex);
}

// Kiểm tra giới hạn số lượng
if (req.ListProducts.Count > 50 && req.ListProducts[0].ProductType == (int)ProductType.Manufactured) {
    throw new KvValidateProductException(KVMessage._product_ExceedingTheLimitComboProduct);
}

if (req.ListProducts.Count > 200) {
    throw new KvValidateProductException(KVMessage._product_ExceedingTheLimit);
}
```

### 2. Cấu hình và thiết lập môi trường
```csharp
// Lấy thông tin chi nhánh hiện tại
var currentBranch = await BranchService.GetByIdAsync(AuthService.Context.CurrentBranchId);

// Lấy cấu hình người bán
var config = await ConfigService.GetByRetailerIdAsync(CurrentRetailerId);
bool isUsingWarehouse = config != null && config.IsSettingWarehouse;
bool isUsingProductBranchSelect = config != null && config.IsSettingProductBranchSelect;
bool isUsingProductVAT = config != null && config.IsSettingProductVAT;
bool isUsingProductTavInventory = config != null && config.IsSettingTavInventory;
```

### 3. Chuyển đổi dữ liệu từ DTO sang entities
```csharp
List<Product> lsParentProduct = new List<Product>();
List<int> lsChildProduct = new List<int>();
List<int> lsProductManufacture = new List<int>();
List<int> lsIdProducts = new List<int>();
List<CostTrackingUpdateCost> lsCostTracking = new List<CostTrackingUpdateCost>();

// Xử lý quyền truy cập giá vốn
bool hasViewCost = AuthService.HasPermission(Permissions.ViewCost);

// Lặp qua từng sản phẩm đầu vào
foreach (var reqProduct in req.ListProducts) {
    // Chuyển đổi sang đối tượng Product
    var product = ProductService.GetProductFromProductByBranch(reqProduct);
    
    // Thiết lập thông tin sản phẩm cha/con
    if (product.MasterProductId == null || product.MasterProductId <= 0) {
        lsParentProduct.Add(product);
    } else {
        // Xử lý sản phẩm con
    }
    
    // Phân loại sản phẩm theo loại
    if (reqProduct.ProductType == (int)ProductType.Manufactured) {
        lsProductManufacture.Add(product.Id);
    }
}
```

### 4. Áp dụng giao dịch cơ sở dữ liệu
```csharp
using (var dbContextTransaction = Db.Database.BeginTransaction()) {
    try {
        // Xác thực mã sản phẩm trùng lặp
        ValidateDuplicateCode(lsParentProduct);
        
        // Tạo mã sản phẩm tự động nếu cần
        var firstProductNoCode = lsParentProduct.FirstOrDefault(m => string.IsNullOrEmpty(m.Code));
        if (firstProductNoCode != null) {
            var listProductNoCode = lsParentProduct.Where(m => string.IsNullOrEmpty(m.Code)).ToList();
            var listCode = await ProductService.BatchCreateUniqCodeAsync(listProductNoCode.Count);
            // Áp dụng mã
        }
        
        // Lưu sản phẩm cha
        await Db.BulkInsertAsync(lsParentProduct);
        
        // Tạo và lưu product tags
        // ...
        
        // Tạo và lưu product commission
        // ...
        
        // Lưu sản phẩm con
        // ...
        
        // Commit giao dịch
        dbContextTransaction.Commit();
    }
    catch (SqlException sqlException) {
        dbContextTransaction.Rollback();
        HandleSqlException(sqlException);
    }
    catch (Exception ex) {
        dbContextTransaction.Rollback();
        Log.Error(ex.Message, ex);
        throw;
    }
}
```

### 5. Xử lý đồng bộ chi nhánh và giá vốn
```csharp
// Xác định phạm vi chi nhánh
List<int> branchIdForProduct = new List<int>();
if (isUsingProductBranchSelect && formData["ListBranchsSelected"] != null) {
    req.ListBranchsSelected = JsonConvert.DeserializeObject<List<int>>(formData["ListBranchsSelected"]);
    if (req.ListBranchsSelected != null && req.ListBranchsSelected.Count > 0) {
        branchIdForProduct = req.ListBranchsSelected.ToList();
    }
}

// Xác định phạm vi giá vốn
List<int> branchIdForProductCosts = new List<int>();
List<string> branchNameForProductCosts = new List<string>();
if (formData["BranchForProductCostss"] != null) {
    try {
        req.BranchForProductCosts = JsonConvert.DeserializeObject<List<SelectedActiveBranches>>(formData["BranchForProductCostss"]);
    }
    catch (Exception ex) {
        throw new KvValidateProductException(KVMessage.invalidRequestParams, ex);
    }
    if (req.BranchForProductCosts != null && req.BranchForProductCosts.Count > 0) {
        branchIdForProductCosts = req.BranchForProductCosts.Select(m => m.Id).ToList();
        branchNameForProductCosts = req.BranchForProductCosts.Select(m => m.Name).ToList();
    }
    else if (req.IsUpdateAllSystem) {
        var lsBranch = await BranchService.GetAll().Where(x => x.RetailerId == CurrentRetailerId && x.IsActive).ToListAsync();
        branchIdForProductCosts = lsBranch.Select(m => m.Id).ToList();
        branchNameForProductCosts = lsBranch.Select(m => m.Name).ToList();
    }
    else {
        branchIdForProductCosts.Add(currentBranch.Id);
        branchNameForProductCosts.Add(currentBranch.Name);
    }
}

// Tạo liên kết sản phẩm với chi nhánh và đồng bộ giá vốn
if (isUsingProductBranchSelect) {
    // Đồng bộ giá vốn
    if (lsCostTracking.Any()) {
        await BatchChangeCostAsync(lsCostTracking, branchId, branchIdForProductCosts, branchIdForProduct);
    }
    
    // Xử lý trạng thái sản phẩm tại chi nhánh
    if (isNotUpdateAllBranchForProduct && !branchIdForProduct.Contains(currentBranch.Id)) {
        var listPrdIdNotInCurrentBranch = lsParentProduct.Select(pr => pr.Id).ToList();
        if (lsChildProduct != null && lsChildProduct.Count > 0) {
            listPrdIdNotInCurrentBranch.AddRange(lsChildProduct);
        }
        await ProductService.ActiveProductListAsync(listPrdIdNotInCurrentBranch, false, new List<int>() { currentBranch.Id });
    }
}
```

### 6. Xử lý hình ảnh sản phẩm
```csharp
// Xác định phạm vi lưu hình ảnh
var saveForAllProductsInGroup = formData.Get("SaveImagesForAllProducts") == "true";
List<CustomerModelProductImages> globalProductsImages = new List<CustomerModelProductImages>();

// Xử lý hình ảnh từ file upload
if (formData.Files != null && formData.Files.Count > 0) {
    for (int i = 0; i < formData.Files.Count; i++) {
        if (file.Headers.ContentType.ToString().Contains("image")) {
            var imageBytes = file.ReadFully();
            var savedImage = await FileManagementService.SaveProductImageAsync(imageBytes, file.FileName);
            // Thêm vào danh sách hình ảnh toàn cục
        }
    }
}

// Xử lý hình ảnh từ URL đề xuất
if (!string.IsNullOrWhiteSpace(req.ProductImageSuggestUrl)) {
    var productImage = new CustomerModelProductImages {
        Url = req.ProductImageSuggestUrl,
        IsPrimary = false
    };
    globalProductsImages.Add(productImage);
}

// Xử lý hình ảnh từ sản phẩm nhân bản
if (req.CloneProductId > 0 && formData.Get("CloneImages") == "true") {
    await ProcessCloneProduct(formData, req, globalProductsImages, lsParentProduct, saveForAllProductsInGroup);
}

// Lưu thông tin hình ảnh vào cơ sở dữ liệu
foreach (var item in globalProductsImages) {
    // Xác định phạm vi áp dụng (một hoặc tất cả sản phẩm)
    var listProdId = saveForAllProductsInGroup ? productIds.ToList() : new List<int> { productIds[0] };
    foreach (var prodId in listProdId) {
        var productImage = await Db.SingleAsync<ProductImage>(x => x.Url == item.Url && x.ProductId == prodId);
        if (productImage != null) continue;
        
        // Tạo bản ghi hình ảnh mới
        await Db.SaveAsync(new ProductImage {
            ProductId = prodId,
            Url = item.Url,
            IsPrimary = item.Id == req.PinnedImageId
        });
    }
}
```

### 7. Xử lý tồn kho ban đầu
```csharp
// Xử lý tồn kho ban đầu
if (isUsingWarehouse) {
    // Xác thực kho tại chi nhánh
    var productWhStockTake = req.ListProducts.SelectMany(m => m.ProductWithWarehouseStockTakes).ToList();
    foreach (var item in productWhStockTake) {
        await WarehouseService.ValidateStatusOfWarehouse(item.WarehouseId, item.BranchId ?? AuthService.Context.CurrentBranchId);
    }
    
    // Tạo bản ghi cân bằng kho
    await StockTakeService.CreateStockTakeForUpdateMultiProductAsync(productIds, productWhStockTake, AuthService.Context.CurrentUserId);
    
    // Ghi log thay đổi tồn kho
    foreach (var item in productWhStockTake) {
        var logWh = new LogWarehouseStockTake {
            ProductId = productIds[0],
            OnHand = item.OnHand,
            WarehouseId = item.WarehouseId,
            BranchId = item.BranchId,
            CreateDate = DateTime.Now,
            RetailerId = CurrentRetailerId,
            InvoiceDetailId = 0,
            CreateBy = AuthService.Context.CurrentUserId,
            Note = string.Format("Nhập tồn ban đầu {0} khi thêm mới sản phẩm", item.OnHand)
        };
        await Db.SaveAsync(logWh);
    }
}
```

### 8. Xử lý ngành đặc thù dược phẩm
```csharp
// Xử lý thông tin đặc thù ngành dược
if (AuthService.Context.IsActiveGppDrugStore) {
    var firstProduct = req.ListProducts.FirstOrDefault();
    if (firstProduct.IsMedicineProduct) {
        // Lấy thông tin liên quan đến dược phẩm
        var globalMedicine = await GlobalMedicineService.GetByIdAsync(firstProduct.GlobalMedicineId);
        var medicineManufacturer = await GlobalManufacturerService.GetByIdAsync(firstProduct.GlobalManufacturerId);
        
        // Xác thực thông tin dược phẩm
        ValidateMedicine(globalMedicine, firstProduct, isRetailerMedicine, req.IsSyncNationalPharmacy, medicineManufacturer);
        
        // Cập nhật thông tin sản phẩm
        var product = await ProductService.GetByIdAsync(productIds[0]);
        product.IsMedicineProduct = true;
        product.GlobalMedicineId = firstProduct.GlobalMedicineId;
        product.GlobalMedicineName = globalMedicine?.Name ?? firstProduct.GlobalMedicineName;
        
        // Cập nhật thông tin nhà sản xuất
        if (medicineManufacturer != null) {
            product.GlobalManufacturerId = firstProduct.GlobalManufacturerId;
            product.GlobalManufacturerName = medicineManufacturer.Name;
        }
        
        // Cập nhật thông tin quốc gia nhà sản xuất
        if (firstProduct.GlobalManufacturerCountryId > 0) {
            var globalManufacturerCountry = await GlobalManufacturerCountryService.GetByIdAsync(firstProduct.GlobalManufacturerCountryId);
            if (globalManufacturerCountry != null) {
                product.GlobalManufacturerCountryId = firstProduct.GlobalManufacturerCountryId;
                product.GlobalManufacturerCountryName = globalManufacturerCountry.Name;
            }
        }
        
        // Đồng bộ với Dược phẩm Quốc gia nếu cần
        if (req.IsSyncNationalPharmacy) {
            // Xử lý đồng bộ với Dược phẩm Quốc gia
        }
        
        // Lưu thông tin
        await Db.SaveAsync(product);
    }
}
```

### 9. Xử lý phản hồi kết quả
```csharp
// Xây dựng thông báo kết quả
var successProductIdsJson = JsonConvert.SerializeObject(productIds);
var message = string.Format(KVMessage._GlobalAddSuccess, Labels.ProductLog_Lbl);

// Trả về kết quả cho client
return new { 
    Message = message, 
    Data = new {
        SuccessProductIds = successProductIdsJson,
        ProductId = productIds.FirstOrDefault()
    }
};
```

## Mô hình try-catch tổng thể
```csharp
public async Task<object> Post(ProductAddMany req)
{
    try {
        // Xử lý logic chức năng
        
        // Trả về kết quả
        return new { Message = message, Data = data };
    }
    catch (KvValidateProductException ex) {
        Log.Error(ex.Message, ex);
        throw;
    }
    catch (KvException ex) {
        Log.Error(ex.Message, ex);
        throw;
    }
    catch (Exception ex) {
        Log.Error(ex.Message, ex);
        throw new KvException(Labels.logError_CreateProduct);
    }
}
```

## Đặc tính kỹ thuật nổi bật

### 1. Hiệu suất và tối ưu
- Sử dụng `BulkInsertAsync` và `BulkMergeAsync` để tối ưu hoạt động cơ sở dữ liệu
- Quản lý giao dịch cơ sở dữ liệu với `BeginTransaction()` và rollback khi cần thiết
- Tối ưu hoá phạm vi xử lý dữ liệu dựa trên cấu hình hệ thống

### 2. Tính linh hoạt trong xử lý
- Hỗ trợ nhiều nguồn dữ liệu đầu vào (ListProducts, ListProductsString, RequestStream)
- Phân loại và xử lý các loại sản phẩm khác nhau (thường, combo, dịch vụ)
- Hỗ trợ đồng bộ đa chi nhánh với cấu hình riêng biệt

### 3. Khả năng mở rộng
- Hỗ trợ tích hợp với hệ thống bên ngoài (Dược phẩm Quốc gia)
- Áp dụng cơ chế phân quyền chi tiết dựa trên AuthService
- Cấu trúc mô-đun cho phép dễ dàng mở rộng tính năng mà không cần thay đổi code cốt lõi

### 4. Xử lý ngoại lệ mạnh mẽ
- Phân loại ngoại lệ theo mức độ nghiêm trọng và loại
- Ghi log chi tiết để dễ dàng khắc phục sự cố
- Cung cấp thông báo thân thiện với người dùng khi xảy ra lỗi

## Luồng xử lý dữ liệu
```
[Client Request]
    ↓
[Phân tích dữ liệu]
    ↓
[Xác thực ban đầu]
    ↓
[Chuyển đổi sang entities]
    ↓
[Lưu vào cơ sở dữ liệu]
    ↓
[Đồng bộ chi nhánh và giá vốn]
    ↓
[Xử lý hình ảnh]
    ↓
[Xử lý tồn kho ban đầu]
    ↓
[Xử lý ngành đặc thù]
    ↓
[Phản hồi kết quả]
```

## Mẫu JSON và API

### 1. Request với sản phẩm đơn giản
```json
{
  "ListProducts": [
    {
      "Code": "SP001",
      "Name": "Sản phẩm A",
      "ProductType": 1,
      "CategoryId": 1,
      "Unit": "Cái",
      "BasePrice": 100000,
      "Cost": 80000
    }
  ]
}
```

### 2. Request với sản phẩm combo
```json
{
  "ListProducts": [
    {
      "Code": "SP002",
      "Name": "Combo B",
      "ProductType": 2,
      "CategoryId": 1,
      "Unit": "Bộ",
      "BasePrice": 150000,
      "Cost": 100000,
      "ProductFormulas": [
        {
          "MaterialId": 100,
          "MaterialCode": "NL001",
          "Quantity": 2,
          "Cost": 50000
        }
      ]
    }
  ]
}
```

### 3. Response thành công
```json
{
  "Message": "Thêm mới sản phẩm thành công",
  "Data": {
    "SuccessProductIds": "[1001]",
    "ProductId": 1001
  }
}
```

## Hướng dẫn xử lý ngoại lệ

Quy trình thêm sản phẩm áp dụng một cấu trúc xử lý ngoại lệ nhất quán, tuân theo các quy tắc và mẫu được mô tả chi tiết trong:

👉 [Exception-Message-Patterns.md](./Exception-Message-Patterns.md) - Tài liệu tổng hợp về mô hình xử lý ngoại lệ và thông báo lỗi

### Các loại ngoại lệ chính

1. **KvValidateProductException** - Lỗi xác thực dữ liệu đầu vào (JSON, giới hạn, trùng lặp)
2. **KvValidateProductMedicineException** - Lỗi xác thực dữ liệu dược phẩm
3. **KvException** - Lỗi nghiệp vụ chung
4. **SqlException** - Lỗi cơ sở dữ liệu (được xử lý và chuyển đổi)

Tham khảo các chức năng cụ thể để biết chi tiết cách xử lý ngoại lệ trong từng bước:

- [1-Chuc-nang-xu-ly-du-lieu-dau-vao.md](./1-Chuc-nang-xu-ly-du-lieu-dau-vao.md) - Xử lý lỗi định dạng dữ liệu
- [2-Chuc-nang-xac-thuc-san-pham.md](./2-Chuc-nang-xac-thuc-san-pham.md) - Xử lý lỗi xác thực sản phẩm
- [6-Chuc-nang-xu-ly-ngoai-le.md](./6-Chuc-nang-xu-ly-ngoai-le.md) - Xử lý tổng hợp các ngoại lệ
- [Medicine-Validation-Errors.md](./Medicine-Validation-Errors.md) - Xử lý lỗi đặc thù cho sản phẩm dược phẩm

---
**Điều hướng chi tiết**
- [1-Chuc-nang-xu-ly-du-lieu-dau-vao.md](./1-Chuc-nang-xu-ly-du-lieu-dau-vao.md)
- [2-Chuc-nang-xac-thuc-san-pham.md](./2-Chuc-nang-xac-thuc-san-pham.md)
- [3-Chuc-nang-quan-ly-hinh-anh.md](./3-Chuc-nang-quan-ly-hinh-anh.md)
- [4-Chuc-nang-nhan-ban-san-pham.md](./4-Chuc-nang-nhan-ban-san-pham.md)
- [5-Chuc-nang-dong-bo-hoa-da-chi-nhanh.md](./5-Chuc-nang-dong-bo-hoa-da-chi-nhanh.md)
- [6-Chuc-nang-xu-ly-ngoai-le.md](./6-Chuc-nang-xu-ly-ngoai-le.md) 