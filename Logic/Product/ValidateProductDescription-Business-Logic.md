# Xác thực mô tả sản phẩm

## Mô tả
Hàm `ValidateMaxSizeDescription(description)` được sử dụng để kiểm tra và xác thực độ dài của mô tả sản phẩm.

## Tham số
- `description`: Chuỗi mô tả sản phẩm cần xác thực

## Các bước xác thực
1. Kiểm tra nếu mô tả không rỗng
2. Tính toán kích thước của mô tả:
   - Chuyển đổi chuỗi sang byte sử dụng Encoding.Unicode
   - Chia cho 1048576 (1MB) để chuyển đổi từ byte sang MB
3. So sánh với giá trị cấu hình `AppConfigInfo.MaxSizeProductDescription`
4. Nếu vượt quá giới hạn, ném ngoại lệ `KvValidateProductAttributeException`

## Xử lý lỗi
- Nếu kích thước mô tả vượt quá giới hạn cho phép:
  - Ném ngoại lệ `KvValidateProductAttributeException`
  - Thông báo lỗi: "Mô tả hàng hóa không được lớn quá {0} MB"
  - Trong đó {0} là giá trị MaxSizeProductDescription từ cấu hình