# Mô hình xử lý ngoại lệ và thông báo trong Product AddMany

Tài liệu này tổng hợp các mẫu xử lý ngoại lệ và thông báo lỗi trong chức năng Product AddMany, giúp duy trì sự nhất quán trong việc xử lý lỗi và tạo trải nghiệm người dùng đồng nhất.

## 1. Cấu trúc xử lý ngoại lệ

Quy trình thêm sản phẩm sử dụng một hệ thống phân tầng các loại ngoại lệ:

```csharp
try {
    // Xử lý nghiệp vụ chính
    return new { Message = message, Data = data };
}
catch (KvValidateProductException ex) {
    // Ngoại lệ xác thực dữ liệu sản phẩm (hiển thị cho người dùng)
    Log.Error(ex.Message, ex);
    throw;
}
catch (KvValidateProductMedicineException ex) {
    // Ngoại lệ xác thực dữ liệu dược phẩm (hiển thị cho người dùng)
    Log.Error(ex.Message, ex);
    throw;
}
catch (KvException ex) {
    // Ngoại lệ nghiệp vụ KiotViet (có thể đã được xử lý)
    Log.Error(ex.Message, ex);
    throw;
}
catch (Exception ex) {
    // Ngoại lệ chung (chuyển đổi thành thông báo thân thiện)
    Log.Error(ex.Message, ex);
    throw new KvException(KVMessage._GlobalErrorSummary);
}
```

## 2. Các loại ngoại lệ

| Loại ngoại lệ | Mục đích | Ngữ cảnh sử dụng | Phản hồi UI |
|---------------|----------|-------------------|-------------|
| KvValidateProductException | Xác thực dữ liệu đầu vào chung | Lỗi định dạng JSON, trùng lặp dữ liệu, giới hạn số lượng | Thông báo chi tiết, hướng dẫn sửa |
| KvValidateProductMedicineException | Xác thực dữ liệu dược phẩm | Lỗi về nhà sản xuất, quốc gia, thông tin đặc thù ngành dược | Thông báo chuyên biệt cho ngành dược |
| KvException | Lỗi nghiệp vụ chung | Lỗi quyền hạn, lỗi hệ thống đã chuyển đổi | Thông báo chung, ít chi tiết |
| SqlException | Lỗi cơ sở dữ liệu | Xung đột dữ liệu, lỗi kết nối | Chuyển đổi thành KvException |

## 3. Bảng thông báo lỗi chuẩn

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
| _commission | Bảng hoa hồng | (Thông báo chung) | Thông tin về bảng hoa hồng |
| _commissionExistInActive | đã ngừng áp dụng/xóa | KvValidateProductException | Bảng hoa hồng đã ngừng áp dụng hoặc bị xóa |

## 4. Mẫu code xử lý lỗi

### 4.1 Xử lý lỗi định dạng dữ liệu

```csharp
try { 
    req.ListProducts = JsonConvert.DeserializeObject<List<ProductByBranchWithWarranty>>(formData["ListProductsString"]); 
}
catch (Exception ex) {
    throw new KvValidateProductException(KVMessage.invalidRequestParams, ex);
}
```

### 4.2 Xử lý lỗi giới hạn số lượng

```csharp
if (req.ListProducts.Count > 50 && req.ListProducts[0].ProductType == (int)ProductType.Manufactured) {
    throw new KvValidateProductException(KVMessage._product_ExceedingTheLimitComboProduct);
}

if (req.ListProducts.Count > 200) {
    throw new KvValidateProductException(KVMessage._product_ExceedingTheLimit);
}
```

### 4.3 Xử lý lỗi trùng lặp

