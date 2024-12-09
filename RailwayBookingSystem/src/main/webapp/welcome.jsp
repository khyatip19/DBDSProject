<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null) {
        response.sendRedirect("login.jsp?message=Please log in first.");
        return;
    }

    // Redirect non-customer roles to their respective dashboards
    if ("Admin".equals(role)) {
        response.sendRedirect("admin_dashboard.jsp");
        return;
    } else if ("Customer Representative".equals(role)) {
        response.sendRedirect("rep_dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <div class="form-container">
        <h2>Welcome, <%= username %>!</h2>
        <p class="subtitle">You are successfully logged in.</p>
        <p><a href="search.jsp" class="link-button">Search Train Schedules</a></p>
        <p><a href="viewReservations.jsp" class="link-button">View Reservations</a></p>
        <p><a href="logout.jsp" class="link-button">Logout</a></p>
    </div>
</body>
</html>

<%-- <%@ page import="jakarta.servlet.http.*" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null) {
        response.sendRedirect("login.jsp?message=Please log in first.");
        return;
    }

    // Redirect non-customer roles to their respective dashboards
    if ("Admin".equals(role)) {
        response.sendRedirect("admin_dashboard.jsp");
        return;
    } else if ("Customer Representative".equals(role)) {
        response.sendRedirect("rep_dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <div class="form-container">
        <h2>Welcome, <%= username %>!</h2>
        <p class="subtitle">You are successfully logged in.</p>
        <p><a href="search.jsp" class="link-button">Search Train Schedules</a></p>
        <p><a href="logout.jsp" class="link-button">Logout</a></p>
    </div>
</body>
</html> --%>