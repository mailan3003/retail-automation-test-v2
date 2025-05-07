# Phân tích Business Logic của phương thức MakeInvoiceAsync

## Các bước xử lý chính

### 19.9. Xử lý giao hàng

- **Mục đích**: Thực hiện quá trình xử lý thông tin giao hàng cho hóa đơn sau khi đã tạo hoặc cập nhật hóa đơn và thanh toán

- **Điều kiện áp dụng**:
  - Áp dụng cho hóa đơn có thông tin giao hàng (delivery information)
  - Hỗ trợ cả trường hợp giao hàng của đối tác vận chuyển và tự giao hàng
  - Đặc biệt quan trọng cho các hóa đơn bán hàng online

- **Quy trình xử lý chi tiết**:
  1. **Kiểm tra thông tin giao hàng**:
     - Xác định hóa đơn có yêu cầu giao hàng không:
       ```csharp
       if (result.DeliveryDetail != null && result.DeliveryDetail.Id > 0 && (result.Status == (byte)InvoiceState.Issued || result.Status == (byte)InvoiceState.Completed))
       {
           // Xử lý thông tin giao hàng
       }
       ```
     - Chỉ áp dụng cho hóa đơn có trạng thái là "Đã phát hành" (Issued) hoặc "Hoàn thành" (Completed)

  2. **Xử lý thông tin giao hàng qua đối tác vận chuyển**:
     - Kiểm tra nếu hóa đơn sử dụng đối tác vận chuyển:
       ```csharp
       if (result.UseDefaultPartner)
       {
           // Thực hiện quá trình tạo vận đơn với đối tác giao hàng
       }
       ```
     - Quá trình xử lý bao gồm:
       + Tạo gói hàng vận chuyển (DeliveryPackage)
       + Đăng ký thông tin giao hàng với đối tác vận chuyển
       + Lấy mã vận đơn từ đối tác vận chuyển
       + Cập nhật thông tin vận đơn vào hóa đơn

  3. **Xử lý giao hàng tự vận chuyển**:
     - Áp dụng khi hóa đơn không sử dụng đối tác vận chuyển:
       ```csharp
       else
       {
           // Tạo thông tin giao hàng cho tự vận chuyển
           await DeliveryInfoService.AddAsync(deliveryInfo);
       }
       ```
     - Tạo và lưu trữ thông tin giao hàng cơ bản (không có mã vận đơn đối tác)
     - Cập nhật thông tin địa chỉ giao hàng

  4. **Xử lý hóa đơn từ nhiều gói hàng**:
     - Trường hợp đặc biệt khi một hóa đơn có nhiều gói hàng:
       ```csharp
       if (result.DeliveryDetail.ListDeliveryPackage?.Count > 0)
       {
           // Xử lý nhiều gói hàng
       }
       ```
     - Lưu trữ thông tin cho từng gói hàng
     - Liên kết các gói hàng với hóa đơn
     - Theo dõi trạng thái giao hàng cho từng gói

  5. **Cập nhật thông tin thanh toán giao hàng**:
     - Xử lý thanh toán cho chi phí giao hàng:
       ```csharp
       if (result.DeliveryDetail?.DeliveryPayment != null && result.DeliveryDetail.DeliveryPayment.Id <= 0)
       {
           // Thêm thanh toán cho phí giao hàng
           await DeliveryPaymentService.AddAsync(result.DeliveryDetail.DeliveryPayment);
       }
       ```
     - Lưu trữ thông tin chi phí giao hàng
     - Cập nhật tổng tiền hóa đơn bao gồm phí giao hàng

  6. **Đăng ký thông tin giao hàng**:
     - Thêm thông tin giao hàng vào hàng đợi xử lý:
       ```csharp
       DeliveryInfoEnqueue(result, bltHelper);
       ```
     - Đăng ký tác vụ giao hàng để hệ thống xử lý sau
     - Theo dõi trạng thái giao hàng qua các bước khác nhau

  7. **Kết nối với hệ thống đối tác vận chuyển**:
     - Gửi thông tin đơn hàng tới API của đối tác vận chuyển:
       ```csharp
       var deliveryCode = await DeliveryClient.CreateDeliveryOrder(deliveryPackage);
       ```
     - Nhận và lưu trữ mã vận đơn từ đối tác
     - Cập nhật trạng thái giao hàng ban đầu

- **Xử lý đặc biệt**:
  - **Xử lý hóa đơn COD (Cash On Delivery)**:
    ```csharp
    if (result.DeliveryDetail.COD)
    {
        // Xử lý đặc biệt cho hóa đơn thu tiền hộ
    }
    ```
    - Tính toán số tiền cần thu hộ
    - Đăng ký dịch vụ thu hộ với đối tác vận chuyển
    - Theo dõi trạng thái thanh toán COD

  - **Xử lý thay đổi phương thức giao hàng**:
    - Khi cập nhật hóa đơn có thay đổi phương thức giao hàng (từ đối tác sang tự giao hoặc ngược lại):
      + Hủy vận đơn cũ với đối tác vận chuyển (nếu có)
      + Tạo thông tin giao hàng mới phù hợp với phương thức mới
      + Cập nhật lại chi phí giao hàng

  - **Xử lý thông tin địa chỉ giao hàng**:
    - Chuẩn hóa thông tin địa chỉ giao hàng:
      + Kiểm tra tính hợp lệ của địa chỉ
      + Phân tích thông tin địa lý (tỉnh/thành, quận/huyện, phường/xã)
      + Lưu trữ thông tin người nhận hàng

- **Ý nghĩa nghiệp vụ**:
  - Đảm bảo thông tin giao hàng được xử lý chính xác
  - Kết nối hiệu quả với các đối tác vận chuyển
  - Theo dõi quá trình giao hàng từ đầu đến cuối
  - Cung cấp trải nghiệm mua sắm trọn vẹn cho khách hàng
  - Hỗ trợ nhiều phương thức giao hàng khác nhau

- **Lưu ý đặc biệt**:
  - Xử lý giao hàng cần đồng bộ với các hệ thống bên ngoài (đối tác vận chuyển)
  - Cần xử lý các trường hợp lỗi kết nối với đối tác vận chuyển
  - Đảm bảo thông tin địa chỉ giao hàng chính xác và đầy đủ
  - Xử lý đặc biệt đối với hàng hóa có yêu cầu vận chuyển đặc thù (hàng dễ vỡ, hàng có kích thước lớn...)

---
**Điều hướng**
- [Quay lại trang chủ](./MakeInvoice-Index.md)
- [Bước trước: Tạo hóa đơn và xử lý thanh toán](./8-MakeInvoice-InvoicePayment.md)
- [Bước tiếp theo: Cập nhật đơn hàng và tài liệu](./10-MakeInvoice-OrderDocumentUpdate.md) 