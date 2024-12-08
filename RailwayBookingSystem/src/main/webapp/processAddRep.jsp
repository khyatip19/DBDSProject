<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>

<%
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }

    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        con.setAutoCommit(false); // Start transaction
        
        try {
            // First insert into Person table
            String personQuery = "INSERT INTO Person (username, password, first_name, last_name) VALUES (?, ?, ?, ?)";
            PreparedStatement pstmt = con.prepareStatement(personQuery);
            pstmt.setString(1, request.getParameter("username"));
            pstmt.setString(2, request.getParameter("password"));
            pstmt.setString(3, request.getParameter("firstName"));
            pstmt.setString(4, request.getParameter("lastName"));
            pstmt.executeUpdate();
            
            // Then insert into Employee table
            String empQuery = "INSERT INTO Employee (username, ssn, role, phone_no) VALUES (?, ?, 'customer_rep', ?)";
            pstmt = con.prepareStatement(empQuery);
            pstmt.setString(1, request.getParameter("username"));
            pstmt.setString(2, request.getParameter("ssn"));
            pstmt.setString(3, request.getParameter("phone"));
            pstmt.executeUpdate();
            
            con.commit(); // Commit transaction
            response.sendRedirect("manageCustomerReps.jsp?success=true");
            
        } catch (SQLException e) {
            con.rollback(); // Rollback on error
            throw e;
        } finally {
            con.setAutoCommit(true);
            db.closeConnection(con);
        }
        
    } catch (Exception e) {
        response.sendRedirect("addRep.jsp?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
    }
%>