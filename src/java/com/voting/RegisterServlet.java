package com.voting;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.Period;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("mobile");
        String password = request.getParameter("password");
        String address = request.getParameter("address");
        String votingArea = request.getParameter("voting_area");
        String dob = request.getParameter("dob");

        // Validate inputs
        if (name == null || name.trim().isEmpty() || 
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            address == null || address.trim().isEmpty() ||
            votingArea == null || votingArea.trim().isEmpty() ||
            dob == null || dob.trim().isEmpty()) {
            response.sendRedirect("voter-register.jsp?error=required");
            return;
        }

        // Sanitize inputs
        name = name.trim();
        email = email.trim();
        phone = phone.trim();
        password = password.trim();
        address = address.trim();
        votingArea = votingArea.trim();

        // Age validation (must be 18 or older)
        try {
            LocalDate birthDate = LocalDate.parse(dob);
            LocalDate currentDate = LocalDate.now();
            int age = Period.between(birthDate, currentDate).getYears();
            
            if (age < 18) {
                response.sendRedirect("voter-register.jsp?error=underage");
                return;
            }
        } catch (Exception e) {
            response.sendRedirect("voter-register.jsp?error=invalid_dob");
            return;
        }

        try {
            Connection conn = DBConnection.getConnection();

            // Check if user already exists
            String checkSql = "SELECT id FROM voters WHERE email = ? OR mobile = ?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setString(1, email);
            checkPs.setString(2, phone);
            ResultSet rs = checkPs.executeQuery();
            
            if (rs.next()) {
                response.sendRedirect("voter-register.jsp?error=duplicate");
                rs.close();
                checkPs.close();
                conn.close();
                return;
            }
            
            rs.close();
            checkPs.close();

            // Insert new voter with additional fields
            String sql = "INSERT INTO voters (name, email, mobile, password, address, voting_area, age, date_of_birth) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, password);
            ps.setString(5, address);
            ps.setString(6, votingArea);
            
            // Calculate age from DOB
            LocalDate birthDate = LocalDate.parse(dob);
            LocalDate currentDate = LocalDate.now();
            int age = Period.between(birthDate, currentDate).getYears();
            ps.setInt(7, age);
            ps.setString(8, dob);
            
            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("voter-register.jsp?success=true");
            } else {
                response.sendRedirect("voter-register.jsp?error=failed");
            }

            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("voter-register.jsp?error=exception");
        }
    }
}