<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page import="java.util.List, java.util.ArrayList, java.util.Map, java.util.HashMap, java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Answer Question</title>
</head>
<body>
    <h1>Answer Customer Questions</h1>

    <%
        String message = "";
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            ApplicationDB db = new ApplicationDB();
            con = db.getConnection();

            // Fetch unanswered questions
            String fetchQuery = "SELECT question_id, customer_username, question_text, ask_date " +
                                "FROM Question WHERE answer_text IS NULL";
            pst = con.prepareStatement(fetchQuery);
            rs = pst.executeQuery();

            if (rs.isBeforeFirst()) {
                %>
                <form method="post">
                    <label for="questionId">Select Question:</label><br>
                    <select id="questionId" name="questionId" required>
                        <% while (rs.next()) { %>
                            <option value="<%= rs.getInt("question_id") %>">
                                Question ID: <%= rs.getInt("question_id") %> | Customer: <%= rs.getString("customer_username") %> | Question: <%= rs.getString("question_text") %>
                            </option>
                        <% } %>
                    </select><br><br>

                    <label for="answerText">Your Answer:</label><br>
                    <textarea id="answerText" name="answerText" rows="5" cols="40" required></textarea><br>
                    <input type="submit" value="Submit Answer">
                </form>
                <%
            } else {
                message = "No unanswered questions available.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (pst != null) try { pst.close(); } catch (Exception e) {}
            if (con != null) try { con.close(); } catch (Exception e) {}
        }

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            String answerText = request.getParameter("answerText");
            String repUsername = (String) session.getAttribute("username"); // Assume rep is logged in

            try {
                ApplicationDB db = new ApplicationDB();
                con = db.getConnection();

                // Update the question with the representative's answer
                String updateQuery = "UPDATE Question SET answer_text = ?, employee_username = ?, answer_date = CURDATE() " +
                                     "WHERE question_id = ?";
                pst = con.prepareStatement(updateQuery);
                pst.setString(1, answerText);
                pst.setString(2, repUsername);
                pst.setInt(3, questionId);
                pst.executeUpdate();

                message = "Answer submitted successfully!";
            } catch (Exception e) {
                e.printStackTrace();
                message = "Error: " + e.getMessage();
            } finally {
                if (pst != null) try { pst.close(); } catch (Exception e) {}
                if (con != null) try { con.close(); } catch (Exception e) {}
            }
        }
    %>

    <p><%= message %></p>
</body>
</html>