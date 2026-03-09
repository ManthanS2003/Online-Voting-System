package com.voting;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class CandidateLoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate inputs
        if (email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            response.sendRedirect("candidate-login.jsp?error=required");
            return;
        }

        // Sanitize inputs
        email = email.trim().toLowerCase();
        password = password.trim();

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();

            // Check candidate credentials with enhanced password verification
            String sql = "SELECT id, name, email, status, password, login_enabled, phone, party FROM candidates WHERE email = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                String dbPassword = rs.getString("password");
                String status = rs.getString("status");
                Boolean loginEnabled = rs.getBoolean("login_enabled");
                String candidateName = rs.getString("name");
                String candidateEmail = rs.getString("email");
                String candidatePhone = rs.getString("phone");
                String candidateParty = rs.getString("party");
                
                // Check if candidate is approved
                if (!"Approved".equals(status)) {
                    if ("Pending".equals(status)) {
                        response.sendRedirect("candidate-login.jsp?error=not_approved&email=" + java.net.URLEncoder.encode(email, "UTF-8"));
                    } else if ("Rejected".equals(status)) {
                        response.sendRedirect("candidate-login.jsp?error=rejected&email=" + java.net.URLEncoder.encode(email, "UTF-8"));
                    } else {
                        response.sendRedirect("candidate-login.jsp?error=not_approved&email=" + java.net.URLEncoder.encode(email, "UTF-8"));
                    }
                    return;
                }
                
                // Check if login is enabled
                if (loginEnabled != null && !loginEnabled) {
                    response.sendRedirect("candidate-login.jsp?error=login_disabled&email=" + java.net.URLEncoder.encode(email, "UTF-8"));
                    return;
                }
                
                // Check if password matches (handle null passwords)
                if (dbPassword != null && dbPassword.equals(password)) {
                    // Login successful - create session
                    HttpSession session = request.getSession();
                    session.setAttribute("candidateId", rs.getInt("id"));
                    session.setAttribute("candidateName", candidateName);
                    session.setAttribute("candidateEmail", candidateEmail);
                    session.setAttribute("candidatePhone", candidatePhone);
                    session.setAttribute("candidateParty", candidateParty);
                    
                    // Set session timeout to 30 minutes
                    session.setMaxInactiveInterval(30 * 60);
                    
                    // Log successful login
                    System.out.println("Candidate login successful: " + candidateName + " (" + candidateEmail + ")");
                    
                    response.sendRedirect("candidate-dashboard.jsp");
                } else {
                    // Invalid password - log failed attempt
                    System.out.println("Failed login attempt for candidate: " + email);
                    response.sendRedirect("candidate-login.jsp?error=invalid&email=" + java.net.URLEncoder.encode(email, "UTF-8"));
                }
            } else {
                // Candidate not found
                response.sendRedirect("candidate-login.jsp?error=not_found&email=" + java.net.URLEncoder.encode(email, "UTF-8"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Log the exception
            System.err.println("Exception during candidate login for email: " + email + " - " + e.getMessage());
            response.sendRedirect("candidate-login.jsp?error=exception");
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
        // Check if already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("candidateId") != null) {
            // Already logged in, redirect to dashboard
            response.sendRedirect("candidate-dashboard.jsp");
            return;
        }
        
        // Redirect to login page for GET requests
        response.sendRedirect("candidate-login.jsp");
    }
    
    // Helper method to validate email format
    private boolean isValidEmail(String email) {
        if (email == null) return false;
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        return email.matches(emailRegex);
    }
    
    // Helper method to log login attempts
    private void logLoginAttempt(String email, boolean success, String reason) {
        String logMessage = String.format("Candidate login attempt - Email: %s, Success: %s, Reason: %s", 
            email, success, reason);
        System.out.println(logMessage);
    }
}