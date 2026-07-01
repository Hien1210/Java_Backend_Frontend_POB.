package org.example.daos;

import org.example.models.Topping;

import java.util.List;

public interface ToppingDAO {
    Boolean create(Topping topping);
    List<Topping> getAll();
    Topping findById(long id);
    Boolean update(Topping topping);
    Boolean delete(long id);
    List<Topping> findByShopId(long shopId);
    List<Topping> findDeletedByShopId(long shopId);
    Boolean restore(long id);
}