```csharp
// Kiểm tra mã sản phẩm trùng lặp
if (lsParentProduct.Count != lsParentProduct.Select(x => x.Code).Distinct().Count()) {
    var codeUnitsDuplicate = lsParentProduct.GroupBy(x => x.Code)
        .Where(x => x.Skip(1).Any()).SelectMany(g => g).Distinct();
    if (codeUnitsDuplicate.Any()) {
        duplicateUnitCodes = codeUnitsDuplicate.Select(x => x.Code).Distinct().Join(", ");
    }
    throw new KvValidateProductException(string.Format(KVMessage._GlobalDuplicateData, 
        KVMessage.ProductLog_UnitCode + ": " + duplicateUnitCodes));
}

// Kiểm tra đơn vị trùng lặp
var temp1 = listProducts.Select(x => new { unit = x.Unit.ToLower(), attribute = x.AttributedName });
var temp2 = temp1.Where(x => x.attribute == temp1.FirstOrDefault().attribute);
if (temp2.Select(x => x.unit.ToLower()).Distinct().Count() != temp2.Select(x => x.unit).Count()) {
    throw new KvValidateProductException(KVMessage.duplicateUnitName);
}
```

### 4.4 Xử lý lỗi dược phẩm

```csharp
// Kiểm tra thông tin nhà sản xuất
if (!string.IsNullOrEmpty(firstProduct.GlobalManufacturerCountryName)) {
    globalManufacturerCountry = await GlobalManufacturerCountryService.GetByNameAsync(
        firstProduct.GlobalManufacturerCountryName.Trim());
    if (globalManufacturerCountry == null) {
        throw new KvValidateProductMedicineException(KVMessage.pharmacy_msgErrorManufacturerCountry);
    }
}

// Kiểm tra độ dài thông tin thuốc
if (firstParent.ShortName?.Length > 100) {
    throw new KvValidateProductMedicineException(KVMessage.product_ShortNameMaxLength);
}

if (firstParent.RouteOfAdministration?.Length > 200) {
    throw new KvValidateProductMedicineException(KVMessage.product_RouteOfAdministrationMaxLength);
}
```

## 5. Quy tắc chung

1. **Nhất quán trong thông báo**: Sử dụng hằng số KVMessage cho tất cả thông báo lỗi
2. **Phân loại ngoại lệ**: Chọn đúng loại ngoại lệ cho từng tình huống lỗi
3. **Chi tiết phù hợp**: Cung cấp thông tin chi tiết cho lỗi xác thực, thông tin chung cho lỗi hệ thống
4. **Ghi log**: Luôn ghi log trước khi ném ngoại lệ hoặc khi bắt ngoại lệ
5. **Chuyển đổi lỗi hệ thống**: Chuyển đổi lỗi hệ thống (Exception, SqlException) thành KvException với thông báo thân thiện

## 6. Quản lý giao dịch và lỗi

```csharp
using (var dbContextTransaction = Db.Database.BeginTransaction()) {
    try {
        // Thực hiện các thao tác cơ sở dữ liệu
        await Db.BulkInsertAsync(products);
        dbContextTransaction.Commit();
    }
    catch (SqlException sqlException) {
        dbContextTransaction.Rollback();
        HandleSqlException(sqlException); // Chuyển đổi thành ngoại lệ có nghiệp vụ
    }
    catch (Exception ex) {
        dbContextTransaction.Rollback();
        Log.Error(ex.Message, ex);
        throw new KvException(KVMessage._GlobalErrorSummary);
    }
}
```

## 7. Phản hồi cho người dùng

- **Lỗi xác thực**: Chuyển tiếp thông báo chi tiết đến UI để người dùng có thể sửa lỗi
- **Lỗi hệ thống**: Hiển thị thông báo chung, không tiết lộ chi tiết kỹ thuật
- **Lỗi nghiệp vụ**: Hiển thị thông báo thân thiện, có hướng dẫn tiếp theo nếu cần

---

**Liên kết tham khảo**:
- [1-Chuc-nang-xu-ly-du-lieu-dau-vao.md](./1-Chuc-nang-xu-ly-du-lieu-dau-vao.md) - Xử lý dữ liệu đầu vào
- [2-Chuc-nang-xac-thuc-san-pham.md](./2-Chuc-nang-xac-thuc-san-pham.md) - Xác thực sản phẩm
- [6-Chuc-nang-xu-ly-ngoai-le.md](./6-Chuc-nang-xu-ly-ngoai-le.md) - Xử lý ngoại lệ tổng thể
- [Tong-quan-Product-AddMany.md](./Tong-quan-Product-AddMany.md) - Tổng quan quy trình 