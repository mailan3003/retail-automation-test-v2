# Phân tích Business Logic của chức năng Hoàn Tất và Phản Hồi

## Các bước xử lý chính

### 1. Xử lý dữ liệu sau khi lưu sản phẩm
- **Cập nhật đồng bộ giá vốn**:
  - Nếu có dữ liệu theo dõi giá vốn (`lsCostTracking`), cập nhật vào cơ sở dữ liệu bằng cách gọi `ProductService.UpdateCostTrackingAsync(lsCostTracking)`
  - Quá trình này duy trì lịch sử thay đổi giá vốn và đảm bảo tính minh bạch trong kế toán
  - Đối với các sản phẩm giá 0 (`lsNewProductIdHaveCostEqual0`), hệ thống có thể tạo bản ghi cân bằng giá vốn đặc biệt
  - Đồng bộ giá vốn giữa sản phẩm cha và sản phẩm con để đảm bảo tính nhất quán

- **Xử lý bảng giá**:
  - Nếu có chi tiết bảng giá (`lsPriceBookDetail`), lưu vào cơ sở dữ liệu bằng cách gọi `PriceBookDetailService.BatchAddAsync(lsPriceBookDetail)`
  - Hệ thống hỗ trợ nhiều bảng giá khác nhau cho cùng một sản phẩm:
    - Bảng giá bán lẻ (Retail)
    - Bảng giá bán buôn (Wholesale)
    - Bảng giá khuyến mãi (Promotion)
    - Bảng giá theo nhóm khách hàng (Customer Group)
  - Mỗi bảng giá có thể có các quy tắc áp dụng khác nhau về thời gian, điều kiện và phạm vi
  - Cập nhật các chỉ số liên quan đến giá như lợi nhuận biên, phần trăm chiết khấu, v.v.

- **Xử lý thuộc tính sản phẩm**:
  - Cập nhật các thuộc tính sản phẩm trong cơ sở dữ liệu bằng cách gọi `ProductAttributeService.UpdateProductAttributesAsync(lsProductAttributes)`
  - Thuộc tính được lưu trữ dưới dạng cặp khóa-giá trị để dễ dàng mở rộng và truy vấn
  - Thuộc tính có thể gồm nhiều loại:
    - Thuộc tính cơ bản (màu sắc, kích thước, trọng lượng)
    - Thuộc tính kỹ thuật (thông số kỹ thuật, vật liệu)
    - Thuộc tính phân loại (loại, nhóm, thương hiệu)
  - Các thuộc tính này hỗ trợ cho chức năng tìm kiếm, lọc và hiển thị sản phẩm

- **Xử lý kệ hàng**:
  - Lưu thông tin kệ hàng cho sản phẩm vào cơ sở dữ liệu: `await ProductShelfService.BatchAddAsync(lsProductShelves)`
  - Thông tin kệ hàng bao gồm:
    - Mã kệ, tên kệ
    - Vị trí trong cửa hàng (khu vực, tầng)
    - Sức chứa và đơn vị đo
  - Cập nhật vị trí sản phẩm giúp nhân viên dễ dàng tìm kiếm và bổ sung hàng hóa
  - Hỗ trợ quản lý không gian bán lẻ và tối ưu hóa bố trí cửa hàng

### 2. Xử lý kiểm kê kho hàng
- **Chèn dữ liệu kiểm kê**:
  - Nếu có dữ liệu kiểm kê (`lsProductAddStockTake`), lưu vào cơ sở dữ liệu bằng cách gọi `StockTakeService.BatchAddAsync(lsProductAddStockTake)`
  - Dữ liệu kiểm kê thiết lập số lượng tồn kho ban đầu cho sản phẩm mới
  - Quá trình này bao gồm:
    - Tạo bản ghi kiểm kê chính (StockTake)
    - Tạo các bản ghi chi tiết kiểm kê (StockTakeDetail) 
    - Cập nhật số lượng trong bảng ProductBranch
  - Đối với sản phẩm có kiểm soát lô/hạn sử dụng, hệ thống tạo các bản ghi phù hợp trong bảng ProductBatchExpire

