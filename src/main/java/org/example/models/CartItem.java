package org.example.models;

public class CartItem {
    private long id;
    private long cartId;
    private long productId;
    private long productSizeId;
    private int quantity;

    public CartItem() {
    }

    public CartItem(long id, long cartId, long productId, long productSizeId, int quantity) {
        this.id = id;
        this.cartId = cartId;
        this.productId = productId;
        this.productSizeId = productSizeId;
        this.quantity = quantity;
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

    public long getProductId() {
        return productId;
    }

    public void setProductId(long productId) {
        this.productId = productId;
    }

    public long getCartId() {
        return cartId;
    }

    public void setCartId(long cartId) {
        this.cartId = cartId;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }


    @Override
    public String toString() {
        return "CartItem{" +
                "id=" + id +
                ", cartId=" + cartId +
                ", productId=" + productId +
                ", productSizeId=" + productSizeId +
                ", quantity=" + quantity +
                '}';
    }
}

