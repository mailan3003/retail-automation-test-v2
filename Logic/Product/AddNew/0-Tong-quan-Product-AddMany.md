# Tổng Quan Quy Trình Thêm Sản Phẩm

## Giới Thiệu

Tài liệu này cung cấp tổng quan về quy trình thêm sản phẩm mới trong hệ thống quản lý bán lẻ. Hệ thống được thiết kế để xử lý quá trình phức tạp khi thêm sản phẩm mới vào phần mềm quản lý, hỗ trợ nhiều loại sản phẩm, thuộc tính, mô hình giá và yêu cầu đặc thù theo ngành hàng.

## Các Thành Phần Chính và Quy Trình

### 1. Xử Lý Dữ Liệu Đầu Vào
- Trích xuất thông tin sản phẩm từ nhiều nguồn (dữ liệu nhập, biểu mẫu)
- Chuẩn hóa tên sản phẩm và kiểm tra định dạng
- Áp dụng các quy tắc kiểm tra (giới hạn số lượng, kiểm tra trùng lặp)
- Xử lý quyền người dùng và kiểm soát truy cập theo chi nhánh

### 2. Xác Thực Sản Phẩm
- Kiểm tra thuộc tính sản phẩm và đảm bảo tồn tại trong hệ thống
- Tự động tạo mã sản phẩm hoặc xác thực mã do người dùng nhập
- Kiểm tra trùng lặp mã sản phẩm giữa sản phẩm cha và con
- Xác thực thông tin đặc thù ngành (sản phẩm dược phẩm, sản xuất)
- Kiểm tra thông tin quốc gia sản xuất và các chi tiết bắt buộc khác

### 3. Xử Lý Quan Hệ Sản Phẩm Cha-Con
- Tạo sản phẩm chính/cha trước tiên
- Xử lý mối quan hệ cha-con cho các đơn vị khác nhau của cùng một sản phẩm (ví dụ: thùng/hộp/cái)
- Đồng bộ thuộc tính cốt lõi giữa sản phẩm cha và con
- Quản lý hệ số chuyển đổi giữa các đơn vị khác nhau
- Thực hiện lưu nhiều sản phẩm cùng lúc với cơ chế an toàn dữ liệu

### 4. Xử Lý Dữ Liệu Liên Quan
- **Thông Tin Thuế**: Xử lý cài đặt VAT/thuế khi được kích hoạt
- **Thuộc Tính Sản Phẩm**: Lưu trữ các thuộc tính tùy chỉnh của sản phẩm
- **Giá Bán**: Quản lý nhiều bảng giá cho các kênh bán hàng khác nhau
- **Tồn Kho**: Xử lý số lượng tồn kho ban đầu cho mỗi chi nhánh/kho
- **Công Thức Sản Xuất**: Xử lý danh sách nguyên liệu và tính toán chi phí
- **Quản Lý Kệ Hàng**: Theo dõi vị trí sản phẩm trong cửa hàng

### 5. Xử Lý Sau Khi Lưu
- Đồng bộ dữ liệu dược phẩm với Cơ Sở Dữ Liệu Dược Quốc Gia
- Cập nhật bảng giá với thông tin sản phẩm mới
- Xử lý giá vốn và tình trạng sẵn có theo chi nhánh
- Tính toán chi phí sản xuất dựa trên công thức nguyên liệu
- Xử lý sự sẵn có của đơn vị sản phẩm trên các chi nhánh

### 6. Quản Lý Tồn Kho Ban Đầu
- Tạo số lượng tồn kho ban đầu cho sản phẩm mới
- Xử lý theo dõi tồn kho theo từng kho hàng
- Quản lý chuyển đổi đơn vị cho số lượng tồn kho
- Cập nhật đơn vị sản phẩm theo chi nhánh cho quản lý tồn kho
- Kiểm tra trạng thái kho hàng trước khi phân bổ tồn kho

### 7. Tìm Kiếm và Hoàn Tất
- Xử lý hình ảnh sản phẩm từ nhiều nguồn (tải lên, URL, kênh bán hàng)
- Tạo gợi ý đơn vị tính mới cho việc thêm sản phẩm trong tương lai
- Đồng bộ dữ liệu với hệ thống tìm kiếm
- Hoàn tất thông tin thuế cho sản phẩm

