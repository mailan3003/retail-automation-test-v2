# Phân tích Business Logic của chức năng Xử Lý Dữ Liệu Đầu Vào

## Các bước xử lý chính

### 1. Trích xuất dữ liệu từ nhiều nguồn
- **Xử lý các nguồn dữ liệu khác nhau**:
  - Kiểm tra và xử lý dữ liệu từ `formData["ListProducts"]` nếu có
  - Nếu không có, kiểm tra trong `formData["ListProductsString"]`
  - Cuối cùng, fallback về `req.ListProductsString` nếu các nguồn trước không có
  - Sử dụng `JsonConvert.DeserializeObject` để chuyển đổi JSON thành đối tượng `List<ProductByBranchWithWarranty>`

- **Xử lý lỗi định dạng JSON**:
  - Bao bọc quá trình chuyển đổi trong khối try-catch
  - Bắt lỗi và ném ngoại lệ `KvValidateProductException` với thông báo rõ ràng (`KVMessage.invalidRequestParams`)
  - Đảm bảo xử lý lỗi từ sớm để không tiếp tục xử lý dữ liệu không hợp lệ

- **Khởi tạo các biến và cấu trúc dữ liệu phục vụ xử lý**:
  - Sử dụng `UsingProductBranchSelectToggle().Enable(AuthService.Context.RetailerId, AuthService.Context.GroupId)` để xác định có bật tính năng chọn chi nhánh cho sản phẩm hay không (`isUsingProductBranchSelect`)
  - Khởi tạo các danh sách và từ điển để lưu trữ dữ liệu sản phẩm, bảng giá, thuộc tính sản phẩm:
    - `listObjReturn`: danh sách các sản phẩm sẽ trả về sau khi xử lý
    - `lsPriceBook`: danh sách các bảng giá liên quan đến sản phẩm
    - `lsProductAttributes`: từ điển ánh xạ giữa sản phẩm và danh sách thuộc tính của sản phẩm
  - Khởi tạo các biến phục vụ xử lý đặc thù ngành dược:
    - `firstProduct`: lưu sản phẩm đầu tiên để sử dụng cho các logic đặc biệt
    - `globalMedicineId`, `globalMedicine`, `globalManufacturerCountry`, `globalManufacturer`, `medicineManufacturer`: các biến lưu thông tin liên quan đến dược phẩm, nhà sản xuất, quốc gia sản xuất, phục vụ cho các nghiệp vụ kiểm tra và đồng bộ với hệ thống Dược phẩm Quốc gia

- **Chuẩn hóa tên sản phẩm**:
  - Gọi hàm `NormalizeName(req)` để chuẩn hóa tên của tất cả sản phẩm
  - Loại bỏ khoảng trắng thừa, ký tự đặc biệt không hợp lệ
  - Đảm bảo định dạng nhất quán cho tên sản phẩm
  - Chi tiết logic triển khai: [Xem tại đây](../NormalizeName-Business-Logic.md)

- **Kiểm tra bảng hoa hồng đang ngừng áp dụng**:
  - Nếu cấu hình `Settings.TimeSheet` được bật và trường `CommissionIds` trong `formData` không rỗng:
    - Gọi hàm `ValidateCommissionInActive(formData["CommissionIds"])` để kiểm tra các bảng hoa hồng có đang ở trạng thái ngừng áp dụng hay không
    - Nếu phát hiện có bảng hoa hồng ngừng áp dụng, ném ngoại lệ và dừng quá trình lưu sản phẩm vào database

- **Xác định chi nhánh áp dụng giá vốn cho sản phẩm**:
  - Nếu `formData["BranchForProductCostss"]` có dữ liệu:
    - Thử parse JSON thành danh sách `SelectedActiveBranches`
    - Nếu parse thành công và danh sách không rỗng:
      - Lấy danh sách ID và tên chi nhánh từ kết quả parse, lưu vào `branchIdForProductCosts` và `branchNameForProductCosts`
    - Nếu danh sách rỗng nhưng `req.IsUpdateAllSystem` là true:
      - Lấy tất cả chi nhánh đang hoạt động của retailer hiện tại, lưu ID và tên vào các biến trên
    - Nếu không thỏa các điều kiện trên:
      - Mặc định chỉ lấy chi nhánh hiện tại (ID và tên)
  - Nếu không có `formData["BranchForProductCostss"]`:
    - Lấy danh sách chi nhánh theo quyền tạo sản phẩm (`Product._Create`)
    - Nếu hệ thống đang sử dụng kho (`isUsingWarehouse`):
      - Loại bỏ các chi nhánh đã lưu trữ kho khỏi danh sách
    - Lưu toàn bộ ID và tên chi nhánh còn lại vào `branchIdForProductCosts` và `branchNameForProductCosts`

