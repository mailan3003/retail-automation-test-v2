# Tổng quan toàn diện về quy trình xử lý sản phẩm

## Giới thiệu
Tài liệu này cung cấp cái nhìn tổng thể về quy trình xử lý sản phẩm trong hệ thống, tập trung vào vòng lặp xử lý cha-con. Các tài liệu được tổ chức thành một chuỗi mô-đun có liên kết chặt chẽ với nhau, mỗi mô-đun tập trung vào một khía cạnh cụ thể của quy trình.

## Kiến trúc tổng thể
Quy trình xử lý sản phẩm được chia thành các bước chính:

```
┌─────────────────┐
│ Xác thực thuộc  │
│ tính sản phẩm   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Xác thực và tạo │
│ mã sản phẩm     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Xác thực tính   │
│ duy nhất của mã │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Xác thực thông  │
│ tin đặc thù     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Xử lý vòng lặp  │
│ cha-con         │──┐
└────────┬────────┘  │
         │           │
         ▼           ▼
┌─────────────────┐ ┌─────────────────┐
│ Xử lý sau lưu   │ │ Xử lý thuế      │
│ sản phẩm        │ └────────┬────────┘
└─────────────────┘          │
                             ▼
                   ┌─────────────────┐
                   │ Ánh xạ mã       │
                   │ sản phẩm        │
                   └────────┬────────┘
                            │
                            ▼
                   ┌─────────────────┐
                   │ Xử lý bảng      │
                   │ liên quan       │
                   └────────┬────────┘
                            │
                            ▼
                   ┌─────────────────┐
                   │ Xử lý sản phẩm  │
                   │ con             │
                   └────────┬────────┘
                            │
                            ▼
                   ┌─────────────────┐
                   │ Đồng bộ tìm kiếm│
                   └────────┬────────┘
                            │
                            ▼
                   ┌─────────────────┐
                   │ Xử lý dược phẩm │
                   └─────────────────┘
```

## Mô tả chi tiết các mô-đun

### 1. Xác thực thuộc tính sản phẩm (2-Chuc-nang-xac-thuc-san-pham.md)
- **Mục đích**: Xác thực các thuộc tính sản phẩm trước khi tiến hành thêm mới
- **Các bước chính**:
  - Kiểm tra tồn tại của thuộc tính
  - Xác thực và tạo mã sản phẩm
  - Kiểm tra tính duy nhất của mã
  - Xác thực thông tin đặc thù ngành (như dược phẩm)
- **Đầu ra**: Sản phẩm cha đầu tiên (firstParent) có thuộc tính đã được xác thực

### 2. Vòng lặp xử lý cha-con (3-Tong-quan-xu-ly-vong-lap-cha-con.md)
- **Mục đích**: Xử lý từng sản phẩm cha và các sản phẩm con liên quan
- **Các đối tượng dữ liệu chính**:
  - lsParentProduct: Danh sách sản phẩm cha
  - listObjReturn: Danh sách kết quả trả về
  - Các danh sách chuyên biệt khác: lsCostTracking, lsProductAddStockTake, lsPriceBookDetail...
- **Nguyên tắc xử lý**:
  - Áp dụng giao dịch cơ sở dữ liệu
  - Tối ưu hiệu suất
  - Xử lý phân cấp
  - Xử lý đặc thù ngành
  - Theo dõi thay đổi

### 3. Xử lý thông tin thuế sản phẩm (3-1-Xu-ly-thong-tin-thue-san-pham.md)
- **Mục đích**: Kiểm tra và xử lý thông tin thuế liên quan đến sản phẩm
- **Các bước chính**:
  - Kiểm tra cấu hình sử dụng thuế VAT
  - Lấy thông tin thuế
  - Lưu thông tin thuế vào danh sách
- **Ý nghĩa nghiệp vụ**: Thông tin thuế quan trọng cho việc tính giá bán, lợi nhuận và tuân thủ quy định

### 4. Ánh xạ mã sản phẩm (3-2-Xu-ly-anh-xa-ma-san-pham.md)
- **Mục đích**: Thực hiện ánh xạ giữa mã sản phẩm tùy chỉnh và mã thực tế
- **Các bước chính**:
  - Lấy thông tin ánh xạ mã sản phẩm
  - Xác định sản phẩm yêu cầu
  - Xác định chi nhánh xử lý
- **Ý nghĩa nghiệp vụ**: Duy trì tính nhất quán giữa dữ liệu đầu vào và dữ liệu lưu trữ

### 5. Xử lý dữ liệu bảng liên quan (3-3-Xu-ly-du-lieu-bang-lien-quan.md)
- **Mục đích**: Xử lý dữ liệu từ các bảng liên quan đến sản phẩm
- **Các bước chính**:
  - Chèn dữ liệu vào các bảng liên quan
  - Xử lý theo dõi giá vốn
  - Xử lý thông tin kiểm kê
  - Xử lý thông tin bảng giá, thuộc tính, kệ hàng, sản xuất
- **Ý nghĩa nghiệp vụ**: Quản lý tồn kho, giá vốn, bảng giá, và các thuộc tính sản phẩm

### 6. Xử lý sản phẩm con (3-4-Xu-ly-san-pham-con.md)
- **Mục đích**: Xử lý các sản phẩm con liên quan đến sản phẩm cha
- **Các bước chính**:
  - Xác định danh sách sản phẩm con
  - Xác thực mã sản phẩm con
  - Cập nhật thông tin sản phẩm con
  - Lưu sản phẩm con vào cơ sở dữ liệu
  - Xử lý thông tin dược phẩm cho sản phẩm con
