<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.cs527.pkg.ApplicationDB" %>

<%
    int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
    String lineName = "";
    Timestamp departTime = null;
    Timestamp arriveTime = null;
    int travelTime = 0;
    double fare = 0.0;

    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        String query = "SELECT * FROM train_schedule WHERE schedule_id = ?";
        PreparedStatement pst = con.prepareStatement(query);
        pst.setInt(1, scheduleId);
        ResultSet rs = pst.executeQuery();
        if (rs.next()) {
            lineName = rs.getString("line_name");
            departTime = rs.getTimestamp("depart_datetime");
            arriveTime = rs.getTimestamp("arrival_datetime");
            travelTime = rs.getInt("travel_time");
            fare = rs.getDouble("fare");
        }
        db.closeConnection(con);
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Train Schedule</title>
</head>
<body>
    <h2>Edit Train Schedule</h2>
    <form action="processEditTrainSchedule.jsp" method="post">
        <input type="hidden" name="scheduleId" value="<%= scheduleId %>">
        <label>Line Name:</label><br>
        <input type="text" name="lineName" value="<%= lineName %>" required><br><br>
        <label>Departure Time:</label><br>
        <input type="datetime-local" name="departTime" value="<%= departTime.toString().substring(0, 16) %>" required><br><br>
        <label>Arrival Time:</label><br>
        <input type="datetime-local" name="arriveTime" value="<%= arriveTime.toString().substring(0, 16) %>" required><br><br>
        <label>Travel Time (mins):</label><br>
        <input type="number" name="travelTime" value="<%= travelTime %>" required><br><br>
        <label>Fare:</label><br>
        <input type="number" step="0.01" name="fare" value="<%= fare %>" required><br><br>
        <button type="submit">Save Changes</button>
    </form>
</body>
</html>
