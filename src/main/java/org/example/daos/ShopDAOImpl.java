package org.example.daos;

import org.example.models.Shop;
import org.example.utils.DBUtil;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;


public class ShopDAOImpl implements ShopDAO {


    private static final String SELECT_ALL = "SELECT * FROM Shops WHERE is_deleted = 0";
    private static final String SELECT_PENDING = "SELECT * FROM Shops WHERE is_deleted = 0 AND LOWER(status) = 'pending' ORDER BY created_at DESC";
    private static final String SELECT_BY_ID = "SELECT * FROM Shops WHERE id = ? AND is_deleted = 0";
    private static final String SELECT_BY_OWNER_ID = "SELECT TOP 1 * FROM Shops WHERE owner_id = ? AND is_deleted = 0 ORDER BY id DESC";

    private static final String INSERT = "INSERT INTO Shops (owner_id, shop_name, shop_description, shop_address, shop_phone, shop_logo, status, rejection_reason, approved_by, approved_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String UPDATE = "UPDATE Shops SET owner_id = ?, shop_name = ?, shop_description = ?, shop_address = ?, shop_phone = ?, shop_logo = ?, status = ?, rejection_reason = ?, approved_by = ?, approved_at = ?, client_key = ?, api_key = ?, check_sum_key = ?, updated_at = GETDATE() WHERE id = ?";

    private static final String UPDATE_APPROVAL = "UPDATE Shops SET status = ?, rejection_reason = ?, approved_by = ?, approved_at = GETDATE(), updated_at = GETDATE() WHERE id = ? AND is_deleted = 0";

    private static final String DELETE_SOFT = "UPDATE Shops SET is_deleted = 1, updated_at = GETDATE() WHERE id = ?";

    @Override
    public List<org.example.models.Shop> selectAllShops() {
        List<Shop> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToShop(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Shop> selectPendingShops() {
        List<Shop> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_PENDING);
             ResultSet rs = ps.executeQuery()) {

            System.out.println("[DEBUG] Connect tới: " + conn.getMetaData().getURL());

            while (rs.next()) {
                list.add(mapResultSetToShop(rs));
            }
            System.out.println("[DEBUG] Số shop pending lấy được: " + list.size());
        } catch (Exception e) {
            System.out.println("[DEBUG] LỖI KẾT NỐI/QUERY:");
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Shop selectShopById(long id) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID)) {

            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToShop(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Shop selectShopByOwnerId(long ownerId) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_OWNER_ID)) {

            ps.setLong(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToShop(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public void insertShop(Shop shop) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT)) {

            ps.setLong(1, shop.getOwnerId());
            ps.setString(2, shop.getShopName());
            ps.setString(3, shop.getShopDescription());
            ps.setString(4, shop.getShopAddress());
            ps.setString(5, shop.getShopPhone());
            ps.setString(6, shop.getShopLogo());

            ps.setString(7, (shop.getStatus() != null && !shop.getStatus().isEmpty()) ? shop.getStatus() : "pending");
            ps.setString(8, shop.getRejectionReason());

            if (shop.getApprovedBy() > 0) {
                ps.setLong(9, shop.getApprovedBy());
            } else {
                ps.setNull(9, Types.BIGINT);
            }

            ps.setTimestamp(10, shop.getApproveDate() != null ? Timestamp.valueOf(shop.getApproveDate()) : null);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateShop(Shop shop) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE)) {

            ps.setLong(1, shop.getOwnerId());
            ps.setString(2, shop.getShopName());
            ps.setString(3, shop.getShopDescription());
            ps.setString(4, shop.getShopAddress());
            ps.setString(5, shop.getShopPhone());
            ps.setString(6, shop.getShopLogo());
            ps.setString(7, (shop.getStatus() != null && !shop.getStatus().isEmpty()) ? shop.getStatus() : "pending");
            ps.setString(8, shop.getRejectionReason());

            if (shop.getApprovedBy() > 0) {
                ps.setLong(9, shop.getApprovedBy());
            } else {
                ps.setNull(9, Types.BIGINT);
            }

            ps.setTimestamp(10, shop.getApproveDate() != null ? Timestamp.valueOf(shop.getApproveDate()) : null);
            ps.setString(11, shop.getClientKey());
            ps.setString(12, shop.getApiKey());
            ps.setString(13, shop.getCheckSumKey());
            ps.setLong(14, shop.getId()); // ID de tim ban ghi can update

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean updateShopApproval(long shopId, String status, String rejectionReason, long approvedBy) {



        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_APPROVAL)) {

            ps.setString(1, status);
            ps.setString(2, rejectionReason);
            ps.setLong(3, approvedBy);
            ps.setLong(4, shopId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public void deleteShop(long id) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_SOFT)) {

            ps.setLong(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public int countPendingShops() {
        String sql = "SELECT COUNT(*) FROM Shops WHERE status = 'PENDING' AND is_deleted = 0";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<Shop> findTop5PendingShops() {
        List<Shop> shops = new ArrayList<>();
        String sql = "SELECT DISTINCT TOP 5 id, shop_name, shop_address, shop_phone, created_at " +
                "FROM Shops WHERE status = 'PENDING' AND is_deleted = 0 " +
                "ORDER BY created_at DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Shop shop = new Shop();
                shop.setId(rs.getLong("id"));
                shop.setShopName(rs.getString("shop_name"));
                shop.setShopAddress(rs.getString("shop_address"));
                shop.setShopPhone(rs.getString("shop_phone"));
                //Timestamp thành LocalDateTime.
                java.sql.Timestamp timestamp = rs.getTimestamp("created_at");
                if (timestamp != null) {
                    shop.setCreatedAt(timestamp.toLocalDateTime());
                }

                shops.add(shop);

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return shops;
    }

    // Ánh xạ chuẩn xác từ tên cột Snake_case của SQL Server sang các hàm Setter của Model Java
    private Shop mapResultSetToShop(ResultSet rs) throws SQLException {
        Shop shop = new Shop();

        shop.setId(rs.getLong("id"));
        shop.setOwnerId(rs.getLong("owner_id"));
        shop.setShopName(rs.getString("shop_name"));
        shop.setShopDescription(rs.getString("shop_description"));
        shop.setShopAddress(rs.getString("shop_address"));
        shop.setShopPhone(rs.getString("shop_phone"));
        shop.setShopLogo(rs.getString("shop_logo"));
        shop.setStatus(rs.getString("status"));
        shop.setRejectionReason(rs.getString("rejection_reason"));
        shop.setApprovedBy(rs.getLong("approved_by"));
        shop.setClientKey(rs.getString("client_key"));
        shop.setApiKey(rs.getString("api_key"));
        shop.setCheckSumKey(rs.getString("check_sum_key"));

        // Xử lý các cột thời gian dạng DATETIME2
        Timestamp approvedAtTs = rs.getTimestamp("approved_at");
        if (approvedAtTs != null) {
            shop.setApproveDate(approvedAtTs.toLocalDateTime());
        }

        shop.setDeleted(rs.getBoolean("is_deleted"));

        Timestamp createdAtTs = rs.getTimestamp("created_at");
        if (createdAtTs != null) {
            shop.setCreatedAt(createdAtTs.toLocalDateTime());
        }

        Timestamp updatedAtTs = rs.getTimestamp("updated_at");
        if (updatedAtTs != null) {
            shop.setUpdatedAt(updatedAtTs.toLocalDateTime());
        }

        return shop;
    }
}
