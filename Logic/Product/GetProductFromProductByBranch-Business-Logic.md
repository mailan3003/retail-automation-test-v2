# Business Logic của phương thức GetProductFromProductByBranch

## Tổng quan
Phương thức `GetProductFromProductByBranch()` thực hiện chuyển đổi dữ liệu từ cấu trúc `ProductByBranch` sang cấu trúc `Product` đồng thời áp dụng các quy tắc nghiệp vụ và kiểm tra tính hợp lệ của dữ liệu trong quá trình chuyển đổi.

## Chi tiết triển khai

### Input
- Danh sách các đối tượng `ProductByBranch` chứa thông tin sản phẩm theo chi nhánh

### Quy trình xử lý

#### 1. Kiểm tra dữ liệu đầu vào
- Nếu danh sách rỗng, ném ngoại lệ `KvValidateProductException` với thông báo lỗi tổng quát
- Trích xuất các thông tin cần thiết từ danh sách đầu vào:
  - Mã sản phẩm (`listProductCode`)
  - ID đơn vị chính (`lsMasterUnitId`)
  - Mã vạch sản phẩm (`lsBarcodeProduct`)

#### 2. Kiểm tra trùng lặp trong cơ sở dữ liệu
- Truy vấn tất cả sản phẩm từ DB dựa trên các điều kiện sau:
  - Mã sản phẩm nằm trong danh sách `listProductCode`
  - Hoặc ID sản phẩm nằm trong danh sách `lsMasterUnitId`
  - Hoặc ID đơn vị chính nằm trong danh sách `lsMasterUnitId`
  - Hoặc mã vạch nằm trong danh sách `lsBarcodeProduct`
  - Và sản phẩm chưa bị xóa (`isDeleted == null || !isDeleted.Value`)

- Kiểm tra trùng lặp mã sản phẩm:
  - Nếu có sản phẩm trong DB trùng mã với danh sách đầu vào, ném ngoại lệ với thông báo trùng lặp mã sản phẩm

- Kiểm tra trùng lặp mã vạch:
  - Nếu có sản phẩm trong DB trùng mã vạch với danh sách đầu vào, ném ngoại lệ với thông báo trùng lặp mã vạch

#### 3. Kiểm tra các ràng buộc đặc biệt
- Lấy danh sách sản phẩm có đơn vị chính từ DB:
  - Truy vấn tất cả sản phẩm có ID nằm trong danh sách `lsMasterUnitId`
  - Chỉ lấy các sản phẩm chưa bị xóa (`isDeleted == null || !isDeleted.Value`)
  - Kết quả được lưu vào biến `lsProductMasterUnit`

- Kiểm tra công thức sản phẩm:
  - Lấy sản phẩm đầu tiên từ danh sách đầu vào để kiểm tra
  - Nếu sản phẩm có công thức (`ProductFormulas != null`):
    - Gọi `productFormulaService.ValidateListFormula()` để xác thực danh sách công thức
    - Truyền vào ID sản phẩm và danh sách ID vật liệu từ công thức
  - Chỉ kiểm tra với sản phẩm đầu tiên vì tất cả sản phẩm trong danh sách đều có cùng giá trị công thức
  - Chi tiết logic triển khai: [Xem tại đây](./ValidateListFormula-Business-Logic.md)

- Kiểm tra kệ hàng sản phẩm:
  - Lấy sản phẩm đầu tiên từ danh sách đầu vào để kiểm tra
  - Nếu sản phẩm có kệ hàng (`ProductShelves != null && ProductShelves.Any()`):
    - Lấy danh sách ID kệ hàng từ sản phẩm
    - Đếm số lượng kệ hàng tồn tại trong hệ thống dựa trên danh sách ID
    - So sánh với số lượng kệ hàng của sản phẩm
    - Nếu số lượng không khớp, ném ngoại lệ `KvValidateProductException` với thông báo kệ hàng không tồn tại

#### 4. Xử lý và chuyển đổi từng sản phẩm
Với mỗi sản phẩm trong danh sách, thực hiện:

