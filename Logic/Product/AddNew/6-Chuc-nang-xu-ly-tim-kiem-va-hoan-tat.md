# Chức năng xử lý tìm kiếm và hoàn tất thêm sản phẩm

## Giới thiệu
Sau khi xử lý thông tin cơ bản và thuộc tính sản phẩm, hệ thống tiếp tục với các chức năng nâng cao như xử lý bảng giá cho sản phẩm được nhân bản, quản lý hình ảnh từ nhiều nguồn, tích hợp tìm kiếm và quản lý thuế. Đây là những bước cuối cùng trong quy trình thêm nhiều sản phẩm để đảm bảo dữ liệu hoàn chỉnh và dễ dàng tìm kiếm.

## Các chức năng xử lý tìm kiếm và hoàn tất

### 1. Xử lý hình ảnh sản phẩm từ nhiều nguồn

- **Xác định danh sách sản phẩm cần lưu hình ảnh**:
  ```csharp
  var listProductToSaveImages = new List<Product>();
  if (saveForAllProductsInGroup)
      listProductToSaveImages.AddRange(listProductsToAdd);
  else
      listProductToSaveImages.Add(firstParent);
  ```
  - Nếu cờ `saveForAllProductsInGroup` là true: thêm tất cả sản phẩm từ `listProductsToAdd` vào danh sách cần lưu hình ảnh
  - Nếu cờ `saveForAllProductsInGroup` là false: chỉ thêm sản phẩm cha đầu tiên (`firstParent`) vào danh sách

- **Xử lý hình ảnh từ URL CDN**:
  ```csharp
  await ProcessProductImagesFromUrl(req,
      listProductToSaveImages,
      req.ProductImageSuggestUrl,
      isPinSuggestImage: req.PinnedImageId.HasValue && req.PinnedImageId.Equals(-88888),
      productsImages: globalProductsImages);
  ```
  - Gọi phương thức `ProcessProductImagesFromUrl` để xử lý hình ảnh từ URL gợi ý (`req.ProductImageSuggestUrl`)
  - Kiểm tra cờ ghim ảnh gợi ý: `isPinSuggestImage: req.PinnedImageId.HasValue && req.PinnedImageId.Equals(-88888)`
  - Mã -88888 là ID đặc biệt đại diện cho ảnh gợi ý từ giao diện quản lý hàng hóa (front-end MHQL)
  - Truyền danh sách hình ảnh toàn cục (`globalProductsImages`) để quản lý tập trung