- **Ý nghĩa nghiệp vụ**: Quản lý sản phẩm theo cấu trúc cha-con, quản lý đơn vị đo lường

### 7. Đồng bộ tìm kiếm sản phẩm (3-5-Xu-ly-dong-bo-tim-kiem.md)
- **Mục đích**: Đảm bảo dữ liệu sản phẩm được cập nhật trong hệ thống tìm kiếm
- **Các bước chính**:
  - Kiểm tra tính năng đồng bộ
  - Khởi tạo danh sách sự kiện
  - Thêm dữ liệu hàng loạt
  - Tạo sự kiện đồng bộ tìm kiếm
  - Lưu sự kiện đồng bộ
- **Ý nghĩa nghiệp vụ**: Cải thiện trải nghiệm người dùng khi tìm kiếm sản phẩm mới thêm

### 8. Xử lý dược phẩm (3-6-Xu-ly-duoc-pham.md)
- **Mục đích**: Xử lý thông tin đặc thù cho sản phẩm dược phẩm
- **Các bước chính**:
  - Kiểm tra điều kiện cửa hàng thuốc
  - Thu thập ID sản phẩm
  - Xử lý thuốc từ danh mục quốc gia
  - Xử lý hàng hóa thông thường
- **Ý nghĩa nghiệp vụ**: Hỗ trợ tuân thủ quy định về Thực hành tốt nhà thuốc (GPP)

## Luồng dữ liệu và Mối quan hệ

1. **Dữ liệu đầu vào**:
   - Danh sách sản phẩm từ người dùng
   - Cấu hình hệ thống (cấu hình thuế, chi nhánh, kho hàng)
   - Danh mục thuốc quốc gia (nếu có)

2. **Xử lý cốt lõi**:
   - Xác thực dữ liệu đầu vào
   - Tạo mã sản phẩm tự động khi cần
   - Thiết lập mối quan hệ cha-con
   - Xử lý dữ liệu liên quan (thuế, giá vốn, kiểm kê)
   - Lưu trữ thông tin vào cơ sở dữ liệu

3. **Dữ liệu đầu ra**:
   - Danh sách sản phẩm đã được tạo (listObjReturn)
   - Thông tin theo dõi giá vốn
   - Thông tin kiểm kê kho
   - Sự kiện đồng bộ tìm kiếm

## Các điểm kỹ thuật nổi bật

1. **Sử dụng giao dịch cơ sở dữ liệu**:
   ```csharp
   using (var dbContextTransaction = Db.Database.BeginTransaction())
   {
       try
       {
           // Xử lý dữ liệu
           dbContextTransaction.Commit();
       }
       catch (Exception)
       {
           dbContextTransaction.Rollback();
           throw;
       }
   }
   ```

2. **Thêm dữ liệu hàng loạt**:
   ```csharp
   await Db.BulkInsertAsync(childProducts);
   ```

3. **Xử lý đồng bộ tìm kiếm**:
   ```csharp
   var eventTrack = SyncEsEventHelper.Instance.CreateEvent(product, SyncProductSearchEventAction.AddOrUpdate);
   ```

4. **Xử lý phân cấp cha-con**:
   ```csharp
   childProducts.ForEach(o =>
   {
       o.MasterCode = firstParent.MasterCode;
       o.MasterUnitId = objReturn.Id;
       o.MasterProductId = firstParent.Id;
       // ...
   });
   ```

## Tổng kết
Quy trình xử lý sản phẩm là một quá trình phức tạp với nhiều bước xử lý và kiểm tra. Việc chia nhỏ quy trình thành các mô-đun giúp dễ dàng hiểu và bảo trì hệ thống. Các nguyên tắc chính được áp dụng xuyên suốt quy trình là:

1. Đảm bảo tính toàn vẹn dữ liệu
2. Tối ưu hiệu suất
3. Xử lý đặc thù ngành
4. Hỗ trợ cấu trúc cha-con cho sản phẩm
5. Đồng bộ dữ liệu với hệ thống tìm kiếm

Với kiến trúc này, hệ thống có thể xử lý hiệu quả việc thêm nhiều sản phẩm cùng lúc, đồng thời đảm bảo mối quan hệ chính xác giữa các sản phẩm và các thông tin liên quan.

## Điều hướng tài liệu
- [2-Chuc-nang-xac-thuc-san-pham.md](./2-Chuc-nang-xac-thuc-san-pham.md)
- [3-Tong-quan-xu-ly-vong-lap-cha-con.md](./3-Tong-quan-xu-ly-vong-lap-cha-con.md)
- [3-1-Xu-ly-thong-tin-thue-san-pham.md](./3-1-Xu-ly-thong-tin-thue-san-pham.md)
- [3-2-Xu-ly-anh-xa-ma-san-pham.md](./3-2-Xu-ly-anh-xa-ma-san-pham.md)
- [3-3-Xu-ly-du-lieu-bang-lien-quan.md](./3-3-Xu-ly-du-lieu-bang-lien-quan.md)
- [3-4-Xu-ly-san-pham-con.md](./3-4-Xu-ly-san-pham-con.md)
- [3-5-Xu-ly-dong-bo-tim-kiem.md](./3-5-Xu-ly-dong-bo-tim-kiem.md)
- [3-6-Xu-ly-duoc-pham.md](./3-6-Xu-ly-duoc-pham.md) 