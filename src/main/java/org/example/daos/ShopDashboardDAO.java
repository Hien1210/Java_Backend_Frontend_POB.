package org.example.daos;

import org.example.models.ShopDashboardStats;

public interface ShopDashboardDAO {
    ShopDashboardStats getDashboardStats(long shopId);
}
