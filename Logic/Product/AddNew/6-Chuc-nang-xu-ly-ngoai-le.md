# Phân tích Business Logic của chức năng Xử Lý Ngoại Lệ

## Các bước xử lý chính

### 1. Xử lý lỗi định dạng dữ liệu
- **Bắt lỗi phân tích JSON**:
  - Bao bọc các thao tác `JsonConvert.DeserializeObject` trong khối `try-catch`
  - Chuyển đổi lỗi thành `KvValidateProductException` với thông báo rõ ràng
  - Mẫu code: `throw new KvValidateProductException(KVMessage.invalidRequestParams, ex);` - "Tham số truyền vào không hợp lệ"

- **Xử lý JSON không hợp lệ từ nhiều nguồn**:
  - Dữ liệu sản phẩm: `formData["ListProductsString"]`, `formData["ListProducts"]`
  - Dữ liệu chi nhánh: `formData["ListBranchsSelected"]`, `formData["BranchForProductCostss"]`
  - Các dữ liệu cấu trúc khác: `CommissionIds`, giá vốn, thông tin kho

### 2. Xử lý giới hạn hệ thống
- **Kiểm soát giới hạn sản phẩm**:
  - Giới hạn sản phẩm combo (ProductType.Manufactured): `req.ListProducts.Count > 50`
  - Giới hạn tổng số sản phẩm: `req.ListProducts.Count > 200`
  - Ném ngoại lệ: `KVMessage._product_ExceedingTheLimitComboProduct` - "Không thể gửi quá 50 sản phẩm combo trong một lần", `KVMessage._product_ExceedingTheLimit` - "Không thể gửi quá 200 sản phẩm trong một lần"

- **Kiểm soát giới hạn kích thước**:
  - Giới hạn độ dài mô tả sản phẩm: `ValidateMaxSizeDescription(firstParent.Description)`
  - Giới hạn độ dài thuộc tính cho dược phẩm: `ShortName.Length > 100`, `RouteOfAdministration.Length > 200`
  - Ném ngoại lệ tương ứng: `KVMessage.product_ShortNameMaxLength` - "Vui lòng nhập Tên viết tắt không quá 100 kí tự", `KVMessage.product_RouteOfAdministrationMaxLength` - "Vui lòng nhập Đường dùng không quá 200 kí tự"

### 3. Xử lý lỗi trùng lặp dữ liệu
- **Kiểm tra mã sản phẩm trùng lặp**:
  - Kiểm tra trong danh sách đang tạo: 
    ```csharp
    if (lsParentProduct.Count != lsParentProduct.Select(x => x.Code).Distinct().Count()) {
        var codeUnitsDuplicate = lsParentProduct.GroupBy(x => x.Code).Where(x => x.Skip(1).Any())
            .SelectMany(g => g).Distinct();
        // Xử lý lỗi trùng lặp
    }
    ```
  - Báo cáo chi tiết mã trùng: `string.Format(KVMessage._GlobalDuplicateData, KVMessage.ProductLog_UnitCode + ": " + duplicateUnitCodes)` - "{0} đã tồn tại"

- **Kiểm tra đơn vị trùng lặp**:
  - Kiểm tra đơn vị trùng trong cùng nhóm sản phẩm:
    ```csharp
    var temp1 = listProducts.Select(x => new { unit = x.Unit.ToLower(), attribute = x.AttributedName });
    var temp2 = temp1.Where(x => x.attribute == temp1.FirstOrDefault().attribute);
    if (temp2.Select(x => x.unit.ToLower()).Distinct().Count() != temp2.Select(x => x.unit).Count()) {
        throw new KvValidateProductException(KVMessage.duplicateUnitName); // "Tên đơn vị tính không được phép trùng nhau"
    }
    ```
  - Kiểm tra mã trùng lặp trong sản phẩm con: `ValidateDuplicateCodeChildProducts(childProducts)`

### 4. Xử lý giao dịch cơ sở dữ liệu
- **Quản lý giao dịch atomic**:
  - Sử dụng `using (var dbContextTransaction = Db.Database.BeginTransaction())` để bao bọc thao tác
  - Rollback khi có lỗi: `dbContextTransaction.Rollback()`
  - Commit khi thành công: `dbContextTransaction.Commit()`

- **Xử lý lỗi SQL đặc thù**:
  - Bắt `SqlException` trong các thao tác với cơ sở dữ liệu
  - Xử lý theo mã lỗi SQL: `HandleSqlException(sqlException)`
  - Xử lý lỗi chèn hàng loạt: `await Db.BulkInsertAsync()`, `await Db.BulkMergeAsync()`

