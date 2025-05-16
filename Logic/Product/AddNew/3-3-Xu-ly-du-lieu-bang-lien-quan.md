# Phân tích Business Logic của chức năng xử lý dữ liệu bảng liên quan

## Tổng quan
Sau khi đã xác định sản phẩm và chi nhánh, hệ thống tiến hành xử lý dữ liệu từ các bảng liên quan đến sản phẩm. Quá trình này bao gồm việc chèn dữ liệu vào các bảng liên quan, xử lý thông tin tồn kho, và theo dõi thay đổi giá vốn.

## Các bước xử lý chính

### 1. Chèn dữ liệu vào các bảng liên quan
- **Gọi hàm xử lý**:
  ```csharp
  var processResult = await InsertRelatedTableOfProduct(reqProduct, objReturn, true);
  ```
  - Sử dụng phương thức `InsertRelatedTableOfProduct` để chèn dữ liệu vào các bảng liên quan
  - Phương thức này nhận ba tham số:
    - `reqProduct`: Sản phẩm yêu cầu từ người dùng
    - `objReturn`: Đối tượng sản phẩm đã được lưu
    - `true`: Cờ đánh dấu là sản phẩm cha (parent product)
  - Kết quả trả về là một tuple với nhiều thành phần dữ liệu khác nhau
  - Chi tiết về phương thức này có thể tìm thấy tại [InsertRelatedTableOfProduct-Business-Logic.md](../InsertRelatedTableOfProduct-Business-Logic.md)
### 2. Lấy thông tin chi tiết sản phẩm
- **Xử lý kết quả**:
  ```csharp
  var productDetailReturn = processResult.Item1;
  productDetailReturn.ProductBranchOnhand = reqProduct.OnHand;
  ```
  - Lấy thông tin chi tiết sản phẩm từ phần tử đầu tiên của tuple kết quả
  - Cập nhật thông tin tồn kho hiện tại (`ProductBranchOnhand`) từ dữ liệu yêu cầu

### 3. Xử lý theo dõi giá vốn
- **Kiểm tra và thêm vào danh sách theo dõi**:
  ```csharp
  if (processResult.Item2 != null)
  {
      lsCostTracking.Add(processResult.Item2);
  }
  ```
  - Kiểm tra nếu phần tử thứ hai của tuple kết quả không null
  - Nếu có dữ liệu, thêm vào danh sách theo dõi giá vốn (`lsCostTracking`)

### 4. Xử lý sản phẩm có giá vốn bằng 0
- **Xử lý trường hợp đặc biệt**:
  ```csharp
  else if (processResult.Item2 == null && reqProduct.Id == 0 && reqProduct.Cost == 0 &&
          (reqProduct.ProductType == (int)ProductType.Purchased ||
           reqProduct.ProductType == (int)ProductType.Service))
      lsNewProductIdHaveCostEqual0.Add(productDetailReturn.Id);
  ```
  - Kiểm tra điều kiện:
    - Không có dữ liệu theo dõi giá vốn (`processResult.Item2 == null`)
    - Sản phẩm mới (`reqProduct.Id == 0`)
    - Giá vốn bằng 0 (`reqProduct.Cost == 0`)
    - Loại sản phẩm là hàng hóa mua vào hoặc dịch vụ
  - Nếu thỏa mãn điều kiện, thêm ID sản phẩm vào danh sách sản phẩm có giá vốn bằng 0

### 5. Xử lý thông tin kiểm kê
- **Thêm thông tin kiểm kê kho**:
  - Kiểm tra nếu phần tử thứ ba của tuple kết quả không null (chứa thông tin kiểm kê)
  - Nếu hệ thống đang sử dụng tính năng quản lý kho (`isUsingWarehouse`) và sản phẩm:
    - Không được kiểm soát theo lô hạn sử dụng (`IsBatchExpireControl != true`)
    - Không được kiểm soát theo số serial/lô (`IsLotSerialControl != true`)
    - Có dữ liệu kiểm kê kho (`ProductWithWarehouseStockTakes != null && Any()`)
  - Thì hệ thống sẽ:
    - Lọc danh sách kiểm kê kho, chỉ giữ lại các bản ghi thuộc chi nhánh khác với chi nhánh hiện tại
    - Xác thực trạng thái hoạt động của từng kho hàng thông qua `WarehouseService.ValidateStatusOfWarehouse` (xem chi tiết tại [WarehouseValidation.md](../../Warehouse/WarehouseValidation.md))
    - Đảm bảo chỉ thêm kiểm kê cho các kho hợp lệ (tồn tại, đang hoạt động, không bị hạn chế truy cập) để đảm bảo tính chính xác của dữ liệu tồn kho
  - Cuối cùng, thêm đối tượng kiểm kê vào danh sách tổng hợp (`lsProductAddStockTake`) để xử lý hàng loạt sau đó

