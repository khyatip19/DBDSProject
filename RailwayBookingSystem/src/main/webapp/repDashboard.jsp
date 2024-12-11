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
<html>
<head>
    <title>Customer Representative Dashboard</title>
    <style>
        .dashboard-link {
            display: block;
            margin: 10px 0;
            padding: 10px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            text-align: center;
            width: 200px;
        }
        .dashboard-link:hover {
            background-color: #0056b3;
        }
    </style>
</head>

<body>
    <h1>Welcome, <%= username %>!</h1>
    <p>This is your Customer Representative dashboard.</p>
    
    <a href="manageTrainSchedules.jsp" class="dashboard-link">Manage Train Schedules</a>
        

    <a href="answerQuestion.jsp" class="dashboard-link">Answer Customer Questions</a>
        <a href="searchTrainSchedules.jsp" class="dashboard-link">Search Train Schedules</a>
    <a href="searchReservations.jsp" class="dashboard-link">Search Customer Reservations</a>

    
<!--     <br></br>
    <a href="editDeleteTrainSchedule.jsp" class="dashboard-link">Ishaan Train Schedules</a>

    <a href="searchQuestions.jsp" class="dashboard-link">Ishaan Search Questions</a>
     -->
    <a href="logout.jsp" class="dashboard-link">Logout</a>
</body>
</html>
