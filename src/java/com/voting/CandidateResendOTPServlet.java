package com.voting;

import java.io.IOException;
import java.sql.*;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class CandidateResendOTPServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("candidateResetEmail") == null) {
            response.sendRedirect("candidate-forgot-password.jsp?error=session_expired");
            return;
        }
        
        String email = (String) session.getAttribute("candidateResetEmail");
        String candidateName = (String) session.getAttribute("candidateName");
        
        try {
            Connection conn = DBConnection.getConnection();
            
            // Generate new OTP
            String newOtp = generateOTP();
            
            // Get candidate ID
            String candidateSql = "SELECT id FROM candidates WHERE email = ? AND status = 'Approved'";
            PreparedStatement candidateStmt = conn.prepareStatement(candidateSql);
            candidateStmt.setString(1, email);
            ResultSet rs = candidateStmt.executeQuery();
            
            if (rs.next()) {
                int candidateId = rs.getInt("id");
                
                // Insert new OTP
                String insertSql = "INSERT INTO candidate_password_reset_tokens (candidate_id, email, token, expires_at) VALUES (?, ?, ?, DATE_ADD(NOW(), INTERVAL 10 MINUTE))";
                PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                insertStmt.setInt(1, candidateId);
                insertStmt.setString(2, email);
                insertStmt.setString(3, newOtp);
                insertStmt.executeUpdate();
                
                // Send new OTP
                boolean emailSent = sendOTPviaEmail(email, newOtp, candidateName);
                
                if (emailSent) {
                    response.sendRedirect("candidate-verify-otp.jsp?success=otp_resent");
                } else {
                    response.sendRedirect("candidate-verify-otp.jsp?error=email_failed");
                }
                
                insertStmt.close();
            }
            
            rs.close();
            candidateStmt.close();
            conn.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("candidate-verify-otp.jsp?error=exception");
        }
    }
    
    private String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }
    
    private boolean sendOTPviaEmail(String email, String otp, String candidateName) {
        System.out.println("Email to " + email + ": Hello " + candidateName + 
                          ", your new OTP for password reset is: " + otp + 
                          ". Valid for 10 minutes.");
        return true;
    }
}