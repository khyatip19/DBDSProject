<!-- manageReps.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.cs527.pkg.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Customer Representatives</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <div class="form-container">
        <h2>Customer Representatives</h2>
        <p class="subtitle">Manage customer service staff</p>

        <!-- Add New Rep Form -->
        <form action="addRep.jsp" method="post">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="text" name="firstName" placeholder="First Name" required>
            <input type="text" name="lastName" placeholder="Last Name" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="text" name="ssn" placeholder="SSN" required>
            <input type="text" name="phone" placeholder="Phone Number">
            <input type="submit" value="Add Representative">
        </form>

        <!-- List of Current Reps -->
        <div class="table-container">
            <table>
                <tr>
                    <th>Username</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Actions</th>
                </tr>
                <%
                    ApplicationDB db = new ApplicationDB();
                    Connection con = db.getConnection();
                    
                    String query = "SELECT e.*, u.first_name, u.last_name, u.email " +
                                 "FROM Employee e " +
                                 "JOIN users u ON e.username = u.username " +
                                 "WHERE e.role = 'customer_rep'";
                                 
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery(query);
                    
                    while(rs.next()) {
                %>
                    <tr>
                        <td><%= rs.getString("username") %></td>
                        <td><%= rs.getString("first_name") + " " + rs.getString("last_name") %></td>
                        <td><%= rs.getString("email") %></td>
                        <td><%= rs.getString("phone_no") %></td>
                        <td>
                            <a href="editRep.jsp?id=<%= rs.getString("username") %>" class="link-button">Edit</a>
                            <a href="deleteRep.jsp?id=<%= rs.getString("username") %>" 
                               class="link-button" 
                               onclick="return confirm('Are you sure you want to delete this representative?')">Delete</a>
                        </td>
                    </tr>
                <% } 
                   db.closeConnection(con);
                %>
            </table>
        </div>

        <div style="margin-top: 20px;">
            <a href="adminDashboard.jsp" class="link-button">Back to Dashboard</a>
        </div>
    </div>
</body>
</html>