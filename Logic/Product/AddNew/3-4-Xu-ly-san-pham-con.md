# Phân tích Business Logic của chức năng xử lý sản phẩm con

## Tổng quan
Sau khi đã xử lý sản phẩm cha (parent product), hệ thống tiến hành xử lý các sản phẩm con (child products) liên quan. Quá trình này đảm bảo mối quan hệ phân cấp giữa sản phẩm cha và sản phẩm con, đồng thời xử lý các thông tin cụ thể cho từng sản phẩm con.

## Các bước xử lý chính

### 1. Xác định danh sách sản phẩm con
- **Lấy danh sách sản phẩm con**:
  ```csharp
  var childProducts = listProductsToAdd
      .Where(x => x.MasterCode == customMasterCode.Value && x.Code != objReturn.Code)
      .ToList();
  ```
  - Lọc từ danh sách sản phẩm cần thêm (`listProductsToAdd`)
  - Điều kiện lọc:
    - Mã chính (`MasterCode`) trùng với mã chính tùy chỉnh của sản phẩm cha
    - Mã sản phẩm (`Code`) khác với mã sản phẩm cha
  - Chuyển kết quả thành danh sách để xử lý

### 2. Kiểm tra tồn tại sản phẩm con
- **Bỏ qua xử lý nếu không có sản phẩm con**:
  ```csharp
  if (!childProducts.Any()) continue;
  ```
  - Kiểm tra nếu danh sách sản phẩm con rỗng
  - Nếu không có sản phẩm con, bỏ qua các bước xử lý tiếp theo và chuyển sang sản phẩm cha tiếp theo

### 3. Xác thực mã sản phẩm con
- **Kiểm tra trùng lặp mã sản phẩm con**:
  ```csharp
  ValidateDuplicateCodeChildProducts(childProducts);
  ```
  - Gọi phương thức `ValidateDuplicateCodeChildProducts` để kiểm tra trùng lặp mã giữa các sản phẩm con
  - Đảm bảo tính duy nhất của mã sản phẩm trong hệ thống

### 4. Cập nhật thông tin sản phẩm con
- **Cập nhật các thuộc tính quan trọng**:
  ```csharp
  childProducts.ForEach(o =>
  {
      o.MasterCode = firstParent.MasterCode;
      o.MasterUnitId = objReturn.Id;
      o.MasterProductId = firstParent.Id;
      o.CreatedDate = DateTime.Now;
      o.RetailerId = CurrentRetailerId;
      o.IsMedicineProduct = firstParent.IsMedicineProduct;
      o.IsBatchExpireControl = firstParent.IsBatchExpireControl;
      o.isActive = firstParent.isActive;
  });
  ```
  - Sử dụng phương thức `ForEach` để duyệt qua từng sản phẩm con
  - Đồng bộ các thuộc tính quan trọng với sản phẩm cha đầu tiên:
    - `MasterCode`: Mã chính từ sản phẩm cha đầu tiên
    - `MasterUnitId`: ID của sản phẩm cha hiện tại
    - `MasterProductId`: ID của sản phẩm cha đầu tiên (sản phẩm chính)
    - `CreatedDate`: Thời gian hiện tại
    - `RetailerId`: ID nhà bán lẻ hiện tại
    - `IsMedicineProduct`: Trạng thái sản phẩm thuốc
    - `IsBatchExpireControl`: Trạng thái kiểm soát lô và hạn sử dụng
    - `isActive`: Trạng thái hoạt động

### 5. Lưu sản phẩm con vào cơ sở dữ liệu
- **Xử lý với tính năng đồng bộ tìm kiếm**:
  ```csharp
  if (new SyncProductSearchEventTrackToggle().Enable(AuthService.Context.RetailerId, AuthService.Context.GroupId))
  {
      // Xử lý với giao dịch cơ sở dữ liệu và đồng bộ sự kiện tìm kiếm
  }
  else
  {
      await Db.BulkInsertAsync(childProducts);
  }
  ```
- Hệ thống kiểm tra xem tính năng "đồng bộ tìm kiếm" có được bật cho cửa hàng này không
- Nếu tính năng này được bật (trường hợp đầu tiên):
  - Hệ thống tạo một "giao dịch an toàn" để lưu dữ liệu - giống như khi ngân hàng đảm bảo tiền được chuyển đúng từ tài khoản này sang tài khoản khác
  - Tất cả sản phẩm con được lưu vào cơ sở dữ liệu cùng một lúc (thay vì từng cái một)
  - Với mỗi sản phẩm con, hệ thống tạo một "thông báo đồng bộ" để cập nhật hệ thống tìm kiếm
  - Nếu có bất kỳ lỗi nào xảy ra trong quá trình này, toàn bộ thao tác sẽ được hoàn tác - không có sản phẩm nào được lưu một nửa
  - Sau khi lưu thành công, hệ thống theo dõi tất cả các thông báo đồng bộ để đảm bảo dữ liệu tìm kiếm được cập nhật
