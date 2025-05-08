# Quản Lý Hình Ảnh Sản Phẩm - Post(ProductAddMany req)

## Mục Đích
Chức năng này thực hiện việc xử lý và quản lý hình ảnh sản phẩm trong quá trình thêm nhiều sản phẩm vào hệ thống, bao gồm việc tải lên, xử lý, lưu trữ và liên kết hình ảnh với sản phẩm.

## Danh Sách Chức Năng Con

### 1. Xử lý hình ảnh từ sản phẩm được sao chép
#### Mô tả
Sao chép hình ảnh từ sản phẩm nguồn (CloneProductId) sang sản phẩm mới tạo.

#### Logic nghiệp vụ
- Gọi ProcessCloneProduct để sao chép hình ảnh từ sản phẩm nguồn
- Tùy theo cấu hình SaveImagesForAllProducts, áp dụng cho một hoặc tất cả sản phẩm trong nhóm
- Lưu thông tin hình ảnh vào danh sách globalProductsImages để xử lý tiếp theo

#### Thông số đầu vào/ra
- **Đầu vào**: req.CloneProductId, formData["SaveImagesForAllProducts"], listProductToSaveImages
- **Đầu ra**: Danh sách hình ảnh sản phẩm đã được sao chép (globalProductsImages)

#### Mã kiểm thử thất bại
```json
{
  "req": {
    "CloneProductId": -1  // ID sản phẩm không tồn tại
  },
  "formData": {
    "SaveImagesForAllProducts": "true"
  },
  "listProductToSaveImages": [
    {"Id": 1001, "Name": "Sản phẩm A"}
  ]
}
```

### 2. Xử lý hình ảnh từ URL gợi ý
#### Mô tả
Tải và xử lý hình ảnh từ URL gợi ý (ProductImageSuggestUrl) và liên kết với sản phẩm.

#### Logic nghiệp vụ
- Gọi ProcessProductImagesFromUrl để tải và xử lý hình ảnh từ URL
- Kiểm tra cờ isPinSuggestImage (PinnedImageId = -88888) để xác định có ghim hình ảnh này không
- Lưu thông tin vào danh sách globalProductsImages để quản lý

#### Thông số đầu vào/ra
- **Đầu vào**: req.ProductImageSuggestUrl, req.PinnedImageId, listProductToSaveImages
- **Đầu ra**: Hình ảnh đã được tải và xử lý, thêm vào globalProductsImages

#### Mã kiểm thử thất bại
```json
{
  "req": {
    "ProductImageSuggestUrl": "http://invalid-url.com/image.jpg",
    "PinnedImageId": -88888  // Yêu cầu ghim ảnh từ URL gợi ý
  },
  "listProductToSaveImages": [
    {"Id": 1001, "Name": "Sản phẩm A"}
  ]
}
```

### 3. Xử lý hình ảnh từ kênh bán hàng
#### Mô tả
Tải và xử lý hình ảnh từ các URL kênh bán hàng (ProductImagesSalesChannelUrl) và liên kết với sản phẩm.

#### Logic nghiệp vụ
- Lặp qua danh sách URL từ ProductImagesSalesChannelUrl và gọi ProcessProductImagesFromUrl
- Kiểm tra cờ ghim ảnh (PinnedImageId = -15230) chỉ áp dụng cho ảnh đầu tiên
- Sau khi xử lý ảnh đầu tiên, đặt lại cờ ghim để tránh ghim nhiều ảnh

#### Thông số đầu vào/ra
- **Đầu vào**: req.ProductImagesSalesChannelUrl, req.PinnedImageId, listProductToSaveImages
- **Đầu ra**: Danh sách hình ảnh đã được tải và xử lý, thêm vào globalProductsImages

#### Mã kiểm thử thất bại
```json
{
  "req": {
    "ProductImagesSalesChannelUrl": [
      "http://invalid-url.com/image1.jpg",
      "http://example.com/image2.jpg"
    ],
    "PinnedImageId": -15230  // Yêu cầu ghim ảnh từ kênh bán hàng
  },
  "listProductToSaveImages": [
    {"Id": 1001, "Name": "Sản phẩm A"}
  ]
}
```

### 4. Xử lý hình ảnh tải lên mới
#### Mô tả
Xử lý hình ảnh mới được tải lên từ client và liên kết với sản phẩm.

