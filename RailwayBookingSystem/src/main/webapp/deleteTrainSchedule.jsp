<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.cs527.pkg.ApplicationDB" %>

<%
    int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));

    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        String deleteQuery = "DELETE FROM train_schedule WHERE schedule_id = ?";
        PreparedStatement pst = con.prepareStatement(deleteQuery);
        pst.setInt(1, scheduleId);
        pst.executeUpdate();
        db.closeConnection(con);
        response.sendRedirect("manageTrainSchedules.jsp");
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
