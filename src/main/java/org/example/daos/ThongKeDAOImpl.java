package org.example.daos;
import org.example.utils.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

import java.util.Map;

public class ThongKeDAOImpl implements ThongKeDAO {
    @Override
    public int getTotalAccounts() {
        String sql = "SELECT COUNT(*) FROM Accounts WHERE is_deleted = 0";
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
    public int getPendingShops() {
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
    public int getActiveShippers() {
        String sql = "SELECT COUNT(*) FROM Accounts a " +
                "JOIN Roles r ON a.role_id = r.id " +
                "WHERE r.name = 'SHIPPER' AND a.status = 'ACTIVE' AND a.is_deleted = 0";
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
    public int getViolationWarnings() {
        // Tạm thời trả về 0 hoặc tính từ số shop bị BLOCKED
        String sql = "SELECT COUNT(*) FROM Shops WHERE status = 'BLOCKED'";
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
    public Map<String, Integer> getDashboardStats() {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("totalAccounts", getTotalAccounts());
        stats.put("pendingShops", getPendingShops());
        stats.put("activeShippers", getActiveShippers());
        stats.put("violationWarnings", getViolationWarnings());
        return stats;
    }
}
