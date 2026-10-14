<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Create Account");
%>
<%@ include file="/common/navbar.jsp" %>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-6">
            <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white">
                <div class="text-center mb-4">
                    <div class="d-inline-flex align-items-center justify-content-center bg-success bg-opacity-10 text-success rounded-circle mb-3" style="width: 60px; height: 60px;">
                        <i class="bi bi-person-plus-fill fs-3"></i>
                    </div>
                    <h3 class="fw-bold text-dark mb-1">Create an Account</h3>
                    <p class="text-muted small">Join ShopSphere to buy and track orders</p>
                </div>

                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-danger py-2 small" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-1"></i>
                        <%= request.getAttribute("errorMessage") %>
                    </div>
                <% } %>

                <form action="<%= request.getContextPath() %>/register" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Full Name <span class="text-danger">*</span></label>
                        <input type="text" name="name" class="form-control" required placeholder="Alex Smith"
                               value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>">
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Email Address <span class="text-danger">*</span></label>
                        <input type="email" name="email" class="form-control" required placeholder="alex@example.com">
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Password <span class="text-danger">*</span></label>
                        <input type="password" name="password" class="form-control" required placeholder="Minimum 6 characters">
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Phone Number</label>
                        <input type="tel" name="phone" class="form-control" placeholder="+1 (555) 012-3456"
                               value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>">
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold small">Delivery Address</label>
                        <textarea name="address" class="form-control" rows="2" placeholder="Street, City, State, Postal code"><%= request.getAttribute("address") != null ? request.getAttribute("address") : "" %></textarea>
                    </div>

                    <button type="submit" class="btn btn-success w-100 py-2 fw-semibold rounded-3 mb-3">
                        Register Account
                    </button>
                </form>

                <div class="text-center mt-3 text-muted small">
                    Already have an account? 
                    <a href="<%= request.getContextPath() %>/login" class="text-primary fw-semibold text-decoration-none">Sign In</a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>