- **Xác thực số lượng sản phẩm**:
  - Kiểm tra giới hạn sản phẩm combo (`ProductType.Manufactured`) không vượt quá 50
  - Đảm bảo tổng số sản phẩm không vượt quá 200
  - Ném ngoại lệ nếu vượt quá giới hạn để bảo vệ hiệu suất hệ thống: `KVMessage._product_ExceedingTheLimitComboProduct`, `KVMessage._product_ExceedingTheLimit`

- **Xác thực quyền hạn**:
  - Kiểm tra quyền truy cập giá vốn của người dùng với `AuthService.CheckPermission(Product.Cost, branchId)`
  - Nếu không có quyền, mặc định đặt giá vốn về 0 cho tất cả sản phẩm
  - Đảm bảo người dùng chỉ thấy/sửa thông tin mà họ có quyền

- **Kiểm tra tính nhất quán của đơn vị**:
  - Kiểm tra đơn vị trùng lặp trong cùng sản phẩm (phân biệt hoa/thường): 
    ```csharp
    var temp1 = listProducts.Select(x => new { unit = x.Unit.ToLower(), attribute = x.AttributedName });
    var temp2 = temp1.Where(x => x.attribute == temp1.FirstOrDefault().attribute);
    if (temp2.Select(x => x.unit.ToLower()).Distinct().Count() != temp2.Select(x => x.unit).Count()) {
        throw new KvValidateProductException(KVMessage.duplicateUnitName); // "Tên đơn vị tính không được phép trùng nhau"
    }
    ```
  - Đảm bảo tính duy nhất của đơn vị trong cùng một nhóm sản phẩm
  
- **Chuyển đổi sang cấu trúc dữ liệu chuẩn**:
  - Gọi `ProductService.GetProductFromProductByBranch(listProducts)` để chuyển đổi từ `ProductByBranch` sang `Product`
  - Áp dụng các ràng buộc nghiệp vụ trong quá trình chuyển đổi
  - Kiểm tra và xử lý thuộc tính đặc biệt như thuộc tính dược phẩm
  - Chi tiết logic triển khai: [Xem tại đây](../GetProductFromProductByBranch-Business-Logic.md)

- **Xử lý dữ liệu đặc thù ngành**:
  - Kiểm tra `AuthService.Context.IsActiveGppDrugStore` để xác định cần xử lý ngành dược hay không
  - Trích xuất thông tin liên quan đến dược phẩm như `GlobalMedicineId`, `ManufacturerId`
  - Chuẩn bị dữ liệu để tích hợp với Dược phẩm Quốc gia nếu cần

- **Chuẩn bị mã sản phẩm**:
  - Thu thập mã sản phẩm từ input người dùng vào `listCodeUserInput`
  - Sử dụng transaction để đảm bảo tính nhất quán khi tạo mã tự động
  - Gọi `ProductService.BatchCreateUniqCodeAsync(listProductsToAdd)` để tạo mã duy nhất cho sản phẩm chưa có mã

## Quy trình xử lý tổng thể
1. Đọc dữ liệu từ các nguồn khác nhau (formData, request)
2. Chuyển đổi JSON thành đối tượng và xử lý lỗi
3. Chuẩn hóa tên và xác thực số lượng sản phẩm
4. Xác định chi nhánh áp dụng cho sản phẩm và giá vốn
5. Chuyển đổi dữ liệu sang cấu trúc chuẩn để xử lý tiếp
6. Chuẩn bị mã sản phẩm (tự động hoặc từ input)
7. Chuẩn bị các danh sách dữ liệu cần thiết cho các bước tiếp theo

## Mã nguồn tham chiếu chính
```csharp
// Trích xuất dữ liệu từ nhiều nguồn
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
        req.ListProducts = JsonConvert.DeserializeObject<List<ProductByBranchWithWarranty>>(formData["ListProductsString"]); 
    }
}
catch (Exception ex) {
    throw new KvValidateProductException(KVMessage.invalidRequestParams, ex);
}

// Chuẩn hóa tên sản phẩm
NormalizeName(req);

// Xác thực số lượng sản phẩm
if (req.ListProducts.Count > 50 && req.ListProducts[0].ProductType == (int)ProductType.Manufactured) {
    throw new KvValidateProductException(KVMessage._product_ExceedingTheLimitComboProduct);
}

if (req.ListProducts.Count > 200) {
    throw new KvValidateProductException(KVMessage._product_ExceedingTheLimit);
}

// Xử lý chi nhánh cho sản phẩm
if (isUsingProductBranchSelect && formData["ListBranchsSelected"] != null) {
    req.ListBranchsSelected = JsonConvert.DeserializeObject<List<int>>(formData["ListBranchsSelected"]);
    if (req.ListBranchsSelected != null && req.ListBranchsSelected.Count > 0) {
        branchIdForProduct = req.ListBranchsSelected.ToList();
    }
}

// Xử lý chi nhánh cho giá vốn
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

// Tạo mã sản phẩm duy nhất
using (var dbContextTransaction = Db.Database.BeginTransaction()) {
    try {
        await ProductService.BatchCreateUniqCodeAsync(listProductsToAdd);
        dbContextTransaction.Commit();
    }
    catch (Exception ex) {
        dbContextTransaction.Rollback();
        Log.Error(ex.Message, ex);
        throw ex;
    }
}
```

