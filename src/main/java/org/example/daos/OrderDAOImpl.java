package org.example.daos;

import org.example.models.Order;
import org.example.utils.DBUtil;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class OrderDAOImpl implements OrderDAO {
    private static volatile OrderSchema CACHED_SCHEMA;

    private static final String[] TABLE_CANDIDATES = {"Orders", "Order"};
    private static final String[] ID_CANDIDATES = {"id"};
    private static final String[] USER_ID_CANDIDATES = {"user_id", "userid", "userId", "account_id", "accountid"};
    private static final String[] SHOP_ID_CANDIDATES = {"shop_id", "shopid", "shopId"};
    private static final String[] SHIPPER_ID_CANDIDATES = {"shipper_id", "shipperid", "shipperId"};
    private static final String[] RECEIVER_NAME_CANDIDATES = {"receiver_name", "receivername", "receiverName"};
    private static final String[] RECEIVER_PHONE_CANDIDATES = {"receiver_phone", "receiverphone", "receiverPhone"};
    private static final String[] SHIPPING_ADDRESS_CANDIDATES = {"shipping_address", "shippingaddress", "shippingAddress", "address"};
    private static final String[] TOTAL_PRICE_CANDIDATES = {"total_price", "totalprice", "totalPrice"};
    private static final String[] DELIVERY_FEE_CANDIDATES = {"delivery_fee", "deliveryfee", "deliveryFee"};
    private static final String[] PAYMENT_METHOD_CANDIDATES = {"payment_method", "paymentmethod", "paymentMethod"};
    private static final String[] PAYMENT_STATUS_CANDIDATES = {"payment_status", "paymentstatus", "paymentStatus"};
    private static final String[] PAYOS_ORDER_CODE_CANDIDATES = {"payos_order_code", "payosordercode", "payosOrderCode"};
    private static final String[] STATUS_CANDIDATES = {"status", "staTus"};
    private static final String[] ESTIMATED_DELIVERY_TIME_CANDIDATES = {"estimated_delivery_time", "estimateddeliverytime", "estimatedDeliveryTime"};
    private static final String[] IS_DELETED_CANDIDATES = {"is_deleted", "isdeleted", "deleted"};
    private static final String[] CREATED_AT_CANDIDATES = {"created_at", "createdat"};
    private static final String[] UPDATED_AT_CANDIDATES = {"updated_at", "updatedat"};

    @Override
    public Boolean create(Order order) {
        try (Connection conn = openConnection()) {
            OrderSchema schema = resolveSchema(conn);
            String sql = buildInsertSql(schema);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                bindInsert(ps, schema, order);
                return ps.executeUpdate() == 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public long createAndReturnId(Order order) {
        try (Connection conn = openConnection()) {
            OrderSchema schema = resolveSchema(conn);
            String sql = buildInsertSql(schema);

            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                bindInsert(ps, schema, order);
                int affected = ps.executeUpdate();
                if (affected == 0) {
                    return 0;
                }
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getLong(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<Order> findByShopId(long shopId) {
        List<Order> orders = new ArrayList<>();

        try (Connection conn = openConnection()) {
            OrderSchema schema = resolveSchema(conn);
            String sql = buildSelectByShopIdSql(schema);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, shopId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        orders.add(mapOrder(rs, schema));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return orders;
    }

    @Override
    public List<Order> findByShipperId(long shipperId) {
        List<Order> orders = new ArrayList<>();

        try (Connection conn = openConnection()) {
            OrderSchema schema = resolveSchema(conn);
            if (schema.shipperId == null) {
                return orders;
            }
            String sql = buildSelectByShipperIdSql(schema);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, shipperId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        orders.add(mapOrder(rs, schema));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return orders;
    }

    @Override
    public List<Order> getAll() {
        List<Order> orders = new ArrayList<>();

        try (Connection conn = openConnection()) {
            OrderSchema schema = resolveSchema(conn);
            String sql = buildSelectAllSql(schema);

            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapOrder(rs, schema));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return orders;
    }

    @Override
    public Order findById(long id) {
        try (Connection conn = openConnection()) {
            OrderSchema schema = resolveSchema(conn);
            String sql = buildSelectByIdSql(schema);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapOrder(rs, schema);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public Boolean update(Order order) {
        try (Connection conn = openConnection()) {
            OrderSchema schema = resolveSchema(conn);
            String sql = buildUpdateSql(schema);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                bindUpdate(ps, schema, order);
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
            OrderSchema schema = resolveSchema(conn);
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

    private OrderSchema resolveSchema(Connection conn) throws SQLException {
        OrderSchema cached = CACHED_SCHEMA;
        if (cached != null) {
            return cached;
        }

        synchronized (OrderDAOImpl.class) {
            if (CACHED_SCHEMA == null) {
                String tableName = resolveTableName(conn, TABLE_CANDIDATES);
                Map<String, String> columns = loadColumns(conn, tableName);
                CACHED_SCHEMA = new OrderSchema(
                        tableName,
                        resolveRequired(columns, ID_CANDIDATES),
                        resolveRequired(columns, USER_ID_CANDIDATES),
                        resolveRequired(columns, SHOP_ID_CANDIDATES),
                        resolveOptional(columns, SHIPPER_ID_CANDIDATES),
                        resolveRequired(columns, RECEIVER_NAME_CANDIDATES),
                        resolveRequired(columns, RECEIVER_PHONE_CANDIDATES),
                        resolveRequired(columns, SHIPPING_ADDRESS_CANDIDATES),
                        resolveRequired(columns, TOTAL_PRICE_CANDIDATES),
                        resolveOptional(columns, DELIVERY_FEE_CANDIDATES),
                        resolveOptional(columns, PAYMENT_METHOD_CANDIDATES),
                        resolveOptional(columns, PAYMENT_STATUS_CANDIDATES),
                        resolveOptional(columns, PAYOS_ORDER_CODE_CANDIDATES),
                        resolveOptional(columns, STATUS_CANDIDATES),
                        resolveOptional(columns, ESTIMATED_DELIVERY_TIME_CANDIDATES),
                        resolveOptional(columns, IS_DELETED_CANDIDATES),
                        resolveOptional(columns, CREATED_AT_CANDIDATES),
                        resolveOptional(columns, UPDATED_AT_CANDIDATES)
                );
            }
            return CACHED_SCHEMA;
        }
    }

    private String buildSelectAllSql(OrderSchema schema) {
        StringBuilder sql = new StringBuilder("SELECT ");
        sql.append(String.join(", ", buildSelectColumns(schema)));
        sql.append(" FROM ").append(q(schema.tableName));
        if (schema.isDeleted != null) {
            sql.append(" WHERE ").append(q(schema.isDeleted)).append(" = 0");
        }
        sql.append(" ORDER BY ").append(q(schema.id)).append(" DESC");
        return sql.toString();
    }

    private String buildSelectByIdSql(OrderSchema schema) {
        StringBuilder sql = new StringBuilder("SELECT ");
        sql.append(String.join(", ", buildSelectColumns(schema)));
        sql.append(" FROM ").append(q(schema.tableName));
        sql.append(" WHERE ").append(q(schema.id)).append(" = ?");
        if (schema.isDeleted != null) {
            sql.append(" AND ").append(q(schema.isDeleted)).append(" = 0");
        }
        return sql.toString();
    }

    private String buildSelectByShopIdSql(OrderSchema schema) {
        StringBuilder sql = new StringBuilder("SELECT ");
        sql.append(String.join(", ", buildSelectColumns(schema)));
        sql.append(" FROM ").append(q(schema.tableName));
        sql.append(" WHERE ").append(q(schema.shopId)).append(" = ?");
        if (schema.isDeleted != null) {
            sql.append(" AND ").append(q(schema.isDeleted)).append(" = 0");
        }
        sql.append(" ORDER BY ").append(q(schema.id)).append(" DESC");
        return sql.toString();
    }

    private String buildSelectByShipperIdSql(OrderSchema schema) {
        StringBuilder sql = new StringBuilder("SELECT ");
        sql.append(String.join(", ", buildSelectColumns(schema)));
        sql.append(" FROM ").append(q(schema.tableName));
        sql.append(" WHERE ").append(q(schema.shipperId)).append(" = ?");
        if (schema.isDeleted != null) {
            sql.append(" AND ").append(q(schema.isDeleted)).append(" = 0");
        }
        sql.append(" ORDER BY ").append(q(schema.id)).append(" DESC");
        return sql.toString();
    }

    private String buildInsertSql(OrderSchema schema) {
        List<String> columns = new ArrayList<>();
        List<String> values = new ArrayList<>();

        addValue(columns, values, schema.userId, "?");
        addValue(columns, values, schema.shopId, "?");
        addOptionalValue(columns, values, schema.shipperId, "?");
        addValue(columns, values, schema.receiverName, "?");
        addValue(columns, values, schema.receiverPhone, "?");
        addValue(columns, values, schema.shippingAddress, "?");
        addValue(columns, values, schema.totalPrice, "?");
        addOptionalValue(columns, values, schema.deliveryFee, "?");
        addOptionalValue(columns, values, schema.paymentMethod, "?");
        addOptionalValue(columns, values, schema.paymentStatus, "?");
        addOptionalValue(columns, values, schema.payosOrderCode, "?");
        addOptionalValue(columns, values, schema.status, "?");
        addOptionalValue(columns, values, schema.estimatedDeliveryTime, "?");
        addOptionalValue(columns, values, schema.isDeleted, "0");
        addOptionalValue(columns, values, schema.createdAt, "GETDATE()");
        addOptionalValue(columns, values, schema.updatedAt, "GETDATE()");

        return "INSERT INTO " + q(schema.tableName)
                + " (" + String.join(", ", columns) + ") VALUES (" + String.join(", ", values) + ")";
    }

    private String buildUpdateSql(OrderSchema schema) {
        List<String> sets = new ArrayList<>();

        addSet(sets, schema.userId);
        addSet(sets, schema.shopId);
        addOptionalSet(sets, schema.shipperId);
        addSet(sets, schema.receiverName);
        addSet(sets, schema.receiverPhone);
        addSet(sets, schema.shippingAddress);
        addSet(sets, schema.totalPrice);
        addOptionalSet(sets, schema.deliveryFee);
        addOptionalSet(sets, schema.paymentMethod);
        addOptionalSet(sets, schema.paymentStatus);
        addOptionalSet(sets, schema.payosOrderCode);
        addOptionalSet(sets, schema.status);
        addOptionalSet(sets, schema.estimatedDeliveryTime);
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

    private void bindInsert(PreparedStatement ps, OrderSchema schema, Order order) throws SQLException {
        int index = bindEditableFields(ps, schema, order, false);
    }

    private void bindUpdate(PreparedStatement ps, OrderSchema schema, Order order) throws SQLException {
        int index = bindEditableFields(ps, schema, order, true);
        ps.setLong(index, order.getId());
    }

    private int bindEditableFields(PreparedStatement ps, OrderSchema schema, Order order, boolean updating) throws SQLException {
        int index = 1;
        ps.setLong(index++, order.getUserId());
        ps.setLong(index++, order.getShopId());
        if (schema.shipperId != null) {
            if (order.getShipperId() > 0) {
                ps.setLong(index++, order.getShipperId());
            } else {
                ps.setNull(index++, Types.BIGINT);
            }
        }
        ps.setNString(index++, order.getReceiverName());
        ps.setString(index++, order.getReceiverPhone());
        ps.setNString(index++, order.getShippingAddress());
        ps.setDouble(index++, order.getTotalPrice());
        if (schema.deliveryFee != null) {
            ps.setDouble(index++, order.getDeliveryFee() == null ? 0 : order.getDeliveryFee());
        }
        if (schema.paymentMethod != null) {
            ps.setString(index++, order.getPaymentMethod());
        }
        if (schema.paymentStatus != null) {
            ps.setString(index++, normalizePaymentStatus(order.getPaymentStatus()));
        }
        if (schema.payosOrderCode != null) {
            if (order.getPayosOrderCode() != null && order.getPayosOrderCode() > 0) {
                ps.setLong(index++, order.getPayosOrderCode());
            } else {
                ps.setNull(index++, Types.BIGINT);
            }
        }
        if (schema.status != null) {
            ps.setString(index++, normalizeStatus(order.getStaTus()));
        }
        if (schema.estimatedDeliveryTime != null) {
            if (order.getEstimatedDeliveryTime() == null) {
                ps.setTimestamp(index++, null);
            } else {
                ps.setTimestamp(index++, Timestamp.valueOf(order.getEstimatedDeliveryTime()));
            }
        }
        return index;
    }

    private List<String> buildSelectColumns(OrderSchema schema) {
        List<String> columns = new ArrayList<>();
        columns.add(q(schema.id));
        columns.add(q(schema.userId));
        columns.add(q(schema.shopId));
        addOptionalColumn(columns, schema.shipperId);
        columns.add(q(schema.receiverName));
        columns.add(q(schema.receiverPhone));
        columns.add(q(schema.shippingAddress));
        columns.add(q(schema.totalPrice));
        addOptionalColumn(columns, schema.deliveryFee);
        addOptionalColumn(columns, schema.paymentMethod);
        addOptionalColumn(columns, schema.paymentStatus);
        addOptionalColumn(columns, schema.payosOrderCode);
        addOptionalColumn(columns, schema.status);
        addOptionalColumn(columns, schema.estimatedDeliveryTime);
        addOptionalColumn(columns, schema.createdAt);
        addOptionalColumn(columns, schema.updatedAt);
        return columns;
    }

    private Order mapOrder(ResultSet rs, OrderSchema schema) throws SQLException {
        Order order = new Order();
        order.setId(rs.getLong(schema.id));
        order.setUserId(rs.getLong(schema.userId));
        order.setShopId(rs.getLong(schema.shopId));
        order.setShipperId(readLong(rs, schema.shipperId));
        order.setReceiverName(rs.getNString(schema.receiverName));
        order.setReceiverPhone(rs.getString(schema.receiverPhone));
        order.setShippingAddress(rs.getNString(schema.shippingAddress));
        order.setTotalPrice(rs.getDouble(schema.totalPrice));
        order.setDeliveryFee(readDouble(rs, schema.deliveryFee));
        order.setPaymentMethod(readString(rs, schema.paymentMethod));
        order.setPaymentStatus(readString(rs, schema.paymentStatus));
        order.setPayosOrderCode(readLongObj(rs, schema.payosOrderCode));
        order.setStaTus(readString(rs, schema.status));
        order.setEstimatedDeliveryTime(readTimestamp(rs, schema.estimatedDeliveryTime));
        order.setCreatedAt(readTimestamp(rs, schema.createdAt));
        order.setUpdatedAt(readTimestamp(rs, schema.updatedAt));
        return order;
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

        throw new SQLException("Khong tim thay bang Orders phu hop");
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

    private void addOptionalValue(List<String> columns, List<String> values, String columnName, String valueSql) {
        if (columnName != null) {
            addValue(columns, values, columnName, valueSql);
        }
    }

    private void addSet(List<String> sets, String columnName) {
        sets.add(q(columnName) + " = ?");
    }

    private void addOptionalSet(List<String> sets, String columnName) {
        if (columnName != null) {
            addSet(sets, columnName);
        }
    }

    private void addOptionalColumn(List<String> columns, String columnName) {
        if (columnName != null) {
            columns.add(q(columnName));
        }
    }

    private long readLong(ResultSet rs, String column) throws SQLException {
        if (column == null) {
            return 0;
        }
        long value = rs.getLong(column);
        return rs.wasNull() ? 0 : value;
    }

    private Long readLongObj(ResultSet rs, String column) throws SQLException {
        if (column == null) {
            return null;
        }
        long value = rs.getLong(column);
        return rs.wasNull() ? null : value;
    }

    private Double readDouble(ResultSet rs, String column) throws SQLException {
        if (column == null) {
            return 0D;
        }
        double value = rs.getDouble(column);
        return rs.wasNull() ? 0D : value;
    }

    private String readString(ResultSet rs, String column) throws SQLException {
        return column == null ? null : rs.getString(column);
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
        return value.isBlank() ? "PENDING" : value.toUpperCase(Locale.ROOT);
    }

    private String normalizePaymentStatus(String paymentStatus) {
        String value = paymentStatus == null ? "" : paymentStatus.trim();
        return value.isBlank() ? "UNPAID" : value.toUpperCase(Locale.ROOT);
    }

    @Override
    public Boolean updatePaymentStatus(long id, long shopId, String paymentStatus) {
        try (Connection conn = openConnection()) {
            OrderSchema schema = resolveSchema(conn);
            if (schema.paymentStatus == null) {
                return false;
            }
            String sql = "UPDATE " + q(schema.tableName) +
                    " SET " + q(schema.paymentStatus) + " = ?" +
                    " WHERE " + q(schema.id) + " = ? AND " + q(schema.shopId) + " = ?";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, normalizePaymentStatus(paymentStatus));
                ps.setLong(2, id);
                ps.setLong(3, shopId);
                return ps.executeUpdate() == 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Boolean setPayosOrderCode(long id, long payosOrderCode) {
        try (Connection conn = openConnection()) {
            OrderSchema schema = resolveSchema(conn);
            if (schema.payosOrderCode == null) {
                return false;
            }
            String sql = "UPDATE " + q(schema.tableName) +
                    " SET " + q(schema.payosOrderCode) + " = ?" +
                    " WHERE " + q(schema.id) + " = ?";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, payosOrderCode);
                ps.setLong(2, id);
                return ps.executeUpdate() == 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Order> findByPayosOrderCode(long payosOrderCode) {
        List<Order> orders = new ArrayList<>();
        try (Connection conn = openConnection()) {
            OrderSchema schema = resolveSchema(conn);
            if (schema.payosOrderCode == null) {
                return orders;
            }
            String sql = "SELECT " + String.join(", ", buildSelectColumns(schema)) +
                    " FROM " + q(schema.tableName) +
                    " WHERE " + q(schema.payosOrderCode) + " = ?";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, payosOrderCode);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        orders.add(mapOrder(rs, schema));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    @Override
    public Boolean updatePaymentStatusByPayosOrderCode(long payosOrderCode, String paymentStatus) {
        try (Connection conn = openConnection()) {
            OrderSchema schema = resolveSchema(conn);
            if (schema.payosOrderCode == null || schema.paymentStatus == null) {
                return false;
            }
            String sql = "UPDATE " + q(schema.tableName) +
                    " SET " + q(schema.paymentStatus) + " = ?" +
                    " WHERE " + q(schema.payosOrderCode) + " = ?";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, normalizePaymentStatus(paymentStatus));
                ps.setLong(2, payosOrderCode);
                return ps.executeUpdate() >= 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private String q(String identifier) {
        return "[" + identifier + "]";
    }

    private String normalizeIdentifier(String value) {
        return value == null ? "" : value.replaceAll("[^A-Za-z0-9]", "").toLowerCase(Locale.ROOT);
    }

    private static final class OrderSchema {
        private final String tableName;
        private final String id;
        private final String userId;
        private final String shopId;
        private final String shipperId;
        private final String receiverName;
        private final String receiverPhone;
        private final String shippingAddress;
        private final String totalPrice;
        private final String deliveryFee;
        private final String paymentMethod;
        private final String paymentStatus;
        private final String payosOrderCode;
        private final String status;
        private final String estimatedDeliveryTime;
        private final String isDeleted;
        private final String createdAt;
        private final String updatedAt;

        private OrderSchema(String tableName, String id, String userId, String shopId, String shipperId,
                            String receiverName, String receiverPhone, String shippingAddress,
                            String totalPrice, String deliveryFee, String paymentMethod, String paymentStatus, String payosOrderCode, String status,
                            String estimatedDeliveryTime, String isDeleted, String createdAt, String updatedAt) {
            this.tableName = tableName;
            this.id = id;
            this.userId = userId;
            this.shopId = shopId;
            this.shipperId = shipperId;
            this.receiverName = receiverName;
            this.receiverPhone = receiverPhone;
            this.shippingAddress = shippingAddress;
            this.totalPrice = totalPrice;
            this.deliveryFee = deliveryFee;
            this.paymentMethod = paymentMethod;
            this.paymentStatus = paymentStatus;
            this.payosOrderCode = payosOrderCode;
            this.status = status;
            this.estimatedDeliveryTime = estimatedDeliveryTime;
            this.isDeleted = isDeleted;
            this.createdAt = createdAt;
            this.updatedAt = updatedAt;
        }
    }
}
