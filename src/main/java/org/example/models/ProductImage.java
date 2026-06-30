package org.example.models;

public class ProductImage {
    private long id;
    private String productId;
    private boolean isPrimary;
    private int sortOrder;

    public ProductImage() {
    }

    public ProductImage(long id, String productId, boolean isPrimary, int sortOrder) {
        this.id = id;
        this.productId = productId;
        this.isPrimary = isPrimary;
        this.sortOrder = sortOrder;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public boolean isPrimary() {
        return isPrimary;
    }

    public void setPrimary(boolean primary) {
        isPrimary = primary;
    }

    public int getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
    }

    @Override
    public String toString() {
        return "ProductImage{" +
                "id=" + id +
                ", productId='" + productId + '\'' +
                ", isPrimary=" + isPrimary +
                ", sortOrder=" + sortOrder +
                '}';
    }
}
