<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ecommerce.model.Order" %>
<%
    request.setAttribute("pageTitle", "Order History");
    List<Order> orders = (List<Order>) request.getAttribute("orders");
%>
<%@ include file="/common/navbar.jsp" %>

<div class="container my-4">
    <div class="mb-4">
        <h2 class="fw-bold text-dark"><i class="bi bi-clock-history text-primary me-2"></i>My Orders</h2>
        <p class="text-muted">Review your current and past purchases, track statuses, and view items.</p>
    </div>

    <% if (orders != null && !orders.isEmpty()) { %>
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th scope="col">Order ID</th>
                            <th scope="col">Date Placed</th>
                            <th scope="col">Payment Method</th>
                            <th scope="col">Status</th>
                            <th scope="col" class="text-end">Total Amount</th>
                            <th scope="col" class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Order ord : orders) { 
                            String badgeColor = "bg-secondary";
                            if ("PENDING".equals(ord.getOrderStatus())) badgeColor = "bg-warning text-dark";
                            else if ("PROCESSING".equals(ord.getOrderStatus())) badgeColor = "bg-info text-dark";
                            else if ("SHIPPED".equals(ord.getOrderStatus())) badgeColor = "bg-primary";
                            else if ("DELIVERED".equals(ord.getOrderStatus())) badgeColor = "bg-success";
                            else if ("CANCELLED".equals(ord.getOrderStatus())) badgeColor = "bg-danger";
                        %>
                            <tr>
                                <td class="fw-bold text-primary">#ORD-<%= ord.getId() %></td>
                                <td class="text-secondary small"><%= ord.getCreatedAt() != null ? ord.getCreatedAt() : "Recent" %></td>
                                <td><%= ord.getPaymentMethod() %></td>
                                <td>
                                    <span class="badge rounded-pill <%= badgeColor %>">
                                        <%= ord.getOrderStatus() %>
                                    </span>
                                </td>
                                <td class="text-end fw-bold text-dark">$<%= String.format("%.2f", ord.getTotalAmount()) %></td>
                                <td class="text-center">
                                    <a href="<%= request.getContextPath() %>/order-detail?id=<%= ord.getId() %>" class="btn btn-outline-primary btn-sm">
                                        View Details
                                    </a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    <% } else { %>
        <div class="card border-0 shadow-sm rounded-4 py-5 text-center bg-white">
            <div class="py-4">
                <i class="bi bi-receipt text-secondary" style="font-size: 4rem; opacity: 0.4;"></i>
                <h4 class="fw-bold text-dark mt-3">No Past Orders Found</h4>
                <p class="text-muted">You have not placed any orders yet.</p>
                <a href="<%= request.getContextPath() %>/products" class="btn btn-primary mt-2">
                    Browse Products
                </a>
            </div>
        </div>
    <% } %>
</div>

<%@ include file="/common/footer.jsp" %>
