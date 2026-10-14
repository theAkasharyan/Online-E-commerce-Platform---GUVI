<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ecommerce.model.Product" %>
<%
    Product product = (Product) request.getAttribute("product");
    if (product == null) {
        response.sendRedirect(request.getContextPath() + "/products");
        return;
    }
    request.setAttribute("pageTitle", product.getName());
%>
<%@ include file="/common/navbar.jsp" %>

<div class="container my-4">

    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="<%= request.getContextPath() %>/products" class="text-decoration-none">Home</a></li>
            <% if (product.getCategoryName() != null) { %>
                <li class="breadcrumb-item">
                    <a href="<%= request.getContextPath() %>/products?category=<%= product.getCategoryId() %>" class="text-decoration-none">
                        <%= product.getCategoryName() %>
                    </a>
                </li>
            <% } %>
            <li class="breadcrumb-item active" aria-current="page"><%= product.getName() %></li>
        </ol>
    </nav>

    <div class="row g-5">
        <!-- Product Image -->
        <div class="col-md-6">
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white text-center p-3">
                <img src="<%= (product.getImageUrl() != null && !product.getImageUrl().isEmpty()) ? product.getImageUrl() : "https://via.placeholder.com/600x500?text=" + product.getName() %>" 
                     alt="<%= product.getName() %>" 
                     class="img-fluid rounded-3" 
                     style="max-height: 480px; object-fit: contain;">
            </div>
        </div>

        <!-- Product Information & Action -->
        <div class="col-md-6 d-flex flex-column justify-content-center">
            <div>
                <% if (product.getCategoryName() != null) { %>
                    <span class="badge bg-secondary mb-2 px-3 py-2 text-uppercase">
                        <%= product.getCategoryName() %>
                    </span>
                <% } %>

                <h1 class="display-6 fw-bold text-dark mb-3"><%= product.getName() %></h1>

                <div class="d-flex align-items-center gap-3 mb-3">
                    <span class="fs-2 fw-bold text-primary">$<%= String.format("%.2f", product.getPrice()) %></span>
                    <% if (product.isInStock()) { %>
                        <span class="badge bg-success-subtle text-success border border-success px-3 py-2 rounded-pill">
                            <i class="bi bi-check-circle me-1"></i>In Stock (<%= product.getStock() %> available)
                        </span>
                    <% } else { %>
                        <span class="badge bg-danger-subtle text-danger border border-danger px-3 py-2 rounded-pill">
                            <i class="bi bi-x-circle me-1"></i>Out of Stock
                        </span>
                    <% } %>
                </div>

                <hr class="my-4">

                <h5 class="fw-semibold text-dark mb-2">Description</h5>
                <p class="text-secondary lead fs-6 lh-base mb-4">
                    <%= product.getDescription() != null ? product.getDescription() : "No detailed description provided." %>
                </p>

                <!-- Add to Cart Form -->
                <form action="<%= request.getContextPath() %>/cart/add" method="post" class="mt-4">
                    <input type="hidden" name="productId" value="<%= product.getId() %>">

                    <div class="row g-3 align-items-center mb-4">
                        <div class="col-auto">
                            <label for="quantityInput" class="col-form-label fw-semibold">Quantity:</label>
                        </div>
                        <div class="col-auto">
                            <input type="number" id="quantityInput" name="quantity" class="form-control text-center" 
                                   value="1" min="1" max="<%= product.getStock() > 0 ? product.getStock() : 1 %>" 
                                   style="width: 80px;" <%= !product.isInStock() ? "disabled" : "" %>>
                        </div>
                    </div>

                    <div class="d-flex gap-3">
                        <button type="submit" class="btn btn-primary btn-lg px-4 py-2 d-flex align-items-center gap-2"
                                <%= !product.isInStock() ? "disabled" : "" %>>
                            <i class="bi bi-cart-plus fs-5"></i>
                            <span>Add to Shopping Cart</span>
                        </button>
                        <a href="<%= request.getContextPath() %>/products" class="btn btn-outline-secondary btn-lg px-4 py-2">
                            Back to Store
                        </a>
                    </div>
                </form>

                <div class="mt-5 border-top pt-4">
                    <div class="row text-secondary small g-3">
                        <div class="col-sm-4 d-flex align-items-center gap-2">
                            <i class="bi bi-truck fs-4 text-primary"></i>
                            <span>Fast Delivery Available</span>
                        </div>
                        <div class="col-sm-4 d-flex align-items-center gap-2">
                            <i class="bi bi-shield-check fs-4 text-success"></i>
                            <span>100% Genuine Quality</span>
                        </div>
                        <div class="col-sm-4 d-flex align-items-center gap-2">
                            <i class="bi bi-arrow-repeat fs-4 text-info"></i>
                            <span>Easy 7-Day Returns</span>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>