- Nếu tính năng không được bật (trường hợp thứ hai):
  - Hệ thống chỉ đơn giản lưu tất cả sản phẩm con vào cơ sở dữ liệu mà không tạo thông báo đồng bộ
  - Điều này nhanh hơn nhưng có nghĩa là dữ liệu tìm kiếm có thể không được cập nhật ngay lập tức

### 6. Xử lý thông tin dược phẩm cho sản phẩm con
  - Kiểm tra nếu cửa hàng thuốc GPP được kích hoạt (`IsActiveGppDrugStore`)
  - Nếu được kích hoạt, hệ thống sẽ xử lý thông tin dược phẩm cho tất cả sản phẩm con:
    - Lấy danh sách ID của tất cả sản phẩm con đã được tạo
    - Xử lý theo hai trường hợp:
      1. **Trường hợp 1**: Nếu có ID thuốc toàn cầu (`globalMedicineId > 0`) hoặc là thuốc của nhà bán lẻ (`isRetailerMedicine`):
         - Gọi phương thức `BatchAddProductMedicineFromNationalRepoAsync` để thêm thông tin thuốc từ kho dữ liệu quốc gia
         - Truyền vào sản phẩm mẫu, ID thuốc toàn cầu (hoặc 0 nếu là thuốc của nhà bán lẻ), và danh sách ID sản phẩm con
      2. **Trường hợp 2**: Nếu không thuộc trường hợp trên:
         - Tạo danh sách đối tượng `ProductMedicine` cho từng sản phẩm con
         - Mỗi đối tượng được khởi tạo từ sản phẩm cha đầu tiên (`firstProduct`)
         - Cập nhật thông tin về nhà sản xuất, quốc gia sản xuất và đường dùng thuốc
         - Gọi phương thức `BatchAddProductMedicineAsync` để lưu hàng loạt thông tin thuốc

### 7. Xử lý từng sản phẩm con
- **Xử lý chi tiết từng sản phẩm con**:
  ```csharp
  foreach (var childObjReturn in childProducts)
  {
      // Tìm sản phẩm con trong danh sách yêu cầu
      // Tính toán giá vốn cho sản phẩm con
      // Chèn dữ liệu vào các bảng liên quan
      // Xử lý thông tin tồn kho, kiểm kê, bảng giá, thuộc tính, kệ hàng
      // Thêm vào danh sách kết quả trả về
  }
  ```
  - Duyệt qua từng sản phẩm con đã lưu trong danh sách `childProducts`
  - Tìm sản phẩm con tương ứng trong danh sách yêu cầu bằng cách so sánh tên đầy đủ:
    - Sử dụng Regex để loại bỏ khoảng trắng thừa trong tên sản phẩm
    - Kết hợp tên sản phẩm với tên đầy đủ (nếu có)
    - Nếu có thuộc tính sản phẩm, thêm dấu gạch ngang trước tên đầy đủ
    - Thêm đơn vị trong ngoặc đơn (nếu có)
    - So sánh chuỗi kết quả với thuộc tính `FullName` của sản phẩm con
  - Tính toán giá vốn cho sản phẩm con: `reqChildProduct.Cost = reqProduct.Cost * (decimal)reqChildProduct.ConversionValue`
  - Gọi phương thức `InsertRelatedTableOfProduct` để chèn dữ liệu vào các bảng liên quan, trả về tuple chứa nhiều thông tin:
    - Item1: Thông tin chi tiết sản phẩm (productDetailReturn)
    - Item2: Thông tin theo dõi giá vốn (costTracking)
    - Item3: Thông tin kiểm kê kho (productWhStockTake)
    - Item4: Thông tin thuộc tính sản phẩm (productAttributes)
    - Chi tiết về phương thức này có thể tham khảo tại [InsertRelatedTableOfProduct-Business-Logic.md](../InsertRelatedTableOfProduct-Business-Logic.md)
  - Thêm ID sản phẩm con vào danh sách `lsChildProduct` để theo dõi
  - Lấy thông tin chi tiết sản phẩm từ kết quả xử lý (`processResult.Item1`)
  - Cập nhật số lượng tồn kho của sản phẩm con bằng số lượng tồn kho của sản phẩm cha: `productDetailReturn.ProductBranchOnhand = reqProduct.OnHand`
  - Xử lý thông tin theo dõi giá vốn:
    - Nếu `processResult.Item2` không null, thêm vào danh sách `lsCostTracking`
    - Nếu `processResult.Item2` là null, sản phẩm mới (Id = 0), giá vốn = 0, và loại sản phẩm là hàng mua vào hoặc dịch vụ, thêm ID sản phẩm vào danh sách `lsNewProductIdHaveCostEqual0`
  - Xử lý thông tin kiểm kê kho (kiểm tra số lượng hàng tồn):
    - **Trường hợp 1**: Nếu đã có thông tin kiểm kê kho:
      - Lấy thông tin kiểm kê kho từ kết quả xử lý trước đó
      - Nếu cửa hàng có sử dụng kho, sản phẩm không cần theo dõi lô/hạn sử dụng, không cần theo dõi số serial, và có thông tin kiểm kê kho ở các chi nhánh:
        - Hệ thống sẽ lọc ra các chi nhánh khác với chi nhánh hiện tại
        - Kiểm tra xem các kho có đang hoạt động bình thường không bằng cách gọi phương thức `WarehouseService.ValidateStatusOfWarehouse(whId)` (xem chi tiết tại [WarehouseValidation.md](../../Warehouse/WarehouseValidation.md))
      - Thêm vào danh sách cần kiểm kê nếu cửa hàng không sử dụng kho hoặc sản phẩm không có đơn vị tính
    
    - **Trường hợp 2**: Nếu chưa có thông tin kiểm kê kho nhưng cần tạo mới:
      - Điều kiện để tạo mới: cửa hàng có sử dụng kho, sản phẩm không cần theo dõi lô/hạn sử dụng, không cần theo dõi số serial, là hàng mua vào, và có thông tin kiểm kê ở chi nhánh khác
      - Khi đó:
        - Tạo một bản ghi kiểm kê mới với thông tin cơ bản của sản phẩm
        - Ghi nhận số lượng thực tế theo số lượng tồn kho hiện tại
        - Đánh dấu chỉ kiểm tra kho (không điều chỉnh số lượng)
        - Lọc ra các chi nhánh khác với chi nhánh hiện tại
        - Kiểm tra trạng thái hoạt động của các kho bằng cách gọi phương thức `WarehouseService.ValidateStatusOfWarehouse(whId)` (xem chi tiết tại [WarehouseValidation.md](../../Warehouse/WarehouseValidation.md))
        - Thêm vào danh sách cần kiểm kê nếu sản phẩm không có đơn vị tính
  - Xử lý thông tin bảng giá: nếu có chi tiết bảng giá (`productDetailReturn.ListPriceBookDetail`), thêm vào danh sách `lsPriceBookDetail`
  - Xử lý thuộc tính sản phẩm (`processResult.Item4`): cập nhật từ điển `lsProductAttributes` bằng cách kết hợp với dữ liệu mới
  - Thêm thông tin kệ hàng cho sản phẩm con thông qua phương thức `GetListProductShelves`
  - Cuối cùng, thêm chi tiết sản phẩm con vào danh sách kết quả trả về `listObjReturn`

