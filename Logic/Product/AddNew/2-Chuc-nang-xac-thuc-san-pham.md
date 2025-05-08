# Phân tích Business Logic của chức năng Xác Thực Sản Phẩm

## Các bước xử lý chính

### 1. Xác thực thuộc tính sản phẩm (ProductAttributes)
- **Kiểm tra tồn tại của thuộc tính**:
  - Thu thập tất cả ID thuộc tính từ sản phẩm: `lsAttrIds = req.ListProducts.SelectMany(v => v.ProductAttributes).Select(iv => iv.AttributeId).Distinct().ToList()`
  - Gọi hàm `ValidateProductAttributes(lsAttrIds)` để kiểm tra thuộc tính tồn tại trong hệ thống
  - Ném ngoại lệ nếu thuộc tính không tồn tại hoặc không được phép sử dụng (`KVMessage.attributeIsDeleted`) - "Thuộc tính đã bị xóa. Vui lòng kiểm tra lại."

- **Kiểm tra giá trị thuộc tính**:
  - Xác thực kiểu dữ liệu của giá trị thuộc tính (văn bản, số, ngày tháng)
  - Đảm bảo giá trị thuộc tính tuân thủ định dạng và giới hạn quy định
  - Hỗ trợ xác thực đặc biệt cho thuộc tính có danh sách giá trị từ điển (predefined values)

### 2. Xác thực mã và dữ liệu sản phẩm
- **Xác thực tính duy nhất của mã sản phẩm**:
  - Kiểm tra mã trùng lặp trong danh sách sản phẩm đang tạo: `lsParentProduct.Count != lsParentProduct.Select(x => x.Code).Distinct().Count()`
  - Nếu phát hiện mã trùng, thu thập danh sách mã trùng lặp và tạo thông báo lỗi chi tiết
  - Ném ngoại lệ `KvValidateProductException` với thông báo rõ ràng về các mã trùng lặp (`KVMessage._GlobalDuplicateData`) - "{0} đã tồn tại"

- **Kiểm tra mã sản phẩm đã tồn tại**:
  - Truy vấn cơ sở dữ liệu để kiểm tra mã đã tồn tại trong hệ thống
  - Ném ngoại lệ nếu mã đã tồn tại, tránh xung đột trong hệ thống
  - Hỗ trợ tự động tạo mã mới nếu không cung cấp hoặc mã tạo từ giao dịch riêng biệt

- **Xác thực mô tả sản phẩm**:
  - Gọi `ValidateMaxSizeDescription(firstParent.Description)` để kiểm tra độ dài mô tả
  - Giới hạn độ dài mô tả (thường là 2000 ký tự) để đảm bảo hiệu suất
  - Làm sạch nội dung mô tả khỏi các ký tự không hợp lệ

### 3. Xác thực đơn vị sản phẩm
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

- **Xác thực đơn vị con (child units)**:
  - Gọi `ValidateDuplicateCodeChildProducts(childProducts)` để kiểm tra tính duy nhất của mã đơn vị con
  - Kiểm tra hệ số chuyển đổi (`ConversionValue`) giữa các đơn vị hợp lệ
  - Đảm bảo tính nhất quán giữa đơn vị cha và đơn vị con

### 4. Xác thực thông tin đặc thù ngành
- **Xác thực thông tin dược phẩm**:
  - Kiểm tra điều kiện `AuthService.Context.IsActiveGppDrugStore` để xác định cần áp dụng xác thực dược phẩm
  - Trích xuất thông tin thuốc từ `GlobalMedicineService`
  - Gọi `ValidateMedicine(globalMedicine, firstProduct, isRetailerMedicine, req.IsSyncNationalPharmacy, medicineManufacturer)`
  - Kiểm tra các trường bắt buộc như `ShortName`, `RouteOfAdministration`, `RegistrationNo`

- **Xác thực nhà sản xuất và nguồn gốc**:
  - Kiểm tra tính hợp lệ của `GlobalManufacturerCountryId` và `GlobalManufacturerId`
  - Truy vấn thông tin từ GlobalManufacturerCountryService và GlobalManufacturerService
  - Đảm bảo thông tin nhà sản xuất và quốc gia xuất xứ hợp lệ
  - Ném ngoại lệ `KvValidateProductMedicineException` nếu nhà sản xuất hoặc quốc gia xuất xứ không hợp lệ (`KVMessage.pharmacy_msgErrorManufacturerCountry`) - "Nước sản xuất không hợp lệ"

