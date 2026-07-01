package org.example.daos;

import org.example.models.Category;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class CategoryDAOImpl implements CategoryDAO {
    private static volatile CategorySchema CACHED_SCHEMA;

    private static final String[] TABLE_CANDIDATES = { "Categories", "Category" };
    private static final String[] ID_CANDIDATES = { "id" };
    private static final String[] SHOP_ID_CANDIDATES = { "shop_id", "shopid", "shopId" };
    private static final String[] CATEGORY_NAME_CANDIDATES = { "category_name", "categoryname", "categoryName",
            "name" };
    private static final String[] STATUS_CANDIDATES = { "status", "staTus" };
    private static final String[] IS_DELETED_CANDIDATES = { "is_deleted", "isdeleted", "deleted" };

    @Override
    public Boolean create(Category category) {
        try (Connection conn = openConnection()) {
            CategorySchema schema = resolveSchema(conn);
            String sql = buildInsertSql(schema);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                bindInsert(ps, schema, category);
                return ps.executeUpdate() == 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Category> getAll() {
        List<Category> categories = new ArrayList<>();

        try (Connection conn = openConnection()) {
            CategorySchema schema = resolveSchema(conn);
            String sql = buildSelectAllSql(schema);

            try (PreparedStatement ps = conn.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    categories.add(mapCategory(rs, schema));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return categories;
    }

    @Override
    public Category findById(long id) {
        try (Connection conn = openConnection()) {
            CategorySchema schema = resolveSchema(conn);
            String sql = buildSelectByIdSql(schema);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapCategory(rs, schema);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public Boolean update(Category category) {
        try (Connection conn = openConnection()) {
            CategorySchema schema = resolveSchema(conn);
            String sql = buildUpdateSql(schema);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                bindUpdate(ps, schema, category);
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
            CategorySchema schema = resolveSchema(conn);

            if (schema.isDeleted != null) {
                String sql = "UPDATE " + q(schema.tableName) + " SET " + q(schema.isDeleted) + " = 1"
                        + " WHERE " + q(schema.id) + " = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setLong(1, id);
                    return ps.executeUpdate() == 1;
                }
            }

            String sql = "DELETE FROM " + q(schema.tableName) + " WHERE " + q(schema.id) + " = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, id);
                return ps.executeUpdate() == 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Category> findByShopId(long shopId) {
        List<Category> categories = new ArrayList<>();

        try (Connection conn = openConnection()) {
            CategorySchema schema = resolveSchema(conn);

            String sql = "SELECT " + String.join(", ", buildSelectColumns(schema)) +
                    " FROM " + q(schema.tableName) +
                    " WHERE " + q(schema.shopId) + " = ?";

            if (schema.isDeleted != null) {
                sql += " AND " + q(schema.isDeleted) + " = 0";
            }
            sql += " ORDER BY " + q(schema.id) + " ASC";

            System.out.println("SQL: " + sql); // ✅ THÊM LOG

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, shopId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        categories.add(mapCategory(rs, schema));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        System.out.println("Categories found: " + categories.size()); // ✅ THÊM LOG
        return categories;
    }

    @Override
    public List<Category> findDeletedByShopId(long shopId) {
        List<Category> categories = new ArrayList<>();
        try (Connection conn = openConnection()) {
            CategorySchema schema = resolveSchema(conn);
            if (schema.isDeleted == null || schema.shopId == null) return categories;
            String sql = "SELECT " + String.join(", ", buildSelectColumns(schema)) +
                    " FROM " + q(schema.tableName) +
                    " WHERE " + q(schema.shopId) + " = ?" +
                    " AND " + q(schema.isDeleted) + " = 1" +
                    " ORDER BY " + q(schema.id) + " DESC";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, shopId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) categories.add(mapCategory(rs, schema));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

    @Override
    public Boolean restore(long id) {
        try (Connection conn = openConnection()) {
            CategorySchema schema = resolveSchema(conn);
            if (schema.isDeleted == null) return false;
            String sql = "UPDATE " + q(schema.tableName) + " SET " + q(schema.isDeleted) + " = 0" +
                    " WHERE " + q(schema.id) + " = ?";
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

    private CategorySchema resolveSchema(Connection conn) throws SQLException {
        CategorySchema cached = CACHED_SCHEMA;
        if (cached != null) {
            return cached;
        }

        synchronized (CategoryDAOImpl.class) {
            if (CACHED_SCHEMA == null) {
                String tableName = resolveTableName(conn, TABLE_CANDIDATES);
                Map<String, String> columns = loadColumns(conn, tableName);
                CACHED_SCHEMA = new CategorySchema(
                        tableName,
                        resolveRequired(columns, ID_CANDIDATES),
                        resolveOptional(columns, SHOP_ID_CANDIDATES),
                        resolveRequired(columns, CATEGORY_NAME_CANDIDATES),
                        resolveOptional(columns, STATUS_CANDIDATES),
                        resolveOptional(columns, IS_DELETED_CANDIDATES));
            }
            return CACHED_SCHEMA;
        }
    }

    private String buildSelectAllSql(CategorySchema schema) {
        StringBuilder sql = new StringBuilder("SELECT ");
        sql.append(String.join(", ", buildSelectColumns(schema)));
        sql.append(" FROM ").append(q(schema.tableName));
        if (schema.isDeleted != null) {
            sql.append(" WHERE ").append(q(schema.isDeleted)).append(" = 0");
        }
        sql.append(" ORDER BY ").append(q(schema.id)).append(" DESC");
        return sql.toString();
    }

    private String buildSelectByIdSql(CategorySchema schema) {
        StringBuilder sql = new StringBuilder("SELECT ");
        sql.append(String.join(", ", buildSelectColumns(schema)));
        sql.append(" FROM ").append(q(schema.tableName));
        sql.append(" WHERE ").append(q(schema.id)).append(" = ?");
        if (schema.isDeleted != null) {
            sql.append(" AND ").append(q(schema.isDeleted)).append(" = 0");
        }
        return sql.toString();
    }

    private String buildInsertSql(CategorySchema schema) {
        List<String> columns = new ArrayList<>();
        List<String> values = new ArrayList<>();

        if (schema.shopId != null) {
            addValue(columns, values, schema.shopId, "?");
        }
        addValue(columns, values, schema.categoryName, "?");
        if (schema.status != null) {
            addValue(columns, values, schema.status, "?");
        }
        if (schema.isDeleted != null) {
            addValue(columns, values, schema.isDeleted, "0");
        }

        return "INSERT INTO " + q(schema.tableName)
                + " (" + String.join(", ", columns) + ") VALUES (" + String.join(", ", values) + ")";
    }

    private String buildUpdateSql(CategorySchema schema) {
        List<String> sets = new ArrayList<>();

        if (schema.shopId != null) {
            addSet(sets, schema.shopId);
        }
        addSet(sets, schema.categoryName);
        if (schema.status != null) {
            addSet(sets, schema.status);
        }

        StringBuilder sql = new StringBuilder("UPDATE ");
        sql.append(q(schema.tableName)).append(" SET ").append(String.join(", ", sets));
        sql.append(" WHERE ").append(q(schema.id)).append(" = ?");
        if (schema.isDeleted != null) {
            sql.append(" AND ").append(q(schema.isDeleted)).append(" = 0");
        }
        return sql.toString();
    }

    private void bindInsert(PreparedStatement ps, CategorySchema schema, Category category) throws SQLException {
        int index = 1;
        if (schema.shopId != null) {
            ps.setLong(index++, category.getShopId());
        }
        ps.setNString(index++, category.getCategoryName());
        if (schema.status != null) {
            ps.setNString(index, normalizeStatus(category.getStatus()));
        }
    }

    private void bindUpdate(PreparedStatement ps, CategorySchema schema, Category category) throws SQLException {
        int index = 1;
        if (schema.shopId != null) {
            ps.setLong(index++, category.getShopId());
        }
        ps.setNString(index++, category.getCategoryName());
        if (schema.status != null) {
            ps.setNString(index++, normalizeStatus(category.getStatus()));
        }
        ps.setLong(index, category.getId());
    }

    private List<String> buildSelectColumns(CategorySchema schema) {
        List<String> columns = new ArrayList<>();
        columns.add(q(schema.id));
        if (schema.shopId != null) {
            columns.add(q(schema.shopId));
        }
        columns.add(q(schema.categoryName));
        if (schema.status != null) {
            columns.add(q(schema.status));
        }
        if (schema.isDeleted != null) {
            columns.add(q(schema.isDeleted));
        }
        return columns;
    }

    private Category mapCategory(ResultSet rs, CategorySchema schema) throws SQLException {
        Category category = new Category();
        category.setId(rs.getLong(schema.id));
        if (schema.shopId != null) {
            category.setShopId(rs.getLong(schema.shopId));
        }
        category.setCategoryName(rs.getNString(schema.categoryName));
        if (schema.status != null) {
            category.setStatus(normalizeStatus(rs.getNString(schema.status)));
        }
        if (schema.isDeleted != null) {
            category.setDeleted(rs.getBoolean(schema.isDeleted));
        }
        return category;
    }

    private String resolveTableName(Connection conn, String... candidates) throws SQLException {
        Map<String, String> tables = new HashMap<>();
        DatabaseMetaData metaData = conn.getMetaData();
        try (ResultSet rs = metaData.getTables(conn.getCatalog(), null, "%", new String[] { "TABLE" })) {
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

        throw new SQLException("Khong tim thay bang Category phu hop");
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

    private void addValue(List<String> columns, List<String> values, String columnName, String valueSql) {
        columns.add(q(columnName));
        values.add(valueSql);
    }

    private void addSet(List<String> sets, String columnName) {
        sets.add(q(columnName) + " = ?");
    }

    private String normalizeStatus(String status) {
        String value = status == null ? "" : status.trim();
        return value.isBlank() ? "ACTIVE" : value.toUpperCase(Locale.ROOT);
    }

    private String q(String identifier) {
        return "[" + identifier + "]";
    }

    private String normalizeIdentifier(String value) {
        return value == null ? "" : value.replaceAll("[^A-Za-z0-9]", "").toLowerCase(Locale.ROOT);
    }

    private static final class CategorySchema {
        private final String tableName;
        private final String id;
        private final String shopId;
        private final String categoryName;
        private final String status;
        private final String isDeleted;

        private CategorySchema(String tableName, String id, String shopId, String categoryName, String status,
                String isDeleted) {
            this.tableName = tableName;
            this.id = id;
            this.shopId = shopId;
            this.categoryName = categoryName;
            this.status = status;
            this.isDeleted = isDeleted;
        }
    }
}
