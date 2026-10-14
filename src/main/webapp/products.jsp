<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ecommerce.model.Product" %>
<%@ page import="com.ecommerce.model.Category" %>
<%
    request.setAttribute("pageTitle", "Product Catalog");
%>
<%@ include file="/common/navbar.jsp" %>

<div class="container">

    <!-- Promotional Hero Banner -->
    <div class="p-4 p-md-5 mb-4 rounded-4 bg-primary text-white position-relative overflow-hidden shadow-sm">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <span class="badge bg-white text-primary mb-2 px-3 py-2 fw-bold text-uppercase">New Collection 2026</span>
                <h1 class="display-5 fw-bold mb-3">Shop Premium Quality Electronics, Fashion & Home</h1>
                <p class="lead mb-4 text-white-50">
                    Explore top-rated products with real-time stock updates, secure checkout, and instant order tracking.
                </p>
                <div class="d-flex gap-2">
                    <a href="#catalogSection" class="btn btn-light btn-lg px-4 fw-semibold text-primary">Browse Catalog</a>
                    <a href="<%= request.getContextPath() %>/cart" class="btn btn-outline-light btn-lg px-4">View Cart</a>
                </div>
            </div>
            <div class="col-lg-4 d-none d-lg-block text-end">
                <i class="bi bi-bag-check-fill" style="font-size: 8rem; opacity: 0.15;"></i>
            </div>
        </div>
    </div>

    <!-- Category Filter Bar -->
    <div id="catalogSection" class="mb-4">
        <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
            <div>
                <h3 class="fw-bold mb-0 text-dark">
                    <%= request.getAttribute("filterTitle") != null ? request.getAttribute("filterTitle") : "All Products" %>
                </h3>
                <%
                    List<Product> products = (List<Product>) request.getAttribute("products");
                    int totalFound = (products != null) ? products.size() : 0;
                %>
                <small class="text-muted"><%= totalFound %> products available</small>
            </div>

            <!-- Category Pills -->
            <div class="d-flex gap-2 flex-wrap">
                <%
                    Integer selectedCategoryId = (Integer) request.getAttribute("selectedCategoryId");
                    List<Category> categories = (List<Category>) request.getAttribute("categories");
                %>
                <a href="<%= request.getContextPath() %>/products" 
                   class="btn btn-sm rounded-pill <%= (selectedCategoryId == null && request.getAttribute("searchQuery") == null) ? "btn-dark" : "btn-outline-secondary" %>">
                    All
                </a>
                <% if (categories != null) {
                    for (Category cat : categories) {
                        boolean isActive = selectedCategoryId != null && selectedCategoryId == cat.getId();
                %>
                    <a href="<%= request.getContextPath() %>/products?category=<%= cat.getId() %>" 
                       class="btn btn-sm rounded-pill <%= isActive ? "btn-primary" : "btn-outline-secondary" %>">
                        <%= cat.getName() %>
                    </a>
                <% 
                    }
                } %>
            </div>
        </div>

        <!-- Search Active Filter Reset -->
        <% if (request.getAttribute("searchQuery") != null || selectedCategoryId != null) { %>
            <div class="alert alert-secondary py-2 px-3 d-flex align-items-center justify-content-between mb-3">
                <span class="small">
                    Filtering active: <strong><%= request.getAttribute("filterTitle") %></strong>
                </span>
                <a href="<%= request.getContextPath() %>/products" class="btn btn-sm btn-link text-decoration-none p-0">
                    <i class="bi bi-x-circle me-1"></i>Reset Filter
                </a>
            </div>
        <% } %>
    </div>

    <!-- Product Cards Grid -->
    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4 mb-5">
        <% if (products != null && !products.isEmpty()) {
            for (Product p : products) {
                boolean inStock = p.isInStock();
                String imgUrl = (p.getImageUrl() != null && !p.getImageUrl().trim().isEmpty()) 
                                ? p.getImageUrl() 
                                : "https://via.placeholder.com/600x400?text=" + p.getName();
        %>
            <div class="col">
                <div class="card h-100 product-card shadow-sm rounded-3">
                    <!-- Product Image -->
                    <div class="product-img-wrapper position-relative">
                        <img src="<%= imgUrl %>" alt="<%= p.getName() %>" loading="lazy">
                        <!-- Category Badge -->
                        <% if (p.getCategoryName() != null) { %>
                            <span class="position-absolute top-0 start-0 m-2 badge bg-dark bg-opacity-75 rounded-pill">
                                <%= p.getCategoryName() %>
                            </span>
                        <% } %>
                        <!-- Stock Status Badge -->
                        <span class="position-absolute top-0 end-0 m-2 badge <%= inStock ? "bg-success" : "bg-danger" %> rounded-pill">
                            <%= inStock ? "In Stock (" + p.getStock() + ")" : "Out of Stock" %>
                        </span>
                    </div>

                    <!-- Card Body -->
                    <div class="card-body d-flex flex-column p-3">
                        <h6 class="card-title fw-bold mb-1 text-truncate" title="<%= p.getName() %>">
                            <a href="<%= request.getContextPath() %>/product?id=<%= p.getId() %>" class="text-dark text-decoration-none">
                                <%= p.getName() %>
                            </a>
                        </h6>
                        <p class="card-text text-secondary small mb-3 flex-grow-1" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                            <%= p.getDescription() != null ? p.getDescription() : "No description provided." %>
                        </p>

                        <!-- Price & Stock -->
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <div>
                                <span class="fs-5 fw-bold text-primary">$<%= String.format("%.2f", p.getPrice()) %></span>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex gap-2">
                            <a href="<%= request.getContextPath() %>/product?id=<%= p.getId() %>" 
                               class="btn btn-outline-secondary btn-sm flex-grow-1">
                                Details
                            </a>
                            <form action="<%= request.getContextPath() %>/cart/add" method="post" class="flex-grow-1 m-0">
                                <input type="hidden" name="productId" value="<%= p.getId() %>">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="btn btn-primary btn-sm w-100 d-flex align-items-center justify-content-center gap-1"
                                        <%= !inStock ? "disabled" : "" %>>
                                    <i class="bi bi-cart-plus"></i> Add
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        <% 
            }
        } else { %>
            <div class="col-12 py-5 text-center">
                <div class="text-secondary mb-3">
                    <i class="bi bi-search fs-1"></i>
                </div>
                <h4 class="fw-bold text-dark">No Products Found</h4>
                <p class="text-muted">We couldn't find any items matching your selection criteria.</p>
                <a href="<%= request.getContextPath() %>/products" class="btn btn-primary mt-2">
                    Browse All Products
                </a>
            </div>
        <% } %>
    </div>

</div>

<%@ include file="/common/footer.jsp" %>
