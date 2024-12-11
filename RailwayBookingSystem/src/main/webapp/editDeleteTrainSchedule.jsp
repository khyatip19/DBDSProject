<%@ page language="java" import="java.sql.*, com.cs527.pkg.*" %>
<%
    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String action = request.getParameter("action");
        int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();

            if ("edit".equals(action)) {
                String newLineName = request.getParameter("lineName");
                String newDeparture = request.getParameter("departure");
                String newArrival = request.getParameter("arrival");
                int newTravelTime = Integer.parseInt(request.getParameter("travelTime"));
                double newFare = Double.parseDouble(request.getParameter("fare"));

                String query = "UPDATE Train_Schedule SET line_name=?, depart_datetime=?, arrival_datetime=?, travel_time=?, fare=? WHERE schedule_id=?";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setString(1, newLineName);
                pst.setString(2, newDeparture);
                pst.setString(3, newArrival);
                pst.setInt(4, newTravelTime);
                pst.setDouble(5, newFare);
                pst.setInt(6, scheduleId);
                pst.executeUpdate();
                message = "Schedule updated successfully!";
            } else if ("delete".equals(action)) {
                String query = "DELETE FROM Train_Schedule WHERE schedule_id=?";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setInt(1, scheduleId);
                pst.executeUpdate();
                message = "Schedule deleted successfully!";
            }

            db.closeConnection(con);
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
%>
<html>
<head>
    <title>Edit/Delete Train Schedule</title>
</head>
<body>
    <h1>Edit or Delete Train Schedule</h1>
    <p><%= message %></p>
    <form method="post">
        <label>Schedule ID:</label>
        <input type="number" name="scheduleId" required><br>
        <label>Action:</label>
        <select name="action" required>
            <option value="edit">Edit</option>
            <option value="delete">Delete</option>
        </select><br>

        <div id="editFields">
            <label>Line Name:</label>
            <input type="text" name="lineName"><br>
            <label>Departure Datetime:</label>
            <input type="text" name="departure"><br>
            <label>Arrival Datetime:</label>
            <input type="text" name="arrival"><br>
            <label>Travel Time:</label>
            <input type="number" name="travelTime"><br>
            <label>Fare:</label>
            <input type="number" step="0.01" name="fare"><br>
        </div>
        <input type="submit" value="Submit">
    </form>
</body>
</html>