### 5. Xử lý lỗi nghiệp vụ đặc thù
- **Xử lý lỗi dược phẩm**:
  - Kiểm tra và xác thực thông tin dược phẩm: `ValidateMedicine(globalMedicine, firstProduct, isRetailerMedicine, req.IsSyncNationalPharmacy, medicineManufacturer)`
  - Kiểm tra thông tin nhà sản xuất: `GlobalManufacturerCountryService.GetByNameAsync()`
  - Ném ngoại lệ chuyên biệt: `KvValidateProductMedicineException(KVMessage.pharmacy_msgErrorManufacturerCountry)` - "Nước sản xuất không hợp lệ"

- **Xử lý lỗi nhân bản sản phẩm**:
  - Kiểm tra sản phẩm nguồn tồn tại: `ProductService.OrmGetByIdAsync(req.CloneProductId)`
  - Kiểm tra người dùng có quyền với sản phẩm nguồn: `AuthService.CheckPermission(cloneProduct)` - có thể ném `KVMessage.permission_denied` - "Bạn không có quyền thực hiện chức năng này"
  - Xử lý các trường hợp đặc biệt khi sao chép thông tin

## Cấu trúc try-catch tổng thể
```csharp
try {
    // Xử lý dữ liệu đầu vào và các bước thực hiện
    
    // Trả về kết quả thành công
    return new { Message = message, Data = data };
}
catch (KvValidateProductException ex) {
    // Lỗi xác thực sản phẩm - hiển thị trực tiếp cho người dùng
    Log.Error(ex.Message, ex);
    throw;
}
catch (KvException ex) {
    // Lỗi nghiệp vụ KiotViet - có thể đã được xử lý
    Log.Error(ex.Message, ex);
    throw;
}
catch (Exception ex) {
    // Lỗi hệ thống không xác định - chuyển đổi thành thông báo chung
    Log.Error(ex.Message, ex);
    throw new KvException(Labels.logError_CreateProduct); // Có thể thay thế bằng KVMessage._GlobalErrorSummary - "Có lỗi trong quá trình cập nhật dữ liệu."
}
```

## Các loại ngoại lệ và cách xử lý

### 1. KvValidateProductException
- **Mục đích**: Xác thực dữ liệu đầu vào, có thể hiển thị trực tiếp cho người dùng
- **Ví dụ sử dụng**:
  ```csharp
  if (lsParentProduct.Count != lsParentProduct.Select(x => x.Code).Distinct().Count()) {
      throw new KvValidateProductException(string.Format(KVMessage._GlobalDuplicateData, "Mã sản phẩm: " + duplicateUnitCodes)); // "{0} đã tồn tại"
  }
  ```
- **Xử lý**: Thường được truyền trực tiếp lên UI để người dùng sửa dữ liệu
- **Các thông báo phổ biến**:
  - `KVMessage.invalidRequestParams` - "Tham số truyền vào không hợp lệ"
  - `KVMessage._product_ExceedingTheLimitComboProduct` - "Không thể gửi quá 50 sản phẩm combo trong một lần"
  - `KVMessage._product_ExceedingTheLimit` - "Không thể gửi quá 200 sản phẩm trong một lần"
  - `KVMessage.duplicateUnitName` - "Tên đơn vị tính không được phép trùng nhau" 
  - `KVMessage._GlobalErrorSummary` - "Có lỗi trong quá trình cập nhật dữ liệu."
  - `KVMessage._GlobalDuplicateData` - "{0} đã tồn tại"
  - `KVMessage.attributeIsDeleted` - "Thuộc tính đã bị xóa. Vui lòng kiểm tra lại."

### 2. KvValidateProductMedicineException
- **Mục đích**: Xác thực dữ liệu đặc thù ngành dược phẩm
- **Ví dụ sử dụng**:
  ```csharp
  if (globalManufacturerCountry == null) {
      throw new KvValidateProductMedicineException(KVMessage.pharmacy_msgErrorManufacturerCountry); // "Nước sản xuất không hợp lệ"
  }
  ```
- **Xử lý**: Thường hiển thị thông báo chuyên biệt cho người dùng ngành dược
- **Các thông báo phổ biến**:
  - `KVMessage.pharmacy_msgErrorManufacturerCountry` - "Nước sản xuất không hợp lệ"
  - `KVMessage.product_ShortNameMaxLength` - "Vui lòng nhập Tên viết tắt không quá 100 kí tự"
  - `KVMessage.product_RouteOfAdministrationMaxLength` - "Vui lòng nhập Đường dùng không quá 200 kí tự"