#### Logic nghiệp vụ
- Gọi ProcessProductImages để xử lý hình ảnh tải lên
- Chuẩn hóa định dạng và kích thước hình ảnh theo cấu hình hệ thống
- Lưu trữ hình ảnh vào hệ thống và cập nhật cơ sở dữ liệu

#### Thông số đầu vào/ra
- **Đầu vào**: req (chứa thông tin yêu cầu tải lên), listProductToSaveImages
- **Đầu ra**: Danh sách hình ảnh đã được xử lý và lưu trữ, thêm vào globalProductsImages

#### Mã kiểm thử thất bại
```json
{
  "req": {
    "UploadedImages": [
      {
        "Content": "base64_encoded_invalid_image_data",
        "FileName": "image.xyz"  // Định dạng không được hỗ trợ
      }
    ]
  },
  "listProductToSaveImages": [
    {"Id": 1001, "Name": "Sản phẩm A"}
  ]
}
```

### 5. Xử lý hình ảnh được ghim
#### Mô tả
Xác định và thiết lập hình ảnh được ghim (pinned) cho sản phẩm.

#### Logic nghiệp vụ
- Kiểm tra giá trị req.PinnedImageId để xác định hình ảnh cần ghim
- Cập nhật trạng thái ghim cho hình ảnh được chọn
- Đảm bảo chỉ có một hình ảnh được ghim cho mỗi sản phẩm

#### Thông số đầu vào/ra
- **Đầu vào**: req.PinnedImageId, globalProductsImages
- **Đầu ra**: Cập nhật trạng thái ghim trong danh sách globalProductsImages

#### Mã kiểm thử thất bại
```json
{
  "req": {
    "PinnedImageId": 9999  // ID không tồn tại trong danh sách hình ảnh
  },
  "globalProductsImages": [
    {"Id": 1, "ProductId": 1001, "Image": "image1.jpg"},
    {"Id": 2, "ProductId": 1001, "Image": "image2.jpg"}
  ]
}
```

### 6. Xử lý xóa hình ảnh
#### Mô tả
Xử lý yêu cầu xóa hình ảnh thông qua danh sách ID hình ảnh cần xóa.

#### Logic nghiệp vụ
- Đọc danh sách DeletedImageId từ req
- Xác thực quyền xóa hình ảnh
- Xóa hình ảnh khỏi hệ thống lưu trữ và cơ sở dữ liệu

#### Thông số đầu vào/ra
- **Đầu vào**: req.DeletedImageId
- **Đầu ra**: Xác nhận xóa hình ảnh thành công hoặc thông báo lỗi

#### Mã kiểm thử thất bại
```json
{
  "req": {
    "DeletedImageId": [1, 2, 999]  // ID 999 không tồn tại
  },
  "AuthService": {
    "HasPermission": false  // Không có quyền xóa
  }
}
```

### 7. Sao chép hình ảnh cho bảng giá
#### Mô tả
Sao chép hình ảnh sản phẩm cho bảng giá khi sản phẩm được thêm vào bảng giá.

#### Logic nghiệp vụ
- Gọi ProcessCloneProductPriceBook để sao chép hình ảnh cho bảng giá
- Xác định sản phẩm đích và bảng giá cần áp dụng
- Tạo bản sao hình ảnh và liên kết với bản ghi bảng giá

#### Thông số đầu vào/ra
- **Đầu vào**: req (thông tin yêu cầu), listObjReturn (danh sách sản phẩm đã xử lý)
- **Đầu ra**: Danh sách chi tiết bảng giá đã được sao chép hình ảnh

#### Mã kiểm thử thất bại
```json
{
  "req": {
    "CloneProductId": 1001  // Sản phẩm nguồn
  },
  "listObjReturn": [
    {
      "Id": 2001,
      "ListPriceBookDetail": null  // Không có thông tin bảng giá
    }
  ]
}
```

## Quy Trình Xử Lý Tổng Thể
1. Tiếp nhận và phân tích thông tin hình ảnh từ nhiều nguồn
2. Xử lý hình ảnh từ sản phẩm được sao chép (nếu có)
3. Xử lý hình ảnh từ URL gợi ý (nếu có)
4. Xử lý hình ảnh từ kênh bán hàng (nếu có)
5. Xử lý hình ảnh mới tải lên (nếu có)
6. Xác định và thiết lập hình ảnh được ghim
7. Xử lý yêu cầu xóa hình ảnh (nếu có)
8. Sao chép hình ảnh cho bảng giá (nếu áp dụng)
9. Lưu tất cả thông tin hình ảnh vào cơ sở dữ liệu

