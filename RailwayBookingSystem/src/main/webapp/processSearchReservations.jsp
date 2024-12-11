<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page import="java.util.List, java.util.ArrayList, java.util.Map, java.util.HashMap, java.sql.*" %>
<%
    String lineName = request.getParameter("line_name");
    String date = request.getParameter("date");

    List<Map<String, String>> reservations = new ArrayList<>();
    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        String query = 
            "SELECT " +
            "    p.first_name, p.last_name, p.username, " +
            "    r.reservation_number, r.depart_date, tl.line_name " +
            "FROM " +
            "    Person p " +
            "JOIN " +
            "    Reservation r ON p.username = r.username " +
            "JOIN " +
            "    Train_Schedule ts ON r.schedule_id = ts.schedule_id " +
            "JOIN " +
            "    Transit_Line tl ON ts.line_name = tl.line_name " +
            "WHERE " +
            "    tl.line_name = ? AND r.depart_date = ?";

        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, lineName);
        ps.setString(2, date);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, String> reservation = new HashMap<>();
            reservation.put("first_name", rs.getString("first_name"));
            reservation.put("last_name", rs.getString("last_name"));
            reservation.put("username", rs.getString("username"));
            reservation.put("reservation_number", rs.getString("reservation_number"));
            reservation.put("depart_date", rs.getString("depart_date"));
            reservation.put("line_name", rs.getString("line_name"));
            reservations.add(reservation);
        }

        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        out.println("<p class='error'>Error fetching reservations: " + e.getMessage() + "</p>");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservations Results</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <div class="form-container">
        <h2>Reservations on Transit Line: <%= lineName %> (Date: <%= date %>)</h2>

        <% if (reservations.isEmpty()) { %>
            <p class="no-results">No reservations found for the selected line and date.</p>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>First Name</th>
                        <th>Last Name</th>
                        <th>Username</th>
                        <th>Reservation Number</th>
                        <th>Reservation Date</th>
                        <th>Transit Line</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, String> reservation : reservations) { %>
                        <tr>
                            <td><%= reservation.get("first_name") %></td>
                            <td><%= reservation.get("last_name") %></td>
                            <td><%= reservation.get("username") %></td>
                            <td><%= reservation.get("reservation_number") %></td>
                            <td><%= reservation.get("depart_date") %></td>
                            <td><%= reservation.get("line_name") %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</body>
</html>
