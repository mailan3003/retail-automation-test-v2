-- Enable advanced options to allow extended properties
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
GO

-- Customer Management Tables
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Main table for storing customer information',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Customer';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Unique identifier for the customer',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Customer',
    @level2type = N'COLUMN', @level2name = 'Id';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Customer type (Individual or Business)',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Customer',
    @level2type = N'COLUMN', @level2name = 'Type';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table linking customers to specific branches',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'CustomerBranch';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table for managing customer groups and classifications',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'CustomerGroup';

-- Additional Customer columns
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Customer code for reference',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Customer',
    @level2type = N'COLUMN', @level2name = 'Code';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Customer''s full name',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Customer',
    @level2type = N'COLUMN', @level2name = 'Name';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Customer''s contact phone number',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Customer',
    @level2type = N'COLUMN', @level2name = 'Phone';

-- Product Management Tables
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Main table for storing product information',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Product';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Unique identifier for the product',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Product',
    @level2type = N'COLUMN', @level2name = 'Id';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Product name',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Product',
    @level2type = N'COLUMN', @level2name = 'Name';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table linking products to branches with inventory information',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'ProductBranch';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing product images and media',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'ProductImage';

-- Additional Product columns
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Product code/SKU',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Product',
    @level2type = N'COLUMN', @level2name = 'Code';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Product barcode',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Product',
    @level2type = N'COLUMN', @level2name = 'Barcode';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Product category ID',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Product',
    @level2type = N'COLUMN', @level2name = 'CategoryId';

-- Sales and Invoice Tables
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Main table for storing sales invoice information',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Invoice';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing invoice line items',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'InvoiceDetail';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing tax information for invoice items',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'InvoiceDetailTax';

-- Additional Invoice columns
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Invoice code/number',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Invoice',
    @level2type = N'COLUMN', @level2name = 'Code';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Customer ID for this invoice',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Invoice',
    @level2type = N'COLUMN', @level2name = 'CustomerId';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Branch ID where invoice was created',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Invoice',
    @level2type = N'COLUMN', @level2name = 'BranchId';

-- Order Management Tables
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Main table for storing customer orders',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Order';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing order line items',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'OrderDetail';

-- Additional Order columns
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Order code/number',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Order',
    @level2type = N'COLUMN', @level2name = 'Code';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Customer ID for this order',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Order',
    @level2type = N'COLUMN', @level2name = 'CustomerId';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Branch ID where order was created',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Order',
    @level2type = N'COLUMN', @level2name = 'BranchId';

-- Payment and Financial Tables
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing payment transactions',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Payment';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table linking payments to invoices or orders',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'PaymentAllocation';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing bank account information',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'BankAccount';

-- Additional Payment columns
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Payment code/reference number',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Payment',
    @level2type = N'COLUMN', @level2name = 'Code';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Payment amount',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Payment',
    @level2type = N'COLUMN', @level2name = 'Amount';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Payment method used',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Payment',
    @level2type = N'COLUMN', @level2name = 'Method';

-- Inventory Management Tables
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table tracking inventory movements',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'InventoryTracking';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing batch and expiry information for products',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'BatchExpire';

-- User and Security Tables
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing system user information',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'User';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table defining user roles',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Role';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing system permissions',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Permission';

-- Additional User columns
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) User''s email address',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'User',
    @level2type = N'COLUMN', @level2name = 'Email';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) User''s given name',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'User',
    @level2type = N'COLUMN', @level2name = 'GivenName';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) User''s mobile phone number',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'User',
    @level2type = N'COLUMN', @level2name = 'MobilePhone';

-- Branch Management Tables
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing branch/location information',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Branch';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing branch delivery addresses',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'BranchTakingAddress';

-- Additional Branch columns
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Branch code',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Branch',
    @level2type = N'COLUMN', @level2name = 'Code';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Branch contact number',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Branch',
    @level2type = N'COLUMN', @level2name = 'ContactNumber';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Branch email address',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Branch',
    @level2type = N'COLUMN', @level2name = 'Email';

-- Supplier Management Tables
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing supplier information',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Supplier';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table for managing supplier groups',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'SupplierGroup';

