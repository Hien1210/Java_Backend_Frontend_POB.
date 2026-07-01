package org.example.daos;

import org.example.models.Product;
import org.example.utils.DBUtil;

import java.sql.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class ProductDAOImpl implements ProductDAO {
    private static volatile ProductSchema CACHED_SCHEMA;

    // ─── Các hằng số tìm cột ──────────────────────────────────────
    private static final String[] TABLE_CANDIDATES = {"Products", "Product"};
    private static final String[] ID_CANDIDATES = {"id"};
    private static final String[] SHOP_ID_CANDIDATES = {"shop_id", "shopid", "shopId"};
    private static final String[] CATEGORY_ID_CANDIDATES = {"category_id", "categoryid", "categoryId"};
    private static final String[] PRODUCT_NAME_CANDIDATES = {"product_name", "productname", "name"};
    private static final String[] DESCRIPTION_CANDIDATES = {"description"};
    private static final String[] SOLD_QUANTITY_CANDIDATES = {"stock_quantity", "stockquantity", "stockQuantity"};
    private static final String[] SOLD_COUNT_CANDIDATES = {"sold_count", "soldcount", "soldCount"};
    private static final String[] STATUS_CANDIDATES = {"status", "staTus"};
    private static final String[] IS_DELETED_CANDIDATES = {"is_deleted", "isdeleted", "deleted"};
    private static final String[] CREATED_AT_CANDIDATES = {"created_at", "createdat"};
    private static final String[] UPDATED_AT_CANDIDATES = {"updated_at", "updatedat"};

    @Override
    public Boolean create(Product product) {
        try (Connection conn = openConnection()) {
            ProductSchema schema = resolveSchema(conn);
            String sql = buildInsertSql(schema);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                bindInsert(ps, schema, product);
                return ps.executeUpdate() == 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Product> getAll() {
        List<Product> products = new ArrayList<>();

        try (Connection conn = openConnection()) {
            ProductSchema schema = resolveSchema(conn);
            String sql = buildSelectAllSql(schema);

            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProduct(rs, schema));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return products;
    }

    @Override
    public Product findById(long id) {
        try (Connection conn = openConnection()) {
            ProductSchema schema = resolveSchema(conn);
            String sql = buildSelectByIdSql(schema);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapProduct(rs, schema);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public Boolean update(Product product) {
        try (Connection conn = openConnection()) {
            ProductSchema schema = resolveSchema(conn);
            String sql = buildUpdateSql(schema);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                bindUpdate(ps, schema, product);
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
            ProductSchema schema = resolveSchema(conn);

            if (schema.isDeleted != null) {
                String sql = "UPDATE " + q(schema.tableName) + " SET " + q(schema.isDeleted) + " = 1"
                        + (schema.updatedAt != null ? ", " + q(schema.updatedAt) + " = GETDATE()" : "")
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
    public List<Product> findByShopId(long shopId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE shop_id = ? AND is_deleted = 0 ORDER BY id DESC";

        try (Connection conn = openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, shopId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapProduct(rs, resolveSchema(conn)));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }

    @Override
    public Product findById(long id, long shopId) {
        try (Connection conn = openConnection()) {
            ProductSchema schema = resolveSchema(conn);

            String sql = "SELECT " + String.join(", ", buildSelectColumns(schema)) +
                    " FROM " + q(schema.tableName) +
                    " WHERE " + q(schema.id) + " = ?" +
                    " AND " + q(schema.shopId) + " = ?";

            if (schema.isDeleted != null) {
                sql += " AND " + q(schema.isDeleted) + " = 0";
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, id);
                ps.setLong(2, shopId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapProduct(rs, schema);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean delete(long id, long shopId) {
        try (Connection conn = openConnection()) {
            ProductSchema schema = resolveSchema(conn);

            if (schema.isDeleted != null) {
                String sql = "UPDATE " + q(schema.tableName) +
                        " SET " + q(schema.isDeleted) + " = 1" +
                        (schema.updatedAt != null ? ", " + q(schema.updatedAt) + " = GETDATE()" : "") +
                        " WHERE " + q(schema.id) + " = ?" +
                        " AND " + q(schema.shopId) + " = ?";

                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setLong(1, id);
                    ps.setLong(2, shopId);
                    return ps.executeUpdate() == 1;
                }
            }

            String sql = "DELETE FROM " + q(schema.tableName) +
                    " WHERE " + q(schema.id) + " = ?" +
                    " AND " + q(schema.shopId) + " = ?";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, id);
                ps.setLong(2, shopId);
                return ps.executeUpdate() == 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Product> findDeletedByShopId(long shopId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE shop_id = ? AND is_deleted = 1 ORDER BY id DESC";
        try (Connection conn = openConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                ProductSchema schema = resolveSchema(conn);
                while (rs.next()) {
                    products.add(mapProduct(rs, schema));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }

    @Override
    public boolean restore(long id, long shopId) {
        try (Connection conn = openConnection()) {
            ProductSchema schema = resolveSchema(conn);
            if (schema.isDeleted == null) return false;
            String sql = "UPDATE " + q(schema.tableName) + " SET " + q(schema.isDeleted) + " = 0"
                    + (schema.updatedAt != null ? ", " + q(schema.updatedAt) + " = GETDATE()" : "")
                    + " WHERE " + q(schema.id) + " = ? AND " + q(schema.shopId) + " = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, id);
                ps.setLong(2, shopId);
                return ps.executeUpdate() == 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public long createAndReturnId(Product product) {
        String sql = "INSERT INTO Products (shop_id, category_id, product_name, description, stock_quantity, sold_count, status, is_deleted) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, 0)";

        try (Connection conn = openConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            int index = 1;
            ps.setLong(index++, product.getShopId());
            ps.setLong(index++, product.getCategoryId());
            ps.setString(index++, product.getProductName());
            ps.setString(index++, product.getDescription());
            ps.setInt(index++, product.getStockQuantity());
            ps.setInt(index++, product.getSoldCount());
            ps.setString(index++, product.getStaTus());
            // ❌ XÓA: ps.setString(index++, product.getImageUrl());

            int affected = ps.executeUpdate();
            if (affected == 0) return 0;

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<Product> findByCategoryId(long categoryId) {
        List<Product> products = new ArrayList<>();

        try (Connection conn = openConnection()) {
            ProductSchema schema = resolveSchema(conn);

            String sql = "SELECT " + String.join(", ", buildSelectColumns(schema)) +
                    " FROM " + q(schema.tableName) +
                    " WHERE " + q(schema.categoryId) + " = ?";

            if (schema.isDeleted != null) {
                sql += " AND " + q(schema.isDeleted) + " = 0";
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, categoryId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        products.add(mapProduct(rs, schema));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return products;
    }

    @Override
    public List<Product> searchByName(String keyword) {
        List<Product> products = new ArrayList<>();

        try (Connection conn = openConnection()) {
            ProductSchema schema = resolveSchema(conn);

            String sql = "SELECT " + String.join(", ", buildSelectColumns(schema)) +
                    " FROM " + q(schema.tableName) +
                    " WHERE " + q(schema.productName) + " LIKE ?";

            if (schema.isDeleted != null) {
                sql += " AND " + q(schema.isDeleted) + " = 0";
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, "%" + keyword + "%");
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        products.add(mapProduct(rs, schema));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return products;
    }

    @Override
    public List<Product> searchByNameAndShop(String keyword, long shopId) {
        List<Product> products = new ArrayList<>();

        try (Connection conn = openConnection()) {
            ProductSchema schema = resolveSchema(conn);

            String sql = "SELECT " + String.join(", ", buildSelectColumns(schema)) +
                    " FROM " + q(schema.tableName) +
                    " WHERE " + q(schema.shopId) + " = ?" +
                    " AND " + q(schema.productName) + " LIKE ?";

            if (schema.isDeleted != null) {
                sql += " AND " + q(schema.isDeleted) + " = 0";
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, shopId);
                ps.setString(2, "%" + keyword + "%");
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        products.add(mapProduct(rs, schema));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return products;
    }

    @Override
    public int countByShopId(long shopId) {
        try (Connection conn = openConnection()) {
            ProductSchema schema = resolveSchema(conn);

            String sql = "SELECT COUNT(*) FROM " + q(schema.tableName) +
                    " WHERE " + q(schema.shopId) + " = ?";

            if (schema.isDeleted != null) {
                sql += " AND " + q(schema.isDeleted) + " = 0";
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, shopId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    @Override
    public int countByCategoryId(long categoryId) {
        try (Connection conn = openConnection()) {
            ProductSchema schema = resolveSchema(conn);

            String sql = "SELECT COUNT(*) FROM " + q(schema.tableName) +
                    " WHERE " + q(schema.categoryId) + " = ?";

            if (schema.isDeleted != null) {
                sql += " AND " + q(schema.isDeleted) + " = 0";
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, categoryId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    private Connection openConnection() throws SQLException {
        Connection conn = DBUtil.getConnection();
        if (conn == null) {
            throw new SQLException("Khong the ket noi database");
        }
        return conn;
    }

    private ProductSchema resolveSchema(Connection conn) throws SQLException {
        ProductSchema cached = CACHED_SCHEMA;
        if (cached != null) {
            return cached;
        }

        synchronized (ProductDAOImpl.class) {
            if (CACHED_SCHEMA == null) {
                String tableName = resolveTableName(conn, TABLE_CANDIDATES);
                Map<String, String> columns = loadColumns(conn, tableName);
                CACHED_SCHEMA = new ProductSchema(
                        tableName,
                        resolveRequired(columns, ID_CANDIDATES),
                        resolveRequired(columns, SHOP_ID_CANDIDATES),
                        resolveRequired(columns, CATEGORY_ID_CANDIDATES),
                        resolveRequired(columns, PRODUCT_NAME_CANDIDATES),
                        resolveOptional(columns, DESCRIPTION_CANDIDATES),
                        // resolveRequired(columns, PRICE_CANDIDATES), // ← ĐÃ XÓA PRICE
                        resolveOptional(columns, SOLD_QUANTITY_CANDIDATES),
                        resolveOptional(columns, SOLD_COUNT_CANDIDATES),
                        resolveOptional(columns, STATUS_CANDIDATES),
                        resolveOptional(columns, IS_DELETED_CANDIDATES),
                        resolveOptional(columns, CREATED_AT_CANDIDATES),
                        resolveOptional(columns, UPDATED_AT_CANDIDATES)
                );
            }
            return CACHED_SCHEMA;
        }
    }

    private String buildSelectAllSql(ProductSchema schema) {
        StringBuilder sql = new StringBuilder("SELECT ");
        List<String> columns = buildSelectColumns(schema);
        sql.append(String.join(", ", columns));
        sql.append(" FROM ").append(q(schema.tableName));
        if (schema.isDeleted != null) {
            sql.append(" WHERE ").append(q(schema.isDeleted)).append(" = 0");
        }
        sql.append(" ORDER BY ").append(q(schema.id)).append(" DESC");
        return sql.toString();
    }

    private String buildSelectByIdSql(ProductSchema schema) {
        StringBuilder sql = new StringBuilder("SELECT ");
        sql.append(String.join(", ", buildSelectColumns(schema)));
        sql.append(" FROM ").append(q(schema.tableName));
        sql.append(" WHERE ").append(q(schema.id)).append(" = ?");
        if (schema.isDeleted != null) {
            sql.append(" AND ").append(q(schema.isDeleted)).append(" = 0");
        }
        return sql.toString();
    }

    private String buildInsertSql(ProductSchema schema) {
        List<String> columns = new ArrayList<>();
        List<String> values = new ArrayList<>();

        addValue(columns, values, schema.shopId, "?");
        addValue(columns, values, schema.categoryId, "?");
        addValue(columns, values, schema.productName, "?");
        if (schema.description != null) {
            addValue(columns, values, schema.description, "?");
        }
        if (schema.soldQuantity != null) {
            addValue(columns, values, schema.soldQuantity, "?");
        }
        if (schema.soldCount != null) {
            addValue(columns, values, schema.soldCount, "?");
        }
        if (schema.status != null) {
            addValue(columns, values, schema.status, "?");
        }
        if (schema.isDeleted != null) {
            addValue(columns, values, schema.isDeleted, "0");
        }
        if (schema.createdAt != null) {
            addValue(columns, values, schema.createdAt, "GETDATE()");
        }
        if (schema.updatedAt != null) {
            addValue(columns, values, schema.updatedAt, "GETDATE()");
        }
        // ❌ KHÔNG có image_url trong Products table

        return "INSERT INTO " + q(schema.tableName)
                + " (" + String.join(", ", columns) + ") VALUES (" + String.join(", ", values) + ")";
    }

    private String buildUpdateSql(ProductSchema schema) {
        List<String> sets = new ArrayList<>();

        addSet(sets, schema.shopId);
        addSet(sets, schema.categoryId);
        addSet(sets, schema.productName);
        addSet(sets, schema.description);
        // addSet(sets, schema.price);  // ← COMMENT DÒNG NÀY

        if (schema.soldQuantity != null) {
            addSet(sets, schema.soldQuantity);
        }
        if (schema.soldCount != null) {
            addSet(sets, schema.soldCount);
        }
        if (schema.status != null) {
            addSet(sets, schema.status);
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

    private void bindInsert(PreparedStatement ps, ProductSchema schema, Product product) throws SQLException {
        int index = 1;
        ps.setLong(index++, product.getShopId());
        ps.setLong(index++, product.getCategoryId());
        ps.setNString(index++, product.getProductName());
        if (schema.description != null) {
            ps.setNString(index++, product.getDescription());
        }
        // ps.setBigDecimal(index++, product.getPrice());  // ← COMMENT DÒNG NÀY
        if (schema.soldQuantity != null) {
            ps.setInt(index++, product.getStockQuantity());
        }
        if (schema.soldCount != null) {
            ps.setInt(index++, product.getSoldCount());
        }
        if (schema.status != null) {
            ps.setNString(index++, normalizeStatus(product.getStaTus()));
        }
    }

    private void bindUpdate(PreparedStatement ps, ProductSchema schema, Product product) throws SQLException {
        int index = 1;
        ps.setLong(index++, product.getShopId());
        ps.setLong(index++, product.getCategoryId());
        ps.setNString(index++, product.getProductName());
        if (schema.description != null) {
            ps.setNString(index++, product.getDescription());
        }
        // ps.setBigDecimal(index++, product.getPrice());  // ← COMMENT DÒNG NÀY

        if (schema.soldQuantity != null) {
            ps.setInt(index++, product.getStockQuantity());
        }
        if (schema.soldCount != null) {
            ps.setInt(index++, product.getSoldCount());
        }
        if (schema.status != null) {
            ps.setNString(index++, normalizeStatus(product.getStaTus()));
        }
        ps.setLong(index, product.getId());
    }

    private List<String> buildSelectColumns(ProductSchema schema) {
        List<String> columns = new ArrayList<>();
        columns.add(q(schema.id));
        columns.add(q(schema.shopId));
        columns.add(q(schema.categoryId));
        columns.add(q(schema.productName));
        if (schema.description != null) {
            columns.add(q(schema.description));
        }
        if (schema.soldQuantity != null) {
            columns.add(q(schema.soldQuantity));
        }
        if (schema.soldCount != null) {
            columns.add(q(schema.soldCount));
        }
        if (schema.status != null) {
            columns.add(q(schema.status));
        }
        if (schema.isDeleted != null) {
            columns.add(q(schema.isDeleted));
        }
        if (schema.createdAt != null) {
            columns.add(q(schema.createdAt));
        }
        if (schema.updatedAt != null) {
            columns.add(q(schema.updatedAt));
        }
        // ❌ KHÔNG có image_url trong Products table
        return columns;
    }

    private Product mapProduct(ResultSet rs, ProductSchema schema) throws SQLException {
        Product product = new Product();
        product.setId(readLong(rs, schema.id));
        product.setShopId(readLong(rs, schema.shopId));
        product.setCategoryId(readLong(rs, schema.categoryId));
        product.setProductName(readString(rs, schema.productName));
        product.setDescription(readString(rs, schema.description));
        // product.setPrice(readBigDecimal(rs, schema.price));
        Integer stockQuantity = readInt(rs, schema.soldQuantity);
        product.setStockQuantity(stockQuantity == null ? 0 : stockQuantity);
        Integer soldCount = readInt(rs, schema.soldCount);
        product.setSoldCount(soldCount == null ? 0 : soldCount);
        String status = readString(rs, schema.status);
        product.setStaTus(status == null ? null : normalizeStatus(status));
        product.setDeleted(readBoolean(rs, schema.isDeleted));
        product.setCreatedAt(readTimestamp(rs, schema.createdAt));
        product.setUpdatedAt(readTimestamp(rs, schema.updatedAt));
        return product;
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

        throw new SQLException("Khong tim thay bang Product phu hop");
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

    private long readLong(ResultSet rs, String column) throws SQLException {
        return rs.getLong(column);
    }

    private String readString(ResultSet rs, String column) throws SQLException {
        return column == null ? null : rs.getString(column);
    }

    private BigDecimal readBigDecimal(ResultSet rs, String column) throws SQLException {
        if (column == null) {
            return null;
        }
        return rs.getBigDecimal(column);
    }

    private Integer readInt(ResultSet rs, String column) throws SQLException {
        if (column == null) {
            return null;
        }
        int value = rs.getInt(column);
        return rs.wasNull() ? null : value;
    }

    private boolean readBoolean(ResultSet rs, String column) throws SQLException {
        if (column == null) {
            return false;
        }
        return rs.getBoolean(column);
    }

    private LocalDateTime readTimestamp(ResultSet rs, String column) throws SQLException {
        if (column == null) {
            return null;
        }
        Timestamp timestamp = rs.getTimestamp(column);
        return timestamp == null ? null : timestamp.toLocalDateTime();
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

    private static final class ProductSchema {
        private final String tableName;
        private final String id;
        private final String shopId;
        private final String categoryId;
        private final String productName;
        private final String description;
        private final String soldQuantity;
        private final String soldCount;
        private final String status;
        private final String isDeleted;
        private final String createdAt;
        private final String updatedAt;

        private ProductSchema(String tableName, String id, String shopId, String categoryId,
                              String productName, String description,
                              String soldQuantity, String soldCount,
                              String status, String isDeleted,
                              String createdAt, String updatedAt) {
            this.tableName = tableName;
            this.id = id;
            this.shopId = shopId;
            this.categoryId = categoryId;
            this.productName = productName;
            this.description = description;
            this.soldQuantity = soldQuantity;
            this.soldCount = soldCount;
            this.status = status;
            this.isDeleted = isDeleted;
            this.createdAt = createdAt;
            this.updatedAt = updatedAt;
        }
    }
}
