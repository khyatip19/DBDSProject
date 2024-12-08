<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>

<%
    // Security check for admin access
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get the username of the representative to edit
    String repUsername = request.getParameter("id");
    if (repUsername == null) {
        response.sendRedirect("manageCustomerReps.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Customer Representative</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <style>
        /* Styles similar to addRep.jsp for consistency */
        .main-container {
            max-width: 500px;
            margin: 40px auto;
            padding: 30px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
        }
        
        .submit-button {
            width: 100%;
            padding: 12px;
            background-color: #333;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 20px;
        }
        
        .messages {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        
        .error {
            background-color: #ffebee;
            color: #c62828;
        }
    </style>
</head>
<body>
    <div class="main-container">
        <h2>Edit Customer Representative</h2>

        <%
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();
                
                // Get current representative information
                String query = "SELECT p.*, e.ssn, e.phone_no " +
                             "FROM Person p " +
                             "JOIN Employee e ON p.username = e.username " +
                             "WHERE p.username = ? AND e.role = 'customer_rep'";
                             
                PreparedStatement pstmt = con.prepareStatement(query);
                pstmt.setString(1, repUsername);
                ResultSet rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    // Display form with current values
        %>
                    <form action="processEditRep.jsp" method="post">
                        <!-- Hidden field for username - shouldn't be changed -->
                        <input type="hidden" name="username" value="<%= rs.getString("username") %>">
                        
                        <div class="form-group">
                            <label>First Name:</label>
                            <input type="text" name="firstName" value="<%= rs.getString("first_name") %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label>Last Name:</label>
                            <input type="text" name="lastName" value="<%= rs.getString("last_name") %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label>Phone Number:</label>
                            <input type="text" name="phone" value="<%= rs.getString("phone_no") %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label>New Password (leave blank to keep current):</label>
                            <input type="password" name="newPassword">
                        </div>
                        
                        <input type="submit" value="Update Representative" class="submit-button">
                    </form>
        <%
                } else {
                    out.println("<div class='messages error'>Representative not found.</div>");
                }
                
                db.closeConnection(con);
                
            } catch(Exception e) {
                out.println("<div class='messages error'>Error: " + e.getMessage() + "</div>");
            }
        %>
        
        <a href="manageCustomerReps.jsp" class="back-button">Back to Representatives List</a>
    </div>
</body>
</html>