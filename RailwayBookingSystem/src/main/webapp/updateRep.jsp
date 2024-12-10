<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.cs527.pkg.*"%>

<%
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
            StringBuilder personQuery = new StringBuilder(
                "UPDATE Person SET first_name = ?, last_name = ?");
            
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                personQuery.append(", password = ?");
            }
            personQuery.append(" WHERE username = ?");
            
            PreparedStatement pstmt = con.prepareStatement(personQuery.toString());
            pstmt.setString(1, request.getParameter("firstName"));
            pstmt.setString(2, request.getParameter("lastName"));
            
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                pstmt.setString(3, newPassword);
                pstmt.setString(4, username);
            } else {
                pstmt.setString(3, username);
            }
            pstmt.executeUpdate();
            
            // Update Employee table
            String empQuery = "UPDATE Employee SET phone_no = ? WHERE username = ?";
            pstmt = con.prepareStatement(empQuery);
            pstmt.setString(1, request.getParameter("phone"));
            pstmt.setString(2, username);
            pstmt.executeUpdate();
            
            // Commit transaction
            con.commit();
            response.sendRedirect("manageCustomerReps.jsp?message=Representative updated successfully");
            
        } catch (SQLException e) {
            // Rollback on error
            con.rollback();
            throw e;
        }
        
        db.closeConnection(con);
        
    } catch (Exception e) {
        response.sendRedirect("manageCustomerReps.jsp?error=" + e.getMessage());
    }
%>