-- Additional Supplier columns
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Supplier code',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Supplier',
    @level2type = N'COLUMN', @level2name = 'Code';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Supplier company name',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Supplier',
    @level2type = N'COLUMN', @level2name = 'Company';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Supplier contact name',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Supplier',
    @level2type = N'COLUMN', @level2name = 'ContactName';

-- Purchase Management Tables
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing purchase orders',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'PurchaseOrder';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing purchase order line items',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'PurchaseOrderDetail';

-- Pricing and Discount Tables
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing price books/price lists',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'PriceBook';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing price book details/prices',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'PriceBookDetail';

-- System Configuration Tables
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing POS system parameters',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'PosParameter';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing currency settings',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'CurrencySetting';

-- Audit and Tracking Tables
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing audit log entries',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'AuditLogTrack';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table tracking system events',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'EventTracking';

-- Inventory and Stock Management Tables
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table for tracking stock takes/inventory counts',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'StockTake';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing stock take line items',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'StockTakeDetail';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table tracking product transfers between branches',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Transfer';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing transfer line items',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'TransferDetail';

-- Promotion and Marketing Tables
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing voucher/coupon definitions',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Voucher';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table linking vouchers to branches',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'VoucherBranch';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing voucher campaigns',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'VoucherCampaign';

-- Point of Sale Tables
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing POS system parameters and settings',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'PosParameter';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing device information',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Device';

-- Financial Management Tables
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing cash flow transactions',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'CashFlow';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing cash flow transaction details',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'CashflowDetail';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing bank account information',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'BankAccount';

-- Pharmacy-specific Tables
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing medicine-specific product information',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'ProductMedicine';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing prescription information',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Prescription';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing prescription details/line items',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'PrescriptionDetail';

-- Location and Address Tables
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing location information',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Location';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing address book entries',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'AddressBook';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing administrative area information',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'AdministrativeArea';

-- Notification and Communication Tables
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing notification settings',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'NotificationSetting';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing SMS and email templates',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'SmsEmailTemplate';

-- System Configuration Tables
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing print templates',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'PrintTemplate';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Table storing export templates',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'ExportTemplate';

-- StockTake columns
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Stock take code/reference number',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'StockTake',
    @level2type = N'COLUMN', @level2name = 'Code';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Branch where stock take was performed',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'StockTake',
    @level2type = N'COLUMN', @level2name = 'BranchId';

-- Transfer columns
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Transfer code/reference number',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Transfer',
    @level2type = N'COLUMN', @level2name = 'Code';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Source branch ID',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Transfer',
    @level2type = N'COLUMN', @level2name = 'FromBranchId';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Destination branch ID',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Transfer',
    @level2type = N'COLUMN', @level2name = 'ToBranchId';

-- Voucher columns
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Voucher code',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Voucher',
    @level2type = N'COLUMN', @level2name = 'Code';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Voucher value/amount',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Voucher',
    @level2type = N'COLUMN', @level2name = 'Value';

-- CashFlow columns
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Cash flow transaction code',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'CashFlow',
    @level2type = N'COLUMN', @level2name = 'Code';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Transaction amount',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'CashFlow',
    @level2type = N'COLUMN', @level2name = 'Amount';

-- Prescription columns
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Prescription code/number',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Prescription',
    @level2type = N'COLUMN', @level2name = 'Code';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Patient ID',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Prescription',
    @level2type = N'COLUMN', @level2name = 'PatientId';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Doctor ID',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Prescription',
    @level2type = N'COLUMN', @level2name = 'DoctorId';

-- Location columns
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Location name',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Location',
    @level2type = N'COLUMN', @level2name = 'Name';

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'(AI generated) Parent location ID',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'Location',
    @level2type = N'COLUMN', @level2name = 'ParentId';

-- Common audit columns for all tables
DECLARE @TableName NVARCHAR(128)
DECLARE table_cursor CURSOR FOR 
SELECT t.name 
FROM sys.tables t
WHERE t.name NOT LIKE 'backup%'
    AND t.name NOT LIKE 'test%'
    AND t.name NOT LIKE '%_test'
    AND t.name NOT LIKE '%_backup'
    AND t.name NOT LIKE '%_bk'
    AND t.name NOT LIKE '%_copy'
