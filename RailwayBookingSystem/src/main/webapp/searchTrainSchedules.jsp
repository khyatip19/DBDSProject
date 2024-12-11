<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.util.List, java.util.ArrayList, java.util.Map, java.util.HashMap, java.sql.*" %>
<%
    // Populate stations from the database
    List<Map<String, String>> stations = new ArrayList<>();
    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        String query = "SELECT station_id, name, city FROM Station";
        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, String> station = new HashMap<>();
            station.put("station_id", rs.getString("station_id"));
            station.put("name", rs.getString("name"));
            station.put("city", rs.getString("city"));
            stations.add(station);
        }

        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        out.println("<p class='error'>Error loading stations: " + e.getMessage() + "</p>");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Train Schedules</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <div class="form-container">
        <h2>Search Train Schedules</h2>
        <p class="subtitle">Search by selecting a station as origin or destination.</p>
        
        <form action="processSearchTrainSchedules.jsp" method="get">
            <!-- Station Dropdown -->
            <label for="station">Select Station:</label>
            <select id="station" name="station_id" required>
                <option value="" disabled selected>Select Station</option>
                <% for (Map<String, String> station : stations) { %>
                    <option value="<%= station.get("station_id") %>">
                        <%= station.get("name") + " (" + station.get("city") + ")" %>
                    </option>
                <% } %>
            </select><br><br>

            <label for="type">Search By:</label>
            <select id="type" name="type" required>
                <option value="origin">Origin</option>
                <option value="destination">Destination</option>
            </select><br><br>

            <!-- Submit Button -->
            <button type="submit" class="search-button">Search</button>
        </form>
    </div>
</body>
</html>
