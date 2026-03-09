package com.voting;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class VerifyOTPServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("resetPhone") == null) {
            response.sendRedirect("forgot-password.jsp?error=session_expired");
            return;
        }
        
        String phoneNumber = (String) session.getAttribute("resetPhone");
        String otp = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (otp == null || otp.trim().isEmpty() || 
            newPassword == null || newPassword.trim().isEmpty()) {
            response.sendRedirect("verify-otp.jsp?error=empty");
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("verify-otp.jsp?error=password_mismatch");
            return;
        }
        
        if (newPassword.length() < 6) {
            response.sendRedirect("verify-otp.jsp?error=password_short");
            return;
        }
        
        try {
            Connection conn = DBConnection.getConnection();
            
            // Verify OTP
            String verifySql = "SELECT prt.id, prt.voter_id FROM password_reset_tokens prt " +
                             "WHERE prt.phone_number = ? AND prt.token = ? " +
                             "AND prt.expires_at > NOW() AND prt.used = FALSE " +
                             "ORDER BY prt.created_at DESC LIMIT 1";
            
            PreparedStatement verifyStmt = conn.prepareStatement(verifySql);
            verifyStmt.setString(1, phoneNumber);
            verifyStmt.setString(2, otp);
            ResultSet rs = verifyStmt.executeQuery();
            
            if (rs.next()) {
                int tokenId = rs.getInt("id");
                int voterId = rs.getInt("voter_id");
                
                // Update password
                String updateSql = "UPDATE voters SET password = ? WHERE id = ?";
                PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                updateStmt.setString(1, newPassword);
                updateStmt.setInt(2, voterId);
                int rowsUpdated = updateStmt.executeUpdate();
                
                if (rowsUpdated > 0) {
                    // Mark token as used
                    String markUsedSql = "UPDATE password_reset_tokens SET used = TRUE WHERE id = ?";
                    PreparedStatement markStmt = conn.prepareStatement(markUsedSql);
                    markStmt.setInt(1, tokenId);
                    markStmt.executeUpdate();
                    markStmt.close();
                    
                    // Clear session
                    session.removeAttribute("resetPhone");
                    session.removeAttribute("voterName");
                    
                    response.sendRedirect("voter-login.jsp?success=password_reset");
                } else {
                    response.sendRedirect("verify-otp.jsp?error=update_failed");
                }
                
                updateStmt.close();
            } else {
                response.sendRedirect("verify-otp.jsp?error=invalid_otp");
            }
            
            rs.close();
            verifyStmt.close();
            conn.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("verify-otp.jsp?error=exception");
        }
    }
}