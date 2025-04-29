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

  2. **Kiểm tra thông tin thuốc trong đơn**:
     - **Kiểm tra mô tả cách dùng thuốc**:
       - Áp dụng khi: Hóa đơn sử dụng đơn thuốc toàn cục (`invoice.UsingGlobalPrescription == 1`) và có chi tiết hóa đơn (`invoice.InvoiceDetails != null && invoice.InvoiceDetails.Any()`)
       - Quy tắc kiểm tra:
         - Với mỗi thuốc trong `invoice.Medicines`, hệ thống tìm sản phẩm tương ứng trong `invoice.InvoiceDetails` dựa trên `ProductId`
         - Sản phẩm được xem là thiếu mô tả khi: `IsMaster == true` và `Note` trống hoặc null
       - Kết quả: Nếu phát hiện sản phẩm thiếu mô tả, hệ thống sẽ ném ngoại lệ `KVMedicineException` với thông báo "Hàng hóa thiếu ghi chú" (`KVMessage.invoice_ProductNoDescription`)
     
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

  3. **Kiểm tra mã đơn thuốc**:
     - **Điều kiện kiểm tra**:
       - Áp dụng khi đơn thuốc có thông tin (`invoice.Prescription != null`)
     
     - **Quy tắc kiểm tra**:
       - **Trường hợp 1**: Đơn thuốc có mã (`invoice.Prescription.Code` không rỗng)
         - Kiểm tra độ dài mã không vượt quá 50 ký tự:
           - Nếu độ dài mã đơn thuốc vượt quá 50 ký tự (`invoice.Prescription.Code.Length > 50`), hệ thống sẽ ném ngoại lệ `KvValidateClinicException` với thông báo: "Vui lòng nhập Mã đơn thuốc không quá 50 kí tự" (`KVMessage.prescription_CodeLengthMax`)
         - Kiểm tra mã đơn thuốc không trùng với mã đơn thuốc đã tồn tại trong hệ thống
         - Kết quả: Nếu trùng và không phải đơn thuốc toàn cục (`invoice.UsingGlobalPrescription != 1`), hệ thống sẽ ném ngoại lệ với thông báo: "Mã đơn thuốc {mã} đã tồn tại trong hệ thống" (`KVMessage.prescription_CodeAlreadyExist`)
       
       - **Trường hợp 2**: Đơn thuốc không có mã nhưng có ID > 0
         - Kết quả: Hệ thống sẽ ném ngoại lệ với thông báo: "Mã đơn thuốc không hợp lệ" (`KVMessage.prescription_CodeIsNotValid`)

## Test Data JSON cho các trường hợp thất bại

