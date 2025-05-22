# Phân tích Business Logic của phương thức ValidateMedicine

## Mục đích
Phương thức `ValidateMedicine` được sử dụng để xác thực thông tin của sản phẩm thuốc, đảm bảo các thông tin bắt buộc được nhập đầy đủ và tuân thủ các quy định về độ dài của các trường dữ liệu.

## Tham số đầu vào
- `globalMedicine`: Thông tin thuốc toàn cầu
- `productByBranch`: Thông tin sản phẩm theo chi nhánh
- `isRetailerMedicine`: Cờ xác định có phải thuốc bán lẻ không
- `isSyncNationalPharmacy`: Cờ xác định có đồng bộ với hệ thống dược quốc gia không
- `medicineManufacturer`: Thông tin nhà sản xuất thuốc

## Các bước xử lý chính

### 1. Xác thực đường dùng thuốc
- Kiểm tra trường `RouteOfAdministration` không được để trống
- Nếu trống, ném ngoại lệ `KvValidateProductMedicineException` với thông báo "Vui lòng nhập Đường dùng trước khi lưu"

### 2. Xác thực thông tin bắt buộc cho thuốc bán lẻ hoặc thuốc có thay đổi
Điều kiện áp dụng: `isRetailerMedicine = true` hoặc `HasChanged(globalMedicine, productByBranch) = true`

Các trường thông tin bắt buộc cần kiểm tra và thông báo lỗi tương ứng:
1. Số đăng ký (`RegistrationNo`): "Vui lòng nhập Số đăng ký trước khi lưu"
2. Hoạt chất (`ActiveElement`): "Vui lòng nhập Hoạt chất trước khi lưu"
3. Hàm lượng (`Content`): "Vui lòng nhập Hàm lượng trước khi lưu"
4. Quy cách đóng gói (`PackagingSize`): "Vui lòng nhập Quy cách đóng gói trước khi lưu"
5. Đơn vị tính (`Unit`): "Vui lòng nhập Đơn vị cơ bản trước khi lưu"
6. Nhà sản xuất (`ManufacturerId` hoặc `GlobalManufacturerId`): "Vui lòng nhập Hãng sản xuất trước khi lưu"
7. Quốc gia sản xuất (`GlobalManufacturerCountryId`): "Vui lòng nhập Nước sản xuất trước khi lưu"

Nếu bất kỳ trường nào bị thiếu, hệ thống sẽ ném ngoại lệ `KvValidateProductMedicineException` với thông báo tương ứng.

### 3. Xác thực độ dài các trường khi đồng bộ với hệ thống dược quốc gia
Điều kiện áp dụng: `isSyncNationalPharmacy = true`

Các trường cần kiểm tra độ dài và thông báo lỗi tương ứng:
1. Tên thuốc (`Name`): tối đa 100 ký tự - "Tên thuốc không được vượt quá 100 kí tự"
2. Số đăng ký (`RegistrationNo`): tối đa 20 ký tự - "Số đăng ký không được vượt quá 20 kí tự"
3. Hoạt chất (`ActiveElement`): tối đa 200 ký tự - "Hoạt chất không được vượt quá 200 kí tự"
4. Hàm lượng (`Content`): tối đa 200 ký tự - "Hàm lượng không được vượt quá 200 kí tự"
5. Quy cách đóng gói (`PackagingSize`): tối đa 50 ký tự - "Quy cách đóng gói không được vượt quá 50 kí tự"
6. Tên nhà sản xuất (`medicineManufacturer.Name`): tối đa 100 ký tự - "Hãng sản xuất không được vượt quá 100 kí tự"
7. Đơn vị tính (`Unit`): tối đa 100 ký tự - "Đơn vị cơ bản không được vượt quá 100 kí tự"

Nếu bất kỳ trường nào vượt quá độ dài cho phép, hệ thống sẽ ném ngoại lệ `KvValidateProductMedicineException` với thông báo định dạng tương ứng.

## Xử lý ngoại lệ
- Sử dụng `KvValidateProductMedicineException` để báo lỗi
- Các thông báo lỗi được định nghĩa trong các file resource:
  - `KVMessage`: Chứa các thông báo lỗi chung
  - `Labels`: Chứa tên các trường dữ liệu

## Lưu ý
- Phương thức này là một phần quan trọng trong quy trình xác thực sản phẩm thuốc
- Đảm bảo tuân thủ các quy định về thông tin thuốc khi đồng bộ với hệ thống dược quốc gia
- Các thông tin bắt buộc phải được nhập đầy đủ cho thuốc bán lẻ hoặc thuốc có thay đổi 