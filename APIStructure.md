# Tài liệu mô tả cấu trúc của API

Các API được thiết kế với tên thể hiện nghiệp vụ theo cấu trúc `<EntityName>Api` trong đó `EntityName` là tên đối tượng cung cấp API thực hiện các hành động nghiệp vụ lên đối tượng đó và được lưu trong file `EntityNameApi.cs`.

### Ví dụ:
- `InvoiceAPI` cung cấp các API thực hiện các nghiệp vụ liên quan đến `Invoice`.  
- `ProductAPI` cung cấp các API thực hiện các nghiệp vụ liên quan đến `Product`.

---

## Entity

Entity là các thực thể nghiệp vụ như `Product`, `Invoice`, `Customer`, và được mô hình hóa qua các class trong namespace `KiotViet.Persistence`.

Tên Entity và các **primitive properties** trong Entity được ánh xạ (map) tương ứng với bảng và các cột (columns) trong CSDL.

### Ví dụ:
- `Invoice` là thực thể mô hình hóa cho hóa đơn, là một class trong namespace `KiotViet.Persistence`.
- Trường `Id` của `Invoice` tương ứng với column `Id` trong bảng `Invoice`.
- Trường `CustomerId` sẽ được map tương ứng với column `CustomerId` trong bảng `Invoice`.

---

## API Endpoint

Một API như `InvoiceApi` bao gồm nhiều **endpoint** nằm trong file `InvoiceApi.cs`. Mỗi endpoint được gắn với một class.

### Ví dụ:

```csharp
[RequiresAnyPermission(Product._Create)]
[Route("/products/addmany", "POST")]
public class ProductAddMany : IRequiresRequestStream, IReturn<object>
{
    public List<ProductByBranchWithWarranty> ListProducts { get; set; }
    public string ListProductsString { get; set; }
    public Stream RequestStream { get; set; }
    public int? PinnedImageId { get; set; }
    public List<long> CommissionIds { get; set; }
    public int CloneProductId { get; set; }
    public List<int> DeletedImageId { get; set; }
    public string ProductImageSuggestUrl { get; set; }
    public List<string> ProductImagesSalesChannelUrl { get; set; }
    public List<SelectedActiveBranches> BranchForProductCosts { get; set; }
    public bool IsUpdateAllSystem { get; set; }
    public bool IsSyncNationalPharmacy { get; set; }
    public List<int> ListBranchsSelected { get; set; }
    public bool isAddFromOtherForm { get; set; }
}
```

- Trong đó, `ProductApi` có một endpoint `/products/addmany` được gắn với phương thức `POST`.
- `ProductAddMany` được map tương ứng với JSON data mà API tiếp nhận từ client.

> Khi client gửi request body với một JSON object, thì JSON object đó sẽ được ánh xạ (map) tương ứng với các properties của class `ProductAddMany`.