ORDER BY t.name

OPEN table_cursor
FETCH NEXT FROM table_cursor INTO @TableName

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Add CreatedDate description
    EXEC sys.sp_addextendedproperty 
        @name = N'MS_Description',
        @value = N'(AI generated) Date and time when the record was created',
        @level0type = N'SCHEMA', @level0name = 'dbo',
        @level1type = N'TABLE',  @level1name = @TableName,
        @level2type = N'COLUMN', @level2name = 'CreatedDate';

    -- Add CreatedBy description
    EXEC sys.sp_addextendedproperty 
        @name = N'MS_Description',
        @value = N'(AI generated) User ID who created the record',
        @level0type = N'SCHEMA', @level0name = 'dbo',
        @level1type = N'TABLE',  @level1name = @TableName,
        @level2type = N'COLUMN', @level2name = 'CreatedBy';

    -- Add ModifiedDate description
    EXEC sys.sp_addextendedproperty 
        @name = N'MS_Description',
        @value = N'(AI generated) Date and time when the record was last modified',
        @level0type = N'SCHEMA', @level0name = 'dbo',
        @level1type = N'TABLE',  @level1name = @TableName,
        @level2type = N'COLUMN', @level2name = 'ModifiedDate';

    -- Add ModifiedBy description
    EXEC sys.sp_addextendedproperty 
        @name = N'MS_Description',
        @value = N'(AI generated) User ID who last modified the record',
        @level0type = N'SCHEMA', @level0name = 'dbo',
        @level1type = N'TABLE',  @level1name = @TableName,
        @level2type = N'COLUMN', @level2name = 'ModifiedBy';

    FETCH NEXT FROM table_cursor INTO @TableName
END

CLOSE table_cursor
DEALLOCATE table_cursor 

-- Category and Attribute Tables
EXEC sp_addextendedproperty 'MS_Description', 'Table for managing product categories and hierarchical category structure', 'SCHEMA', 'dbo', 'TABLE', 'Category';
EXEC sp_addextendedproperty 'MS_Description', 'Parent category ID for hierarchical structure', 'SCHEMA', 'dbo', 'TABLE', 'Category', 'COLUMN', 'ParentId';
EXEC sp_addextendedproperty 'MS_Description', 'Category name', 'SCHEMA', 'dbo', 'TABLE', 'Category', 'COLUMN', 'Name';
EXEC sp_addextendedproperty 'MS_Description', 'Category code for reference', 'SCHEMA', 'dbo', 'TABLE', 'Category', 'COLUMN', 'Code';

EXEC sp_addextendedproperty 'MS_Description', 'Table for storing product attributes/characteristics', 'SCHEMA', 'dbo', 'TABLE', 'Attribute';
EXEC sp_addextendedproperty 'MS_Description', 'Attribute name', 'SCHEMA', 'dbo', 'TABLE', 'Attribute', 'COLUMN', 'Name';
EXEC sp_addextendedproperty 'MS_Description', 'Attribute value type (text, number, etc.)', 'SCHEMA', 'dbo', 'TABLE', 'Attribute', 'COLUMN', 'ValueType';

-- Warehouse and Inventory Tables
EXEC sp_addextendedproperty 'MS_Description', 'Table for managing physical warehouses', 'SCHEMA', 'dbo', 'TABLE', 'Warehouse';
EXEC sp_addextendedproperty 'MS_Description', 'Warehouse name', 'SCHEMA', 'dbo', 'TABLE', 'Warehouse', 'COLUMN', 'Name';
EXEC sp_addextendedproperty 'MS_Description', 'Warehouse address', 'SCHEMA', 'dbo', 'TABLE', 'Warehouse', 'COLUMN', 'Address';
EXEC sp_addextendedproperty 'MS_Description', 'Branch ID this warehouse belongs to', 'SCHEMA', 'dbo', 'TABLE', 'Warehouse', 'COLUMN', 'BranchId';

