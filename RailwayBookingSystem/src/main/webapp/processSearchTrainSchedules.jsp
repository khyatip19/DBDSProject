<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page import="java.util.List, java.util.ArrayList, java.util.Map, java.util.HashMap, java.sql.*" %>
<%
    // Get search parameters from the request
    String stationId = request.getParameter("station_id");
    String type = request.getParameter("type"); // Either "origin" or "destination"
    
    // Validate input
    if (stationId == null || type == null) {
        out.println("<p class='error'>Invalid search parameters. Please try again.</p>");
        return;
    }

    List<Map<String, String>> schedules = new ArrayList<>();

    try {
        // Database connection
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        // Query based on origin or destination
        String query = "";
        if ("origin".equalsIgnoreCase(type)) {
            query = "SELECT ts.schedule_id, ts.line_name, ts.depart_datetime, ts.arrival_datetime, ts.travel_time, ts.fare " +
                    "FROM Train_Schedule ts " +
                    "JOIN Transit_Line tl ON ts.line_name = tl.line_name " +
                    "WHERE tl.origin = ?";
        } else if ("destination".equalsIgnoreCase(type)) {
            query = "SELECT ts.schedule_id, ts.line_name, ts.depart_datetime, ts.arrival_datetime, ts.travel_time, ts.fare " +
                    "FROM Train_Schedule ts " +
                    "JOIN Transit_Line tl ON ts.line_name = tl.line_name " +
                    "WHERE tl.destination = ?";
        }

        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, Integer.parseInt(stationId));
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, String> schedule = new HashMap<>();
            schedule.put("schedule_id", rs.getString("schedule_id"));
            schedule.put("line_name", rs.getString("line_name"));
            schedule.put("depart_datetime", rs.getString("depart_datetime"));
            schedule.put("arrival_datetime", rs.getString("arrival_datetime"));
            schedule.put("travel_time", rs.getString("travel_time"));
            schedule.put("fare", rs.getString("fare"));
            schedules.add(schedule);
        }

        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Search Results</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <div class="form-container">
        <h2>Train Schedules</h2>
        <p class="subtitle">Showing results for station as <%= type %></p>
        <div class="table-container">
            <% if (schedules.isEmpty()) { %>
                <p class="no-results">No train schedules found for the selected station.</p>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>Schedule ID</th>
                            <th>Line Name</th>
                            <th>Departure</th>
                            <th>Arrival</th>
                            <th>Travel Time</th>
                            <th>Fare</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, String> schedule : schedules) { %>
                            <tr>
                                <td><%= schedule.get("schedule_id") %></td>
                                <td><%= schedule.get("line_name") %></td>
                                <td><%= schedule.get("depart_datetime") %></td>
                                <td><%= schedule.get("arrival_datetime") %></td>
                                <td><%= schedule.get("travel_time") %> mins</td>
                                <td>$<%= schedule.get("fare") %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
        <div class="button-container">
            <a href="repDashboard.jsp" class="link-button">Back to Dashboard</a>
        </div>
    </div>
</body>
</html>
