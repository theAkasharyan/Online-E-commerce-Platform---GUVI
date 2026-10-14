package com.ecommerce.dao;

import com.ecommerce.model.CartItem;
import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;
import com.ecommerce.util.DBConnectionUtil;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for handling customer Orders and Line Items.
 * Supports ACID transactions for placing orders and deducting stock.
 */
public class OrderDAO {

    private static final Logger LOGGER = Logger.getLogger(OrderDAO.class.getName());

    private static final String SQL_INSERT_ORDER = 
        "INSERT INTO orders (user_id, total_amount, shipping_address, phone, payment_method, order_status) " +
        "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String SQL_INSERT_ORDER_ITEM = 
        "INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)";

    private static final String SQL_DEDUCT_STOCK = 
        "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?";

    private static final String SQL_ORDERS_BY_USER = 
        "SELECT id, user_id, total_amount, shipping_address, phone, payment_method, order_status, created_at " +
        "FROM orders WHERE user_id = ? ORDER BY id DESC";

    private static final String SQL_ALL_ORDERS = 
        "SELECT o.id, o.user_id, o.total_amount, o.shipping_address, o.phone, o.payment_method, " +
        "       o.order_status, o.created_at, u.name AS user_name " +
        "FROM orders o " +
        "LEFT JOIN users u ON o.user_id = u.id " +
        "ORDER BY o.id DESC";

    private static final String SQL_ORDER_BY_ID = 
        "SELECT o.id, o.user_id, o.total_amount, o.shipping_address, o.phone, o.payment_method, " +
        "       o.order_status, o.created_at, u.name AS user_name " +
        "FROM orders o " +
        "LEFT JOIN users u ON o.user_id = u.id " +
        "WHERE o.id = ?";

    private static final String SQL_ITEMS_BY_ORDER = 
        "SELECT oi.id, oi.order_id, oi.product_id, oi.quantity, oi.unit_price, " +
        "       p.name AS product_name, p.image_url AS product_image " +
        "FROM order_items oi " +
        "LEFT JOIN products p ON oi.product_id = p.id " +
        "WHERE oi.order_id = ?";

    private static final String SQL_UPDATE_STATUS = 
        "UPDATE orders SET order_status = ? WHERE id = ?";

    /**
     * Places a new order atomically within a database transaction.
     * Inserts the order, its items, and deducts the inventory stock.
     */
    public boolean placeOrder(Order order, List<CartItem> cartItems) {
        Connection conn = null;
        PreparedStatement orderStmt = null;
        PreparedStatement itemStmt = null;
        PreparedStatement stockStmt = null;
        ResultSet generatedKeys = null;

        try {
            conn = DBConnectionUtil.getConnection();
            conn.setAutoCommit(false); // Begin transaction

            // 1. Insert into orders
            orderStmt = conn.prepareStatement(SQL_INSERT_ORDER, Statement.RETURN_GENERATED_KEYS);
            if (order.getUserId() != null && order.getUserId() > 0) {
                orderStmt.setInt(1, order.getUserId());
            } else {
                orderStmt.setNull(1, Types.INTEGER);
            }
            orderStmt.setBigDecimal(2, order.getTotalAmount());
            orderStmt.setString(3, order.getShippingAddress());
            orderStmt.setString(4, order.getPhone());
            orderStmt.setString(5, order.getPaymentMethod() != null ? order.getPaymentMethod() : "Cash on Delivery");
            orderStmt.setString(6, order.getOrderStatus() != null ? order.getOrderStatus() : "PENDING");

            int affected = orderStmt.executeUpdate();
            if (affected == 0) {
                conn.rollback();
                return false;
            }

            generatedKeys = orderStmt.getGeneratedKeys();
            if (!generatedKeys.next()) {
                conn.rollback();
                return false;
            }
            int orderId = generatedKeys.getInt(1);
            order.setId(orderId);

            // 2. Insert order items & deduct stock
            itemStmt = conn.prepareStatement(SQL_INSERT_ORDER_ITEM);
            stockStmt = conn.prepareStatement(SQL_DEDUCT_STOCK);

            for (CartItem cartItem : cartItems) {
                // Insert item
                itemStmt.setInt(1, orderId);
                itemStmt.setInt(2, cartItem.getProduct().getId());
                itemStmt.setInt(3, cartItem.getQuantity());
                itemStmt.setBigDecimal(4, cartItem.getProduct().getPrice());
                itemStmt.addBatch();

                // Deduct stock
                stockStmt.setInt(1, cartItem.getQuantity());
                stockStmt.setInt(2, cartItem.getProduct().getId());
                stockStmt.setInt(3, cartItem.getQuantity());
                int updatedStock = stockStmt.executeUpdate();

                if (updatedStock == 0) {
                    // Stock insufficient or product not found
                    LOGGER.warning("Insufficient stock for product ID: " + cartItem.getProduct().getId());
                    conn.rollback();
                    return false;
                }
            }

            itemStmt.executeBatch();

            // Commit transaction
            conn.commit();
            return true;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Transaction rollback due to order placement error", e);
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Failed to rollback connection", ex);
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException ignored) {}
            }
            DBConnectionUtil.closeResultSet(generatedKeys);
            DBConnectionUtil.closeStatement(orderStmt);
            DBConnectionUtil.closeStatement(itemStmt);
            DBConnectionUtil.closeStatement(stockStmt);
            DBConnectionUtil.closeConnection(conn);
        }
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnectionUtil.getConnection();
            stmt = conn.prepareStatement(SQL_ORDERS_BY_USER);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setShippingAddress(rs.getString("shipping_address"));
                order.setPhone(rs.getString("phone"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                orders.add(order);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching orders for user: " + userId, e);
        } finally {
            DBConnectionUtil.closeResources(conn, stmt, rs);
        }
        return orders;
    }

    public Order getOrderById(int orderId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnectionUtil.getConnection();
            stmt = conn.prepareStatement(SQL_ORDER_BY_ID);
            stmt.setInt(1, orderId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setUserName(rs.getString("user_name"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setShippingAddress(rs.getString("shipping_address"));
                order.setPhone(rs.getString("phone"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setCreatedAt(rs.getTimestamp("created_at"));

                // Load items
                order.setItems(getOrderItems(conn, orderId));
                return order;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching order by id: " + orderId, e);
        } finally {
            DBConnectionUtil.closeResources(conn, stmt, rs);
        }
        return null;
    }

    public List<OrderItem> getOrderItems(Connection conn, int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            stmt = conn.prepareStatement(SQL_ITEMS_BY_ORDER);
            stmt.setInt(1, orderId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getInt("id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setUnitPrice(rs.getBigDecimal("unit_price"));
                item.setProductName(rs.getString("product_name"));
                item.setProductImage(rs.getString("product_image"));
                items.add(item);
            }
        } finally {
            DBConnectionUtil.closeResultSet(rs);
            DBConnectionUtil.closeStatement(stmt);
        }
        return items;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnectionUtil.getConnection();
            stmt = conn.prepareStatement(SQL_UPDATE_STATUS);
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating order status", e);
        } finally {
            DBConnectionUtil.closeResources(conn, stmt, null);
        }
        return false;
    }
}