## Phụ Thuộc Mã Nguồn
- Hàm `ProcessCloneProduct`: Sao chép hình ảnh từ sản phẩm nguồn
- Hàm `ProcessProductImagesFromUrl`: Tải và xử lý hình ảnh từ URL
- Hàm `ProcessProductImages`: Xử lý hình ảnh tải lên
- Hàm `ProcessCloneProductPriceBook`: Sao chép hình ảnh cho bảng giá
- Dịch vụ xử lý và lưu trữ hình ảnh: Để tối ưu và lưu trữ hình ảnh

## Điểm Lưu Ý Quan Trọng
1. Hệ thống hỗ trợ các định dạng hình ảnh phổ biến: JPG, PNG, GIF, WEBP
2. Mỗi sản phẩm có thể có nhiều hình ảnh nhưng chỉ một hình ảnh được ghim
3. Có nhiều nguồn hình ảnh khác nhau và cần xử lý theo thứ tự ưu tiên
4. Cờ ghim ảnh PinnedImageId có giá trị đặc biệt: -88888 cho URL gợi ý, -15230 cho kênh bán hàng
5. Tùy chọn SaveImagesForAllProducts ảnh hưởng đến việc áp dụng hình ảnh cho một hay tất cả sản phẩm trong nhóm

## Cấu Hình Dữ Liệu Kiểm Thử Thất Bại

### 1. URL hình ảnh không hợp lệ
```json
{
  "ListProducts": [
    {
      "Name": "Sản phẩm A",
      "CategoryId": 1001,
      "Code": "SP001",
      "Images": [
        "http://example.com/invalid-image.jpg",
        "https://invalid-domain.com/image.png"
      ]
    }
  ],
  "ProductImageSuggestUrl": "http://non-existent-server.com/image.jpg"
}
```

### 2. Định dạng hình ảnh không được hỗ trợ
```json
{
  "ListProducts": [
    {
      "Name": "Sản phẩm A",
      "CategoryId": 1001,
      "Code": "SP001",
      "Images": [
        "data:image/bmp;base64,..."
      ]
    }
  ]
}
```

### 3. PinnedImageId không hợp lệ
```json
{
  "ListProducts": [
    {
      "Name": "Sản phẩm A",
      "CategoryId": 1001,
      "Code": "SP001",
      "Images": [
        "https://example.com/valid-image.jpg"
      ]
    }
  ],
  "PinnedImageId": 99999
}
```

## Quy Tắc Nghiệp Vụ
1. Mỗi sản phẩm có thể có tối đa 10 hình ảnh (có thể điều chỉnh theo cấu hình)
2. Hình ảnh được ghim sẽ được hiển thị là hình ảnh chính của sản phẩm
3. Các định dạng hình ảnh được hỗ trợ: JPG, JPEG, PNG, GIF, WEBP
4. Kích thước tối đa của hình ảnh: 5MB
5. Hệ thống tự động tạo các biến thể hình ảnh với kích thước khác nhau
6. Danh sách `DeletedImageId` được sử dụng để xóa các hình ảnh không còn cần thiết 

# Phân tích Business Logic của chức năng Quản Lý Hình Ảnh Sản Phẩm

## Các bước xử lý chính

### 1. Quản lý và thu thập hình ảnh từ nhiều nguồn
- **Quản lý đối tượng hình ảnh tổng thể**:
  - Sử dụng đối tượng `globalProductsImages` để lưu trữ tất cả hình ảnh từ mọi nguồn
  - Đối tượng này là danh sách chung, được sử dụng xuyên suốt toàn bộ quá trình xử lý
  - Lưu trữ đầy đủ thông tin: ID, ID sản phẩm, URL hình ảnh, trạng thái ghim, thứ tự hiển thị

- **Xác định phạm vi áp dụng hình ảnh**:
  - Kiểm tra cờ `saveForAllProductsInGroup` từ `formData.Get("SaveImagesForAllProducts")`
  - Nếu true, áp dụng hình ảnh cho tất cả sản phẩm trong nhóm
  - Nếu false, chỉ áp dụng cho sản phẩm đầu tiên trong danh sách

