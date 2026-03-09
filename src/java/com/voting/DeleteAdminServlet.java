package com.voting;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class DeleteAdminServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("admin-login.jsp");
            return;
        }

        String adminIdParam = request.getParameter("adminId");
        if (adminIdParam == null || adminIdParam.trim().isEmpty()) {
            response.sendRedirect("admin-profile.jsp?delete=failed");
            return;
        }

        int adminId = Integer.parseInt(adminIdParam);

        // Prevent deletion of main admin (ID 1)
        if (adminId == 1) {
            response.sendRedirect("admin-profile.jsp?delete=protected");
            return;
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();

            String deleteSql = "DELETE FROM admins WHERE id = ?";
            PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
            deleteStmt.setInt(1, adminId);

            int rowsDeleted = deleteStmt.executeUpdate();
            deleteStmt.close();
            conn.close();

            if (rowsDeleted > 0) {
                response.sendRedirect("admin-profile.jsp?delete=success");
            } else {
                response.sendRedirect("admin-profile.jsp?delete=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-profile.jsp?delete=failed");
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}