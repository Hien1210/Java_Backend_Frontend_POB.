package org.example.daos;


import org.example.models.Shop;

import java.util.List;

public interface ShopDAO {
    List<Shop> selectAllShops();
    List<Shop> selectPendingShops();
    Shop selectShopById(long id);
    Shop selectShopByOwnerId(long ownerId);
    void insertShop(Shop shop);
    void updateShop(Shop shop);
    boolean updateShopApproval(long shopId, String status, String rejectionReason, long approvedBy);
    void deleteShop(long id); // Xóa mềm (set isDeleted = true)
    int countPendingShops();
    List<Shop> findTop5PendingShops();
}
