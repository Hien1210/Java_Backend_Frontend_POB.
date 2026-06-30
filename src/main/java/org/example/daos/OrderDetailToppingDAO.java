package org.example.daos;

import org.example.models.OrderDetailTopping;

import java.util.List;

public interface OrderDetailToppingDAO {
    Boolean create(OrderDetailTopping detailTopping);
    List<OrderDetailTopping> findByOrderDetailId(long orderDetailId);
}
