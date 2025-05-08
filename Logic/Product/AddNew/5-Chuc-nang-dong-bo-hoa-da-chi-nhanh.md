# Đồng Bộ Hóa Đa Chi Nhánh - Post(ProductAddMany req)

## Mục Đích
Chức năng này thực hiện việc đồng bộ hóa thông tin sản phẩm giữa nhiều chi nhánh trong hệ thống KiotViet, đảm bảo tính nhất quán của dữ liệu sản phẩm trên toàn bộ hệ thống bán lẻ.

## Danh Sách Chức Năng Con

### 1. Xác định phạm vi đồng bộ chi nhánh
#### Mô tả
Xác định danh sách chi nhánh cần đồng bộ hóa sản phẩm dựa trên thông số yêu cầu.

#### Logic nghiệp vụ
- Đọc danh sách chi nhánh được chọn từ formData["ListBranchsSelected"] khi isUsingProductBranchSelect = true
- Kiểm tra cờ IsUpdateAllSystem để áp dụng cho tất cả chi nhánh nếu được yêu cầu
- Tạo danh sách branchIdForProduct dựa trên dữ liệu đầu vào

#### Thông số đầu vào/ra
- **Đầu vào**: formData["ListBranchsSelected"], req.IsUpdateAllSystem, isUsingProductBranchSelect
- **Đầu ra**: branchIdForProduct (danh sách ID chi nhánh cần đồng bộ)

#### Mã kiểm thử thất bại
```json
{
  "formData": {
    "ListBranchsSelected": "không phải mảng JSON hợp lệ"
  },
  "req": {
    "IsUpdateAllSystem": false
  },
  "isUsingProductBranchSelect": true
}
```

### 2. Xác định phạm vi đồng bộ giá vốn
#### Mô tả
Xác định danh sách chi nhánh cần áp dụng thông tin giá vốn (cost) của sản phẩm.

#### Logic nghiệp vụ
- Đọc danh sách chi nhánh cho giá vốn từ formData["BranchForProductCostss"]
- Kiểm tra cờ IsUpdateAllSystem để áp dụng cho tất cả chi nhánh nếu được yêu cầu
- Mặc định sử dụng chi nhánh hiện tại nếu không có thông tin nào được cung cấp

#### Thông số đầu vào/ra
- **Đầu vào**: formData["BranchForProductCostss"], req.IsUpdateAllSystem, currentBranch
- **Đầu ra**: branchIdForProductCosts, branchNameForProductCosts

#### Mã kiểm thử thất bại
```json
{
  "formData": {
    "BranchForProductCostss": "không phải mảng JSON hợp lệ"
  },
  "req": {
    "IsUpdateAllSystem": false,
    "BranchForProductCosts": null
  },
  "currentBranch": {"Id": 1, "Name": "Chi nhánh trung tâm"}
}
```

### 3. Kiểm tra kho tại chi nhánh
#### Mô tả
Kiểm tra và xác thực trạng thái của kho hàng tại chi nhánh khi yêu cầu đồng bộ.

#### Logic nghiệp vụ
- Sử dụng WarehouseService.ValidateStatusOfWarehouse để kiểm tra trạng thái kho
- Áp dụng cho danh sách kho trong ProductWithWarehouseStockTakes
- Đảm bảo kho có trạng thái hợp lệ trước khi thực hiện đồng bộ

#### Thông số đầu vào/ra
- **Đầu vào**: productWhStockTake.ProductWithWarehouseStockTakes, isUsingWarehouse
- **Đầu ra**: Xác nhận trạng thái kho hợp lệ hoặc ngoại lệ nếu không hợp lệ

#### Mã kiểm thử thất bại
```json
{
  "isUsingWarehouse": true,
  "productWhStockTake": {
    "ProductWithWarehouseStockTakes": [
      {"BranchId": 1001, "OnHand": 10.0},
      {"BranchId": 9999, "OnHand": 5.0}  // Chi nhánh không tồn tại
    ]
  }
}
```

### 4. Thiết lập thông tin chi nhánh cho sản phẩm
#### Mô tả
Tạo hoặc cập nhật bản ghi ProductBranch để liên kết sản phẩm với chi nhánh.

#### Logic nghiệp vụ
- Gọi ProductBranchService.GetOrCreateListAsync để tạo bản ghi ProductBranch
- Truyền danh sách sản phẩm và danh sách chi nhánh đã xác định
- Đảm bảo mỗi sản phẩm đều được liên kết với các chi nhánh được chọn

