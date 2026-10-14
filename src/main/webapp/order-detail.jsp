<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ecommerce.model.Order" %>
<%@ page import="com.ecommerce.model.OrderItem" %>
<%
    Order order = (Order) request.getAttribute("order");
    if (order == null) {
        response.sendRedirect(request.getContextPath() + "/orders");
        return;
    }
    request.setAttribute("pageTitle", "Order Details #" + order.getId());
%>
<%@ include file="/common/navbar.jsp" %>

<div class="container my-4">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h2 class="fw-bold text-dark mb-0">Order Details #ORD-<%= order.getId() %></h2>
            <small class="text-muted">Placed on <%= order.getCreatedAt() != null ? order.getCreatedAt() : "N/A" %></small>
        </div>
        <a href="<%= request.getContextPath() %>/orders" class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left me-1"></i>Back to Orders
        </a>
    </div>

    <div class="row g-4">
        <!-- Items table (Col 8) -->
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
                <div class="card-header bg-white py-3 border-0">
                    <h5 class="fw-bold mb-0">Purchased Items</h5>
                </div>
                <div class="table-responsive">
                    <table class="table align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Item</th>
                                <th class="text-center">Unit Price</th>
                                <th class="text-center">Quantity</th>
                                <th class="text-end">Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (order.getItems() != null) {
                                for (OrderItem item : order.getItems()) { %>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center gap-3">
                                                <img src="<%= (item.getProductImage() != null && !item.getProductImage().isEmpty()) ? item.getProductImage() : "https://via.placeholder.com/60" %>" 
                                                     class="rounded-3" style="width: 50px; height: 50px; object-fit: cover;">
                                                <span class="fw-semibold"><%= item.getProductName() %></span>
                                            </div>
                                        </td>
                                        <td class="text-center">$<%= String.format("%.2f", item.getUnitPrice()) %></td>
                                        <td class="text-center"><%= item.getQuantity() %></td>
                                        <td class="text-end fw-bold">$<%= String.format("%.2f", item.getSubtotal()) %></td>
                                    </tr>
                            <%  }
                            } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Order Information (Col 4) -->
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                <h5 class="fw-bold mb-3 text-dark">Order Information</h5>

                <div class="mb-3">
                    <span class="text-muted small d-block">Status:</span>
                    <span class="badge bg-primary px-3 py-2 rounded-pill fs-6"><%= order.getOrderStatus() %></span>
                </div>

                <div class="mb-3">
                    <span class="text-muted small d-block">Payment Method:</span>
                    <strong><%= order.getPaymentMethod() %></strong>
                </div>

                <div class="mb-3">
                    <span class="text-muted small d-block">Contact Phone:</span>
                    <strong><%= order.getPhone() %></strong>
                </div>

                <div class="mb-3">
                    <span class="text-muted small d-block">Shipping Address:</span>
                    <p class="mb-0 text-secondary"><%= order.getShippingAddress() %></p>
                </div>

                <hr>

                <div class="d-flex justify-content-between mb-2">
                    <span class="fw-bold fs-5">Total Paid:</span>
                    <span class="fw-bold fs-4 text-primary">$<%= String.format("%.2f", order.getTotalAmount()) %></span>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>
