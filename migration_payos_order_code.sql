-- Chạy 1 lần trên database POB đã có sẵn (không xóa dữ liệu cũ).
-- Thêm cột payos_order_code cho bảng Orders để liên kết 1 Order với 1 link thanh toán PayOS
-- (orderCode PayOS gửi lên khi redirect về returnUrl / gọi webhook).
USE POB;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID('Orders') AND name = 'payos_order_code'
)
BEGIN
    ALTER TABLE Orders ADD payos_order_code BIGINT NULL;
END
GO
