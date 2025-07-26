*** Settings ***


*** Variables ***

${PRODUCT_ID1}    6326422
${PRODUCT_ID2}    5816657
${PRODUCT_ID3}    2001424958

&{PRODUCT1}    
...    ProductId=${PRODUCT_ID1}
...    ConversionValue=1
...    ProductName=Xoài Tứ Quý
...    ProductCode=SP9934437195
...    BasePrice=89000
...    Price=58000
...    Cost=58000
...    Quantity=1
...    SelectedUnit=6326422
...    Stotal=58000
...    Allocation=2900
...    AllocationSuppliers=483.84
...    OrderByNumber=0

&{PRODUCT2}
...    ProductId=${PRODUCT_ID2}
...    ConversionValue=1
...    ProductName=Redbull
...    ProductCode=SP9934437062
...    BasePrice=10000
...    Price=10000
...    Cost=10000
...    Quantity=1
...    SelectedUnit=5816657
...    Stotal=10000
...    Allocation=500
...    AllocationSuppliers=83.42
...    OrderByNumber=1

&{PRODUCT3}
...    ProductId=${PRODUCT_ID3}
...    ConversionValue=1
...    ProductName=Hộp phở bò phố cổ
...    ProductCode=ggg235325
...    BasePrice=10000
...    Price=8000
...    Cost=8694.38
...    Quantity=1
...    SelectedUnit=2001424958
...    Stotal=8000
...    Allocation=400
...    AllocationSuppliers=66.74
...    OrderByNumber=2


@{PURCHASE_ORDER_DETAILS}
...    &{PRODUCT1}
...    &{PRODUCT2}
...    &{PRODUCT3}

&{SUPPLIER}
...    Id=2001401362
...    Name=Haley
...    Phone=491-469-0696
...    Email=Laverne20@yahoo.com
...    Address=Lueilwitzview
...    Code=NIGILTM1

&{BRANCH}
...    Id=30
...    Name=Chi nhánh trung tâm
...    Address=160 Trần Hưng Đạo
...    LocationName=Hà Nội - Quận Hoàn Kiếm
...    WardName=Phường Đồng Xuân
...    ContactNumber=+84987964658

&{EXPENSE}
...    ExpensesOtherId=1000300566
...    ExValue=634
...    Name=Quitzon
...    Code=LNDUTHQ1

@{PAYMENTS}
...    {'paymentMethod': 'Cash', 'PayingAmount': 50000}

&{PURCHASE_ORDER}
...    PurchaseOrderDetails=@{PURCHASE_ORDER_DETAILS}
...    UserId=510
...    SupplierId=${SUPPLIER['Id']}
...    Supplier=&{SUPPLIER}
...    BranchId=${BRANCH['Id']}
...    Branch=&{BRANCH}
...    SubTotal=76000
...    Discount=3800
...    DiscountRatio=5
...    Total=72834
...    TotalQuantity=3
# ...    PurchaseOrderExpensesOthers=[&{EXPENSE}]
# ...    Payments=${PAYMENTS}
...    PayingAmount=50000
...    Status=3
...    StatusValue=Đã nhập hàng

&{REQUEST_BODY}
...    PurchaseOrder=&{PURCHASE_ORDER}
...    Complete=True
...    CopyFrom=0
...    IsFinalizedOS=False
