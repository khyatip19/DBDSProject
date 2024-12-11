<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page import="java.util.List, java.util.ArrayList, java.util.Map, java.util.HashMap, java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Browse Questions</title>
</head>
<body>
    <h1>Browse Questions</h1>

    <form method="get">
        <label for="keyword">Search by Keyword:</label>
        <input type="text" id="keyword" name="keyword" placeholder="Enter keyword">
        <input type="submit" value="Search">
    </form>

    <hr/>

    <%
        String keyword = request.getParameter("keyword"); // Get the keyword from the request
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            // Establish database connection
            ApplicationDB db = new ApplicationDB();
            con = db.getConnection();

            // Prepare the query with keyword matching
            String query = "SELECT question_id, customer_username, employee_username, question_text, answer_text, ask_date, answer_date " +
                           "FROM Question WHERE question_text LIKE ?";
            pst = con.prepareStatement(query);
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                pst.setString(1, "%" + keyword.trim() + "%"); // Add wildcards for keyword matching
            } else {
                pst.setString(1, "%"); // If no keyword, match all questions
            }

            rs = pst.executeQuery();

            if (rs.isBeforeFirst()) {
                %>
                <table border="1">
                    <tr>
                        <th>Question ID</th>
                        <th>Customer Username</th>
                        <th>Employee Username</th>
                        <th>Question</th>
                        <th>Answer</th>
                        <th>Ask Date</th>
                        <th>Answer Date</th>
                    </tr>
                <%
                while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("question_id") %></td>
                        <td><%= rs.getString("customer_username") %></td>
                        <td><%= rs.getString("employee_username") %></td>
                        <td><%= rs.getString("question_text") %></td>
                        <td><%= rs.getString("answer_text") != null ? rs.getString("answer_text") : "Not Answered" %></td>
                        <td><%= rs.getDate("ask_date") %></td>
                        <td><%= rs.getDate("answer_date") != null ? rs.getDate("answer_date") : "Not Answered" %></td>
                    </tr>
                    <%
                }
                %>
                </table>
                <%
            } else {
                %>
                <p>No questions found matching your keyword.</p>
                <%
            }

        } catch (Exception e) {
            e.printStackTrace();
            %>
            <p>Error: <%= e.getMessage() %></p>
            <%
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (pst != null) try { pst.close(); } catch (Exception e) {}
            if (con != null) try { con.close(); } catch (Exception e) {}
        }
    %>
</body>
</html>
