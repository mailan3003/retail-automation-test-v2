# Tổng quan xử lý vòng lặp cha-con trong quy trình thêm sản phẩm

## Giới thiệu
Quá trình xử lý vòng lặp cha-con là một phần quan trọng trong quy trình thêm nhiều sản phẩm cùng lúc. Vòng lặp này xử lý từng sản phẩm cha và các sản phẩm con liên quan, đảm bảo mối quan hệ phân cấp giữa chúng được thiết lập chính xác và các thông tin liên quan được lưu trữ đúng cách.

## Luồng xử lý tổng thể

1. **Khởi tạo và chuẩn bị dữ liệu**
   - Danh sách sản phẩm cha (`lsParentProduct`) được xác định trước khi vào vòng lặp
   - Các danh sách lưu trữ kết quả được khởi tạo: danh sách thuế, sản phẩm trả về, sản phẩm kiểm kê, thuộc tính, v.v.

2. **Vòng lặp chính qua các sản phẩm cha**
   - Với mỗi sản phẩm cha (`foreach (var objReturn in lsParentProduct)`)
   - Quy trình xử lý được chia thành các bước nhỏ và được mô tả chi tiết trong các tài liệu con

3. **Các tài liệu con mô tả chi tiết các bước xử lý**
   - [3-1-Xu-ly-thong-tin-thue-san-pham.md](./3-1-Xu-ly-thong-tin-thue-san-pham.md): Xử lý thông tin thuế của sản phẩm
   - [3-2-Xu-ly-anh-xa-ma-san-pham.md](./3-2-Xu-ly-anh-xa-ma-san-pham.md): Ánh xạ mã sản phẩm và xác định chi nhánh
   - [3-3-Xu-ly-du-lieu-bang-lien-quan.md](./3-3-Xu-ly-du-lieu-bang-lien-quan.md): Chèn dữ liệu vào các bảng liên quan
   - [3-4-Xu-ly-san-pham-con.md](./3-4-Xu-ly-san-pham-con.md): Xử lý các sản phẩm con liên quan

## Các đối tượng dữ liệu chính

1. **lsParentProduct**: Danh sách sản phẩm cha cần xử lý
2. **listObjReturn**: Danh sách kết quả trả về sau khi xử lý
3. **lsCostTracking**: Danh sách theo dõi thay đổi giá vốn
4. **lsProductAddStockTake**: Danh sách sản phẩm cần kiểm kê kho
5. **lsPriceBookDetail**: Danh sách chi tiết bảng giá
6. **lsProductAttributes**: Từ điển thuộc tính sản phẩm
7. **lsProductShelves**: Danh sách kệ hàng sản phẩm
8. **lsProductManufacture, lsProductManufactureCombo**: Danh sách sản phẩm sản xuất
9. **lsChildProduct**: Danh sách ID sản phẩm con
10. **lsChangeProductBranchUnit**: Danh sách thay đổi đơn vị sản phẩm chi nhánh
11. **listEventSyncProductSearch**: Danh sách sự kiện đồng bộ tìm kiếm sản phẩm

## Quy trình xử lý áp dụng các nguyên tắc

1. **Áp dụng giao dịch cơ sở dữ liệu**
   - Sử dụng transaction để đảm bảo tính toàn vẹn dữ liệu
   - Rollback khi có lỗi để tránh dữ liệu không nhất quán

2. **Tối ưu hiệu suất**
   - Sử dụng `BulkInsertAsync` để thêm hàng loạt dữ liệu
   - Tối ưu các truy vấn LINQ

3. **Xử lý phân cấp**
   - Thiết lập mối quan hệ giữa sản phẩm cha và con
   - Kế thừa thuộc tính từ sản phẩm cha cho sản phẩm con

4. **Xử lý đặc thù ngành**
   - Phân biệt xử lý cho sản phẩm thuốc
   - Tuân thủ quy định ngành dược

5. **Theo dõi thay đổi**
   - Tạo các sự kiện đồng bộ khi có thay đổi
   - Đảm bảo dữ liệu được cập nhật trong hệ thống tìm kiếm

## Kết quả xử lý

Sau khi vòng lặp xử lý hoàn tất, các danh sách kết quả chứa thông tin sản phẩm được tạo và các dữ liệu liên quan. Các thông tin này sẽ được sử dụng trong các bước tiếp theo của quy trình thêm sản phẩm, bao gồm:

1. Xử lý các bảng dữ liệu bổ sung
2. Cập nhật cân bằng giá vốn
3. Đồng bộ dữ liệu với hệ thống tìm kiếm
4. Trả về kết quả cho người dùng

## Điều hướng tài liệu
- Trước đó: [2-Chuc-nang-xac-thuc-san-pham.md](./2-Chuc-nang-xac-thuc-san-pham.md)
- Tiếp theo: [4-Chuc-nang-xu-ly-sau-luu-san-pham.md](./4-Chuc-nang-xu-ly-sau-luu-san-pham.md)
- Tổng quan: [0-Tong-quan-Product-AddMany.md](./0-Tong-quan-Product-AddMany.md) 