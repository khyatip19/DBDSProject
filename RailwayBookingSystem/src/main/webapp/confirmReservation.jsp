<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.math.BigDecimal" %> <!-- Add this import for BigDecimal -->

<!DOCTYPE html>
<html>
<head>
    <title>Reservation Confirmation</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        .confirmation {
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 8px;
            max-width: 600px;
            margin: auto;
            background-color: #f9f9f9;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .button {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            text-align: center;
            display: inline-block;
            border-radius: 4px;
            font-size: 16px;
            margin-top: 20px;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="confirmation">
        <h2>Reservation Confirmation</h2>
        <%
            String name = request.getParameter("customerName");
            String age = request.getParameter("customerAge");
            String scheduleId = request.getParameter("schedule_id");
            String origin = request.getParameter("origin_station");
            String destination = request.getParameter("destination_station");
            String departTime = request.getParameter("depart_datetime");
            String arrivalTime = request.getParameter("arrival_datetime");
            String fare = request.getParameter("fare");
            String st1id = request.getParameter("st1id");
            String st2id = request.getParameter("st2id");
            String disability = request.getParameter("disability");
            String roundTrip = request.getParameter("roundTrip"); 
			
            BigDecimal finalFare = new BigDecimal(fare);
            boolean isDiscounted = false;
            if (disability != null || Integer.parseInt(age) < 14 || Integer.parseInt(age) > 60) {
                isDiscounted = true;
                finalFare = finalFare.multiply(new BigDecimal("0.90")); // 10% discount
            }

            
            String departTimeWithoutMilliseconds = departTime.split(" ")[1].split("\\.")[0]; // e.g., "08:00:00"


            // Generate a unique reservation number
            int reservationNumber = (int) (Math.random() * 1000000);

            // Insert the reservation into the database
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/railwaybookingsystem", "root", "password")) {
                String insertQuery = "INSERT INTO Reservation (reservation_number, username, schedule_id, reservation_date, total_fare, origin, destination, depart_date, departure_time, discount, ticket_type) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement pstmt = conn.prepareStatement(insertQuery);
                
                String username = (String) session.getAttribute("username");

                pstmt.setInt(1, reservationNumber);
                pstmt.setString(2, username); // Replace this with actual username from session
                pstmt.setInt(3, Integer.parseInt(scheduleId));
                pstmt.setDate(4, Date.valueOf(LocalDate.now())); // Current date
                pstmt.setBigDecimal(5, finalFare);
                pstmt.setInt(6, Integer.parseInt(st1id));
                pstmt.setInt(7, Integer.parseInt(st1id));
                pstmt.setDate(8, Date.valueOf(departTime.split(" ")[0])); // Depart date
                pstmt.setTime(9, Time.valueOf(departTimeWithoutMilliseconds));
                pstmt.setBigDecimal(10, finalFare);
                pstmt.setString(11, "One-way"); // Default ticket type, update if needed

                pstmt.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p>Error: Unable to complete reservation.</p>");
            }
        %>

        <p>Thank you, <b><%= name %></b>! Your reservation has been successfully made.</p>
        <p><b>Reservation Number:</b> <%= reservationNumber %></p>
        <table>
            <tr>
                <th>Origin</th>
                <td><%= origin %></td>
            </tr>
            <tr>
                <th>Destination</th>
                <td><%= destination %></td>
            </tr>
            <tr>
                <th>Departure Time</th>
                <td><%= departTime %></td>
            </tr>
            <tr>
                <th>Arrival Time</th>
                <td><%= arrivalTime %></td>
            </tr>
            <tr>
                <th>Fare</th>
                <td>$<%= finalFare %></td>
            </tr>
        </table>

        <a href="welcome.jsp" class="button">Back to Home</a>
    </div>
</body>
</html>