EXEC sp_addextendedproperty 'MS_Description', 'Table for tracking inventory movements in warehouses', 'SCHEMA', 'dbo', 'TABLE', 'WarehouseInventoryTracking';
EXEC sp_addextendedproperty 'MS_Description', 'Product ID being tracked', 'SCHEMA', 'dbo', 'TABLE', 'WarehouseInventoryTracking', 'COLUMN', 'ProductId';
EXEC sp_addextendedproperty 'MS_Description', 'Warehouse ID where movement occurred', 'SCHEMA', 'dbo', 'TABLE', 'WarehouseInventoryTracking', 'COLUMN', 'WarehouseId';
EXEC sp_addextendedproperty 'MS_Description', 'Quantity changed (+/-)', 'SCHEMA', 'dbo', 'TABLE', 'WarehouseInventoryTracking', 'COLUMN', 'Quantity';

-- Customer and Supplier Grouping Tables
EXEC sp_addextendedproperty 'MS_Description', 'Table for managing customer group details and membership', 'SCHEMA', 'dbo', 'TABLE', 'CustomerGroupDetail';
EXEC sp_addextendedproperty 'MS_Description', 'Customer group ID', 'SCHEMA', 'dbo', 'TABLE', 'CustomerGroupDetail', 'COLUMN', 'CustomerGroupId';
EXEC sp_addextendedproperty 'MS_Description', 'Customer ID belonging to group', 'SCHEMA', 'dbo', 'TABLE', 'CustomerGroupDetail', 'COLUMN', 'CustomerId';

EXEC sp_addextendedproperty 'MS_Description', 'Table for managing supplier group details and membership', 'SCHEMA', 'dbo', 'TABLE', 'SupplierGroupDetail';
EXEC sp_addextendedproperty 'MS_Description', 'Supplier group ID', 'SCHEMA', 'dbo', 'TABLE', 'SupplierGroupDetail', 'COLUMN', 'SupplierGroupId';
EXEC sp_addextendedproperty 'MS_Description', 'Supplier ID belonging to group', 'SCHEMA', 'dbo', 'TABLE', 'SupplierGroupDetail', 'COLUMN', 'SupplierId';

-- Financial Tracking Tables
EXEC sp_addextendedproperty 'MS_Description', 'Table for tracking customer and supplier balance changes', 'SCHEMA', 'dbo', 'TABLE', 'BalanceCustomerSupplierTracking';
EXEC sp_addextendedproperty 'MS_Description', 'Reference ID (Customer/Supplier)', 'SCHEMA', 'dbo', 'TABLE', 'BalanceCustomerSupplierTracking', 'COLUMN', 'ReferenceId';
EXEC sp_addextendedproperty 'MS_Description', 'Type of entity (Customer/Supplier)', 'SCHEMA', 'dbo', 'TABLE', 'BalanceCustomerSupplierTracking', 'COLUMN', 'Type';
EXEC sp_addextendedproperty 'MS_Description', 'Amount changed (+/-)', 'SCHEMA', 'dbo', 'TABLE', 'BalanceCustomerSupplierTracking', 'COLUMN', 'Amount';

-- Business Settings Tables
EXEC sp_addextendedproperty 'MS_Description', 'Table for storing POS system parameters and settings', 'SCHEMA', 'dbo', 'TABLE', 'PosParameter';
EXEC sp_addextendedproperty 'MS_Description', 'Parameter key/name', 'SCHEMA', 'dbo', 'TABLE', 'PosParameter', 'COLUMN', 'Name';
EXEC sp_addextendedproperty 'MS_Description', 'Parameter value', 'SCHEMA', 'dbo', 'TABLE', 'PosParameter', 'COLUMN', 'Value';
EXEC sp_addextendedproperty 'MS_Description', 'Parameter data type', 'SCHEMA', 'dbo', 'TABLE', 'PosParameter', 'COLUMN', 'DataType';

