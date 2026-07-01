package org.example.daos;

import org.example.models.UserProfile;
import org.example.utils.DBUtil;

import java.sql.*;

public class UserProfileDAOImpl implements UserProfileDAO {

    @Override
    public UserProfile findByAccountId(long accountId) {
        String sql = "SELECT id, account_id, date_of_birth, gender, default_address_id, created_at, updated_at " +
                     "FROM User_Profiles WHERE account_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean save(UserProfile p) {
        String sql = "MERGE User_Profiles AS target " +
                     "USING (SELECT ? AS account_id) AS source ON target.account_id = source.account_id " +
                     "WHEN MATCHED THEN UPDATE SET " +
                     "  date_of_birth = ?, gender = ?, updated_at = GETDATE() " +
                     "WHEN NOT MATCHED THEN INSERT (account_id, date_of_birth, gender) " +
                     "  VALUES (?, ?, ?);";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, p.getAccountId());
            // UPDATE branch
            ps.setObject(2, p.getDateOfBirth() != null ? Date.valueOf(p.getDateOfBirth()) : null);
            ps.setString(3, p.getGender());
            // INSERT branch
            ps.setLong(4, p.getAccountId());
            ps.setObject(5, p.getDateOfBirth() != null ? Date.valueOf(p.getDateOfBirth()) : null);
            ps.setString(6, p.getGender());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private UserProfile map(ResultSet rs) throws SQLException {
        UserProfile p = new UserProfile();
        p.setId(rs.getLong("id"));
        p.setAccountId(rs.getLong("account_id"));
        Date dob = rs.getDate("date_of_birth");
        if (dob != null) p.setDateOfBirth(dob.toLocalDate());
        p.setGender(rs.getString("gender"));
        long daid = rs.getLong("default_address_id");
        if (!rs.wasNull()) p.setDefaultAddressId(daid);
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) p.setCreatedAt(ca.toLocalDateTime());
        Timestamp ua = rs.getTimestamp("updated_at");
        if (ua != null) p.setUpdatedAt(ua.toLocalDateTime());
        return p;
    }
}
