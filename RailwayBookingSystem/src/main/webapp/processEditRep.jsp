<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>

<%
    // Security check for admin access
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }

    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        
        // Start transaction
        con.setAutoCommit(false);
        
        try {
            String username = request.getParameter("username");
            String newPassword = request.getParameter("newPassword");
            
            // Update Person table
            // Only update password if a new one was provided
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                String personQuery = "UPDATE Person SET first_name = ?, last_name = ?, password = ? WHERE username = ?";
                PreparedStatement pstmt = con.prepareStatement(personQuery);
                pstmt.setString(1, request.getParameter("firstName"));
                pstmt.setString(2, request.getParameter("lastName"));
                pstmt.setString(3, newPassword);
                pstmt.setString(4, username);
                pstmt.executeUpdate();
            } else {
                String personQuery = "UPDATE Person SET first_name = ?, last_name = ? WHERE username = ?";
                PreparedStatement pstmt = con.prepareStatement(personQuery);
                pstmt.setString(1, request.getParameter("firstName"));
                pstmt.setString(2, request.getParameter("lastName"));
                pstmt.setString(3, username);
                pstmt.executeUpdate();
            }
            
            // Update Employee table
            String empQuery = "UPDATE Employee SET phone_no = ? WHERE username = ?";
            PreparedStatement pstmt = con.prepareStatement(empQuery);
            pstmt.setString(1, request.getParameter("phone"));
            pstmt.setString(2, username);
            pstmt.executeUpdate();
            
            // Commit transaction
            con.commit();
            
            // Redirect with success message
            response.sendRedirect("manageCustomerReps.jsp?message=Representative updated successfully");
            
        } catch (SQLException e) {
            // Rollback on error
            con.rollback();
            throw e;
        } finally {
            con.setAutoCommit(true);
            db.closeConnection(con);
        }
        
    } catch (Exception e) {
        // Redirect with error message
        response.sendRedirect("editRep.jsp?id=" + request.getParameter("username") + 
                            "&error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
    }
%>