# Phân tích Business Logic của phương thức InsertRelatedTableOfProduct

## Tổng quan
Phương thức `InsertRelatedTableOfProduct` là một thành phần quan trọng trong quá trình thêm sản phẩm, chịu trách nhiệm xử lý và lưu trữ tất cả các dữ liệu liên quan đến sản phẩm như bảng giá, thuộc tính, công thức, tồn kho và giá vốn. Phương thức này được gọi cho mỗi sản phẩm (cả sản phẩm cha và sản phẩm con) trong quá trình thêm sản phẩm.

## Tham số và giá trị trả về
- **Tham số**:
  - `ProductByBranch reqProduct`: Dữ liệu sản phẩm từ yêu cầu, chứa tất cả thông tin do người dùng cung cấp
  - `Product objReturn`: Đối tượng sản phẩm đã được tạo trước đó và sẽ được lưu vào cơ sở dữ liệu
  - `bool isParent`: Cờ xác định đây là sản phẩm cha hay sản phẩm con
  
- **Giá trị trả về**: Một `Tuple` gồm 4 thành phần:
  - `Product`: Sản phẩm đã được cập nhật với các dữ liệu liên quan
  - `CostTrackingUpdateCost`: Thông tin theo dõi giá vốn (nếu có)
  - `ProductAddStockTake`: Thông tin kiểm kê tồn kho (nếu có)
  - `Dictionary<Product, List<ProductAttribute>>`: Từ điển thuộc tính sản phẩm

## Các bước xử lý chính

### 1. Khởi tạo biến
- Khởi tạo các biến cần thiết:
  ```csharp
  CostTrackingUpdateCost costTracking = null;
  ProductAddStockTake productStockTake = null;
  var lsProductAttribute = new Dictionary<Product, List<ProductAttribute>>();
  ICollection<ProductFormula> saveFormula = null;
  ```
- Kiểm tra tính năng chọn chi nhánh sản phẩm có được bật không:
  ```csharp
  var isUsingProductBranchSelect = new UsingProductBranchSelectToggle().Enable(AuthService.Context.RetailerId, AuthService.Context.GroupId);
  ```
- Tính năng này cho phép quản lý sản phẩm khác nhau trên các chi nhánh khác nhau, thường được sử dụng trong doanh nghiệp đa chi nhánh

### 2. Xử lý chi tiết bảng giá
- Tạo danh sách để lưu trữ chi tiết bảng giá:
  ```csharp
  var listPriceBookDetailReturn = new List<PriceBookDetail>();
  ```
- Xác định danh sách chi tiết bảng giá cần xử lý dựa trên loại sản phẩm (cha hoặc con):
  ```csharp
  var lsProcessPriceBookDetail = isParent ? reqProduct.ListPriceBookDetail : reqProduct.ListUnitPriceBookDetail;
  ```
- Đối với sản phẩm con không có thông tin bảng giá đơn vị, sử dụng bảng giá từ sản phẩm chính:
  ```csharp
  if (!isParent && reqProduct.ListUnitPriceBookDetail == null)
  {
      lsProcessPriceBookDetail = reqProduct.ListPriceBookDetail;
  }
  ```
- Chuyển đổi thông tin bảng giá từ yêu cầu thành đối tượng `PriceBookDetail`, loại bỏ các mục có giá -1 (không áp dụng):
  ```csharp
  listPriceBookDetailReturn = lsProcessPriceBookDetail
      .Where(pd => pd.Price != -1)
      .Select(pd => new PriceBookDetail
      {
          Id = pd.Id,
          Price = pd.Price,
          ProductId = objReturn.Id,
          PriceBookId = pd.PriceBookId,
          CreatedDate = DateTime.Now
      })
      .ToList();
  ```
- Gán danh sách bảng giá đã xử lý cho sản phẩm:
  ```csharp
  objReturn.ListPriceBookDetail = listPriceBookDetailReturn;
  ```

### 3. Xác định chi nhánh hiện tại
- Lấy cấu hình tiền tệ hiện tại để xử lý làm tròn số:
  ```csharp
  var currentCurrency = NumberHelper.GetCurrentCurrency();
  ```
- Xác định ID chi nhánh hiện tại, sử dụng chi nhánh từ yêu cầu nếu không có chi nhánh hiện tại:
  ```csharp
  var currentBranchId = CurrentBranchId == 0 ? reqProduct.BranchId : CurrentBranchId;
  ```
- Các thao tác tiếp theo chỉ được thực hiện nếu có chi nhánh:
  ```csharp
  if (currentBranchId != null)
  {
      // Các xử lý liên quan đến chi nhánh
  }
  ```

### 4. Xử lý thuộc tính sản phẩm
- Kiểm tra và thêm thuộc tính sản phẩm vào từ điển:
  ```csharp
  if (reqProduct.ProductAttributes != null && reqProduct.ProductAttributes.Any())
      lsProductAttribute.Add(objReturn, reqProduct.ProductAttributes.ToList());
  ```
