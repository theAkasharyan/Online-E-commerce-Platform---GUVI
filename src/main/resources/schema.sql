-- ============================================================
-- E-Commerce Database Schema
-- Database: ecommerce_db
-- Target: MySQL 8.0+
-- ============================================================

DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ecommerce_db;

-- ------------------------------------------------------------
-- 1. Users Table
-- ------------------------------------------------------------
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    role ENUM('CUSTOMER', 'ADMIN') NOT NULL DEFAULT 'CUSTOMER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 2. Categories Table
-- ------------------------------------------------------------
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    image_url VARCHAR(255)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 3. Products Table
-- ------------------------------------------------------------
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    category_id INT,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_product_category FOREIGN KEY (category_id) 
        REFERENCES categories(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 4. Orders Table
-- ------------------------------------------------------------
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    total_amount DECIMAL(10, 2) NOT NULL,
    shipping_address TEXT NOT NULL,
    phone VARCHAR(20) NOT NULL,
    payment_method VARCHAR(50) NOT NULL DEFAULT 'Cash on Delivery',
    order_status ENUM('PENDING', 'PROCESSING', 'SHIPPED', 'DELIVERED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_user FOREIGN KEY (user_id) 
        REFERENCES users(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 5. Order Items Table
-- ------------------------------------------------------------
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_orderitem_order FOREIGN KEY (order_id) 
        REFERENCES orders(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_orderitem_product FOREIGN KEY (product_id) 
        REFERENCES products(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- SEED DATA
-- ============================================================

INSERT INTO users (name, email, password, phone, address, role) VALUES
('Admin User', 'admin@ecommerce.com', 'admin123', '9876543210', 'Headquarters, Tech Park, City', 'ADMIN'),
('Jane Doe', 'jane@example.com', 'user123', '9123456780', '42 Baker Street, Apt 3B, Downtown', 'CUSTOMER');

INSERT INTO categories (name, description, image_url) VALUES
('Electronics', 'Smartphones, laptops, headphones, and modern gadgets', 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=500&auto=format&fit=crop&q=60'),
('Fashion', 'Trendy apparel, shoes, watches, and accessories', 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=500&auto=format&fit=crop&q=60'),
('Home & Kitchen', 'Home appliances, decor, cookware, and furniture', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=500&auto=format&fit=crop&q=60'),
('Books & Stationery', 'Bestsellers, notebooks, study supplies, and novels', 'https://images.unsplash.com/photo-1495446815901-a7297e633e8d?w=500&auto=format&fit=crop&q=60');

INSERT INTO products (name, description, price, stock, category_id, image_url) VALUES
('Apple MacBook Air M2', '13.6-inch Liquid Retina Display, 8GB RAM, 256GB SSD storage with all-day battery life.', 999.00, 15, 1, 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600&auto=format&fit=crop&q=80'),
('Sony WH-1000XM5 Wireless Headphones', 'Industry-leading noise canceling headphones with dual processors and 30hr battery.', 349.99, 25, 1, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&auto=format&fit=crop&q=80'),
('Mechanical Gaming Keyboard', 'RGB Backlit mechanical keyboard with tactile blue switches and detachable USB-C cable.', 79.50, 40, 1, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&auto=format&fit=crop&q=80'),
('Classic Leather Jacket', 'Premium genuine leather biker jacket with quilted lining and durable metal zippers.', 189.00, 18, 2, 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600&auto=format&fit=crop&q=80'),
('Casual Canvas Sneakers', 'Lightweight comfortable everyday walking sneakers with breathable fabric and rubber sole.', 49.99, 50, 2, 'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=600&auto=format&fit=crop&q=80'),
('Minimalist Chronograph Watch', 'Stainless steel case with minimalist dial, date window, and waterproof mesh strap.', 120.00, 30, 2, 'https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=600&auto=format&fit=crop&q=80'),
('Espresso Coffee Machine', '15-Bar pump espresso and cappuccino maker with milk frother wand and removable water tank.', 145.50, 12, 3, 'https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=600&auto=format&fit=crop&q=80'),
('Ceramic Cookware Set (10-Piece)', 'Non-stick ceramic pots and pans set with stay-cool handles and tempered glass lids.', 110.00, 20, 3, 'https://images.unsplash.com/photo-1584990347449-399551167448?w=600&auto=format&fit=crop&q=80'),
('Atomic Habits by James Clear', 'An easy and proven way to build good habits and break bad ones. Hardcover edition.', 19.99, 100, 4, 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=600&auto=format&fit=crop&q=80'),
('Premium Fountain Pen Set', 'Handcrafted luxury writing pen with refillable ink converter and gift box.', 35.00, 45, 4, 'https://images.unsplash.com/photo-1583485088034-697b5bc54ccd?w=600&auto=format&fit=crop&q=80');
