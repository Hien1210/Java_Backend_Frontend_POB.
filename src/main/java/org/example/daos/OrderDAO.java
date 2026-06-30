package org.example.daos;

import org.example.models.Order;

import java.util.List;

public interface OrderDAO {
    Boolean create(Order order);
    long createAndReturnId(Order order);
    List<Order> getAll();
    List<Order> findByShopId(long shopId);
    List<Order> findByShipperId(long shipperId);
    Order findById(long id);
    Boolean update(Order order);
    Boolean delete(long id);
    Boolean updatePaymentStatus(long id, long shopId, String paymentStatus);
    Boolean setPayosOrderCode(long id, long payosOrderCode);
    List<Order> findByPayosOrderCode(long payosOrderCode);
    Boolean updatePaymentStatusByPayosOrderCode(long payosOrderCode, String paymentStatus);
}
