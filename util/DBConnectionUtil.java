package util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utility class to manage MySQL JDBC database connections.
 * Reads database credentials dynamically from 'db.properties'.
 */
public class DBConnectionUtil {

    private static final Logger LOGGER = Logger.getLogger(DBConnectionUtil.class.getName());
    private static final Properties properties = new Properties();

    private static String dbUrl;
    private static String dbUser;
    private static String dbPassword;
    private static String dbDriver;

    static {
        loadProperties();
        loadDriver();
    }

    /**
     * Loads database configuration properties from classpath or file system.
     */
    private static void loadProperties() {
        InputStream input = null;
        try {
            // 1. Context ClassLoader
            ClassLoader contextClassLoader = Thread.currentThread().getContextClassLoader();
            if (contextClassLoader != null) {
                input = contextClassLoader.getResourceAsStream("db.properties");
            }

            // 2. Class ClassLoader
            if (input == null) {
                input = DBConnectionUtil.class.getClassLoader().getResourceAsStream("db.properties");
            }

            // 3. Class direct resource
            if (input == null) {
                input = DBConnectionUtil.class.getResourceAsStream("/db.properties");
            }

            // 4. File system fallback
            if (input == null) {
                String[] potentialPaths = {
                    "db.properties",
                    "src/main/resources/db.properties",
                    "ecommerce-app/db.properties",
                    "../db.properties"
                };

                for (String path : potentialPaths) {
                    File file = new File(path);
                    if (file.exists() && file.isFile()) {
                        input = new FileInputStream(file);
                        LOGGER.info("Loaded db.properties from file: " + file.getAbsolutePath());
                        break;
                    }
                }
            }

            if (input == null) {
                throw new RuntimeException("CRITICAL: 'db.properties' file not found in classpath or project directories.");
            }

            properties.load(input);

            dbDriver = properties.getProperty("db.driver", "com.mysql.cj.jdbc.Driver").trim();
            dbUrl = properties.getProperty("db.url").trim();
            dbUser = properties.getProperty("db.username", properties.getProperty("db.user", "root")).trim();
            dbPassword = properties.getProperty("db.password", "").trim();

            LOGGER.info("Database properties loaded successfully. URL: " + dbUrl);

        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to read db.properties file", e);
            throw new RuntimeException("Failed to load db.properties: " + e.getMessage(), e);
        } finally {
            if (input != null) {
                try {
                    input.close();
                } catch (IOException ignored) {}
            }
        }
    }

    /**
     * Loads the JDBC driver class.
     */
    private static void loadDriver() {
        try {
            Class.forName(dbDriver);
            LOGGER.info("JDBC Driver registered: " + dbDriver);
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "MySQL JDBC Driver not found in classpath: " + dbDriver, e);
            throw new RuntimeException("MySQL JDBC Driver missing. Ensure mysql-connector-j jar is present.", e);
        }
    }

    /**
     * Obtains a new database connection.
     *
     * @return active java.sql.Connection
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Could not establish database connection to: " + dbUrl, e);
            throw e;
        }
    }

    /**
     * Closes a database connection safely.
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing connection", e);
            }
        }
    }

    /**
     * Closes Statement safely.
     */
    public static void closeStatement(Statement stmt) {
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing statement", e);
            }
        }
    }

    /**
     * Closes ResultSet safely.
     */
    public static void closeResultSet(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing result set", e);
            }
        }
    }

    /**
     * Closes Connection, Statement, and ResultSet in one call.
     */
    public static void closeResources(Connection conn, Statement stmt, ResultSet rs) {
        closeResultSet(rs);
        closeStatement(stmt);
        closeConnection(conn);
    }

    /**
     * Quick test runner.
     */
    public static void main(String[] args) {
        System.out.println("Testing DBConnectionUtil connectivity...");
        try (Connection conn = getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("[SUCCESS] Database connected successfully to: " + conn.getCatalog());
            }
        } catch (SQLException e) {
            System.err.println("[ERROR] Database connection failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
