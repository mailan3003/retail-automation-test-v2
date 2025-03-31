# Logic nghiệp vụ tạo hóa đơn (CreateInvoice)

1. Kiểm tra và xác thực đầu vào
   1.1. Kiểm tra dữ liệu đầu vào cơ bản
   - Validate mã hóa đơn bắt đầu bằng các prefix hợp lệ (HDO, LZD, FB,...)
   - Validate ID cập nhật hóa đơn (UpdateInvoiceId) 
   - Kiểm tra ID đơn hàng (OrderId)
   - Validate quyền thao tác với chi nhánh
   - Kiểm tra thông tin sổ giá (PriceBookId)

   1.2. Kiểm tra thông tin khách hàng
   - Validate ID khách hàng
   - Kiểm tra quản lý khách hàng theo chi nhánh
   - Kiểm tra thanh toán bằng điểm

   1.3. Kiểm tra giao hàng COD
   - Validate thông tin đơn vị vận chuyển 
   - Kiểm tra địa chỉ giao hàng
   - Validate dịch vụ vận chuyển

   1.4. Kiểm tra điểm thưởng và khuyến mãi
   - Validate việc dùng voucher cùng khuyến mãi
   - Kiểm tra điều kiện tích điểm thưởng
   - Tính toán điểm thưởng theo hóa đơn/sản phẩm
   
   1.5. Kiểm tra tồn kho
   - Validate số lượng tồn kho nếu không cho phép bán âm
   - Kiểm tra sản phẩm combo
   - Validate tồn kho theo đơn hàng

   1.6. Kiểm tra serial/imei
   - Validate trạng thái serial/imei
   - Kiểm tra trùng serial/imei

   1.7. Kiểm tra thanh toán
   - Validate giá trị thanh toán
   - Kiểm tra phân bổ thanh toán tự động
   - Validate thanh toán bằng voucher/điểm

   1.8. Xác thực lô/hạn sử dụng
   - Kiểm tra tồn kho theo lô
   - Validate ngày hết hạn
   - Kiểm tra trạng thái lô

2. Xử lý dữ liệu đầu vào
   2.1. Xử lý mã hóa đơn
   - Tạo mã hóa đơn mới theo prefix
   - Xử lý mã hóa đơn trùng
   
   2.2. Xử lý thông tin giao hàng
   - Chuyển đổi thông tin địa chỉ
   - Xử lý thông tin đơn vị vận chuyển mặc định

   2.3. Xử lý giảm giá
   - Tính phân bổ giảm giá hóa đơn
   - Xử lý giảm giá theo chương trình khuyến mãi

3. Tính toán giá trị
   3.1. Tính tổng tiền hàng
   - Tính giá trị từng sản phẩm
   - Tính phụ phí
   - Tính thuế

   3.2. Tính điểm thưởng
   - Tính điểm theo cấu hình (hóa đơn/sản phẩm)
   - Tính điểm khuyến mãi
   
   3.3. Tính giá trị thanh toán
   - Tính tổng thanh toán
   - Xử lý tiền thừa
   - Tính công nợ

4. Cập nhật dữ liệu
   4.1. Cập nhật tồn kho
   - Cập nhật số lượng tồn
   - Cập nhật serial/imei
   - Cập nhật lô/hạn sử dụng

   4.2. Cập nhật công nợ và điểm thưởng
   - Cập nhật công nợ khách hàng
   - Cập nhật lịch sử điểm thưởng
   - Cập nhật trạng thái voucher

   4.3. Cập nhật vận chuyển
   - Cập nhật thông tin giao hàng
   - Cập nhật trạng thái vận chuyển

   4.4. Cập nhật thanh toán
   - Lưu thông tin thanh toán
   - Cập nhật phân bổ thanh toán
   - Cập nhật thu chi

5. Xử lý khuyến mãi
   5.1. Áp dụng khuyến mãi
   - Kiểm tra điều kiện khuyến mãi
   - Tính giá trị khuyến mãi
   
   5.2. Xử lý quà tặng
   - Tạo sản phẩm quà tặng
   - Tạo voucher tặng

6. Xử lý thu chi
   6.1. Tạo phiếu thu
   - Tạo phiếu thu tiền mặt
   - Tạo phiếu thu chuyển khoản
   
   6.2. Xử lý hoàn tiền
   - Tính tiền thừa trả lại
   - Tạo phiếu chi hoàn tiền

7. Xử lý đặt cọc
   7.1. Kiểm tra đặt cọc
   - Validate số tiền đặt cọc
   - Kiểm tra thanh toán đặt cọc

   7.2. Xử lý hoàn cọc
   - Tính tiền hoàn cọc
   - Tạo phiếu chi hoàn cọc

8. Xử lý đơn hàng
   8.1. Cập nhật đơn hàng
   - Cập nhật trạng thái đơn hàng
   - Cập nhật số lượng đã xuất
   
   8.2. Xử lý hàng đặt
   - Cập nhật số lượng đặt hàng
   - Tính số lượng còn lại

9. Xử lý ngoại lệ
   9.1. Rollback dữ liệu
   - Rollback tồn kho
   - Rollback thanh toán
   - Rollback công nợ

   9.2. Log lỗi
   - Log chi tiết lỗi
   - Thông báo lỗi

10. Xử lý kết thúc
    10.1. Tính toán lại
    - Tính lại tổng tiền
    - Tính lại công nợ
    
    10.2. Cập nhật cache
    - Clear cache hóa đơn
    - Clear cache tồn kho
