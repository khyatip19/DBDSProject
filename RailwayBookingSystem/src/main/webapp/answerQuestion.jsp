<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Answer Question</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 20px;
            color: #333;
        }

        .form-container {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 600px;
            margin: 20px auto;
        }

        h1 {
            text-align: center;
            color: #007bff;
        }

        label {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
        }

        select, textarea, input[type="submit"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }

        textarea {
            resize: none;
        }

        input[type="submit"] {
            background-color: #007bff;
            color: white;
            font-weight: bold;
            cursor: pointer;
            border: none;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }

        .button-container {
            text-align: center;
            margin-top: 20px;
        }

        .link-button {
            display: inline-block;
            padding: 10px 20px;
            color: white;
            background-color: #007bff;
            border-radius: 4px;
            text-decoration: none;
            font-weight: bold;
            font-size: 14px;
            margin: 5px;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .link-button:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
            text-decoration: none;
        }

        .message {
            text-align: center;
            margin-top: 10px;
            padding: 10px;
            font-size: 16px;
        }

        .message.success {
            color: #28a745;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            border-radius: 4px;
        }

        .message.error {
            color: #e74c3c;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h1>Answer Customer Questions</h1>

        <%
            String message = ""; // Declare and initialize the message variable
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
            <label for="questionId">Select Question:</label>
            <select id="questionId" name="questionId" required>
                <% while (rs.next()) { %>
                    <option value="<%= rs.getInt("question_id") %>">
                        Question ID: <%= rs.getInt("question_id") %> | Customer: <%= rs.getString("customer_username") %> | Question: <%= rs.getString("question_text") %>
                    </option>
                <% } %>
            </select>

            <label for="answerText">Your Answer:</label>
            <textarea id="answerText" name="answerText" rows="5" required></textarea>

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

        <p class="message <%= message.contains("Error") ? "error" : "success" %>"><%= message %></p>

        <div class="button-container">
            <a href="repDashboard.jsp" class="link-button">Back to Dashboard</a>
        </div>
    </div>
</body>
</html>