- Điều này cho phép lưu trữ và theo dõi các thuộc tính riêng biệt cho mỗi sản phẩm

### 5. Xử lý công thức sản phẩm
- Chỉ tạo công thức sản phẩm cho sản phẩm cơ bản (không phải sản phẩm đơn vị):
  ```csharp
  if (objReturn.MasterUnitId == null)
  {
      if (reqProduct.ProductFormulas != null && reqProduct.ProductFormulas.Any())
      {
          // Xử lý tạo hoặc cập nhật công thức
      }
  }
  ```
- Phương thức tạo hoặc cập nhật công thức phụ thuộc vào cấu hình chi nhánh sản phẩm:
  ```csharp
  saveFormula = isUsingProductBranchSelect ? 
      await ProductFormulaService.CreateOrUpdateFormulaHistoryAsync(reqProduct.ProductFormulas, objReturn.Id, reqProduct.OnHand) : 
      await ProductFormulaService.CreateOrUpdateAsync(reqProduct.ProductFormulas, objReturn.Id, reqProduct.OnHand);
  ```
- Gán công thức đã lưu cho sản phẩm và cập nhật tham chiếu lịch sử công thức:
  ```csharp
  objReturn.Formula = saveFormula;
  if (saveFormula != null && saveFormula.Any() && saveFormula.FirstOrDefault() != null)
  {
      reqProduct.ProductFormulaHistoryId = saveFormula.FirstOrDefault().ProductFormulaHistoryId;
  }
  ```

### 6. Xử lý giá vốn và chi nhánh sản phẩm theo loại sản phẩm
- Sử dụng cấu trúc switch để xử lý khác nhau cho mỗi loại sản phẩm:
  ```csharp
  switch (objReturn.ProductType)
  {
      case ((int)ProductType.Service):
          // Xử lý cho dịch vụ
      case ((int)ProductType.Manufactured):
          // Xử lý cho sản phẩm sản xuất
      case ((int)ProductType.Purchased):
          // Xử lý cho hàng mua
      default:
          break;
  }
  ```

#### a. Xử lý cho dịch vụ
- Chỉ tạo bản ghi theo dõi giá vốn nếu giá vốn khác 0:
  ```csharp
  if (reqProduct.Cost != 0)
  {
      costTracking = new CostTrackingUpdateCost
      {
          NewCost = reqProduct.Cost * (decimal)reqProduct.ConversionValue,
          BranchId = CurrentBranchId,
          RetailerId = CurrentRetailerId,
          ProductId = objReturn.Id,
          UseTracking = false
      };
      InsertRelatedTableOfProduct_SwitchService(reqProduct, costTracking);
  }
  ```
- Giá vốn được tính toán dựa trên giá cơ bản và hệ số chuyển đổi
- Mặc định không sử dụng theo dõi (`UseTracking = false`) vì dịch vụ không có tồn kho
- Phương thức `InsertRelatedTableOfProduct_SwitchService` có thể điều chỉnh cờ `UseTracking`:
  - Nếu hệ thống không sử dụng giá vốn trung bình (`!Settings.UseAvgCost`)
  - Hoặc nếu đây là sản phẩm mới (`reqProduct.Id == 0`)
  - Hoặc nếu hệ thống cho phép cập nhật giá vốn (`AllowUpdateCost`)
  - Trong các trường hợp này, `UseTracking` sẽ được đặt thành `true` để theo dõi thay đổi giá vốn
- Việc theo dõi giá vốn cho dịch vụ giúp phân tích chi phí và lợi nhuận mặc dù dịch vụ không có tồn kho vật lý

#### b. Xử lý cho sản phẩm sản xuất
- Không có xử lý đặc biệt cho sản phẩm sản xuất trong phương thức này
- Sản phẩm sản xuất thường được xử lý bởi các quy trình riêng biệt sau khi tạo sản phẩm

#### c. Xử lý cho hàng mua
- Gọi phương thức riêng để xử lý thông tin giá vốn:
  ```csharp
  costTracking = InsertRelatedTableOfProduct_SwitchPurchased(reqProduct, costTracking, saveFormula, objReturn, isParent);
  ```
- Chi tiết về phương thức này có thể tìm thấy tại [InsertRelatedTableOfProduct_SwitchPurchased-Business-Logic.md](./InsertRelatedTableOfProduct_SwitchPurchased-Business-Logic.md)
- Cập nhật hoặc tạo thông tin chi nhánh sản phẩm với số lượng tối thiểu và tối đa:
  ```csharp
  await ProductBranchService.UpdateOrCreateAsync(objReturn.Id, currentBranchId.GetValueOrDefault(), CurrentRetailerId, reqProduct.MinQuantity, reqProduct.MaxQuantity);
  ```
