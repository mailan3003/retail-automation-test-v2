# Tổng quan về phương thức DoCreateOrUpdateAsync

## Mục đích
Phương thức `DoCreateOrUpdateAsync` trong lớp `StockTakeService` là phương thức cốt lõi xử lý việc tạo mới hoặc cập nhật phiếu kiểm kho (StockTake) trong hệ thống KiotViet. Phương thức này thực hiện nhiều quy trình phức tạp từ việc xác thực dữ liệu, chuẩn hóa thông tin, đến việc lưu trữ dữ liệu vào cơ sở dữ liệu và xử lý các sự kiện liên quan.

## Cấu trúc tổng quát
Phương thức này được chia thành nhiều phần chính:

1. **Khởi tạo và chuẩn bị dữ liệu ban đầu**: Thiết lập các thông số cơ bản như branch ID, kiểm tra trạng thái kho hàng, xác định phiếu kiểm kho mới hay cập nhật.
2. **Xác thực dữ liệu từ client**: Kiểm tra tính hợp lệ của dữ liệu từ phía người dùng.
3. **Chuẩn hóa và xác thực dữ liệu từ server**: Chuẩn hóa dữ liệu và kiểm tra tính hợp lệ dựa trên dữ liệu từ cơ sở dữ liệu.
4. **Xử lý thông tin lô hàng và hạn sử dụng**: Quản lý thông tin về lô hàng và hạn sử dụng sản phẩm.
5. **Tạo mới hoặc cập nhật phiếu kiểm kho**: Lưu trữ thông tin phiếu kiểm kho vào cơ sở dữ liệu.
6. **Xử lý sau khi lưu**: Theo dõi sự kiện và xử lý dữ liệu sau khi lưu trữ.

## Các tham số đầu vào

- **entity**: Đối tượng `StockTake` chứa thông tin cơ bản của phiếu kiểm kho cần tạo hoặc cập nhật.
- **itemDetails**: Danh sách các `StockTakeDetail` chứa thông tin chi tiết về sản phẩm kiểm kho.
- **isAdjust**: Cờ xác định liệu phiếu kiểm kho có được sử dụng để điều chỉnh tồn kho hay không.
- **checkPermission**: (tùy chọn) Cờ xác định liệu có kiểm tra quyền hạn người dùng hay không.
- **isMan**: Cờ xác định liệu thao tác có được thực hiện bởi người dùng thủ công hay không.
- **isDeleteWarehouse**: Cờ xác định liệu có đang xóa kho hàng hay không.

## Kết quả đầu ra
- Đối tượng `StockTake` đã được tạo mới hoặc cập nhật đầy đủ thông tin và đã được lưu vào cơ sở dữ liệu.

## Phụ thuộc chính

Phương thức này phụ thuộc vào nhiều dịch vụ và lớp tiện ích:

1. **WarehouseService**: Kiểm tra trạng thái kho hàng và tính năng kho hàng.
2. **BranchService**: Xử lý thông tin chi nhánh.
3. **StockTakeValidate**: Xác thực dữ liệu phiếu kiểm kho.
4. **StockTakeNormalize**: Chuẩn hóa dữ liệu phiếu kiểm kho.
5. **ProductService**: Truy xuất thông tin sản phẩm.
6. **ProductBranchService**: Truy xuất thông tin tồn kho sản phẩm.
7. **ProductBatchExpireService**: Quản lý thông tin lô hàng và hạn sử dụng.

## Xử lý ngoại lệ

Phương thức này xử lý các loại ngoại lệ sau:
- `KvValidateStockTakeException`: Lỗi xác thực phiếu kiểm kho.
- `KvValidateProductException`: Lỗi xác thực sản phẩm.
- `KvValidateBranchException`: Lỗi xác thực chi nhánh.
- Các ngoại lệ liên quan đến cơ sở dữ liệu và xử lý giao dịch.

## Tài liệu chi tiết các chức năng

- [1. Khởi tạo và thiết lập](./1-Chuc-nang-Khoi-tao.md)
- [2. Xác thực dữ liệu client](./2-Chuc-nang-Validate-Du-lieu.md)
- [3. Chuẩn hóa và xác thực dữ liệu server](./3-Chuc-nang-Chuan-hoa-Du-lieu.md)
- [4. Xử lý thông tin lô hàng](./4-Chuc-nang-Xu-ly-Lo-hang.md)
- [5. Tạo mới hoặc cập nhật phiếu kiểm kho](./5-Chuc-nang-Tao-Cap-nhat-Phieu-kiem.md)
- [6. Xử lý sự kiện sau lưu](./6-Chuc-nang-Xu-ly-Sau-luu.md)

## Lưu ý quan trọng

1. Phương thức này xử lý cả việc tạo mới và cập nhật phiếu kiểm kho, dựa vào giá trị của `stockTake != null`.
2. Việc điều chỉnh tồn kho (isAdjust=true) sẽ thay đổi trạng thái phiếu từ "Generator" sang "Approval".
3. Có sự xử lý đặc biệt cho sản phẩm có quản lý lô hàng (BatchExpire) và sản phẩm có quản lý số serial (LotSerial).
4. Phương thức xử lý khác nhau tùy thuộc vào việc hệ thống đang sử dụng tính năng kho hàng (isUsingWarehouse) hay không. 