- **Kiểm tra giới hạn độ dài của các trường dược phẩm**:
  - Kiểm tra `ShortName` không vượt quá 100 ký tự (`KVMessage.product_ShortNameMaxLength`) - "Vui lòng nhập Tên viết tắt không quá 100 kí tự"
  - Kiểm tra `RouteOfAdministration` không vượt quá 200 ký tự (`KVMessage.product_RouteOfAdministrationMaxLength`) - "Vui lòng nhập Đường dùng không quá 200 kí tự"
  - Ném ngoại lệ `KvValidateProductMedicineException` nếu vi phạm giới hạn

### 5. Xác thực thông tin bổ sung
- **Kiểm tra thông tin bảng giá**:
  - Xác thực tính hợp lệ của bảng giá được liên kết với sản phẩm
  - Kiểm tra quyền truy cập bảng giá của người dùng hiện tại (`KVMessage.permission_denied`) - "Bạn không có quyền thực hiện chức năng này"
  - Đảm bảo tính nhất quán của thông tin giá

- **Kiểm tra thông tin kệ hàng**:
  - Kiểm tra sự tồn tại của kệ hàng được liên kết với sản phẩm
  - Truy vấn thông tin từ `ShelvesService` để xác thực
  - Chuẩn bị dữ liệu cho việc liên kết sản phẩm với kệ hàng

## Quy trình xử lý tổng thể
1. Thu thập và chuẩn bị dữ liệu đầu vào
2. Xác thực các thuộc tính sản phẩm (ID, giá trị)
3. Kiểm tra tính duy nhất của mã sản phẩm trong nhóm và hệ thống
4. Xác thực các đơn vị và mối quan hệ giữa các đơn vị
5. Áp dụng xác thực đặc thù ngành (dược phẩm nếu cần)
6. Kiểm tra các thông tin bổ sung (bảng giá, kệ hàng)
7. Chuẩn bị dữ liệu cho quy trình tạo sản phẩm tiếp theo

## Mã nguồn tham chiếu chính
```csharp
// Xác thực thuộc tính sản phẩm
var lsAttrIds = req.ListProducts.Where(x => x.ProductAttributes != null && x.ProductAttributes.Any())
    .SelectMany(v => v.ProductAttributes).Select(iv => iv.AttributeId).Distinct().ToList();
if (lsAttrIds.Any()) await ValidateProductAttributes(lsAttrIds); // Có thể ném KVMessage.attributeIsDeleted

// Xác thực mã sản phẩm
if (lsParentProduct.Count != lsParentProduct.Select(x => x.Code).Distinct().Count()) {
    var codeUnitsDuplicate = lsParentProduct.GroupBy(x => x.Code).Where(x => x.Skip(1).Any())
        .SelectMany(g => g).Distinct();
    if (codeUnitsDuplicate.Any()) {
        duplicateUnitCodes = codeUnitsDuplicate.Select(x => x.Code).Distinct().Join(", ").ToString();
    }
}
if (!string.IsNullOrEmpty(duplicateUnitCodes)) {
    throw new KvValidateProductException(string.Format(KVMessage._GlobalDuplicateData, KVMessage.ProductLog_UnitCode + ": " + duplicateUnitCodes)); // "{0} đã tồn tại"
}

// Xác thực mô tả
ValidateMaxSizeDescription(firstParent.Description);

// Xác thực thông tin thuốc
if (AuthService.Context.IsActiveGppDrugStore) {
    globalMedicineId = req.ListProducts.Select(p => p.GlobalMedicineId).FirstOrDefault();
    firstProduct = req.ListProducts.FirstOrDefault();
    
    if (!string.IsNullOrEmpty(firstProduct.GlobalManufacturerCountryName)) {
        globalManufacturerCountry =
            await GlobalManufacturerCountryService.GetByNameAsync(
                firstProduct.GlobalManufacturerCountryName.Trim());
        if (globalManufacturerCountry == null) {
            throw new KvValidateProductMedicineException(KVMessage.pharmacy_msgErrorManufacturerCountry); // "Nước sản xuất không hợp lệ"
        } else {
            firstProduct.GlobalManufacturerCountryId = globalManufacturerCountry.Id;
            firstProduct.GlobalManufacturerCountryName = globalManufacturerCountry.Name;
        }
    }
    
    if (globalMedicineId > 0 || isRetailerMedicine) {
        globalMedicine = await GlobalMedicineService.GetById(globalMedicineId ?? 0);
        ValidateMedicine(globalMedicine, firstProduct, isRetailerMedicine, req.IsSyncNationalPharmacy, medicineManufacturer);
        
        firstParent.IsMedicineProduct = true;
        firstParent.ShortName = firstProduct.ShortName;
        firstParent.RouteOfAdministration = firstProduct.RouteOfAdministration;
        firstParent.IsBatchExpireControl = true;
    }
    
    if (firstParent.ShortName?.Length > 100) {
        throw new KvValidateProductMedicineException(KVMessage.product_ShortNameMaxLength); // "Vui lòng nhập Tên viết tắt không quá 100 kí tự"
    }
    
    if (firstParent.RouteOfAdministration?.Length > 200) {
        throw new KvValidateProductMedicineException(KVMessage.product_RouteOfAdministrationMaxLength); // "Vui lòng nhập Đường dùng không quá 200 kí tự"
    }
}

// Xác thực đơn vị con
if (childProducts.Any()) {
    ValidateDuplicateCodeChildProducts(childProducts);
}
```

