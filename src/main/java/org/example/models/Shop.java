package org.example.models;

import java.time.LocalDateTime;

public class Shop {
    private long id;
    private long ownerId;
    private String shopName;
    private String shopDescription;
    private String shopAddress;
    private String shopPhone;
    private String shopLogo;

    private String clientKey;
    private String apiKey;
    private String checkSumKey;
    private Double locationX;
    private Double locationY;

    private String status;
    private String rejectionReason;
    private long approvedBy;
    private LocalDateTime approveDate;
    private boolean isDeleted;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Shop() {
    }

    public Shop(long id, long ownerId, String shopName, String shopDescription, String shopAddress, String shopPhone, String shopLogo, String clientKey, String apiKey, String checkSumKey, Double locationX, Double locationY, String status, String rejectionReason, long approvedBy, LocalDateTime approveDate, boolean isDeleted, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.id = id;
        this.ownerId = ownerId;
        this.shopName = shopName;
        this.shopDescription = shopDescription;
        this.shopAddress = shopAddress;
        this.shopPhone = shopPhone;
        this.shopLogo = shopLogo;
        this.clientKey = clientKey;
        this.apiKey = apiKey;
        this.checkSumKey = checkSumKey;
        this.locationX = locationX;
        this.locationY = locationY;
        this.status = status;
        this.rejectionReason = rejectionReason;
        this.approvedBy = approvedBy;
        this.approveDate = approveDate;
        this.isDeleted = isDeleted;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(long ownerId) {
        this.ownerId = ownerId;
    }

    public String getShopName() {
        return shopName;
    }

    public void setShopName(String shopName) {
        this.shopName = shopName;
    }

    public String getShopDescription() {
        return shopDescription;
    }

    public void setShopDescription(String shopDescription) {
        this.shopDescription = shopDescription;
    }

    public String getShopAddress() {
        return shopAddress;
    }

    public void setShopAddress(String shopAddress) {
        this.shopAddress = shopAddress;
    }

    public String getShopPhone() {
        return shopPhone;
    }

    public void setShopPhone(String shopPhone) {
        this.shopPhone = shopPhone;
    }

    public String getShopLogo() {
        return shopLogo;
    }

    public void setShopLogo(String shopLogo) {
        this.shopLogo = shopLogo;
    }

    public String getClientKey() {
        return clientKey;
    }

    public void setClientKey(String clientKey) {
        this.clientKey = clientKey;
    }

    public String getApiKey() {
        return apiKey;
    }

    public void setApiKey(String apiKey) {
        this.apiKey = apiKey;
    }

    public String getCheckSumKey() {
        return checkSumKey;
    }

    public void setCheckSumKey(String checkSumKey) {
        this.checkSumKey = checkSumKey;
    }

    public Double getLocationX() {
        return locationX;
    }

    public void setLocationX(Double locationX) {
        this.locationX = locationX;
    }

    public Double getLocationY() {
        return locationY;
    }

    public void setLocationY(Double locationY) {
        this.locationY = locationY;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public long getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(long approvedBy) {
        this.approvedBy = approvedBy;
    }

    public LocalDateTime getApproveDate() {
        return approveDate;
    }

    public void setApproveDate(LocalDateTime approveDate) {
        this.approveDate = approveDate;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Shop{" +
                "id=" + id +
                ", ownerId=" + ownerId +
                ", shopName='" + shopName + '\'' +
                ", shopDescription='" + shopDescription + '\'' +
                ", shopAddress='" + shopAddress + '\'' +
                ", shopPhone='" + shopPhone + '\'' +
                ", shopLogo='" + shopLogo + '\'' +
                ", clientKey='" + clientKey + '\'' +
                ", apiKey='" + apiKey + '\'' +
                ", checkSumKey='" + checkSumKey + '\'' +
                ", locationX=" + locationX +
                ", locationY=" + locationY +
                ", status='" + status + '\'' +
                ", rejectionReason='" + rejectionReason + '\'' +
                ", approvedBy=" + approvedBy +
                ", approveDate=" + approveDate +
                ", isDeleted=" + isDeleted +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}