### 8. Nhật Ký và Lịch Sử
- Ghi lại chi tiết mọi thay đổi của sản phẩm
- Theo dõi thông tin chi nhánh trong nhật ký
- Bao gồm thuộc tính sản phẩm, tồn kho, giá bán trong nhật ký
- Xử lý ghi log đặc biệt cho ngành được quản lý (dược phẩm)
- Ghi lại thay đổi công thức và thông tin nguyên liệu

### 9. Xử Lý Đặc Thù Theo Ngành
- **Dược Phẩm**: Quản lý đăng ký thuốc, hoạt chất, nhà sản xuất
- **Xây Dựng**: Xử lý trọng lượng, kích thước và đặc tính vật liệu
- **Sản Xuất**: Xử lý công thức, chi phí nguyên liệu và đơn vị sản xuất
- **Dịch Vụ**: Xử lý các thuộc tính dịch vụ khác với hàng hóa vật lý

## Các Quy Tắc Nghiệp Vụ Chính

1. **Giới Hạn Sản Phẩm**:
   - Tối đa 50 sản phẩm combo/sản xuất
   - Tối đa 200 sản phẩm tổng cộng mỗi lần thao tác

2. **Tính Duy Nhất Của Mã**:
   - Mã sản phẩm phải duy nhất trong hệ thống
   - Sản phẩm cha và con có không gian mã riêng biệt
   - Tạo mã tự động theo các mẫu có thể cấu hình

3. **Tính Toán Giá Vốn**:
   - Giá vốn sản phẩm con được tính từ: giá vốn sản phẩm cha × hệ số chuyển đổi
   - Giá vốn sản phẩm theo công thức được tính từ nguyên liệu
   - Giá vốn theo chi nhánh được quản lý riêng khi cần thiết

4. **Quản Lý Tồn Kho**:
   - Tồn kho ban đầu được đếm tại chi nhánh/kho cụ thể
   - Hỗ trợ nhiều kho với xác thực trạng thái kho
   - Theo dõi lô/serial/hạn sử dụng dựa trên cấu hình sản phẩm

5. **Quy Định Dược Phẩm**:
   - Các trường bắt buộc cho sản phẩm dược phẩm (số đăng ký, hoạt chất)
   - Tích hợp với Cơ Sở Dữ Liệu Dược Quốc Gia
   - Tự động bật kiểm soát lô và hạn sử dụng cho sản phẩm thuốc

6. **Xử Lý Hình Ảnh**:
   - Hỗ trợ nhiều nguồn hình ảnh (tải lên, URL, gợi ý)
   - Tùy chọn áp dụng hình ảnh cho tất cả sản phẩm trong nhóm
   - Khả năng ghim hình ảnh chính cho sản phẩm

7. **Tích Hợp Tìm Kiếm**:
   - Đồng bộ hóa dựa trên sự kiện với hệ thống tìm kiếm
   - Theo dõi thay đổi qua ID sự kiện duy nhất
   - Xử lý hàng loạt để tối ưu hiệu suất

## Mô Hình Kiến Trúc

1. **Quản Lý Giao Dịch**:
   - Giao dịch cơ sở dữ liệu đảm bảo tính toàn vẹn dữ liệu
   - Cơ chế hoàn tác để xử lý lỗi
   - Thao tác hàng loạt để tối ưu hiệu suất

2. **Thiết Kế Hướng Dịch Vụ**:
   - Các dịch vụ tách biệt cho các khía cạnh khác nhau (Quản lý Sản phẩm, Thuế...)
   - Phân tách rõ ràng giữa xác thực và xử lý

3. **Xử Lý Hàng Loạt**:
   - Tối ưu hóa thao tác cơ sở dữ liệu với chức năng thêm và cập nhật hàng loạt
   - Xử lý theo lô để giảm thiểu các lệnh gọi đến cơ sở dữ liệu

