# Phân tích Business Logic của chức năng Xử Lý Dữ Liệu Đầu Vào

## Các bước xử lý chính

### 1. Trích xuất dữ liệu từ nhiều nguồn
- **Xử lý các nguồn dữ liệu khác nhau**:
  - Kiểm tra và xử lý dữ liệu từ `formData["ListProducts"]` nếu có
  - Nếu không có, kiểm tra trong `formData["ListProductsString"]`
  - Cuối cùng, fallback về `req.ListProductsString` nếu các nguồn trước không có
  - Sử dụng `JsonConvert.DeserializeObject` để chuyển đổi JSON thành đối tượng `List<ProductByBranchWithWarranty>`

- **Xử lý lỗi định dạng JSON**:
  - Bao bọc quá trình chuyển đổi trong khối try-catch
  - Bắt lỗi và ném ngoại lệ `KvValidateProductException` với thông báo rõ ràng (`KVMessage.invalidRequestParams`)
  - Đảm bảo xử lý lỗi từ sớm để không tiếp tục xử lý dữ liệu không hợp lệ

- **Khởi tạo các biến và cấu trúc dữ liệu phục vụ xử lý**:
  - Sử dụng `UsingProductBranchSelectToggle().Enable(AuthService.Context.RetailerId, AuthService.Context.GroupId)` để xác định có bật tính năng chọn chi nhánh cho sản phẩm hay không (`isUsingProductBranchSelect`)
  - Khởi tạo các danh sách và từ điển để lưu trữ dữ liệu sản phẩm, bảng giá, thuộc tính sản phẩm:
    - `listObjReturn`: danh sách các sản phẩm sẽ trả về sau khi xử lý
    - `lsPriceBook`: danh sách các bảng giá liên quan đến sản phẩm
    - `lsProductAttributes`: từ điển ánh xạ giữa sản phẩm và danh sách thuộc tính của sản phẩm
  - Khởi tạo các biến phục vụ xử lý đặc thù ngành dược:
    - `firstProduct`: lưu sản phẩm đầu tiên để sử dụng cho các logic đặc biệt
    - `globalMedicineId`, `globalMedicine`, `globalManufacturerCountry`, `globalManufacturer`, `medicineManufacturer`: các biến lưu thông tin liên quan đến dược phẩm, nhà sản xuất, quốc gia sản xuất, phục vụ cho các nghiệp vụ kiểm tra và đồng bộ với hệ thống Dược phẩm Quốc gia

- **Chuẩn hóa tên sản phẩm**:
  - Gọi hàm `NormalizeName(req)` để chuẩn hóa tên của tất cả sản phẩm
  - Loại bỏ khoảng trắng thừa, ký tự đặc biệt không hợp lệ
  - Đảm bảo định dạng nhất quán cho tên sản phẩm
  - Chi tiết logic triển khai: [Xem tại đây](../NormalizeName-Business-Logic.md)

- **Kiểm tra bảng hoa hồng đang ngừng áp dụng**:
  - Nếu cấu hình `Settings.TimeSheet` được bật và trường `CommissionIds` trong `formData` không rỗng:
    - Gọi hàm `ValidateCommissionInActive(formData["CommissionIds"])` để kiểm tra các bảng hoa hồng có đang ở trạng thái ngừng áp dụng hay không
    - Nếu phát hiện có bảng hoa hồng ngừng áp dụng, ném ngoại lệ và dừng quá trình lưu sản phẩm vào database

- **Xác định chi nhánh áp dụng giá vốn cho sản phẩm**:
  - Nếu `formData["BranchForProductCostss"]` có dữ liệu:
    - Thử parse JSON thành danh sách `SelectedActiveBranches`
    - Nếu parse thành công và danh sách không rỗng:
      - Lấy danh sách ID và tên chi nhánh từ kết quả parse, lưu vào `branchIdForProductCosts` và `branchNameForProductCosts`
    - Nếu danh sách rỗng nhưng `req.IsUpdateAllSystem` là true:
      - Lấy tất cả chi nhánh đang hoạt động của retailer hiện tại, lưu ID và tên vào các biến trên
    - Nếu không thỏa các điều kiện trên:
      - Mặc định chỉ lấy chi nhánh hiện tại (ID và tên)
  - Nếu không có `formData["BranchForProductCostss"]`:
    - Lấy danh sách chi nhánh theo quyền tạo sản phẩm (`Product._Create`)
    - Nếu hệ thống đang sử dụng kho (`isUsingWarehouse`):
      - Loại bỏ các chi nhánh đã lưu trữ kho khỏi danh sách
    - Lưu toàn bộ ID và tên chi nhánh còn lại vào `branchIdForProductCosts` và `branchNameForProductCosts`

- **Xác thực số lượng sản phẩm**:
  - Kiểm tra giới hạn sản phẩm combo (`ProductType.Manufactured`) không vượt quá 50
  - Đảm bảo tổng số sản phẩm không vượt quá 200
  - Ném ngoại lệ nếu vượt quá giới hạn để bảo vệ hiệu suất hệ thống: `KVMessage._product_ExceedingTheLimitComboProduct`, `KVMessage._product_ExceedingTheLimit`

- **Xác thực quyền hạn**:
  - Kiểm tra quyền truy cập giá vốn của người dùng với `AuthService.CheckPermission(Product.Cost, branchId)`
  - Nếu không có quyền, mặc định đặt giá vốn về 0 cho tất cả sản phẩm
  - Đảm bảo người dùng chỉ thấy/sửa thông tin mà họ có quyền

- **Kiểm tra tính nhất quán của đơn vị**:
  - Kiểm tra đơn vị trùng lặp trong cùng sản phẩm (phân biệt hoa/thường): 
    ```csharp
    var temp1 = listProducts.Select(x => new { unit = x.Unit.ToLower(), attribute = x.AttributedName });
    var temp2 = temp1.Where(x => x.attribute == temp1.FirstOrDefault().attribute);
    if (temp2.Select(x => x.unit.ToLower()).Distinct().Count() != temp2.Select(x => x.unit).Count()) {
        throw new KvValidateProductException(KVMessage.duplicateUnitName); // "Tên đơn vị tính không được phép trùng nhau"
    }
    ```
  - Đảm bảo tính duy nhất của đơn vị trong cùng một nhóm sản phẩm
  
- **Chuyển đổi sang cấu trúc dữ liệu chuẩn**:
  - Gọi `ProductService.GetProductFromProductByBranch(listProducts)` để chuyển đổi từ `ProductByBranch` sang `Product`
  - Áp dụng các ràng buộc nghiệp vụ trong quá trình chuyển đổi
  - Kiểm tra và xử lý thuộc tính đặc biệt như thuộc tính dược phẩm
  - Chi tiết logic triển khai: [Xem tại đây](../GetProductFromProductByBranch-Business-Logic.md)

---
**Điều hướng**
- Trang tổng quan: [Tổng quan quy trình thêm sản phẩm](./0-Tong-quan-Product-AddMany.md)
- Tiếp theo: [Chức năng xác thực sản phẩm](./2-Chuc-nang-xac-thuc-san-pham.md) 