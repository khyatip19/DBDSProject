<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.cs527.pkg.ApplicationDB" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Train Schedules</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="form-container">
        <h2>Manage Train Schedules</h2>
        <p class="subtitle">View, edit, or delete train schedules below.</p>
        


        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Schedule ID</th>
                        <th>Line Name</th>
                        <th>Departure</th>
                        <th>Arrival</th>
                        <th>Travel Time</th>
                        <th>Fare</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>

            <%
                try {
                    ApplicationDB db = new ApplicationDB();
                    Connection con = db.getConnection();
                    String query = "SELECT * FROM train_schedule";
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery(query);
                    while (rs.next()) {
                        int scheduleId = rs.getInt("schedule_id");
                        String lineName = rs.getString("line_name");
                        Timestamp departTime = rs.getTimestamp("depart_datetime");
                        Timestamp arriveTime = rs.getTimestamp("arrival_datetime");
                        int travelTime = rs.getInt("travel_time");
                        double fare = rs.getDouble("fare");
            %>

            <tr>
                <td><%= scheduleId %></td>
                <td><%= lineName %></td>
                <td><%= departTime %></td>
                <td><%= arriveTime %></td>
                <td><%= travelTime %> mins</td>
                <td>$<%= fare %></td>
                <td>
                    <a href="editTrainSchedule.jsp?scheduleId=<%= scheduleId %>" class="action-button">Edit</a>
                    <a href="deleteTrainSchedule.jsp?scheduleId=<%= scheduleId %>" class="action-button">Delete</a>
                </td>
            </tr>
            <%
                    }
                    db.closeConnection(con);
                } catch (Exception e) {
                    out.println("Error: " + e.getMessage());
                }
            %>
        </tbody>
    </table>
    </div>
         
        <div class="button-container">
            <a href="repDashboard.jsp" class="link-button">Back to Dashboard</a>
        </div>
    </div>
</body>
</html>
