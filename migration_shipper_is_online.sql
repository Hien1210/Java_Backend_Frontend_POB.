-- Thêm cột is_online vào bảng Accounts (dùng cho tài xế bật/tắt chế độ sẵn sàng nhận đơn)
-- Chạy 1 lần duy nhất trên DB thực tế
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Accounts' AND COLUMN_NAME = 'is_online'
)
BEGIN
    ALTER TABLE Accounts ADD is_online BIT NOT NULL DEFAULT 0;
END
GO
