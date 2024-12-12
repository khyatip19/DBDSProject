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
            <div class="button-container"><a href="welcome.jsp" class="link-button">Back to Dashboard</a></div>
        </form>
    </div>
        <script>
        // Set minimum date to today
        var today = new Date().toISOString().split('T')[0];
        document.getElementsByName("travelDate")[0].setAttribute('min', today);
        
        // Prevent selecting same station for origin and destination
        document.querySelector('form').addEventListener('submit', function(e) {
            var origin = document.getElementsByName('origin')[0].value;
            var destination = document.getElementsByName('destination')[0].value;
            
            if(origin === destination) {
                e.preventDefault();
                alert('Origin and destination stations cannot be the same.');
            }
        });
    </script>
</body>
</html>