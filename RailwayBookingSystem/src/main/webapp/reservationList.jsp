<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Reservation Search</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <style>
        .filter-container {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        .filter-group {
            flex: 1;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Reservation Search</h2>

        <%
            ApplicationDB db = new ApplicationDB();
            Connection con = null;
            try {
                con = db.getConnection();
                
                // Get transit lines for dropdown
                String lineQuery = "SELECT DISTINCT line_name FROM Train_Schedule WHERE line_name IS NOT NULL ORDER BY line_name";
                Statement lineStmt = con.createStatement();
                ResultSet lines = lineStmt.executeQuery(lineQuery);
        %>
                <form method="get" action="reservationSearch.jsp" class="filter-form">
                    <div class="filter-container">
                        <div class="filter-group">
                            <label for="filter_type">Search By:</label>
                            <select name="filter_type" id="filter_type" onchange="toggleSearchFields()">
                                <option value="line" <%= "line".equals(request.getParameter("filter_type")) ? "selected" : "" %>>Transit Line</option>
                                <option value="customer" <%= "customer".equals(request.getParameter("filter_type")) ? "selected" : "" %>>Customer Name</option>
                            </select>
                        </div>
                        
                        <div class="filter-group" id="line_filter">
                            <label for="line_name">Select Transit Line:</label>
                            <select name="line_name" id="line_name">
                                <option value="">All Lines</option>
                                <%
                                    String selectedLine = request.getParameter("line_name");
                                    while(lines.next()) {
                                        String lineName = lines.getString("line_name");
                                        boolean isSelected = lineName != null && lineName.equals(selectedLine);
                                %>
                                        <option value="<%= lineName %>" <%= isSelected ? "selected" : "" %>><%= lineName %></option>
                                <%
                                    }
                                %>
                            </select>
                        </div>
                        
                        <div class="filter-group" id="customer_filter" style="display: none;">
                            <label for="customer_name">Customer Name:</label>
                            <input type="text" name="customer_name" id="customer_name" 
                                   value="<%= request.getParameter("customer_name") != null ? request.getParameter("customer_name") : "" %>"
                                   placeholder="Enter customer name">
                        </div>
                    </div>
                    <button type="submit" class="submit-button">Search Reservations</button>
                </form>

                <div class="table-container">
                    <table>
                        <tr>
                            <th>Reservation #</th>
                            <th>Customer</th>
                            <th>Date</th>
                            <th>Transit Line</th>
                            <th>Origin</th>
                            <th>Destination</th>
                            <th>Fare</th>
                        </tr>
                        <%
                            StringBuilder queryBuilder = new StringBuilder(
                                "SELECT r.reservation_number, p.first_name, p.last_name, " +
                                "r.reservation_date, ts.line_name, " +
                                "s1.name as origin_station, s2.name as destination_station, " +
                                "r.total_fare " +
                                "FROM Reservation r " +
                                "JOIN Person p ON r.username = p.username " +
                                "JOIN Station s1 ON r.origin = s1.station_id " +
                                "JOIN Station s2 ON r.destination = s2.station_id " +
                                "JOIN Train_Schedule ts ON r.schedule_id = ts.schedule_id "
                            );
                            
                            String filterType = request.getParameter("filter_type");
                            if(filterType != null) {
                                if(filterType.equals("line") && selectedLine != null && !selectedLine.trim().isEmpty()) {
                                    queryBuilder.append("WHERE ts.line_name = ? ");
                                } else if(filterType.equals("customer")) {
                                    String customerName = request.getParameter("customer_name");
                                    if(customerName != null && !customerName.trim().isEmpty()) {
                                        queryBuilder.append("WHERE CONCAT(p.first_name, ' ', p.last_name) LIKE ? ");
                                    }
                                }
                            }
                            queryBuilder.append("ORDER BY r.reservation_date DESC");
                            
                            PreparedStatement pstmt = con.prepareStatement(queryBuilder.toString());
                            if(filterType != null) {
                                if(filterType.equals("line") && selectedLine != null && !selectedLine.trim().isEmpty()) {
                                    pstmt.setString(1, selectedLine);
                                } else if(filterType.equals("customer")) {
                                    String customerName = request.getParameter("customer_name");
                                    if(customerName != null && !customerName.trim().isEmpty()) {
                                        pstmt.setString(1, "%" + customerName + "%");
                                    }
                                }
                            }
                            
                            ResultSet reservations = pstmt.executeQuery();
                            boolean hasResults = false;
                            
                            while(reservations.next()) {
                                hasResults = true;
                        %>
                                <tr>
                                    <td><%= reservations.getInt("reservation_number") %></td>
                                    <td><%= reservations.getString("first_name") + " " + reservations.getString("last_name") %></td>
                                    <td><%= reservations.getDate("reservation_date") %></td>
                                    <td><%= reservations.getString("line_name") %></td>
                                    <td><%= reservations.getString("origin_station") %></td>
                                    <td><%= reservations.getString("destination_station") %></td>
                                    <td>$<%= String.format("%.2f", reservations.getDouble("total_fare")) %></td>
                                </tr>
                        <%
                            }
                            if (!hasResults) {
                        %>
                                <tr>
                                    <td colspan="7" class="no-results">No reservations found for the selected criteria</td>
                                </tr>
                        <%
                            }
                        %>
                    </table>
                </div>
        <%
            } catch(Exception e) {
                out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
                e.printStackTrace();
            } finally {
                if(con != null) db.closeConnection(con);
            }
        %>

        <div class="button-container">
            <a href="adminDashboard.jsp" class="link-button">Back to Dashboard</a>
        </div>
    </div>

    <script>
        function toggleSearchFields() {
            const filterType = document.getElementById('filter_type').value;
            const lineFilter = document.getElementById('line_filter');
            const customerFilter = document.getElementById('customer_filter');
            
            if(filterType === 'line') {
                lineFilter.style.display = 'block';
                customerFilter.style.display = 'none';
            } else {
                lineFilter.style.display = 'none';
                customerFilter.style.display = 'block';
            }
        }

        // Initialize on page load
        window.onload = toggleSearchFields;
    </script>
</body>
</html>



<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
</html> --%>