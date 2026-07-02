-- Tạo bảng Notifications cho hệ thống thông báo Shipper
-- Chạy 1 lần duy nhất trên DB thực tế
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'Notifications'
)
BEGIN
    CREATE TABLE Notifications (
        id         BIGINT        PRIMARY KEY IDENTITY(1,1),
        account_id BIGINT        NOT NULL,           -- Người nhận thông báo
        title      NVARCHAR(255) NOT NULL,
        message    NVARCHAR(MAX) NOT NULL,
        is_read    BIT           NOT NULL DEFAULT 0,
        created_at DATETIME2     DEFAULT GETDATE(),
        CONSTRAINT FK_Notification_Account FOREIGN KEY (account_id) REFERENCES Accounts(id) ON DELETE CASCADE
    );

    CREATE INDEX IDX_Notification_Account ON Notifications(account_id);
END
GO
