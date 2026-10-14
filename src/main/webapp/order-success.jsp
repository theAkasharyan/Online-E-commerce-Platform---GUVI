<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ecommerce.model.Order" %>
<%@ page import="com.ecommerce.model.OrderItem" %>
<%
    request.setAttribute("pageTitle", "Order Successful");
    Order order = (Order) request.getAttribute("order");
%>
<%@ include file="/common/navbar.jsp" %>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm rounded-4 text-center p-4 p-md-5 bg-white">
                <div class="mb-4">
                    <span class="d-inline-flex align-items-center justify-content-center bg-success text-white rounded-circle shadow" style="width: 80px; height: 80px;">
                        <i class="bi bi-check2 fs-1 fw-bold"></i>
                    </span>
                </div>

                <h2 class="fw-bold text-dark mb-2">Thank You for Your Order!</h2>
                <p class="text-secondary lead fs-6 mb-4">
                    Your order has been placed successfully and is being prepared for shipment.
                </p>

                <% if (order != null) { %>
                    <div class="card bg-light border-0 rounded-3 p-3 text-start mb-4">
                        <div class="row g-3">
                            <div class="col-sm-6">
                                <span class="text-muted small d-block">Order Reference ID</span>
                                <strong class="fs-5 text-primary">#ORD-<%= order.getId() %></strong>
                            </div>
                            <div class="col-sm-6">
                                <span class="text-muted small d-block">Order Status</span>
                                <span class="badge bg-warning text-dark"><%= order.getOrderStatus() %></span>
                            </div>
                            <div class="col-sm-6">
                                <span class="text-muted small d-block">Payment Method</span>
                                <strong><%= order.getPaymentMethod() %></strong>
                            </div>
                            <div class="col-sm-6">
                                <span class="text-muted small d-block">Total Amount</span>
                                <strong class="text-success fs-5">$<%= String.format("%.2f", order.getTotalAmount()) %></strong>
                            </div>
                            <div class="col-12 border-top pt-2 mt-2">
                                <span class="text-muted small d-block">Shipping Address:</span>
                                <span><%= order.getShippingAddress() %> (Phone: <%= order.getPhone() %>)</span>
                            </div>
                        </div>
                    </div>

                    <% if (order.getItems() != null && !order.getItems().isEmpty()) { %>
                        <div class="text-start mb-4">
                            <h6 class="fw-bold mb-3">Items Summary:</h6>
                            <ul class="list-group list-group-flush border rounded-3">
                                <% for (OrderItem item : order.getItems()) { %>
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        <div>
                                            <span class="fw-semibold"><%= item.getProductName() %></span>
                                            <span class="text-muted small d-block">Quantity: <%= item.getQuantity() %> &times; $<%= String.format("%.2f", item.getUnitPrice()) %></span>
                                        </div>
                                        <span class="fw-bold">$<%= String.format("%.2f", item.getSubtotal()) %></span>
                                    </li>
                                <% } %>
                            </ul>
                        </div>
                    <% } %>
                <% } %>

                <div class="d-flex justify-content-center gap-3 flex-wrap">
                    <a href="<%= request.getContextPath() %>/products" class="btn btn-primary btn-lg px-4 rounded-pill">
                        <i class="bi bi-bag me-1"></i>Continue Shopping
                    </a>
                    <a href="<%= request.getContextPath() %>/orders" class="btn btn-outline-secondary btn-lg px-4 rounded-pill">
                        <i class="bi bi-clock-history me-1"></i>View All Orders
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>
