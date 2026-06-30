package org.example.daos;

import org.example.models.ProductSize;
import java.util.List;

public interface ProductSizeDAO {
    // ✅ THÊM CÁC METHOD SAU
    long create(ProductSize size);
    boolean update(ProductSize size);
    boolean delete(long id);
    boolean deleteByProductId(long productId);
    ProductSize findById(long id);
    List<ProductSize> findByProductId(long productId);
    List<ProductSize> findByShopId(long shopId);

}
