<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>

<%
    try {
        // Get login credentials
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Create database connection
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        
        // Prepare SQL query to check admin credentials
        // We check both Person table and Employee table with admin role
        String query = "SELECT p.username FROM Person p " +
                      "JOIN Employee e ON p.username = e.username " +
                      "WHERE p.username = ? AND p.password = ? AND e.role = 'admin'";
                      
        PreparedStatement pstmt = con.prepareStatement(query);
        pstmt.setString(1, username);
        pstmt.setString(2, password);
        
        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next()) {
            // Valid admin login - create session
            session.setAttribute("adminUser", username);
            session.setAttribute("userRole", "admin");
            response.sendRedirect("adminDashboard.jsp");
        } else {
            // Invalid login - redirect back with error
            response.sendRedirect("adminLogin.jsp?error=invalid");
        }
        
        // Close resources
        rs.close();
        pstmt.close();
        db.closeConnection(con);
        
    } catch (Exception e) {
        out.print("Error: " + e.getMessage());
        e.printStackTrace();
    }
%>