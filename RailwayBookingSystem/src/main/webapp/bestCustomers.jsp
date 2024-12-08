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
    <title>Best Customers Analysis</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <style>
        .customer-card {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 15px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .customer-metrics {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-top: 10px;
        }
        
        .metric {
            text-align: center;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="form-container" style="max-width: 1200px;">
        <h2>Best Customers Analysis</h2>
        
        <%
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();
                
                // Query to get top customers by revenue
                String topCustomersQuery = 
                    "SELECT " +
                    "   p.username, " +
                    "   p.first_name, " +
                    "   p.last_name, " +
                    "   COUNT(*) as total_bookings, " +
                    "   SUM(r.total_fare) as total_spent, " +
                    "   AVG(r.total_fare) as avg_booking_value, " +
                    "   MAX(r.reservation_date) as last_booking " +
                    "FROM Person p " +
                    "JOIN Reservation r ON p.username = r.username " +
                    "GROUP BY p.username " +
                    "ORDER BY total_spent DESC " +
                    "LIMIT 10";
                    
                Statement stmt = con.createStatement();
                ResultSet topCustomers = stmt.executeQuery(topCustomersQuery);
        %>
        
        <!-- Top 10 Customers Section -->
        <div class="section">
            <h3>Top 10 Customers by Revenue</h3>
            <% 
                int rank = 1;
                while(topCustomers.next()) { 
            %>
                <div class="customer-card">
                    <h4>
                        #<%= rank++ %> - <%= topCustomers.getString("first_name") + " " + 
                                           topCustomers.getString("last_name") %>
                    </h4>
                    <div class="customer-metrics">
                        <div class="metric">
                            <div class="label">Total Spent</div>
                            <div class="value">$<%= String.format("%.2f", 
                                    topCustomers.getDouble("total_spent")) %></div>
                        </div>
                        <div class="metric">
                            <div class="label">Number of Bookings</div>
                            <div class="value"><%= topCustomers.getInt("total_bookings") %></div>
                        </div>
                        <div class="metric">
                            <div class="label">Average Booking Value</div>
                            <div class="value">$<%= String.format("%.2f", 
                                    topCustomers.getDouble("avg_booking_value")) %></div>
                        </div>
                        <div class="metric">
                            <div class="label">Last Booking</div>
                            <div class="value"><%= topCustomers.getDate("last_booking") %></div>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>

        <!-- Customer Value Distribution -->
        <%
            String valueDistributionQuery = 
                "SELECT " +
                "   CASE " +
                "       WHEN total_spent >= 1000 THEN 'Premium' " +
                "       WHEN total_spent >= 500 THEN 'High Value' " +
                "       WHEN total_spent >= 100 THEN 'Regular' " +
                "       ELSE 'Occasional' " +
                "   END as customer_segment, " +
                "   COUNT(*) as customer_count, " +
                "   SUM(total_spent) as segment_revenue " +
                "FROM (" +
                "   SELECT r.username, SUM(r.total_fare) as total_spent " +
                "   FROM Reservation r " +
                "   GROUP BY r.username" +
                ") customer_totals " +
                "GROUP BY " +
                "   CASE " +
                "       WHEN total_spent >= 1000 THEN 'Premium' " +
                "       WHEN total_spent >= 500 THEN 'High Value' " +
                "       WHEN total_spent >= 100 THEN 'Regular' " +
                "       ELSE 'Occasional' " +
                "   END " +
                "ORDER BY segment_revenue DESC";
                
            ResultSet distribution = stmt.executeQuery(valueDistributionQuery);
        %>
        
        <div class="section">
            <h3>Customer Value Distribution</h3>
            <table>
                <tr>
                    <th>Customer Segment</th>
                    <th>Number of Customers</th>
                    <th>Total Revenue</th>
                    <th>Average Revenue per Customer</th>
                </tr>
                <% while(distribution.next()) { %>
                    <tr>
                        <td><%= distribution.getString("customer_segment") %></td>
                        <td><%= distribution.getInt("customer_count") %></td>
                        <td>$<%= String.format("%.2f", 
                                distribution.getDouble("segment_revenue")) %></td>
                        <td>$<%= String.format("%.2f", 
                                distribution.getDouble("segment_revenue") / 
                                distribution.getInt("customer_count")) %></td>
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
            <a href="exportCustomerAnalysis.jsp" class="link-button">Export Analysis</a>
        </div>
    </div>
</body>
</html>