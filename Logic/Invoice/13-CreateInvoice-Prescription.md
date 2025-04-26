# Phân tích Business Logic của phương thức CreateInvoice

### 12. Xử lý thông tin đơn thuốc (cho nhà thuốc GPP)
- **Điều kiện áp dụng**:
  - Hệ thống sẽ bỏ qua kiểm tra khi `isValid = true` (đã xác thực ở nơi khác)
  - Chỉ áp dụng khi cửa hàng thuộc ngành dược (`AuthService.Context.IsActiveGppDrugStore`), hóa đơn có sử dụng đơn thuốc (`invoice.UsingPrescription == 1`)

- **Quy trình xử lý đơn thuốc**:
  1. **Kiểm tra thông tin đơn thuốc và bệnh nhân**:
     - Hệ thống kiểm tra tính đầy đủ của thông tin đơn thuốc và bệnh nhân:
       - Đơn thuốc được xem là thiếu thông tin khi:
         - `invoice.Prescription` là null, hoặc
         - Tất cả các trường sau đều trống/null: `Code`, `DoctorId`, `ClinicId`, `Description`
       - Bệnh nhân được xem là thiếu thông tin khi:
         - `invoice.Patient` là null, hoặc
         - Tất cả các trường sau đều trống/null: `Name`, `Age`, `Gender`, `Weight`, `IdentityCard`, `HealthInsuranceCard`, `Address`, `Guardian`, `PhoneNumber`
     - Điều kiện lỗi: Nếu CẢ đơn thuốc VÀ bệnh nhân đều thiếu thông tin
     - Kết quả: Hệ thống sẽ ném ngoại lệ `KvValidateClinicException` với thông báo `KVMessage.prescription_Empty` ("Bạn chưa nhập thông tin đơn thuốc")
     - Test case:
       - TC1: Đơn thuốc null, bệnh nhân null → Lỗi
       - TC2: Đơn thuốc có thông tin, bệnh nhân null → Không lỗi
       - TC3: Đơn thuốc null, bệnh nhân có thông tin → Không lỗi
       - TC4: Đơn thuốc không có thông tin, bệnh nhân không có thông tin → Lỗi
       - TC5: Đơn thuốc có thông tin, bệnh nhân có thông tin → Không lỗi

  2. **Kiểm tra thông tin thuốc trong đơn**:
     - **Kiểm tra mô tả cách dùng thuốc**:
       - Áp dụng khi: Hóa đơn sử dụng đơn thuốc toàn cục (`invoice.UsingGlobalPrescription == 1`) và có chi tiết hóa đơn (`invoice.InvoiceDetails != null && invoice.InvoiceDetails.Any()`)
       - Quy tắc kiểm tra:
         - Với mỗi thuốc trong `invoice.Medicines`, hệ thống tìm sản phẩm tương ứng trong `invoice.InvoiceDetails` dựa trên `ProductId`
         - Sản phẩm được xem là thiếu mô tả khi: `IsMaster == true` và `Note` trống hoặc null
       - Kết quả: Nếu phát hiện sản phẩm thiếu mô tả, hệ thống sẽ ném ngoại lệ `KVMedicineException` với thông báo "Hàng hóa thiếu ghi chú" (`KVMessage.invoice_ProductNoDescription`)
       - Test case:
         - TC1: `UsingGlobalPrescription == 1`, sản phẩm có `Note` → Không lỗi
         - TC2: `UsingGlobalPrescription == 1`, sản phẩm không có `Note` → Lỗi
         - TC3: `UsingGlobalPrescription == 0`, sản phẩm không có `Note` → Không lỗi
     
     - **Kiểm tra tình trạng thuốc hết hạn**:
       - Quy tắc xác định thuốc đang bán:
         - Hệ thống lọc ra các thuốc không phải thuốc mới hoặc có thuốc thay thế
         - Công thức: `listSellMedicine = invoice.Medicines` loại trừ các thuốc có mã trùng với `invoice.NewMedicines` hoặc có `ReplaceMedicine != null`
       - Quy tắc kiểm tra hết hạn:
         - Với mỗi thuốc trong danh sách đang bán, kiểm tra thuộc tính `IsExpired`
         - Nếu `IsExpired == true`, thêm mã thuốc vào danh sách thuốc hết hạn
       - Kết quả: 
         - Nếu có ít nhất một thuốc hết hạn, hệ thống sẽ ném ngoại lệ `KVMedicineException`
         - Thông báo lỗi: Nếu chỉ có 1 thuốc hết hạn, hiển thị mã thuốc đó; nếu có nhiều thuốc, hiển thị danh sách mã thuốc ngăn cách bởi dấu phẩy
         - Nội dung thông báo: "[danh sách mã] đã bán hết số lượng trong đơn, vui lòng xóa sản phẩm để tạo đơn." (`KVMessage.Medicine_ProductCodeSoldOut`)
       - Test case:
         - TC1: Không có thuốc hết hạn (`IsExpired == false` hoặc null) → Không lỗi
         - TC2: Một thuốc có `IsExpired == true` → Lỗi, hiển thị mã thuốc đó
         - TC3: Nhiều thuốc có `IsExpired == true` → Lỗi, hiển thị danh sách mã thuốc

  3. **Kiểm tra mã đơn thuốc**:
     - **Điều kiện kiểm tra**:
       - Áp dụng khi đơn thuốc có thông tin (`invoice.Prescription != null`)
     
     - **Quy tắc kiểm tra**:
       - **Trường hợp 1**: Đơn thuốc có mã (`invoice.Prescription.Code` không rỗng)
         - Kiểm tra độ dài mã không vượt quá 50 ký tự
         - Kiểm tra mã đơn thuốc không trùng với mã đơn thuốc đã tồn tại trong hệ thống
         - Kết quả: Nếu trùng và không phải đơn thuốc toàn cục (`invoice.UsingGlobalPrescription != 1`), hệ thống sẽ ném ngoại lệ với thông báo: "Mã đơn thuốc {mã} đã tồn tại trong hệ thống" (`KVMessage.prescription_CodeAlreadyExist`)
       
       - **Trường hợp 2**: Đơn thuốc không có mã nhưng có ID > 0
         - Kết quả: Hệ thống sẽ ném ngoại lệ với thông báo: "Mã đơn thuốc không hợp lệ" (`KVMessage.prescription_CodeIsNotValid`)
     
     - **Test case**:
       - TC1: Đơn thuốc không có mã (`Code` rỗng hoặc null), ID = 0 → Không lỗi
       - TC2: Đơn thuốc không có mã (`Code` rỗng hoặc null), ID > 0 → Lỗi "Mã đơn thuốc không hợp lệ"
       - TC3: Đơn thuốc có mã, độ dài > 50 ký tự → Lỗi (kiểm tra độ dài)
       - TC4: Đơn thuốc có mã, mã không trùng trong hệ thống → Không lỗi
       - TC5: Đơn thuốc có mã, mã trùng trong hệ thống, `invoice.UsingGlobalPrescription == 1` → Không lỗi
       - TC6: Đơn thuốc có mã, mã trùng trong hệ thống, `invoice.UsingGlobalPrescription != 1` → Lỗi "Mã đơn thuốc {mã} đã tồn tại trong hệ thống"

---
**Điều hướng**
- Trước đó: [12-CreateInvoice-PromotionLimits.md](./12-CreateInvoice-PromotionLimits.md)
- Tiếp theo: [14-CreateInvoice-SalesPersonCheck.md](./14-CreateInvoice-SalesPersonCheck.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 