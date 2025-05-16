# Chức năng xử lý tồn kho ban đầu và thuộc tính sản phẩm

## Giới thiệu
Sau khi hoàn tất việc xử lý chi nhánh và giá vốn, hệ thống tiếp tục với các chức năng quản lý tồn kho ban đầu, cập nhật thuộc tính sản phẩm, vị trí kệ hàng và xử lý hình ảnh sản phẩm. Các chức năng này đảm bảo sản phẩm mới được tích hợp đầy đủ vào hệ thống quản lý kho và dữ liệu liên quan.

## Các chức năng xử lý tồn kho và thuộc tính

### 1. Quản lý tồn kho ban đầu (Product Stock Take)
- **Xử lý kiểm kê kho mặc định**:
  - Tạo phiếu kiểm kê tồn kho ban đầu cho các sản phẩm mới thông qua `CreateStockTakeForUpdateMultiProductAsync`
  - Cập nhật số lượng tồn kho ban đầu dựa trên danh sách `lsProductAddStockTake`

- **Xử lý đặc biệt khi sử dụng nhiều kho (isUsingWarehouse)**:
  - **Kho chính (Master Stock)**:
    - Xác định sản phẩm không chỉ kiểm tra kho: `Where(e => !e.IsOnlyCheckWarehouse)`
    - Tạo phiếu kiểm kê riêng cho kho chính
  
  - **Kho phụ (Warehouse)**:
    - Tạo các nhóm kiểm kê theo từng kho (`GroupOfProductWarehouseStockTake`)
    - Xây dựng cấu trúc dữ liệu phân cấp cho từng kho và sản phẩm tương ứng
    - Tạo phiếu kiểm kê riêng cho từng kho phụ
    - Ghi nhật ký kiểm kê kho thông qua `LogWarehouseStockTake`

### 2. Cập nhật đơn vị tính cho sản phẩm theo chi nhánh
- Thực hiện cập nhật hàng loạt đơn vị tính cho sản phẩm theo chi nhánh thông qua `BatchUpdateProductBranchUnit`
- Sử dụng danh sách `lsChangeProductBranchUnit` chứa thông tin thay đổi
- Áp dụng cho nhà bán lẻ hiện tại (`AuthService.Context.RetailerId`) và chi nhánh hiện tại (`AuthService.Context.BranchId`)

### 3. Cập nhật thuộc tính sản phẩm
- Thực hiện thêm hàng loạt thuộc tính cho nhiều sản phẩm qua `BatchAddMultiProductAsync`
- Sử dụng danh sách `lsProductAttributes` chứa các thuộc tính cần thêm

### 4. Quản lý vị trí kệ hàng cho sản phẩm
- **Xóa thông tin kệ hàng cũ**:
  - Lấy danh sách ID sản phẩm từ `lsProductShelves`
  - Xóa tất cả dữ liệu kệ hàng hiện có của các sản phẩm này
  
- **Thêm thông tin kệ hàng mới**:
  - Cập nhật ID nhà bán lẻ cho từng mục
  - Sử dụng `BulkMergeAsync` để thêm hàng loạt dữ liệu
  - Xác định khóa chính bằng tổ hợp ShelvesId, ProductId và RetailerId

### 5. Xử lý hình ảnh sản phẩm
- **Xác định phạm vi lưu hình ảnh**:
  - Kiểm tra cờ `SaveImagesForAllProducts` từ dữ liệu form
  - Nếu bật: áp dụng hình ảnh cho tất cả sản phẩm trong nhóm (`listObjReturn`)
  - Nếu tắt: chỉ áp dụng cho sản phẩm đầu tiên trong danh sách

- **Xử lý sao chép hình ảnh**:
  - Gọi `ProcessCloneProduct` để xử lý sao chép hình ảnh cho sản phẩm
  - Sử dụng danh sách `globalProductsImages` chứa thông tin hình ảnh toàn cục

## Luồng xử lý chức năng

1. **Xử lý tồn kho ban đầu**
   - Kiểm tra điều kiện sử dụng nhiều kho
   - Nếu sử dụng nhiều kho:
     - Tạo phiếu kiểm kê cho kho chính
     - Tạo và nhóm dữ liệu cho các kho phụ
     - Tạo phiếu kiểm kê cho từng kho phụ
   - Nếu không sử dụng nhiều kho:
     - Tạo phiếu kiểm kê duy nhất cho tất cả sản phẩm

2. **Cập nhật đơn vị tính theo chi nhánh**
   - Thực hiện cập nhật hàng loạt nếu có thay đổi

3. **Cập nhật thuộc tính sản phẩm**
   - Thêm thuộc tính cho nhiều sản phẩm nếu có

4. **Quản lý kệ hàng**
   - Xóa dữ liệu kệ hàng cũ
   - Thêm dữ liệu kệ hàng mới

5. **Xử lý hình ảnh**
   - Xác định phạm vi áp dụng hình ảnh
   - Thực hiện sao chép hình ảnh cho sản phẩm

## Điều hướng tài liệu
- Trước đó: [4-Chuc-nang-xu-ly-sau-luu-san-pham.md](./4-Chuc-nang-xu-ly-sau-luu-san-pham.md)
- Tiếp theo: [6-Chuc-nang-xu-ly-tim-kiem-va-hoan-tat.md](./6-Chuc-nang-xu-ly-tim-kiem-va-hoan-tat.md)
- Tổng quan: [Tong-quan-Product-AddMany.md](./Tong-quan-Product-AddMany.md) 