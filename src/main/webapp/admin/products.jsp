<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ecommerce.model.Product" %>
<%
    request.setAttribute("pageTitle", "Admin Product Management");
    List<Product> products = (List<Product>) request.getAttribute("products");
    int total = (products != null) ? products.size() : 0;
    int inStock = 0;
    int outOfStock = 0;
    if (products != null) {
        for (Product p : products) {
            if (p.getStock() > 0) inStock++;
            else outOfStock++;
        }
    }
%>
<%@ include file="/common/navbar.jsp" %>

<div class="container my-4">

    <!-- Header & Action -->
    <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-2">
        <div>
            <h2 class="fw-bold text-dark mb-0"><i class="bi bi-box-seam text-primary me-2"></i>Product Inventory Management</h2>
            <p class="text-muted small mb-0">Perform CRUD operations matching database schema</p>
        </div>
        <div class="d-flex gap-2">
            <a href="<%= request.getContextPath() %>/admin/products/new" class="btn btn-primary">
                <i class="bi bi-plus-circle me-1"></i>Add New Product
            </a>
            <a href="<%= request.getContextPath() %>/products" class="btn btn-outline-secondary">
                <i class="bi bi-eye me-1"></i>View Storefront
            </a>
        </div>
    </div>

    <!-- Quick Stats Cards -->
    <div class="row g-3 mb-4">
        <div class="col-sm-4">
            <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <span class="text-muted small">Total Products</span>
                        <h3 class="fw-bold text-dark mb-0"><%= total %></h3>
                    </div>
                    <div class="bg-primary bg-opacity-10 text-primary p-3 rounded-circle">
                        <i class="bi bi-boxes fs-4"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-sm-4">
            <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <span class="text-muted small">In Stock</span>
                        <h3 class="fw-bold text-success mb-0"><%= inStock %></h3>
                    </div>
                    <div class="bg-success bg-opacity-10 text-success p-3 rounded-circle">
                        <i class="bi bi-check-circle fs-4"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-sm-4">
            <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <span class="text-muted small">Out of Stock</span>
                        <h3 class="fw-bold text-danger mb-0"><%= outOfStock %></h3>
                    </div>
                    <div class="bg-danger bg-opacity-10 text-danger p-3 rounded-circle">
                        <i class="bi bi-exclamation-triangle fs-4"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Products Data Table -->
    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-dark">
                    <tr>
                        <th scope="col" style="width: 60px;">ID</th>
                        <th scope="col" style="width: 80px;">Image</th>
                        <th scope="col">Product Name</th>
                        <th scope="col">Category</th>
                        <th scope="col" class="text-end">Price</th>
                        <th scope="col" class="text-center">Stock</th>
                        <th scope="col" class="text-center" style="width: 150px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (products != null && !products.isEmpty()) {
                        for (Product p : products) { 
                            boolean lowStock = p.getStock() <= 5;
                    %>
                        <tr>
                            <td class="fw-bold text-secondary">#<%= p.getId() %></td>
                            <td>
                                <img src="<%= (p.getImageUrl() != null && !p.getImageUrl().isEmpty()) ? p.getImageUrl() : "https://via.placeholder.com/60" %>" 
                                     alt="<%= p.getName() %>" class="rounded-2" 
                                     style="width: 48px; height: 48px; object-fit: cover;">
                            </td>
                            <td>
                                <div class="fw-bold text-dark"><%= p.getName() %></div>
                                <div class="text-muted small text-truncate" style="max-width: 250px;">
                                    <%= p.getDescription() != null ? p.getDescription() : "No description" %>
                                </div>
                            </td>
                            <td>
                                <span class="badge bg-secondary">
                                    <%= p.getCategoryName() != null ? p.getCategoryName() : "Unassigned" %>
                                </span>
                            </td>
                            <td class="text-end fw-bold text-primary">
                                $<%= String.format("%.2f", p.getPrice()) %>
                            </td>
                            <td class="text-center">
                                <span class="badge <%= p.getStock() == 0 ? "bg-danger" : (lowStock ? "bg-warning text-dark" : "bg-success") %>">
                                    <%= p.getStock() %> units
                                </span>
                            </td>
                            <td class="text-center">
                                <div class="btn-group btn-group-sm">
                                    <a href="<%= request.getContextPath() %>/admin/products/edit?id=<%= p.getId() %>" 
                                       class="btn btn-outline-primary" title="Edit Product">
                                        <i class="bi bi-pencil-square"></i> Edit
                                    </a>
                                    <a href="<%= request.getContextPath() %>/admin/products/delete?id=<%= p.getId() %>" 
                                       class="btn btn-outline-danger" 
                                       onclick="return confirm('Are you sure you want to delete Product #<%= p.getId() %> (<%= p.getName() %>)?');"
                                       title="Delete Product">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    <%  }
                    } else { %>
                        <tr>
                            <td colspan="7" class="text-center py-5 text-muted">
                                <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                No products found in the database.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

</div>

<%@ include file="/common/footer.jsp" %>
