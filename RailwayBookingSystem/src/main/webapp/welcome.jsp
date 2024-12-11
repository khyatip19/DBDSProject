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
        response.sendRedirect("adminDashboard.jsp");
        return;
    } else if ("Customer Representative".equals(role)) {
        response.sendRedirect("repDashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .form-container {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            padding: 30px 40px;
            max-width: 400px;
            text-align: center;
        }

        h2 {
            color: #333;
            margin-bottom: 10px;
            font-weight: bold;
        }

        .subtitle {
            font-size: 14px;
            color: #666;
            margin-bottom: 20px;
        }

        .link-button {
            display: block;
            margin: 10px 0;
            padding: 10px 15px;
            text-align: center;
            color: #fff;
            background-color: #555;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            font-size: 14px;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .link-button:hover {
            background-color: #333;
            transform: translateY(-2px);
        }

        .logout-button {
            background-color: #c0392b;
        }

        .logout-button:hover {
            background-color: #a93226;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Welcome, <%= username %>!</h2>
        <p class="subtitle">You are successfully logged in.</p>

        <a href="search.jsp" class="link-button">Search Train Schedules</a>
        <a href="viewReservations.jsp" class="link-button">View Reservations</a>
        <a href="sendQuestion.jsp" class="link-button">Send a Question</a>
        <a href="browserQuestion.jsp" class="link-button">Browse Questions</a>
        <a href="searchQuestions.jsp" class="link-button">Search Customer Questions</a>
        <a href="logout.jsp" class="link-button logout-button">Logout</a>
    </div>
</body>
</html>