### 2. Xử lý hình ảnh sản phẩm nhân bản
- **Nhân bản hình ảnh từ sản phẩm nguồn**:
  - Kiểm tra `req.CloneProductId` để xác định có nhân bản sản phẩm không
  - Gọi `ProcessCloneProduct(req, productsListToCloneImages, productsImages: globalProductsImages)`
  - Sao chép hình ảnh từ sản phẩm gốc cho các sản phẩm mới

- **Nhân bản hình ảnh cho bảng giá**:
  - Gọi `ProcessCloneProductPriceBook(req, listObjReturn)` để sao chép hình ảnh cho bảng giá
  - Đảm bảo hình ảnh được áp dụng cho cả sản phẩm trong bảng giá

### 3. Xử lý hình ảnh từ URL
- **Xử lý hình ảnh từ URL gợi ý**:
  - Kiểm tra `req.ProductImageSuggestUrl` để lấy hình ảnh từ URL
  - Gọi `ProcessProductImagesFromUrl` để tải và xử lý hình ảnh
  - Kiểm tra cờ ghim `-88888` để xác định có ghim hình ảnh này không

- **Xử lý hình ảnh từ kênh bán hàng**:
  - Duyệt qua danh sách `req.ProductImagesSalesChannelUrl` để xử lý mỗi URL
  - Kiểm tra cờ ghim `-15230` để xác định có ghim hình ảnh đầu tiên không
  - Chỉ ghim ảnh đầu tiên trong danh sách, sau đó reset cờ ghim

### 4. Xử lý hình ảnh tải lên
- **Xử lý hình ảnh mới**:
  - Gọi `ProcessProductImages(req, listProductToSaveImages, productsImages: globalProductsImages)`
  - Xử lý hình ảnh được tải lên từ client với nhiều định dạng
  - Thực hiện tối ưu hình ảnh, điều chỉnh kích thước, và lưu trữ

### 5. Xử lý trạng thái ghim và thứ tự hình ảnh
- **Quản lý hình ảnh ghim**:
  - Sử dụng `req.PinnedImageId` để xác định ID hình ảnh cần ghim
  - Đảm bảo mỗi sản phẩm chỉ có một hình ảnh được ghim
  - Cập nhật trạng thái ghim và thứ tự hiển thị trong `globalProductsImages`

- **Xử lý thứ tự hình ảnh**:
  - Sắp xếp hình ảnh theo thứ tự ưu tiên: ảnh ghim trước, sau đó theo thời gian tạo
  - Áp dụng thứ tự hiển thị cho tất cả các hình ảnh trong `globalProductsImages`

### 6. Xử lý xóa hình ảnh
- **Xóa hình ảnh không cần thiết**:
  - Đọc danh sách `req.DeletedImageId` để xác định các hình ảnh cần xóa
  - Kiểm tra quyền xóa hình ảnh thông qua AuthService
  - Xóa hình ảnh khỏi hệ thống lưu trữ và cơ sở dữ liệu

### 7. Lưu trữ và trả về kết quả
- **Lưu trữ hình ảnh vào cơ sở dữ liệu**:
  - Thực hiện `Db.SaveChangesAsync()` để lưu tất cả thông tin về hình ảnh
  - Ánh xạ hình ảnh với sản phẩm trong kết quả trả về

