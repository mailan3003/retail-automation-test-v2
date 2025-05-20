# Chức năng xử lý tồn kho ban đầu và thuộc tính sản phẩm

## Giới thiệu
Sau khi hoàn tất việc xử lý chi nhánh và giá vốn, hệ thống tiếp tục với các chức năng quản lý tồn kho ban đầu, cập nhật thuộc tính sản phẩm, vị trí kệ hàng và xử lý hình ảnh sản phẩm. Các chức năng này đảm bảo sản phẩm mới được tích hợp đầy đủ vào hệ thống quản lý kho và dữ liệu liên quan.

## Các chức năng xử lý tồn kho và thuộc tính

### 1. Quản lý tồn kho ban đầu (Product Stock Take)
- **Xử lý kiểm kê kho mặc định**:
  - Hệ thống kiểm tra nếu danh sách `lsProductAddStockTake` có dữ liệu thông qua `lsProductAddStockTake.Any()`
  - Tạo phiếu kiểm kê tồn kho ban đầu cho các sản phẩm mới thông qua `StockTakeService.CreateStockTakeForUpdateMultiProductAsync`
  - Truyền các tham số: ID nhà bán lẻ hiện tại (`CurrentRetailerId`), ID chi nhánh (`branchId`), danh sách sản phẩm cần kiểm kê, và cờ `true` để xác nhận đây là kiểm kê ban đầu

- **Xử lý đặc biệt khi sử dụng nhiều kho (isUsingWarehouse = true)**:
  - **Kho chính (Master Stock)**:
    - Lọc ra các sản phẩm không chỉ kiểm tra kho: `masterStock = lsProductAddStockTake.Where(e => !e.IsOnlyCheckWarehouse).ToList()`
    - Kiểm tra nếu danh sách này có dữ liệu: `masterStock != null && masterStock.Any()`
    - Tạo phiếu kiểm kê riêng cho kho chính với tham số `true` để xác nhận đây là kiểm kê ban đầu
  
  - **Kho phụ (Warehouse)**:
    - Lọc ra các sản phẩm có dữ liệu kiểm kê kho phụ: `lsStockTakeForWarehouses = lsProductAddStockTake.Where(e => e.ProductWithWarehouseStockTakes != null && e.ProductWithWarehouseStockTakes.Any()).ToList()`
    - Tạo cấu trúc dữ liệu `GroupOfProductWarehouseStockTake` để nhóm các sản phẩm theo từng kho
    - Với mỗi sản phẩm trong `lsStockTakeForWarehouses`, duyệt qua từng bản ghi kiểm kê kho phụ (`ProductWithWarehouseStockTakes`)
    - Tạo đối tượng `ProductAddStockTake` mới với thông tin sản phẩm và số lượng tồn kho thực tế (`ActualCount = stk.OnHand ?? 0`)
    - Nhóm các bản ghi theo ID chi nhánh (kho) và thêm vào danh sách `lsGroupWarehouseStockTake`
    - Với mỗi nhóm kho phụ khác với chi nhánh hiện tại, tạo phiếu kiểm kê riêng
    - Ghi nhật ký kiểm kê kho thông qua `LogWarehouseStockTake` với thông tin kho và kho mặc định

- **Xử lý khi không sử dụng nhiều kho (isUsingWarehouse = false)**:
  - Tạo một phiếu kiểm kê duy nhất cho tất cả sản phẩm trong `lsProductAddStockTake`
  - Sử dụng `StockTakeService.CreateStockTakeForUpdateMultiProductAsync` với tham số tương tự như trên

### 2. Cập nhật đơn vị tính cho sản phẩm theo chi nhánh
- Kiểm tra nếu danh sách `lsChangeProductBranchUnit` có dữ liệu thông qua `lsChangeProductBranchUnit.Any()`
- Thực hiện cập nhật hàng loạt đơn vị tính cho sản phẩm theo chi nhánh thông qua `ProductBranchService.BatchUpdateProductBranchUnit`
- Truyền các tham số: danh sách thay đổi (`lsChangeProductBranchUnit`), ID nhà bán lẻ (`AuthService.Context.RetailerId`), và ID chi nhánh hiện tại (`AuthService.Context.BranchId`)

### 3. Cập nhật thuộc tính sản phẩm
- Kiểm tra nếu danh sách `lsProductAttributes` có dữ liệu thông qua `lsProductAttributes.Any()`
- Thực hiện thêm hàng loạt thuộc tính cho nhiều sản phẩm qua `ProductAttributeService.BatchAddMultiProductAsync`
- Truyền danh sách thuộc tính sản phẩm (`lsProductAttributes`) làm tham số

### 4. Quản lý vị trí kệ hàng cho sản phẩm
- Kiểm tra nếu danh sách `lsProductShelves` có dữ liệu thông qua `lsProductShelves.Any()`
- **Xóa thông tin kệ hàng cũ**:
  - Lấy danh sách ID sản phẩm từ `lsProductShelves`: `delShelvesProductIds = lsProductShelves.Select(ps => ps.ProductId).ToArray()`
  - Xóa tất cả dữ liệu kệ hàng hiện có của các sản phẩm này: `Db.ProductShelves.WhereIn(delShelvesProductIds, ps => ps.ProductId).DeleteFromQueryAsync()`
  
- **Thêm thông tin kệ hàng mới**:
  - Cập nhật ID nhà bán lẻ cho từng mục: `lsProductShelves.ForEach(s => s.RetailerId = CurrentRetailerId)`
  - Sử dụng `Db.BulkMergeAsync` để thêm hàng loạt dữ liệu kệ hàng mới
  - Xác định khóa chính bằng biểu thức: `ps => new { ps.ShelvesId, ps.ProductId, ps.RetailerId }`

### 5. Xử lý hình ảnh sản phẩm
- **Xác định phạm vi lưu hình ảnh**:
  - Kiểm tra cờ `SaveImagesForAllProducts` từ dữ liệu form: `formData != null && ConvertHelper.ToBoolean(formData.Get("SaveImagesForAllProducts"))`
  - Khởi tạo danh sách sản phẩm cần sao chép hình ảnh: `productsListToCloneImages = new List<Product>()`
  - Nếu `saveForAllProductsInGroup = true`: thêm tất cả sản phẩm từ `listObjReturn` vào danh sách
  - Nếu `saveForAllProductsInGroup = false`: chỉ thêm sản phẩm đầu tiên từ `listObjReturn` vào danh sách

- **Xử lý sao chép hình ảnh**:
  - Gọi `ProcessCloneProduct` để xử lý sao chép hình ảnh cho sản phẩm
  - Truyền các tham số: yêu cầu (`req`), danh sách sản phẩm cần sao chép (`productsListToCloneImages`), và danh sách hình ảnh sản phẩm toàn cục (`globalProductsImages`)
  
## Điều hướng tài liệu
- Trước đó: [4-Chuc-nang-xu-ly-sau-luu-san-pham.md](./4-Chuc-nang-xu-ly-sau-luu-san-pham.md)
- Tiếp theo: [6-Chuc-nang-xu-ly-tim-kiem-va-hoan-tat.md](./6-Chuc-nang-xu-ly-tim-kiem-va-hoan-tat.md)
- Tổng quan: [0-Tong-quan-Product-AddMany.md](./0-Tong-quan-Product-AddMany.md) 