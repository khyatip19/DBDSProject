<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page import="java.util.List, java.util.ArrayList, java.util.Map, java.util.HashMap, java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Questions</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .container {
            background: #ffffff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 90%;
            max-width: 1200px;
            margin-top: 20px;
        }

        h1 {
            color: #333333;
            font-size: 24px;
            text-align: center;
            margin-bottom: 20px;
        }

        form {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 20px;
        }

        form input[type="text"] {
            width: 50%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }

        form input[type="submit"] {
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
        }

        form input[type="submit"]:hover {
            background-color: #0056b3;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: white;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border: 1px solid #ddd;
        }

        th {
            background-color: #007bff;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        .no-results {
            text-align: center;
            color: #666;
            margin-top: 20px;
        }

        .error-message {
            color: #e74c3c;
            margin-top: 20px;
            text-align: center;
        }

        .button-container {
            text-align: center;
            margin-top: 20px;
        }

        .link-button {
            display: inline-block;
            padding: 10px 20px;
            color: #ffffff;
            background-color: #007bff;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            font-size: 14px;
            margin: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .link-button:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Browse Questions</h1>

        <form method="get">
            <input type="text" id="keyword" name="keyword" placeholder="Search by keyword">
            <input type="submit" value="Search">
        </form>

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
                    <table>
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
                    <p class="no-results">No questions found matching your keyword.</p>
                    <%
                }

            } catch (Exception e) {
                e.printStackTrace();
                %>
                <p class="error-message">Error: <%= e.getMessage() %></p>
                <%
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception e) {}
                if (pst != null) try { pst.close(); } catch (Exception e) {}
                if (con != null) try { con.close(); } catch (Exception e) {}
            }
        %>
        <div class="button-container">
            <a href="welcome.jsp" class="link-button">Back to Dashboard</a>
        </div>
    </div>
</body>
</html>
