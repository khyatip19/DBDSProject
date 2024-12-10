<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page import="com.cs527.pkg.ApplicationDB" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Search Train Schedules</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <div class="form-container">
        <h2>Search for Train Schedules</h2>
        <p class="subtitle">Enter the details below to search for available train schedules.</p>

        <!-- Search Form -->
        <form method="post" action="searchSchedules.jsp">
            <input type="text" name="origin" placeholder="Origin Station" required>
            <input type="text" name="destination" placeholder="Destination Station" required>
            <input type="date" name="travelDate" required>
            <input type="submit" value="Search">
        </form>
    </div>
</body>
</html>