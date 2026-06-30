package org.example.models;

public class Category {

    private long id;
    private long shopId;
    private String categoryName;
    private String status;
    private boolean isDeleted;

    public Category() {
    }

    public Category(long id, long shopId, String categoryName, String status, boolean isDeleted) {
        this.id = id;
        this.shopId = shopId;
        this.categoryName = categoryName;
        this.status = status;
        this.isDeleted = isDeleted;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getShopId() {
        return shopId;
    }

    public void setShopId(long shopId) {
        this.shopId = shopId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
    }

    @Override
    public String toString() {
        return "Category{" +
                "id=" + id +
                ", shopId=" + shopId +
                ", categoryName='" + categoryName + '\'' +
                ", status='" + status + '\'' +
                ", isDeleted=" + isDeleted +
                '}';
    }
}