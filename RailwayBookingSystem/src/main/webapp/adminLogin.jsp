<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Login - Railway Booking System</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <div class="form-container">
        <h2>Admin Login</h2>
        <p class="subtitle">Please enter your admin credentials</p>
        
        <!-- Show error message if login fails -->
        <% 
            String error = request.getParameter("error");
            if (error != null && error.equals("invalid")) {
        %>
            <p class="error-message">Invalid username or password</p>
        <% } %>
        
        <!-- Admin Login Form -->
        <form action="checkAdminLogin.jsp" method="post">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="submit" value="Login">
        </form>
        
        <p class="error-message">${message}</p>
    </div>
</body>
</html>