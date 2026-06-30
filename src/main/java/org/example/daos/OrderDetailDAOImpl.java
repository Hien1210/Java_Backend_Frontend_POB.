package org.example.daos;

import org.example.models.OrderDetail;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class OrderDetailDAOImpl implements OrderDetailDAO {
    @Override
    public Boolean create(OrderDetail detail) {
        String sql = "INSERT INTO Order_Details (order_id, product_id, product_size_id, quantity, price) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, detail.getOrderId());
            ps.setLong(2, detail.getProductId());
            ps.setLong(3, detail.getProductSizeId());
            ps.setInt(4, detail.getQuantity());
            ps.setDouble(5, detail.getPrice());
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public long createAndReturnId(OrderDetail detail) {
        String sql = "INSERT INTO Order_Details (order_id, product_id, product_size_id, quantity, price) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, detail.getOrderId());
            ps.setLong(2, detail.getProductId());
            ps.setLong(3, detail.getProductSizeId());
            ps.setInt(4, detail.getQuantity());
            ps.setDouble(5, detail.getPrice());
            int affected = ps.executeUpdate();
            if (affected == 0) return 0;
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getLong(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<OrderDetail> getAll() {
        String sql = "SELECT id, order_id, product_id, product_size_id, quantity, price FROM Order_Details ORDER BY id DESC";
        List<OrderDetail> details = new ArrayList<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                details.add(mapOrderDetail(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return details;
    }

    @Override
    public OrderDetail findById(long id) {
        String sql = "SELECT id, order_id, product_id, product_size_id, quantity, price FROM Order_Details WHERE id = ?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapOrderDetail(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public Boolean update(OrderDetail detail) {
        String sql = "UPDATE Order_Details SET order_id = ?, product_id = ?, product_size_id = ?, quantity = ?, price = ? WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, detail.getOrderId());
            ps.setLong(2, detail.getProductId());
            ps.setLong(3, detail.getProductSizeId());
            ps.setInt(4, detail.getQuantity());
            ps.setDouble(5, detail.getPrice());
            ps.setLong(6, detail.getId());
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Boolean delete(long id) {
        String sql = "DELETE FROM Order_Details WHERE id = ?";
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
    public List<OrderDetail> findByOrderId(long orderId) {
        String sql = "SELECT id, order_id, product_id, product_size_id, quantity, price FROM Order_Details WHERE order_id = ? ORDER BY id ASC";
        List<OrderDetail> details = new ArrayList<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    details.add(mapOrderDetail(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return details;
    }

    private OrderDetail mapOrderDetail(ResultSet rs) throws Exception {
        OrderDetail detail = new OrderDetail();
        detail.setId(rs.getLong("id"));
        detail.setOrderId(rs.getLong("order_id"));
        detail.setProductId(rs.getLong("product_id"));
        detail.setProductSizeId(rs.getLong("product_size_id"));
        detail.setQuantity(rs.getInt("quantity"));
        detail.setPrice(rs.getDouble("price"));
        return detail;
    }
}
