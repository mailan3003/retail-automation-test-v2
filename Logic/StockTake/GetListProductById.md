# Truy vấn thông tin sản phẩm trong GetListProductById

## Mục đích
Phương thức `GetListProductById` trong lớp `StockTakeService` có nhiệm vụ truy vấn và lấy thông tin chi tiết của nhiều sản phẩm từ cơ sở dữ liệu dựa trên danh sách ID sản phẩm được cung cấp. Phương thức này xử lý việc truy vấn một cách hiệu quả, đặc biệt khi đối mặt với danh sách ID sản phẩm lớn.

## Quy trình chính

### 1. Khởi tạo danh sách kết quả
- Tạo một danh sách rỗng để lưu trữ thông tin sản phẩm được truy vấn:
  ```csharp
  var lsProductStockStakeInfo = new List<ProductStockStakeInfo>();
  ```

### 2. Xử lý danh sách ID lớn
- Kiểm tra số lượng ID sản phẩm và chia thành các nhóm nhỏ hơn nếu cần thiết:
  ```csharp
  if (lstProductId.Count > SqlExceptionHelper.MaxIdParamsIQueryableExtensions)
  {
      var listGroupId = lstProductId
          .Select((x, i) => new { Index = i, Value = x })
          .GroupBy(x => x.Index / SqlExceptionHelper.MaxIdParamsIQueryableExtensions)
          .Select(x => x.Select(v => v.Value).ToList())
          .ToList();
  }
  ```

### 3. Truy vấn tuần tự từng nhóm ID sản phẩm
- Lặp qua từng nhóm ID sản phẩm và thực hiện truy vấn LINQ:
  ```csharp
  foreach (var groupId in listGroupId)
  {
      var sublsProductStockStakeInfo = await ProductService.GetAll()
          .WhereIn(groupId, p => p.Id)
          .Select(x => new ProductStockStakeInfo
          {
              Id = x.Id,
              Code = x.Code,
              IsLotSerialControl = x.IsLotSerialControl,
              ConversionValue = ((x.MasterUnitId != null) ? x.ConversionValue : 1),
              MasterUnitId = x.MasterUnitId,
              IsBatchExpireControl = x.IsBatchExpireControl
          }).ToListAsync();
          
      if (sublsProductStockStakeInfo != null && sublsProductStockStakeInfo.Any())
      {
          lsProductStockStakeInfo.AddRange(sublsProductStockStakeInfo);
      }
  }
  ```

### 4. Xử lý danh sách ID nhỏ
- Nếu số lượng ID không vượt quá giới hạn, thực hiện truy vấn trực tiếp:
  ```csharp
  else
  {
      lsProductStockStakeInfo = await ProductService.GetAll()
          .Where(p => lstProductId.Contains(p.Id))
          .Select(x => new ProductStockStakeInfo
          {
              Id = x.Id,
              Code = x.Code,
              IsLotSerialControl = x.IsLotSerialControl,
              ConversionValue = ((x.MasterUnitId != null) ? x.ConversionValue : 1),
              MasterUnitId = x.MasterUnitId,
              IsBatchExpireControl = x.IsBatchExpireControl
          }).ToListAsync();
  }
  ```

## Phụ thuộc

### Dịch vụ và lớp tiện ích
- **ProductService**: Cung cấp truy cập đến thông tin sản phẩm trong cơ sở dữ liệu.
- **SqlExceptionHelper**: Cung cấp hằng số `MaxIdParamsIQueryableExtensions` để giới hạn số lượng tham số trong truy vấn SQL.

### Đối tượng dữ liệu
- **ProductStockStakeInfo**: Đối tượng chứa thông tin sản phẩm cần thiết cho phiếu kiểm kho.

## Các quy tắc nghiệp vụ

1. **Quy tắc về chia nhóm ID**:
   - Danh sách ID sản phẩm được chia thành các nhóm nhỏ hơn nếu vượt quá `SqlExceptionHelper.MaxIdParamsIQueryableExtensions`.
   - Sử dụng phương thức `WhereIn` để tối ưu truy vấn cho các nhóm ID.

2. **Quy tắc về truy vấn dữ liệu**:
   - Chỉ lấy các thuộc tính cần thiết: Id, Code, IsLotSerialControl, ConversionValue, MasterUnitId, IsBatchExpireControl.
   - ConversionValue được tính toán dựa trên MasterUnitId: nếu MasterUnitId không null thì lấy ConversionValue, ngược lại là 1.

3. **Quy tắc về xử lý kết quả**:
   - Kiểm tra null và empty trước khi thêm kết quả vào danh sách chính.
   - Sử dụng AddRange để thêm nhiều phần tử cùng lúc.

## Lưu ý quan trọng
1. Phương thức sử dụng `WhereIn` thay vì `Contains` để tối ưu hiệu suất truy vấn.
2. Cách chia nhóm ID giúp tránh vượt quá giới hạn tham số của SQL Server.
3. Chỉ những thuộc tính cần thiết được truy vấn, giúp giảm lượng dữ liệu truyền qua mạng.

## Cấu trúc dữ liệu ProductStockStakeInfo
- **Id**: ID của sản phẩm
- **Code**: Mã sản phẩm
- **IsLotSerialControl**: Cờ xác định sản phẩm có quản lý theo serial hay không
- **ConversionValue**: Hệ số chuyển đổi (1 nếu là đơn vị chính)
- **MasterUnitId**: ID của đơn vị chính (nếu là đơn vị phụ)
- **IsBatchExpireControl**: Cờ xác định sản phẩm có quản lý theo lô/hạn sử dụng hay không