#### Thông số đầu vào/ra
- **Đầu vào**: lsNewProductIdHaveCostEqual0, branchId, CurrentRetailerId, branchIdForProduct
- **Đầu ra**: Các bản ghi ProductBranch được tạo hoặc cập nhật

#### Mã kiểm thử thất bại
```json
{
  "lsNewProductIdHaveCostEqual0": [1001, 1002],
  "branchId": 0,  // Chi nhánh không hợp lệ
  "CurrentRetailerId": 101,
  "branchIdForProduct": [1, 2, 3]
}
```

### 5. Đồng bộ giá vốn đa chi nhánh
#### Mô tả
Cập nhật thông tin giá vốn của sản phẩm cho nhiều chi nhánh.

#### Logic nghiệp vụ
- Gọi BatchChangeCostAsync để cập nhật giá vốn cho danh sách chi nhánh
- Áp dụng danh sách thay đổi giá vốn (lsCostTracking) cho các chi nhánh trong phạm vi
- Xử lý trường hợp đặc biệt khi isUsingProductBranchSelect = true

#### Thông số đầu vào/ra
- **Đầu vào**: lsCostTracking, branchId, branchIdForProductCosts, branchIdForProduct
- **Đầu ra**: Thông tin giá vốn được cập nhật cho các chi nhánh

#### Mã kiểm thử thất bại
```json
{
  "lsCostTracking": [
    {"ProductId": 1001, "Cost": 100000, "OldCost": 90000}
  ],
  "branchId": 1,
  "branchIdForProductCosts": [1, 999],  // Chi nhánh 999 không tồn tại
  "isUsingProductBranchSelect": true
}
```

### 6. Xử lý trạng thái hoạt động của sản phẩm tại chi nhánh
#### Mô tả
Cập nhật trạng thái hoạt động (active) của sản phẩm tại các chi nhánh.

#### Logic nghiệp vụ
- Kiểm tra isNotUpdateAllBranchForProduct và branchIdForProduct không chứa chi nhánh hiện tại
- Gọi ProductService.ActiveProductListAsync để cập nhật trạng thái hoạt động
- Đánh dấu sản phẩm không hoạt động tại chi nhánh hiện tại nếu không được chọn

#### Thông số đầu vào/ra
- **Đầu vào**: isNotUpdateAllBranchForProduct, branchIdForProduct, currentBranch, listPrdIdNotInCurrentBranch
- **Đầu ra**: Cập nhật trạng thái hoạt động trong bảng ProductBranch

#### Mã kiểm thử thất bại
```json
{
  "isNotUpdateAllBranchForProduct": true,
  "branchIdForProduct": [2, 3],  // Không chứa chi nhánh hiện tại
  "currentBranch": {"Id": 1, "Name": "Chi nhánh trung tâm"},
  "listPrdIdNotInCurrentBranch": []  // Danh sách rỗng
}
```

### 7. Đồng bộ sản phẩm có công thức
#### Mô tả
Xử lý đặc biệt cho sản phẩm có công thức sản xuất để đồng bộ giữa các chi nhánh.

#### Logic nghiệp vụ
- Kiểm tra sản phẩm có công thức ProductFormulas không
- Tính toán giá vốn của sản phẩm dựa trên công thức với CalculateProductFormulaCost
- Gọi GetOrCreateListProductManufactureAsync để đồng bộ sản phẩm có công thức

#### Thông số đầu vào/ra
- **Đầu vào**: reqProduct.ProductFormulas, lsProductManufacture, branchIdForProduct, branchIdForProductCosts
- **Đầu ra**: Danh sách ProductBranch được cập nhật với giá vốn theo công thức

#### Mã kiểm thử thất bại
```json
{
  "reqProduct": {
    "ProductFormulas": [
      {"MaterialId": 9999, "Quantity": 2.0}  // MaterialId không tồn tại
    ]
  },
  "lsProductManufacture": [1001, 1002],
  "branchIdForProduct": [1, 2, 3],
  "branchIdForProductCosts": [1, 2]
}
```

## Quy Trình Xử Lý Tổng Thể
1. Xác định phạm vi đồng bộ chi nhánh từ ListBranchsSelected hoặc IsUpdateAllSystem
2. Xác định phạm vi đồng bộ giá vốn từ BranchForProductCosts
3. Kiểm tra và xác thực trạng thái kho tại các chi nhánh (nếu áp dụng)
4. Tạo bản ghi ProductBranch để liên kết sản phẩm với chi nhánh
5. Cập nhật giá vốn cho các chi nhánh được chọn
6. Cập nhật trạng thái hoạt động của sản phẩm tại chi nhánh
7. Xử lý đặc biệt cho sản phẩm có công thức sản xuất
8. Đồng bộ với hệ thống Dược phẩm Quốc gia nếu có yêu cầu

