# Business Logic của phương thức NormalizeName

## Tổng quan
Phương thức `NormalizeName(req)` thực hiện chuẩn hóa tên và các thuộc tính văn bản của sản phẩm trong quá trình thêm nhiều sản phẩm (AddMany). Phương thức này đảm bảo tính nhất quán và chuẩn hóa dữ liệu trước khi lưu vào cơ sở dữ liệu.

## Chi tiết triển khai

### Input
- Parameter `req` kiểu `ProductAddMany` chứa danh sách các sản phẩm cần chuẩn hóa (`ListProducts`)

### Quy trình xử lý
Đối với mỗi sản phẩm trong danh sách, phương thức thực hiện:

1. **Chuẩn hóa mã sản phẩm (Code)**:
   - Nếu mã không rỗng, áp dụng hàm `Normalize()` để chuẩn hóa Unicode
   - Áp dụng hàm `StringHelper.ReplaceHexadecimalSymbols()` để loại bỏ hoặc thay thế các ký tự hex không hợp lệ

2. **Chuẩn hóa tên sản phẩm (Name)**:
   - Áp dụng hàm `Normalize()` để chuẩn hóa Unicode và loại bỏ các dấu không phù hợp
   - Đảm bảo định dạng nhất quán cho tên sản phẩm

3. **Chuẩn hóa tên đầy đủ (FullName)**:
   - Áp dụng hàm `Normalize()` tương tự như với trường Name

4. **Chuẩn hóa tên ngắn (ShortName)**:
   - Áp dụng hàm `Normalize()` tương tự như với trường Name

5. **Xử lý mô tả sản phẩm (Description)**:
   - Áp dụng hàm `ConvertDescriptionHtml()` với tham số `true` để chuẩn hóa nội dung HTML
   - Loại bỏ các mã độc và đảm bảo định dạng HTML an toàn

### Xử lý ngoại lệ
- Mọi ngoại lệ phát sinh trong quá trình chuẩn hóa đều được ghi log
- Quá trình chuẩn hóa tiếp tục với sản phẩm tiếp theo ngay cả khi có lỗi xảy ra với sản phẩm hiện tại
- Không ném ngoại lệ ra bên ngoài phương thức, đảm bảo quá trình tạo sản phẩm vẫn tiếp tục

### Output
- Không có giá trị trả về trực tiếp (void)
- Dữ liệu sản phẩm trong `req.ListProducts` được cập nhật trực tiếp

## Mã nguồn tham chiếu
```csharp
private void NormalizeName(ProductAddMany req)
{
    req.ListProducts = req.ListProducts.Select(x =>
    {
        try
        {
            x.Code = string.IsNullOrEmpty(x.Code) ? x.Code : StringHelper.ReplaceHexadecimalSymbols(x.Code.Normalize());
            x.Name = string.IsNullOrEmpty(x.Name) ? x.Name : x.Name.Normalize();
            x.FullName = string.IsNullOrEmpty(x.FullName) ? x.FullName : x.FullName.Normalize();
            x.ShortName = string.IsNullOrEmpty(x.ShortName) ? x.ShortName : x.ShortName.Normalize();
            x.Description = ConvertDescriptionHtml(x.Description, true);
        }
        catch (Exception ex)
        {
            Log.Error(ex.Message, ex);
        }
        return x;
    }).ToList();
}
```

## Lưu ý quan trọng
1. Phương thức được gọi sớm trong quy trình xử lý dữ liệu đầu vào để đảm bảo các bước xử lý tiếp theo nhận được dữ liệu đã chuẩn hóa
2. Việc chuẩn hóa giúp tránh các vấn đề về:
   - Lỗi encoding khi lưu vào database
   - Không nhất quán trong hiển thị và tìm kiếm
   - Lỗi XSS và lỗi bảo mật khác trong phần mô tả HTML
3. Phương thức này là một phần của chuỗi xử lý dữ liệu đầu vào, đóng vai trò quan trọng trong việc đảm bảo chất lượng dữ liệu 