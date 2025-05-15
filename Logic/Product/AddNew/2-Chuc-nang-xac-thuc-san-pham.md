# Phân tích Business Logic của chức năng Xác Thực Sản Phẩm

## Các bước xử lý chính

### 1. Xác thực thuộc tính sản phẩm (ProductAttributes)
- **Kiểm tra tồn tại của thuộc tính**:
  - Thu thập tất cả ID thuộc tính từ sản phẩm: `lsAttrIds = req.ListProducts.SelectMany(v => v.ProductAttributes).Select(iv => iv.AttributeId).Distinct().ToList()`
  - Gọi hàm `ValidateProductAttributes(lsAttrIds)` để kiểm tra thuộc tính tồn tại trong hệ thống
  - Chi tiết logic xác thực thuộc tính được mô tả trong file [ValidateProductAttributes-Business-Logic.md](../ValidateProductAttributes-Business-Logic.md)

### 2. Xác thực và tạo mã sản phẩm
- **Thu thập mã sản phẩm người dùng nhập**:
  - Thu thập danh sách mã người dùng đã nhập: `listCodeUserInput = new List<string>()`
  - Lọc và thêm các mã không rỗng vào danh sách: `if (!string.IsNullOrEmpty(productAdded.Code)) { listCodeUserInput.Add(productAdded.Code); }`

- **Tạo mã sản phẩm tự động**:
  - Sử dụng giao dịch cơ sở dữ liệu để đảm bảo tính toàn vẹn khi tạo mã:
    ```csharp
    using (var dbContextTransaction = Db.Database.BeginTransaction())
    {
        try
        {
            await ProductService.BatchCreateUniqCodeAsync(listProductsToAdd);
            dbContextTransaction.Commit();
        }
        catch (Exception ex)
        {
            dbContextTransaction.Rollback();
            Log.Error(ex.Message, ex);
            throw ex;
        }
    }
    ```
  - Hàm `BatchCreateUniqCodeAsync` sẽ tạo mã duy nhất cho các sản phẩm chưa có mã
  - Sử dụng cơ chế transaction để đảm bảo hoặc tất cả mã được tạo thành công, hoặc không có mã nào được tạo

### 3. Xác thực tính duy nhất của mã sản phẩm
- **Kiểm tra mã sản phẩm trùng lặp**:
  - Nhóm các sản phẩm cha (parent products) dựa trên MasterCode: `lsParentProduct = listProductsToAdd.GroupBy(p => p.MasterCode, (key, g) => g.First()).ToList()`
  - Kiểm tra xem có mã sản phẩm trùng lặp trong danh sách sản phẩm cha không:
    ```csharp
    if (lsParentProduct.Count != lsParentProduct.Select(x => x.Code).Distinct().Count())
    {
        var codeUnitsDuplicate = lsParentProduct.GroupBy(x => x.Code).Where(x => x.Skip(1).Any())
            .SelectMany(g => g).Distinct();
        if (codeUnitsDuplicate.Any())
        {
            duplicateUnitCodes = codeUnitsDuplicate.Select(x => x.Code).Distinct().Join(", ").ToString();
        }
    }
    ```
  - Nếu phát hiện mã trùng lặp, hệ thống sẽ tạo chuỗi chứa tất cả các mã bị trùng, phân cách bằng dấu phẩy
  - Ném ngoại lệ `KvValidateProductException` với thông báo lỗi định dạng: `string.Format(KVMessage._GlobalDuplicateData, KVMessage.ProductLog_UnitCode + ": " + duplicateUnitCodes)`
  - Thông báo lỗi sẽ có dạng: "Dữ liệu bị trùng: Mã đơn vị: CODE1, CODE2, ..."

