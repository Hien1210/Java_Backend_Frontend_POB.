package org.example.daos;

import org.example.models.CartItem;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CartItemDAOImpl implements CartItemDAO {
    @Override
    public Boolean create(CartItem item) {
        String sql = "INSERT INTO Cart_Items (cart_id, product_id, product_size_id, quantity) VALUES (?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, item.getCartId());
            ps.setLong(2, item.getProductId());
            ps.setLong(3, item.getProductSizeId());
            ps.setInt(4, item.getQuantity());
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<CartItem> getAll() {
        String sql = "SELECT id, cart_id, product_id, product_size_id, quantity FROM Cart_Items ORDER BY id DESC";
        List<CartItem> items = new ArrayList<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                items.add(mapCartItem(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return items;
    }

    @Override
    public CartItem findById(long id) {
        String sql = "SELECT id, cart_id, product_id, product_size_id, quantity FROM Cart_Items WHERE id = ?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCartItem(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public Boolean update(CartItem item) {
        String sql = "UPDATE Cart_Items SET cart_id = ?, product_id = ?, product_size_id = ?, quantity = ? WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, item.getCartId());
            ps.setLong(2, item.getProductId());
            ps.setLong(3, item.getProductSizeId());
            ps.setInt(4, item.getQuantity());
            ps.setLong(5, item.getId());
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Boolean delete(long id) {
        String sql = "DELETE FROM Cart_Items WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<CartItem> findByCartId(long cartId) {
        String sql = "SELECT id, cart_id, product_id, product_size_id, quantity FROM Cart_Items WHERE cart_id = ? ORDER BY id ASC";
        List<CartItem> items = new ArrayList<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(mapCartItem(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return items;
    }

    private CartItem mapCartItem(ResultSet rs) throws Exception {
        CartItem item = new CartItem();
        item.setId(rs.getLong("id"));
        item.setCartId(rs.getLong("cart_id"));
        item.setProductId(rs.getLong("product_id"));
        item.setProductSizeId(rs.getLong("product_size_id"));
        item.setQuantity(rs.getInt("quantity"));
        return item;
    }
}
