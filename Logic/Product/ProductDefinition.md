| Key | Message | Message Value |
|-----|---------|--------------|
| invalidRequestParams | Tham số truyền vào không hợp lệ | Tham số truyền vào không hợp lệ |
| _commission | Bảng hoa hồng | Bảng hoa hồng |
| _commissionExistInActive | đã ngừng áp dụng/xóa | đã ngừng áp dụng/xóa |
| attributeIsDeleted | Thuộc tính đã bị xóa. Vui lòng kiểm tra lại. | Thuộc tính đã bị xóa. Vui lòng kiểm tra lại. |

## Exception Messages in Post(ProductAddMany req) Method

### KvValidateProductException
| Exception Message | Description | Occurrence Condition | Message Value |
|-------------------|-------------|---------------------|---------------|
| KVMessage.invalidRequestParams | Invalid request parameters | Thrown when JSON deserialization fails for ListProductsString, ListProducts, or BranchForProductCostss | Tham số truyền vào không hợp lệ |
| KVMessage._product_ExceedingTheLimitComboProduct | Exceeding combo product limit | When attempting to add more than 50 combo products (ProductType.Manufactured) at once | Không thể gửi quá 50 sản phẩm combo trong một lần |
| KVMessage._product_ExceedingTheLimit | Exceeding general product limit | When attempting to add more than 200 products at once | Không thể gửi quá 200 sản phẩm trong một lần |
| KVMessage.duplicateUnitName | Duplicate unit name | When duplicate unit names are detected in product units | Tên đơn vị tính không được phép trùng nhau |
| KVMessage._GlobalErrorSummary | General error summary | When product list extraction fails | Có lỗi trong quá trình cập nhật dữ liệu. |
| KVMessage._GlobalDuplicateData | Duplicate product codes | When duplicate product codes are detected within the parent products list | {0} đã tồn tại |

### KvValidateProductMedicineException
| Exception Message | Description | Occurrence Condition | Message Value |
|-------------------|-------------|---------------------|---------------|
| KVMessage.pharmacy_EmptyRouteOfAdministration | Empty route of administration | When RouteOfAdministration is empty | Vui lòng nhập Đường dùng trước khi lưu |
| KVMessage.product_Required_Field | Required field missing | When any required field is empty for retailer medicine or changed medicine | Vui lòng nhập {0} trước khi lưu |
| KVMessage.pharmacy_msgErrorManufacturerCountry | Invalid manufacturer country | When manufacturer country doesn't exist for a medicine product | Nước sản xuất không hợp lệ |
| KVMessage.product_ShortNameMaxLength | Medicine short name too long | When ShortName property exceeds 100 characters | Tên thuốc không được vượt quá 100 kí tự |
| KVMessage.product_RouteOfAdministrationMaxLength | Route of administration too long | When RouteOfAdministration property exceeds 200 characters | Đường dùng không được vượt quá 200 kí tự |
| KVMessage.validateMaxLength | Field length exceeds limit | When any field exceeds its maximum length during national pharmacy sync | {0} không được vượt quá {1} kí tự |

### Labels Messages
| Label Key | Description | Message Value | Used In |
|-----------|-------------|---------------|---------|
| Labels.product_MedicineRegistrationNo | Medicine registration number field name | Số đăng ký | Required field validation |
| Labels.product_MedicineActiveElement | Medicine active element field name | Hoạt chất | Required field validation |
| Labels.product_MedicineContent | Medicine content field name | Hàm lượng | Required field validation |
| Labels.product_MedicinePackagingSize | Medicine packaging size field name | Quy cách đóng gói | Required field validation |
| Labels.product_BaseUnit | Base unit field name | Đơn vị cơ bản | Required field validation |
| Labels.product_MedicineManufacturer | Medicine manufacturer field name | Hãng sản xuất | Required field validation |
| Labels.product_MedicineManufacturerCountry | Medicine manufacturer country field name | Nước sản xuất | Required field validation |
| Labels.product_MedicineName | Medicine name field name | Tên thuốc | Length validation |

These exceptions ensure data validation and business rule enforcement during the product creation process. They provide specific error messages to help identify and resolve issues with product data before committing to the database.