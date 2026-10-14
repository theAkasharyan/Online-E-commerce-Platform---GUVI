<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ecommerce.model.Product" %>
<%@ page import="com.ecommerce.model.Category" %>
<%
    Product product = (Product) request.getAttribute("product");
    boolean isEdit = (product != null);
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    request.setAttribute("pageTitle", isEdit ? "Edit Product" : "Add New Product");
%>
<%@ include file="/common/navbar.jsp" %>

<div class="container my-4">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white">
                <div class="d-flex align-items-center justify-content-between mb-4 pb-2 border-bottom">
                    <div>
                        <h3 class="fw-bold text-dark mb-0">
                            <i class="bi <%= isEdit ? "bi-pencil-square text-warning" : "bi-plus-circle text-primary" %> me-2"></i>
                            <%= isEdit ? "Edit Product (#" + product.getId() + ")" : "Add New Product" %>
                        </h3>
                        <p class="text-muted small mb-0">Manage product catalog parameters matching schema.sql</p>
                    </div>
                    <a href="<%= request.getContextPath() %>/admin/products" class="btn btn-outline-secondary btn-sm">
                        <i class="bi bi-arrow-left me-1"></i>Back to List
                    </a>
                </div>

                <form action="<%= request.getContextPath() %>/admin/products/<%= isEdit ? "update" : "insert" %>" method="post">
                    <% if (isEdit) { %>
                        <input type="hidden" name="id" value="<%= product.getId() %>">
                    <% } %>

                    <!-- Product Name -->
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Product Name <span class="text-danger">*</span></label>
                        <input type="text" name="name" class="form-control" required 
                               placeholder="e.g. Sony WH-1000XM5 Headphones"
                               value="<%= isEdit ? product.getName() : "" %>">
                    </div>

                    <!-- Category & Price Row -->
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Category <span class="text-danger">*</span></label>
                            <select name="categoryId" class="form-select" required>
                                <option value="">-- Select Category --</option>
                                <% if (categories != null) {
                                    for (Category cat : categories) {
                                        boolean selected = isEdit && product.getCategoryId() != null && product.getCategoryId().equals(cat.getId());
                                %>
                                    <option value="<%= cat.getId() %>" <%= selected ? "selected" : "" %>>
                                        <%= cat.getName() %>
                                    </option>
                                <%  }
                                } %>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Price ($ USD) <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text">$</span>
                                <input type="number" step="0.01" min="0.01" name="price" class="form-control" required
                                       placeholder="99.99"
                                       value="<%= isEdit && product.getPrice() != null ? product.getPrice() : "" %>">
                            </div>
                        </div>
                    </div>

                    <!-- Stock & Image URL Row -->
                    <div class="row g-3 mb-3">
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Inventory Stock <span class="text-danger">*</span></label>
                            <input type="number" min="0" name="stock" class="form-control" required
                                   placeholder="25"
                                   value="<%= isEdit ? product.getStock() : "10" %>">
                        </div>

                        <div class="col-md-8">
                            <label class="form-label fw-semibold">Image URL (HTTPS link)</label>
                            <input type="url" name="imageUrl" class="form-control" 
                                   placeholder="https://images.unsplash.com/..."
                                   value="<%= isEdit && product.getImageUrl() != null ? product.getImageUrl() : "" %>">
                        </div>
                    </div>

                    <!-- Description -->
                    <div class="mb-4">
                        <label class="form-label fw-semibold">Product Description</label>
                        <textarea name="description" rows="4" class="form-control" 
                                  placeholder="Describe the product features, specifications, and warranty details..."><%= isEdit && product.getDescription() != null ? product.getDescription() : "" %></textarea>
                    </div>

                    <!-- Form Actions -->
                    <div class="d-flex justify-content-end gap-2">
                        <a href="<%= request.getContextPath() %>/admin/products" class="btn btn-light px-4">Cancel</a>
                        <button type="submit" class="btn btn-primary px-4 fw-semibold">
                            <i class="bi <%= isEdit ? "bi-check2-circle" : "bi-plus-circle" %> me-1"></i>
                            <%= isEdit ? "Save Changes" : "Create Product" %>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>
