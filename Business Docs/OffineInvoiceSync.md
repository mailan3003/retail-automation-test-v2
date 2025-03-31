### 5.4. Xử lý đồng bộ offline
- Validate đồng bộ hóa đơn offline:
  + Kiểm tra trùng lặp hóa đơn:
    * Tìm kiếm theo Code trong vòng 7 ngày
    * Tìm kiếm theo UUID nếu có
    * Đánh dấu IsDuplicated = true nếu trùng
  + Validate thông tin thanh toán:
    * Kiểm tra tổng tiền thanh toán khớp với hóa đơn
    * Validate phương thức thanh toán hợp lệ
    * Kiểm tra payment code không trùng lặp
  + Xử lý trạng thái:
    * Đồng bộ trạng thái với hóa đơn gốc
    * Giữ nguyên trạng thái nếu là hóa đơn mới
    * Log lịch sử thay đổi trạng thái

- Xử lý tồn kho khi đồng bộ offline:
  + Với sản phẩm thường:
    * Kiểm tra tồn kho tại thời điểm ghi nhận
    * Bỏ qua kiểm tra tồn âm với cấu hình AllowSellWhenOutStock
    * Cập nhật số lượng OnHand sau khi đồng bộ
  + Với sản phẩm theo lô:
    * Validate số lượng tồn của lô tại thời điểm ghi nhận
    * Kiểm tra lô không bị khóa trong kiểm kho
    * Cập nhật BatchExpireTracking với thời gian gốc
  + Với sản phẩm có serial:
    * Validate serial không được sử dụng bởi chứng từ khác
    * Kiểm tra trạng thái serial tại thời điểm ghi nhận
    * Cập nhật ImeiTracking với thời gian gốc

- Đồng bộ công nợ và điểm thưởng:
  + Xử lý công nợ khách hàng:
    * Tính lại số nợ tại thời điểm ghi nhận
    * Đồng bộ PaymentTracking theo thứ tự thời gian
    * Cập nhật CustomerDebt với dữ liệu mới nhất
  + Xử lý điểm thưởng:
    * Tính điểm theo cấu hình tại thời điểm ghi nhận
    * Đồng bộ PointTracking theo thứ tự thời gian
    * Cập nhật số điểm khách hàng với dữ liệu mới nhất

- Xử lý trường hợp đặc biệt:
  + Hóa đơn đã được đồng bộ một phần:
    * Kiểm tra trạng thái đồng bộ cuối 
    * Đồng bộ các thông tin còn thiếu
    * Ghi log tracking cho phần mới
  + Hóa đơn bị conflict:
    * So sánh dữ liệu với phiên bản trên server
    * Ưu tiên dữ liệu mới nhất theo timestamp
    * Ghi log chi tiết conflict
  + Mất kết nối khi đang đồng bộ:
    * Lưu trạng thái đồng bộ dở
    * Thử lại tự động theo cấu hình retry
    * Đánh dấu để đồng bộ lại sau

- Tracking quá trình đồng bộ:
  + Thông tin cơ bản:
    * InvoiceId, InvoiceCode
    * SyncTime: thời điểm đồng bộ
    * Status: trạng thái đồng bộ
    * RetryCount: số lần thử lại
  + Chi tiết lỗi:
    * ErrorCode: mã lỗi
    * ErrorMessage: thông báo lỗi
    * StackTrace: ngăn xếp lỗi
  + Dữ liệu đồng bộ:
    * RequestData: dữ liệu gửi lên
    * ResponseData: dữ liệu nhận về
    * ConflictData: dữ liệu xung đột nếu có