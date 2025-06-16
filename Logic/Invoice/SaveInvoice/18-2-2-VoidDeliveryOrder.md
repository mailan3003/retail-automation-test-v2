# Phân tích Business Logic của phương thức CreateInvoice

## Các bước xử lý chính

### 18.2.2. Xử lý hủy vận đơn khi thay đổi phương thức giao hàng

- **Mục đích**: Xử lý việc hủy vận đơn khi người dùng thay đổi từ phương thức giao hàng qua đối tác vận chuyển sang tự giao hàng

- **Điều kiện áp dụng**:
  - Đang cập nhật hóa đơn qua hóa đơn mới (**invoice.UpdateInvoiceId > 0**)
  - Hóa đơn cũ sử dụng đối tác vận chuyển (**UseDefaultPartner = true**)
  - Hóa đơn cũ đã có mã vận đơn (DeliveryCode không rỗng)
  - Hóa đơn mới chuyển sang tự giao hàng (**UseDefaultPartner = false**)

- **Quy trình xử lý chi tiết**:
  1. **Kiểm tra điều kiện hủy vận đơn**:
     - Xác định hóa đơn cũ thông qua ID cập nhật (UpdateInvoiceId)
     - Kiểm tra xem hóa đơn cũ có sử dụng đối tác vận chuyển không (UseDefaultPartner)
     - Kiểm tra xem hóa đơn cũ đã có mã vận đơn chưa (DeliveryCode)
     - Kiểm tra xem hóa đơn mới có chuyển sang tự giao hàng không

  2. **Xử lý hủy vận đơn qua KShip**:
     - Kiểm tra trạng thái hoạt động của KShip thông qua cấu hình **AppConfigInfo.OffKship**:
       
       + Nếu KShip đang hoạt động (**AppConfigInfo.OffKship = false**):
         * Chuẩn bị dữ liệu cần thiết cho yêu cầu hủy vận đơn:
           - Mã hóa đơn
           - Lý do hủy (thường là "Thay đổi thông tin")
           - Thông tin xác thực API
         * Gọi phương thức **DeliveryPartnerService.VoidOrderV3()** để gửi yêu cầu hủy vận đơn
         * Xử lý kết quả trả về từ API:
           - Nếu thành công (isSuccess = true):
             + Tiếp tục quy trình tạo hóa đơn mới
             + Đánh dấu vận đơn cũ là đã hủy trong hệ thống
           - Nếu thất bại (isSuccess = false):
             + Hiển thị thông báo lỗi từ đối tác vận chuyển
             + Ngăn không cho phép tiếp tục tạo hóa đơn mới
       
       + Nếu KShip không hoạt động hoặc bị tắt (**AppConfigInfo.OffKship = true**):
         * Hiển thị thông báo: "Không kết nối được hệ thống tạo vận đơn. Hãy thử lại sau."
         * Ngăn không cho phép tiếp tục tạo hóa đơn mới

  3. **Cập nhật trạng thái vận đơn trong hệ thống**:
     - Cập nhật trạng thái của vận đơn cũ thành "Đã hủy" (Void)
     - Cập nhật các thông tin liên quan:
       + Đặt DeliveryBy = null
       + Đặt UseDefaultPartner = false
       + Cập nhật lý do hủy và thời gian hủy

  4. **Ghi log và thông báo**:
     - Ghi log về việc hủy vận đơn trong hệ thống
     - Thông báo cho người dùng về kết quả của việc hủy vận đơn

- **Quy trình xử lý sau khi hủy vận đơn**:
  - Nếu hủy vận đơn thành công:
    + Tiếp tục quy trình tạo hóa đơn mới với phương thức tự giao hàng
    + Không sao chép thông tin vận đơn từ hóa đơn cũ sang hóa đơn mới
  - Nếu hủy vận đơn thất bại:
    + Hiển thị thông báo lỗi cho người dùng
    + Không cho phép tiếp tục tạo hóa đơn mới
    + Yêu cầu người dùng kiểm tra lại thông tin hoặc liên hệ bộ phận hỗ trợ

- **Ý nghĩa nghiệp vụ**:
  - Đảm bảo tính nhất quán giữa hệ thống nội bộ và hệ thống đối tác vận chuyển
  - Tránh tình trạng "ghost order" (đơn ma) tại đối tác vận chuyển khi người dùng đã chuyển sang tự giao hàng
  - Duy trì tính minh bạch trong việc theo dõi hóa đơn và vận đơn
  - Cho phép người dùng linh hoạt thay đổi phương thức giao hàng nếu vận đơn chưa được xử lý bởi đối tác vận chuyển

---
**Điều hướng**
- Quay lại: [18-2-CreateInvoice-CreateNewInvoice.md](./18-2-CreateInvoice-CreateNewInvoice.md)
- Trước đó: [18-2-1-CheckFailedTask.md](./18-2-1-CheckFailedTask.md)
- Tiếp theo: [18-2-3-CreateAndUpdateInvoice.md](./18-2-3-CreateAndUpdateInvoice.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 