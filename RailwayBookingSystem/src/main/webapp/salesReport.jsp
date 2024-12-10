<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>

<%
    // Security check - ensure only admin can access this report
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
        .monthly-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .monthly-table th, .monthly-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .positive {
            color: green;
        }
        .negative {
            color: red;
        }
        .report-header {
            margin-bottom: 30px;
            text-align: center;
        }
        .no-data {
            text-align: center;
            padding: 20px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="form-container" style="max-width: 1000px;">
        <div class="report-header">
            <h2>Monthly Sales Report</h2>
            <p>Generated on: <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date()) %></p>
        </div>
        
        <%
            ApplicationDB db = new ApplicationDB();
            Connection con = null;
            try {
                con = db.getConnection();
                
                // Get current month's summary with proper null handling
                String currentMonthQuery = 
                    "SELECT " +
                    "   COUNT(*) as total_reservations, " +
                    "   COALESCE(SUM(total_fare), 0) as total_revenue, " +
                    "   COALESCE(AVG(total_fare), 0) as avg_fare " +
                    "FROM Reservation " +
                    "WHERE MONTH(reservation_date) = MONTH(CURRENT_DATE()) " +
                    "AND YEAR(reservation_date) = YEAR(CURRENT_DATE())";
                
                Statement stmt = con.createStatement();
                ResultSet currentMonth = stmt.executeQuery(currentMonthQuery);
                
                if(currentMonth.next()) {
                    int totalReservations = currentMonth.getInt("total_reservations");
                    double totalRevenue = currentMonth.getDouble("total_revenue");
                    double avgFare = currentMonth.getDouble("avg_fare");
        %>
                    <!-- Summary cards for current month -->
                    <div class="summary-cards">
                        <div class="summary-card">
                            <h3>Total Reservations</h3>
                            <div class="stat-number">
                                <%= totalReservations %>
                            </div>
                        </div>
                        <div class="summary-card">
                            <h3>Total Revenue</h3>
                            <div class="stat-number">
                                $<%= String.format("%,.2f", totalRevenue) %>
                            </div>
                        </div>
                        <div class="summary-card">
                            <h3>Average Fare</h3>
                            <div class="stat-number">
                                $<%= String.format("%.2f", avgFare) %>
                            </div>
                        </div>
                    </div>

                    <!-- Monthly breakdown table -->
                    <h3>Monthly Breakdown</h3>
                    <table class="monthly-table">
                        <tr>
                            <th>Month</th>
                            <th>Reservations</th>
                            <th>Revenue</th>
                            <th>Average Fare</th>
                            <th>Growth Rate</th>
                        </tr>
                        <%
                            // Get monthly breakdown with proper growth rate calculation
                            String monthlyQuery = 
                                "WITH MonthlyStats AS (" +
                                "    SELECT " +
                                "        DATE_FORMAT(reservation_date, '%Y-%m') as month, " +
                                "        COUNT(*) as reservations, " +
                                "        SUM(total_fare) as revenue, " +
                                "        AVG(total_fare) as avg_fare " +
                                "    FROM Reservation " +
                                "    WHERE reservation_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 12 MONTH) " +
                                "    GROUP BY DATE_FORMAT(reservation_date, '%Y-%m') " +
                                ") " +
                                "SELECT *, " +
                                "    COALESCE( " +
                                "        ((revenue - LAG(revenue) OVER (ORDER BY month)) / NULLIF(LAG(revenue) OVER (ORDER BY month), 0)) * 100, " +
                                "        0 " +
                                "    ) as growth_rate " +
                                "FROM MonthlyStats " +
                                "ORDER BY month DESC";
                            
                            ResultSet monthlyStats = stmt.executeQuery(monthlyQuery);
                            boolean hasMonthlyData = false;
                            
                            while(monthlyStats.next()) {
                                hasMonthlyData = true;
                                String month = monthlyStats.getString("month");
                                int reservations = monthlyStats.getInt("reservations");
                                double revenue = monthlyStats.getDouble("revenue");
                                double avgFareMonth = monthlyStats.getDouble("avg_fare");
                                double growthRate = monthlyStats.getDouble("growth_rate");
                        %>
                                <tr>
                                    <td><%= month %></td>
                                    <td><%= reservations %></td>
                                    <td>$<%= String.format("%,.2f", revenue) %></td>
                                    <td>$<%= String.format("%.2f", avgFareMonth) %></td>
                                    <td class="<%= growthRate >= 0 ? "positive" : "negative" %>">
                                        <%= String.format("%.1f%%", growthRate) %>
                                    </td>
                                </tr>
                        <%
                            }
                            if (!hasMonthlyData) {
                        %>
                                <tr>
                                    <td colspan="5" class="no-data">No monthly data available</td>
                                </tr>
                        <%
                            }
                        %>
                    </table>
        <%
                }
            } catch(Exception e) {
                // Log the error and show user-friendly message
                e.printStackTrace();
                out.println("<div class='error'>An error occurred while generating the report. Please try again later.</div>");
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
        
        <div class="button-container">
            <a href="adminDashboard.jsp" class="link-button">Back to Dashboard</a>
            <a href="exportSalesReport.jsp" class="link-button">Export to CSV</a>
        </div>
    </div>
</body>
</html>