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
<html>
<head>
    <title>Search Questions</title>
</head>
<body>
    <h1>Search Questions</h1>
    <form method="get">
        <label>Keyword:</label>
        <input type="text" name="keyword">
        <input type="submit" value="Search">
    </form>

    <% if (results.size() > 0) { %>
        <table border="1">
            <tr>
                <th>Question</th>
                <th>Answer</th>
            </tr>
            <% for (String[] qa : results) { %>
                <tr>
                    <td><%= qa[0] %></td>
                    <td><%= qa[1] %></td>
                </tr>
            <% } %>
        </table>
    <% } else if (keyword != null) { %>
        <p>No results found for "<%= keyword %>".</p>
    <% } %>
</body>
</html>
