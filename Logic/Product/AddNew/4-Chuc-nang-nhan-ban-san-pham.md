# Nhân Bản Sản Phẩm - Post(ProductAddMany req)

## Mục Đích
Chức năng này cho phép tạo mới sản phẩm dựa trên thông tin của sản phẩm đã tồn tại (nhân bản/clone), giúp người dùng tiết kiệm thời gian khi thêm nhiều sản phẩm có thuộc tính tương tự nhau.

## Danh Sách Chức Năng Con

### 1. Xác thực sản phẩm nguồn (Clone Product)
#### Mô tả
Kiểm tra tính hợp lệ của sản phẩm nguồn được chỉ định bởi CloneProductId và lấy thông tin chi tiết.

#### Logic nghiệp vụ
- Kiểm tra CloneProductId có giá trị hợp lệ (> 0)
- Truy vấn thông tin sản phẩm từ ProductService.OrmGetByIdAsync
- Kiểm tra người dùng có quyền truy cập sản phẩm nguồn không

#### Thông số đầu vào/ra
- **Đầu vào**: req.CloneProductId
- **Đầu ra**: Đối tượng sản phẩm nguồn hoặc null, ghi thông tin vào log

#### Mã kiểm thử thất bại
```json
{
  "req": {
    "CloneProductId": -1  // ID không hợp lệ
  }
}
```

### 2. Sao chép thông tin sản phẩm nguồn
#### Mô tả
Sao chép các thuộc tính từ sản phẩm nguồn sang sản phẩm mới, bao gồm thông tin cơ bản và cấu hình.

#### Logic nghiệp vụ
- Đọc thông tin chi tiết sản phẩm nguồn
- Sao chép các thuộc tính cơ bản (tên, mô tả, danh mục, v.v.)
- Áp dụng các thuộc tính đặc biệt từ sản phẩm nguồn (IsBatchExpireControl, IsMedicineProduct, v.v.)

#### Thông số đầu vào/ra
- **Đầu vào**: Sản phẩm nguồn (cloneProduct), danh sách sản phẩm đích (lsParentProduct)
- **Đầu ra**: lsParentProduct với thông tin đã được cập nhật

#### Mã kiểm thử thất bại
```json
{
  "cloneProduct": null,  // Sản phẩm nguồn không tồn tại
  "lsParentProduct": [
    {"Id": 0, "Name": "Sản phẩm mới"}
  ]
}
```

### 3. Sao chép hình ảnh sản phẩm
#### Mô tả
Xử lý yêu cầu sao chép hình ảnh từ sản phẩm nguồn sang sản phẩm mới.

#### Logic nghiệp vụ
- Kiểm tra cờ SaveImagesForAllProducts để xác định phạm vi sao chép
- Gọi ProcessCloneProduct để xử lý sao chép hình ảnh
- Cập nhật danh sách globalProductsImages

#### Thông số đầu vào/ra
- **Đầu vào**: req, productsListToCloneImages, formData["SaveImagesForAllProducts"]
- **Đầu ra**: Cập nhật danh sách globalProductsImages

#### Mã kiểm thử thất bại
```json
{
  "req": {
    "CloneProductId": 1001  // Sản phẩm nguồn
  },
  "formData": {
    "SaveImagesForAllProducts": "true"
  },
  "productsListToCloneImages": []  // Danh sách rỗng
}
```

### 4. Sao chép bảng giá cho sản phẩm
#### Mô tả
Sao chép thông tin bảng giá từ sản phẩm nguồn sang sản phẩm mới.

#### Logic nghiệp vụ
- Gọi ProcessCloneProductPriceBook để xử lý sao chép thông tin bảng giá
- Kiểm tra và cập nhật thông tin bảng giá cho sản phẩm mới
- Trả về danh sách chi tiết bảng giá đã được sao chép

#### Thông số đầu vào/ra
- **Đầu vào**: req, listObjReturn (danh sách sản phẩm đã được xử lý)
- **Đầu ra**: priceBookDetailCloned (danh sách chi tiết bảng giá đã sao chép)

#### Mã kiểm thử thất bại
```json
{
  "req": {
    "CloneProductId": 0  // Không có sản phẩm nguồn
  },
  "listObjReturn": [
    {"Id": 1001, "Name": "Sản phẩm mới"}
  ]
}
```

