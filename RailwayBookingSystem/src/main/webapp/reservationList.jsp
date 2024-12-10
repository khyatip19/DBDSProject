<%-- reservationList.jsp --%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Reservation Search</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <div class="form-container">
        <h2>Reservation Search</h2>

        <%
            // Initialize database connection
            ApplicationDB db = new ApplicationDB();
            Connection con = null;
            try {
                con = db.getConnection();
                
                // Query to get unique transit lines for the dropdown
                String lineQuery = "SELECT DISTINCT line_name FROM Train_Schedule WHERE line_name IS NOT NULL ORDER BY line_name";
                Statement lineStmt = con.createStatement();
                ResultSet lines = lineStmt.executeQuery(lineQuery);
        %>
                <%-- Search Form Section --%>
                <form method="get" action="reservationList.jsp">
                    <div class="search-container">
                        <div class="search-group">
                            <label>Search By:</label>
                            <select name="searchType" id="searchType" onchange="toggleSearchFields()">
                                <option value="transit" <%= "transit".equals(request.getParameter("searchType")) ? "selected" : "" %>>Transit Line</option>
                                <option value="customer" <%= "customer".equals(request.getParameter("searchType")) ? "selected" : "" %>>Customer Name</option>
                            </select>
                        </div>

                        <%-- Transit Line Search Fields --%>
                        <div id="transitSearch" class="search-fields">
                            <label>Select Transit Line:</label>
                            <select name="transitLine">
                                <option value="">All Lines</option>
                                <% while(lines.next()) { %>
                                    <option value="<%= lines.getString("line_name") %>" 
                                            <%= lines.getString("line_name").equals(request.getParameter("transitLine")) ? "selected" : "" %>>
                                        <%= lines.getString("line_name") %>
                                    </option>
                                <% } %>
                            </select>
                        </div>

                        <%-- Customer Search Fields --%>
                        <div id="customerSearch" class="search-fields" style="display:none;">
                            <label>Customer Name:</label>
                            <input type="text" name="customerName" 
                                   value="<%= request.getParameter("customerName") != null ? request.getParameter("customerName") : "" %>"
                                   placeholder="Enter name...">
                        </div>

                        <button type="submit" class="search-button">Search Reservations</button>
                    </div>
                </form>

                <%-- Results Table Section --%>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Reservation #</th>
                                <th>Customer</th>
                                <th>Date</th>
                                <th>Transit Line</th>
                                <th>Origin</th>
                                <th>Destination</th>
                                <th>Fare</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                // Build the query based on search parameters
                                StringBuilder queryBuilder = new StringBuilder(
                                    "SELECT r.reservation_number, p.first_name, p.last_name, " +
                                    "r.reservation_date, ts.line_name, " +
                                    "s1.name as origin_station, s2.name as destination_station, " +
                                    "r.total_fare " +
                                    "FROM Reservation r " +
                                    "JOIN Person p ON r.username = p.username " +
                                    "JOIN Train_Schedule ts ON r.schedule_id = ts.schedule_id " +
                                    "JOIN Station s1 ON r.origin = s1.station_id " +
                                    "JOIN Station s2 ON r.destination = s2.station_id "
                                );

                                // Add search conditions based on user input
                                String searchType = request.getParameter("searchType");
                                String transitLine = request.getParameter("transitLine");
                                String customerName = request.getParameter("customerName");

                                boolean hasCondition = false;

                                if ("transit".equals(searchType) && transitLine != null && !transitLine.trim().isEmpty()) {
                                    queryBuilder.append("WHERE ts.line_name = ? ");
                                    hasCondition = true;
                                } else if ("customer".equals(searchType) && customerName != null && !customerName.trim().isEmpty()) {
                                    queryBuilder.append("WHERE (LOWER(p.first_name) LIKE LOWER(?) OR LOWER(p.last_name) LIKE LOWER(?)) ");
                                    hasCondition = true;
                                }

                                queryBuilder.append("ORDER BY r.reservation_date DESC");

                                PreparedStatement pstmt = con.prepareStatement(queryBuilder.toString());

                                // Set query parameters
                                if (hasCondition) {
                                    if ("transit".equals(searchType) && transitLine != null && !transitLine.trim().isEmpty()) {
                                        pstmt.setString(1, transitLine);
                                    } else if ("customer".equals(searchType) && customerName != null && !customerName.trim().isEmpty()) {
                                        String searchTerm = "%" + customerName.trim() + "%";
                                        pstmt.setString(1, searchTerm);
                                        pstmt.setString(2, searchTerm);
                                    }
                                }

                                // Execute query and display results
                                ResultSet results = pstmt.executeQuery();
                                boolean hasResults = false;

                                while(results.next()) {
                                    hasResults = true;
                            %>
                                    <tr>
                                        <td><%= results.getInt("reservation_number") %></td>
                                        <td><%= results.getString("first_name") + " " + results.getString("last_name") %></td>
                                        <td><%= results.getDate("reservation_date") %></td>
                                        <td><%= results.getString("line_name") %></td>
                                        <td><%= results.getString("origin_station") %></td>
                                        <td><%= results.getString("destination_station") %></td>
                                        <td>$<%= String.format("%.2f", results.getDouble("total_fare")) %></td>
                                    </tr>
                            <%
                                }
                                if (!hasResults) {
                            %>
                                    <tr>
                                        <td colspan="7" class="no-results">No reservations found</td>
                                    </tr>
                            <%
                                }
                            %>
                        </tbody>
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
            var searchType = document.getElementById('searchType').value;
            var transitSearch = document.getElementById('transitSearch');
            var customerSearch = document.getElementById('customerSearch');
            
            if (searchType === 'transit') {
                transitSearch.style.display = 'block';
                customerSearch.style.display = 'none';
            } else {
                transitSearch.style.display = 'none';
                customerSearch.style.display = 'block';
            }
        }

        // Run on page load to set initial state
        window.onload = toggleSearchFields;
    </script>
</body>
</html>