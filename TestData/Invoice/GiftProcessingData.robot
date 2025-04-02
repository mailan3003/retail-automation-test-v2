*** Settings ***
Documentation     Test data cho phần xử lý quà tặng

*** Variables ***
# Thông tin hóa đơn tiêu chuẩn
&{STANDARD_INVOICE}     Code=HD_TEST_GIFT001    BranchId=1    SoldById=1    CustomerId=1    PurchaseDate=2023-04-01    Total=100000

# IDs Sản phẩm mẫu
${PRODUCT_1}            1001
${PRODUCT_2}            1002
${PRODUCT_3}            1003

# Types của các khuyến mãi
${PROMOTION_TYPE_FIXED_AMOUNT}             1
${PROMOTION_TYPE_INVOICE_PRODUCT_GIFT}     2
${PROMOTION_TYPE_PERCENTAGE}               3
${PROMOTION_TYPE_INVOICE_POINT_GIFT}       4
${PROMOTION_TYPE_PRODUCT_DISCOUNT}         5
${PROMOTION_TYPE_PRODUCT_GIFT}             6
${PROMOTION_TYPE_PRODUCT_POINT_GIFT}       7
${PROMOTION_TYPE_INVOICE_DISCOUNT}         8
${PROMOTION_TYPE_INVOICE_VOUCHER_GIFT}     9
${PROMOTION_TYPE_PRODUCT_VOUCHER_GIFT}    10

# Cấu trúc chi tiết sản phẩm tiêu chuẩn
@{STANDARD_INVOICE_DETAILS}    &{PRODUCT_1_DETAIL}

&{PRODUCT_1_DETAIL}    ProductId=${PRODUCT_1}    Quantity=1    Price=100000    DiscountRate=0    DiscountValue=0

# Quà tặng sản phẩm theo hóa đơn
&{INVOICE_WITH_PRODUCT_GIFT}    &{STANDARD_INVOICE}
...                             InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...                             SalePromotions=@{PRODUCT_GIFT_PROMOTIONS}

@{PRODUCT_GIFT_PROMOTIONS}    &{PRODUCT_GIFT_PROMOTION}

&{PRODUCT_GIFT_PROMOTION}    Id=1
...                         PromotionType=${PROMOTION_TYPE_INVOICE_PRODUCT_GIFT}
...                         PromotionData=&{PRODUCT_GIFT_DATA}

&{PRODUCT_GIFT_DATA}    GiftProducts=@{GIFT_PRODUCTS}

@{GIFT_PRODUCTS}    &{GIFT_PRODUCT_1}

&{GIFT_PRODUCT_1}    ProductId=${PRODUCT_2}    Quantity=1

# Quà tặng sản phẩm theo sản phẩm
&{INVOICE_WITH_PRODUCT_GIFT_BY_PRODUCT}    &{STANDARD_INVOICE}
...                                        InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...                                        SalePromotions=@{PRODUCT_GIFT_BY_PRODUCT_PROMOTIONS}

@{PRODUCT_GIFT_BY_PRODUCT_PROMOTIONS}    &{PRODUCT_GIFT_BY_PRODUCT_PROMOTION}

&{PRODUCT_GIFT_BY_PRODUCT_PROMOTION}    Id=2
...                                    PromotionType=${PROMOTION_TYPE_PRODUCT_GIFT}
...                                    ProductId=${PRODUCT_1}
...                                    PromotionData=&{PRODUCT_GIFT_BY_PRODUCT_DATA}

&{PRODUCT_GIFT_BY_PRODUCT_DATA}    GiftProducts=@{GIFT_PRODUCTS}

# Quà tặng Voucher theo hóa đơn
&{INVOICE_WITH_VOUCHER_GIFT}    &{STANDARD_INVOICE}
...                            InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...                            SalePromotions=@{VOUCHER_GIFT_PROMOTIONS}

@{VOUCHER_GIFT_PROMOTIONS}    &{VOUCHER_GIFT_PROMOTION}

&{VOUCHER_GIFT_PROMOTION}    Id=3
...                         PromotionType=${PROMOTION_TYPE_INVOICE_VOUCHER_GIFT}
...                         PromotionData=&{VOUCHER_GIFT_DATA}

&{VOUCHER_GIFT_DATA}    VoucherValue=50000    VoucherQuantity=1    VoucherDaysToExpire=30

# Quà tặng Voucher theo sản phẩm
&{INVOICE_WITH_VOUCHER_GIFT_BY_PRODUCT}    &{STANDARD_INVOICE}
...                                       InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...                                       SalePromotions=@{VOUCHER_GIFT_BY_PRODUCT_PROMOTIONS}

