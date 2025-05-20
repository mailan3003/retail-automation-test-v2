# Phương thức ValidCloseDate

## Mục đích
Phương thức này kiểm tra xem một ngày giao dịch có hợp lệ không dựa trên ngày khóa sổ của chi nhánh. Nếu ngày giao dịch nhỏ hơn ngày khóa sổ, hệ thống sẽ hiển thị thông báo lỗi.

## Quy trình
1. Kiểm tra xem tính năng khóa sổ có được bật không (thông qua `PosSetting.BookClosing`)
2. Nếu `transDate` là ngày mặc định, phương thức kết thúc
3. Nếu không có ngày khóa sổ (closeDate), lấy ngày khóa sổ từ chi nhánh
4. Chuyển đổi ngày khóa sổ sang múi giờ UTC+7 nếu cần
5. So sánh ngày giao dịch với ngày khóa sổ và ném ngoại lệ nếu ngày giao dịch nhỏ hơn

## Tham số
- `transDate` (DateTime?): Ngày giao dịch cần kiểm tra
- `msg` (string): Thông báo lỗi sẽ hiển thị nếu kiểm tra thất bại
- `branchId` (long?): ID chi nhánh cần kiểm tra
- `isUpdateWithTimeZone` (bool): Có áp dụng chuyển đổi múi giờ hay không (mặc định: true)
- `addToMsg` (string): Thông tin bổ sung cho thông báo lỗi (mặc định: chuỗi rỗng)
- `closeDate` (DateTime): Ngày khóa sổ được chỉ định tường minh (mặc định: lấy từ chi nhánh)

## Xử lý ngoại lệ
- Ném ngoại lệ `KvCloseBookException` nếu ngày giao dịch nhỏ hơn ngày khóa sổ, với thông báo lỗi bao gồm ngày khóa sổ được định dạng theo quy tắc địa phương

## Mã nguồn

```csharp
public async Task ValidCloseDate(DateTime? transDate, string msg, long? branchId, bool isUpdateWithTimeZone = true, string addToMsg = "", DateTime closeDate = default(DateTime))
{
    if (PosSetting == null) return;
    if (!PosSetting.BookClosing) return;
    if (transDate == default(DateTime)) return;
    if (closeDate == default(DateTime)) closeDate = (await GetBookCloseDate(branchId)) ?? default(DateTime);
    if (closeDate == default(DateTime)) return;
    // for timezone
    var closeDateUtcPlus7 = isUpdateWithTimeZone ? KvTimeZone.DateFormatFromTimezoneOfBranchToUTCPlus7(closeDate) : closeDate;
    if (closeDateUtcPlus7 > transDate)
    {
        var datetimeFormat = HostContext.TryResolve<KvCountryDateFormat>();
        var shortDatePattern = datetimeFormat?.ShortDatePattern ?? "dd/MM/yyyy";
        throw new KvCloseBookException($"{msg} {closeDate.ToString(shortDatePattern)}{addToMsg}");
    }
}
```

## Dữ liệu kiểm thử

### Tình huống 1: Ngày giao dịch hợp lệ (sau ngày khóa sổ)
- transDate: 15/04/2023
- Ngày khóa sổ: 10/04/2023
- Kết quả: Không có lỗi, phương thức kết thúc bình thường

### Tình huống 2: Ngày giao dịch không hợp lệ (trước ngày khóa sổ)
- transDate: 05/04/2023
- Ngày khóa sổ: 10/04/2023
- Kết quả: Ném ngoại lệ KvCloseBookException với thông báo chứa ngày khóa sổ

### Tình huống 3: Tính năng khóa sổ không được bật
- PosSetting.BookClosing: false
- Kết quả: Phương thức kết thúc sớm, không có lỗi

### Tình huống 4: Ngày khóa sổ được chỉ định rõ ràng
- closeDate: 10/04/2023 (tham số đầu vào)
- Kết quả: Sử dụng ngày được chỉ định thay vì lấy từ cơ sở dữ liệu 