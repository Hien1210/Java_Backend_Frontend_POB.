package org.example.models;



import java.time.LocalDateTime;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class Product {
    private long id;
    private long shopId;
    private long categoryId;
    private String productName;
    private String description;
    private BigDecimal price;
    private int stockQuantity;
    private int soldCount;
    private String staTus;
    private String imageUrl;
    private boolean isDeleted;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<ProductSize> sizes = new ArrayList<>();
    private String categoryName;

    public Product() {
    }

    public Product(String categoryName, List<ProductSize> sizes, LocalDateTime updatedAt, LocalDateTime createdAt, boolean isDeleted, String imageUrl, String staTus, int soldCount, int stockQuantity, BigDecimal price, String description, String productName, long categoryId, long shopId, long id) {
        this.categoryName = categoryName;
        this.sizes = sizes;
        this.updatedAt = updatedAt;
        this.createdAt = createdAt;
        this.isDeleted = isDeleted;
        this.imageUrl = imageUrl;
        this.staTus = staTus;
        this.soldCount = soldCount;
        this.stockQuantity = stockQuantity;
        this.price = price;
        this.description = description;
        this.productName = productName;
        this.categoryId = categoryId;
        this.shopId = shopId;
        this.id = id;
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

    public long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(long categoryId) {
        this.categoryId = categoryId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public int getSoldCount() {
        return soldCount;
    }

    public void setSoldCount(int soldCount) {
        this.soldCount = soldCount;
    }

    public String getStaTus() {
        return staTus;
    }

    public void setStaTus(String staTus) {
        this.staTus = staTus;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
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

    public List<ProductSize> getSizes() {
        return sizes;
    }

    public void setSizes(List<ProductSize> sizes) {
        this.sizes = sizes != null ? sizes : new ArrayList<>();
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }


    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", shopId=" + shopId +
                ", categoryId=" + categoryId +
                ", productName='" + productName + '\'' +
                ", description='" + description + '\'' +
                ", price=" + price +
                ", stockQuantity=" + stockQuantity +
                ", soldCount=" + soldCount +
                ", staTus='" + staTus + '\'' +
                ", imageUrl='" + imageUrl + '\'' +
                ", isDeleted=" + isDeleted +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                ", sizes=" + sizes +
                ", categoryName='" + categoryName + '\'' +
                '}';
    }
}