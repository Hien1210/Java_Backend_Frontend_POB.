package org.example.daos;

import org.example.models.Product;

import java.util.List;

public interface ProductDAO {
    Boolean create(Product product);
    List<Product> getAll();
    Product findById(long id);
    Boolean update(Product product);
    Boolean delete(long id);

    // ✅ THIẾU: Lấy sản phẩm theo shop
    List<Product> findByShopId(long shopId);

    // ✅ THIẾU: Lấy sản phẩm theo shop và id
    Product findById(long id, long shopId);

    // ✅ THIẾU: Xóa sản phẩm theo shop
    boolean delete(long id, long shopId);
    long createAndReturnId(Product product);

    List<Product> findByCategoryId(long categoryId);
    List<Product> searchByName(String keyword);
    List<Product> searchByNameAndShop(String keyword, long shopId);
    int countByShopId(long shopId);
    int countByCategoryId(long categoryId);

    List<Product> findDeletedByShopId(long shopId);
    boolean restore(long id, long shopId);
}
