<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.math.BigDecimal" %> <!-- Add this import for BigDecimal -->

<html>
<head>
    <title>Reservation</title>
    <style>
        form { width: 50%; margin: 0 auto; }
        label { display: block; margin: 10px 0 5px; }
        input, select { width: 100%; padding: 8px; margin-bottom: 15px; }
        input[type="submit"] { width: auto; }
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
    <h3>Booking Details</h3>
    <p><strong>Schedule ID:</strong> <%= scheduleId %></p>
    <p><strong>Origin:</strong> <%= origin %></p>
    <p><strong>Destination:</strong> <%= destination %></p>
    <p><strong>Travel Date:</strong> <%= travelDate %></p>
    <p><strong>Departure Time:</strong> <%= departTime %></p>
    <p><strong>Arrival Time:</strong> <%= arrivalTime %></p>
    <p><strong>Travel Time:</strong> <%= travelTime %> minutes</p>
    <p><strong>Fare:</strong> $<%= fare %></p>

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
    <label for="roundTrip">Round Trip</label>
    <input type="checkbox" id="roundTrip" name="roundTrip" value="true">
    <br><br>

    <!-- Return Journey Fields -->
    <div id="returnJourneySection" style="display:none;">
        <label for="returnDate">Return Date:</label>
        <input type="date" id="returnDate" name="returnDate">
        <br>
    </div>
 <br>
       
        
        <label for="disability">Do you have a disability?</label>
        <input type="checkbox" id="disability" name="disability"><br><br>

        <!-- Submit button -->
        <input type="submit" value="Proceed to Payment" />
    </form>
    <!-- JavaScript to Toggle Return Journey Section -->
<script>
    document.getElementById('roundTrip').addEventListener('change', function() {
        const returnJourneySection = document.getElementById('returnJourneySection');
        // Show or hide the return journey section based on checkbox state
        if (this.checked) {
            returnJourneySection.style.display = 'block';
        } else {
            returnJourneySection.style.display = 'none';
        }
    });
</script>
</body>
</html>