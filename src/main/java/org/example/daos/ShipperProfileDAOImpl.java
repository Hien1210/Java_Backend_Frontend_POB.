package org.example.daos;

import org.example.models.ShipperProfile;
import org.example.utils.DBUtil;

import java.sql.*;

public class ShipperProfileDAOImpl implements ShipperProfileDAO {

    @Override
    public ShipperProfile findByAccountId(long accountId) {
        String sql = "SELECT id, account_id, cccd, license_number, vehicle_type, vehicle_plate, " +
                     "vehicle_model, bank_account, bank_name, created_at, updated_at " +
                     "FROM Shipper_Profiles WHERE account_id = ?";
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
    public boolean save(ShipperProfile p) {
        String sql = "MERGE Shipper_Profiles AS target " +
                     "USING (SELECT ? AS account_id) AS source ON target.account_id = source.account_id " +
                     "WHEN MATCHED THEN UPDATE SET " +
                     "  cccd = ?, license_number = ?, vehicle_type = ?, vehicle_plate = ?, " +
                     "  vehicle_model = ?, bank_account = ?, bank_name = ?, updated_at = GETDATE() " +
                     "WHEN NOT MATCHED THEN INSERT " +
                     "  (account_id, cccd, license_number, vehicle_type, vehicle_plate, vehicle_model, bank_account, bank_name) " +
                     "  VALUES (?, ?, ?, ?, ?, ?, ?, ?);";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, p.getAccountId());
            // UPDATE branch
            ps.setString(2, p.getCccd());
            ps.setString(3, p.getLicenseNumber());
            ps.setNString(4, p.getVehicleType());
            ps.setString(5, p.getVehiclePlate());
            ps.setNString(6, p.getVehicleModel());
            ps.setString(7, p.getBankAccount());
            ps.setNString(8, p.getBankName());
            // INSERT branch
            ps.setLong(9, p.getAccountId());
            ps.setString(10, p.getCccd());
            ps.setString(11, p.getLicenseNumber());
            ps.setNString(12, p.getVehicleType());
            ps.setString(13, p.getVehiclePlate());
            ps.setNString(14, p.getVehicleModel());
            ps.setString(15, p.getBankAccount());
            ps.setNString(16, p.getBankName());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private ShipperProfile map(ResultSet rs) throws SQLException {
        ShipperProfile p = new ShipperProfile();
        p.setId(rs.getLong("id"));
        p.setAccountId(rs.getLong("account_id"));
        p.setCccd(rs.getString("cccd"));
        p.setLicenseNumber(rs.getString("license_number"));
        p.setVehicleType(rs.getString("vehicle_type"));
        p.setVehiclePlate(rs.getString("vehicle_plate"));
        p.setVehicleModel(rs.getString("vehicle_model"));
        p.setBankAccount(rs.getString("bank_account"));
        p.setBankName(rs.getString("bank_name"));
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) p.setCreatedAt(ca.toLocalDateTime());
        Timestamp ua = rs.getTimestamp("updated_at");
        if (ua != null) p.setUpdatedAt(ua.toLocalDateTime());
        return p;
    }
}
