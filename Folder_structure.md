## Modular Breakdown & Folder Structure

```
ecommerce-platform/
├── .vscode/               # Workspace settings and launch configurations for your editor
├── db/                    # Database-related files
│   └── database_schema.sql  
├── docs/                  # Project documentation
│   └── platform_requirements.pdf 
├── lib/                   # Manually downloaded external dependencies (.jar files)
│   ├── mysql-connector-j-8.x.x.jar
│   ├── jakarta.servlet-api-6.x.x.jar
│   └── jstl-1.2.jar
├── src/                   # All your Java source code
│   ├── com/ecommerce/util/
│   │   └── DatabaseConnection.java    // Modified to read from db.properties
│   ├── com/ecommerce/models/
│   │   ├── User.java 
│   │   ├── Product.java 
│   │   └── Order.java 
│   ├── com/ecommerce/dao/
│   │   ├── UserDao.java 
│   │   ├── ProductDao.java 
│   │   └── OrderDao.java 
│   ├── com/ecommerce/controllers/
│   │   ├── AdminServlet.java 
│   │   ├── SellerServlet.java 
│   │   └── BuyerServlet.java 
│   └── webapp/                        // Frontend templates (HTML, CSS, Bootstrap 5, JSP)
│       ├── assets/css/bootstrap.min.css
│       ├── admin-dashboard.jsp
│       ├── seller-dashboard.jsp
│       └── buyer-dashboard.jsp
├── .gitignore             # Prevents committing compiled .class files or local logs
├── README.md              # Setup instructions for your team and evaluators
├── REVIEW1_PLAN.md        # Academic review planning, milestones, and frontend/backend role assignments
├── db.properties          # Stores your database URL, username, and password securely outside the Java code
└── start-mysql.bat        # A quick batch script to start the local MySQL server before running the app
```