## Phụ Thuộc Mã Nguồn
- Dịch vụ BranchService: Để truy xuất thông tin chi nhánh
- Dịch vụ ProductBranchService: Để quản lý liên kết sản phẩm và chi nhánh
- Dịch vụ WarehouseService: Để kiểm tra trạng thái kho
- Dịch vụ ProductService: Để cập nhật trạng thái sản phẩm
- Dịch vụ ProductFormulaService: Để tính toán giá vốn từ công thức

## Điểm Lưu Ý Quan Trọng
1. Việc đồng bộ chi nhánh phụ thuộc vào tùy chọn isUsingProductBranchSelect
2. Thông tin giá vốn có thể được áp dụng cho một tập hợp chi nhánh khác với tập hợp đồng bộ sản phẩm
3. Sản phẩm có thể được đánh dấu không hoạt động tại chi nhánh hiện tại nếu không nằm trong danh sách chi nhánh được chọn
4. Sản phẩm có công thức cần được xử lý đặc biệt để tính toán giá vốn dựa trên thành phần
5. Đồng bộ với hệ thống bên ngoài (như Dược phẩm Quốc gia) phụ thuộc vào cấu hình và yêu cầu đặc biệt 

# Phân tích Business Logic của chức năng Đồng Bộ Hóa Đa Chi Nhánh

## Các bước xử lý chính

### 1. Xác định phạm vi đồng bộ chi nhánh
- **Phân tích dữ liệu chi nhánh đầu vào**:
  - Kiểm tra cờ `isUsingProductBranchSelect` để xác định có sử dụng tính năng chọn chi nhánh riêng biệt
  - Đọc danh sách ID chi nhánh từ `formData["ListBranchsSelected"]` nếu có
  - Lưu vào biến `branchIdForProduct` để sử dụng trong quá trình xử lý tiếp theo

- **Xử lý phạm vi toàn hệ thống**:
  - Kiểm tra cờ `req.IsUpdateAllSystem` để xác định phạm vi áp dụng trên toàn hệ thống
  - Nếu cờ này được bật, lấy toàn bộ chi nhánh đang hoạt động của người bán lẻ hiện tại
  - Gọi `BranchService.GetAll().Where(x => x.RetailerId == CurrentRetailerId && x.IsActive).ToListAsync()`

### 2. Xác định phạm vi giá vốn cho chi nhánh
- **Phân tích dữ liệu phạm vi giá vốn**:
  - Đọc danh sách chi nhánh áp dụng giá vốn từ `formData["BranchForProductCostss"]`
  - Phân tích JSON thành đối tượng `List<SelectedActiveBranches>`
  - Trích xuất ID chi nhánh vào `branchIdForProductCosts` và tên chi nhánh vào `branchNameForProductCosts`

- **Xử lý trường hợp đặc biệt**:
  - Nếu không có chi nhánh nào được chọn nhưng `req.IsUpdateAllSystem` là true, áp dụng cho tất cả chi nhánh
  - Nếu không có thông tin và không áp dụng toàn hệ thống, mặc định chỉ áp dụng cho chi nhánh hiện tại
  - Tùy chỉnh phạm vi dựa trên quyền hạn của người dùng hiện tại

### 3. Thiết lập liên kết sản phẩm với chi nhánh
- **Tạo bản ghi ProductBranch**:
  - Gọi `ProductBranchService.GetOrCreateListAsync` để tạo liên kết sản phẩm với chi nhánh
  - Tham số: danh sách sản phẩm, danh sách chi nhánh, RetailerId hiện tại
  - Hỗ trợ cả sản phẩm có giá vốn bằng 0 qua `lsNewProductIdHaveCostEqual0`

- **Thiết lập trạng thái hoạt động**:
  - Kiểm tra nếu `isNotUpdateAllBranchForProduct` và chi nhánh hiện tại không nằm trong `branchIdForProduct`
  - Gọi `ProductService.ActiveProductListAsync(listPrdIdNotInCurrentBranch, false, [currentBranch.Id])` để đánh dấu không hoạt động
  - Đảm bảo sản phẩm chỉ hiển thị tại các chi nhánh được chọn

