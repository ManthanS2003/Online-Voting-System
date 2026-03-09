package com.voting;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class CandidateRegistrationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if candidate registration is enabled
        if (!isCandidateRegistrationEnabled()) {
            response.sendRedirect("candidate-register.jsp?error=disabled");
            return;
        }

        String candidateName = request.getParameter("candidateName");
        String candidateEmail = request.getParameter("candidateEmail");
        String candidatePhone = request.getParameter("candidatePhone");
        String candidateParty = request.getParameter("candidateParty");
        String candidateDescription = request.getParameter("candidateDescription");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate inputs
        if (candidateName == null || candidateName.trim().isEmpty() ||
            candidateEmail == null || candidateEmail.trim().isEmpty() ||
            candidatePhone == null || candidatePhone.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            response.sendRedirect("candidate-register.jsp?error=empty_fields");
            return;
        }

        // Validate email format
        if (!isValidEmail(candidateEmail)) {
            response.sendRedirect("candidate-register.jsp?error=invalid_email");
            return;
        }

        // Validate phone format (10 digits)
        if (!candidatePhone.matches("\\d{10}")) {
            response.sendRedirect("candidate-register.jsp?error=invalid_phone");
            return;
        }

        // Validate password match
        if (!password.equals(confirmPassword)) {
            response.sendRedirect("candidate-register.jsp?error=password_mismatch");
            return;
        }

        // Validate password strength
        if (!isStrongPassword(password)) {
            response.sendRedirect("candidate-register.jsp?error=password_weak");
            return;
        }

        // Sanitize inputs
        candidateName = candidateName.trim();
        candidateEmail = candidateEmail.trim().toLowerCase();
        candidatePhone = candidatePhone.trim();
        candidateParty = candidateParty != null ? candidateParty.trim() : "";
        candidateDescription = candidateDescription != null ? candidateDescription.trim() : "";
        password = password.trim();

        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement insertStmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();

            // Check if candidate email or phone already exists
            String checkSql = "SELECT id FROM candidates WHERE email = ? OR phone = ?";
            checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, candidateEmail);
            checkStmt.setString(2, candidatePhone);
            rs = checkStmt.executeQuery();
            
            if (rs.next()) {
                response.sendRedirect("candidate-register.jsp?error=duplicate");
                return;
            }
            rs.close();
            checkStmt.close();

            // Insert new candidate with user-provided password
            String insertSql = "INSERT INTO candidates (name, email, phone, party, description, status, votes, password, login_enabled) VALUES (?, ?, ?, ?, ?, 'Pending', 0, ?, FALSE)";
            insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setString(1, candidateName);
            insertStmt.setString(2, candidateEmail);
            insertStmt.setString(3, candidatePhone);
            insertStmt.setString(4, candidateParty);
            insertStmt.setString(5, candidateDescription);
            insertStmt.setString(6, password); // Use user-provided password
            
            int rowsInserted = insertStmt.executeUpdate();

            if (rowsInserted > 0) {
                // Log the registration for admin reference
                System.out.println("New candidate registered: " + candidateName + " (" + candidateEmail + ")");
                System.out.println("Password set by candidate during registration");
                
                response.sendRedirect("candidate-register.jsp?success=registered");
            } else {
                response.sendRedirect("candidate-register.jsp?error=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("candidate-register.jsp?error=exception");
        } finally {
            // Close resources properly
            try {
                if (rs != null) rs.close();
                if (checkStmt != null) checkStmt.close();
                if (insertStmt != null) insertStmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    private boolean isCandidateRegistrationEnabled() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT setting_value FROM system_settings WHERE setting_key = 'candidate_registration'";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return "enabled".equals(rs.getString("setting_value"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return false;
    }
    
    private boolean isValidEmail(String email) {
        // Basic email validation
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        return email != null && email.matches(emailRegex);
    }
    
    private boolean isStrongPassword(String password) {
        // Check password strength: at least 6 characters with uppercase, lowercase and number
        if (password.length() < 6) {
            return false;
        }
        
        boolean hasUpper = false;
        boolean hasLower = false;
        boolean hasDigit = false;
        
        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) hasUpper = true;
            if (Character.isLowerCase(c)) hasLower = true;
            if (Character.isDigit(c)) hasDigit = true;
        }
        
        return hasUpper && hasLower && hasDigit;
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to registration page for GET requests
        response.sendRedirect("candidate-register.jsp");
    }
}