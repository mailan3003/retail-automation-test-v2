# Phân tích Business Logic của phương thức MakeInvoiceAsync

## Các bước xử lý chính

### 19.10. Cập nhật đơn hàng và tài liệu

- **Mục đích**: Thực hiện việc cập nhật trạng thái đơn hàng và các tài liệu liên quan sau khi hóa đơn đã được tạo hoặc cập nhật thành công

- **Điều kiện áp dụng**:
  - Áp dụng khi hóa đơn được tạo từ đơn hàng (invoice.OrderId > 0)
  - Áp dụng khi hóa đơn liên kết với tài liệu (DocumentId > 0)

- **Quy trình xử lý chi tiết**:
  1. **Cập nhật đơn hàng**:
     - Kiểm tra xem hóa đơn có liên kết với đơn hàng không:
       ```csharp
       if (result.OrderId > 0)
       {
           result = await UpdateOrderOfInvoice(result, updateOnHand);
       }
       ```
     - Quá trình cập nhật đơn hàng bao gồm:
       + Lấy thông tin đơn hàng từ cơ sở dữ liệu
       + Cập nhật trạng thái đơn hàng (thường thành "Đã hoàn thành" hoặc "Đã xuất hóa đơn")
       + Cập nhật các thông tin khác như ngày hoàn thành, người hoàn thành
       + Đồng bộ thông tin thanh toán giữa đơn hàng và hóa đơn

  2. **Cập nhật đơn hàng hoàn thành**:
     - Xử lý đặc biệt khi đơn hàng đã hoàn thành:
       ```csharp
       if (finishedOrderId > 0)
       {
           var order = await OrderService.GetByIdAsync(finishedOrderId);
           if (order != null && order.Status != (byte)OrderState.Completed)
           {
               order.Status = (byte)OrderState.Completed;
               await OrderService.UpdateAsync(order);
           }
       }
       ```
     - Đảm bảo đơn hàng được đánh dấu là hoàn thành sau khi tạo hóa đơn
     - Duy trì tính nhất quán giữa trạng thái đơn hàng và hóa đơn

  3. **Cập nhật tài liệu**:
     - Kiểm tra xem hóa đơn có liên kết với tài liệu không:
       ```csharp
       if (result.DocumentId > 0)
       {
           result = await UpdateDocumentOfInvoice(result, updateOnHand);
       }
       ```
     - Quá trình cập nhật tài liệu bao gồm:
       + Lấy thông tin tài liệu từ cơ sở dữ liệu
       + Cập nhật trạng thái tài liệu
       + Cập nhật các thông tin liên quan như ngày xử lý, người xử lý
       + Đồng bộ thông tin giữa tài liệu và hóa đơn

  4. **Xử lý lịch sử cập nhật hóa đơn**:
     - Nếu đang cập nhật hóa đơn, cập nhật mã hóa đơn gốc:
       ```csharp
       if (!string.IsNullOrEmpty(result.Code) && result.Code.StartsWith(Invoice.UpdatePrefix))
       {
           result.OriginCode = GetOriginInvoiceUpdateCode(result.Code);
       }
       ```
     - Đảm bảo có thể theo dõi lịch sử cập nhật hóa đơn
     - Duy trì mối liên hệ giữa hóa đơn mới và hóa đơn gốc

  5. **Liên kết tác vụ giao hàng**:
     - Đối với hóa đơn có tác vụ giao hàng, cập nhật thông tin liên kết:
       ```csharp
       if (result.DeliveryDetail != null && !string.IsNullOrEmpty(result.DeliveryDetail.DeliveryCode))
       {
           // Cập nhật thông tin giao hàng
       }
       ```
     - Đảm bảo thông tin giao hàng được liên kết chính xác với hóa đơn
     - Hỗ trợ việc theo dõi trạng thái giao hàng

  6. **Đánh dấu hóa đơn mới nhất**:
     - Cập nhật trạng thái "hóa đơn mới nhất" khi cập nhật hóa đơn:
       ```csharp
       if (result.UpdateInvoiceId > 0)
       {
           var lastInvoice = await GetLastUpdateInvoice(result.OriginCode);
           if (lastInvoice != null && lastInvoice.Id != result.Id)
           {
               lastInvoice.IsLastest = false;
               await UpdateAsyncWithEventTracking(lastInvoice, null);
           }
       }
       ```
     - Đảm bảo chỉ có hóa đơn mới nhất được đánh dấu là "mới nhất"
     - Phục vụ cho việc tìm kiếm và báo cáo hóa đơn

- **Xử lý đặc biệt**:
  - **Xử lý đơn hàng phân phối**:
    - Đối với đơn hàng phân phối (distribution orders), áp dụng quy trình xử lý đặc biệt:
      + Cập nhật các đơn hàng con liên quan
      + Đồng bộ trạng thái giữa đơn hàng phân phối và các đơn hàng con
      + Theo dõi quá trình phân phối hàng hóa

  - **Xử lý đơn hàng đặt trước**:
    - Đối với đơn hàng đặt trước (pre-orders):
      + Cập nhật trạng thái đặc biệt cho đơn hàng đặt trước
      + Theo dõi tiến độ giao hàng của các sản phẩm đặt trước
      + Xử lý các trường hợp đơn hàng đặt trước một phần

  - **Xử lý đơn hàng từ nhiều chi nhánh**:
    - Nếu đơn hàng bao gồm sản phẩm từ nhiều chi nhánh:
      + Cập nhật thông tin kho hàng ở từng chi nhánh
      + Điều phối việc giao hàng từ các chi nhánh khác nhau
      + Theo dõi trạng thái đơn hàng tổng hợp

- **Ý nghĩa nghiệp vụ**:
  - Đảm bảo sự nhất quán giữa đơn hàng, hóa đơn và tài liệu
  - Cung cấp thông tin chính xác về trạng thái của đơn hàng và hóa đơn
  - Tạo điều kiện cho việc theo dõi và báo cáo
  - Hỗ trợ quy trình bán hàng từ đầu đến cuối
  - Duy trì tính toàn vẹn dữ liệu trong hệ thống

- **Lưu ý đặc biệt**:
  - Cần đảm bảo xử lý đồng bộ giữa các đối tượng liên quan
  - Tránh tình trạng không đồng bộ giữa trạng thái đơn hàng và hóa đơn
  - Đảm bảo ghi nhận đầy đủ các thay đổi trong lịch sử
  - Xử lý cẩn thận trường hợp nhiều hóa đơn liên kết với một đơn hàng

---
**Điều hướng**
- [Quay lại trang chủ](./MakeInvoice-Index.md)
- [Bước trước: Xử lý giao hàng](./9-MakeInvoice-DeliveryProcessing.md)
- [Bước tiếp theo: Phân bổ thanh toán](./11-MakeInvoice-PaymentAllocation.md) 