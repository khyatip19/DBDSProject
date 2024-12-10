<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.math.BigDecimal" %> <!-- Add this import for BigDecimal -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 20px;
            padding: 20px;
        }

        h2, h3 {
            text-align: center;
            color: #333;
        }

        form {
            width: 50%;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        label {
            display: block;
            margin: 10px 0 5px;
            font-weight: bold;
        }

        input, select {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }

        input[type="submit"] {
            width: auto;
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            font-size: 16px;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }

        p {
            font-size: 16px;
            color: #555;
        }

        .booking-details {
            width: 50%;
            margin: 0 auto 20px;
            padding: 20px;
            background-color: #fff;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .booking-details p {
            margin: 10px 0;
        }

        .center {
            text-align: center;
        }

        /* Align the checkboxes closer to the labels */
        input[type="checkbox"] {
            margin-right: 10px;  /* Adds a small space between checkbox and text */
        }

        .checkbox-label {
            display: inline-block;
            margin-left: 5px;
        }

    </style>
</head>
<body>
    <h2>Reservation</h2>

    <%
        // Retrieve parameters from the search schedule page
        String scheduleId = request.getParameter("scheduleId");
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String travelDate = request.getParameter("travelDate");
        String departTime = request.getParameter("departTime");
        String arrivalTime = request.getParameter("arrivalTime");
        String travelTime = request.getParameter("travelTime");
        String fare = request.getParameter("fare");
        String st1id = request.getParameter("st1id");
        String st2id = request.getParameter("st2id");

        // Validation: If required parameters are missing, redirect back to search page
        if (scheduleId == null || origin == null || destination == null || travelDate == null ||
            departTime == null || arrivalTime == null || travelTime == null || fare == null) {
            response.sendRedirect("searchSchedules.jsp");
        }
    %>

    <!-- Display reservation details -->
    <div class="booking-details">
        <h3>Booking Details</h3>
        <p><strong>Schedule ID:</strong> <%= scheduleId %></p>
        <p><strong>Origin:</strong> <%= origin %></p>
        <p><strong>Destination:</strong> <%= destination %></p>
        <p><strong>Travel Date:</strong> <%= travelDate %></p>
        <p><strong>Departure Time:</strong> <%= departTime %></p>
        <p><strong>Arrival Time:</strong> <%= arrivalTime %></p>
        <p><strong>Travel Time:</strong> <%= travelTime %> minutes</p>
        <p><strong>Fare:</strong> $<%= fare %></p>
    </div>

    <!-- Reservation form -->
    <form action="confirmReservation.jsp" method="post">
        <!-- Hidden fields to pass schedule info -->
        <input type="hidden" name="schedule_id" value="<%= scheduleId %>" />
        <input type="hidden" name="origin_station" value="<%= origin %>" />
        <input type="hidden" name="destination_station" value="<%= destination %>" />
        <input type="hidden" name="travelDate" value="<%= travelDate %>" />
        <input type="hidden" name="depart_datetime" value="<%= departTime %>" />
        <input type="hidden" name="arrival_datetime" value="<%= arrivalTime %>" />
        <input type="hidden" name="travelTime" value="<%= travelTime %>" />
        <input type="hidden" name="fare" value="<%= fare %>" />
        <input type="hidden" name="st1id" value="<%= st1id %>" />
        <input type="hidden" name="st2id" value="<%= st2id %>" />

        <!-- Input fields for customer details -->
        <label for="customerName">Customer Name:</label>
        <input type="text" id="customerName" name="customerName" placeholder="Enter your name" required />

        <label for="customerAge">Customer Age:</label>
        <input type="number" id="customerAge" name="customerAge" placeholder="Enter your age" min="1" required />

        <!-- Round-trip option -->
        <label for="roundTrip" class="checkbox-label">Round Trip:</label>
        <input type="checkbox" id="roundTrip" name="roundTrip" value="true"><br><br>

        <!-- Disability checkbox -->
        <label for="disability" class="checkbox-label">Do you have a disability?</label>
        <input type="checkbox" id="disability" name="disability"><br><br>

        <!-- Submit button -->
        <div class="center">
            <input type="submit" value="Proceed to Payment" />
        </div>
    </form>
</body>
</html>