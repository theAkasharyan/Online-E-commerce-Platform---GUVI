<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.ecommerce.model.CartItem" %>
<%
    request.setAttribute("pageTitle", "Shopping Cart");
%>
<%@ include file="/common/navbar.jsp" %>

<div class="container my-4">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <h2 class="fw-bold mb-0 text-dark">
            <i class="bi bi-cart3 text-primary me-2"></i>Shopping Cart
        </h2>
        <%
            @SuppressWarnings("unchecked")
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            BigDecimal cartTotal = (BigDecimal) session.getAttribute("cartTotal");
            if (cartTotal == null) cartTotal = BigDecimal.ZERO;
            boolean hasItems = (cart != null && !cart.isEmpty());
        %>
        <% if (hasItems) { %>
            <a href="<%= request.getContextPath() %>/cart/clear" class="btn btn-outline-danger btn-sm"
               onclick="return confirm('Are you sure you want to clear your cart?');">
                <i class="bi bi-trash3 me-1"></i>Clear Cart
            </a>
        <% } %>
    </div>

    <% if (hasItems) { %>
        <div class="row g-4">
            <!-- Items Table (Col 8) -->
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th scope="col" style="min-width: 250px;">Product</th>
                                    <th scope="col" class="text-center">Price</th>
                                    <th scope="col" class="text-center" style="width: 140px;">Quantity</th>
                                    <th scope="col" class="text-end">Subtotal</th>
                                    <th scope="col" class="text-center" style="width: 60px;"></th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (CartItem item : cart) { %>
                                    <tr>
                                        <!-- Product info -->
                                        <td>
                                            <div class="d-flex align-items-center gap-3">
                                                <img src="<%= (item.getProduct().getImageUrl() != null && !item.getProduct().getImageUrl().isEmpty()) ? item.getProduct().getImageUrl() : "https://via.placeholder.com/80" %>" 
                                                     alt="<%= item.getProduct().getName() %>" 
                                                     class="rounded-3" 
                                                     style="width: 65px; height: 65px; object-fit: cover;">
                                                <div>
                                                    <h6 class="mb-0 fw-semibold">
                                                        <a href="<%= request.getContextPath() %>/product?id=<%= item.getProduct().getId() %>" class="text-dark text-decoration-none">
                                                            <%= item.getProduct().getName() %>
                                                        </a>
                                                    </h6>
                                                    <small class="text-muted"><%= item.getProduct().getCategoryName() != null ? item.getProduct().getCategoryName() : "General" %></small>
                                                </div>
                                            </div>
                                        </td>

                                        <!-- Unit Price -->
                                        <td class="text-center fw-semibold text-secondary">
                                            $<%= String.format("%.2f", item.getProduct().getPrice()) %>
                                        </td>

                                        <!-- Quantity Form -->
                                        <td class="text-center">
                                            <form action="<%= request.getContextPath() %>/cart/update" method="post" class="d-flex align-items-center justify-content-center gap-1 m-0">
                                                <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                                                <input type="number" name="quantity" value="<%= item.getQuantity() %>" 
                                                       min="1" max="<%= item.getProduct().getStock() %>" 
                                                       class="form-control form-control-sm text-center" style="width: 65px;"
                                                       onchange="this.form.submit()">
                                            </form>
                                        </td>

                                        <!-- Subtotal -->
                                        <td class="text-end fw-bold text-dark">
                                            $<%= String.format("%.2f", item.getSubtotal()) %>
                                        </td>

                                        <!-- Remove Item -->
                                        <td class="text-center">
                                            <a href="<%= request.getContextPath() %>/cart/remove?productId=<%= item.getProduct().getId() %>" 
                                               class="text-danger" title="Remove item">
                                                <i class="bi bi-trash3 fs-5"></i>
                                            </a>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="mt-3">
                    <a href="<%= request.getContextPath() %>/products" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i>Continue Shopping
                    </a>
                </div>
            </div>

            <!-- Order Summary Sidebar (Col 4) -->
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white sticky-top" style="top: 80px;">
                    <h5 class="fw-bold mb-3 text-dark">Order Summary</h5>

                    <div class="d-flex justify-content-between mb-2 text-secondary">
                        <span>Items Subtotal:</span>
                        <span class="fw-semibold text-dark">$<%= String.format("%.2f", cartTotal) %></span>
                    </div>

                    <div class="d-flex justify-content-between mb-2 text-secondary">
                        <span>Standard Shipping:</span>
                        <span class="text-success fw-semibold">FREE</span>
                    </div>

                    <div class="d-flex justify-content-between mb-3 text-secondary">
                        <span>Estimated Tax:</span>
                        <span class="fw-semibold text-dark">$0.00</span>
                    </div>

                    <hr>

                    <div class="d-flex justify-content-between mb-4">
                        <span class="fs-5 fw-bold text-dark">Total:</span>
                        <span class="fs-4 fw-bold text-primary">$<%= String.format("%.2f", cartTotal) %></span>
                    </div>

                    <a href="<%= request.getContextPath() %>/checkout" class="btn btn-primary btn-lg w-100 py-3 fw-bold rounded-3">
                        <i class="bi bi-shield-lock me-1"></i>Proceed to Checkout
                    </a>

                    <div class="text-center mt-3 text-secondary small">
                        <i class="bi bi-lock-fill text-success me-1"></i>Encrypted & Secure 256-bit Checkout
                    </div>
                </div>
            </div>
        </div>
    <% } else { %>
        <!-- Empty Cart State -->
        <div class="card border-0 shadow-sm rounded-4 py-5 text-center bg-white">
            <div class="py-4">
                <i class="bi bi-cart-x text-secondary" style="font-size: 5rem; opacity: 0.4;"></i>
                <h3 class="fw-bold text-dark mt-3">Your Cart is Empty</h3>
                <p class="text-muted mb-4">Looks like you haven't added any products to your shopping bag yet.</p>
                <a href="<%= request.getContextPath() %>/products" class="btn btn-primary btn-lg px-4 rounded-pill">
                    <i class="bi bi-arrow-left me-2"></i>Explore Products
                </a>
            </div>
        </div>
    <% } %>

</div>

<%@ include file="/common/footer.jsp" %>
