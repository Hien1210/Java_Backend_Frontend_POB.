package org.example.models;

public class OrderDetail {
    private long id;
    private long orderId;
    private long productId;
    private long productSizeId; // mới
    private int quantity;
    private double price; // giá tại thời điểm mua

    public OrderDetail() {
    }

    public OrderDetail(long id, long orderId, long productId, long productSizeId, int quantity, double price) {
        this.id = id;
        this.orderId = orderId;
        this.productId = productId;
        this.productSizeId = productSizeId;
        this.quantity = quantity;
        this.price = price;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getOrderId() {
        return orderId;
    }

    public void setOrderId(long orderId) {
        this.orderId = orderId;
    }

    public long getProductId() {
        return productId;
    }

    public void setProductId(long productId) {
        this.productId = productId;
    }

    public long getProductSizeId() {
        return productSizeId;
    }

    public void setProductSizeId(long productSizeId) {
        this.productSizeId = productSizeId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    @Override
    public String toString() {
        return "OrderDetail{" +
                "id=" + id +
                ", orderId=" + orderId +
                ", productId=" + productId +
                ", productSizeId=" + productSizeId +
                ", quantity=" + quantity +
                ", price=" + price +
                '}';
    }
}