### 5. Xử lý các thuộc tính đặc biệt (ngành dược)
#### Mô tả
Xử lý các thuộc tính đặc biệt cho ngành dược khi sao chép từ sản phẩm thuốc.

#### Logic nghiệp vụ
- Kiểm tra AuthService.Context.IsActiveGppDrugStore để xác định có áp dụng xử lý dược phẩm không
- Xác định các thuộc tính cần sao chép: ShortName, RegistrationNo, ActiveElement, v.v.
- Cập nhật thông tin cho sản phẩm mới

#### Thông số đầu vào/ra
- **Đầu vào**: cloneProduct, firstParent, AuthService.Context.IsActiveGppDrugStore
- **Đầu ra**: firstParent với thông tin đặc thù ngành dược đã được cập nhật

#### Mã kiểm thử thất bại
```json
{
  "AuthService": {
    "Context": {
      "IsActiveGppDrugStore": true
    }
  },
  "cloneProduct": {
    "IsMedicineProduct": true,
    "ShortName": null  // Thiếu thông tin bắt buộc
  },
  "firstParent": {
    "Id": 0, "Name": "Sản phẩm thuốc mới"
  }
}
```

### 6. Xử lý đơn vị sản phẩm và biến thể
#### Mô tả
Xử lý thông tin về đơn vị sản phẩm và các biến thể khi sao chép từ sản phẩm có nhiều đơn vị.

#### Logic nghiệp vụ
- Truy vấn thông tin đơn vị con từ sản phẩm nguồn
- Sao chép thông tin chuyển đổi đơn vị (ConversionValue)
- Cập nhật thông tin quan hệ cha-con giữa các đơn vị

#### Thông số đầu vào/ra
- **Đầu vào**: cloneProduct, childProducts
- **Đầu ra**: childProducts với thông tin đơn vị và biến thể đã được cập nhật

#### Mã kiểm thử thất bại
```json
{
  "cloneProduct": {
    "Id": 1001,
    "HasProductUnit": true
  },
  "childProducts": null  // Không có dữ liệu sản phẩm con
}
```

### 7. Xử lý công thức sản phẩm (cho sản phẩm chế biến)
#### Mô tả
Sao chép công thức sản phẩm cho sản phẩm chế biến từ sản phẩm nguồn.

#### Logic nghiệp vụ
- Kiểm tra sản phẩm nguồn có công thức không (ProductFormulas)
- Sao chép thông tin nguyên liệu và định lượng
- Cập nhật chi phí và thông tin sản xuất

#### Thông số đầu vào/ra
- **Đầu vào**: cloneProduct (sản phẩm nguồn), reqProduct (sản phẩm mới)
- **Đầu ra**: reqProduct với thông tin công thức đã được cập nhật

#### Mã kiểm thử thất bại
```json
{
  "cloneProduct": {
    "ProductType": 2,  // ProductType.Manufactured
    "ProductFormulas": [
      {"MaterialId": 1001, "Quantity": 2.0, "MaterialCode": "NL001"}
    ]
  },
  "reqProduct": {
    "ProductFormulas": null  // Chưa có danh sách công thức
  }
}
```

## Quy Trình Xử Lý Tổng Thể
1. Kiểm tra tính hợp lệ của CloneProductId
2. Lấy thông tin chi tiết sản phẩm nguồn
3. Sao chép các thuộc tính cơ bản cho sản phẩm mới
4. Xử lý các thuộc tính đặc thù theo ngành (dược phẩm nếu cần)
5. Tạo và cập nhật thông tin đơn vị và biến thể
6. Sao chép hình ảnh sản phẩm (nếu được yêu cầu)
7. Sao chép thông tin bảng giá
8. Xử lý công thức sản phẩm (cho sản phẩm chế biến)

## Phụ Thuộc Mã Nguồn
- Hàm `ProductService.OrmGetByIdAsync`: Lấy thông tin sản phẩm nguồn
- Hàm `ProcessCloneProduct`: Xử lý sao chép hình ảnh
- Hàm `ProcessCloneProductPriceBook`: Xử lý sao chép bảng giá
- Các dịch vụ xác thực và kiểm tra quyền: AuthService