### 1. Đơn thuốc và bệnh nhân đều thiếu thông tin
```json
{
  "Invoice": {
    "UsingPrescription": 1,
    "Prescription": {
      "Code": null,
      "DoctorId": null,
      "ClinicId": null,
      "Description": null
    },
    "Patient": {
      "Name": null,
      "Age": null,
      "Gender": null,
      "Weight": null,
      "IdentityCard": null,
      "HealthInsuranceCard": null,
      "Address": null,
      "Guardian": null,
      "PhoneNumber": null
    }
  },
  "AuthServiceContext": {
    "IsActiveGppDrugStore": true
  },
  "IsValid": false,
  "ExpectedError": {
    "Type": "KvValidateClinicException",
    "Message": "Bạn chưa nhập thông tin đơn thuốc"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi cả đơn thuốc và bệnh nhân đều thiếu thông tin.

### 2. Sản phẩm trong đơn thuốc toàn cục thiếu mô tả cách dùng
```json
{
  "Invoice": {
    "UsingPrescription": 1,
    "UsingGlobalPrescription": 1,
    "InvoiceDetails": [
      {
        "ProductId": 100,
        "ProductName": "Paracetamol 500mg",
        "IsMaster": true,
        "Note": null
      },
      {
        "ProductId": 200,
        "ProductName": "Vitamin C",
        "IsMaster": true,
        "Note": "Uống 1 viên/ngày sau ăn"
      }
    ],
    "Medicines": [
      {
        "ProductId": 100,
        "Code": "PARA-500",
        "Name": "Paracetamol 500mg"
      },
      {
        "ProductId": 200,
        "Code": "VIT-C",
        "Name": "Vitamin C"
      }
    ]
  },
  "AuthServiceContext": {
    "IsActiveGppDrugStore": true
  },
  "IsValid": false,
  "ExpectedError": {
    "Type": "KVMedicineException",
    "Message": "Hàng hóa thiếu ghi chú"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi phát hiện sản phẩm thiếu mô tả cách dùng trong đơn thuốc toàn cục.

### 3. Thuốc trong đơn đã hết hạn
```json
{
  "Invoice": {
    "UsingPrescription": 1,
    "Medicines": [
      {
        "ProductId": 100,
        "Code": "PARA-500",
        "Name": "Paracetamol 500mg",
        "IsExpired": true
      },
      {
        "ProductId": 200,
        "Code": "VIT-C",
        "Name": "Vitamin C",
        "IsExpired": false
      }
    ],
    "NewMedicines": []
  },
  "AuthServiceContext": {
    "IsActiveGppDrugStore": true
  },
  "IsValid": false,
  "ExpectedError": {
    "Type": "KVMedicineException",
    "Message": "PARA-500 đã bán hết số lượng trong đơn, vui lòng xóa sản phẩm để tạo đơn."
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi phát hiện thuốc trong đơn đã hết hạn.

### 4. Nhiều thuốc trong đơn đã hết hạn
```json
{
  "Invoice": {
    "UsingPrescription": 1,
    "Medicines": [
      {
        "ProductId": 100,
        "Code": "PARA-500",
        "Name": "Paracetamol 500mg",
        "IsExpired": true
      },
      {
        "ProductId": 200,
        "Code": "VIT-C",
        "Name": "Vitamin C",
        "IsExpired": true
      }
    ],
    "NewMedicines": []
  },
  "AuthServiceContext": {
    "IsActiveGppDrugStore": true
  },
  "IsValid": false,
  "ExpectedError": {
    "Type": "KVMedicineException",
    "Message": "PARA-500, VIT-C đã bán hết số lượng trong đơn, vui lòng xóa sản phẩm để tạo đơn."
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi liệt kê tất cả các mã thuốc đã hết hạn trong thông báo.

### 5. Đơn thuốc không có mã nhưng có ID > 0
```json
{
  "Invoice": {
    "UsingPrescription": 1,
    "Prescription": {
      "Id": 123,
      "Code": null,
      "DoctorId": 456,
      "ClinicId": 789
    }
  },
  "AuthServiceContext": {
    "IsActiveGppDrugStore": true
  },
  "IsValid": false,
  "ExpectedError": {
    "Type": "KvValidateClinicException",
    "Message": "Mã đơn thuốc không hợp lệ"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi đơn thuốc không có mã nhưng có ID > 0.

### 6. Mã đơn thuốc trùng với mã đã tồn tại
```json
{
  "Invoice": {
    "UsingPrescription": 1,
    "UsingGlobalPrescription": 0,
    "Prescription": {
      "Id": 0,
      "Code": "DT001",
      "DoctorId": 456,
      "ClinicId": 789
    }
  },
  "AuthServiceContext": {
    "IsActiveGppDrugStore": true
  },
  "ExistingPrescription": {
    "Code": "DT001"
  },
  "IsValid": false,
  "ExpectedError": {
    "Type": "KvValidateClinicException",
    "Message": "Mã đơn thuốc DT001 đã tồn tại trong hệ thống"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi phát hiện mã đơn thuốc đã tồn tại trong hệ thống.

### 7. Mã đơn thuốc vượt quá độ dài cho phép
```json
{
  "Invoice": {
    "UsingPrescription": 1,
    "Prescription": {
      "Id": 0,
      "Code": "DT00100000000000000000000000000000000000000000000000000",
      "DoctorId": 456,
      "ClinicId": 789
    }
  },
  "AuthServiceContext": {
    "IsActiveGppDrugStore": true
  },
  "IsValid": false,
  "ExpectedError": {
    "Type": "KvValidateClinicException",
    "Message": "Vui lòng nhập Mã đơn thuốc không quá 50 kí tự"
  }
}
```
**Kết quả kiểm tra**: Hệ thống báo lỗi khi mã đơn thuốc vượt quá 50 ký tự.

---
**Điều hướng**
- Trước đó: [12-CreateInvoice-PromotionLimits.md](./12-CreateInvoice-PromotionLimits.md)
- Tiếp theo: [14-CreateInvoice-SalesPersonCheck.md](./14-CreateInvoice-SalesPersonCheck.md)
- Mục lục: [00-CreateInvoice-Index.md](./00-CreateInvoice-Index.md) 