<script>
    $('form').submit(function(event) {
        event.preventDefault();
        var name = $('#name').val();
        var email = $('#email').val();
        var amount = $('#amount').val();
        $.ajax({
            url: "PaymentServlet",
            type: "post",
            data: {
                name: name,
                email: email,
                amount: amount
            },
            success: function(response) {
                var options = {
                    "key": response.key,
                    "amount": response.amount,
                    "currency": response.currency,
                    "name": "Razorpay Integration Demo",
                    "description": "Payment for " + name,
                    "image": "https://dummyimage.com/150x150/000/fff.png&text=Razorpay",
                    "handler": function (response){
                        window.location.href = "PaymentStatusServlet?payment_id=" + response.razorpay_payment_id;
                    },
                    "prefill": {
                        "name": name,
                        "email": email
                    }
                };
                var rzp1 = new Razorpay(options);
                rzp1.open();
            },
            error: function(xhr, status, error) {
                console.log(xhr.responseText);
            }
        });
    });
</script>
