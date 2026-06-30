-- Chạy 1 lần trên database POB đã có sẵn (không xóa dữ liệu cũ).
-- CHECK constraint cũ trên Orders.payment_method chỉ cho phép 'MOMO'/'BANK'/'COD',
-- chưa có 'PAYOS' -> insert Order với paymentMethod=PAYOS bị lỗi
-- "The INSERT statement conflicted with the CHECK constraint".
-- Thêm 'PAYOS' vào danh sách giá trị hợp lệ (giữ nguyên 'MOMO' để không phá dữ liệu cũ).
USE POB;
GO

IF EXISTS (
    SELECT 1 FROM sys.check_constraints
    WHERE name = 'CK__Orders__payment___690797E6' AND parent_object_id = OBJECT_ID('Orders')
)
BEGIN
    ALTER TABLE Orders DROP CONSTRAINT CK__Orders__payment___690797E6;
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints
    WHERE name = 'CK_Orders_PaymentMethod' AND parent_object_id = OBJECT_ID('Orders')
)
BEGIN
    ALTER TABLE Orders ADD CONSTRAINT CK_Orders_PaymentMethod
        CHECK ([payment_method] = 'MOMO' OR [payment_method] = 'BANK' OR [payment_method] = 'COD' OR [payment_method] = 'PAYOS');
END
GO
