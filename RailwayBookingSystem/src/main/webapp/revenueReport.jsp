<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%
    // Security check for admin access
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Revenue Analysis</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <style>
        .analysis-section {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .revenue-chart {
            margin: 20px 0;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <div class="form-container" style="max-width: 1200px;">
        <h2>Revenue Analysis Dashboard</h2>
        
        <%
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();
                
                // Revenue by Transit Line
                String transitLineQuery = 
                    "SELECT ts.line_name, " +
                    "COUNT(*) as total_bookings, " +
                    "SUM(r.total_fare) as total_revenue, " +
                    "AVG(r.total_fare) as avg_fare, " +
                    "MIN(r.total_fare) as min_fare, " +
                    "MAX(r.total_fare) as max_fare " +
                    "FROM Reservation r " +
                    "JOIN Train_Schedule ts ON r.schedule_id = ts.schedule_id " +
                    "GROUP BY ts.line_name " +
                    "ORDER BY total_revenue DESC";
        %>
        
        <!-- Transit Line Revenue Analysis -->
        <div class="analysis-section">
            <h3>Revenue by Transit Line</h3>
            <table>
                <tr>
                    <th>Transit Line</th>
                    <th>Total Bookings</th>
                    <th>Total Revenue</th>
                    <th>Average Fare</th>
                    <th>Fare Range</th>
                    <th>Share of Revenue</th>
                </tr>
                <%
                    Statement stmt = con.createStatement();
                    ResultSet transitLines = stmt.executeQuery(transitLineQuery);
                    double totalSystemRevenue = 0;
                    
                    // First pass to get total revenue
                    while(transitLines.next()) {
                        totalSystemRevenue += transitLines.getDouble("total_revenue");
                    }
                    
                    // Reset result set
                    transitLines = stmt.executeQuery(transitLineQuery);
                    
                    while(transitLines.next()) {
                        double lineRevenue = transitLines.getDouble("total_revenue");
                        double revenueShare = (lineRevenue / totalSystemRevenue) * 100;
                %>
                        <tr>
                            <td><%= transitLines.getString("line_name") %></td>
                            <td><%= transitLines.getInt("total_bookings") %></td>
                            <td>$<%= String.format("%.2f", lineRevenue) %></td>
                            <td>$<%= String.format("%.2f", transitLines.getDouble("avg_fare")) %></td>
                            <td>$<%= String.format("%.2f - $%.2f", 
                                    transitLines.getDouble("min_fare"),
                                    transitLines.getDouble("max_fare")) %></td>
                            <td><%= String.format("%.1f%%", revenueShare) %></td>
                        </tr>
                <%
                    }
                %>
            </table>
        </div>

        <!-- Revenue by Customer Type -->
        <div class="analysis-section">
            <h3>Revenue by Customer Type</h3>
            <%
                String customerTypeQuery = 
                    "SELECT " +
                    "CASE " +
                    "    WHEN discount > 0 THEN 'Discounted Fare' " +
                    "    ELSE 'Regular Fare' " +
                    "END as customer_type, " +
                    "COUNT(*) as booking_count, " +
                    "SUM(total_fare) as revenue, " +
                    "AVG(total_fare) as avg_fare " +
                    "FROM Reservation " +
                    "GROUP BY CASE WHEN discount > 0 THEN 'Discounted Fare' ELSE 'Regular Fare' END";
                
                ResultSet customerTypes = stmt.executeQuery(customerTypeQuery);
            %>
            <table>
                <tr>
                    <th>Customer Type</th>
                    <th>Number of Bookings</th>
                    <th>Total Revenue</th>
                    <th>Average Fare</th>
                </tr>
                <% while(customerTypes.next()) { %>
                    <tr>
                        <td><%= customerTypes.getString("customer_type") %></td>
                        <td><%= customerTypes.getInt("booking_count") %></td>
                        <td>$<%= String.format("%.2f", customerTypes.getDouble("revenue")) %></td>
                        <td>$<%= String.format("%.2f", customerTypes.getDouble("avg_fare")) %></td>
                    </tr>
                <% } %>
            </table>
        </div>

        <!-- Monthly Trend Analysis -->
        <div class="analysis-section">
            <h3>Monthly Revenue Trends</h3>
            <%
                String monthlyTrendQuery = 
                    "SELECT DATE_FORMAT(reservation_date, '%Y-%m') as month, " +
                    "COUNT(*) as bookings, " +
                    "SUM(total_fare) as revenue, " +
                    "AVG(total_fare) as avg_fare " +
                    "FROM Reservation " +
                    "GROUP BY DATE_FORMAT(reservation_date, '%Y-%m') " +
                    "ORDER BY month DESC " +
                    "LIMIT 12";
                    
                ResultSet monthlyTrends = stmt.executeQuery(monthlyTrendQuery);
            %>
            <table>
                <tr>
                    <th>Month</th>
                    <th>Bookings</th>
                    <th>Revenue</th>
                    <th>Average Fare</th>
                </tr>
                <% while(monthlyTrends.next()) { %>
                    <tr>
                        <td><%= monthlyTrends.getString("month") %></td>
                        <td><%= monthlyTrends.getInt("bookings") %></td>
                        <td>$<%= String.format("%.2f", monthlyTrends.getDouble("revenue")) %></td>
                        <td>$<%= String.format("%.2f", monthlyTrends.getDouble("avg_fare")) %></td>
                    </tr>
                <% } %>
            </table>
        </div>

        <%
                db.closeConnection(con);
            } catch(Exception e) {
                out.println("Error: " + e.getMessage());
            }
        %>

        <div class="button-container">
            <a href="adminDashboard.jsp" class="link-button">Back to Dashboard</a>
            <a href="exportRevenueReport.jsp" class="link-button">Export Report</a>
        </div>
    </div>
</body>
</html>