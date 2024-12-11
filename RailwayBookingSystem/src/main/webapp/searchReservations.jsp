<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page import="java.util.List, java.util.ArrayList, java.util.Map, java.util.HashMap, java.sql.*" %>
<%
    // Populate transit lines from the database
    List<Map<String, String>> transitLines = new ArrayList<>();
    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        String query = "SELECT line_name FROM Transit_Line";
        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, String> line = new HashMap<>();
            line.put("line_name", rs.getString("line_name"));
            transitLines.add(line);
        }

        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        out.println("<p class='error'>Error loading transit lines: " + e.getMessage() + "</p>");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Reservations</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <div class="form-container">
        <h2>Search Reservations</h2>
        <p class="subtitle">Search for customers with reservations on a specific transit line and date.</p>
        
        <form action="processSearchReservations.jsp" method="get">
            <!-- Transit Line Dropdown -->
            <label for="line">Select Transit Line:</label>
            <select id="line" name="line_name" required>
                <option value="" disabled selected>Select Line</option>
                <% for (Map<String, String> line : transitLines) { %>
                    <option value="<%= line.get("line_name") %>">
                        <%= line.get("line_name") %>
                    </option>
                <% } %>
            </select><br><br>

            <!-- Date Field -->
            <label for="date">Select Date:</label>
            <input type="date" id="date" name="date" required><br><br>

            <!-- Submit Button -->
            <button type="submit" class="search-button">Search</button>
        </form>
    </div>
</body>
</html>
