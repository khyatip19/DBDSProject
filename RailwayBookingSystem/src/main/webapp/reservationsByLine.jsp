<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Reservations by Transit Line</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <div class="form-container">
        <h2>Reservations by Transit Line</h2>

        <%
            ApplicationDB db = new ApplicationDB();
            Connection con = null;
            try {
                con = db.getConnection();
                
                // Debug: Print available transit lines
                System.out.println("Available Transit Lines:");
                String lineQuery = "SELECT DISTINCT line_name FROM Train_Schedule WHERE line_name IS NOT NULL";
                Statement lineStmt = con.createStatement();
                ResultSet lines = lineStmt.executeQuery(lineQuery);
        %>
                <form method="get" action="reservationsByLine.jsp" class="filter-form">
                    <div class="form-group">
                        <label for="line_name">Select Transit Line:</label>
                        <select name="line_name" id="line_name">
                            <option value="">All Lines</option>
                            <%
                                String selectedLine = request.getParameter("line_name");
                                System.out.println("Selected Line: " + selectedLine); // Debug print
                                
                                while(lines.next()) {
                                    String lineName = lines.getString("line_name");
                                    System.out.println("Found line: " + lineName); // Debug print
                                    boolean isSelected = lineName != null && lineName.equals(selectedLine);
                            %>
                                    <option value="<%= lineName %>" <%= isSelected ? "selected" : "" %>><%= lineName %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <button type="submit" class="submit-button">Filter Reservations</button>
                </form>

                <%
                    // Debug: Print reservation counts
                    String countQuery = "SELECT ts.line_name, COUNT(*) as count " +
                                      "FROM Reservation r " +
                                      "JOIN Train_Schedule ts ON r.schedule_id = ts.schedule_id " +
                                      "GROUP BY ts.line_name";
                    Statement countStmt = con.createStatement();
                    ResultSet counts = countStmt.executeQuery(countQuery);
                    System.out.println("Reservation counts by line:");
                    while(counts.next()) {
                        System.out.println(counts.getString("line_name") + ": " + counts.getInt("count"));
                    }
                %>

                <div class="table-container">
                    <table>
                        <tr>
                            <th>Reservation #</th>
                            <th>Customer</th>
                            <th>Date</th>
                            <th>Origin</th>
                            <th>Destination</th>
                            <th>Fare</th>
                        </tr>
                        <%
                            String query = 
                                "SELECT r.reservation_number, p.first_name, p.last_name, " +
                                "r.reservation_date, s1.name as origin_station, " +
                                "s2.name as destination_station, r.total_fare, ts.line_name " +
                                "FROM Reservation r " +
                                "JOIN Person p ON r.username = p.username " +
                                "JOIN Station s1 ON r.origin = s1.station_id " +
                                "JOIN Station s2 ON r.destination = s2.station_id " +
                                "JOIN Train_Schedule ts ON r.schedule_id = ts.schedule_id ";
                            
                            if(selectedLine != null && !selectedLine.trim().isEmpty()) {
                                query += "WHERE ts.line_name = ?";
                            }
                            query += " ORDER BY r.reservation_date DESC";
                            
                            System.out.println("Executing query: " + query); // Debug print
                            
                            PreparedStatement pstmt = con.prepareStatement(query);
                            if(selectedLine != null && !selectedLine.trim().isEmpty()) {
                                pstmt.setString(1, selectedLine);
                                System.out.println("With parameter: " + selectedLine); // Debug print
                            }
                            
                            ResultSet reservations = pstmt.executeQuery();
                            boolean hasResults = false;
                            
                            while(reservations.next()) {
                                hasResults = true;
                                // Debug print
                                System.out.println("Found reservation: " + reservations.getInt("reservation_number") + 
                                                 " for line: " + reservations.getString("line_name"));
                        %>
                                <tr>
                                    <td><%= reservations.getInt("reservation_number") %></td>
                                    <td><%= reservations.getString("first_name") + " " + reservations.getString("last_name") %></td>
                                    <td><%= reservations.getDate("reservation_date") %></td>
                                    <td><%= reservations.getString("origin_station") %></td>
                                    <td><%= reservations.getString("destination_station") %></td>
                                    <td>$<%= String.format("%.2f", reservations.getDouble("total_fare")) %></td>
                                </tr>
                        <%
                            }
                            if (!hasResults) {
                        %>
                                <tr>
                                    <td colspan="6" class="no-results">No reservations found for the selected criteria</td>
                                </tr>
                        <%
                            }
                        %>
                    </table>
                </div>
        <%
            } catch(Exception e) {
                System.out.println("Error occurred: " + e.getMessage()); // Debug print
                e.printStackTrace();
                out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
            } finally {
                if(con != null) db.closeConnection(con);
            }
        %>

        <div class="button-container">
            <a href="adminDashboard.jsp" class="link-button">Back to Dashboard</a>
        </div>
    </div>
</body>
</html>