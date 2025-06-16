# Enum WarehouseType

`WarehouseType` là enum định nghĩa các loại kho hàng trong hệ thống:

| Giá trị | Tên | Mô tả |
|---------|-----|-------|
| 0 | Branch | Chi nhánh |
| 1 | DefaultDirectSale | Kho bán trực tiếp mặc định tạo ra từ thông tin chi nhánh |
| 2 | Archive | Kho không bán trực tiếp |
| 3 | DirectSales | Kho bán trực tiếp do người dùng tạo ra |

## Mục đích sử dụng

Enum này được sử dụng để phân loại các loại kho hàng khác nhau trong hệ thống, giúp xác định cách xử lý và quyền truy cập phù hợp cho từng loại kho. Ví dụ, trong quá trình tạo hóa đơn, hệ thống sẽ kiểm tra loại kho để xác định ID kho hàng cần sử dụng:
