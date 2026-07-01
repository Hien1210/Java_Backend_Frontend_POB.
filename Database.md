-- =============================================
-- 0. TẠO DATABASE
-- =============================================
IF NOT EXISTS (
SELECT * FROM sys.databases
WHERE name = 'POB'
)
BEGIN
CREATE DATABASE POB;
END
GO

USE POB;
GO

-- =============================================
-- XÓA BẢNG CŨ THEO ĐÚNG THỨ TỰ RÀNG BUỘC (Từ ngọn đến gốc)
-- =============================================
DROP TABLE IF EXISTS Order_Logs;
DROP TABLE IF EXISTS Order_Detail_Toppings;
DROP TABLE IF EXISTS Order_Details;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Cart_Item_Toppings;
DROP TABLE IF EXISTS Cart_Items;
DROP TABLE IF EXISTS Carts;
DROP TABLE IF EXISTS Product_Images;
DROP TABLE IF EXISTS Product_Sizes;
DROP TABLE IF EXISTS Toppings;
DROP TABLE IF EXISTS ToppingCategories;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Shops;
DROP TABLE IF EXISTS Shipper_Profiles;
DROP TABLE IF EXISTS User_Addresses;
DROP TABLE IF EXISTS User_Profiles;
DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Roles;
GO

-- =============================================
-- 1. BẢNG ROLES
-- =============================================
CREATE TABLE Roles (
id   BIGINT       PRIMARY KEY IDENTITY(1,1),
name NVARCHAR(50) UNIQUE NOT NULL
);
GO

INSERT INTO Roles (name)
VALUES ('SUPER_ADMIN'), ('ADMIN'), ('USER'), ('SHIPPER');
GO

-- =============================================
-- 2. BẢNG ACCOUNTS (thông tin đăng nhập chung cho mọi role)
-- =============================================
CREATE TABLE Accounts (
id         BIGINT        PRIMARY KEY IDENTITY(1,1),
username   VARCHAR(100)  UNIQUE NOT NULL,
password   VARCHAR(MAX)  NOT NULL,
email      VARCHAR(100)  UNIQUE NOT NULL,
full_name  NVARCHAR(100),
phone      VARCHAR(20),
avatar_url NVARCHAR(MAX),
role_id    BIGINT        NOT NULL,
status     VARCHAR(20)   CHECK (status IN ('ACTIVE', 'PENDING', 'BLOCKED')) DEFAULT 'ACTIVE',
is_deleted BIT           NOT NULL DEFAULT 0,
is_online  BIT           NOT NULL DEFAULT 0,   -- Chỉ dùng cho SHIPPER (bật/tắt sẵn sàng nhận đơn)
created_at DATETIME2     DEFAULT GETDATE(),
updated_at DATETIME2     DEFAULT GETDATE(),
CONSTRAINT FK_Account_Role FOREIGN KEY (role_id) REFERENCES Roles(id)
);
GO

CREATE TRIGGER TR_Accounts_UpdatedAt ON Accounts AFTER UPDATE AS
BEGIN
SET NOCOUNT ON;
IF NOT EXISTS (SELECT 1 FROM inserted i JOIN deleted d ON i.id = d.id WHERE i.updated_at = d.updated_at) RETURN;
UPDATE Accounts SET updated_at = GETDATE() WHERE id IN (SELECT id FROM inserted);
END;
GO

-- =============================================
-- 3. BẢNG USER_PROFILES (thông tin cá nhân mở rộng cho role USER)
-- =============================================
CREATE TABLE User_Profiles (
id                 BIGINT        PRIMARY KEY IDENTITY(1,1),
account_id         BIGINT        NOT NULL UNIQUE,
date_of_birth      DATE          NULL,
gender             VARCHAR(10)   CHECK (gender IN ('MALE', 'FEMALE', 'OTHER')) NULL,
default_address_id BIGINT        NULL,   -- FK sang User_Addresses (set sau khi tạo bảng đó)
created_at         DATETIME2     DEFAULT GETDATE(),
updated_at         DATETIME2     DEFAULT GETDATE(),
CONSTRAINT FK_UserProfile_Account FOREIGN KEY (account_id) REFERENCES Accounts(id)
);
GO

CREATE TRIGGER TR_UserProfiles_UpdatedAt ON User_Profiles AFTER UPDATE AS
BEGIN
SET NOCOUNT ON;
UPDATE User_Profiles SET updated_at = GETDATE() WHERE id IN (SELECT id FROM inserted);
END;
GO

-- =============================================
-- 4. BẢNG USER_ADDRESSES (danh sách địa chỉ giao hàng của USER)
-- =============================================
CREATE TABLE User_Addresses (
id           BIGINT        PRIMARY KEY IDENTITY(1,1),
account_id   BIGINT        NOT NULL,
label        NVARCHAR(100) NULL,            -- Ví dụ: 'Nhà', 'Công ty', 'Trường học'
full_address NVARCHAR(MAX) NOT NULL,
receiver_name  NVARCHAR(100) NULL,          -- Tên người nhận tại địa chỉ này
receiver_phone VARCHAR(20)   NULL,
is_default   BIT           NOT NULL DEFAULT 0,
created_at   DATETIME2     DEFAULT GETDATE(),
CONSTRAINT FK_UserAddress_Account FOREIGN KEY (account_id) REFERENCES Accounts(id) ON DELETE CASCADE
);
GO

CREATE INDEX IDX_UserAddress_Account ON User_Addresses(account_id);
GO

-- Gắn FK default_address_id sau khi User_Addresses đã tồn tại
ALTER TABLE User_Profiles
ADD CONSTRAINT FK_UserProfile_DefaultAddress
    FOREIGN KEY (default_address_id) REFERENCES User_Addresses(id);
GO

-- =============================================
-- 5. BẢNG SHIPPER_PROFILES (thông tin nghề nghiệp & phương tiện của SHIPPER)
-- =============================================
CREATE TABLE Shipper_Profiles (
id             BIGINT        PRIMARY KEY IDENTITY(1,1),
account_id     BIGINT        NOT NULL UNIQUE,
cccd           VARCHAR(20)   NULL,            -- Căn cước công dân
license_number VARCHAR(30)   NULL,            -- Số GPLX
vehicle_type   NVARCHAR(50)  NULL,            -- 'Xe máy', 'Ô tô', 'Xe đạp điện', 'Xe đạp'
vehicle_plate  VARCHAR(20)   NULL,            -- Biển số xe (lưu chữ hoa)
vehicle_model  NVARCHAR(100) NULL,            -- Nhãn hiệu / model xe
bank_account   VARCHAR(30)   NULL,            -- Số tài khoản ngân hàng nhận tiền
bank_name      NVARCHAR(100) NULL,            -- Tên ngân hàng
created_at     DATETIME2     DEFAULT GETDATE(),
updated_at     DATETIME2     DEFAULT GETDATE(),
CONSTRAINT FK_ShipperProfile_Account FOREIGN KEY (account_id) REFERENCES Accounts(id)
);
GO

CREATE TRIGGER TR_ShipperProfiles_UpdatedAt ON Shipper_Profiles AFTER UPDATE AS
BEGIN
SET NOCOUNT ON;
UPDATE Shipper_Profiles SET updated_at = GETDATE() WHERE id IN (SELECT id FROM inserted);
END;
GO

-- =============================================
-- 6. BẢNG SHOPS
-- =============================================
CREATE TABLE Shops (
id               BIGINT        PRIMARY KEY IDENTITY(1,1),
owner_id         BIGINT        NOT NULL,
shop_name        NVARCHAR(255) NOT NULL,
shop_description NVARCHAR(MAX),
shop_address     NVARCHAR(MAX),
shop_phone       VARCHAR(20),
shop_logo        NVARCHAR(MAX),
status           VARCHAR(20)   CHECK (status IN ('PENDING', 'ACTIVE', 'REJECTED', 'BLOCKED')) DEFAULT 'PENDING',
rejection_reason NVARCHAR(MAX),
approved_by      BIGINT        NULL,
approved_at      DATETIME2     NULL,
client_key       VARCHAR(255)  NULL,
api_key          VARCHAR(255)  NULL,
check_sum_key    VARCHAR(255)  NULL,
locationX        DECIMAL(18,10) NULL,
locationY        DECIMAL(18,10) NULL,
is_deleted       BIT           DEFAULT 0,
created_at       DATETIME2     DEFAULT GETDATE(),
updated_at       DATETIME2     DEFAULT GETDATE(),
CONSTRAINT FK_Shop_Account     FOREIGN KEY (owner_id)    REFERENCES Accounts(id),
CONSTRAINT FK_Shop_Approved_By FOREIGN KEY (approved_by) REFERENCES Accounts(id),
CONSTRAINT UQ_Shop_Owner UNIQUE (owner_id)
);
GO

CREATE TRIGGER TR_Shops_UpdatedAt ON Shops AFTER UPDATE AS
BEGIN
SET NOCOUNT ON;
IF NOT EXISTS (SELECT 1 FROM inserted i JOIN deleted d ON i.id = d.id WHERE i.updated_at = d.updated_at) RETURN;
UPDATE Shops SET updated_at = GETDATE() WHERE id IN (SELECT id FROM inserted);
END;
GO

-- =============================================
-- 7. BẢNG CATEGORIES (loại sản phẩm của shop)
-- =============================================
CREATE TABLE Categories (
id          BIGINT        PRIMARY KEY IDENTITY(1,1),
shop_id     BIGINT        NOT NULL,
name        NVARCHAR(100) NOT NULL,
description NVARCHAR(MAX),
is_deleted  BIT           DEFAULT 0,
CONSTRAINT FK_Category_Shop FOREIGN KEY (shop_id) REFERENCES Shops(id)
);
GO
CREATE INDEX IDX_Category_Shop ON Categories(shop_id);
GO

-- =============================================
-- 8. BẢNG PRODUCTS
-- =============================================
CREATE TABLE Products (
id             BIGINT        PRIMARY KEY IDENTITY(1,1),
shop_id        BIGINT        NOT NULL,
category_id    BIGINT        NOT NULL,
product_name   NVARCHAR(255) NOT NULL,
description    NVARCHAR(MAX),
stock_quantity INT           DEFAULT 0,
sold_count     INT           DEFAULT 0,
status         VARCHAR(20)   CHECK (status IN ('ACTIVE', 'OUT_OF_STOCK', 'HIDDEN')) DEFAULT 'ACTIVE',
is_deleted     BIT           DEFAULT 0,
created_at     DATETIME2     DEFAULT GETDATE(),
updated_at     DATETIME2     DEFAULT GETDATE(),
CONSTRAINT CHK_Product_Stock     CHECK (stock_quantity >= 0),
CONSTRAINT CHK_Product_SoldCount CHECK (sold_count >= 0),
CONSTRAINT FK_Product_Shop     FOREIGN KEY (shop_id)     REFERENCES Shops(id),
CONSTRAINT FK_Product_Category FOREIGN KEY (category_id) REFERENCES Categories(id)
);
GO

CREATE TRIGGER TR_Products_UpdatedAt ON Products AFTER UPDATE AS
BEGIN
SET NOCOUNT ON;
IF NOT EXISTS (SELECT 1 FROM inserted i JOIN deleted d ON i.id = d.id WHERE i.updated_at = d.updated_at) RETURN;
UPDATE Products SET updated_at = GETDATE() WHERE id IN (SELECT id FROM inserted);
END;
GO

CREATE INDEX IDX_Product_Name     ON Products(product_name);
CREATE INDEX IDX_Product_Shop     ON Products(shop_id);
CREATE INDEX IDX_Product_Category ON Products(category_id);
GO

-- =============================================
-- 9. BẢNG PRODUCT_SIZES (giá theo size)
-- =============================================
CREATE TABLE Product_Sizes (
id         BIGINT        PRIMARY KEY IDENTITY(1,1),
product_id BIGINT        NOT NULL,
shop_id    BIGINT        NOT NULL,
size_name  NVARCHAR(50)  NOT NULL,
price      DECIMAL(12,2) NOT NULL,
CONSTRAINT CHK_ProductSize_Price CHECK (price > 0),
CONSTRAINT FK_ProductSize_Product FOREIGN KEY (product_id) REFERENCES Products(id) ON DELETE CASCADE,
CONSTRAINT FK_ProductSize_Shop    FOREIGN KEY (shop_id)    REFERENCES Shops(id),
CONSTRAINT UQ_Product_Size UNIQUE (product_id, size_name)
);
GO
CREATE INDEX IDX_ProductSize_Shop ON Product_Sizes(shop_id);
GO

-- =============================================
-- 10. BẢNG TOPPING_CATEGORIES
-- =============================================
CREATE TABLE ToppingCategories (
id          BIGINT        PRIMARY KEY IDENTITY(1,1),
shop_id     BIGINT        NOT NULL,
name        NVARCHAR(100) NOT NULL,
description NVARCHAR(MAX),
is_deleted  BIT           DEFAULT 0,
CONSTRAINT FK_ToppingCategory_Shop FOREIGN KEY (shop_id) REFERENCES Shops(id)
);
GO
CREATE INDEX IDX_ToppingCategory_Shop ON ToppingCategories(shop_id);
GO

-- =============================================
-- 11. BẢNG TOPPINGS
-- =============================================
CREATE TABLE Toppings (
id                  BIGINT        PRIMARY KEY IDENTITY(1,1),
topping_category_id BIGINT        NOT NULL,
shop_id             BIGINT        NOT NULL,
topping_name        NVARCHAR(100) NOT NULL,
price               DECIMAL(12,2) NOT NULL DEFAULT 0,
status              VARCHAR(20)   CHECK (status IN ('ACTIVE', 'OUT_OF_STOCK')) DEFAULT 'ACTIVE',
is_deleted          BIT           DEFAULT 0,
CONSTRAINT CHK_Topping_Price CHECK (price >= 0),
CONSTRAINT FK_Topping_Category FOREIGN KEY (topping_category_id) REFERENCES ToppingCategories(id),
CONSTRAINT FK_Topping_Shop     FOREIGN KEY (shop_id)             REFERENCES Shops(id)
);
GO
CREATE INDEX IDX_Topping_Shop ON Toppings(shop_id);
GO

-- =============================================
-- 12. BẢNG PRODUCT_IMAGES
-- =============================================
CREATE TABLE Product_Images (
id         BIGINT        PRIMARY KEY IDENTITY(1,1),
product_id BIGINT        NOT NULL,
image_url  NVARCHAR(MAX) NOT NULL,
is_primary BIT           DEFAULT 0,
sort_order INT           DEFAULT 0,
CONSTRAINT FK_Product_Image FOREIGN KEY (product_id) REFERENCES Products(id) ON DELETE CASCADE
);
GO
CREATE UNIQUE INDEX UQ_Product_Primary_Image  ON Product_Images(product_id) WHERE is_primary = 1;
CREATE INDEX        IDX_Product_Image_Product ON Product_Images(product_id);
GO

-- =============================================
-- 13. BẢNG CARTS
-- =============================================
CREATE TABLE Carts (
id         BIGINT    PRIMARY KEY IDENTITY(1,1),
user_id    BIGINT    NOT NULL UNIQUE,
created_at DATETIME2 DEFAULT GETDATE(),
CONSTRAINT FK_Cart_Account FOREIGN KEY (user_id) REFERENCES Accounts(id) ON DELETE CASCADE
);
GO

-- =============================================
-- 14. BẢNG CART_ITEMS
-- =============================================
CREATE TABLE Cart_Items (
id              BIGINT PRIMARY KEY IDENTITY(1,1),
cart_id         BIGINT NOT NULL,
product_id      BIGINT NOT NULL,
product_size_id BIGINT NOT NULL,
quantity        INT    NOT NULL,
CONSTRAINT CHK_CartItem_Quantity CHECK (quantity > 0),
CONSTRAINT FK_Item_Cart    FOREIGN KEY (cart_id)         REFERENCES Carts(id)         ON DELETE CASCADE,
CONSTRAINT FK_Item_Product FOREIGN KEY (product_id)      REFERENCES Products(id),
CONSTRAINT FK_Item_Size    FOREIGN KEY (product_size_id) REFERENCES Product_Sizes(id)
);
GO
CREATE INDEX IDX_CartItem_Cart ON Cart_Items(cart_id);
GO

-- =============================================
-- 15. BẢNG CART_ITEM_TOPPINGS
-- =============================================
CREATE TABLE Cart_Item_Toppings (
id           BIGINT PRIMARY KEY IDENTITY(1,1),
cart_item_id BIGINT NOT NULL,
topping_id   BIGINT NOT NULL,
quantity     INT    DEFAULT 1,
CONSTRAINT FK_CartTopping_Item    FOREIGN KEY (cart_item_id) REFERENCES Cart_Items(id) ON DELETE CASCADE,
CONSTRAINT FK_CartTopping_Topping FOREIGN KEY (topping_id)   REFERENCES Toppings(id)
);
GO

