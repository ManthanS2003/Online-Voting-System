package com.voting;

import java.io.IOException;
import java.sql.*;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class ResendOTPServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("resetPhone") == null) {
            response.sendRedirect("forgot-password.jsp?error=session_expired");
            return;
        }
        
        String phoneNumber = (String) session.getAttribute("resetPhone");
        String voterName = (String) session.getAttribute("voterName");
        
        try {
            Connection conn = DBConnection.getConnection();
            
            // Generate new OTP
            String newOtp = generateOTP();
            
            // Get voter ID
            String voterSql = "SELECT id FROM voters WHERE mobile = ?";
            PreparedStatement voterStmt = conn.prepareStatement(voterSql);
            voterStmt.setString(1, phoneNumber);
            ResultSet rs = voterStmt.executeQuery();
            
            if (rs.next()) {
                int voterId = rs.getInt("id");
                
                // Insert new OTP
                String insertSql = "INSERT INTO password_reset_tokens (voter_id, phone_number, token, expires_at) VALUES (?, ?, ?, DATE_ADD(NOW(), INTERVAL 10 MINUTE))";
                PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                insertStmt.setInt(1, voterId);
                insertStmt.setString(2, phoneNumber);
                insertStmt.setString(3, newOtp);
                insertStmt.executeUpdate();
                
                // Send new OTP
                boolean smsSent = sendOTPviaSMS(phoneNumber, newOtp, voterName);
                
                if (smsSent) {
                    response.sendRedirect("verify-otp.jsp?success=otp_resent");
                } else {
                    response.sendRedirect("verify-otp.jsp?error=sms_failed");
                }
                
                insertStmt.close();
            }
            
            rs.close();
            voterStmt.close();
            conn.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("verify-otp.jsp?error=exception");
        }
    }
    
    private String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }
    
    private boolean sendOTPviaSMS(String phoneNumber, String otp, String voterName) {
        System.out.println("SMS to " + phoneNumber + ": Hello " + voterName + 
                          ", your new OTP for password reset is: " + otp + 
                          ". Valid for 10 minutes.");
        return true;
    }
}