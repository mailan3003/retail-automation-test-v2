# Business Logic của phương thức ValidateListFormula

## Tổng quan
Phương thức `ValidateListFormula()` thực hiện xác thực tính hợp lệ của công thức sản phẩm, bao gồm kiểm tra vòng lặp vô hạn, kiểm tra cấp bậc công thức và đảm bảo tuân thủ các ràng buộc nghiệp vụ quan trọng trong việc định nghĩa công thức sản phẩm.

## Chi tiết triển khai

### Input
- `productId`: ID của sản phẩm cần xác thực công thức
- `lstMaterialId`: Danh sách ID các vật liệu/sản phẩm con được sử dụng trong công thức

### Quy trình xử lý

#### 1. Kiểm tra dữ liệu đầu vào
- Nếu danh sách vật liệu rỗng, kết thúc phương thức (không có vật liệu để xác thực)
- Kiểm tra ngay nếu sản phẩm tự tham chiếu đến chính nó trong công thức:
  - Nếu `lstMaterialId` chứa `productId`, lấy mã sản phẩm và ném ngoại lệ với thông báo lỗi `{0}: Hàng thành phần và hàng sản xuất không được lồng nhau` (`product_RecursiveHierachyProduct`)

#### 2. Kiểm tra sản phẩm con
- Kiểm tra các vật liệu phải là sản phẩm chính (không phải đơn vị con):
  - Truy vấn danh sách mã của các sản phẩm có `MasterUnitId` (tức là sản phẩm đơn vị con) trong danh sách vật liệu
  - Nếu có sản phẩm đơn vị con, ném ngoại lệ với thông báo `không cho phép sử dụng sản phẩm không phải đơn vị chính trong công thức` (`product_NotPrimitive`)

#### 3. Kiểm tra đệ quy và cấp bậc công thức
- Truy vấn công thức cha (sản phẩm cha sử dụng sản phẩm hiện tại):
  - Gọi stored procedure `Pr_Product_Get_Parent_Formula(productId)` để lấy danh sách các sản phẩm cha
  - Nếu `productId = 0` (sản phẩm mới), sử dụng danh sách trống

- Truy vấn công thức con (sản phẩm con được sử dụng bởi vật liệu hiện tại):
  - Gọi stored procedure `Pr_Product_Get_Child_Formula(materialIdJoined)` để lấy danh sách các sản phẩm con
  - Tìm kiếm các trường hợp vòng lặp đệ quy:
    - Kiểm tra xem có vật liệu nào trong công thức hiện tại cũng là sản phẩm cha không
    - Kiểm tra xem có sản phẩm cha nào sử dụng vật liệu trong danh sách sản phẩm con không
    - Nếu phát hiện vòng lặp, ném ngoại lệ với thông báo lỗi vòng lặp đệ quy

#### 4. Kiểm tra độ sâu tối đa của công thức
- Tính toán độ sâu tối đa của công thức:
  - Lấy cấp độ cao nhất từ phía sản phẩm cha (`maxParentLevel`)
  - Lấy cấp độ cao nhất từ phía sản phẩm con (`maxChildLevel`) 
  - Kiểm tra tổng độ sâu có vượt quá giới hạn cho phép (`MaxFormulaLevelSupported`) không
  
- Nếu vượt quá giới hạn, xác định nguyên nhân và hiển thị thông báo lỗi phù hợp:
  - Trường hợp 1: Chỉ có sản phẩm con vượt quá giới hạn (không có sản phẩm cha)
  - Trường hợp 2: Chỉ có sản phẩm cha vượt quá giới hạn (không có sản phẩm con)
  - Trường hợp 3: Cả sản phẩm cha và con đều góp phần vượt quá giới hạn

### Xử lý ngoại lệ
Phương thức ném ngoại lệ `KvValidateProductException` trong các trường hợp:
- Sản phẩm tự tham chiếu chính nó trong công thức
- Sử dụng sản phẩm đơn vị con trong công thức
- Phát hiện vòng lặp đệ quy trong cấu trúc công thức
- Độ sâu của công thức vượt quá giới hạn cho phép

