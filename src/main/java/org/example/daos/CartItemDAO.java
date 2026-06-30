package org.example.daos;

import org.example.models.CartItem;

import java.util.List;

public interface CartItemDAO {
    Boolean create(CartItem item);
    List<CartItem> getAll();
    CartItem findById(long id);
    Boolean update(CartItem item);
    Boolean delete(long id);
    List<CartItem> findByCartId(long cartId);
}
