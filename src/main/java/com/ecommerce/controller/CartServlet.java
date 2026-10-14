package com.ecommerce.controller;

import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.CartItem;
import com.ecommerce.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Controller handling user Shopping Cart actions (Add, Update, Remove, Clear).
 * Persists cart state in user HTTP session.
 */
@WebServlet(name = "CartServlet", urlPatterns = {
    "/cart",
    "/cart/add",
    "/cart/update",
    "/cart/remove",
    "/cart/clear"
})
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/cart/clear".equals(path)) {
            clearCart(request, response);
        } else if ("/cart/remove".equals(path)) {
            removeItem(request, response);
        } else {
            viewCart(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/cart/add":
                addToCart(request, response);
                break;
            case "/cart/update":
                updateQuantity(request, response);
                break;
            case "/cart/remove":
                removeItem(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/cart");
                break;
        }
    }

    @SuppressWarnings("unchecked")
    private List<CartItem> getCart(HttpSession session) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private void updateCartTotals(HttpSession session, List<CartItem> cart) {
        BigDecimal total = BigDecimal.ZERO;
        int totalItems = 0;

        for (CartItem item : cart) {
            total = total.add(item.getSubtotal());
            totalItems += item.getQuantity();
        }

        session.setAttribute("cartTotal", total);
        session.setAttribute("cartCount", totalItems);
    }

    private void viewCart(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<CartItem> cart = getCart(session);
        updateCartTotals(session, cart);
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        List<CartItem> cart = getCart(session);

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = 1;
            String qtyParam = request.getParameter("quantity");
            if (qtyParam != null && !qtyParam.trim().isEmpty()) {
                quantity = Math.max(1, Integer.parseInt(qtyParam.trim()));
            }

            Product product = productDAO.getProductById(productId);
            if (product != null && product.getStock() > 0) {
                boolean itemExists = false;
                for (CartItem item : cart) {
                    if (item.getProduct().getId() == productId) {
                        int newQty = Math.min(item.getQuantity() + quantity, product.getStock());
                        item.setQuantity(newQty);
                        itemExists = true;
                        break;
                    }
                }

                if (!itemExists) {
                    int safeQty = Math.min(quantity, product.getStock());
                    cart.add(new CartItem(product, safeQty));
                }

                updateCartTotals(session, cart);
                session.setAttribute("flashMessage", product.getName() + " added to your cart!");
                session.setAttribute("flashType", "success");
            } else {
                session.setAttribute("flashMessage", "Item is out of stock!");
                session.setAttribute("flashType", "warning");
            }
        } catch (Exception e) {
            session.setAttribute("flashMessage", "Could not add item to cart.");
            session.setAttribute("flashType", "danger");
        }

        String referer = request.getHeader("referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private void updateQuantity(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        List<CartItem> cart = getCart(session);

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int newQuantity = Integer.parseInt(request.getParameter("quantity"));

            if (newQuantity <= 0) {
                cart.removeIf(item -> item.getProduct().getId() == productId);
            } else {
                Product product = productDAO.getProductById(productId);
                for (CartItem item : cart) {
                    if (item.getProduct().getId() == productId) {
                        int safeQty = Math.min(newQuantity, product != null ? product.getStock() : newQuantity);
                        item.setQuantity(safeQty);
                        break;
                    }
                }
            }
            updateCartTotals(session, cart);
        } catch (Exception ignored) {}

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void removeItem(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        List<CartItem> cart = getCart(session);

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            cart.removeIf(item -> item.getProduct().getId() == productId);
            updateCartTotals(session, cart);
            session.setAttribute("flashMessage", "Item removed from cart.");
            session.setAttribute("flashType", "info");
        } catch (Exception ignored) {}

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void clearCart(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        List<CartItem> cart = getCart(session);
        cart.clear();
        updateCartTotals(session, cart);

        session.setAttribute("flashMessage", "Shopping cart cleared.");
        session.setAttribute("flashType", "info");
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
