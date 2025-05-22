# Phương thức ValidateProductNotExistInDb

## Mục đích
Phương thức này kiểm tra sự tồn tại của các sản phẩm trong chi tiết phiếu kiểm kho so với dữ liệu truy vấn từ cơ sở dữ liệu. Mục đích của phương thức là đảm bảo tất cả sản phẩm cần kiểm kê phải tồn tại trong hệ thống và phát hiện bất kỳ sự không khớp nào giữa danh sách chi tiết và dữ liệu thực tế.

## Quy trình
1. Nhận danh sách chi tiết phiếu kiểm kho (`itemDetails`) và danh sách thông tin sản phẩm từ cơ sở dữ liệu (`lstProductFromDb`)
2. So sánh số lượng sản phẩm giữa hai danh sách
3. Nếu số lượng không khớp (số sản phẩm trong chi tiết khác với số sản phẩm tìm thấy), ném ngoại lệ `KvValidateProductException` với thông báo lỗi định dạng "Phiếu kiểm kho không đúng do số lượng sản phẩm không hợp lệ: Số lượng trong hệ thống {0}, số lượng kiểm {1}" trong đó {0} là số lượng sản phẩm từ cơ sở dữ liệu (lstProductFromDb.Count) và {1} là số lượng sản phẩm trong chi tiết phiếu kiểm kho (itemDetails.Count)

## Tham số
- `itemDetails` (List<StockTakeDetail>): Danh sách chi tiết phiếu kiểm kho
- `lstProductFromDb` (List<ProductStockStakeInfo>): Danh sách thông tin sản phẩm được truy vấn từ cơ sở dữ liệu

## Xử lý ngoại lệ
- Ném ngoại lệ `KvValidateProductException` với thông báo lỗi về số lượng sản phẩm không khớp nếu có sự khác biệt giữa số lượng sản phẩm trong chi tiết và số lượng sản phẩm tìm thấy trong cơ sở dữ liệu

## Dữ liệu kiểm thử

### Tình huống 1: Tất cả sản phẩm đều tồn tại
- itemDetails: 3 sản phẩm (ID: 1, 2, 3)
- lstProductFromDb: 3 sản phẩm (ID: 1, 2, 3)
- Kết quả: Phương thức kết thúc bình thường, không có ngoại lệ

### Tình huống 2: Thiếu sản phẩm trong cơ sở dữ liệu
- itemDetails: 4 sản phẩm (ID: 1, 2, 3, 4)
- lstProductFromDb: 3 sản phẩm (ID: 1, 2, 3)
- Kết quả: Ném ngoại lệ KvValidateProductException với thông báo về số lượng không khớp (4 và 3)

### Tình huống 3: Cơ sở dữ liệu có nhiều sản phẩm hơn
- itemDetails: 2 sản phẩm (ID: 1, 2)
- lstProductFromDb: 3 sản phẩm (ID: 1, 2, 3)
- Kết quả: Ném ngoại lệ KvValidateProductException với thông báo về số lượng không khớp (2 và 3) 