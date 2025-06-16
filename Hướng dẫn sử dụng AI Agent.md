# Hướng dẫn sử dụng AI Agent để tạo testcase automation

## Giới thiệu

Tài liệu này hướng dẫn cách sử dụng AI Agent (như ChatGPT, Claude, Copilot) để tự động tạo các testcase cho hệ thống automation test. Quy trình này giúp tăng hiệu quả và độ bao phủ của test, giảm thiểu thời gian viết test thủ công.

## Quy trình sử dụng AI Agent

### 1. Chuẩn bị thông tin đầu vào

#### 1.1. Thu thập mã nguồn của API cần test
- Xác định và cung cấp cho AI file mã nguồn chứa API endpoint cần test (ví dụ: `InvoiceApi.cs`, `ProductApi.cs`)
- Chắc chắn rằng mã nguồn bao gồm đầy đủ thông tin về:
  - Các endpoint API
  - Cấu trúc dữ liệu đầu vào (request)
  - Logic xử lý
  - Các ràng buộc và validate

#### 1.2. Thu thập thông tin về cấu trúc dữ liệu
- Cung cấp thông tin về cấu trúc Entity và bảng trong CSDL
- Có thể sử dụng file `table_descriptions.sql` để AI hiểu được cấu trúc dữ liệu

#### 1.3. Thu thập logic nghiệp vụ
- Cung cấp cho AI các tài liệu mô tả logic nghiệp vụ (nếu có)
- Hoặc yêu cầu AI phân tích mã nguồn để trích xuất logic nghiệp vụ

### 2. Tinh chỉnh prompt

#### 2.1. Sử dụng các mẫu prompt có sẵn
Dựa theo file `Promtps.md`, các mẫu prompt hiệu quả bao gồm:

```
Bạn là senior .net developer với kinh nghiệm sâu về Robot Framework, ngôn ngữ Gherkin, và kiến thức chuyên sâu về hệ thống Point of Sale và ERP. Hãy đọc kỹ mã nguồn được cung cấp và tạo tất cả các testcase cho phương thức [Tên API] với các yêu cầu sau:

- Bao phủ tất cả nhánh logic của mã nguồn
- Không được bỏ sót một case nào, việc bỏ sót case là lỗi nghiêm trọng
- Tuân thủ nghiêm ngặt các mẫu và quy tắc thực hành tốt nhất trong tệp APITestDesign.md
- Viết testcase bằng tiếng Việt
- Không gọi API để thiết lập dữ liệu test hoặc xác thực kết quả test
- Xác thực dữ liệu được chèn/cập nhật đúng trong cơ sở dữ liệu
- Xem xét tệp CommonData.robot để tái sử dụng dữ liệu test chung và Env.robot cho biến chung
- Mô tả testcase phải mô tả logic test với dữ liệu ví dụ cụ thể
```

#### 2.2. Bổ sung chi tiết cụ thể cho prompt
- Thêm thông tin về endpoint API cụ thể
- Nêu rõ các section logic nghiệp vụ cần test
- Chỉ rõ các file cần tham khảo để hiểu cấu trúc và dữ liệu

### 3. Phân tích logic nghiệp vụ trước khi tạo testcase

Sử dụng prompt để AI phân tích logic nghiệp vụ trước:

```
Bạn là senior .net developer với kinh nghiệm sâu về Point of Sale. Hãy đọc kỹ mã nguồn theo từng dòng và liệt kê tất cả logic nghiệp vụ của phương thức [Tên phương thức] thành file markdown bằng tiếng Việt. Không được tưởng tượng hoặc lấy các tính năng phổ biến trong domain. Logic bạn liệt kê phải được tìm thấy trong mã nguồn thực tế.
```

### 4. Tạo testcase tự động

#### 4.1. Bắt đầu với phân đoạn logic đơn giản
- Yêu cầu AI tạo testcase cho từng phần logic đã được phân tích
- Bắt đầu với các phần đơn giản trước, sau đó chuyển sang phần phức tạp hơn

#### 4.2. Sử dụng prompt tạo testcase
```
Bạn là senior .net developer và master Robot Framework. Hãy đọc kỹ mã nguồn và tạo tất cả testcase API cho phần "[Tên phần logic]" với các yêu cầu sau:
- Tuân thủ nghiêm ngặt các mẫu và quy tắc trong tệp APITestDesign.md
- Sử dụng cấu trúc Given-When-Then
- Viết testcase bằng tiếng Việt
- Bao phủ tất cả nhánh logic của mã nguồn
- Xác thực dữ liệu được chèn/cập nhật đúng trong cơ sở dữ liệu
- Tái sử dụng dữ liệu test chung từ CommonData.robot
```

