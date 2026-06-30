package org.example.daos;

import org.example.models.ProductSize;
import org.example.utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductSizeDAOImpl implements ProductSizeDAO {
    @Override
    public long create(ProductSize size) {
        // ✅ SỬA: Xóa is_deleted
        String sql = "INSERT INTO Product_Sizes (product_id, shop_id, size_name, price) " +
                "VALUES (?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setLong(1, size.getProductId());
            ps.setLong(2, size.getShopId());
            ps.setString(3, size.getSizeName());
            ps.setDouble(4, size.getPrice());

            int affected = ps.executeUpdate();
            if (affected == 0) return 0;

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;

    }

    @Override
    public boolean update(ProductSize size) {
        String sql = "UPDATE Product_Sizes SET size_name = ?, price = ? WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, size.getSizeName());
            ps.setDouble(2, size.getPrice());
            ps.setLong(3, size.getId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean delete(long id) {
        // ✅ SỬA: DELETE theo id
        String sql = "DELETE FROM Product_Sizes WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean deleteByProductId(long productId) {
        // ✅ SỬA: DELETE theo product_id
        String sql = "DELETE FROM Product_Sizes WHERE product_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public ProductSize findById(long id) {
        String sql = "SELECT * FROM Product_Sizes WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapProductSize(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<ProductSize> findByProductId(long productId) {
        List<ProductSize> sizes = new ArrayList<>();
        // ✅ SỬA: Xóa điều kiện is_deleted
        String sql = "SELECT * FROM Product_Sizes WHERE product_id = ? ORDER BY id ASC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    sizes.add(mapProductSize(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sizes;
    }

    @Override
    public List<ProductSize> findByShopId(long shopId) {
        List<ProductSize> sizes = new ArrayList<>();
        // ✅ SỬA: Xóa is_deleted
        String sql = "SELECT * FROM Product_Sizes WHERE shop_id = ? ORDER BY id ASC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    sizes.add(mapProductSize(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sizes;
    }

    private ProductSize mapProductSize(ResultSet rs) throws SQLException {
        ProductSize size = new ProductSize();
        size.setId(rs.getLong("id"));
        size.setProductId(rs.getLong("product_id"));
        size.setShopId(rs.getLong("shop_id"));
        size.setSizeName(rs.getString("size_name"));
        size.setPrice(rs.getDouble("price"));
        // ❌ XÓA: size.setDeleted(rs.getBoolean("is_deleted"));
        return size;
    }

}
