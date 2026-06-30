package org.example.models;

public class Topping {
    private long id;
    private long toppingCategoryId;
    private long shopId;
    private String toppingName;
    private double price;
    private String status;
    private boolean isDeleted;

    // Transient field — dùng để hiển thị tên loại topping trên JSP (không lưu DB)
    private String toppingCategoryName;

    public Topping() {}

    public Topping(long id, long toppingCategoryId, long shopId,
                   String toppingName, double price,
                   String status, boolean isDeleted) {
        this.id = id;
        this.toppingCategoryId = toppingCategoryId;
        this.shopId = shopId;
        this.toppingName = toppingName;
        this.price = price;
        this.status = status;
        this.isDeleted = isDeleted;
    }

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getToppingCategoryId() { return toppingCategoryId; }
    public void setToppingCategoryId(long toppingCategoryId) { this.toppingCategoryId = toppingCategoryId; }

    public long getShopId() { return shopId; }
    public void setShopId(long shopId) { this.shopId = shopId; }

    public String getToppingName() { return toppingName; }
    public void setToppingName(String toppingName) { this.toppingName = toppingName; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public boolean isDeleted() { return isDeleted; }
    public void setDeleted(boolean deleted) { isDeleted = deleted; }

    /** Tên hiển thị của loại topping — được gán bởi DAO sau khi JOIN, không lưu DB. */
    public String getToppingCategoryName() { return toppingCategoryName; }
    public void setToppingCategoryName(String toppingCategoryName) {
        this.toppingCategoryName = toppingCategoryName;
    }

    @Override
    public String toString() {
        return "Topping{id=" + id + ", toppingCategoryId=" + toppingCategoryId +
                ", shopId=" + shopId + ", toppingName='" + toppingName + '\'' +
                ", price=" + price + ", status='" + status + '\'' +
                ", isDeleted=" + isDeleted + '}';
    }
}