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
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Send Question to Representative</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .form-container {
            background: #ffffff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 600px;
            text-align: center;
        }

        h1 {
            color: #333333;
            font-size: 24px;
            margin-bottom: 20px;
        }

        .message {
            color: #007bff;
            font-size: 16px;
            margin-bottom: 20px;
        }

        .error {
            color: #e74c3c;
        }

        form label {
            font-size: 16px;
            color: #555;
        }

        textarea {
            width: 100%;
            height: 100px;
            padding: 10px;
            margin-top: 10px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }

        input[type="submit"] {
            background-color: #007bff;
            color: #ffffff;
            border: none;
            border-radius: 4px;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }

        .link-button {
	    display: inline-block;
	    padding: 10px 20px;
	    color: #ffffff;
	    background-color: #007bff; /* Bootstrap primary color */
	    border-radius: 5px;
	    text-decoration: none;
	    font-weight: bold;
	    font-size: 14px;
	    margin: 10px;
	    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Subtle shadow */
	    transition: background-color 0.3s ease, transform 0.2s ease;
		}
		.link-button:hover {
	    background-color: #0056b3; /* Darker blue on hover */
	    transform: translateY(-2px); /* Lift effect */
	    text-decoration: none; /* Ensure no underline on hover */
		}
	
		.button-container {
		    text-align: center; /* Center-align buttons */
		    margin-top: 20px;
    </style>
</head>
<body>
    <div class="form-container">
        <h1>Send Question to Representative</h1>
        <% if (!message.isEmpty()) { %>
            <p class="<%= message.startsWith("Error") ? "error" : "message" %>"><%= message %></p>
        <% } %>
        <form method="post" action="sendQuestion.jsp">
            <label>Your Question:</label><br>
            <textarea name="question_text" placeholder="Type your question here..." required></textarea><br>
            <input type="submit" value="Send Question">
        </form>
        <a href="welcome.jsp" class="link-button">Back to Dashboard</a>
    </div>
</body>
</html>