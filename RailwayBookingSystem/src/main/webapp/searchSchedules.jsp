<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page import="com.cs527.pkg.ApplicationDB" %>

<%
    // Get form parameters
    String origin = request.getParameter("origin");
    String destination = request.getParameter("destination");
    String travelDate = request.getParameter("travelDate");

    String message = ""; // Message to show if no schedules are found

    try {
        // Establish database connection
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        // Query to find matching train schedules
        String query = "SELECT ts.schedule_id, ts.depart_datetime, ts.arrival_datetime, " +
                       "st1.name AS origin_station, st2.name AS destination_station, " +
                       "ts.travel_time " +
                       "FROM Train_Schedule ts " +
                       "JOIN Transit_Line tl ON ts.line_name = tl.line_name " +
                       "JOIN Station st1 ON tl.origin = st1.station_id " +
                       "JOIN Station st2 ON tl.destination = st2.station_id " +
                       "WHERE st1.name = ? AND st2.name = ? AND DATE(ts.depart_datetime) = ?";

        PreparedStatement pst = con.prepareStatement(query);
        pst.setString(1, origin);
        pst.setString(2, destination);
        pst.setString(3, travelDate); // Use the date entered by the user

        ResultSet rs = pst.executeQuery();

        // Check if there are any results
        if (!rs.next()) {
            message = "No schedules found for this route.";
        } else {
            // Loop through and display results if found
            response.setContentType("text/html");
            out.println("<div class='form-container'>");
            out.println("<h2>Available Train Schedules</h2>");
            out.println("<table border='1'><tr><th>Train ID</th><th>Departure</th><th>Arrival</th><th>Travel Time</th><th>Origin</th><th>Destination</th><th>Action</th></tr>");

            do {
                int scheduleId = rs.getInt("schedule_id");
                out.println("<tr>");
                out.println("<td>" + scheduleId + "</td>");
                out.println("<td>" + rs.getTimestamp("depart_datetime") + "</td>");
                out.println("<td>" + rs.getTimestamp("arrival_datetime") + "</td>");
                out.println("<td>" + rs.getInt("travel_time") + " mins</td>");
                out.println("<td>" + rs.getString("origin_station") + "</td>");
                out.println("<td>" + rs.getString("destination_station") + "</td>");
                // Add View Details link
                out.println("<td><a href='trainDetails.jsp?schedule_id=" + scheduleId + "'>View Details</a></td>");
                out.println("</tr>");
            } while (rs.next());

            out.println("</table>");
            out.println("</div>");
        }

        // Close the database connection
        db.closeConnection(con);
    } catch (Exception e) {
        e.printStackTrace();
        message = "Error: " + e.getMessage();
    }
%>

<% if (!message.isEmpty()) { %>
    <div class="error-message"><%= message %></div>
<% } %>

<!-- Add some basic styling for the results and errors -->
<style>
    .form-container {
        margin-top: 20px;
        padding: 20px;
        border: 1px solid #ccc;
        border-radius: 5px;
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    th, td {
        padding: 10px;
        text-align: left;
        border-bottom: 1px solid #ddd;
    }

    th {
        background-color: #f4f4f4;
    }

    a {
        color: blue;
        text-decoration: none;
    }

    a:hover {
        text-decoration: underline;
    }

    .error-message {
        color: red;
        font-weight: bold;
    }
</style>
