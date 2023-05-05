<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.razorpay.*" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="com.razorpay.Order" %>
<%@ page import="com.razorpay.RazorpayClient" %>
<%@ page import="com.razorpay.RazorpayException" %>


<html>
<head>
    <title>Create Razorpay Order</title>
</head>
<body>
    <h1>Create Razorpay Order</h1>
    <%
        try {
            // Replace with your Razorpay Key ID and Secret Key
            RazorpayClient razorpay = new RazorpayClient("rzp_test_J1SjHS1VvCg3ua", "4VD93ayMyDxtVl84tHvmeduP");

            // Create a new order request
            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", 50000); // amount in the smallest currency unit
            orderRequest.put("currency", "INR");
            orderRequest.put("receipt", "order_rcptid_11");

            // Create the order using the Razorpay API
            Order order = razorpay.orders.create(orderRequest);

            // Display the order ID and amount
            out.println("<p>Order ID: " + order.get("id") + "</p>");
            out.println("<p>Amount: " + order.get("amount") + "</p>");

        } catch (RazorpayException e) {
            // Handle Exception
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    %>
    <button id="rzp-button1">Pay</button>
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <script>
    var options = {
        "key": "rzp_test_J1SjHS1VvCg3ua", // Enter the Key ID generated from the Dashboard
        "amount": "50000", // Amount is in currency subunits. Default currency is INR. Hence, 50000 refers to 50000 paise
        "currency": "INR",
        "name": "Acme Corp", //your business name
        "description": "Test Transaction",
        "image": "https://example.com/your_logo",
        "order_id": "order_Lm0ErsHSItfqFx", //This is a sample Order ID. Pass the `id` obtained in the response of Step 1
        "handler": function (response){
            alert(response.razorpay_payment_id);
            alert(response.razorpay_order_id);
            alert(response.razorpay_signature)
        },
        "prefill": {
            "name": "Kaushal Faldu",
            "email": "kaushalfaldu1610@gmail.com",
            "contact": "6353462654"
        },
        "notes": {
            "address": "Razorpay Corporate Office"
        },
        "theme": {
            "color": "#3399cc"
        }
    };
    var rzp1 = new Razorpay(options);
    rzp1.on('payment.failed', function (response){
            alert(response.error.code);
            alert(response.error.description);
            alert(response.error.source);
            alert(response.error.step);
            alert(response.error.reason);
            alert(response.error.metadata.order_id);
            alert(response.error.metadata.payment_id);
    });
    document.getElementById('rzp-button1').onclick = function(e){
        rzp1.open();
        e.preventDefault();
    }
    </script>
</body>
</html>
