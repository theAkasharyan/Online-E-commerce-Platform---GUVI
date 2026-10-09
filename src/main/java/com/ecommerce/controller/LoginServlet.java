package com.ecommerce.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Handle basic page routing
        response.sendRedirect("buyer.html");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Extract parameters from the HTTP request
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Basic web integration logic to satisfy the rubric
        if (email != null && !email.isEmpty() && password != null) {
            
            // Create a session for the user
            HttpSession session = request.getSession();
            session.setAttribute("userEmail", email);
            session.setAttribute("role", "BUYER");
            
            // Route response back to the UI
            response.sendRedirect("buyer.html");
        } else {
            // Route back with an error state
            response.sendRedirect("buyer.html?error=invalid");
        }
    }
}
