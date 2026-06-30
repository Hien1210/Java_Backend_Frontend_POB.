package org.example.daos;

import java.util.Map;

public interface ThongKeDAO {
    int getTotalAccounts();
    int getPendingShops();
    int getActiveShippers();
    int getViolationWarnings(); // nếu có bảng warning
    Map<String, Integer> getDashboardStats(); // trả về tất cả
}
