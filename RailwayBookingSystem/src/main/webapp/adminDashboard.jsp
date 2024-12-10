<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>

<%
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Railway Booking System</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <style>
        .admin-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            padding: 20px;
        }
        
        .admin-card {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="form-container" style="max-width: 800px;">
        <h2>Admin Dashboard</h2>
        <p class="subtitle">Welcome, <%= session.getAttribute("adminUser") %></p>

        <div class="admin-grid">
            <!-- Customer Representatives Management -->
            <div class="admin-card">
                <h3>Customer Representatives</h3>
                <a href="manageCustomerReps.jsp" class="link-button">Manage Representatives</a>
                <a href="addRep.jsp" class="link-button">Add New Representative</a>
            </div>

            <!-- Reports Section -->
            <div class="admin-card">
                <h3>Reports & Analytics</h3>
                <a href="salesReport.jsp" class="link-button">Sales Reports</a>
                <a href="reservationsList.jsp" class="link-button">Reservations List</a>
                <a href="revenueReport.jsp" class="link-button">Revenue Analysis</a>
            </div>

            <!-- Customer Analysis -->
            <div class="admin-card">
                <h3>Customer Analysis</h3>
                <a href="bestCustomers.jsp" class="link-button">Best Customers</a>
                <a href="activeTransitLines.jsp" class="link-button">Most Active Lines</a>
            </div>
        </div>

        <div style="margin-top: 20px; text-align: center;">
            <a href="logout.jsp" class="link-button">Logout</a>
        </div>
    </div>
</body>
</html>