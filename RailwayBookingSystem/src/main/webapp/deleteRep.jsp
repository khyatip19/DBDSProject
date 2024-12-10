<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>

<%
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = request.getParameter("id");
    if(username != null) {
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            con.setAutoCommit(false); // Start transaction

            try {
                // First delete from Employee table
                String deleteEmployee = "DELETE FROM Employee WHERE username = ?";
                PreparedStatement pstmt = con.prepareStatement(deleteEmployee);
                pstmt.setString(1, username);
                pstmt.executeUpdate();

                // Then delete from Person table
                String deletePerson = "DELETE FROM Person WHERE username = ?";
                pstmt = con.prepareStatement(deletePerson);
                pstmt.setString(1, username);
                pstmt.executeUpdate();

                con.commit();
                response.sendRedirect("manageCustomerReps.jsp?success=deleted");
            } catch (SQLException e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
                db.closeConnection(con);
            }
        } catch (Exception e) {
            response.sendRedirect("manageCustomerReps.jsp?error=" + 
                java.net.URLEncoder.encode("Error deleting representative: " + e.getMessage(), "UTF-8"));
        }
    } else {
        response.sendRedirect("manageCustomerReps.jsp?error=No+username+specified");
    }
%>