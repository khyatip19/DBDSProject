<%@ page import="java.sql.*, java.time.LocalDate" %>
<%
    // Retrieve the logged-in username from the session
    String username = (String) session.getAttribute("username");

    if (username == null) {
        response.sendRedirect("login.jsp"); // Redirect to login page if not logged in
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/railwaybookingsystem", "root", "mysqlroot");

        // Query for current reservations
        String currentReservationsQuery = 
              "SELECT r.reservation_number, r.depart_date, r.departure_time, r.total_fare, r.ticket_type, " +
              "       st1.name AS origin_station, st2.name AS destination_station " +
              "FROM Reservation r " +
              "JOIN Station st1 ON r.origin = st1.station_id " +
              "JOIN Station st2 ON r.destination = st2.station_id " +
              "WHERE r.username = ? AND r.depart_date >= CURDATE() " +
              "ORDER BY r.depart_date ASC";

        // Query for past reservations
        String pastReservationsQuery = 
              "SELECT r.reservation_number, r.depart_date, r.departure_time, r.total_fare, r.ticket_type, " +
              "       st1.name AS origin_station, st2.name AS destination_station " +
              "FROM Reservation r " +
              "JOIN Station st1 ON r.origin = st1.station_id " +
              "JOIN Station st2 ON r.destination = st2.station_id " +
              "WHERE r.username = ? AND r.depart_date < CURDATE() " +
              "ORDER BY r.depart_date DESC";

        out.println("<h2 class='section-title'>Current Reservations</h2>");
        pstmt = conn.prepareStatement(currentReservationsQuery);
        pstmt.setString(1, username);
        rs = pstmt.executeQuery();

        if (!rs.isBeforeFirst()) {
            out.println("<p>No current reservations found.</p>");
        } else {
            out.println("<table class='styled-table'>");
            out.println("<thead><tr><th>Reservation No</th><th>Origin</th><th>Destination</th><th>Depart Date</th><th>Depart Time</th><th>Fare</th><th>Ticket Type</th><th>Action</th></tr></thead>");
            out.println("<tbody>");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("reservation_number") + "</td>");
                out.println("<td>" + rs.getString("origin_station") + "</td>");
                out.println("<td>" + rs.getString("destination_station") + "</td>");
                out.println("<td>" + rs.getDate("depart_date") + "</td>");
                out.println("<td>" + rs.getTime("departure_time") + "</td>");
                out.println("<td>$" + rs.getBigDecimal("total_fare") + "</td>");
                out.println("<td>" + rs.getString("ticket_type") + "</td>");
                out.println("<td><a href='cancelReservation.jsp?reservation_number=" + rs.getInt("reservation_number") + "'>Cancel</a></td>");
                out.println("</tr>");
            }
            out.println("</tbody>");
            out.println("</table>");
        }

        out.println("<h2 class='section-title'>Past Reservations</h2>");
        pstmt = conn.prepareStatement(pastReservationsQuery);
        pstmt.setString(1, username);
        rs = pstmt.executeQuery();

        if (!rs.isBeforeFirst()) {
            out.println("<p>No past reservations found.</p>");
        } else {
            out.println("<table class='styled-table'>");
            out.println("<thead><tr><th>Reservation No</th><th>Origin</th><th>Destination</th><th>Depart Date</th><th>Depart Time</th><th>Fare</th><th>Ticket Type</th></tr></thead>");
            out.println("<tbody>");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("reservation_number") + "</td>");
                out.println("<td>" + rs.getString("origin_station") + "</td>");
                out.println("<td>" + rs.getString("destination_station") + "</td>");
                out.println("<td>" + rs.getDate("depart_date") + "</td>");
                out.println("<td>" + rs.getTime("departure_time") + "</td>");
                out.println("<td>$" + rs.getBigDecimal("total_fare") + "</td>");
                out.println("<td>" + rs.getString("ticket_type") + "</td>");
                out.println("</tr>");
            }
            out.println("</tbody>");
            out.println("</table>");
        }

    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<p>Error: Unable to retrieve reservation.</p>");
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>

<!-- CSS for better table formatting -->
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        margin: 20px;
    }

    h2.section-title {
        color: #333;
        font-size: 24px;
        text-align: center;
        margin-bottom: 20px;
    }

    .styled-table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 30px;
        background-color: white;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    .styled-table th, .styled-table td {
        padding: 12px 15px;
        text-align: left;
    }

    .styled-table th {
        background-color: #007bff;
        color: white;
    }

    .styled-table tr:nth-child(even) {
        background-color: #f9f9f9;
    }

    .styled-table tr:hover {
        background-color: #f1f1f1;
    }

    .styled-table td {
        color: #555;
    }

    .styled-table td, .styled-table th {
        border: 1px solid #ddd;
    }

    .styled-table td {
        text-align: center;
    }

    .styled-table th {
        text-align: center;
    }
</style>