### 5. Đánh giá và tinh chỉnh testcase

#### 5.1. Kiểm tra độ phủ logic
- Yêu cầu AI tự đánh giá xem testcase đã bao phủ hết logic chưa
- Bổ sung testcase cho các nhánh logic còn thiếu

#### 5.2. Điều chỉnh theo feedback
```
Hãy kiểm tra lại kết quả và xem bạn có bỏ sót điều gì không. Hãy bổ sung thêm testcase cho các phần bị bỏ sót.
```

### 6. Tái sử dụng dữ liệu test

Sử dụng prompt để tái sử dụng dữ liệu test chung:
```
Hãy tuân theo quy tắc trong APITestDesign.md để tái sử dụng dữ liệu chung. Kiểm tra các biến chưa được định nghĩa trong file này và tìm kiếm trong CommonData.robot. Nếu không tìm thấy, hãy sử dụng mcp để tạo bản ghi mới cho nó trong cơ sở dữ liệu, lấy giá trị của nó và sử dụng để định nghĩa nó trong CommonData.robot.
```

### 7. Thêm test case khi cần thiết

Sử dụng prompt để thêm test case mới:
```
Bạn là senior .net developer và master Robot Framework. Hãy tạo thêm test case cho phần "[Tên phần logic]" bằng cách:
- So sánh với file test hiện tại và thêm test case mới
- Không tạo file mới hoặc sửa đổi/xóa test case hiện tại
- Tái sử dụng keywords, dữ liệu test hiện tại
- Chỉ thêm test case mới vào cuối file
- Thêm tag AIGenerated cho test case mới
```

## Ví dụ cụ thể

### Ví dụ 1: Tạo testcase cho API CreateInvoice

**Bước 1:** Thu thập mã nguồn `InvoiceApi.cs` và cung cấp cho AI

**Bước 2:** Yêu cầu AI phân tích logic nghiệp vụ
```
Bạn là senior .net developer với kinh nghiệm sâu về Point of Sale. Hãy đọc kỹ mã nguồn theo từng dòng và liệt kê tất cả logic nghiệp vụ của phương thức CreateInvoice thành file markdown bằng tiếng Việt.
```

**Bước 3:** Yêu cầu AI tạo testcase cho từng phần logic
```
Bạn là senior .net developer và master Robot Framework. Hãy tạo tất cả testcase API cho phần "Kiểm tra và xác thực đầu vào" của phương thức CreateInvoice với các yêu cầu sau:
- Tuân thủ nghiêm ngặt APITestDesign.md
- Viết testcase bằng tiếng Việt
- Bao phủ tất cả nhánh logic
- Xác thực dữ liệu được cập nhật đúng trong cơ sở dữ liệu
```

### Ví dụ 2: Thêm testcase cho phần xử lý thanh toán

```
Bạn là senior .net developer và master Robot Framework. Hãy tạo thêm test case cho phần "Xử lý thanh toán" bằng cách:
- So sánh với file PromotionTest.robot hiện tại
- Chỉ thêm test case mới vào cuối file
- Thêm tag AIGenerated cho test case mới
```

## Lưu ý quan trọng

1. **Kiểm tra dữ liệu test:** Luôn kiểm tra xem dữ liệu test đã tồn tại hay chưa, ưu tiên tái sử dụng dữ liệu test chung

2. **Tuân thủ cấu trúc Given-When-Then:** Testcase phải tuân thủ nghiêm ngặt cấu trúc này

3. **Viết bằng tiếng Việt:** Tất cả testcase và mô tả phải được viết bằng tiếng Việt

4. **Kiểm tra độ phủ logic:** Đảm bảo tất cả nhánh logic được bao phủ

5. **Xác thực dữ liệu DB:** Luôn xác thực dữ liệu trong cơ sở dữ liệu, không chỉ phản hồi API

6. **Nhóm các testcase tương tự:** Sử dụng template để nhóm các testcase tương tự

7. **Không tạo dữ liệu test mới:** Ưu tiên sử dụng dữ liệu test hiện có

## Kết luận

Sử dụng AI Agent để tạo testcase automation là một cách hiệu quả để tăng tốc quá trình phát triển test, đảm bảo độ bao phủ cao và tuân thủ các quy ước. Bằng cách tuân thủ hướng dẫn này, bạn có thể tận dụng tối đa sức mạnh của AI để tạo ra các testcase chất lượng cao, giảm thiểu công sức thủ công và tăng độ tin cậy của hệ thống test. 