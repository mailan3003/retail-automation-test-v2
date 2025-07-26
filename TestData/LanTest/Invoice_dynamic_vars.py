# -*- coding: utf-8 -*-
# invoice_dynamic_vars.py
# Nơi định nghĩa các biến phức tạp như INVOICE

# Import thư viện BuiltIn của Robot Framework
from robot.libraries.BuiltIn import BuiltIn

# Hàm này sẽ được gọi bởi Robot Framework và KHÔNG cần nhận đối số
def get_variables():
    # Lấy instance của thư viện BuiltIn
    builtin = BuiltIn()

    # Lấy giá trị của các biến từ môi trường Robot Framework
    # Đảm bảo các biến này đã được định nghĩa trong Env_${ENV}.robot và được tải trước đó
    DEFAULT_BRANCH_ID = int(builtin.get_variable_value("${DEFAULT_BRANCH_ID}"))
    RETAILER_ID = int(builtin.get_variable_value("${RETAILER_ID}"))
    DEFAULT_USER_ID = int(builtin.get_variable_value("${DEFAULT_USER_ID}"))
    DEFAULT_CUSTOMER_ID = int(builtin.get_variable_value("${DEFAULT_CUSTOMER_ID}"))
    DEFAULT_PRODUCT_ID = int(builtin.get_variable_value("${DEFAULT_PRODUCT_ID}"))

    # Định nghĩa các dictionary và list phụ thuộc
    SoldBy = {
        "Id": DEFAULT_USER_ID
    }

    Seller = {
        "Id": DEFAULT_USER_ID
    }

    DETAIL1 = {
        "BasePrice": 6300000,
        "IsLotSerialControl": False,
        "IsBatchExpireControl": False,
        "IsRewardPoint": False,
        "Note": None,
        "Price": 6300000,
        "ProductId": DEFAULT_PRODUCT_ID,
        "Quantity": 1,
        "Weight": 0,
        "OriginPrice": 6300000,
        "PriceByPromotion": None,
        "ProductFormulaHistoryId": None,
        "PromotionParentProductId": None,
        "ProductBatchExpireId": None,
        "MasterProductId": DEFAULT_PRODUCT_ID,
        "Unit": "",
        "ProductWarranty": [],
        "Formulas": None,
        "InvoiceDetailTaxs": [],
        "DetailTaxIds": None
    }

    INVOICE_DETAILS = [DETAIL1]

    SURCHARGE1 = {
        "Code": "THK000001",
        "Name": "Phụ phí",
        "RetailerId": RETAILER_ID,
        "SurValue": 50000,
        "SurchargeBranches": {},
        "SurchargeId": 795,
        "UsageFlag": True,
        "Value": 50000,
        "isAuto": True,
        "Price": 50000
    }

    INVOICE_SURCHARGES = [SURCHARGE1]

    PAYMENT1 = {
        "Method": "Cash",
        "MethodStr": "Tiền mặt",
        "Amount": 6350000,
        "Id": -1,
        "AccountId": None,
        "UsePoint": None
    }

    PAYMENTS = [PAYMENT1]

    # Định nghĩa dictionary INVOICE chính
    INVOICE = {
        "BranchId": DEFAULT_BRANCH_ID,
        "RetailerId": RETAILER_ID,
        "UpdateInvoiceId": 0,
        "UpdateReturnId": 0,
        "CustomerId": DEFAULT_CUSTOMER_ID,
        "SoldById": DEFAULT_USER_ID,
        "SoldBy": SoldBy,
        "SaleChannelId": 0,
        "Seller": Seller,
        "InvoiceDetails": INVOICE_DETAILS,
        "InvoiceOrderSurcharges": INVOICE_SURCHARGES,
        "InvoicePromotions": [],
        "UsingCod": 0,
        "Payments": PAYMENTS,
        "Status": 1,
        "Total": 6350000,
        "TotalTax": None,
        "EnableVATToggle": False,
        "RoundAmount": None,
        "Surcharge": 50000,
        "Type": 1,
        "addToAccount": 0,
        "addToAccountSurplus": 0,
        "addToAccountAllocation": 0,
        "addToAccountPaymentAllocation": 0,
        "PayingAmount": 6350000,
        "TotalBeforeDiscount": 6300000,
        "ProductDiscount": 0,
        "InvoiceWarranties": [],
        "CreatedBy": DEFAULT_USER_ID
    }

    # Trả về một dictionary chứa tất cả các biến bạn muốn Robot Framework sử dụng
    return {
        "INVOICE": INVOICE,
    }
