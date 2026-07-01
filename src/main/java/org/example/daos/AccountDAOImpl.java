package org.example.daos;

import org.example.models.Account;
import org.example.utils.DBUtil;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AccountDAOImpl implements AccountDAO {
    @Override
    public Boolean dangkyNguoiDung(String username, String password, String email, String fullname, String phone) {
        String sql = "INSERT INTO Accounts (username, password, email, full_name, phone, role_id) VALUES (?, ?, ?, ?, ?, 3)";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, username);
            pst.setString(2, password);
            pst.setString(3, email);
            pst.setNString(4, fullname);
            pst.setString(5, phone);
            return pst.executeUpdate() == 1;

        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        }
    }

    @Override
    public Boolean tonTaiEmail(String email) {
        String sql = "SELECT 1 FROM Accounts WHERE email = ?";
        return exists(sql, email);
    }

    @Override
    public Boolean tonTaiUsername(String username) {
        String sql = "SELECT 1 FROM Accounts WHERE username = ?";
        return exists(sql, username);
    }

    @Override
    public Boolean tonTaiEmailKhacId(String email, long id) {
        String sql = "SELECT 1 FROM Accounts WHERE email = ? AND id <> ?";
        return exists(sql, email, id);
    }

    @Override
    public Boolean tonTaiUsernameKhacId(String username, long id) {
        String sql = "SELECT 1 FROM Accounts WHERE username = ? AND id <> ?";
        return exists(sql, username, id);
    }

    @Override
    public Boolean capNhatMatKhauTheoEmail(String email, String password) {
        String sql = "UPDATE Accounts SET password = ? WHERE email = ?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, password);
            pst.setString(2, email);
            return pst.executeUpdate() == 1;

        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        }
    }

    @Override
    public Account DangNhap(String username, String password) {
        String sql = "SELECT id, username, password, email, full_name, phone, avatar_url, role_id FROM Accounts WHERE username = ?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, username);

            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    Account acc = mapAccount(rs);
                    if (BCrypt.checkpw(password, acc.getPassWord())) {
                        return acc;
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<Account> getAll() {
        String sql = "SELECT id, username, password, email, full_name, phone, avatar_url, role_id FROM Accounts ORDER BY id DESC";
        List<Account> danhsach = new ArrayList<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                danhsach.add(mapAccount(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return danhsach;
    }

    @Override
    public Account findById(long id) {
        String sql = "SELECT id, username, password, email, full_name, phone, avatar_url, role_id FROM Accounts WHERE id = ?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setLong(1, id);

            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return mapAccount(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public Boolean create(Account account) {
        String sql = "INSERT INTO Accounts (username, password, email, full_name, phone, avatar_url, role_id) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, account.getUserName());
            pst.setString(2, account.getPassWord());
            pst.setString(3, account.getEmail());
            pst.setNString(4, account.getFullName());
            pst.setString(5, account.getPhone());
            pst.setString(6, account.getAvatarUrl());
            pst.setLong(7, account.getRoleId());
            return pst.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Boolean update(Account account) {
        boolean updatePassword = account.getPassWord() != null && !account.getPassWord().isBlank();
        String sql = updatePassword
                ? "UPDATE Accounts SET username = ?, email = ?, full_name = ?, phone = ?, avatar_url = ?, role_id = ?, password = ? WHERE id = ?"
                : "UPDATE Accounts SET username = ?, email = ?, full_name = ?, phone = ?, avatar_url = ?, role_id = ? WHERE id = ?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, account.getUserName());
            pst.setString(2, account.getEmail());
            pst.setNString(3, account.getFullName());
            pst.setString(4, account.getPhone());
            pst.setString(5, account.getAvatarUrl());
            pst.setLong(6, account.getRoleId());

            if (updatePassword) {
                pst.setString(7, account.getPassWord());
                pst.setLong(8, account.getId());
            } else {
                pst.setLong(7, account.getId());
            }

            return pst.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Boolean delete(long id) {
        String sql = "DELETE FROM Accounts WHERE id = ?";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setLong(1, id);
            return pst.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int getTotalAccounts() {
        String sql = "SELECT COUNT(*) FROM Accounts WHERE is_deleted = 0";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int countActiveShippers() {
        String sql = "SELECT COUNT(*) FROM Accounts WHERE role_id = 4 AND status = 'ACTIVE' AND is_deleted = 0";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<Account> searchByUsernameOrEmail(String keyword) {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT * FROM Accounts WHERE is_deleted = 0 " +
                "AND (username LIKE ? OR email LIKE ?) " +
                "ORDER BY id DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Account account = new Account();
                account.setId(rs.getLong("id"));
                account.setUserName(rs.getString("username"));
                account.setPassWord(rs.getString("password"));
                account.setEmail(rs.getString("email"));
                account.setFullName(rs.getString("full_name"));
                account.setPhone(rs.getString("phone"));
                account.setAvatarUrl(rs.getString("avatar_url"));
                account.setRoleId(rs.getLong("role_id"));
                account.setStaTus(rs.getString("status"));
                account.setDeleted(rs.getBoolean("is_deleted"));

                java.sql.Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    account.setCreatedAt(createdAt.toLocalDateTime());
                }
                java.sql.Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    account.setUpdatedAt(updatedAt.toLocalDateTime());
                }

                accounts.add(account);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return accounts;
    }

    @Override
    public List<Account> getAll(String sortField, String sortOrder) {
        List<Account> accounts = new ArrayList<>();

        // Xác định cột sắp xếp
        String orderBy = "id";
        if (sortField != null) {
            switch (sortField) {
                case "username":
                    orderBy = "username";
                    break;
                case "fullname":
                    orderBy = "full_name";
                    break;
                case "email":
                    orderBy = "email";
                    break;
                case "role":
                    orderBy = "role_id";
                    break;
                case "id":
                default:
                    orderBy = "id";
                    break;
            }
        }

        // Xác định thứ tự sắp xếp
        String order = "DESC";
        if ("ASC".equalsIgnoreCase(sortOrder)) {
            order = "ASC";
        }

        String sql = "SELECT * FROM Accounts WHERE is_deleted = 0 ORDER BY " + orderBy + " " + order;

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Account account = new Account();
                account.setId(rs.getLong("id"));
                account.setUserName(rs.getString("username"));
                account.setPassWord(rs.getString("password"));
                account.setEmail(rs.getString("email"));
                account.setFullName(rs.getString("full_name"));
                account.setPhone(rs.getString("phone"));
                account.setAvatarUrl(rs.getString("avatar_url"));
                account.setRoleId(rs.getLong("role_id"));
                account.setStaTus(rs.getString("status"));
                account.setDeleted(rs.getBoolean("is_deleted"));

                java.sql.Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    account.setCreatedAt(createdAt.toLocalDateTime());
                }
                java.sql.Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    account.setUpdatedAt(updatedAt.toLocalDateTime());
                }

                accounts.add(account);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return accounts;
    }

    @Override
    public List<Account> searchByUsernameOrEmail(String keyword, String sortField, String sortOrder) {
        List<Account> accounts = new ArrayList<>();

        // Xác định cột sắp xếp
        String orderBy = "id";
        if (sortField != null) {
            switch (sortField) {
                case "username":
                    orderBy = "username";
                    break;
                case "fullname":
                    orderBy = "full_name";
                    break;
                case "email":
                    orderBy = "email";
                    break;
                case "role":
                    orderBy = "role_id";
                    break;
                case "id":
                default:
                    orderBy = "id";
                    break;
            }
        }

        // Xác định thứ tự sắp xếp
        String order = "DESC";
        if ("ASC".equalsIgnoreCase(sortOrder)) {
            order = "ASC";
        }

        String sql = "SELECT * FROM Accounts WHERE is_deleted = 0 " +
                "AND (username LIKE ? OR email LIKE ?) " +
                "ORDER BY " + orderBy + " " + order;

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Account account = new Account();
                account.setId(rs.getLong("id"));
                account.setUserName(rs.getString("username"));
                account.setPassWord(rs.getString("password"));
                account.setEmail(rs.getString("email"));
                account.setFullName(rs.getString("full_name"));
                account.setPhone(rs.getString("phone"));
                account.setAvatarUrl(rs.getString("avatar_url"));
                account.setRoleId(rs.getLong("role_id"));
                account.setStaTus(rs.getString("status"));
                account.setDeleted(rs.getBoolean("is_deleted"));

                java.sql.Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    account.setCreatedAt(createdAt.toLocalDateTime());
                }
                java.sql.Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    account.setUpdatedAt(updatedAt.toLocalDateTime());
                }

                accounts.add(account);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return accounts;
    }

    private Boolean exists(String sql, String value) {
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, value);

            try (ResultSet rs = pst.executeQuery()) {
                return rs.next();
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            return true;
        }
    }

    private Boolean exists(String sql, String value, long id) {
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, value);
            pst.setLong(2, id);

            try (ResultSet rs = pst.executeQuery()) {
                return rs.next();
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            return true;
        }
    }

    private Account mapAccount(ResultSet rs) throws SQLException {
        Account acc = new Account();
        acc.setAvatarUrl(rs.getString("avatar_url"));
        acc.setEmail(rs.getString("email"));
        acc.setId(rs.getLong("id"));
        acc.setPassWord(rs.getString("password"));
        acc.setFullName(rs.getString("full_name"));
        acc.setPhone(rs.getString("phone"));
        acc.setRoleId(rs.getLong("role_id"));
        acc.setUserName(rs.getString("username"));
        try { acc.setOnline(rs.getBoolean("is_online")); } catch (SQLException ignored) {}
        return acc;
    }

    @Override
    public int countPendingShopAccounts() {
        String sql = "SELECT COUNT(*) FROM Accounts WHERE role_id = 2 AND (status IS NULL OR LOWER(status) != 'active') AND is_deleted = 0";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<Account> findTop5PendingShopAccounts() {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT TOP 5 * FROM Accounts WHERE role_id = 2 AND (status IS NULL OR LOWER(status) != 'active') AND is_deleted = 0 ORDER BY created_at DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                list.add(mapAccountFull(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Account> findPendingShopAccounts() {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT * FROM Accounts WHERE role_id = 2 AND (status IS NULL OR LOWER(status) != 'active') AND is_deleted = 0 ORDER BY created_at DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                list.add(mapAccountFull(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean updateAccountStatus(long accountId, String status) {
        String sql = "UPDATE Accounts SET status = ?, updated_at = GETDATE() WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setLong(2, accountId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateShipperOnlineStatus(long accountId, boolean isOnline) {
        String sql = "UPDATE Accounts SET is_online = ?, updated_at = GETDATE() WHERE id = ? AND role_id = 4";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isOnline);
            ps.setLong(2, accountId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private Account mapAccountFull(ResultSet rs) throws SQLException {
        Account account = new Account();
        account.setId(rs.getLong("id"));
        account.setUserName(rs.getString("username"));
        account.setPassWord(rs.getString("password"));
        account.setEmail(rs.getString("email"));
        account.setFullName(rs.getString("full_name"));
        account.setPhone(rs.getString("phone"));
        account.setAvatarUrl(rs.getString("avatar_url"));
        account.setRoleId(rs.getLong("role_id"));
        account.setStaTus(rs.getString("status"));
        account.setDeleted(rs.getBoolean("is_deleted"));
        try { account.setOnline(rs.getBoolean("is_online")); } catch (SQLException ignored) {}

        java.sql.Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            account.setCreatedAt(createdAt.toLocalDateTime());
        }
        java.sql.Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            account.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        return account;
    }
}
