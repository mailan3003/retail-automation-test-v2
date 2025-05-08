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
| KVMessage.pharmacy_msgErrorManufacturerCountry | Invalid manufacturer country | When manufacturer country doesn't exist for a medicine product | Nước sản xuất không hợp lệ |
| KVMessage.product_ShortNameMaxLength | Medicine short name too long | When ShortName property exceeds 100 characters | Vui lòng nhập Tên viết tắt không quá 100 kí tự |
| KVMessage.product_RouteOfAdministrationMaxLength | Route of administration too long | When RouteOfAdministration property exceeds 200 characters | Vui lòng nhập Đường dùng không quá 200 kí tự |

These exceptions ensure data validation and business rule enforcement during the product creation process. They provide specific error messages to help identify and resolve issues with product data before committing to the database.