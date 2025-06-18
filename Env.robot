*** Variables ***
# API Endpoints
${BASE_URL}    http://localhost:5000
${CUSTOMER_VALIDATION_ENDPOINT}    ${BASE_URL}/api/customers/validate

# Database Queries
${QUERY_GET_CUSTOMER_BY_CODE}    SELECT * FROM Customer WHERE CustomerCode = ?

# Common Data
${CUSTOMER_GROUP_1}    1
${CUSTOMER_GROUP_2}    2
${CUSTOMER_GROUP_3}    3

# Location IDs
${WARD_1}    1
${DISTRICT_1}    1
${CITY_1}    1

# Error Messages
${ERROR_MISSING_CUSTOMER_CODE}    Mã khách hàng không được để trống
${ERROR_MISSING_CUSTOMER_NAME}    Tên khách hàng không được để trống
${ERROR_MISSING_PHONE}    Số điện thoại không được để trống
${ERROR_INVALID_EMAIL}    Email không đúng định dạng
${ERROR_INVALID_PHONE}    Số điện thoại không đúng định dạng
${ERROR_INVALID_TAX_CODE}    Mã số thuế không đúng định dạng
${ERROR_INVALID_BIRTH_DATE}    Ngày sinh không đúng định dạng
${ERROR_DUPLICATE_CUSTOMER_CODE}    Mã khách hàng đã tồn tại
${ERROR_DUPLICATE_PHONE}    Số điện thoại đã tồn tại
${ERROR_DUPLICATE_EMAIL}    Email đã tồn tại
${ERROR_DUPLICATE_TAX_CODE}    Mã số thuế đã tồn tại
${ERROR_INVALID_WARD}    Phường/xã không tồn tại
${ERROR_INVALID_DISTRICT}    Quận/huyện không tồn tại
${ERROR_INVALID_CITY}    Tỉnh/thành phố không tồn tại
${ERROR_INVALID_ADDRESS}    Địa chỉ không đúng định dạng
${ERROR_INVALID_GROUP}    Nhóm khách hàng không tồn tại
${ERROR_UNAUTHORIZED_GROUP}    Không có quyền truy cập nhóm
${ERROR_GROUP_LIMIT_EXCEEDED}    Vượt quá giới hạn số lượng khách hàng trong nhóm 