package com.voting;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class AddAdminServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("admin-login.jsp");
            return;
        }

        String adminName = request.getParameter("adminName");
        String adminPassword = request.getParameter("adminPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate inputs
        if (adminName == null || adminName.trim().isEmpty() || 
            adminPassword == null || adminPassword.trim().isEmpty()) {
            response.sendRedirect("admin-profile.jsp?add=failed");
            return;
        }

        // Check if passwords match
        if (!adminPassword.equals(confirmPassword)) {
            response.sendRedirect("admin-profile.jsp?add=failed");
            return;
        }

        // Sanitize inputs
        adminName = adminName.trim();
        adminPassword = adminPassword.trim();

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();

            // Check if admin username already exists
            String checkSql = "SELECT id FROM admins WHERE name = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, adminName);
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next()) {
                // Admin username already exists
                response.sendRedirect("admin-profile.jsp?add=duplicate");
                rs.close();
                checkStmt.close();
                conn.close();
                return;
            }
            rs.close();
            checkStmt.close();

            // Insert new admin
            String insertSql = "INSERT INTO admins (name, password) VALUES (?, ?)";
            PreparedStatement insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setString(1, adminName);
            insertStmt.setString(2, adminPassword);

            int rowsInserted = insertStmt.executeUpdate();
            insertStmt.close();
            conn.close();

            if (rowsInserted > 0) {
                response.sendRedirect("admin-profile.jsp?add=success");
            } else {
                response.sendRedirect("admin-profile.jsp?add=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-profile.jsp?add=failed");
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}