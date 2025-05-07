# Hướng dẫn tích hợp Redis

Hướng dẫn này giải thích cách tích hợp bộ nhớ đệm Redis với cấu trúc API của bạn dựa trên RedisLibrary đã cung cấp.

## Tổng quan

Redis được sử dụng để lưu trữ dữ liệu vào bộ nhớ đệm nhằm cải thiện hiệu suất và giảm tải cho cơ sở dữ liệu. Lớp `RedisLibrary` cung cấp một wrapper cho các thao tác Redis để đơn giản hóa việc tích hợp.

## Thiết lập và cấu hình

1. Đảm bảo máy chủ Redis đã được cài đặt và đang chạy
2. Import lớp RedisLibrary:
   ```python
   from RedisLibrary import RedisLibrary
   ```
3. Khởi tạo kết nối Redis:
   ```python
   redis = RedisLibrary(
       host='your-redis-host',  # mặc định: localhost
       port=6379,               # cổng Redis mặc định
       db=0,                    # cơ sở dữ liệu mặc định
       password='your-password' # tùy chọn
   )
   ```

## Sử dụng cơ bản

### Tạo khóa
```python
# Đặt một khóa với thời gian hết hạn tùy chọn (tính bằng giây)
redis.create_key('user:1234', user_data, ex=3600)  # Hết hạn sau 1 giờ
```

### Đọc khóa
```python
# Lấy giá trị cho một khóa
user_data = redis.read_key('user:1234')
```

### Cập nhật khóa
```python
# Cập nhật một khóa đã tồn tại
redis.update_key('user:1234', updated_user_data, ex=3600)
```

### Xóa khóa
```python
# Xóa một khóa
redis.delete_key('user:1234')
```

### Phương thức xác minh
```python
# Khẳng định rằng một khóa tồn tại
redis.key_should_exist('user:1234')

# Khẳng định rằng một khóa không tồn tại
redis.key_should_not_exist('user:1234')
```

## Tích hợp với Robot Framework

### Cài đặt và Import trong Robot Framework

```robotframework
*** Settings ***
Library    RedisLibrary    host=localhost    port=6379    db=0

# Hoặc sử dụng với các đối số tùy chọn
# Library    RedisLibrary    host=redis.example.com    port=6379    db=0    password=secret
```

### Ví dụ sử dụng trong test case Robot Framework

```robotframework
*** Test Cases ***
Test Redis Operations
    # Tạo một khóa mới
    Create Key    user:1001    {"name": "Nguyen Van A", "email": "nguyenvana@example.com"}    ex=3600
    
    # Kiểm tra khóa tồn tại
    Key Should Exist    user:1001
    
    # Đọc giá trị
    ${user_data}=    Read Key    user:1001
    Should Contain    ${user_data}    Nguyen Van A
    
    # Cập nhật khóa
    Update Key    user:1001    {"name": "Nguyen Van A", "email": "nguyenvana@example.com", "phone": "0123456789"}
    
    # Xóa khóa
    Delete Key    user:1001
    Key Should Not Exist    user:1001
```

### Tích hợp với API Testing

```robotframework
*** Settings ***
Library    RedisLibrary
Library    RequestsLibrary
Library    Collections

*** Test Cases ***
Verify API Uses Redis Cache
    # Tạo phiên kết nối HTTP
    Create Session    api    http://localhost:8000
    
    # Gửi yêu cầu API lần đầu tiên
    ${response1}=    GET On Session    api    /products/123
    
    # Kiểm tra Redis cache đã được tạo
    Key Should Exist    product:123
    
    # Kiểm tra thời gian phản hồi nhanh hơn khi cache đã tồn tại
    ${start_time}=    Get Time    epoch
    ${response2}=    GET On Session    api    /products/123
    ${end_time}=    Get Time    epoch
    ${response_time}=    Evaluate    ${end_time} - ${start_time}
    
    # Kiểm tra phản hồi nhanh (ví dụ: dưới 50ms)
    Should Be True    ${response_time} < 0.05
    
    # Xác minh dữ liệu nhất quán
    Should Be Equal    ${response1.json()}    ${response2.json()}
```

## Tích hợp với cấu trúc API

Dựa trên cấu trúc API được mô tả trong tài liệu, bạn có thể tích hợp bộ nhớ đệm Redis như sau:

### Ví dụ: Lưu trữ dữ liệu sản phẩm

```csharp
[RequiresAnyPermission(Product._Read)]
[Route("/products/{id}", "GET")]
public class GetProductById : IReturn<ProductResponse>
{
    public int Id { get; set; }
    
    // Thêm cờ để bỏ qua bộ nhớ đệm nếu cần
    public bool BypassCache { get; set; }
}

// Trong triển khai dịch vụ
public ProductResponse Get(GetProductById request)
{
    string cacheKey = $"product:{request.Id}";
    
    // Thử lấy từ bộ nhớ đệm trước, trừ khi có yêu cầu bỏ qua
    if (!request.BypassCache)
    {
        var cachedProduct = _redisCache.Read(cacheKey);
        if (cachedProduct != null)
        {
            return cachedProduct;
        }
    }
    
    // Lấy từ cơ sở dữ liệu nếu không có trong bộ nhớ đệm
    var product = _productRepository.GetById(request.Id);
    
    // Lưu kết quả vào bộ nhớ đệm
    _redisCache.Create(cacheKey, product, ex=3600);
    
    return product;
}
```

## Các phương pháp hay nhất

1. **Quy ước đặt tên khóa**: Sử dụng mẫu đặt tên nhất quán như `entity:id` (ví dụ: `product:1234`, `invoice:5678`)
2. **Đặt thời gian hết hạn phù hợp**: Xem xét tần suất dữ liệu thay đổi
3. **Vô hiệu hóa bộ nhớ đệm**: Xóa hoặc cập nhật các mục bộ nhớ đệm khi dữ liệu cơ bản thay đổi
4. **Xử lý lỗi**: Triển khai xử lý ngoại lệ thích hợp cho các thao tác Redis
5. **Xem xét hiện tượng Cache Stampede**: Sử dụng các kỹ thuật như thời gian hết hạn trượt hoặc làm mới trong nền cho dữ liệu được truy cập thường xuyên 