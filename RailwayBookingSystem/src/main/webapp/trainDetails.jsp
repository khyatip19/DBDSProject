<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page import="com.cs527.pkg.ApplicationDB" %>
<%@ page import="java.math.BigDecimal" %> <!-- Add this import for BigDecimal -->

<%
    // Get schedule_id from the request
    String scheduleId = request.getParameter("schedule_id");
    String message = "";
    
    try {
        // Establish database connection
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        
        // Query to get the details for the train schedule
        String scheduleQuery = "SELECT ts.schedule_id, ts.depart_datetime, ts.arrival_datetime, " +
                               "tl.line_name, ts.fare, " +
                               "st1.name AS origin_station, st2.name AS destination_station " +
                               "FROM Train_Schedule ts " +
                               "JOIN Transit_Line tl ON ts.line_name = tl.line_name " +
                               "JOIN Station st1 ON tl.origin = st1.station_id " +
                               "JOIN Station st2 ON tl.destination = st2.station_id " +
                               "WHERE ts.schedule_id = ?";
        
        PreparedStatement pstSchedule = con.prepareStatement(scheduleQuery);
        pstSchedule.setString(1, scheduleId);
        ResultSet rsSchedule = pstSchedule.executeQuery();

        if (rsSchedule.next()) {
            // Retrieve train schedule details
            String lineName = rsSchedule.getString("line_name");
            Timestamp departure = rsSchedule.getTimestamp("depart_datetime");
            Timestamp arrival = rsSchedule.getTimestamp("arrival_datetime");
            BigDecimal baseFare = rsSchedule.getBigDecimal("fare");
            String origin = rsSchedule.getString("origin_station");
            String destination = rsSchedule.getString("destination_station");
            
            // Display schedule info
            out.println("<h2>Train Schedule Details</h2>");
            out.println("<p>Line Name: " + lineName + "</p>");
            out.println("<p>Departure: " + departure + "</p>");
            out.println("<p>Arrival: " + arrival + "</p>");
            out.println("<p>Base Fare: $" + baseFare + "</p>");
            out.println("<p>Origin: " + origin + "</p>");
            out.println("<p>Destination: " + destination + "</p>");
            
            // Query to get the stops for this train schedule
            String stopsQuery = "SELECT st.name, st.city, st.state, s.arrival_time, s.depart_time " +
                                "FROM Stop s " +
                                "JOIN Station st ON s.station_id = st.station_id " +
                                "WHERE s.schedule_id = ? " +
                                "ORDER BY s.arrival_time";
            
            PreparedStatement pstStops = con.prepareStatement(stopsQuery);
            pstStops.setString(1, scheduleId);
            ResultSet rsStops = pstStops.executeQuery();

            // Display stops information
            out.println("<h3>Stops</h3>");
            out.println("<table border='1'><tr><th>Station Name</th><th>City</th><th>State</th><th>Arrival Time</th><th>Departure Time</th></tr>");
            
            while (rsStops.next()) {
                String stationName = rsStops.getString("name");
                String city = rsStops.getString("city");
                String state = rsStops.getString("state");
                String arrivalTime = rsStops.getString("arrival_time");
                String departTime = rsStops.getString("depart_time");

                out.println("<tr>");
                out.println("<td>" + stationName + "</td>");
                out.println("<td>" + city + "</td>");
                out.println("<td>" + state + "</td>");
                out.println("<td>" + arrivalTime + "</td>");
                out.println("<td>" + departTime + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        } else {
            message = "Schedule not found.";
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

<style>
    .error-message {
        color: red;
        font-weight: bold;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 30px;
        background-color: white;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);    }

    th, td {
        padding: 12px 15px;
        text-align: left;
        border: 1px solid #ddd;
            }

    th {
        background-color: #007bff;
        color: white;
        text-align: center;
    }
    
    td {
        color: #555;
        text-align: center;
    }
</style>