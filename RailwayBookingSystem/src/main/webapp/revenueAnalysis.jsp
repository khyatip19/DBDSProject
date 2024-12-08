<!-- revenueAnalysis.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.*, com.cs527.pkg.*"%>

<!DOCTYPE html>
<html>
<head>
    <title>Revenue Analysis</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <div class="form-container">
        <h2>Revenue Analysis</h2>
        <p class="subtitle">Detailed revenue breakdown and analysis</p>
        
        <!-- Revenue by Transit Line -->
        <div class="report-section">
            <h3>Revenue by Transit Line</h3>
            <table>
                <tr>
                    <th>Transit Line</th>
                    <th>Total Revenue</th>
                    <th>Reservations</th>
                    <th>Avg. Revenue/Reservation</th>
                </tr>
                <%
                    ApplicationDB db = new ApplicationDB();
                    Connection con = db.getConnection();
                    
                    String lineQuery = "SELECT ts.line_name, " +
                                     "SUM(r.total_fare) as total_revenue, " +
                                     "COUNT(*) as reservation_count, " +
                                     "AVG(r.total_fare) as avg_revenue " +
                                     "FROM Reservation r " +
                                     "JOIN Train_Schedule ts ON r.schedule_id = ts.schedule_id " +
                                     "GROUP BY ts.line_name " +
                                     "ORDER BY total_revenue DESC";
                                     
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery(lineQuery);
                    
                    while(rs.next()) {
                %>
                    <tr>
                        <td><%= rs.getString("line_name") %></td>
                        <td>$<%= String.format("%.2f", rs.getDouble("total_revenue")) %></td>
                        <td><%= rs.getInt("reservation_count") %></td>
                        <td>$<%= String.format("%.2f", rs.getDouble("avg_revenue")) %></td>
                    </tr>
                <% } %>
            </table>
        </div>

        <!-- Revenue by Customer Type -->
        <div class="report-section">
            <h3>Revenue by Customer Type</h3>
            <table>
                <tr>
                    <th>Customer Type</th>
                    <th>Total Revenue</th>
                    <th>Percentage</th>
                </tr>
                <%
                    String customerTypeQuery = 
                        "SELECT " +
                        "CASE " +
                        "  WHEN discount > 0 THEN 'Discounted' " +
                        "  ELSE 'Regular' " +
                        "END as customer_type, " +
                        "SUM(total_fare) as revenue, " +
                        "COUNT(*) as count, " +
                        "(SUM(total_fare) / (SELECT SUM(total_fare) FROM Reservation) * 100) as percentage " +
                        "FROM Reservation " +
                        "GROUP BY CASE WHEN discount > 0 THEN 'Discounted' ELSE 'Regular' END";
                        
                    rs = stmt.executeQuery(customerTypeQuery);
                    
                    while(rs.next()) {
                %>
                    <tr>
                        <td><%= rs.getString("customer_type") %></td>
                        <td>$<%= String.format("%.2f", rs.getDouble("revenue")) %></td>
                        <td><%= String.format("%.1f%%", rs.getDouble("percentage")) %></td>
                    </tr>
                <% }
                   db.closeConnection(con);
                %>
            </table>
        </div>
        
        <div style="margin-top: 20px; text-align: center;">
            <a href="adminDashboard.jsp" class="link-button">Back to Dashboard</a>
        </div>
    </div>
</body>
</html>