- **Xử lý sản phẩm sản xuất**:
  - Nếu có sản phẩm sản xuất (`lsProductManufacture`), cập nhật thông tin bằng cách gọi `ProductService.UpdateProductManufactureAsync(lsProductManufacture)`
  - Thông tin bao gồm:
    - Danh sách nguyên liệu (thành phần)
    - Định lượng cho mỗi nguyên liệu
    - Quy trình sản xuất và thời gian
  - Đối với sản phẩm combo (`lsProductManufactureCombo`), cập nhật thông tin combo: `ProductService.UpdateProductManufactureComboAsync(lsProductManufactureCombo)`
  - Việc cập nhật này đảm bảo hệ thống có thể tự động tính toán giá vốn và cập nhật tồn kho khi sản xuất sản phẩm

- **Xử lý đơn vị chi nhánh**:
  - Cập nhật thông tin đơn vị chi nhánh sản phẩm bằng cách gọi `ProductService.UpdateProductBranchUnitAsync(lsChangeProductBranchUnit)`
  - Quá trình này đồng bộ các tham số giữa các đơn vị sản phẩm:
    - Tỷ lệ chuyển đổi giữa các đơn vị
    - Số lượng tối thiểu và tối đa cho mỗi đơn vị
    - Giá bán và giá vốn theo tỷ lệ
  - Đảm bảo rằng các đơn vị sản phẩm được quản lý đồng bộ trên tất cả các chi nhánh
  - Hỗ trợ tính năng chuyển đổi đơn vị trong quá trình bán hàng và nhập kho

### 3. Đồng bộ dữ liệu tìm kiếm
- **Tạo sự kiện đồng bộ**:
  - Nếu có sự kiện đồng bộ tìm kiếm (`listEventSyncProductSearch`), xử lý bằng cách gọi `SearchSyncService.CreateEventsAsync(listEventSyncProductSearch)`
  - Quá trình đồng bộ có thể được thực hiện ngay hoặc theo lịch trình định kỳ tùy thuộc vào cấu hình
  - Các sự kiện đồng bộ được gửi đến dịch vụ ElasticSearch (hoặc dịch vụ tìm kiếm tương tự)
  - Sự kiện bao gồm thông tin về sản phẩm cần đồng bộ (ID, loại thao tác, thời gian)
  - Đảm bảo dữ liệu sản phẩm được cập nhật trong dịch vụ tìm kiếm để người dùng có thể tìm thấy sản phẩm mới

- **Xử lý thông báo**:
  - Tạo thông báo cho người dùng về kết quả thêm sản phẩm: `await NotificationService.CreateProductAddedNotificationAsync(listObjReturn, currentUserName)`
  - Thông báo có thể được gửi qua nhiều kênh:
    - Thông báo trong ứng dụng
    - Email
    - SMS
    - Push notification cho thiết bị di động
  - Nội dung thông báo thường bao gồm số lượng sản phẩm đã thêm, thời gian và thông tin người thực hiện
  - Hệ thống có thể gửi thông báo đến các vai trò khác nhau (quản lý, kế toán, nhân viên kho)

### 4. Chuẩn bị dữ liệu trả về
- **Chuẩn bị danh sách kết quả**:
  - Tạo danh sách sản phẩm đã thêm thành công `listObjReturn` với các thông tin cơ bản:
    - ID sản phẩm: để tham chiếu trong hệ thống
    - Mã sản phẩm: mã duy nhất để nhận dạng
    - Tên sản phẩm: thông tin hiển thị
    - Đơn vị: đơn vị tính của sản phẩm
    - Loại sản phẩm: hàng hóa, dịch vụ, combo, v.v.
  - Danh sách này được sắp xếp theo thứ tự phù hợp cho việc hiển thị hoặc xử lý tiếp theo

