<%@ page language="java" contentType="text/csv; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.sql.*, com.cs527.pkg.*"%>
<%
    // Set response headers for CSV download
    response.setHeader("Content-Disposition", "attachment; filename=sales_report.csv");

    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        
        // Create CSV writer
        PrintWriter writer = response.getWriter();
        
        // Write CSV headers
        writer.println("Month,Reservations,Revenue,Average Fare,Growth Rate");
        
        // Query for monthly breakdown
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
        
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery(monthlyQuery);
        
        // Write data rows
        while(rs.next()) {
            StringBuilder line = new StringBuilder();
            line.append(rs.getString("month")).append(",");
            line.append(rs.getInt("reservations")).append(",");
            line.append(String.format("%.2f", rs.getDouble("revenue"))).append(",");
            line.append(String.format("%.2f", rs.getDouble("avg_fare"))).append(",");
            line.append(String.format("%.1f", rs.getDouble("growth_rate"))).append("%");
            writer.println(line.toString());
        }
        
        db.closeConnection(con);
    } catch(Exception e) {
        e.printStackTrace();
    }
%>