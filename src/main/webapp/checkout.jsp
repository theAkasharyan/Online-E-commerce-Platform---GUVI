<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.ecommerce.model.CartItem" %>
<%@ page import="com.ecommerce.model.User" %>
<%
    request.setAttribute("pageTitle", "Checkout");
    User u = (User) session.getAttribute("currentUser");
    @SuppressWarnings("unchecked")
    List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cart");
    BigDecimal cartTotal = (BigDecimal) session.getAttribute("cartTotal");
    if (cartTotal == null) cartTotal = BigDecimal.ZERO;
%>
<%@ include file="/common/navbar.jsp" %>

<div class="container my-4">
    <div class="mb-4">
        <h2 class="fw-bold text-dark"><i class="bi bi-credit-card-2-front text-primary me-2"></i>Checkout & Shipping</h2>
        <p class="text-muted">Please provide your delivery destination and contact details to finalize your order.</p>
    </div>

    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            <%= request.getAttribute("errorMessage") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <form action="<%= request.getContextPath() %>/checkout/place-order" method="post">
        <div class="row g-4">
            <!-- Shipping Info Form (Col 7) -->
            <div class="col-lg-7">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                    <h5 class="fw-bold text-dark mb-3"><i class="bi bi-geo-alt text-primary me-2"></i>Delivery Information</h5>

                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label fw-semibold">Full Name <span class="text-danger">*</span></label>
                            <input type="text" name="name" class="form-control form-control-lg fs-6" 
                                   value="<%= u != null ? u.getName() : "" %>" required placeholder="e.g. John Doe">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Email Address</label>
                            <input type="email" name="email" class="form-control form-control-lg fs-6" 
                                   value="<%= u != null ? u.getEmail() : "" %>" placeholder="john@example.com">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Phone Number <span class="text-danger">*</span></label>
                            <input type="tel" name="phone" class="form-control form-control-lg fs-6" 
                                   value="<%= u != null && u.getPhone() != null ? u.getPhone() : "" %>" required placeholder="+1 (555) 000-0000">
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-semibold">Complete Delivery Address <span class="text-danger">*</span></label>
                            <textarea name="address" rows="3" class="form-control fs-6" required 
                                      placeholder="Street address, Apartment / Suite, City, Postal Code"><%= u != null && u.getAddress() != null ? u.getAddress() : "" %></textarea>
                        </div>
                    </div>
                </div>

                <!-- Payment Method Card -->
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                    <h5 class="fw-bold text-dark mb-3"><i class="bi bi-cash-stack text-success me-2"></i>Payment Option</h5>

                    <div class="form-check p-3 border rounded-3 mb-2 bg-light">
                        <input class="form-check-input ms-0 me-3" type="radio" name="paymentMethod" id="cod" value="Cash on Delivery" checked>
                        <label class="form-check-label fw-semibold d-flex align-items-center justify-content-between w-100" for="cod">
                            <span><i class="bi bi-cash me-2 text-success"></i>Cash on Delivery (COD)</span>
                            <span class="badge bg-success">Pay at Doorstep</span>
                        </label>
                    </div>

                    <div class="form-check p-3 border rounded-3 mb-2">
                        <input class="form-check-input ms-0 me-3" type="radio" name="paymentMethod" id="card" value="Credit/Debit Card">
                        <label class="form-check-label fw-semibold d-flex align-items-center justify-content-between w-100" for="card">
                            <span><i class="bi bi-credit-card me-2 text-primary"></i>Credit / Debit Card</span>
                            <span class="text-muted small">Visa, Mastercard</span>
                        </label>
                    </div>

                    <div class="form-check p-3 border rounded-3">
                        <input class="form-check-input ms-0 me-3" type="radio" name="paymentMethod" id="upi" value="UPI / Online">
                        <label class="form-check-label fw-semibold d-flex align-items-center justify-content-between w-100" for="upi">
                            <span><i class="bi bi-phone me-2 text-info"></i>UPI / Digital Wallet</span>
                            <span class="text-muted small">Instant</span>
                        </label>
                    </div>
                </div>
            </div>

            <!-- Review Summary (Col 5) -->
            <div class="col-lg-5">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white sticky-top" style="top: 80px;">
                    <h5 class="fw-bold text-dark mb-3">Order Items (<%= cartItems != null ? cartItems.size() : 0 %>)</h5>

                    <div class="overflow-auto mb-3" style="max-height: 280px;">
                        <% if (cartItems != null) {
                            for (CartItem ci : cartItems) { %>
                                <div class="d-flex align-items-center justify-content-between py-2 border-bottom">
                                    <div class="d-flex align-items-center gap-2">
                                        <img src="<%= (ci.getProduct().getImageUrl() != null && !ci.getProduct().getImageUrl().isEmpty()) ? ci.getProduct().getImageUrl() : "https://via.placeholder.com/50" %>" 
                                             class="rounded-2" style="width: 45px; height: 45px; object-fit: cover;">
                                        <div>
                                            <div class="fw-semibold small text-truncate" style="max-width: 170px;"><%= ci.getProduct().getName() %></div>
                                            <div class="text-muted small">Qty: <%= ci.getQuantity() %> &times; $<%= String.format("%.2f", ci.getProduct().getPrice()) %></div>
                                        </div>
                                    </div>
                                    <span class="fw-bold small text-dark">$<%= String.format("%.2f", ci.getSubtotal()) %></span>
                                </div>
                        <%  }
                        } %>
                    </div>

                    <div class="d-flex justify-content-between mb-2 text-secondary">
                        <span>Items Subtotal:</span>
                        <span class="fw-semibold text-dark">$<%= String.format("%.2f", cartTotal) %></span>
                    </div>

                    <div class="d-flex justify-content-between mb-2 text-secondary">
                        <span>Shipping Delivery:</span>
                        <span class="text-success fw-semibold">FREE</span>
                    </div>

                    <hr>

                    <div class="d-flex justify-content-between mb-4">
                        <span class="fs-5 fw-bold text-dark">Total Payable:</span>
                        <span class="fs-4 fw-bold text-primary">$<%= String.format("%.2f", cartTotal) %></span>
                    </div>

                    <button type="submit" class="btn btn-primary btn-lg w-100 py-3 fw-bold rounded-3">
                        <i class="bi bi-bag-check-fill me-2"></i>Confirm & Place Order
                    </button>

                    <div class="text-center mt-3">
                        <a href="<%= request.getContextPath() %>/cart" class="text-secondary small text-decoration-none">
                            <i class="bi bi-arrow-left me-1"></i>Return to Cart
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<%@ include file="/common/footer.jsp" %>