## Điểm Lưu Ý Quan Trọng
1. Mã sản phẩm và barcode không được sao chép từ sản phẩm nguồn, cần được tạo mới
2. Thông tin tồn kho không được sao chép từ sản phẩm nguồn
3. Hình ảnh sản phẩm có thể được sao chép tùy theo cấu hình SaveImagesForAllProducts
4. Với sản phẩm thuốc, cần đảm bảo các thông tin đặc thù ngành dược được sao chép đầy đủ
5. Thông tin công thức sản phẩm cần được cập nhật đúng với tham chiếu nguyên liệu mới

## Cấu Hình Dữ Liệu Kiểm Thử Thất Bại

### 1. Sản phẩm nguồn không tồn tại
```json
{
  "req": {
    "CloneProductId": 99999,
    "ListProducts": [
      {
        "Code": "SP001",
        "Name": "Sản phẩm mới A"
      }
    ]
  },
  "ExpectedResult": {
    "Exception": "KvValidateProductException",
    "Message": "Sản phẩm gốc không tồn tại"
  }
}
```
**Kết quả kiểm tra**: Hệ thống phát hiện và báo lỗi khi sản phẩm nguồn không tồn tại, ngăn chặn việc nhân bản từ dữ liệu không hợp lệ.

### 2. Không có quyền truy cập sản phẩm nguồn
```json
{
  "req": {
    "CloneProductId": 1001
  },
  "AuthService": {
    "HasPermission": false
  },
  "ExpectedResult": {
    "Exception": "KvValidateProductException",
    "Message": "Không có quyền truy cập sản phẩm gốc"
  }
}
```
**Kết quả kiểm tra**: Hệ thống xác thực quyền truy cập và báo lỗi khi người dùng không có quyền với sản phẩm nguồn, đảm bảo tính bảo mật dữ liệu.

### 3. Thông tin không nhất quán giữa sản phẩm nguồn và mới
```json
{
  "cloneProduct": {
    "ProductType": 2,
    "HasProductUnit": false
  },
  "reqProduct": {
    "ProductType": 1,
    "HasProductUnit": true
  },
  "ExpectedResult": {
    "Exception": "KvValidateProductException",
    "Message": "Thông tin không nhất quán với sản phẩm gốc"
  }
}
```
**Kết quả kiểm tra**: Hệ thống phát hiện và báo lỗi khi có sự không nhất quán giữa loại sản phẩm nguồn và sản phẩm mới, đảm bảo tính toàn vẹn dữ liệu.

## Quy Tắc Nghiệp Vụ
1. Sản phẩm nguồn và người dùng phải thuộc cùng một người bán lẻ (RetailerId)
2. Sản phẩm được nhân bản cần có mã sản phẩm (Code) và tên sản phẩm (Name) mới
3. Mặc định, các thuộc tính cơ bản và cấu trúc sản phẩm sẽ được sao chép
4. Thông tin liên quan đến tồn kho, doanh số và các số liệu khác không được sao chép
5. Hình ảnh sản phẩm có thể được sao chép tùy theo cấu hình (tham chiếu hoặc tạo bản sao mới)
6. Đối với sản phẩm có biến thể, cấu trúc biến thể được sao chép nhưng người dùng cần tạo các biến thể cụ thể 

# Phân tích Business Logic của chức năng Nhân Bản Sản Phẩm

## Các bước xử lý chính

### 1. Truy xuất và xác thực sản phẩm nguồn
- **Kiểm tra tính hợp lệ của sản phẩm nguồn**:
  - Kiểm tra `CloneProductId` có giá trị lớn hơn 0
  - Gọi `ProductService.OrmGetByIdAsync(req.CloneProductId)` để lấy thông tin sản phẩm
  - Kiểm tra sản phẩm nguồn có tồn tại không và có thể truy cập được không

- **Xác thực quyền truy cập**:
  - Kiểm tra người dùng có quyền truy cập sản phẩm nguồn không
  - Đảm bảo sản phẩm nguồn và người dùng thuộc cùng một người bán lẻ (RetailerId)
  - Ném ngoại lệ `KvValidateProductException` nếu không thỏa mãn điều kiện

### 2. Sao chép thuộc tính cơ bản
- **Áp dụng thuộc tính từ sản phẩm nguồn**:
  - Cấu hình lưu trữ và quản lý: `IsBatchExpireControl`, `IsMedicineProduct` 
  - Thuộc tính cơ bản: `CategoryId`, `isActive`, `AllowsSale`
  - Cấu hình kinh doanh: `IsRewardPoint`, `RewardPoint`, `TaxId`
  - Mô tả và nội dung chi tiết: `Description`