EXEC sp_addextendedproperty 'MS_Description', 'Table for managing currency settings and configurations', 'SCHEMA', 'dbo', 'TABLE', 'CurrencySetting';
EXEC sp_addextendedproperty 'MS_Description', 'Currency code (e.g., USD, VND)', 'SCHEMA', 'dbo', 'TABLE', 'CurrencySetting', 'COLUMN', 'Code';
EXEC sp_addextendedproperty 'MS_Description', 'Currency symbol', 'SCHEMA', 'dbo', 'TABLE', 'CurrencySetting', 'COLUMN', 'Symbol';
EXEC sp_addextendedproperty 'MS_Description', 'Number of decimal places', 'SCHEMA', 'dbo', 'TABLE', 'CurrencySetting', 'COLUMN', 'DecimalPlaces';

-- Manufacturing and Formula Tables
EXEC sp_addextendedproperty 'MS_Description', 'Table for managing product manufacturing/assembly processes', 'SCHEMA', 'dbo', 'TABLE', 'Manufacturing';
EXEC sp_addextendedproperty 'MS_Description', 'Manufacturing code/reference', 'SCHEMA', 'dbo', 'TABLE', 'Manufacturing', 'COLUMN', 'Code';
EXEC sp_addextendedproperty 'MS_Description', 'Branch where manufacturing occurs', 'SCHEMA', 'dbo', 'TABLE', 'Manufacturing', 'COLUMN', 'BranchId';
EXEC sp_addextendedproperty 'MS_Description', 'Total cost of manufacturing', 'SCHEMA', 'dbo', 'TABLE', 'Manufacturing', 'COLUMN', 'TotalCost';

EXEC sp_addextendedproperty 'MS_Description', 'Table for storing product manufacturing formulas/recipes', 'SCHEMA', 'dbo', 'TABLE', 'ProductFormula';
EXEC sp_addextendedproperty 'MS_Description', 'Product ID being manufactured', 'SCHEMA', 'dbo', 'TABLE', 'ProductFormula', 'COLUMN', 'ProductId';
EXEC sp_addextendedproperty 'MS_Description', 'Material product ID used in formula', 'SCHEMA', 'dbo', 'TABLE', 'ProductFormula', 'COLUMN', 'MaterialId';
EXEC sp_addextendedproperty 'MS_Description', 'Quantity of material needed', 'SCHEMA', 'dbo', 'TABLE', 'ProductFormula', 'COLUMN', 'Quantity';

-- Delivery and Shipping Tables
EXEC sp_addextendedproperty 'MS_Description', 'Table for managing delivery partners', 'SCHEMA', 'dbo', 'TABLE', 'PartnerDelivery';
EXEC sp_addextendedproperty 'MS_Description', 'Partner name', 'SCHEMA', 'dbo', 'TABLE', 'PartnerDelivery', 'COLUMN', 'Name';
EXEC sp_addextendedproperty 'MS_Description', 'Partner code', 'SCHEMA', 'dbo', 'TABLE', 'PartnerDelivery', 'COLUMN', 'Code';
EXEC sp_addextendedproperty 'MS_Description', 'Integration type/method', 'SCHEMA', 'dbo', 'TABLE', 'PartnerDelivery', 'COLUMN', 'IntegrationType';

EXEC sp_addextendedproperty 'MS_Description', 'Table for managing shipping tasks/deliveries', 'SCHEMA', 'dbo', 'TABLE', 'ShippingTask';
EXEC sp_addextendedproperty 'MS_Description', 'Task code/reference', 'SCHEMA', 'dbo', 'TABLE', 'ShippingTask', 'COLUMN', 'Code';
EXEC sp_addextendedproperty 'MS_Description', 'Delivery partner ID', 'SCHEMA', 'dbo', 'TABLE', 'ShippingTask', 'COLUMN', 'PartnerId';
EXEC sp_addextendedproperty 'MS_Description', 'Current status of shipping task', 'SCHEMA', 'dbo', 'TABLE', 'ShippingTask', 'COLUMN', 'Status';

