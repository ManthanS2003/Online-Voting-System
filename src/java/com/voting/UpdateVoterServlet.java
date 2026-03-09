package com.voting;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.LocalDate;
import java.time.Period;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class UpdateVoterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("voterId") == null) {
            response.sendRedirect("voter-login.jsp");
            return;
        }

        int voterId = (Integer) session.getAttribute("voterId");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        String address = request.getParameter("address");
        String votingArea = request.getParameter("voting_area");
        String dob = request.getParameter("dob");

        // Validate age if DOB is provided
        if (dob != null && !dob.trim().isEmpty()) {
            try {
                LocalDate birthDate = LocalDate.parse(dob);
                LocalDate currentDate = LocalDate.now();
                int age = Period.between(birthDate, currentDate).getYears();
                
                if (age < 18) {
                    response.sendRedirect("DashboardServlet?error=underage");
                    return;
                }
            } catch (Exception e) {
                response.sendRedirect("DashboardServlet?error=invalid_dob");
                return;
            }
        }

        try {
            Connection conn = DBConnection.getConnection();
            
            String sql = "UPDATE voters SET name = ?, email = ?, mobile = ?, address = ?, voting_area = ?, date_of_birth = ?, age = ? WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, mobile);
            ps.setString(4, address);
            ps.setString(5, votingArea);
            ps.setString(6, dob);
            
            // Calculate age from DOB
            if (dob != null && !dob.trim().isEmpty()) {
                LocalDate birthDate = LocalDate.parse(dob);
                LocalDate currentDate = LocalDate.now();
                int age = Period.between(birthDate, currentDate).getYears();
                ps.setInt(7, age);
            } else {
                ps.setNull(7, java.sql.Types.INTEGER);
            }
            
            ps.setInt(8, voterId);
            
            int rowsUpdated = ps.executeUpdate();
            ps.close();
            conn.close();
            
            if (rowsUpdated > 0) {
                // Update session attribute if name was changed
                session.setAttribute("voterName", name);
                response.sendRedirect("DashboardServlet?success=updated");
            } else {
                response.sendRedirect("DashboardServlet?error=updatefailed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("DashboardServlet?error=exception");
        }
    }
}