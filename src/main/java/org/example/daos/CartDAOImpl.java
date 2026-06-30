package org.example.daos;

import org.example.models.Cart;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class CartDAOImpl implements CartDAO {
    private static volatile CartSchema CACHED_SCHEMA;

    private static final String[] TABLE_CANDIDATES = {"Carts", "Cart"};
    private static final String[] ID_CANDIDATES = {"id"};
    private static final String[] USER_ID_CANDIDATES = {"user_id", "userid", "userId", "account_id", "accountid"};
    private static final String[] CREATED_AT_CANDIDATES = {"created_at", "createdat"};
    private static final String[] UPDATED_AT_CANDIDATES = {"updated_at", "updatedat"};
    private static final String[] IS_DELETED_CANDIDATES = {"is_deleted", "isdeleted", "deleted"};

    @Override
    public Boolean create(Cart cart) {
        try (Connection conn = openConnection()) {
            CartSchema schema = resolveSchema(conn);
            String sql = buildInsertSql(schema);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                int index = 1;
                ps.setLong(index++, cart.getUserId());
                if (schema.createdAt != null && cart.getCreatedAt() != null) {
                    ps.setTimestamp(index, Timestamp.valueOf(cart.getCreatedAt()));
                }
                return ps.executeUpdate() == 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Cart> getAll() {
        List<Cart> carts = new ArrayList<>();

        try (Connection conn = openConnection()) {
            CartSchema schema = resolveSchema(conn);
            String sql = buildSelectAllSql(schema);

            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    carts.add(mapCart(rs, schema));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return carts;
    }

    @Override
    public Cart findById(long id) {
        try (Connection conn = openConnection()) {
            CartSchema schema = resolveSchema(conn);
            String sql = buildSelectByIdSql(schema);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapCart(rs, schema);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public Boolean update(Cart cart) {
        try (Connection conn = openConnection()) {
            CartSchema schema = resolveSchema(conn);
            String sql = buildUpdateSql(schema);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                int index = 1;
                ps.setLong(index++, cart.getUserId());
                if (schema.createdAt != null) {
                    if (cart.getCreatedAt() == null) {
                        ps.setTimestamp(index++, null);
                    } else {
                        ps.setTimestamp(index++, Timestamp.valueOf(cart.getCreatedAt()));
                    }
                }
                ps.setLong(index, cart.getId());
                return ps.executeUpdate() == 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Boolean delete(long id) {
        try (Connection conn = openConnection()) {
            CartSchema schema = resolveSchema(conn);
            String sql;

            if (schema.isDeleted != null) {
                sql = "UPDATE " + q(schema.tableName) + " SET " + q(schema.isDeleted) + " = 1"
                        + (schema.updatedAt != null ? ", " + q(schema.updatedAt) + " = GETDATE()" : "")
                        + " WHERE " + q(schema.id) + " = ?";
            } else {
                sql = "DELETE FROM " + q(schema.tableName) + " WHERE " + q(schema.id) + " = ?";
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, id);
                return ps.executeUpdate() == 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private Connection openConnection() throws SQLException {
        Connection conn = DBUtil.getConnection();
        if (conn == null) {
            throw new SQLException("Khong the ket noi database");
        }
        return conn;
    }

    private CartSchema resolveSchema(Connection conn) throws SQLException {
        CartSchema cached = CACHED_SCHEMA;
        if (cached != null) {
            return cached;
        }

        synchronized (CartDAOImpl.class) {
            if (CACHED_SCHEMA == null) {
                String tableName = resolveTableName(conn, TABLE_CANDIDATES);
                Map<String, String> columns = loadColumns(conn, tableName);
                CACHED_SCHEMA = new CartSchema(
                        tableName,
                        resolveRequired(columns, ID_CANDIDATES),
                        resolveRequired(columns, USER_ID_CANDIDATES),
                        resolveOptional(columns, CREATED_AT_CANDIDATES),
                        resolveOptional(columns, UPDATED_AT_CANDIDATES),
                        resolveOptional(columns, IS_DELETED_CANDIDATES)
                );
            }
            return CACHED_SCHEMA;
        }
    }

    private String buildSelectAllSql(CartSchema schema) {
        StringBuilder sql = new StringBuilder("SELECT ");
        sql.append(String.join(", ", buildSelectColumns(schema)));
        sql.append(" FROM ").append(q(schema.tableName));
        if (schema.isDeleted != null) {
            sql.append(" WHERE ").append(q(schema.isDeleted)).append(" = 0");
        }
        sql.append(" ORDER BY ").append(q(schema.id)).append(" DESC");
        return sql.toString();
    }

    private String buildSelectByIdSql(CartSchema schema) {
        StringBuilder sql = new StringBuilder("SELECT ");
        sql.append(String.join(", ", buildSelectColumns(schema)));
        sql.append(" FROM ").append(q(schema.tableName));
        sql.append(" WHERE ").append(q(schema.id)).append(" = ?");
        if (schema.isDeleted != null) {
            sql.append(" AND ").append(q(schema.isDeleted)).append(" = 0");
        }
        return sql.toString();
    }

    private String buildInsertSql(CartSchema schema) {
        List<String> columns = new ArrayList<>();
        List<String> values = new ArrayList<>();
        addValue(columns, values, schema.userId, "?");

        if (schema.createdAt != null) {
            addValue(columns, values, schema.createdAt, "?");
        }
        if (schema.updatedAt != null) {
            addValue(columns, values, schema.updatedAt, "GETDATE()");
        }
        if (schema.isDeleted != null) {
            addValue(columns, values, schema.isDeleted, "0");
        }

        return "INSERT INTO " + q(schema.tableName)
                + " (" + String.join(", ", columns) + ") VALUES (" + String.join(", ", values) + ")";
    }

    private String buildUpdateSql(CartSchema schema) {
        List<String> sets = new ArrayList<>();
        sets.add(q(schema.userId) + " = ?");
        if (schema.createdAt != null) {
            sets.add(q(schema.createdAt) + " = ?");
        }
        if (schema.updatedAt != null) {
            sets.add(q(schema.updatedAt) + " = GETDATE()");
        }

        StringBuilder sql = new StringBuilder("UPDATE ");
        sql.append(q(schema.tableName)).append(" SET ").append(String.join(", ", sets));
        sql.append(" WHERE ").append(q(schema.id)).append(" = ?");
        if (schema.isDeleted != null) {
            sql.append(" AND ").append(q(schema.isDeleted)).append(" = 0");
        }
        return sql.toString();
    }

    private List<String> buildSelectColumns(CartSchema schema) {
        List<String> columns = new ArrayList<>();
        columns.add(q(schema.id));
        columns.add(q(schema.userId));
        if (schema.createdAt != null) {
            columns.add(q(schema.createdAt));
        }
        return columns;
    }

    private Cart mapCart(ResultSet rs, CartSchema schema) throws SQLException {
        Cart cart = new Cart();
        cart.setId(rs.getLong(schema.id));
        cart.setUserId(rs.getLong(schema.userId));
        cart.setCreatedAt(readTimestamp(rs, schema.createdAt));
        return cart;
    }

    private String resolveTableName(Connection conn, String... candidates) throws SQLException {
        Map<String, String> tables = new HashMap<>();
        DatabaseMetaData metaData = conn.getMetaData();
        try (ResultSet rs = metaData.getTables(conn.getCatalog(), null, "%", new String[]{"TABLE"})) {
            while (rs.next()) {
                String actual = rs.getString("TABLE_NAME");
                tables.put(normalizeIdentifier(actual), actual);
            }
        }

        for (String candidate : candidates) {
            String actual = tables.get(normalizeIdentifier(candidate));
            if (actual != null) {
                return actual;
            }
        }

        throw new SQLException("Khong tim thay bang Cart phu hop");
    }

    private Map<String, String> loadColumns(Connection conn, String tableName) throws SQLException {
        Map<String, String> columns = new HashMap<>();
        DatabaseMetaData metaData = conn.getMetaData();
        try (ResultSet rs = metaData.getColumns(conn.getCatalog(), null, tableName, null)) {
            while (rs.next()) {
                String actual = rs.getString("COLUMN_NAME");
                columns.put(normalizeIdentifier(actual), actual);
            }
        }
        return columns;
    }

    private String resolveRequired(Map<String, String> columns, String[] candidates) throws SQLException {
        String value = resolveOptional(columns, candidates);
        if (value == null) {
            throw new SQLException("Khong tim thay cot bat buoc: " + String.join(", ", candidates));
        }
        return value;
    }

    private String resolveOptional(Map<String, String> columns, String[] candidates) {
        for (String candidate : candidates) {
            String actual = columns.get(normalizeIdentifier(candidate));
            if (actual != null) {
                return actual;
            }
        }
        return null;
    }

    private LocalDateTime readTimestamp(ResultSet rs, String column) throws SQLException {
        if (column == null) {
            return null;
        }
        Timestamp timestamp = rs.getTimestamp(column);
        return timestamp == null ? null : timestamp.toLocalDateTime();
    }

    private void addValue(List<String> columns, List<String> values, String columnName, String valueSql) {
        columns.add(q(columnName));
        values.add(valueSql);
    }

    private String q(String identifier) {
        return "[" + identifier + "]";
    }

    private String normalizeIdentifier(String value) {
        return value == null ? "" : value.replaceAll("[^A-Za-z0-9]", "").toLowerCase(Locale.ROOT);
    }

    private static final class CartSchema {
        private final String tableName;
        private final String id;
        private final String userId;
        private final String createdAt;
        private final String updatedAt;
        private final String isDeleted;

        private CartSchema(String tableName, String id, String userId, String createdAt, String updatedAt, String isDeleted) {
            this.tableName = tableName;
            this.id = id;
            this.userId = userId;
            this.createdAt = createdAt;
            this.updatedAt = updatedAt;
            this.isDeleted = isDeleted;
        }
    }
}