## Test Data JSON cho các trường hợp thất bại

### 1. Dữ liệu JSON không hợp lệ
```json
{
  "formData": {
    "ListProductsString": "{không phải JSON hợp lệ}"
  },
  "ExpectedResult": {
    "Exception": "KvValidateProductException",
    "Message": "Dữ liệu không hợp lệ",
    "ErrorCode": "invalidRequestParams"
  }
}
```

### 2. Vượt quá giới hạn sản phẩm combo
```json
{
  "req": {
    "ListProducts": [
      {"ProductType": 2, "Name": "Sản phẩm combo 1"},
      {"ProductType": 2, "Name": "Sản phẩm combo 2"}
      // ... (thêm 49 sản phẩm nữa để vượt quá giới hạn 50)
    ]
  },
  "ExpectedResult": {
    "Exception": "KvValidateProductException",
    "Message": "Không thể thêm quá 50 sản phẩm combo cùng lúc",
    "ErrorCode": "_product_ExceedingTheLimitComboProduct"
  }
}
```

### 3. Định dạng chi nhánh không hợp lệ
```json
{
  "formData": {
    "BranchForProductCostss": "{không phải JSON hợp lệ}"
  },
  "ExpectedResult": {
    "Exception": "KvValidateProductException",
    "Message": "Dữ liệu không hợp lệ",
    "ErrorCode": "invalidRequestParams"
  }
}
```

## Mô hình xử lý ngoại lệ và thông báo lỗi

Chức năng xử lý dữ liệu đầu vào áp dụng mô hình phân tầng các loại ngoại lệ, với các mã thông báo được định nghĩa trong class `KVMessage`:

### 1. Lỗi định dạng dữ liệu
- **Mã thông báo**: `KVMessage.invalidRequestParams`
- **Giá trị**: "Tham số truyền vào không hợp lệ"
- **Ngữ cảnh sử dụng**: Khi xảy ra lỗi trong quá trình phân tích JSON từ các nguồn `ListProductsString`, `ListProducts`, và `BranchForProductCostss`
- **Loại ngoại lệ**: `KvValidateProductException`

### 2. Lỗi số lượng sản phẩm combo vượt quá giới hạn
- **Mã thông báo**: `KVMessage._product_ExceedingTheLimitComboProduct`
- **Giá trị**: "Không thể gửi quá 50 sản phẩm combo trong một lần"
- **Ngữ cảnh sử dụng**: Khi số lượng sản phẩm combo (ProductType.Manufactured) vượt quá 50
- **Loại ngoại lệ**: `KvValidateProductException`

### 3. Lỗi tổng số sản phẩm vượt quá giới hạn
- **Mã thông báo**: `KVMessage._product_ExceedingTheLimit`
- **Giá trị**: "Không thể gửi quá 200 sản phẩm trong một lần"
- **Ngữ cảnh sử dụng**: Khi tổng số sản phẩm vượt quá 200
- **Loại ngoại lệ**: `KvValidateProductException`

### 4. Lỗi tổng hợp khi xử lý dữ liệu
- **Mã thông báo**: `KVMessage._GlobalErrorSummary`
- **Giá trị**: "Có lỗi trong quá trình cập nhật dữ liệu."
- **Ngữ cảnh sử dụng**: Khi xảy ra lỗi không xác định trong quá trình tạo mã sản phẩm hoặc xử lý giao dịch cơ sở dữ liệu
- **Loại ngoại lệ**: `KvException`

Mô hình này đảm bảo thông báo lỗi nhất quán và cụ thể, giúp xác định vấn đề chính xác khi xảy ra lỗi trong quá trình xử lý dữ liệu đầu vào.

---
**Điều hướng**
- Tiếp theo: [2-Chuc-nang-xac-thuc-san-pham.md](./2-Chuc-nang-xac-thuc-san-pham.md)
- Tổng quan: [Tong-quan-Product-AddMany.md](./Tong-quan-Product-AddMany.md) 