### Output
- Không có giá trị trả về (void), nhưng sẽ ném ngoại lệ nếu phát hiện bất kỳ vấn đề nào
- Nếu phương thức hoàn thành mà không có ngoại lệ, công thức được coi là hợp lệ

## Mã nguồn tham chiếu chính
```csharp
public async Task ValidateListFormula(long productId, IList<long> lstMaterialId)
{
    // Kiểm tra danh sách vật liệu rỗng
    if (!lstMaterialId.Any())
    {
        return;
    }
    
    // Kiểm tra sản phẩm tự tham chiếu chính nó
    if (lstMaterialId.Contains(productId))
    {
        var productCode = await ProductService.GetProductsWithoutPermission()
            .Where(p => p.Id == productId)
            .Select(p => p.Code)
            .FirstOrDefaultAsync();
        throw new KvValidateProductException(string.Format(KVMessage.product_RecursiveHierachyProduct, productCode));
    }

    // Kiểm tra sản phẩm đơn vị con
    var lstNotPrimary = await ProductService.GetProductsWithoutPermission()
        .Where(p => p.MasterUnitId.HasValue)
        .WhereIn(lstMaterialId, p => p.Id)
        .Select(p => p.Code).ToListAsync();
    if (lstNotPrimary.Any())
    {
        throw new KvValidateProductException(string.Format(KVMessage.product_NotPrimitive, string.Join(",", lstNotPrimary.Join(","))));
    }
    
    // Truy vấn công thức cha và con
    var parents = productId > 0 ? Db.Pr_Product_Get_Parent_Formula(productId).ToList() : new List<Pr_Product_Get_Parent_Formula_Result>();
    var materialIdJoined = lstMaterialId.Join(",");
    var children = Db.Pr_Product_Get_Child_Formula(materialIdJoined).ToList();
    
    // Kiểm tra vòng lặp đệ quy
    var setRecursiveId = lstMaterialId.Where(m => parents.Any(pf => pf.ProductId == m)).ToHashSet();
    var lstChildRecursiveId = children.Where(cf => parents.Any(pf => pf.ProductId == cf.MaterialId))
        .Select(cf => cf.RootId ?? 0).ToList();
    setRecursiveId.UnionWith(lstChildRecursiveId);
    if (setRecursiveId.Any())
    {
        var recursiveCodes = await ProductService.GetProductsWithoutPermission()
            .WhereIn(setRecursiveId, p => p.Id)
            .Select(p => p.Code).ToListAsync();
        throw new KvValidateProductException(string.Format(KVMessage.product_RecursiveHierachyProduct, string.Join(",", recursiveCodes)));
    }
    
    // Kiểm tra độ sâu tối đa của công thức
    var maxParentLevel = parents.Max(f => f.Level) ?? 0;
    var maxChildLevel = children.Max(f => f.Level) ?? 0;
    if (maxParentLevel + maxChildLevel + 1 > MaxFormulaLevelSupported)
    {
        // Xử lý các trường hợp vượt quá giới hạn độ sâu
        // ...
    }
}
```

## Lưu ý quan trọng
1. Phương thức này đảm bảo tính toàn vẹn của cấu trúc công thức sản phẩm bằng cách kiểm tra:
   - Không có vòng lặp đệ quy (sản phẩm A không thể chứa sản phẩm B nếu B đã chứa A)
   - Chỉ sử dụng sản phẩm chính (không sử dụng sản phẩm đơn vị con) trong công thức
   - Độ sâu của cây công thức không vượt quá giới hạn cho phép
   
2. Các kiểm tra này rất quan trọng để tránh:
   - Vòng lặp vô hạn khi tính toán số lượng vật liệu cần thiết
   - Lỗi logic khi sử dụng đơn vị con thay vì đơn vị chính
   - Hiệu suất kém do công thức quá phức tạp
   
3. Phương thức sử dụng stored procedure để tối ưu hiệu suất khi truy vấn cấu trúc công thức

4. Thông báo lỗi được tùy chỉnh tùy thuộc vào nguyên nhân cụ thể của vấn đề, giúp người dùng dễ dàng hiểu và khắc phục 