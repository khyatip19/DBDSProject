<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("username");
    String reservationNumber = request.getParameter("reservation_number");

    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/railwaybookingsystem", "root", "password");

        if (request.getParameter("confirm") != null) {
            // Process cancellation
            String deleteQuery = "DELETE FROM Reservation WHERE reservation_number = ? AND username = ?";
            pstmt = conn.prepareStatement(deleteQuery);
            pstmt.setInt(1, Integer.parseInt(reservationNumber));
            pstmt.setString(2, username);
            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
%>
                <div style="text-align: center; margin-top: 50px;">
                    <h2>Reservation Cancelled</h2>
                    <p>Your reservation has been successfully cancelled.</p>
                    
                            <a href="welcome.jsp" class="button">Back to Home</a>
                    
                </div>
<%
            } else {
%>
                <div style="text-align: center; margin-top: 50px;">
                    <h2>Error</h2>
                    <p>Failed to cancel the reservation. Please try again.</p>
                    
                            <a href="welcome.jsp" class="button">Back to Home</a>
                    
                </div>
<%
            }
        } else {
            // Display reservation details
            String query = 
                  "SELECT r.reservation_number, r.depart_date, r.departure_time, r.total_fare, r.ticket_type, " +
                  "       st1.name AS origin_station, st2.name AS destination_station " +
                  "FROM Reservation r " +
                  "JOIN Station st1 ON r.origin = st1.station_id " +
                  "JOIN Station st2 ON r.destination = st2.station_id " +
                  "WHERE r.reservation_number = ? AND r.username = ?";

            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, Integer.parseInt(reservationNumber));
            pstmt.setString(2, username);
            rs = pstmt.executeQuery();

            if (rs.next()) {
%>
                <div style="text-align: center; margin-top: 30px;">
                    <h2>Cancel Reservation</h2>
                    <p>Are you sure you want to cancel the following reservation?</p>
                    <table class="styled-table" style="margin: 20px auto; border-collapse: collapse; width: 60%; text-align: left;">
                        <tr><th>Reservation No:</th><td><%= rs.getInt("reservation_number") %></td></tr>
                        <tr><th>Origin:</th><td><%= rs.getString("origin_station") %></td></tr>
                        <tr><th>Destination:</th><td><%= rs.getString("destination_station") %></td></tr>
                        <tr><th>Depart Date:</th><td><%= rs.getDate("depart_date") %></td></tr>
                        <tr><th>Depart Time:</th><td><%= rs.getTime("departure_time") %></td></tr>
                        <tr><th>Total Fare:</th><td>$<%= rs.getBigDecimal("total_fare") %></td></tr>
                        <tr><th>Ticket Type:</th><td><%= rs.getString("ticket_type") %></td></tr>
                    </table>
                    <form method="post" action="cancelReservation.jsp" style="margin-top: 20px;">
                        <input type="hidden" name="reservation_number" value="<%= reservationNumber %>">
                        <input type="hidden" name="confirm" value="true">
                        <input type="submit" value="Confirm Cancel" 
                               style="background-color: #ff6666; color: white; border: none; padding: 10px 20px; font-size: 16px; border-radius: 5px; cursor: pointer;">
                    </form>
                </div>
<%
            } else {
%>
                <div style="text-align: center; margin-top: 50px;">
                    <p>Reservation not found or unauthorized access.</p>
                </div>
<%
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<p>Error: Unable to cancel reservation.</p>");
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
