<%@ page language="java" import="java.sql.*, java.util.*, com.cs527.pkg.*" %>
<%
    String keyword = request.getParameter("keyword");
    List<String[]> results = new ArrayList<>();

    if (keyword != null) {
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();

            String query = "SELECT question_text, answer_text FROM Question WHERE question_text LIKE ?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, "%" + keyword + "%");
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                results.add(new String[] { rs.getString("question_text"), rs.getString("answer_text") });
            }

            db.closeConnection(con);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Questions</title>
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
            max-width: 800px;
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
            width: 80%;
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
        <h1>Search Questions</h1>
        <form method="get">
            <input type="text" name="keyword" placeholder="Enter keyword">
            <input type="submit" value="Search">
        </form>

        <% if (results.size() > 0) { %>
            <table>
                <thead>
                    <tr>
                        <th>Question</th>
                        <th>Answer</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (String[] qa : results) { %>
                        <tr>
                            <td><%= qa[0] %></td>
                            <td><%= qa[1] != null && !qa[1].trim().isEmpty() ? qa[1] : "Not Answered" %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else if (keyword != null) { %>
            <p class="no-results">No results found for "<%= keyword %>".</p>
        <% } %>
        <div class="button-container">
            <a href="welcome.jsp" class="link-button">Back to Dashboard</a>
        </div>
    </div>
</body>
</html>
