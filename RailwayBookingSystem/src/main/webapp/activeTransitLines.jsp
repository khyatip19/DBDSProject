<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>

<%
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Most Active Transit Lines</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <meta charset="UTF-8">
</head>
<body>
    <div class="admin-container">
        <h2>Top 5 Most Active Transit Lines</h2>

        <div class="report-section">
            <table>
                <tr>
                    <th>Rank</th>
                    <th>Transit Line</th>
                    <th>Total Reservations</th>
                    <th>Total Revenue</th>
                    <th>Most Popular Route</th>
                </tr>
                <%
                    ApplicationDB db = new ApplicationDB();
                    Connection con = null;
                    try {
                        con = db.getConnection();
                        
                        // Improved query to show proper route information
                        String query = 
                            "WITH LineStats AS ( " +
                            "    SELECT " +
                            "        ts.line_name, " +
                            "        COUNT(*) as total_reservations, " +
                            "        SUM(r.total_fare) as total_revenue, " +
                            "        s1.name as origin_name, " +
                            "        s2.name as dest_name " +
                            "    FROM Reservation r " +
                            "    JOIN Train_Schedule ts ON r.schedule_id = ts.schedule_id " +
                            "    JOIN Transit_Line tl ON ts.line_name = tl.line_name " +
                            "    JOIN Station s1 ON tl.origin = s1.station_id " +
                            "    JOIN Station s2 ON tl.destination = s2.station_id " +
                            "    GROUP BY ts.line_name, s1.name, s2.name " +
                            ") " +
                            "SELECT * FROM LineStats " +
                            "ORDER BY total_reservations DESC, total_revenue DESC " +
                            "LIMIT 5";

                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery(query);

                        int rank = 1;
                        boolean hasResults = false;
                        
                        while(rs.next()) {
                            hasResults = true;
                            String route = rs.getString("origin_name") + " to " + rs.getString("dest_name");
                %>
                            <tr>
                                <td><%= rank++ %></td>
                                <td><%= rs.getString("line_name") %></td>
                                <td><%= rs.getInt("total_reservations") %></td>
                                <td>$<%= String.format("%,.2f", rs.getDouble("total_revenue")) %></td>
                                <td><%= route %></td>
                            </tr>
                <%
                        }
                        
                        if (!hasResults) {
                %>
                            <tr>
                                <td colspan="5" class="no-results">No transit line data available</td>
                            </tr>
                <%
                        }
                    } catch(Exception e) {
                        out.println("<tr><td colspan='5' class='error'>Error: " + e.getMessage() + "</td></tr>");
                        e.printStackTrace();
                    } finally {
                        if(con != null) {
                            try {
                                db.closeConnection(con);
                            } catch(Exception e) {
                                e.printStackTrace();
                            }
                        }
                    }
                %>
            </table>
        </div>

        <div class="button-container">
            <a href="adminDashboard.jsp" class="link-button">Back to Dashboard</a>
        </div>
    </div>
</body>
</html>