### 8. Cập nhật thông tin đơn vị sản phẩm
- **Cập nhật đơn vị sản phẩm nếu là hàng hóa mua vào**:
  ```csharp
  if (objReturn.ProductType == (int)ProductType.Purchased)
  {
      lsChangeProductBranchUnit.Add(new ChangeProductBranchUnit
      {
          MasterProductId = objReturn.Id,
          UpdatedUnits = childProducts,
          MinQuantity = reqProduct.MinQuantity,
          MaxQuantity = reqProduct.MaxQuantity
      });
  }
  ```
  - Kiểm tra nếu sản phẩm cha có loại là hàng hóa mua vào
  - Tạo đối tượng `ChangeProductBranchUnit` với thông tin cập nhật đơn vị
  - Thêm vào danh sách thay đổi đơn vị sản phẩm chi nhánh

## Ý nghĩa nghiệp vụ
- Hệ thống cho phép quản lý sản phẩm theo cấu trúc cha-con
- Sản phẩm con kế thừa nhiều thuộc tính từ sản phẩm cha nhưng vẫn có thông tin riêng biệt
- Hỗ trợ quản lý các đơn vị đo lường khác nhau cho cùng một sản phẩm
- Tự động tính toán giá vốn cho sản phẩm con dựa trên tỷ lệ chuyển đổi

## Liên hệ với các quy trình khác
- Cấu trúc sản phẩm cha-con ảnh hưởng đến quá trình bán hàng, quản lý tồn kho
- Thông tin đơn vị đo lường được sử dụng trong quá trình nhập xuất kho và bán hàng
- Đồng bộ thông tin dược phẩm giữa sản phẩm cha và con đảm bảo tính nhất quán trong quản lý thuốc

**Điều hướng**
- Trước đó: [3-3-Xu-ly-du-lieu-bang-lien-quan.md](./3-3-Xu-ly-du-lieu-bang-lien-quan.md)
- Tổng quan: [0-Tong-quan-Product-AddMany.md](./0-Tong-quan-Product-AddMany.md)