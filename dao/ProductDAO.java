package dao;

import model.Product;
import util.DBConnectionUtil;

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
 * Data Access Object (DAO) for Product operations.
 * Implements full CRUD operations and queries matching schema.sql.
 */
public class ProductDAO {

    private static final Logger LOGGER = Logger.getLogger(ProductDAO.class.getName());

    // SQL Queries
    private static final String SQL_INSERT = 
        "INSERT INTO products (name, description, price, stock, category_id, image_url) " +
        "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String SQL_SELECT_BY_ID = 
        "SELECT p.id, p.name, p.description, p.price, p.stock, p.category_id, p.image_url, " +
        "       p.created_at, p.updated_at, c.name AS category_name " +
        "FROM products p " +
        "LEFT JOIN categories c ON p.category_id = c.id " +
        "WHERE p.id = ?";

    private static final String SQL_SELECT_ALL = 
        "SELECT p.id, p.name, p.description, p.price, p.stock, p.category_id, p.image_url, " +
        "       p.created_at, p.updated_at, c.name AS category_name " +
        "FROM products p " +
        "LEFT JOIN categories c ON p.category_id = c.id " +
        "ORDER BY p.id DESC";

    private static final String SQL_SELECT_BY_CATEGORY = 
        "SELECT p.id, p.name, p.description, p.price, p.stock, p.category_id, p.image_url, " +
        "       p.created_at, p.updated_at, c.name AS category_name " +
        "FROM products p " +
        "LEFT JOIN categories c ON p.category_id = c.id " +
        "WHERE p.category_id = ? " +
        "ORDER BY p.id DESC";

    private static final String SQL_SEARCH = 
        "SELECT p.id, p.name, p.description, p.price, p.stock, p.category_id, p.image_url, " +
        "       p.created_at, p.updated_at, c.name AS category_name " +
        "FROM products p " +
        "LEFT JOIN categories c ON p.category_id = c.id " +
        "WHERE LOWER(p.name) LIKE ? OR LOWER(p.description) LIKE ? " +
        "ORDER BY p.id DESC";

    private static final String SQL_UPDATE = 
        "UPDATE products " +
        "SET name = ?, description = ?, price = ?, stock = ?, category_id = ?, image_url = ? " +
        "WHERE id = ?";

    private static final String SQL_DELETE = 
        "DELETE FROM products WHERE id = ?";

    private static final String SQL_COUNT = 
        "SELECT COUNT(*) FROM products";

    private static final String SQL_DEDUCT_STOCK = 
        "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?";

    /**
     * CREATE: Inserts a new product into the database.
     * Sets the auto-generated primary key back on the product object.
     *
     * @param product The product to insert
     * @return true if insertion was successful, false otherwise
     */
    public boolean addProduct(Product product) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet generatedKeys = null;

        try {
            conn = DBConnectionUtil.getConnection();
            stmt = conn.prepareStatement(SQL_INSERT, Statement.RETURN_GENERATED_KEYS);

            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setBigDecimal(3, product.getPrice());
            stmt.setInt(4, product.getStock());

            if (product.getCategoryId() != null && product.getCategoryId() > 0) {
                stmt.setInt(5, product.getCategoryId());
            } else {
                stmt.setNull(5, Types.INTEGER);
            }

            stmt.setString(6, product.getImageUrl());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    product.setId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting product: " + product.getName(), e);
        } finally {
            DBConnectionUtil.closeResources(conn, stmt, generatedKeys);
        }
        return false;
    }

    /**
     * READ: Retrieves a product by its primary key ID.
     *
     * @param id The product ID
     * @return Product object or null if not found
     */
    public Product getProductById(int id) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnectionUtil.getConnection();
            stmt = conn.prepareStatement(SQL_SELECT_BY_ID);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToProduct(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching product by id: " + id, e);
        } finally {
            DBConnectionUtil.closeResources(conn, stmt, rs);
        }
        return null;
    }

    /**
     * READ: Retrieves all products.
     *
     * @return List of Product objects
     */
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnectionUtil.getConnection();
            stmt = conn.prepareStatement(SQL_SELECT_ALL);
            rs = stmt.executeQuery();

            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all products", e);
        } finally {
            DBConnectionUtil.closeResources(conn, stmt, rs);
        }
        return products;
    }

    /**
     * READ: Retrieves products belonging to a specific category.
     *
     * @param categoryId Category ID
     * @return List of products
     */
    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> products = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnectionUtil.getConnection();
            stmt = conn.prepareStatement(SQL_SELECT_BY_CATEGORY);
            stmt.setInt(1, categoryId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching products for category: " + categoryId, e);
        } finally {
            DBConnectionUtil.closeResources(conn, stmt, rs);
        }
        return products;
    }

    /**
     * READ: Searches products by keyword in name or description.
     *
     * @param keyword Search term
     * @return List of matching products
     */
    public List<Product> searchProducts(String keyword) {
        List<Product> products = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnectionUtil.getConnection();
            stmt = conn.prepareStatement(SQL_SEARCH);
            String pattern = "%" + (keyword != null ? keyword.trim().toLowerCase() : "") + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            rs = stmt.executeQuery();

            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error searching products with keyword: " + keyword, e);
        } finally {
            DBConnectionUtil.closeResources(conn, stmt, rs);
        }
        return products;
    }

    /**
     * UPDATE: Updates existing product information in database.
     *
     * @param product Product to update
     * @return true if updated successfully, false otherwise
     */
    public boolean updateProduct(Product product) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnectionUtil.getConnection();
            stmt = conn.prepareStatement(SQL_UPDATE);

            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setBigDecimal(3, product.getPrice());
            stmt.setInt(4, product.getStock());

            if (product.getCategoryId() != null && product.getCategoryId() > 0) {
                stmt.setInt(5, product.getCategoryId());
            } else {
                stmt.setNull(5, Types.INTEGER);
            }

            stmt.setString(6, product.getImageUrl());
            stmt.setInt(7, product.getId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating product with id: " + product.getId(), e);
        } finally {
            DBConnectionUtil.closeResources(conn, stmt, null);
        }
        return false;
    }

    /**
     * DELETE: Deletes product by ID.
     *
     * @param id Product ID to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteProduct(int id) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnectionUtil.getConnection();
            stmt = conn.prepareStatement(SQL_DELETE);
            stmt.setInt(1, id);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting product with id: " + id, e);
        } finally {
            DBConnectionUtil.closeResources(conn, stmt, null);
        }
        return false;
    }

    /**
     * Deducts stock for a product, transactional helper for orders.
     */
    public boolean deductStock(Connection conn, int productId, int quantity) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(SQL_DEDUCT_STOCK)) {
            stmt.setInt(1, quantity);
            stmt.setInt(2, productId);
            stmt.setInt(3, quantity);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Returns total count of products in the store.
     */
    public int getTotalProductCount() {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnectionUtil.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(SQL_COUNT);
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving product count", e);
        } finally {
            DBConnectionUtil.closeResources(conn, stmt, rs);
        }
        return 0;
    }

    /**
     * Helper mapper method to transform ResultSet row to Product entity.
     */
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getInt("id"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getBigDecimal("price"));
        product.setStock(rs.getInt("stock"));

        int catId = rs.getInt("category_id");
        if (!rs.wasNull()) {
            product.setCategoryId(catId);
        }
        product.setImageUrl(rs.getString("image_url"));
        product.setCreatedAt(rs.getTimestamp("created_at"));
        product.setUpdatedAt(rs.getTimestamp("updated_at"));
        product.setCategoryName(rs.getString("category_name"));

        return product;
    }
}
