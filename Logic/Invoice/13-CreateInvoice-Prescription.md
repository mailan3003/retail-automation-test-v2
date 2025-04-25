# Phân tích Business Logic của phương thức CreateInvoice

### 12. Xử lý thông tin đơn thuốc (cho nhà thuốc GPP)
- **Điều kiện áp dụng**:
  - Hệ thống sẽ bỏ qua kiểm tra khi `isValid = true` (đã xác thực ở nơi khác)
  - Chỉ áp dụng khi cửa hàng thuộc ngành dược (`AuthService.Context.IsActiveGppDrugStore`), hóa đơn có sử dụng đơn thuốc (`invoice.UsingPrescription == 1`)

- **Quy trình xử lý đơn thuốc**:
  1. **Kiểm tra thông tin đơn thuốc và bệnh nhân**:
     - Hệ thống kiểm tra tính đầy đủ của thông tin:
       - Đơn thuốc: mã đơn (`Code`), bác sĩ (`DoctorId`), phòng khám (`ClinicId`), mô tả (`Description`)
       - Bệnh nhân: tên (`Name`), tuổi (`Age`), giới tính (`Gender`), cân nặng (`Weight`), CMND/CCCD (`IdentityCard`), thẻ BHYT (`HealthInsuranceCard`), địa chỉ (`Address`), người giám hộ (`Guardian`), số điện thoại (`PhoneNumber`)
     - Nếu cả hai đều thiếu thông tin, hiển thị thông báo: "Bạn chưa nhập thông tin đơn thuốc" (`KVMessage.prescription_Empty`)

  2. **Kiểm tra mô tả cách dùng thuốc**:
     - Áp dụng khi hóa đơn sử dụng đơn thuốc toàn cục (`UsingGlobalPrescription == 1`)
     - Mỗi sản phẩm thuốc phải có mô tả cách dùng (trường `Note` không được trống)
     - Nếu phát hiện thiếu mô tả, hiển thị: "Hàng hóa thiếu ghi chú" (`KVMessage.invoice_ProductNoDescription`)

  3. **Kiểm tra tình trạng thuốc**:
     - Hệ thống lọc danh sách thuốc đang bán (không bao gồm thuốc mới/thay thế)
     ```csharp
     var listSellMedicine = invoice.Medicines.Where(x => 
         !invoice.NewMedicines.Any(nm => nm.MedicineCode == x.MedicineCode) || 
         x.ReplaceMedicine != null
     ).ToList();
     ```
     - Kiểm tra thuộc tính `IsExpired` để xác định thuốc hết hạn
     - Nếu phát hiện thuốc hết hạn:
       - Tổng hợp danh sách mã thuốc có vấn đề
       - Hiển thị thông báo: "[danh sách mã] đã bán hết số lượng trong đơn, vui lòng xóa sản phẩm để tạo đơn." (`KVMessage.Medicine_ProductCodeSoldOut`)

  4. **Kiểm tra mã đơn thuốc**:
     - Nếu đơn thuốc có mã (`invoice.Prescription?.Code` không rỗng):
       - Kiểm tra độ dài mã không vượt quá 50 ký tự
       - Kiểm tra mã đơn thuốc không trùng với mã đơn thuốc đã tồn tại trong hệ thống
       - Nếu trùng và không phải đơn thuốc toàn cục (`UsingGlobalPrescription != 1`), hiển thị thông báo: "Mã đơn thuốc {mã} đã tồn tại trong hệ thống" (`KVMessage.prescription_CodeAlreadyExist`)
     - Nếu đơn thuốc không có mã nhưng có ID > 0, hiển thị thông báo: "Mã đơn thuốc không hợp lệ" (`KVMessage.prescription_CodeIsNotValid`)

---
**Điều hướng**
- Trước đó: [12-CreateInvoice-PromotionLimits.md](./12-CreateInvoice-PromotionLimits.md)
- Tiếp theo: [14-CreateInvoice-SalesPersonCheck.md](./14-CreateInvoice-SalesPersonCheck.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 