- **Xác thực mô tả sản phẩm**:
  - Lấy sản phẩm cha đầu tiên và đặt MasterCode thành chuỗi rỗng: `firstParent.MasterCode = string.Empty`
  - Kiểm tra độ dài mô tả sản phẩm: `ValidateMaxSizeDescription(firstParent.Description)`
  - Đảm bảo mô tả không vượt quá giới hạn kích thước cho phép, thường được đo bằng MB thay vì số ký tự
  - Chi tiết logic xác thực mô tả sản phẩm được mô tả trong file [ValidateProductDescription-Business-Logic.md](../ValidateProductDescription-Business-Logic.md)

### 4. Xác thực thông tin đặc thù ngành
- **Xác thực thông tin dược phẩm**:
  - Kiểm tra điều kiện `AuthService.Context.IsActiveGppDrugStore` để xác định cần áp dụng xác thực dược phẩm
  - Trích xuất `globalMedicineId` từ danh sách sản phẩm
  - Lấy sản phẩm đầu tiên từ danh sách

- **Xử lý công thức sản phẩm**:
  - Nếu sản phẩm có công thức (`ProductFormulas`), xóa các thông tin về nhà sản xuất và quốc gia:
    - `GlobalManufacturerCountryId = null`
    - `GlobalManufacturerCountryName = null`
    - `ManufacturerId = null`
    - `ManufacturerName = null`
    - `GlobalManufacturerId = null`
    - `GlobalManufacturerName = null`
    - `PackagingSize = null`

- **Xác thực quốc gia sản xuất**:
  - Nếu `GlobalManufacturerCountryName` không rỗng, tìm kiếm quốc gia trong cơ sở dữ liệu
  - Gọi `GlobalManufacturerCountryService.GetByNameAsync(firstProduct.GlobalManufacturerCountryName.Trim())`
  - Nếu không tìm thấy, ném ngoại lệ `KvValidateProductMedicineException` với thông báo `KVMessage.pharmacy_msgErrorManufacturerCountry`
  - Nếu tìm thấy, cập nhật `GlobalManufacturerCountryId` và `GlobalManufacturerCountryName`

- **Xác thực nhà sản xuất**:
  - Lấy thông tin nhà sản xuất toàn cầu: `GlobalManufacturerService.GetByIdAsync(firstProduct.GlobalManufacturerId ?? 0)`
  - Lấy thông tin nhà sản xuất thuốc: `MedicineManufacturerService.GetByIdAsync(firstProduct.ManufacturerId ?? 0)`
  - Nếu `globalMedicineId > 0` hoặc `isRetailerMedicine`:
    - Lấy thông tin thuốc toàn cầu: `GlobalMedicineService.GetById(globalMedicineId ?? 0)`
    - Gọi `ValidateMedicine(globalMedicine, firstProduct, isRetailerMedicine, req.IsSyncNationalPharmacy, medicineManufacturer)`
    - Đánh dấu sản phẩm cha là sản phẩm thuốc: `firstParent.IsMedicineProduct = true`
    - Cập nhật `ShortName` và `RouteOfAdministration`
    - Bật kiểm soát lô và hạn sử dụng: `firstParent.IsBatchExpireControl = true`

- **Kiểm tra giới hạn độ dài của các trường dược phẩm**:
  - Kiểm tra `ShortName` không vượt quá 100 ký tự, nếu vượt quá ném ngoại lệ `KvValidateProductMedicineException` với thông báo `KVMessage.product_ShortNameMaxLength`
  - Kiểm tra `RouteOfAdministration` không vượt quá 200 ký tự, nếu vượt quá ném ngoại lệ `KvValidateProductMedicineException` với thông báo `KVMessage.product_RouteOfAdministrationMaxLength`


**Điều hướng**
- Trước đó: [1-Chuc-nang-xu-ly-du-lieu-dau-vao.md](./1-Chuc-nang-xu-ly-du-lieu-dau-vao.md)
- Tiếp theo: [3-Chuc-nang-quan-ly-hinh-anh.md](./3-Chuc-nang-quan-ly-hinh-anh.md)
- Tổng quan: [Tong-quan-Product-AddMany.md](./Tong-quan-Product-AddMany.md) 