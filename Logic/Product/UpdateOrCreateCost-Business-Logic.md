# Logic Kinh Doanh của Phương Thức UpdateOrCreateCostAsync

## Tổng Quan
Phương thức `UpdateOrCreateCostAsync` được thiết kế để cập nhật hoặc tạo mới thông tin chi phí của sản phẩm trong một chi nhánh cụ thể. Phương thức này đảm bảo rằng dữ liệu chi phí luôn được cập nhật và có theo dõi lịch sử thay đổi.

## Tham Số
- `productId`: ID của sản phẩm cần cập nhật chi phí
- `branchId`: ID của chi nhánh
- `cost`: Giá trị chi phí mới cần cập nhật

## Quy Trình Chi Tiết

1. **Lấy Cấu Hình Tiền Tệ**
   - Hệ thống lấy thông tin cấu hình tiền tệ hiện tại của cửa hàng thông qua `NumberHelper.GetCurrentCurrency()`
   - Cấu hình này xác định cách làm tròn số và hiển thị giá trị tiền tệ

2. **Lấy Thông Tin Nhà Bán Lẻ**
   - Hệ thống lấy ID của nhà bán lẻ từ context hiện tại

3. **Lấy hoặc Tạo Mới Dữ Liệu Sản Phẩm Chi Nhánh**
   - Hệ thống gọi phương thức `GetOrCreateAsync` để lấy bản ghi ProductBranch cho sản phẩm và chi nhánh
   - Nếu bản ghi chưa tồn tại, hệ thống sẽ tạo mới bản ghi này

4. **Kiểm Tra Thay Đổi Chi Phí**
   - Hệ thống so sánh chi phí hiện tại với chi phí mới
   - Chỉ tiếp tục cập nhật nếu sự khác biệt vượt quá 0.001 (để tránh cập nhật không cần thiết)

5. **Cập Nhật Chi Phí**
   - Nếu chi phí có thay đổi đáng kể:
     - Hệ thống làm tròn giá trị chi phí mới theo cấu hình tiền tệ
     - Thực hiện cập nhật trong một giao dịch (transaction) để đảm bảo tính nhất quán dữ liệu

6. **Bắt Đầu Giao Dịch Cơ Sở Dữ Liệu**
   - Hệ thống tạo một giao dịch cơ sở dữ liệu để đảm bảo tất cả các thay đổi đều được thực hiện hoặc không có thay đổi nào được áp dụng

7. **Cập Nhật Dữ Liệu ProductBranch**
   - Hệ thống cập nhật bản ghi ProductBranch với giá trị chi phí mới

8. **Tạo Bản Ghi Điều Chỉnh Chi Phí**
   - Hệ thống tạo một bản ghi CostAdjustment để theo dõi lịch sử thay đổi chi phí, bao gồm:
     - Chi phí mới
     - Người thực hiện điều chỉnh
     - Thời gian điều chỉnh
     - Chi nhánh liên quan
     - Sản phẩm liên quan

9. **Thêm Bản Ghi CostAdjustment vào Cơ Sở Dữ Liệu**
   - Hệ thống lưu bản ghi CostAdjustment vào cơ sở dữ liệu

10. **Tạo Sự Kiện Theo Dõi (Event Tracking)**
    - Hệ thống chuyển đổi bản ghi CostAdjustment thành sự kiện theo dõi
    - Nếu sự kiện hợp lệ, hệ thống thêm sự kiện vào cơ sở dữ liệu
    - Cập nhật thông tin sự kiện vào bản ghi CostAdjustment

11. **Đưa Vào Hàng Đợi Theo Dõi**
    - Hệ thống đưa bản ghi CostAdjustment vào hàng đợi theo dõi để xử lý tiếp

12. **Xác Nhận Giao Dịch**
    - Nếu tất cả các bước trên thành công, hệ thống xác nhận (commit) giao dịch

13. **Xử Lý Lỗi**
    - Nếu có lỗi xảy ra trong quá trình cập nhật:
      - Hệ thống ghi lại lỗi vào log
      - Hủy bỏ (rollback) giao dịch để đảm bảo tính nhất quán dữ liệu

14. **Trả Về Kết Quả**
    - Hệ thống trả về bản ghi ProductBranch đã được cập nhật

## Ý Nghĩa Kinh Doanh
- Đảm bảo thông tin chi phí sản phẩm luôn chính xác và cập nhật
- Theo dõi lịch sử thay đổi chi phí giúp kiểm soát và phân tích biến động chi phí theo thời gian
- Đảm bảo tính nhất quán dữ liệu thông qua cơ chế giao dịch
- Hỗ trợ quy trình định giá và phân tích lợi nhuận
- Cung cấp dữ liệu cho các báo cáo tài chính và phân tích kinh doanh
- Hỗ trợ việc ra quyết định về chiến lược giá và quản lý chi phí 

## Tham Khảo và Liên Kết
### Phương Thức Liên Quan
- [UpdateManufacturedCostByMaterialAsync](./UpdateManufacturedCostByMaterial-Business-Logic.md) - Phương thức gọi UpdateOrCreateCostAsync để cập nhật chi phí sản phẩm sau khi tính toán từ nguyên liệu

### Thành Phần Liên Quan
- **ProductBranch** - Đối tượng lưu trữ thông tin chi phí của sản phẩm tại chi nhánh
- **CostAdjustment** - Đối tượng lưu trữ lịch sử điều chỉnh chi phí
- **EventTracking** - Hệ thống theo dõi sự kiện thay đổi dữ liệu
- **TrackingHelper** - Lớp hỗ trợ xử lý hàng đợi theo dõi

### Quy Trình Nghiệp Vụ Liên Quan
- Quy trình quản lý chi phí sản phẩm
- Quy trình sản xuất và tính giá thành sản phẩm
- Quy trình định giá bán sản phẩm 