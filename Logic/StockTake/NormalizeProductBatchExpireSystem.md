# Chuẩn hóa dữ liệu lô hàng trong NormalizeProductBatchExpireSystem

## Mục đích
Phương thức `NormalizeProductBatchExpireSystem` trong lớp `StockTakeService` có nhiệm vụ truy vấn thông tin về lô và hạn sử dụng của sản phẩm từ cơ sở dữ liệu, sau đó chuẩn hóa và gán thông tin này vào các chi tiết phiếu kiểm kho. Phương thức này đặc biệt quan trọng cho các sản phẩm được quản lý theo lô và hạn sử dụng, giúp hiển thị chính xác số lượng tồn kho theo từng lô cho người dùng khi thực hiện kiểm kho.

## Quy trình chính

### 1. Lọc danh sách sản phẩm cần xử lý
- Hệ thống sẽ tìm kiếm trong danh sách sản phẩm để xác định những sản phẩm nào cần được quản lý theo lô và hạn sử dụng. Đây là những sản phẩm có đánh dấu đặc biệt (IsBatchExpireControl = true).
- Đối với mỗi sản phẩm, hệ thống sẽ lấy mã sản phẩm chính (MasterUnitId) nếu có, nếu không có thì sẽ lấy mã sản phẩm thông thường (ProductId).

### 2. Truy vấn thông tin lô/hạn sử dụng
- Hệ thống sẽ tìm kiếm thông tin chi tiết về các lô hàng và số lượng tồn kho của chúng tại chi nhánh hiện tại. Thông tin này bao gồm:
  + Mã lô hàng (Id)
  + Mã sản phẩm (ProductId)
  + Số lượng tồn kho (OnHand)
  + Số lượng theo hệ thống (SystemCount)
  + Trạng thái lô hàng (Status)
  + Tên lô hàng (BatchName)
  + Ngày hết hạn (ExpireDate)
  + Tên đầy đủ của lô hàng (FullNameVirgule)
- Tất cả thông tin này được lấy từ hai bảng dữ liệu chính: bảng thông tin lô hàng và bảng thông tin tồn kho theo chi nhánh.

### 3. Cập nhật thông tin vào chi tiết phiếu kiểm kho

Khi hệ thống tìm thấy thông tin về các lô hàng, nó sẽ thực hiện các bước sau để cập nhật thông tin vào phiếu kiểm kho:

1. **Xác định sản phẩm cần xử lý**:
   - Hệ thống sẽ tìm tất cả các sản phẩm được đánh dấu là cần quản lý theo lô và hạn sử dụng
   - Mỗi sản phẩm sẽ được xử lý lần lượt

2. **Tìm thông tin lô hàng**:
   - Với mỗi sản phẩm, hệ thống sẽ tìm tất cả các lô hàng liên quan
   - Nếu không tìm thấy lô hàng nào, hệ thống sẽ bỏ qua sản phẩm đó
   - Nếu tìm thấy, hệ thống sẽ lưu danh sách lô hàng vào phiếu kiểm kho

3. **Xử lý đơn vị tính**:
   - Nếu sản phẩm có đơn vị phụ (ví dụ: hộp, thùng), hệ thống sẽ thực hiện quy đổi số lượng
   - Hệ thống sẽ lấy hệ số quy đổi (ví dụ: 1 thùng = 12 hộp)
   - Số lượng tồn kho sẽ được quy đổi và làm tròn theo quy định

4. **Lưu thông tin**:
   - Cuối cùng, hệ thống sẽ lưu toàn bộ thông tin lô hàng vào phiếu kiểm kho
   - Thông tin được lưu dưới dạng có thể đọc được để người dùng dễ dàng kiểm tra

Quá trình này giúp đảm bảo rằng khi người dùng thực hiện kiểm kho, họ có thể thấy được chính xác số lượng tồn kho theo từng lô hàng, giúp việc kiểm tra được chính xác và hiệu quả hơn.

## Phụ thuộc

### Dịch vụ và lớp tiện ích
- **ProductBatchExpireService**: Cung cấp truy cập đến thông tin định nghĩa lô/hạn sử dụng.
- **ProductBatchExpireBranchService**: Cung cấp truy cập đến thông tin số lượng tồn kho theo lô tại chi nhánh.
- **NumberHelper**: Cung cấp thông tin về định dạng số tiền tệ hiện tại.

### Đối tượng dữ liệu
- **StockTakeDetailBatchExpiresInfo**: Đối tượng chứa thông tin kết hợp về lô và số lượng tồn kho.
- **StockTakeDetail**: Đối tượng chi tiết phiếu kiểm kho, chứa thông tin về sản phẩm.

## Các quy tắc nghiệp vụ

1. **Quy tắc về phạm vi áp dụng**:
   - Chỉ áp dụng cho sản phẩm có cờ `IsBatchExpireControl = true`.
   - Không xử lý các sản phẩm không quản lý lô/hạn sử dụng.

2. **Quy tắc về đơn vị master**:
   - Truy vấn thông tin dựa trên ID đơn vị master nếu sản phẩm có MasterUnitId.
   - Điều này đảm bảo lấy đúng thông tin lô cho cả sản phẩm chính và sản phẩm có đơn vị phụ.

3. **Quy tắc về số lượng tồn kho**:
   - Số lượng tồn kho được lưu trong trường OnHand.
   - Với sản phẩm đơn vị phụ, số lượng tồn được quy đổi theo hệ số chuyển đổi và làm tròn theo số thập phân của đơn vị tiền tệ.

4. **Quy tắc về cấu trúc dữ liệu kết quả**:
   - Kết quả được lưu trữ trong hai trường:
     - `ProductBatchExpireSystemList`: Danh sách đối tượng StockTakeDetailBatchExpiresInfo
     - `ProductBatchExpireSystem`: Chuỗi JSON của danh sách trên

## Lưu ý quan trọng
1. Phương thức này là bước quan trọng trong việc chuẩn bị dữ liệu cho người dùng khi thực hiện kiểm kho.
2. Thông tin lô/hạn sử dụng hiện có trong hệ thống sẽ được hiển thị cho người dùng để so sánh với thực tế.
3. Việc quy đổi số lượng cho đơn vị phụ là rất quan trọng để hiển thị chính xác số lượng tồn kho.
4. Số lượng được làm tròn theo số thập phân của đơn vị tiền tệ hiện tại.

## Cấu trúc dữ liệu StockTakeDetailBatchExpiresInfo
- **Id**: ID của bản ghi lô/hạn sử dụng.
- **ProductId**: ID của sản phẩm.
- **OnHand**: Số lượng tồn kho theo lô.
- **SystemCount**: Số lượng tồn kho theo lô (sau khi quy đổi nếu là đơn vị phụ).
- **Status**: Trạng thái của lô hàng.
- **BatchName**: Tên lô hàng.
- **ExpireDate**: Ngày hết hạn.
- **FullNameVirgule**: Tên đầy đủ của lô/hạn sử dụng.