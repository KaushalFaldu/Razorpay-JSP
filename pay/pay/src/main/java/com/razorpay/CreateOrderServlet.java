package com.razorpay;
import org.json.JSONObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CreateOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Create an instance of the Razorpay client
            RazorpayClient razorpay = new RazorpayClient("rzp_test_J1SjHS1VvCg3ua", "4VD93ayMyDxtVl84tHvmeduP");

            // Prepare the order details as a JSON object
            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", 50000); // amount in the smallest currency unit
            orderRequest.put("currency", "INR");
            orderRequest.put("receipt", "order_" + UUID.randomUUID().toString().substring(0, 10)); // Use first 10 characters of UUID
//            orderRequest.put("payment_capture", 1);


            // Create the order using the Razorpay API
            Order order = razorpay.orders.create(orderRequest);

            // Get the order ID from the order object
            String orderId = order.get("id").toString();

            // Set the response content type
            response.setContentType("text/html");

            // Get the writer
            PrintWriter out = response.getWriter();

            // Write the order ID to the response
            out.println(orderId);
        } catch (RazorpayException e) {
            // Handle exceptions
            e.printStackTrace();
        }
    }
}
