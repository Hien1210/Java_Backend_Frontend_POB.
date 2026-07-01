package org.example.models;

import java.time.LocalDateTime;

public class UserAddress {
    private long id;
    private long accountId;
    private String label;           // 'Nhà', 'Công ty', 'Trường học'...
    private String fullAddress;
    private String receiverName;
    private String receiverPhone;
    private boolean isDefault;
    private LocalDateTime createdAt;

    public UserAddress() {}

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getAccountId() { return accountId; }
    public void setAccountId(long accountId) { this.accountId = accountId; }

    public String getLabel() { return label; }
    public void setLabel(String label) { this.label = label; }

    public String getFullAddress() { return fullAddress; }
    public void setFullAddress(String fullAddress) { this.fullAddress = fullAddress; }

    public String getReceiverName() { return receiverName; }
    public void setReceiverName(String receiverName) { this.receiverName = receiverName; }

    public String getReceiverPhone() { return receiverPhone; }
    public void setReceiverPhone(String receiverPhone) { this.receiverPhone = receiverPhone; }

    public boolean isDefault() { return isDefault; }
    public void setDefault(boolean aDefault) { isDefault = aDefault; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
