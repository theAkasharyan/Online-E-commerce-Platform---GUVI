# 🛒 ShopSphere - Java E-Commerce Web Application

A full-featured, responsive E-Commerce web application built using **Java Servlets**, **JDBC**, **MySQL**, and **Bootstrap 5**. The application follows the standard **MVC (Model-View-Controller)** and **DAO (Data Access Object)** architectural patterns.

---

## 📁 Project Structure

```text
ecommerce-app/
├── schema.sql                                # MySQL schema & sample seed data
├── db.properties                             # Database connection credentials
├── pom.xml                                   # Maven dependency & build configuration
├── lib/                                      # Downloaded JDBC & Servlet runtime JARs
│   ├── mysql-connector-j-8.3.0.jar
│   └── jakarta.servlet-api-6.0.0.jar
├── util/
│   └── DBConnectionUtil.java                 # Standalone Connection Utility reading db.properties
├── dao/
│   └── ProductDAO.java                       # Standalone Product DAO with CRUD queries
├── model/
│   └── Product.java                          # Standalone Product Entity
└── src/
    └── main/
        ├── java/com/ecommerce/
        │   ├── model/                        # Domain Models
        │   │   ├── Product.java
        │   │   ├── Category.java
        │   │   ├── User.java
        │   │   ├── CartItem.java
        │   │   ├── Order.java
        │   │   └── OrderItem.java
        │   ├── dao/                          # Data Access Objects (JDBC)
        │   │   ├── ProductDAO.java           # Complete CRUD for products matching schema.sql
        │   │   ├── CategoryDAO.java          # Category queries
        │   │   ├── UserDAO.java              # User registration & authentication
        │   │   └── OrderDAO.java             # Transactional orders & inventory deduction
        │   ├── util/
        │   │   └── DBConnectionUtil.java     # Connection helper reading db.properties
        │   └── controller/                   # Jakarta Servlets
        │       ├── ProductServlet.java       # Catalog, Category filtering & Search
        │       ├── AdminProductServlet.java  # Admin Product CRUD (Add/Edit/Delete)
        │       ├── CartServlet.java          # Session Shopping Cart management
        │       ├── CheckoutServlet.java      # Order placement & shipping
        │       ├── OrderServlet.java         # Confirmation & Order History
        │       └── AuthServlet.java          # Login, Register & Logout
        ├── resources/
        │   ├── db.properties                 # Classpath DB configuration
        │   └── schema.sql                    # Classpath DB schema
        └── webapp/                           # Presentation Layer (JSP + Bootstrap 5)
            ├── WEB-INF/
            │   ├── web.xml                   # Deployment descriptor
            │   ├── classes/                  # Precompiled classes & configuration
            │   └── lib/                      # Jars bundled for deployment
            ├── common/
            │   ├── navbar.jsp                # Responsive Navbar, search bar & cart badge
            │   └── footer.jsp                # Footer with tech stack info & JS bundle
            ├── index.jsp                     # Root entry point redirecting to /products
            ├── products.jsp                  # Product catalog grid with filters
            ├── product-detail.jsp            # Single product detail view & quantity selector
            ├── cart.jsp                      # Shopping cart table & order summary
            ├── checkout.jsp                  # Shipping address form & payment selection
            ├── order-success.jsp             # Order confirmation receipt
            ├── orders.jsp                    # User order history
            ├── order-detail.jsp              # Single order item breakdown
            ├── login.jsp                     # Authentication form with demo helpers
            ├── register.jsp                  # User registration form
            └── admin/
                ├── products.jsp              # Admin product list with Edit/Delete
                └── product-form.jsp          # Add/Edit product form
```

---

## 🗄️ Database Setup (`schema.sql`)

### 1. Execute SQL Script in MySQL
Open your terminal / command prompt or MySQL Workbench and run:

```bash
# If running from MySQL CLI:
mysql -u root -p < "d:/C++ language practice/GU/class/ecommerce-app/schema.sql"
```

Or log in to MySQL:
```sql
SOURCE d:/C++ language practice/GU/class/ecommerce-app/schema.sql;
```