### 4. Đồng bộ giá vốn cho chi nhánh
- **Đồng bộ thay đổi giá vốn**:
  - Gọi `BatchChangeCostAsync(lsCostTracking, branchId, branchIdForProductCosts, branchIdForProduct)`
  - Ứng dụng danh sách thay đổi giá vốn `lsCostTracking` cho tất cả chi nhánh trong phạm vi
  - Xử lý các trường hợp đặc biệt như giá vốn 0 và giá vốn dựa trên công thức

- **Xử lý tính toán giá vốn từ công thức**:
  - Kiểm tra sản phẩm có công thức sản xuất (`reqProduct.ProductFormulas`)
  - Gọi `ProductFormulaService.CalculateProductFormulaCost` để tính toán giá vốn dựa trên công thức
  - Áp dụng giá vốn tính toán cho tất cả chi nhánh được chọn

### 5. Xử lý tồn kho và kho hàng
- **Xác thực trạng thái kho hàng**:
  - Kiểm tra cờ `isUsingWarehouse` để xác định có sử dụng tính năng quản lý kho
  - Duyệt qua danh sách `ProductWithWarehouseStockTakes` để kiểm tra các kho liên quan
  - Gọi `WarehouseService.ValidateStatusOfWarehouse` để xác thực trạng thái kho

- **Tạo bản ghi cân bằng kho**:
  - Gọi `StockTakeService.CreateStockTakeForUpdateMultiProductAsync` để tạo bản ghi cân bằng kho
  - Áp dụng tồn kho ban đầu cho sản phẩm ở mỗi chi nhánh hoặc kho được chọn
  - Ghi log chi tiết cho mọi thay đổi thông qua `LogWarehouseStockTake`

## Mã nguồn tham chiếu chính
```csharp
// Xác định phạm vi chi nhánh
if (isUsingProductBranchSelect && formData["ListBranchsSelected"] != null) {
    req.ListBranchsSelected = JsonConvert.DeserializeObject<List<int>>(formData["ListBranchsSelected"]);
    if (req.ListBranchsSelected != null && req.ListBranchsSelected.Count > 0) {
        branchIdForProduct = req.ListBranchsSelected.ToList();
    }
}

// Xác định phạm vi giá vốn
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

// Xử lý liên kết sản phẩm với chi nhánh
if (isUsingProductBranchSelect) {
    // Đồng bộ giá vốn
    if (lsCostTracking.Any()) {
        await BatchChangeCostAsync(lsCostTracking, branchId, branchIdForProductCosts, branchIdForProduct);
    }
    
    // Xử lý sản phẩm có giá vốn bằng 0
    if (lsNewProductIdHaveCostEqual0.Any()) {
        await ProductBranchService.GetOrCreateListAsync(lsNewProductIdHaveCostEqual0, branchId, CurrentRetailerId, null, branchIdForProduct);
    }
    
    // Kiểm tra trạng thái hoạt động
    if (isNotUpdateAllBranchForProduct && !branchIdForProduct.Contains(currentBranch.Id)) {
        var listPrdIdNotInCurrentBranch = lsParentProduct.Select(pr => pr.Id).ToList();
        if (lsChildProduct != null && lsChildProduct.Count > 0) {
            listPrdIdNotInCurrentBranch.AddRange(lsChildProduct);
        }
        await ProductService.ActiveProductListAsync(listPrdIdNotInCurrentBranch, false, new List<int>() { currentBranch.Id });
    }
    
    // Xử lý sản phẩm có công thức
    var reqProduct = req.ListProducts.FirstOrDefault();
    if (reqProduct.ProductFormulas != null && reqProduct.ProductFormulas.Any()) {
        var formulaIds = reqProduct.ProductFormulas.Select(f => f.MaterialId).Distinct();
        var lsProductBranchCost = ProductFormulaService.CalculateProductFormulaCost((IList<CustomerModelProductFormula>)reqProduct.ProductFormulas, formulaIds, branchIdForProductCosts);
        if (lsProductManufacture != null && lsProductManufacture.Count > 0) {
            await ProductBranchService.GetOrCreateListProductManufactureAsync(lsProductManufacture, branchId, CurrentRetailerId, null, branchIdForProduct, lsProductBranchCost, branchIdForProductCosts);
            if (lsChildProduct != null && lsChildProduct.Count > 0) {
                await ProductBranchService.GetOrCreateListProductManufactureAsync(lsChildProduct, branchId, CurrentRetailerId, null, branchIdForProduct, lsProductBranchCost, branchIdForProductCosts);
            }
        }
    }
}
```

## Các vấn đề kỹ thuật quan trọng

