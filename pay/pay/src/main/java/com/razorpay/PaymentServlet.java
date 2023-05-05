package com.razorpay;

import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String amount = request.getParameter("amount");

        // Initialize Razorpay client with your key and secret
        RazorpayClient client = null;
        try {
            client = new RazorpayClient("rzp_test_J1SjHS1VvCg3ua", "4VD93ayMyDxtVl84tHvmeduP");
        } catch (RazorpayException e) {
            throw new RuntimeException(e);
        }

        // Create a payment object
        Map<String, Object> paymentRequest = new HashMap<String, Object>();
        paymentRequest.put("amount", Integer.parseInt(amount) * 100); // amount in paise
        paymentRequest.put("currency", "INR");
        paymentRequest.put("receipt", "order_rcptid_11");
        paymentRequest.put("payment_capture", 1); // auto capture

        try {
            Payment payment = client.payments.createUpi((JSONObject) paymentRequest);
            String paymentId = payment.get("id").toString();
            String paymentAmount = payment.get("amount").toString();

            // Set payment id and amount as attributes to be used later
            request.setAttribute("payment_id", paymentId);
            request.setAttribute("payment_amount", paymentAmount);

            // Create a JSON object with the payment id and amount
            Map<String, String> responseData = new HashMap<String, String>();
            responseData.put("key", "rzp_test_J1SjHS1VvCg3ua");
            responseData.put("amount", paymentAmount);
            responseData.put("currency", "INR");

            // Send the JSON object as a response
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(responseData);
            out.flush();

        } catch (RazorpayException e) {
            e.printStackTrace();
        }
    }
}
