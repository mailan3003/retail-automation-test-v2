# Chức năng xử lý tìm kiếm và hoàn tất thêm sản phẩm

## Giới thiệu
Sau khi xử lý thông tin cơ bản và thuộc tính sản phẩm, hệ thống tiếp tục với các chức năng nâng cao như xử lý bảng giá cho sản phẩm được nhân bản, quản lý hình ảnh từ nhiều nguồn, tích hợp tìm kiếm và quản lý thuế. Đây là những bước cuối cùng trong quy trình thêm nhiều sản phẩm để đảm bảo dữ liệu hoàn chỉnh và dễ dàng tìm kiếm.

## Các chức năng xử lý tìm kiếm và hoàn tất

### 1. Xử lý bảng giá cho sản phẩm được nhân bản
- Hệ thống gọi phương thức `ProcessCloneProductPriceBook` với tham số là yêu cầu (`req`) và danh sách sản phẩm đã được xử lý (`listObjReturn`)
- Kết quả được lưu trong biến `priceBookDetailCloned` để sử dụng trong các bước tiếp theo
- Chức năng này giải quyết vấn đề #10886: Sao chép hình ảnh từ sản phẩm gốc sang bảng giá của sản phẩm được nhân bản
- Đảm bảo thông tin bảng giá được duy trì khi nhân bản sản phẩm, giúp duy trì tính nhất quán về giá

### 2. Xử lý hình ảnh sản phẩm từ nhiều nguồn

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

### 3. Tạo đơn vị tính mới cho gợi ý