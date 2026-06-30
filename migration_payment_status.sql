-- Chạy 1 lần trên database POB đã có sẵn (không xóa dữ liệu cũ).
-- Thêm cột payment_status cho bảng Orders để phục vụ tính năng "Bấm Bill" (POS).
USE POB;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Orders') AND name = 'payment_status'
)
BEGIN
    ALTER TABLE Orders ADD payment_status VARCHAR(20) NOT NULL
        CONSTRAINT DF_Order_PaymentStatus DEFAULT 'UNPAID';

    ALTER TABLE Orders ADD CONSTRAINT CHK_Order_PaymentStatus
        CHECK (payment_status IN ('UNPAID', 'PENDING', 'PAID'));
END
GO
