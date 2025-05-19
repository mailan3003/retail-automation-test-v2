# Logic Kinh Doanh của Phương Thức UpdateManufacturedCostByMaterialAsync

## Tổng Quan
Phương thức `UpdateManufacturedCostByMaterialAsync` được thiết kế để cập nhật chi phí sản xuất của sản phẩm khi giá nguyên liệu thay đổi. Phương thức này đảm bảo rằng chi phí của sản phẩm cuối cùng luôn phản ánh chính xác tổng chi phí của các nguyên liệu thành phần.

## Tham Số
- `materialId`: ID của nguyên liệu cần cập nhật giá

## Quy Trình Chi Tiết

1. **Lấy Cấu Hình Tiền Tệ**
   - Hệ thống lấy thông tin cấu hình tiền tệ hiện tại của cửa hàng thông qua `NumberHelper.GetCurrentCurrency()`
   - Cấu hình này bao gồm số chữ số thập phân cho sản phẩm và tổng giá trị

2. **Tìm Sản Phẩm Chứa Nguyên Liệu**
   - Hệ thống truy vấn danh sách các sản phẩm (công thức sản xuất) có sử dụng nguyên liệu được chỉ định thông qua `ProductFormulaService.GetByMaterialIdAsync(materialId)`
   - Nếu không tìm thấy sản phẩm nào, quy trình dừng lại

3. **Xử Lý Từng Sản Phẩm**
   - Với mỗi sản phẩm tìm được, hệ thống thực hiện:
     
4. **Lấy Toàn Bộ Nguyên Liệu của Sản Phẩm**
   - Hệ thống truy vấn tất cả nguyên liệu cần thiết để tạo ra sản phẩm qua `ProductFormulaService.GetByProductIdAsync(item.ProductId)`
   - Lấy danh sách ID của tất cả nguyên liệu

5. **Tính Toán Chi Phí Mới**
   - Khởi tạo biến `newCost` để tích lũy tổng chi phí
   - Lấy thông tin chi phí của tất cả nguyên liệu từ cơ sở dữ liệu:
     - Chỉ lấy dữ liệu của nhà bán lẻ và chi nhánh hiện tại
     - Chỉ lấy những nguyên liệu có trong công thức sản phẩm
   - Với mỗi nguyên liệu:
     - Lấy chi phí đơn vị của nguyên liệu và làm tròn theo cấu hình tiền tệ
     - Lấy số lượng nguyên liệu cần thiết từ công thức
     - Tính chi phí = đơn giá nguyên liệu * số lượng cần dùng
     - Làm tròn kết quả theo cấu hình tiền tệ
     - Cộng vào tổng chi phí

6. **Cập Nhật Chi Phí Sản Phẩm**
   - Sau khi tính toán xong tổng chi phí mới, hệ thống cập nhật chi phí cho sản phẩm thông qua `UpdateOrCreateCostAsync()` (xem chi tiết tại [UpdateOrCreateCost-Business-Logic.md](./UpdateOrCreateCost-Business-Logic.md))
   - Nếu sản phẩm đã có thông tin chi phí trong chi nhánh hiện tại, hệ thống cập nhật giá trị mới
   - Nếu chưa có, hệ thống tạo mới bản ghi chi phí cho sản phẩm

## Ý Nghĩa Kinh Doanh
- Đảm bảo chi phí sản phẩm được tính toán chính xác dựa trên giá hiện tại của các nguyên liệu đầu vào
- Tự động cập nhật chi phí khi giá nguyên liệu thay đổi, giúp doanh nghiệp có thông tin đúng để định giá sản phẩm
- Hỗ trợ quá trình ra quyết định về giá bán, chiến lược sản phẩm và phân tích lợi nhuận
- Đảm bảo tính nhất quán của dữ liệu chi phí trên toàn hệ thống 