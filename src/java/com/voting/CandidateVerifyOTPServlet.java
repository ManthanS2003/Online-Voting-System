package com.voting;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class CandidateVerifyOTPServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("candidateResetEmail") == null) {
            response.sendRedirect("candidate-forgot-password.jsp?error=session_expired");
            return;
        }
        
        String email = (String) session.getAttribute("candidateResetEmail");
        String otp = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (otp == null || otp.trim().isEmpty() || 
            newPassword == null || newPassword.trim().isEmpty()) {
            response.sendRedirect("candidate-verify-otp.jsp?error=empty");
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("candidate-verify-otp.jsp?error=password_mismatch");
            return;
        }
        
        if (newPassword.length() < 6) {
            response.sendRedirect("candidate-verify-otp.jsp?error=password_short");
            return;
        }
        
        try {
            Connection conn = DBConnection.getConnection();

            String verifySql = "SELECT cprt.id, cprt.candidate_id FROM candidate_password_reset_tokens cprt " +
                             "WHERE cprt.email = ? AND cprt.token = ? " +
                             "AND cprt.expires_at > NOW() AND cprt.used = FALSE " +
                             "ORDER BY cprt.created_at DESC LIMIT 1";
            
            PreparedStatement verifyStmt = conn.prepareStatement(verifySql);
            verifyStmt.setString(1, email);
            verifyStmt.setString(2, otp);
            ResultSet rs = verifyStmt.executeQuery();
            
            if (rs.next()) {
                int tokenId = rs.getInt("id");
                int candidateId = rs.getInt("candidate_id");

                String updateSql = "UPDATE candidates SET password = ? WHERE id = ?";
                PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                updateStmt.setString(1, newPassword);
                updateStmt.setInt(2, candidateId);
                int rowsUpdated = updateStmt.executeUpdate();
                
                if (rowsUpdated > 0) {

                    String markUsedSql = "UPDATE candidate_password_reset_tokens SET used = TRUE WHERE id = ?";
                    PreparedStatement markStmt = conn.prepareStatement(markUsedSql);
                    markStmt.setInt(1, tokenId);
                    markStmt.executeUpdate();
                    markStmt.close();

                    session.removeAttribute("candidateResetEmail");
                    session.removeAttribute("candidateName");
                    
                    response.sendRedirect("candidate-login.jsp?success=password_reset");
                } else {
                    response.sendRedirect("candidate-verify-otp.jsp?error=update_failed");
                }
                
                updateStmt.close();
            } else {
                response.sendRedirect("candidate-verify-otp.jsp?error=invalid_otp");
            }
            
            rs.close();
            verifyStmt.close();
            conn.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("candidate-verify-otp.jsp?error=exception");
        }
    }
}