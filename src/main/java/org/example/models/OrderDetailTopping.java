package org.example.models;

public class OrderDetailTopping {
    private long id;
    private long orderDetailId;
    private long toppingId;
    private int quantity;
    private double price;

    public OrderDetailTopping() {
    }

    public OrderDetailTopping(long id, long orderDetailId,
                              long toppingId, int quantity, double price) {
        this.id = id;
        this.orderDetailId = orderDetailId;
        this.toppingId = toppingId;
        this.quantity = quantity;
        this.price = price;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getOrderDetailId() {
        return orderDetailId;
    }

    public void setOrderDetailId(long orderDetailId) {
        this.orderDetailId = orderDetailId;
    }

    public long getToppingId() {
        return toppingId;
    }

    public void setToppingId(long toppingId) {
        this.toppingId = toppingId;
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
}