- **Xử lý thông tin không được sao chép**:
  - **Mã sản phẩm, mã vạch**: Tạo mới hoặc sử dụng giá trị từ input
  - **Thông tin tồn kho**: Không sao chép, sử dụng giá trị từ input hoặc mặc định
  - **Thời gian tạo và người tạo**: Thiết lập theo người dùng và thời gian hiện tại
  - **Các số liệu thống kê và lịch sử**: Không sao chép, bắt đầu từ 0

### 3. Xử lý cấu trúc sản phẩm đặc biệt
- **Sao chép thông tin đơn vị sản phẩm**:
  - Truy vấn thông tin đơn vị con từ sản phẩm nguồn
  - Sao chép các thuộc tính `ConversionValue` (hệ số chuyển đổi) giữa các đơn vị
  - Thiết lập mối quan hệ cha-con giữa các đơn vị mới

- **Xử lý công thức sản phẩm (sản phẩm combo hoặc chế biến)**:
  - Kiểm tra sản phẩm nguồn có công thức không (`ProductFormulas`)
  - Sao chép danh sách nguyên liệu và định lượng tương ứng
  - Cập nhật và tính toán lại chi phí sản xuất nếu cần

### 4. Xử lý thông tin đặc thù ngành
- **Xử lý thông tin dược phẩm**:
  - Kiểm tra `AuthService.Context.IsActiveGppDrugStore` để xác định có xử lý thông tin dược phẩm không
  - Sao chép thuộc tính đặc thù: `ShortName`, `RegistrationNo`, `ActiveElement`, `Content`
  - Sao chép thông tin nhà sản xuất: `GlobalManufacturerCountryId`, `GlobalManufacturerId`

- **Xử lý thông tin ngành đặc thù khác**:
  - Ngành xây dựng: `ProductExtraMaterials` với các thuộc tính vật liệu
  - Thời trang: Thuộc tính kích thước, màu sắc, v.v.
  - Các thông tin ngành khác tùy theo cấu hình

### 5. Sao chép dữ liệu bổ sung
- **Sao chép thông tin bảng giá**:
  - Gọi `ProcessCloneProductPriceBook(req, listObjReturn)` để sao chép bảng giá
  - Duy trì các mối quan hệ giá đặc biệt áp dụng cho sản phẩm
  - Đảm bảo tính nhất quán của giá giữa các phiên bản sản phẩm

- **Sao chép thông tin kệ hàng**:
  - Duy trì liên kết giữa sản phẩm và kệ hàng
  - Sao chép các thông tin vị trí trong kho

## Mã nguồn tham chiếu chính
```csharp
// Kiểm tra và lấy thông tin sản phẩm nguồn
if (req.CloneProductId > 0) {
    try {
        var cloneProduct = await ProductService.OrmGetByIdAsync(req.CloneProductId);
        if (cloneProduct != null) {
            // Xác thực quyền truy cập
            if (!AuthService.CheckPermission(cloneProduct)) {
                throw new KvValidateProductException(KVMessage.permission_denied);
            }
            
            // Áp dụng thuộc tính cơ bản
            firstParent.CategoryId = cloneProduct.CategoryId;
            firstParent.TaxId = cloneProduct.TaxId;
            firstParent.IsBatchExpireControl = cloneProduct.IsBatchExpireControl;
            firstParent.AllowsSale = cloneProduct.AllowsSale;
            firstParent.IsRewardPoint = cloneProduct.IsRewardPoint;
            firstParent.RewardPoint = cloneProduct.RewardPoint;
            firstParent.Description = cloneProduct.Description;
            
            // Xử lý thông tin dược phẩm
            if (AuthService.Context.IsActiveGppDrugStore) {
                firstParent.IsMedicineProduct = cloneProduct.IsMedicineProduct;
                firstParent.ShortName = cloneProduct.ShortName;
                firstParent.RegistrationNo = cloneProduct.RegistrationNo;
                firstParent.ActiveElement = cloneProduct.ActiveElement;
                firstParent.Content = cloneProduct.Content;
                firstParent.PackagingSize = cloneProduct.PackagingSize;
                firstParent.GlobalManufacturerId = cloneProduct.GlobalManufacturerId;
                firstParent.GlobalManufacturerName = cloneProduct.GlobalManufacturerName;
                firstParent.GlobalManufacturerCountryId = cloneProduct.GlobalManufacturerCountryId;
                firstParent.GlobalManufacturerCountryName = cloneProduct.GlobalManufacturerCountryName;
                firstParent.RouteOfAdministration = cloneProduct.RouteOfAdministration;
            }
            
            // Sao chép công thức sản phẩm
            if (cloneProduct.Formula != null && cloneProduct.Formula.Any()) {
                var productFormulas = reqProduct.ProductFormulas ?? new List<CustomerModelProductFormula>();
                foreach (var formula in cloneProduct.Formula) {
                    productFormulas.Add(new CustomerModelProductFormula {
                        MaterialId = formula.MaterialId,
                        MaterialCode = formula.Material?.Code,
                        Quantity = formula.Quantity,
                        Cost = formula.Cost
                    });
                }
                reqProduct.ProductFormulas = productFormulas;
                
                // Tính toán lại giá vốn từ công thức
                var formulaCost = cloneProduct.Formula.Sum(f => 
                    f.Cost * (decimal)f.Quantity);
                reqProduct.Cost = NumberHelper.RoundProductPrice(formulaCost, currentCurrency.CurrencyDecimalPlaceForProduct) ?? 0;
            }
        }
    }
    catch (Exception ex) {
        Log.Error(ex.Message, ex);
        // Xử lý ngoại lệ khi truy vấn sản phẩm nguồn
    }
}
```

