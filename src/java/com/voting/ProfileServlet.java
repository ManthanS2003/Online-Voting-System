package com.voting;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class ProfileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0"); // Fixed: changed from 0 to "0"
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("voterId") == null) {
            response.sendRedirect("voter-login.jsp");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            int voterId = (Integer) session.getAttribute("voterId");
            conn = DBConnection.getConnection();
            String sql = "SELECT id, name, email, mobile, status, address, voting_area, age, date_of_birth, DATE_FORMAT(created_at, '%M %d, %Y') as created_date FROM voters WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, voterId);
            rs = ps.executeQuery();

            if (rs.next()) {
                request.setAttribute("voterId", rs.getInt("id"));
                request.setAttribute("voterName", rs.getString("name"));
                request.setAttribute("voterEmail", rs.getString("email"));
                request.setAttribute("voterMobile", rs.getString("mobile"));
                request.setAttribute("voterStatus", rs.getString("status"));
                request.setAttribute("voterAddress", rs.getString("address"));
                request.setAttribute("votingArea", rs.getString("voting_area"));
                request.setAttribute("voterAge", rs.getInt("age"));
                request.setAttribute("dateOfBirth", rs.getString("date_of_birth"));
                request.setAttribute("createdDate", rs.getString("created_date"));
                
                // Update session with current name
                session.setAttribute("voterName", rs.getString("name"));
            } else {
                // Voter not found in database
                response.sendRedirect("voter-login.jsp?error=notfound");
                return;
            }
            
            request.getRequestDispatcher("my-profile.jsp").forward(request, response);

        } catch (ClassCastException e) {
            e.printStackTrace();
            response.sendRedirect("voter-login.jsp?error=invalidsession");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("voter-login.jsp?error=driver");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("voter-login.jsp?error=database");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("voter-login.jsp?error=exception");
        } finally {
            // Close resources in finally block
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}