## Test Data JSON cho các trường hợp thất bại

### 1. Thuộc tính sản phẩm không tồn tại
```json
{
  "req": {
    "ListProducts": [
      {
        "Name": "Sản phẩm A",
        "ProductAttributes": [
          {"AttributeId": 9999, "Value": "Giá trị không hợp lệ"}
        ]
      }
    ]
  },
  "ExpectedResult": {
    "Exception": "KvValidateProductException",
    "Message": "Thuộc tính sản phẩm không tồn tại",
    "ErrorCode": "attributeIsDeleted"
  }
}
```

### 2. Mã sản phẩm trùng lặp
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

### 3. Thông tin nhà sản xuất thuốc không hợp lệ
```json
{
  "AuthService": {
    "Context": {
      "IsActiveGppDrugStore": true
    }
  },
  "firstProduct": {
    "GlobalManufacturerCountryName": "Không tồn tại"
  },
  "ExpectedResult": {
    "Exception": "KvValidateProductMedicineException",
    "Message": "Nước sản xuất không hợp lệ",
    "ErrorCode": "pharmacy_msgErrorManufacturerCountry"
  }
}
```

## Mô hình xử lý ngoại lệ và thông báo lỗi

Chức năng xác thực sản phẩm áp dụng các loại ngoại lệ và mã thông báo lỗi sau:

### 1. Lỗi đơn vị tính trùng lặp
- **Mã thông báo**: `KVMessage.duplicateUnitName`
- **Giá trị**: "Tên đơn vị tính không được phép trùng nhau"
- **Ngữ cảnh sử dụng**: Khi phát hiện đơn vị tính trùng lặp trong cùng sản phẩm
- **Loại ngoại lệ**: `KvValidateProductException`

### 2. Lỗi dữ liệu trùng lặp
- **Mã thông báo**: `KVMessage._GlobalDuplicateData`
- **Giá trị**: "{0} đã tồn tại"
- **Ngữ cảnh sử dụng**: Khi phát hiện mã sản phẩm trùng lặp trong danh sách sản phẩm đang tạo
- **Loại ngoại lệ**: `KvValidateProductException`

### 3. Lỗi thuộc tính không tồn tại
- **Mã thông báo**: `KVMessage.attributeIsDeleted`
- **Giá trị**: "Thuộc tính đã bị xóa. Vui lòng kiểm tra lại."
- **Ngữ cảnh sử dụng**: Khi thuộc tính sản phẩm không tồn tại hoặc đã bị xóa
- **Loại ngoại lệ**: `KvValidateProductException`

### 4. Lỗi nhà sản xuất thuốc
- **Mã thông báo**: `KVMessage.pharmacy_msgErrorManufacturerCountry`
- **Giá trị**: "Nước sản xuất không hợp lệ"
- **Ngữ cảnh sử dụng**: Khi nước sản xuất thuốc không tồn tại trong hệ thống
- **Loại ngoại lệ**: `KvValidateProductMedicineException`

### 5. Lỗi độ dài tên viết tắt thuốc
- **Mã thông báo**: `KVMessage.product_ShortNameMaxLength`
- **Giá trị**: "Vui lòng nhập Tên viết tắt không quá 100 kí tự"
- **Ngữ cảnh sử dụng**: Khi tên viết tắt thuốc vượt quá 100 ký tự
- **Loại ngoại lệ**: `KvValidateProductMedicineException`

### 6. Lỗi độ dài đường dùng thuốc
- **Mã thông báo**: `KVMessage.product_RouteOfAdministrationMaxLength`
- **Giá trị**: "Vui lòng nhập Đường dùng không quá 200 kí tự"
- **Ngữ cảnh sử dụng**: Khi đường dùng thuốc vượt quá 200 ký tự
- **Loại ngoại lệ**: `KvValidateProductMedicineException`

---
**Điều hướng**
- Trước đó: [1-Chuc-nang-xu-ly-du-lieu-dau-vao.md](./1-Chuc-nang-xu-ly-du-lieu-dau-vao.md)
- Tiếp theo: [3-Chuc-nang-quan-ly-hinh-anh.md](./3-Chuc-nang-quan-ly-hinh-anh.md)
- Tổng quan: [Tong-quan-Product-AddMany.md](./Tong-quan-Product-AddMany.md) 