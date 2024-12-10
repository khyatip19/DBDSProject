<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
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
                    Connection con = db.getConnection();
                    
                    String query = "SELECT tl.line_name, " +
                                 "COUNT(*) as total_reservations, " +
                                 "SUM(r.total_fare) as total_revenue, " +
                                 "CONCAT(s1.name, ' → ', s2.name) as popular_route " +
                                 "FROM Reservation r " +
                                 "JOIN Train_Schedule ts ON r.schedule_id = ts.schedule_id " +
                                 "JOIN Transit_Line tl ON ts.line_name = tl.line_name " +
                                 "JOIN Station s1 ON r.origin = s1.station_id " +
                                 "JOIN Station s2 ON r.destination = s2.station_id " +
                                 "GROUP BY tl.line_name " +
                                 "ORDER BY total_reservations DESC " +
                                 "LIMIT 5";
                     
                    /* String query = 
                            "SELECT " +
                            "   tl.line_name, " +
                            "   COUNT(*) as total_reservations, " +
                            "   SUM(r.total_fare) as total_revenue, " +
                            "   CONCAT(s1.name, ' → ', s2.name) as popular_route " +
                            "FROM Train_Schedule ts " +
                            "JOIN Transit_Line tl ON ts.line_name = tl.line_name " +
                            "JOIN Reservation r ON ts.schedule_id = r.schedule_id " +
                            "JOIN Station s1 ON r.origin = s1.station_id " +
                            "JOIN Station s2 ON r.destination = s2.station_id " +
                            "GROUP BY tl.line_name " +
                            "ORDER BY total_reservations DESC " +
                            "LIMIT 5"; */
                    
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery(query);
                    
                    int rank = 1;
                    while(rs.next()) {
                %>
                    <tr>
                        <td><%= rank++ %></td>
                        <td><%= rs.getString("line_name") %></td>
                        <td><%= rs.getInt("total_reservations") %></td>
                        <td>$<%= String.format("%.2f", rs.getDouble("total_revenue")) %></td>
                        <td><%= rs.getString("popular_route") %></td>
                    </tr>
                <% } 
                   db.closeConnection(con);
                %>
            </table>
        </div>
        
        <div style="margin-top: 20px; text-align: center;">
       <!--  <div class="button-container"> -->
            <a href="adminDashboard.jsp" class="link-button">Back to Dashboard</a>
        </div>
    </div>
</body>
</html>