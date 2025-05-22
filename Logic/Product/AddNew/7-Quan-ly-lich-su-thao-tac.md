# Quản lý lịch sử thao tác khi thêm sản phẩm mới

## Giới thiệu
Lịch sử thao tác (audit log) là một phần quan trọng trong hệ thống quản lý hàng hóa, giúp theo dõi và quản lý mọi thay đổi đối với sản phẩm. Khi thêm sản phẩm mới, hệ thống cần ghi lại đầy đủ thông tin để đảm bảo tính minh bạch và truy xuất nguồn gốc. Tài liệu này mô tả chi tiết quy trình ghi lịch sử thao tác khi thêm sản phẩm mới vào hệ thống.

## Quy trình ghi lịch sử thao tác

### 1. Thu thập thông tin cần thiết

```csharp
var lstBranchActive = await BranchService.GetByRetailer(CurrentRetailerId).Where(br => br.LimitAccess == false).ToListAsync();
var lsExitstCategory = await CategoryService.GetAll().AsNoTracking()
    .Select(x => new { x.ParentId, x.Id, x.Name }).ToListAsync();
```
- Lấy danh sách chi nhánh hoạt động của nhà bán lẻ hiện tại
- Lấy danh sách danh mục sản phẩm hiện có trong hệ thống
- Thông tin này sẽ được sử dụng để hiển thị tên chi nhánh và danh mục đầy đủ trong lịch sử thao tác

### 2. Xử lý thông tin bảng giá
```csharp
var session = SessionAs<KVSession>();
if (session?.HasPermission(PriceBook._Read) ?? false)
{
    var lsPriceBookId = listObjReturn.SelectMany(o => o.ListPriceBookDetail != null ? o.ListPriceBookDetail.Select(s => s.PriceBookId) : new List<long>()).ToList();
    lsPriceBook = await PriceBookService.GetAll().WhereIn(lsPriceBookId, pb => pb.Id).ToListAsync();
}
```
- Kiểm tra quyền đọc bảng giá của người dùng hiện tại
- Nếu có quyền: lấy danh sách ID bảng giá từ thông tin sản phẩm và truy vấn thông tin chi tiết
- Thông tin bảng giá sẽ được dùng để ghi vào lịch sử thao tác

### 3. Ghi log cho từng sản phẩm

Hệ thống duyệt qua từng sản phẩm trong danh sách sản phẩm mới thêm và thực hiện ghi log với các bước:

#### 3.1. Thu thập thông tin cơ bản
```csharp
var isLotSerialControl = listObjReturn[i].IsLotSerialControl.Value ? Labels.yes : Labels.no;
var isAllowsSale = listObjReturn[i].AllowsSale ? Labels.yes : Labels.no;
var isRewardPoint = listObjReturn[i].IsRewardPoint == true ? Labels.yes : Labels.no;
var isBatchExpireControl = listObjReturn[i].IsBatchExpireControl == true ? Labels.yes : Labels.no;
```
- Chuyển đổi các cờ tính năng sang dạng "Có/Không" để hiển thị
- Các thông tin này bao gồm: quản lý số serial/IMEI, cho phép bán, tích điểm, quản lý lô hạn sử dụng

#### 3.2. Xử lý thông tin đặc thù theo ngành hàng
```csharp
// Thêm Log Serial/imei
if ((listObjReturn[i].ProductType != null && listObjReturn[i].ProductType == (byte)ProductType.Purchased) && Settings.UseImei)
{
    posLog = $", {Labels.posParameterSerialImei}: {isLotSerialControl}";
}
// Thêm Log Lô, hạn sử dụng
if (Settings.UseBatchExpire)
{
    posLog = $", {Labels.posParameterManageBatchExpire}: {isBatchExpireControl}";
}
```
- Thêm thông tin quản lý IMEI nếu là sản phẩm mua vào và tính năng IMEI được bật
- Thêm thông tin quản lý lô, hạn sử dụng nếu tính năng này được bật trong hệ thống

#### 3.3. Xử lý thông tin bán hàng và tích điểm
```csharp
// Thêm Log bán trực tiếp
posLog += $", {Labels.productAllowSale}: {isAllowsSale}";
// THêm log Tích điểm 
if (Settings.RewardPoint)
{
    posLog += $", {Labels.rewardPoint}: {isRewardPoint ?? string.Empty}";
    if (Settings.RewardPoint_Type == Convert.ToByte(RewardPointType.Product) &&
        listObjReturn[i].IsRewardPoint == true)
    {
        posLog += $", {Labels.productPoint}: {listObjReturn[i].RewardPoint}";
    }
}
```
- Ghi lại thông tin cấu hình bán hàng của sản phẩm: có cho phép bán trực tiếp không
- Nếu tính năng tích điểm được bật: ghi thông tin tích điểm
- Nếu loại tích điểm là theo sản phẩm và sản phẩm được cấu hình tích điểm: thêm thông tin số điểm tích lũy

#### 3.4. Xử lý thông tin thuế
```csharp
if (IsUsingProductVAT && listTaxs.Any() && listObjReturn[i].TaxId.HasValue && listObjReturn[i].TaxId.Value > 0)
{
    var taxLog = listTaxs.Where(a => a.Id == listObjReturn[i].TaxId.Value).FirstOrDefault();
    if(taxLog != null)
    {
        posLog += $", {Labels.Tax}: {taxLog.Name}";
    }
}
```
- Kiểm tra nếu tính năng thuế sản phẩm được bật và sản phẩm có ID thuế hợp lệ
- Tìm thông tin thuế tương ứng từ danh sách thuế đã lấy trước đó
- Thêm thông tin thuế vào nội dung log

### 4. Ghi log cho bảng giá sản phẩm
```csharp
if (listObjReturn[i].ListPriceBookDetail != null)
{
    foreach (var itemPriceBook in listObjReturn[i].ListPriceBookDetail)
    {
        var pricebook = lsPriceBook.FirstOrDefault(pb => pb.Id == itemPriceBook.PriceBookId);
        if (pricebook != null)
        {
            string contentCreatePrice = string.Format(Labels.auditTrailProduct_UpdateProductPrice, pricebook.Name, listObjReturn[i].Code, NormallizeProductPrice((double)(itemPriceBook.Price)));
            var logCreatePrice = new AuditTrailLog
            {
                FunctionId = (int)FunctionType.PriceBook,
                Action = (int)AuditTrailAction.Update,
                BranchId = CurrentBranchId,
                Content = contentCreatePrice,
                TransGuid = itemPriceBook.CrudGuid
            };
            await AuditTrailService.AddLog(logCreatePrice);
        }
    }
}
```
- Duyệt qua từng bảng giá của sản phẩm
- Tìm thông tin chi tiết của bảng giá từ danh sách đã lấy
- Tạo nội dung log cho việc cập nhật giá sản phẩm trong bảng giá
- Ghi log vào hệ thống với loại thao tác là cập nhật bảng giá 

## Điều hướng tài liệu
- Trước đó: [6-Chuc-nang-xu-ly-tim-kiem-va-hoan-tat.md](./6-Chuc-nang-xu-ly-tim-kiem-va-hoan-tat.md)
- Tiếp theo: [8-Xu-ly-thuoc-tinh-dac-thu.md](./8-Xu-ly-thuoc-tinh-dac-thu.md)
- Tổng quan: [0-Tong-quan-Product-AddMany.md](./0-Tong-quan-Product-AddMany.md)