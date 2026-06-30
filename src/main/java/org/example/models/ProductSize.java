package org.example.models;

public class ProductSize {
    private long id;
    private long productId;
    private long shopId;          // ← THÊM
    private String sizeName;
    private double price;


    public ProductSize() {
    }

    public ProductSize(long id, long productId, long shopId, String sizeName, double price) {
        this.id = id;
        this.productId = productId;
        this.shopId = shopId;
        this.sizeName = sizeName;
        this.price = price;
    }

    // ─── Getters & Setters ──────────────────────────────────────────

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getProductId() { return productId; }
    public void setProductId(long productId) { this.productId = productId; }

    public long getShopId() { return shopId; }
    public void setShopId(long shopId) { this.shopId = shopId; }

    public String getSizeName() { return sizeName; }
    public void setSizeName(String sizeName) { this.sizeName = sizeName; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    // ─── toString ──────────────────────────────────────────────────

    @Override
    public String toString() {
        return "ProductSize{" +
                "id=" + id +
                ", productId=" + productId +
                ", shopId=" + shopId +
                ", sizeName='" + sizeName + '\'' +
                ", price=" + price +
                '}';
    }
}
