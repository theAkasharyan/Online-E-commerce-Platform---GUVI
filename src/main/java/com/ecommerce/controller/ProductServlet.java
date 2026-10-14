package com.ecommerce.controller;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Category;
import com.ecommerce.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller handling public product catalog, filtering, searching, and single product views.
 */
@WebServlet(name = "ProductServlet", urlPatterns = {"/products", "/product"})
public class ProductServlet extends HttpServlet {
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
        String servletPath = request.getServletPath();

        if ("/product".equals(servletPath)) {
            showProductDetail(request, response);
        } else {
            listProducts(request, response);
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String categoryParam = request.getParameter("category");
        String searchParam = request.getParameter("search");

        List<Product> productList;
        String activeFilterTitle = "All Products";

        if (searchParam != null && !searchParam.trim().isEmpty()) {
            productList = productDAO.searchProducts(searchParam.trim());
            activeFilterTitle = "Search Results for \"" + searchParam.trim() + "\"";
            request.setAttribute("searchQuery", searchParam.trim());
        } else if (categoryParam != null && !categoryParam.trim().isEmpty()) {
            try {
                int categoryId = Integer.parseInt(categoryParam.trim());
                productList = productDAO.getProductsByCategory(categoryId);
                Category cat = categoryDAO.getCategoryById(categoryId);
                if (cat != null) {
                    activeFilterTitle = cat.getName();
                    request.setAttribute("selectedCategoryId", categoryId);
                }
            } catch (NumberFormatException e) {
                productList = productDAO.getAllProducts();
            }
        } else {
            productList = productDAO.getAllProducts();
        }

        List<Category> categoryList = categoryDAO.getAllCategories();

        request.setAttribute("products", productList);
        request.setAttribute("categories", categoryList);
        request.setAttribute("filterTitle", activeFilterTitle);

        request.getRequestDispatcher("/products.jsp").forward(request, response);
    }

    private void showProductDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            int id = Integer.parseInt(idParam.trim());
            Product product = productDAO.getProductById(id);

            if (product == null) {
                request.setAttribute("errorMessage", "Product not found.");
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }

            request.setAttribute("product", product);
            request.getRequestDispatcher("/product-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
}