- Kiểm tra điều kiện để tạo bản ghi kiểm kê:
  ```csharp
  if (((reqProduct.Id == 0 && reqProduct.OnHand > 0) || (reqProduct.Id > 0 && Math.Abs(reqProduct.OnHand - reqProduct.CompareOnHand) > KVConst.Tolerance))
      && reqProduct.ProductType == (int)ProductType.Purchased && !reqProduct.IsLotSerialControl && reqProduct.IsBatchExpireControl != true)
  ```
  - Điều kiện 1: Sản phẩm mới (Id = 0) và có tồn kho ban đầu (OnHand > 0)
  - Điều kiện 2: Sản phẩm hiện tại (Id > 0) và tồn kho thay đổi vượt quá dung sai
  - Điều kiện 3: Sản phẩm thuộc loại hàng mua
  - Điều kiện 4: Không kiểm soát số serial
  - Điều kiện 5: Không kiểm soát lô/hạn sử dụng
- Tạo bản ghi kiểm kê cho sản phẩm cha:
  ```csharp
  if (isParent)
  {
      productStockTake = new ProductAddStockTake
      {
          ProductId = objReturn.Id,
          ProductCode = objReturn.Code,
          ActualCount = Math.Round(reqProduct.OnHand, currentCurrency.QuantityDec)
      };
  }
  ```
- Số lượng được làm tròn theo cấu hình tiền tệ hiện tại

### 7. Cập nhật giá vốn cho sản phẩm sản xuất
- Cập nhật giá vốn dựa trên nguyên liệu:
  ```csharp
  await ProductBranchService.UpdateManufacturedCostByMaterialAsync(objReturn.Id);
  ```
- Đảm bảo giá vốn của sản phẩm sản xuất phản ánh đúng chi phí của các nguyên liệu thành phần

### 8. Trả về kết quả
- Trả về một tuple với 4 thành phần:
  ```csharp
  return new Tuple<Product, CostTrackingUpdateCost, ProductAddStockTake, Dictionary<Product, List<ProductAttribute>>>(
      objReturn, 
      costTracking, 
      productStockTake, 
      lsProductAttribute
  );
  ```
  - Thành phần 1: Sản phẩm đã được cập nhật
  - Thành phần 2: Thông tin theo dõi giá vốn (có thể null)
  - Thành phần 3: Thông tin kiểm kê tồn kho (có thể null)
  - Thành phần 4: Từ điển thuộc tính sản phẩm

## Đặc điểm quan trọng

### 1. Tính linh hoạt
- Phương thức xử lý nhiều loại dữ liệu liên quan đến sản phẩm trong một lần gọi
- Hỗ trợ cả sản phẩm cha và sản phẩm con với các xử lý phù hợp
- Điều chỉnh hành vi dựa trên các cờ cấu hình và loại sản phẩm

### 2. Xử lý theo ngữ cảnh
- Sử dụng ngữ cảnh người dùng hiện tại (RetailerId, BranchId) để xác định phạm vi dữ liệu
- Áp dụng các quy tắc kinh doanh khác nhau cho các loại sản phẩm khác nhau
- Điều chỉnh xử lý dựa trên các tính năng được bật/tắt trong hệ thống

### 3. Cơ chế trả về dữ liệu
- Sử dụng Tuple để trả về nhiều loại dữ liệu khác nhau
- Cho phép lớp gọi xử lý từng loại dữ liệu một cách độc lập
- Cung cấp khả năng mở rộng bằng cách thêm thông tin vào Tuple mà không làm thay đổi giao diện phương thức

## Tích hợp với các thành phần khác

### 1. Tích hợp với quá trình thêm sản phẩm
- Phương thức này được gọi cho mỗi sản phẩm cha và sản phẩm con trong quá trình thêm sản phẩm
- Kết quả từ phương thức được sử dụng để cập nhật nhiều danh sách ở mức cao hơn:
  - `lsCostTracking`: Danh sách theo dõi giá vốn
  - `lsProductAddStockTake`: Danh sách kiểm kê tồn kho
  - `lsPriceBookDetail`: Danh sách chi tiết bảng giá
  - `lsProductAttributes`: Từ điển thuộc tính sản phẩm

### 2. Tích hợp với các dịch vụ
- Gọi nhiều dịch vụ khác nhau để xử lý các khía cạnh khác nhau của sản phẩm:
  - `ProductFormulaService`: Quản lý công thức sản phẩm
  - `ProductBranchService`: Quản lý tồn kho và thông tin chi nhánh
  - Các dịch vụ nội bộ khác cho xử lý cụ thể

## Liên kết và tài liệu tham khảo
- **Xử lý giá vốn cho hàng mua**: [InsertRelatedTableOfProduct_SwitchPurchased-Business-Logic.md](./InsertRelatedTableOfProduct_SwitchPurchased-Business-Logic.md)
- **Xử lý sản phẩm cha và đơn vị**: [3-Chuc-nang-xu-ly-san-pham-va-don-vi.md](./3-Chuc-nang-xu-ly-san-pham-va-don-vi.md)
- **Tổng quan quá trình thêm sản phẩm**: [Tong-quan-Product-AddMany.md](./Tong-quan-Product-AddMany.md) 