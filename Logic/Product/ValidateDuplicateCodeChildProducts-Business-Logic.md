# Logic Nghiệp Vụ của Phương Thức ValidateDuplicateCodeChildProducts

## Tổng Quan
Phương thức `ValidateDuplicateCodeChildProducts` được thiết kế để kiểm tra và ngăn chặn việc tạo các sản phẩm con có mã (code) trùng lặp. Phương thức này đảm bảo tính duy nhất của mã sản phẩm trong hệ thống, giúp tránh xung đột và duy trì tính toàn vẹn của dữ liệu.

## Tham Số
- `childProducts`: Danh sách các sản phẩm con cần kiểm tra

## Quy Trình Chi Tiết

1. **Khởi Tạo Biến**
   - Hệ thống khởi tạo biến `duplicateUnitCodes` là chuỗi rỗng để lưu trữ các mã sản phẩm trùng lặp (nếu có)

2. **Kiểm Tra Sự Trùng Lặp**
   - Hệ thống so sánh số lượng sản phẩm trong danh sách với số lượng mã sản phẩm duy nhất (distinct)
   - Nếu số lượng không bằng nhau, nghĩa là có mã sản phẩm bị trùng lặp

3. **Xác Định Các Mã Trùng Lặp**
   - Hệ thống nhóm các sản phẩm theo mã (code)
   - Lọc ra các nhóm có nhiều hơn một sản phẩm (tức là mã bị trùng)
   - Trích xuất và làm phẳng danh sách các sản phẩm có mã bị trùng
   - Lấy danh sách duy nhất các mã bị trùng lặp
   - Nối các mã thành một chuỗi, phân cách bằng dấu phẩy

4. **Ném Ngoại Lệ Nếu Có Trùng Lặp**
   - Kiểm tra xem chuỗi `duplicateUnitCodes` có rỗng không
   - Nếu không rỗng (có mã trùng lặp), hệ thống ném ngoại lệ `KvValidateProductException`
   - Thông báo lỗi được định dạng dựa trên mẫu từ `KVMessage._GlobalDuplicateData` với giá trị "{0} đã tồn tại" và cụ thể hóa với tên trường `ProductLog_UnitCode` cùng danh sách các mã bị trùng

## Ý Nghĩa Kinh Doanh
- Đảm bảo tính duy nhất của mã sản phẩm trong hệ thống bán lẻ
- Ngăn chặn việc tạo ra các sản phẩm có mã trùng lặp, tránh nhầm lẫn trong quá trình quản lý kho hàng
- Duy trì tính toàn vẹn dữ liệu, hỗ trợ cho các hoạt động tìm kiếm, thống kê và báo cáo
- Giảm thiểu lỗi trong quá trình xử lý đơn hàng, kiểm kê và quản lý tồn kho
- Nâng cao trải nghiệm người dùng bằng cách cung cấp thông báo lỗi rõ ràng khi phát hiện vấn đề 