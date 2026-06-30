package org.example.daos;

import org.example.models.ShopDashboardStats;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ShopDashboardDAOImpl implements ShopDashboardDAO {

    @Override
    public ShopDashboardStats getDashboardStats(long shopId) {
        ShopDashboardStats stats = new ShopDashboardStats();

        try (Connection conn = DBUtil.getConnection()) {
            stats.setDoanhThuHomNay(getRevenueSince(conn, shopId, "CAST(GETDATE() AS DATE)"));
            stats.setDoanhThuTuanNay(getRevenueSince(conn, shopId, "DATEADD(DAY, -6, CAST(GETDATE() AS DATE))"));
            stats.setDoanhThuThangNay(getRevenueSince(conn, shopId, "DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)"));

            loadOrderCounts(conn, shopId, stats);
            stats.setTongSanPham(countRows(conn, "Products", shopId));
            stats.setTongTopping(countRows(conn, "Toppings", shopId));
            stats.setTopSanPhamBanChay(loadTopProducts(conn, shopId, 5));
            stats.setDoanhThu7NgayQua(loadRevenueLast7Days(conn, shopId));
        } catch (Exception e) {
            e.printStackTrace();
        }

        return stats;
    }

    private double getRevenueSince(Connection conn, long shopId, String fromDateExpr) throws Exception {
        String sql = "SELECT ISNULL(SUM(total_price), 0) FROM Orders " +
                "WHERE shop_id = ? AND status = 'DONE' " +
                "AND created_at >= " + fromDateExpr;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getDouble(1) : 0D;
            }
        }
    }

    private void loadOrderCounts(Connection conn, long shopId, ShopDashboardStats stats) throws Exception {
        String sql = "SELECT status, COUNT(*) AS so_luong FROM Orders " +
                "WHERE shop_id = ? GROUP BY status";
        int tongDon = 0;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String status = rs.getString("status");
                    int soLuong = rs.getInt("so_luong");
                    tongDon += soLuong;
                    if ("DONE".equalsIgnoreCase(status)) {
                        stats.setDonHoanThanh(soLuong);
                    } else if ("CANCELLED".equalsIgnoreCase(status)) {
                        stats.setDonHuy(soLuong);
                    } else if ("PENDING".equalsIgnoreCase(status)) {
                        stats.setDonChoXuLy(soLuong);
                    }
                }
            }
        }
        stats.setTongDon(tongDon);
    }

    private int countRows(Connection conn, String table, long shopId) throws Exception {
        String sql = "SELECT COUNT(*) FROM " + table + " WHERE shop_id = ? AND is_deleted = 0";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    private List<ShopDashboardStats.TopProduct> loadTopProducts(Connection conn, long shopId, int limit) throws Exception {
        List<ShopDashboardStats.TopProduct> result = new ArrayList<>();
        String sql = "SELECT TOP (?) p.id, p.product_name, " +
                "SUM(od.quantity) AS so_luong_da_ban, SUM(od.quantity * od.price) AS doanh_thu " +
                "FROM Order_Details od " +
                "JOIN Orders o ON od.order_id = o.id " +
                "JOIN Products p ON od.product_id = p.id " +
                "WHERE o.shop_id = ? AND o.status = 'DONE' " +
                "GROUP BY p.id, p.product_name " +
                "ORDER BY so_luong_da_ban DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setLong(2, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(new ShopDashboardStats.TopProduct(
                            rs.getLong("id"),
                            rs.getNString("product_name"),
                            rs.getInt("so_luong_da_ban"),
                            rs.getDouble("doanh_thu")
                    ));
                }
            }
        }
        return result;
    }

    private List<ShopDashboardStats.RevenueByDay> loadRevenueLast7Days(Connection conn, long shopId) throws Exception {
        String sql = "SELECT CAST(created_at AS DATE) AS ngay, SUM(total_price) AS doanh_thu " +
                "FROM Orders " +
                "WHERE shop_id = ? AND status = 'DONE' " +
                "AND created_at >= DATEADD(DAY, -6, CAST(GETDATE() AS DATE)) " +
                "GROUP BY CAST(created_at AS DATE)";

        java.util.Map<String, Double> revenueByDate = new java.util.HashMap<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    revenueByDate.put(rs.getDate("ngay").toLocalDate().toString(), rs.getDouble("doanh_thu"));
                }
            }
        }

        List<ShopDashboardStats.RevenueByDay> result = new ArrayList<>();
        LocalDate today = LocalDate.now();
        for (int i = 6; i >= 0; i--) {
            LocalDate day = today.minusDays(i);
            String key = day.toString();
            double revenue = revenueByDate.getOrDefault(key, 0D);
            result.add(new ShopDashboardStats.RevenueByDay(key, revenue));
        }
        return result;
    }
}