-- =============================================
-- 16. BẢNG ORDERS
-- =============================================
CREATE TABLE Orders (
id                      BIGINT        PRIMARY KEY IDENTITY(1,1),
user_id                 BIGINT        NOT NULL,
shop_id                 BIGINT        NOT NULL,
shipper_id              BIGINT        NULL,
receiver_name           NVARCHAR(100) NOT NULL,
receiver_phone          VARCHAR(20)   NOT NULL,
shipping_address        NVARCHAR(MAX) NOT NULL,
total_price             DECIMAL(12,2) NOT NULL,
delivery_fee            DECIMAL(12,2) DEFAULT 0,
payment_method          VARCHAR(20)   CHECK (payment_method IN ('COD', 'BANK', 'PAYOS')) DEFAULT 'COD',
payment_status          VARCHAR(20)   NOT NULL CHECK (payment_status IN ('UNPAID', 'PENDING', 'PAID')) DEFAULT 'UNPAID',
status                  VARCHAR(30)   CHECK (status IN ('PENDING', 'CONFIRMED', 'READY_FOR_PICKUP', 'SHIPPING', 'DONE', 'CANCELLED')) DEFAULT 'PENDING',
estimated_delivery_time DATETIME2     NULL,
payos_order_code        BIGINT        NULL,
created_at              DATETIME2     DEFAULT GETDATE(),
updated_at              DATETIME2     DEFAULT GETDATE(),
CONSTRAINT CHK_Order_TotalPrice  CHECK (total_price >= 0),
CONSTRAINT CHK_Order_DeliveryFee CHECK (delivery_fee >= 0),
CONSTRAINT FK_Order_User    FOREIGN KEY (user_id)    REFERENCES Accounts(id),
CONSTRAINT FK_Order_Shop    FOREIGN KEY (shop_id)    REFERENCES Shops(id),
CONSTRAINT FK_Order_Shipper FOREIGN KEY (shipper_id) REFERENCES Accounts(id)
);
GO

CREATE TRIGGER TR_Orders_UpdatedAt ON Orders AFTER UPDATE AS
BEGIN
SET NOCOUNT ON;
IF NOT EXISTS (SELECT 1 FROM inserted i JOIN deleted d ON i.id = d.id WHERE i.updated_at = d.updated_at) RETURN;
UPDATE Orders SET updated_at = GETDATE() WHERE id IN (SELECT id FROM inserted);
END;
GO

CREATE INDEX IDX_Order_Status ON Orders(status);
CREATE INDEX IDX_Order_User   ON Orders(user_id);
CREATE INDEX IDX_Order_Shop   ON Orders(shop_id);
GO

-- =============================================
-- 17. BẢNG ORDER_DETAILS
-- =============================================
CREATE TABLE Order_Details (
id              BIGINT        PRIMARY KEY IDENTITY(1,1),
order_id        BIGINT        NOT NULL,
product_id      BIGINT        NOT NULL,
product_size_id BIGINT        NOT NULL,
quantity        INT           NOT NULL,
price           DECIMAL(12,2) NOT NULL,
CONSTRAINT CHK_OrderDetail_Quantity CHECK (quantity > 0),
CONSTRAINT CHK_OrderDetail_Price    CHECK (price > 0),
CONSTRAINT FK_Detail_Order   FOREIGN KEY (order_id)        REFERENCES Orders(id)        ON DELETE CASCADE,
CONSTRAINT FK_Detail_Product FOREIGN KEY (product_id)      REFERENCES Products(id),
CONSTRAINT FK_Detail_Size    FOREIGN KEY (product_size_id) REFERENCES Product_Sizes(id)
);
GO
CREATE INDEX IDX_OrderDetail_Order ON Order_Details(order_id);
GO

-- =============================================
-- 18. BẢNG ORDER_DETAIL_TOPPINGS
-- =============================================
CREATE TABLE Order_Detail_Toppings (
id              BIGINT        PRIMARY KEY IDENTITY(1,1),
order_detail_id BIGINT        NOT NULL,
topping_id      BIGINT        NOT NULL,
quantity        INT           DEFAULT 1,
price           DECIMAL(12,2) NOT NULL,
CONSTRAINT FK_OrderTopping_Detail  FOREIGN KEY (order_detail_id) REFERENCES Order_Details(id) ON DELETE CASCADE,
CONSTRAINT FK_OrderTopping_Topping FOREIGN KEY (topping_id)      REFERENCES Toppings(id)
);
GO