- **Xử lý dữ liệu bổ sung**:
  - Thêm thông tin thuế vào kết quả nếu sử dụng chức năng thuế: `response.ListTaxs = listTaxs`
  - Thêm thông tin bảng giá và các thiết lập giá:
    - Giá bán lẻ
    - Giá bán buôn
    - Giá vốn
    - Lợi nhuận biên
  - Có thể bao gồm các thông số khác như tồn kho ban đầu, thông tin kho hàng, v.v.
  - Dữ liệu này giúp người dùng có cái nhìn tổng quan về sản phẩm vừa thêm

- **Tạo phản hồi API**:
  - Đóng gói dữ liệu kết quả thành đối tượng phản hồi API `ProductAddResponse`:
    - Danh sách sản phẩm đã thêm
    - Thống kê (số lượng thêm thành công, thất bại)
    - Thông tin bổ sung (thuế, bảng giá)
  - Thêm thông tin mã trạng thái (StatusCode): 200 cho thành công, 400/500 cho lỗi
  - Thêm thông báo thành công: "Thêm sản phẩm thành công"
  - Định dạng dữ liệu theo chuẩn API (thường là JSON) với các trường được đặt tên theo quy ước camelCase

### 5. Xử lý lỗi và ngoại lệ
- **Bắt và xử lý ngoại lệ**:
  - Bắt các ngoại lệ trong quá trình thêm sản phẩm bằng cấu trúc try-catch
  - Phân loại ngoại lệ theo nguồn gốc:
    - Lỗi xác thực dữ liệu (KvValidateProductException)
    - Lỗi cơ sở dữ liệu (SqlException, DbUpdateException)
    - Lỗi dược phẩm (KvValidateProductMedicineException)
    - Lỗi hệ thống chung (Exception)
  - Mỗi loại lỗi được xử lý theo cách thích hợp, có thể bao gồm việc rollback giao dịch cơ sở dữ liệu

- **Ghi log lỗi**:
  - Ghi lại thông tin lỗi vào hệ thống log bằng cách sử dụng `Log.Error(ex.Message, ex)`
  - Thông tin log bao gồm:
    - Thời gian xảy ra lỗi
    - Loại lỗi và thông báo lỗi
    - Stack trace để hỗ trợ gỡ lỗi
    - Dữ liệu liên quan (ID sản phẩm, thông tin người dùng)
  - Hệ thống log có thể sử dụng các công cụ như Serilog, NLog hoặc log4net
  - Log được lưu trong cơ sở dữ liệu hoặc tệp văn bản, có thể được gửi đến các dịch vụ giám sát

- **Trả về thông báo lỗi**:
  - Tạo phản hồi lỗi với định dạng nhất quán:
    - Mã lỗi: xác định loại lỗi
    - Thông báo lỗi: mô tả ngắn gọn về vấn đề
    - Chi tiết lỗi: thông tin bổ sung để giúp người dùng giải quyết vấn đề
  - Đảm bảo thông báo lỗi dễ hiểu cho người dùng, tránh các thuật ngữ kỹ thuật phức tạp
  - Thông báo lỗi có thể được dịch sang ngôn ngữ của người dùng
  - Trong một số trường hợp, cung cấp hướng dẫn khắc phục hoặc liên kết đến tài liệu hỗ trợ

**Điều hướng**
- Trước đó: [4-Chuc-nang-quan-ly-hinh-anh.md](./4-Chuc-nang-quan-ly-hinh-anh.md)
- Tài liệu liên quan: [InsertRelatedTableOfProduct-Business-Logic.md](./InsertRelatedTableOfProduct-Business-Logic.md)
- Trở về tổng quan: [Tong-quan-Product-AddMany.md](./Tong-quan-Product-AddMany.md) 