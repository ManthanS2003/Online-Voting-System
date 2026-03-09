package com.voting;

import java.io.IOException;
import java.sql.*;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class CandidateForgotPasswordServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        
        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect("candidate-forgot-password.jsp?error=empty");
            return;
        }
        
        try {
            Connection conn = DBConnection.getConnection();

            String checkSql = "SELECT id, name FROM candidates WHERE email = ? AND status = 'Approved'";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next()) {
                int candidateId = rs.getInt("id");
                String candidateName = rs.getString("name");

                String otp = generateOTP();

                String insertSql = "INSERT INTO candidate_password_reset_tokens (candidate_id, email, token, expires_at) VALUES (?, ?, ?, DATE_ADD(NOW(), INTERVAL 10 MINUTE))";
                PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                insertStmt.setInt(1, candidateId);
                insertStmt.setString(2, email);
                insertStmt.setString(3, otp);
                insertStmt.executeUpdate();

                boolean emailSent = sendOTPviaEmail(email, otp, candidateName);
                
                if (emailSent) {

                    HttpSession session = request.getSession();
                    session.setAttribute("candidateResetEmail", email);
                    session.setAttribute("candidateName", candidateName);
                    
                    response.sendRedirect("candidate-verify-otp.jsp?success=otp_sent");
                } else {
                    response.sendRedirect("candidate-forgot-password.jsp?error=email_failed");
                }
                
                insertStmt.close();
            } else {
                response.sendRedirect("candidate-forgot-password.jsp?error=not_found");
            }
            
            rs.close();
            checkStmt.close();
            conn.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("candidate-forgot-password.jsp?error=exception");
        }
    }
    
    private String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }
    
    private boolean sendOTPviaEmail(String email, String otp, String candidateName) {

        System.out.println("Email to " + email + ": Hello " + candidateName + 
                          ", your OTP for password reset is: " + otp + 
                          ". Valid for 10 minutes.");
        return true;
    }
}