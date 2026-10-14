<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ecommerce.model.User" %>
<%
    User sessionUser = (User) session.getAttribute("currentUser");
    Integer cartCount = (Integer) session.getAttribute("cartCount");
    if (cartCount == null) cartCount = 0;
    String flashMessage = (String) session.getAttribute("flashMessage");
    String flashType = (String) session.getAttribute("flashType");
    if (flashType == null) flashType = "info";
    // Clear flash after reading
    session.removeAttribute("flashMessage");
    session.removeAttribute("flashType");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") + " - " : "" %>ShopSphere | Modern E-Commerce</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root {
            --primary-accent: #2563eb;
            --primary-hover: #1d4ed8;
        }
        body {
            background-color: #f8fafc;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
        }
        main {
            flex: 1;
        }
        .navbar-brand {
            font-weight: 700;
            letter-spacing: -0.5px;
        }
        .product-card {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            border: 1px solid rgba(0,0,0,0.08);
        }
        .product-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px -10px rgba(0,0,0,0.15);
        }
        .product-img-wrapper {
            height: 220px;
            overflow: hidden;
            background-color: #f1f5f9;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .product-img-wrapper img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        .product-card:hover .product-img-wrapper img {
            transform: scale(1.05);
        }
    </style>
</head>
<body>

<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm py-2">
    <div class="container">
        <!-- Logo -->
        <a class="navbar-brand text-white d-flex align-items-center gap-2" href="<%= request.getContextPath() %>/products">
            <i class="bi bi-bag-heart-fill text-primary fs-4"></i>
            <span>ShopSphere</span>
        </a>

        <!-- Mobile Toggler -->
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarContent">
            <!-- Search Bar -->
            <form class="d-flex mx-auto my-2 my-lg-0 col-12 col-lg-5" action="<%= request.getContextPath() %>/products" method="get">
                <div class="input-group">
                    <input type="text" class="form-control" name="search" 
                           placeholder="Search gadgets, fashion, home..." 
                           value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                    <button class="btn btn-primary" type="submit">
                        <i class="bi bi-search"></i>
                    </button>
                </div>
            </form>

            <!-- Right Nav Links -->
            <ul class="navbar-nav ms-auto align-items-lg-center gap-2">
                <li class="nav-item">
                    <a class="nav-link text-white" href="<%= request.getContextPath() %>/products">
                        <i class="bi bi-grid me-1"></i> Catalog
                    </a>
                </li>

                <!-- Shopping Cart with Badge -->
                <li class="nav-item">
                    <a class="nav-link position-relative text-white btn btn-outline-secondary btn-sm px-3 text-start" 
                       href="<%= request.getContextPath() %>/cart">
                        <i class="bi bi-cart3 me-1"></i> Cart
                        <% if (cartCount > 0) { %>
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                <%= cartCount %>
                            </span>
                        <% } %>
                    </a>
                </li>

                <!-- User / Auth Menu -->
                <% if (sessionUser != null) { %>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle text-white d-flex align-items-center gap-1" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="bi bi-person-circle fs-5 text-info"></i>
                            <span><%= sessionUser.getName() %></span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow">
                            <li><h6 class="dropdown-header"><%= sessionUser.getEmail() %></h6></li>
                            <li><a class="dropdown-item" href="<%= request.getContextPath() %>/orders"><i class="bi bi-receipt me-2"></i>My Orders</a></li>
                            <% if (sessionUser.isAdmin()) { %>
                                <li><hr class="dropdown-divider"></li>
                                <li><h6 class="dropdown-header text-warning"><i class="bi bi-shield-lock me-1"></i>Admin Zone</h6></li>
                                <li><a class="dropdown-item text-primary fw-semibold" href="<%= request.getContextPath() %>/admin/products"><i class="bi bi-gear me-2"></i>Manage Products</a></li>
                            <% } %>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="<%= request.getContextPath() %>/logout"><i class="bi bi-box-arrow-right me-2"></i>Sign Out</a></li>
                        </ul>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link text-white-50" href="<%= request.getContextPath() %>/login">Sign In</a>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-outline-light btn-sm px-3" href="<%= request.getContextPath() %>/register">Register</a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<!-- Flash Notification Banner -->
<% if (flashMessage != null) { %>
    <div class="container mt-3">
        <div class="alert alert-<%= flashType %> alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-info-circle-fill me-2"></i>
            <%= flashMessage %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </div>
<% } %>

<main class="py-4">
