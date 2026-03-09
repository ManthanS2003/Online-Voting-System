package com.voting;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class DashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Prevent caching
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        // Check if session exists
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("voterId") == null) {
            response.sendRedirect("voter-login.jsp");
            return;
        }

        int voterId = (Integer) session.getAttribute("voterId");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT id, name, email, mobile, status, address, voting_area, age, date_of_birth FROM voters WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, voterId);
            rs = ps.executeQuery();

            if (rs.next()) {
                // Set voter details as request attributes
                request.setAttribute("voterId", rs.getInt("id"));
                request.setAttribute("voterName", rs.getString("name"));
                request.setAttribute("voterEmail", rs.getString("email"));
                request.setAttribute("voterMobile", rs.getString("mobile"));
                request.setAttribute("voterStatus", rs.getString("status"));
                request.setAttribute("voterAddress", rs.getString("address"));
                request.setAttribute("votingArea", rs.getString("voting_area"));
                request.setAttribute("voterAge", rs.getInt("age"));
                request.setAttribute("dateOfBirth", rs.getString("date_of_birth"));

                // Forward to JSP with all attributes
                request.getRequestDispatcher("user-dashboard.jsp").forward(request, response);

            } else {
                // If no voter found, redirect to login
                session.invalidate();
                response.sendRedirect("voter-login.jsp?error=notfound");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("voter-login.jsp?error=exception");
        } finally {
            // Close resources properly
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}