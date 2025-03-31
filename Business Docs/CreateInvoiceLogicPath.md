# Các Luồng Xử Lý Trong Phương Thức CreateInvoice

## 1. Xác Thực Đầu Vào và Tiền Xử Lý
- Kiểm tra nếu hóa đơn là `null` → ném ngoại lệ `KvValidateInvoiceException` nếu đúng.
- Xử lý chuyển đổi VAT sản phẩm → xóa `TotalTax` nếu không sử dụng VAT sản phẩm.
- Xử lý ngày (`PurchaseDateUtc`, `ExpectedDeliveryUtc`).
- Kiểm tra quyền sửa đổi người bán → khôi phục `SoldById` gốc nếu không có quyền.
- Kiểm tra trùng lặp UUID hóa đơn trong Redis cache.
  - Nếu trùng, ném ngoại lệ `KvValidateInvoiceException`.
  - Nếu không, lưu UUID vào cache.

## 2. Xác Định Loại Hóa Đơn
- Xác định nếu tạo mới hóa đơn (`invoice.Id <= 0`).
- Xác định nếu cập nhật hóa đơn hiện có (`invoice.UpdateInvoiceId > 0`).
- Xử lý điều chỉnh `PurchaseDate`.
- Lọc ra các khoản thanh toán có cờ `IsUpdate`.
- Xác thực thông tin giao hàng của hóa đơn cũ.

## 3. Xử Lý Thông Tin Giao Hàng
- Xác thực thông tin giao hàng khi cập nhật hóa đơn.
- Kiểm tra UUID bằng `CheckUuidAsync`.
- Xác thực việc sử dụng COD (`UsingCod == 1`).
- Kiểm tra công ty vận chuyển có đang hoạt động không.
- Kiểm tra đơn vị vận chuyển có thuộc phạm vi của nhà bán lẻ không.
- Kiểm tra COD bởi nhà vận chuyển KV có được bật không.
- Kiểm tra `ServiceAdd` hợp lệ.
- Sửa các lỗi không khớp trạng thái giao hàng.
- Cập nhật thông tin vị trí và phường nếu cần.

## 4. Xác Thực Khách Hàng và Kênh Bán Hàng
- Xác thực ID khách hàng (`CustomerId`) → ném ngoại lệ nếu không hợp lệ.
- Xác thực kênh bán hàng (`SaleChannelId`).
  - Kiểm tra kênh có tồn tại không.
  - Kiểm tra kênh có thuộc nhà bán lẻ và đang hoạt động không.
- Xác thực ngày giao hàng dự kiến → phải sau ngày mua hàng.
- Kiểm tra khuyến mãi giới hạn theo khách hàng.

## 5. Xác Thực Đơn Thuốc (Dành Cho Nhà Thuốc)
- Kiểm tra nếu là nhà thuốc GPP và có sử dụng đơn thuốc (`UsingPrescription == 1`).
- Xác thực thông tin đơn thuốc hoặc thông tin bệnh nhân.
- Đối với đơn thuốc toàn cầu (`UsingGlobalPrescription == 1`):
  - Kiểm tra sản phẩm có mô tả không.
  - Xác thực hạn sử dụng thuốc.
  - Xác thực độ dài và tính duy nhất của mã đơn thuốc.

## 6. Xác Thực Người Dùng
- Kiểm tra người bán có tồn tại không.

## 7. Xử Lý Đơn Hàng
- Kiểm tra hóa đơn có được tạo từ đơn hàng không.
- Xác thực trạng thái đơn hàng.
- Xử lý chi tiết hóa đơn cho đơn hàng.

## 8. Xử Lý Chi Tiết Hóa Đơn
- Cập nhật chi tiết hóa đơn với sản phẩm tương ứng.
- Tính tổng tiền và thuế.
- Xử lý chiết khấu khuyến mãi.
- Xử lý chuyển đổi đơn vị.
- Chuẩn hóa chi tiết hóa đơn.

## 9. Xác Thực Lô Hàng/Hạn Sử Dụng
- Xác thực lô hàng/hạn sử dụng nếu có sử dụng kiểm tra hạn.
- Kiểm tra tồn kho của lô hàng.
- Kiểm tra ngày hết hạn của lô hàng.
- Xử lý điều chỉnh tồn kho lô hàng.

## 10. Lưu Hóa Đơn và Dữ Liệu Liên Quan
- Tạo mã hóa đơn với giao dịch.
- Tạo hóa đơn trong cơ sở dữ liệu (Thêm mới hoặc Cập nhật).
- Thêm chi tiết hóa đơn và dữ liệu liên quan.
- Tạo bản ghi thanh toán.
- Tạo chi tiết dòng tiền cho đa tiền tệ.
- Xử lý điểm thưởng dựa trên cài đặt.
- Xử lý thông tin bảo hành.
- Xử lý thông tin giao hàng.

## 11. Xử Lý Sau Khi Tạo
- Gửi thông báo (tin nhắn ZNS).
- Tạo nhật ký kiểm toán.
- Cập nhật tồn kho.
- Xử lý thông tin nợ của khách hàng.
- Xử lý voucher và coupon.

## 12. Các Luồng Xử Lý Lỗi
- Kiểm tra trùng lặp hóa đơn.
- Xác thực quyền.
- Xác thực sản phẩm/lô hàng.
- Xác thực khách hàng.
- Xác thực giao hàng.
- Xác thực đơn thuốc/thuốc.
- Cô lập giao dịch và khóa dữ liệu.