-- Marketing and Promotion Tables
EXEC sp_addextendedproperty 'MS_Description', 'Table for managing email marketing campaigns', 'SCHEMA', 'dbo', 'TABLE', 'EmailMarketing';
EXEC sp_addextendedproperty 'MS_Description', 'Campaign name', 'SCHEMA', 'dbo', 'TABLE', 'EmailMarketing', 'COLUMN', 'Name';
EXEC sp_addextendedproperty 'MS_Description', 'Email subject', 'SCHEMA', 'dbo', 'TABLE', 'EmailMarketing', 'COLUMN', 'Subject';
EXEC sp_addextendedproperty 'MS_Description', 'Campaign status', 'SCHEMA', 'dbo', 'TABLE', 'EmailMarketing', 'COLUMN', 'Status';

EXEC sp_addextendedproperty 'MS_Description', 'Table for managing SMS and email templates', 'SCHEMA', 'dbo', 'TABLE', 'SmsEmailTemplate';
EXEC sp_addextendedproperty 'MS_Description', 'Template name', 'SCHEMA', 'dbo', 'TABLE', 'SmsEmailTemplate', 'COLUMN', 'Name';
EXEC sp_addextendedproperty 'MS_Description', 'Template content', 'SCHEMA', 'dbo', 'TABLE', 'SmsEmailTemplate', 'COLUMN', 'Content';
EXEC sp_addextendedproperty 'MS_Description', 'Template type (SMS/Email)', 'SCHEMA', 'dbo', 'TABLE', 'SmsEmailTemplate', 'COLUMN', 'Type';

-- Medical/Pharmacy Tables
EXEC sp_addextendedproperty 'MS_Description', 'Table for storing medicine manufacturer information', 'SCHEMA', 'dbo', 'TABLE', 'MedicineManufacturer';
EXEC sp_addextendedproperty 'MS_Description', 'Manufacturer name', 'SCHEMA', 'dbo', 'TABLE', 'MedicineManufacturer', 'COLUMN', 'Name';
EXEC sp_addextendedproperty 'MS_Description', 'License number', 'SCHEMA', 'dbo', 'TABLE', 'MedicineManufacturer', 'COLUMN', 'LicenseNumber';
EXEC sp_addextendedproperty 'MS_Description', 'Country of origin', 'SCHEMA', 'dbo', 'TABLE', 'MedicineManufacturer', 'COLUMN', 'Country';

EXEC sp_addextendedproperty 'MS_Description', 'Table for storing doctor information', 'SCHEMA', 'dbo', 'TABLE', 'Doctor';
EXEC sp_addextendedproperty 'MS_Description', 'Doctor name', 'SCHEMA', 'dbo', 'TABLE', 'Doctor', 'COLUMN', 'Name';
EXEC sp_addextendedproperty 'MS_Description', 'License number', 'SCHEMA', 'dbo', 'TABLE', 'Doctor', 'COLUMN', 'LicenseNumber';
EXEC sp_addextendedproperty 'MS_Description', 'Specialization', 'SCHEMA', 'dbo', 'TABLE', 'Doctor', 'COLUMN', 'Specialization';

-- System Audit and Tracking Tables
EXEC sp_addextendedproperty 'MS_Description', 'Table for tracking system audit logs', 'SCHEMA', 'dbo', 'TABLE', 'AuditLogTrack';
EXEC sp_addextendedproperty 'MS_Description', 'Action performed', 'SCHEMA', 'dbo', 'TABLE', 'AuditLogTrack', 'COLUMN', 'Action';
EXEC sp_addextendedproperty 'MS_Description', 'Entity type affected', 'SCHEMA', 'dbo', 'TABLE', 'AuditLogTrack', 'COLUMN', 'EntityType';
EXEC sp_addextendedproperty 'MS_Description', 'Entity ID affected', 'SCHEMA', 'dbo', 'TABLE', 'AuditLogTrack', 'COLUMN', 'EntityId';
EXEC sp_addextendedproperty 'MS_Description', 'Changes made in JSON format', 'SCHEMA', 'dbo', 'TABLE', 'AuditLogTrack', 'COLUMN', 'Changes';

EXEC sp_addextendedproperty 'MS_Description', 'Table for tracking event-based system activities', 'SCHEMA', 'dbo', 'TABLE', 'EventTracking';
EXEC sp_addextendedproperty 'MS_Description', 'Event type/name', 'SCHEMA', 'dbo', 'TABLE', 'EventTracking', 'COLUMN', 'EventType';
EXEC sp_addextendedproperty 'MS_Description', 'Event status', 'SCHEMA', 'dbo', 'TABLE', 'EventTracking', 'COLUMN', 'Status';
EXEC sp_addextendedproperty 'MS_Description', 'Event data in JSON format', 'SCHEMA', 'dbo', 'TABLE', 'EventTracking', 'COLUMN', 'Data';

