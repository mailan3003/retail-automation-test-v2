# Phân tích Business Logic của phương thức MakeInvoiceAsync

## Các bước xử lý chính

### 1. Chuẩn bị dữ liệu và chuẩn hóa

- **Mục đích**: Chuẩn bị và chuẩn hóa dữ liệu đầu vào cho quá trình tạo hóa đơn

- **Quy trình xử lý chi tiết**:
  1. **Kiểm tra và chuẩn hóa dữ liệu đầu vào**:
     ```csharp
     if (invoice == null)
         throw new KvValidateInvoiceException(KVMessage.request_DataNull);
     ```
     - Kiểm tra đối tượng hóa đơn không được null
     - Ném ngoại lệ nếu dữ liệu không hợp lệ

  2. **Xác định loại hóa đơn**:
     ```csharp
     var isOfflineInv = !string.IsNullOrEmpty(invoice.Code) && 
                        invoice.Code.StartsWith(Invoice.OffCodePrefix) || 
                        invoice.DocumentId > 0;
     ```
     - Hóa đơn được xem là offline nếu:
       + Mã hóa đơn bắt đầu bằng tiền tố offline (`OFF_`), hoặc
       + Có ID tài liệu (`DocumentId > 0`)

  3. **Xác định trạng thái cập nhật**:
     ```csharp
     var isUpdateInvoice = invoice.UpdateInvoiceId > 0;
     ```
     - Hóa đơn được xem là đang cập nhật nếu có ID hóa đơn cần cập nhật

  4. **Lấy thông tin hóa đơn cũ (nếu đang cập nhật)**:
     ```csharp
     Invoice oldInvoice = null;
     if (isUpdateInvoice)
     {
         oldInvoice = await _getByIdAsync(invoice.UpdateInvoiceId);
         if (oldInvoice == null)
             throw new KvValidateInvoiceException(string.Format(KVMessage.InvoiceNotFound, invoice.UpdateInvoiceId));
     }
     ```
     - Nếu đang cập nhật hóa đơn:
       + Truy vấn thông tin hóa đơn cũ từ database
       + Kiểm tra tồn tại của hóa đơn cũ
       + Ném ngoại lệ nếu không tìm thấy hóa đơn cũ

## Các trường hợp đặc biệt

1. **Dữ liệu đầu vào không hợp lệ**:
   - Ném ngoại lệ `KvValidateInvoiceException` với thông báo "Request không có dữ liệu"

2. **Hóa đơn offline**:
   - Được xác định qua mã hóa đơn hoặc ID tài liệu
   - Có các xử lý đặc biệt trong các bước tiếp theo

3. **Cập nhật hóa đơn**:
   - Cần kiểm tra tồn tại của hóa đơn cũ
   - Ném ngoại lệ nếu không tìm thấy hóa đơn cần cập nhật

## Ý nghĩa nghiệp vụ

- Đảm bảo dữ liệu đầu vào hợp lệ trước khi xử lý
- Phân loại hóa đơn để có luồng xử lý phù hợp
- Chuẩn bị dữ liệu cần thiết cho các bước xử lý tiếp theo

## Lưu ý quan trọng

- Đây là bước đầu tiên và quan trọng trong quy trình tạo hóa đơn
- Cần xử lý cẩn thận các trường hợp đặc biệt
- Thông báo lỗi cần rõ ràng để người dùng biết cách xử lý

---
**Điều hướng**
- [Quay lại trang chủ](./MakeInvoice-Index.md)
- [Bước tiếp theo: Xử lý hóa đơn offline](./2-MakeInvoice-OfflineInvoice.md)