package com.voting;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String mobile = request.getParameter("mobile");
        String password = request.getParameter("password");

        // Validate inputs
        if (mobile == null || mobile.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            response.sendRedirect("voter-login.jsp?error=required");
            return;
        }

        // Sanitize inputs
        mobile = mobile.trim();
        password = password.trim();

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();

            // ✅ First check if Admin login
            String adminSql = "SELECT id, name, password FROM admins WHERE name = ? AND password = ?";
            PreparedStatement adminStmt = conn.prepareStatement(adminSql);
            adminStmt.setString(1, mobile);
            adminStmt.setString(2, password);
            ResultSet adminRs = adminStmt.executeQuery();

            if (adminRs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("adminId", adminRs.getInt("id"));
                session.setAttribute("adminName", adminRs.getString("name"));
                
                adminRs.close();
                adminStmt.close();
                conn.close();
                
                response.sendRedirect("admin-dashboard.jsp");
                return;
            }
            adminRs.close();
            adminStmt.close();

            // ✅ Check for Voter login
            String voterSql = "SELECT id, name, password, status FROM voters WHERE mobile = ? AND password = ?";
            PreparedStatement voterStmt = conn.prepareStatement(voterSql);
            voterStmt.setString(1, mobile);
            voterStmt.setString(2, password);
            ResultSet voterRs = voterStmt.executeQuery();

            if (voterRs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("voterId", voterRs.getInt("id"));
                session.setAttribute("voterName", voterRs.getString("name"));
                
                voterRs.close();
                voterStmt.close();
                conn.close();
                
                response.sendRedirect(request.getContextPath() + "/DashboardServlet");
            } else {
                // Invalid credentials
                voterRs.close();
                voterStmt.close();
                conn.close();
                response.sendRedirect("voter-login.jsp?error=invalid");
            }

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            response.sendRedirect("voter-login.jsp?error=exception");
        }
    }
}