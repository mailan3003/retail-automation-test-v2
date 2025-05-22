# Phương thức ValidateUpdateOrDeletePurchaseDate

## Mục đích
Phương thức này kiểm tra tính hợp lệ của việc cập nhật hoặc xóa ngày mua hàng trong hóa đơn. Hệ thống có giới hạn về khoảng thời gian cho phép cập nhật/xóa để đảm bảo tính nhất quán của dữ liệu.

## Quy trình
1. Kiểm tra xem tính năng kiểm tra cập nhật ngày mua có được bật không (thông qua `ValidateUpdatePurchaseDateToggle`)
2. Nếu tính năng không được bật, phương thức kết thúc mà không thực hiện kiểm tra
3. Kiểm tra xem ngày mua mới có khác với ngày mua cũ không
4. Tính toán xem ngày mua mới có nằm ngoài khoảng thời gian cho phép không:
   - Kiểm tra nếu ngày mới lớn hơn ngày cũ quá `MaxMonthUpdatePurchaseDateInvoice` tháng
   - Kiểm tra nếu ngày mới nhỏ hơn ngày cũ quá `MaxMonthUpdatePurchaseDateInvVoice` tháng
5. Nếu ngày mới nằm ngoài khoảng cho phép, hệ thống sẽ xử lý theo loại thao tác:
   - Nếu là thao tác xóa (TypeDirection.Delete): Ném ngoại lệ với thông báo "Bạn chỉ có thể hủy giao dịch trong vòng {0} tháng." (deletePurchaseDateError), trong đó {0} là giá trị MaxMonthUpdatePurchaseDateInvoice
   - Nếu là thao tác khác (cập nhật): Gọi đến phương thức ThrowUpdatePurchaseDate để xử lý ngoại lệ tương ứng (xem chi tiết tại [ThrowUpdatePurchaseDate.md](./ThrowUpdatePurchaseDate.md))

## Tham số
- `purchaseDate` (DateTime): Ngày mua hàng mới hoặc cập nhật
- `oldPurchaseDate` (DateTime): Ngày mua hàng cũ trong hệ thống
- `type` (TypeDirection): Loại thao tác (Thêm, Sửa, Xóa)
- `isOffline` (bool): Xác định nếu thao tác được thực hiện ở chế độ offline (mặc định: false)

## Xử lý ngoại lệ
- Ném ngoại lệ `KvValidateRetailerException` nếu thao tác xóa không hợp lệ với thông báo chứa giới hạn tháng cho phép
- Gọi đến phương thức `ThrowUpdatePurchaseDate` để xử lý ngoại lệ cho thao tác cập nhật không hợp lệ

## Dữ liệu kiểm thử

### Tình huống 1: Tính năng kiểm tra không được bật
- ValidateUpdatePurchaseDateToggle: false
- Kết quả: Phương thức kết thúc sớm, không có lỗi

### Tình huống 2: Ngày mua không thay đổi
- purchaseDate: 15/04/2023
- oldPurchaseDate: 15/04/2023
- Kết quả: Không có lỗi, phương thức kết thúc bình thường

### Tình huống 3: Cập nhật ngày mua mới quá xa trong tương lai
- purchaseDate: 15/07/2023
- oldPurchaseDate: 15/04/2023
- MaxMonthUpdatePurchaseDateInvoice: 2
- TypeDirection: Update
- Kết quả: Gọi phương thức ThrowUpdatePurchaseDate để ném ngoại lệ tương ứng

### Tình huống 4: Cập nhật ngày mua mới quá xa trong quá khứ
- purchaseDate: 15/01/2023
- oldPurchaseDate: 15/04/2023
- MaxMonthUpdatePurchaseDateInvoice: 2
- TypeDirection: Update
- Kết quả: Gọi phương thức ThrowUpdatePurchaseDate để ném ngoại lệ tương ứng

### Tình huống 5: Xóa hóa đơn có ngày mua quá xa với ngày hiện tại
- purchaseDate: 15/07/2023
- oldPurchaseDate: 15/04/2023
- MaxMonthUpdatePurchaseDateInvoice: 2
- TypeDirection: Delete
- Kết quả: Ném ngoại lệ KvValidateRetailerException với thông báo chứa giới hạn tháng cho phép 