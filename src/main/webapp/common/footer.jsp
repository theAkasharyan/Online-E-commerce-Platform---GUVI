</main>

<!-- Footer -->
<footer class="bg-dark text-light py-5 mt-auto border-top border-secondary">
    <div class="container">
        <div class="row g-4">
            <div class="col-lg-4 col-md-6">
                <h5 class="fw-bold text-white d-flex align-items-center gap-2">
                    <i class="bi bi-bag-heart-fill text-primary"></i> ShopSphere
                </h5>
                <p class="text-secondary small mt-2">
                    Modern Java E-Commerce application powered by Servlets, JDBC, MySQL, and Bootstrap 5.
                    Engineered with clean architectural patterns and responsive web design.
                </p>
                <div class="d-flex gap-3 text-secondary fs-5">
                    <a href="#" class="text-secondary"><i class="bi bi-github"></i></a>
                    <a href="#" class="text-secondary"><i class="bi bi-twitter-x"></i></a>
                    <a href="#" class="text-secondary"><i class="bi bi-linkedin"></i></a>
                </div>
            </div>

            <div class="col-lg-2 col-md-6">
                <h6 class="text-uppercase fw-semibold text-white mb-3">Quick Links</h6>
                <ul class="list-unstyled small d-flex flex-column gap-2">
                    <li><a href="<%= request.getContextPath() %>/products" class="text-secondary text-decoration-none hover-white">Product Catalog</a></li>
                    <li><a href="<%= request.getContextPath() %>/cart" class="text-secondary text-decoration-none hover-white">Shopping Cart</a></li>
                    <li><a href="<%= request.getContextPath() %>/orders" class="text-secondary text-decoration-none hover-white">My Orders</a></li>
                </ul>
            </div>

            <div class="col-lg-3 col-md-6">
                <h6 class="text-uppercase fw-semibold text-white mb-3">Tech Stack</h6>
                <ul class="list-unstyled small text-secondary d-flex flex-column gap-2">
                    <li><i class="bi bi-check2 text-primary me-1"></i> Java Servlets (Jakarta EE)</li>
                    <li><i class="bi bi-check2 text-primary me-1"></i> JDBC & MySQL 8.0+</li>
                    <li><i class="bi bi-check2 text-primary me-1"></i> Bootstrap 5 & Bootstrap Icons</li>
                    <li><i class="bi bi-check2 text-primary me-1"></i> DAO & MVC Architecture</li>
                </ul>
            </div>

            <div class="col-lg-3 col-md-6">
                <h6 class="text-uppercase fw-semibold text-white mb-3">Customer Support</h6>
                <p class="small text-secondary mb-1"><i class="bi bi-geo-alt me-2"></i>Tech Campus, Class Project</p>
                <p class="small text-secondary mb-1"><i class="bi bi-envelope me-2"></i>support@ecommerce.com</p>
                <p class="small text-secondary"><i class="bi bi-telephone me-2"></i>+1 (800) 555-0199</p>
            </div>
        </div>

        <hr class="border-secondary my-4">

        <div class="d-flex flex-column flex-sm-row justify-content-between align-items-center small text-secondary">
            <span>&copy; <%= java.time.Year.now().getValue() %> ShopSphere. All rights reserved.</span>
            <span>Built with Servlets, JDBC, and Bootstrap 5.</span>
        </div>
    </div>
</footer>

<!-- Bootstrap 5 Bundle JS (Includes Popper) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
