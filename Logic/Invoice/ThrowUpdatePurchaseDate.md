# Phương thức ThrowUpdatePurchaseDate

## Mục đích
Phương thức này xử lý việc ném các ngoại lệ khi cập nhật ngày mua hàng không hợp lệ, dựa trên loại thao tác và trạng thái offline. Đây là phương thức hỗ trợ được gọi từ `ValidateUpdateOrDeletePurchaseDate`.

## Quy trình
1. Kiểm tra trạng thái offline trước:
   - Nếu `isOffline = true`, ném ngoại lệ với thông báo "Hóa đơn có thời gian giao dịch quá {0} tháng so với hiện tại." (`KVMessage.invoice_SyncPurchaseDateError`)
2. Nếu không phải offline, kiểm tra loại thao tác (TypeDirection):
   - Nếu `type = TypeDirection.Update`: Ném ngoại lệ với thông báo "Bạn chỉ được cập nhật giao dịch trong vòng {0} tháng." (`KVMessage.updatePurchaseDateError`)
   - Các trường hợp còn lại: Ném ngoại lệ với thông báo "Bạn chỉ được đổi thời gian của giao dịch trong vòng {0} tháng."
3. Tất cả thông báo lỗi đều bao gồm thông tin về giới hạn thời gian cho phép cập nhật (`MaxMonthUpdatePurchaseDateInvoice`) (`KVMessage.addPurchaseDateError`)

## Tham số
- `type` (TypeDirection): Loại thao tác (Thêm, Sửa, Xóa)
- `isOffline` (bool): Xác định nếu thao tác được thực hiện ở chế độ offline (mặc định: false)

## Xử lý ngoại lệ
- Ném ngoại lệ `KvValidateRetailerException` cho tất cả các trường hợp
- Thông báo lỗi được định dạng sử dụng `string.Format` với các message key:
  - `KVMessage.invoice_SyncPurchaseDateError`: Cho trường hợp offline
  - `KVMessage.updatePurchaseDateError`: Cho trường hợp cập nhật
  - `KVMessage.addPurchaseDateError`: Cho các trường hợp còn lại
- Tất cả thông báo đều bao gồm tham số `AppServiceConfigInfo.MaxMonthUpdatePurchaseDateInvoice` để hiển thị số tháng giới hạn

## Mã nguồn