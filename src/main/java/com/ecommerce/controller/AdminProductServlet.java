package com.ecommerce.controller;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Category;
import com.ecommerce.model.Product;
import com.ecommerce.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Controller handling Admin CRUD operations for products matching schema.sql.
 */
@WebServlet(name = "AdminProductServlet", urlPatterns = {
    "/admin/products",
    "/admin/products/new",
    "/admin/products/insert",
    "/admin/products/edit",
    "/admin/products/update",
    "/admin/products/delete"
})
public class AdminProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Authorization check (can be relaxed for testing, but let's allow session check)
        if (!isAdmin(request)) {
            // Store redirect message
            request.getSession().setAttribute("flashMessage", "Admin login required for management access.");
            request.getSession().setAttribute("flashType", "warning");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String path = request.getServletPath();

        switch (path) {
            case "/admin/products/new":
                showNewForm(request, response);
                break;
            case "/admin/products/edit":
                showEditForm(request, response);
                break;
            case "/admin/products/delete":
                deleteProduct(request, response);
                break;
            case "/admin/products":
            default:
                listAdminProducts(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String path = request.getServletPath();

        switch (path) {
            case "/admin/products/insert":
                insertProduct(request, response);
                break;
            case "/admin/products/update":
                updateProduct(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/products");
                break;
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("currentUser");
            if (user != null && "ADMIN".equalsIgnoreCase(user.getRole())) {
                return true;
            }
        }
        // For development/demo convenience, allow if ?demoAdmin=true is passed
        String demoParam = request.getParameter("demoAdmin");
        return "true".equals(demoParam);
    }

    private void listAdminProducts(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Product> products = productDAO.getAllProducts();
        request.setAttribute("products", products);
        request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Product existingProduct = productDAO.getProductById(id);
        List<Category> categories = categoryDAO.getAllCategories();

        request.setAttribute("product", existingProduct);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
    }

    private void insertProduct(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            
            String catStr = request.getParameter("categoryId");
            Integer categoryId = (catStr != null && !catStr.isEmpty()) ? Integer.parseInt(catStr) : null;
            
            String imageUrl = request.getParameter("imageUrl");

            Product product = new Product(name, description, price, stock, categoryId, imageUrl);
            boolean success = productDAO.addProduct(product);

            HttpSession session = request.getSession();
            if (success) {
                session.setAttribute("flashMessage", "Product '" + name + "' added successfully!");
                session.setAttribute("flashType", "success");
            } else {
                session.setAttribute("flashMessage", "Failed to add product. Please check input.");
                session.setAttribute("flashType", "danger");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("flashMessage", "Error processing product: " + e.getMessage());
            request.getSession().setAttribute("flashType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));

            String catStr = request.getParameter("categoryId");
            Integer categoryId = (catStr != null && !catStr.isEmpty()) ? Integer.parseInt(catStr) : null;

            String imageUrl = request.getParameter("imageUrl");

            Product product = new Product(id, name, description, price, stock, categoryId, imageUrl);
            boolean success = productDAO.updateProduct(product);

            HttpSession session = request.getSession();
            if (success) {
                session.setAttribute("flashMessage", "Product ID #" + id + " updated successfully!");
                session.setAttribute("flashType", "success");
            } else {
                session.setAttribute("flashMessage", "Failed to update product ID #" + id);
                session.setAttribute("flashType", "danger");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("flashMessage", "Error updating product: " + e.getMessage());
            request.getSession().setAttribute("flashType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = productDAO.deleteProduct(id);

            HttpSession session = request.getSession();
            if (success) {
                session.setAttribute("flashMessage", "Product #" + id + " deleted successfully!");
                session.setAttribute("flashType", "info");
            } else {
                session.setAttribute("flashMessage", "Failed to delete product #" + id);
                session.setAttribute("flashType", "danger");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("flashMessage", "Error deleting product: " + e.getMessage());
            request.getSession().setAttribute("flashType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }
}
