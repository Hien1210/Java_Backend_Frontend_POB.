package org.example.models;

public class CartItemTopping {
    private long id;
    private long cartItemId;
    private long toppingId;
    private int quantity;

    public CartItemTopping() {
    }

    public CartItemTopping(long id, long cartItemId, long toppingId, int quantity) {
        this.id = id;
        this.cartItemId = cartItemId;
        this.toppingId = toppingId;
        this.quantity = quantity;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getCartItemId() {
        return cartItemId;
    }

    public void setCartItemId(long cartItemId) {
        this.cartItemId = cartItemId;
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
}