### 6. Xử lý thông tin kiểm kê kho cho sản phẩm đặc biệt
- **Xử lý theo điều kiện kho**:
  ```csharp
  else if (isUsingWarehouse && reqProduct.IsBatchExpireControl != true && reqProduct.IsLotSerialControl != true && reqProduct.ProductType == (int)ProductType.Purchased && reqProduct.ProductWithWarehouseStockTakes != null && reqProduct.ProductWithWarehouseStockTakes.Any(e => e.BranchId != currentBranchId))
  {
    
  }
  ```
  - **Điều kiện xử lý chi tiết**:
    - `isUsingWarehouse`: Hệ thống đang sử dụng tính năng quản lý kho hàng
    - `reqProduct.IsBatchExpireControl != true`: Sản phẩm không được kiểm soát theo lô hạn sử dụng
    - `reqProduct.IsLotSerialControl != true`: Sản phẩm không được kiểm soát theo số serial/lô
    - `reqProduct.ProductType == (int)ProductType.Purchased`: Sản phẩm thuộc loại hàng hóa mua vào
    - `reqProduct.ProductWithWarehouseStockTakes != null`: Sản phẩm có dữ liệu kiểm kê kho
    - `reqProduct.ProductWithWarehouseStockTakes.Any(e => e.BranchId != currentBranchId)`: Có ít nhất một bản ghi kiểm kê thuộc chi nhánh khác với chi nhánh hiện tại
  
  - **Quy trình xử lý**:
    - Tạo đối tượng kiểm kê kho mới (`ProductAddStockTake`) với các thông tin:
      - ID và mã sản phẩm từ đối tượng trả về
      - Số lượng thực tế được làm tròn theo cấu hình số thập phân của đơn vị tiền tệ hiện tại
      - Đánh dấu chỉ kiểm tra kho (`IsOnlyCheckWarehouse = true`)
    - Lọc danh sách kiểm kê kho, chỉ giữ lại các bản ghi thuộc chi nhánh khác với chi nhánh hiện tại
    - Xác thực trạng thái hoạt động của từng kho hàng thông qua `WarehouseService.ValidateStatusOfWarehouse` (xem chi tiết tại [WarehouseValidation.md](../../Warehouse/WarehouseValidation.md))
    - Thêm đối tượng kiểm kê vào danh sách tổng hợp (`lsProductAddStockTake`)

### 7. Xử lý thông tin bảng giá
- **Xử lý chi tiết bảng giá**:
  ```csharp
  if (productDetailReturn.ListPriceBookDetail != null &&
      productDetailReturn.ListPriceBookDetail.Any())
  {
      lsPriceBookDetail.AddRange(productDetailReturn.ListPriceBookDetail);
  }
  ```
  - Kiểm tra nếu sản phẩm có thông tin chi tiết bảng giá
  - Thêm tất cả thông tin bảng giá vào danh sách tổng hợp (`lsPriceBookDetail`)

### 8. Xử lý thuộc tính sản phẩm
- **Thêm thuộc tính sản phẩm**:
  ```csharp
  if (processResult.Item4 != null)
      lsProductAttributes = lsProductAttributes.Concat(processResult.Item4)
          .ToDictionary(x => x.Key, x => x.Value);
  ```
  - Kiểm tra nếu phần tử thứ tư của tuple kết quả không null
  - Nếu có dữ liệu, kết hợp với danh sách thuộc tính hiện có và chuyển đổi thành từ điển

### 9. Xử lý kệ hàng của sản phẩm
- **Thêm thông tin kệ hàng**:
  ```csharp
  lsProductShelves.AddRange(GetListProductShelves(reqProduct, objReturn));
  ```
  - Gọi phương thức `GetListProductShelves` để lấy danh sách kệ hàng cho sản phẩm
  - Thêm tất cả kệ hàng vào danh sách tổng hợp (`lsProductShelves`)

### 10. Xử lý thông tin sản xuất
- **Kiểm tra công thức sản phẩm**:
  ```csharp
  if (isUsingProductBranchSelect && reqProduct.ProductFormulas != null && reqProduct.ProductFormulas.Any())
  {
      if(reqProduct.ProductType == (int)ProductType.Purchased)
      {
          lsProductManufacture.Add(productDetailReturn.Id);
      } else
      {
          lsProductManufactureCombo.Add(productDetailReturn.Id);
      }
  }
  ```
  - Kiểm tra nếu tính năng chọn chi nhánh sản phẩm được bật và sản phẩm có công thức
  - Dựa vào loại sản phẩm, thêm vào danh sách sản xuất hoặc danh sách combo sản xuất

## Ý nghĩa nghiệp vụ
- Hệ thống xử lý đồng bộ nhiều bảng dữ liệu liên quan đến sản phẩm
- Phân biệt xử lý giữa các loại sản phẩm khác nhau (hàng hóa, dịch vụ)
- Quản lý tồn kho, giá vốn, bảng giá, và các thuộc tính sản phẩm một cách tích hợp

## Liên hệ với các quy trình khác
- Dữ liệu được xử lý sẽ được sử dụng trong các quy trình bán hàng, kiểm kê kho, báo cáo giá vốn
- Thông tin thuộc tính và kệ hàng giúp tối ưu hóa quá trình tìm kiếm và quản lý sản phẩm

**Điều hướng**
- Trước đó: [3-2-Xu-ly-anh-xa-ma-san-pham.md](./3-2-Xu-ly-anh-xa-ma-san-pham.md)
- Tiếp theo: [3-4-Xu-ly-san-pham-con.md](./3-4-Xu-ly-san-pham-con.md) 