<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Login - Railway Booking System</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>

<body>

<%
    String message = request.getParameter("message"); // Get the message from the query parameter
    if (message == null) {
        message = "";  // Initialize message if it's null
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            // Establish database connection
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();

            // Prepare and execute the login query
            String username = request.getParameter("username");
            String password = request.getParameter("password");
			
            // Check if user already in table or not
            // String query = "SELECT p.username, p.password FROM Person p JOIN Customer c ON p.username = c.username WHERE p.username = ? AND p.password = ?";
            String query = "SELECT p.*, " +
                    "CASE " +
                    "   WHEN e.role = 'admin' THEN 'admin' " +
                    "   WHEN e.role = 'customer_rep' THEN 'rep' " +
                    "   ELSE 'customer' " +
                    "END as user_role " +
                    "FROM Person p " +
                    "LEFT JOIN Employee e ON p.username = e.username " +
                    "WHERE p.username = ? AND p.password = ?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, username);
            pst.setString(2, password);
            
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                // Set session attribute and redirect
                String role = rs.getString("user_role");
                session.setAttribute("username", username);
                session.setAttribute("role", role);
                String firstName = rs.getString("first_name");
                String lastName = rs.getString("last_name");
                String fullName = firstName + " " + lastName;
                session.setAttribute("fullName", fullName);
                
             	// Redirect based on role
                switch(role) {
                    case "admin":
                        response.sendRedirect("adminDashboard.jsp");
                        break;
                    case "rep":
                        response.sendRedirect("repDashboard.jsp");
                        break;
                    default:
                        response.sendRedirect("welcome.jsp");
                }
            } else {
                message = "Invalid username or password.";
            }

            // Close the database connection
            db.closeConnection(con);
        } catch (Exception e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
        }
    }
%>

<div class="form-container">

    <!-- Display Success/Error Message -->
    <% if (!message.isEmpty()) { %>
        <p class="message"><%= message %></p>
    <% } %>

    <h2>Welcome back</h2>
    <p class="subtitle">Please enter your details to sign in.</p>

    <!-- Login Form -->
    <form method="post" action="login.jsp">
        <input type="text" name="username" placeholder="Username" required>
        <input type="password" name="password" placeholder="Password" required>

        <input type="submit" value="Sign in">
    </form>

    <p class="signup-link">Don't have an account yet? <a href="register.jsp">Sign Up</a></p>
</div>

</body>
</html>