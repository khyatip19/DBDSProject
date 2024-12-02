<%@ page import="jakarta.servlet.http.*" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<html>
<head>
    <title>Welcome</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <div class="form-container">
        <h2>Welcome, <%= username %>!</h2>
        <p class="subtitle">You are successfully logged in.</p>
        <p><a href="logout.jsp" class="link-button">Logout</a></p>
    </div>
</body>
</html>
