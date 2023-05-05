<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Razorpay Integration Demo</title>
    <!-- Import required libraries -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
</head>
<body>
<h1>Razorpay Integration</h1>
<!-- Payment form -->


<script>
    $(document).ready(function() {
        // When the payment form is submitted
        $('form').submit(function(event) {
            // Prevent the default form submission behavior
            event.preventDefault();
            // Get form data
            var name = $('#name').val();
            var email = $('#email').val();
            var amount = $('#amount').val();
            // Send form data to the server
            $.ajax({
                url: "PaymentServlet",
                type: "post",
                data: {
                    name: name,
                    email: email,
                    amount: amount
                },
                // If the server responds with success
                success: function(response) {
                    try {
                        // Parse the JSON response
                        var responseData = JSON.parse(response);
                        // Create options for the Razorpay checkout popup
                        var options = {
                            "key": responseData.key,
                            "amount": responseData.amount,
                            "currency": responseData.currency,
                            "name": "Razorpay Integration Demo",
                            "description": "Payment for " + name,
                            "image": "https://dummyimage.com/150x150/000/fff.png&text=Razorpay",
                            "handler": function (response){
                                // Redirect to the payment status page with the payment ID
                                window.location.href = "PaymentStatusServlet?payment_id=" + response.razorpay_payment_id;
                            },
                            "prefill": {
                                "name": name,
                                "email": email
                            }
                        };
                        // Initialize the Razorpay checkout popup with the options
                        var rzp1 = new Razorpay(options);
                        rzp1.open();
                    } catch (e) {
                        console.log("Error parsing response: " + response);
                    }
                },
                // If the server responds with an error
                error: function(xhr, status, error) {
                    console.log("Error: " + xhr.responseText);
                }
            });
        });
    });
</script>
</body>
</html>