-- Point of Sale and Retail Tables
EXEC sp_addextendedproperty 'MS_Description', 'Table for managing tables and rooms in restaurants/cafes', 'SCHEMA', 'dbo', 'TABLE', 'TableAndRoom';
EXEC sp_addextendedproperty 'MS_Description', 'Table/room name', 'SCHEMA', 'dbo', 'TABLE', 'TableAndRoom', 'COLUMN', 'Name';
EXEC sp_addextendedproperty 'MS_Description', 'Table/room status', 'SCHEMA', 'dbo', 'TABLE', 'TableAndRoom', 'COLUMN', 'Status';
EXEC sp_addextendedproperty 'MS_Description', 'Seating capacity', 'SCHEMA', 'dbo', 'TABLE', 'TableAndRoom', 'COLUMN', 'Capacity';

EXEC sp_addextendedproperty 'MS_Description', 'Table for managing product shelves/locations in store', 'SCHEMA', 'dbo', 'TABLE', 'ProductShelves';
EXEC sp_addextendedproperty 'MS_Description', 'Product ID', 'SCHEMA', 'dbo', 'TABLE', 'ProductShelves', 'COLUMN', 'ProductId';
EXEC sp_addextendedproperty 'MS_Description', 'Shelf ID', 'SCHEMA', 'dbo', 'TABLE', 'ProductShelves', 'COLUMN', 'ShelfId';
EXEC sp_addextendedproperty 'MS_Description', 'Position on shelf', 'SCHEMA', 'dbo', 'TABLE', 'ProductShelves', 'COLUMN', 'Position';

-- Batch and Expiry Tracking Tables
EXEC sp_addextendedproperty 'MS_Description', 'Table for tracking product batches and expiry dates', 'SCHEMA', 'dbo', 'TABLE', 'BatchExpire';
EXEC sp_addextendedproperty 'MS_Description', 'Batch number/code', 'SCHEMA', 'dbo', 'TABLE', 'BatchExpire', 'COLUMN', 'BatchNumber';
EXEC sp_addextendedproperty 'MS_Description', 'Manufacturing date', 'SCHEMA', 'dbo', 'TABLE', 'BatchExpire', 'COLUMN', 'ManufacturingDate';
EXEC sp_addextendedproperty 'MS_Description', 'Expiry date', 'SCHEMA', 'dbo', 'TABLE', 'BatchExpire', 'COLUMN', 'ExpiryDate';

EXEC sp_addextendedproperty 'MS_Description', 'Table for tracking batch movements and transactions', 'SCHEMA', 'dbo', 'TABLE', 'BatchExpireTracking';
EXEC sp_addextendedproperty 'MS_Description', 'Batch ID', 'SCHEMA', 'dbo', 'TABLE', 'BatchExpireTracking', 'COLUMN', 'BatchId';
EXEC sp_addextendedproperty 'MS_Description', 'Transaction type', 'SCHEMA', 'dbo', 'TABLE', 'BatchExpireTracking', 'COLUMN', 'Type';
EXEC sp_addextendedproperty 'MS_Description', 'Quantity changed', 'SCHEMA', 'dbo', 'TABLE', 'BatchExpireTracking', 'COLUMN', 'Quantity';

-- Tax and Financial Reporting Tables
EXEC sp_addextendedproperty 'MS_Description', 'Table for managing tax rates and configurations', 'SCHEMA', 'dbo', 'TABLE', 'Tax';
EXEC sp_addextendedproperty 'MS_Description', 'Tax name/description', 'SCHEMA', 'dbo', 'TABLE', 'Tax', 'COLUMN', 'Name';
EXEC sp_addextendedproperty 'MS_Description', 'Tax rate percentage', 'SCHEMA', 'dbo', 'TABLE', 'Tax', 'COLUMN', 'Rate';
EXEC sp_addextendedproperty 'MS_Description', 'Tax type/category', 'SCHEMA', 'dbo', 'TABLE', 'Tax', 'COLUMN', 'Type';

