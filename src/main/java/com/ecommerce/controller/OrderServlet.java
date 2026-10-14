package com.ecommerce.controller;

import com.ecommerce.dao.OrderDAO;
import com.ecommerce.model.Order;
import com.ecommerce.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller handling Order Success confirmation and Customer Order history.
 */
@WebServlet(name = "OrderServlet", urlPatterns = {"/orders", "/order-detail", "/order-success"})
public class OrderServlet extends HttpServlet {
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
        String servletPath = request.getServletPath();

        switch (servletPath) {
            case "/order-success":
                showOrderSuccess(request, response);
                break;
            case "/order-detail":
                showOrderDetail(request, response);
                break;
            case "/orders":
            default:
                showUserOrders(request, response);
                break;
        }
    }

    private void showOrderSuccess(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idParam = request.getParameter("orderId");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int orderId = Integer.parseInt(idParam);
                Order order = orderDAO.getOrderById(orderId);
                request.setAttribute("order", order);
            } catch (NumberFormatException ignored) {}
        }
        request.getRequestDispatcher("/order-success.jsp").forward(request, response);
    }

    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int orderId = Integer.parseInt(idParam);
                Order order = orderDAO.getOrderById(orderId);
                request.setAttribute("order", order);
                request.getRequestDispatcher("/order-detail.jsp").forward(request, response);
                return;
            } catch (NumberFormatException ignored) {}
        }
        response.sendRedirect(request.getContextPath() + "/orders");
    }

    private void showUserOrders(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null) {
            request.getSession().setAttribute("flashMessage", "Please login to view your order history.");
            request.getSession().setAttribute("flashType", "info");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<Order> orders = orderDAO.getOrdersByUserId(user.getId());
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/orders.jsp").forward(request, response);
    }
}