4. **Cấu Hình Tính Năng**:
   - Các tính năng điều kiện dựa trên cài đặt của nhà bán lẻ
   - Xử lý đặc thù theo ngành được kích hoạt bởi cấu hình
   - Truy cập tính năng dựa trên quyền hạn

5. **Kiểm Toán và Theo Dõi**:
   - Ghi log đầy đủ mọi thay đổi
   - Trách nhiệm hành động người dùng
   - ID giao dịch để tham chiếu chéo

## Điểm Tích Hợp

1. **Hệ Thống Tìm Kiếm**: Cho chức năng tìm kiếm sản phẩm
2. **Cơ Sở Dữ Liệu Dược Quốc Gia**: Cho sản phẩm dược phẩm được quản lý
3. **Hệ Thống Tồn Kho Đa Chi Nhánh**: Cho quản lý hàng tồn kho tại nhiều địa điểm
4. **Hệ Thống Bảng Giá**: Cho quản lý các mô hình giá khác nhau
5. **Hệ Thống Nhật Ký Thao Tác**: Cho việc tuân thủ và theo dõi thay đổi

## Cân Nhắc Hiệu Suất

1. **Thao Tác Hàng Loạt**: Sử dụng để thêm nhiều bản ghi cùng một lúc
2. **Quản Lý Giao Dịch**: Được tối ưu hóa để xử lý nhiều sản phẩm
3. **Xử Lý Bất Đồng Bộ**: Sử dụng cho các thao tác không chặn
4. **Cập Nhật Chọn Lọc**: Chỉ dữ liệu thay đổi được đồng bộ hóa với hệ thống tìm kiếm

## Kết Luận

Hệ thống thêm sản phẩm là một thành phần phức tạp, giàu tính năng của nền tảng tự động hóa bán lẻ. Nó xử lý các yêu cầu đa dạng trên nhiều ngành hàng khác nhau, đồng thời duy trì tính toàn vẹn dữ liệu, hiệu suất và tuân thủ với các quy định khác nhau. Thiết kế mô-đun cho phép mở rộng và tùy chỉnh trong tương lai dựa trên nhu cầu kinh doanh ngày càng phát triển.

## Chi Tiết Các Quy Trình

Dưới đây là danh sách các tài liệu chi tiết về từng quy trình trong hệ thống thêm sản phẩm:

1. [Xử lý dữ liệu đầu vào](./1-Chuc-nang-xu-ly-du-lieu-dau-vao.md)
2. [Xác thực sản phẩm](./2-Chuc-nang-xac-thuc-san-pham.md)
3. [Tổng quan xử lý vòng lặp cha-con](./3-Tong-quan-xu-ly-vong-lap-cha-con.md)
   - [Xử lý thông tin thuế sản phẩm](./3-1-Xu-ly-thong-tin-thue-san-pham.md)
   - [Xử lý ánh xạ mã sản phẩm](./3-2-Xu-ly-anh-xa-ma-san-pham.md)
   - [Xử lý dữ liệu bảng liên quan](./3-3-Xu-ly-du-lieu-bang-lien-quan.md)
   - [Xử lý sản phẩm con](./3-4-Xu-ly-san-pham-con.md)
4. [Xử lý sau lưu sản phẩm](./4-Chuc-nang-xu-ly-sau-luu-san-pham.md)
5. [Xử lý tồn kho ban đầu](./5-Chuc-nang-xu-ly-ton-kho-ban-dau.md)
6. [Xử lý tìm kiếm và hoàn tất](./6-Chuc-nang-xu-ly-tim-kiem-va-hoan-tat.md)
7. [Quản lý lịch sử thao tác](./7-Quan-ly-lich-su-thao-tac.md)
8. [Xử lý thuộc tính đặc thù](./8-Xu-ly-thuoc-tinh-dac-thu.md)
9. [Tích hợp với hệ thống ngoài](./9-Tich-hop-voi-he-thong-ngoai.md)
10. [Xử lý theo ngành hàng](./10-Xu-ly-theo-nganh-hang.md)
11. [Ghi nhật ký kiểm kê hàng](./11-Ghi-nhat-ky-kiem-ke-hang.md) 