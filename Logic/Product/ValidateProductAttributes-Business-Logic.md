# Xác thực thuộc tính sản phẩm

## Hàm: ValidateProductAttributes(lsAttrIds)

### Mô tả
Kiểm tra xác thực các ID thuộc tính có tồn tại trong hệ thống của retailer hiện tại.

### Tham số
- `lsAttrIds`: Danh sách các ID thuộc tính cần xác thực

### Các bước xác thực
1. Bỏ qua việc xác thực nếu:
   - Danh sách ID thuộc tính rỗng
   - Không có ID hợp lệ (> 0)

2. Xử lý danh sách ID thuộc tính:
   - Loại bỏ các ID trùng lặp bằng cách gọi `Distinct()`
   - Đếm số lượng thuộc tính thực sự tồn tại trong cơ sở dữ liệu của retailer hiện tại
   - So sánh số lượng thuộc tính yêu cầu với số lượng thuộc tính tồn tại

3. Xử lý lỗi:
   - Ném ngoại lệ `KvValidateProductAttributeException` với thông báo lỗi `KVMessage.attributeIsDeleted` ("Thuộc tính đã bị xóa. Vui lòng kiểm tra lại.") nếu có bất kỳ thuộc tính nào không tồn tại

### Tham chiếu
Được trích xuất từ phần "Chức năng xác thực sản phẩm" trong file `Logic/Product/AddNew/2-Chuc-nang-xac-thuc-san-pham.md` 