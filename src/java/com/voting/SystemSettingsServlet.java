package com.voting;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class SystemSettingsServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("admin-login.jsp");
            return;
        }

        // Get parameters with proper handling for unchecked checkboxes
        String candidateRegistration = "disabled";
        String votingEnabled = "disabled";

        // Check if checkboxes are checked (they send "enabled" when checked)
        if ("enabled".equals(request.getParameter("candidate_registration"))) {
            candidateRegistration = "enabled";
        }
        if ("enabled".equals(request.getParameter("voting_enabled"))) {
            votingEnabled = "enabled";
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();

            // Update candidate registration setting
            String updateSql = "UPDATE system_settings SET setting_value = ? WHERE setting_key = ?";
            PreparedStatement ps = conn.prepareStatement(updateSql);
            
            // Update candidate registration
            ps.setString(1, candidateRegistration);
            ps.setString(2, "candidate_registration");
            int rows1 = ps.executeUpdate();
            
            // Update voting enabled
            ps.setString(1, votingEnabled);
            ps.setString(2, "voting_enabled");
            int rows2 = ps.executeUpdate();
            
            ps.close();
            conn.close();

            if (rows1 > 0 || rows2 > 0) {
                response.sendRedirect("system-settings.jsp?success=updated");
            } else {
                response.sendRedirect("system-settings.jsp?error=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("system-settings.jsp?error=exception");
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}