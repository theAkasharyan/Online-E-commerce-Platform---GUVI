# 🛒 Java E-Commerce Platform
> A modular, multi-role e-commerce web platform featuring dedicated dashboards for Admins, Sellers, and Buyers.

[![GUVI](https://img.shields.io/badge/GUVI-00B569?style=for-the-badge&logo=codeforces&logoColor=white)](https://www.guvi.in/)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Java](https://img.shields.io/badge/Java-11%2B-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![Bootstrap](https://img.shields.io/badge/Bootstrap-v5-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white)
---

## 📋 Table of Contents
- [✨ Features](#-features)
- [🛠️ Tech Stack](#️-tech-stack)
- [🏗️ System Architecture](#️-system-architecture)
- [🚀 Getting Started](#-getting-started)
- [💡 Usage](#-usage)
- [👥 Contributors](#-contributors)

---

## ✨ Features

* **Multi-Role Dashboards**: Role-specific, segregated views for Buyers, Sellers, and System Administrators.
* **Responsive Storefront**: Dynamic product catalog with real-time category filtering, search, and responsive Bootstrap grid cards.
* **Cart & Wishlist Engine**: Client-side state tracking for cart additions, item quantities, and saved wishlist products.
* **Vendor Inventory Management**: Real-time stock shortage indicators, inventory quantity updates, and sales performance indicators.
* **Order Processing Lifecycle**: Structured order submission, transactional tracking, and purchase history logging.
* **Granular Administration**: Admin controls for user management, account permission auditing, and product catalog moderation.

---

# 🛠️ Tech Stack

| Technology | Layer | Purpose |
| :--- | :--- | :--- |
| **HTML5 & CSS3** | Frontend | Document structure and core styling |
| **Bootstrap 5** | Frontend | Modern layout grids, cards, modals, and responsive UI |
| **JavaScript** | Frontend | Dynamic DOM manipulation and client-side interactions |
| **Java (Servlets & JSP)** | Backend | Application logic, session handling, and routing |
| **JDBC** | Middleware | Database connectivity and query execution |
| **MySQL 8.0** | Database | Relational persistent data storage |
| **Apache Tomcat** | Server | Local web server environment |

---

## 🏗️ System Architecture
The project follows a standard 3-tier architecture:

* **Client Tier (Frontend):** HTML5, CSS3, Bootstrap 5, and JavaScript. Handles UI layout, responsive grids, and DOM manipulation.
* **Application Tier (Backend):** Java Servlets and JSP running on an Apache Tomcat Server. Manages business logic, session handling, and API routing.
* **Data Tier (Database):** MySQL. Stores persistent data for users, product inventory, and order history via JDBC connections.

```text
[Web Browser / UI]  <--HTTP/Fetch-->  [Tomcat Server (Java/Servlets)]  <--JDBC-->  [MySQL Database]
(HTML/Bootstrap/JS)                   (Business Logic & Controllers)               (Data Storage)
```
## 🚀 Getting Started

### Prerequisites
Before running the application locally, ensure you have the following installed:
* [Java Development Kit (JDK 11+)](https://www.oracle.com/java/technologies/downloads/)
* [MySQL Community Server 8.0+](https://dev.mysql.com/downloads/mysql/)
* [Apache Tomcat 9.0+ / 10.0+](https://tomcat.apache.org/)
* [Visual Studio Code](https://code.visualstudio.com/) (with the Live Server extension)
* [IntelliJ IDEA](https://www.jetbrains.com/idea/) (for backend configuration)

### Local Setup & Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/theAkasharyan/Online-E-commerce-Platform---GUVI.git
   cd Online-E-commerce-Platform---GUVI
   ```
2. **Initialize the Database:**
   Open MySQL Workbench or your terminal and execute:
   ```bash
   CREATE DATABASE ecommerce_db;
   USE ecommerce_db;
   CREATE TABLE users (
   id INT AUTO_INCREMENT PRIMARY KEY,
   name VARCHAR(100) NOT NULL,
   email VARCHAR(100) UNIQUE NOT NULL,
   password VARCHAR(255) NOT NULL,
   role ENUM('BUYER', 'SELLER', 'ADMIN') NOT NULL,
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
   ```
3. **Run the Frontend (Development):** using Live Server extension.
4. **Run the Backend(Server):***
   * Open the repository in IntelliJ IDEA.
   * Configure the local Apache Tomcat server to deploy the project artifact.
   * Update database credentials in your JDBC connection properties.
   * Start Tomcat and access the backend services at http://localhost:8080.

## 💡 Usage

* **Buyer Module**: Browse active listings, search through items, inspect cart contents, and manage account details.
* **Seller Module**: Review product inventory numbers, monitor out-of-stock notices, and inspect sales trends.
* **Admin Module**: Audit registered accounts, modify role permissions, and oversee product listings.

## 👥 Contributors:

<a href="https://github.com/theAkasharyan/Online-E-commerce-Platform---GUVI/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=theAkasharyan/Online-E-commerce-Platform---GUVI" alt="Contributors" />
</a>
