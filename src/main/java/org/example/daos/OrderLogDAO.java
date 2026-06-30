package org.example.daos;

import org.example.models.OrderLog;

import java.util.List;

public interface OrderLogDAO {
    Boolean create(OrderLog log);
    List<OrderLog> getAll();
    OrderLog findById(long id);
    Boolean update(OrderLog log);
    Boolean delete(long id);
}