- **Chuẩn hóa giá trị chuyển đổi**:
  - Nếu `ConversionValue <= 0`, đặt giá trị mặc định là 1

- **Xử lý sản phẩm chính**:
  - Nếu `MasterProductId == 0`, đặt giá trị là `null`

- **Chuẩn hóa mô tả và tên sản phẩm**:
  - Thay thế các ký tự đặc biệt trong `Description` và `Name`
  - Loại bỏ khoảng trắng thừa trong tên sản phẩm

- **Xử lý thuộc tính sản phẩm**:
  - Chuẩn hóa các giá trị thuộc tính nếu có

- **Kiểm tra kiểm soát lô/serial**:
  - Nếu sản phẩm có kiểm soát lô/serial, đặt `OnHand = CompareOnHand`

- **Xác định loại sản phẩm**:
  - Mặc định là sản phẩm mua nếu không thuộc một trong các loại: sản xuất, mua, dịch vụ

- **Kiểm tra đơn vị sản phẩm**:
  - Đối với sản phẩm có kiểm soát serial, không được có đơn vị sản phẩm phụ
  - Kiểm tra tính hợp lệ của đơn vị chính và đơn vị con
  - Đảm bảo không trùng tên đơn vị trong cùng một nhóm sản phẩm

- **Kiểm tra độ dài các trường thông tin**:
  - Mã sản phẩm không vượt quá 40 ký tự
  - Mã vạch không vượt quá 16 ký tự
  - Kiểm tra đơn vị tính của sản phẩm:
    - Nếu sản phẩm có đơn vị con (`MasterUnitId != null`):
      - Đảm bảo trường `Unit` không được để trống, nếu trống thì ném ngoại lệ `KvValidateProductException` với thông báo `product_notInputUnit` ("Chưa nhập đơn vị cơ bản")
      - Tìm sản phẩm cha trong danh sách `lsProductMasterUnit` dựa trên `MasterUnitId`
      - Nếu sản phẩm cha có thuộc tính `MasterUnitId` không null, ném ngoại lệ `KvValidateProductException` với thông báo `invalidMasterUnitId` ("MasterUnitId không hợp lệ") (không cho phép đơn vị nhiều cấp)
      - Nếu sản phẩm cha có cùng tên đơn vị với sản phẩm hiện tại:
        - Kiểm tra trong danh sách đơn vị con của sản phẩm cha
        - Nếu đã có đơn vị con nào đang hoạt động có cùng tên, ném ngoại lệ `KvValidateProductException` với thông báo `duplicateUnitName` ("Tên đơn vị tính không được phép trùng nhau")
      - Kiểm tra tất cả các sản phẩm con khác của cùng sản phẩm cha:
        - Lấy danh sách các sản phẩm con đang hoạt động (không bị xóa) có cùng `MasterUnitId`
        - Nếu có sản phẩm con nào có cùng tên đơn vị, ném ngoại lệ `KvValidateProductException` với thông báo `duplicateUnitName` ("Tên đơn vị tính không được phép trùng nhau")
  - Tên đầy đủ không vượt quá 500 ký tự

- **Tạo đối tượng sản phẩm mới**:
  - Chuyển đổi thông tin từ `ProductByBranch` sang `Product`
  - Xử lý các thông tin bổ sung (vật liệu, thuộc tính mở rộng) nếu có

### Xử lý ngoại lệ
Phương thức ném các ngoại lệ `KvValidateProductException` trong các trường hợp:
- Danh sách sản phẩm đầu vào rỗng
- Trùng lặp mã sản phẩm hoặc mã vạch
- Kệ hàng không tồn tại
- Sản phẩm kiểm soát serial không thể có đơn vị phụ
- Độ dài mã sản phẩm hoặc mã vạch vượt quá giới hạn
- Đơn vị sản phẩm không hợp lệ
- Trùng lặp tên đơn vị
- Tên đầy đủ vượt quá giới hạn

### Output
- Trả về danh sách các đối tượng `Product` đã được chuyển đổi và xác thực