### 3. KvException
- **Mục đích**: Lỗi nghiệp vụ chung, thường đi kèm mã thông báo từ `KVMessage`
- **Ví dụ sử dụng**:
  ```csharp
  throw new KvException(Labels.logError_CreateProduct); // Hoặc KVMessage._GlobalErrorSummary - "Có lỗi trong quá trình cập nhật dữ liệu."
  ```
- **Xử lý**: Thường được log và hiển thị thông báo chung cho người dùng
- **Các thông báo phổ biến**:
  - `KVMessage._GlobalErrorSummary` - "Có lỗi trong quá trình cập nhật dữ liệu."
  - `KVMessage.permission_denied` - "Bạn không có quyền thực hiện chức năng này"

### 4. Exception hoặc SqlException
- **Mục đích**: Lỗi hệ thống hoặc cơ sở dữ liệu
- **Ví dụ xử lý**:
  ```csharp
  catch (SqlException sqlException) {
      dbContextTransaction.Rollback();
      HandleSqlException(sqlException);
  }
  ```
- **Xử lý**: Thường được chuyển đổi thành `KvException` hoặc message thân thiện hơn

## Test Data JSON cho các trường hợp thất bại

### 1. Dữ liệu JSON không hợp lệ
```json
{
  "formData": {
    "ListProductsString": "{Dữ liệu JSON không hợp lệ}"
  },
  "ExpectedResult": {
    "Exception": "KvValidateProductException",
    "Message": "Tham số truyền vào không hợp lệ",
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
      // ... (thêm 49 sản phẩm combo nữa để vượt quá giới hạn 50)
    ]
  },
  "ExpectedResult": {
    "Exception": "KvValidateProductException",
    "Message": "Không thể gửi quá 50 sản phẩm combo trong một lần",
    "ErrorCode": "_product_ExceedingTheLimitComboProduct"
  }
}
```

### 3. Trùng lặp mã sản phẩm
```json
{
  "lsParentProduct": [
    {"Code": "SP001", "Name": "Sản phẩm A"},
    {"Code": "SP001", "Name": "Sản phẩm B"}
  ],
  "ExpectedResult": {
    "Exception": "KvValidateProductException",
    "Message": "Mã sản phẩm: SP001 đã tồn tại",
    "ErrorCode": "_GlobalDuplicateData"
  }
}
```

## Bảng tổng hợp các mã lỗi và thông báo

| Mã lỗi (KVMessage key) | Thông báo | Loại ngoại lệ | Ngữ cảnh sử dụng |
|--------------------------|----------|----------------|-------------------|
| invalidRequestParams | Tham số truyền vào không hợp lệ | KvValidateProductException | Lỗi định dạng JSON, dữ liệu đầu vào không hợp lệ |
| _product_ExceedingTheLimitComboProduct | Không thể gửi quá 50 sản phẩm combo trong một lần | KvValidateProductException | Vượt quá giới hạn sản phẩm combo |
| _product_ExceedingTheLimit | Không thể gửi quá 200 sản phẩm trong một lần | KvValidateProductException | Vượt quá giới hạn tổng số sản phẩm |
| duplicateUnitName | Tên đơn vị tính không được phép trùng nhau | KvValidateProductException | Đơn vị tính trùng lặp trong sản phẩm |
| _GlobalErrorSummary | Có lỗi trong quá trình cập nhật dữ liệu. | KvValidateProductException, KvException | Lỗi chung trong quá trình xử lý |
| _GlobalDuplicateData | {0} đã tồn tại | KvValidateProductException | Dữ liệu trùng lặp (mã sản phẩm, v.v.) |
| pharmacy_msgErrorManufacturerCountry | Nước sản xuất không hợp lệ | KvValidateProductMedicineException | Nhà sản xuất thuốc không tồn tại |
| product_ShortNameMaxLength | Vui lòng nhập Tên viết tắt không quá 100 kí tự | KvValidateProductMedicineException | Độ dài tên viết tắt thuốc vượt quá 100 ký tự |
| product_RouteOfAdministrationMaxLength | Vui lòng nhập Đường dùng không quá 200 kí tự | KvValidateProductMedicineException | Độ dài đường dùng thuốc vượt quá 200 ký tự |
| permission_denied | Bạn không có quyền thực hiện chức năng này | KvException | Người dùng không có đủ quyền hạn |
| attributeIsDeleted | Thuộc tính đã bị xóa. Vui lòng kiểm tra lại. | KvValidateProductException | Thuộc tính sản phẩm không tồn tại hoặc đã bị xóa |

---
**Điều hướng**
- Trước đó: [5-Chuc-nang-dong-bo-hoa-da-chi-nhanh.md](./5-Chuc-nang-dong-bo-hoa-da-chi-nhanh.md)
- Tổng quan: [Tong-quan-Product-AddMany.md](./Tong-quan-Product-AddMany.md) 