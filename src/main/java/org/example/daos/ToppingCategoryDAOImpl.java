package org.example.daos;

import org.example.models.ToppingCategory;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ToppingCategoryDAOImpl implements ToppingCategoryDAO {

    // ── CREATE ───────────────────────────────────────────────────────────────

    @Override
    public Boolean create(ToppingCategory category) {
        String sql = "INSERT INTO ToppingCategories (shop_id, name, description, is_deleted) " +
                "VALUES (?, ?, ?, 0)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, category.getShopId());
            ps.setNString(2, category.getName());
            ps.setNString(3, category.getDescription());
            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── READ ALL ─────────────────────────────────────────────────────────────

    @Override
    public List<ToppingCategory> getAll() {
        String sql = "SELECT id, shop_id, name, description, is_deleted " +
                "FROM ToppingCategories WHERE is_deleted = 0 ORDER BY id DESC";
        List<ToppingCategory> list = new ArrayList<>();

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
    public ToppingCategory findById(long id) {
        String sql = "SELECT id, shop_id, name, description, is_deleted " +
                "FROM ToppingCategories WHERE id = ? AND is_deleted = 0";

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
    public Boolean update(ToppingCategory category) {
        String sql = "UPDATE ToppingCategories " +
                "SET name = ?, description = ? " +
                "WHERE id = ? AND shop_id = ? AND is_deleted = 0";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setNString(1, category.getName());
            ps.setNString(2, category.getDescription());
            ps.setLong(3, category.getId());
            ps.setLong(4, category.getShopId());
            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── DELETE (soft) ────────────────────────────────────────────────────────

    @Override
    public Boolean delete(long id) {
        String sql = "UPDATE ToppingCategories SET is_deleted = 1 WHERE id = ?";

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
    public List<ToppingCategory> findByShopId(long shopId) {
        String sql = "SELECT id, shop_id, name, description, is_deleted " +
                "FROM ToppingCategories " +
                "WHERE shop_id = ? AND is_deleted = 0 ORDER BY id ASC";
        List<ToppingCategory> list = new ArrayList<>();

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
    public List<ToppingCategory> findDeletedByShopId(long shopId) {
        String sql = "SELECT id, shop_id, name, description, is_deleted " +
                "FROM ToppingCategories WHERE shop_id = ? AND is_deleted = 1 ORDER BY id DESC";
        List<ToppingCategory> list = new ArrayList<>();
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
        String sql = "UPDATE ToppingCategories SET is_deleted = 0 WHERE id = ?";
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

    private ToppingCategory mapRow(ResultSet rs) throws Exception {
        ToppingCategory tc = new ToppingCategory();
        tc.setId(rs.getLong("id"));
        tc.setShopId(rs.getLong("shop_id"));
        tc.setName(rs.getNString("name"));
        tc.setDescription(rs.getNString("description"));
        tc.setDeleted(rs.getBoolean("is_deleted"));
        return tc;
    }
}
