package com.ecommerce.controller;

import com.ecommerce.dao.OrderDAO;
import com.ecommerce.model.CartItem;
import com.ecommerce.model.Order;
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
 * Controller handling checkout and order placement.
 */
@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout", "/checkout/place-order"})
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            session.setAttribute("flashMessage", "Your cart is currently empty. Add products to checkout.");
            session.setAttribute("flashType", "warning");
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        String fullName = request.getParameter("name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod");

        if (address == null || address.trim().isEmpty() || phone == null || phone.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Shipping address and contact phone are required.");
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
            return;
        }

        // Calculate total amount
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (CartItem item : cart) {
            totalAmount = totalAmount.add(item.getSubtotal());
        }

        // Determine user ID if logged in
        User currentUser = (User) session.getAttribute("currentUser");
        Integer userId = (currentUser != null) ? currentUser.getId() : null;

        Order order = new Order();
        order.setUserId(userId);
        order.setTotalAmount(totalAmount);
        order.setShippingAddress(address.trim());
        order.setPhone(phone.trim());
        order.setPaymentMethod(paymentMethod != null ? paymentMethod : "Cash on Delivery");
        order.setOrderStatus("PENDING");

        boolean success = orderDAO.placeOrder(order, cart);

        if (success) {
            // Clear cart
            cart.clear();
            session.removeAttribute("cartTotal");
            session.removeAttribute("cartCount");

            response.sendRedirect(request.getContextPath() + "/order-success?orderId=" + order.getId());
        } else {
            request.setAttribute("errorMessage", "Unable to complete order. An item in your cart may be out of stock.");
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
        }
    }
}
