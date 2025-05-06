# Phân tích Business Logic của phương thức UpdateInvoiceAsync

## 18.1.3.1. Kiểm tra tính hợp lệ của hóa đơn

### Mục đích
Kiểm tra và xác thực tính hợp lệ của hóa đơn trước khi thực hiện cập nhật, đảm bảo dữ liệu được cập nhật là chính xác và đầy đủ.

### Quy trình xử lý

#### 1. Kiểm tra sự tồn tại của hóa đơn
- **Điều kiện kiểm tra**:
  - Hóa đơn không được null
  - Hóa đơn phải tồn tại trong hệ thống

- **Xử lý**:
  ```csharp
  if (invoice == null)
      throw new KvValidateInvoiceException(KVMessage.NotFound);
  ```
  - Nếu hóa đơn không tồn tại, ném ngoại lệ với thông báo "Dữ liệu này không còn tồn tại trên hệ thống. Vui lòng kiểm tra lại"

#### 2. Kiểm tra tiền tệ hiện tại
- **Mục đích**: Đảm bảo tính nhất quán về đơn vị tiền tệ trong hóa đơn
- **Xử lý**:
  - Lấy thông tin tiền tệ từ `NumberHelper.GetCurrentCurrency()`
  - Kiểm tra tính hợp lệ của đơn vị tiền tệ
  - Đảm bảo các giá trị tiền tệ trong hóa đơn sử dụng đúng đơn vị

#### 3. Kiểm tra tính hợp lệ của hóa đơn COD
- **Điều kiện kiểm tra**:
  - Hóa đơn có sử dụng COD (UsingCod = 1)
  - Có thông tin giao hàng (DeliveryDetail không null)
  - Chưa chọn đối tác giao hàng (DeliveryBy = null)
  - Hóa đơn đang ở một trong các trạng thái vận chuyển:
    + Đang giao (Delivering)
    + Đã giao (Delivered)
    + Đang trả (Returning)
    + Đã trả (Returned)

- **Xử lý**:
  - Nếu tất cả điều kiện được thỏa mãn, hiển thị thông báo lỗi "Chưa nhập đối tác giao hàng"
  - Đảm bảo hóa đơn COD trong quá trình vận chuyển phải có thông tin đối tác giao hàng

#### 4. Kiểm tra nguồn gốc hóa đơn
- **Mục đích**: Xác định và xử lý đặc biệt cho các loại hóa đơn khác nhau
- **Xử lý**:
  - Xác định hóa đơn có phải từ OmniChannel không thông qua `PosOnlineHelper.IsInvoiceOmni()`
  - Kiểm tra mã hóa đơn có bắt đầu bằng các tiền tố của các sàn thương mại điện tử:
    + DHSPE: Shopee
    + DHTTS: Tiki
    + DHLZD: Lazada
    + v.v.

#### 5. Lấy và so sánh thông tin hóa đơn hiện tại
- **Mục đích**: Đảm bảo tính nhất quán của dữ liệu khi cập nhật
- **Xử lý**:
  - Truy vấn thông tin hóa đơn hiện tại từ cơ sở dữ liệu
  - So sánh để xác định các thay đổi về:
    + Tổng tiền
    + Trạng thái
    + Thông tin thanh toán
    + Thông tin giao hàng
    + Các thông tin khác

## Điều hướng
- Quay lại: [18-1-3-UpdateInvoice.md](../SaveInvoice/18-1-3-UpdateInvoice.md)
- Tiếp theo: [2-NormalizeInvoiceDetail.md](./2-NormalizeInvoiceDetail.md) 