### 1. Quản lý phạm vi đồng bộ
- **Phân biệt giữa phạm vi sản phẩm và phạm vi giá vốn**:
  - `branchIdForProduct`: Danh sách chi nhánh được áp dụng sản phẩm (hiển thị, bán hàng)
  - `branchIdForProductCosts`: Danh sách chi nhánh được áp dụng giá vốn (có thể khác với phạm vi sản phẩm)
  - Cho phép tùy biến giá vốn khác nhau giữa các chi nhánh

- **Xử lý các cấu hình hệ thống**:
  - `isUsingProductBranchSelect`: Cờ cho phép chọn chi nhánh riêng biệt từ người dùng
  - `isUsingWarehouse`: Cờ xác định có sử dụng tính năng quản lý nhiều kho trong cùng chi nhánh
  - `IsUsingProductVAT`: Cờ xác định có sử dụng VAT cho sản phẩm hay không

### 2. Đồng bộ hóa giá vốn
- **Cơ chế đồng bộ giá vốn**:
  - Lưu trữ thông tin thay đổi giá vốn trong đối tượng `CostTrackingUpdateCost`
  - Sử dụng `BatchChangeCostAsync` để áp dụng đồng thời cho nhiều chi nhánh
  - Hỗ trợ tính toán và đồng bộ giá vốn dựa trên công thức sản phẩm

- **Xử lý giá vốn cho sản phẩm chế biến**:
  - Tính toán giá vốn dựa trên công thức qua `CalculateProductFormulaCost`
  - Cập nhật giá vốn dựa trên giá thành phần hiện tại
  - Đảm bảo tính nhất quán giữa các chi nhánh

### 3. Quản lý trạng thái hoạt động
- **Quản lý tình trạng hiển thị sản phẩm**:
  - Cập nhật trạng thái `isActive` trong bảng `ProductBranch` cho từng chi nhánh
  - Gọi `ProductService.ActiveProductListAsync` để áp dụng trạng thái cho một nhóm sản phẩm
  - Xử lý trường hợp đặc biệt khi chi nhánh hiện tại không nằm trong danh sách được chọn

- **Quản lý sản phẩm không hoạt động**:
  - Lưu trữ danh sách sản phẩm không hoạt động ở chi nhánh hiện tại trong `listPrdIdNotInCurrentBranch`
  - Đánh dấu sản phẩm không hoạt động ở chi nhánh không được chọn
  - Duy trì tính nhất quán giữa sản phẩm chính và sản phẩm con

### 4. Quản lý tồn kho đa chi nhánh
- **Xử lý kho hàng phân tán**:
  - Lưu trữ thông tin tồn kho ban đầu trong `ProductWithWarehouseStockTakes`
  - Tạo bản ghi cân bằng kho thông qua `StockTakeService.CreateStockTakeForUpdateMultiProductAsync`
  - Hỗ trợ tồn kho riêng biệt cho mỗi chi nhánh và kho

- **Xác thực trạng thái kho hàng**:
  - Gọi `WarehouseService.ValidateStatusOfWarehouse` để xác thực trạng thái kho
  - Đảm bảo chỉ áp dụng tồn kho cho các kho đang hoạt động
  - Ghi log thay đổi tồn kho thông qua `LogWarehouseStockTake`

## Test Data JSON cho các trường hợp thất bại

### 1. Dữ liệu chi nhánh không hợp lệ
```json
{
  "formData": {
    "ListBranchsSelected": "không phải JSON hợp lệ"
  },
  "isUsingProductBranchSelect": true,
  "ExpectedResult": {
    "Exception": "KvValidateProductException",
    "Message": "Dữ liệu không hợp lệ"
  }
}
```

### 2. Kho hàng không tồn tại tại chi nhánh
```json
{
  "isUsingWarehouse": true,
  "productWhStockTake": {
    "ProductWithWarehouseStockTakes": [
      {"BranchId": 1001, "WarehouseId": 9999, "OnHand": 10.0}
    ]
  },
  "ExpectedResult": {
    "Exception": "KvValidateProductException",
    "Message": "Kho hàng không tồn tại tại chi nhánh"
  }
}
```

---
**Điều hướng**
- Trước đó: [4-Chuc-nang-nhan-ban-san-pham.md](./4-Chuc-nang-nhan-ban-san-pham.md)
- Tiếp theo: [6-Chuc-nang-xu-ly-ngoai-le.md](./6-Chuc-nang-xu-ly-ngoai-le.md)
- Tổng quan: [Tong-quan-Product-AddMany.md](./Tong-quan-Product-AddMany.md) 