- **Xử lý hình ảnh từ kênh bán hàng (#15230)**:
  ```csharp
  if (req.ProductImagesSalesChannelUrl != null)
  {
      var isPinSuggestImage = req.PinnedImageId.HasValue && req.PinnedImageId.Equals(-15230);
      foreach (var imageUrl in req.ProductImagesSalesChannelUrl)
      {
          await ProcessProductImagesFromUrl(req,
              listProductToSaveImages,
              imageUrl,
              isPinSuggestImage: isPinSuggestImage,
              productsImages: globalProductsImages);
          isPinSuggestImage = false;
      }
  }
  ```
  - Kiểm tra nếu danh sách URL hình ảnh từ kênh bán hàng (`req.ProductImagesSalesChannelUrl`) không null
  - Xác định cờ ghim ảnh từ kênh bán hàng: `isPinSuggestImage = req.PinnedImageId.HasValue && req.PinnedImageId.Equals(-15230)`
  - Mã -15230 là ID đặc biệt đại diện cho ảnh gợi ý từ kênh bán hàng
  - Duyệt qua từng URL hình ảnh trong danh sách và xử lý bằng `ProcessProductImagesFromUrl`
  - Đặt cờ `isPinSuggestImage = false` sau khi xử lý ảnh đầu tiên để chỉ ghim ảnh đầu tiên (nếu có yêu cầu ghim)

- **Xử lý hình ảnh mới được tải lên**:
  ```csharp
  await ProcessProductImages(req, listProductToSaveImages, productsImages: globalProductsImages);
  ```
  - Gọi phương thức `ProcessProductImages` để xử lý các hình ảnh mới được tải lên từ người dùng
  - Truyền danh sách sản phẩm cần lưu hình ảnh và danh sách hình ảnh toàn cục

### 2. Tạo đơn vị tính mới cho gợi ý
- **Thu thập đơn vị tính mới**:
  ```csharp
  var listUnit = new List<string>();
  foreach (var productToAdd in listProductsToAdd)
  {
      if (!string.IsNullOrEmpty(productToAdd.Unit))
      {
          listUnit.Add(productToAdd.Unit);
      }
  }
  ```
  - Khởi tạo danh sách để lưu các đơn vị tính mới
  - Duyệt qua từng sản phẩm trong danh sách sản phẩm cần thêm
  - Kiểm tra nếu sản phẩm có đơn vị tính (`Unit`) không rỗng
  - Thêm đơn vị tính vào danh sách để xử lý sau

- **Lưu đơn vị tính mới vào hệ thống**:
  ```csharp
  if (listUnit.Any())
  {
      await ProductUnitSuggestionService.CreateNewUnitAsync(listUnit.ToList());
  }
  ```
  - Kiểm tra nếu danh sách đơn vị tính có dữ liệu
  - Gọi phương thức `CreateNewUnitAsync` của `ProductUnitSuggestionService` để lưu các đơn vị tính mới
  - Mục đích: Tạo gợi ý đơn vị tính cho các sản phẩm mới thêm vào hệ thống, giúp người dùng dễ dàng chọn đơn vị tính phù hợp trong tương lai

  ### 3. Lưu thay đổi và đồng bộ dữ liệu tìm kiếm
  - **Lưu thay đổi vào cơ sở dữ liệu**:
    ```csharp
    await Db.SaveChangesAsync();
    ```
    - Gọi phương thức `SaveChangesAsync` để lưu tất cả các thay đổi đã thực hiện vào cơ sở dữ liệu
    - Đảm bảo tính toàn vẹn dữ liệu bằng cách lưu đồng bộ tất cả các thay đổi

  - **Đồng bộ dữ liệu với Elasticsearch (nếu được kích hoạt)**:
    ```csharp
    if (AppConfigInfo.EnableEsIntegration)
    {
    }
    ```
    - Kiểm tra nếu tính năng tích hợp Elasticsearch được kích hoạt
    - Đồng bộ thông tin sản phẩm mới thêm vào Elasticsearch để phục vụ tìm kiếm
    - Xử lý đồng bộ thông tin bảng giá:
      - Kết hợp danh sách bảng giá gốc và bảng giá đã sao chép
      - Nhóm các sản phẩm theo ID bảng giá
      - Gửi sự kiện cập nhật bảng giá lên Elasticsearch

  ### 4. Xử lý thuế sản phẩm
  ```csharp
  if (IsUsingProductVAT)
  {
      for (var i = 0; i < listObjReturn.Count; i++)
      {
      }
  }
  ```
  - Kiểm tra nếu tính năng thuế sản phẩm được kích hoạt
  - Duyệt qua từng sản phẩm trong danh sách sản phẩm đã lưu
  - Xử lý thuế cho sản phẩm có ID thuế hợp lệ:
    - Kiểm tra xem sản phẩm đã có thông tin thuế chưa
    - Nếu có: cập nhật ID thuế mới cho các bản ghi thuế hiện có
    - Nếu chưa: tạo mới bản ghi thuế cho sản phẩm
  - Đảm bảo tính nhất quán của thông tin thuế trong hệ thống

## Điều hướng tài liệu
- Trước đó: [5-Chuc-nang-xu-ly-ton-kho-ban-dau.md](./5-Chuc-nang-xu-ly-ton-kho-ban-dau.md)
- Tiếp theo: [7-Quan-ly-lich-su-thao-tac.md](./7-Quan-ly-lich-su-thao-tac.md)
- Tổng quan: [0-Tong-quan-Product-AddMany.md](./0-Tong-quan-Product-AddMany.md)

