<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Forward directly to ProductServlet catalog
    response.sendRedirect(request.getContextPath() + "/products");
%>
