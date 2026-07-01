package org.example.daos;

import org.example.models.Topping;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ToppingDAOImpl implements ToppingDAO {

    // ── CREATE ───────────────────────────────────────────────────────────────

    @Override
    public Boolean create(Topping topping) {
        String sql = "INSERT INTO Toppings (topping_category_id, shop_id, topping_name, price, status, is_deleted) " +
                "VALUES (?, ?, ?, ?, ?, 0)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, topping.getToppingCategoryId());
            ps.setLong(2, topping.getShopId());
            ps.setNString(3, topping.getToppingName());
            ps.setDouble(4, topping.getPrice());
            ps.setString(5, normalizeStatus(topping.getStatus()));
            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── READ ALL ─────────────────────────────────────────────────────────────

    @Override
    public List<Topping> getAll() {
        String sql = "SELECT t.id, t.topping_category_id, t.shop_id, t.topping_name, t.price, t.status, t.is_deleted, " +
                "tc.name AS category_name " +
                "FROM Toppings t LEFT JOIN ToppingCategories tc ON t.topping_category_id = tc.id " +
                "WHERE t.is_deleted = 0 ORDER BY t.id DESC";
        List<Topping> list = new ArrayList<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── READ BY ID ───────────────────────────────────────────────────────────

    @Override
    public Topping findById(long id) {
        String sql = "SELECT t.id, t.topping_category_id, t.shop_id, t.topping_name, t.price, t.status, t.is_deleted, " +
                "tc.name AS category_name " +
                "FROM Toppings t LEFT JOIN ToppingCategories tc ON t.topping_category_id = tc.id " +
                "WHERE t.id = ? AND t.is_deleted = 0";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ── UPDATE ───────────────────────────────────────────────────────────────

    @Override
    public Boolean update(Topping topping) {
        String sql = "UPDATE Toppings " +
                "SET topping_category_id = ?, topping_name = ?, price = ?, status = ? " +
                "WHERE id = ? AND shop_id = ? AND is_deleted = 0";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, topping.getToppingCategoryId());
            ps.setNString(2, topping.getToppingName());
            ps.setDouble(3, topping.getPrice());
            ps.setString(4, normalizeStatus(topping.getStatus()));
            ps.setLong(5, topping.getId());
            ps.setLong(6, topping.getShopId());
            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── DELETE (soft) ────────────────────────────────────────────────────────

    @Override
    public Boolean delete(long id) {
        String sql = "UPDATE Toppings SET is_deleted = 1 WHERE id = ?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, id);
            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── FIND BY SHOP ─────────────────────────────────────────────────────────

    @Override
    public List<Topping> findByShopId(long shopId) {
        String sql = "SELECT t.id, t.topping_category_id, t.shop_id, t.topping_name, t.price, t.status, t.is_deleted, " +
                "tc.name AS category_name " +
                "FROM Toppings t LEFT JOIN ToppingCategories tc ON t.topping_category_id = tc.id " +
                "WHERE t.shop_id = ? AND t.is_deleted = 0 ORDER BY t.id ASC";
        List<Topping> list = new ArrayList<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── FIND DELETED BY SHOP ─────────────────────────────────────────────────

    @Override
    public List<Topping> findDeletedByShopId(long shopId) {
        String sql = "SELECT t.id, t.topping_category_id, t.shop_id, t.topping_name, t.price, t.status, t.is_deleted, " +
                "tc.name AS category_name " +
                "FROM Toppings t LEFT JOIN ToppingCategories tc ON t.topping_category_id = tc.id " +
                "WHERE t.shop_id = ? AND t.is_deleted = 1 ORDER BY t.id DESC";
        List<Topping> list = new ArrayList<>();
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── RESTORE ──────────────────────────────────────────────────────────────

    @Override
    public Boolean restore(long id) {
        String sql = "UPDATE Toppings SET is_deleted = 0 WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── HELPERS ──────────────────────────────────────────────────────────────

    private Topping mapRow(ResultSet rs) throws Exception {
        Topping t = new Topping();
        t.setId(rs.getLong("id"));
        t.setToppingCategoryId(rs.getLong("topping_category_id"));
        t.setShopId(rs.getLong("shop_id"));
        t.setToppingName(rs.getNString("topping_name"));
        t.setPrice(rs.getDouble("price"));
        t.setStatus(rs.getString("status"));
        t.setDeleted(rs.getBoolean("is_deleted"));
        t.setToppingCategoryName(rs.getNString("category_name"));
        return t;
    }

    private String normalizeStatus(String status) {
        String v = (status == null) ? "" : status.trim();
        return v.isBlank() ? "ACTIVE" : v.toUpperCase();
    }
}
