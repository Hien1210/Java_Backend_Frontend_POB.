package org.example.daos;

import org.example.models.Account;

import java.util.List;

public interface AccountDAO {

    Boolean dangkyNguoiDung(String username, String password, String email, String fullname, String phone);
    Boolean tonTaiEmail (String email);
    Boolean tonTaiUsername(String username);
    Boolean tonTaiEmailKhacId(String email, long id);
    Boolean tonTaiUsernameKhacId(String username, long id);
    Boolean capNhatMatKhauTheoEmail(String email, String password);
    Account DangNhap(String username, String password);
    List<Account> getAll();
    Account findById(long id);
    Boolean create(Account account);
    Boolean update(Account account);
    Boolean delete(long id);
    int getTotalAccounts();
    int countActiveShippers();
    List<Account> searchByUsernameOrEmail(String keyword);
    List<Account> getAll(String sortField, String sortOrder);
    List<Account> searchByUsernameOrEmail(String keyword, String sortField, String sortOrder);

    int countPendingShopAccounts();
    List<Account> findTop5PendingShopAccounts();
    List<Account> findPendingShopAccounts();
    boolean updateAccountStatus(long accountId, String status);
    boolean updateShipperOnlineStatus(long accountId, boolean isOnline);
}