-- =============================================
-- 19. BẢNG ORDER_LOGS
-- =============================================
CREATE TABLE Order_Logs (
id         BIGINT      PRIMARY KEY IDENTITY(1,1),
order_id   BIGINT      NOT NULL,
changed_by BIGINT      NOT NULL,
old_status VARCHAR(30) NULL  CHECK (old_status IN ('PENDING', 'CONFIRMED', 'READY_FOR_PICKUP', 'SHIPPING', 'DONE', 'CANCELLED')),
new_status VARCHAR(30) NOT NULL CHECK (new_status IN ('PENDING', 'CONFIRMED', 'READY_FOR_PICKUP', 'SHIPPING', 'DONE', 'CANCELLED')),
note       NVARCHAR(MAX),
created_at DATETIME2   DEFAULT GETDATE(),
CONSTRAINT FK_Log_Order   FOREIGN KEY (order_id)   REFERENCES Orders(id)   ON DELETE CASCADE,
CONSTRAINT FK_Log_Account FOREIGN KEY (changed_by) REFERENCES Accounts(id)
);
GO

-- =============================================
-- TRIGGERS BẢO VỆ SOFT DELETE
-- =============================================

CREATE TRIGGER TR_Accounts_PreventSoftDelete ON Accounts AFTER UPDATE AS
BEGIN
SET NOCOUNT ON;
IF NOT EXISTS (SELECT 1 FROM inserted i JOIN deleted d ON i.id = d.id WHERE d.is_deleted = 0 AND i.is_deleted = 1) RETURN;
IF EXISTS (SELECT 1 FROM Orders o JOIN inserted i ON o.user_id = i.id)
BEGIN
RAISERROR('Không thể xóa tài khoản đang có đơn hàng.', 16, 1); ROLLBACK TRANSACTION; RETURN;
END
IF EXISTS (SELECT 1 FROM Shops s JOIN inserted i ON s.owner_id = i.id WHERE s.is_deleted = 0)
BEGIN
RAISERROR('Không thể xóa tài khoản đang sở hữu cửa hàng.', 16, 1); ROLLBACK TRANSACTION; RETURN;
END
END;
GO

CREATE TRIGGER TR_Shops_PreventSoftDelete ON Shops AFTER UPDATE AS
BEGIN
SET NOCOUNT ON;
IF NOT EXISTS (SELECT 1 FROM inserted i JOIN deleted d ON i.id = d.id WHERE d.is_deleted = 0 AND i.is_deleted = 1) RETURN;
IF EXISTS (SELECT 1 FROM Products p JOIN inserted i ON p.shop_id = i.id WHERE p.is_deleted = 0)
BEGIN
RAISERROR('Không thể xóa cửa hàng còn sản phẩm đang hoạt động.', 16, 1); ROLLBACK TRANSACTION; RETURN;
END
IF EXISTS (SELECT 1 FROM Orders o JOIN inserted i ON o.shop_id = i.id WHERE o.status NOT IN ('DONE', 'CANCELLED'))
BEGIN
RAISERROR('Không thể xóa cửa hàng còn đơn hàng đang xử lý.', 16, 1); ROLLBACK TRANSACTION; RETURN;
END
END;
GO

CREATE TRIGGER TR_Products_PreventSoftDelete ON Products AFTER UPDATE AS
BEGIN
SET NOCOUNT ON;
IF NOT EXISTS (SELECT 1 FROM inserted i JOIN deleted d ON i.id = d.id WHERE d.is_deleted = 0 AND i.is_deleted = 1) RETURN;
IF EXISTS (SELECT 1 FROM Cart_Items ci JOIN inserted i ON ci.product_id = i.id)
BEGIN
RAISERROR('Không thể xóa sản phẩm đang có trong giỏ hàng.', 16, 1); ROLLBACK TRANSACTION; RETURN;
END
IF EXISTS (SELECT 1 FROM Order_Details od JOIN inserted i ON od.product_id = i.id JOIN Orders o ON od.order_id = o.id WHERE o.status NOT IN ('DONE', 'CANCELLED'))
BEGIN
RAISERROR('Không thể xóa sản phẩm đang có trong đơn hàng chưa hoàn thành.', 16, 1); ROLLBACK TRANSACTION; RETURN;
END
END;
GO
