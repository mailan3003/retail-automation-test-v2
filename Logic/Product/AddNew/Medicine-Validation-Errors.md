# Xử lý lỗi xác thực sản phẩm dược phẩm

Tài liệu này tập trung vào các lỗi xác thực đặc thù cho sản phẩm ngành dược phẩm. Các ngoại lệ và thông báo lỗi này chỉ được sử dụng khi `AuthService.Context.IsActiveGppDrugStore` là `true`.

## 1. Quy trình xác thực dược phẩm

Khi thêm một sản phẩm thuốc, quy trình xác thực bao gồm:

```csharp
if (AuthService.Context.IsActiveGppDrugStore) {
    // Lấy thông tin thuốc từ danh mục
    globalMedicineId = req.ListProducts.Select(p => p.GlobalMedicineId).FirstOrDefault();
    firstProduct = req.ListProducts.FirstOrDefault();
    
    // Xác thực thông tin nước sản xuất
    if (!string.IsNullOrEmpty(firstProduct.GlobalManufacturerCountryName)) {
        globalManufacturerCountry = await GlobalManufacturerCountryService.GetByNameAsync(
            firstProduct.GlobalManufacturerCountryName.Trim());
        if (globalManufacturerCountry == null) {
            throw new KvValidateProductMedicineException(KVMessage.pharmacy_msgErrorManufacturerCountry);
        }
    }
    
    // Xác thực thông tin từ danh mục dược quốc gia
    if (globalMedicineId > 0 || isRetailerMedicine) {
        globalMedicine = await GlobalMedicineService.GetById(globalMedicineId ?? 0);
        ValidateMedicine(globalMedicine, firstProduct, isRetailerMedicine, req.IsSyncNationalPharmacy, medicineManufacturer);
    }
    
    // Xác thực độ dài các trường thông tin
    if (firstParent.ShortName?.Length > 100) {
        throw new KvValidateProductMedicineException(KVMessage.product_ShortNameMaxLength);
    }
    
    if (firstParent.RouteOfAdministration?.Length > 200) {
        throw new KvValidateProductMedicineException(KVMessage.product_RouteOfAdministrationMaxLength);
    }
}
```

## 2. Các lỗi xác thực chuyên biệt dược phẩm

| Mã thông báo | Thông báo lỗi | Ngữ cảnh sử dụng |
|--------------|---------------|------------------|
| pharmacy_msgErrorManufacturerCountry | Nước sản xuất không hợp lệ | Khi nước sản xuất không tồn tại trong hệ thống |
| product_ShortNameMaxLength | Vui lòng nhập Tên viết tắt không quá 100 kí tự | Khi độ dài Tên viết tắt vượt quá 100 ký tự |
| product_RouteOfAdministrationMaxLength | Vui lòng nhập Đường dùng không quá 200 kí tự | Khi độ dài Đường dùng vượt quá 200 ký tự |

## 3. Xác thực thông tin từ Dược quốc gia

Hàm `ValidateMedicine()` xử lý nhiều quy tắc nghiệp vụ dược phẩm:

```csharp
private void ValidateMedicine(GlobalMedicine globalMedicine, ProductByBranch firstProduct, 
                              bool isRetailerMedicine, bool isSyncNationalPharmacy, 
                              MedicineManufacturer medicineManufacturer)
{
    // Xác thực thông tin thuốc từ danh mục quốc gia
    if (globalMedicine == null && !isRetailerMedicine) {
        throw new KvValidateProductMedicineException("Không tìm thấy thông tin thuốc từ danh mục quốc gia");
    }
    
    // Xác thực thông tin bắt buộc 
    if (string.IsNullOrEmpty(firstProduct.ShortName)) {
        throw new KvValidateProductMedicineException("Tên viết tắt không được để trống");
    }
    
    // Xác thực thông tin nhà sản xuất khi đồng bộ lên danh mục quốc gia
    if (isSyncNationalPharmacy) {
        if (string.IsNullOrEmpty(firstProduct.RegistrationNo)) {
            throw new KvValidateProductMedicineException("Số đăng ký không được để trống khi đồng bộ lên danh mục quốc gia");
        }
        
        if (medicineManufacturer == null) {
            throw new KvValidateProductMedicineException("Nhà sản xuất không được để trống khi đồng bộ lên danh mục quốc gia");
        }
    }
}
```

## 4. Kiểm tra quyền hạn đặc thù

Các hệ thống dược phẩm thường có yêu cầu quyền hạn đặc biệt:

```csharp
// Kiểm tra quyền đồng bộ dược quốc gia
if (isSyncNationalPharmacy && !AuthService.CheckPermission(Medicine.SyncNational)) {
    throw new KvException(KVMessage.permission_denied);
}
```

## 5. Thử nghiệm các kịch bản lỗi

### Lỗi nước sản xuất không hợp lệ

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

### Lỗi độ dài tên viết tắt

```json
{
  "AuthService": {
    "Context": {
      "IsActiveGppDrugStore": true
    }
  },
  "firstProduct": {
    "ShortName": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco."
  },
  "ExpectedResult": {
    "Exception": "KvValidateProductMedicineException",
    "Message": "Vui lòng nhập Tên viết tắt không quá 100 kí tự",
    "ErrorCode": "product_ShortNameMaxLength"
  }
}
```

## 6. Quy tắc xử lý lỗi dược phẩm

1. **Sử dụng KvValidateProductMedicineException**: Các lỗi xác thực dược phẩm nên sử dụng loại ngoại lệ chuyên biệt này
2. **Thông báo cụ thể**: Thông báo lỗi nên chỉ ra vấn đề cụ thể và cách sửa chữa
3. **Phân tách với xác thực thông thường**: Đặt xác thực dược phẩm trong khối `if (AuthService.Context.IsActiveGppDrugStore)` để không áp dụng cho các cửa hàng thông thường
4. **Kiểm tra đồng bộ quốc gia**: Có xác thực bổ sung khi `isSyncNationalPharmacy = true`

---

**Xem thêm**:
- [2-Chuc-nang-xac-thuc-san-pham.md](./2-Chuc-nang-xac-thuc-san-pham.md) - Xác thực chung cho sản phẩm
- [Exception-Message-Patterns.md](./Exception-Message-Patterns.md) - Mô hình xử lý ngoại lệ chung 