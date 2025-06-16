# Tài liệu mô tả cấu trúc của API

Các API được thiết kế với tên thể hiện nghiệp vụ theo cấu trúc `<EntityName>Api` trong đó `EntityName` là tên đối tượng cung cấp API thực hiện các hành động nghiệp vụ lên đối tượng đó và được lưu trong file `EntityNameApi.cs`.

### Ví dụ:
- `OrderAPI` cung cấp các API thực hiện các nghiệp vụ liên quan đến `Order`.  

---

## Entity

Entity là các thực thể nghiệp vụ như `Product`, `Invoice`, `Customer`, và được mô hình hóa qua các class trong namespace `KiotViet.Persistence`.

Tên Entity và các **primitive properties** trong Entity được ánh xạ (map) tương ứng với bảng và các cột (columns) trong CSDL.

### Ví dụ:
- `Order` là thực thể mô hình hóa cho hóa đơn, là một class trong namespace `KiotViet.Persistence`.
- Trường `Id` của `Order` tương ứng với column `Id` trong bảng `Order`.
- Trường `CustomerId` sẽ được map tương ứng với column `CustomerId` trong bảng `Order`.

---

## API Endpoint

Một API như `OrderApi` bao gồm nhiều **endpoint** nằm trong file `OrderApi.cs`. Mỗi endpoint được gắn với một class.

### Ví dụ:

```csharp
[RequiresAnyPermission(Order._Create, Order._Update)]
[Route("/orders", "POST")]
    public class OrderCreateOrUpdate : IReturn<object>
    {
        public Order Order { get; set; }
        public bool Complete { get; set; }
        public bool MakeInvoice { get; set; }
        public decimal Amount { get; set; }
        public IList<Order> Orders { get; set; }
        public bool FromManager { get; set; }
        public bool IsCombine { get; set; }
        public string[] OrderCodes { get; set; }
        public bool UpdateCustomerIdInPayments { get; set; }
        public FBPosParam FBPosParam { get; set; }
    }

```

- Trong đó, `OrderApi` có một endpoint `/orders` được gắn với phương thức `POST`.
- `Orders` được map tương ứng với JSON data mà API tiếp nhận từ client.

> Khi client gửi request body với một JSON object, thì JSON object đó sẽ được ánh xạ (map) tương ứng với các properties của class `Orders`.
