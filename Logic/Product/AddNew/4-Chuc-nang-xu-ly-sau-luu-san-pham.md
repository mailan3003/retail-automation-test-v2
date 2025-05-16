# Chức năng xử lý sau lưu sản phẩm

## Giới thiệu
Sau khi hoàn tất vòng lặp xử lý cha-con cho các sản phẩm, hệ thống cần thực hiện các bước xử lý bổ sung để đảm bảo dữ liệu sản phẩm được đồng bộ, tích hợp và cập nhật đúng cách trong toàn bộ hệ thống. Các chức năng này bao gồm đồng bộ thông tin thuốc, quản lý bảng giá, xử lý tồn kho và giá vốn tại các chi nhánh.

## Các chức năng xử lý sau lưu sản phẩm

### 1. Đồng bộ thông tin thuốc lên Dược Quốc Gia (DQG)
- Điều kiện: Hệ thống kiểm tra hai điều kiện `AuthService.Context.IsActiveGppDrugStore` (cửa hàng có kích hoạt tính năng GPP) và `req.IsSyncNationalPharmacy` (yêu cầu đồng bộ lên hệ thống Quốc gia)
- Thực hiện đồng bộ thông tin thuốc của sản phẩm cha đầu tiên (`firstParent`) lên hệ thống DQG thông qua phương thức `ProductService.SyncProductMedicineNational`
- Mục đích: Tuân thủ quy định ngành dược, đảm bảo dữ liệu thuốc được quản lý tập trung theo quy định của Bộ Y tế

### 2. Xử lý chi tiết bảng giá (PriceBook Detail)
- Hệ thống kiểm tra nếu danh sách `lsPriceBookDetail` có dữ liệu (sử dụng `lsPriceBookDetail.Any()`)
- Cập nhật ID nhà bán lẻ (`RetailerId`) cho mỗi mục trong danh sách bảng giá bằng giá trị `CurrentRetailerId`
- Sử dụng `Db.BulkMergeAsync` để cập nhật hàng loạt dữ liệu bảng giá, tối ưu hiệu suất khi xử lý nhiều bản ghi
- Khóa chính được xác định bởi biểu thức `pd => new { pd.Id, pd.PriceBookId, pd.ProductId, pd.RetailerId }` để đảm bảo tính duy nhất của mỗi bản ghi

### 3. Xử lý chi nhánh và giá vốn (khi sử dụng tính năng chọn chi nhánh)
Khi biến `isUsingProductBranchSelect` là true, hệ thống thực hiện:

- **Thay đổi giá vốn**: 
  - Kiểm tra nếu `lsCostTracking` có dữ liệu
  - Gọi phương thức `BatchChangeCostAsync` với các tham số `lsCostTracking`, `branchId`, `branchIdForProductCosts`, `branchIdForProduct` để cập nhật giá vốn theo từng chi nhánh cụ thể

- **Xử lý sản phẩm không có giá vốn (0 đồng)**:
  - Kiểm tra nếu `lsNewProductIdHaveCostEqual0` có dữ liệu
  - Gọi `ProductBranchService.GetOrCreateListAsync` để tạo bản ghi ProductBranch cho các sản phẩm mới có giá vốn bằng 0
  - Giải quyết vấn đề #12715: Đảm bảo tính năng chuyển hàng, bán hàng hoạt động đúng khi hết tồn kho bằng cách tạo các bản ghi cần thiết trong bảng ProductBranch

- **Kiểm soát trạng thái sản phẩm tại chi nhánh hiện tại**:
  - Kiểm tra điều kiện `isNotUpdateAllBranchForProduct && !branchIdForProduct.Contains(currentBranch.Id)`
  - Nếu chi nhánh hiện tại không nằm trong danh sách chi nhánh được chọn, tạo danh sách ID sản phẩm từ `lsParentProduct` và `lsChildProduct` (nếu có)
  - Gọi `ProductService.ActiveProductListAsync` với tham số `false` để vô hiệu hóa sản phẩm tại chi nhánh hiện tại

### 4. Xử lý sản phẩm có công thức sản xuất
Khi sản phẩm có công thức sản xuất (`reqProduct.ProductFormulas != null && reqProduct.ProductFormulas.Any()`):

- Lấy danh sách ID nguyên liệu từ công thức sản xuất (`formulaIds`)
- Tính toán giá vốn dựa trên công thức sản xuất cho từng chi nhánh được chọn thông qua `ProductFormulaService.CalculateProductFormulaCost`
- Xử lý theo ba trường hợp riêng biệt:
  - **Sản phẩm sản xuất thông thường**: Nếu `lsProductManufacture` có dữ liệu, gọi `ProductBranchService.GetOrCreateListProductManufactureAsync` để tạo/cập nhật thông tin
  - **Sản phẩm con của sản phẩm sản xuất**: Nếu `lsChildProduct` có dữ liệu, thực hiện tương tự cho các sản phẩm con
  - **Sản phẩm combo có công thức sản xuất**: Nếu `lsProductManufactureCombo` có dữ liệu, xử lý riêng cho loại sản phẩm này

### 5. Xử lý khi không sử dụng tính năng chọn chi nhánh
Khi biến `isUsingProductBranchSelect` là false, hệ thống thực hiện:

- **Thay đổi giá vốn**: 
  - Kiểm tra nếu `lsCostTracking` có dữ liệu
  - Gọi phương thức `BatchChangeCostAsync` chỉ với các tham số `lsCostTracking` và `branchId`, áp dụng cho tất cả chi nhánh mặc định
  - Không truyền tham số `branchIdForProductCosts` và `branchIdForProduct` như trường hợp có chọn chi nhánh

- **Xử lý sản phẩm không có giá vốn (0 đồng)**:
  - Kiểm tra nếu `lsNewProductIdHaveCostEqual0` có dữ liệu
  - Gọi `ProductBranchService.GetOrCreateListAsync` với ít tham số hơn, chỉ truyền `lsNewProductIdHaveCostEqual0`, `branchId`, và `CurrentRetailerId`
  - Tạo bản ghi ProductBranch cho tất cả chi nhánh mặc định

## Điều hướng tài liệu
- Trước đó: [3-Tong-quan-xu-ly-vong-lap-cha-con.md](./3-Tong-quan-xu-ly-vong-lap-cha-con.md)
- Tiếp theo: [5-Chuc-nang-xu-ly-ton-kho-ban-dau.md](./5-Chuc-nang-xu-ly-ton-kho-ban-dau.md)
- Tổng quan: [Tong-quan-Product-AddMany.md](./Tong-quan-Product-AddMany.md) 