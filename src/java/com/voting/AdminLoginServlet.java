package com.voting;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class AdminLoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validate inputs
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            response.sendRedirect("admin-login.jsp?error=required");
            return;
        }

        // Sanitize inputs
        username = username.trim();
        password = password.trim();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                "SELECT id, name FROM admins WHERE name = ? AND password = ?")) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("adminId", rs.getInt("id"));
                    session.setAttribute("adminName", rs.getString("name"));
                    response.sendRedirect("admin-dashboard.jsp");
                } else {
                    response.sendRedirect("admin-login.jsp?error=invalid");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-login.jsp?error=exception");
        }
    }
}