package com.voting;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class CandidateManagementServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("admin-login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String candidateId = request.getParameter("candidateId");
        String adminName = (String) session.getAttribute("adminName");

        if (action == null || candidateId == null) {
            response.sendRedirect("manage-candidates.jsp?error=invalid");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "";
            String successMessage = "";
            String errorMessage = "";

            switch (action) {
                case "approve":
                    // First get candidate details to set up login
                    String getCandidateSql = "SELECT email, name, password FROM candidates WHERE id = ?";
                    ps = conn.prepareStatement(getCandidateSql);
                    ps.setInt(1, Integer.parseInt(candidateId));
                    rs = ps.executeQuery();
                    
                    if (rs.next()) {
                        String candidateEmail = rs.getString("email");
                        String candidateName = rs.getString("name");
                        String currentPassword = rs.getString("password");
                        
                        // Close current result set and statement
                        rs.close();
                        ps.close();
                        
                        // Enable login and set status to approved
                        sql = "UPDATE candidates SET status = 'Approved', login_enabled = TRUE WHERE id = ?";
                        ps = conn.prepareStatement(sql);
                        ps.setInt(1, Integer.parseInt(candidateId));
                        
                        int rowsAffected = ps.executeUpdate();
                        
                        if (rowsAffected > 0) {
                            // Log the approval for admin reference
                            System.out.println("Candidate approved by " + adminName + ": " + candidateName + " (" + candidateEmail + ")");
                            System.out.println("Login enabled with existing password");
                            
                            successMessage = "Candidate '" + candidateName + "' approved successfully. Login has been enabled.";
                        } else {
                            errorMessage = "Failed to approve candidate.";
                        }
                    } else {
                        errorMessage = "Candidate not found.";
                    }
                    break;
                    
                case "reject":
                    // Get candidate info before rejection
                    String getRejectCandidateSql = "SELECT name, email FROM candidates WHERE id = ?";
                    ps = conn.prepareStatement(getRejectCandidateSql);
                    ps.setInt(1, Integer.parseInt(candidateId));
                    rs = ps.executeQuery();
                    
                    if (rs.next()) {
                        String candidateName = rs.getString("name");
                        String candidateEmail = rs.getString("email");
                        
                        rs.close();
                        ps.close();
                        
                        sql = "UPDATE candidates SET status = 'Rejected', login_enabled = FALSE WHERE id = ?";
                        ps = conn.prepareStatement(sql);
                        ps.setInt(1, Integer.parseInt(candidateId));
                        int rowsAffected = ps.executeUpdate();
                        
                        if (rowsAffected > 0) {
                            System.out.println("Candidate rejected by " + adminName + ": " + candidateName + " (" + candidateEmail + ")");
                            successMessage = "Candidate '" + candidateName + "' application rejected.";
                        } else {
                            errorMessage = "Failed to reject candidate.";
                        }
                    }
                    break;
                    
                case "delete":
                    // First get candidate info for logging
                    String getInfoSql = "SELECT name, email FROM candidates WHERE id = ?";
                    ps = conn.prepareStatement(getInfoSql);
                    ps.setInt(1, Integer.parseInt(candidateId));
                    rs = ps.executeQuery();
                    
                    if (rs.next()) {
                        String candidateName = rs.getString("name");
                        String candidateEmail = rs.getString("email");
                        
                        rs.close();
                        ps.close();
                        
                        // Delete candidate
                        sql = "DELETE FROM candidates WHERE id = ?";
                        ps = conn.prepareStatement(sql);
                        ps.setInt(1, Integer.parseInt(candidateId));
                        
                        int deleteRows = ps.executeUpdate();
                        
                        if (deleteRows > 0) {
                            // Also delete any associated password reset tokens
                            String deleteTokensSql = "DELETE FROM candidate_password_reset_tokens WHERE candidate_id = ?";
                            PreparedStatement deleteTokensStmt = conn.prepareStatement(deleteTokensSql);
                            deleteTokensStmt.setInt(1, Integer.parseInt(candidateId));
                            deleteTokensStmt.executeUpdate();
                            deleteTokensStmt.close();
                            
                            // Delete any votes for this candidate
                            String deleteVotesSql = "DELETE FROM votes WHERE candidate_id = ?";
                            PreparedStatement deleteVotesStmt = conn.prepareStatement(deleteVotesSql);
                            deleteVotesStmt.setInt(1, Integer.parseInt(candidateId));
                            deleteVotesStmt.executeUpdate();
                            deleteVotesStmt.close();
                            
                            System.out.println("Candidate deleted by " + adminName + ": " + candidateName + " (" + candidateEmail + ")");
                            successMessage = "Candidate '" + candidateName + "' deleted successfully.";
                        } else {
                            errorMessage = "Failed to delete candidate.";
                        }
                    } else {
                        errorMessage = "Candidate not found.";
                    }
                    break;
                    
                case "enable_login":
                    // Get candidate info
                    String getEnableCandidateSql = "SELECT name, email FROM candidates WHERE id = ?";
                    ps = conn.prepareStatement(getEnableCandidateSql);
                    ps.setInt(1, Integer.parseInt(candidateId));
                    rs = ps.executeQuery();
                    
                    if (rs.next()) {
                        String candidateName = rs.getString("name");
                        String candidateEmail = rs.getString("email");
                        
                        rs.close();
                        ps.close();
                        
                        sql = "UPDATE candidates SET login_enabled = TRUE WHERE id = ?";
                        ps = conn.prepareStatement(sql);
                        ps.setInt(1, Integer.parseInt(candidateId));
                        int enableRows = ps.executeUpdate();
                        
                        if (enableRows > 0) {
                            System.out.println("Candidate login enabled by " + adminName + ": " + candidateName + " (" + candidateEmail + ")");
                            successMessage = "Candidate '" + candidateName + "' login enabled successfully.";
                        } else {
                            errorMessage = "Failed to enable candidate login.";
                        }
                    }
                    break;
                    
                case "disable_login":
                    // Get candidate info
                    String getDisableCandidateSql = "SELECT name, email FROM candidates WHERE id = ?";
                    ps = conn.prepareStatement(getDisableCandidateSql);
                    ps.setInt(1, Integer.parseInt(candidateId));
                    rs = ps.executeQuery();
                    
                    if (rs.next()) {
                        String candidateName = rs.getString("name");
                        String candidateEmail = rs.getString("email");
                        
                        rs.close();
                        ps.close();
                        
                        sql = "UPDATE candidates SET login_enabled = FALSE WHERE id = ?";
                        ps = conn.prepareStatement(sql);
                        ps.setInt(1, Integer.parseInt(candidateId));
                        int disableRows = ps.executeUpdate();
                        
                        if (disableRows > 0) {
                            System.out.println("Candidate login disabled by " + adminName + ": " + candidateName + " (" + candidateEmail + ")");
                            successMessage = "Candidate '" + candidateName + "' login disabled successfully.";
                        } else {
                            errorMessage = "Failed to disable candidate login.";
                        }
                    }
                    break;
                    
                case "reset_password":
                    // Get candidate info
                    String getResetCandidateSql = "SELECT name, email FROM candidates WHERE id = ?";
                    ps = conn.prepareStatement(getResetCandidateSql);
                    ps.setInt(1, Integer.parseInt(candidateId));
                    rs = ps.executeQuery();
                    
                    if (rs.next()) {
                        String candidateName = rs.getString("name");
                        String candidateEmail = rs.getString("email");
                        
                        rs.close();
                        ps.close();
                        
                        // Reset candidate password to a secure default
                        String defaultPassword = generateSecureDefaultPassword();
                        sql = "UPDATE candidates SET password = ? WHERE id = ?";
                        ps = conn.prepareStatement(sql);
                        ps.setString(1, defaultPassword);
                        ps.setInt(2, Integer.parseInt(candidateId));
                        int resetRows = ps.executeUpdate();
                        
                        if (resetRows > 0) {
                            System.out.println("Candidate password reset by " + adminName + ": " + candidateName + " (" + candidateEmail + ")");
                            System.out.println("New password: " + defaultPassword);
                            successMessage = "Candidate '" + candidateName + "' password reset successfully. New password: " + defaultPassword;
                        } else {
                            errorMessage = "Failed to reset candidate password.";
                        }
                    }
                    break;
                    
                default:
                    response.sendRedirect("manage-candidates.jsp?error=invalid_action");
                    return;
            }

            if (ps != null) {
                ps.close();
            }
            
            if (conn != null) {
                conn.close();
            }

            if (!successMessage.isEmpty()) {
                response.sendRedirect("manage-candidates.jsp?success=" + action + "&message=" + java.net.URLEncoder.encode(successMessage, "UTF-8"));
            } else if (!errorMessage.isEmpty()) {
                response.sendRedirect("manage-candidates.jsp?error=" + action + "_failed&message=" + java.net.URLEncoder.encode(errorMessage, "UTF-8"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Log the exception
            System.err.println("Exception in CandidateManagementServlet: " + e.getMessage());
            response.sendRedirect("manage-candidates.jsp?error=exception&message=" + java.net.URLEncoder.encode("An error occurred: " + e.getMessage(), "UTF-8"));
        } finally {
            // Close resources properly
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to manage candidates page for GET requests
        response.sendRedirect("manage-candidates.jsp");
    }
    
    // Helper method to generate secure passwords
    private String generateSecureDefaultPassword() {
        String upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        String lowerCase = "abcdefghijklmnopqrstuvwxyz";
        String digits = "0123456789";
        String specialChars = "!@#$%^&*";
        
        StringBuilder password = new StringBuilder();
        
        // Ensure at least one of each required character type
        password.append(upperCase.charAt((int) (Math.random() * upperCase.length()))); // Uppercase
        password.append(lowerCase.charAt((int) (Math.random() * lowerCase.length()))); // Lowercase
        password.append(digits.charAt((int) (Math.random() * digits.length()))); // Digit
        password.append(specialChars.charAt((int) (Math.random() * specialChars.length()))); // Special char
        
        // Add remaining characters from all character sets
        String allChars = upperCase + lowerCase + digits + specialChars;
        for (int i = 0; i < 4; i++) {
            int randomIndex = (int) (Math.random() * allChars.length());
            password.append(allChars.charAt(randomIndex));
        }
        
        // Shuffle the password to make it more random
        char[] passwordArray = password.toString().toCharArray();
        for (int i = passwordArray.length - 1; i > 0; i--) {
            int j = (int) (Math.random() * (i + 1));
            char temp = passwordArray[i];
            passwordArray[i] = passwordArray[j];
            passwordArray[j] = temp;
        }
        
        return new String(passwordArray);
    }
    
    // Helper method to validate candidate ID
    private boolean isValidCandidateId(String candidateId) {
        if (candidateId == null || candidateId.trim().isEmpty()) {
            return false;
        }
        try {
            int id = Integer.parseInt(candidateId);
            return id > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }
    
    // Helper method to log admin actions
    private void logAdminAction(String adminName, String action, String candidateInfo, boolean success) {
        String logMessage = String.format("Admin action - Admin: %s, Action: %s, Candidate: %s, Success: %s", 
            adminName, action, candidateInfo, success);
        System.out.println(logMessage);
    }
}