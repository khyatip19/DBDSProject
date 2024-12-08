<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.cs527.pkg.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Reservation List</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <div class="form-container">
        <h2>Reservation List</h2>
        
        <!-- Search/Filter Form -->
        <form method="get" action="reservationList.jsp">
            <select name="filterType">
                <option value="transit_line">By Transit Line</option>
                <option value="customer">By Customer Name</option>
            </select>
            <input type="text" name="searchTerm" placeholder="Enter search term">
            <input type="submit" value="Search">
        </form>

        <div class="table-container">
            <table>
                <tr>
                    <th>Reservation #</th>
                    <th>Customer Name</th>
                    <th>Transit Line</th>
                    <th>Date</th>
                    <th>Fare</th>
                </tr>
                <%
                    ApplicationDB db = new ApplicationDB();
                    Connection con = db.getConnection();
                    
                    String filterType = request.getParameter("filterType");
                    String searchTerm = request.getParameter("searchTerm");
                    
                    String query = "SELECT r.reservation_number, u.first_name, u.last_name, " +
                                 "ts.line_name, r.reservation_date, r.total_fare " +
                                 "FROM Reservation r " +
                                 "JOIN users u ON r.username = u.username " +
                                 "JOIN Train_Schedule ts ON r.schedule_id = ts.schedule_id ";
                                 
                    if(filterType != null && searchTerm != null) {
                        if(filterType.equals("transit_line")) {
                            query += "WHERE ts.line_name LIKE ?";
                        } else {
                            query += "WHERE CONCAT(u.first_name, ' ', u.last_name) LIKE ?";
                        }
                    }
                    
                    PreparedStatement pstmt = con.prepareStatement(query);
                    if(searchTerm != null) {
                        pstmt.setString(1, "%" + searchTerm + "%");
                    }
                    
                    ResultSet rs = pstmt.executeQuery();
                    
                    while(rs.next()) {
                %>
                    <tr>
                        <td><%= rs.getInt("reservation_number") %></td>
                        <td><%= rs.getString("first_name") + " " + rs.getString("last_name") %></td>
                        <td><%= rs.getString("line_name") %></td>
                        <td><%= rs.getDate("reservation_date") %></td>
                        <td>$<%= String.format("%.2f", rs.getDouble("total_fare")) %></td>
                    </tr>
                <% }
                   db.closeConnection(con);
                %>
            </table>
        </div>
        <a href="adminDashboard.jsp" class="link-button">Back to Dashboard</a>
    </div>
</body>
</html>