## Mã nguồn tham chiếu chính
```csharp
// Xác định phạm vi áp dụng hình ảnh
var saveForAllProductsInGroup = formData != null && ConvertHelper.ToBoolean(formData.Get("SaveImagesForAllProducts"));
var productsListToCloneImages = new List<Product>();
if (saveForAllProductsInGroup)
    productsListToCloneImages.AddRange(listObjReturn);
else
    productsListToCloneImages.Add(listObjReturn.FirstOrDefault());

// Xử lý hình ảnh từ sản phẩm nhân bản
await ProcessCloneProduct(req, productsListToCloneImages, productsImages: globalProductsImages);

// Nhân bản hình ảnh cho bảng giá
var priceBookDetailCloned = await ProcessCloneProductPriceBook(req, listObjReturn);

// Xử lý hình ảnh từ URL gợi ý
await ProcessProductImagesFromUrl(req,
    listProductToSaveImages,
    req.ProductImageSuggestUrl,
    isPinSuggestImage: req.PinnedImageId.HasValue && req.PinnedImageId.Equals(-88888),
    productsImages: globalProductsImages);

// Xử lý hình ảnh từ kênh bán hàng
if (req.ProductImagesSalesChannelUrl != null) {
    var isPinSuggestImage = req.PinnedImageId.HasValue && req.PinnedImageId.Equals(-15230);
    foreach (var imageUrl in req.ProductImagesSalesChannelUrl) {
        await ProcessProductImagesFromUrl(req,
            listProductToSaveImages,
            imageUrl,
            isPinSuggestImage: isPinSuggestImage,
            productsImages: globalProductsImages);
        isPinSuggestImage = false; // Chỉ ghim ảnh đầu tiên
    }
}

// Xử lý hình ảnh tải lên từ client
await ProcessProductImages(req, listProductToSaveImages, productsImages: globalProductsImages);

// Lưu dữ liệu hình ảnh
await Db.SaveChangesAsync();

// Ánh xạ hình ảnh vào kết quả trả về
foreach (var item in data) {
    if (globalProductsImages.Any()) {
        item.ProductImages = globalProductsImages.Where(i => i.ProductId == item.Id)
            ?.OrderBy(i => i.CreatedDate)?.ThenBy(i => i.Id)?.ToList() 
            ?? new List<ProductImage>();
    }
}
```

## Các vấn đề kỹ thuật quan trọng

### 1. Xử lý đường dẫn hình ảnh và lưu trữ
- Hình ảnh được lưu trữ với đường dẫn tương đối hoặc URL đầy đủ tùy theo nguồn
- Hỗ trợ nhiều định dạng hình ảnh: JPG, PNG, GIF, WEBP
- Kích thước tối đa cho mỗi hình ảnh thường là 5MB
- Hệ thống tạo các biến thể hình ảnh với kích thước khác nhau để tối ưu hiển thị

### 2. Kiểm soát trạng thái ghim ảnh
- Cờ ghim đặc biệt `-88888` dùng cho URL gợi ý
- Cờ ghim đặc biệt `-15230` dùng cho kênh bán hàng
- ID thực tế được sử dụng cho hình ảnh đã tồn tại trong hệ thống
- Mỗi sản phẩm chỉ có một hình ảnh được ghim tại một thời điểm

### 3. Tối ưu hóa hiệu suất và tài nguyên
- Xử lý hình ảnh không đồng bộ để không chặn luồng chính
- Sử dụng shared collection `globalProductsImages` để tránh truy vấn lặp lại
- Kiểm soát số lượng hình ảnh tối đa cho mỗi sản phẩm (thường là 10 hình ảnh)

### 4. Xử lý lỗi và ngoại lệ
- Xử lý URL không hợp lệ hoặc không thể truy cập
- Kiểm tra định dạng hình ảnh không được hỗ trợ
- Quản lý lỗi khi kích thước hình ảnh vượt quá giới hạn

## Test Data JSON cho các trường hợp thất bại

### 1. URL hình ảnh không hợp lệ
```json
{
  "req": {
    "ProductImageSuggestUrl": "http://invalid-domain.com/non-existent-image.jpg",
    "PinnedImageId": -88888
  },
  "ExpectedResult": {
    "Exception": "KvValidateProductException",
    "Message": "Không thể tải hình ảnh từ URL đã cung cấp"
  }
}
```

### 2. Định dạng hình ảnh không được hỗ trợ
```json
{
  "req": {
    "UploadedImages": [
      {
        "Content": "base64_encoded_image",
        "FileName": "image.bmp"
      }
    ]
  },
  "ExpectedResult": {
    "Exception": "KvValidateProductException",
    "Message": "Định dạng hình ảnh không được hỗ trợ"
  }
}
```

---
**Điều hướng**
- Trước đó: [2-Chuc-nang-xac-thuc-san-pham.md](./2-Chuc-nang-xac-thuc-san-pham.md)
- Tiếp theo: [4-Chuc-nang-nhan-ban-san-pham.md](./4-Chuc-nang-nhan-ban-san-pham.md)
- Tổng quan: [Tong-quan-Product-AddMany.md](./Tong-quan-Product-AddMany.md) 