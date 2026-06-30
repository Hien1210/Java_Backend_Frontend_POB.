package org.example.daos;

import org.example.models.OrderDetail;

import java.util.List;

public interface OrderDetailDAO {
    Boolean create(OrderDetail detail);
    long createAndReturnId(OrderDetail detail);
    List<OrderDetail> getAll();
    OrderDetail findById(long id);
    Boolean update(OrderDetail detail);
    Boolean delete(long id);
    List<OrderDetail> findByOrderId(long orderId);
}