This creates the database `ecommerce_db` and initializes 5 relational tables:
1. `users` (id, name, email, password, phone, address, role, created_at)
2. `categories` (id, name, description, image_url)
3. `products` (id, name, description, price, stock, category_id, image_url, created_at, updated_at)
4. `orders` (id, user_id, total_amount, shipping_address, phone, payment_method, order_status, created_at)
5. `order_items` (id, order_id, product_id, quantity, unit_price)

Pre-loaded with 4 categories, 10 products, and 2 accounts.

---

## ⚙️ Configuration (`db.properties`)

Update `db.properties` (in the project root and `src/main/resources/db.properties`) with your MySQL credentials:

```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/ecommerce_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8
db.username=root
db.password=YOUR_MYSQL_PASSWORD
```

---

## 🧪 Testing DB Connection (`DBConnectionUtil`)

Both `util/DBConnectionUtil.java` and `com.ecommerce.util.DBConnectionUtil` contain a runnable `main` method that tests the connection to MySQL:

```bash
# Test connection from terminal:
java -cp "lib/*;target/classes" com.ecommerce.util.DBConnectionUtil
```

Expected output:
```text
INFO: Loaded db.properties from file: .../db.properties
INFO: JDBC Driver registered: com.mysql.cj.jdbc.Driver
Testing DBConnectionUtil connectivity...
[SUCCESS] Database connected successfully to: ecommerce_db
Database Product Name: MySQL
Database Product Version: 8.0.x
```

---

## 🚀 How to Run the Web Application

### Option 1: Run with Apache Tomcat 10+
1. Download **Apache Tomcat 10.1+** (standard for Jakarta EE / Servlets 5/6).
2. Copy the `src/main/webapp` directory (or compiled WAR) to Tomcat's `webapps/` folder as `ecommerce-app`.
3. Start Tomcat:
   ```bash
   bin/startup.bat   # Windows
   bin/startup.sh    # macOS / Linux
   ```
4. Access the web app in your browser:
   `http://localhost:8080/ecommerce-app/`

### Option 2: Run in IntelliJ IDEA / Eclipse
1. **IntelliJ IDEA**:
   - File -> Open -> Select `ecommerce-app`.
   - Add Configuration -> **Tomcat Server (Local)**.
   - In the **Deployment** tab: Add Artifact -> `ecommerce-app:war exploded` (Application context: `/ecommerce-app`).
   - Click **Run** or **Debug**.
2. **Eclipse IDE for Enterprise Java**:
   - File -> Import -> Existing Maven Projects -> Select `ecommerce-app`.
   - Right click project -> Run As -> **Run on Server** -> Select Tomcat 10.

---

## 🔑 Default Accounts (Seeded Data)

| Role | Email | Password | Access |
|---|---|---|---|
| **Admin** | `admin@ecommerce.com` | `admin123` | Full Storefront + Inventory Management (`/admin/products`) |
| **Customer** | `jane@example.com` | `user123` | Storefront, Shopping Cart, Checkout, Order History |

*(You can also register a new account on the `/register` page).*

---

## 🌟 Key Application Features

1. **Storefront & Catalog (`ProductServlet` + `products.jsp`)**:
   - Modern Bootstrap 5 product grid with dynamic badges for stock status and categories.
   - Real-time search query filtering and category tab filtering.
   - Single item view with breadcrumbs and detailed specifications (`product-detail.jsp`).

2. **Full CRUD Inventory Management (`ProductDAO` + `AdminProductServlet`)**:
   - **Create**: Add new product with category selector, price, stock, description, and image URL.
   - **Read**: View inventory table with stock alerts.
   - **Update**: Edit product attributes in pre-populated form.
   - **Delete**: Safe deletion of products with foreign key consistency.

3. **Shopping Cart (`CartServlet` + `cart.jsp`)**:
   - Stored in HTTP Session (`session.getAttribute("cart")`).
   - Add to cart, adjust quantities, remove item, or clear cart.
   - Real-time cart badge counter displayed in navbar.

4. **Transactional Checkout (`OrderDAO` + `CheckoutServlet`)**:
   - Executes inside a MySQL transaction (`conn.setAutoCommit(false)`).
   - Atomically records the order, inserts line items, and deducts product stock.
   - Generates an Order Confirmation Receipt with reference ID (`order-success.jsp`).
   - Customer past order history tracking (`orders.jsp`).