EXEC sp_addextendedproperty 'MS_Description', 'Table for storing financial reports', 'SCHEMA', 'dbo', 'TABLE', 'biplatform_financial_report';
EXEC sp_addextendedproperty 'MS_Description', 'Report type', 'SCHEMA', 'dbo', 'TABLE', 'biplatform_financial_report', 'COLUMN', 'ReportType';
EXEC sp_addextendedproperty 'MS_Description', 'Report period', 'SCHEMA', 'dbo', 'TABLE', 'biplatform_financial_report', 'COLUMN', 'Period';
EXEC sp_addextendedproperty 'MS_Description', 'Report data in JSON format', 'SCHEMA', 'dbo', 'TABLE', 'biplatform_financial_report', 'COLUMN', 'Data';

-- User Access and Permissions Tables
EXEC sp_addextendedproperty 'MS_Description', 'Table for managing object-level access permissions', 'SCHEMA', 'dbo', 'TABLE', 'ObjectAccess';
EXEC sp_addextendedproperty 'MS_Description', 'Object type', 'SCHEMA', 'dbo', 'TABLE', 'ObjectAccess', 'COLUMN', 'ObjectType';
EXEC sp_addextendedproperty 'MS_Description', 'Object ID', 'SCHEMA', 'dbo', 'TABLE', 'ObjectAccess', 'COLUMN', 'ObjectId';
EXEC sp_addextendedproperty 'MS_Description', 'Access level/type', 'SCHEMA', 'dbo', 'TABLE', 'ObjectAccess', 'COLUMN', 'AccessType';

EXEC sp_addextendedproperty 'MS_Description', 'Table for tracking user password changes', 'SCHEMA', 'dbo', 'TABLE', 'UserPasswordChangeHistory';
EXEC sp_addextendedproperty 'MS_Description', 'User ID', 'SCHEMA', 'dbo', 'TABLE', 'UserPasswordChangeHistory', 'COLUMN', 'UserId';
EXEC sp_addextendedproperty 'MS_Description', 'Change date/time', 'SCHEMA', 'dbo', 'TABLE', 'UserPasswordChangeHistory', 'COLUMN', 'ChangeDate';
EXEC sp_addextendedproperty 'MS_Description', 'Change reason', 'SCHEMA', 'dbo', 'TABLE', 'UserPasswordChangeHistory', 'COLUMN', 'Reason';

-- System Configuration Tables
EXEC sp_addextendedproperty 'MS_Description', 'Table for managing automatic code generation rules', 'SCHEMA', 'dbo', 'TABLE', 'AutoGenCodeRules';
EXEC sp_addextendedproperty 'MS_Description', 'Rule name/description', 'SCHEMA', 'dbo', 'TABLE', 'AutoGenCodeRules', 'COLUMN', 'Name';
EXEC sp_addextendedproperty 'MS_Description', 'Code prefix', 'SCHEMA', 'dbo', 'TABLE', 'AutoGenCodeRules', 'COLUMN', 'Prefix';
EXEC sp_addextendedproperty 'MS_Description', 'Number format', 'SCHEMA', 'dbo', 'TABLE', 'AutoGenCodeRules', 'COLUMN', 'Format';

EXEC sp_addextendedproperty 'MS_Description', 'Table for storing notification settings and preferences', 'SCHEMA', 'dbo', 'TABLE', 'NotificationSetting';
EXEC sp_addextendedproperty 'MS_Description', 'Setting name/key', 'SCHEMA', 'dbo', 'TABLE', 'NotificationSetting', 'COLUMN', 'Name';
EXEC sp_addextendedproperty 'MS_Description', 'Setting value', 'SCHEMA', 'dbo', 'TABLE', 'NotificationSetting', 'COLUMN', 'Value';
EXEC sp_addextendedproperty 'MS_Description', 'Setting scope/context', 'SCHEMA', 'dbo', 'TABLE', 'NotificationSetting', 'COLUMN', 'Scope'; 