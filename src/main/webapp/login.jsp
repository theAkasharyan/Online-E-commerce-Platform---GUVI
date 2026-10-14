<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Sign In");
%>
<%@ include file="/common/navbar.jsp" %>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white">
                <div class="text-center mb-4">
                    <div class="d-inline-flex align-items-center justify-content-center bg-primary bg-opacity-10 text-primary rounded-circle mb-3" style="width: 60px; height: 60px;">
                        <i class="bi bi-person-fill fs-3"></i>
                    </div>
                    <h3 class="fw-bold text-dark mb-1">Welcome Back</h3>
                    <p class="text-muted small">Sign in to your ShopSphere account</p>
                </div>

                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-danger py-2 small" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-1"></i>
                        <%= request.getAttribute("errorMessage") %>
                    </div>
                <% } %>

                <form action="<%= request.getContextPath() %>/login" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-envelope"></i></span>
                            <input type="email" name="email" class="form-control" required 
                                   placeholder="user@example.com"
                                   value="<%= request.getAttribute("enteredEmail") != null ? request.getAttribute("enteredEmail") : "" %>">
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold small">Password</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-lock"></i></span>
                            <input type="password" name="password" class="form-control" required placeholder="••••••••">
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold rounded-3 mb-3">
                        Sign In
                    </button>
                </form>

                <!-- Demo Credentials Box -->
                <div class="card bg-light border-0 rounded-3 p-3 mt-2 text-start small">
                    <div class="fw-bold text-secondary mb-1"><i class="bi bi-key-fill text-warning me-1"></i>Pre-seeded Test Accounts:</div>
                    <div class="text-muted">
                        <div><strong>Admin:</strong> admin@ecommerce.com / admin123</div>
                        <div><strong>User:</strong> jane@example.com / user123</div>
                    </div>
                </div>

                <div class="text-center mt-4 text-muted small">
                    Don't have an account? 
                    <a href="<%= request.getContextPath() %>/register" class="text-primary fw-semibold text-decoration-none">Create Account</a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>
