# Phân tích Business Logic của chức năng Quản Lý Hình Ảnh Sản Phẩm

## Các bước xử lý chính

### 1. Xử lý hình ảnh sản phẩm
- **Thu thập thông tin hình ảnh**:
  - Thu thập danh sách hình ảnh từ yêu cầu: `req.ListImages`
  - Xác định danh sách ID sản phẩm đã xử lý (`allProductIdsAdded`) để liên kết hình ảnh với sản phẩm đúng
  - Kiểm tra nếu có hình ảnh cần xử lý: `req.ListImages != null && req.ListImages.Any()`
  - Danh sách hình ảnh thường chứa dữ liệu base64 của hình ảnh hoặc đường dẫn URL
  - Hệ thống ánh xạ hình ảnh với sản phẩm cụ thể dựa trên các định danh trong dữ liệu hình ảnh

- **Xác thực hình ảnh**:
  - Kiểm tra kích thước hình ảnh: đảm bảo mỗi hình ảnh không vượt quá giới hạn cho phép (thường từ 2MB đến 5MB)
  - Xác thực định dạng: kiểm tra hình ảnh có phải là định dạng được hỗ trợ (JPG, PNG, GIF, v.v.)
  - Xác thực số lượng hình ảnh cho mỗi sản phẩm không vượt quá giới hạn (thường từ 5 đến 10 hình ảnh/sản phẩm)
  - Kiểm tra dung lượng tổng hình ảnh không vượt quá giới hạn hệ thống để tránh quá tải
  - Các quy tắc xác thực này đảm bảo hiệu suất hệ thống và ngăn chặn lạm dụng

### 2. Lưu trữ hình ảnh
- **Tải lên hình ảnh**:
  - Sử dụng dịch vụ tải lên (`UploadService`) để lưu trữ hình ảnh
  - Dịch vụ tải lên có thể xử lý nhiều loại lưu trữ khác nhau:
    - Lưu trữ cục bộ: lưu trong thư mục vật lý trên máy chủ
    - Amazon S3: lưu trữ trên dịch vụ đám mây của Amazon
    - Azure Blob Storage: lưu trữ trên dịch vụ đám mây của Microsoft
    - Các dịch vụ lưu trữ khác
  - Tạo cấu trúc thư mục và tên file dựa trên ID nhà bán lẻ, ID sản phẩm và thời gian tải lên
  - Tạo metadata về kích thước file, kích thước hình ảnh và vị trí lưu trữ

- **Liên kết hình ảnh với sản phẩm**:
  - Tạo bản ghi `ProductImage` cho mỗi hình ảnh đã tải lên với các thông tin:
    - ProductId: ID của sản phẩm
    - ImageURL: Đường dẫn đến hình ảnh đã lưu trữ
    - DisplayOrder: Thứ tự hiển thị của hình ảnh
    - CreatedDate: Thời gian tạo bản ghi
    - CreatedBy: ID người dùng tạo
  - Lưu thông tin liên kết vào cơ sở dữ liệu bằng cách gọi `ProductImageService.AddAsync(productImage)`
  - Cấu trúc dữ liệu này cho phép mỗi sản phẩm có nhiều hình ảnh với thứ tự xác định

### 3. Xử lý hình ảnh mặc định
- **Thiết lập hình ảnh mặc định**:
  - Xác định hình ảnh mặc định cho mỗi sản phẩm - thường là hình ảnh đầu tiên hoặc hình ảnh được đánh dấu rõ ràng là mặc định
  - Cập nhật trường `ImagePath` trong bảng sản phẩm để lưu đường dẫn hình ảnh mặc định: `product.ImagePath = defaultImage.ImageURL`
  - Thực hiện cập nhật trong cơ sở dữ liệu: `await ProductService.UpdateAsync(product)`
  - Đảm bảo mỗi sản phẩm có tối đa một hình ảnh mặc định để duy trì tính nhất quán trong trải nghiệm người dùng
  - Hình ảnh mặc định được sử dụng trong danh sách sản phẩm, kết quả tìm kiếm và báo cáo

- **Tối ưu hóa hình ảnh**:
  - Tạo các phiên bản hình ảnh khác nhau để phục vụ các mục đích khác nhau:
    - Thumbnail (50x50 hoặc 100x100 pixel): cho danh sách sản phẩm
    - Medium (300x300 pixel): cho trang chi tiết sản phẩm
    - Large (800x800 pixel hoặc lớn hơn): cho chế độ xem chi tiết hoặc zoom
  - Nén hình ảnh để giảm dung lượng lưu trữ và tăng tốc độ tải, sử dụng các thuật toán nén như JPEG với chất lượng thích hợp
  - Lưu trữ metadata về các phiên bản hình ảnh để dễ dàng truy cập sau này
  - Có thể tích hợp với CDN (Content Delivery Network) để phân phối hình ảnh nhanh hơn đến người dùng cuối

### 4. Đồng bộ hình ảnh
- **Đồng bộ với dịch vụ tìm kiếm**:
  - Cập nhật thông tin hình ảnh trong dữ liệu tìm kiếm sản phẩm
  - Đánh dấu sản phẩm cần cập nhật trong chỉ mục tìm kiếm bằng cách tạo sự kiện đồng bộ:
    - `SyncEsEventHelper.Instance.CreateEvent(product, SyncProductSearchEventAction.AddOrUpdate)`
  - Gửi sự kiện đồng bộ để cập nhật dữ liệu tìm kiếm đến hệ thống ElasticSearch hoặc dịch vụ tìm kiếm tương tự
  - Đảm bảo rằng hình ảnh sản phẩm được hiển thị chính xác trong kết quả tìm kiếm và các giao diện khác
  - Quá trình đồng bộ có thể diễn ra ngay lập tức hoặc theo lịch trình định kỳ tùy thuộc vào cấu hình hệ thống

- **Xử lý lỗi**:
  - Ghi lại lỗi trong quá trình xử lý hình ảnh bằng cách sử dụng hệ thống log:
    - `Log.Error($"Error processing image for product {productId}: {ex.Message}", ex)`
  - Thực hiện các biện pháp khắc phục:
    - Retry logic: thử lại thao tác tải lên sau một khoảng thời gian nếu lỗi có vẻ tạm thời
    - Fallback mechanisms: sử dụng hình ảnh mặc định hoặc lưu trữ thay thế nếu phương thức chính không khả dụng
  - Thông báo cho người dùng nếu có lỗi nghiêm trọng không thể khắc phục tự động
  - Giám sát tỷ lệ lỗi để xác định các vấn đề hệ thống tiềm ẩn và cải thiện quy trình

**Điều hướng**
- Trước đó: [3-Chuc-nang-xu-ly-san-pham-va-don-vi.md](./3-Chuc-nang-xu-ly-san-pham-va-don-vi.md)
- Tiếp theo: [5-Chuc-nang-hoan-tat-va-phan-hoi.md](./5-Chuc-nang-hoan-tat-va-phan-hoi.md)
- Tài liệu liên quan: [InsertRelatedTableOfProduct-Business-Logic.md](./InsertRelatedTableOfProduct-Business-Logic.md)
- Tổng quan: [Tong-quan-Product-AddMany.md](./Tong-quan-Product-AddMany.md) 