@{VOUCHER_GIFT_BY_PRODUCT_PROMOTIONS}    &{VOUCHER_GIFT_BY_PRODUCT_PROMOTION}

&{VOUCHER_GIFT_BY_PRODUCT_PROMOTION}    Id=4
...                                    PromotionType=${PROMOTION_TYPE_PRODUCT_VOUCHER_GIFT}
...                                    ProductId=${PRODUCT_1}
...                                    PromotionData=&{VOUCHER_GIFT_BY_PRODUCT_DATA}

&{VOUCHER_GIFT_BY_PRODUCT_DATA}    VoucherValue=50000    VoucherQuantity=1    VoucherDaysToExpire=30

# Quà tặng điểm thưởng theo hóa đơn
&{INVOICE_WITH_POINT_GIFT}    &{STANDARD_INVOICE}
...                          InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...                          SalePromotions=@{POINT_GIFT_PROMOTIONS}

@{POINT_GIFT_PROMOTIONS}    &{POINT_GIFT_PROMOTION}

&{POINT_GIFT_PROMOTION}    Id=5
...                       PromotionType=${PROMOTION_TYPE_INVOICE_POINT_GIFT}
...                       PromotionData=&{POINT_GIFT_DATA}

&{POINT_GIFT_DATA}    PointValue=20

# Quà tặng điểm thưởng theo sản phẩm
&{INVOICE_WITH_POINT_GIFT_BY_PRODUCT}    &{STANDARD_INVOICE}
...                                     InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...                                     SalePromotions=@{POINT_GIFT_BY_PRODUCT_PROMOTIONS}

@{POINT_GIFT_BY_PRODUCT_PROMOTIONS}    &{POINT_GIFT_BY_PRODUCT_PROMOTION}

&{POINT_GIFT_BY_PRODUCT_PROMOTION}    Id=6
...                                  PromotionType=${PROMOTION_TYPE_PRODUCT_POINT_GIFT}
...                                  ProductId=${PRODUCT_1}
...                                  PromotionData=&{POINT_GIFT_BY_PRODUCT_DATA}

&{POINT_GIFT_BY_PRODUCT_DATA}    PointValue=15

# Hóa đơn với nhiều loại quà tặng cùng lúc
&{INVOICE_WITH_MULTIPLE_GIFTS}    &{STANDARD_INVOICE}
...                              InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...                              SalePromotions=@{MULTIPLE_GIFT_PROMOTIONS}

@{MULTIPLE_GIFT_PROMOTIONS}    &{PRODUCT_GIFT_PROMOTION}    &{POINT_GIFT_PROMOTION}

# Hóa đơn với quà tặng số lượng lớn
&{INVOICE_WITH_LARGE_QUANTITY_GIFT}    &{STANDARD_INVOICE}
...                                    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...                                    SalePromotions=@{LARGE_QUANTITY_GIFT_PROMOTIONS}

@{LARGE_QUANTITY_GIFT_PROMOTIONS}    &{LARGE_QUANTITY_GIFT_PROMOTION}

&{LARGE_QUANTITY_GIFT_PROMOTION}    Id=7
...                                PromotionType=${PROMOTION_TYPE_INVOICE_PRODUCT_GIFT}
...                                PromotionData=&{LARGE_QUANTITY_GIFT_DATA}

&{LARGE_QUANTITY_GIFT_DATA}    GiftProducts=@{LARGE_QUANTITY_GIFT_PRODUCTS}

@{LARGE_QUANTITY_GIFT_PRODUCTS}    &{LARGE_QUANTITY_GIFT_PRODUCT}

&{LARGE_QUANTITY_GIFT_PRODUCT}    ProductId=${PRODUCT_2}    Quantity=3

# Hóa đơn với nhiều voucher quà tặng
&{INVOICE_WITH_MULTIPLE_VOUCHERS}    &{STANDARD_INVOICE}
...                                 InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...                                 SalePromotions=@{MULTIPLE_VOUCHER_PROMOTIONS}

@{MULTIPLE_VOUCHER_PROMOTIONS}    &{MULTIPLE_VOUCHER_PROMOTION}

&{MULTIPLE_VOUCHER_PROMOTION}    Id=8
...                             PromotionType=${PROMOTION_TYPE_INVOICE_VOUCHER_GIFT}
...                             PromotionData=&{MULTIPLE_VOUCHER_DATA}

&{MULTIPLE_VOUCHER_DATA}    VoucherValue=20000    VoucherQuantity=3    VoucherDaysToExpire=30 