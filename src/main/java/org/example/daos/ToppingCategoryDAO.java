package org.example.daos;

import org.example.models.ToppingCategory;

import java.util.List;

public interface ToppingCategoryDAO {
    Boolean create(ToppingCategory category);
    List<ToppingCategory> getAll();
    ToppingCategory findById(long id);
    Boolean update(ToppingCategory category);
    Boolean delete(long id);
    List<ToppingCategory> findByShopId(long shopId);
    List<ToppingCategory> findDeletedByShopId(long shopId);
    Boolean restore(long id);
}