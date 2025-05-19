# Phân tích Business Logic của chức năng ánh xạ mã sản phẩm

## Tổng quan
Trong quá trình xử lý sản phẩm cha, hệ thống cần thực hiện việc ánh xạ giữa mã sản phẩm tùy chỉnh (custom master code) và mã sản phẩm thực tế. Quá trình này giúp liên kết sản phẩm với dữ liệu đầu vào từ người dùng và xác định chi nhánh xử lý.

## Các bước xử lý chính

### 1. Lấy thông tin ánh xạ mã sản phẩm
- **Trích xuất mã sản phẩm tùy chỉnh**:
  ```csharp
  var customMasterCode = dicMapperProductAndCustomMasterCode.FirstOrDefault(k => k.Key == objReturn.Code);
  ```
  - Hệ thống tìm kiếm trong từ điển ánh xạ `dicMapperProductAndCustomMasterCode` dựa trên mã sản phẩm hiện tại
  - Sử dụng `FirstOrDefault` để lấy cặp khóa-giá trị đầu tiên khớp với điều kiện, hoặc giá trị mặc định nếu không tìm thấy

### 2. Xác định sản phẩm yêu cầu
- **Tìm sản phẩm trong danh sách yêu cầu**:
  ```csharp
  var reqProduct = req.ListProducts.FirstOrDefault(x => x.MasterCode == customMasterCode.Value);
  ```
  - Tìm kiếm sản phẩm trong danh sách yêu cầu (`req.ListProducts`) dựa trên mã chính tùy chỉnh
  - Cho phép liên kết dữ liệu sản phẩm từ người dùng với sản phẩm đang được xử lý

### 3. Xác định chi nhánh xử lý
- **Thiết lập chi nhánh hiện tại**:
  ```csharp
  var currentBranchId = CurrentBranchId == 0 ? reqProduct.BranchId : CurrentBranchId;
  ```
  - Kiểm tra nếu chi nhánh hiện tại chưa được thiết lập (`CurrentBranchId == 0`)
  - Nếu chưa thiết lập, sử dụng chi nhánh từ sản phẩm yêu cầu (`reqProduct.BranchId`)
  - Nếu đã thiết lập, giữ nguyên giá trị hiện tại

## Ý nghĩa nghiệp vụ
- Hệ thống cho phép lưu trữ và sử dụng mã sản phẩm tùy chỉnh khác với mã thực tế trong hệ thống
- Việc ánh xạ giúp duy trì tính nhất quán giữa dữ liệu đầu vào và dữ liệu lưu trữ
- Hỗ trợ mô hình đa chi nhánh, cho phép sản phẩm được liên kết với chi nhánh cụ thể

## Liên hệ với các quy trình khác
- Thông tin ánh xạ mã sản phẩm được sử dụng trong quá trình xử lý các bảng liên quan
- Chi nhánh xác định được sử dụng cho các thao tác quản lý tồn kho, giá cả theo chi nhánh

**Điều hướng**
- Trước đó: [3-1-Xu-ly-thong-tin-thue-san-pham.md](./3-1-Xu-ly-thong-tin-thue-san-pham.md)
- Tiếp theo: [3-3-Xu-ly-du-lieu-bang-lien-quan.md](./3-3-Xu-ly-du-lieu-bang-lien-quan.md) 
- Tổng quan: [0-Tong-quan-Product-AddMany.md](./0-Tong-quan-Product-AddMany.md) 