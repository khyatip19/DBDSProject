<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*, java.text.*" %>
<%@ page import="com.cs527.pkg.ApplicationDB" %>

<%
    // Get form parameters
    String origin = request.getParameter("origin");
    String destination = request.getParameter("destination");
    String travelDate = request.getParameter("travelDate");
    String sortOrder = request.getParameter("sortOrder"); // Sorting option
    


    if (sortOrder == null) {
        sortOrder = "departure_ASC"; // Default sorting order
    }

    String[] sortOptions = sortOrder.split("_"); // Split into column and direction
    String sortColumn = sortOptions[0];
    String sortDirection = sortOptions[1];

    String message = ""; // Message to display if no results are found

    try {
        // Establish database connection
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        // Map sortColumn to actual SQL column names
        String sortColumnSQL;
        switch (sortColumn) {
            case "arrival":
                sortColumnSQL = "ts.arrival_datetime";
                break;
            case "duration":
                sortColumnSQL = "ts.travel_time";
                break;
            case "fare":
                sortColumnSQL = "ts.fare";
                break;
            default: // Default to departure
                sortColumnSQL = "ts.depart_datetime";
        }

        // Query to find matching train schedules with fare and duration
/*  		String query = "SELECT ts.schedule_id, ts.depart_datetime, ts.arrival_datetime, " +
                       "ts.travel_time, ts.fare, " +
                       "st1.name AS origin_station, st2.name AS destination_station " +
                       "FROM Train_Schedule ts " +
                       "JOIN Transit_Line tl ON ts.line_name = tl.line_name " +
                       "JOIN Station st1 ON tl.origin = st1.station_id " +
                       "JOIN Station st2 ON tl.destination = st2.station_id " +
                       "WHERE st1.name = ? AND st2.name = ? AND DATE(ts.depart_datetime) = ? " +
                       "ORDER BY " + sortColumnSQL + " " + sortDirection; */
 
 
                       String query = "SELECT ts.schedule_id, ts.depart_datetime, ts.arrival_datetime, " +
                               "ts.travel_time, ts.fare, st1.station_id AS st1id, st2.station_id AS st2id, " +
                               "st1.name AS origin_station, " +
                               "COALESCE(intermediate_station.name, st2.name) AS destination_station " +
                               "FROM Train_Schedule ts " +
                               "JOIN Transit_Line tl ON ts.line_name = tl.line_name " +
                               "JOIN Station st1 ON tl.origin = st1.station_id " +
                               "JOIN Station st2 ON tl.destination = st2.station_id " +
                               "JOIN Stop s ON ts.schedule_id = s.schedule_id " + 
                               "JOIN Station intermediate_station ON s.station_id = intermediate_station.station_id " +
                               "WHERE st1.name = ? " + 
                               "AND intermediate_station.name = ? " + 
                               "AND DATE(ts.depart_datetime) = ? " +
                               "ORDER BY " + sortColumnSQL + " " + sortDirection;
	
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

            // Sorting options form
            out.println("<form method='get' action='searchSchedules.jsp'>");
            out.println("<input type='hidden' name='origin' value='" + origin + "'/>");
            out.println("<input type='hidden' name='destination' value='" + destination + "'/>");
            out.println("<input type='hidden' name='travelDate' value='" + travelDate + "'/>");
            out.println("<label for='sortOrder'>Sort by:</label>");
            out.println("<select name='sortOrder' id='sortOrder' onchange='this.form.submit()'>");
            out.println("<option value='departure_ASC'" + ("departure_ASC".equals(sortOrder) ? " selected" : "") + ">Departure Time (Ascending)</option>");
            out.println("<option value='departure_DESC'" + ("departure_DESC".equals(sortOrder) ? " selected" : "") + ">Departure Time (Descending)</option>");
            out.println("<option value='arrival_ASC'" + ("arrival_ASC".equals(sortOrder) ? " selected" : "") + ">Arrival Time (Ascending)</option>");
            out.println("<option value='arrival_DESC'" + ("arrival_DESC".equals(sortOrder) ? " selected" : "") + ">Arrival Time (Descending)</option>");
            out.println("<option value='duration_ASC'" + ("duration_ASC".equals(sortOrder) ? " selected" : "") + ">Duration (Shortest First)</option>");
            out.println("<option value='duration_DESC'" + ("duration_DESC".equals(sortOrder) ? " selected" : "") + ">Duration (Longest First)</option>");
            out.println("<option value='fare_ASC'" + ("fare_ASC".equals(sortOrder) ? " selected" : "") + ">Fare (Lowest First)</option>");
            out.println("<option value='fare_DESC'" + ("fare_DESC".equals(sortOrder) ? " selected" : "") + ">Fare (Highest First)</option>");
            out.println("</select>");
            out.println("</form>");

            // Display schedules table with fare and duration
            out.println("<table border='1'><tr><th>Train ID</th><th>Departure</th><th>Arrival</th><th>Duration</th><th>Fare</th><th>Origin</th><th>Destination</th><th>Details</th><th>Action</th></tr>");

            do {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("schedule_id") + "</td>");
                out.println("<td>" + rs.getTimestamp("depart_datetime") + "</td>");
                out.println("<td>" + rs.getTimestamp("arrival_datetime") + "</td>");
                out.println("<td>" + rs.getInt("travel_time") + " mins</td>");
                out.println("<td>$" + rs.getBigDecimal("fare") + "</td>");
                out.println("<td>" + rs.getString("origin_station") + "</td>");
                out.println("<td>" + rs.getString("destination_station") + "</td>");
                out.println("<td><a href='trainDetails.jsp?schedule_id=" + rs.getInt("schedule_id") + "'>View Details</a></td>");
                out.println("<td>");
                // Book button, passing scheduleId, origin, destination, and travelDate
                out.println("<form action='reservation.jsp' method='get'>");
                out.println("<input type='hidden' name='scheduleId' value='" + rs.getInt("schedule_id") + "' />");
                out.println("<input type='hidden' name='origin' value='" + rs.getString("origin_station") + "' />");
                out.println("<input type='hidden' name='destination' value='" + rs.getString("destination_station") + "' />");
                out.println("<input type='hidden' name='st1id' value='" + rs.getInt("st1id") + "' />");
                out.println("<input type='hidden' name='st2id' value='" + rs.getInt("st2id") + "' />");
                out.println("<input type='hidden' name='departTime' value='" + rs.getTimestamp("depart_datetime") + "' />");
                out.println("<input type='hidden' name='arrivalTime' value='" + rs.getTimestamp("arrival_datetime") + "' />");
                out.println("<input type='hidden' name='travelTime' value='" + rs.getInt("travel_time") + "' />");
                out.println("<input type='hidden' name='fare' value='" + rs.getBigDecimal("fare") + "' />");
                java.sql.Timestamp departTimestamp = rs.getTimestamp("depart_datetime");
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                String departDate = sdf.format(departTimestamp);

                out.println("<input type='hidden' name='travelDate' value='" + departDate + "' />");
                out.println("<input type='submit' value='Book' />");
                out.println("</form>");
                out.println("</td>");
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