<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="jakarta.servlet.http.*, jakarta.servlet.*" %>
<%
    String role = (String) session.getAttribute("role");
    if (!"rep".equals(role)) {
        response.sendRedirect("login.jsp?message=Unauthorized access.");
        return;
    }

    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Representative Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .container {
            background: #ffffff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 90%;
            max-width: 600px;
            margin-top: 50px;
            text-align: center;
        }

        h1 {
            color: #333333;
            font-size: 28px;
            margin-bottom: 10px;
        }

        p {
            color: #666666;
            font-size: 16px;
            margin-bottom: 30px;
        }

        .dashboard-link {
            display: inline-block;
            margin: 10px;
            padding: 12px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            text-align: center;
            transition: background-color 0.3s ease, transform 0.2s ease;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .dashboard-link:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
        }

        .logout {
            background-color: #dc3545;
        }

        .logout:hover {
            background-color: #a71d2a;
        }

        .link-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }

        @media (max-width: 600px) {
            .dashboard-link {
                width: 100%;
                margin: 10px 0;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome, <%= username %>!</h1>
        <p>Use the options below to manage tasks.</p>
        
        <div class="link-container">
            <a href="manageTrainSchedules.jsp" class="dashboard-link">Manage Train Schedules</a>
            <a href="answerQuestion.jsp" class="dashboard-link">Answer Customer Questions</a>
            <a href="searchTrainSchedules.jsp" class="dashboard-link">Search Train Schedules</a>
            <a href="searchReservations.jsp" class="dashboard-link">Search Customer Reservations</a>
            <a href="logout.jsp" class="dashboard-link logout">Logout</a>
        </div>
    </div>
</body>
</html>
