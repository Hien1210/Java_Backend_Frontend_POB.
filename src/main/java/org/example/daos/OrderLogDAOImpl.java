package org.example.daos;

import org.example.models.OrderLog;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class OrderLogDAOImpl implements OrderLogDAO {
    @Override
    public Boolean create(OrderLog log) {
        String sql = "INSERT INTO OrderLogs (order_id, changed_by, old_status, new_status, note) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, log.getOrderId());
            ps.setLong(2, log.getChangedBy());
            ps.setString(3, log.getOldStatus());
            ps.setString(4, log.getNewStatus());
            ps.setNString(5, log.getNote());
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<OrderLog> getAll() {
        String sql = "SELECT id, order_id, changed_by, old_status, new_status, note FROM OrderLogs ORDER BY id DESC";
        List<OrderLog> logs = new ArrayList<>();
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                logs.add(mapOrderLog(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return logs;
    }

    @Override
    public OrderLog findById(long id) {
        String sql = "SELECT id, order_id, changed_by, old_status, new_status, note FROM OrderLogs WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapOrderLog(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Boolean update(OrderLog log) {
        String sql = "UPDATE OrderLogs SET order_id = ?, changed_by = ?, old_status = ?, new_status = ?, note = ? WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, log.getOrderId());
            ps.setLong(2, log.getChangedBy());
            ps.setString(3, log.getOldStatus());
            ps.setString(4, log.getNewStatus());
            ps.setNString(5, log.getNote());
            ps.setLong(6, log.getId());
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Boolean delete(long id) {
        String sql = "DELETE FROM OrderLogs WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private OrderLog mapOrderLog(ResultSet rs) throws Exception {
        OrderLog log = new OrderLog();
        log.setId(rs.getLong("id"));
        log.setOrderId(rs.getLong("order_id"));
        log.setChangedBy(rs.getLong("changed_by"));
        log.setOldStatus(rs.getString("old_status"));
        log.setNewStatus(rs.getString("new_status"));
        log.setNote(rs.getNString("note"));
        return log;
    }
}
