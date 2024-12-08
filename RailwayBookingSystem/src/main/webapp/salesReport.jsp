<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>

<%
    // Verify admin access - security check
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Monthly Sales Report</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <style>
        /* Additional styles for the sales report */
        .summary-cards {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        .summary-card {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            text-align: center;
        }
        .stat-number {
            font-size: 24px;
            font-weight: bold;
            color: #2c3e50;
        }
    </style>
</head>
<body>
    <div class="form-container" style="max-width: 1000px;">
        <h2>Monthly Sales Report</h2>
        
        <%
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();
                
                // Get current month's summary
                String currentMonthQuery = 
                    "SELECT COUNT(*) as total_reservations, " +
                    "SUM(total_fare) as total_revenue, " +
                    "AVG(total_fare) as avg_fare " +
                    "FROM Reservation " +
                    "WHERE MONTH(reservation_date) = MONTH(CURRENT_DATE()) " +
                    "AND YEAR(reservation_date) = YEAR(CURRENT_DATE())";
                
                Statement stmt = con.createStatement();
                ResultSet currentMonth = stmt.executeQuery(currentMonthQuery);
                
                if(currentMonth.next()) {
        %>
                    <!-- Summary cards for current month -->
                    <div class="summary-cards">
                        <div class="summary-card">
                            <h3>Total Reservations</h3>
                            <div class="stat-number">
                                <%= currentMonth.getInt("total_reservations") %>
                            </div>
                        </div>
                        <div class="summary-card">
                            <h3>Total Revenue</h3>
                            <div class="stat-number">
                                $<%= String.format("%.2f", currentMonth.getDouble("total_revenue")) %>
                            </div>
                        </div>
                        <div class="summary-card">
                            <h3>Average Fare</h3>
                            <div class="stat-number">
                                $<%= String.format("%.2f", currentMonth.getDouble("avg_fare")) %>
                            </div>
                        </div>
                    </div>

                    <!-- Monthly breakdown table -->
                    <h3>Monthly Breakdown</h3>
                    <table>
                        <tr>
                            <th>Month</th>
                            <th>Reservations</th>
                            <th>Revenue</th>
                            <th>Average Fare</th>
                            <th>Growth Rate</th>
                        </tr>
                        <%
                            // Get monthly breakdown for the last 12 months
                            String monthlyQuery = 
                                "SELECT " +
                                "   DATE_FORMAT(reservation_date, '%Y-%m') as month, " +
                                "   COUNT(*) as reservations, " +
                                "   SUM(total_fare) as revenue, " +
                                "   AVG(total_fare) as avg_fare, " +
                                "   LAG(SUM(total_fare)) OVER (ORDER BY reservation_date) as prev_revenue " +
                                "FROM Reservation " +
                                "WHERE reservation_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 12 MONTH) " +
                                "GROUP BY DATE_FORMAT(reservation_date, '%Y-%m') " +
                                "ORDER BY month DESC";
                            
                            ResultSet monthlyStats = stmt.executeQuery(monthlyQuery);
                            
                            while(monthlyStats.next()) {
                                double currentRevenue = monthlyStats.getDouble("revenue");
                                double prevRevenue = monthlyStats.getDouble("prev_revenue");
                                double growthRate = prevRevenue > 0 ? 
                                    ((currentRevenue - prevRevenue) / prevRevenue) * 100 : 0;
                        %>
                                <tr>
                                    <td><%= monthlyStats.getString("month") %></td>
                                    <td><%= monthlyStats.getInt("reservations") %></td>
                                    <td>$<%= String.format("%.2f", monthlyStats.getDouble("revenue")) %></td>
                                    <td>$<%= String.format("%.2f", monthlyStats.getDouble("avg_fare")) %></td>
                                    <td class="<%= growthRate >= 0 ? "positive" : "negative" %>">
                                        <%= String.format("%.1f%%", growthRate) %>
                                    </td>
                                </tr>
                        <%
                            }
                        %>
                    </table>
        <%
                }
                db.closeConnection(con);
            } catch(Exception e) {
                out.println("Error: " + e.getMessage());
            }
        %>
        
        <div class="button-container">
            <a href="adminDashboard.jsp" class="link-button">Back to Dashboard</a>
            <!-- Add an export button that downloads the report as CSV -->
            <a href="exportSalesReport.jsp" class="link-button">Export to CSV</a>
        </div>
    </div>
</body>
</html>