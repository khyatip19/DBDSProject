<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page import="java.util.List, java.util.ArrayList, java.util.Map, java.util.HashMap, java.sql.*" %>

<%
    String message = "";
    String username = (String) session.getAttribute("username"); // Fetch username from session

    if (username == null || username.isEmpty()) {
        message = "Error: You must log in before sending a question.";
    } else if ("POST".equalsIgnoreCase(request.getMethod())) {
        String questionText = request.getParameter("question_text");

        if (questionText == null || questionText.trim().isEmpty()) {
            message = "Error: Question cannot be empty.";
        } else {
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();

                // Generate a unique question ID
                String getMaxIdQuery = "SELECT IFNULL(MAX(question_id), 0) + 1 AS next_id FROM Question";
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery(getMaxIdQuery);
                int nextId = 1;
                if (rs.next()) {
                    nextId = rs.getInt("next_id");
                }

                // Insert the question into the Question table
                String insertQuery = "INSERT INTO Question (question_id, customer_username, question_text, ask_date) VALUES (?, ?, ?, CURDATE())";
                PreparedStatement pst = con.prepareStatement(insertQuery);
                pst.setInt(1, nextId);
                pst.setString(2, username);
                pst.setString(3, questionText);
                pst.executeUpdate();

                message = "Your question has been submitted successfully!";
                db.closeConnection(con);
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
            }
        }
    }
%>
<html>
<head>
    <title>Send Question to Representative</title>
</head>
<body>
    <h1>Send Question to Representative</h1>
    <p><%= message %></p>
    <form method="post" action="sendQuestion.jsp">
        <label>Your Question:</label><br>
        <textarea name="question_text" rows="4" cols="50" required></textarea><br><br>
        <input type="submit" value="Send Question">
    </form>
</body>
</html>