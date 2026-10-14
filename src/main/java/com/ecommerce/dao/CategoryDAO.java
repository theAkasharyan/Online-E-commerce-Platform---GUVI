package com.ecommerce.dao;

import com.ecommerce.model.Category;
import com.ecommerce.util.DBConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Product Categories.
 */
public class CategoryDAO {

    private static final Logger LOGGER = Logger.getLogger(CategoryDAO.class.getName());

    private static final String SQL_SELECT_ALL = "SELECT id, name, description, image_url FROM categories ORDER BY name ASC";
    private static final String SQL_SELECT_BY_ID = "SELECT id, name, description, image_url FROM categories WHERE id = ?";
    private static final String SQL_INSERT = "INSERT INTO categories (name, description, image_url) VALUES (?, ?, ?)";

    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnectionUtil.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(SQL_SELECT_ALL);

            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                c.setImageUrl(rs.getString("image_url"));
                categories.add(c);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching categories", e);
        } finally {
            DBConnectionUtil.closeResources(conn, stmt, rs);
        }
        return categories;
    }

    public Category getCategoryById(int id) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnectionUtil.getConnection();
            stmt = conn.prepareStatement(SQL_SELECT_BY_ID);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();

            if (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                c.setImageUrl(rs.getString("image_url"));
                return c;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching category by id: " + id, e);
        } finally {
            DBConnectionUtil.closeResources(conn, stmt, rs);
        }
        return null;
    }

    public boolean addCategory(Category category) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnectionUtil.getConnection();
            stmt = conn.prepareStatement(SQL_INSERT);
            stmt.setString(1, category.getName());
            stmt.setString(2, category.getDescription());
            stmt.setString(3, category.getImageUrl());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting category", e);
        } finally {
            DBConnectionUtil.closeResources(conn, stmt, null);
        }
        return false;
    }
}
