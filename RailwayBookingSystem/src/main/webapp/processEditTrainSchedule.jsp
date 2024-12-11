<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.cs527.pkg.ApplicationDB" %>

<%
    int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
    String lineName = request.getParameter("lineName");
    String departTime = request.getParameter("departTime") + ":00";
    String arriveTime = request.getParameter("arriveTime") + ":00";
    int travelTime = Integer.parseInt(request.getParameter("travelTime"));
    double fare = Double.parseDouble(request.getParameter("fare"));

    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        String updateQuery = "UPDATE train_schedule SET line_name = ?, depart_datetime = ?, " +
                             "arrival_datetime = ?, travel_time = ?, fare = ? WHERE schedule_id = ?";
        PreparedStatement pst = con.prepareStatement(updateQuery);
        pst.setString(1, lineName);
        pst.setString(2, departTime);
        pst.setString(3, arriveTime);
        pst.setInt(4, travelTime);
        pst.setDouble(5, fare);
        pst.setInt(6, scheduleId);
        pst.executeUpdate();
        db.closeConnection(con);
        response.sendRedirect("manageTrainSchedules.jsp");
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
