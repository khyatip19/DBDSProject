<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs527.pkg.*" %>
<%@ page import="java.io.*, java.sql.*, jakarta.servlet.http.*, jakarta.servlet.*" %>

<%
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Customer Representatives</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <style>
        .main-container {
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        
        .title {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .add-new-button {
            display: block;
            width: 100%;
            padding: 12px;
            background-color: #333;
            color: white;
            text-align: center;
            text-decoration: none;
            border-radius: 5px;
            margin-bottom: 30px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        .action-buttons a {
            display: inline-block;
            padding: 6px 12px;
            margin: 0 5px;
            background-color: #333;
            color: white;
            text-decoration: none;
            border-radius: 3px;
        }
        
        .back-button {
            display: inline-block;
            padding: 10px 20px;
            margin-top: 20px;
            background-color: #333;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .error-message {
		    color: #721c24;
		    background-color: #f8d7da;
		    border: 1px solid #f5c6cb;
		    padding: 10px;
		    margin: 10px 0;
		    border-radius: 4px;
		}
		
		.success-message {
		    color: #155724;
		    background-color: #d4edda;
		    border: 1px solid #c3e6cb;
		    padding: 10px;
		    margin: 10px 0;
		    border-radius: 4px;
		}
		
		.link-button {
		    display: inline-block;
		    padding: 5px 10px;
		    margin: 2px;
		    background-color: #333;
		    color: white;
		    text-decoration: none;
		    border-radius: 3px;
		}
		
		.link-button:hover {
		    background-color: #555;
		}
    </style>
</head>
<body>
    <div class="main-container">
        <h2 class="title">Manage Customer Representatives</h2>
 
		<%
		    String error = request.getParameter("error");
		    String success = request.getParameter("success");
		    if(error != null) {
		        out.println("<div class='error-message'>" + error + "</div>");
		    }
		    if(success != null) {
		        String message = success.equals("deleted") ? 
		            "Representative successfully deleted." : 
		            "Operation completed successfully.";
		        out.println("<div class='success-message'>" + message + "</div>");
		    }
		%>

        <a href="addRep.jsp" class="add-new-button">Add New Representative</a>

        <h3>Current Representatives</h3>
        <table>
            <tr>
                <th>Name</th>
                <th>Username</th>
                <th>Phone</th>
                <th>Actions</th>
            </tr>
            <%
                try {
                    ApplicationDB db = new ApplicationDB();
                    Connection con = db.getConnection();
                    
                    /* String query = "SELECT p.*, e.phone_no FROM Person p " +
                                 "JOIN Employee e ON p.username = e.username " +
                                 "WHERE e.role = 'customer_rep'"; */
                    
                    String query = "SELECT DISTINCT p.username, p.first_name, p.last_name, e.phone_no " +
                                   "FROM Person p " +
                                   "JOIN Employee e ON p.username = e.username " +
                                   "WHERE e.role = 'customer_rep' " +
                                   "ORDER BY p.first_name, p.last_name";
                    
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery(query);
                    
                    while(rs.next()) {
            %>
                        <tr>
                            <td><%= rs.getString("first_name") + " " + rs.getString("last_name") %></td>
                            <td><%= rs.getString("username") %></td>
                            <td><%= rs.getString("phone_no") %></td>
                            <td class="action-buttons">
                                <a href="editRep.jsp?id=<%= rs.getString("username") %>">Edit</a>
                                <%-- <a href="deleteRep.jsp?id=<%= rs.getString("username") %>" 
                                   onclick="return confirm('Are you sure you want to delete this representative?')">Delete</a> --%>
                                   
								<a href="javascript:void(0);" 
								       onclick="if(confirm('Are you sure you want to delete this representative?')) 
								       window.location.href='deleteRep.jsp?id=<%= rs.getString("username") %>'" 
								       class="link-button">Delete</a>                                
                                
                            </td>
                        </tr>
            <%
                    }
                    db.closeConnection(con);
                } catch(Exception e) {
                    out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>

        <a href="adminDashboard.jsp" class="back-button">Back to Dashboard</a>
    </div>
</body>
</html>