## Các vấn đề kỹ thuật quan trọng
### 1. Xử lý mã sản phẩm và mã vạch
- Mã sản phẩm (Code) và mã vạch (Barcode) không được sao chép từ sản phẩm nguồn để đảm bảo tính duy nhất
- Có thể tạo mã tự động qua `ProductService.BatchCreateUniqCodeAsync` hoặc sử dụng mã do người dùng chỉ định
- Mã vạch mới có thể được tạo tự động hoặc để trống cho người dùng cập nhật sau

### 2. Xử lý dữ liệu tồn kho
- Dữ liệu tồn kho không được sao chép từ sản phẩm nguồn
- Tồn kho ban đầu được thiết lập từ dữ liệu đầu vào hoặc mặc định là 0
- Các thiết lập giới hạn tồn kho (MinQuantity, MaxQuantity) có thể được sao chép từ sản phẩm nguồn

### 3. Xử lý giá vốn và giá bán
- Giá vốn (Cost) có thể được sao chép từ sản phẩm nguồn hoặc tính toán lại từ công thức
- Giá bán (BasePrice) có thể được sao chép từ sản phẩm nguồn hoặc nhập mới
- Các giá đặc biệt từ bảng giá được sao chép thông qua `ProcessCloneProductPriceBook`

### 4. Xử lý quan hệ đơn vị và sản phẩm con
- Cấu trúc quan hệ cha-con giữa các sản phẩm và đơn vị được duy trì qua các trường MasterProductId và MasterUnitId
- Hệ số chuyển đổi (ConversionValue) được sao chép chính xác để đảm bảo tính toán số lượng đúng
- Khi sản phẩm cha được nhân bản, tất cả sản phẩm con cũng được nhân bản tương ứng

## Test Data JSON cho các trường hợp thất bại

### 1. Sản phẩm nguồn không tồn tại
```json
{
  "req": {
    "CloneProductId": 99999,
    "ListProducts": [
      {
        "Code": "SP001",
        "Name": "Sản phẩm mới A"
      }
    ]
  },
  "ExpectedResult": {
    "Exception": "KvValidateProductException",
    "Message": "Sản phẩm gốc không tồn tại"
  }
}
```

### 2. Không có quyền truy cập sản phẩm nguồn
```json
{
  "req": {
    "CloneProductId": 1001
  },
  "AuthService": {
    "CheckPermission": false
  },
  "ExpectedResult": {
    "Exception": "KvValidateProductException",
    "Message": "Không có quyền truy cập"
  }
}
```

---
**Điều hướng**
- Trước đó: [3-Chuc-nang-quan-ly-hinh-anh.md](./3-Chuc-nang-quan-ly-hinh-anh.md)
- Tiếp theo: [5-Chuc-nang-dong-bo-hoa-da-chi-nhanh.md](./5-Chuc-nang-dong-bo-hoa-da-chi-nhanh.md)
- Tổng quan: [Tong-quan-Product-AddMany.md](./Tong-quan-Product-AddMany.md) 