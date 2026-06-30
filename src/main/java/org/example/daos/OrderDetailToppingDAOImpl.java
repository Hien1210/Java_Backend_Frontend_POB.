package org.example.daos;

import org.example.models.OrderDetailTopping;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class OrderDetailToppingDAOImpl implements OrderDetailToppingDAO {

    @Override
    public Boolean create(OrderDetailTopping detailTopping) {
        String sql = "INSERT INTO Order_Detail_Toppings (order_detail_id, topping_id, quantity, price) VALUES (?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, detailTopping.getOrderDetailId());
            ps.setLong(2, detailTopping.getToppingId());
            ps.setInt(3, detailTopping.getQuantity());
            ps.setDouble(4, detailTopping.getPrice());
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<OrderDetailTopping> findByOrderDetailId(long orderDetailId) {
        String sql = "SELECT id, order_detail_id, topping_id, quantity, price FROM Order_Detail_Toppings WHERE order_detail_id = ? ORDER BY id ASC";
        List<OrderDetailTopping> list = new ArrayList<>();
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, orderDetailId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetailTopping t = new OrderDetailTopping();
                    t.setId(rs.getLong("id"));
                    t.setOrderDetailId(rs.getLong("order_detail_id"));
                    t.setToppingId(rs.getLong("topping_id"));
                    t.setQuantity(rs.getInt("quantity"));
                    t.setPrice(rs.getDouble("price"));
                    list.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
