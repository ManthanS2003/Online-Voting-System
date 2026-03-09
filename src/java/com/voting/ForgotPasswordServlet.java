package com.voting;

import java.io.IOException;
import java.sql.*;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class ForgotPasswordServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String phoneNumber = request.getParameter("phone");
        
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            response.sendRedirect("forgot-password.jsp?error=empty");
            return;
        }
        
        try {
            Connection conn = DBConnection.getConnection();
            
            // Check if voter exists with this phone number
            String checkSql = "SELECT id, name FROM voters WHERE mobile = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, phoneNumber);
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next()) {
                int voterId = rs.getInt("id");
                String voterName = rs.getString("name");
                
                // Generate 6-digit OTP
                String otp = generateOTP();
                
                // Store OTP in database
                String insertSql = "INSERT INTO password_reset_tokens (voter_id, phone_number, token, expires_at) VALUES (?, ?, ?, DATE_ADD(NOW(), INTERVAL 10 MINUTE))";
                PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                insertStmt.setInt(1, voterId);
                insertStmt.setString(2, phoneNumber);
                insertStmt.setString(3, otp);
                insertStmt.executeUpdate();
                
                // Send OTP via SMS
                boolean smsSent = sendOTPviaSMS(phoneNumber, otp, voterName);
                
                if (smsSent) {
                    // Store phone in session for verification
                    HttpSession session = request.getSession();
                    session.setAttribute("resetPhone", phoneNumber);
                    session.setAttribute("voterName", voterName);
                    
                    response.sendRedirect("verify-otp.jsp?success=otp_sent");
                } else {
                    response.sendRedirect("forgot-password.jsp?error=sms_failed");
                }
                
                insertStmt.close();
            } else {
                response.sendRedirect("forgot-password.jsp?error=not_found");
            }
            
            rs.close();
            checkStmt.close();
            conn.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("forgot-password.jsp?error=exception");
        }
    }
    
    private String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }
    
    private boolean sendOTPviaSMS(String phoneNumber, String otp, String voterName) {
        // Your existing SMS implementation
        System.out.println("SMS to " + phoneNumber + ": Hello " + voterName + 
                          ", your OTP for password reset is: " + otp + 
                          ". Valid for 10 minutes.");
        return true;
    }
}