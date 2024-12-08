<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="jakarta.servlet.http.*, jakarta.servlet.*" %>
<%
    String role = (String) session.getAttribute("role");
    if (!"Customer Representative".equals(role)) {
        response.sendRedirect("login.jsp?message=Unauthorized access.");
        return;
    }

    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Representative Dashboard</title>
</head>

<body>
    <h1>Welcome, <%= username %>!</h1>
    <p>This is your Customer Representative dashboard.</p>
    <a href="logout.jsp">Logout</a>
</body>
</html>
