# Phân tích Business Logic của phương thức CreateInvoice

## Các bước xử lý chính

### 18.2. Tạo hóa đơn mới

- **Xử lý cho hóa đơn mới**:
  - Điều kiện áp dụng: **invoice.Id <= 0** (hóa đơn chưa có ID, chưa tồn tại trong hệ thống)
  
  - **Kiểm tra và xác thực ban đầu**:
    - Nếu là hóa đơn cập nhật (**invoice.UpdateInvoiceId > 0**):
      - Kiểm tra xem hóa đơn gốc có đang được xử lý bởi tác vụ vận chuyển không
      - Sử dụng `ShippingTaskService.ValidateProcessingInvoice(invoice.UpdateInvoiceId)` tương tự như khi cập nhật hóa đơn hiện có
    - Lưu trữ ID đơn hàng đã hoàn thành (nếu có) để xử lý sau này:
      - Nếu hóa đơn được tạo từ đơn hàng, lưu lại ID đơn hàng để cập nhật trạng thái sau khi tạo hóa đơn thành công

  - **Xử lý hủy vận đơn khi thay đổi phương thức giao hàng**:
    - Điều kiện áp dụng:
      - Đang cập nhật hóa đơn (**invoice.UpdateInvoiceId > 0**)
      - Hóa đơn cũ sử dụng đối tác vận chuyển (**UseDefaultPartner = true**)
      - Hóa đơn cũ đã có mã vận đơn (DeliveryCode không rỗng)
      - Hóa đơn mới chuyển sang tự giao hàng (**UseDefaultPartner = false**)
    
    - Quy trình hủy vận đơn:
      - Nếu KShip đang hoạt động và **AppConfigInfo.OffKship = false** (tính năng vận chuyển được bật):
        - Gửi yêu cầu hủy vận đơn đến đối tác vận chuyển thông qua API
        - Gọi phương thức `DeliveryPartnerService.VoidOrder()` hoặc `VoidOrderAsync()`
        - Cung cấp thông tin cần thiết: mã hóa đơn, lý do hủy, v.v.
        - Xử lý kết quả trả về từ API:
          - Nếu thành công: Tiếp tục quy trình tạo hóa đơn mới
          - Nếu thất bại: Hiển thị thông báo lỗi từ đối tác vận chuyển
      
      - Nếu KShip không hoạt động hoặc **AppConfigInfo.OffKship = true** (tính năng vận chuyển bị tắt):
        - Hiển thị thông báo: "Không kết nối được hệ thống tạo vận đơn. Hãy thử lại sau."
        - Ngăn không cho phép tiếp tục tạo hóa đơn

  - **Tạo và cập nhật hóa đơn**:
    - Gọi phương thức `InvoiceService.MakeInvoiceAsync()` với các tham số phù hợp:
      - `updateOnHand`: Cập nhật số lượng tồn kho (true/false)
      - `isNewInvoice`: Đánh dấu là hóa đơn mới (true)
      - `fromCombine`: Đánh dấu nếu tạo từ việc kết hợp hóa đơn (false, trừ khi được chỉ định)
      - `omniOnlineFieldObject`: Thông tin bổ sung cho kênh bán hàng đa kênh
    
    - **Quá trình tạo hóa đơn sử dụng khóa đồng bộ Redis**:
      - Mục đích: Tránh xử lý đồng thời, ngăn tạo hóa đơn trùng lặp
      
      - Trường hợp sử dụng khóa Redis:
        1. **Hóa đơn cập nhật**:
           - Nếu hóa đơn đang cập nhật (có **UpdateInvoiceId > 0**) và mã bắt đầu bằng **Invoice.UpdatePrefix**
           - Sử dụng khóa Redis với định dạng liên quan đến ID hóa đơn gốc
           - Kiểm tra xem hóa đơn đã được xử lý chưa, nếu đã xử lý thì hiển thị lỗi: "Có thay đổi mới hơn từ server. Bạn cần cập nhật trước khi tạo thay đổi mới"
        
        2. **Hóa đơn sử dụng lô/hạn sử dụng hoặc IMEI**:
           - Sử dụng khóa Redis theo chi nhánh để đảm bảo xử lý tuần tự
           - Điều này đặc biệt quan trọng đối với sản phẩm có lô/hạn sử dụng hoặc IMEI để tránh xung đột về số lượng tồn kho
        
        3. **Hóa đơn được tạo từ đơn hàng hoặc có UUID**:
           - Sử dụng khóa Redis theo OrderId hoặc UUID để tránh tạo trùng lặp
           - Hiển thị thông báo lỗi nếu đang có yêu cầu tạo hóa đơn đang xử lý
      
      - Mỗi loại khóa có thời gian sống (timeout) và cơ chế xử lý riêng khi khóa bị chiếm
    
    - **Thực hiện tạo hóa đơn thông qua DoMakeInvoiceAsync**:
      - Xử lý chi tiết hóa đơn:
        - Xác thực các sản phẩm trong hóa đơn
        - Kiểm tra tồn kho
        - Tính giá và thuế
      
      - Xử lý khuyến mãi:
        - Áp dụng các ưu đãi, khuyến mãi, coupon
        - Tính toán giảm giá
      
      - Xử lý thanh toán:
        - Tạo các bản ghi thanh toán liên quan
        - Ghi nhận các phương thức thanh toán
      
      - Lưu thông tin giao hàng (nếu có):
        - Tạo bản ghi thông tin giao hàng
        - Liên kết với đối tác vận chuyển (nếu có)
      
      - Cập nhật tồn kho:
        - Điều chỉnh số lượng tồn kho theo các mặt hàng trong hóa đơn
        - Cập nhật lịch sử tồn kho
      
      - Khởi tạo mã hóa đơn:
        - Tạo mã hóa đơn theo định dạng cấu hình
        - Đảm bảo tính duy nhất của mã hóa đơn
      
      - Cập nhật trạng thái đơn hàng (nếu có):
        - Nếu hóa đơn được tạo từ đơn hàng, cập nhật trạng thái đơn hàng thành "Đã xử lý"
      
      - Ghi lịch sử:
        - Lưu lại các thông tin về người tạo, thời gian tạo
        - Ghi nhận các thông tin thay đổi

---
**Điều hướng**
- Quay lại: [18-CreateInvoice-SaveOrUpdateInvoice.md](./18-CreateInvoice-SaveOrUpdateInvoice.md)
- Trước đó: [18-1-CreateInvoice-UpdateExistingInvoice.md](./18-1-CreateInvoice-UpdateExistingInvoice.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 