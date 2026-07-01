package org.example.daos;

import org.example.models.Category;

import java.util.List;

public interface CategoryDAO {
    Boolean create(Category category);
    List<Category> getAll();
    Category findById(long id);
    Boolean update(Category category);
    Boolean delete(long id);
    List<Category> findByShopId(long shopId);
    List<Category> findDeletedByShopId(long shopId);
    Boolean restore(long id);
}