## Mã nguồn tham chiếu chính
```csharp
public async Task<List<Product>> GetProductFromProductByBranch(List<ProductByBranch> lsProductByBranch)
{
    // Kiểm tra đầu vào
    if (lsProductByBranch == null || !lsProductByBranch.Any())
        throw new KvValidateProductException(KVMessage._GlobalErrorSummary);

    var results = new List<Product>();
    var listProductCode = lsProductByBranch.Where(x => !string.IsNullOrEmpty(x.Code)).Select(x => x.Code).ToList();
    var lsMasterUnitId = lsProductByBranch.Where(pb => pb.MasterUnitId.HasValue).Select(pb => pb.MasterUnitId).ToArray();
    var lsBarcodeProduct = lsProductByBranch.Where(x => !string.IsNullOrEmpty(x.Barcode)).Select(x => x.Barcode).ToList();

    // Truy vấn sản phẩm từ CSDL
    var allProducts = await GetAll()
        .Where(x => (
                listProductCode.Contains(x.Code) ||
                lsMasterUnitId.Contains(x.Id) ||
                lsMasterUnitId.Contains(x.MasterUnitId) ||
                lsBarcodeProduct.Contains(x.Barcode)
            ) &&
            (x.isDeleted == null || !x.isDeleted.Value))
        .ToListAsync();

    // Kiểm tra trùng lặp mã sản phẩm
    var listDuplicateProducts = allProducts.Where(c => listProductCode.Contains(c.Code, StringComparer.OrdinalIgnoreCase)).Select(x => x.Code).ToArray();
    if (listDuplicateProducts != null && listDuplicateProducts.Any())
        throw new KvValidateProductException(string.Format(KVMessage._GlobalDuplicateData, $"{KVMessage.ProductLog_ProductCode}: {listDuplicateProducts.Join(", ")}"));

    // Kiểm tra trùng lặp mã vạch
    listDuplicateProducts = allProducts.Where(c => lsBarcodeProduct.Contains(c.Barcode, StringComparer.OrdinalIgnoreCase) && !(c.isDeleted ?? false)).Select(x => x.Barcode).ToArray();
    if (listDuplicateProducts != null && listDuplicateProducts.Any())
        throw new KvValidateProductException(string.Format(KVMessage._GlobalDuplicateData, $"{Labels.productLog_Barcode} {listDuplicateProducts.Join(", ")}"));

    // Xử lý từng sản phẩm trong danh sách
    lsProductByBranch.ForEach(entity =>
    {
        // Chuẩn hóa các giá trị
        if (entity.ConversionValue <= 0)
            entity.ConversionValue = 1;

        if (entity.MasterProductId == 0)
            entity.MasterProductId = null;

        // Chuyển đổi mô tả và tên
        // ...

        // Kiểm tra điều kiện hợp lệ
        // ...

        // Tạo đối tượng sản phẩm mới
        var newProduct = new Product
        {
            Id = entity.Id,
            Code = Regex.Replace(entity.Code, @"\s+", " "),
            Name = entity.Name,
            // ...
        };

        results.Add(newProduct);
    });

    return results;
}
```

## Lưu ý quan trọng
1. Phương thức này đảm bảo tính nhất quán của dữ liệu khi chuyển đổi từ mô hình `ProductByBranch` sang `Product`
2. Thực hiện nhiều kiểm tra nghiệp vụ quan trọng như:
   - Ngăn chặn trùng lặp mã sản phẩm và mã vạch
   - Đảm bảo tính hợp lệ của mối quan hệ giữa sản phẩm chính và sản phẩm con
   - Kiểm soát các quy tắc đặc biệt cho sản phẩm có kiểm soát lô/serial
3. Xử lý và chuẩn hóa dữ liệu trước khi lưu vào cơ sở dữ liệu
4. Phương thức này là một phần quan trọng trong quy trình thêm mới sản phẩm, đảm bảo dữ liệu đầu vào đã được kiểm tra kỹ lưỡng trước khi tiếp tục xử lý 